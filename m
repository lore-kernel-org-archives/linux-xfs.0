Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E561C2D
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709001031; cv=none; b=geCcqVMOGYUA+esFnOTWIn34v7wX6ZCBKoaXygu74SGowApniCH1khtQ4hGF4HwCnTc/4Pm9nz+4jP9mhgeLbj4s+6t9WNsXDVknNzzKtXoHVULsYhprTH85dxkpGWItDGTnPcKdahy0dCqdwH5RTYmxOGBrxmytOQ4rWFkN+BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709001031; c=relaxed/simple;
	bh=eNkFlj5zubhPRiEL7RIPbhTr1xzqDm5Qsckzt9TH5Xw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KBRcfp08nkhaYPReZCzKovcuCxjmZttC0Uz/12H9Y+J4AMYhD3WX8ANoAeUSEZkyxwSf1xUFt4hvwHtE4+9fcIPoHkiHZ914FobJlFULNrFkrdU3kBKoCPwJUh/dfabQaDsTIVIHTPUADPRbSHPtRhrSxw4tHmkOyPXP5xIOVpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+AIcRJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+AIcRJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CA3C433F1;
	Tue, 27 Feb 2024 02:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709001031;
	bh=eNkFlj5zubhPRiEL7RIPbhTr1xzqDm5Qsckzt9TH5Xw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c+AIcRJVDYhTG3kaCg6bt6LJlnhvJBhT1w47sJhtclwUFoRBkz26ZS0jgO2JyLWL+
	 8xoldGyc04P3cLc6YWpfFQi0gZuh1OgZkjCTL2bCT6N2/VL8005fsBnMpsVYuIMUL1
	 o9Uj9RetElj0tBjSLNELbdT3Wlc5tSSwXpcEQFQNfhtXbhAPzROLhVOEkW/jhdVI8m
	 HJXXy8datAIt5ltlewwVVYylW6GSORoFDQzgZbVV1EKgm61cFtqDKY9kElDeOijB6S
	 p0Sp+SdZze87rvOi4Yu5AXrAJbvXshJq2pQ+RiGeaN29FF4uZsdb/6g2ick2qr1Pba
	 l19PqhPQt0GVA==
Date: Mon, 26 Feb 2024 18:30:30 -0800
Subject: [PATCH 1/2] xfs: ensure unlinked list state is consistent with nlink
 during scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900014076.939412.5263933989053425912.stgit@frogsfrogsfrogs>
In-Reply-To: <170900014056.939412.3163260522615205535.stgit@frogsfrogsfrogs>
References: <170900014056.939412.3163260522615205535.stgit@frogsfrogsfrogs>
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
index eab380e95ef40..2105026d178a2 100644
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
index 1eee2f9ad265e..e6588790e39ae 100644
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
@@ -2263,7 +2260,7 @@ xfs_iunlink_remove_inode(
 /*
  * Pull the on-disk inode from the AGI unlinked list.
  */
-STATIC int
+int
 xfs_iunlink_remove(
 	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c6e0590c39b67..e15634fcb2638 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -613,6 +613,8 @@ extern struct kmem_cache	*xfs_inode_cache;
 bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip);
 
 void xfs_end_io(struct work_struct *work);
 

