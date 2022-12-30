Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43DE1C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbiLaBlT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbiLaBlS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:41:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F3B26D2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:41:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FD2661C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AA0C433EF;
        Sat, 31 Dec 2022 01:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450876;
        bh=bpsxLlA9UrZheMn2UP24dl5HxG0Ic/pudPCYxoERVW8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ou5rfoG/53j37KU3mJAgTXkQPPdGbeAQwTb7MRQ9jii/gvb7oJJxegDcseuP7L3Xa
         okC1hckWE4a0+Ym1DXJkVSNAyc/P2qa/mmDoHNpsIuhedT3VZUWwcBvf+7J299zqZT
         TY2Zi3d2zrwOc//Km2NZU179xhd0Vr1Z0H/uCjpOwGp1Ka9wlyHJ8oFXFOiUAM+cNi
         Ilyf+m3JEseX12CoxJaSYidWwAg+08Ibyl2YmGStaxfxEAd0t92AbeadokOw/BSGGp
         M9cgWjHopXTL6p9Tux0RqfJ8D8jCHNgsOeL3G0nCrAaei0KNbf/YXteHf6NKDe/LVx
         OhfIvINOzXYJw==
Subject: [PATCH 17/38] xfs: create routine to allocate and initialize a
 realtime rmap btree inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:18 -0800
Message-ID: <167243869841.715303.1721205201463684435.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a library routine to allocate and initialize an empty realtime
rmapbt inode.  We'll use this for mkfs and repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   42 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    5 +++++
 2 files changed, 47 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index a099f33f26ab..9181fca2ba54 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -27,6 +27,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
+#include "xfs_imeta.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -867,3 +868,44 @@ xfs_iflush_rtrmap(
 	xfs_rtrmapbt_to_disk(ip->i_mount, ifp->if_broot, ifp->if_broot_bytes,
 			dfp, XFS_DFORK_SIZE(dip, ip->i_mount, XFS_DATA_FORK));
 }
+
+/*
+ * Create a realtime rmap btree inode.
+ *
+ * Regardless of the return value, the caller must clean up @ic.  If a new
+ * inode is returned through *ipp, the caller must finish setting up the incore
+ * inode and release it.
+ */
+int
+xfs_rtrmapbt_create(
+	struct xfs_trans	**tpp,
+	struct xfs_imeta_path	*path,
+	struct xfs_imeta_update	*upd,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = (*tpp)->t_mountp;
+	struct xfs_ifork	*ifp;
+	struct xfs_inode	*ip;
+	int			error;
+
+	*ipp = NULL;
+
+	error = xfs_imeta_create(tpp, path, S_IFREG, 0, &ip, upd);
+	if (error)
+		return error;
+
+	ifp = &ip->i_df;
+	ifp->if_format = XFS_DINODE_FMT_RMAP;
+	ASSERT(ifp->if_broot_bytes == 0);
+	ASSERT(ifp->if_bytes == 0);
+
+	/* Initialize the empty incore btree root. */
+	xfs_iroot_alloc(ip, XFS_DATA_FORK,
+			xfs_rtrmap_broot_space_calc(mp, 0, 0));
+	xfs_btree_init_block(mp, ifp->if_broot, &xfs_rtrmapbt_ops, 0, 0,
+			ip->i_ino);
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
+
+	*ipp = ip;
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 6917a31bfe0c..046a60816736 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -198,4 +198,9 @@ void xfs_rtrmapbt_to_disk(struct xfs_mount *mp, struct xfs_btree_block *rblock,
 		unsigned int dblocklen);
 void xfs_iflush_rtrmap(struct xfs_inode *ip, struct xfs_dinode *dip);
 
+struct xfs_imeta_update;
+
+int xfs_rtrmapbt_create(struct xfs_trans **tpp, struct xfs_imeta_path *path,
+		struct xfs_imeta_update *ic, struct xfs_inode **ipp);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */

