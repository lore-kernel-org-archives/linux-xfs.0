Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39C5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbiLaBOC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbiLaBOC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:14:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2087B16588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:14:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9498B81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BB5C433D2;
        Sat, 31 Dec 2022 01:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449238;
        bh=RR5Kd7D8yEIMHWudheZ7fESnyjMOVGqXqbJ2hU4Kzqs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iDhZrLLOD7FcmOV+IEYySjXfpClJLEDv6rA1Ou2Hc0RDHFDR/yfs3N6wPn1cPVtR0
         VppnYFZOHvzqx4a/bQfL3K7lL/8hhIaNVXG2TDzuzkhWPm5alVZXT1cT0I07qXx0Rx
         0mQyS2nlUDwD0wo7atFgnzBY0j8GM4kUY6vLa2bpus4VP/cx2Fta7jtpCibiKnKRbI
         wGjNOKG6A6IUFLgUVyPPlTDbbjrIm8GfTBHB66UJI19DEtoVkMrNfiCFiH7MXiChwR
         H6M3G+V6yGCiZCntCwdHbUBcjr0TDT1BEtrFbHafz4RXf/7KD6vWJQzhTtii0KPvD2
         JvaokPdGi4OPQ==
Subject: [PATCH 14/23] xfs: disable the agi rotor for metadata inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:26 -0800
Message-ID: <167243864655.708110.16700641660672261534.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_ialloc.c |   16 +++++++++-------
 fs/xfs/libxfs/xfs_ialloc.h |    2 +-
 fs/xfs/libxfs/xfs_imeta.c  |    4 ++--
 fs/xfs/scrub/tempfile.c    |    2 +-
 fs/xfs/xfs_inode.c         |    4 ++--
 fs/xfs/xfs_symlink.c       |    2 +-
 6 files changed, 16 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d4c202da84cb..1d1c3cb0389c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1798,26 +1798,28 @@ xfs_dialloc_try_ag(
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
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index f4dc97bb8e83..adf60dc56e73 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -36,7 +36,7 @@ xfs_make_iptr(struct xfs_mount *mp, struct xfs_buf *b, int o)
  * Allocate an inode on disk.  Mode is used to tell whether the new inode will
  * need space, and whether it is a directory.
  */
-int xfs_dialloc(struct xfs_trans **tpp, xfs_ino_t parent, umode_t mode,
+int xfs_dialloc(struct xfs_trans **tpp, struct xfs_inode *dp, umode_t mode,
 		xfs_ino_t *new_ino);
 
 int xfs_difree(struct xfs_trans *tp, struct xfs_perag *pag,
diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index d3f60150f8ef..07f88df7a7e5 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -232,7 +232,7 @@ xfs_imeta_sb_create(
 		return -EEXIST;
 
 	/* Create a new inode and set the sb pointer. */
-	error = xfs_dialloc(tpp, 0, mode, &ino);
+	error = xfs_dialloc(tpp, NULL, mode, &ino);
 	if (error)
 		return error;
 	error = xfs_icreate(*tpp, ino, &args, ipp);
@@ -642,7 +642,7 @@ xfs_imeta_dir_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dialloc(tpp, dp->i_ino, mode, &ino);
+	error = xfs_dialloc(tpp, dp, mode, &ino);
 	if (error)
 		goto out_ilock;
 	error = xfs_icreate(*tpp, ino, &args, ipp);
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 6efaab50440f..beaaebf27284 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -87,7 +87,7 @@ xrep_tempfile_create(
 		goto out_release_dquots;
 
 	/* Allocate inode, set up directory. */
-	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
+	error = xfs_dialloc(&tp, dp, mode, &ino);
 	if (error)
 		goto out_trans_cancel;
 	error = xfs_icreate(tp, ino, &args, &sc->tempip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1eb53ed0097d..187c6025cfd8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -864,7 +864,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dialloc(&tp, dp->i_ino, args->mode, &ino);
+	error = xfs_dialloc(&tp, dp, args->mode, &ino);
 	if (!error)
 		error = xfs_icreate(tp, ino, args, &ip);
 	if (error)
@@ -980,7 +980,7 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_release_dquots;
 
-	error = xfs_dialloc(&tp, dp->i_ino, args->mode, &ino);
+	error = xfs_dialloc(&tp, dp, args->mode, &ino);
 	if (!error)
 		error = xfs_icreate(tp, ino, args, &ip);
 	if (error)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 6dc15f125895..f26ed3eba6cc 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -158,7 +158,7 @@ xfs_symlink(
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-	error = xfs_dialloc(&tp, dp->i_ino, S_IFLNK, &ino);
+	error = xfs_dialloc(&tp, dp, S_IFLNK, &ino);
 	if (!error)
 		error = xfs_icreate(tp, ino, &args, &ip);
 	if (error)

