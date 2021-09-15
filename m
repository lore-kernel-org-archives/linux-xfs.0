Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F7EC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97CC1610E8
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhIOXL2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:11:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOXL1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EEAC610A6;
        Wed, 15 Sep 2021 23:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747408;
        bh=RHZDUuCtkVfl0Wz2ePRGYMcYeSirR0Hugc2Sutu3TFk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Qb3sBe5jlNqa0UTx8MhcB/qWrga4bp/AUUimoR3aMO2D94RdYed+q9ZFkF3waeWTz
         LwdzcD7JvfdFTC8wkQkyZaMIBkCdjAl6TEAVK82MQRdu5Vht1j3C4LmgywJFCosbEV
         WBo4E0w1/PDFyQ4A/PqtLj9VlYrUtTU+JnznwtbYA/Kr1ktefazZyBkUCKxbwpZriZ
         85LHEVzSS/I88Zns/V0heeRyJ2Gh2fopiUlfTI1rDMmIPguw6X3u9hU4lEXDt2VACM
         +047FLuDjnU6TTDoOOVfQDqqDPVGixG1zVjwkL3lmUZHkeqMSxqLZcVEqkfhCsqbnZ
         qeI4P/pY4I95g==
Subject: [PATCH 39/61] xfs: get rid of xfs_dir_ialloc()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:10:07 -0700
Message-ID: <163174740780.350433.16571266852111030872.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: b652afd937033911944d7f681f2031b006961f1d

This is just a simple wrapper around the per-ag inode allocation
that doesn't need to exist. The internal mechanism to select and
allocate within an AG does not need to be exposed outside
xfs_ialloc.c, and it being exposed simply makes it harder to follow
the code and simplify it.

This is simplified by internalising xf_dialloc_select_ag() and
xfs_dialloc_ag() into a single xfs_dialloc() function and then
xfs_dir_ialloc() can go away.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/util.c       |   12 +-----------
 libxfs/xfs_ialloc.c |   17 ++++++++++-------
 libxfs/xfs_ialloc.h |   27 ++++-----------------------
 3 files changed, 15 insertions(+), 41 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index f8ea3d2a..905f1784 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -514,7 +514,6 @@ libxfs_dir_ialloc(
 	struct fsxattr		*fsx,
 	struct xfs_inode	**ipp)
 {
-	struct xfs_buf		*agibp;
 	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
 	xfs_ino_t		ino;
 	int			error;
@@ -523,19 +522,10 @@ libxfs_dir_ialloc(
 	 * Call the space management code to pick the on-disk inode to be
 	 * allocated.
 	 */
-	error = xfs_dialloc_select_ag(tpp, parent_ino, mode, &agibp);
+	error = xfs_dialloc(tpp, parent_ino, mode, &ino);
 	if (error)
 		return error;
 
-	if (!agibp)
-		return -ENOSPC;
-
-	/* Allocate an inode from the selected AG */
-	error = xfs_dialloc_ag(*tpp, agibp, parent_ino, &ino);
-	if (error)
-		return error;
-	ASSERT(ino != NULLFSINO);
-
 	return libxfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, cr,
 				fsx, ipp);
 }
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 573a7804..b133b2ed 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1423,7 +1423,7 @@ xfs_dialloc_ag_update_inobt(
  * The caller selected an AG for us, and made sure that free inodes are
  * available.
  */
-int
+static int
 xfs_dialloc_ag(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
@@ -1597,24 +1597,23 @@ xfs_ialloc_next_ag(
  * can be allocated, -ENOSPC be returned.
  */
 int
-xfs_dialloc_select_ag(
+xfs_dialloc(
 	struct xfs_trans	**tpp,
 	xfs_ino_t		parent,
 	umode_t			mode,
-	struct xfs_buf		**IO_agbp)
+	xfs_ino_t		*new_ino)
 {
 	struct xfs_mount	*mp = (*tpp)->t_mountp;
 	struct xfs_buf		*agbp;
 	xfs_agnumber_t		agno;
-	int			error;
+	int			error = 0;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	bool			okalloc = true;
 	int			needspace;
 	int			flags;
-
-	*IO_agbp = NULL;
+	xfs_ino_t		ino;
 
 	/*
 	 * Directories, symlinks, and regular files frequently allocate at least
@@ -1760,7 +1759,11 @@ xfs_dialloc_select_ag(
 	return error ? error : -ENOSPC;
 found_ag:
 	xfs_perag_put(pag);
-	*IO_agbp = agbp;
+	/* Allocate an inode in the found AG */
+	error = xfs_dialloc_ag(*tpp, agbp, parent, &ino);
+	if (error)
+		return error;
+	*new_ino = ino;
 	return 0;
 }
 
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index 3511086a..886f6748 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -33,30 +33,11 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
 }
 
 /*
- * Allocate an inode on disk.
- * Mode is used to tell whether the new inode will need space, and whether
- * it is a directory.
- *
- * There are two phases to inode allocation: selecting an AG and ensuring
- * that it contains free inodes, followed by allocating one of the free
- * inodes. xfs_dialloc_select_ag() does the former and returns a locked AGI
- * to the caller, ensuring that followup call to xfs_dialloc_ag() will
- * have free inodes to allocate from. xfs_dialloc_ag() will return the inode
- * number of the free inode we allocated.
+ * Allocate an inode on disk.  Mode is used to tell whether the new inode will
+ * need space, and whether it is a directory.
  */
-int					/* error */
-xfs_dialloc_select_ag(
-	struct xfs_trans **tpp,		/* double pointer of transaction */
-	xfs_ino_t	parent,		/* parent inode (directory) */
-	umode_t		mode,		/* mode bits for new inode */
-	struct xfs_buf	**IO_agbp);
-
-int
-xfs_dialloc_ag(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	xfs_ino_t		parent,
-	xfs_ino_t		*inop);
+int xfs_dialloc(struct xfs_trans **tpp, xfs_ino_t parent, umode_t mode,
+		xfs_ino_t *new_ino);
 
 /*
  * Free disk inode.  Carefully avoids touching the incore inode, all

