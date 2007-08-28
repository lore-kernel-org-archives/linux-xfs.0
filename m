Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Aug 2007 13:04:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7SK4S4p015257
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2007 13:04:31 -0700
Date: Wed, 29 Aug 2007 06:04:16 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] clean up vnode^winode tracing
Message-ID: <20070828200416.GG61154114@sgi.com>
References: <46D11F1B.5020409@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D11F1B.5020409@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Aug 26, 2007 at 01:35:07AM -0500, Eric Sandeen wrote:
> Simplify vnode tracing calls by embedding function name & return addr
> in the calling macro.
> 
> Also do a lot of vnode->inode renaming for consistency, while
> we're at it.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
> @@ -1525,8 +1525,7 @@ xfs_vm_bmap(
>  	struct inode		*inode = (struct inode *)mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  
> -	vn_trace_entry(XFS_I(inode), __FUNCTION__,
> -			(inst_t *)__return_address);
> +	ip_trace_entry(XFS_I(inode));

s/ip_trace/xfs_itrace/

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
