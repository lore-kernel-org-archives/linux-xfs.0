Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFE3C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiLaC5T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbiLaC5S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:57:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6794192B7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:57:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7385961CD1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE4DC433EF;
        Sat, 31 Dec 2022 02:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455436;
        bh=g3ZSTTD8ct2jeaJKGbhhVsELS8zMe5benfCVTL493sw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BqiyhH+ufiisGzBNZfR3Nlv/oA9fptMAl02pPV7jRZl8PDiBiVUmPb2z1D7gXYXxj
         gPAVv35Ze2sIoGdIDHV7mn95D1ffYdbnj3cQrtd0WQcy05/ReiwGymos5kdTLz1rRw
         nWa19dEN+l5pK/l3bbecriKjCWlWViFVMuXjqbwg7wUdHqYTR1UdDyzf566L4UmDUw
         XHPkyc8FCCdAqtNgnUJC+vuU9rxkMs0UgtrTVXsyTTtw1s+ztrm3N307eiBR+BMmkT
         4xOFPysykZXbhSbXUKEE53H+9+OPbdiBgL6zTFO6BYl618XOK6KWHVYvK8t3KNWCmS
         sDifF8kfHkZuw==
Subject: [PATCH 12/41] xfs: create routine to allocate and initialize a
 realtime refcount btree inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:09 -0800
Message-ID: <167243880928.734096.8253842279528997937.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
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
 libxfs/xfs_rtrefcount_btree.c |   41 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrefcount_btree.h |    6 ++++++
 2 files changed, 47 insertions(+)


diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 2c9fbab5159..5e9930d315c 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -763,3 +763,44 @@ xfs_iflush_rtrefcount(
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
diff --git a/libxfs/xfs_rtrefcount_btree.h b/libxfs/xfs_rtrefcount_btree.h
index d2fe2004568..86a547529c9 100644
--- a/libxfs/xfs_rtrefcount_btree.h
+++ b/libxfs/xfs_rtrefcount_btree.h
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

