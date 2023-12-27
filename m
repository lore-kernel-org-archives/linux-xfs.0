Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255F87EE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ORuMvI7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6E9C433C7;
	Mon,  1 Jan 2024 00:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068800;
	bh=RAZqk422lgzSjsb+8omzNRQ+MEY+NS8L+YMHiEufRik=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ORuMvI7XJu1ketdSzbfrIaOv0Al8L6ZdNoWViRbXNxQbFhPMy8sWrS8NAm7EfuC0W
	 lfUMbG/9D1igp6pWdL8kWPQsrjDOFY80RB/nB7GCvtgJ7YP03nAtJrCYw3DMxV+3Ma
	 w25H6fy/ecW3p1KVpD+wxy/HkaFz4hncwEGO8Nhg0wNKAElWLpdXh4XHQM1VW0XNbI
	 IAxlc2RWqHalsHM1MkW3NA/YMqpqr/vN54MaaKvrhDsRuSAJvNx8FgFVg7b5fOw+4I
	 No8O4Cg/4lwcAYF0RoS4kvGeJXHjwDT5ngNG0oWdrpIq6Z43aUUT58N5C+dPuLEmza
	 jQQjK9uxLffRQ==
Date: Sun, 31 Dec 2023 16:26:40 +9900
Subject: [PATCH 02/42] xfs: namespace the maximum length/refcount symbols
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017151.1817107.2813514508736516850.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_format.h   |    4 ++--
 libxfs/xfs_refcount.c |   18 +++++++++---------
 repair/rmap.c         |    4 ++--
 repair/scan.c         |    2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 0dc169fde2e..473bdc2a1ad 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1809,8 +1809,8 @@ struct xfs_refcount_key {
 	__be32		rc_startblock;	/* starting block number */
 };
 
-#define MAXREFCOUNT	((xfs_nlink_t)~0U)
-#define MAXREFCEXTLEN	((xfs_extlen_t)~0U)
+#define XFS_REFC_REFCOUNT_MAX	((xfs_nlink_t)~0U)
+#define XFS_REFC_LEN_MAX	((xfs_extlen_t)~0U)
 
 /* btree pointer type */
 typedef __be32 xfs_refcount_ptr_t;
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index b094d9a41f6..e98d5ea6ca2 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -127,7 +127,7 @@ xfs_refcount_check_irec(
 	struct xfs_perag		*pag,
 	const struct xfs_refcount_irec	*irec)
 {
-	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
+	if (irec->rc_blockcount == 0 || irec->rc_blockcount > XFS_REFC_LEN_MAX)
 		return __this_address;
 
 	if (!xfs_refcount_check_domain(irec))
@@ -137,7 +137,7 @@ xfs_refcount_check_irec(
 	if (!xfs_verify_agbext(pag, irec->rc_startblock, irec->rc_blockcount))
 		return __this_address;
 
-	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
+	if (irec->rc_refcount == 0 || irec->rc_refcount > XFS_REFC_REFCOUNT_MAX)
 		return __this_address;
 
 	return NULL;
@@ -852,9 +852,9 @@ xfs_refc_merge_refcount(
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
 
@@ -897,7 +897,7 @@ xfs_refc_want_merge_center(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cleft->rc_blockcount + right->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	*ulenp = ulen;
@@ -932,7 +932,7 @@ xfs_refc_want_merge_left(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cleft->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
@@ -966,7 +966,7 @@ xfs_refc_want_merge_right(
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
diff --git a/repair/rmap.c b/repair/rmap.c
index 1312a0dde34..6fd537f533f 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1004,8 +1004,8 @@ refcount_emit(
 		agno, agbno, len, nr_rmaps);
 	rlrec.rc_startblock = agbno;
 	rlrec.rc_blockcount = len;
-	if (nr_rmaps > MAXREFCOUNT)
-		nr_rmaps = MAXREFCOUNT;
+	if (nr_rmaps > XFS_REFC_REFCOUNT_MAX)
+		nr_rmaps = XFS_REFC_REFCOUNT_MAX;
 	rlrec.rc_refcount = nr_rmaps;
 	rlrec.rc_domain = XFS_REFC_DOMAIN_SHARED;
 
diff --git a/repair/scan.c b/repair/scan.c
index 2f414898078..ba634af8bb1 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1895,7 +1895,7 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 						break;
 					}
 				}
-			} else if (nr < 2 || nr > MAXREFCOUNT) {
+			} else if (nr < 2 || nr > XFS_REFC_REFCOUNT_MAX) {
 				do_warn(
 	_("invalid reference count %u in record %u of %s btree block %u/%u\n"),
 					nr, i, name, agno, bno);

