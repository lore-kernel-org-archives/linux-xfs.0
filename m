Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1B4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbiLaBHQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbiLaBHP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:07:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222A715F3F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:07:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B25EC61D03
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A09EC433D2;
        Sat, 31 Dec 2022 01:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448833;
        bh=54/Oe335M0PgDjW+vctb7QIGbdsV77/I3s6CjrVt4+o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bS8LBBc8sXjWYemmvjIYckGXt3rcd83p7LS3vsiYYq4Mm6pRUWDiPA330EK5OkC0V
         T5ZP8ppPTX9DOuGRWRJQlMR64GkssXMUp6CV9q1m2ZFaxX5gP0l7ZYcs55+5ZjP4ga
         yEO4wqLp/Hul9Nmy95xrJEG6JWvErQIfvhNn/rbRb8+/y3gAJbJUMKOe4gx3iMriQd
         rme7NUd1PsK2BcFaH4KHM6exWoLwRK9cVnY9JZo1FMKFNlypnJIyB0BkLQzt5QJN6M
         GTshKW6muRPJ5B9PamN5kTKsMuHWPy3iwpMzao0BYBsFLP/ZNx+DZG2Xe0QunPbxYa
         HBOmlnLHqfO0Q==
Subject: [PATCH 08/20] xfs: split new inode creation into two pieces
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:19 -0800
Message-ID: <167243863946.707335.1074883601333784409.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_ialloc.c |   20 ++++++++++++-
 fs/xfs/xfs_inode.c         |   66 ++++++++++++++++++++------------------------
 2 files changed, 48 insertions(+), 38 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index ecf53198907f..d4c202da84cb 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1870,9 +1870,25 @@ xfs_dialloc(
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
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7a634a1ea111..1352599fee4c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -674,51 +674,21 @@ xfs_inode_inherit_flags2(
 	}
 }
 
-/*
- * Initialise a newly allocated inode and return the in-core inode to the
- * caller locked exclusively.
- */
-int
-xfs_icreate(
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
 	struct inode		*dir = pip ? VFS_I(pip) : NULL;
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_inode	*ip;
-	struct inode		*inode;
+	struct inode		*inode = VFS_I(ip);
 	unsigned int		flags;
 	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
 					XFS_ICHGTIME_ACCESS;
-	int			error;
 
-	/*
-	 * Protect against obviously corrupt allocation btree records. Later
-	 * xfs_iget checks will catch re-allocation of other active in-memory
-	 * and on-disk inodes. If we don't catch reallocating the parent inode
-	 * here we will deadlock in xfs_iget() so we have to do these checks
-	 * first.
-	 */
-	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
-		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
-		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
-				XFS_SICK_AG_INOBT);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Get the in-core inode with the lock held exclusively to prevent
-	 * others from looking at until we're done.
-	 */
-	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE, XFS_ILOCK_EXCL, &ip);
-	if (error)
-		return error;
-
-	ASSERT(ip != NULL);
-	inode = VFS_I(ip);
 	set_nlink(inode, args->nlink);
 	inode->i_rdev = args->rdev;
 	ip->i_projid = args->prid;
@@ -815,8 +785,32 @@ xfs_icreate(
 
 	/* now that we have an i_mode we can setup the inode structure */
 	xfs_setup_inode(ip);
+}
 
-	*ipp = ip;
+/*
+ * Initialise a newly allocated inode and return the in-core inode to the
+ * caller locked exclusively.
+ */
+int
+xfs_icreate(
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	const struct xfs_icreate_args *args,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error;
+
+	/*
+	 * Get the in-core inode with the lock held exclusively to prevent
+	 * others from looking at until we're done.
+	 */
+	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE, XFS_ILOCK_EXCL, ipp);
+	if (error)
+		return error;
+
+	ASSERT(*ipp != NULL);
+	xfs_inode_init(tp, args, *ipp);
 	return 0;
 }
 

