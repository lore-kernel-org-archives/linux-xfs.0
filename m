Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76FEDC433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F4D52192A
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:32:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vjrEw0l0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgGNBcR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:32:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53148 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgGNBcQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:32:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1SYfQ159019
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2S+Xtg7iCRpP0w2QK1SDQmZH/ivjGcYKqf/l606PxCM=;
 b=vjrEw0l0au19FMDrNNktuNDceqmK1To6uVMv0PB9CgA2j2Lvn+G/5TIFXQLmsIhhPcv2
 0VPjlTW5UfYkG2ZZleBO88Is6fJ1bwcrLsYfUJOuuoozjwNXwI+Ony8v9s2rQOp4Bnyf
 FNes93/Q/a/mhNEabX90E+U+q627a0PwaDMlc9T4B/Inh99/HFuu0GVtOLCWvcCKI9HL
 ZehzYn5rDryY4qUBlw16kBn3up5OacgE/qCNTp2ouOSKnGu0grcb3CKOi9PNVRMmTiav
 BohI29J/5KmjkRqs6KiGJidHyRSPQY3Ha/6lkkR4mcZJBq2I9N5cvWM3s7l9bjP3xY8Q 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3275cm2d8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1Sasb054818
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 327qbwgxb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:14 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06E1WD0n010106
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:13 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:32:13 -0700
Subject: [PATCH 07/26] xfs: rename dquot incore state flags
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 13 Jul 2020 18:32:13 -0700
Message-ID: <159469033295.2914673.15913112198887429156.stgit@magnolia>
In-Reply-To: <159469028734.2914673.17856142063205791176.stgit@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Rename the existing incore dquot "dq_flags" field to "q_flags" to match
everything else in the structure, then move the two actual dquot state
flags to the XFS_DQFLAG_ namespace from XFS_DQ_.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |   10 +++++-----
 fs/xfs/xfs_dquot.c             |    6 +++---
 fs/xfs/xfs_dquot.h             |    4 ++--
 fs/xfs/xfs_qm.c                |   12 ++++++------
 fs/xfs/xfs_qm_syscalls.c       |    2 +-
 fs/xfs/xfs_trace.h             |    4 ++--
 fs/xfs/xfs_trans_dquot.c       |    2 +-
 7 files changed, 20 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 0285252b0c23..5a8f5c973495 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -37,17 +37,17 @@ typedef uint8_t		xfs_dqtype_t;
 #define XFS_DQ_USER		0x0001		/* a user quota */
 #define XFS_DQ_PROJ		0x0002		/* project quota */
 #define XFS_DQ_GROUP		0x0004		/* a group quota */
-#define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
-#define XFS_DQ_FREEING		0x0010		/* dquot is being torn down */
+#define XFS_DQFLAG_DIRTY	0x0008		/* dquot is dirty */
+#define XFS_DQFLAG_FREEING	0x0010		/* dquot is being torn down */
 
 #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
 
-#define XFS_DQ_FLAGS \
+#define XFS_DQFLAG_STRINGS \
 	{ XFS_DQ_USER,		"USER" }, \
 	{ XFS_DQ_PROJ,		"PROJ" }, \
 	{ XFS_DQ_GROUP,		"GROUP" }, \
-	{ XFS_DQ_DIRTY,		"DIRTY" }, \
-	{ XFS_DQ_FREEING,	"FREEING" }
+	{ XFS_DQFLAG_DIRTY,	"DIRTY" }, \
+	{ XFS_DQFLAG_FREEING,	"FREEING" }
 
 static inline __u8
 xfs_dquot_type_to_disk(
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ddaa5968e98e..98a83c2fe1d3 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -731,7 +731,7 @@ xfs_qm_dqget_cache_lookup(
 	}
 
 	xfs_dqlock(dqp);
-	if (dqp->dq_flags & XFS_DQ_FREEING) {
+	if (dqp->q_flags & XFS_DQFLAG_FREEING) {
 		xfs_dqunlock(dqp);
 		mutex_unlock(&qi->qi_tree_lock);
 		trace_xfs_dqget_freeing(dqp);
@@ -1187,7 +1187,7 @@ xfs_qm_dqflush(
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
 	 */
-	dqp->dq_flags &= ~XFS_DQ_DIRTY;
+	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
 
 	xfs_trans_ail_copy_lsn(mp->m_ail, &dqp->q_logitem.qli_flush_lsn,
 					&dqp->q_logitem.qli_item.li_lsn);
@@ -1228,7 +1228,7 @@ xfs_qm_dqflush(
 	return 0;
 
 out_abort:
-	dqp->dq_flags &= ~XFS_DQ_DIRTY;
+	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
 	xfs_trans_ail_delete(lip, 0);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 out_unlock:
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 077d0988cff9..7f3f734bced8 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -31,10 +31,10 @@ enum {
  * The incore dquot structure
  */
 struct xfs_dquot {
-	uint			dq_flags;
 	struct list_head	q_lru;
 	struct xfs_mount	*q_mount;
 	xfs_dqtype_t		q_type;
+	uint16_t		q_flags;
 	uint			q_nrefs;
 	xfs_daddr_t		q_blkno;
 	int			q_bufoffset;
@@ -152,7 +152,7 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
 }
 
 #define XFS_DQ_IS_LOCKED(dqp)	(mutex_is_locked(&((dqp)->q_qlock)))
-#define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
+#define XFS_DQ_IS_DIRTY(dqp)	((dqp)->q_flags & XFS_DQFLAG_DIRTY)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->q_type == XFS_DQTYPE_USER)
 #define XFS_QM_ISPDQ(dqp)	((dqp)->q_type == XFS_DQTYPE_PROJ)
 #define XFS_QM_ISGDQ(dqp)	((dqp)->q_type == XFS_DQTYPE_GROUP)
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c89d9c444351..9786acec4076 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -124,10 +124,10 @@ xfs_qm_dqpurge(
 	int			error = -EAGAIN;
 
 	xfs_dqlock(dqp);
-	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0)
+	if ((dqp->q_flags & XFS_DQFLAG_FREEING) || dqp->q_nrefs != 0)
 		goto out_unlock;
 
-	dqp->dq_flags |= XFS_DQ_FREEING;
+	dqp->q_flags |= XFS_DQFLAG_FREEING;
 
 	xfs_dqflock(dqp);
 
@@ -148,7 +148,7 @@ xfs_qm_dqpurge(
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
 		} else if (error == -EAGAIN) {
-			dqp->dq_flags &= ~XFS_DQ_FREEING;
+			dqp->q_flags &= ~XFS_DQFLAG_FREEING;
 			goto out_unlock;
 		}
 		xfs_dqflock(dqp);
@@ -474,7 +474,7 @@ xfs_qm_dquot_isolate(
 	/*
 	 * Prevent lookups now that we are past the point of no return.
 	 */
-	dqp->dq_flags |= XFS_DQ_FREEING;
+	dqp->q_flags |= XFS_DQFLAG_FREEING;
 	xfs_dqunlock(dqp);
 
 	ASSERT(dqp->q_nrefs == 0);
@@ -1113,7 +1113,7 @@ xfs_qm_quotacheck_dqadjust(
 		xfs_qm_adjust_dqtimers(mp, dqp);
 	}
 
-	dqp->dq_flags |= XFS_DQ_DIRTY;
+	dqp->q_flags |= XFS_DQFLAG_DIRTY;
 	xfs_qm_dqput(dqp);
 	return 0;
 }
@@ -1219,7 +1219,7 @@ xfs_qm_flush_one(
 	int			error = 0;
 
 	xfs_dqlock(dqp);
-	if (dqp->dq_flags & XFS_DQ_FREEING)
+	if (dqp->q_flags & XFS_DQFLAG_FREEING)
 		goto out_unlock;
 	if (!XFS_DQ_IS_DIRTY(dqp))
 		goto out_unlock;
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index c7cb8a356c88..7f157275e370 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -598,7 +598,7 @@ xfs_qm_scall_setqlim(
 		 */
 		xfs_qm_adjust_dqtimers(mp, dqp);
 	}
-	dqp->dq_flags |= XFS_DQ_DIRTY;
+	dqp->q_flags |= XFS_DQFLAG_DIRTY;
 	xfs_trans_log_dquot(tp, dqp);
 
 	error = xfs_trans_commit(tp);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f19e66da6646..0b6738070619 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -879,7 +879,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 		__entry->dev = dqp->q_mount->m_super->s_dev;
 		__entry->id = be32_to_cpu(dqp->q_core.d_id);
 		__entry->type = dqp->q_type;
-		__entry->flags = dqp->dq_flags;
+		__entry->flags = dqp->q_flags;
 		__entry->nrefs = dqp->q_nrefs;
 		__entry->res_bcount = dqp->q_res_bcount;
 		__entry->bcount = be64_to_cpu(dqp->q_core.d_bcount);
@@ -899,7 +899,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->id,
 		  __print_symbolic(__entry->type, XFS_DQTYPE_STRINGS),
-		  __print_flags(__entry->flags, "|", XFS_DQ_FLAGS),
+		  __print_flags(__entry->flags, "|", XFS_DQFLAG_STRINGS),
 		  __entry->nrefs,
 		  __entry->res_bcount,
 		  __entry->bcount,
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 964f69a444a3..bdbd8e88c772 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -391,7 +391,7 @@ xfs_trans_apply_dquot_deltas(
 				xfs_qm_adjust_dqtimers(tp->t_mountp, dqp);
 			}
 
-			dqp->dq_flags |= XFS_DQ_DIRTY;
+			dqp->q_flags |= XFS_DQFLAG_DIRTY;
 			/*
 			 * add this to the list of items to get logged
 			 */

