Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Sep 2007 03:27:43 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8TARa6s010269
	for <xfs@oss.sgi.com>; Sat, 29 Sep 2007 03:27:40 -0700
Date: Sat, 29 Sep 2007 10:45:52 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] kill XFS_INOBT_IS_FREE_DISK
Message-ID: <20070929094552.GC29241@infradead.org>
References: <20070919161202.GA18130@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919161202.GA18130@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Sep 19, 2007 at 06:12:03PM +0200, Christoph Hellwig wrote:
> This macro is unused an all other acros in this family operate on native
> types, so we most likely won't grow a user either.

Could anyone put this trivial remove one line patch in?

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6.23-rc6/fs/xfs/xfs_ialloc_btree.h
> ===================================================================
> --- linux-2.6.23-rc6.orig/fs/xfs/xfs_ialloc_btree.h	2007-09-18 16:27:08.000000000 +0200
> +++ linux-2.6.23-rc6/fs/xfs/xfs_ialloc_btree.h	2007-09-18 16:27:18.000000000 +0200
> @@ -81,8 +81,6 @@ typedef	struct xfs_btree_sblock xfs_inob
>  #define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
>  #define	XFS_INOBT_IS_FREE(rp,i)		\
>  		(((rp)->ir_free & XFS_INOBT_MASK(i)) != 0)
> -#define	XFS_INOBT_IS_FREE_DISK(rp,i)	\
> -		((be64_to_cpu((rp)->ir_free) & XFS_INOBT_MASK(i)) != 0)
>  #define	XFS_INOBT_SET_FREE(rp,i)	((rp)->ir_free |= XFS_INOBT_MASK(i))
>  #define	XFS_INOBT_CLR_FREE(rp,i)	((rp)->ir_free &= ~XFS_INOBT_MASK(i))
>  
> 
> 
---end quoted text---
