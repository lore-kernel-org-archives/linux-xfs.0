Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Aug 2008 18:01:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7P10uYW014355
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 18:00:56 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B61BA3C87CE
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 18:02:17 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id qZ31Q5lNVk3zqj3H for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 18:02:17 -0700 (PDT)
Date: Mon, 25 Aug 2008 11:02:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [2.6.27-rc4] XFS i_lock vs i_iolock...
Message-ID: <20080825010213.GO5706@disturbed>
References: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, hch@lst.de

On Fri, Aug 22, 2008 at 10:12:59PM +0100, Daniel J Blueman wrote:
> On 2.6.27-rc4 with various debug options enabled, lockdep claims lock
> ordering issues with XFS [1] - easiest reproducer is just running
> xfs_fsr. Mount options I was using were
> 'nobarrier,noatime,nodiratime'.
> 
> Thanks,
>   Daniel
> 
> --- [1]
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.27-rc4-224c #1
> -------------------------------------------------------
> xfs_fsr/5763 is trying to acquire lock:
>  (&(&ip->i_lock)->mr_lock/2){--..}, at: [<ffffffff803ad8fc>] xfs_ilock+0x8c/0xb0
> 
> but task is already holding lock:
>  (&(&ip->i_iolock)->mr_lock/3){--..}, at: [<ffffffff803ad915>]
> xfs_ilock+0xa5/0xb0

False positive. We do:

	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
	.....
	xfs_iunlock(ip, XFS_ILOCK_EXCL);
	xfs_iunlock(tip, XFS_ILOCK_EXCL);
	.....
	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);

Which is a perfectly valid thing to do.

The problem is that lockdep is complaining about the second call
to xfs_lock_two_inodes(), which uses the subclasses 2 and 3.
effectively it is seeing:

	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
		iolock/2
		ilock/2
		iolock/3
		ilock/3
	.....
	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
		ilock/2
		ilock/3


But because the original lock order was ilock/2->iolock/3, the
second call to xfs_lock_two_inodes is seeing iolock/3->ilock/2
which it then complains about....

Christoph - I think we're going to need to pass a lockdep 'order'
flag into xfs_lock_two_inodes() to avoid this so the second call
can use different classes to the first call. Or perhaps a '_nested'
variant of the call...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
