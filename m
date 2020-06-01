Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C350C433E5
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 858F4207BB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgFAVm6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 17:42:58 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:47971 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728541AbgFAVm4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:42:56 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id C79C910531D
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 07:42:52 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-0000WI-0r
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCp-00HU52-Nm
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/30] xfs: mark dquot buffers in cache
Date:   Tue,  2 Jun 2020 07:42:26 +1000
Message-Id: <20200601214251.4167140-6-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200601214251.4167140-1-david@fromorbit.com>
References: <20200601214251.4167140-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=nDrCKdGSDarCGLS7qDwA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

dquot buffers always have write IO callbacks, so by marking them
directly we can avoid needing to attach ->b_iodone functions to
them. This avoids an indirect call, and makes future modifications
much simpler.

This is largely a rearrangement of the code at this point - no IO
completion functionality changes at this point, just how the
code is run is modified.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c       |  5 +++++
 fs/xfs/xfs_buf.h       |  2 ++
 fs/xfs/xfs_buf_item.c  | 10 ++++++++++
 fs/xfs/xfs_buf_item.h  |  1 +
 fs/xfs/xfs_dquot.c     |  1 +
 fs/xfs/xfs_trans_buf.c |  1 +
 6 files changed, 20 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index fcf650575be61..3bffde8640a52 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1212,6 +1212,11 @@ xfs_buf_ioend(
 		return;
 	}
 
+	if (bp->b_flags & _XBF_DQUOTS) {
+		xfs_buf_dquot_iodone(bp);
+		return;
+	}
+
 	if (bp->b_iodone) {
 		(*(bp->b_iodone))(bp);
 		return;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 2400cb90a04c6..c1d0843206dd6 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -32,6 +32,7 @@
 
 /* buffer type flags for write callbacks */
 #define _XBF_INODES	 (1 << 16)/* inode buffer */
+#define _XBF_DQUOTS	 (1 << 17)/* dquot buffer */
 
 /* flags used only internally */
 #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
@@ -54,6 +55,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
 	{ _XBF_INODES,		"INODES" }, \
+	{ _XBF_DQUOTS,		"DQUOTS" }, \
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 8659cf4282a64..a42cdf9ccc47d 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1210,6 +1210,16 @@ xfs_buf_inode_iodone(
 	xfs_buf_ioend_finish(bp);
 }
 
+/*
+ * Dquot buffer iodone callback function.
+ */
+void
+xfs_buf_dquot_iodone(
+	struct xfs_buf		*bp)
+{
+	xfs_buf_run_callbacks(bp);
+	xfs_buf_ioend_finish(bp);
+}
 
 /*
  * This is the iodone() function for buffers which have been
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index a342933ad9b8d..27d13d29b5bbb 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -60,6 +60,7 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
 void	xfs_buf_iodone_callbacks(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
+void	xfs_buf_dquot_iodone(struct xfs_buf *);
 bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
 
 extern kmem_zone_t	*xfs_buf_item_zone;
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index d5b7f03e93c8d..2e2146fa0914c 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1179,6 +1179,7 @@ xfs_qm_dqflush(
 	 * Attach an iodone routine so that we can remove this dquot from the
 	 * AIL and release the flush lock once the dquot is synced to disk.
 	 */
+	bp->b_flags |= _XBF_DQUOTS;
 	xfs_buf_attach_iodone(bp, xfs_qm_dqflush_done,
 				  &dqp->q_logitem.qli_item);
 
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 552d0869aa0fe..93d62cb864c15 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -788,5 +788,6 @@ xfs_trans_dquot_buf(
 		break;
 	}
 
+	bp->b_flags |= _XBF_DQUOTS;
 	xfs_trans_buf_set_type(tp, bp, type);
 }
-- 
2.26.2.761.g0e0b3e54be

