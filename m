Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Mar 2008 17:47:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2H0l6jL027290
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2008 17:47:06 -0700
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 722E3FAECD9
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2008 17:47:38 -0700 (PDT)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id Q6B4RPnCrgWVG5qh for <xfs@oss.sgi.com>; Sun, 16 Mar 2008 17:47:38 -0700 (PDT)
Date: Sun, 16 Mar 2008 23:44:30 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
In-Reply-To: <20080220054216.GN155407@sgi.com>
Message-ID: <Pine.LNX.4.64.0803162336100.8204@alienAngel.home.sk>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
 <20080216074019.GV155407@sgi.com> <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk>
 <20080217230645.GY155407@sgi.com> <Pine.LNX.4.63.0802180015110.4514@alienAngel.home.sk>
 <Pine.LNX.4.63.0802190044350.8907@alienAngel.home.sk> <20080219002059.GX155407@sgi.com>
 <Pine.LNX.4.63.0802190209490.20408@alienAngel.home.sk> <20080219014619.GY155407@sgi.com>
 <Pine.LNX.4.63.0802191458080.4320@alienAngel.home.sk> <20080220054216.GN155407@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, 20 Feb 2008, David Chinner wrote:

> On Tue, Feb 19, 2008 at 03:05:32PM +0100, Jan Derfinak wrote:
> > On Tue, 19 Feb 2008, David Chinner wrote:
> > 
> > > I did not use a patched mkfs - just my patch that does correction.
> > 
> > I tried with only your patch. The result is slightly different, but
> > not correct.
> 
> Ok, still 1024 blocks out. Still need to reproduce it locally.
> 
> FYI - thisis not a corruption bug - just an accounting problem.
> IOWs, all it will cause is slightly premature detection of ENOSPC....

Just for your information.
I tested kernel 2.6.25-rc5 compiled from sources from ftp.kernel.org.
The bug with wrong sb_fdblocks is there too:
# xfs_check /dev/system/mnt
# mount /mnt/mnt
# umount /mnt/mnt
# xfs_check /dev/system/mnt
sb_fdblocks 214009, counted 215033

# xfs_info /mnt/mnt
meta-data=/dev/mapper/system-mnt isize=256    agcount=4, agsize=554240 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2216960, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# uname -a
Linux host 2.6.25-rc5 #1 Sun Mar 16 21:17:39 CET 2008 x86_64 x86_64 x86_64 GNU/Linux
# xfs_repair -V
xfs_repair version 2.9.6


jan
 

-- 
