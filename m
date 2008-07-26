Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 15:02:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6QM2UZV021225
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 15:02:30 -0700
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67562EA7684
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 15:03:41 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.240]) by cuda.sgi.com with ESMTP id T99qSYt1d7way7KH for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 15:03:41 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id f25so2846001rvb.32
        for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 15:03:41 -0700 (PDT)
Message-ID: <8ece0edb0807261503w2998464asfeb403cce270d9ae@mail.gmail.com>
Date: Sat, 26 Jul 2008 22:03:40 +0000
From: entereczek <entereczek@gmail.com>
Subject: HDD and xfs problem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I've got a problem with my harddisk. After last reboot my system hangs
with kernel panic about xfs problems. I tried accessing my xfs
partitions using live cd but I get:

[ 2567.872000] hda: drive not ready for command
[ 2567.888000] hda: status error: status=0x59 { DriveReady
SeekComplete DataRequest Error }
[ 2567.888000] hda: status error: error=0x40 { UncorrectableError },
LBAsect=23695938, high=1, low=6918722, sector=23695938
[ 2567.888000] ide: failed opcode was: unknown
[ 2567.888000] end_request: I/O error, dev hda, sector 23695938
[ 2567.888000] hda: drive not ready for command
[ 2567.892000] hda: status error: status=0x59 { DriveReady
SeekComplete DataRequest Error }
[ 2567.892000] hda: status error: error=0x40 { UncorrectableError },
LBAsect=23695938, high=1, low=6918722, sector=23695942
[ 2567.892000] ide: failed opcode was: unknown
[ 2567.892000] end_request: I/O error, dev hda, sector 23695942
[ 2567.892000] hda: drive not ready for command
[ 2567.928000] hda: status error: status=0x59 { DriveReady
SeekComplete DataRequest Error }
[ 2567.928000] hda: status error: error=0x40 { UncorrectableError },
LBAsect=23695938, high=1, low=6918722, sector=0
[ 2567.928000] ide: failed opcode was: 0xea
[ 2567.928000] hda: drive not ready for command
[ 2567.928000] hda: wcache flush failed!

The weirdest thing is that I can boot that disk and in command line
grub after trying:
>root (hd0,[press TAB]
I get list of 3 first partitions and instead of last 3 I get:

Error 18: Selected cylinder exceeds maximum supported by BIOS

I tried >root (hd0,5) which was my home directory and I didn't get any
errors. So i tried:
>kernel /myusername/[TAB]
and I got list of my dirs&files. I can list files and show it's
content by grub's cat from that partition using grub, but I can't do
mount it using live cd.
So I deeply investigated it using livecd:

>fdisk -l /dev/hda
>ls /dev/hda*
/dev/hda  /dev/hda1  /dev/hda2  /dev/hda3  /dev/hda4  /dev/hda5  /dev/hda6
>xfs_admin -l /dev/hda5
xfs_admin: /dev/hda1 is invalid (cannot read first 512 bytes)
>dd if=/dev/hda of=temp
dd: reading `/dev/hda': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.0301734 seconds, 0.0 kB/s
>dd if=/dev/hda5 of=temp
dd: reading `/dev/hda5': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.0619014 seconds, 0.0 kB/s

and in dmesg I get lots of errors as above.
So, fdisk doesn't see any partitions but block devices are good.
I get in&out error in linux, but grub can access that xfs partition.
So here is the deal:
1. Is there any chance of forcing linux to get access to this drive?
2. Is there any way of getting a mirror clone of this drive so I can
try for example replacing first 512 bytes from another xfs partition
or any other way without disturbing the orginal one?
3. Is there any way of cloning content of this xfs in grub-level or
use grub-implementation of xfs client to get access to this data?
4. Is there any other working way of getting access to my data?

PS: I almost forgot, I tried connecting this HDD to PC running M$ Win
and when I accessed partition manager in computer management it hang
:P

Regards,
Entereczek
