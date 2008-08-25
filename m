Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Aug 2008 23:59:28 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7P6xPcO010190
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 23:59:25 -0700
Subject: Re: [2.6.27-rc4] XFS i_lock vs i_iolock...
From: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20080825035542.GR5706@disturbed>
References: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com>
	 <20080825010213.GO5706@disturbed> <48B21507.9050708@sgi.com>
	 <20080825035542.GR5706@disturbed>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 08:59:33 +0200
Message-Id: <1219647573.20732.28.camel@twins>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, Daniel J Blueman <daniel.blueman@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, hch@lst.de

On Mon, 2008-08-25 at 13:55 +1000, Dave Chinner wrote:
> On Mon, Aug 25, 2008 at 12:12:23PM +1000, Lachlan McIlroy wrote:
> > Dave Chinner wrote:
> >> On Fri, Aug 22, 2008 at 10:12:59PM +0100, Daniel J Blueman wrote:
> >>> On 2.6.27-rc4 with various debug options enabled, lockdep claims lock
> >>> ordering issues with XFS [1] - easiest reproducer is just running
> >>> xfs_fsr. Mount options I was using were
> >>> 'nobarrier,noatime,nodiratime'.
> >>>
> >>> Thanks,
> >>>   Daniel
> >>>
> >>> --- [1]
> >>>
> >>> =======================================================
> >>> [ INFO: possible circular locking dependency detected ]
> >>> 2.6.27-rc4-224c #1
> >>> -------------------------------------------------------
> >>> xfs_fsr/5763 is trying to acquire lock:
> >>>  (&(&ip->i_lock)->mr_lock/2){--..}, at: [<ffffffff803ad8fc>] xfs_ilock+0x8c/0xb0
> >>>
> >>> but task is already holding lock:
> >>>  (&(&ip->i_iolock)->mr_lock/3){--..}, at: [<ffffffff803ad915>]
> >>> xfs_ilock+0xa5/0xb0
> >>
> >> False positive. We do:
> >>
> >> 	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> >
> > Why not just change the above line to two lines:
> > 	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
> > 	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
> 
> Yeah, that'd work, but it implllies that we no longer allow
> xfs_lock_two_inodes() to take both inode locks at once. 

How can you take two locks in one go? It seems to me you always need to
take them one after another, and as soon as you do that, you have
ordering constraints.

Of course it could be that doesn't matter, because there is another
serializing lock, but that isn't clear from this context.

> It
> would need a comment blaming^Wexplaining why lockdep requires
> us to do this, and then debug code in xfs_lock_two_inodes() to
> catch this when someone makes this mistake again in the future.
