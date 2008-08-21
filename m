Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 04:01:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7LB1Nev032624
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 04:01:24 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7D7FF92166
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 04:02:44 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id 8Llyq4mWlQTn9raf for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 04:02:44 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
Date: Thu, 21 Aug 2008 13:02:50 +0200
References: <20080820004326.519405a2.akpm@linux-foundation.org> <20080821060418.GC5706@disturbed> <20080821082532.GE5706@disturbed> (sfid-20080821_113328_880260_8C88CA66)
In-Reply-To: <20080821082532.GE5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211302.51633.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Am Donnerstag 21 August 2008 schrieb Dave Chinner:
> On Thu, Aug 21, 2008 at 04:04:18PM +1000, Dave Chinner wrote:
> > On Thu, Aug 21, 2008 at 03:15:08PM +1000, Dave Chinner wrote:
> > > On Thu, Aug 21, 2008 at 05:46:00AM +0300, Szabolcs Szakacsits wrote:
> > > > On Thu, 21 Aug 2008, Dave Chinner wrote:
> > > > Everything is default.
> > > >
> > > >   % rpm -qf =mkfs.xfs
> > > >   xfsprogs-2.9.8-7.1
> > > >
> > > > which, according to ftp://oss.sgi.com/projects/xfs/cmd_tars, is
> > > > the latest stable mkfs.xfs. Its output is
> > > >
> > > > meta-data=/dev/sda8              isize=256    agcount=4,
> > > > agsize=1221440 blks =                       sectsz=512   attr=2
> > > > data     =                       bsize=4096   blocks=4885760,
> > > > imaxpct=25 =                       sunit=0      swidth=0 blks
> > > > naming   =version 2              bsize=4096
> > > > log      =internal log           bsize=4096   blocks=2560,
> > > > version=2 =                       sectsz=512   sunit=0 blks,
> > > > lazy-count=0 realtime =none                   extsz=4096  
> > > > blocks=0, rtextents=0
> > >
> > > Ok, I thought it might be the tiny log, but it didn't improve
> > > anything here when increased the log size, or the log buffer size.
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

Interesting. I switched from cfq to deadline some time ago, due to abysmal 
XFS performance on parallel IO - aptitude upgrade and doing desktop 
stuff. Just my subjective perception, but I have seen it crawl, even 
stall for 5-10 seconds easily at times. I found deadline to be way faster 
initially, but then it rarely happened that IO for desktop tasks is 
basically stalled for even longer, say 15 seconds or more, on parallel 
IO. However I can't remember having this problem with the last kernel 
2.6.26.2.

I am now testing with cfq again. On a ThinkPad T42 internal 160 GB 
harddisk with barriers enabled. But you tell, it only happens on certain 
servers, so I might have seen something different.

Thus I had the rough feeling that something is wrong with at least CFQ and 
XFS together, but I couldn't prove it back then. I have no idea how to 
easily do a reproducable test case. Maybe having a script that unpacks 
kernel source archives while I try to use the desktop...

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
