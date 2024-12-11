Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF551EC4D9
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907451; cv=none; b=ZC84kQPzh7+SEj3PBnuGzTzgQNsdFt7ZFXogar1Pnr4AC+ltIYZiLWbLW/CFp122FpRs55FDyv0dQ0xZhbBjAfKtI3uX5/ZRYHnEE1JbVWkf81PG5W/MeiPhQ45o+ZtTYp7uS6CnipEUYUtYhmaKzjwNBl7g2t1PZNwmWs+47Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907451; c=relaxed/simple;
	bh=E1lhW0vm21Q62xhvDUb+zeyCJ0PzK1eUiYiZDrAOUOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AATPA4kX15GmABaGLnmNvg5MeTxCj9zzJYNHLcUIUAJcCzmWYefieIkWZWHIWyPoRVYe+4hrJiopiGT7fnDEzKXgmQVBFydy7A5xvvojoADPu0DAKFnVCcR7l+9uMC7DLvlKlhitxbJa99X5TctN3RT5Nu/Nb5XXF+SMFUfQ4bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DRoCQ6zb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DRoCQ6zb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6BX5+LEb3UyrSRzCOVOqIsg+EWg8wafrDar19ieGn6g=; b=DRoCQ6zbO+EssLbxXu0DVpVJ4b
	1YQDYEhFjEMqD6v6661KzG7/2wIt2TkaXq3qJByezkSdidpDBRSbFT70dByJCPJUJUDqxQ0A8CYCU
	6qekZ40EoYeSPS/Stm44YrYB/5PtNAZlN152RtKXAK3XrtViIv7wgPvsE5YMD8q0lB+UIT91SaxDM
	TOCccqWPhfFvFw9VCDNoVQ/M+r+ESPH27d/zIiZADddG1GyBe2gwsVoN0J4qKNb9m1bg1ehx8t5fm
	QRVMcHVTMnT4DUSZsuqMrRCFYk8MawwNn6PcJ1pHLIMaorL0bRm3Am3JdFYHhYsSmtzKpTyW2FyGs
	YWj6fBFg==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIXB-0000000EJCa-0n1k;
	Wed, 11 Dec 2024 08:57:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 19/43] xfs: disable sb_frextents for zoned file systems
Date: Wed, 11 Dec 2024 09:54:44 +0100
Message-ID: <20241211085636.1380516-20-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Zoned file systems not only don't use the global frextents counter, but
for them the in-memory percpu counter also includes reservations taken
before even allocating delalloc extent records, so it will never match
the per-zone used information.  Disable all updates and verification of
the sb counter for zoned file systems as it isn't useful for them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_sb.c           |  2 +-
 fs/xfs/scrub/fscounters.c        | 11 +++++++++--
 fs/xfs/scrub/fscounters_repair.c | 10 ++++++----
 fs/xfs/xfs_mount.c               |  2 +-
 fs/xfs/xfs_super.c               |  4 +++-
 5 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 6fc21c0a332b..ee56fc22fd06 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1305,7 +1305,7 @@ xfs_log_sb(
 	 * we handle nearly-lockless reservations, so we must use the _positive
 	 * variant here to avoid writing out nonsense frextents.
 	 */
-	if (xfs_has_rtgroups(mp)) {
+	if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp)) {
 		mp->m_sb.sb_frextents =
 			xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS);
 	}
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 732658a62a2d..5f5f67947440 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -413,7 +413,13 @@ xchk_fscount_count_frextents(
 
 	fsc->frextents = 0;
 	fsc->frextents_delayed = 0;
-	if (!xfs_has_realtime(mp))
+
+	/*
+	 * Don't bother verifying and repairing the fs counters for zoned file
+	 * systems as they don't track an on-disk frextents count, and the
+	 * in-memory percpu counter also includes reservations.
+	 */
+	if (!xfs_has_realtime(mp) || xfs_has_zoned(mp))
 		return 0;
 
 	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
@@ -597,7 +603,8 @@ xchk_fscounters(
 			try_again = true;
 	}
 
-	if (!xchk_fscount_within_range(sc, frextents,
+	if (!xfs_has_zoned(mp) &&
+	    !xchk_fscount_within_range(sc, frextents,
 			&mp->m_free[XC_FREE_RTEXTENTS],
 			fsc->frextents - fsc->frextents_delayed)) {
 		if (fsc->frozen)
diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
index 8fb0db78489e..f0d2b04644e4 100644
--- a/fs/xfs/scrub/fscounters_repair.c
+++ b/fs/xfs/scrub/fscounters_repair.c
@@ -74,10 +74,12 @@ xrep_fscounters(
 	 * track of the delalloc reservations separately, as they are are
 	 * subtracted from m_frextents, but not included in sb_frextents.
 	 */
-	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
-		fsc->frextents - fsc->frextents_delayed);
-	if (!xfs_has_rtgroups(mp))
-		mp->m_sb.sb_frextents = fsc->frextents;
+	if (!xfs_has_zoned(mp)) {
+		xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
+				fsc->frextents - fsc->frextents_delayed);
+		if (!xfs_has_rtgroups(mp))
+			mp->m_sb.sb_frextents = fsc->frextents;
+	}
 
 	return 0;
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index db910ecc1ed4..72fa28263e14 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -551,7 +551,7 @@ xfs_check_summary_counts(
 	 * If we're mounting the rt volume after recovering the log, recompute
 	 * frextents from the rtbitmap file to fix the inconsistency.
 	 */
-	if (xfs_has_realtime(mp) && !xfs_is_clean(mp)) {
+	if (xfs_has_realtime(mp) && !xfs_has_zoned(mp) && !xfs_is_clean(mp)) {
 		error = xfs_rtalloc_reinit_frextents(mp);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 18430e975c53..d0b7e0d02366 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1127,7 +1127,9 @@ xfs_reinit_percpu_counters(
 	percpu_counter_set(&mp->m_icount, mp->m_sb.sb_icount);
 	percpu_counter_set(&mp->m_ifree, mp->m_sb.sb_ifree);
 	xfs_set_freecounter(mp, XC_FREE_BLOCKS, mp->m_sb.sb_fdblocks);
-	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS, mp->m_sb.sb_frextents);
+	if (!xfs_has_zoned(mp))
+		xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
+				mp->m_sb.sb_frextents);
 }
 
 static void
-- 
2.45.2

