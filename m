Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4ABEC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 06:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbiL3GXS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 01:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiL3GXS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 01:23:18 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942E11F7
        for <linux-xfs@vger.kernel.org>; Thu, 29 Dec 2022 22:23:15 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4Njw3w3Qjhz9v7HJ
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:15:40 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id BqC_BwDXBH_Ag65j7ezMAA--.12751S2;
        Fri, 30 Dec 2022 06:23:01 +0000 (GMT)
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org
Cc:     guoxuenan@huawei.com, guoxuenan@huaweicloud.com,
        houtao1@huawei.com, jack.qiu@huawei.com, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: [PATCH] xfs: set minleft correctly for randomly sparse inode allocations
Date:   Fri, 30 Dec 2022 14:22:29 +0800
Message-Id: <20221230062229.211186-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: BqC_BwDXBH_Ag65j7ezMAA--.12751S2
X-Coremail-Antispam: 1UD129KBjvdXoWruFW3Aw1rZryfur47Zr4ruFg_yoWfZrc_Ja
        9FkFZ7Z3s8Ww1xA3y2qrs0qFykKFWxXrnrGw45tF9xt34UuFn7Xws7XrsxXFW3CF93Ar15
        Xw1xC34S9ryqvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVxYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r1j6r4UM28EF7xvwVC2z280aVCY1x0267
        AKxVW8JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
        j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjsIEF7I21c0EjII2zVCS5cI20VAGYxC7MxAI
        w28IcxkI7VAKI48JMxAIw28IcVAKzI0EY4vE52x082I5MxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjxUFjg4DUUUU
Sender: guoxuenan@huaweicloud.com
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In DEBUG mode may do sparse inode allocations randomly, but forget to
set the remaining space correctly for the inode btree to split.
It's OK for most cases, only under DEBUG mode and AG space is running
out may bring something bad.

Fixes: 1cdadee11f8d ("xfs: randomly do sparse inode allocations in DEBUG mode")
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 94db50eb706a..29bc160312ec 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -763,6 +763,8 @@ xfs_ialloc_ag_alloc(
 		args.alignment = args.mp->m_sb.sb_spino_align;
 		args.prod = 1;
 
+		/* Allow space for the inode btree to split */
+		args.minleft = igeo->inobt_maxlevels;
 		args.minlen = igeo->ialloc_min_blks;
 		args.maxlen = args.minlen;
 
-- 
2.31.1

