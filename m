Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11226C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbiLaCSA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiLaCRx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:17:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948DF13F62
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:17:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 310AF61C9C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9780EC433D2;
        Sat, 31 Dec 2022 02:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453071;
        bh=IY2cBr3QZGPuSAfrp9InL8Dm+LABs7MxtJa0Rgnrmjk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J2Xx+c5bVyMkb/SXSONxv01oCG7dkggQJGmHJplkhUW0xolYFwn7BNBk+Och7B3dR
         slplCAFayC5zXt0oiHfToqrg2G3wCRA3kOkcbVs1cNPOfjjgNmPVZPh+deQQ7pVLYD
         f+WKMIJr99cOAXMNjqPZLW/KyUAkmNUHTCkYFLtrC7jKyMXHFqhEVJQuZHBM+u/v2O
         WaLAYPtMZzbaYfRtJhTRtiTYDKZMXKdHtNnb4BOhPsscgPunE5YK39akV8ITqbNkMB
         aT6M+ha1eBNWF8Sb/48npOB+KukIRHLlu1Jf5o17zy4+IOtYwSu+UShsp7r7MgTBng
         OswBR2l1A6A7Q==
Subject: [PATCH 31/46] xfs_repair: refactor root directory initialization
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:23 -0800
Message-ID: <167243876342.725900.16520400905151204132.stgit@magnolia>
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

Refactor root directory initialization into a separate function we can
call for both the root dir and the metadir.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   63 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 23 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index d8df0f608f8..7e751f41770 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -755,27 +755,27 @@ mk_rsumino(xfs_mount_t *mp)
 	libxfs_irele(ip);
 }
 
-/*
- * makes a new root directory.
- */
-static void
-mk_root_dir(xfs_mount_t *mp)
+/* Initialize a root directory. */
+static int
+init_fs_root_dir(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	mode_t			mode,
+	struct xfs_inode	**ipp)
 {
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	int		i;
-	int		error;
-	const mode_t	mode = 0755;
-	ino_tree_node_t	*irec;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip = NULL;
+	struct ino_tree_node	*irec;
+	int			error;
 
-	ip = NULL;
-	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
-	if (i)
-		res_failed(i);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
+	if (error)
+		return error;
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rootino, 0, &ip);
+	error = -libxfs_iget(mp, tp, ino, 0, &ip);
 	if (error) {
-		do_error(_("could not iget root inode -- error - %d\n"), error);
+		libxfs_trans_cancel(tp);
+		return error;
 	}
 
 	/* Reset the root directory. */
@@ -784,14 +784,31 @@ mk_root_dir(xfs_mount_t *mp)
 
 	error = -libxfs_trans_commit(tp);
 	if (error)
-		do_error(_("%s: commit failed, error %d\n"), __func__, error);
+		return error;
+
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+				XFS_INO_TO_AGINO(mp, ino));
+	set_inode_isadir(irec, XFS_INO_TO_AGINO(mp, ino) - irec->ino_startnum);
+	*ipp = ip;
+	return 0;
+}
+
+/*
+ * makes a new root directory.
+ */
+static void
+mk_root_dir(xfs_mount_t *mp)
+{
+	struct xfs_inode	*ip = NULL;
+	int			error;
+
+	error = init_fs_root_dir(mp, mp->m_sb.sb_rootino, 0755, &ip);
+	if (error)
+		do_error(
+	_("Could not reinitialize root directory inode, error %d\n"),
+			error);
 
 	libxfs_irele(ip);
-
-	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
-	set_inode_isadir(irec, XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino) -
-				irec->ino_startnum);
 }
 
 /*

