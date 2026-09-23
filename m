Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D788F39A04F;
	Wed, 23 Sep 2026 06:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143278; cv=none; b=qEB9qVDXGvHuG9bjhfHpVLjLy2wpyHJeUaTiUHg8clwti//rRxHGpyPBIpsJX82EdHsRoKn+kGguBQmsFYd0LzA0RBomceIuD1FYdrdzT89ZnqaW2hvlmO3z+7uXvgglz8Zfb9iOFzixeXd3t8D2DR5UStYhGRJSWaPpazU52+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143278; c=relaxed/simple;
	bh=g2aT2borS2FH0dhBGwePtDrbkIKA3haiThGfdDhm7Jg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=toWJkGNsS7JP47JuU2no5PaDiF0WZfFU5MnVdTQiupRC4I3fFFo99KKz86qLH+Zvk76f8mlaxKmEMAF9DpdeH3Hv/zAKR2+ULVO4zz0rfaN46v6vano48g22q2zqldNz/LFPdS1760Vx0OrSP0jdpy/K2ShW0xU46CwoPIkQtE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCWwT6Dm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCWwT6Dm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7C53A1F000FF;
	Wed, 23 Sep 2026 06:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143276;
	bh=4SfPPKo413daSVbyu/XHjX/TSEgIBixUROZtFRK39X8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=eCWwT6DmMkMi8fgcXNckV+ygnceoSTPnlX/eIwUdUlgByIUDMwml82IHY5rAyBG+n
	 W5txite+GGymzKzSrYJPa92KO8kvRPJAIjlEeXOGfE48q7Tja+Ow4nmM73fHDimF6N
	 JzNaRXJ9oLdtFIFRwTZGbc1v7xhREzVFSRJ0R6jB17VFA3ZxgXvQos156Hn086/nBt
	 P3sSkWuUaz7YS1Bc8mRfBtUY3iFt9iPIldKj9gslvw04z0kILWmcTmMXq3sXamffFz
	 ZDigNUj1tYB7v7sOxN48HSO1+rFzZPw47ZW1b32MEH43sB3IYaNEZOk+J5BTrANFtL
	 BdPdT60rj5APw==
Date: Tue, 22 Sep 2026 23:01:16 -0700
Subject: [PATCH 02/12] xfs: mark cow extents bad if there's no rmap mapping
 for them
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014159586.1875436.14436067546937024850.stgit@frogsfrogsfrogs>
In-Reply-To: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that we fail to mark cow staging extents as bad if there's
a cow staging extent but no rmap record for the cow staging event.
Close this gap.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: dbbdbd0086320a ("xfs: repair problems in CoW forks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/cow_repair.c |   84 +++++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index 8dd9c0266e2169..e49d9396edc527 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -200,29 +200,35 @@ xrep_cow_mark_missing_staging_rmap(
 	void				*priv)
 {
 	struct xrep_cow			*xc = priv;
-	xfs_agblock_t			rec_bno;
-	xfs_extlen_t			rec_len;
-	unsigned int			adj;
+	const xfs_agblock_t		rec_end =
+			rec->rm_startblock + rec->rm_blockcount;
+	int				error = 0;
 
-	if (rec->rm_owner == XFS_RMAP_OWN_COW)
-		return 0;
-
-	rec_bno = rec->rm_startblock;
-	rec_len = rec->rm_blockcount;
-	if (rec_bno < xc->irec_startbno) {
-		adj = xc->irec_startbno - rec_bno;
-		rec_len -= adj;
-		rec_bno += adj;
+	/* Was there a gap since the last rmap? */
+	if (xc->next_bno < rec->rm_startblock) {
+		error = xrep_cow_mark_file_range(xc,
+				xfs_gbno_to_fsb(cur->bc_group, xc->next_bno),
+				rec->rm_startblock - xc->next_bno);
+		if (error)
+			return error;
 	}
 
-	if (rec_bno + rec_len > xc->irec_startbno + xc->irec.br_blockcount) {
-		adj = (rec_bno + rec_len) -
-		      (xc->irec_startbno + xc->irec.br_blockcount);
-		rec_len -= adj;
+	if (rec->rm_owner != XFS_RMAP_OWN_COW) {
+		const xfs_agblock_t	bad_bno =
+				max(xc->irec_startbno, rec->rm_startblock);
+		const xfs_agblock_t	irec_end =
+				xc->irec_startbno + xc->irec.br_blockcount;
+		const xfs_extlen_t	bad_end = min(irec_end, rec_end);
+
+		error = xrep_cow_mark_file_range(xc,
+				xfs_gbno_to_fsb(cur->bc_group, bad_bno),
+				bad_end - bad_bno);
+		if (error)
+			return error;
 	}
 
-	return xrep_cow_mark_file_range(xc,
-			xfs_gbno_to_fsb(cur->bc_group, rec_bno), rec_len);
+	xc->next_bno = max(xc->next_bno, rec_end);
+	return error;
 }
 
 /*
@@ -263,10 +269,12 @@ xrep_cow_find_bad(
 	struct xfs_perag		*pag;
 	struct xfs_scrub		*sc = xc->sc;
 	xfs_agnumber_t			agno;
+	xfs_agblock_t			irec_end;
 	int				error;
 
 	agno = XFS_FSB_TO_AGNO(sc->mp, xc->irec.br_startblock);
 	xc->irec_startbno = XFS_FSB_TO_AGBNO(sc->mp, xc->irec.br_startblock);
+	irec_end = xc->irec_startbno + xc->irec.br_blockcount;
 
 	pag = xfs_perag_get(sc->mp, agno);
 	if (!pag)
@@ -278,7 +286,7 @@ xrep_cow_find_bad(
 
 	/* Mark any CoW fork extents that are shared. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_SHARED;
 	error = xfs_refcount_query_range(sc->sa.refc_cur, &rc_low, &rc_high,
 			xrep_cow_mark_shared_staging, xc);
@@ -287,7 +295,7 @@ xrep_cow_find_bad(
 
 	/* Make sure there are CoW staging extents for the whole mapping. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_COW;
 	xc->next_bno = xc->irec_startbno;
 	error = xfs_refcount_query_range(sc->sa.refc_cur, &rc_low, &rc_high,
@@ -295,11 +303,10 @@ xrep_cow_find_bad(
 	if (error)
 		goto out_sa;
 
-	if (xc->next_bno < xc->irec_startbno + xc->irec.br_blockcount) {
+	if (xc->next_bno < irec_end) {
 		error = xrep_cow_mark_file_range(xc,
 				xfs_agbno_to_fsb(pag, xc->next_bno),
-				xc->irec_startbno + xc->irec.br_blockcount -
-				xc->next_bno);
+				irec_end - xc->next_bno);
 		if (error)
 			goto out_sa;
 	}
@@ -308,11 +315,20 @@ xrep_cow_find_bad(
 	rm_low.rm_startblock = xc->irec_startbno;
 	memset(&rm_high, 0xFF, sizeof(rm_high));
 	rm_high.rm_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	xc->next_bno = xc->irec_startbno;
 	error = xfs_rmap_query_range(sc->sa.rmap_cur, &rm_low, &rm_high,
 			xrep_cow_mark_missing_staging_rmap, xc);
 	if (error)
 		goto out_sa;
 
+	if (xc->next_bno < irec_end) {
+		error = xrep_cow_mark_file_range(xc,
+				xfs_agbno_to_fsb(pag, xc->next_bno),
+				irec_end - xc->next_bno);
+		if (error)
+			goto out_sa;
+	}
+
 	/*
 	 * If userspace is forcing us to rebuild the CoW fork or someone turned
 	 * on the debugging knob, replace everything in the CoW fork.
@@ -344,9 +360,11 @@ xrep_cow_find_bad_rt(
 	struct xfs_rmap_irec		rm_high = { 0 };
 	struct xfs_scrub		*sc = xc->sc;
 	struct xfs_rtgroup		*rtg;
+	xfs_agblock_t			irec_end;
 	int				error = 0;
 
 	xc->irec_startbno = xfs_rtb_to_rgbno(sc->mp, xc->irec.br_startblock);
+	irec_end = xc->irec_startbno + xc->irec.br_blockcount;
 
 	rtg = xfs_rtgroup_get(sc->mp,
 			xfs_rtb_to_rgno(sc->mp, xc->irec.br_startblock));
@@ -360,7 +378,7 @@ xrep_cow_find_bad_rt(
 
 	/* Mark any CoW fork extents that are shared. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_SHARED;
 	error = xfs_refcount_query_range(sc->sr.refc_cur, &rc_low, &rc_high,
 			xrep_cow_mark_shared_staging, xc);
@@ -369,7 +387,7 @@ xrep_cow_find_bad_rt(
 
 	/* Make sure there are CoW staging extents for the whole mapping. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_COW;
 	xc->next_bno = xc->irec_startbno;
 	error = xfs_refcount_query_range(sc->sr.refc_cur, &rc_low, &rc_high,
@@ -377,11 +395,10 @@ xrep_cow_find_bad_rt(
 	if (error)
 		goto out_sr;
 
-	if (xc->next_bno < xc->irec_startbno + xc->irec.br_blockcount) {
+	if (xc->next_bno < irec_end) {
 		error = xrep_cow_mark_file_range(xc,
 				xfs_rgbno_to_rtb(rtg, xc->next_bno),
-				xc->irec_startbno + xc->irec.br_blockcount -
-				xc->next_bno);
+				irec_end - xc->next_bno);
 		if (error)
 			goto out_sr;
 	}
@@ -389,12 +406,21 @@ xrep_cow_find_bad_rt(
 	/* Mark any area has an rmap that isn't a COW staging extent. */
 	rm_low.rm_startblock = xc->irec_startbno;
 	memset(&rm_high, 0xFF, sizeof(rm_high));
-	rm_high.rm_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rm_high.rm_startblock = irec_end - 1;
+	xc->next_bno = xc->irec_startbno;
 	error = xfs_rmap_query_range(sc->sr.rmap_cur, &rm_low, &rm_high,
 			xrep_cow_mark_missing_staging_rmap, xc);
 	if (error)
 		goto out_sr;
 
+	if (xc->next_bno < irec_end) {
+		error = xrep_cow_mark_file_range(xc,
+				xfs_rgbno_to_rtb(rtg, xc->next_bno),
+				irec_end - xc->next_bno);
+		if (error)
+			goto out_sr;
+	}
+
 	/*
 	 * If userspace is forcing us to rebuild the CoW fork or someone
 	 * turned on the debugging knob, replace everything in the

