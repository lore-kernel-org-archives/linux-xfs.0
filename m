Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 01:59:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3L8x6qP028267
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 01:59:08 -0700
Date: Mon, 21 Apr 2008 04:59:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080421085947.GA10399@infradead.org>
References: <20080421083103.433280025@chook.melbourne.sgi.com> <20080421083644.809426871@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421083644.809426871@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

> +STATIC struct dentry *
> +xfs_ci_dentry_update(
> +	struct dentry	*dent,
> +	struct inode	*dent_inode,
> +	struct xfs_name	*name)
> +{
> +	int		err;
> +	struct dentry	*real_dent;
> +	struct dentry	*new_dent;
> +	struct qstr	nls_name;

This helper should go into fs/dcache.c with a slightly move descritive
name (d_add_ci?).

Also the naming is rather odd, please replace every occurance of
dent with dentry, and the variable dent_inode should be just inode.

Also when moving this to dcache.c please provide a nice big kerneldoc
comment describing it like Anton did for the ntfs lookup instance.
of the 

> +	/*
> +	 * following code from ntfs_lookup() in fs/ntfs/namei.c
> +	 */

Not a very helpful comment :)

> +		new_dent = d_splice_alias(dent_inode, real_dent);
> +		if (new_dent)
> +			dput(real_dent);
> +		else
> +			new_dent = real_dent;
> +		return new_dent;

I think this would be more readable as

		if (new_dentry) {
			dput(real_dentry);
			return new_dentry;
		}
		return real_dentry;

> +	/* Matching dentry exists, check if it is negative. */
> +	if (real_dent->d_inode) {
> +		if (unlikely(real_dent->d_inode != dent_inode)) {
> +			/* This can happen because bad inodes are unhashed. */
> +			BUG_ON(!is_bad_inode(dent_inode));
> +			BUG_ON(!is_bad_inode(real_dent->d_inode));
> +		}

Shouldn't this be a can't above?

> +		 * Already have the inode and the dentry attached, decrement
> +		 * the reference count to balance the xfs_lookup() we did
> +		 * earlier on.  We found the dentry using d_lookup() so it
> +		 * cannot be disconnected and thus we do not need to worry
> +		 * about any NFS/disconnectedness issues here.

		s/xfs_lookup/iget/ 

> +kmem_zone_t	*xfs_name_zone;

What about just using kmalloc here?  We know the length of the name
anyway, so there is no point of allocating the maximum possible size.

>  	error = xfs_iget(dp->i_mount, NULL, inum, 0, 0, ipp, 0);
> -	if (error)
> +	if (error) {
> +		if (ci_match && *ci_match)
> +			xfs_name_free(name->name);
>  		goto out;
> +	}

All the allocation and freeing for ci_match looks odd and error prone
to me.  I think the low-level directory code should never allocate
args->value unless it's explicitly asked for a CI match.  That way
there's only one place in xfs_ci_lookup to free it either.
