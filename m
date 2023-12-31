Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59169BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n07T3Gg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC67C433C7;
	Sun, 31 Dec 2023 20:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055006;
	bh=9+it8trxLEkipBMwNdsGInz6n2YljjBi36swpiUXeIc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n07T3Gg3AJ1B23acOkOGomAxw59e6fN0pRUk7knRPnwls8MQbRHCRyoxQQdiQpbue
	 fs8nhA+QW34pXpo2KYmyzuvmOtAmdwV4JbzLCsmJNdoMfrp71BRlr6bh4GBJ9rZFJh
	 e++2fS+PE17PV1o3Ko4U6Hvi5J1/mA18dIFjZYUjJeubdLxinldd3SPmC6XsZfj4U5
	 OlrqIkOGjWJ6is4MEMyKesNiryH9DTTegeUazlRD3OU1SYfpZph6FnK2zyl4UythLJ
	 E9Yg3L7oiFismWruwET96/1YCg7W4fcUfhZFx9h73REpsTTyK4lABtal/jq9RnJ/fO
	 cwkmgvh2u1HFg==
Date: Sun, 31 Dec 2023 12:36:45 -0800
Subject: [PATCH 1/2] xfs: ensure unlinked list state is consistent with nlink
 during scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404835655.1753516.14567016148033579573.stgit@frogsfrogsfrogs>
In-Reply-To: <170404835635.1753516.7102734968917257897.stgit@frogsfrogsfrogs>
References: <170404835635.1753516.7102734968917257897.stgit@frogsfrogsfrogs>
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

Now that we have the means to tell if an inode is on an unlinked inode
list or not, we can check that an inode with zero link count is on the
unlinked list; and an inode that has nonzero link count is not on that
list.  Make repair clean things up too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode.c        |   19 ++++++++++++++++++
 fs/xfs/scrub/inode_repair.c |   45 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c          |    5 +----
 fs/xfs/xfs_inode.h          |    2 ++
 4 files changed, 67 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 6e2fe2d6250b3..d32716fb2fecf 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -739,6 +739,23 @@ xchk_inode_check_reflink_iflag(
 		xchk_ino_set_corrupt(sc, ino);
 }
 
+/*
+ * If this inode has zero link count, it must be on the unlinked list.  If
+ * it has nonzero link count, it must not be on the unlinked list.
+ */
+STATIC void
+xchk_inode_check_unlinked(
+	struct xfs_scrub	*sc)
+{
+	if (VFS_I(sc->ip)->i_nlink == 0) {
+		if (!xfs_inode_on_unlinked_list(sc->ip))
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+	} else {
+		if (xfs_inode_on_unlinked_list(sc->ip))
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+	}
+}
+
 /* Scrub an inode. */
 int
 xchk_inode(
@@ -771,6 +788,8 @@ xchk_inode(
 	if (S_ISREG(VFS_I(sc->ip)->i_mode))
 		xchk_inode_check_reflink_iflag(sc, sc->ip->i_ino);
 
+	xchk_inode_check_unlinked(sc);
+
 	xchk_inode_xref(sc, sc->ip->i_ino, &di);
 out:
 	return error;
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 549b66ef826a9..50bcc5a4c3df1 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1697,6 +1697,46 @@ xrep_inode_problems(
 	return xrep_roll_trans(sc);
 }
 
+/*
+ * Make sure this inode's unlinked list pointers are consistent with its
+ * link count.
+ */
+STATIC int
+xrep_inode_unlinked(
+	struct xfs_scrub	*sc)
+{
+	unsigned int		nlink = VFS_I(sc->ip)->i_nlink;
+	int			error;
+
+	/*
+	 * If this inode is linked from the directory tree and on the unlinked
+	 * list, remove it from the unlinked list.
+	 */
+	if (nlink > 0 && xfs_inode_on_unlinked_list(sc->ip)) {
+		struct xfs_perag	*pag;
+		int			error;
+
+		pag = xfs_perag_get(sc->mp,
+				XFS_INO_TO_AGNO(sc->mp, sc->ip->i_ino));
+		error = xfs_iunlink_remove(sc->tp, pag, sc->ip);
+		xfs_perag_put(pag);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * If this inode is not linked from the directory tree yet not on the
+	 * unlinked list, put it on the unlinked list.
+	 */
+	if (nlink == 0 && !xfs_inode_on_unlinked_list(sc->ip)) {
+		error = xfs_iunlink(sc->tp, sc->ip);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
 /* Repair an inode's fields. */
 int
 xrep_inode(
@@ -1746,5 +1786,10 @@ xrep_inode(
 			return error;
 	}
 
+	/* Reconnect incore unlinked list */
+	error = xrep_inode_unlinked(sc);
+	if (error)
+		return error;
+
 	return xrep_defer_finish(sc);
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 70705e2e30f79..970daeb160b24 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -42,9 +42,6 @@
 
 struct kmem_cache *xfs_inode_cache;
 
-STATIC int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
-	struct xfs_inode *);
-
 /*
  * helper function to extract extent size hint from inode
  */
@@ -2254,7 +2251,7 @@ xfs_iunlink_remove_inode(
 /*
  * Pull the on-disk inode from the AGI unlinked list.
  */
-STATIC int
+int
 xfs_iunlink_remove(
 	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b6f10ea725857..f11e91c6e2182 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -613,6 +613,8 @@ extern struct kmem_cache	*xfs_inode_cache;
 bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip);
 
 void xfs_end_io(struct work_struct *work);
 

