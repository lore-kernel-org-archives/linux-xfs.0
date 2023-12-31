Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F94C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RxmNCuln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A76AC433C7;
	Sun, 31 Dec 2023 23:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065344;
	bh=qQe2NNCEL3ErtVPC72lc6a5PnxYfgBqymylUeTPPfdo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RxmNCulnRg8sY5BTDtmjONgQphjPXRu+eKvaZkwvOJess9apPpdbYkKMlyVfDy4qZ
	 iKyKLWkI7GBg1IVR8WQCWMUcABEnViQP/l6eh6OtiCJzN1XB848V+NsZSxGccOuk5u
	 62js+iJt/zLzwU5WPx+dhbe97oI6LjRVlC+mMbPbpYpFN2OlWsOZsIWiFPbJNBV/gR
	 o1YHZ/fI68Lgshx2FIuKYi0yjO1uZ/IpaKIzLCd7V0990aPfe9jclUm+v7o7o2iVvS
	 e8gz1IhRqA9aVr6tEZ5MmYuwXwYNKE/vC6qMxnnJnQDbfXG9bLAp+VNhYM+1/rzwo3
	 9/TN/PB8hqugA==
Date: Sun, 31 Dec 2023 15:29:04 -0800
Subject: [PATCH 26/28] xfs_db: port the iunlink command to use the libxfs
 iunlink function
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009521.1808635.799051296564572900.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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

Now that we've ported the kernel's iunlink code to userspace, adapt the
debugger command to use it instead of duplicating the logic.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/iunlink.c             |  110 ----------------------------------------------
 libxfs/libxfs_api_defs.h |    1 
 2 files changed, 2 insertions(+), 109 deletions(-)


diff --git a/db/iunlink.c b/db/iunlink.c
index af452d028bd..c87b98431e5 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -197,114 +197,6 @@ static const cmdinfo_t	dump_iunlinked_cmd =
 	  N_("[-a agno] [-b bucket] [-q] [-v]"),
 	  N_("dump chain of unlinked inode buckets"), NULL };
 
-/*
- * Look up the inode cluster buffer and log the on-disk unlinked inode change
- * we need to make.
- */
-static int
-iunlink_log_dinode(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	struct xfs_perag	*pag,
-	xfs_agino_t		next_agino)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_dinode	*dip;
-	struct xfs_buf		*ibp;
-	int			offset;
-	int			error;
-
-	error = -libxfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
-	if (error)
-		return error;
-
-	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
-
-	dip->di_next_unlinked = cpu_to_be32(next_agino);
-	offset = ip->i_imap.im_boffset +
-			offsetof(struct xfs_dinode, di_next_unlinked);
-
-	libxfs_dinode_calc_crc(mp, dip);
-	libxfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
-	return 0;
-}
-
-static int
-iunlink_insert_inode(
-	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
-	struct xfs_buf		*agibp,
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi = agibp->b_addr;
-	xfs_agino_t		next_agino;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
-	int			offset;
-	int			error;
-
-	/*
-	 * Get the index into the agi hash table for the list this inode will
-	 * go on.  Make sure the pointer isn't garbage and that this inode
-	 * isn't already on the list.
-	 */
-	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	if (next_agino == agino || !xfs_verify_agino_or_null(pag, next_agino))
-		return EFSCORRUPTED;
-
-	if (next_agino != NULLAGINO) {
-		/*
-		 * There is already another inode in the bucket, so point this
-		 * inode to the current head of the list.
-		 */
-		error = iunlink_log_dinode(tp, ip, pag, next_agino);
-		if (error)
-			return error;
-	}
-
-	/* Update the bucket. */
-	agi->agi_unlinked[bucket_index] = cpu_to_be32(agino);
-	offset = offsetof(struct xfs_agi, agi_unlinked) +
-			(sizeof(xfs_agino_t) * bucket_index);
-	libxfs_trans_log_buf(tp, agibp, offset,
-			offset + sizeof(xfs_agino_t) - 1);
-	return 0;
-}
-
-/*
- * This is called when the inode's link count has gone to 0 or we are creating
- * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
- *
- * We place the on-disk inode on a list in the AGI.  It will be pulled from this
- * list when the inode is freed.
- */
-static int
-iunlink(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_perag	*pag;
-	struct xfs_buf		*agibp;
-	int			error;
-
-	ASSERT(VFS_I(ip)->i_nlink == 0);
-	ASSERT(VFS_I(ip)->i_mode != 0);
-
-	pag = libxfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = -libxfs_read_agi(pag, tp, &agibp);
-	if (error)
-		goto out;
-
-	error = iunlink_insert_inode(tp, pag, agibp, ip);
-out:
-	libxfs_perag_put(pag);
-	return error;
-}
-
 static int
 create_unlinked(
 	struct xfs_mount	*mp)
@@ -341,7 +233,7 @@ create_unlinked(
 		goto out_cancel;
 	}
 
-	error = iunlink(tp, ip);
+	error = -libxfs_iunlink(tp, ip);
 	if (error) {
 		dbprintf(_("unlink inode: %s\n"), strerror(error));
 		goto out_rele;
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index de59d6cdb5d..58c643d7535 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -185,6 +185,7 @@
 
 #define xfs_iread_extents		libxfs_iread_extents
 #define xfs_irele			libxfs_irele
+#define xfs_iunlink			libxfs_iunlink
 #define xfs_link_space_res		libxfs_link_space_res
 #define xfs_log_calc_minimum_size	libxfs_log_calc_minimum_size
 #define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res

