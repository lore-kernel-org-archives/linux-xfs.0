Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F61DC7618E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Apr 2023 02:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjDYCyn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Apr 2023 22:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjDYCym (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2023 22:54:42 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3872A26A8
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 19:54:41 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q563H3YcVzKykf;
        Tue, 25 Apr 2023 10:51:55 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 25 Apr
 2023 10:54:38 +0800
Date:   Tue, 25 Apr 2023 10:53:45 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>
CC:     <david@fromorbit.com>, <linux-xfs@vger.kernel.org>,
        <houtao1@huawei.com>, <yi.zhang@huawei.com>, <guoxuenan@huawei.com>
Subject: [PATCH] xfs: fix ag count overflow during growfs
Message-ID: <20230425025345.GA2098270@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I found a corruption during growfs:

 XFS (loop0): Internal error agbno >= mp->m_sb.sb_agblocks at line 3661 of
   file fs/xfs/libxfs/xfs_alloc.c.  Caller __xfs_free_extent+0x28e/0x3c0
 CPU: 0 PID: 573 Comm: xfs_growfs Not tainted 6.3.0-rc7-next-20230420-00001-gda8c95746257
 Call Trace:
  <TASK>
  dump_stack_lvl+0x50/0x70
  xfs_corruption_error+0x134/0x150
  __xfs_free_extent+0x2c1/0x3c0
  xfs_ag_extend_space+0x291/0x3e0
  xfs_growfs_data+0xd72/0xe90
  xfs_file_ioctl+0x5f9/0x14a0
  __x64_sys_ioctl+0x13e/0x1c0
  do_syscall_64+0x39/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 XFS (loop0): Corruption detected. Unmount and run xfs_repair
 XFS (loop0): Internal error xfs_trans_cancel at line 1097 of file
   fs/xfs/xfs_trans.c.  Caller xfs_growfs_data+0x691/0xe90
 CPU: 0 PID: 573 Comm: xfs_growfs Not tainted 6.3.0-rc7-next-20230420-00001-gda8c95746257
 Call Trace:
  <TASK>
  dump_stack_lvl+0x50/0x70
  xfs_error_report+0x93/0xc0
  xfs_trans_cancel+0x2c0/0x350
  xfs_growfs_data+0x691/0xe90
  xfs_file_ioctl+0x5f9/0x14a0
  __x64_sys_ioctl+0x13e/0x1c0
  do_syscall_64+0x39/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 RIP: 0033:0x7f2d86706577

The bug can be reproduced with the following sequence:

 # truncate -s  1073741824 xfs_test.img
 # mkfs.xfs -f -b size=1024 -d agcount=4 xfs_test.img
 # truncate -s 2305843009213693952  xfs_test.img
 # mount -o loop xfs_test.img /mnt/test
 # xfs_growfs -D  1125899907891200  /mnt/test

The root cause is that during growfs, user space passed in a large value
of newblcoks to xfs_growfs_data_private(), due to current sb_agblocks is
too small, new AG count will exceed UINT_MAX. Because of AG number type
is unsigned int and it would overflow, that caused nagcount much smaller
than the actual value. During AG extent space, delta blocks in
xfs_resizefs_init_new_ags() will much larger than the actual value due to
incorrect nagcount, even exceed UINT_MAX. This will cause corruption and
be detected in __xfs_free_extent. Fix it by add checks for AG number that
should not greater than or equal to NULLAGNUMBER before growfs and mount
filesystem.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/xfs_fsops.c   | 2 +-
 fs/xfs/xfs_mount.c   | 6 +++++-
 fs/xfs/xfs_mount.h   | 2 +-
 fs/xfs/xfs_rtalloc.c | 2 +-
 fs/xfs/xfs_super.c   | 4 ++--
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 13851c0d640b..0f0b12eaf53a 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -100,7 +100,7 @@ xfs_growfs_data_private(
 	struct xfs_perag	*last_pag;
 
 	nb = in->newblocks;
-	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb);
+	error = xfs_sb_validate_fsb_count(&mp->m_sb, nb, true);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fb87ffb48f7f..284c11c1c6e8 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -128,7 +128,8 @@ xfs_uuid_unmount(
 int
 xfs_sb_validate_fsb_count(
 	xfs_sb_t	*sbp,
-	uint64_t	nblocks)
+	uint64_t	nblocks,
+	bool		dblock)
 {
 	ASSERT(PAGE_SHIFT >= sbp->sb_blocklog);
 	ASSERT(sbp->sb_blocklog >= BBSHIFT);
@@ -136,6 +137,9 @@ xfs_sb_validate_fsb_count(
 	/* Limited by ULONG_MAX of page cache index */
 	if (nblocks >> (PAGE_SHIFT - sbp->sb_blocklog) > ULONG_MAX)
 		return -EFBIG;
+	/* Limited by NULLAGNUMBER of ag number */
+	if (dblock && (nblocks >> sbp->sb_agblklog) >= NULLAGNUMBER)
+		return -EFBIG;
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f3269c0626f0..a69e9b21ef61 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -531,7 +531,7 @@ xfs_mod_frextents(struct xfs_mount *mp, int64_t delta)
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
 extern bool	xfs_fs_writable(struct xfs_mount *mp, int level);
-extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, uint64_t);
+extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, uint64_t, bool);
 
 extern int	xfs_dev_is_read_only(struct xfs_mount *, char *);
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 16534e9873f6..c207026d92ac 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -958,7 +958,7 @@ xfs_growfs_rt(
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
-	error = xfs_sb_validate_fsb_count(sbp, nrblocks);
+	error = xfs_sb_validate_fsb_count(sbp, nrblocks, false);
 	if (error)
 		return error;
 	/*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4d2e87462ac4..72dfd02c588e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1592,8 +1592,8 @@ xfs_fs_fill_super(
 	}
 
 	/* Ensure this filesystem fits in the page cache limits */
-	if (xfs_sb_validate_fsb_count(&mp->m_sb, mp->m_sb.sb_dblocks) ||
-	    xfs_sb_validate_fsb_count(&mp->m_sb, mp->m_sb.sb_rblocks)) {
+	if (xfs_sb_validate_fsb_count(&mp->m_sb, mp->m_sb.sb_dblocks, true) ||
+	    xfs_sb_validate_fsb_count(&mp->m_sb, mp->m_sb.sb_rblocks, false)) {
 		xfs_warn(mp,
 		"file system too large to be mounted on this system.");
 		error = -EFBIG;
-- 
2.31.1

