Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74C5C77B73
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 03:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjDUDcM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 23:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjDUDcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 23:32:11 -0400
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E971BD8
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 20:32:09 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.229])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4Q2fvN2S96z9xFrg
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 11:21:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id BqC_BwC35oCgA0JkJLD+BQ--.17472S4;
        Fri, 21 Apr 2023 03:31:56 +0000 (GMT)
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org
Cc:     sandeen@redhat.com, guoxuenan@huawei.com,
        guoxuenan@huaweicloud.com, houtao1@huawei.com, fangwei1@huawei.com,
        jack.qiu@huawei.com, yi.zhang@huawei.com
Subject: [PATCH 2/3] xfs: fix xfs print level wrong parsing
Date:   Fri, 21 Apr 2023 11:31:41 +0800
Message-Id: <20230421033142.1656296-3-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230421033142.1656296-1-guoxuenan@huawei.com>
References: <20230421033142.1656296-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: BqC_BwC35oCgA0JkJLD+BQ--.17472S4
X-Coremail-Antispam: 1UD129KBjvdXoWrur1fJw1xXr4ruFW5WrW8Crg_yoWDCrb_Ja
        y2qrWxuw4SqF17uw1kA34qvrWjqw4xtrn3J3y3JFyYyFyDAFW3ZFs7JwsYva1Duw1YgFy3
        Xry7Jry8KrySvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbdxYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r15M2
        8IrcIa0xkI8VCY1x0267AKxVW8JVW5JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
        021l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
        4j6F4UM28EF7xvwVC2z280aVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j
        6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7V
        C0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j
        6r4UM4x0Y48IcxkI7VAKI48JM4x0aVACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7
        CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l42xK82IY
        64kExVAvwVAq07x20xyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
        WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAK
        I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F
        4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
        6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUcfHUDUUUU
Sender: guoxuenan@huaweicloud.com
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Recently, during my xfs bugfix work, notice a bug that makes
xfs_stack_trace never take effect. This has been around here at xfs
debug framework for a long time.

The root cause is misuse of `kstrtoint` which always return -EINVAL
because KERN_<LEVEL> with KERN_SOH prefix unable to parse correctly by
it. By skipping the prefix KERN_SOH we can get correct printk level.

Fixes: 847f9f6875fb ("xfs: more info from kmem deadlocks and high-level error msgs")
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 fs/xfs/xfs_message.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 8f495cc23903..bda4c0a0ca42 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -45,7 +45,7 @@ xfs_printk_level(
 
 	va_end(args);
 
-	if (!kstrtoint(kern_level, 0, &level) &&
+	if (!kstrtoint(kern_level + strlen(KERN_SOH), 0, &level) &&
 	    level <= LOGLEVEL_ERR &&
 	    xfs_error_level >= XFS_ERRLEVEL_HIGH)
 		xfs_stack_trace();
-- 
2.31.1

