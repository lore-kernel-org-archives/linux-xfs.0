Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Apr 2007 02:04:37 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3O94VfB004804
	for <xfs@oss.sgi.com>; Tue, 24 Apr 2007 02:04:33 -0700
Date: Tue, 24 Apr 2007 09:56:47 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review - flush blockdev on close
Message-ID: <20070424085647.GB28820@infradead.org>
References: <20070424014249.GF48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424014249.GF48531920@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 24, 2007 at 11:42:49AM +1000, David Chinner wrote:
> 
> As suggested by Christoph, we probably should flush the block
> device as we complete the process of unmounting the filesystem.
> Patch attached.

Looks good.

> 
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-04-24 09:32:22.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c	2007-04-24 11:12:42.181361346 +1000
> @@ -1464,6 +1464,7 @@ xfs_free_buftarg(
>  	int			external)
>  {
>  	xfs_flush_buftarg(btp, 1);
> +	xfs_blkdev_issue_flush(btp);
>  	if (external)
>  		xfs_blkdev_put(btp->bt_bdev);
>  	xfs_free_bufhash(btp);
