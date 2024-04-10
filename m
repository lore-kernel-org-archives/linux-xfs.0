Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BD510E3
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711162; cv=none; b=ABFXr1ZrcDcn5PCCC4JkYku14HxtWP7Frj52x6RT3E/0AuFgMrQYxca8L613zrgHnsVHfzMP6H/PG4v/1XfyQ+uK43KfvZwgeEpRg4xU9DtNjhMPqGyS9BDyDquHS/jsSKa29y1XdOSdb8fYvFUQXg2nblmmIkHtBrcX4+x6Z8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711162; c=relaxed/simple;
	bh=f997zppQiLEKpzWUZYND8Esv3egftvk3aC6Z+SHsSvw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zs7S/YErNs08w6h+lDIHFSa+mgBVCt9GkbvXL8ZhDsoebo2WvzBlvRkTJI43UJC/4rDKH5YSAMYy2n4dO60FapbWKuqw01jme1crvuyUfHjBRNR+sT5Xj1kCAOx38qzJVhqarWTzeRzDPQo4lTRKIotsTxbo2NzZjC8Pe91Q8B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYhle3WN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYhle3WN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCF6C433C7;
	Wed, 10 Apr 2024 01:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711162;
	bh=f997zppQiLEKpzWUZYND8Esv3egftvk3aC6Z+SHsSvw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jYhle3WN9FfSRM7l5MkWDDbjTWdn3qKmYRqcLNf64EErTZl30WUS0fia5DUkEswfr
	 ScELeN/zW68NfdokDKcL4Ai8Bj/ypNwzHQidBr5a78M52LVknIiXbypwODhpw/j/F7
	 ozWg0r4DdaYvoUcl11mm9lPWLXwuPo+1hvjqe/ajipbU56D9buGCQ2WciZNZnEDHbP
	 pC8H1CfgNBlehxJq+reEmD0UGQ73mPPcgu8MbLVB/A1b8v8RvVZg56NzqxzD2FGrSq
	 MTtBL871lkrW9ldL2t2uxUbbsX3XRtN0JJNzfud5joaukK/6oZj91+RYf2dPVW7kyW
	 axFQ1m8nMDgQw==
Date: Tue, 09 Apr 2024 18:06:01 -0700
Subject: [PATCH 09/14] xfs: split xfs_bmap_add_attrfork into two pieces
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270971136.3632937.4652714249716908945.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_attr.c |   39 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_bmap.c |   36 ++++++++++--------------------------
 fs/xfs/libxfs/xfs_bmap.h |    3 ++-
 3 files changed, 50 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 83f8cf551816a..94f5acaad6e09 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -950,6 +950,43 @@ xfs_attr_lookup(
 	return error;
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
  * Before updating xattrs, add an attribute fork if the inode doesn't have.
  * (inode must not be locked when we call this routine)
@@ -968,7 +1005,7 @@ xfs_attr_ensure_fork(
 			xfs_attr_sf_entsize_byname(args->namelen,
 						   args->valuelen);
 
-	return xfs_bmap_add_attrfork(args->dp, sf_size, rsvd);
+	return xfs_attr_add_fork(args->dp, sf_size, rsvd);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 55a64a72771f2..b01d477d1cfbc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1025,38 +1025,29 @@ xfs_bmap_set_attrforkoff(
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
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
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
@@ -1077,7 +1068,7 @@ xfs_bmap_add_attrfork(
 	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (error)
-		goto trans_cancel;
+		return error;
 	if (!xfs_has_attr(mp) ||
 	   (!xfs_has_attr2(mp) && version == 2)) {
 		bool log_sb = false;
@@ -1096,14 +1087,7 @@ xfs_bmap_add_attrfork(
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
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 32fb2a455c294..e98849eb9bbae 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -176,7 +176,8 @@ int	xfs_bmap_longest_free_extent(struct xfs_perag *pag,
 void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
-int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
+int	xfs_bmap_add_attrfork(struct xfs_trans *tp, struct xfs_inode *ip,
+		int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
 int xfs_bmap_local_to_extents(struct xfs_trans *tp, struct xfs_inode *ip,

