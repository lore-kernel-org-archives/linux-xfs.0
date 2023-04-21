Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5707C7618E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 03:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbjDUDtE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 23:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbjDUDsk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 23:48:40 -0400
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FD27A93
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 20:48:19 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4Q2fwb23ccz9xFfT
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 11:22:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id BqC_BwC35oCgA0JkJLD+BQ--.17472S5;
        Fri, 21 Apr 2023 03:31:59 +0000 (GMT)
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org
Cc:     sandeen@redhat.com, guoxuenan@huawei.com,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, fangwei1@huawei.com,
        jack.qiu@huawei.com, yi.zhang@huawei.com
Subject: [PATCH 3/3] xfs: clean up some unnecessary xfs_stack_trace
Date:   Fri, 21 Apr 2023 11:31:42 +0800
Message-Id: <20230421033142.1656296-4-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230421033142.1656296-1-guoxuenan@huawei.com>
References: <20230421033142.1656296-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: BqC_BwC35oCgA0JkJLD+BQ--.17472S5
X-Coremail-Antispam: 1UD129KBjvJXoW7trWDXw4rAFWxKFWruw1rJFb_yoW8uFW8pF
        n7Aan2kr4qyryjvrn8Jry0qw18Jry0kw10krn5Aw1Sqw4UJ3W7Ary0yw10gwnrWa9Yv3ya
        gr9rur47Xw4rXa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUH0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
        A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r1j6r4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
        JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
        0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
        JVW8JwACjcxG0xvY0x0EwIxGrwACjsIEF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6x
        kF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxAIw28I
        cVAKzI0EY4vE52x082I5MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JV
        WxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1P8n5UUUUU==
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

