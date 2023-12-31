Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54878BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uOW94Tep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20787C433C8;
	Sun, 31 Dec 2023 21:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058558;
	bh=WmUnPLLXqbFbDN+61WQ7MtxTARtPwv+692jaBDERyCo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uOW94TeprS2wXb153uEe0r+6Z1gcyOQOWQMToslpx3o+wwPOK3xMorrFjSsQ9rUDa
	 c7shFqXm1CPqYpKBR4/h5NkjuQ4yMMJyHV41CVcz7fmENdt0SuT1obUfAU4ZlwfY09
	 3CK0DVLwgHUm4TZMKL3WUqFQdmiILRgyExveJ/rm5hH+1bM0Kwh1lBQzWNfSOARSow
	 RJwFLmDIMEqVaApxmk5TocN5SVohCusNkBR4mZgknk9SP1xiAZ5gvWjw909BreNqag
	 Bsesk8Zzi6EPBCmAmn68BY+p0CRa18Tfcgp7kzJDpH+lQg2wPgsvceZ1Z79nZtXmht
	 1jGk1aSV3tz9g==
Date: Sun, 31 Dec 2023 13:35:57 -0800
Subject: [PATCH 16/39] xfs: wire up rmap map and unmap to the realtime rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850159.1764998.17772260162651574654.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Connect the map and unmap reverse-mapping operations to the realtime
rmapbt via the deferred operation callbacks.  This enables us to
perform rmap operations against the correct btree.

[Contains a minor bugfix from hch]

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c    |   37 ++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_rtgroup.c |    9 +++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |    5 ++++-
 3 files changed, 47 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index daef2d67eb7a0..8766805ed1343 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -26,6 +26,7 @@
 #include "xfs_health.h"
 #include "xfs_rmap_item.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -2692,9 +2693,39 @@ xfs_rtrmap_finish_one(
 	struct xfs_rmap_intent		*ri,
 	struct xfs_btree_cur		**pcur)
 {
-	/* coming in a subsequent patch */
-	ASSERT(0);
-	return -EFSCORRUPTED;
+	struct xfs_owner_info		oinfo;
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*rcur = *pcur;
+	xfs_rgnumber_t			rgno;
+	xfs_rgblock_t			bno;
+	bool				unwritten;
+
+	trace_xfs_rmap_deferred(mp, ri);
+
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE))
+		return -EIO;
+
+	/*
+	 * If we haven't gotten a cursor or the cursor rtgroup doesn't match
+	 * the startblock, get one now.
+	 */
+	if (rcur != NULL && rcur->bc_ino.rtg != ri->ri_rtg) {
+		xfs_btree_del_cursor(rcur, 0);
+		rcur = NULL;
+	}
+	if (rcur == NULL) {
+		xfs_rtgroup_lock(tp, ri->ri_rtg, XFS_RTGLOCK_RMAP);
+		*pcur = rcur = xfs_rtrmapbt_init_cursor(mp, tp, ri->ri_rtg,
+				ri->ri_rtg->rtg_rmapip);
+	}
+
+	xfs_rmap_ino_owner(&oinfo, ri->ri_owner, ri->ri_whichfork,
+			ri->ri_bmap.br_startoff);
+	unwritten = ri->ri_bmap.br_state == XFS_EXT_UNWRITTEN;
+	bno = xfs_rtb_to_rgbno(mp, ri->ri_bmap.br_startblock, &rgno);
+
+	return __xfs_rmap_finish_intent(rcur, ri->ri_type, bno,
+			ri->ri_bmap.br_blockcount, &oinfo, unwritten);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 7a45a16cbbab8..6ffe1c21a1ea4 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -552,6 +552,12 @@ xfs_rtgroup_lock(
 		xfs_rtbitmap_lock(tp, rtg->rtg_mount);
 	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
 		xfs_rtbitmap_lock_shared(rtg->rtg_mount, XFS_RBMLOCK_BITMAP);
+
+	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg->rtg_rmapip) {
+		xfs_ilock(rtg->rtg_rmapip, XFS_ILOCK_EXCL);
+		if (tp)
+			xfs_trans_ijoin(tp, rtg->rtg_rmapip, XFS_ILOCK_EXCL);
+	}
 }
 
 /* Unlock metadata inodes associated with this rt group. */
@@ -564,6 +570,9 @@ xfs_rtgroup_unlock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
+	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg->rtg_rmapip)
+		xfs_iunlock(rtg->rtg_rmapip, XFS_ILOCK_EXCL);
+
 	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
 		xfs_rtbitmap_unlock(rtg->rtg_mount);
 	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 77503bda35563..559a5135820d3 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -231,9 +231,12 @@ int xfs_rtgroup_init_secondary_super(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 #define XFS_RTGLOCK_BITMAP		(1U << 0)
 /* Lock the rt bitmap inode in shared mode */
 #define XFS_RTGLOCK_BITMAP_SHARED	(1U << 1)
+/* Lock the rt rmap inode in exclusive mode */
+#define XFS_RTGLOCK_RMAP		(1U << 2)
 
 #define XFS_RTGLOCK_ALL_FLAGS	(XFS_RTGLOCK_BITMAP | \
-				 XFS_RTGLOCK_BITMAP_SHARED)
+				 XFS_RTGLOCK_BITMAP_SHARED | \
+				 XFS_RTGLOCK_RMAP)
 
 void xfs_rtgroup_lock(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);

