Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4687AC77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Apr 2023 03:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbjDTDhB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Apr 2023 23:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDTDhA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2023 23:37:00 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C053AA4
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 20:36:58 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Q23HT4FJ0z4f3sn2
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 11:36:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgD3rLBDs0BkApsKHw--.18030S4;
        Thu, 20 Apr 2023 11:36:55 +0800 (CST)
From:   yangerkun <yangerkun@huaweicloud.com>
To:     djwong@kernel.org, david@fromorbit.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix xfs_buf use-after-free in xfs_buf_item_unpin
Date:   Thu, 20 Apr 2023 11:35:50 +0800
Message-Id: <20230420033550.339934-1-yangerkun@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3rLBDs0BkApsKHw--.18030S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF1fury5CrWftF1DWryxGrg_yoW8KrW5pr
        s3Jr17Cr15tr4Fvr4kA34UX34rt34kAF18CF47Gr4fuw13Ary7K3WYyF1xJFyDtrWIvr45
        Zr1UCr1UW34DAFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
        c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
        CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
        MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJV
        Cq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBI
        daVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

commit 84d8949e7707 ("xfs: hold buffer across unpin and potential
shutdown processing") describle a use-after-free bug show as follow.
Call xfs_buf_hold before dec b_pin_count can forbid the problem.

   +-----------------------------+--------------------------------+
     xlog_ioend_work             | xfsaild
     ...                         |  xfs_buf_delwri_submit_buffers
      xfs_buf_item_unpin         |
       dec &bip->bli_refcount    |
       dec &bp->b_pin_count      |
                                 |  // check unpin and go on
                                 |  __xfs_buf_submit
                                 |  xfs_buf_ioend_fail // shutdown
                                 |  xfs_buf_ioend
                                 |  xfs_buf_relse
                                 |  xfs_buf_free(bp)
       xfs_buf_lock(bp) // UAF   |

However with the patch, we still get a UAF with shutdown:

   +-----------------------------+--------------------------------+
     xlog_ioend_work             |  xlog_cil_push_work // now shutdown
     ...                         |   xlog_cil_committed
      xfs_buf_item_unpin         |    ...
      // bli_refcount = 2        |
      dec bli_refcount // 1      |    xfs_buf_item_unpin
                                 |    dec bli_refcount // 0,will free
                                 |    xfs_buf_ioend_fail // free bp
      dec b_pin_count // UAF     |

xlog_cil_push_work will call xlog_cil_committed once we meet some error
like shutdown, and then call xfs_buf_item_unpin with 'remove' equals 1.
xlog_ioend_work can happened same time which trigger xfs_buf_item_unpin
too, and then bli_refcount will down to zero which trigger
xfs_buf_ioend_fail that free the xfs_buf, so the UAF can trigger.

Fix it by call xfs_buf_hold before dec bli_refcount, and release the
hold once we actually do not need it.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/xfs/xfs_buf_item.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index df7322ed73fa..3880eb2495b8 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -502,12 +502,15 @@ xfs_buf_item_unpin(
 	 * completion) at any point before we return. This can be removed once
 	 * the AIL properly holds a reference on the bli.
 	 */
+	xfs_buf_hold(bp);
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-	if (freed && !stale && remove)
-		xfs_buf_hold(bp);
+
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
 
+	if (!freed || stale || !remove)
+		xfs_buf_rele(bp);
+
 	 /* nothing to do but drop the pin count if the bli is active */
 	if (!freed)
 		return;
-- 
2.31.1

