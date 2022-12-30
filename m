Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA75C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbiLaCGN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbiLaCGM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:06:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF221021
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:06:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB3EC61CBD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14490C433D2;
        Sat, 31 Dec 2022 02:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452371;
        bh=rzb0C5EHCoixlCb6jsycAt74JB1hVyE+63zOV7j2VI0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=heEG3KKqkYViEfDPVNm3VFMBFGUqD18K1Rnx347hObLyL6id+RvRBc/NUG0Kbko/D
         9pglgzwgwd/gf8iqhFQG7X+vu5NqsGYNfU/lDEW93FwBcfANbSzvvOD11/GbeVoVn5
         FG1u7qMOVlh/ClnxWJw0Hh9+tMPsculbQyx/n05FDfEB29z8HA7Zh4obGPJMK6Bbx9
         09l8ZPKMQMX/tbQgCdA5EAmPLlOZB9rrOTrrgW4y2eMisFQqyw36qKzL2r9PZe8n4Q
         h7RiRzIq1VMWMgjpZ3b4y6S2neE6jsjU0Fa9pSFZ//04PjbtHKLrez4Q1E7sqEY0uv
         rwbrOb83hDdKg==
Subject: [PATCH 12/26] libxfs: split new inode creation into two pieces
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:14 -0800
Message-ID: <167243875465.723621.8558270654292621940.stgit@magnolia>
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

There are two parts to initializing a newly allocated inode: setting up
the incore structures, and initializing the new inode core based on the
parent inode and the current user's environment.  The initialization
code is not specific to the kernel, so we would like to share that with
userspace by hoisting it to libxfs.  Therefore, split xfs_icreate into
separate functions to prepare for the next few patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c      |   42 ++++++++++++++++++++++++++----------------
 libxfs/xfs_ialloc.c |   20 ++++++++++++++++++--
 2 files changed, 44 insertions(+), 18 deletions(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 9835c708021..44d889f3f0f 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -73,28 +73,17 @@ xfs_inode_inherit_flags2(
 		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
 }
 
-/*
- * Initialise a newly allocated inode and return the in-core inode to the
- * caller locked exclusively.
- */
-static int
-libxfs_icreate(
+/* Initialise an inode's attributes. */
+static void
+xfs_inode_init(
 	struct xfs_trans	*tp,
-	xfs_ino_t		ino,
 	const struct xfs_icreate_args *args,
-	struct xfs_inode	**ipp)
+	struct xfs_inode	*ip)
 {
 	struct xfs_inode	*pip = args->pip;
-	struct xfs_inode	*ip;
 	unsigned int		flags;
 	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
 					XFS_ICHGTIME_ACCESS;
-	int			error;
-
-	error = libxfs_iget(tp->t_mountp, tp, ino, 0, &ip);
-	if (error != 0)
-		return error;
-	ASSERT(ip != NULL);
 
 	VFS_I(ip)->i_mode = args->mode;
 	set_nlink(VFS_I(ip), args->nlink);
@@ -154,7 +143,28 @@ libxfs_icreate(
 	 */
 	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
-	*ipp = ip;
+}
+
+/*
+ * Initialise a newly allocated inode and return the in-core inode to the
+ * caller locked exclusively.
+ */
+static int
+libxfs_icreate(
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	const struct xfs_icreate_args *args,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error;
+
+	error = libxfs_iget(mp, tp, ino, 0, ipp);
+	if (error)
+		return error;
+
+	ASSERT(*ipp != NULL);
+	xfs_inode_init(tp, args, *ipp);
 	return 0;
 }
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 3d55f5d1f46..9ce36b2cd8d 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1865,9 +1865,25 @@ xfs_dialloc(
 		}
 		xfs_perag_put(pag);
 	}
+	if (error)
+		goto out;
 
-	if (!error)
-		*new_ino = ino;
+	/*
+	 * Protect against obviously corrupt allocation btree records. Later
+	 * xfs_iget checks will catch re-allocation of other active in-memory
+	 * and on-disk inodes. If we don't catch reallocating the parent inode
+	 * here we will deadlock in xfs_iget() so we have to do these checks
+	 * first.
+	 */
+	if (ino == parent || !xfs_verify_dir_ino(mp, ino)) {
+		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_INOBT);
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	*new_ino = ino;
+out:
 	xfs_perag_put(pag);
 	return error;
 }

