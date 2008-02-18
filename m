Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Feb 2008 16:17:00 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1I0Gt7a001442
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 16:16:58 -0800
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83659E464FD
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 16:17:20 -0800 (PST)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id hc18ZfxIJqKfNK3t for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 16:17:20 -0800 (PST)
Date: Mon, 18 Feb 2008 01:17:21 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
In-Reply-To: <20080217230645.GY155407@sgi.com>
Message-ID: <Pine.LNX.4.63.0802180113560.4514@alienAngel.home.sk>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
 <20080216074019.GV155407@sgi.com> <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk>
 <20080217230645.GY155407@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, 18 Feb 2008, David Chinner wrote:

> Is this reproducable with simple tests? e.g. mkfs, mount, unmount
> check? or doing some simple things like creating some files

One more test (no FS activity, only mount, umount sequence):
# /root/mkfs.xfs -f /dev/loop0
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
# umount /mnt/usb
# xfs_check /dev/loop0
sb_fdblocks 253756, counted 254780
# mount /dev/loop0 /mnt/usb
# umount /mnt/usb
# xfs_check /dev/loop0
sb_fdblocks 252732, counted 254780

Cheers,

jan

-- 
