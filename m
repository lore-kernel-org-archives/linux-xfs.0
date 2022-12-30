Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C67BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236120AbiLaCDc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbiLaCDV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:03:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2082AF8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:03:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB09261C19
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28436C433EF;
        Sat, 31 Dec 2022 02:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452200;
        bh=c8807y3+Q+eEQuHSZ/lACy9JdnM+skcHahQLpjbPyHw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sIVjwoEJ6ibdZYCdIw3ftE50hAfzNRZHLo1qbIFxhOxrc223x3atzbNv3SgG4I5dP
         Cfg8A5TAH36n1ga4z574Ooh/heARYnJYpr8NbEMOteB12aJqilClLR+Ag5o57CEosE
         uDF0heLdIfjzx2fg5YqcVNaWhJqaJQ1hFnhLY13zkuKT51VgfNPoKpFLblDDKycWLt
         TxSQCLTWI6RfRCuxx+zb16WpROMz6rsbZX3aM4m4j7MlLk4uWGtCM5i5mUMWBmhOBr
         OYzdqV2giUqke25kZl9GUwBEspM+FmKvB9XsWLiCOSfIREA9gh/ta6utPpFujY50ZL
         TfBd1lgbhFiBg==
Subject: [PATCH 01/26] xfs: hoist extent size helpers to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:13 -0800
Message-ID: <167243875339.723621.2360895558110300051.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the extent size helpers to xfs_bmap.c in libxfs since they're used
there already.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h  |    7 +++++++
 libxfs/libxfs_priv.h |    2 --
 libxfs/xfs_bmap.c    |   41 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_bmap.h    |    3 +++
 4 files changed, 51 insertions(+), 2 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 489fd7d107d..3bc5aa2c7cb 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -237,6 +237,11 @@ static inline bool xfs_inode_has_bigrtextents(struct xfs_inode *ip)
 	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
 }
 
+static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
+{
+	return false;
+}
+
 /* Always set the child's GID to this value, even if the parent is setgid. */
 #define CRED_FORCE_GID	(1U << 0)
 struct cred {
@@ -262,4 +267,6 @@ extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 				uint, struct xfs_inode **);
 extern void	libxfs_irele(struct xfs_inode *ip);
 
+#define XFS_DEFAULT_COWEXTSZ_HINT 32
+
 #endif /* __XFS_INODE_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 63bc6ea7c2b..716e711cde4 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -508,8 +508,6 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 
 #define xfs_rotorstep				1
 #define xfs_bmap_rtalloc(a)			(-ENOSYS)
-#define xfs_get_extsz_hint(ip)			(0)
-#define xfs_get_cowextsz_hint(ip)		(0)
 #define xfs_inode_is_filestream(ip)		(0)
 #define xfs_filestream_lookup_ag(ip)		(0)
 #define xfs_filestream_new_ag(ip,ag)		(0)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index f2af8a012a9..c4a81537ccf 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6406,3 +6406,44 @@ xfs_bmap_query_all(
 
 	return xfs_btree_query_all(cur, xfs_bmap_query_range_helper, &query);
 }
+
+/* Helper function to extract extent size hint from inode */
+xfs_extlen_t
+xfs_get_extsz_hint(
+	struct xfs_inode	*ip)
+{
+	/*
+	 * No point in aligning allocations if we need to COW to actually
+	 * write to them.
+	 */
+	if (xfs_is_always_cow_inode(ip))
+		return 0;
+	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
+		return ip->i_extsize;
+	if (XFS_IS_REALTIME_INODE(ip))
+		return ip->i_mount->m_sb.sb_rextsize;
+	return 0;
+}
+
+/*
+ * Helper function to extract CoW extent size hint from inode.
+ * Between the extent size hint and the CoW extent size hint, we
+ * return the greater of the two.  If the value is zero (automatic),
+ * use the default size.
+ */
+xfs_extlen_t
+xfs_get_cowextsz_hint(
+	struct xfs_inode	*ip)
+{
+	xfs_extlen_t		a, b;
+
+	a = 0;
+	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
+		a = ip->i_cowextsize;
+	b = xfs_get_extsz_hint(ip);
+
+	a = max(a, b);
+	if (a == 0)
+		return XFS_DEFAULT_COWEXTSZ_HINT;
+	return a;
+}
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 9559f7174bb..d870c6a62e4 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -292,4 +292,7 @@ typedef int (*xfs_bmap_query_range_fn)(
 int xfs_bmap_query_all(struct xfs_btree_cur *cur, xfs_bmap_query_range_fn fn,
 		void *priv);
 
+xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
+xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
+
 #endif	/* __XFS_BMAP_H__ */

