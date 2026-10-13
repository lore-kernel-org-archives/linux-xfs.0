Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7155749B5AB
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871830; cv=none; b=HwbSpW2H+kqjpdCU1Ul6VZwsKWrloHBMsK9mXxb/oblBM5HR2eygAcbXeLOHf4anXfzdA2NO+C/Wn9pefvylxrGMFTAd2xQRxRbWgwW9K44Os7cWgOHFazhrS4njdpMViKkm44sAC0cDHem7RazCVwrtcRLzhEtPiaRGEc+9Uqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871830; c=relaxed/simple;
	bh=8cHdCT4q5CvEutRiTZ3xmF35rgrazoxi10+nNBQ3Ric=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qYTI4CNp0JK+FgwUO5YuGdBPEcmSfq7LRlYSQ46Kr65YlXRt5e13RcMXi24s4oC3URTbLrKq2O1ugYJX3HMwIZZKcrV37GORR9WRRpl5t1xSOPlEhs9uQuwTgFb3ovmf9OvI+1c3HRV0xTeSUpfH/l3ltnPgnnigHPYaZVh2pM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpaHVXIs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpaHVXIs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B97FA1F000FF;
	Tue, 13 Oct 2026 06:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871825;
	bh=n4JYZ4a2MRgqZNwX/h9zP37n1vIkZ9iKd476zTZ29PA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=JpaHVXIskzkJqnJ1zfU74ZKH8zVRwojO3ZV/mPmia/rzjRCt4ns5N5a8zsa/zzETx
	 00Os/i042vKj7ZYHfOlY5kKeRVbRNRLjA36lSXGocFxl84yGfcpw0Ftih1uKCzzT+A
	 HflZiFJw8cHg2aGn02NhSvnF3ZP4GjJememeB7ZOt/mHg6e7KSdYvmJnvtTEwgOhqW
	 Js+nXLlbsL9RZpNTaI6P9cTytuiL44Jy0eOwVYFjr0yzaEWR3pmdGUKqBRH7bjMi2z
	 K9nOgd29nSnL+Q+3LA0b+2vHOKfC6Cc7Ht6ce6dXOvgzfxlDaSjuwXTga3WMqcPk7/
	 JBPQzQ713SVmA==
Date: Mon, 12 Oct 2026 23:10:25 -0700
Subject: [PATCH 08/12] xfs: drop unnecessary sa parameter from the xrep_ag
 init functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179186108015.1898896.1117829804477814070.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
References: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM went down a crazy path complaining about the horrible things that
happen in these functions if sa != &sc->sa.  However, I observe that the
sa argument is never not &sc->sa, so let's just drop the parameter.
There's no bug here, but let's get rid of some stupid.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/repair.h            |    5 ++---
 fs/xfs/scrub/alloc_repair.c      |    2 +-
 fs/xfs/scrub/bmap_repair.c       |    2 +-
 fs/xfs/scrub/cow_repair.c        |    2 +-
 fs/xfs/scrub/ialloc_repair.c     |    2 +-
 fs/xfs/scrub/refcount_repair.c   |    2 +-
 fs/xfs/scrub/repair.c            |   10 +++++-----
 fs/xfs/scrub/rmap_repair.c       |    4 ++--
 fs/xfs/scrub/rtrefcount_repair.c |    2 +-
 fs/xfs/scrub/rtrmap_repair.c     |    2 +-
 10 files changed, 16 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 1af568651e20a1..a32fd9fb59bdae 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -100,9 +100,8 @@ int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
 struct xfs_imap;
 int xrep_setup_inode(struct xfs_scrub *sc, const struct xfs_imap *imap);
 
-void xrep_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
-int xrep_ag_init(struct xfs_scrub *sc, struct xfs_perag *pag,
-		struct xchk_ag *sa);
+void xrep_ag_btcur_init(struct xfs_scrub *sc);
+int xrep_ag_init(struct xfs_scrub *sc, struct xfs_perag *pag);
 #ifdef CONFIG_XFS_RT
 int xrep_rtgroup_init(struct xfs_scrub *sc, struct xfs_rtgroup *rtg,
 		struct xchk_rt *sr, unsigned int rtglock_flags);
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 05f27c927adfb9..854cfbbd9ecf4f 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -370,7 +370,7 @@ xrep_abt_find_freespace(
 
 	xagb_bitmap_init(&ra->not_allocbt_blocks);
 
-	xrep_ag_btcur_init(sc, &sc->sa);
+	xrep_ag_btcur_init(sc);
 
 	/*
 	 * Iterate all the reverse mappings to find gaps in the physical
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index eabffba47776e9..7288940b74e6c1 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -359,7 +359,7 @@ xrep_bmap_scan_ag(
 	struct xfs_scrub	*sc = rb->sc;
 	int			error;
 
-	error = xrep_ag_init(sc, pag, &sc->sa);
+	error = xrep_ag_init(sc, pag);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index e49d9396edc527..3d4e94757de040 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -280,7 +280,7 @@ xrep_cow_find_bad(
 	if (!pag)
 		return -EFSCORRUPTED;
 
-	error = xrep_ag_init(sc, pag, &sc->sa);
+	error = xrep_ag_init(sc, pag);
 	if (error)
 		goto out_pag;
 
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index 43846b3bbf4ed4..f0f2232a9686d8 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -473,7 +473,7 @@ xrep_ibt_find_inodes(
 	ri->rie.ir_startino = NULLAGINO;
 
 	/* Collect all reverse mappings for inode blocks. */
-	xrep_ag_btcur_init(sc, &sc->sa);
+	xrep_ag_btcur_init(sc);
 	error = xfs_rmap_query_all(sc->sa.rmap_cur, xrep_ibt_walk_rmap, ri);
 	xchk_ag_btcur_free(&sc->sa);
 	if (error)
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index ca9c382005ff1d..aa29d7a27abaa8 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -411,7 +411,7 @@ xrep_refc_find_refcounts(
 	bool			have;
 	int			error;
 
-	xrep_ag_btcur_init(sc, &sc->sa);
+	xrep_ag_btcur_init(sc);
 
 	/*
 	 * Set up a bag to store all the rmap records that we're tracking to
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 956aa75218aa24..19c582223efe42 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -888,10 +888,10 @@ xrep_ino_ensure_extent_count(
  */
 void
 xrep_ag_btcur_init(
-	struct xfs_scrub	*sc,
-	struct xchk_ag		*sa)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
+	struct xchk_ag		*sa = &sc->sa;
 
 	/* Set up a bnobt cursor for cross-referencing. */
 	if (sc->sm->sm_type != XFS_SCRUB_TYPE_BNOBT &&
@@ -990,9 +990,9 @@ xrep_reinit_pagi(
 int
 xrep_ag_init(
 	struct xfs_scrub	*sc,
-	struct xfs_perag	*pag,
-	struct xchk_ag		*sa)
+	struct xfs_perag	*pag)
 {
+	struct xchk_ag		*sa = &sc->sa;
 	int			error;
 
 	ASSERT(!sa->pag);
@@ -1007,7 +1007,7 @@ xrep_ag_init(
 
 	/* Grab our own passive reference from the caller's ref. */
 	sa->pag = xfs_perag_hold(pag);
-	xrep_ag_btcur_init(sc, sa);
+	xrep_ag_btcur_init(sc);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 725035bf490329..aac9e534df798f 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -910,7 +910,7 @@ xrep_rmap_find_rmaps(
 	int			error;
 
 	/* Find all the per-AG metadata. */
-	xrep_ag_btcur_init(sc, &sc->sa);
+	xrep_ag_btcur_init(sc);
 
 	error = xrep_rmap_find_inode_rmaps(rr);
 	if (error)
@@ -1167,7 +1167,7 @@ xrep_rmap_reserve_space(
 	} while (!done);
 
 	/* Emit rmaps for everything in the free space bitmap. */
-	xrep_ag_btcur_init(rr->sc, &rr->sc->sa);
+	xrep_ag_btcur_init(rr->sc);
 	error = xrep_rmap_stash_bitmap(rr, &freesp_blocks, &XFS_RMAP_OINFO_AG);
 	xchk_ag_btcur_free(&rr->sc->sa);
 
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index 2b939960c7ddcd..b307ea15197090 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -420,7 +420,7 @@ xrep_rtrefc_scan_ag(
 	struct xfs_scrub	*sc = rr->sc;
 	int			error;
 
-	error = xrep_ag_init(sc, pag, &sc->sa);
+	error = xrep_ag_init(sc, pag);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index a2b72e61edf5fe..6b435acc2d69ff 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -413,7 +413,7 @@ xrep_rtrmap_scan_ag(
 	struct xfs_scrub	*sc = rr->sc;
 	int			error;
 
-	error = xrep_ag_init(sc, pag, &sc->sa);
+	error = xrep_ag_init(sc, pag);
 	if (error)
 		return error;
 

