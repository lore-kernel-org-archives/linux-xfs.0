Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44809C77B76
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 11:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjDULjK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 07:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjDULjJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 07:39:09 -0400
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786AEC65B
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 04:38:25 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4Q2shn41K5z9v7Hm
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 19:28:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id BqC_BwDH+IJudUJkSOICBg--.28716S4;
        Fri, 21 Apr 2023 11:37:30 +0000 (GMT)
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org
Cc:     sandeen@redhat.com, guoxuenan@huawei.com,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, fangwei1@huawei.com,
        jack.qiu@huawei.com, yi.zhang@huawei.com
Subject: [PATCH v2 2/2] xfs: clean up some unnecessary xfs_stack_trace
Date:   Fri, 21 Apr 2023 19:37:16 +0800
Message-Id: <20230421113716.1890274-3-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230421113716.1890274-1-guoxuenan@huawei.com>
References: <20230421113716.1890274-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: BqC_BwDH+IJudUJkSOICBg--.28716S4
X-Coremail-Antispam: 1UD129KBjvJXoW7trWDXw4rAFWxKFWruw1rJFb_yoW8uFW8pF
        n7Aan2kr4qyryjvrn8Jry0qw18Jry0kw10krn5Aw1Sqw4UJ3W7Ary0yw10gwnrWa9Yv3ya
        gr9rur47Xw4rXa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUQ0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
        A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
        Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
        Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
        Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7Iv64x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YV
        CY1x02628vn2kIc2xKxwCF04k20xvY0x0EwIxGrwCF04k20xvEw4C26cxK6c8Ij28IcwCF
        x2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14
        v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY
        67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2
        IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_
        Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxU2Xo2UUUUU
Sender: guoxuenan@huaweicloud.com
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With xfs print level parsing correctly, these duplicate dump
information can be removed.

Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 1 -
 fs/xfs/xfs_error.c         | 9 ---------
 fs/xfs/xfs_fsops.c         | 2 --
 fs/xfs/xfs_log.c           | 2 --
 4 files changed, 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index a16d5de16933..df4e4eb19f14 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2329,7 +2329,6 @@ xfs_imap(
 				__func__, ino,
 				XFS_AGINO_TO_INO(mp, pag->pag_agno, agino));
 		}
-		xfs_stack_trace();
 #endif /* DEBUG */
 		return error;
 	}
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index b2cbbba3e15a..7c8e1f3b69a6 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -421,9 +421,6 @@ xfs_buf_corruption_error(
 		  fa, bp->b_ops->name, xfs_buf_daddr(bp));
 
 	xfs_alert(mp, "Unmount and run xfs_repair");
-
-	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
-		xfs_stack_trace();
 }
 
 /*
@@ -459,9 +456,6 @@ xfs_buf_verifier_error(
 				sz);
 		xfs_hex_dump(buf, sz);
 	}
-
-	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
-		xfs_stack_trace();
 }
 
 /*
@@ -509,7 +503,4 @@ xfs_inode_verifier_error(
 				sz);
 		xfs_hex_dump(buf, sz);
 	}
-
-	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
-		xfs_stack_trace();
 }
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 13851c0d640b..e08b1ce109d9 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -546,8 +546,6 @@ xfs_do_force_shutdown(
 			why, flags, __return_address, fname, lnnum);
 	xfs_alert(mp,
 		"Please unmount the filesystem and rectify the problem(s)");
-	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
-		xfs_stack_trace();
 }
 
 /*
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fc61cc024023..e4e4da33281d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3808,8 +3808,6 @@ xlog_force_shutdown(
 				shutdown_flags);
 		xfs_alert(log->l_mp,
 "Please unmount the filesystem and rectify the problem(s).");
-		if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
-			xfs_stack_trace();
 	}
 
 	/*
-- 
2.31.1

