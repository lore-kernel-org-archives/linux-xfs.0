Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28733C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbiLaCNc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbiLaCNb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:13:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C491B1C900
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:13:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F72CB81E4A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EABC433EF;
        Sat, 31 Dec 2022 02:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452807;
        bh=WV11RT7lzHkS0eDYHoUxuGuBuyxSvZEp5pHn38pA3Ow=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lILr/I5DL/OOWeV2Pfvt/ppM0E/JLO7IMrBjPnSMYbPA00WZWz3ouj0spPwzB8JtO
         fXNb6XfQfcfrqDz0tSzXbi4sI0Zpsu7aNeJPlOsOm6TfOcBO8G1nrfijjG7T2Lg0IF
         ANbS3oVEz4LSeX8/sUko9aPjirxWwOzAWlgZdxOisKp6wqt+ZddbtXTGHQahS50Bdq
         6k2f8WjqNNNm3x13C3VgmGVQVdBWwCpFcdpXqv5M1OSeIxArrJLQgTnl/1YLkAur+j
         /2vQMtnuJlooAXA6pCgflPPQAxq+BQxwTdPGB5QhqK3z4yG42S1uZuN1O+C+7GnlQw
         d0+VCDQ6Bdnig==
Subject: [PATCH 14/46] xfs: disable the agi rotor for metadata inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:21 -0800
Message-ID: <167243876121.725900.6832424021444193749.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Ideally, we'd put all the metadata inodes in one place if we could, so
that the metadata all stay reasonably close together instead of
spreading out over the disk.  Furthermore, if the log is internal we'd
probably prefer to keep the metadata near the log.  Therefore, disable
AGI rotoring for metadata inode allocations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/util.c       |    3 ---
 libxfs/xfs_ialloc.c |   16 +++++++++-------
 libxfs/xfs_ialloc.h |    2 +-
 libxfs/xfs_imeta.c  |    4 ++--
 mkfs/proto.c        |    3 +--
 repair/phase6.c     |    2 +-
 6 files changed, 14 insertions(+), 16 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index fec26e6d30f..7b16d30b754 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -467,9 +467,6 @@ libxfs_imeta_mkdir(
 	uint				resblks;
 	int				error;
 
-	/* Try to place metadata directories in AG 0. */
-	mp->m_agirotor = 0;
-
 	error = xfs_imeta_start_update(mp, path, &upd);
 	if (error)
 		return error;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 9ce36b2cd8d..e7cafdd395b 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1793,26 +1793,28 @@ xfs_dialloc_try_ag(
 int
 xfs_dialloc(
 	struct xfs_trans	**tpp,
-	xfs_ino_t		parent,
+	struct xfs_inode	*pip,
 	umode_t			mode,
 	xfs_ino_t		*new_ino)
 {
 	struct xfs_mount	*mp = (*tpp)->t_mountp;
+	struct xfs_perag	*pag;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_ino_t		ino;
+	xfs_ino_t		parent = pip ? pip->i_ino : 0;
 	xfs_agnumber_t		agno;
-	int			error = 0;
 	xfs_agnumber_t		start_agno;
-	struct xfs_perag	*pag;
-	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	bool			ok_alloc = true;
 	int			flags;
-	xfs_ino_t		ino;
+	int			error = 0;
 
 	/*
 	 * Directories, symlinks, and regular files frequently allocate at least
 	 * one block, so factor that potential expansion when we examine whether
-	 * an AG has enough space for file creation.
+	 * an AG has enough space for file creation.  Try to keep metadata
+	 * files all in the same AG.
 	 */
-	if (S_ISDIR(mode))
+	if (S_ISDIR(mode) && (!pip || !xfs_is_metadata_inode(pip)))
 		start_agno = xfs_ialloc_next_ag(mp);
 	else {
 		start_agno = XFS_INO_TO_AGNO(mp, parent);
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index f4dc97bb8e8..adf60dc56e7 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -36,7 +36,7 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
  * Allocate an inode on disk.  Mode is used to tell whether the new inode will
  * need space, and whether it is a directory.
  */
-int xfs_dialloc(struct xfs_trans **tpp, xfs_ino_t parent, umode_t mode,
+int xfs_dialloc(struct xfs_trans **tpp, struct xfs_inode *dp, umode_t mode,
 		xfs_ino_t *new_ino);
 
 int xfs_difree(struct xfs_trans *tp, struct xfs_perag *pag,
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index 9e92186b58c..1502d4eb2e3 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -231,7 +231,7 @@ xfs_imeta_sb_create(
 		return -EEXIST;
 
 	/* Create a new inode and set the sb pointer. */
-	error = xfs_dialloc(tpp, 0, mode, &ino);
+	error = xfs_dialloc(tpp, NULL, mode, &ino);
 	if (error)
 		return error;
 	error = xfs_icreate(*tpp, ino, &args, ipp);
@@ -641,7 +641,7 @@ xfs_imeta_dir_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dialloc(tpp, dp->i_ino, mode, &ino);
+	error = xfs_dialloc(tpp, dp, mode, &ino);
 	if (error)
 		goto out_ilock;
 	error = xfs_icreate(*tpp, ino, &args, ipp);
diff --git a/mkfs/proto.c b/mkfs/proto.c
index f15cbea84c7..6fb58bd7cd4 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -380,7 +380,6 @@ creatproto(
 				  XFS_ICREATE_ARGS_FORCE_MODE,
 	};
 	struct xfs_inode	*ip;
-	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
 	xfs_ino_t		ino;
 	int			error;
 
@@ -388,7 +387,7 @@ creatproto(
 	 * Call the space management code to pick the on-disk inode to be
 	 * allocated.
 	 */
-	error = -libxfs_dialloc(tpp, parent_ino, mode, &ino);
+	error = -libxfs_dialloc(tpp, dp, mode, &ino);
 	if (error)
 		return error;
 
diff --git a/repair/phase6.c b/repair/phase6.c
index f8f42eb6e29..90413251b56 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -846,7 +846,7 @@ mk_orphanage(
 	if (i)
 		res_failed(i);
 
-	error = -libxfs_dialloc(&tp, mp->m_sb.sb_rootino, mode, &ino);
+	error = -libxfs_dialloc(&tp, pip, mode, &ino);
 	if (error)
 		do_error(_("%s inode allocation failed %d\n"),
 			ORPHANAGE, error);

