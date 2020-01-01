Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F64CC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 185D5206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V/VsCfKX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgAABRq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:17:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56450 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABRq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:17:46 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011Ev23092424
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=oJHX/f9bWKq4qN6gnJ+eXEaXCXidX50Zc3wJD9JohUk=;
 b=V/VsCfKXEOzm3FzGM97HztlrC9mrKqja02hg9FKtEBkHZkuxwksf0tNHREM5nXdi63+t
 m4CU1CDZRMY8ApTPLe0Omvnc0E08SDSxyAM4iI5D6F6aKQMC/dl7wr02R2AUIQXjxM+k
 vW223QdTWHau+cItfm+GQ1DirPnzhNbKGmxgTmzXJkQaFqaHWs4sWVGwHDFFbeAg0+Kq
 7L4bn/IDkIVM1AYtG6DYH3j+ycqRdh3Av+5tys/TCFCWejlInfqjs+0yGA0Fszf6Q7k2
 z4ffbeKgaHFTEWx41itbko9fKSbbcxPr7JVDexKku2GfLyey3JdW2Bha+Qy3SBY+QmOz 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:17:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011901n012585
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2x8guefpvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:17:44 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011Hisi030919
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:44 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:17:44 -0800
Subject: [PATCH 13/21] xfs: wire up rmap map and unmap to the realtime rmapbt
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:17:41 -0800
Message-ID: <157784146157.1368137.15012539914173796507.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Connect the map and unmap reverse-mapping operations to the realtime
rmapbt via the deferred operation callbacks.  This enables us to
perform rmap operations against the correct btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   62 ++++++++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_rmap.h |    2 +
 fs/xfs/xfs_log_recover.c |    6 ++--
 fs/xfs/xfs_rmap_item.c   |   13 ++++++++--
 fs/xfs/xfs_rmap_item.h   |    2 +
 5 files changed, 56 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 3e625ba057e6..2bb1d0cea443 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -22,6 +22,7 @@
 #include "xfs_error.h"
 #include "xfs_inode.h"
 #include "xfs_health.h"
+#include "xfs_rtrmap_btree.h"
 
 /* By convention, the rtrmapbt's "AG" number is NULLAGNUMBER. */
 static xfs_agnumber_t
@@ -2459,13 +2460,14 @@ xfs_rmap_finish_one_cleanup(
 	struct xfs_btree_cur	*rcur,
 	int			error)
 {
-	struct xfs_buf		*agbp;
+	struct xfs_buf		*agbp = NULL;
 
 	if (rcur == NULL)
 		return;
-	agbp = rcur->bc_private.a.agbp;
+	if (!(rcur->bc_flags & XFS_BTREE_LONG_PTRS))
+		agbp = rcur->bc_private.a.agbp;
 	xfs_btree_del_cursor(rcur, error);
-	if (error)
+	if (error && agbp)
 		xfs_trans_brelse(tp, agbp);
 }
 
@@ -2486,20 +2488,21 @@ xfs_rmap_finish_one(
 	xfs_fsblock_t			startblock,
 	xfs_filblks_t			blockcount,
 	xfs_exntst_t			state,
+	bool				realtime,
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_btree_cur		*rcur;
 	struct xfs_buf			*agbp = NULL;
+	int				lockmode;
 	int				error = 0;
 	xfs_agnumber_t			agno;
 	struct xfs_owner_info		oinfo;
 	xfs_fsblock_t			bno;
 	bool				unwritten;
 
-	agno = XFS_FSB_TO_AGNO(mp, startblock);
-	ASSERT(agno != NULLAGNUMBER);
-	bno = XFS_FSB_TO_AGBNO(mp, startblock);
+	agno = realtime ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp, startblock);
+	bno = realtime ? startblock : XFS_FSB_TO_AGBNO(mp, startblock);
 
 	trace_xfs_rmap_deferred(mp, agno, type, bno, owner, whichfork,
 			startoff, blockcount, state);
@@ -2518,31 +2521,44 @@ xfs_rmap_finish_one(
 		*pcur = NULL;
 	}
 	if (rcur == NULL) {
-		/*
-		 * Refresh the freelist before we start changing the
-		 * rmapbt, because a shape change could cause us to
-		 * allocate blocks.
-		 */
-		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
-		if (error)
-			return error;
-		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
-			return -EFSCORRUPTED;
-
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
-		if (!rcur) {
-			error = -ENOMEM;
-			goto out_cur;
+		if (realtime) {
+			lockmode = XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP;
+			xfs_ilock(mp->m_rrmapip, lockmode);
+			xfs_trans_ijoin(tp, mp->m_rrmapip, lockmode);
+			rcur = xfs_rtrmapbt_init_cursor(mp, tp, mp->m_rrmapip);
+			if (!rcur) {
+				error = -ENOMEM;
+				goto out_cur;
+			}
+			rcur->bc_private.b.flags = 0;
+		} else {
+			/*
+			 * Refresh the freelist before we start changing the
+			 * rmapbt, because a shape change could cause us to
+			 * allocate blocks.
+			 */
+			error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
+			if (error)
+				return error;
+			if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
+				return -EFSCORRUPTED;
+
+			rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+			if (!rcur) {
+				error = -ENOMEM;
+				goto out_cur;
+			}
 		}
 	}
 	*pcur = rcur;
 
 	xfs_rmap_ino_owner(&oinfo, owner, whichfork, startoff);
 	unwritten = state == XFS_EXT_UNWRITTEN;
-	bno = XFS_FSB_TO_AGBNO(rcur->bc_mp, startblock);
 
 	switch (type) {
 	case XFS_RMAP_ALLOC:
+		ASSERT(!realtime);
+		/* fall through */
 	case XFS_RMAP_MAP:
 		error = xfs_rmap_map(rcur, bno, blockcount, unwritten, &oinfo);
 		break;
@@ -2551,6 +2567,8 @@ xfs_rmap_finish_one(
 				&oinfo);
 		break;
 	case XFS_RMAP_FREE:
+		ASSERT(!realtime);
+		/* fall through */
 	case XFS_RMAP_UNMAP:
 		error = xfs_rmap_unmap(rcur, bno, blockcount, unwritten,
 				&oinfo);
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 2d4badc4a531..958f9e27dba7 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -180,7 +180,7 @@ void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
 		uint64_t owner, int whichfork, xfs_fileoff_t startoff,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state, struct xfs_btree_cur **pcur);
+		xfs_exntst_t state, bool realtime, struct xfs_btree_cur **pcur);
 
 int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_fsblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e966a7e569be..bca5b1bfae91 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4617,7 +4617,7 @@ xlog_recover_cancel_efi(
 /* Recover the RUI if necessary. */
 STATIC int
 xlog_recover_process_rui(
-	struct xfs_mount		*mp,
+	struct xfs_trans		*parent_tp,
 	struct xfs_ail			*ailp,
 	struct xfs_log_item		*lip)
 {
@@ -4632,7 +4632,7 @@ xlog_recover_process_rui(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_rui_recover(mp, ruip);
+	error = xfs_rui_recover(parent_tp, ruip);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4861,7 +4861,7 @@ xlog_recover_process_intents(
 			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
 			break;
 		case XFS_LI_RUI:
-			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
+			error = xlog_recover_process_rui(parent_tp, ailp, lip);
 			break;
 		case XFS_LI_CUI:
 			error = xlog_recover_process_cui(parent_tp, ailp, lip);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index c7a55011972f..4080b86b8615 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -324,7 +324,7 @@ xfs_trans_log_finish_rmap_update(
 	int				error;
 
 	error = xfs_rmap_finish_one(tp, type, owner, whichfork, startoff,
-			startblock, blockcount, state, pcur);
+			startblock, blockcount, state, rt, pcur);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -494,7 +494,7 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
  */
 int
 xfs_rui_recover(
-	struct xfs_mount		*mp,
+	struct xfs_trans		*parent_tp,
 	struct xfs_rui_log_item		*ruip)
 {
 	int				i;
@@ -508,6 +508,7 @@ xfs_rui_recover(
 	xfs_exntst_t			state;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
+	struct xfs_mount		*mp = parent_tp->t_mountp;
 	bool				rt;
 
 	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
@@ -555,6 +556,12 @@ xfs_rui_recover(
 			mp->m_rmap_maxlevels, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
+	/*
+	 * Recovery stashes all deferred ops during intent processing and
+	 * finishes them on completion. Transfer current dfops state to this
+	 * transaction and transfer the result back before we return.
+	 */
+	xfs_defer_move(tp, parent_tp);
 	rudp = xfs_trans_get_rud(tp, ruip);
 
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
@@ -605,10 +612,12 @@ xfs_rui_recover(
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
+	xfs_defer_move(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	return error;
 
 abort_error:
+	xfs_defer_move(parent_tp, tp);
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
 	xfs_trans_cancel(tp);
 	return error;
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 8708e4a5aa5c..2ed916a860fd 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -82,6 +82,6 @@ int xfs_rui_copy_format(struct xfs_log_iovec *buf,
 		struct xfs_rui_log_format *dst_rui_fmt);
 void xfs_rui_item_free(struct xfs_rui_log_item *);
 void xfs_rui_release(struct xfs_rui_log_item *);
-int xfs_rui_recover(struct xfs_mount *mp, struct xfs_rui_log_item *ruip);
+int xfs_rui_recover(struct xfs_trans *parent_tp, struct xfs_rui_log_item *ruip);
 
 #endif	/* __XFS_RMAP_ITEM_H__ */

