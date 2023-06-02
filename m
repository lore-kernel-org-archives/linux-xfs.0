Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2C7C7EE2A
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jun 2023 02:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbjFBCUe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 22:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFBCUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 22:20:34 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C66413E
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 19:20:32 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QXRYR6FjTz4f3mVw
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jun 2023 10:20:27 +0800 (CST)
Received: from localhost (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgCX_7LsUXlkkzT0Kg--.22928S3;
        Fri, 02 Jun 2023 10:20:28 +0800 (CST)
Date:   Fri, 2 Jun 2023 10:18:44 +0800
From:   Long Li <leo.lilong@huaweicloud.com>
To:     djwong@kernel.org
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        yi.zhang@huawei.com, guoxuenan@huawei.com
Subject: [PATCH v4] xfs: fix ag count overflow during growfs
Message-ID: <20230602021844.GA3150998@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-CM-TRANSID: gCh0CgCX_7LsUXlkkzT0Kg--.22928S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAryxCFyfKry8GF45ZFyDGFg_yoWrWF4DpF
        n3K3WUCr1kKw1ayFsavF1UtFsxAwsay3WIkrykJrn7A3WUt347XF1qyr109a4xurWrZryF
        93Z8uryDZanYy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUglb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1j6r18M7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
        6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
        CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
        0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3w
        CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVF
        xhVjvjDU0xZFpf9x07UQzVbUUUUU=
X-CM-SenderInfo: hohrhzxlor0w46kxt4xhlfz01xgou0bp/
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
be detected in __xfs_free_extent. Fix it by growing the filesystem to up
to the maximally allowed AGs and not return EINVAL when new AG count
overflow.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
v3:
- Ensure that the performance is consisent before and after the modification
  when nagcount just overflows and 0 < nb_mod < XFS_MIN_AG_BLOCKS. 
- Based on Darrick's advice, growing the filesystem to up to the maximally
  allowed AGs when new AG count overflow.
v4:
- Define max ag number follow the definition in xfsprogs. 

 fs/xfs/libxfs/xfs_fs.h |  2 ++
 fs/xfs/xfs_fsops.c     | 13 +++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1cfd5bc6520a..9c60ebb328b4 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -257,6 +257,8 @@ typedef struct xfs_fsop_resblks {
 #define XFS_MAX_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_BLOCKSIZE)
 #define XFS_MAX_CRC_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_CRC_BLOCKSIZE)
 
+#define XFS_MAX_AGNUMBER	((xfs_agnumber_t)(NULLAGNUMBER - 1))
+
 /* keep the maximum size under 2^31 by a small amount */
 #define XFS_MAX_LOG_BYTES \
 	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 13851c0d640b..f03b6cd317a6 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -115,11 +115,16 @@ xfs_growfs_data_private(
 
 	nb_div = nb;
 	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
-	nagcount = nb_div + (nb_mod != 0);
-	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
-		nagcount--;
-		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
+	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
+		nb_div++;
+	else if (nb_mod)
+		nb = nb_div * mp->m_sb.sb_agblocks;
+
+	if (nb_div > XFS_MAX_AGNUMBER + 1) {
+		nb_div = XFS_MAX_AGNUMBER + 1;
+		nb = nb_div * mp->m_sb.sb_agblocks;
 	}
+	nagcount = nb_div;
 	delta = nb - mp->m_sb.sb_dblocks;
 	/*
 	 * Reject filesystems with a single AG because they are not
-- 
2.31.1

