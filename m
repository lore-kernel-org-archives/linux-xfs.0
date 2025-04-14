Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB41148832
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609072; cv=none; b=AoXjlw6ap9Jy1F3/kR119SbAmoR6JPPre/CtQDCSphVRvtOMoDTI1iYbc+u8x7O2O7yzFUw8g1AFKQqaisF+ceZyvs2uZoij6kAsp/htqdDBarW7wEL86JHN6/TmsYD81z+uMEilNDwQmsAsgpAoTyM/T0+uFbey7FHswejjlpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609072; c=relaxed/simple;
	bh=NtMxzHIKxjvQglgk1sPfa6U/JKRJU1aGhBNXri7hVMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hi2nXTqUU9VIYldvjAEpZB76b5YmGoYb0TuzfG1HhBVup5FV8jQzTfoEkMAVd12L+nbES4+72dP6nqVWCi+YAu8sRYZcQqcKbPkOgV75SUXcWIB+5OIRbjhDbcvWmdX4uDEU+5ZaWbqCaQYcnQc1CqFXp6yKfxsuWSEWakc69QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=304Oh1HD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="304Oh1HD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/tQzDyj85m6G7/YgwB+twEwLeTuOoMClNNB71uDJYkI=; b=304Oh1HDH8sEx/qTweIElTQ91l
	qbSc2L7ZkwHJgRHOY/dJi+djt6UiABo94HGLX1qMeCxkFFBGxQV8H2TJgxHBQ4AlxWRtcIOwcWotp
	fSWQw+KE5q3tXaJOE4RnJFxgmeot0lGUai4lTe4THh87BRgYZ+O8i7gvT+aUjUhFkzSvVc1ssKEyh
	w7UvhzF2tSxK6VpyoazIY6JWKBldCc2x+3Otx4Tty9bBQuQNW+/TNuSESBfp5n0MHJLdXzHpxOFe4
	iwlTM3/sf9U891S1C/X00BS+OD1bpJmGdbqMTs61mhDOERTJDxlFrv906WlSJ88EmqCmtgiSCT6zr
	F2vfLyIw==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVy-00000000iLb-36Jn;
	Mon, 14 Apr 2025 05:37:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 27/43] xfs_repair: support repairing zoned file systems
Date: Mon, 14 Apr 2025 07:36:10 +0200
Message-ID: <20250414053629.360672-28-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Note really much to do here.  Mostly ignore the validation and
regeneration of the bitmap and summary inodes.  Eventually this
could grow a bit of validation of the hardware zone state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c        |  4 +++-
 repair/phase5.c        | 13 +++++++++++++
 repair/phase6.c        |  6 ++++--
 repair/rt.c            |  2 ++
 repair/rtrmap_repair.c | 33 +++++++++++++++++++++++++++++++++
 repair/xfs_repair.c    |  9 ++++++---
 6 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 8696a838087f..7bdd3dcf15c1 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -3585,7 +3585,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 
 	validate_extsize(mp, dino, lino, dirty);
 
-	if (dino->di_version >= 3)
+	if (dino->di_version >= 3 &&
+	    (!xfs_has_zoned(mp) ||
+	     dino->di_metatype != cpu_to_be16(XFS_METAFILE_RTRMAP)))
 		validate_cowextsize(mp, dino, lino, dirty);
 
 	/* nsec fields cannot be larger than 1 billion */
diff --git a/repair/phase5.c b/repair/phase5.c
index 4cf28d8ae1a2..e350b411c243 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -630,6 +630,19 @@ void
 check_rtmetadata(
 	struct xfs_mount	*mp)
 {
+	if (xfs_has_zoned(mp)) {
+		/*
+		 * Here we could/should verify the zone state a bit when we are
+		 * on actual zoned devices:
+		 *	- compare hw write pointer to last written
+		 *	- compare zone state to last written
+		 *
+		 * Note much we can do when running in zoned mode on a
+		 * conventional device.
+		 */
+		return;
+	}
+
 	generate_rtinfo(mp);
 	check_rtbitmap(mp);
 	check_rtsummary(mp);
diff --git a/repair/phase6.c b/repair/phase6.c
index dbc090a54139..a7187e84daae 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3460,8 +3460,10 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 		return;
 
 	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
-		ensure_rtgroup_bitmap(rtg);
-		ensure_rtgroup_summary(rtg);
+		if (!xfs_has_zoned(mp)) {
+			ensure_rtgroup_bitmap(rtg);
+			ensure_rtgroup_summary(rtg);
+		}
 		ensure_rtgroup_rmapbt(rtg, est_fdblocks);
 		ensure_rtgroup_refcountbt(rtg, est_fdblocks);
 	}
diff --git a/repair/rt.c b/repair/rt.c
index e0a4943ee3b7..a2478fb635e3 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -222,6 +222,8 @@ check_rtfile_contents(
 	xfs_fileoff_t		bno = 0;
 	int			error;
 
+	ASSERT(!xfs_has_zoned(mp));
+
 	if (!ip) {
 		do_warn(_("unable to open %s file\n"), filename);
 		return;
diff --git a/repair/rtrmap_repair.c b/repair/rtrmap_repair.c
index 2b07e8943e59..955db1738fe2 100644
--- a/repair/rtrmap_repair.c
+++ b/repair/rtrmap_repair.c
@@ -141,6 +141,37 @@ xrep_rtrmap_btree_load(
 	return error;
 }
 
+static void
+rtgroup_update_counters(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_inode	*rmapip = rtg->rtg_inodes[XFS_RTGI_RMAP];
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	uint64_t		end =
+		xfs_rtbxlen_to_blen(mp, rtg->rtg_extents);
+	xfs_agblock_t		gbno = 0;
+	uint64_t		used = 0;
+
+	do {
+		int		bstate;
+		xfs_extlen_t	blen;
+
+		bstate = get_bmap_ext(rtg_rgno(rtg), gbno, end, &blen, true);
+		switch (bstate) {
+		case XR_E_INUSE:
+		case XR_E_INUSE_FS:
+			used += blen;
+			break;
+		default:
+			break;
+		}
+
+		gbno += blen;
+	} while (gbno < end);
+
+	rmapip->i_used_blocks = used;
+}
+
 /* Update the inode counters. */
 STATIC int
 xrep_rtrmap_reset_counters(
@@ -153,6 +184,8 @@ xrep_rtrmap_reset_counters(
 	 * generated.
 	 */
 	sc->ip->i_nblocks = rr->new_fork_info.ifake.if_blocks;
+	if (xfs_has_zoned(sc->mp))
+		rtgroup_update_counters(rr->rtg);
 	libxfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
 
 	/* Quotas don't exist so we're done. */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index eeaaf6434689..7bf75c09b945 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1388,16 +1388,19 @@ main(int argc, char **argv)
 	 * Done with the block usage maps, toss them.  Realtime metadata aren't
 	 * rebuilt until phase 6, so we have to keep them around.
 	 */
-	if (mp->m_sb.sb_rblocks == 0)
+	if (mp->m_sb.sb_rblocks == 0) {
 		rmaps_free(mp);
-	free_bmaps(mp);
+		free_bmaps(mp);
+	}
 
 	if (!bad_ino_btree)  {
 		phase6(mp);
 		phase_end(mp, 6);
 
-		if (mp->m_sb.sb_rblocks != 0)
+		if (mp->m_sb.sb_rblocks != 0) {
 			rmaps_free(mp);
+			free_bmaps(mp);
+		}
 		free_rtgroup_inodes();
 
 		phase7(mp, phase2_threads);
-- 
2.47.2

