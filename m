Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81JjebJ203182 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 14:45:50 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 201254183FA
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 12:46:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wl3WKzDN7YItWKP0 for
	<xfs@oss.sgi.com>; Tue, 01 Sep 2009 12:46:06 -0700 (PDT)
Message-ID: <4A9D79F7.9080702@sandeen.net>
Date: Tue, 01 Sep 2009 14:45:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: actually enable the swapext compat handler
References: <20090901180308.GA26071@infradead.org>
In-Reply-To: <20090901180308.GA26071@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Fix a small typo in the compat ioctl handler that cause the swapext
> compat handler to never be called.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>

Guilty-party: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>


> Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2009-08-31 15:25:06.093044591 -0300
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c	2009-08-31 15:25:10.856544216 -0300
> @@ -619,7 +619,7 @@ xfs_file_compat_ioctl(
>  	case XFS_IOC_GETVERSION_32:
>  		cmd = _NATIVE_IOC(cmd, long);
>  		return xfs_file_ioctl(filp, cmd, p);
> -	case XFS_IOC_SWAPEXT: {
> +	case XFS_IOC_SWAPEXT_32: {
>  		struct xfs_swapext	  sxp;
>  		struct compat_xfs_swapext __user *sxu = arg;
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
