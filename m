Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89364C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BAC56101B
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbhJLXfb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:35:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235893AbhJLXfb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:35:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22F2D60EB6;
        Tue, 12 Oct 2021 23:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081609;
        bh=pEcAaTs9Uwi0IDiRSEBncOKYvUCukqs6d2HDdfMf4r8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NX/EsCjgzZeQc6hPY5qQHlYS/0a7IfhvG+0IxSis2Io8G7ypbgPojUY3aoHiYHx74
         1Po6Fm+sSgDv3mNZZZh0BBln6qp4LlSUUbMvTSczKP4XZlzHUti0t7z1PioU3QwBIN
         8OPu7zKcDajjg4rw3jLxoDrTEsBZ3zNWZfAvlgvDluYE3STayHgH5WCpUJWPn9TdFb
         5euHYF6aR+v4VjBoXehOIjPFcO1VHbogiSsWZG2cHACMAhww5Mqqe6Ozr4iD/S7UbW
         lIioKAvQFdNmz/hzoAlBAN9Tc1jdoklBUoLvwBuvAf+3q62Qbhp4Clay2n8gaFDfuW
         eYPxO6y/pnzcw==
Subject: [PATCH 10/15] xfs: compute actual maximum btree height for critical
 reservation calculation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:33:28 -0700
Message-ID: <163408160882.4151249.14701173486144926020.stgit@magnolia>
In-Reply-To: <163408155346.4151249.8364703447365270670.stgit@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Compute the actual maximum btree height when deciding if per-AG block
reservation is critically low.  This only affects the sanity check
condition, since we /generally/ will trigger on the 10% threshold.
This is a long-winded way of saying that we're removing one more
usage of XFS_BTREE_MAXLEVELS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag_resv.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 2aa2b3484c28..d34d4614f175 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -60,6 +60,20 @@
  * to use the reservation system should update ask/used in xfs_ag_resv_init.
  */
 
+/* Compute maximum possible height for per-AG btree types for this fs. */
+static unsigned int
+xfs_ag_btree_maxlevels(
+	struct xfs_mount	*mp)
+{
+	unsigned int		ret = mp->m_ag_maxlevels;
+
+	ret = max(ret, mp->m_bm_maxlevels[XFS_DATA_FORK]);
+	ret = max(ret, mp->m_bm_maxlevels[XFS_ATTR_FORK]);
+	ret = max(ret, M_IGEO(mp)->inobt_maxlevels);
+	ret = max(ret, mp->m_rmap_maxlevels);
+	return max(ret, mp->m_refc_maxlevels);
+}
+
 /*
  * Are we critically low on blocks?  For now we'll define that as the number
  * of blocks we can get our hands on being less than 10% of what we reserved
@@ -72,6 +86,7 @@ xfs_ag_resv_critical(
 {
 	xfs_extlen_t			avail;
 	xfs_extlen_t			orig;
+	xfs_extlen_t			btree_maxlevels;
 
 	switch (type) {
 	case XFS_AG_RESV_METADATA:
@@ -91,7 +106,8 @@ xfs_ag_resv_critical(
 	trace_xfs_ag_resv_critical(pag, type, avail);
 
 	/* Critically low if less than 10% or max btree height remains. */
-	return XFS_TEST_ERROR(avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS,
+	btree_maxlevels = xfs_ag_btree_maxlevels(pag->pag_mount);
+	return XFS_TEST_ERROR(avail < orig / 10 || avail < btree_maxlevels,
 			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL);
 }
 

