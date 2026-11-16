Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871097;
	b=V//MWJQI7sTPAuGThK3fwM9IEzTnsneCfvHGaTkPEVQiAgsTj3tGvQO16kYd0OUYMuwC
	 8+w2B89wCNhWrQMcMaO3mQsYdQIEj4bK0n+y37Xw4GfbM6m7QLMJSgnccvzEXhTXgbTWh
	 eeFPxOfgdzvqDeBrHrQKEalMApx2byrMQ5PYSbmz+4UCeTPeIN4fg9mRN/egRWvUcr0X0
	 xR4ggQzEXDxcg9oT6KlR08vphTdP4DKyGO0HrkdQYzf5JefXdxQPkclYS9NHAzC522LJh
	 NuexWdNTDJH2cDBARZFUFuvJZoYGH+2coVUi5/Gtqr8oIoNHIVDYBozVlAuZrCxPdTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=vM3V9UmPGPZN4kmj6qneI+pOgjuL8OAGLHEXQTvtbBc=;
	b=DDzRMxln4n68hkVo8rIzN7VXxyOFVCd4i2NIzf1kEsQDRkUFIGuoJlpNwsbz8HUdVShB
	 k+eGbN5KSNxjExIFyklkwBc7yHuljFqL8ZFk/0RSAsUR71OPlFuTNRRo34FLZur0I5zaw
	 w1Sb82BjKn0jy5jKVBQA+CaZRF3L3JsgmRx/8/3pfZL5v/M6JCkX9T0v0mLvfbqOysWeI
	 Dnj0DHtpvw/niYfm/zKUM/C21DiRkvvyMfy7dGTXcuAfu7uIgdoqDVwyKt5DGCPYrotWP
	 BAHfImifRAIrZNGsbM4SNo+hF6SG6wEKFpDiOwgAFY5Kvvn4/Tr4m6f19QM4V7JAxJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EG1QyCH2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5ABA606A330
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EG1QyCH2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD451F000C9;
	Mon, 16 Nov 2026 23:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871097;
	bh=vM3V9UmPGPZN4kmj6qneI+pOgjuL8OAGLHEXQTvtbBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EG1QyCH21P2Yic1j8xS/eCITK+8LcvMnpxeusJZNiagU2VMSd9IM0SQbv/A4GQzGo
	 mJOdNgwOPGBAoMdPMnbtCkCBQSGK8g4UzQuTZAnbtLqEhYCxp1fc9Uld+ycp9qA1qK
	 5Mg5GZtI8JVbOQa5fFVZpiIsFNrArYt3N4wg3b6A06eEPJdlzbnlpYF6Mf6PKLEEZq
	 9HObZWuj+/9w1y23j3HowEzS7GJlNMjG+jlj3Xq03UqgkDuh6sP53Lm6CBrRfPUuf2
	 1yw3joQvmTtrWi3Cuhfvu7TUU2/2Zo8QFYNv3//XCDWTLSniu2txhFgUhcVEAEel3p
	 zm0qnBb2MwBKQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 49/59] xfs: validate logged extent fork contents during recovery
Date: Tue, 17 Nov 2026 10:15:06 +1100
Message-ID: <20261116231707.3625263-50-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An extents format fork is logged as a packed array of on-disk extent records.
Recovery copied this array into the inode without inspecting it, so corrupt
extent records were replayed as they stood.

The existing verifiers open code the extent array walk for validation, so factor
that walk into xfs_bmap_validate_extent_array() and use it in all three places.
The on-disk reader now dumps the whole fork on a bad record rather than the
single record, so the failing record is still captured.

xfs_bmap_complain_bad_rec() is recast to take a mount and inode number rather
than an incore inode, so the array walk can report a bad record on behalf of any
caller. The walk reports against the inode number it is passed, and stays silent
when passed NULLFSINO.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c        | 48 ++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_bmap.h        |  8 ++++--
 fs/xfs/libxfs/xfs_inode_fork.c  | 23 ++++++++--------
 fs/xfs/scrub/inode_repair.c     | 14 +++-------
 fs/xfs/xfs_inode_item_recover.c | 35 ++++++++++++++++++++++--
 5 files changed, 94 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ed081a5e4166..8dddde66de2a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1130,12 +1130,12 @@ struct xfs_iread_state {
 
 int
 xfs_bmap_complain_bad_rec(
-	struct xfs_inode		*ip,
+	struct xfs_mount		*mp,
+	xfs_ino_t			ino,
 	int				whichfork,
 	xfs_failaddr_t			fa,
 	const struct xfs_bmbt_irec	*irec)
 {
-	struct xfs_mount		*mp = ip->i_mount;
 	const char			*forkname;
 
 	switch (whichfork) {
@@ -1147,7 +1147,7 @@ xfs_bmap_complain_bad_rec(
 
 	xfs_warn(mp,
  "Bmap BTree record corruption in inode 0x%llx %s fork detected at %pS!",
-				I_INO(ip), forkname, fa);
+				ino, forkname, fa);
 	xfs_warn(mp,
 		"Offset 0x%llx, start block 0x%llx, block count 0x%llx state 0x%x",
 		irec->br_startoff, irec->br_startblock, irec->br_blockcount,
@@ -1200,8 +1200,8 @@ xfs_iread_bmbt_block(
 					"xfs_iread_extents(2)", frp,
 					sizeof(*frp), fa);
 			xfs_bmap_mark_sick(ip, whichfork);
-			return xfs_bmap_complain_bad_rec(ip, whichfork, fa,
-					&new);
+			return xfs_bmap_complain_bad_rec(ip->i_mount,
+					I_INO(ip), whichfork, fa, &new);
 		}
 		xfs_iext_insert(ip, &ir->icur, &new,
 				xfs_bmap_fork_to_state(whichfork));
@@ -6102,6 +6102,39 @@ xfs_bmap_validate_extent(
 			XFS_IS_REALTIME_INODE(ip), whichfork, irec);
 }
 
+/*
+ * Check a packed on-disk array of extent records. Returns the address of the
+ * first bad record, or NULL if they are all good. If ino is not NULLFSINO, a
+ * bad record is also reported against that inode.
+ */
+xfs_failaddr_t
+xfs_bmap_validate_extent_array(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	bool			rtfile,
+	int			whichfork,
+	struct xfs_bmbt_rec	*recs,
+	xfs_extnum_t		nrecs)
+{
+	xfs_extnum_t		i;
+
+	for (i = 0; i < nrecs; i++) {
+		struct xfs_bmbt_irec	irec;
+		xfs_failaddr_t		fa;
+
+		xfs_bmbt_disk_get_all(&recs[i], &irec);
+		fa = xfs_bmap_validate_extent_raw(mp, rtfile, whichfork, &irec);
+		if (fa) {
+			if (ino != NULLFSINO)
+				xfs_bmap_complain_bad_rec(mp, ino, whichfork,
+						fa, &irec);
+			return fa;
+		}
+	}
+
+	return NULL;
+}
+
 /*
  * Used in xfs_itruncate_extents().  This is the maximum number of extents
  * freed from a file in a single transaction.
@@ -6163,8 +6196,9 @@ xfs_bmap_query_range_helper(
 			&irec);
 	if (fa) {
 		xfs_btree_mark_sick(cur);
-		return xfs_bmap_complain_bad_rec(cur->bc_ino.ip,
-				cur->bc_ino.whichfork, fa, &irec);
+		return xfs_bmap_complain_bad_rec(cur->bc_mp,
+				I_INO(cur->bc_ino.ip), cur->bc_ino.whichfork,
+				fa, &irec);
 	}
 
 	return query->fn(cur, &irec, query->priv);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index ab870415c505..26c80926278f 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -291,8 +291,12 @@ xfs_failaddr_t xfs_bmap_validate_extent_raw(struct xfs_mount *mp, bool rtfile,
 		int whichfork, struct xfs_bmbt_irec *irec);
 xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *irec);
-int xfs_bmap_complain_bad_rec(struct xfs_inode *ip, int whichfork,
-		xfs_failaddr_t fa, const struct xfs_bmbt_irec *irec);
+xfs_failaddr_t xfs_bmap_validate_extent_array(struct xfs_mount *mp,
+		xfs_ino_t ino, bool rtfile, int whichfork,
+		struct xfs_bmbt_rec *recs, xfs_extnum_t nrecs);
+int xfs_bmap_complain_bad_rec(struct xfs_mount *mp, xfs_ino_t ino,
+		int whichfork, xfs_failaddr_t fa,
+		const struct xfs_bmbt_irec *irec);
 
 int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index d856174ed8fa..79f4fce650ff 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -138,23 +138,22 @@ xfs_iformat_extents(
 	ifp->if_data = NULL;
 	ifp->if_height = 0;
 	if (size) {
+		xfs_failaddr_t	fa;
+
 		dp = (xfs_bmbt_rec_t *) XFS_DFORK_PTR(dip, whichfork);
 
+		fa = xfs_bmap_validate_extent_array(mp, I_INO(ip),
+				XFS_IS_REALTIME_INODE(ip), whichfork, dp, nex);
+		if (fa) {
+			xfs_inode_verifier_error(ip, -EFSCORRUPTED,
+					"xfs_iformat_extents(2)", dp, size, fa);
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
+			return -EFSCORRUPTED;
+		}
+
 		xfs_iext_first(ifp, &icur);
 		for (i = 0; i < nex; i++, dp++) {
-			xfs_failaddr_t	fa;
-
 			xfs_bmbt_disk_get_all(dp, &new);
-			fa = xfs_bmap_validate_extent(ip, whichfork, &new);
-			if (fa) {
-				xfs_inode_verifier_error(ip, -EFSCORRUPTED,
-						"xfs_iformat_extents(2)",
-						dp, sizeof(*dp), fa);
-				xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
-				return xfs_bmap_complain_bad_rec(ip, whichfork,
-						fa, &new);
-			}
-
 			xfs_iext_insert(ip, &icur, &new, state);
 			trace_xfs_read_extent(ip, &icur, state, _THIS_IP_);
 			xfs_iext_next(ifp, &icur);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index dbd42976bdcd..2dd3ea7fb361 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -873,11 +873,9 @@ xrep_dinode_bad_extents_fork(
 	unsigned int		dfork_size,
 	int			whichfork)
 {
-	struct xfs_bmbt_irec	new;
 	struct xfs_bmbt_rec	*dp;
 	xfs_extnum_t		nex;
 	bool			isrt;
-	unsigned int		i;
 
 	nex = xfs_dfork_nextents(dip, whichfork);
 	if (nex > dfork_size / sizeof(struct xfs_bmbt_rec))
@@ -886,15 +884,9 @@ xrep_dinode_bad_extents_fork(
 	dp = XFS_DFORK_PTR(dip, whichfork);
 
 	isrt = dip->di_flags & cpu_to_be16(XFS_DIFLAG_REALTIME);
-	for (i = 0; i < nex; i++, dp++) {
-		xfs_failaddr_t	fa;
-
-		xfs_bmbt_disk_get_all(dp, &new);
-		fa = xfs_bmap_validate_extent_raw(sc->mp, isrt, whichfork,
-				&new);
-		if (fa)
-			return true;
-	}
+	if (xfs_bmap_validate_extent_array(sc->mp, NULLFSINO, isrt, whichfork,
+			dp, nex))
+		return true;
 
 	return false;
 }
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index a2001716eeca..89a087d77aae 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -27,6 +27,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_metafile.h"
+#include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
@@ -443,6 +444,32 @@ xlog_dinode_verify(
 	return NULL;
 }
 
+/*
+ * Verify a logged extents fork. The region is a packed array of on-disk extent
+ * records, so its size fixes the number of records it holds.
+ *
+ * The region size has already been bounds checked against the inode fork size,
+ * so it is known to fit within the fork and does not need rechecking here.
+ */
+static xfs_failaddr_t
+xlog_dinode_verify_extents(
+	struct xfs_mount		*mp,
+	xfs_ino_t			ino,
+	struct xfs_log_dinode		*ldip,
+	int				whichfork,
+	void				*src,
+	unsigned int			size)
+{
+	bool				isrt;
+
+	if (size == 0 || (size % sizeof(struct xfs_bmbt_rec)))
+		return __this_address;
+
+	isrt = ldip->di_flags & XFS_DIFLAG_REALTIME;
+	return xfs_bmap_validate_extent_array(mp, ino, isrt, whichfork,
+			src, size / sizeof(struct xfs_bmbt_rec));
+}
+
 /*
  * Verify a logged shortform symlink target. The logged target is the on-disk
  * form, which is not null terminated, so this cannot use
@@ -538,7 +565,9 @@ xlog_dinode_verify_dfork(
 			return __this_address;
 		if (ilfp->ilf_dsize > fork_size)
 			return __this_address;
-		break;
+		return xlog_dinode_verify_extents(mp, ilfp->ilf_ino, ldip,
+				XFS_DATA_FORK, item->ri_buf[2].iov_base,
+				ilfp->ilf_dsize);
 	case XFS_DINODE_FMT_BTREE:
 	case XFS_DINODE_FMT_META_BTREE:
 		if (field != XFS_ILOG_DBROOT)
@@ -596,7 +625,9 @@ xlog_dinode_verify_afork(
 			return __this_address;
 		if (ilfp->ilf_asize > fork_size)
 			return __this_address;
-		break;
+		return xlog_dinode_verify_extents(mp, ilfp->ilf_ino, ldip,
+				XFS_ATTR_FORK, item->ri_buf[region].iov_base,
+				ilfp->ilf_asize);
 	case XFS_DINODE_FMT_BTREE:
 		if (field != XFS_ILOG_ABROOT)
 			return __this_address;
-- 
2.55.0

