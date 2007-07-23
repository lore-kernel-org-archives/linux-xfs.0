Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 17:21:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6N0LTbm022058
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 17:21:31 -0700
Date: Mon, 23 Jul 2007 10:21:21 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] dinode endianess annotations
Message-ID: <20070723002121.GK31489@sgi.com>
References: <20070720163026.GA6902@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720163026.GA6902@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Jul 20, 2007 at 06:30:26PM +0200, Christoph Hellwig wrote:
> Biggest bit is duplicating the dinode structure so we have one annoted
> for native endianess and one for disk endinaess.  The other significant
> change is that xfs_xlate_dinode_core is split into one helper per
> direction to allow for proper annotations, everything else is trivial.

Ok, we've needed to do that for a while....

> As a sidenode splitting out the incore dinode means we can move it into
> xfs_inode.h in a later patch and severly improving on the include hell
> in xfs.

Excellent!

Couple of comments, though....

> Index: linux-2.6-xfs/fs/xfs/xfs_dinode.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_dinode.h	2007-07-17 07:54:01.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_dinode.h	2007-07-17 07:54:35.000000000 +0200
> @@ -33,16 +33,17 @@ struct xfs_mount;
>   * with the last field expanding.  It is split into the core and "other"
>   * because we only need the core part in the in-core inode.
>   */
> -typedef struct xfs_timestamp {
> +
> +typedef struct xfs_timestamp_incore {
>  	__int32_t	t_sec;		/* timestamp seconds */
>  	__int32_t	t_nsec;		/* timestamp nanoseconds */
> -} xfs_timestamp_t;
> +} xfs_timestamp_incore_t;

This is a bit ugly - we typically use the "ic" prefix to indicate
"in-core" e.g. "l_iclogbufs", "xfs_icsb_cnts_t".

Perhaps "xfs_ictimestamp_t" or "xfs_ictstamp_t" would be more
consistent with other code. Not sure it really matters, but it would
fix up some of the formatting issues such a long variable
introduces....

>  /*
> - * Note: Coordinate changes to this structure with the XFS_DI_* #defines
> - * below and the offsets table in xfs_ialloc_log_di().
> + * Incore dinode core.  Must match xfs_dinode_core except for endianess
> + * annotations.
>   */
> -typedef struct xfs_dinode_core
> +typedef struct xfs_dinode_incore

So now we have:

	- struct inode (linux in memory inode)
	- struct xfs_inode (xfs in memory inode)
	- struct xfs_dinode_incore (xfs in memory disk inode core)
	- struct xfs_dinode_core (xfs on disk inode core)

I think the xfs_dinode_incore is badly named, because the "core"
part of xfs_dinode_core refers to the main part (or "core") of the
on disk inode. i.e. the non-literal area of the inode. IOWs, "core"
in this context has very different meaning to "incore" (see
XFS_ILOG_CORE and friends, for example).

Perhaps "struct xfs_icdinode_core" as per the above?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
