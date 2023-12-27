Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FAD644
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BL8vClBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA809C433C8;
	Mon,  1 Jan 2024 00:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069521;
	bh=jihn1geNjr6lGaZfG3pTeajVaUq/oPfdL1IVICbsbTY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BL8vClBCEXOTzjOVD2mg7zRGIig+1RYetp/u53PC9IykUIcdJCEYMdOsIHJRcLh2q
	 K5aZJjg3om1G/Ppbhh9T85cR9+/Kqj43O0SYIwJduINM5gtm20Dvgsa/zERCQoYHxK
	 ClRgq08i9R1CTzolWyJ7ctTpSI1Zci/IyQKAND14qkOk9VTjlC94BGRe27BM9Zy8dn
	 KcoIfh2dM0N47LjWUWCn4VjbT/EMTL4pMkEH4VIqFvcBFS8svjFEm8DJyTCQujVFlq
	 eXTXlFOaJgD2bLt3jaeNx7uIoMqCBJJIQLkCGrbGoBkT5JR/2F2b8oLP9li/1/jE7g
	 zFx1/kS9mMPZg==
Date: Sun, 31 Dec 2023 16:38:40 +9900
Subject: [PATCH 2/5] xfs: create a noalloc mode for allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405019590.1820520.6157557397044115302.stgit@frogsfrogsfrogs>
In-Reply-To: <170405019560.1820520.7145960948523376788.stgit@frogsfrogsfrogs>
References: <170405019560.1820520.7145960948523376788.stgit@frogsfrogsfrogs>
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

Create a new noalloc state for the per-AG structure that will disable
block allocation in this AG.  We accomplish this by subtracting from
fdblocks all the free blocks in this AG, hiding those blocks from the
allocator, and preventing freed blocks from updating fdblocks until
we're ready to lift noalloc mode.

Note that we reduce the free block count of the filesystem so that we
can prevent transactions from entering the allocator looking for "free"
space that we've turned off incore.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h  |    2 ++
 libxfs/xfs_ag.c      |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ag.h      |    8 +++++++
 libxfs/xfs_ag_resv.c |   28 +++++++++++++++++++++--
 4 files changed, 95 insertions(+), 3 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index a6ae0ca13b6..c8368227705 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -13,6 +13,8 @@
 #define trace_xfbtree_trans_cancel_buf(...)	((void) 0)
 #define trace_xfbtree_trans_commit_buf(...)	((void) 0)
 
+#define trace_xfs_ag_clear_noalloc(a)		((void) 0)
+#define trace_xfs_ag_set_noalloc(a)		((void) 0)
 #define trace_xfs_agfl_free_defer(...)		((void) 0)
 #define trace_xfs_agfl_reset(a,b,c,d)		((void) 0)
 #define trace_xfs_alloc_cur_check(a,b,c,d,e,f)	((void) 0)
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index ac6b0090825..c639e8e07d7 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -1117,3 +1117,63 @@ xfs_ag_get_geometry(
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
+	struct xfs_mount	*mp = pag->pag_mount;
+	int			error;
+
+	ASSERT(xfs_perag_initialised_agf(pag));
+	ASSERT(xfs_perag_initialised_agi(pag));
+
+	if (xfs_perag_prohibits_alloc(pag))
+		return 0;
+
+	error = xfs_mod_fdblocks(mp, -(int64_t)xfs_ag_fdblocks(pag), false);
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
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	if (!xfs_perag_prohibits_alloc(pag))
+		return;
+
+	xfs_mod_fdblocks(mp, xfs_ag_fdblocks(pag), false);
+
+	trace_xfs_ag_clear_noalloc(pag);
+	clear_bit(XFS_AGSTATE_NOALLOC, &pag->pag_opstate);
+}
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 79017fcd3df..c21cc30ebc7 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -131,6 +131,7 @@ struct xfs_perag {
 #define XFS_AGSTATE_PREFERS_METADATA	2
 #define XFS_AGSTATE_ALLOWS_INODES	3
 #define XFS_AGSTATE_AGFL_NEEDS_RESET	4
+#define XFS_AGSTATE_NOALLOC		5
 
 #define __XFS_AG_OPSTATE(name, NAME) \
 static inline bool xfs_perag_ ## name (struct xfs_perag *pag) \
@@ -143,6 +144,7 @@ __XFS_AG_OPSTATE(initialised_agi, AGI_INIT)
 __XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
 __XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
 __XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
+__XFS_AG_OPSTATE(prohibits_alloc, NOALLOC)
 
 int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
 			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
@@ -156,12 +158,18 @@ struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
 struct xfs_perag *xfs_perag_hold(struct xfs_perag *pag);
 void xfs_perag_put(struct xfs_perag *pag);
 
+
 /* Active AG references */
 struct xfs_perag *xfs_perag_grab(struct xfs_mount *, xfs_agnumber_t);
 struct xfs_perag *xfs_perag_grab_tag(struct xfs_mount *, xfs_agnumber_t,
 				   int tag);
 void xfs_perag_rele(struct xfs_perag *pag);
 
+/* Enable or disable allocation from an AG */
+xfs_extlen_t xfs_ag_fdblocks(struct xfs_perag *pag);
+int xfs_ag_set_noalloc(struct xfs_perag *pag);
+void xfs_ag_clear_noalloc(struct xfs_perag *pag);
+
 /*
  * Per-ag geometry infomation and validation
  */
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 5963ff5602b..ddb679bc4ae 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -20,6 +20,7 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
+#include "xfs_ag.h"
 
 /*
  * Per-AG Block Reservations
@@ -72,6 +73,13 @@ xfs_ag_resv_critical(
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
@@ -114,7 +122,12 @@ xfs_ag_resv_needed(
 		break;
 	case XFS_AG_RESV_IMETA:
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

