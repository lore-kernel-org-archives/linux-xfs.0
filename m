Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB9513FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688613; cv=none; b=syaudtGFNw4dHgAbWc8Y85zo1gv0iiWzLJo7g8RLP0TYZ60ScXKpdcpRs/wo/FfP/WsZXWvpZmpHIQmCpN+BBOeuGiyavTKTWNPToLE8xqf6WnhbFBbSE7ly+ra580IRxx32mxnIehVRmyxKvc4tkAxBHSDNd3QGNkmQ2O79MOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688613; c=relaxed/simple;
	bh=hRBhGZXBw6ENH358xigtdzny6luPA/hZ87gprRKUYUU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tifoSDgl5X8a1qpZG854kZ7xD751oYM+6LUA1dLMs+5ePuR78DC8mPLAB7thuUx5Mb40p9beo1yPB+3OMoQ5jAU7Gx7S4BawmNp7YBhQM2SUNGD5Ev74365Kz6dci93GVfpiAJ4A/JsKoM+1p+YxECUGK/DQE/AVHgmzZSEdEm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYpUB0Ko; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYpUB0Ko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10676C4CED2;
	Tue, 31 Dec 2024 23:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688613;
	bh=hRBhGZXBw6ENH358xigtdzny6luPA/hZ87gprRKUYUU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LYpUB0KoWJC7o90gnxaWHKXSsXcV1oHU7MZNloAOdxZotH9hregMY+LBZH9dHMT50
	 wp79bdzQmslcz58brvLKVquYrDGcp9IzhbXvr59zNfLDkGY5n70UjeY5cGI11v3lnw
	 1owGpWodJuHdFsqcl3QvyTjzAQ7itrKaWvNB7oo4mikrKDI1fFHZJ6z40sDLQyjIqi
	 z1UQjW3QkbQPwcYw8HSUvjAE439rqarwb02FBm2xrastVpSAu1h3FA0Z3GXDASdXPT
	 u+HyFhAL6ZMdhkjiB2veVRfmjA5phnLH9WpX+gKTfKd2le0iEIPjDGUDGr5MQY/V6g
	 GVINTW7bV4G9g==
Date: Tue, 31 Dec 2024 15:43:32 -0800
Subject: [PATCH 2/5] xfs: create a noalloc mode for allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568777039.2709441.5588361008382501280.stgit@frogsfrogsfrogs>
In-Reply-To: <173568777001.2709441.13781927144429990672.stgit@frogsfrogsfrogs>
References: <173568777001.2709441.13781927144429990672.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a new noalloc state for the per-AG structure that will disable
block allocation in this AG.  We accomplish this by subtracting from
fdblocks all the free blocks in this AG, hiding those blocks from the
allocator, and preventing freed blocks from updating fdblocks until
we're ready to lift noalloc mode.

Note that we reduce the free block count of the filesystem so that we
can prevent transactions from entering the allocator looking for "free"
space that we've turned off incore.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/xfs_trace.h  |    2 ++
 libxfs/xfs_ag.c      |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ag.h      |    8 +++++++
 libxfs/xfs_ag_resv.c |   28 +++++++++++++++++++++--
 4 files changed, 95 insertions(+), 3 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 30166c11dd597b..7778366c5e3319 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -13,6 +13,8 @@
 #define trace_xfbtree_trans_cancel_buf(...)	((void) 0)
 #define trace_xfbtree_trans_commit_buf(...)	((void) 0)
 
+#define trace_xfs_ag_clear_noalloc(a)		((void) 0)
+#define trace_xfs_ag_set_noalloc(a)		((void) 0)
 #define trace_xfs_agfl_reset(a,b,c,d)		((void) 0)
 #define trace_xfs_agfl_free_defer(...)		((void) 0)
 #define trace_xfs_alloc_cur_check(...)		((void) 0)
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 095b581a116180..462d16347cadb9 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -974,3 +974,63 @@ xfs_ag_get_geometry(
 	xfs_buf_relse(agi_bp);
 	return error;
 }
+
+/* How many blocks does this AG contribute to fdblocks? */
+xfs_extlen_t
+xfs_ag_fdblocks(
+	struct xfs_perag		*pag)
+{
+	xfs_extlen_t			ret;
+
+	ASSERT(xfs_perag_initialised_agf(pag));
+
+	ret = pag->pagf_freeblks + pag->pagf_flcount + pag->pagf_btreeblks;
+	ret -= pag->pag_meta_resv.ar_reserved;
+	ret -= pag->pag_rmapbt_resv.ar_orig_reserved;
+	return ret;
+}
+
+/*
+ * Hide all the free space in this AG.  Caller must hold both the AGI and the
+ * AGF buffers or have otherwise prevented concurrent access.
+ */
+int
+xfs_ag_set_noalloc(
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = pag_mount(pag);
+	int			error;
+
+	ASSERT(xfs_perag_initialised_agf(pag));
+	ASSERT(xfs_perag_initialised_agi(pag));
+
+	if (xfs_perag_prohibits_alloc(pag))
+		return 0;
+
+	error = xfs_dec_fdblocks(mp, xfs_ag_fdblocks(pag), false);
+	if (error)
+		return error;
+
+	trace_xfs_ag_set_noalloc(pag);
+	set_bit(XFS_AGSTATE_NOALLOC, &pag->pag_opstate);
+	return 0;
+}
+
+/*
+ * Unhide all the free space in this AG.  Caller must hold both the AGI and
+ * the AGF buffers or have otherwise prevented concurrent access.
+ */
+void
+xfs_ag_clear_noalloc(
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = pag_mount(pag);
+
+	if (!xfs_perag_prohibits_alloc(pag))
+		return;
+
+	xfs_add_fdblocks(mp, xfs_ag_fdblocks(pag));
+
+	trace_xfs_ag_clear_noalloc(pag);
+	clear_bit(XFS_AGSTATE_NOALLOC, &pag->pag_opstate);
+}
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 1f24cfa2732172..e8fae59206d929 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -120,6 +120,7 @@ static inline xfs_agnumber_t pag_agno(const struct xfs_perag *pag)
 #define XFS_AGSTATE_PREFERS_METADATA	2
 #define XFS_AGSTATE_ALLOWS_INODES	3
 #define XFS_AGSTATE_AGFL_NEEDS_RESET	4
+#define XFS_AGSTATE_NOALLOC		5
 
 #define __XFS_AG_OPSTATE(name, NAME) \
 static inline bool xfs_perag_ ## name (struct xfs_perag *pag) \
@@ -132,6 +133,7 @@ __XFS_AG_OPSTATE(initialised_agi, AGI_INIT)
 __XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
 __XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
 __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
+__XFS_AG_OPSTATE(prohibits_alloc, NOALLOC)
 
 int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t orig_agcount,
 		xfs_agnumber_t new_agcount, xfs_rfsblock_t dcount,
@@ -164,6 +166,7 @@ xfs_perag_put(
 	xfs_group_put(pag_group(pag));
 }
 
+
 /* Active AG references */
 static inline struct xfs_perag *
 xfs_perag_grab(
@@ -208,6 +211,11 @@ xfs_perag_next(
 	return xfs_perag_next_from(mp, pag, 0);
 }
 
+/* Enable or disable allocation from an AG */
+xfs_extlen_t xfs_ag_fdblocks(struct xfs_perag *pag);
+int xfs_ag_set_noalloc(struct xfs_perag *pag);
+void xfs_ag_clear_noalloc(struct xfs_perag *pag);
+
 /*
  * Per-ag geometry infomation and validation
  */
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 83cac20331fd34..e811a6807e12ea 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -20,6 +20,7 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
+#include "xfs_ag.h"
 
 /*
  * Per-AG Block Reservations
@@ -73,6 +74,13 @@ xfs_ag_resv_critical(
 	xfs_extlen_t			avail;
 	xfs_extlen_t			orig;
 
+	/*
+	 * Pretend we're critically low on reservations in this AG to scare
+	 * everyone else away.
+	 */
+	if (xfs_perag_prohibits_alloc(pag))
+		return true;
+
 	switch (type) {
 	case XFS_AG_RESV_METADATA:
 		avail = pag->pagf_freeblks - pag->pag_rmapbt_resv.ar_reserved;
@@ -115,7 +123,12 @@ xfs_ag_resv_needed(
 		break;
 	case XFS_AG_RESV_METAFILE:
 	case XFS_AG_RESV_NONE:
-		/* empty */
+		/*
+		 * In noalloc mode, we pretend that all the free blocks in this
+		 * AG have been allocated.  Make this AG look full.
+		 */
+		if (xfs_perag_prohibits_alloc(pag))
+			len += xfs_ag_fdblocks(pag);
 		break;
 	default:
 		ASSERT(0);
@@ -343,6 +356,8 @@ xfs_ag_resv_alloc_extent(
 	xfs_extlen_t			len;
 	uint				field;
 
+	ASSERT(type != XFS_AG_RESV_NONE || !xfs_perag_prohibits_alloc(pag));
+
 	trace_xfs_ag_resv_alloc_extent(pag, type, args->len);
 
 	switch (type) {
@@ -400,7 +415,14 @@ xfs_ag_resv_free_extent(
 		ASSERT(0);
 		fallthrough;
 	case XFS_AG_RESV_NONE:
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
+		/*
+		 * Normally we put freed blocks back into fdblocks.  In noalloc
+		 * mode, however, we pretend that there are no fdblocks in the
+		 * AG, so don't put them back.
+		 */
+		if (!xfs_perag_prohibits_alloc(pag))
+			xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS,
+					(int64_t)len);
 		fallthrough;
 	case XFS_AG_RESV_IGNORE:
 		return;
@@ -413,6 +435,6 @@ xfs_ag_resv_free_extent(
 	/* Freeing into the reserved pool only requires on-disk update... */
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FDBLOCKS, len);
 	/* ...but freeing beyond that requires in-core and on-disk update. */
-	if (len > leftover)
+	if (len > leftover && !xfs_perag_prohibits_alloc(pag))
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, len - leftover);
 }

