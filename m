Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DBB1DDC07
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866368; cv=none; b=K1CQaKUreVRz43eqIE3oXPMcRpi9h1yCAYhK9olbG5rNNxcn6OfnVFXjmgOsAd85d/mV0MprEwOeWRqCrcPSaSqpHSv02xvoy9VnAIVkaW5zpTR4E9z8bFHITWL99Vc51uNl4VjUPntolD65ms/DlqXEqFYHI9Spn5i9UA8oCMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866368; c=relaxed/simple;
	bh=zzYde/ysDi7IHF04JF0iUFu8MVP02meo2MMvu452DAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPkML7vvFi5WEvamtcuibk5jQGqTTgoRbM9uLhMkKGwIZORKsw/iprgQ4OlhlxJLadEm1CUA7+jZnx5uKOuX1XZtlpA1WcVwpL6dBot0oyHlGFpdJ0iAK6wol5HJsb5vXAqEc1Tzfo7fw+YwB02xthIOhFAMkRwTKGfB70W5cLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KQv0S9iD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KQv0S9iD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fvHfsvkIWCsx1ByIq3on87A+oDYX6mIhXF+Mr4bWMA4=; b=KQv0S9iDVm++eza6M2AGiWzCyh
	6zk+FfGj6n/iEXgTdcEXjregv5YtrewvRWbnQ7vx0YY8E2k2h2s8XNkQTekLkUwQIg/D+vPXt49gI
	tLMObWrY2QHRha5iQrEC/h5Kshe66cIZKYAiAIBre+EoaHk42ZXoPDmMnIIGBcqFFJ1Mr22Uw3pBf
	kKdJsu7lmWRzRcSzB4oIADaByYFwSyVJRJx4b2R15Gdf+2CbTHnJnk3yJ+U7jcUIkwwrFv69ya1An
	vsrRsjmN5FnlbZG8AlWqVyF7m9r+qgfQtqnbL4kHd9j9k3qAk94LClxj6S7zqtirVOhIi3Bhl4QQJ
	F+w6hyyg==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIik-00000007CX7-0hUc;
	Tue, 18 Feb 2025 08:12:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 19/45] xfs: disable sb_frextents for zoned file systems
Date: Tue, 18 Feb 2025 09:10:22 +0100
Message-ID: <20250218081153.3889537-20-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c           |  2 +-
 fs/xfs/scrub/fscounters.c        | 11 +++++++++--
 fs/xfs/scrub/fscounters_repair.c | 10 ++++++----
 fs/xfs/xfs_mount.c               |  2 +-
 fs/xfs/xfs_super.c               |  4 +++-
 5 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 3b886886ea69..65256e109e64 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1333,7 +1333,7 @@ xfs_log_sb(
 	 * we handle nearly-lockless reservations, so we must use the _positive
 	 * variant here to avoid writing out nonsense frextents.
 	 */
-	if (xfs_has_rtgroups(mp)) {
+	if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp)) {
 		mp->m_sb.sb_frextents =
 				xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS);
 	}
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 9dd893ece188..e629663e460a 100644
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
 			&mp->m_free[XC_FREE_RTEXTENTS].count,
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
index 6b80fd55c787..fd1f1e63ede7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -556,7 +556,7 @@ xfs_check_summary_counts(
 	 * If we're mounting the rt volume after recovering the log, recompute
 	 * frextents from the rtbitmap file to fix the inconsistency.
 	 */
-	if (xfs_has_realtime(mp) && !xfs_is_clean(mp)) {
+	if (xfs_has_realtime(mp) && !xfs_has_zoned(mp) && !xfs_is_clean(mp)) {
 		error = xfs_rtalloc_reinit_frextents(mp);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 86d61f3d83cd..a840e1c68ff2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1131,7 +1131,9 @@ xfs_reinit_percpu_counters(
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

