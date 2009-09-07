Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n876b4Cb218286 for <xfs@oss.sgi.com>; Mon, 7 Sep 2009 01:37:14 -0500
Received: from peace.netnation.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57E0542F620
	for <xfs@oss.sgi.com>; Sun,  6 Sep 2009 23:37:25 -0700 (PDT)
Received: from peace.netnation.com (newpeace.netnation.com [204.174.223.7]) by
	cuda.sgi.com with ESMTP id wX8kmbFR9onFkCpZ for
	<xfs@oss.sgi.com>; Sun, 06 Sep 2009 23:37:25 -0700 (PDT)
Received: from sim by peace.netnation.com with local (Exim 4.63)
	(envelope-from <sim@netnation.com>) id 1MkXqu-0001Bl-RQ
	for xfs@oss.sgi.com; Sun, 06 Sep 2009 23:37:24 -0700
Date: Sun, 6 Sep 2009 23:37:24 -0700
From: Simon Kirby <sim@hostway.ca>
Subject: XFS corruption [2.6.30.5+patches.2.6.30.tgz]
Message-ID: <20090907063724.GB4568@hostway.ca>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello!

In a backup server attached to a Coraid shelf via AOE and DM, we saw
2.6.30.5+patches.2.6.30.tgz die with a corruption problem.  The kernel
logged many similar errors, and then stopped responding some time later.

This particular storage is written to entirely by "cp" and "rsync", and
is responsible for storing backups over NFS.  The file system was created
only a few days ago, and the system had not rebooted since mkfs.xfs. 
This is one of six volumes at 3 TB each.

This file system stores a hardlink-based backup (eg: where each day's
backups are hardlinked except where files change), and this crash
occurred during a run of "cp -al" between backup trees:

Sep  3 00:05:22 backup01 kernel: ffff880125072000: 54 03 62 d0 83 cf 00 00 00 6c 16 47 00 6c 16 47  T.b......l.G.l.G
Sep  3 00:05:22 backup01 kernel: Filesystem "dm-59": XFS internal error xfs_da_do_buf(2) at line 2112 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff803fec85
Sep  3 00:05:22 backup01 kernel:
Sep  3 00:05:22 backup01 kernel: Pid: 2449, comm: cp Not tainted 2.6.30.5-hw-fixedxfs #1
Sep  3 00:05:22 backup01 kernel: Call Trace:
Sep  3 00:05:22 backup01 kernel: [<ffffffff8040a83e>] xfs_error_report+0x3e/0x40
Sep  3 00:05:22 backup01 kernel: [<ffffffff803fec85>] ? xfs_da_read_buf+0x25/0x30
Sep  3 00:05:22 backup01 kernel: [<ffffffff8040a898>] xfs_corruption_error+0x58/0x70
Sep  3 00:05:22 backup01 kernel: [<ffffffff803febbd>] xfs_da_do_buf+0x65d/0x6b0  
Sep  3 00:05:22 backup01 kernel: [<ffffffff803fec85>] ? xfs_da_read_buf+0x25/0x30   
Sep  3 00:05:22 backup01 kernel: [<ffffffff80705c47>] ? __down_read+0x17/0xc7  
Sep  3 00:05:22 backup01 kernel: [<ffffffff8028a4ea>] ? get_page_from_freelist+0x30a/0x480
Sep  3 00:05:22 backup01 kernel: [<ffffffff802c1d30>] ? filldir+0x0/0xe0
Sep  3 00:05:22 backup01 kernel: [<ffffffff803fec85>] xfs_da_read_buf+0x25/0x30
Sep  3 00:05:22 backup01 kernel: [<ffffffff804026ea>] ? xfs_dir2_block_getdents+0x7a/0x1e0
Sep  3 00:05:22 backup01 kernel: [<ffffffff804026ea>] xfs_dir2_block_getdents+0x7a/0x1e0
Sep  3 00:05:22 backup01 kernel: [<ffffffff802c1d30>] ? filldir+0x0/0xe0
Sep  3 00:05:22 backup01 kernel: [<ffffffff802c1d30>] ? filldir+0x0/0xe0
Sep  3 00:05:22 backup01 kernel: [<ffffffff804013f1>] xfs_readdir+0xd1/0xe0
Sep  3 00:05:22 backup01 kernel: [<ffffffff802c1d30>] ? filldir+0x0/0xe0
Sep  3 00:05:22 backup01 kernel: [<ffffffff80431d6a>] xfs_file_readdir+0x3a/0x50
Sep  3 00:05:22 backup01 kernel: [<ffffffff802c1eb1>] vfs_readdir+0xa1/0xc0
Sep  3 00:05:22 backup01 kernel: [<ffffffff802c2141>] sys_getdents+0x81/0xd0
Sep  3 00:05:22 backup01 kernel: [<ffffffff80706365>] ? page_fault+0x25/0x30
Sep  3 00:05:22 backup01 kernel: [<ffffffff8020be02>] system_call_fastpath+0x16/0x1b
Sep  3 00:05:22 backup01 kernel: ffff880228059000: f7 b6 37 2e cf dc e2 ea 00 00 00 00 00 00 00 00  ..7.............
Sep  3 00:05:22 backup01 kernel: Filesystem "dm-59": XFS internal error xfs_da_do_buf(2) at line 2112 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff803fec85
(same backtrace)
Sep  3 00:05:22 backup01 kernel: Filesystem "dm-59": XFS internal error xfs_da_do_buf(2) at line 2112 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff803fec85
(same backtrace)

Full kern.log including result from attempt to mount after reboot:

	http://0x.ca/sim/ref/2.6.30.5-hw-fixedxfs/kern_log_0.txt

I've left the file system in this state for debugging purposes.  I can
run xfs_repair or metadata dumps, etc., on demand.

Cheers,

Simon-

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
