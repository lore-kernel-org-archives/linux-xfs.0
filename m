Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3842837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995209; cv=none; b=eG8oj+G29BVvV4gNSL6Vb6l0MUOB5M5I/cqJhWzPRL8X8dfKfUgUuChfKkEG0dyhp1WS3XDsNgUWwZcLW/Wv4cSKaoUoqRfqmAUbCceC56e99lVJIpvCyM0/vT5kr1jJB06BsCZdPmgR/lY/pT1n7/9CeEYFJXYYjK0CJXVSrOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995209; c=relaxed/simple;
	bh=AkyaUdYSvZhnL1Y6wxhASs5P6tSY4/xfgLsDT9Gd9WU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aBKqOIGI+pDn3WBs/9uK6j/jupLBDATCCjACZNQSG0vQthSq3ldxhZbjVV1GQQEvy6RwI4FbqYhvOoWfBN0TeWD0YRjlHRYcQ29lWcVgDlYr+rDSmF2MBGkXoxqgs94R2m+F/b0ayJ3USaOJPlUACY5B3MFlnhU9M8DsQmnzGXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4CI7xAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4CI7xAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5557EC4CED3;
	Mon, 23 Dec 2024 23:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995209;
	bh=AkyaUdYSvZhnL1Y6wxhASs5P6tSY4/xfgLsDT9Gd9WU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U4CI7xALvQwS6cBeI6wriNgA0J1u7XoFFAnVJOfbPA0JeVEpEH0TYtD53V+8XKmQX
	 Xu57YFUj+3gz9d6FB1qatUKg0Gh4NRyGNI1Y3RCIee2YT6RzMDNB+YDLDj0o91ATPk
	 KU0m+lBn2nGF+o4XcCCm6A0C5kYBU1cOtqsZbfj70FcaB48bfwSm0SMfSUgO/sqcmY
	 5hv+pizxHKmS2CfCd8V5weeIaTCHzlwQ0I0aexltaH1hrNdyi31/TIhJI5MABI9XSH
	 inSAKFYVCa9z36fgW2NHXkpC6cEFBSiknYonzPzB8R6/1Sgva3urcFaaMd7G+G4mmj
	 zyfwaEIgLcl4w==
Date: Mon, 23 Dec 2024 15:06:48 -0800
Subject: [PATCH 02/43] xfs: namespace the maximum length/refcount symbols
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499419971.2381378.15930313026565206436.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
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

