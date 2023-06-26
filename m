Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E7AEB64D7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jun 2023 13:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjFZNQu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jun 2023 09:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjFZNQn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2023 09:16:43 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2C6E7B
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2023 06:16:40 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QqSzQ6dQvz4f3s5w
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2023 21:16:34 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
        by APP4 (Coremail) with SMTP id gCh0CgD3X7Orj5lke5JTMg--.31738S4;
        Mon, 26 Jun 2023 21:16:36 +0800 (CST)
From:   yangerkun <yangerkun@huaweicloud.com>
To:     djwong@kernel.org, dchinner@redhat.com, sandeen@redhat.com
Cc:     linux-xfs@vger.kernel.org, yangerkun@huawei.com,
        yangerkun@huaweicloud.com, yukuai3@huawei.com
Subject: [PATCH] xfs: fix deadlock when set label online
Date:   Mon, 26 Jun 2023 21:15:42 +0800
Message-Id: <20230626131542.3711391-1-yangerkun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3X7Orj5lke5JTMg--.31738S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGw1DKFWxGr43ArykGF1rJFb_yoWrJFW5pr
        n3Cw43Grs5Jr4a9F97JF4jqa1rtw4rGw40kr97Xwnavwn8Ar1avF1FyryFgryDZrW3Xw43
        ur1jy398Xwn3uaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
        vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
        x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
        xKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
        67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU1a9aPUUUUU==
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

Combine use of xfs_trans_hold and xfs_trans_set_sync in xfs_sync_sb_buf
can trigger a deadlock once shutdown happened concurrently. xlog_ioend_work
will first unpin the sb(which stuck with xfs_buf_lock), then wakeup
xfs_sync_sb_buf. However, xfs_sync_sb_buf never get the chance to unlock
sb until been wakeup by xlog_ioend_work.

xfs_sync_sb_buf
  xfs_trans_getsb // lock sb buf
  xfs_trans_bhold // sb buf keep lock until success commit
  xfs_trans_commit
  ...
    xfs_log_force_seq
      xlog_force_lsn
        xlog_wait_on_iclog
          xlog_wait(&iclog->ic_force_wait... // shutdown happened
  xfs_buf_relse // unlock sb buf

xlog_ioend_work
  xlog_force_shutdown
    xlog_state_shutdown_callbacks
      xlog_cil_process_committed
        xlog_cil_committed
        ...
        xfs_buf_item_unpin
          xfs_buf_lock // deadlock
      wake_up_all(&iclog->ic_force_wait)

xfs_ioc_setlabel use xfs_sync_sb_buf to make sure userspace will see the
change for sb immediately. We can simply call xfs_ail_push_all_sync to
do this and sametime fix the deadlock.

Fixes: f7664b31975b ("xfs: implement online get/set fs label")
Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/xfs/libxfs/xfs_sb.c | 32 --------------------------------
 fs/xfs/libxfs/xfs_sb.h |  1 -
 fs/xfs/xfs_ioctl.c     |  5 ++++-
 3 files changed, 4 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ba0f17bc1dc0..8b89e65c5e1e 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1089,38 +1089,6 @@ xfs_update_secondary_sbs(
 	return saved_error ? saved_error : error;
 }
 
-/*
- * Same behavior as xfs_sync_sb, except that it is always synchronous and it
- * also writes the superblock buffer to disk sector 0 immediately.
- */
-int
-xfs_sync_sb_buf(
-	struct xfs_mount	*mp)
-{
-	struct xfs_trans	*tp;
-	struct xfs_buf		*bp;
-	int			error;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
-	if (error)
-		return error;
-
-	bp = xfs_trans_getsb(tp);
-	xfs_log_sb(tp);
-	xfs_trans_bhold(tp, bp);
-	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp);
-	if (error)
-		goto out;
-	/*
-	 * write out the sb buffer to get the changes to disk
-	 */
-	error = xfs_bwrite(bp);
-out:
-	xfs_buf_relse(bp);
-	return error;
-}
-
 void
 xfs_fs_geometry(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index a5e14740ec9a..fb420312c476 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -15,7 +15,6 @@ struct xfs_perag;
 
 extern void	xfs_log_sb(struct xfs_trans *tp);
 extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
-extern int	xfs_sync_sb_buf(struct xfs_mount *mp);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 55bb01173cde..9bacc71d2c9e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -27,6 +27,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_acl.h"
 #include "xfs_btree.h"
 #include <linux/fsmap.h>
@@ -1798,9 +1799,11 @@ xfs_ioc_setlabel(
 	 * buffered reads from userspace (i.e. from blkid) are invalidated,
 	 * and userspace will see the newly-written label.
 	 */
-	error = xfs_sync_sb_buf(mp);
+	error = xfs_sync_sb(mp, true);
 	if (error)
 		goto out;
+
+	xfs_ail_push_all_sync(mp->m_ail);
 	/*
 	 * growfs also updates backup supers so lock against that.
 	 */
-- 
2.39.2

