Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Feb 2008 16:11:59 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1I0BtN1000715
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 16:11:57 -0800
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B05B0E46485
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 16:12:19 -0800 (PST)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id 7OLp9FGTaKK3LqEc for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 16:12:19 -0800 (PST)
Date: Mon, 18 Feb 2008 01:12:18 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
In-Reply-To: <20080217230645.GY155407@sgi.com>
Message-ID: <Pine.LNX.4.63.0802180015110.4514@alienAngel.home.sk>
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

mkfs, mount, xfsrestore, umount is 100% reproducable. I restored 5 different
filesystems, some of them several times.

Other tests (all show bug on first try):
# /root/mkfs.xfs -f /dev/loop0
meta-data=/dev/loop0             isize=256    agcount=4, agsize=64000 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=256000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# mount /dev/loop0 /mnt/usb
# cp -a /mnt/mnt/xfs/xfs-cmds /mnt/usb  (xfs-cmds is CVS repository)
# umount /mnt/usb
# xfs_check /dev/loop0 
sb_fdblocks 248626, counted 249650

# /root/mkfs.xfs -f /dev/loop0
meta-data=/dev/loop0             isize=256    agcount=4, agsize=64000 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=256000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# mount /dev/loop0 /mnt/usb
# cd /mnt/usb
# foreach i ( `seq 1 100` )
foreach? echo 123456789 > $i
foreach? end
# cd
# umount /mnt/usb
# xfs_check /dev/loop0
sb_fdblocks 253651, counted 254675

(added removing files)
# /root/mkfs.xfs -f /dev/loop0
meta-data=/dev/loop0             isize=256    agcount=4, agsize=64000 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=256000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# mount /dev/loop0 /mnt/usb
# cd /mnt/usb
# foreach i ( `seq 1 100` )
foreach? echo 123456789 > $i
foreach? end
# foreach i ( `seq 1 2 100` )
foreach? rm -f $i
foreach? end
# cd
# umount /mnt/usb
# xfs_check /dev/loop0
sb_fdblocks 253701, counted 254725

(test if mount fixes fdblocks information)
# mount /dev/loop0 /mnt/usb
# umount /mnt/usb
# xfs_check /dev/loop0
sb_fdblocks 252677, counted 254725
# mount /dev/loop0 /mnt/usb
# umount /mnt/usb
# xfs_check /dev/loop0
sb_fdblocks 251653, counted 254725
# mount /dev/loop0 /mnt/usb
# umount /mnt/usb
# xfs_check /dev/loop0
sb_fdblocks 250629, counted 254725

mount, umount sequence changes sb_fdblocks without any activity on filesystem,
after every run is sb_fdblocks different (less than previous) but not correct.

# mount -V
mount (util-linux-ng 2.13-rc2)

fdblocks on fresh mkfs-ed filesystem is:
fdblocks = 254780

Should I do any specific test?

> with dd and rm'ing a subset of the files before unmounting?
> I've run some simple tests this morning that do this, and I
> don't see any issues. I'd like to confirm that simple cases

Did you use x86_64 and latest CVS kernel?

Cheers,

jan

-- 
