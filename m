Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Nov 2008 07:36:23 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA9FZmq1002467
	for <xfs@oss.sgi.com>; Sun, 9 Nov 2008 07:35:48 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7963715272B8
	for <xfs@oss.sgi.com>; Sun,  9 Nov 2008 07:35:48 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id S7cKmUx4adMS0MiP for <xfs@oss.sgi.com>; Sun, 09 Nov 2008 07:35:48 -0800 (PST)
Date: Sun, 9 Nov 2008 10:28:21 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: xfs_repair hanging
Message-ID: <alpine.DEB.1.10.0811091026030.6319@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

p34:~# xfs_repair -V
xfs_repair version 2.9.8

Hangs with xfs_repair as shown below or with -L option.

p34:~# xfs_repair /dev/md3
Phase 1 - find and verify superblock...
Phase 2 - using internal log
         - zero log...
         - scan filesystem freespace and inode maps...
bad magic # 0x58443242 in btbno block 0/1022
expected level 1 got 2672 in btbno block 0/1022
bad magic # 0x3f052a50 in btbno block 0/12392
bad magic # 0 in btbno block 0/36892
bad magic # 0 in btbno block 0/1241755
bad magic # 0x2f2a0a20 in btbno block 0/2800
bad magic # 0x44726976 in btbno block 0/2672
bad magic # 0x30302d49 in btbno block 0/46
<hang>

strace of event:
write(2, "bad magic # 0 in btbno block 0/36"..., 37bad magic # 0 in btbno block 0/36892
) = 37
pread(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096, 5086228480) = 4096
write(2, "bad magic # 0 in btbno block 0/12"..., 39bad magic # 0 in btbno block 0/1241755
) = 39
pread(4, "/*\n * arch/arm/mach-loki/include/"..., 4096, 11468800) = 4096
write(2, "bad magic # 0x2f2a0a20 in btbno b"..., 45bad magic # 0x2f2a0a20 in btbno block 0/2800
) = 45
pread(4, "Driver\n------\n\nInformations about"..., 4096, 10944512) = 4096
write(2, "bad magic # 0x44726976 in btbno b"..., 45bad magic # 0x44726976 in btbno block 0/2672
) = 45
pread(4, "00-INDEX\n\t- this file (info on so"..., 4096, 188416) = 4096
write(2, "bad magic # 0x30302d49 in btbno b"..., 43bad magic # 0x30302d49 in btbno block 0/46
) = 43
futex(0x185d098, FUTEX_WAIT_PRIVATE, 2, NULL

I can mount the filesystem but its a bit mangled:

p34:~# cd /r1
p34:/r1# ls
ls: cannot access x3: Structure needs cleaning
ls: cannot access x4: Structure needs cleaning
ls: cannot access x5: Structure needs cleaning

Should I re-format or is there any possibility to fix the FS?  This was 
due to some disks going in/out of a RAID5, not XFS' fault but xfs_repair 
failing to repair seems strange.

Justin.
