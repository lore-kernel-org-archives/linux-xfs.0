Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D451C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA7D020760
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QZbqSFUg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389655AbgF3PoG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:44:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45844 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389699AbgF3PoG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:44:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFgMV4007125
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:44:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2cC/4AcHUoZOzejQBdpdBbfdjWbtjLI8J/RD/RM8daM=;
 b=QZbqSFUgXxXpkKbAfBJbj8byvz4vNVUQRFw5X6+q9pa2YDlRngrLIiQWQs2YYFAKOvmT
 Kk2iRBCMnRrxXhfQKtAKBfpdmvXEsVYNypZNpJIhWIS6SZUU0lEibf33uihxCPKGNvJY
 /bJBMzwVK475m7w7t6L29BeFFwFuqeyNxL0J7yQU9PYgNrDMneXt16V/L17UjqdTcq+7
 bKIyasyiDoKWb91x7WWXEBsd45d/VajVNrRLPfGDFCnDluxgFKKM36SV4lGQrC8yQKQH
 KGchZhkn+16yJ8XGNc3ngROY6qhEJ6VkrhxxWgf+ccBOqRGD8aU95EkzaarYMq7twkoK Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31wxrn5a4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:44:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFi2v3048120
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:44:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31xg1wy7sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:44:02 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UFhkZp017718
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:43:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:43:46 +0000
Subject: [PATCH 18/18] xfs: add more dquot tracepoints
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:43:45 -0700
Message-ID: <159353182503.2864738.13936001087522113609.stgit@magnolia>
In-Reply-To: <159353170983.2864738.16885438169173786208.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add all the xfs_dquot fields to the tracepoint for that type; add a new
tracepoint type for the qtrx structure (dquot transaction deltas); and
use our new tracepoints.  This makes it easier for the author to trace
changes to dquot counters for debugging.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trace.h       |  140 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans_dquot.c |   21 +++++++
 2 files changed, 159 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 851f97dfe9e3..35b9dfd3984f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -36,6 +36,7 @@ struct xfs_owner_info;
 struct xfs_trans_res;
 struct xfs_inobt_rec_incore;
 union xfs_btree_ptr;
+struct xfs_dqtrx;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -867,37 +868,59 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 		__field(unsigned, flags)
 		__field(unsigned, nrefs)
 		__field(unsigned long long, res_bcount)
+		__field(unsigned long long, res_rtbcount)
+		__field(unsigned long long, res_icount)
+
 		__field(unsigned long long, bcount)
+		__field(unsigned long long, rtbcount)
 		__field(unsigned long long, icount)
+
 		__field(unsigned long long, blk_hardlimit)
 		__field(unsigned long long, blk_softlimit)
+		__field(unsigned long long, rtb_hardlimit)
+		__field(unsigned long long, rtb_softlimit)
 		__field(unsigned long long, ino_hardlimit)
 		__field(unsigned long long, ino_softlimit)
-	), \
+	),
 	TP_fast_assign(
 		__entry->dev = dqp->q_mount->m_super->s_dev;
 		__entry->id = dqp->q_id;
 		__entry->flags = dqp->dq_flags;
 		__entry->nrefs = dqp->q_nrefs;
+
 		__entry->res_bcount = dqp->q_blk.reserved;
+		__entry->res_rtbcount = dqp->q_rtb.reserved;
+		__entry->res_icount = dqp->q_ino.reserved;
+
 		__entry->bcount = dqp->q_blk.count;
+		__entry->rtbcount = dqp->q_rtb.count;
 		__entry->icount = dqp->q_ino.count;
+
 		__entry->blk_hardlimit = dqp->q_blk.hardlimit;
 		__entry->blk_softlimit = dqp->q_blk.softlimit;
+		__entry->rtb_hardlimit = dqp->q_rtb.hardlimit;
+		__entry->rtb_softlimit = dqp->q_rtb.softlimit;
 		__entry->ino_hardlimit = dqp->q_ino.hardlimit;
 		__entry->ino_softlimit = dqp->q_ino.softlimit;
 	),
-	TP_printk("dev %d:%d id 0x%x flags %s nrefs %u res_bc 0x%llx "
+	TP_printk("dev %d:%d id 0x%x flags %s nrefs %u "
+		  "res_bc 0x%llx res_rtbc 0x%llx res_ic 0x%llx "
 		  "bcnt 0x%llx bhardlimit 0x%llx bsoftlimit 0x%llx "
+		  "rtbcnt 0x%llx rtbhardlimit 0x%llx rtbsoftlimit 0x%llx "
 		  "icnt 0x%llx ihardlimit 0x%llx isoftlimit 0x%llx]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->id,
 		  __print_flags(__entry->flags, "|", XFS_DQ_FLAGS),
 		  __entry->nrefs,
 		  __entry->res_bcount,
+		  __entry->res_rtbcount,
+		  __entry->res_icount,
 		  __entry->bcount,
 		  __entry->blk_hardlimit,
 		  __entry->blk_softlimit,
+		  __entry->rtbcount,
+		  __entry->rtb_hardlimit,
+		  __entry->rtb_softlimit,
 		  __entry->icount,
 		  __entry->ino_hardlimit,
 		  __entry->ino_softlimit)
@@ -928,6 +951,119 @@ DEFINE_DQUOT_EVENT(xfs_dqrele);
 DEFINE_DQUOT_EVENT(xfs_dqflush);
 DEFINE_DQUOT_EVENT(xfs_dqflush_force);
 DEFINE_DQUOT_EVENT(xfs_dqflush_done);
+DEFINE_DQUOT_EVENT(xfs_trans_apply_dquot_deltas_before);
+DEFINE_DQUOT_EVENT(xfs_trans_apply_dquot_deltas_after);
+
+#define XFS_QMOPT_FLAGS \
+	{ XFS_QMOPT_UQUOTA,		"UQUOTA" }, \
+	{ XFS_QMOPT_PQUOTA,		"PQUOTA" }, \
+	{ XFS_QMOPT_FORCE_RES,		"FORCE_RES" }, \
+	{ XFS_QMOPT_SBVERSION,		"SBVERSION" }, \
+	{ XFS_QMOPT_GQUOTA,		"GQUOTA" }, \
+	{ XFS_QMOPT_INHERIT,		"INHERIT" }, \
+	{ XFS_QMOPT_RES_REGBLKS,	"RES_REGBLKS" }, \
+	{ XFS_QMOPT_RES_RTBLKS,		"RES_RTBLKS" }, \
+	{ XFS_QMOPT_BCOUNT,		"BCOUNT" }, \
+	{ XFS_QMOPT_ICOUNT,		"ICOUNT" }, \
+	{ XFS_QMOPT_RTBCOUNT,		"RTBCOUNT" }, \
+	{ XFS_QMOPT_DELBCOUNT,		"DELBCOUNT" }, \
+	{ XFS_QMOPT_DELRTBCOUNT,	"DELRTBCOUNT" }, \
+	{ XFS_QMOPT_RES_INOS,		"RES_INOS" }
+
+TRACE_EVENT(xfs_trans_mod_dquot,
+	TP_PROTO(struct xfs_trans *tp, struct xfs_dquot *dqp,
+		 unsigned int field, int64_t delta),
+	TP_ARGS(tp, dqp, field, delta),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, dqflags)
+		__field(unsigned int, dqid)
+		__field(unsigned int, field)
+		__field(int64_t, delta)
+	),
+	TP_fast_assign(
+		__entry->dev = tp->t_mountp->m_super->s_dev;
+		__entry->dqflags = dqp->dq_flags;
+		__entry->dqid = dqp->q_id;
+		__entry->field = field;
+		__entry->delta = delta;
+	),
+	TP_printk("dev %d:%d dquot %s id 0x%x %s delta %lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __print_flags(__entry->dqflags, "|", XFS_DQ_FLAGS),
+		  __entry->dqid,
+		   __print_flags(__entry->field, "|", XFS_QMOPT_FLAGS),
+		  __entry->delta)
+);
+
+DECLARE_EVENT_CLASS(xfs_dqtrx_class,
+	TP_PROTO(struct xfs_dqtrx *qtrx),
+	TP_ARGS(qtrx),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, dqflags)
+		__field(u32, dqid)
+
+		__field(uint64_t, blk_res)
+		__field(int64_t,  bcount_delta)
+		__field(int64_t,  delbcnt_delta)
+
+		__field(uint64_t, rtblk_res)
+		__field(uint64_t, rtblk_res_used)
+		__field(int64_t,  rtbcount_delta)
+		__field(int64_t,  delrtb_delta)
+
+		__field(uint64_t, ino_res)
+		__field(uint64_t, ino_res_used)
+		__field(int64_t,  icount_delta)
+	),
+	TP_fast_assign(
+		__entry->dev = qtrx->qt_dquot->q_mount->m_super->s_dev;
+		__entry->dqflags = qtrx->qt_dquot->dq_flags;
+		__entry->dqid = qtrx->qt_dquot->q_id;
+
+		__entry->blk_res = qtrx->qt_blk_res;
+		__entry->bcount_delta = qtrx->qt_bcount_delta;
+		__entry->delbcnt_delta = qtrx->qt_delbcnt_delta;
+
+		__entry->rtblk_res = qtrx->qt_rtblk_res;
+		__entry->rtblk_res_used = qtrx->qt_rtblk_res_used;
+		__entry->rtbcount_delta = qtrx->qt_rtbcount_delta;
+		__entry->delrtb_delta = qtrx->qt_delrtb_delta;
+
+		__entry->ino_res = qtrx->qt_ino_res;
+		__entry->ino_res_used = qtrx->qt_ino_res_used;
+		__entry->icount_delta = qtrx->qt_icount_delta;
+	),
+	TP_printk("dev %d:%d dquot %s id 0x%x "
+		  "blk_res %llu bcount_delta %lld delbcnt_delta %lld "
+		  "rtblk_res %llu rtblk_res_used %llu rtbcount_delta %lld delrtb_delta %lld "
+		  "ino_res %llu ino_res_used %llu icount_delta %lld",
+		MAJOR(__entry->dev), MINOR(__entry->dev),
+		__print_flags(__entry->dqflags, "|", XFS_DQ_FLAGS),
+		__entry->dqid,
+
+		__entry->blk_res,
+		__entry->bcount_delta,
+		__entry->delbcnt_delta,
+
+		__entry->rtblk_res,
+		__entry->rtblk_res_used,
+		__entry->rtbcount_delta,
+		__entry->delrtb_delta,
+
+		__entry->ino_res,
+		__entry->ino_res_used,
+		__entry->icount_delta)
+)
+
+#define DEFINE_DQTRX_EVENT(name) \
+DEFINE_EVENT(xfs_dqtrx_class, name, \
+	TP_PROTO(struct xfs_dqtrx *qtrx), \
+	TP_ARGS(qtrx))
+DEFINE_DQTRX_EVENT(xfs_trans_apply_dquot_deltas);
+DEFINE_DQTRX_EVENT(xfs_trans_mod_dquot_before);
+DEFINE_DQTRX_EVENT(xfs_trans_mod_dquot_after);
 
 DECLARE_EVENT_CLASS(xfs_loggrant_class,
 	TP_PROTO(struct xlog *log, struct xlog_ticket *tic),
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 701923ea6c04..5689d9f1b748 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -15,6 +15,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
+#include "xfs_trace.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -203,6 +204,11 @@ xfs_trans_mod_dquot(
 	if (qtrx->qt_dquot == NULL)
 		qtrx->qt_dquot = dqp;
 
+	if (delta) {
+		trace_xfs_trans_mod_dquot_before(qtrx);
+		trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
+	}
+
 	switch (field) {
 
 		/*
@@ -266,6 +272,10 @@ xfs_trans_mod_dquot(
 	      default:
 		ASSERT(0);
 	}
+
+	if (delta)
+		trace_xfs_trans_mod_dquot_after(qtrx);
+
 	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
 }
 
@@ -391,6 +401,13 @@ xfs_trans_apply_dquot_deltas(
 				qtrx->qt_delbcnt_delta;
 			totalrtbdelta = qtrx->qt_rtbcount_delta +
 				qtrx->qt_delrtb_delta;
+
+			if (totalbdelta != 0 || totalrtbdelta != 0 ||
+			    qtrx->qt_icount_delta != 0) {
+				trace_xfs_trans_apply_dquot_deltas_before(dqp);
+				trace_xfs_trans_apply_dquot_deltas(qtrx);
+			}
+
 #ifdef DEBUG
 			if (totalbdelta < 0)
 				ASSERT(dqp->q_blk.count >= -totalbdelta);
@@ -410,6 +427,10 @@ xfs_trans_apply_dquot_deltas(
 			if (totalrtbdelta)
 				dqp->q_rtb.count += totalrtbdelta;
 
+			if (totalbdelta != 0 || totalrtbdelta != 0 ||
+			    qtrx->qt_icount_delta != 0)
+				trace_xfs_trans_apply_dquot_deltas_after(dqp);
+
 			/*
 			 * Get any default limits in use.
 			 * Start/reset the timer(s) if needed.

