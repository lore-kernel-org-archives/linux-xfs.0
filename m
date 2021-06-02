Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59751C47083
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CFE26138C
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhFBW1E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFBW1D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:27:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78A916138C;
        Wed,  2 Jun 2021 22:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672719;
        bh=DgudiMREF3dwq9P2CbKEGby5TiqqFgF6nUy082uP8PI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rL1PqklRXqXCQHj0ycUj+IJcdMnumklD4D3z2U1Kz831KB1usqSlh3e9TpTfbwWq5
         vRwIF/DqR9coSLA2BLv8Jl+erYPxJ4nMm5nFwN5c3mKGGGrJsl4ulOvStQv3fE3Kj8
         C5aqthrer9BG+VrWCPqukqe+34NLlGgG4aGsTMKU+JAEI7NroYSKKqgOvAfEuEe6I+
         zcbxCl0NhXmDDNsXn/PoGotIkOAyCm0KLWn/jHZP4kEUAnoQXgcYFLeodpslTexpff
         2+uadj+Ya6/PB0FjGXOZlPj7EPU+/ml91HH/E8l1eurUKO8D2Tq+79aCA37xdu23hH
         xJIlxNy2mVYog==
Subject: [PATCH 04/15] xfs: rename xfs_inode_walk functions to xfs_icwalk
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:25:19 -0700
Message-ID: <162267271913.2375284.4758622992711446717.stgit@locust>
In-Reply-To: <162267269663.2375284.15885514656776142361.stgit@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Shorten the prefix so that all the incore walk code has "xfs_icwalk" in
the name somewhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 55c55e449cab..d5ecd4cd3ef5 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -26,10 +26,10 @@
 
 #include <linux/iversion.h>
 
-static int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
+static int xfs_icwalk(struct xfs_mount *mp, int iter_flags,
 		int (*execute)(struct xfs_inode *ip, void *args),
 		void *args, int tag);
-static int xfs_inode_walk_ag(struct xfs_perag *pag, int iter_flags,
+static int xfs_icwalk_ag(struct xfs_perag *pag, int iter_flags,
 		int (*execute)(struct xfs_inode *ip, void *args),
 		void *args, int tag);
 
@@ -740,7 +740,7 @@ xfs_icache_inode_is_allocated(
  * lookup reduction and stack usage. This is in the reclaim path, so we can't
  * be too greedy.
  *
- * XXX: This will be moved closer to xfs_inode_walk* once we get rid of the
+ * XXX: This will be moved closer to xfs_icwalk* once we get rid of the
  * separate reclaim walk functions.
  */
 #define XFS_LOOKUP_BATCH	32
@@ -790,7 +790,7 @@ xfs_dqrele_all_inodes(
 	if (qflags & XFS_PQUOTA_ACCT)
 		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_PDQUOT;
 
-	return xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
+	return xfs_icwalk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
 			&eofb, XFS_ICI_NO_TAG);
 }
 #endif /* CONFIG_XFS_QUOTA */
@@ -1538,7 +1538,7 @@ xfs_blockgc_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	error = xfs_inode_walk_ag(pag, 0, xfs_blockgc_scan_inode, NULL,
+	error = xfs_icwalk_ag(pag, 0, xfs_blockgc_scan_inode, NULL,
 			XFS_ICI_BLOCKGC_TAG);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
@@ -1557,7 +1557,7 @@ xfs_blockgc_free_space(
 {
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_inode_walk(mp, 0, xfs_blockgc_scan_inode, eofb,
+	return xfs_icwalk(mp, 0, xfs_blockgc_scan_inode, eofb,
 			XFS_ICI_BLOCKGC_TAG);
 }
 
@@ -1634,7 +1634,7 @@ xfs_blockgc_free_quota(
  * inodes with the given radix tree @tag.
  */
 static int
-xfs_inode_walk_ag(
+xfs_icwalk_ag(
 	struct xfs_perag	*pag,
 	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
@@ -1740,7 +1740,7 @@ xfs_inode_walk_ag(
 
 /* Fetch the next (possibly tagged) per-AG structure. */
 static inline struct xfs_perag *
-xfs_inode_walk_get_perag(
+xfs_icwalk_get_perag(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	int			tag)
@@ -1755,7 +1755,7 @@ xfs_inode_walk_get_perag(
  * @tag.
  */
 static int
-xfs_inode_walk(
+xfs_icwalk(
 	struct xfs_mount	*mp,
 	int			iter_flags,
 	int			(*execute)(struct xfs_inode *ip, void *args),
@@ -1767,9 +1767,9 @@ xfs_inode_walk(
 	int			last_error = 0;
 	xfs_agnumber_t		agno = 0;
 
-	while ((pag = xfs_inode_walk_get_perag(mp, agno, tag))) {
+	while ((pag = xfs_icwalk_get_perag(mp, agno, tag))) {
 		agno = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
+		error = xfs_icwalk_ag(pag, iter_flags, execute, args, tag);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;

