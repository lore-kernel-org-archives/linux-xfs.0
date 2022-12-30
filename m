Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4794C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236167AbiLaCJx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCJx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:09:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD94B140F1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:09:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A277B81E00
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C629C433EF;
        Sat, 31 Dec 2022 02:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452589;
        bh=6iLz3kl0MA3aOKqY0S7feDtba5Yf0eL9+N61uCVmTsU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NL61b+8guZjt/Gb/Jo4tDA1FpZJNxNWR5uPUPriYLcgpw1t15jnOsukCMKyrhaiEV
         8vIw0rRY6xO3Ol+lTzaeZgsmFUyye7OU6NHr9Ky2vzoZnQYd6bO0L/Rs/czoLW8Dac
         t8wgU7ZV+zALJ/nwwmz/t6r/c0OijeX3+OYjC8kCExG6uVoyyets3h+0boOUf9FpbJ
         mm08AzItWJhJMA943yJ/wpRW2MHGCZd7Ybk83OzwlFf3vJIQzBO/a02y50FwHQt0xT
         7vlpzVg3rMWNFjXhjyvkkw2tJRiUoywIOeGTLnEr3K2uhP/dlINkfzyK+ulKyjmuU7
         mmOwWAOZrdoiQ==
Subject: [PATCH 26/26] xfs_repair: use library functions for orphanage
 creation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:16 -0800
Message-ID: <167243875627.723621.10704668689659836913.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use new library functions to create lost+found.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/phase6.c          |   28 ++++++++--------------------
 2 files changed, 9 insertions(+), 20 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 2b2b958d8a9..a5f9c6006f6 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -123,6 +123,7 @@
 #define xfs_dir2_shrink_inode		libxfs_dir2_shrink_inode
 
 #define xfs_dir_createname		libxfs_dir_createname
+#define xfs_dir_create_new_child	libxfs_dir_create_new_child
 #define xfs_dir_init			libxfs_dir_init
 #define xfs_dir_ino_validate		libxfs_dir_ino_validate
 #define xfs_dir_lookup			libxfs_dir_lookup
diff --git a/repair/phase6.c b/repair/phase6.c
index 5765c2b1250..f8f42eb6e29 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -804,6 +804,11 @@ mk_orphanage(
 	struct xfs_icreate_args	args = {
 		.nlink		= 2,
 	};
+	struct xfs_name		xname = {
+		.name		= ORPHANAGE,
+		.len		= strlen(ORPHANAGE),
+		.type		= XFS_DIR3_FT_DIR,
+	};
 	struct xfs_trans	*tp;
 	struct xfs_inode	*ip;
 	struct xfs_inode	*pip;
@@ -814,7 +819,6 @@ mk_orphanage(
 	int			error;
 	int			nres;
 	const umode_t		mode = S_IFDIR | 0755;
-	struct xfs_name		xname;
 
 	libxfs_icreate_args_rootfile(&args, mode);
 
@@ -830,9 +834,6 @@ mk_orphanage(
 			i, ORPHANAGE);
 
 	args.pip = pip;
-	xname.name = (unsigned char *)ORPHANAGE;
-	xname.len = strlen(ORPHANAGE);
-	xname.type = XFS_DIR3_FT_DIR;
 
 	if (libxfs_dir_lookup(NULL, pip, &xname, &ino, NULL) == 0)
 		return ino;
@@ -845,15 +846,6 @@ mk_orphanage(
 	if (i)
 		res_failed(i);
 
-	/*
-	 * use iget/ijoin instead of trans_iget because the ialloc
-	 * wrapper can commit the transaction and start a new one
-	 */
-/*	i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip);
-	if (i)
-		do_error(_("%d - couldn't iget root inode to make %s\n"),
-			i, ORPHANAGE);*/
-
 	error = -libxfs_dialloc(&tp, mp->m_sb.sb_rootino, mode, &ino);
 	if (error)
 		do_error(_("%s inode allocation failed %d\n"),
@@ -902,26 +894,22 @@ mk_orphanage(
 	/*
 	 * create the actual entry
 	 */
-	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, nres);
+	error = -libxfs_dir_create_new_child(tp, nres, pip, &xname, ip);
 	if (error)
 		do_error(
 		_("can't make %s, createname error %d\n"),
 			ORPHANAGE, error);
 
 	/*
-	 * bump up the link count in the root directory to account
-	 * for .. in the new directory, and update the irec copy of the
+	 * We bumped up the link count in the root directory to account
+	 * for .. in the new directory, so now update the irec copy of the
 	 * on-disk nlink so we don't fail the link count check later.
 	 */
-	inc_nlink(VFS_I(pip));
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 				  XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
 	add_inode_ref(irec, 0);
 	set_inode_disk_nlinks(irec, 0, get_inode_disk_nlinks(irec, 0) + 1);
 
-	libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
-	libxfs_dir_init(tp, ip, pip);
-	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);
 	if (error) {
 		do_error(_("%s directory creation failed -- bmapf error %d\n"),

