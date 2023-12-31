Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44C1C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vIXWk3CA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9984CC433C8;
	Sun, 31 Dec 2023 23:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064516;
	bh=WQOMsFBmjMglf75OFkgEXvDkC8YtMP5m4zskZEb0hxI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vIXWk3CAk68hSj3qcJFjg8XZ91xFBrDQgWRApHVHJcYOBVJvcDLkICSjeG+oC4Pl1
	 wFKoWyubyG+G/CkkhqNfRjLUwPcuywkTuK7t2/CQh4q7vQIjIdDb+45HPmrZDXeOUP
	 5SMvJVf/Zku6J526x2y8EW/nnQtse1J908Tu1+KAYYPbIwoCGIbFrfMqtz45R3NL37
	 wSUbVkfeNcYZt2J0vvRV3PxHusmZ6oN5KhvE3I+Aev1G4I8A86IySYRCb6GpBW9SZn
	 bFzAapvgK/5hfS75008QFX1u9679jkY8qOCVbn2NdawIWpKDQr0qQ7BxK/QrkpXaIW
	 bViwkOZbmBkBA==
Date: Sun, 31 Dec 2023 15:15:16 -0800
Subject: [PATCH 07/18] xfs: split xfs_bmap_add_attrfork into two pieces
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006956.1805510.7188021792001804610.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Split this function into two pieces -- one to make the actual changes to
the inode core to add the attr fork, and another one to deal with
getting the transaction and locking the inodes.

The next couple of patches will need this to be split into two.  One
patch implements committing new parent pointer recordsets to damaged
files.  If one file has an attr fork and the other does not, we have to
create the missing attr fork before the atomic swap transaction, and can
use the behavior encoded in the current xfs_bmap_add_attrfork.

The second patch adapts /lost+found adoptions to handle parent pointers
correctly.  The adoption process will add a parent pointer to a child
that is being moved to /lost+found, but this requires that the attr fork
already exists.  We don't know if we're actually going to commit the
adoption until we've already reserved a transaction and taken the
ILOCKs, which means that we must have a way to bypass the start of the
current xfs_bmap_add_attrfork.

Therefore, create xfs_attr_add_fork as the helper that creates a
transaction and takes locks; and make xfs_bmap_add_attrfork the function
that updates the inode core and allocates the incore attr fork.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |   39 ++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_bmap.c |   36 ++++++++++--------------------------
 libxfs/xfs_bmap.h |    3 ++-
 3 files changed, 50 insertions(+), 28 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index c4f543db474..cb4c2726fd7 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -933,6 +933,43 @@ xfs_attr_defer_add(
 	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
 }
 
+STATIC int
+xfs_attr_add_fork(
+	struct xfs_inode	*ip,		/* incore inode pointer */
+	int			size,		/* space new attribute needs */
+	int			rsvd)		/* xact may use reserved blks */
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;		/* transaction pointer */
+	unsigned int		blks;		/* space reservation */
+	int			error;		/* error return value */
+
+	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+
+	blks = XFS_ADDAFORK_SPACE_RES(mp);
+
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_addafork, blks, 0,
+			rsvd, &tp);
+	if (error)
+		return error;
+
+	if (xfs_inode_has_attr_fork(ip))
+		goto trans_cancel;
+
+	error = xfs_bmap_add_attrfork(tp, ip, size, rsvd);
+	if (error)
+		goto trans_cancel;
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+
+trans_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
 /*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
@@ -984,7 +1021,7 @@ xfs_attr_set(
 				xfs_attr_sf_entsize_byname(args->namelen,
 						args->valuelen);
 
-			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
+			error = xfs_attr_add_fork(dp, sf_size, rsvd);
 			if (error)
 				return error;
 		}
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index f16e4369306..5c69720e19e 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1001,38 +1001,29 @@ xfs_bmap_set_attrforkoff(
 }
 
 /*
- * Convert inode from non-attributed to attributed.
- * Must not be in a transaction, ip must not be locked.
+ * Convert inode from non-attributed to attributed.  Caller must hold the
+ * ILOCK_EXCL and the file cannot have an attr fork.
  */
 int						/* error code */
 xfs_bmap_add_attrfork(
-	xfs_inode_t		*ip,		/* incore inode pointer */
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,		/* incore inode pointer */
 	int			size,		/* space new attribute needs */
 	int			rsvd)		/* xact may use reserved blks */
 {
-	xfs_mount_t		*mp;		/* mount structure */
-	xfs_trans_t		*tp;		/* transaction pointer */
-	int			blks;		/* space reservation */
+	struct xfs_mount	*mp = tp->t_mountp;
 	int			version = 1;	/* superblock attr version */
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
-	mp = ip->i_mount;
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
-
-	blks = XFS_ADDAFORK_SPACE_RES(mp);
-
-	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_addafork, blks, 0,
-			rsvd, &tp);
-	if (error)
-		return error;
-	if (xfs_inode_has_attr_fork(ip))
-		goto trans_cancel;
+	ASSERT(!xfs_inode_has_attr_fork(ip));
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = xfs_bmap_set_attrforkoff(ip, size, &version);
 	if (error)
-		goto trans_cancel;
+		return error;
 
 	xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 	logflags = 0;
@@ -1053,7 +1044,7 @@ xfs_bmap_add_attrfork(
 	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (error)
-		goto trans_cancel;
+		return error;
 	if (!xfs_has_attr(mp) ||
 	   (!xfs_has_attr2(mp) && version == 2)) {
 		bool log_sb = false;
@@ -1072,14 +1063,7 @@ xfs_bmap_add_attrfork(
 			xfs_log_sb(tp);
 	}
 
-	error = xfs_trans_commit(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
-
-trans_cancel:
-	xfs_trans_cancel(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
+	return 0;
 }
 
 /*
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 87633449c37..c9e297dba88 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -174,7 +174,8 @@ int	xfs_bmap_longest_free_extent(struct xfs_perag *pag,
 void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
-int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
+int	xfs_bmap_add_attrfork(struct xfs_trans *tp, struct xfs_inode *ip,
+		int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
 int xfs_bmap_local_to_extents(struct xfs_trans *tp, struct xfs_inode *ip,

