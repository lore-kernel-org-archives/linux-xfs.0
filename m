Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1401372
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051651; cv=none; b=YXE79T0z7QdSJDFd/k4cPrazQUQPq+7m4h+Usl23kVPAVMxbKyjByOfoB2SQeu7fi5KxTrZDwDE6LuH0kqoyQLTFMUAl2gBXkdnY98u/y+2GZT8Ys57wIqgWduwHMCgo7lGOYtcBGsb0Dwm2odxX6qAkVqjDtpa4fZnukhcs0pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051651; c=relaxed/simple;
	bh=S61ndOKxzAjpavRflo+zX8sOQ0AyHawb8RHBCqqj4mU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qtwu8KtvRTG9J2XWRbHqGGbGW9EnUAfZaRj2uLAR+3pUdcBzirlO7CLYhQlwB6YN87TjWOwXv0DM2vBQO/2lN78g65FjwoX7fy1HkBVIid96QafzbkWbStjTympoxaNVXs9KRYBtx1flmM/WYYmiFIAebijRkkO485xv1Mf2j1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9elLqkm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9elLqkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0CBC4CECE;
	Fri, 13 Dec 2024 01:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051651;
	bh=S61ndOKxzAjpavRflo+zX8sOQ0AyHawb8RHBCqqj4mU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S9elLqkm+H21xsKNAD9w8VROJuWaC73kCVHMMk4CtuzgAL1oeSAOwL1/JcGphaZs/
	 FOlVv40usfw0yOfwHVkJWjhi+g+mgiwtRDgNgcxoXaN0GNgC7CTYG7xDIUcwUXP0gI
	 FGQbKYIEc9HWeQqiqVsEH7PhtW0tHxEfgovvcCW+GVCLIKUpfwoH2U1uv0VJFTjQld
	 t/gF0yUiPev1YM8WXqKSz8kwViq+3iiyiSckaNCXpZubegcvMeqwMwoxDW+iR9jijr
	 hZn3Pa1AzCRZ32/EVEL4iuWAafWs4/mrbjAXsWpVnEHxRw0vMWJk9FVlOdYkNImAGR
	 RZQe5ZOZGNTAA==
Date: Thu, 12 Dec 2024 17:00:50 -0800
Subject: [PATCH 01/37] xfs: add some rtgroup inode helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123329.1181370.17404943645784258939.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create some simple helpers to reduce the amount of typing whenever we
access rtgroup inodes.  Conversion was done with this spatch and some
minor reformatting:

@@
expression rtg;
@@

- rtg->rtg_inodes[XFS_RTGI_BITMAP]
+ rtg_bitmap(rtg)

@@
expression rtg;
@@

- rtg->rtg_inodes[XFS_RTGI_SUMMARY]
+ rtg_summary(rtg)

and the CLI command:

$ spatch --sp-file /tmp/moo.cocci --dir fs/xfs/ --use-gitgrep --in-place

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    2 +-
 fs/xfs/libxfs/xfs_rtgroup.c  |   18 ++++++++----------
 fs/xfs/libxfs/xfs_rtgroup.h  |   10 ++++++++++
 fs/xfs/scrub/rtbitmap.c      |    7 +++----
 fs/xfs/scrub/rtsummary.c     |   12 +++++-------
 fs/xfs/xfs_qm.c              |    8 ++++----
 fs/xfs/xfs_rtalloc.c         |   10 +++++-----
 7 files changed, 36 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 4ddfb7e395b38a..770adf60dd7392 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1055,7 +1055,7 @@ xfs_rtfree_extent(
 	xfs_rtxlen_t		len)	/* length of extent freed */
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
+	struct xfs_inode	*rbmip = rtg_bitmap(rtg);
 	struct xfs_rtalloc_args	args = {
 		.mp		= mp,
 		.tp		= tp,
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 4f3bfc884aff29..a79b734e70440d 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -197,10 +197,10 @@ xfs_rtgroup_lock(
 		 * Lock both realtime free space metadata inodes for a freespace
 		 * update.
 		 */
-		xfs_ilock(rtg->rtg_inodes[XFS_RTGI_BITMAP], XFS_ILOCK_EXCL);
-		xfs_ilock(rtg->rtg_inodes[XFS_RTGI_SUMMARY], XFS_ILOCK_EXCL);
+		xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
+		xfs_ilock(rtg_summary(rtg), XFS_ILOCK_EXCL);
 	} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
-		xfs_ilock(rtg->rtg_inodes[XFS_RTGI_BITMAP], XFS_ILOCK_SHARED);
+		xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
 	}
 }
 
@@ -215,10 +215,10 @@ xfs_rtgroup_unlock(
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
 	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
-		xfs_iunlock(rtg->rtg_inodes[XFS_RTGI_SUMMARY], XFS_ILOCK_EXCL);
-		xfs_iunlock(rtg->rtg_inodes[XFS_RTGI_BITMAP], XFS_ILOCK_EXCL);
+		xfs_iunlock(rtg_summary(rtg), XFS_ILOCK_EXCL);
+		xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
 	} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
-		xfs_iunlock(rtg->rtg_inodes[XFS_RTGI_BITMAP], XFS_ILOCK_SHARED);
+		xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
 	}
 }
 
@@ -236,10 +236,8 @@ xfs_rtgroup_trans_join(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED));
 
 	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
-		xfs_trans_ijoin(tp, rtg->rtg_inodes[XFS_RTGI_BITMAP],
-				XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, rtg->rtg_inodes[XFS_RTGI_SUMMARY],
-				XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, rtg_bitmap(rtg), XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, rtg_summary(rtg), XFS_ILOCK_EXCL);
 	}
 }
 
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 7e7e491ff06fa5..19f8d302b9aa3f 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -64,6 +64,16 @@ static inline xfs_rgnumber_t rtg_rgno(const struct xfs_rtgroup *rtg)
 	return rtg->rtg_group.xg_gno;
 }
 
+static inline struct xfs_inode *rtg_bitmap(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_inodes[XFS_RTGI_BITMAP];
+}
+
+static inline struct xfs_inode *rtg_summary(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_inodes[XFS_RTGI_SUMMARY];
+}
+
 /* Passive rtgroup references */
 static inline struct xfs_rtgroup *
 xfs_rtgroup_get(
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 376a36fd9a9cdd..fb4970c877abd3 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -49,8 +49,7 @@ xchk_setup_rtbitmap(
 	if (error)
 		return error;
 
-	error = xchk_install_live_inode(sc,
-			sc->sr.rtg->rtg_inodes[XFS_RTGI_BITMAP]);
+	error = xchk_install_live_inode(sc, rtg_bitmap(sc->sr.rtg));
 	if (error)
 		return error;
 
@@ -146,7 +145,7 @@ xchk_rtbitmap(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
-	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
+	struct xfs_inode	*rbmip = rtg_bitmap(rtg);
 	struct xchk_rtbitmap	*rtb = sc->buf;
 	int			error;
 
@@ -215,7 +214,7 @@ xchk_xref_is_used_rt_space(
 	xfs_extlen_t		len)
 {
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
-	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
+	struct xfs_inode	*rbmip = rtg_bitmap(rtg);
 	xfs_rtxnum_t		startext;
 	xfs_rtxnum_t		endext;
 	bool			is_free;
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 49fc6250bafcaa..f1af5431b38856 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -81,8 +81,7 @@ xchk_setup_rtsummary(
 	if (error)
 		return error;
 
-	error = xchk_install_live_inode(sc,
-			sc->sr.rtg->rtg_inodes[XFS_RTGI_SUMMARY]);
+	error = xchk_install_live_inode(sc, rtg_summary(sc->sr.rtg));
 	if (error)
 		return error;
 
@@ -191,8 +190,7 @@ xchk_rtsum_record_free(
 	rtlen = xfs_rtxlen_to_extlen(mp, rec->ar_extcount);
 
 	if (!xfs_verify_rtbext(mp, rtbno, rtlen)) {
-		xchk_ino_xref_set_corrupt(sc,
-				rtg->rtg_inodes[XFS_RTGI_BITMAP]->i_ino);
+		xchk_ino_xref_set_corrupt(sc, rtg_bitmap(rtg)->i_ino);
 		return -EFSCORRUPTED;
 	}
 
@@ -218,7 +216,7 @@ xchk_rtsum_compute(
 
 	/* If the bitmap size doesn't match the computed size, bail. */
 	if (XFS_FSB_TO_B(mp, xfs_rtbitmap_blockcount(mp)) !=
-	    rtg->rtg_inodes[XFS_RTGI_BITMAP]->i_disk_size)
+	    rtg_bitmap(rtg)->i_disk_size)
 		return -EFSCORRUPTED;
 
 	return xfs_rtalloc_query_all(rtg, sc->tp, xchk_rtsum_record_free, sc);
@@ -310,8 +308,8 @@ xchk_rtsummary(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
-	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
-	struct xfs_inode	*rsumip = rtg->rtg_inodes[XFS_RTGI_SUMMARY];
+	struct xfs_inode	*rbmip = rtg_bitmap(rtg);
+	struct xfs_inode	*rsumip = rtg_summary(rtg);
 	struct xchk_rtsummary	*rts = sc->buf;
 	int			error;
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3abab5fb593e37..e1ba5af6250f0b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -230,10 +230,10 @@ xfs_qm_unmount_rt(
 
 	if (!rtg)
 		return;
-	if (rtg->rtg_inodes[XFS_RTGI_BITMAP])
-		xfs_qm_dqdetach(rtg->rtg_inodes[XFS_RTGI_BITMAP]);
-	if (rtg->rtg_inodes[XFS_RTGI_SUMMARY])
-		xfs_qm_dqdetach(rtg->rtg_inodes[XFS_RTGI_SUMMARY]);
+	if (rtg_bitmap(rtg))
+		xfs_qm_dqdetach(rtg_bitmap(rtg));
+	if (rtg_summary(rtg))
+		xfs_qm_dqdetach(rtg_summary(rtg));
 	xfs_rtgroup_rele(rtg);
 }
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 5128c5ad72f5da..4cd2f32aa70a0a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -856,8 +856,8 @@ xfs_growfs_rt_bmblock(
 	xfs_fileoff_t		bmbno)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
-	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
-	struct xfs_inode	*rsumip = rtg->rtg_inodes[XFS_RTGI_SUMMARY];
+	struct xfs_inode	*rbmip = rtg_bitmap(rtg);
+	struct xfs_inode	*rsumip = rtg_summary(rtg);
 	struct xfs_rtalloc_args	args = {
 		.mp		= mp,
 		.rtg		= rtg,
@@ -1041,8 +1041,8 @@ xfs_growfs_rt_alloc_blocks(
 	xfs_extlen_t		*nrbmblocks)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
-	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
-	struct xfs_inode	*rsumip = rtg->rtg_inodes[XFS_RTGI_SUMMARY];
+	struct xfs_inode	*rbmip = rtg_bitmap(rtg);
+	struct xfs_inode	*rsumip = rtg_summary(rtg);
 	xfs_extlen_t		orbmblocks = 0;
 	xfs_extlen_t		orsumblocks = 0;
 	struct xfs_mount	*nmp;
@@ -1622,7 +1622,7 @@ xfs_rtpick_extent(
 	xfs_rtxlen_t		len)		/* allocation length (rtextents) */
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
-	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
+	struct xfs_inode	*rbmip = rtg_bitmap(rtg);
 	xfs_rtxnum_t		b = 0;		/* result rtext */
 	int			log2;		/* log of sequence number */
 	uint64_t		resid;		/* residual after log removed */

