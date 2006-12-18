Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Dec 2006 15:41:57 -0800 (PST)
Received: from netcenter.hu (ns.netcenter.hu [195.228.254.57])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBINfmqw031167
	for <linux-xfs@oss.sgi.com>; Mon, 18 Dec 2006 15:41:52 -0800
Message-ID: <001a01c722fd$df5ca710$0400a8c0@dcccs>
From: =?iso-8859-1?Q?Haar_J=E1nos?= <djani22@netcenter.hu>
References: <003701c71d78$33ed28d0$0400a8c0@dcccs> <Pine.LNX.4.64.0612120932220.19050@p34.internal.lan> <00ab01c71e53$942af2f0$0400a8c0@dcccs> <000d01c72127$3d7509b0$0400a8c0@dcccs> <20061217224457.GN33919298@melbourne.sgi.com> <026501c72237$0464f7a0$0400a8c0@dcccs> <20061218062444.GH44411608@melbourne.sgi.com> <027b01c7227d$0e26d1f0$0400a8c0@dcccs> <20061218223637.GP44411608@melbourne.sgi.com>
Subject: Re: xfslogd-spinlock bug?
Date: Tue, 19 Dec 2006 00:39:46 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-xfs@oss.sgi.com, linux-kernel@vger.kernel.org


----- Original Message ----- 
From: "David Chinner" <dgc@sgi.com>
To: "Haar János" <djani22@netcenter.hu>
Cc: "David Chinner" <dgc@sgi.com>; <linux-xfs@oss.sgi.com>;
<linux-kernel@vger.kernel.org>
Sent: Monday, December 18, 2006 11:36 PM
Subject: Re: xfslogd-spinlock bug?


> On Mon, Dec 18, 2006 at 09:17:50AM +0100, Haar János wrote:
> > From: "David Chinner" <dgc@sgi.com>
> > > > The NBD serves through eth1, and it is on the CPU3, but the ide0 is
on
> > the
> > > > CPU0.
> > >
> > > I'd say your NBD based XFS filesystem is having trouble.
> > >
> > > > > Are you using XFS on a NBD?
> > > >
> > > > Yes, on the 3. source.
> > >
> > > Ok, I've never heard of a problem like this before and you are doing
> > > something that very few ppl are doing (i.e. XFS on NBD). I'd start
> > > Hence  I'd start by suspecting a bug in the NBD driver.
> >
> > Ok, if you have right, this also can be in context with the following
issue:
> >
> > http://download.netcenter.hu/bughunt/20061217/messages.txt   (10KB)
>
> Which appears to be a crash in wake_up_process() when doing memory
> reclaim (waking the xfsbufd).

Sorry, can you translate it to "poor mans language"? :-)
This is a different bug?


>
> > > > > > Dec 16 12:08:36 dy-base RSP: 0018:ffff81011fdedbc0  EFLAGS:
00010002
> > > > > > Dec 16 12:08:36 dy-base RAX: 0000000000000033 RBX:
6b6b6b6b6b6b6b6b
> > RCX:
> > > > >
^^^^^^^^^^^^^^^^
> > > > > Anyone recognise that pattern?
>
> Ok, I've found this pattern:
>
> #define POISON_FREE 0x6b
>
> Can you confirm that you are running with CONFIG_DEBUG_SLAB=y?

Yes, i build with this option enabled.
Is this wrong?

>
> If so, we have a use after free occurring here and it would also
> explain why no-one has reported it before.
>
> FWIW, can you turn on CONFIG_XFS_DEBUG=y and see if that triggers
> a different bug check prior to the above dump?

[root@X64 linux-2.6.19]# make bzImage
scripts/kconfig/conf -s arch/x86_64/Kconfig
.config:7:warning: trying to assign nonexistent symbol XFS_DEBUG

I have missed something?


Thanks,

Janos

>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
