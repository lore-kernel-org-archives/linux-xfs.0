Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 06:05:19 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1JE5A5R011728
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 06:05:14 -0800
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9767DE5E4EB
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 06:05:35 -0800 (PST)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id YAPuJ8KkYJMOKRLn for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 06:05:35 -0800 (PST)
Date: Tue, 19 Feb 2008 15:05:32 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
In-Reply-To: <20080219014619.GY155407@sgi.com>
Message-ID: <Pine.LNX.4.63.0802191458080.4320@alienAngel.home.sk>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
 <20080216074019.GV155407@sgi.com> <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk>
 <20080217230645.GY155407@sgi.com> <Pine.LNX.4.63.0802180015110.4514@alienAngel.home.sk>
 <Pine.LNX.4.63.0802190044350.8907@alienAngel.home.sk> <20080219002059.GX155407@sgi.com>
 <Pine.LNX.4.63.0802190209490.20408@alienAngel.home.sk> <20080219014619.GY155407@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, 19 Feb 2008, David Chinner wrote:

> I did not use a patched mkfs - just my patch that does correction.

I tried with only your patch. The result is slightly different, but
not correct.
# mkfs.xfs -f /dev/loop0 
meta-data=/dev/loop0             isize=256    agcount=4, agsize=64000 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=256000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# mount /dev/loop0 /mnt/usb
# dmesg
...
Filesystem "loop0": Disabling barriers, not supported by the underlying device
XFS: correcting sb_features alignment problem
XFS mounting filesystem loop0
# umount /mnt/usb
# xfs_check  /dev/loop0
sb_fdblocks 253756, counted 254780
sb_fdblocks 253756, aggregate AGF count 254780


Cheers,
 
jan

-- 
