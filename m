Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50216 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753725AbeFUSbi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 14:31:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5LITH8l083098
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:37 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2jmr2muat8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:37 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5LIVa7V017456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:36 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5LIVa1P018581
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:36 GMT
Subject: [PATCH 5/8] xfs: recheck reflink state after grabbing ILOCK_SHARED
 for a write
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jun 2018 11:31:35 -0700
Message-ID: <152960589497.26246.2694743986896972501.stgit@magnolia>
In-Reply-To: <152960586416.26246.8634761888260524091.stgit@magnolia>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The reflink iflag could have changed since the earlier unlocked check,
so if we got ILOCK_SHARED for a write and but we're now a reflink inode
we have to switch to ILOCK_EXCL and relock.

This helps us avoid blowing lock assertions in things like generic/166:

XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/xfs_reflink.c, line: 383
WARNING: CPU: 1 PID: 24707 at fs/xfs/xfs_message.c:104 assfail+0x25/0x30 [xfs]
Modules linked in: deadline_iosched dm_snapshot dm_bufio ext4 mbcache jbd2 dm_flakey xfs libcrc32c dax_pmem device_dax nd_pmem sch_fq_codel af_packet [last unloaded: scsi_debug]
CPU: 1 PID: 24707 Comm: xfs_io Not tainted 4.18.0-rc1-djw #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:assfail+0x25/0x30 [xfs]
Code: ff 0f 0b c3 90 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 e8 ef 1b a0 48 89 fa 31 ff e8 54 f9 ff ff 80 3d fd ba 0f 00 00 75 03 <0f> 0b c3 0f 0b 66 0f 1f 44 00 00 66 66 66 66 90 48 63 f6 49 89 f9
RSP: 0018:ffffc90006423ad8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff880030b65e80 RCX: 0000000000000000
RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa01b0447
RBP: ffffc90006423c10 R08: 0000000000000000 R09: 0000000000000000
R10: ffff88003d43fc30 R11: f000000000000000 R12: ffff880077cda000
R13: 0000000000000000 R14: ffffc90006423c30 R15: ffffc90006423bf9
FS:  00007feba8986800(0000) GS:ffff88003ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000138ab58 CR3: 000000003d40a000 CR4: 00000000000006a0
Call Trace:
 xfs_reflink_allocate_cow+0x24c/0x3d0 [xfs]
 xfs_file_iomap_begin+0x6d2/0xeb0 [xfs]
 ? iomap_to_fiemap+0x80/0x80
 iomap_apply+0x5e/0x130
 iomap_dio_rw+0x2e0/0x400
 ? iomap_to_fiemap+0x80/0x80
 ? xfs_file_dio_aio_write+0x133/0x4a0 [xfs]
 xfs_file_dio_aio_write+0x133/0x4a0 [xfs]
 xfs_file_write_iter+0x7b/0xb0 [xfs]
 __vfs_write+0x16f/0x1f0
 vfs_write+0xc8/0x1c0
 ksys_pwrite64+0x74/0x90
 do_syscall_64+0x56/0x180
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 49f5492eed3b..55876dd02f0c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -963,12 +963,13 @@ xfs_ilock_for_iomap(
 	unsigned		*lockmode)
 {
 	unsigned		mode = XFS_ILOCK_SHARED;
+	bool			is_write = flags & (IOMAP_WRITE | IOMAP_ZERO);
 
 	/*
 	 * COW writes may allocate delalloc space or convert unwritten COW
 	 * extents, so we need to make sure to take the lock exclusively here.
 	 */
-	if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | IOMAP_ZERO))) {
+	if (xfs_is_reflink_inode(ip) && is_write) {
 		/*
 		 * FIXME: It could still overwrite on unshared extents and not
 		 * need allocation.
@@ -989,6 +990,7 @@ xfs_ilock_for_iomap(
 		mode = XFS_ILOCK_EXCL;
 	}
 
+relock:
 	if (flags & IOMAP_NOWAIT) {
 		if (!xfs_ilock_nowait(ip, mode))
 			return -EAGAIN;
@@ -996,6 +998,17 @@ xfs_ilock_for_iomap(
 		xfs_ilock(ip, mode);
 	}
 
+	/*
+	 * The reflink iflag could have changed since the earlier unlocked
+	 * check, so if we got ILOCK_SHARED for a write and but we're now a
+	 * reflink inode we have to switch to ILOCK_EXCL and relock.
+	 */
+	if (mode == XFS_ILOCK_SHARED && is_write && xfs_is_reflink_inode(ip)) {
+		xfs_iunlock(ip, mode);
+		mode = XFS_ILOCK_EXCL;
+		goto relock;
+	}
+
 	*lockmode = mode;
 	return 0;
 }

