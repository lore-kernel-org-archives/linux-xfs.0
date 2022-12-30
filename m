Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975A6C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbiLaCSJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbiLaCSJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:18:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2439E13F62
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:18:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B61FF61C9C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0FDC433EF;
        Sat, 31 Dec 2022 02:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453087;
        bh=JtDmoYW3Y7ivBU+EmYd6VOEKGTjjJ3XgUHlRCH5wy2o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qhUbltkeypTN58+I8Lvj/Qr1s38zGU/lRORLr2FGyy2gREy/42VLURJ5idcTuVtLb
         g4yAevTHfNY+7bEdtI6MwSosjCd8UUuKVfcNkAliCLHzLhoqBgdkw70Y8mD5D+abB5
         VPzntswrEHvvjfxddxhECQH1WfjpePtjCNo1ROFBW+hLP+bMj9MFlrNwF0Yv9ZU41x
         KBKmtCCiyMmtoRIypNLsyoqvIoybER+pqw7QpdHgo8h81RXeTgMn2/VhWl5ZkWNGzU
         H2kItWcJ4TveLOx+AiuIR0d5dXy/g3FftUm3fvfarR+Mcfa86DIz0hcloFY1qvmV+1
         NGuZUO03lBYzA==
Subject: [PATCH 32/46] xfs_repair: refactor grabbing realtime metadata inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:23 -0800
Message-ID: <167243876354.725900.12838140320983581144.stgit@magnolia>
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

Create a helper function to grab a realtime metadata inode.  When
metadir arrives, the bitmap and summary inodes can float, so we'll
turn this function into a "load or allocate" function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   90 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 53 insertions(+), 37 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 7e751f41770..aaaebc79098 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -469,18 +469,37 @@ reset_root_ino(
 	libxfs_inode_init(tp, &args, ip);
 }
 
+/* Load a realtime metadata inode from disk and reset it. */
+static int
+ensure_rtino(
+	struct xfs_trans		**tpp,
+	xfs_ino_t			ino,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_mount		*mp = (*tpp)->t_mountp;
+	int				error;
+
+	error = -libxfs_iget(mp, *tpp, ino, 0, ipp);
+	if (error)
+		return error;
+
+	reset_root_ino(*tpp, S_IFREG, *ipp);
+	return 0;
+}
+
 static void
-mk_rbmino(xfs_mount_t *mp)
+mk_rbmino(
+	struct xfs_mount	*mp)
 {
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	xfs_bmbt_irec_t	*ep;
-	int		i;
-	int		nmap;
-	int		error;
-	xfs_fileoff_t	bno;
-	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	uint		blocks;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	struct xfs_bmbt_irec	*ep;
+	int			i;
+	int			nmap;
+	int			error;
+	xfs_fileoff_t		bno;
+	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	uint			blocks;
 
 	/*
 	 * first set up inode
@@ -489,15 +508,13 @@ mk_rbmino(xfs_mount_t *mp)
 	if (i)
 		res_failed(i);
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip);
-	if (error) {
-		do_error(
-		_("couldn't iget realtime bitmap inode -- error - %d\n"),
-			error);
-	}
-
 	/* Reset the realtime bitmap inode. */
-	reset_root_ino(tp, S_IFREG, ip);
+	error = ensure_rtino(&tp, mp->m_sb.sb_rbmino, &ip);
+	if (error) {
+		do_error(
+		_("couldn't iget realtime bitmap inode -- error - %d\n"),
+			error);
+	}
 	ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);
@@ -682,18 +699,19 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 }
 
 static void
-mk_rsumino(xfs_mount_t *mp)
+mk_rsumino(
+	struct xfs_mount	*mp)
 {
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	xfs_bmbt_irec_t	*ep;
-	int		i;
-	int		nmap;
-	int		error;
-	int		nsumblocks;
-	xfs_fileoff_t	bno;
-	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	uint		blocks;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	struct xfs_bmbt_irec	*ep;
+	int			i;
+	int			nmap;
+	int			error;
+	int			nsumblocks;
+	xfs_fileoff_t		bno;
+	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	uint			blocks;
 
 	/*
 	 * first set up inode
@@ -702,15 +720,13 @@ mk_rsumino(xfs_mount_t *mp)
 	if (i)
 		res_failed(i);
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip);
-	if (error) {
-		do_error(
-		_("couldn't iget realtime summary inode -- error - %d\n"),
-			error);
-	}
-
 	/* Reset the rt summary inode. */
-	reset_root_ino(tp, S_IFREG, ip);
+	error = ensure_rtino(&tp, mp->m_sb.sb_rsumino, &ip);
+	if (error) {
+		do_error(
+		_("couldn't iget realtime summary inode -- error - %d\n"),
+			error);
+	}
 	ip->i_disk_size = mp->m_rsumsize;
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);

