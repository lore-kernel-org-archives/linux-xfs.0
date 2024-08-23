Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71341DA3D
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372315; cv=none; b=jnCTdPfyGZRQ7x61yktlGGWUAnImMRNpKQ1VYyRLmQcjtJJVf7qZ0nE8FwMNKMXC8TVrhxGSzT4gNcQTOPcPFqmT+k/DgGiDkKTuGirt4kq3lLJH0js6k3NXuswvI737Ik3hrladLRozb10pPqxGkv3lW38KCrT9NfAB0/Wi3uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372315; c=relaxed/simple;
	bh=KBCOWGEAfiSxZTKJ76yBY1Au9OFD1BVFFCHXf+AK0hE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NyQvaXBuBoDIsn6/sG+IuDbmvWt6ySzrSUIei0OF5yee4pJIEj2yL1eIDo8EYvwu0RfR614oVrL0NOKINQij77ylvvtCRzXavDWVAgOaITd1Zwu2RyTS2MrlcAQtL8yZ7nbWZ/wzavUauFJwBd4ASabcfrhOGEO9su5WahCPeGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=shMxfBrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="shMxfBrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696B4C32782;
	Fri, 23 Aug 2024 00:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372314;
	bh=KBCOWGEAfiSxZTKJ76yBY1Au9OFD1BVFFCHXf+AK0hE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=shMxfBrlWeNN90/RooFtKbPFVyrg6WqdNCjFX9TsBZtloxqKZjBvZC2otbDpRcQr5
	 CUNzlqj8YSJxgtUQRgK1XnYoJyecD3F2NPvuvlQ4HOo/ZZLngmzOvkSK3w4sEvI20J
	 eC0BtO8DdJnGRmsqOsU71A0d8gXYxZAtRIdiq6upsE9EeQMPtYMeH9ux5WBweOJsvR
	 IAnWlqQbWSil2Q1G6CLH6/LvsGC1UIWI0PQUj7E7QUd7tXtNMj6Rl8ZFpDqZj1QMdt
	 8pjyoNtgp3j/c5YdhcHZgbKA1WOgDSaG+/pcUpHegf18oBp2CKw6V7fOdeiLLnFiQL
	 6kNSXawQj9U7Q==
Date: Thu, 22 Aug 2024 17:18:33 -0700
Subject: [PATCH 15/24] xfs: add rtgroup-based realtime scrubbing context
 management
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087504.59588.10025312195068387840.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
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

Create a pair of helpers to deal with setting up the necessary incore
context to check metadata records against the realtime metadata.  Right
now this is limited to locking the realtime bitmap and summary inodes,
but as we add rmap and reflink to the realtime device this will grow to
include btree cursors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h |   30 +++++++++++++++++++
 fs/xfs/scrub/scrub.c  |   29 ++++++++++++++++++
 fs/xfs/scrub/scrub.h  |   13 ++++++++
 4 files changed, 150 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 5245943496c8b..8d44f18787c42 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -34,6 +34,7 @@
 #include "xfs_quota.h"
 #include "xfs_exchmaps.h"
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
@@ -684,6 +696,72 @@ xchk_ag_init(
 	return 0;
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
+	struct xchk_rt		*sr)
+{
+	ASSERT(sr->rtg == NULL);
+	ASSERT(sr->rtlock_flags == 0);
+
+	sr->rtg = xfs_rtgroup_get(sc->mp, rgno);
+	if (!sr->rtg)
+		return -ENOENT;
+	return 0;
+}
+
+void
+xchk_rtgroup_lock(
+	struct xchk_rt		*sr,
+	unsigned int		rtglock_flags)
+{
+	xfs_rtgroup_lock(sr->rtg, rtglock_flags);
+	sr->rtlock_flags = rtglock_flags;
+}
+
+/*
+ * Unlock the realtime group.  This must be done /after/ committing (or
+ * cancelling) the scrub transaction.
+ */
+static void
+xchk_rtgroup_unlock(
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
+	xchk_rtgroup_unlock(sr);
+
+	xfs_rtgroup_put(sr->rtg);
+	sr->rtg = NULL;
+}
+#endif /* CONFIG_XFS_RT */
+
 /* Per-scrubber setup functions */
 
 void
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 27e5bf8f7c60b..0d531770e83b0 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -12,6 +12,8 @@ void xchk_trans_cancel(struct xfs_scrub *sc);
 
 bool xchk_process_error(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		xfs_agblock_t bno, int *error);
+bool xchk_process_rt_error(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
+		xfs_rgblock_t rgbno, int *error);
 bool xchk_fblock_process_error(struct xfs_scrub *sc, int whichfork,
 		xfs_fileoff_t offset, int *error);
 
@@ -118,6 +120,34 @@ xchk_ag_init_existing(
 	return error == -ENOENT ? -EFSCORRUPTED : error;
 }
 
+#ifdef CONFIG_XFS_RT
+
+/* All the locks we need to check an rtgroup. */
+#define XCHK_RTGLOCK_ALL	(XFS_RTGLOCK_BITMAP)
+
+int xchk_rtgroup_init(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
+		struct xchk_rt *sr);
+
+static inline int
+xchk_rtgroup_init_existing(
+	struct xfs_scrub	*sc,
+	xfs_rgnumber_t		rgno,
+	struct xchk_rt		*sr)
+{
+	int			error = xchk_rtgroup_init(sc, rgno, sr);
+
+	return error == -ENOENT ? -EFSCORRUPTED : error;
+}
+
+void xchk_rtgroup_lock(struct xchk_rt *sr, unsigned int rtglock_flags);
+void xchk_rtgroup_free(struct xfs_scrub *sc, struct xchk_rt *sr);
+#else
+# define xchk_rtgroup_init(sc, rgno, sr)		(-EFSCORRUPTED)
+# define xchk_rtgroup_init_existing(sc, rgno, sr)	(-EFSCORRUPTED)
+# define xchk_rtgroup_lock(sc, lockflags)		do { } while (0)
+# define xchk_rtgroup_free(sc, sr)			do { } while (0)
+#endif /* CONFIG_XFS_RT */
+
 int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		struct xchk_ag *sa);
 void xchk_ag_btcur_free(struct xchk_ag *sa);
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 04a7a5944837d..9d9990d5c6c48 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -225,6 +225,8 @@ xchk_teardown(
 			xfs_trans_cancel(sc->tp);
 		sc->tp = NULL;
 	}
+	if (sc->sr.rtg)
+		xchk_rtgroup_free(sc, &sc->sr);
 	if (sc->ip) {
 		if (sc->ilock_flags)
 			xchk_iunlock(sc, sc->ilock_flags);
@@ -498,6 +500,33 @@ xchk_validate_inputs(
 		break;
 	case ST_GENERIC:
 		break;
+	case ST_RTGROUP:
+		if (sm->sm_ino || sm->sm_gen)
+			goto out;
+		if (xfs_has_rtgroups(mp)) {
+			/*
+			 * On a rtgroups filesystem, there won't be an rtbitmap
+			 * or rtsummary file for group 0 unless there's
+			 * actually a realtime volume attached.  However, older
+			 * xfs_scrub always calls the rtbitmap/rtsummary
+			 * scrubbers with sm_agno==0 so transform the error
+			 * code to ENOENT.
+			 */
+			if (sm->sm_agno >= mp->m_sb.sb_rgcount) {
+				if (sm->sm_agno == 0)
+					error = -ENOENT;
+				goto out;
+			}
+		} else {
+			/*
+			 * Prior to rtgroups, the rtbitmap/rtsummary scrubbers
+			 * accepted sm_agno==0, so we still accept that for
+			 * scrubbing pre-rtgroups filesystems.
+			 */
+			if (sm->sm_agno != 0)
+				goto out;
+		}
+		break;
 	default:
 		goto out;
 	}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index c688ff4fc7fc4..f73c6d0d90a11 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -74,6 +74,7 @@ enum xchk_type {
 	ST_FS,		/* per-FS metadata */
 	ST_INODE,	/* per-inode metadata */
 	ST_GENERIC,	/* determined by the scrubber */
+	ST_RTGROUP,	/* rtgroup metadata */
 };
 
 struct xchk_meta_ops {
@@ -118,6 +119,15 @@ struct xchk_ag {
 	struct xfs_btree_cur	*refc_cur;
 };
 
+/* Inode lock state for the RT volume. */
+struct xchk_rt {
+	/* incore rtgroup, if applicable */
+	struct xfs_rtgroup	*rtg;
+
+	/* XFS_RTGLOCK_* lock state if locked */
+	unsigned int		rtlock_flags;
+};
+
 struct xfs_scrub {
 	/* General scrub state. */
 	struct xfs_mount		*mp;
@@ -179,6 +189,9 @@ struct xfs_scrub {
 
 	/* State tracking for single-AG operations. */
 	struct xchk_ag			sa;
+
+	/* State tracking for realtime operations. */
+	struct xchk_rt			sr;
 };
 
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */

