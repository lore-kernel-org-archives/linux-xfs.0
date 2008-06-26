Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 21:49:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q4nBQs011251
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:49:12 -0700
Received: from web34508.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 9C0E8D5634C
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:50:12 -0700 (PDT)
Received: from web34508.mail.mud.yahoo.com (web34508.mail.mud.yahoo.com [66.163.178.174]) by cuda.sgi.com with SMTP id nRFxQBXb0GEMkwME for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:50:12 -0700 (PDT)
Date: Wed, 25 Jun 2008 21:50:11 -0700 (PDT)
From: Mark <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: XFS w/ extern journal as root on Linux?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <732501.9968.qm@web34508.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Well, I tried to convert my non-/home space to XFS with an external journal, but Linux consistently choked on it. I passed "rootfstype=xfs root=/dev/sdb5 rootflags=logdev=/dev/sda2" on the kernel command line (via GRUB) but it panicked every time. 

Here is a transcript of the boot panic from an unmodified kernel:

~~~~~~~~~~~~~~~~~
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
XFS: Invalid device [/dev/sda2], error=-2
VFS: Cannot open root device "sdb5" or unknown-block(8,21)
Please append a correct "root=" boot option; here are the available partitions:
0800  390711384 sda driver: sd
 0801 1005448 sda1
 0802 3008880 sda2
 0803 30005640 sda3
 0804 1 sda4
 0805 356688328 sda5
0b00  1048575 sr0 driver: sr
0810 488386584 sdb driver: sd
 0811 146488671 sdb1
 0812 4008217 sdb2
 0813 3004155 sdb3
 0814 1 sdb4
 0815 334882926 sdb5
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,21)
~~~~~~~~~~~~~~~~~

Judging from the output, it seems not to be able to open the log device /dev/sda2. I slipped in a couple statements in xfs_vfsops.c to watch for function entries and successful exits. I saw where xfs_blkdev_get() was called twice, the first time successfully (probably corresponding to /dev/sdb5), the second time unsuccessfully (/dev/sda2). Yet, the partition list at the end of the panic shows /dev/sda2 as recognized and available.

Is this a known issue?

As an acceptable substitute, I moved /usr to XFS with an external journal. Staying with the deadline scheduler, it's a noticeable difference. OOo launches in about 4 seconds.
-- 
Mark

"What better place to find oneself than
 on the streets of one's home village?"
      --Capt. Jean-Luc Picard, "Family"
