Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E942157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225074; cv=none; b=hYAqJThncC0EEInxLPb68ZA/HrieDRRRnKxgysRxZrqk2HuPY+bW+EdVSst0sbvzMhZYFzh2VEJXoV7kjyEBv1cS5hKFSaa5viOaMLeZhbwGdK4/87dZgmndxtaSFD41MDv+lFEKu4/Gn9XmWxj351Dlhh45n5ag6sg08ZPv8kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225074; c=relaxed/simple;
	bh=Dnm5DB6xBzqmyF3K8FLGCXJLMPEG+86HSvFImWXTqLs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kgsjcdr8a6betBnnAj9Q0eGgylQ/Ra6VjiPXgd6IihYdL/T9b4V7XwJIWLV/dVDmH/ndzYm6IiOmL5sNIhEsWD1+vu1/eK9zRzRxAQqRPNefBQLeOJh7bAzuk62a9xlaXNg4AUSOiLyTKEIEBg/GbGMKjTtefeyaVj7JZvxW9gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NzTlwNSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NzTlwNSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5E5C113CC;
	Mon, 15 Apr 2024 23:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225074;
	bh=Dnm5DB6xBzqmyF3K8FLGCXJLMPEG+86HSvFImWXTqLs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NzTlwNSZxTeiJWnUBimCqiHircPKKX5s9Iv5EGs9EhcRSbkQZhYL7ib6iRbuq/DFF
	 loCuaWdC+A2IYoQW5P5lyNQIJfPnyyc3+5aFoz3QgosLBiY8lHIjeWM+FMB9fIhmQ5
	 w5N2cJfluLQb62NzLAD4jI8HbtheprT+va+HQg7he+w3QC9txMdDP5TTTcNy6ZhT57
	 21PkhKqs5POGJV3YhVsAvO+swBc5+YEizuoTvGPNHKUVXPBkywesBoZ9iRkdTkpvuA
	 Hu46nmDGEZ/r7zNj3hIvCHusAEwvaCyVpNd0yrtdJ3HqZMHKm9dY54bf8Hq9qc1V5O
	 yMJjQMadNQPfw==
Date: Mon, 15 Apr 2024 16:51:13 -0700
Subject: [PATCH 1/2] xfs: ensure unlinked list state is consistent with nlink
 during scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322383527.89063.16564193593726668059.stgit@frogsfrogsfrogs>
In-Reply-To: <171322383505.89063.1663567277512574374.stgit@frogsfrogsfrogs>
References: <171322383505.89063.1663567277512574374.stgit@frogsfrogsfrogs>
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
index 6e2fe2d6250b..d32716fb2fec 100644
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
index 097afba3043f..c743772a523e 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1745,6 +1745,46 @@ xrep_inode_problems(
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
@@ -1794,5 +1834,10 @@ xrep_inode(
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
index ac92c0525d9b..b24c0e23d37d 100644
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
@@ -2252,7 +2249,7 @@ xfs_iunlink_remove_inode(
 /*
  * Pull the on-disk inode from the AGI unlinked list.
  */
-STATIC int
+int
 xfs_iunlink_remove(
 	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 596eec715675..8157ae7f8e59 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -617,6 +617,8 @@ extern struct kmem_cache	*xfs_inode_cache;
 bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip);
 
 void xfs_end_io(struct work_struct *work);
 

