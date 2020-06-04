Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D06AC433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 07:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BAAB2067B
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 07:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgFDHqL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 03:46:11 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33589 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726537AbgFDHqL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 03:46:11 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5724382122B
        for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2020 17:46:08 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgkZj-00049k-KS
        for linux-xfs@vger.kernel.org; Thu, 04 Jun 2020 17:46:07 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jgkZj-0017Gw-BS
        for linux-xfs@vger.kernel.org; Thu, 04 Jun 2020 17:46:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/30] xfs: mark log recovery buffers for completion
Date:   Thu,  4 Jun 2020 17:45:42 +1000
Message-Id: <20200604074606.266213-7-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200604074606.266213-1-david@fromorbit.com>
References: <20200604074606.266213-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=J8PYUobFq9NN7i4cLVkA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Log recovery has it's own buffer write completion handler for
buffers that it directly recovers. Convert these to direct calls by
flagging these buffers as being log recovery buffers. The flag will
get cleared by the log recovery IO completion routine, so it will
never leak out of log recovery.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c                | 10 ++++++++++
 fs/xfs/xfs_buf.h                |  2 ++
 fs/xfs/xfs_buf_item_recover.c   |  5 ++---
 fs/xfs/xfs_dquot_item_recover.c |  2 +-
 fs/xfs/xfs_inode_item_recover.c |  2 +-
 fs/xfs/xfs_log_recover.c        |  5 ++---
 6 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 3bffde8640a52..0a69de674af9d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -14,6 +14,7 @@
 #include "xfs_mount.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_log_recover.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_errortag.h"
@@ -1207,6 +1208,15 @@ xfs_buf_ioend(
 	if (read)
 		goto out_finish;
 
+	/*
+	 * If this is a log recovery buffer, we aren't doing transactional IO
+	 * yet so we need to let it handle IO completions.
+	 */
+	if (bp->b_flags & _XBF_LOGRECOVERY) {
+		xlog_recover_iodone(bp);
+		return;
+	}
+
 	if (bp->b_flags & _XBF_INODES) {
 		xfs_buf_inode_iodone(bp);
 		return;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index c1d0843206dd6..30dabc5bae96d 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -33,6 +33,7 @@
 /* buffer type flags for write callbacks */
 #define _XBF_INODES	 (1 << 16)/* inode buffer */
 #define _XBF_DQUOTS	 (1 << 17)/* dquot buffer */
+#define _XBF_LOGRECOVERY	 (1 << 18)/* log recovery buffer */
 
 /* flags used only internally */
 #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
@@ -56,6 +57,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
 	{ _XBF_INODES,		"INODES" }, \
 	{ _XBF_DQUOTS,		"DQUOTS" }, \
+	{ _XBF_LOGRECOVERY,		"LOG_RECOVERY" }, \
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 04faa7310c4f0..74c851f60eeeb 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -419,8 +419,7 @@ xlog_recover_validate_buf_type(
 	if (bp->b_ops) {
 		struct xfs_buf_log_item	*bip;
 
-		ASSERT(!bp->b_iodone || bp->b_iodone == xlog_recover_iodone);
-		bp->b_iodone = xlog_recover_iodone;
+		bp->b_flags |= _XBF_LOGRECOVERY;
 		xfs_buf_item_init(bp, mp);
 		bip = bp->b_log_item;
 		bip->bli_item.li_lsn = current_lsn;
@@ -963,7 +962,7 @@ xlog_recover_buf_commit_pass2(
 		error = xfs_bwrite(bp);
 	} else {
 		ASSERT(bp->b_mount == mp);
-		bp->b_iodone = xlog_recover_iodone;
+		bp->b_flags |= _XBF_LOGRECOVERY;
 		xfs_buf_delwri_queue(bp, buffer_list);
 	}
 
diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 3400be4c88f08..f9ea9f55aa7cc 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -153,7 +153,7 @@ xlog_recover_dquot_commit_pass2(
 
 	ASSERT(dq_f->qlf_size == 2);
 	ASSERT(bp->b_mount == mp);
-	bp->b_iodone = xlog_recover_iodone;
+	bp->b_flags |= _XBF_LOGRECOVERY;
 	xfs_buf_delwri_queue(bp, buffer_list);
 
 out_release:
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index dc3e26ff16c90..5e0d291835b35 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -376,7 +376,7 @@ xlog_recover_inode_commit_pass2(
 	xfs_dinode_calc_crc(log->l_mp, dip);
 
 	ASSERT(bp->b_mount == mp);
-	bp->b_iodone = xlog_recover_iodone;
+	bp->b_flags |= _XBF_LOGRECOVERY;
 	xfs_buf_delwri_queue(bp, buffer_list);
 
 out_release:
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ec015df55b77a..52a65a74208ff 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -287,9 +287,8 @@ xlog_recover_iodone(
 	if (bp->b_log_item)
 		xfs_buf_item_relse(bp);
 	ASSERT(bp->b_log_item == NULL);
-
-	bp->b_iodone = NULL;
-	xfs_buf_ioend(bp);
+	bp->b_flags &= ~_XBF_LOGRECOVERY;
+	xfs_buf_ioend_finish(bp);
 }
 
 /*
-- 
2.26.2.761.g0e0b3e54be

