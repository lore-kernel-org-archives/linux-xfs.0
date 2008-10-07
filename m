Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 14:34:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97LYYaH030070
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 14:34:35 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F6771B57A6B
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 14:36:13 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id OkEEMaJZVU826M5r for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 14:36:13 -0700 (PDT)
Date: Wed, 8 Oct 2008 08:36:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] kill xfs_dinode_core_t
Message-ID: <20081007213610.GV30001@disturbed>
References: <20081007202201.GC16485@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007202201.GC16485@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Oct 07, 2008 at 10:22:01PM +0200, Christoph Hellwig wrote:
> No that we have a separate xfs_icdinode_t for the in-core inode that
> get's logged there's absolutely no reason for the xfs_dinode vs
> xfs_dinode_core split - the fact that part of the structure gets logged
> through the inode log item and a small part not can better be described
> in a comment.  The few places that uses sizeof() on the dinode_core
> are replaced with macros that also prepare for the variable size inode
> core we'll need for adding checksums to the inodes.
> 
> Removing the data and attribute fork unions also has the advantage that
> xfs_dinode.h doesn't need to pull in every header under the sun.
> 
> While we're at it also add some more comments describing the dinode
> structure.

Nice. I haven't reviewed this fully yet, but a couple of things
stand out:

> @@ -359,7 +357,7 @@ xfs_dip_to_stat(
>  
>  	switch (dic->di_format) {
>  	case XFS_DINODE_FMT_DEV:
> -		buf->dt_rdev = be32_to_cpu(dip->di_u.di_dev);
> +		buf->dt_rdev = be32_to_cpu(*(__be32 *)XFS_DFORK_DPTR(mp, dic));

That's not particularly obvious where the rdev value is stored.
Perhaps a comment indicating that it's a direct dereference out
of the start of the data area in the inode?

>  /*
> - * Note: Coordinate changes to this structure with the XFS_DI_* #defines
> - * below, the offsets table in xfs_ialloc_log_di() and struct xfs_icdinode
> - * in xfs_inode.h.
> + * On-disk inode structure.
> + *
> + * This is just the header or "dinode core", the inode is expanded to fill a
> + * variable size the leftover area split into a data and an attribute fork.
> + * The format of the data and attribute fork depends on the format of the
> + * inode as indicated by di_format and di_aformat.  To access the data and
> + * attribute use the XFS_DFORK_PTR, XFS_DFORK_DPTR, and XFS_DFORK_PTR macro:

macros

> +#define XFS_DINODE_CORE_SIZE(mp)	(96)
> +#define XFS_DINODE_SIZE(mp)		(96 + sizeof(__be32))

probably shouldn't hard-code the second "96" there. Perhaps
the XFS_DINODE_SIZE() macro should be a sizeof(xfs_dinode_t)?

That's as far as I've looked....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
