Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBA5BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A7oFt3Dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A41C433C8;
	Sun, 31 Dec 2023 21:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059372;
	bh=vDnwoHAB1eBho+zBA+qQfED9aA/Botcm3gDy2ekM6Z0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A7oFt3DtVV2XKm1y6z3KFV8H0tZW5t5Gn2P91u4Gb/OmzlWNfO5Z45zleBaWy8STh
	 63v5VtSBOk8IeZ59eljgOrgV6VhZ3715GOeFwoHTWylEzshT0975eboCwoQDNDmbfR
	 vZ4/7TZe5j5TG/PA1mZfEfk+WG2FW0DLRsTPtJzdt/1uZcCGmN4ywWb/DLzWfTbiK8
	 w90WE42riL4FppBpm8iNO1MWvRWEuPPkHnlcUEomNoPpwlZmoVzPtGGtUVxCRtfo3I
	 fGo/gAoIPdJKk0z6iMtV1HT2r96B3XHaO7flfL6SkC0qleZ3elFMqBXJ2H3Lxp1OYJ
	 frDxbHGw//MJQ==
Date: Sun, 31 Dec 2023 13:49:31 -0800
Subject: [PATCH 19/44] xfs: enable CoW for realtime data
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851888.1766284.906833932864734256.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Update our write paths to support copy on write on the rt volume.  This
works in more or less the same way as it does on the data device, with
the major exception that we never do delalloc on the rt volume.

Because we consider unwritten CoW fork staging extents to be incore
quota reservation, we update xfs_quota_reserve_blkres to support this
case.  Though xfs doesn't allow rt and quota together, the change is
trivial and we shouldn't leave a logic bomb here.

While we're at it, add a missing xfs_mod_delalloc call when we remove
delalloc block reservation from the inode.  This is largely irrelvant
since realtime files do not use delalloc, but we want to avoid leaving
logic bombs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c   |   61 ++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_quota.h       |    6 +----
 fs/xfs/xfs_reflink.c     |   36 +++++++++++++++++++++------
 fs/xfs/xfs_trans_dquot.c |   11 ++++++++
 4 files changed, 90 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ef8658a9724dd..a7a99177bbf8b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -71,6 +71,55 @@ xfs_zero_extent(
 }
 
 #ifdef CONFIG_XFS_RT
+
+/* Update all inode and quota accounting for the allocation we just did. */
+static void
+xfs_bmap_rtalloc_accounting(
+	struct xfs_bmalloca	*ap)
+{
+	if (ap->flags & XFS_BMAPI_COWFORK) {
+		/*
+		 * COW fork blocks are in-core only and thus are treated as
+		 * in-core quota reservation (like delalloc blocks) even when
+		 * converted to real blocks. The quota reservation is not
+		 * accounted to disk until blocks are remapped to the data
+		 * fork. So if these blocks were previously delalloc, we
+		 * already have quota reservation and there's nothing to do
+		 * yet.
+		 */
+		if (ap->wasdel) {
+			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+			return;
+		}
+
+		/*
+		 * Otherwise, we've allocated blocks in a hole. The transaction
+		 * has acquired in-core quota reservation for this extent.
+		 * Rather than account these as real blocks, however, we reduce
+		 * the transaction quota reservation based on the allocation.
+		 * This essentially transfers the transaction quota reservation
+		 * to that of a delalloc extent.
+		 */
+		ap->ip->i_delayed_blks += ap->length;
+		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
+				XFS_TRANS_DQ_RES_RTBLKS, -(long)ap->length);
+		return;
+	}
+
+	/* data fork only */
+	ap->ip->i_nblocks += ap->length;
+	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+	if (ap->wasdel) {
+		ap->ip->i_delayed_blks -= ap->length;
+		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+	}
+
+	/* Adjust the disk quota also. This was reserved earlier. */
+	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
+			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
+				     XFS_TRANS_DQ_RTBCOUNT, ap->length);
+}
+
 int
 xfs_bmap_rtalloc(
 	struct xfs_bmalloca	*ap)
@@ -166,17 +215,7 @@ xfs_bmap_rtalloc(
 	if (rtx != NULLRTEXTNO) {
 		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
 		ap->length = xfs_rtxlen_to_extlen(mp, ralen);
-		ap->ip->i_nblocks += ap->length;
-		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
-		if (ap->wasdel)
-			ap->ip->i_delayed_blks -= ap->length;
-		/*
-		 * Adjust the disk quota also. This was reserved
-		 * earlier.
-		 */
-		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
-			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
-					XFS_TRANS_DQ_RTBCOUNT, ap->length);
+		xfs_bmap_rtalloc_accounting(ap);
 		return 0;
 	}
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 55320c9ff1367..165013f03db9e 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -129,11 +129,7 @@ extern void xfs_qm_mount_quotas(struct xfs_mount *);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
-static inline int
-xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
-{
-	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
-}
+int xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks);
 bool xfs_inode_near_dquot_enforcement(struct xfs_inode *ip, xfs_dqtype_t type);
 
 # ifdef CONFIG_XFS_LIVE_HOOKS
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 8e352b23dacf2..ed9f4ca34fcea 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -434,20 +434,26 @@ xfs_reflink_fill_cow_hole(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	xfs_filblks_t		resaligned;
-	xfs_extlen_t		resblks;
+	unsigned int		dblocks = 0, rblocks = 0;
 	int			nimaps;
 	int			error;
 	bool			found;
 
 	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
 		imap->br_blockcount, xfs_get_cowextsz_hint(ip));
-	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+		rblocks = resaligned;
+	} else {
+		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
+		rblocks = 0;
+	}
 
 	xfs_iunlock(ip, *lockmode);
 	*lockmode = 0;
 
-	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
-			false, &tp);
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
+			rblocks, false, &tp);
 	if (error)
 		return error;
 
@@ -1236,7 +1242,7 @@ xfs_reflink_remap_extent(
 	struct xfs_trans	*tp;
 	xfs_off_t		newlen;
 	int64_t			qdelta = 0;
-	unsigned int		resblks;
+	unsigned int		dblocks, rblocks, resblks;
 	bool			quota_reserved = true;
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
@@ -1267,8 +1273,15 @@ xfs_reflink_remap_extent(
 	 * we're remapping.
 	 */
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		dblocks = resblks;
+		rblocks = dmap->br_blockcount;
+	} else {
+		dblocks = resblks + dmap->br_blockcount;
+		rblocks = 0;
+	}
 	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
-			resblks + dmap->br_blockcount, 0, false, &tp);
+			dblocks, rblocks, false, &tp);
 	if (error == -EDQUOT || error == -ENOSPC) {
 		quota_reserved = false;
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
@@ -1348,8 +1361,15 @@ xfs_reflink_remap_extent(
 	 * done.
 	 */
 	if (!quota_reserved && !smap_real && dmap_written) {
-		error = xfs_trans_reserve_quota_nblks(tp, ip,
-				dmap->br_blockcount, 0, false);
+		if (XFS_IS_REALTIME_INODE(ip)) {
+			dblocks = 0;
+			rblocks = dmap->br_blockcount;
+		} else {
+			dblocks = dmap->br_blockcount;
+			rblocks = 0;
+		}
+		error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks,
+				false);
 		if (error)
 			goto out_cancel;
 	}
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 6983e35b7c2b7..5a0bdc8e06fca 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -1020,3 +1020,14 @@ xfs_trans_free_dqinfo(
 	kmem_cache_free(xfs_dqtrx_cache, tp->t_dqinfo);
 	tp->t_dqinfo = NULL;
 }
+
+int
+xfs_quota_reserve_blkres(
+	struct xfs_inode	*ip,
+	int64_t			blocks)
+{
+	if (XFS_IS_REALTIME_INODE(ip))
+		return xfs_trans_reserve_quota_nblks(NULL, ip, 0, blocks,
+				false);
+	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
+}

