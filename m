Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CA8196
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530240; cv=none; b=TAg9+MDhaipuo601fmFCwjk2vV2tXHxVVF6KQqk7td9LqKlHae/rKZsu3Y3PQ3aYjlxEQoVGKzFWOwSDru95JxfLvat82zZXY7dJx7drj22W/ADKCiYIwY0cCqsVbne6OVTPGOg3uwdvPf36nshj+xYwsPP05dd8RYq2zlcvAjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530240; c=relaxed/simple;
	bh=zfGFa7d9hfinLkQGu/wqg2048vycKn3q09kkWATswxw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iGjdSwwPxvvAYmlt1+8l4RVWtLybXcvcu2wiD/hjMbQOWYUWUYZ93WX1HsI0lZa9i6o5ySAYjbRwve8b4TpLvye72UvClvcGtf0zWyQe39ctUzHrHJ1hyATMwNFeN2wbzsd7yIWXrrwZIZ9TgV/DH9We+tkopXBbuXJeGohyj+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGTpc96F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGTpc96F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A01FC4CED1;
	Sat,  7 Dec 2024 00:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530240;
	bh=zfGFa7d9hfinLkQGu/wqg2048vycKn3q09kkWATswxw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kGTpc96F63rx+zEM1UVGWyBHGJd35GXNtdVnsh6Vyr05LdseOJC8tvldMxFs8eq2g
	 UcMQqu9D9gm9e/q1yuwOS2SgMVoyR/oezXbPDdsnDywFwGunUnI2ZVT8Nzjii+d1NL
	 sfnLzHQROeWOACRq7iYmSlsibUn7xZPXKOORAD+UXczuvCYIw87ORr0qsW6GFZIPGr
	 lokWrUhGB9WeFeD2eYFVN5MeT3c0IClcx0jhEB2ndxFITpLnTx6uP0zT/0W+GH38pp
	 MuAkASoyZ8c2ZZvbiNUXby8qIEMAwIQX8hisvVzhS5ESkBEm1Ev/7Beyieu+uxYk7y
	 n3eM4x66ATYzg==
Date: Fri, 06 Dec 2024 16:10:38 -0800
Subject: [PATCH 22/50] xfs_repair: support realtime superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752281.126362.11077683700931989988.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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

