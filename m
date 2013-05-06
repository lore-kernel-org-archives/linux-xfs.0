Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D60FA29DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 06:27:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 97FED304051
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 04:27:22 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id EWqjOQmTqt973Qdu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 04:27:20 -0700 (PDT)
Date: Mon, 6 May 2013 13:27:17 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Internal error xfs_sb_read_verify at line 726
Message-ID: <20130506112717.GA502@x4>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Today I accidentally tried to mount my backup disk at /dev/sdc instead
of /dev/sdc1 and this is what happened:

...
EXT4-fs (sdc): VFS: Can't find ext4 filesystem
FAT-fs (sdc): bogus number of reserved sectors
FAT-fs (sdc): Can't find a valid FAT filesystem
FAT-fs (sdc): bogus number of reserved sectors
FAT-fs (sdc): Can't find a valid FAT filesystem
ISOFS: Unable to identify CD-ROM format.
XFS (sdc): bad magic number
ffff8800db620000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff8800db620010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff8800db620020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
ffff8800db620030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
XFS (sdc): Internal error xfs_sb_read_verify at line 726 of file fs/xfs/xfs_mount.c.  Caller 0xffffffff8119e5cd

CPU: 3 PID: 68 Comm: kworker/3:1H Not tainted 3.9.0-10518-gd7ab730-dirty #440
Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
Workqueue: xfslogd xfs_buf_iodone_work
 ffffffff81537e9c ffffffff811a0416 000002d600000000 ffffffff8119e5cd
 ffff8800db2e7500 0000000000000016 ffff8801c0242800 ffff88021fd94f00
 ffffffff811e93d5 ffffffff8119e5cd ffff8802168ed820 ffff8800db2e75a0
Call Trace:
 [<ffffffff81537e9c>] ? dump_stack+0xc/0x15
 [<ffffffff811a0416>] ? xfs_corruption_error+0x56/0x80
 [<ffffffff8119e5cd>] ? xfs_buf_iodone_work+0x6d/0xa0
 [<ffffffff811e93d5>] ? xfs_sb_read_verify+0xf5/0x120
 [<ffffffff8119e5cd>] ? xfs_buf_iodone_work+0x6d/0xa0
 [<ffffffff8119e5cd>] ? xfs_buf_iodone_work+0x6d/0xa0
 [<ffffffff81072cbc>] ? process_one_work+0x13c/0x3c0
 [<ffffffff8107304d>] ? worker_thread+0x10d/0x3a0
 [<ffffffff81072f40>] ? process_one_work+0x3c0/0x3c0
 [<ffffffff8107912f>] ? kthread+0xaf/0xc0
 [<ffffffff81079080>] ? __kthread_parkme+0x80/0x80
 [<ffffffff8153cf2c>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff81079080>] ? __kthread_parkme+0x80/0x80
XFS (sdc): Corruption detected. Unmount and run xfs_repair
XFS (sdc): SB validate failed with error 22.
XFS (sdc1): Mounting Filesystem
XFS (sdc1): Ending clean mount

Seems a bit overkill to me ;-).

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
