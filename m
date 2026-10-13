Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A1E30ACE6
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871379; cv=none; b=a/mqn1sDHQor2Qw4d2lyGpRDG7c213utuPY1AYCsmsZTA7vkAI37ufUVXrnBreX7qm/KoivEn4/0ltQ9fE498+vHQ2rfUuYVopaASXXaSddAn1yswHs733pwLgIrSgSWJxocTgdhs4Kevo/BXiB2Q0n082Sjc4pE7hRIASBajfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871379; c=relaxed/simple;
	bh=H9O603esoQknBfrs9YQpIU8iA/W5+7vPwU/nBCIBzHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqQeIrJWC6/RzDDIGcnw7Megr/vNlcV/icuYWT75YgR4pqsoTWV/2KoPcqDmDiccs7iSTuNfRec29jhtevx++RLZ9szQ6srux8wg7fLMEX5jg1mh1Yi1aB4uxZrZFpOy/i8W/Hw3dVsqYYLHlQjazZ2bMaMa2GWNV2IEVTAiU9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctKdtEwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctKdtEwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB8C1F000FF;
	Tue, 13 Oct 2026 06:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871377;
	bh=cWUNmI4rcjPD+brR+kNwxqMpxzEhBBfbFhZ+U0KlQCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ctKdtEwLSpBlPgnukGqoNil+K3Z1FKGObqggL+mVO3Nto8+vDfeq9Oe96md92OM83
	 S7rUBxsEgA5z5wbfspKlVp2ZZOT4op1NsxS8w1JYKC/w3ZaesP184+KH6RwbPMhybh
	 GnZrRUeTRW/zkvsF2orxFodXw4BdygNGCzhfzl1slJZGBvbVjBwTa3s/k6OPrNWSw3
	 y5YnRB/FuzHF1NNzu9PDXif7H2afceuc5dZhZ8vRCRyDZu3SQ3P9ZGjSLp1dPUEk6Q
	 wk1y11BKX+4aHn4vOTEl2GPUWXK+UCfcoMi1xlIMVWtRpI+Y5vLstua21WxMnwXAB6
	 WOkxthrx0QO5g==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 39/48] xfs: validate logged extent fork contents during recovery
Date: Tue, 13 Oct 2026 17:01:29 +1100
Message-ID: <20261013060204.3138690-40-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
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
 fs/xfs/xfs_inode_item_recover.c | 32 ++++++++++++++++++++--
 5 files changed, 91 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9bffde1484a7..a89c2076e7c9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1090,12 +1090,12 @@ struct xfs_iread_state {
 
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
@@ -1107,7 +1107,7 @@ xfs_bmap_complain_bad_rec(
 
 	xfs_warn(mp,
  "Bmap BTree record corruption in inode 0x%llx %s fork detected at %pS!",
-				I_INO(ip), forkname, fa);
+				ino, forkname, fa);
 	xfs_warn(mp,
 		"Offset 0x%llx, start block 0x%llx, block count 0x%llx state 0x%x",
 		irec->br_startoff, irec->br_startblock, irec->br_blockcount,
@@ -1160,8 +1160,8 @@ xfs_iread_bmbt_block(
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
@@ -6135,6 +6135,39 @@ xfs_bmap_validate_extent(
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
@@ -6196,8 +6229,9 @@ xfs_bmap_query_range_helper(
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
index 60f6df4ce057..6d9c61994be8 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -275,8 +275,12 @@ xfs_failaddr_t xfs_bmap_validate_extent_raw(struct xfs_mount *mp, bool rtfile,
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
index fac592e1852c..f4af3c18ddc2 100644
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
index e1a7a2729b47..191ef85055e0 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -869,11 +869,9 @@ xrep_dinode_bad_extents_fork(
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
@@ -882,15 +880,9 @@ xrep_dinode_bad_extents_fork(
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
index c987d4cd0285..3e0109833d21 100644
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
@@ -443,6 +444,31 @@ xlog_dinode_verify(
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
+	return xfs_bmap_validate_extent_array(mp, ldip->di_ino, isrt, whichfork,
+			src, size / sizeof(struct xfs_bmbt_rec));
+}
+
 /*
  * Verify a logged shortform symlink target. The logged target is the on-disk
  * form, which is not null terminated, so this cannot use
@@ -538,7 +564,8 @@ xlog_dinode_verify_dfork(
 			return __this_address;
 		if (ilfp->ilf_dsize > fork_size)
 			return __this_address;
-		break;
+		return xlog_dinode_verify_extents(mp, ldip, XFS_DATA_FORK,
+				item->ri_buf[2].iov_base, ilfp->ilf_dsize);
 	case XFS_DINODE_FMT_BTREE:
 	case XFS_DINODE_FMT_META_BTREE:
 		if (field != XFS_ILOG_DBROOT)
@@ -596,7 +623,8 @@ xlog_dinode_verify_afork(
 			return __this_address;
 		if (ilfp->ilf_asize > fork_size)
 			return __this_address;
-		break;
+		return xlog_dinode_verify_extents(mp, ldip, XFS_ATTR_FORK,
+				item->ri_buf[region].iov_base, ilfp->ilf_asize);
 	case XFS_DINODE_FMT_BTREE:
 		if (field != XFS_ILOG_ABROOT)
 			return __this_address;
-- 
2.55.0

