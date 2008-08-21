Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 04:04:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7LB428s000575
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 04:04:04 -0700
Received: from web32606.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 2E6513BA71F
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 04:05:23 -0700 (PDT)
Received: from web32606.mail.mud.yahoo.com (web32606.mail.mud.yahoo.com [68.142.207.233]) by cuda.sgi.com with SMTP id B2p9cZn5gq3AVKEE for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 04:05:23 -0700 (PDT)
Date: Thu, 21 Aug 2008 04:05:21 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <293210.50030.qm@web32606.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

----- Original Message ----

> From: Dave Chinner <david@fromorbit.com>
> To: Szabolcs Szakacsits <szaka@ntfs-3g.org>; Andrew Morton <akpm@linux-foundation.org>; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; xfs@oss.sgi.com
> Sent: Thursday, August 21, 2008 10:25:32 AM
> Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
> 
> On Thu, Aug 21, 2008 at 04:04:18PM +1000, Dave Chinner wrote:
> > On Thu, Aug 21, 2008 at 03:15:08PM +1000, Dave Chinner wrote:
> > > On Thu, Aug 21, 2008 at 05:46:00AM +0300, Szabolcs Szakacsits wrote:
> > > > On Thu, 21 Aug 2008, Dave Chinner wrote:
> > > > Everything is default.
> > > > 
> > > >   % rpm -qf =mkfs.xfs
> > > >   xfsprogs-2.9.8-7.1 
> > > > 
> > > > which, according to ftp://oss.sgi.com/projects/xfs/cmd_tars, is the 
> > > > latest stable mkfs.xfs. Its output is
> > > > 
> > > > meta-data=/dev/sda8              isize=256    agcount=4, agsize=1221440 
> blks
> > > >          =                       sectsz=512   attr=2
> > > > data     =                       bsize=4096   blocks=4885760, imaxpct=25
> > > >          =                       sunit=0      swidth=0 blks
> > > > naming   =version 2              bsize=4096  
> > > > log      =internal log           bsize=4096   blocks=2560, version=2
> > > >          =                       sectsz=512   sunit=0 blks, lazy-count=0
> > > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > 
> > > Ok, I thought it might be the tiny log, but it didn't improve anything
> > > here when increased the log size, or the log buffer size.
> > 
> > One thing I just found out - my old *laptop* is 4-5x faster than the
> > 10krpm scsi disk behind an old cciss raid controller.  I'm wondering
> > if the long delays in dispatch is caused by an interaction with CTQ
> > but I can't change it on the cciss raid controllers. Are you using
> > ctq/ncq on your machine?  If so, can you reduce the depth to
> > something less than 4 and see what difference that makes?
> 
> Just to point out - this is not a new problem - I can reproduce
> it on 2.6.24 as well as 2.6.26. Likewise, my laptop shows XFS
> being faster than ext3 on both 2.6.24 and 2.6.26. So the difference
> is something related to the disk subsystem on the server....
> 
Hi Dave,

 just curious - which CCISS controller and and what kind of disk configuration are you using.

Cheers
Martin
