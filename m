Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4ABC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A3060FBF
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhIRBbl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234976AbhIRBbi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E458E6112E;
        Sat, 18 Sep 2021 01:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928616;
        bh=Cxj1cGQ5vwazVeHYmrjlibKlT7ggUBVTm3vRlZTryeo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MhgMoZZtoHS62mHuWeu6Fv2qg8KHAPzz0YhsuIGmUr+GLcDflTBIo6T657NEevBrq
         V/wSoZtDqUup7L9EkUPT0lE4FyFRwA4wN0hKi6dMoT9UShl+DWnZ3N04abmICYbQEd
         s+BvhNvclwi1NZpBESAFNNeoIAlfEhI1s2ZX7o7DgZxfGORtiX34JRhcNkUISMv92Q
         OaadiPpbqxQKxF688wu2tLUmWcLIZsPY2SC6V6opULFHOpnzjWKNCesxmq0/VZfwTS
         0MZ1D8+3IthccIkD912c5QNkoxIUp+t3U2HXC+ms5ZfvOzpqrzz+FqWNYYKjSy6Ar2
         mh3bRkRBjbrxA==
Subject: [PATCH 12/14] xfs: compute actual maximum btree height for critical
 reservation calculation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:30:15 -0700
Message-ID: <163192861564.416199.12921575958749918045.stgit@magnolia>
In-Reply-To: <163192854958.416199.3396890438240296942.stgit@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_ag_resv.c |    4 +++-
 fs/xfs/libxfs/xfs_btree.c   |   19 +++++++++++++++----
 fs/xfs/libxfs/xfs_btree.h   |    1 +
 3 files changed, 19 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 2aa2b3484c28..931481fbdd72 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -72,6 +72,7 @@ xfs_ag_resv_critical(
 {
 	xfs_extlen_t			avail;
 	xfs_extlen_t			orig;
+	xfs_extlen_t			btree_maxlevels;
 
 	switch (type) {
 	case XFS_AG_RESV_METADATA:
@@ -91,7 +92,8 @@ xfs_ag_resv_critical(
 	trace_xfs_ag_resv_critical(pag, type, avail);
 
 	/* Critically low if less than 10% or max btree height remains. */
-	return XFS_TEST_ERROR(avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS,
+	btree_maxlevels = xfs_btree_maxlevels(pag->pag_mount, XFS_BTNUM_MAX);
+	return XFS_TEST_ERROR(avail < orig / 10 || avail < btree_maxlevels,
 			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL);
 }
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index f9516828a847..6cf49f7e1299 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4922,12 +4922,17 @@ xfs_btree_has_more_records(
 		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
 }
 
-/* Compute the maximum allowed height for a given btree type. */
-static unsigned int
+/*
+ * Compute the maximum allowed height for a given btree type.  If XFS_BTNUM_MAX
+ * is passed in, the maximum allowed height for all btree types is returned.
+ */
+unsigned int
 xfs_btree_maxlevels(
 	struct xfs_mount	*mp,
 	xfs_btnum_t		btnum)
 {
+	unsigned int		ret;
+
 	switch (btnum) {
 	case XFS_BTNUM_BNO:
 	case XFS_BTNUM_CNT:
@@ -4943,9 +4948,15 @@ xfs_btree_maxlevels(
 	case XFS_BTNUM_REFC:
 		return mp->m_refc_maxlevels;
 	default:
-		ASSERT(0);
-		return XFS_BTREE_MAXLEVELS;
+		break;
 	}
+
+	ret = mp->m_ag_maxlevels;
+	ret = max(ret, mp->m_bm_maxlevels[XFS_DATA_FORK]);
+	ret = max(ret, mp->m_bm_maxlevels[XFS_ATTR_FORK]);
+	ret = max(ret, M_IGEO(mp)->inobt_maxlevels);
+	ret = max(ret, mp->m_rmap_maxlevels);
+	return max(ret, mp->m_refc_maxlevels);
 }
 
 /* Allocate a new btree cursor of the appropriate size. */
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index ae83fbf58c18..106760c540c7 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -574,5 +574,6 @@ void xfs_btree_copy_keys(struct xfs_btree_cur *cur,
 		const union xfs_btree_key *src_key, int numkeys);
 struct xfs_btree_cur *xfs_btree_alloc_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, xfs_btnum_t btnum);
+unsigned int xfs_btree_maxlevels(struct xfs_mount *mp, xfs_btnum_t btnum);
 
 #endif	/* __XFS_BTREE_H__ */

