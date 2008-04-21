Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 02:46:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3L9k0iF032101
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 02:46:03 -0700
Date: Mon, 21 Apr 2008 05:46:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080421094641.GA5191@infradead.org>
References: <20080421083103.433280025@chook.melbourne.sgi.com> <20080421083644.809426871@chook.melbourne.sgi.com> <20080421085947.GA10399@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421085947.GA10399@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

> > +kmem_zone_t	*xfs_name_zone;
> 
> What about just using kmalloc here?  We know the length of the name
> anyway, so there is no point of allocating the maximum possible size.
> 
> >  	error = xfs_iget(dp->i_mount, NULL, inum, 0, 0, ipp, 0);
> > -	if (error)
> > +	if (error) {
> > +		if (ci_match && *ci_match)
> > +			xfs_name_free(name->name);
> >  		goto out;
> > +	}
> 
> All the allocation and freeing for ci_match looks odd and error prone
> to me.  I think the low-level directory code should never allocate
> args->value unless it's explicitly asked for a CI match.  That way
> there's only one place in xfs_ci_lookup to free it either.

Also the low-level name duplication code could be factored out a little
more ala:

/*
 * If a case-insensitive match, allocate a buffer and copy the actual
 * name into the buffer. Return it via args->value.
 */
void xfs_copy_ci_name(struct xfs_da_args *args, const char *name, int namelen)
{
	if (args->return_ci_name && args->cmpresult == XFS_CMP_CASE) {
		args->valuelen = namelen;
		args->value = kmemdup(name, namelen, GFP_NOFS);
		/* error handled in higher layers */
	}
}

Instead of adding args->return_ci_name it might make sense to just
replace the last four chars there with an unsigned short lookup_flags
and just set bits in it.
