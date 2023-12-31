Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDE3BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iueehF27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF7AC433C7;
	Sun, 31 Dec 2023 21:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057697;
	bh=cnEwhY3fO67SXke7cblo1KV4dxsoshG1f0MkMMoyf90=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iueehF273zmgGtNP7CKiOHTnAlivlwhwIlGyVx0ceD3qYRH1YWrtg4oGDs2MLSJ3d
	 /pfdaxXmYp0oIKtHd0ZKEm940SDKcXSnVp9/n10dYBzJZxvi2YPNbpVZwXbTRxeB07
	 V6GihCjPVTPua3n9i+rS2DTMsbpPiL+M3Kpu1TUhV8zQxDvKCCFMiBeKp3XhChg7wq
	 7i8rKOOrL/WyxjuXMMJXH4O+0a9ycjrXrWZIwRGzp4g9+brlSRe15zx4p5g9+VBniJ
	 iX5061FeJN4i6zDrMe3sgjgYuMdx8tLwMckjoWxVqQ83RmdqLogm11qM9de1BVEa3G
	 kLwGuDTT183AA==
Date: Sun, 31 Dec 2023 13:21:36 -0800
Subject: [PATCH 23/24] xfs: scrub each rtgroup's portion of the rtbitmap
 separately
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846609.1763124.17143188488189530626.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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

Create a new scrub type code so that userspace can scrub each rtgroup's
portion of the rtbitmap file separately.  This reduces the long tail
latency that results from scanning the entire bitmap all at once, and
prepares us for future patchsets, wherein we'll need to be able to lock
a specific rtgroup so that we can rebuild that rtgroup's part of the
rtbitmap contents from the rtgroup's rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h  |    3 +
 fs/xfs/scrub/common.h   |    6 ++
 fs/xfs/scrub/rtbitmap.c |  127 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/rtbitmap.h |    6 ++
 fs/xfs/scrub/scrub.c    |    7 +++
 fs/xfs/scrub/scrub.h    |    2 +
 fs/xfs/scrub/stats.c    |    1 
 fs/xfs/scrub/trace.h    |    4 +
 8 files changed, 150 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 237d13a500daf..102b927336057 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -736,9 +736,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
 #define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
 #define XFS_SCRUB_TYPE_RGSUPER	30	/* realtime superblock */
+#define XFS_SCRUB_TYPE_RGBITMAP	31	/* realtime group bitmap */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	31
+#define XFS_SCRUB_TYPE_NR	32
 
 /*
  * This special type code only applies to the vectored scrub implementation.
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 0edf67e697da3..f96dd658feab9 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -82,10 +82,12 @@ int xchk_setup_metapath(struct xfs_scrub *sc);
 int xchk_setup_rtbitmap(struct xfs_scrub *sc);
 int xchk_setup_rtsummary(struct xfs_scrub *sc);
 int xchk_setup_rgsuperblock(struct xfs_scrub *sc);
+int xchk_setup_rgbitmap(struct xfs_scrub *sc);
 #else
 # define xchk_setup_rtbitmap		xchk_setup_nothing
 # define xchk_setup_rtsummary		xchk_setup_nothing
 # define xchk_setup_rgsuperblock	xchk_setup_nothing
+# define xchk_setup_rgbitmap		xchk_setup_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_ino_dqattach(struct xfs_scrub *sc);
@@ -144,6 +146,10 @@ void xchk_rt_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
 void xchk_rt_unlock_rtbitmap(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
+
+/* All the locks we need to check an rtgroup. */
+#define XCHK_RTGLOCK_ALL	(XFS_RTGLOCK_BITMAP_SHARED)
+
 int xchk_rtgroup_init(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
 		struct xchk_rt *sr, unsigned int rtglock_flags);
 void xchk_rtgroup_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 7f910fed7de95..aae8b0e6ff281 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -15,11 +15,66 @@
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "xfs_bit.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
 #include "scrub/rtbitmap.h"
 
+static inline void
+xchk_rtbitmap_compute_geometry(
+	struct xfs_mount	*mp,
+	struct xchk_rtbitmap	*rtb)
+{
+	if (mp->m_sb.sb_rblocks == 0)
+		return;
+
+	rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
+	rtb->rextslog = xfs_compute_rextslog(&mp->m_sb, rtb->rextents);
+	rtb->rbmblocks = xfs_rtbitmap_blockcount(mp, rtb->rextents);
+}
+
+/* Set us up with the realtime group metadata locked. */
+int
+xchk_setup_rgbitmap(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xchk_rgbitmap	*rgb;
+	int			error;
+
+	rgb = kzalloc(sizeof(struct xchk_rgbitmap), XCHK_GFP_FLAGS);
+	if (!rgb)
+		return -ENOMEM;
+	rgb->sc = sc;
+	sc->buf = rgb;
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+
+	error = xchk_install_live_inode(sc, mp->m_rbmip);
+	if (error)
+		return error;
+
+	error = xchk_ino_dqattach(sc);
+	if (error)
+		return error;
+
+	error = xchk_rtgroup_init(sc, sc->sm->sm_agno, &sc->sr,
+			XCHK_RTGLOCK_ALL);
+	if (error)
+		return error;
+
+	/*
+	 * Now that we've locked the rtbitmap, we can't race with growfsrt
+	 * trying to expand the bitmap or change the size of the rt volume.
+	 * Hence it is safe to compute and check the geometry values.
+	 */
+	xchk_rtbitmap_compute_geometry(mp, &rgb->rtb);
+	return 0;
+}
+
 /* Set us up with the realtime metadata locked. */
 int
 xchk_setup_rtbitmap(
@@ -59,11 +114,68 @@ xchk_setup_rtbitmap(
 	 * trying to expand the bitmap or change the size of the rt volume.
 	 * Hence it is safe to compute and check the geometry values.
 	 */
-	if (mp->m_sb.sb_rblocks) {
-		rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
-		rtb->rextslog = xfs_compute_rextslog(&mp->m_sb, rtb->rextents);
-		rtb->rbmblocks = xfs_rtbitmap_blockcount(mp, rtb->rextents);
+	xchk_rtbitmap_compute_geometry(mp, rtb);
+	return 0;
+}
+
+/* Per-rtgroup bitmap contents. */
+
+/* Scrub a free extent record from the realtime bitmap. */
+STATIC int
+xchk_rgbitmap_rec(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	const struct xfs_rtalloc_rec *rec,
+	void			*priv)
+{
+	struct xchk_rgbitmap	*rgb = priv;
+	struct xfs_scrub	*sc = rgb->sc;
+	xfs_rtblock_t		startblock;
+	xfs_filblks_t		blockcount;
+
+	startblock = xfs_rtx_to_rtb(mp, rec->ar_startext);
+	blockcount = xfs_rtx_to_rtb(mp, rec->ar_extcount);
+
+	if (!xfs_verify_rtbext(mp, startblock, blockcount))
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+	return 0;
+}
+
+/* Scrub this group's realtime bitmap. */
+int
+xchk_rgbitmap(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_rtalloc_rec	keys[2];
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	struct xchk_rgbitmap	*rgb = sc->buf;
+	xfs_rtblock_t		rtbno;
+	xfs_rgblock_t		last_rgbno = rtg->rtg_blockcount - 1;
+	int			error;
+
+	/* Sanity check the realtime bitmap size. */
+	if (sc->ip->i_disk_size < XFS_FSB_TO_B(mp, rgb->rtb.rbmblocks)) {
+		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		return 0;
 	}
+
+	/*
+	 * Check only the portion of the rtbitmap that corresponds to this
+	 * realtime group.
+	 */
+	rtbno = xfs_rgbno_to_rtb(mp, rtg->rtg_rgno, 0);
+	keys[0].ar_startext = xfs_rtb_to_rtx(mp, rtbno);
+
+	rtbno = xfs_rgbno_to_rtb(mp, rtg->rtg_rgno, last_rgbno);
+	keys[1].ar_startext = xfs_rtb_to_rtx(mp, rtbno);
+	keys[0].ar_extcount = keys[1].ar_extcount = 0;
+
+	error = xfs_rtalloc_query_range(mp, sc->tp, &keys[0], &keys[1],
+			xchk_rgbitmap_rec, rgb);
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+		return error;
+
 	return 0;
 }
 
@@ -192,6 +304,13 @@ xchk_rtbitmap(
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
+	/*
+	 * Each rtgroup checks its portion of the rt bitmap, so if we don't
+	 * have that feature, we have to check the bitmap contents now.
+	 */
+	if (xfs_has_rtgroups(mp))
+		return 0;
+
 	error = xfs_rtalloc_query_all(mp, sc->tp, xchk_rtbitmap_rec, sc);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		return error;
diff --git a/fs/xfs/scrub/rtbitmap.h b/fs/xfs/scrub/rtbitmap.h
index 85304ff019e1d..f659f0e76b4fa 100644
--- a/fs/xfs/scrub/rtbitmap.h
+++ b/fs/xfs/scrub/rtbitmap.h
@@ -13,6 +13,12 @@ struct xchk_rtbitmap {
 	unsigned int		resblks;
 };
 
+struct xchk_rgbitmap {
+	struct xfs_scrub	*sc;
+
+	struct xchk_rtbitmap	rtb;
+};
+
 #ifdef CONFIG_XFS_ONLINE_REPAIR
 int xrep_setup_rtbitmap(struct xfs_scrub *sc, struct xchk_rtbitmap *rtb);
 #else
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index c9acc10209ddb..a6b7b57fc1df7 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -465,6 +465,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.has	= xfs_has_rtgroups,
 		.repair = xrep_rgsuperblock,
 	},
+	[XFS_SCRUB_TYPE_RGBITMAP] = {	/* realtime group bitmap */
+		.type	= ST_RTGROUP,
+		.setup	= xchk_setup_rgbitmap,
+		.scrub	= xchk_rgbitmap,
+		.has	= xfs_has_rtgroups,
+		.repair = xrep_notsupported,
+	},
 };
 
 static int
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 26d2731eddb99..76eca41a8995a 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -277,10 +277,12 @@ int xchk_metapath(struct xfs_scrub *sc);
 int xchk_rtbitmap(struct xfs_scrub *sc);
 int xchk_rtsummary(struct xfs_scrub *sc);
 int xchk_rgsuperblock(struct xfs_scrub *sc);
+int xchk_rgbitmap(struct xfs_scrub *sc);
 #else
 # define xchk_rtbitmap		xchk_nothing
 # define xchk_rtsummary		xchk_nothing
 # define xchk_rgsuperblock	xchk_nothing
+# define xchk_rgbitmap		xchk_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_quota(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index c3f8ac37e5e03..4bdff9a19dd6c 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -82,6 +82,7 @@ static const char *name_map[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_DIRTREE]	= "dirtree",
 	[XFS_SCRUB_TYPE_METAPATH]	= "metapath",
 	[XFS_SCRUB_TYPE_RGSUPER]	= "rgsuper",
+	[XFS_SCRUB_TYPE_RGBITMAP]	= "rgbitmap",
 };
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 0bcd93bed07d6..dd809042a6041 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -84,6 +84,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIRTREE);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_METAPATH);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGSUPER);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGBITMAP);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -117,7 +118,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGSUPER);
 	{ XFS_SCRUB_TYPE_DIRTREE,	"dirtree" }, \
 	{ XFS_SCRUB_TYPE_BARRIER,	"barrier" }, \
 	{ XFS_SCRUB_TYPE_METAPATH,	"metapath" }, \
-	{ XFS_SCRUB_TYPE_RGSUPER,	"rgsuper" }
+	{ XFS_SCRUB_TYPE_RGSUPER,	"rgsuper" }, \
+	{ XFS_SCRUB_TYPE_RGBITMAP,	"rgbitmap" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \

