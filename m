Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Aug 2008 18:54:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7Q1sUEX012342
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 18:54:31 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DC713CD48C
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 18:55:53 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Dv77OX9UipMuZOGW for <xfs@oss.sgi.com>; Mon, 25 Aug 2008 18:55:53 -0700 (PDT)
Date: Tue, 26 Aug 2008 11:55:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [2.6.27-rc4] XFS i_lock vs i_iolock...
Message-ID: <20080826015549.GT5706@disturbed>
References: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com> <20080825010213.GO5706@disturbed> <48B21507.9050708@sgi.com> <20080825035542.GR5706@disturbed> <1219647573.20732.28.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219647573.20732.28.camel@twins>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, Daniel J Blueman <daniel.blueman@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, hch@lst.de

On Mon, Aug 25, 2008 at 08:59:33AM +0200, Peter Zijlstra wrote:
> On Mon, 2008-08-25 at 13:55 +1000, Dave Chinner wrote:
> > On Mon, Aug 25, 2008 at 12:12:23PM +1000, Lachlan McIlroy wrote:
> > > Dave Chinner wrote:
> > >> On Fri, Aug 22, 2008 at 10:12:59PM +0100, Daniel J Blueman wrote:
> > >>> =======================================================
> > >>> [ INFO: possible circular locking dependency detected ]
> > >>> 2.6.27-rc4-224c #1
> > >>> -------------------------------------------------------
> > >>> xfs_fsr/5763 is trying to acquire lock:
> > >>>  (&(&ip->i_lock)->mr_lock/2){--..}, at: [<ffffffff803ad8fc>] xfs_ilock+0x8c/0xb0
> > >>>
> > >>> but task is already holding lock:
> > >>>  (&(&ip->i_iolock)->mr_lock/3){--..}, at: [<ffffffff803ad915>]
> > >>> xfs_ilock+0xa5/0xb0
> > >>
> > >> False positive. We do:
> > >>
> > >> 	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> > >
> > > Why not just change the above line to two lines:
> > > 	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
> > > 	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
> > 
> > Yeah, that'd work, but it implllies that we no longer allow
> > xfs_lock_two_inodes() to take both inode locks at once. 
> 
> How can you take two locks in one go? It seems to me you always need to
> take them one after another, and as soon as you do that, you have
> ordering constraints.

It doesn't take them both inode locks in one go - it does them
separately in a given order via xfs_ilock(). Basically there are two
layers of constraints here - xfs_ilock() handles the order
withing a given inode, xfs_lock_two_inodes() handles order and
deadlock prevention between inodes.

What lockdep is complaining about is a difference in the lock
order between different locks in different inodes - a situation
that does not result in a deadlock...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
