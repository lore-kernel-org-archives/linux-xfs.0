Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B7A433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992250; cv=none; b=Z9aF/TxY4l7Qz7JXntbHJip2kSN6wA9yIoJ+wyZxzlOcSPJPVpWvJiLHCF2opyh1ZpbGOTc/IUKB6foBH4X8Os4XXuPUDLnyklpywP4kdc/F5HNMwk4x8+yo0Aqh7ZS7xnS2cZ8EKUqkjB2G7KygqoLyGx/O+kKZZQarEyEV38o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992250; c=relaxed/simple;
	bh=WNuIcaHvbJ2BKfZZqAj1nZaGuD5eDg4WR6ZmE1xrqNI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HBBWLRDwYYjfNf5Iacj7k83DPY6PR7QbIEzpVbd/rTKazhYdCQkyExetUledtmpAP+xmKRvA/s0/TH/s4v7GncoLOagrE2TcrbQph4F9Wj8PxKOezoN9k38lHLnf22PapSPuGdHyrgY5SZHlbnsp9/THYGe18YbwFuL7o1ULosk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=seDsKduq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="seDsKduq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133CCC4CED3;
	Mon, 23 Dec 2024 22:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992250;
	bh=WNuIcaHvbJ2BKfZZqAj1nZaGuD5eDg4WR6ZmE1xrqNI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=seDsKduqhWKIt45y7quei4kIrBk3o5WYQkk9lFMa0MhTM0S9JH+IZl+p6mCk25Xth
	 zeIcpjN8QWD5YvvjubJAYkGlHXLMdHztd212hfb6/MXuES6jgf2L7EH4ShykgKotip
	 qdxicYdpQWc0wQEY4QYJPeoajJlMxWQzDG1q7r01mMndpQpvBT/yPdmciXi9inAh8i
	 pe+tTsSx5vA9fW4jo7w2MxJBsCXZQoj6JhOayF1nmIg02eYEJUJVlZDkBKv4pSfMX+
	 rgkUOs4+Jk4zcZu7Ph4+7bE0BgAwJQPLSQmRjIPcc6wVeGsdSauFpWxZ3DeIdMmDeF
	 1tFAYxMrbhDLQ==
Date: Mon, 23 Dec 2024 14:17:29 -0800
Subject: [PATCH 22/51] xfs_repair: support realtime superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944141.2297565.9135988674963134278.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Support the realtime superblock feature.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/incore.c          |   12 ++++++++++
 repair/phase3.c          |    4 +++
 repair/rt.c              |   54 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/rt.h              |    3 +++
 repair/xfs_repair.c      |    4 +++
 6 files changed, 78 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 84965106358d61..dbdf5d100ec8e9 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -300,6 +300,7 @@
 
 #define xfs_rtfree_extent		libxfs_rtfree_extent
 #define xfs_rtfree_blocks		libxfs_rtfree_blocks
+#define xfs_update_rtsb			libxfs_update_rtsb
 #define xfs_sb_from_disk		libxfs_sb_from_disk
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
 #define xfs_sb_read_secondary		libxfs_sb_read_secondary
diff --git a/repair/incore.c b/repair/incore.c
index 2339d49a95773d..5b3d077f50e495 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -220,6 +220,15 @@ set_rtbmap(
 	 (((uint64_t) state) << ((rtx % XR_BB_NUM) * XR_BB)));
 }
 
+static void
+rtsb_init(
+	struct xfs_mount	*mp)
+{
+	/* The first rtx of the realtime device contains the super */
+	if (xfs_has_rtsb(mp) && rt_bmap)
+		set_rtbmap(0, XR_E_INUSE_FS);
+}
+
 static void
 reset_rt_bmap(void)
 {
@@ -245,6 +254,8 @@ init_rt_bmap(
 			mp->m_sb.sb_rextents);
 		return;
 	}
+
+	rtsb_init(mp);
 }
 
 static void
@@ -332,6 +343,7 @@ reset_bmaps(
 
 	if (xfs_has_rtgroups(mp)) {
 		reset_rtg_bmaps(mp);
+		rtsb_init(mp);
 	} else {
 		reset_rt_bmap();
 	}
diff --git a/repair/phase3.c b/repair/phase3.c
index ca4dbee47434c8..3a3ca22de14d26 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -17,6 +17,7 @@
 #include "progress.h"
 #include "bmap.h"
 #include "threads.h"
+#include "rt.h"
 
 static void
 process_agi_unlinked(
@@ -116,6 +117,9 @@ phase3(
 
 	set_progress_msg(PROG_FMT_AGI_UNLINKED, (uint64_t) glob_agcount);
 
+	if (xfs_has_rtsb(mp) && xfs_has_realtime(mp))
+		check_rtsb(mp);
+
 	/* first clear the agi unlinked AGI list */
 	if (!no_modify) {
 		for (i = 0; i < mp->m_sb.sb_agcount; i++)
diff --git a/repair/rt.c b/repair/rt.c
index 2de6830c931e86..102baa1d5d6186 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -562,3 +562,57 @@ free_rtgroup_inodes(void)
 	for (i = 0; i < XFS_RTGI_MAX; i++)
 		bitmap_free(&rtg_inodes[i]);
 }
+
+void
+check_rtsb(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	error = -libxfs_buf_read_uncached(mp->m_rtdev_targp, XFS_RTSB_DADDR,
+			XFS_FSB_TO_BB(mp, 1), 0, &bp, &xfs_rtsb_buf_ops);
+	if (!error) {
+		libxfs_buf_relse(bp);
+		return;
+	}
+
+	if (no_modify) {
+		do_warn(_("would rewrite realtime superblock\n"));
+		return;
+	}
+
+	/*
+	 * Rewrite the rt superblock so that an update to the primary fs
+	 * superblock will not get confused by the non-matching rtsb.
+	 */
+	do_warn(_("will rewrite realtime superblock\n"));
+	rewrite_rtsb(mp);
+}
+
+void
+rewrite_rtsb(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*rtsb_bp;
+	struct xfs_buf		*sb_bp = libxfs_getsb(mp);
+	int			error;
+
+	if (!sb_bp)
+		do_error(
+ _("couldn't grab primary sb to update realtime sb\n"));
+
+	error = -libxfs_buf_get_uncached(mp->m_rtdev_targp,
+			XFS_FSB_TO_BB(mp, 1), XFS_RTSB_DADDR, &rtsb_bp);
+	if (error)
+		do_error(
+ _("couldn't grab realtime superblock\n"));
+
+	rtsb_bp->b_maps[0].bm_bn = XFS_RTSB_DADDR;
+	rtsb_bp->b_ops = &xfs_rtsb_buf_ops;
+
+	libxfs_update_rtsb(rtsb_bp, sb_bp);
+	libxfs_buf_mark_dirty(rtsb_bp);
+	libxfs_buf_relse(rtsb_bp);
+	libxfs_buf_relse(sb_bp);
+}
diff --git a/repair/rt.h b/repair/rt.h
index 4dfe4a921d4cdf..865d950b2bf3c4 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -33,4 +33,7 @@ static inline bool is_rtsummary_inode(xfs_ino_t ino)
 void mark_rtgroup_inodes_bad(struct xfs_mount *mp, enum xfs_rtg_inodes type);
 bool rtgroup_inodes_were_bad(enum xfs_rtg_inodes type);
 
+void check_rtsb(struct xfs_mount *mp);
+void rewrite_rtsb(struct xfs_mount *mp);
+
 #endif /* _XFS_REPAIR_RT_H_ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index d06bf659df89c1..2a8a72e7027591 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1518,6 +1518,10 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 				XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
 	}
 
+	/* Always rewrite the realtime superblock */
+	if (xfs_has_rtsb(mp) && xfs_has_realtime(mp))
+		rewrite_rtsb(mp);
+
 	/*
 	 * Done. Flush all cached buffers and inodes first to ensure all
 	 * verifiers are run (where we discover the max metadata LSN), reformat

