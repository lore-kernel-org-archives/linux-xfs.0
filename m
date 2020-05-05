Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE746C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96B08206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zbglELCU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgEEBMf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:12:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47386 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBMf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:12:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04513u0e055596
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7uX1UZ1I3GCFmvH+BsbR4Q7j3vxOKO00Mo0zAGoUZmQ=;
 b=zbglELCUMwdKcP+YiCAvrFd1Uhcjr+7decBhtaLP22inlCC0D+c0+HwyQSZ0HH+XagXv
 moLAEjvPv+nmSeffdrht3jRRi9NdQAElrj/1DooJ/jHkf79schvh3iwCGbDmNjg6/Jsa
 3LNp1D+5iHEHxY22zKS7E+NvSxDHpiEd2O0VUQAePtSXg466veSunT27s+odRYUyGO/E
 ATIMNpBWCzyQukIigdDC7PUtfRVGYpKy4LzRIBqhpX3A4Nb3NYqr366mko4+X57Vtj/Y
 ID4o8TqtnmQhBDYQQrZc27Sh48B7XN9JVTZSNKgH85KqRXv5pL9ATG/SVIHXyJ40iJOx 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30s1gn1vkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515Sn9145329
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjnckxu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:31 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451CUx8016485
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:12:29 -0700
Subject: [PATCH 18/28] xfs: refactor unlinked inode recovery
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:12:29 -0700
Message-ID: <158864114901.182683.2099772155374609732.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the code that processes unlinked inodes into a separate file in
preparation for centralizing the log recovery bits that have to walk
every AG.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                 |    3 -
 fs/xfs/libxfs/xfs_log_recover.h |    1 
 fs/xfs/xfs_log_recover.c        |  177 -----------------------------------
 fs/xfs/xfs_unlink_recover.c     |  198 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 202 insertions(+), 177 deletions(-)
 create mode 100644 fs/xfs/xfs_unlink_recover.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 04611a1068b4..505c898d6cee 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -109,7 +109,8 @@ xfs-y				+= xfs_log.o \
 				   xfs_rmap_item.o \
 				   xfs_log_recover.o \
 				   xfs_trans_ail.o \
-				   xfs_trans_buf.o
+				   xfs_trans_buf.o \
+				   xfs_unlink_recover.o
 
 # optional features
 xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index a45f6e9fa47b..33c14dd22b77 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -124,5 +124,6 @@ bool xlog_add_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 bool xlog_put_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 void xlog_recover_iodone(struct xfs_buf *bp);
+void xlog_recover_process_unlinked(struct xlog *log);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 20ee32c2652d..362296b34490 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2720,181 +2720,6 @@ xlog_recover_cancel_intents(
 	spin_unlock(&ailp->ail_lock);
 }
 
-/*
- * This routine performs a transaction to null out a bad inode pointer
- * in an agi unlinked inode hash bucket.
- */
-STATIC void
-xlog_recover_clear_agi_bucket(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno,
-	int		bucket)
-{
-	xfs_trans_t	*tp;
-	xfs_agi_t	*agi;
-	xfs_buf_t	*agibp;
-	int		offset;
-	int		error;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_clearagi, 0, 0, 0, &tp);
-	if (error)
-		goto out_error;
-
-	error = xfs_read_agi(mp, tp, agno, &agibp);
-	if (error)
-		goto out_abort;
-
-	agi = agibp->b_addr;
-	agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
-	offset = offsetof(xfs_agi_t, agi_unlinked) +
-		 (sizeof(xfs_agino_t) * bucket);
-	xfs_trans_log_buf(tp, agibp, offset,
-			  (offset + sizeof(xfs_agino_t) - 1));
-
-	error = xfs_trans_commit(tp);
-	if (error)
-		goto out_error;
-	return;
-
-out_abort:
-	xfs_trans_cancel(tp);
-out_error:
-	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.", __func__, agno);
-	return;
-}
-
-STATIC xfs_agino_t
-xlog_recover_process_one_iunlink(
-	struct xfs_mount		*mp,
-	xfs_agnumber_t			agno,
-	xfs_agino_t			agino,
-	int				bucket)
-{
-	struct xfs_buf			*ibp;
-	struct xfs_dinode		*dip;
-	struct xfs_inode		*ip;
-	xfs_ino_t			ino;
-	int				error;
-
-	ino = XFS_AGINO_TO_INO(mp, agno, agino);
-	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
-	if (error)
-		goto fail;
-
-	/*
-	 * Get the on disk inode to find the next inode in the bucket.
-	 */
-	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &ibp, 0, 0);
-	if (error)
-		goto fail_iput;
-
-	xfs_iflags_clear(ip, XFS_IRECOVERY);
-	ASSERT(VFS_I(ip)->i_nlink == 0);
-	ASSERT(VFS_I(ip)->i_mode != 0);
-
-	/* setup for the next pass */
-	agino = be32_to_cpu(dip->di_next_unlinked);
-	xfs_buf_relse(ibp);
-
-	/*
-	 * Prevent any DMAPI event from being sent when the reference on
-	 * the inode is dropped.
-	 */
-	ip->i_d.di_dmevmask = 0;
-
-	xfs_irele(ip);
-	return agino;
-
- fail_iput:
-	xfs_irele(ip);
- fail:
-	/*
-	 * We can't read in the inode this bucket points to, or this inode
-	 * is messed up.  Just ditch this bucket of inodes.  We will lose
-	 * some inodes and space, but at least we won't hang.
-	 *
-	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
-	 * clear the inode pointer in the bucket.
-	 */
-	xlog_recover_clear_agi_bucket(mp, agno, bucket);
-	return NULLAGINO;
-}
-
-/*
- * Recover AGI unlinked lists
- *
- * This is called during recovery to process any inodes which we unlinked but
- * not freed when the system crashed.  These inodes will be on the lists in the
- * AGI blocks. What we do here is scan all the AGIs and fully truncate and free
- * any inodes found on the lists. Each inode is removed from the lists when it
- * has been fully truncated and is freed. The freeing of the inode and its
- * removal from the list must be atomic.
- *
- * If everything we touch in the agi processing loop is already in memory, this
- * loop can hold the cpu for a long time. It runs without lock contention,
- * memory allocation contention, the need wait for IO, etc, and so will run
- * until we either run out of inodes to process, run low on memory or we run out
- * of log space.
- *
- * This behaviour is bad for latency on single CPU and non-preemptible kernels,
- * and can prevent other filesytem work (such as CIL pushes) from running. This
- * can lead to deadlocks if the recovery process runs out of log reservation
- * space. Hence we need to yield the CPU when there is other kernel work
- * scheduled on this CPU to ensure other scheduled work can run without undue
- * latency.
- */
-STATIC void
-xlog_recover_process_iunlinks(
-	struct xlog	*log)
-{
-	xfs_mount_t	*mp;
-	xfs_agnumber_t	agno;
-	xfs_agi_t	*agi;
-	xfs_buf_t	*agibp;
-	xfs_agino_t	agino;
-	int		bucket;
-	int		error;
-
-	mp = log->l_mp;
-
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		/*
-		 * Find the agi for this ag.
-		 */
-		error = xfs_read_agi(mp, NULL, agno, &agibp);
-		if (error) {
-			/*
-			 * AGI is b0rked. Don't process it.
-			 *
-			 * We should probably mark the filesystem as corrupt
-			 * after we've recovered all the ag's we can....
-			 */
-			continue;
-		}
-		/*
-		 * Unlock the buffer so that it can be acquired in the normal
-		 * course of the transaction to truncate and free each inode.
-		 * Because we are not racing with anyone else here for the AGI
-		 * buffer, we don't even need to hold it locked to read the
-		 * initial unlinked bucket entries out of the buffer. We keep
-		 * buffer reference though, so that it stays pinned in memory
-		 * while we need the buffer.
-		 */
-		agi = agibp->b_addr;
-		xfs_buf_unlock(agibp);
-
-		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
-			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
-			while (agino != NULLAGINO) {
-				agino = xlog_recover_process_one_iunlink(mp,
-							agno, agino, bucket);
-				cond_resched();
-			}
-		}
-		xfs_buf_rele(agibp);
-	}
-}
-
 STATIC void
 xlog_unpack_data(
 	struct xlog_rec_header	*rhead,
@@ -3574,7 +3399,7 @@ xlog_recover_finish(
 		 */
 		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
 
-		xlog_recover_process_iunlinks(log);
+		xlog_recover_process_unlinked(log);
 
 		xlog_recover_check_summary(log);
 
diff --git a/fs/xfs/xfs_unlink_recover.c b/fs/xfs/xfs_unlink_recover.c
new file mode 100644
index 000000000000..2a19d096e88d
--- /dev/null
+++ b/fs/xfs/xfs_unlink_recover.c
@@ -0,0 +1,198 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_log.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+#include "xfs_trans_priv.h"
+#include "xfs_ialloc.h"
+#include "xfs_icache.h"
+
+/*
+ * This routine performs a transaction to null out a bad inode pointer
+ * in an agi unlinked inode hash bucket.
+ */
+STATIC void
+xlog_recover_clear_agi_bucket(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	int			bucket)
+{
+	struct xfs_trans	*tp;
+	struct xfs_agi		*agi;
+	struct xfs_buf		*agibp;
+	int			offset;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_clearagi, 0, 0, 0, &tp);
+	if (error)
+		goto out_error;
+
+	error = xfs_read_agi(mp, tp, agno, &agibp);
+	if (error)
+		goto out_abort;
+
+	agi = agibp->b_addr;
+	agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
+	offset = offsetof(xfs_agi_t, agi_unlinked) +
+		 (sizeof(xfs_agino_t) * bucket);
+	xfs_trans_log_buf(tp, agibp, offset,
+			  (offset + sizeof(xfs_agino_t) - 1));
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_error;
+	return;
+
+out_abort:
+	xfs_trans_cancel(tp);
+out_error:
+	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.", __func__, agno);
+	return;
+}
+
+STATIC xfs_agino_t
+xlog_recover_process_one_iunlink(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	xfs_agino_t			agino,
+	int				bucket)
+{
+	struct xfs_buf			*ibp;
+	struct xfs_dinode		*dip;
+	struct xfs_inode		*ip;
+	xfs_ino_t			ino;
+	int				error;
+
+	ino = XFS_AGINO_TO_INO(mp, agno, agino);
+	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
+	if (error)
+		goto fail;
+
+	/*
+	 * Get the on disk inode to find the next inode in the bucket.
+	 */
+	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &ibp, 0, 0);
+	if (error)
+		goto fail_iput;
+
+	xfs_iflags_clear(ip, XFS_IRECOVERY);
+	ASSERT(VFS_I(ip)->i_nlink == 0);
+	ASSERT(VFS_I(ip)->i_mode != 0);
+
+	/* setup for the next pass */
+	agino = be32_to_cpu(dip->di_next_unlinked);
+	xfs_buf_relse(ibp);
+
+	/*
+	 * Prevent any DMAPI event from being sent when the reference on
+	 * the inode is dropped.
+	 */
+	ip->i_d.di_dmevmask = 0;
+
+	xfs_irele(ip);
+	return agino;
+
+ fail_iput:
+	xfs_irele(ip);
+ fail:
+	/*
+	 * We can't read in the inode this bucket points to, or this inode
+	 * is messed up.  Just ditch this bucket of inodes.  We will lose
+	 * some inodes and space, but at least we won't hang.
+	 *
+	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
+	 * clear the inode pointer in the bucket.
+	 */
+	xlog_recover_clear_agi_bucket(mp, agno, bucket);
+	return NULLAGINO;
+}
+
+/*
+ * Recover AGI unlinked lists
+ *
+ * This is called during recovery to process any inodes which we unlinked but
+ * not freed when the system crashed.  These inodes will be on the lists in the
+ * AGI blocks. What we do here is scan all the AGIs and fully truncate and free
+ * any inodes found on the lists. Each inode is removed from the lists when it
+ * has been fully truncated and is freed. The freeing of the inode and its
+ * removal from the list must be atomic.
+ *
+ * If everything we touch in the agi processing loop is already in memory, this
+ * loop can hold the cpu for a long time. It runs without lock contention,
+ * memory allocation contention, the need wait for IO, etc, and so will run
+ * until we either run out of inodes to process, run low on memory or we run out
+ * of log space.
+ *
+ * This behaviour is bad for latency on single CPU and non-preemptible kernels,
+ * and can prevent other filesytem work (such as CIL pushes) from running. This
+ * can lead to deadlocks if the recovery process runs out of log reservation
+ * space. Hence we need to yield the CPU when there is other kernel work
+ * scheduled on this CPU to ensure other scheduled work can run without undue
+ * latency.
+ */
+void
+xlog_recover_process_unlinked(
+	struct xlog		*log)
+{
+	struct xfs_mount	*mp;
+	struct xfs_agi		*agi;
+	struct xfs_buf		*agibp;
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	int			bucket;
+	int			error;
+
+	mp = log->l_mp;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		/*
+		 * Find the agi for this ag.
+		 */
+		error = xfs_read_agi(mp, NULL, agno, &agibp);
+		if (error) {
+			/*
+			 * AGI is b0rked. Don't process it.
+			 *
+			 * We should probably mark the filesystem as corrupt
+			 * after we've recovered all the ag's we can....
+			 */
+			continue;
+		}
+		/*
+		 * Unlock the buffer so that it can be acquired in the normal
+		 * course of the transaction to truncate and free each inode.
+		 * Because we are not racing with anyone else here for the AGI
+		 * buffer, we don't even need to hold it locked to read the
+		 * initial unlinked bucket entries out of the buffer. We keep
+		 * buffer reference though, so that it stays pinned in memory
+		 * while we need the buffer.
+		 */
+		agi = agibp->b_addr;
+		xfs_buf_unlock(agibp);
+
+		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
+			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
+			while (agino != NULLAGINO) {
+				agino = xlog_recover_process_one_iunlink(mp,
+							agno, agino, bucket);
+				cond_resched();
+			}
+		}
+		xfs_buf_rele(agibp);
+	}
+}

