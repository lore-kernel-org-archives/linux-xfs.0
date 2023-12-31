Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95112BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7kUgLvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED24C433C8;
	Sun, 31 Dec 2023 21:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057290;
	bh=/q2gio5aDLgOv1Wn+jfPHTOXOgluUBn2ngjVnr+jekk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M7kUgLvzfpDNm53CU9zUf0EQsa7hM+RwCla+Dx0qO5b3kJwnsJKSwzCzNlHibj0E/
	 GT2ppW0YLs2Hsps6mx8QAysXOFGX6YUuSdKYmXjwlxK6iMabnlomIK8xSeLPXbptuX
	 e1vUuXL+F2EwgbtFIc9pn7lPto21VhWoJKdDApbqvpQwZhxo2P7rgCKJ9/4P3/wlSN
	 wCeOmjexdPeUrW/WfNHMtIsNnS1h7sP1NGTnpzO7uch6YBgv2aboJgPgB9KiVLyy4+
	 T0il8rP1YJx8hZawkOjRDsAVU0LJo2YbRrE1RYk8eXfe4S5zueKzb313wGv4DoNars
	 MVMV7wwAMlimQ==
Date: Sun, 31 Dec 2023 13:14:49 -0800
Subject: [PATCH 1/4] xfs: refactor realtime scrubbing context management
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845748.1761787.14839160140875498114.stgit@frogsfrogsfrogs>
In-Reply-To: <170404845722.1761787.5477037333223536717.stgit@frogsfrogsfrogs>
References: <170404845722.1761787.5477037333223536717.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/bmap.c      |    2 +
 fs/xfs/scrub/common.c    |   69 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h    |   18 ++++++++++++
 fs/xfs/scrub/rtbitmap.c  |    7 +----
 fs/xfs/scrub/rtsummary.c |   12 ++------
 fs/xfs/scrub/scrub.c     |    1 +
 fs/xfs/scrub/scrub.h     |    9 ++++++
 7 files changed, 104 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 24a15bf784f11..b90f0d8540ba5 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -314,8 +314,10 @@ xchk_bmap_rt_iextent_xref(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
+	xchk_rt_init(info->sc, &info->sc->sr, XCHK_RTLOCK_BITMAP_SHARED);
 	xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
 			irec->br_blockcount);
+	xchk_rt_unlock(info->sc, &info->sc->sr);
 }
 
 /* Cross-reference a single datadev extent record. */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index c6501101c925b..4ad58192f2e3d 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -679,6 +679,75 @@ xchk_ag_init(
 	return 0;
 }
 
+/*
+ * For scrubbing a realtime file, grab all the in-core resources we'll need to
+ * check the realtime metadata, which means taking the ILOCK of the realtime
+ * metadata inodes.  Callers must not join these inodes to the transaction
+ * with non-zero lockflags or concurrency problems will result.  The
+ * @rtlock_flags argument takes XCHK_RTLOCK_* flags because scrub has somewhat
+ * unusual locking requirements.
+ */
+void
+xchk_rt_init(
+	struct xfs_scrub	*sc,
+	struct xchk_rt		*sr,
+	unsigned int		rtlock_flags)
+{
+	ASSERT(!(rtlock_flags & ~XCHK_RTLOCK_ALL));
+	ASSERT(hweight32(rtlock_flags & (XCHK_RTLOCK_BITMAP |
+					 XCHK_RTLOCK_BITMAP_SHARED)) < 2);
+	ASSERT(hweight32(rtlock_flags & (XCHK_RTLOCK_SUMMARY |
+					 XCHK_RTLOCK_SUMMARY_SHARED)) < 2);
+
+	if (rtlock_flags & XCHK_RTLOCK_BITMAP)
+		xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+	else if (rtlock_flags & XCHK_RTLOCK_BITMAP_SHARED)
+		xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+
+	if (rtlock_flags & XCHK_RTLOCK_SUMMARY)
+		xfs_ilock(sc->mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+	else if (rtlock_flags & XCHK_RTLOCK_SUMMARY_SHARED)
+		xfs_ilock(sc->mp->m_rsumip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
+
+	sr->rtlock_flags = rtlock_flags;
+}
+
+/*
+ * Unlock the realtime metadata inodes.  This must be done /after/ committing
+ * (or cancelling) the scrub transaction.
+ */
+void
+xchk_rt_unlock(
+	struct xfs_scrub	*sc,
+	struct xchk_rt		*sr)
+{
+	if (!sr->rtlock_flags)
+		return;
+
+	if (sr->rtlock_flags & XCHK_RTLOCK_SUMMARY)
+		xfs_iunlock(sc->mp->m_rsumip, XFS_ILOCK_EXCL);
+	else if (sr->rtlock_flags & XCHK_RTLOCK_SUMMARY_SHARED)
+		xfs_iunlock(sc->mp->m_rsumip, XFS_ILOCK_SHARED);
+
+	if (sr->rtlock_flags & XCHK_RTLOCK_BITMAP)
+		xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_EXCL);
+	else if (sr->rtlock_flags & XCHK_RTLOCK_BITMAP_SHARED)
+		xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED);
+
+	sr->rtlock_flags = 0;
+}
+
+/* Drop only the shared rt bitmap lock. */
+void
+xchk_rt_unlock_rtbitmap(
+	struct xfs_scrub	*sc)
+{
+	ASSERT(sc->sr.rtlock_flags & XCHK_RTLOCK_BITMAP_SHARED);
+
+	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	sc->sr.rtlock_flags &= ~XCHK_RTLOCK_BITMAP_SHARED;
+}
+
 /* Per-scrubber setup functions */
 
 void
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 11a893e4b228e..007d293a06d52 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -129,6 +129,24 @@ xchk_ag_init_existing(
 	return error == -ENOENT ? -EFSCORRUPTED : error;
 }
 
+/* Lock the rt bitmap in exclusive mode */
+#define XCHK_RTLOCK_BITMAP		(1U << 31)
+/* Lock the rt bitmap in shared mode */
+#define XCHK_RTLOCK_BITMAP_SHARED	(1U << 30)
+/* Lock the rt summary in exclusive mode */
+#define XCHK_RTLOCK_SUMMARY		(1U << 29)
+/* Lock the rt summary in shared mode */
+#define XCHK_RTLOCK_SUMMARY_SHARED	(1U << 28)
+
+#define XCHK_RTLOCK_ALL		(XCHK_RTLOCK_BITMAP | \
+				 XCHK_RTLOCK_BITMAP_SHARED | \
+				 XCHK_RTLOCK_SUMMARY | \
+				 XCHK_RTLOCK_SUMMARY_SHARED)
+
+void xchk_rt_init(struct xfs_scrub *sc, struct xchk_rt *sr,
+		unsigned int xchk_rtlock_flags);
+void xchk_rt_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
+void xchk_rt_unlock_rtbitmap(struct xfs_scrub *sc);
 int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		struct xchk_ag *sa);
 void xchk_ag_btcur_free(struct xchk_ag *sa);
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 441ca99776527..c018376256a86 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -52,7 +52,7 @@ xchk_setup_rtbitmap(
 	if (error)
 		return error;
 
-	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+	xchk_rt_init(sc, &sc->sr, XCHK_RTLOCK_BITMAP);
 
 	/*
 	 * Now that we've locked the rtbitmap, we can't race with growfsrt
@@ -216,13 +216,10 @@ xchk_xref_is_used_rt_space(
 
 	startext = xfs_rtb_to_rtx(sc->mp, rtbno);
 	endext = xfs_rtb_to_rtx(sc->mp, rtbno + len - 1);
-	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext,
 			endext - startext + 1, &is_free);
 	if (!xchk_should_check_xref(sc, &error, NULL))
-		goto out_unlock;
+		return;
 	if (is_free)
 		xchk_ino_xref_set_corrupt(sc, sc->mp->m_rbmip->i_ino);
-out_unlock:
-	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 }
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 5d1622203c8a9..829036b50b0c1 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -79,14 +79,8 @@ xchk_setup_rtsummary(
 	if (error)
 		return error;
 
-	/*
-	 * Locking order requires us to take the rtbitmap first.  We must be
-	 * careful to unlock it ourselves when we are done with the rtbitmap
-	 * file since the scrub infrastructure won't do that for us.  Only
-	 * then we can lock the rtsummary inode.
-	 */
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
-	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+	xchk_rt_init(sc, &sc->sr,
+			XCHK_RTLOCK_SUMMARY | XCHK_RTLOCK_BITMAP_SHARED);
 
 	/*
 	 * Now that we've locked the rtbitmap and rtsummary, we can't race with
@@ -365,6 +359,6 @@ xchk_rtsummary(
 	 * that order, so we're still protected against allocation activities
 	 * even if we continue on to the repair function.
 	 */
-	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+	xchk_rt_unlock_rtbitmap(sc);
 	return error;
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 1c3b140b02419..5d551433b3233 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -230,6 +230,7 @@ xchk_teardown(
 			xfs_trans_cancel(sc->tp);
 		sc->tp = NULL;
 	}
+	xchk_rt_unlock(sc, &sc->sr);
 	if (sc->ip) {
 		if (sc->ilock_flags)
 			xchk_iunlock(sc, sc->ilock_flags);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index b48199d8940b8..1671b6aa48081 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -111,6 +111,12 @@ struct xchk_ag {
 	struct xfs_btree_cur	*refc_cur;
 };
 
+/* Inode lock state for the RT volume. */
+struct xchk_rt {
+	/* XCHK_RTLOCK_* lock state */
+	unsigned int		rtlock_flags;
+};
+
 struct xfs_scrub {
 	/* General scrub state. */
 	struct xfs_mount		*mp;
@@ -172,6 +178,9 @@ struct xfs_scrub {
 
 	/* State tracking for single-AG operations. */
 	struct xchk_ag			sa;
+
+	/* State tracking for realtime operations. */
+	struct xchk_rt			sr;
 };
 
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */

