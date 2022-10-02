Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75507C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiJBSaS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiJBSaR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196E420346
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9F9260F04
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113B7C433C1;
        Sun,  2 Oct 2022 18:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735415;
        bh=PpXG4l6BXlQkBskfQ5nijB5TjOog/xwQYSlgiERXaIw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SnxWspXYMfyr9hq+S7H9Dm3WhgmSmUNJ+OKd6eZe7/+IbYqtJexFXypUBPr6bb0KD
         jYoygFyYWx0FWDHnGCyv9PVyIzScfDtwMIut4CdD/emxbnIjpCm86Qp7Ha90czyLQF
         EVzKc8EoayUmf0J+4oSz9DKgPyqZ+7dGBZrTdZSX/MDQXQ+wujtOrW9N+9AVNz07dL
         QheWm1wXNnq+scRHzI+r8sxxEMF66cN2s5Zkr3XHVAM50zQ1EKyG5i/kIJnoUEH9/x
         Om5XbBBBtD5A0npBhwkLaXpS7u2Z/k6lf1Ml1TuYzO5KxseQwvoKa1+LKJd0BntgAd
         CQEm8ovr7biZA==
Subject: [PATCH 1/2] xfs: load rtbitmap and rtsummary extent mapping btrees at
 mount time
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:02 -0700
Message-ID: <166473480249.1083697.13081552727850377113.stgit@magnolia>
In-Reply-To: <166473480232.1083697.18352887736798889545.stgit@magnolia>
References: <166473480232.1083697.18352887736798889545.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It turns out that GETFSMAP and online fsck have had a bug for years due
to their use of ILOCK_SHARED to coordinate their linear scans of the
realtime bitmap.  If the bitmap file's data fork happens to be in BTREE
format and the scan occurs immediately after mounting, the incore bmbt
will not be populated, leading to ASSERTs tripping over the incorrect
inode state.  Because the bitmap scans always lock bitmap buffers in
increasing order of file offset, it is appropriate for these two callers
to take a shared ILOCK to improve scalability.

To fix this problem, load both data and attr fork state into memory when
mounting the realtime inodes.  Realtime metadata files aren't supposed
to have an attr fork so the second step is likely a nop.

On most filesystems this is unlikely since the rtbitmap data fork is
usually in extents format, but it's possible to craft a filesystem that
will by fragmenting the free space in the data section and growfsing the
rt section.

Fixes: 4c934c7dd60c ("xfs: report realtime space information via the rtbitmap")
Also-Fixes: 46d9bfb5e706 ("xfs: cross-reference the realtime bitmap")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 292d5e54a92c..b0846204c436 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1325,6 +1325,41 @@ xfs_rtalloc_reinit_frextents(
 	return 0;
 }
 
+/*
+ * Read in the bmbt of an rt metadata inode so that we never have to load them
+ * at runtime.  This enables the use of shared ILOCKs for rtbitmap scans.  Use
+ * an empty transaction to avoid deadlocking on loops in the bmbt.
+ */
+static inline int
+xfs_rtmount_iread_extents(
+	struct xfs_inode	*ip,
+	unsigned int		lock_class)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc_empty(ip->i_mount, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL | lock_class);
+
+	error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
+	if (error)
+		goto out_unlock;
+
+	if (xfs_inode_has_attr_fork(ip)) {
+		error = xfs_iread_extents(tp, ip, XFS_ATTR_FORK);
+		if (error)
+			goto out_unlock;
+	}
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL | lock_class);
+	xfs_trans_cancel(tp);
+	return error;
+}
+
 /*
  * Get the bitmap and summary inodes and the summary cache into the mount
  * structure at mount time.
@@ -1342,14 +1377,27 @@ xfs_rtmount_inodes(
 		return error;
 	ASSERT(mp->m_rbmip != NULL);
 
+	error = xfs_rtmount_iread_extents(mp->m_rbmip, XFS_ILOCK_RTBITMAP);
+	if (error)
+		goto out_rele_bitmap;
+
 	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
-	if (error) {
-		xfs_irele(mp->m_rbmip);
-		return error;
-	}
+	if (error)
+		goto out_rele_bitmap;
 	ASSERT(mp->m_rsumip != NULL);
+
+	error = xfs_rtmount_iread_extents(mp->m_rsumip, XFS_ILOCK_RTSUM);
+	if (error)
+		goto out_rele_summary;
+
 	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
 	return 0;
+
+out_rele_summary:
+	xfs_irele(mp->m_rsumip);
+out_rele_bitmap:
+	xfs_irele(mp->m_rbmip);
+	return error;
 }
 
 void

