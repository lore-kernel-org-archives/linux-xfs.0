Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6133EC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 00:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F6B923A1C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 00:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgLHAnN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 19:43:13 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34254 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgLHAnN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 19:43:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B80ZGro169791
        for <linux-xfs@vger.kernel.org>; Tue, 8 Dec 2020 00:42:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=nR9LZF8iZiaB5nVrndtvxOulTake/t7+7Tuibl7VXiQ=;
 b=ykgHIEhKRtufE8Svm+BWexSM4Moh6tYaUpWsfXowSp6Z6zgkoYMfP473us/FLB8ocLPz
 SWz4dNh3RhB1GIb6sO2j3TNZtA2HIBou2rr62ZDLgvjclXx0/KHZuOR2oUfas6N/4ON9
 hf8ShmAUG6RY6eznKA4wptDw+3vG7HWNzHJ9CTEXlqkPO0A5JCzA0MNNcvr+IfPhRYOa
 nO93SPmxL01R8mxVxnYk+1mN0TYguoWrion6rrXUT/ic9VVrNND6COZW0O1O0yp5adGM
 wn8mu05Q2XOpDF0LdrRrNqSkWzP2CmKmbHpkMwF+3AMBirXz1u3IyqvRoPvveiV/Fy3m pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35825m0acf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 08 Dec 2020 00:42:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B80aalJ000763
        for <linux-xfs@vger.kernel.org>; Tue, 8 Dec 2020 00:40:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 358kys2unq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 Dec 2020 00:40:30 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B80eT7C014529
        for <linux-xfs@vger.kernel.org>; Tue, 8 Dec 2020 00:40:29 GMT
Received: from localhost (/10.159.240.214)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 16:40:29 -0800
Date:   Mon, 7 Dec 2020 16:40:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <20201208004028.GU629293@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Log incompat feature flags in the superblock exist for one purpose: to
protect the contents of a dirty log from replay on a kernel that isn't
prepared to handle those dirty contents.  This means that they can be
cleared if (a) we know the log is clean and (b) we know that there
aren't any other threads in the system that might be setting or relying
upon a log incompat flag.

Therefore, clear the log incompat flags when we've finished recovering
the log, when we're unmounting cleanly, remounting read-only, or
freezing; and provide a function so that subsequent patches can start
using this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
Note: I wrote this so that we could turn on log incompat flags for
atomic extent swapping and Allison could probably use it for the delayed
logged xattr patchset.  Not gonna try to land this in 5.11, FWIW...
---
 fs/xfs/libxfs/xfs_format.h |   15 ++++++
 fs/xfs/xfs_log.c           |    8 +++
 fs/xfs/xfs_mount.c         |  119 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h         |    2 +
 fs/xfs/xfs_super.c         |    9 +++
 5 files changed, 153 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c5481444d61e..84806986009c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -495,6 +495,21 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
+static inline void
+xfs_sb_remove_incompat_log_features(
+	struct xfs_sb	*sbp)
+{
+	sbp->sb_features_log_incompat &= ~XFS_SB_FEAT_INCOMPAT_LOG_ALL;
+}
+
+static inline void
+xfs_sb_add_incompat_log_features(
+	struct xfs_sb	*sbp,
+	unsigned int	features)
+{
+	sbp->sb_features_log_incompat |= features;
+}
+
 /*
  * V5 superblock specific feature checks
  */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fa2d05e65ff1..eeb29f4c676b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -738,6 +738,14 @@ xfs_log_mount_finish(
 	 * that aren't removed until recovery is cancelled.
 	 */
 	if (!error && recovered) {
+		/*
+		 * Now that we've recovered the log and all the intents, we can
+		 * clear the log incompat feature bits in the superblock
+		 * because there's no longer anything to protect.  We rely on
+		 * the AIL push to write out the updated superblock after
+		 * everything else.
+		 */
+		error = xfs_clear_incompat_log_features(mp);
 		xfs_log_force(mp, XFS_LOG_SYNC);
 		xfs_ail_push_all_sync(mp->m_ail);
 	}
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 669a9cf43582..68a5c90ec65b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1151,6 +1151,14 @@ xfs_unmountfs(
 		xfs_warn(mp, "Unable to update superblock counters. "
 				"Freespace may not be correct on next mount.");
 
+	/*
+	 * Clear log incompat features since we're unmounting cleanly.  Report
+	 * failures, though it's not fatal to have a higher log feature
+	 * protection level than the log contents actually require.
+	 */
+	error = xfs_clear_incompat_log_features(mp);
+	if (error)
+		xfs_warn(mp, "Unable to clear superblock log incompat flags.");
 
 	xfs_log_unmount(mp);
 	xfs_da_unmount(mp);
@@ -1361,6 +1369,117 @@ xfs_force_summary_recalc(
 	xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
 }
 
+/*
+ * Enable a log incompat feature flag in the primary superblock.  The caller
+ * cannot have any other transactions in progress.
+ */
+int
+xfs_add_incompat_log_feature(
+	struct xfs_mount	*mp,
+	uint32_t		feature)
+{
+	struct xfs_dsb		*dsb;
+	int			error;
+
+	ASSERT(hweight32(feature) == 1);
+	ASSERT(!(feature & XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
+
+	/*
+	 * Force the log to disk and kick the background AIL thread to reduce
+	 * the chances that the bwrite will stall waiting for the AIL to unpin
+	 * the primary superblock buffer.  This isn't a data integrity
+	 * operation, so we don't need a synchronous push.
+	 */
+	error = xfs_log_force(mp, XFS_LOG_SYNC);
+	if (error)
+		return error;
+	xfs_ail_push_all(mp->m_ail);
+
+	/*
+	 * Lock the primary superblock buffer to serialize all callers that
+	 * are trying to set feature bits.
+	 */
+	xfs_buf_lock(mp->m_sb_bp);
+	xfs_buf_hold(mp->m_sb_bp);
+
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		error = -EIO;
+		goto rele;
+	}
+
+	if (xfs_sb_has_incompat_log_feature(&mp->m_sb, feature))
+		goto rele;
+
+	/*
+	 * Write the primary superblock to disk immediately, because we need
+	 * the log_incompat bit to be set in the primary super now to protect
+	 * the log items that we're going to commit later.
+	 */
+	dsb = mp->m_sb_bp->b_addr;
+	xfs_sb_to_disk(dsb, &mp->m_sb);
+	dsb->sb_features_log_incompat |= cpu_to_be32(feature);
+	error = xfs_bwrite(mp->m_sb_bp);
+	if (error)
+		goto shutdown;
+
+	/*
+	 * Add the feature bits to the incore superblock before we unlock the
+	 * buffer.
+	 */
+	xfs_sb_add_incompat_log_features(&mp->m_sb, feature);
+	xfs_buf_relse(mp->m_sb_bp);
+
+	/* Log the superblock to disk. */
+	return xfs_sync_sb(mp, false);
+shutdown:
+	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+rele:
+	xfs_buf_relse(mp->m_sb_bp);
+	return error;
+}
+
+/*
+ * Clear all the log incompat flags from the superblock.
+ *
+ * The caller must have freeze protection, cannot have any other transactions
+ * in progress, must ensure that the log does not contain any log items
+ * protected by any log incompat bit, and must ensure that there are no other
+ * threads that could be reading or writing the log incompat feature flag in
+ * the primary super.  In other words, we can only turn features off as one of
+ * the final steps of quiescing or unmounting the log.
+ */
+int
+xfs_clear_incompat_log_features(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
+	    !xfs_sb_has_incompat_log_feature(&mp->m_sb,
+				XFS_SB_FEAT_INCOMPAT_LOG_ALL) ||
+	    XFS_FORCED_SHUTDOWN(mp))
+		return 0;
+
+	/*
+	 * Update the incore superblock.  We synchronize on the primary super
+	 * buffer lock to be consistent with the add function, though at least
+	 * in theory this shouldn't be necessary.
+	 */
+	xfs_buf_lock(mp->m_sb_bp);
+	xfs_buf_hold(mp->m_sb_bp);
+
+	if (!xfs_sb_has_incompat_log_feature(&mp->m_sb,
+				XFS_SB_FEAT_INCOMPAT_LOG_ALL))
+		goto rele;
+
+	xfs_sb_remove_incompat_log_features(&mp->m_sb);
+	xfs_buf_relse(mp->m_sb_bp);
+
+	/* Log the superblock to disk. */
+	return xfs_sync_sb(mp, false);
+rele:
+	xfs_buf_relse(mp->m_sb_bp);
+	return 0;
+}
+
 /*
  * Update the in-core delayed block counter.
  *
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 232f2383e8ba..02bd940d66fb 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -441,6 +441,8 @@ int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
 		int error_class, int error);
 void xfs_force_summary_recalc(struct xfs_mount *mp);
+int xfs_add_incompat_log_feature(struct xfs_mount *mp, uint32_t feature);
+int xfs_clear_incompat_log_features(struct xfs_mount *mp);
 void xfs_mod_delalloc(struct xfs_mount *mp, int64_t delta);
 unsigned int xfs_guess_metadata_threads(struct xfs_mount *mp);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 343435a677f9..71e304c15e6b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -919,6 +919,15 @@ xfs_quiesce_attr(
 	/* force the log to unpin objects from the now complete transactions */
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
+	/*
+	 * Clear log incompat features since we're freezing or remounting ro.
+	 * Report failures, though it's not fatal to have a higher log feature
+	 * protection level than the log contents actually require.
+	 */
+	error = xfs_clear_incompat_log_features(mp);
+	if (error)
+		xfs_warn(mp, "Unable to clear superblock log incompat flags. "
+				"Frozen image may not be consistent.");
 
 	/* Push the superblock and write an unmount record */
 	error = xfs_log_sbcount(mp);
