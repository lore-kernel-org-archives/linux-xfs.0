Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172041B043D
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636814; cv=none; b=NUqUk9oB+HQJKJZTpokX5Te0nurAn0DHVsQH51gFDCmOGWh6LjttSCU5ikvFblhV7/DB/xLDyYZ75I/zAq1cRG3lH0KsdgfZeufOJk6O5fximuYmcoXVRs0PyHUH3hToof1udEi890kCIgmDEAqC5UtVfEv7IwKFCUz3CmBEyoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636814; c=relaxed/simple;
	bh=AkyaUdYSvZhnL1Y6wxhASs5P6tSY4/xfgLsDT9Gd9WU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SCALaWl2aeJTeB8EAtIuDRAqw5ZMEyiC93+PwA9vNypSuM+a+P0k25wWzoWI59Q7HwuwNpy2gPceix+A/bA6vUwMdZnYPfeOf9vfmvwr1DlQGz9CyayltKrF5gIoblde1qGyduCthpCeAYJxjvmQk8xc7IaaUjhQcTGXZgx1vSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NRXDpFyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NRXDpFyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95F1C4CECE;
	Thu, 19 Dec 2024 19:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636814;
	bh=AkyaUdYSvZhnL1Y6wxhASs5P6tSY4/xfgLsDT9Gd9WU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NRXDpFyi6L54crMtNXNN9YJQJuGurYosHcp9TsIA1yuMrU0PoLBGjQQif2OAcdD2Q
	 2+NdwFNMMWrnB2m8PCoOOaozQ4lx2OWo2QFdKsvW5EwYRrw4lr6YvviN1Qz4jNPEHI
	 h4kA2glAqTUSMB3lSEXap/T29JPcI3qkKoou3wogtZ01GP0VPxqmy2+5ZTo3w8bthg
	 DXJNv61xzYnre6RwZCQkqKFUS64PilIBAn4OBd9VWLMDxRmLzL6icu/mkqtRHiIu/u
	 t1D6jGu8pyWLEDw1RYBzY71Ifo/m7GdkXRJ4vyePITD8uH1l/1FeW6/qbxZZsAF+iL
	 0OpYzwaxjsb4A==
Date: Thu, 19 Dec 2024 11:33:33 -0800
Subject: [PATCH 02/43] xfs: namespace the maximum length/refcount symbols
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581010.1572761.11513189735808800599.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Actually namespace these variables properly, so that readers can tell
that this is an XFS symbol, and that it's for the refcount
functionality.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h     |    4 ++--
 fs/xfs/libxfs/xfs_refcount.c   |   18 +++++++++---------
 fs/xfs/scrub/refcount.c        |    2 +-
 fs/xfs/scrub/refcount_repair.c |    4 ++--
 4 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index fba4e59aded4a0..16696bc3ff9445 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1790,8 +1790,8 @@ struct xfs_refcount_key {
 	__be32		rc_startblock;	/* starting block number */
 };
 
-#define MAXREFCOUNT	((xfs_nlink_t)~0U)
-#define MAXREFCEXTLEN	((xfs_extlen_t)~0U)
+#define XFS_REFC_REFCOUNT_MAX	((xfs_nlink_t)~0U)
+#define XFS_REFC_LEN_MAX	((xfs_extlen_t)~0U)
 
 /* btree pointer type */
 typedef __be32 xfs_refcount_ptr_t;
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index bbb86dc9a25c7f..faace12fe2e383 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -128,7 +128,7 @@ xfs_refcount_check_irec(
 	struct xfs_perag		*pag,
 	const struct xfs_refcount_irec	*irec)
 {
-	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
+	if (irec->rc_blockcount == 0 || irec->rc_blockcount > XFS_REFC_LEN_MAX)
 		return __this_address;
 
 	if (!xfs_refcount_check_domain(irec))
@@ -138,7 +138,7 @@ xfs_refcount_check_irec(
 	if (!xfs_verify_agbext(pag, irec->rc_startblock, irec->rc_blockcount))
 		return __this_address;
 
-	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
+	if (irec->rc_refcount == 0 || irec->rc_refcount > XFS_REFC_REFCOUNT_MAX)
 		return __this_address;
 
 	return NULL;
@@ -853,9 +853,9 @@ xfs_refc_merge_refcount(
 	const struct xfs_refcount_irec	*irec,
 	enum xfs_refc_adjust_op		adjust)
 {
-	/* Once a record hits MAXREFCOUNT, it is pinned there forever */
-	if (irec->rc_refcount == MAXREFCOUNT)
-		return MAXREFCOUNT;
+	/* Once a record hits XFS_REFC_REFCOUNT_MAX, it is pinned forever */
+	if (irec->rc_refcount == XFS_REFC_REFCOUNT_MAX)
+		return XFS_REFC_REFCOUNT_MAX;
 	return irec->rc_refcount + adjust;
 }
 
@@ -898,7 +898,7 @@ xfs_refc_want_merge_center(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cleft->rc_blockcount + right->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	*ulenp = ulen;
@@ -933,7 +933,7 @@ xfs_refc_want_merge_left(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cleft->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
@@ -967,7 +967,7 @@ xfs_refc_want_merge_right(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cright->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
@@ -1196,7 +1196,7 @@ xfs_refcount_adjust_extents(
 		 * Adjust the reference count and either update the tree
 		 * (incr) or free the blocks (decr).
 		 */
-		if (ext.rc_refcount == MAXREFCOUNT)
+		if (ext.rc_refcount == XFS_REFC_REFCOUNT_MAX)
 			goto skip;
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur, &ext);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 1c5e45cc64190c..d465280230154f 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -421,7 +421,7 @@ xchk_refcount_mergeable(
 	if (r1->rc_refcount != r2->rc_refcount)
 		return false;
 	if ((unsigned long long)r1->rc_blockcount + r2->rc_blockcount >
-			MAXREFCEXTLEN)
+			XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index 4e572b81c98669..1ee6d4aeb308f5 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -183,7 +183,7 @@ xrep_refc_stash(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
-	irec.rc_refcount = min_t(uint64_t, MAXREFCOUNT, refcount);
+	irec.rc_refcount = min_t(uint64_t, XFS_REFC_REFCOUNT_MAX, refcount);
 
 	error = xrep_refc_check_ext(rr->sc, &irec);
 	if (error)
@@ -422,7 +422,7 @@ xrep_refc_find_refcounts(
 	/*
 	 * Set up a bag to store all the rmap records that we're tracking to
 	 * generate a reference count record.  If the size of the bag exceeds
-	 * MAXREFCOUNT, we clamp rc_refcount.
+	 * XFS_REFC_REFCOUNT_MAX, we clamp rc_refcount.
 	 */
 	error = rcbag_init(sc->mp, sc->xmbtp, &rcstack);
 	if (error)

