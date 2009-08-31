Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7VIR3GY115629 for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 13:27:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BA931593A38
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 11:27:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bjnVOK9JmaWjfDKx for
	<xfs@oss.sgi.com>; Mon, 31 Aug 2009 11:27:59 -0700 (PDT)
Date: Mon, 31 Aug 2009 14:27:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs compat_ioctl?
Message-ID: <20090831182754.GA3620@infradead.org>
References: <4A9B759B.7020401@msgid.tls.msk.ru>
	<20090831123010.GA2368@infradead.org>
	<64bb37e0908311114t4a3cefc3v8ea5092e1558c578@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <64bb37e0908311114t4a3cefc3v8ea5092e1558c578@mail.gmail.com>
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
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Michael Tokarev <mjt@tls.msk.ru>, Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Aug 31, 2009 at 08:14:58PM +0200, Torsten Kaiser wrote:
> On a slightly related note: I also have a system with a 32bit userland
> and a 64bit kernel.
> After switching to the 64bit kernel, xfs_fsr was no longer working,
> but that was caused by the then still missing compat ioctls.
> 
> Today I retried it, but it still fails:
> XFS_IOC_SWAPEXT failed: ino=<number>: Invalid argument
> 
> Looking at the compat code SWAPEXT looks somewhat suspicious:
> 
> fs/xfs/linux-2.6/xfs_ioctl32.h defines XFS_IOC_SWAPEXT_32, but I can't
> find a single place where this is used.
> And in the big switch of xfs_compat_ioctl() the value XFS_IOC_SWAPEXT
> is surrounded by contants that all end in 32.
> 
> I don't have any experience with the linux ioctl code, I only read
> fs/xfs/linux-2.6/xfs_ioctl32.c, but for my untrained eye it looks like
> there is a _32 missing.
> 
> Or am I misreading this completely?

I think you are right, the constant used is incorrect.  Does the small
patch below fix it for you?

Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2009-08-31 15:25:06.093044591 -0300
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c	2009-08-31 15:25:10.856544216 -0300
@@ -619,7 +619,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_GETVERSION_32:
 		cmd = _NATIVE_IOC(cmd, long);
 		return xfs_file_ioctl(filp, cmd, p);
-	case XFS_IOC_SWAPEXT: {
+	case XFS_IOC_SWAPEXT_32: {
 		struct xfs_swapext	  sxp;
 		struct compat_xfs_swapext __user *sxu = arg;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
