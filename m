Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81GxP2G188445 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 11:59:35 -0500
Received: from mail-bw0-f216.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC317159CCAE
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 10:00:11 -0700 (PDT)
Received: from mail-bw0-f216.google.com (mail-bw0-f216.google.com
	[209.85.218.216]) by cuda.sgi.com with ESMTP id
	nR8z18Vrr54xdQlp for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2009 10:00:11 -0700 (PDT)
Received: by bwz12 with SMTP id 12so134975bwz.20
	for <xfs@oss.sgi.com>; Tue, 01 Sep 2009 10:00:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090831182754.GA3620@infradead.org>
References: <4A9B759B.7020401@msgid.tls.msk.ru>
	<20090831123010.GA2368@infradead.org>
	<64bb37e0908311114t4a3cefc3v8ea5092e1558c578@mail.gmail.com>
	<20090831182754.GA3620@infradead.org>
Date: Tue, 1 Sep 2009 19:00:05 +0200
Message-ID: <64bb37e0909011000l78a0aef0wf4c53252c14af75e@mail.gmail.com>
Subject: Re: xfs compat_ioctl?
From: Torsten Kaiser <just.for.lkml@googlemail.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Michael Tokarev <mjt@tls.msk.ru>, Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Aug 31, 2009 at 8:27 PM, Christoph Hellwig<hch@infradead.org> wrote:
> I think you are right, the constant used is incorrect.  Does the small
> patch below fix it for you?

Yes, after adding this patch, xfs_fsr works.

> Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c       2009-08-31 15:25:06.093044591 -0300
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c    2009-08-31 15:25:10.856544216 -0300
> @@ -619,7 +619,7 @@ xfs_file_compat_ioctl(
>        case XFS_IOC_GETVERSION_32:
>                cmd = _NATIVE_IOC(cmd, long);
>                return xfs_file_ioctl(filp, cmd, p);
> -       case XFS_IOC_SWAPEXT: {
> +       case XFS_IOC_SWAPEXT_32: {
>                struct xfs_swapext        sxp;
>                struct compat_xfs_swapext __user *sxu = arg;
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
