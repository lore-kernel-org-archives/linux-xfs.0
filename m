Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8AAC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B25F7217BA
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:36:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BQyEydi+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGNBgU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:36:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40672 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgGNBgU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:36:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1WATT096166;
        Tue, 14 Jul 2020 01:36:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kGhhzDPNEb2gop0dMl2OqdmE4ds27iyzOX+4BUjHsfM=;
 b=BQyEydi+FUPwpuL9VB3H1+Tvs+Q0UbGvAXg5nbelXk02y3J+cz2gRJ3WX9z1cVhG1Swe
 VTkWlXoWLw+HfZLn1XYO14Bq/zs8U/EScsOgUJLRU3FMnKmeFR8kCbhNUuJSPlHtKbu+
 MJ9CVNee+uI3uiDuqUBITJBZAGxPM4Jf1tz4F2GRh2VHT6dRIhzlJ0dXwsDQdV8kWCPB
 GEJOFQ43hB2Vm5K7By8iEywZtdNm+ZeTp4oaKQG56UyjLO7HqDwEumPXwkA4Mr6FvFdh
 d2VOpCIQ6vBfN0tP1DAYzW/OmuE6wmO7/BKNMRlaiuxZJN8BVXSlxfw4C2RL0rag0AJw eA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274ur2f84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 01:36:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1XY0T175705;
        Tue, 14 Jul 2020 01:34:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 327q0n6mqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 01:34:15 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06E1YFVJ014175;
        Tue, 14 Jul 2020 01:34:15 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:34:15 -0700
Subject: [PATCH 26/26] xfs: add more dquot tracepoints
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 13 Jul 2020 18:34:14 -0700
Message-ID: <159469045467.2914673.3575157462136790000.stgit@magnolia>
In-Reply-To: <159469028734.2914673.17856142063205791176.stgit@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140009
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
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/xfs_trace.h       |  145 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans_dquot.c |   21 +++++++
 2 files changed, 164 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b6541f7d1b7d..31438da52724 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -36,6 +36,7 @@ struct xfs_owner_info;
 struct xfs_trans_res;
 struct xfs_inobt_rec_incore;
 union xfs_btree_ptr;
+struct xfs_dqtrx;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -868,29 +869,46 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
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
 		__entry->type = dqp->q_type;
 		__entry->flags = dqp->q_flags;
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
-	TP_printk("dev %d:%d id 0x%x type %s flags %s nrefs %u res_bc 0x%llx "
+	TP_printk("dev %d:%d id 0x%x type %s flags %s nrefs %u "
+		  "res_bc 0x%llx res_rtbc 0x%llx res_ic 0x%llx "
 		  "bcnt 0x%llx bhardlimit 0x%llx bsoftlimit 0x%llx "
+		  "rtbcnt 0x%llx rtbhardlimit 0x%llx rtbsoftlimit 0x%llx "
 		  "icnt 0x%llx ihardlimit 0x%llx isoftlimit 0x%llx]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->id,
@@ -898,9 +916,14 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 		  __print_flags(__entry->flags, "|", XFS_DQFLAG_STRINGS),
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
@@ -931,6 +954,124 @@ DEFINE_DQUOT_EVENT(xfs_dqrele);
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
+		__field(xfs_dqtype_t, type)
+		__field(unsigned int, flags)
+		__field(unsigned int, dqid)
+		__field(unsigned int, field)
+		__field(int64_t, delta)
+	),
+	TP_fast_assign(
+		__entry->dev = tp->t_mountp->m_super->s_dev;
+		__entry->type = dqp->q_type;
+		__entry->flags = dqp->q_flags;
+		__entry->dqid = dqp->q_id;
+		__entry->field = field;
+		__entry->delta = delta;
+	),
+	TP_printk("dev %d:%d dquot id 0x%x type %s flags %s field %s delta %lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dqid,
+		  __print_symbolic(__entry->type, XFS_DQTYPE_STRINGS),
+		  __print_flags(__entry->flags, "|", XFS_DQFLAG_STRINGS),
+		  __print_flags(__entry->field, "|", XFS_QMOPT_FLAGS),
+		  __entry->delta)
+);
+
+DECLARE_EVENT_CLASS(xfs_dqtrx_class,
+	TP_PROTO(struct xfs_dqtrx *qtrx),
+	TP_ARGS(qtrx),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_dqtype_t, type)
+		__field(unsigned int, flags)
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
+		__entry->type = qtrx->qt_dquot->q_type;
+		__entry->flags = qtrx->qt_dquot->q_flags;
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
+	TP_printk("dev %d:%d dquot id 0x%x type %s"
+		  "blk_res %llu bcount_delta %lld delbcnt_delta %lld "
+		  "rtblk_res %llu rtblk_res_used %llu rtbcount_delta %lld delrtb_delta %lld "
+		  "ino_res %llu ino_res_used %llu icount_delta %lld",
+		MAJOR(__entry->dev), MINOR(__entry->dev),
+		__entry->dqid,
+		__print_symbolic(__entry->type, XFS_DQTYPE_STRINGS),
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
index cbd92d8b693d..6e0eabbbd3ba 100644
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

