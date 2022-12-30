Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27483C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbiLaBJU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbiLaBJT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:09:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856861DDF0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:09:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2222261D33
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81433C433D2;
        Sat, 31 Dec 2022 01:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448957;
        bh=gb+Fy8Zpq48kdEHBJZl/5btK4yizTEHI3BtPJnDURKQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ooTzkpdqeGk1Il7q8KzyCas5e/Rm0KUsQSFP5m5fYp+9/UAE/vMgiVIjPiIUNT94O
         IPiO7X4wxcgf0XpKtjaztOrx5NcQwkEissvfLIVV/J2EBOBG1gL7Rg7QerOgrgDRbK
         tBuD5K/vsWXQe81xIFloi3B1aDSa+f8jGiSQUKvoUkXGlsBR2TL+Jdk5cRyqexSeBi
         4WZ3fRxY97WhihZ+xso32iWML/IyCykAJY2HcpdzBdkQT9KlT7rqPuW28E37yStXod
         K9WoRssQ84HTDCVy3ESXNcthWzO1K29SiP8kUb4yE6kozq+K+bbkB1WwfkLRJKD4c9
         XLvNYFSgC4JBA==
Subject: [PATCH 16/20] xfs: hoist inode free function to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:20 -0800
Message-ID: <167243864060.707335.16448396748632349504.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a libxfs helper function that marks an inode free on disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_util.c |   51 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    5 ++++
 fs/xfs/xfs_inode.c             |   35 +--------------------------
 3 files changed, 57 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index e32b3152c3df..1135bec1328b 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "xfs_iunlink_item.h"
+#include "xfs_inode_item.h"
 
 uint16_t
 xfs_flags2diflags(
@@ -645,3 +646,53 @@ xfs_bumplink(
 	inc_nlink(VFS_I(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
+
+/* Mark an inode free on disk. */
+int
+xfs_dir_ifree(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip,
+	struct xfs_icluster	*xic)
+{
+	int			error;
+
+	/*
+	 * Free the inode first so that we guarantee that the AGI lock is going
+	 * to be taken before we remove the inode from the unlinked list. This
+	 * makes the AGI lock -> unlinked list modification order the same as
+	 * used in O_TMPFILE creation.
+	 */
+	error = xfs_difree(tp, pag, ip->i_ino, xic);
+	if (error)
+		return error;
+
+	error = xfs_iunlink_remove(tp, pag, ip);
+	if (error)
+		return error;
+
+	/*
+	 * Free any local-format data sitting around before we reset the
+	 * data fork to extents format.  Note that the attr fork data has
+	 * already been freed by xfs_attr_inactive.
+	 */
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		kmem_free(ip->i_df.if_u1.if_data);
+		ip->i_df.if_u1.if_data = NULL;
+		ip->i_df.if_bytes = 0;
+	}
+
+	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
+	ip->i_diflags = 0;
+	ip->i_diflags2 = ip->i_mount->m_ino_geo.new_diflags2;
+	ip->i_forkoff = 0;		/* mark the attr fork not in use */
+	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
+
+	/*
+	 * Bump the generation count so no one will be confused
+	 * by reincarnations of this inode.
+	 */
+	VFS_I(ip)->i_generation++;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index f92b14a6fbe8..fcddaa6f738c 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_INODE_UTIL_H__
 #define	__XFS_INODE_UTIL_H__
 
+struct xfs_icluster;
+
 uint16_t	xfs_flags2diflags(struct xfs_inode *ip, unsigned int xflags);
 uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
 uint32_t	xfs_dic2xflags(struct xfs_inode *ip);
@@ -56,6 +58,9 @@ void xfs_trans_ichgtime(struct xfs_trans *tp, struct xfs_inode *ip, int flags);
 void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 		struct xfs_inode *ip);
 
+int xfs_dir_ifree(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip, struct xfs_icluster *xic);
+
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e2563401b27d..8bd9d47bf6fa 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1886,36 +1886,10 @@ xfs_ifree(
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
-	/*
-	 * Free the inode first so that we guarantee that the AGI lock is going
-	 * to be taken before we remove the inode from the unlinked list. This
-	 * makes the AGI lock -> unlinked list modification order the same as
-	 * used in O_TMPFILE creation.
-	 */
-	error = xfs_difree(tp, pag, ip->i_ino, &xic);
+	error = xfs_dir_ifree(tp, pag, ip, &xic);
 	if (error)
 		goto out;
 
-	error = xfs_iunlink_remove(tp, pag, ip);
-	if (error)
-		goto out;
-
-	/*
-	 * Free any local-format data sitting around before we reset the
-	 * data fork to extents format.  Note that the attr fork data has
-	 * already been freed by xfs_attr_inactive.
-	 */
-	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
-		kmem_free(ip->i_df.if_u1.if_data);
-		ip->i_df.if_u1.if_data = NULL;
-		ip->i_df.if_bytes = 0;
-	}
-
-	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
-	ip->i_diflags = 0;
-	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
-	ip->i_forkoff = 0;		/* mark the attr fork not in use */
-	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 	if (xfs_iflags_test(ip, XFS_IPRESERVE_DM_FIELDS))
 		xfs_iflags_clear(ip, XFS_IPRESERVE_DM_FIELDS);
 
@@ -1924,13 +1898,6 @@ xfs_ifree(
 	iip->ili_fields &= ~(XFS_ILOG_AOWNER | XFS_ILOG_DOWNER);
 	spin_unlock(&iip->ili_lock);
 
-	/*
-	 * Bump the generation count so no one will be confused
-	 * by reincarnations of this inode.
-	 */
-	VFS_I(ip)->i_generation++;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
 	if (xic.deleted)
 		error = xfs_ifree_cluster(tp, pag, ip, &xic);
 out:

