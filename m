Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Feb 2008 05:41:16 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1HDfDkI029040
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 05:41:14 -0800
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3ECF95E6A29
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 05:41:38 -0800 (PST)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id Orp8Hx9McobtTzAE for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 05:41:38 -0800 (PST)
Date: Sun, 17 Feb 2008 14:41:05 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
In-Reply-To: <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk>
Message-ID: <Pine.LNX.4.63.0802171424380.4514@alienAngel.home.sk>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
 <20080216074019.GV155407@sgi.com> <Pine.LNX.4.63.0802162319300.6528@alienAngel.home.sk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Sat, 16 Feb 2008, Jan Derfinak wrote:

> I would like to ask if correcting the feature2 field can lead to this
> message?:
> # xfs_check /dev/system/mnt
> sb_fdblocks 190009, counted 191033
> sb_fdblocks 190009, aggregate AGF count 191033

I think no. I made some more test I think that wrong sb_fdblocks is
pertinent to lazy-count feature. I used mkfs.xfs patched with Eric's patch,
so there was no correction during mount.

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
# xfsrestore -J -f var.dump /mnt/usb
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 2.2.48 (dump format 3.0) - Running single-threaded
xfsrestore: searching media for dump
xfsrestore: examining media file 0
xfsrestore: dump description: 
xfsrestore: hostname: host
xfsrestore: mount point: /var
xfsrestore: volume: /dev/mapper/system-var
xfsrestore: session time: Sun Feb 17 10:58:47 2008
xfsrestore: level: 0
xfsrestore: session label: "var"
xfsrestore: media label: "var"
xfsrestore: file system id: 6f9542f1-642f-463f-88ae-1b1b8b1383a9
xfsrestore: session id: 0cf809bb-a9f0-44aa-af7b-65fa79994677
xfsrestore: media id: b28bdc65-517e-4c27-809a-42a4baf3c238
xfsrestore: searching media for directory dump
xfsrestore: reading directories
xfsrestore: 1564 directories and 4965 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsrestore: restore complete: 50 seconds elapsed
xfsrestore: Restore Status: SUCCESS
# umount /mnt/usb
# xfs_check /dev/loop0
sb_fdblocks 48340, counted 49364


The same test without lazy-count.
# /root/mkfs.xfs -f -l lazy-count=0 /dev/loop0
meta-data=/dev/loop0             isize=256    agcount=4, agsize=64000 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=256000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
# xfs_check /dev/loop0
# mount /dev/loop0 /mnt/usb
# xfsrestore -J -f var.dump /mnt/usb
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 2.2.48 (dump format 3.0) - Running single-threaded
.
.
.
xfsrestore: restore complete: 48 seconds elapsed
xfsrestore: Restore Status: SUCCESS
# umount /mnt/usb
# xfs_check /dev/loop0
#

No errors with lazy-count=0.

architecture: x86_64
kernel: SGI-XFS CVS-2008-02-16_08:00_UTC with ACLs, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
# /root/mkfs.xfs -V
mkfs.xfs version 2.9.6 (With Eric's feature2 patch)

Cheers,
 
jan

-- 
