Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227DCC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0821320759
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgEVDum (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 23:50:42 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39513 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728041AbgEVDul (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 23:50:41 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A3EA8820A97
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 13:50:38 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-0002VO-Hp
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-00CgHt-9Z
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/24] xfs: use direct calls for dquot IO completion
Date:   Fri, 22 May 2020 13:50:14 +1000
Message-Id: <20200522035029.3022405-10-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200522035029.3022405-1-david@fromorbit.com>
References: <20200522035029.3022405-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=3hWKYrsoyYVgIumzgdIA:9
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
 fs/xfs/xfs_dquot.c    | 27 +++++++++++++++++++++++----
 fs/xfs/xfs_dquot.h    |  1 +
 3 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index e376f778bf57c..57e5d37f6852e 100644
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
index 25592b701db40..1d7f34a9bc989 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1043,9 +1043,8 @@ xfs_qm_dqrele(
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
@@ -1086,6 +1085,27 @@ xfs_qm_dqflush_done(
 	xfs_dqfunlock(dqp);
 }
 
+void
+xfs_dquot_done(
+	struct xfs_buf		*bp)
+{
+	struct xfs_log_item	*lip;
+
+	while (!list_empty(&bp->b_li_list)) {
+		lip = list_first_entry(&bp->b_li_list, struct xfs_log_item,
+				       li_bio_list);
+
+		/*
+		 * Remove the item from the list, so we don't have any
+		 * confusion if the item is added to another buf.
+		 * Don't touch the log item after calling its
+		 * callback, because it could have freed itself.
+		 */
+		list_del_init(&lip->li_bio_list);
+		xfs_qm_dqflush_done(lip);
+	}
+}
+
 /*
  * Write a modified dquot to disk.
  * The dquot must be locked and the flush lock too taken by caller.
@@ -1175,8 +1195,7 @@ xfs_qm_dqflush(
 	 * AIL and release the flush lock once the dquot is synced to disk.
 	 */
 	bp->b_flags |= _XBF_DQUOTS;
-	xfs_buf_attach_iodone(bp, xfs_qm_dqflush_done,
-				  &dqp->q_logitem.qli_item);
+	xfs_buf_attach_iodone(bp, NULL, &dqp->q_logitem.qli_item);
 
 	/*
 	 * If the buffer is pinned then push on the log so we won't
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index fe3e46df604b4..f1924288986d3 100644
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

