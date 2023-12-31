Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58461BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u0uq4ELU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8C7C433C8;
	Sun, 31 Dec 2023 21:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059121;
	bh=72ryRCNcAXpJG0BOUn8Nnt8g1BBWOcYKhp5yC+o3RqU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u0uq4ELU/EJti4EgcdJx+0In1PpT+D+sIJ4YKYZiVM8aiQ6Sb3h84IIyBAWd0Lojl
	 XoygJbc4Zjc5CQk7j2eJlhlPNO++furS5fOMG6bdHrWwAXOU4Bw0/8PKwtekLSchJS
	 AkeTF8KYZKNRDNz0EeC6M84N2OnvnpK+GoCaw63PuMZUU0QuOdIx1jP43yda2ZIzTK
	 g7SnTI6mywvaficbgPeMFBkAQXCqffOxCwByv7zovOMU3P6dcYv4gDnWDcfop5TYvv
	 0MYFYSz/ASukdrquvCqfaUS8xOJwohy9bV0zg4lR7/C/bCvU8H0sI7A7lLjglmqyf3
	 8sfbdoJvw1y/w==
Date: Sun, 31 Dec 2023 13:45:21 -0800
Subject: [PATCH 03/44] xfs: namespace the maximum length/refcount symbols
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851629.1766284.4083085525437258188.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Actually namespace these variables properly, so that readers can tell
that this is an XFS symbol, and that it's for the refcount
functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h     |    4 ++--
 fs/xfs/libxfs/xfs_refcount.c   |   18 +++++++++---------
 fs/xfs/scrub/refcount.c        |    2 +-
 fs/xfs/scrub/refcount_repair.c |    4 ++--
 4 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 0dc169fde2e3d..473bdc2a1ad10 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1809,8 +1809,8 @@ struct xfs_refcount_key {
 	__be32		rc_startblock;	/* starting block number */
 };
 
-#define MAXREFCOUNT	((xfs_nlink_t)~0U)
-#define MAXREFCEXTLEN	((xfs_extlen_t)~0U)
+#define XFS_REFC_REFCOUNT_MAX	((xfs_nlink_t)~0U)
+#define XFS_REFC_LEN_MAX	((xfs_extlen_t)~0U)
 
 /* btree pointer type */
 typedef __be32 xfs_refcount_ptr_t;
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index edabdf1a97d4b..b29a718737c59 100644
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
@@ -1197,7 +1197,7 @@ xfs_refcount_adjust_extents(
 		 * Adjust the reference count and either update the tree
 		 * (incr) or free the blocks (decr).
 		 */
-		if (ext.rc_refcount == MAXREFCOUNT)
+		if (ext.rc_refcount == XFS_REFC_REFCOUNT_MAX)
 			goto skip;
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur, &ext);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index d0c7d4a29c0fe..31a0461e2a0e3 100644
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
index b485c5cc9f290..d4a42f8b7e95b 100644
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
 	error = rcbag_init(sc->mp, sc->xfile_buftarg, &rcstack);
 	if (error)

