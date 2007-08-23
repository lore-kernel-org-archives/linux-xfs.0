Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:47:56 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJlq4p009848
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:47:54 -0700
Date: Thu, 23 Aug 2007 15:47:49 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: [PATCH 5/17] move v_iocount from bhv_vnode to xfs_inode
Message-ID: <20070823194749.GB8431@filer.fsl.cs.sunysb.edu>
References: <20070823193818.GF8050@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823193818.GF8050@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Aug 23, 2007 at 09:38:18PM +0200, Christoph Hellwig wrote:
> struct bhv_vnode is on it's way out, so move the I/O count to the XFS inode.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-08-23 14:46:18.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2007-08-23 14:51:38.000000000 +0200
> @@ -140,9 +140,11 @@ xfs_destroy_ioend(
>  		next = bh->b_private;
>  		bh->b_end_io(bh, !ioend->io_error);
>  	}
> -	if (unlikely(ioend->io_error))
> -		vn_ioerror(ioend->io_vnode, ioend->io_error, __FILE__,__LINE__);
> -	vn_iowake(ioend->io_vnode);
> +	if (unlikely(ioend->io_error)) {
> +		vn_ioerror(XFS_I(ioend->io_inode), ioend->io_error,
> +				__FILE__,__LINE__);

Should it still be called vn_* if it takes an xfs inode? (And yes, I realize
this is a patch in the middle of the series.)

> +	}
> +	vn_iowake(XFS_I(ioend->io_inode));

ditto.

Josef 'Jeff' Sipek.

-- 
A computer without Microsoft is like chocolate cake without mustard.
