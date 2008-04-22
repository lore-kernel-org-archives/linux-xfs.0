Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 19:06:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3M26EuZ019133
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 19:06:16 -0700
Date: Tue, 22 Apr 2008 12:07:01 +1000
Subject: Re: [PATCH 2/4] XFS: Return case-insensitive match for dentry cache
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080421083103.433280025@chook.melbourne.sgi.com> <20080421083644.809426871@chook.melbourne.sgi.com> <20080421085947.GA10399@infradead.org>
Message-ID: <op.t9zphzsa3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080421085947.GA10399@infradead.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Mon, 21 Apr 2008 18:59:47 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

>> +STATIC struct dentry *
>> +xfs_ci_dentry_update(
>> +	struct dentry	*dent,
>> +	struct inode	*dent_inode,
>> +	struct xfs_name	*name)
>> +{
>> +	int		err;
>> +	struct dentry	*real_dent;
>> +	struct dentry	*new_dent;
>> +	struct qstr	nls_name;
>
> This helper should go into fs/dcache.c with a slightly move descritive
> name (d_add_ci?).
>
> Also the naming is rather odd, please replace every occurance of
> dent with dentry, and the variable dent_inode should be just inode.
>
> Also when moving this to dcache.c please provide a nice big kerneldoc
> comment describing it like Anton did for the ntfs lookup instance.
> of the
>
>> +	/*
>> +	 * following code from ntfs_lookup() in fs/ntfs/namei.c
>> +	 */
>
> Not a very helpful comment :)
>
>> +		new_dent = d_splice_alias(dent_inode, real_dent);
>> +		if (new_dent)
>> +			dput(real_dent);
>> +		else
>> +			new_dent = real_dent;
>> +		return new_dent;
>
> I think this would be more readable as
>
> 		if (new_dentry) {
> 			dput(real_dentry);
> 			return new_dentry;
> 		}
> 		return real_dentry;
>
>> +	/* Matching dentry exists, check if it is negative. */
>> +	if (real_dent->d_inode) {
>> +		if (unlikely(real_dent->d_inode != dent_inode)) {
>> +			/* This can happen because bad inodes are unhashed. */
>> +			BUG_ON(!is_bad_inode(dent_inode));
>> +			BUG_ON(!is_bad_inode(real_dent->d_inode));
>> +		}
>
> Shouldn't this be a can't above?
>
>> +		 * Already have the inode and the dentry attached, decrement
>> +		 * the reference count to balance the xfs_lookup() we did
>> +		 * earlier on.  We found the dentry using d_lookup() so it
>> +		 * cannot be disconnected and thus we do not need to worry
>> +		 * about any NFS/disconnectedness issues here.
>
> 		s/xfs_lookup/iget/

This whole function (other than the xfs_blah) is a direct copy of
Anton's code, I left the variable names etc the same.

>> +kmem_zone_t	*xfs_name_zone;
>
> What about just using kmalloc here?  We know the length of the name
> anyway, so there is no point of allocating the maximum possible size.

Not with the CI/NLS, the length could be different.

>>  	error = xfs_iget(dp->i_mount, NULL, inum, 0, 0, ipp, 0);
>> -	if (error)
>> +	if (error) {
>> +		if (ci_match && *ci_match)
>> +			xfs_name_free(name->name);
>>  		goto out;
>> +	}
>
> All the allocation and freeing for ci_match looks odd and error prone
> to me.  I think the low-level directory code should never allocate
> args->value unless it's explicitly asked for a CI match.  That way
> there's only one place in xfs_ci_lookup to free it either.

Yes, I could do that, it is a neater, cleaner implementation. I did it
this way to only alloc as required rather than an alloc for every lookup.

Barry.
