Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698C6C432BE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 07:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EE2D61059
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 07:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242600AbhIAHbp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 03:31:45 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:48237 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242598AbhIAHbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 03:31:45 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id B8B9B10C41B;
        Wed,  1 Sep 2021 17:30:47 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLKhm-007NLO-KP; Wed, 01 Sep 2021 17:30:42 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mLKhm-003Xo2-CK; Wed, 01 Sep 2021 17:30:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH 3/5] xfs: hide log iovec alignment constraints
Date:   Wed,  1 Sep 2021 17:30:37 +1000
Message-Id: <20210901073039.844617-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210901073039.844617-1-david@fromorbit.com>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210901073039.844617-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=R5RXffkYQKTqY8OMXQgA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Callers currently have to round out the size of buffers to match the
aligment constraints of log iovecs and xlog_write(). They should not
need to know this detail, so introduce a new function to calculate
the iovec length (for use in ->iop_size implementations). Also
modify xlog_finish_iovec() to round up the length to the correct
alignment so the callers don't need to do this, either.

Convert the only user - inode forks - of this alignment rounding to
use the new interface.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 10 ++--------
 fs/xfs/xfs_inode_item.c        | 25 +++++++------------------
 fs/xfs/xfs_log.h               | 20 ++++++++++++++++++++
 3 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1d174909f9bd..2690f5f47b7e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -50,8 +50,7 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
-		real_size = roundup(mem_size, 4);
-		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
+		ifp->if_u1.if_data = kmem_alloc(mem_size, KM_NOFS);
 		memcpy(ifp->if_u1.if_data, data, size);
 		if (zero_terminate)
 			ifp->if_u1.if_data[size] = '\0';
@@ -497,12 +496,7 @@ xfs_idata_realloc(
 		return;
 	}
 
-	/*
-	 * For inline data, the underlying buffer must be a multiple of 4 bytes
-	 * in size so that it can be logged and stay on word boundaries.
-	 * We enforce that here.
-	 */
-	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
+	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, new_size,
 				      GFP_NOFS | __GFP_NOFAIL);
 	ifp->if_bytes = new_size;
 }
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 0659d19c211e..806562d82ced 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -70,7 +70,7 @@ xfs_inode_item_data_fork_size(
 	case XFS_DINODE_FMT_LOCAL:
 		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
 		    ip->i_df.if_bytes > 0) {
-			*nbytes += roundup(ip->i_df.if_bytes, 4);
+			*nbytes += xlog_calc_iovec_len(ip->i_df.if_bytes);
 			*nvecs += 1;
 		}
 		break;
@@ -111,7 +111,7 @@ xfs_inode_item_attr_fork_size(
 	case XFS_DINODE_FMT_LOCAL:
 		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
 		    ip->i_afp->if_bytes > 0) {
-			*nbytes += roundup(ip->i_afp->if_bytes, 4);
+			*nbytes += xlog_calc_iovec_len(ip->i_df.if_bytes);
 			*nvecs += 1;
 		}
 		break;
@@ -203,17 +203,12 @@ xfs_inode_item_format_data_fork(
 			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
 		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
 		    ip->i_df.if_bytes > 0) {
-			/*
-			 * Round i_bytes up to a word boundary.
-			 * The underlying memory is guaranteed
-			 * to be there by xfs_idata_realloc().
-			 */
-			data_bytes = roundup(ip->i_df.if_bytes, 4);
 			ASSERT(ip->i_df.if_u1.if_data != NULL);
 			ASSERT(ip->i_disk_size > 0);
 			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_ILOCAL,
-					ip->i_df.if_u1.if_data, data_bytes);
-			ilf->ilf_dsize = (unsigned)data_bytes;
+					ip->i_df.if_u1.if_data,
+					ip->i_df.if_bytes);
+			ilf->ilf_dsize = (unsigned)ip->i_df.if_bytes;
 			ilf->ilf_size++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_DDATA;
@@ -287,17 +282,11 @@ xfs_inode_item_format_attr_fork(
 
 		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
 		    ip->i_afp->if_bytes > 0) {
-			/*
-			 * Round i_bytes up to a word boundary.
-			 * The underlying memory is guaranteed
-			 * to be there by xfs_idata_realloc().
-			 */
-			data_bytes = roundup(ip->i_afp->if_bytes, 4);
 			ASSERT(ip->i_afp->if_u1.if_data != NULL);
 			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_LOCAL,
 					ip->i_afp->if_u1.if_data,
-					data_bytes);
-			ilf->ilf_asize = (unsigned)data_bytes;
+					ip->i_afp->if_bytes);
+			ilf->ilf_asize = (unsigned)ip->i_afp->if_bytes;
 			ilf->ilf_size++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_ADATA;
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index b324d2136e94..0ee0ec7f96c8 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -22,6 +22,17 @@ struct xfs_log_vec {
 
 #define XFS_LOG_VEC_ORDERED	(-1)
 
+/*
+ * Calculate the log iovec length for a given user buffer length. Intended to be
+ * used by ->iop_size implementations when sizing buffers of arbitrary
+ * alignments.
+ */
+static inline int
+xlog_calc_iovec_len(int len)
+{
+	return roundup(len, 4);
+}
+
 void *xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
 		uint type);
 
@@ -30,6 +41,12 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
 {
 	struct xlog_op_header	*oph = vec->i_addr;
 
+	/*
+	 * Always round up the length to the correct alignment so callers don't
+	 * need to know anything about this log vec layout requirement.
+	 */
+	len = xlog_calc_iovec_len(len);
+
 	/* opheader tracks payload length, logvec tracks region length */
 	oph->oh_len = len;
 
@@ -39,6 +56,9 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
 	vec->i_len = len;
 }
 
+/*
+ * Copy the amount of data requested by the caller into a new log iovec.
+ */
 static inline void *
 xlog_copy_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
 		uint type, void *data, int len)
-- 
2.31.1

