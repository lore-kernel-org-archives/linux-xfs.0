Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69FA4C433E1
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53F3B20734
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgFAVm4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 17:42:56 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:48001 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728483AbgFAVmz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:42:55 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 3D38B10707F
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 07:42:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-0000Wa-7n
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCp-00HU5R-VQ
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/30] xfs: use direct calls for dquot IO completion
Date:   Tue,  2 Jun 2020 07:42:31 +1000
Message-Id: <20200601214251.4167140-11-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200601214251.4167140-1-david@fromorbit.com>
References: <20200601214251.4167140-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=RC6LCOMzik_5eL-T5OoA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Similar to inodes, we can call the dquot IO completion functions
directly from the buffer completion code, removing another user of
log item callbacks for IO completion processing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 18 +++++++++++++++++-
 fs/xfs/xfs_dquot.c    | 18 ++++++++++++++----
 fs/xfs/xfs_dquot.h    |  1 +
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a4e416af5c614..f46e5ec28111c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -15,6 +15,9 @@
 #include "xfs_buf_item.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
+#include "xfs_quota.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 #include "xfs_trans_priv.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
@@ -1209,7 +1212,20 @@ void
 xfs_buf_dquot_iodone(
 	struct xfs_buf		*bp)
 {
-	xfs_buf_run_callbacks(bp);
+	struct xfs_buf_log_item *blip = bp->b_log_item;
+	struct xfs_log_item	*lip;
+
+	if (xfs_buf_had_callback_errors(bp))
+		return;
+
+	/* a newly allocated dquot buffer might have a log item attached */
+	if (blip) {
+		lip = &blip->bli_item;
+		lip->li_cb(bp, lip);
+		bp->b_log_item = NULL;
+	}
+
+	xfs_dquot_done(bp);
 	xfs_buf_ioend_finish(bp);
 }
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 2e2146fa0914c..403bc4e9f21ff 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1048,9 +1048,8 @@ xfs_qm_dqrele(
  * from the AIL if it has not been re-logged, and unlocking the dquot's
  * flush lock. This behavior is very similar to that of inodes..
  */
-STATIC void
+static void
 xfs_qm_dqflush_done(
-	struct xfs_buf		*bp,
 	struct xfs_log_item	*lip)
 {
 	struct xfs_dq_logitem	*qip = (struct xfs_dq_logitem *)lip;
@@ -1091,6 +1090,18 @@ xfs_qm_dqflush_done(
 	xfs_dqfunlock(dqp);
 }
 
+void
+xfs_dquot_done(
+	struct xfs_buf		*bp)
+{
+	struct xfs_log_item	*lip, *n;
+
+	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
+		list_del_init(&lip->li_bio_list);
+		xfs_qm_dqflush_done(lip);
+	}
+}
+
 /*
  * Write a modified dquot to disk.
  * The dquot must be locked and the flush lock too taken by caller.
@@ -1180,8 +1191,7 @@ xfs_qm_dqflush(
 	 * AIL and release the flush lock once the dquot is synced to disk.
 	 */
 	bp->b_flags |= _XBF_DQUOTS;
-	xfs_buf_attach_iodone(bp, xfs_qm_dqflush_done,
-				  &dqp->q_logitem.qli_item);
+	xfs_buf_attach_iodone(bp, NULL, &dqp->q_logitem.qli_item);
 
 	/*
 	 * If the buffer is pinned then push on the log so we won't
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 71e36c85e20b6..fe9cc3e08ed6d 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -174,6 +174,7 @@ void		xfs_qm_dqput(struct xfs_dquot *dqp);
 void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
 
 void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
+void		xfs_dquot_done(struct xfs_buf *);
 
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 {
-- 
2.26.2.761.g0e0b3e54be

