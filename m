Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B382208A4
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504997; cv=none; b=hqkV7JsvqwmIzD8+pocjsJLPTTyNbxcJFzlwiRYMiFiivQiMmZ9idTIqsEwewfzEstdpDFZrzpYxg145DqVN28ZqmiUjCGsAMjmrOAEdY66p+oELgg8bO2XQhaPWR2fL1ujOuo+4OxUZ/LXMDsOZNw0Pk3kvU3cjYGv2hTUn0TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504997; c=relaxed/simple;
	bh=IUVzoZYMQRM0g9et7rHXnmVHvrbHTlX9lG5nSmHV2Ps=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nvklqDH0hlU//CmiQ/c/jPNuabra0rNmnAnzhGdxoRWK/7DMZaZFPj+dpzackc9Ig+y14GF5wJG6UufjcOux0aOhcX+XSB7scUg/xEAv6UlA7BS9hbWP/FlPySSulp8umFN2IDwje8YesngV1rH10wjkD/xkuiDZGiXQNsY2MAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sQ19REda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sQ19REda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5C8C433C7;
	Wed, 27 Mar 2024 02:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504996;
	bh=IUVzoZYMQRM0g9et7rHXnmVHvrbHTlX9lG5nSmHV2Ps=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sQ19REdaogqaQKFQIILp7qqezPjrlh1BVB/FXazjzSYw8QNuDRsLw/L+Zm9OQ8B7L
	 iYJrlZkBG/2tXUL9S2+EdpTjT1mkK2NhMmsOBMnr5lCgckrta9ZONncUVwGXcU3/OX
	 f+xTH3xlq8n5UE6EGKN3vGqslpf2I2663z7cBNe6Q06fqvnA/4LRUodtCDxjxfFfwy
	 /rDsKGJysux9ImZaBBjf5Po+xYp0zgNzOHnQayZKXnk2QWDzR61NIYFpbgsd1NhP5i
	 2ApXxckYxgtZt8rciVPqh6p+jZklswIteVHAM1XVzTGYaYCZxWDSTc/TObBYy6bd6b
	 UNtg10HnsHWiA==
Date: Tue, 26 Mar 2024 19:03:16 -0700
Subject: [PATCH 1/2] xfs: ensure unlinked list state is consistent with nlink
 during scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150383132.3217890.15507771181490839027.stgit@frogsfrogsfrogs>
In-Reply-To: <171150383111.3217890.14975563638879707412.stgit@frogsfrogsfrogs>
References: <171150383111.3217890.14975563638879707412.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 96c5763dc3839..7b8efb6d3539b 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1743,6 +1743,46 @@ xrep_inode_problems(
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
@@ -1792,5 +1832,10 @@ xrep_inode(
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
index f9fcb7761e233..98a01a490adcc 100644
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
@@ -2241,7 +2238,7 @@ xfs_iunlink_remove_inode(
 /*
  * Pull the on-disk inode from the AGI unlinked list.
  */
-STATIC int
+int
 xfs_iunlink_remove(
 	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 23be8f7521530..22d6fa2fcc676 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -617,6 +617,8 @@ extern struct kmem_cache	*xfs_inode_cache;
 bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip);
 
 void xfs_end_io(struct work_struct *work);
 

