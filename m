Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 16:04:18 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1J04AWi007810
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 16:04:14 -0800
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFE245EDC8E
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 16:04:36 -0800 (PST)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id zezWfCmHYu23PeDY for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 16:04:36 -0800 (PST)
Date: Tue, 19 Feb 2008 01:04:35 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
In-Reply-To: <Pine.LNX.4.63.0802180015110.4514@alienAngel.home.sk>
Message-ID: <Pine.LNX.4.63.0802190044350.8907@alienAngel.home.sk>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
 <20080216074019.GV155407@sgi.com> <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk>
 <20080217230645.GY155407@sgi.com> <Pine.LNX.4.63.0802180015110.4514@alienAngel.home.sk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, 18 Feb 2008, Jan Derfinak wrote:

> > with dd and rm'ing a subset of the files before unmounting?
> > I've run some simple tests this morning that do this, and I
> > don't see any issues. I'd like to confirm that simple cases
> 
> Did you use x86_64 and latest CVS kernel?

I have run the mount,umount test on x86 architecture with the same kernel
source version. Kernel image is of course different, it is different
computer.
On x86 everything is ok.
I guess that problem is in 64-bit architecture. Is it possible?


dmesg:
SGI-XFS CVS-2008-02-15_08:00_UTC with ACLs, no debug enabled
SGI XFS Quota Management subsystem

mkfs.xfs version 2.9.6

# mkfs.xfs -f /dev/loop0
meta-data=/dev/loop0             isize=256    agcount=4, agsize=64000 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=256000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# xfs_check /dev/loop0 
# mount /dev/loop0 /mnt/usb
# umount /dev/loop0 
# xfs_check /dev/loop0
# 


Cheers,
 
jan

-- 
