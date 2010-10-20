Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9K6CKDA033819 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 01:12:20 -0500
Received: from mail1.noloco.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D277106551
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 23:13:33 -0700 (PDT)
Received: from mail1.noloco.com (mail.homesbylynette.com [38.119.107.104]) by
	cuda.sgi.com with ESMTP id 98prlosrFI0JWvI9 for
	<xfs@oss.sgi.com>; Tue, 19 Oct 2010 23:13:33 -0700 (PDT)
Received: from ASSP.nospam (localhost.localdomain [127.0.0.1])
	by mail1.noloco.com (Postfix) with ESMTP id 2FD8578456
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 01:13:33 -0500 (CDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail1.noloco.com (Postfix) with ESMTP id BC352E11C5
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 01:13:32 -0500 (CDT)
Received: from mail1.noloco.com ([127.0.0.1])
	by localhost (mail1.noloco.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f9c4F4Fil6ft for <xfs@oss.sgi.com>;
	Wed, 20 Oct 2010 01:13:30 -0500 (CDT)
Received: from [127.0.0.1] (173-165-241-186-minnesota.hfc.comcastbusiness.net
	[173.165.241.186])
	by mail1.noloco.com (Postfix) with ESMTPSA id 87F46E118F
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 01:13:30 -0500 (CDT)
Message-ID: <4CBE887F.6020506@dolphinlogic.com>
Date: Wed, 20 Oct 2010 01:13:19 -0500
From: Shawn Usry <shawn@dolphinlogic.com>
MIME-Version: 1.0
Subject: Interesting possible XFS crash condition
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

  Hi List -

First off, thanks for the great filesystem.  Thus far it's been an 
excellent performer for my needs both professionally and personally.

I have a situation/environment that is producing a kernel crash, that 
may be XFS related.   A colleague suggested I post to this list as there 
may be some interest in reproducing it.


Environment (current):

Fedora core 13 (kernel 2.6.34.7-56.fc13.i686)
xfsprogs-3.1.1-7.fc13.i686

RAID5 Controller:  3ware 9550-SXU-8LP 8-port sata controller, 64-bit PCI-X.
XFS filesystem in question is on a RAID 5 array on this controller, made 
of up 4 identical disks, 1.5TB each, 64k stripe (block device = /dev/sdb)

The setup:
ORIGINALLY, this was a 3-disk RAID5.  Created the XFS filesystem with:
   --> mkfs -t xfs /dev/sdb

All was well in use to this point.

Next, I ADDED a 4th disk to the array, and expanded the array in place; 
and operation supported by this RAID device.
New usable size = 4.5T

Once completed, I grew the XFS filesystem with xfs_growxfs to expand 
into the full size of the new array.

Again, all was well, for about a week of normal use - fairly heavy 
copy/read/write operations on a regular basis.

Then, without any changes or warning (that I was aware of at least), the 
machine started crashing/kernel panic anytime I accessed (read/write) 
MOST of the files in the filesystem.   Some files could be accessed 
without a problem.  In general though any kind of high I/O (copying a 
file (not moving) to the same device, copying to another block 
device/disk, reading it across the network, etc) now causes the 
condition, observed by access occurring normally for the first few MB 
(this seems to vary in value) and then the system locking up completely.

Most of the time, the system becomes unresponsive and must be rebooted 
to gain access again.   In some cases though, system access will return, 
on a limited / choppy basis and messages like "card reset" will appear 
in the message log.

The latter statement and observations lead me to believe that perhaps 
this was simply a yucky controller that was failing under heavy I/O.   
However, several other tests/observations leave me wondering if it may 
be a corrupt filesystem in some way, that is not being detected by 
xfs_repair.

Tests / Observations:

1.  Mounted, or Unmounted, I can "dd" the block device array (/dev/sdb)  
all day long without a problem:
--> dd if=/dev/sdb of=/dev/null bs=(varied tests)    result:  end to end 
no problem
--> dd if=/dev/sdb of=/tmp/test.file bs=(varies)  result:   no problem 
(as long as test.file space permits..)

2.  I can CREATE arbitrary NEW files onto the filesystem, and copy them 
/read them OFF the device, such as a disk-to-otherdisk, 
disk-to-samedisk, copy across the network, etc, read them, delete, them 
- NO CRASH.
--> dd if=/dev/zero of=/myblkdevice/test.file bs=1M count=1024 (create 
an arbitrary 1GB file).  All normal.

3.  Copying / Reading existing files (at least, that existed at the time 
I grew the array) seems to trigger the system crash.  Copying/reading 
said NEW files (i.e., #2 above) does NOT trigger the crash.

4.  Copying EXISTING files from other servers / locations on the 
network, or other disks,  to the device triggers the crash (i.e., would 
be a NEW file being copied to the array, but not created ON the array).

5.  Unmounted, xfs_repair -n /dev/sdb ---> finds no issues

6.  Unmounted, xfs_repair /dev/sdb ---> finds no issues, performs no 
changes.

Other Notes:
1.  I did recently learn of the create-time and mount-time options 
sunit/swidth for optimizing performance.   Setting these had no effect 
on this issue.

2.  SOME files behave perfectly normal. I can copy them, read them, etc 
without a problem.  But for the MOST part, MOST files, and MOST all file 
operations seem to trigger the crash, though

3.  Limited information shown in what I've been able to capture in the 
kernel crash.  Nothing really specific or repeatable (different message 
each time) - some instances to the term "atomic" and "xfs" - other times 
"irq" related.

4.  In general the crash seems to happen when I either:
    a.  Attempt to do any reads of files larger than 100 MB or so 
(small, single operations don't seem to have an effect, but strings of 
small operations (unzipping a dir of files, for example) does).
    b.  Attempt to move or copy any data to the filesystem that didn't 
ORIGINATE on the filesystem.


Questions:
1.  Is is possible that my raid-expansion on the 3ware board brought on 
some kind of corruption?   Might not xfs_repair detect this if so?

2.  Are there any thoughts / patches / commands / debug options I might 
try to resolve this?

3.  Is this more likely a problem with the 3ware controller + XFS 
combination?

The only recourse I've thought of is to completely wipe the array and 
start from scratch with a fresh 4-disk array, and XFS filesystem 
creation, then copy data back to it.

I can't leave this device in place in an unusable state very long - I 
just thought this list might be interested in the conditions.   Any 
suggestions or thoughts would be greatly appreciated.  Resolving this 
would save me a good deal of time.

Shawn

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
