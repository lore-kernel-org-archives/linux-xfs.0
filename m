Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E47C7618E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 11:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjDULjJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 07:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjDULjI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 07:39:08 -0400
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F599B750
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 04:38:22 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4Q2shk2B8dz9v7Zf
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 19:28:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id BqC_BwDH+IJudUJkSOICBg--.28716S3;
        Fri, 21 Apr 2023 11:37:26 +0000 (GMT)
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org
Cc:     sandeen@redhat.com, guoxuenan@huawei.com,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, fangwei1@huawei.com,
        jack.qiu@huawei.com, yi.zhang@huawei.com
Subject: [PATCH v2 1/2] xfs: fix xfs print level wrong parsing
Date:   Fri, 21 Apr 2023 19:37:15 +0800
Message-Id: <20230421113716.1890274-2-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230421113716.1890274-1-guoxuenan@huawei.com>
References: <20230421113716.1890274-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: BqC_BwDH+IJudUJkSOICBg--.28716S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJFykZrW3ur48uw1fXw1kZrb_yoW5KFy5pw
        n3Ja4YkrZ8A343u3Z3KF10va13Ww1UCr1UCrZ3Ca13Xa4jk3s2g3Wv9w1avFn3Kr42gayf
        GFyjvry3ua4fuFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUQ0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
        A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
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
        Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUzpnmDUUUU
Sender: guoxuenan@huaweicloud.com
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Recently, during my xfs bugfix work, notice a bug that makes
xfs_stack_trace never take effect. This has been around here at xfs
debug framework for a long time.

The root cause is misuse of `kstrtoint` which always return -EINVAL,
because KERN_<LEVEL> with KERN_SOH prefix will always parse failed.
Directly set loglevel in xfs print definition to make it work properly.

Fixes: 847f9f6875fb ("xfs: more info from kmem deadlocks and high-level error msgs")
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 fs/xfs/xfs_message.c |  5 ++---
 fs/xfs/xfs_message.h | 28 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 8f495cc23903..1cfa21d62514 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -30,12 +30,12 @@ __xfs_printk(
 void
 xfs_printk_level(
 	const char *kern_level,
+	const int log_level,
 	const struct xfs_mount *mp,
 	const char *fmt, ...)
 {
 	struct va_format	vaf;
 	va_list			args;
-	int			level;
 
 	va_start(args, fmt);
 	vaf.fmt = fmt;
@@ -45,8 +45,7 @@ xfs_printk_level(
 
 	va_end(args);
 
-	if (!kstrtoint(kern_level, 0, &level) &&
-	    level <= LOGLEVEL_ERR &&
+	if (log_level <= LOGLEVEL_ERR &&
 	    xfs_error_level >= XFS_ERRLEVEL_HIGH)
 		xfs_stack_trace();
 }
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index cc323775a12c..666a549eb989 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -6,32 +6,32 @@
 
 struct xfs_mount;
 
-extern __printf(3, 4)
-void xfs_printk_level(const char *kern_level, const struct xfs_mount *mp,
-			const char *fmt, ...);
+extern __printf(4, 5)
+void xfs_printk_level(const char *kern_level, const int log_level,
+		const struct xfs_mount *mp, const char *fmt, ...);
 
-#define xfs_printk_index_wrap(kern_level, mp, fmt, ...)		\
+#define xfs_printk_index_wrap(level, mp, fmt, ...)		\
 ({								\
-	printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt);	\
-	xfs_printk_level(kern_level, mp, fmt, ##__VA_ARGS__);	\
+	printk_index_subsys_emit("%sXFS%s: ", KERN_##level, fmt);	\
+	xfs_printk_level(KERN_##level, LOGLEVEL_##level, mp, fmt, ##__VA_ARGS__); \
 })
 #define xfs_emerg(mp, fmt, ...) \
-	xfs_printk_index_wrap(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(EMERG, mp, fmt, ##__VA_ARGS__)
 #define xfs_alert(mp, fmt, ...) \
-	xfs_printk_index_wrap(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(ALERT, mp, fmt, ##__VA_ARGS__)
 #define xfs_crit(mp, fmt, ...) \
-	xfs_printk_index_wrap(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(CRIT, mp, fmt, ##__VA_ARGS__)
 #define xfs_err(mp, fmt, ...) \
-	xfs_printk_index_wrap(KERN_ERR, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(ERR, mp, fmt, ##__VA_ARGS__)
 #define xfs_warn(mp, fmt, ...) \
-	xfs_printk_index_wrap(KERN_WARNING, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(WARNING, mp, fmt, ##__VA_ARGS__)
 #define xfs_notice(mp, fmt, ...) \
-	xfs_printk_index_wrap(KERN_NOTICE, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(NOTICE, mp, fmt, ##__VA_ARGS__)
 #define xfs_info(mp, fmt, ...) \
-	xfs_printk_index_wrap(KERN_INFO, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(INFO, mp, fmt, ##__VA_ARGS__)
 #ifdef DEBUG
 #define xfs_debug(mp, fmt, ...) \
-	xfs_printk_index_wrap(KERN_DEBUG, mp, fmt, ##__VA_ARGS__)
+	xfs_printk_index_wrap(DEBUG, mp, fmt, ##__VA_ARGS__)
 #else
 #define xfs_debug(mp, fmt, ...) do {} while (0)
 #endif
-- 
2.31.1

