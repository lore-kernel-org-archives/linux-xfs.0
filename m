Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59ECEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235815AbiLaBwF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbiLaBv7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:51:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E091DDDA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:51:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA397B81DFC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0297C433EF;
        Sat, 31 Dec 2022 01:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451515;
        bh=scSHGjMPdBNrFB1pSJcYoyuy1Bp4xm2RdsIQMVwOc2g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SrF2EmurpGN15XwA4hgDYcVdAnvscaoBHqyqQl4+86qZEqUlbwKr74QixecESwg4K
         9eX8CyGaDpGIFCWTFaC4QpWVX5W2MvZZY4ob1dO+9miHawlQ/LWbNC2FT66FRDJoxP
         rwmSfuNChAbN86hUXhvUUuYrFimHC6wtHt3KNqND9WIcnlnr8v4pmN2wfsKLhxs+DI
         FPscC/izyGpr44gHbFu0TP5hrQSfXgLBIx2dj1eppmz+vbb05+BjE34oq5aNWRBcxy
         yS42QcqMsqnQ/XHYQrPxl0j+vJSyPxWwdvocnQbohaFNcV1zHF+JsIgaWd/C8FE80u
         s4YRhNqWNv1cg==
Subject: [PATCH 15/42] xfs: create routine to allocate and initialize a
 realtime refcount btree inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871111.717073.3368219455039072884.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a library routine to allocate and initialize an empty realtime
refcountbt inode.  We'll use this for growfs, mkfs, and repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   41 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |    6 +++++
 2 files changed, 47 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index a43ee6d7b547..0a6fa9851371 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -765,3 +765,44 @@ xfs_iflush_rtrefcount(
 			ifp->if_broot_bytes, dfp,
 			XFS_DFORK_SIZE(dip, ip->i_mount, XFS_DATA_FORK));
 }
+
+/*
+ * Create a realtime refcount btree inode.
+ *
+ * Regardless of the return value, the caller must clean up @ic.  If a new
+ * inode is returned through *ipp, the caller must finish setting up the incore
+ * inode and release it.
+ */
+int
+xfs_rtrefcountbt_create(
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
+	ifp->if_format = XFS_DINODE_FMT_REFCOUNT;
+	ASSERT(ifp->if_broot_bytes == 0);
+	ASSERT(ifp->if_bytes == 0);
+
+	/* Initialize the empty incore btree root. */
+	xfs_iroot_alloc(ip, XFS_DATA_FORK,
+			xfs_rtrefcount_broot_space_calc(mp, 0, 0));
+	xfs_btree_init_block(ip->i_mount, ifp->if_broot, &xfs_rtrefcountbt_ops,
+			0, 0, ip->i_ino);
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
+
+	*ipp = ip;
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index d2fe2004568d..86a547529c9d 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -186,4 +186,10 @@ void xfs_rtrefcountbt_to_disk(struct xfs_mount *mp,
 		struct xfs_rtrefcount_root *dblock, int dblocklen);
 void xfs_iflush_rtrefcount(struct xfs_inode *ip, struct xfs_dinode *dip);
 
+struct xfs_imeta_update;
+
+int xfs_rtrefcountbt_create(struct xfs_trans **tpp,
+		struct xfs_imeta_path *path, struct xfs_imeta_update *ic,
+		struct xfs_inode **ipp);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */

