Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C109BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="it/mZKOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4C4C433C7;
	Sun, 31 Dec 2023 21:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057666;
	bh=gZS+Di5Rdrc58RCqwPES7BV0rAEd9DXrWlJyM1xGvbk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=it/mZKOCb8ppnyWX0OqbSM1pf9S/rwTERygcigWR6Oiecpx5C0gMA4jRvx802jQP5
	 XF2hRp2Hoa8Nd3nd3rMGgLRw9GsvZg82402hMB+pB4vgy1sdy+LJ6jYC4op/tcqjgi
	 QXSQ5UHlxHan4CGb7vSYrKDgMzJw8yTK6dtk5w+r7JKgfp3DfTI+BDbxsRJN1KoiYi
	 /z2SQ/txttzc0pWQsoPvMn7pVg1CgGFrLuRqW4VfgF6vO5v5mAmz+b8ZBE6AFWGCdk
	 +oKQUWxz5gsexjl7U+dZazOqUNC8bInIquKFRi6SpjoKAyo1DQZDHu8B3GsDUYFsty
	 X748SSsFuYjzQ==
Date: Sun, 31 Dec 2023 13:21:05 -0800
Subject: [PATCH 21/24] xfs: scrub the realtime group superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846576.1763124.1964293867828384078.stgit@frogsfrogsfrogs>
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

Enable scrubbing of realtime group superblocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile        |    1 +
 fs/xfs/libxfs/xfs_fs.h |    3 +-
 fs/xfs/scrub/common.c  |   88 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h  |   46 ++++++++++++++-----------
 fs/xfs/scrub/health.c  |    1 +
 fs/xfs/scrub/rgsuper.c |   77 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c   |   20 ++++++++++-
 fs/xfs/scrub/scrub.h   |   40 ++++++++++------------
 fs/xfs/scrub/stats.c   |    1 +
 fs/xfs/scrub/trace.h   |    4 ++
 10 files changed, 237 insertions(+), 44 deletions(-)
 create mode 100644 fs/xfs/scrub/rgsuper.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 500dea292a9d6..7416ab9efc4d8 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -190,6 +190,7 @@ xfs-y				+= $(addprefix scrub/, \
 xfs-$(CONFIG_XFS_ONLINE_SCRUB_STATS) += scrub/stats.o
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
+				   rgsuper.o \
 				   rtbitmap.o \
 				   rtsummary.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c5bf53c6a43ca..237d13a500daf 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -735,9 +735,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 #define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
 #define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
+#define XFS_SCRUB_TYPE_RGSUPER	30	/* realtime superblock */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	30
+#define XFS_SCRUB_TYPE_NR	31
 
 /*
  * This special type code only applies to the vectored scrub implementation.
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index e9294a933c3ab..3dee7d717073e 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -34,6 +34,7 @@
 #include "xfs_quota.h"
 #include "xfs_swapext.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -121,6 +122,17 @@ xchk_process_error(
 			XFS_SCRUB_OFLAG_CORRUPT, __return_address);
 }
 
+bool
+xchk_process_rt_error(
+	struct xfs_scrub	*sc,
+	xfs_rgnumber_t		rgno,
+	xfs_rgblock_t		rgbno,
+	int			*error)
+{
+	return __xchk_process_error(sc, rgno, rgbno, error,
+			XFS_SCRUB_OFLAG_CORRUPT, __return_address);
+}
+
 bool
 xchk_xref_process_error(
 	struct xfs_scrub	*sc,
@@ -132,6 +144,17 @@ xchk_xref_process_error(
 			XFS_SCRUB_OFLAG_XFAIL, __return_address);
 }
 
+bool
+xchk_xref_process_rt_error(
+	struct xfs_scrub	*sc,
+	xfs_rgnumber_t		rgno,
+	xfs_rgblock_t		rgbno,
+	int			*error)
+{
+	return __xchk_process_error(sc, rgno, rgbno, error,
+			XFS_SCRUB_OFLAG_XFAIL, __return_address);
+}
+
 /* Check for operational errors for a file offset. */
 static bool
 __xchk_fblock_process_error(
@@ -699,6 +722,7 @@ xchk_rt_init(
 					 XCHK_RTLOCK_BITMAP_SHARED)) < 2);
 	ASSERT(hweight32(rtlock_flags & (XCHK_RTLOCK_SUMMARY |
 					 XCHK_RTLOCK_SUMMARY_SHARED)) < 2);
+	ASSERT(sr->rtg == NULL);
 
 	if (rtlock_flags & XCHK_RTLOCK_BITMAP)
 		xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_EXCL);
@@ -722,6 +746,8 @@ xchk_rt_unlock(
 	struct xfs_scrub	*sc,
 	struct xchk_rt		*sr)
 {
+	ASSERT(sr->rtg == NULL);
+
 	if (!sr->rtlock_flags)
 		return;
 
@@ -749,6 +775,68 @@ xchk_rt_unlock_rtbitmap(
 	sc->sr.rtlock_flags &= ~XCHK_RTLOCK_BITMAP_SHARED;
 }
 
+#ifdef CONFIG_XFS_RT
+/*
+ * For scrubbing a realtime group, grab all the in-core resources we'll need to
+ * check the metadata, which means taking the ILOCK of the realtime group's
+ * metadata inodes.  Callers must not join these inodes to the transaction with
+ * non-zero lockflags or concurrency problems will result.  The @rtglock_flags
+ * argument takes XFS_RTGLOCK_* flags.
+ */
+int
+xchk_rtgroup_init(
+	struct xfs_scrub	*sc,
+	xfs_rgnumber_t		rgno,
+	struct xchk_rt		*sr,
+	unsigned int		rtglock_flags)
+{
+	ASSERT(sr->rtg == NULL);
+	ASSERT(sr->rtlock_flags == 0);
+
+	sr->rtg = xfs_rtgroup_get(sc->mp, rgno);
+	if (!sr->rtg)
+		return -ENOENT;
+
+	xfs_rtgroup_lock(NULL, sr->rtg, rtglock_flags);
+	sr->rtlock_flags = rtglock_flags;
+	return 0;
+}
+
+/*
+ * Unlock the realtime group.  This must be done /after/ committing (or
+ * cancelling) the scrub transaction.
+ */
+void
+xchk_rtgroup_unlock(
+	struct xfs_scrub	*sc,
+	struct xchk_rt		*sr)
+{
+	ASSERT(sr->rtg != NULL);
+
+	if (sr->rtlock_flags) {
+		xfs_rtgroup_unlock(sr->rtg, sr->rtlock_flags);
+		sr->rtlock_flags = 0;
+	}
+}
+
+/*
+ * Unlock the realtime group and release its resources.  This must be done
+ * /after/ committing (or cancelling) the scrub transaction.
+ */
+void
+xchk_rtgroup_free(
+	struct xfs_scrub	*sc,
+	struct xchk_rt		*sr)
+{
+	ASSERT(sr->rtg != NULL);
+
+	xchk_rtgroup_unlock(sc, sr);
+
+	xfs_rtgroup_put(sr->rtg);
+	sr->rtg = NULL;
+}
+#endif /* CONFIG_XFS_RT */
+
 /* Per-scrubber setup functions */
 
 void
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 007d293a06d52..0edf67e697da3 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -12,11 +12,15 @@ void xchk_trans_cancel(struct xfs_scrub *sc);
 
 bool xchk_process_error(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		xfs_agblock_t bno, int *error);
+bool xchk_process_rt_error(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
+		xfs_rgblock_t rgbno, int *error);
 bool xchk_fblock_process_error(struct xfs_scrub *sc, int whichfork,
 		xfs_fileoff_t offset, int *error);
 
 bool xchk_xref_process_error(struct xfs_scrub *sc,
 		xfs_agnumber_t agno, xfs_agblock_t bno, int *error);
+bool xchk_xref_process_rt_error(struct xfs_scrub *sc,
+		xfs_rgnumber_t rgno, xfs_rgblock_t rgbno, int *error);
 bool xchk_fblock_xref_process_error(struct xfs_scrub *sc,
 		int whichfork, xfs_fileoff_t offset, int *error);
 
@@ -53,6 +57,11 @@ int xchk_checkpoint_log(struct xfs_mount *mp);
 bool xchk_should_check_xref(struct xfs_scrub *sc, int *error,
 			   struct xfs_btree_cur **curpp);
 
+static inline int xchk_setup_nothing(struct xfs_scrub *sc)
+{
+	return -ENOENT;
+}
+
 /* Setup functions */
 int xchk_setup_agheader(struct xfs_scrub *sc);
 int xchk_setup_fs(struct xfs_scrub *sc);
@@ -72,17 +81,11 @@ int xchk_setup_metapath(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_setup_rtbitmap(struct xfs_scrub *sc);
 int xchk_setup_rtsummary(struct xfs_scrub *sc);
+int xchk_setup_rgsuperblock(struct xfs_scrub *sc);
 #else
-static inline int
-xchk_setup_rtbitmap(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
-static inline int
-xchk_setup_rtsummary(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
+# define xchk_setup_rtbitmap		xchk_setup_nothing
+# define xchk_setup_rtsummary		xchk_setup_nothing
+# define xchk_setup_rgsuperblock	xchk_setup_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_ino_dqattach(struct xfs_scrub *sc);
@@ -94,16 +97,8 @@ xchk_ino_dqattach(struct xfs_scrub *sc)
 {
 	return 0;
 }
-static inline int
-xchk_setup_quota(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
-static inline int
-xchk_setup_quotacheck(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
+# define xchk_setup_quota		xchk_setup_nothing
+# define xchk_setup_quotacheck		xchk_setup_nothing
 #endif
 int xchk_setup_fscounters(struct xfs_scrub *sc);
 int xchk_setup_nlinks(struct xfs_scrub *sc);
@@ -147,6 +142,17 @@ void xchk_rt_init(struct xfs_scrub *sc, struct xchk_rt *sr,
 		unsigned int xchk_rtlock_flags);
 void xchk_rt_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
 void xchk_rt_unlock_rtbitmap(struct xfs_scrub *sc);
+
+#ifdef CONFIG_XFS_RT
+int xchk_rtgroup_init(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
+		struct xchk_rt *sr, unsigned int rtglock_flags);
+void xchk_rtgroup_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
+void xchk_rtgroup_free(struct xfs_scrub *sc, struct xchk_rt *sr);
+#else
+# define xchk_rtgroup_init(sc, rgno, sr, lockflags)	(-ENOSYS)
+# define xchk_rtgroup_free(sc, sr)			((void)0)
+#endif /* CONFIG_XFS_RT */
+
 int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		struct xchk_ag *sa);
 void xchk_ag_btcur_free(struct xchk_ag *sa);
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 063176c1f35eb..7fccb1a03060a 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -114,6 +114,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_NLINKS]		= { XHG_FS,  XFS_SICK_FS_NLINKS },
 	[XFS_SCRUB_TYPE_DIRTREE]	= { XHG_INO, XFS_SICK_INO_DIRTREE },
 	[XFS_SCRUB_TYPE_METAPATH]	= { XHG_FS,  XFS_SICK_FS_METAPATH },
+	[XFS_SCRUB_TYPE_RGSUPER]	= { XHG_RTGROUP, XFS_SICK_RT_SUPER },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
new file mode 100644
index 0000000000000..ae23609cdb900
--- /dev/null
+++ b/fs/xfs/scrub/rgsuper.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_rtgroup.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+
+/* Set us up with a transaction and an empty context. */
+int
+xchk_setup_rgsuperblock(
+	struct xfs_scrub	*sc)
+{
+	return xchk_trans_alloc(sc, 0);
+}
+
+/* Cross-reference with the other rt metadata. */
+STATIC void
+xchk_rgsuperblock_xref(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	xfs_rgnumber_t		rgno = sc->sr.rtg->rtg_rgno;
+	xfs_rtblock_t		rtbno;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	rtbno = xfs_rgbno_to_rtb(mp, rgno, 0);
+	xchk_xref_is_used_rt_space(sc, rtbno, 1);
+}
+
+int
+xchk_rgsuperblock(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_buf		*bp;
+	xfs_rgnumber_t		rgno = sc->sm->sm_agno;
+	int			error;
+
+	/*
+	 * Grab an active reference to the rtgroup structure.  If we can't get
+	 * it, we're racing with something that's tearing down the group, so
+	 * signal that the group no longer exists.  Take the rtbitmap in shared
+	 * mode so that the group can't change while we're doing things.
+	 */
+	error = xchk_rtgroup_init(sc, rgno, &sc->sr, XFS_RTGLOCK_BITMAP_SHARED);
+	if (error)
+		return error;
+
+	/*
+	 * If this is the primary rtgroup superblock, we know it passed the
+	 * verifier checks at mount time and do not need to load the buffer
+	 * again.
+	 */
+	if (sc->sr.rtg->rtg_rgno == 0) {
+		xchk_rgsuperblock_xref(sc);
+		return 0;
+	}
+
+	/* The secondary rt super is checked by the read verifier. */
+	error = xfs_buf_read_uncached(sc->mp->m_rtdev_targp, XFS_RTSB_DADDR,
+			XFS_FSB_TO_BB(sc->mp, 1), 0, &bp, &xfs_rtsb_buf_ops);
+	if (!xchk_process_rt_error(sc, rgno, 0, &error))
+		return error;
+
+	xchk_rgsuperblock_xref(sc);
+	xfs_buf_relse(bp);
+	return 0;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 5d551433b3233..c1e226a9ac08d 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -230,7 +230,10 @@ xchk_teardown(
 			xfs_trans_cancel(sc->tp);
 		sc->tp = NULL;
 	}
-	xchk_rt_unlock(sc, &sc->sr);
+	if (sc->sr.rtg)
+		xchk_rtgroup_free(sc, &sc->sr);
+	else
+		xchk_rt_unlock(sc, &sc->sr);
 	if (sc->ip) {
 		if (sc->ilock_flags)
 			xchk_iunlock(sc, sc->ilock_flags);
@@ -455,6 +458,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.has	= xfs_has_metadir,
 		.repair	= xrep_metapath,
 	},
+	[XFS_SCRUB_TYPE_RGSUPER] = {	/* realtime group superblock */
+		.type	= ST_RTGROUP,
+		.setup	= xchk_setup_rgsuperblock,
+		.scrub	= xchk_rgsuperblock,
+		.has	= xfs_has_rtgroups,
+		.repair = xrep_notsupported,
+	},
 };
 
 static int
@@ -504,6 +514,14 @@ xchk_validate_inputs(
 		break;
 	case ST_GENERIC:
 		break;
+	case ST_RTGROUP:
+		if (sm->sm_ino || sm->sm_gen)
+			goto out;
+		if (!xfs_has_rtgroups(mp) && sm->sm_agno != 0)
+			goto out;
+		if (xfs_has_rtgroups(mp) && sm->sm_agno >= mp->m_sb.sb_rgcount)
+			goto out;
+		break;
 	default:
 		goto out;
 	}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 1671b6aa48081..26d2731eddb99 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -67,6 +67,7 @@ enum xchk_type {
 	ST_FS,		/* per-FS metadata */
 	ST_INODE,	/* per-inode metadata */
 	ST_GENERIC,	/* determined by the scrubber */
+	ST_RTGROUP,	/* rtgroup metadata */
 };
 
 struct xchk_meta_ops {
@@ -113,7 +114,13 @@ struct xchk_ag {
 
 /* Inode lock state for the RT volume. */
 struct xchk_rt {
-	/* XCHK_RTLOCK_* lock state */
+	/* incore rtgroup, if applicable */
+	struct xfs_rtgroup	*rtg;
+
+	/*
+	 * XCHK_RTLOCK_* lock state if rtg == NULL, or XFS_RTGLOCK_* lock state
+	 * if rtg != NULL.
+	 */
 	unsigned int		rtlock_flags;
 };
 
@@ -241,6 +248,11 @@ xchk_should_terminate(
 	return false;
 }
 
+static inline int xchk_nothing(struct xfs_scrub *sc)
+{
+	return -ENOENT;
+}
+
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);
@@ -264,32 +276,18 @@ int xchk_metapath(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_rtbitmap(struct xfs_scrub *sc);
 int xchk_rtsummary(struct xfs_scrub *sc);
+int xchk_rgsuperblock(struct xfs_scrub *sc);
 #else
-static inline int
-xchk_rtbitmap(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
-static inline int
-xchk_rtsummary(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
+# define xchk_rtbitmap		xchk_nothing
+# define xchk_rtsummary		xchk_nothing
+# define xchk_rgsuperblock	xchk_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_quota(struct xfs_scrub *sc);
 int xchk_quotacheck(struct xfs_scrub *sc);
 #else
-static inline int
-xchk_quota(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
-static inline int
-xchk_quotacheck(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
+# define xchk_quota		xchk_nothing
+# define xchk_quotacheck	xchk_nothing
 #endif
 int xchk_fscounters(struct xfs_scrub *sc);
 int xchk_nlinks(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index 2e576c601b7dc..c3f8ac37e5e03 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -81,6 +81,7 @@ static const char *name_map[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_NLINKS]		= "nlinks",
 	[XFS_SCRUB_TYPE_DIRTREE]	= "dirtree",
 	[XFS_SCRUB_TYPE_METAPATH]	= "metapath",
+	[XFS_SCRUB_TYPE_RGSUPER]	= "rgsuper",
 };
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 038a4f8dda5a0..0bcd93bed07d6 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -83,6 +83,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIRTREE);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_METAPATH);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGSUPER);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -115,7 +116,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_METAPATH);
 	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }, \
 	{ XFS_SCRUB_TYPE_DIRTREE,	"dirtree" }, \
 	{ XFS_SCRUB_TYPE_BARRIER,	"barrier" }, \
-	{ XFS_SCRUB_TYPE_METAPATH,	"metapath" }
+	{ XFS_SCRUB_TYPE_METAPATH,	"metapath" }, \
+	{ XFS_SCRUB_TYPE_RGSUPER,	"rgsuper" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \

