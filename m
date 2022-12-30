Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9725DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbiLaB1R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbiLaB1Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:27:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D1B1C93A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:27:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CB84B81DE3
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC481C433EF;
        Sat, 31 Dec 2022 01:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450033;
        bh=bgGIMKAWrKOu+6fs/ymBeea8moo8ZkuivNnD+hiQo+A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QEc2urCLcjU3MiXY9844nICNXePaud/dQAfmg4jBQyCga043ZbSovevUXMdzva4hi
         eLekwgDgXyF7fhFFTIXFgUobqNAXTPTiidjYwp9jatCQanQRMotGNo9vKyq5aQEwyH
         NqMuzveQFwYV2h/aLwSMA13M02wRYxmWwtsnpQOItWkq0KYKa3QQ4BPG9awU1A2Yix
         oebGnnf4pRVQGtflT5Jk1bp+On3UGD1OMHNh7giMLy3gOsQpjh+IWT4aTtpAOnloNQ
         LItOv7gpaABcKEToLktXbTHAE1AFSLg4RpzRRv/Wicme8jSF0cdYEzog4VMpq66Ezl
         ssiRGuFj6NV6w==
Subject: [PATCH 2/3] xfs: refactor realtime inode locking
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:49 -0800
Message-ID: <167243866912.712531.12624284771909096670.stgit@magnolia>
In-Reply-To: <167243866880.712531.9794913817759933297.stgit@magnolia>
References: <167243866880.712531.9794913817759933297.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create helper functions to deal with locking realtime metadata inodes.
This enables us to maintain correct locking order once we start adding
the realtime rmap and refcount btree inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c     |    7 +----
 fs/xfs/libxfs/xfs_rtbitmap.c |   57 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h |   17 +++++++++++++
 fs/xfs/scrub/common.c        |    1 +
 fs/xfs/scrub/fscounters.c    |    4 +--
 fs/xfs/xfs_bmap_util.c       |    5 +---
 fs/xfs/xfs_fsmap.c           |    4 +--
 fs/xfs/xfs_rtalloc.c         |   15 ++++-------
 8 files changed, 87 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1ad8606c1dd9..55fe8cda3d98 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5416,12 +5416,9 @@ __xfs_bunmapi(
 
 	if (isrt) {
 		/*
-		 * Synchronize by locking the bitmap inode.
+		 * Synchronize by locking the realtime bitmap.
 		 */
-		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
-		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
-		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
-		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
+		xfs_rtbitmap_lock(tp, mp);
 	}
 
 	extno = 0;
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index b74261abd238..46095acec709 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1251,3 +1251,60 @@ xfs_rtsummary_wordcount(
 	blocks = xfs_rtsummary_blockcount(mp, rsumlevels, rbmblocks);
 	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
 }
+
+/*
+ * Lock both realtime free space metadata inodes for a freespace update.  If a
+ * transaction is given, the inodes will be joined to the transaction and the
+ * ILOCKs will be released on transaction commit.
+ */
+void
+xfs_rtbitmap_lock(
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp)
+{
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+	if (tp)
+		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+
+	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+	if (tp)
+		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
+}
+
+/* Unlock both realtime free space metadata inodes after a freespace update. */
+void
+xfs_rtbitmap_unlock(
+	struct xfs_mount	*mp)
+{
+	xfs_iunlock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+}
+
+/*
+ * Lock the realtime free space metadata inodes for a freespace scan.  Callers
+ * must walk metadata blocks in order of increasing file offset.
+ */
+void
+xfs_rtbitmap_lock_shared(
+	struct xfs_mount	*mp,
+	unsigned int		rbmlock_flags)
+{
+	if (rbmlock_flags & XFS_RBMLOCK_BITMAP)
+		xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+
+	if (rbmlock_flags & XFS_RBMLOCK_SUMMARY)
+		xfs_ilock(mp->m_rsumip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
+}
+
+/* Unlock the realtime free space metadata inodes after a freespace scan. */
+void
+xfs_rtbitmap_unlock_shared(
+	struct xfs_mount	*mp,
+	unsigned int		rbmlock_flags)
+{
+	if (rbmlock_flags & XFS_RBMLOCK_SUMMARY)
+		xfs_iunlock(mp->m_rsumip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
+
+	if (rbmlock_flags & XFS_RBMLOCK_BITMAP)
+		xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+}
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 749c8e3ec4cb..f6a2a48973ab 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -279,6 +279,19 @@ xfs_suminfo_t xfs_suminfo_get(struct xfs_mount *mp,
 		union xfs_suminfo_ondisk *infoptr);
 void xfs_suminfo_add(struct xfs_mount *mp, union xfs_suminfo_ondisk *infoptr,
 		int delta);
+
+void xfs_rtbitmap_lock(struct xfs_trans *tp, struct xfs_mount *mp);
+void xfs_rtbitmap_unlock(struct xfs_mount *mp);
+
+/* Lock the rt bitmap inode in shared mode */
+#define XFS_RBMLOCK_BITMAP	(1U << 0)
+/* Lock the rt summary inode in shared mode */
+#define XFS_RBMLOCK_SUMMARY	(1U << 1)
+
+void xfs_rtbitmap_lock_shared(struct xfs_mount *mp,
+		unsigned int rbmlock_flags);
+void xfs_rtbitmap_unlock_shared(struct xfs_mount *mp,
+		unsigned int rbmlock_flags);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -295,6 +308,10 @@ xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 # define xfs_rtbitmap_wordcount(mp, r)			(0)
 # define xfs_rtsummary_blockcount(mp, l, b)		(0)
 # define xfs_rtsummary_wordcount(mp, l, b)		(0)
+# define xfs_rtbitmap_lock(tp, mp)		do { } while (0)
+# define xfs_rtbitmap_unlock(mp)		do { } while (0)
+# define xfs_rtbitmap_lock_shared(mp, lf)	do { } while (0)
+# define xfs_rtbitmap_unlock_shared(mp, lf)	do { } while (0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 4de13f8f4277..dadbe32916de 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -33,6 +33,7 @@
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_swapext.h"
+#include "xfs_rtbitmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 680b2e1d2940..043fb5777290 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -470,7 +470,7 @@ xchk_fscount_count_frextents(
 	if (!xfs_has_realtime(mp))
 		return 0;
 
-	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xfs_rtbitmap_lock_shared(sc->mp, XFS_RBMLOCK_BITMAP);
 	error = xfs_rtalloc_query_all(sc->mp, sc->tp,
 			xchk_fscount_add_frextent, fsc);
 	if (error) {
@@ -479,7 +479,7 @@ xchk_fscount_count_frextents(
 	}
 
 out_unlock:
-	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xfs_rtbitmap_unlock_shared(sc->mp, XFS_RBMLOCK_BITMAP);
 	return error;
 }
 #else
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 1bfdd31723f5..447c057c9331 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -131,10 +131,7 @@ xfs_bmap_rtalloc(
 	 * Lock out modifications to both the RT bitmap and summary inodes
 	 */
 	if (!rtlocked) {
-		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
-		xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
-		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
-		xfs_trans_ijoin(ap->tp, mp->m_rsumip, XFS_ILOCK_EXCL);
+		xfs_rtbitmap_lock(ap->tp, mp);
 		rtlocked = true;
 	}
 
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 8d0a6f480d2a..71053f840ea4 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -525,7 +525,7 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 	unsigned int			mod;
 	int				error;
 
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
 
 	/*
 	 * Set up query parameters to return free rtextents covering the range
@@ -551,7 +551,7 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 	if (error)
 		goto err;
 err:
-	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 674ca3dab72e..11bea1c60eda 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1081,10 +1081,10 @@ xfs_growfs_rt(
 		if (error)
 			break;
 		/*
-		 * Lock out other callers by grabbing the bitmap inode lock.
+		 * Lock out other callers by grabbing the bitmap and summary
+		 * inode locks and joining them to the transaction.
 		 */
-		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
-		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+		xfs_rtbitmap_lock(tp, mp);
 		/*
 		 * Update the bitmap inode's size ondisk and incore.  We need
 		 * to update the incore size so that inode inactivation won't
@@ -1094,11 +1094,6 @@ xfs_growfs_rt(
 			nsbp->sb_rbmblocks * nsbp->sb_blocksize;
 		i_size_write(VFS_I(mp->m_rbmip), mp->m_rbmip->i_disk_size);
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
-		/*
-		 * Get the summary inode into the transaction.
-		 */
-		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
-		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
 		/*
 		 * Update the summary inode's size.  We need to update the
 		 * incore size so that inode inactivation won't punch what it
@@ -1338,10 +1333,10 @@ xfs_rtalloc_reinit_frextents(
 	uint64_t		val = 0;
 	int			error;
 
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
 	error = xfs_rtalloc_query_all(mp, NULL, xfs_rtalloc_count_frextent,
 			&val);
-	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
 	if (error)
 		return error;
 

