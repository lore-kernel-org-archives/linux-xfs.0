Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A714DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbiLaCqC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLaCp4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:45:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93DE8FE9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:45:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74EB3B81E65
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF7AC433D2;
        Sat, 31 Dec 2022 02:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454752;
        bh=byQJrduyLcrzMRjehp/SSqonzjujxbw1KKWJu4zNw/s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hGA29c4MAm4MSs74k1uIzIukO+vL7ZRsPLPLbzjHpTN0gECuTrLwseudqAy/Hm/0l
         EsoL/jg/lsrmQ7bL77hpuH3CIku/PrnlLtpQ1Bb2di1gEKUjSH613BCC34F2G18bBS
         EVMEtK+jhJVGjobdqxGov76a+LKyVagPTv4Wo7SWnqamG+ETQyMHZjyFTjlf3Cp1Yn
         X4tBBNMLihrwQxtlFM6t7uatKmyq360CwFGmffq5sCCXzMN/mUau8+0VdHcCeyYMJZ
         HoMVConrnHrft+O1YdRB19AzXLAuQY+q3a8IBjRhqGnWx8Im+sRNWdX6HaMD/PtM4U
         DL5Fr3dQ3QQNA==
Subject: [PATCH 13/41] xfs: create routine to allocate and initialize a
 realtime rmap btree inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:57 -0800
Message-ID: <167243879769.732820.16336764988216674471.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a library routine to allocate and initialize an empty realtime
rmapbt inode.  We'll use this for growfs, mkfs, and repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtrmap_btree.c |   41 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |    5 +++++
 2 files changed, 46 insertions(+)


diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index f92815b08a2..38f0b8567a6 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -865,3 +865,44 @@ xfs_iflush_rtrmap(
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
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index 6917a31bfe0..046a6081673 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -198,4 +198,9 @@ void xfs_rtrmapbt_to_disk(struct xfs_mount *mp, struct xfs_btree_block *rblock,
 		unsigned int dblocklen);
 void xfs_iflush_rtrmap(struct xfs_inode *ip, struct xfs_dinode *dip);
 
+struct xfs_imeta_update;
+
+int xfs_rtrmapbt_create(struct xfs_trans **tpp, struct xfs_imeta_path *path,
+		struct xfs_imeta_update *ic, struct xfs_inode **ipp);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */

