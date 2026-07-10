Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8A71A6831
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2026 05:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783660949; cv=none; b=Q0aEdvuZ5CYJfotXP35Ae4W0Y6sbyP8wP75I8QUKtd2yU6+NlJxSjQ4T1RyYwYwzBR0KYIH8oLGqLY+raMTedtM+wN2dkByUAQBbRinn6Vm0yVswjqgPznHqdM2IFA+vx+FQ2s2YJFpTyK+/+UmyE2DtWiuGxkRheKpjmXAn28w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783660949; c=relaxed/simple;
	bh=fVp5Rh5yR3aG7eyH9g0fCdO70+2jH3J47UdhcJbtYVQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BGa64XjYTF0cAmtbFOAdIbQ80xgaxr33H3r62o/9Lwp6WX4IxrR+bnTq6E+lrrvyn6UdRM67qBRgEl9b14BoGKxgT8SphfCnb17EMdEugJCEGGfmLjopp73AwDDR01TRQe6nVQ3lnXlirdqJcpt6OSX0beY7grZz5PJhVTiESM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0hqHtOZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0hqHtOZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0F1271F000E9;
	Fri, 10 Jul 2026 05:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783660948;
	bh=kKaWrC+lNNCitTxF5l4WCO/1MX4UekZelXedrVUZV1A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=X0hqHtOZwT1RlcJXY2g1fe9PiNyVZG2wOp7m2tfVxASn23WnBzN/Xn2tJIlHTeo4N
	 0DR7SM/W3VI/7qDMfkYhNSw0R7jtLMTik4gH7/qoofM3XuTdkBhBcu5A2h/AZLMX3S
	 2QZVE18gfJ21RGGk9s2mIWY3y7XOloMuC1rVuedOPfSntR5um71B88lRr7zW+k2NVp
	 8Seh0edHWPUK87wQmbrWDcLtv0I2bhTD20pRhjn1F4rkd9p7+2f99JBkIHwHkPZN1d
	 HP9GpUFPcv25zplfNxby8DS00EjIr798Ul1QI2n+x6ba8ebBsdFojRPPHiXYzoPB/K
	 hCV+Bd2NzowsQ==
Date: Thu, 09 Jul 2026 22:22:27 -0700
Subject: [PATCH 3/8] xfs: move cow_replace_mapping to xfs_bmap_util.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <178366081056.1173468.2365303915396495079.stgit@frogsfrogsfrogs>
In-Reply-To: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs>
References: <178366080946.1173468.2461850065055339934.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Move the actual details of (partially) replacing a COW fork mapping to
xfs_bmap_util.c so that all the code doing hairy operations on subsets
of bmbt_irecs are kept together.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h      |   41 -------------------
 fs/xfs/xfs_bmap_util.h    |    4 ++
 fs/xfs/xfs_trace.h        |   41 +++++++++++++++++++
 fs/xfs/scrub/cow_repair.c |   95 +--------------------------------------------
 fs/xfs/xfs_bmap_util.c    |   89 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 136 insertions(+), 134 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d48a6db5b5f308..d5d39d82749e5c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2671,47 +2671,6 @@ TRACE_EVENT(xrep_cow_mark_file_range,
 		  __entry->blockcount)
 );
 
-TRACE_EVENT(xrep_cow_replace_mapping,
-	TP_PROTO(struct xfs_inode *ip, const struct xfs_bmbt_irec *got,
-		 const struct xfs_bmbt_irec *rep),
-	TP_ARGS(ip, got, rep),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fsblock_t, startblock)
-		__field(xfs_fileoff_t, startoff)
-		__field(xfs_filblks_t, blockcount)
-		__field(xfs_exntst_t, state)
-		__field(xfs_fileoff_t, new_startoff)
-		__field(xfs_fsblock_t, new_startblock)
-		__field(xfs_extlen_t, new_blockcount)
-		__field(xfs_exntst_t, new_state)
-	),
-	TP_fast_assign(
-		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = I_INO(ip);
-		__entry->startoff = got->br_startoff;
-		__entry->startblock = got->br_startblock;
-		__entry->blockcount = got->br_blockcount;
-		__entry->state = got->br_state;
-		__entry->new_startoff = rep->br_startoff;
-		__entry->new_startblock = rep->br_startblock;
-		__entry->new_blockcount = rep->br_blockcount;
-		__entry->new_state = rep->br_state;
-	),
-	TP_printk("dev %d:%d ino 0x%llx startoff 0x%llx startblock 0x%llx fsbcount 0x%llx state 0x%x new_startoff 0x%llx new_startblock 0x%llx new_fsbcount 0x%x new_state 0x%x",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->startoff,
-		  __entry->startblock,
-		  __entry->blockcount,
-		  __entry->state,
-		  __entry->new_startoff,
-		  __entry->new_startblock,
-		  __entry->new_blockcount,
-		  __entry->new_state)
-);
-
 TRACE_EVENT(xrep_cow_free_staging,
 	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
 		 xfs_extlen_t blockcount),
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index c477b336163040..eaaf094154b9f9 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -81,4 +81,8 @@ int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_flush_unmap_range(struct xfs_inode *ip, xfs_off_t offset,
 			      xfs_off_t len);
 
+void xfs_bmap_replace_cow_mapping(struct xfs_inode *ip,
+		struct xfs_iext_cursor *icur, struct xfs_bmbt_irec *got,
+		struct xfs_bmbt_irec *rep);
+
 #endif	/* __XFS_BMAP_UTIL_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d478693674f952..aeb89ac53bf190 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -6439,6 +6439,47 @@ TRACE_EVENT(xfs_verify_media_error,
 		  __entry->error)
 );
 
+TRACE_EVENT(xfs_bmap_replace_cow_mapping,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_bmbt_irec *got,
+		 const struct xfs_bmbt_irec *rep),
+	TP_ARGS(ip, got, rep),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsblock_t, startblock)
+		__field(xfs_fileoff_t, startoff)
+		__field(xfs_filblks_t, blockcount)
+		__field(xfs_exntst_t, state)
+		__field(xfs_fileoff_t, new_startoff)
+		__field(xfs_fsblock_t, new_startblock)
+		__field(xfs_extlen_t, new_blockcount)
+		__field(xfs_exntst_t, new_state)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = I_INO(ip);
+		__entry->startoff = got->br_startoff;
+		__entry->startblock = got->br_startblock;
+		__entry->blockcount = got->br_blockcount;
+		__entry->state = got->br_state;
+		__entry->new_startoff = rep->br_startoff;
+		__entry->new_startblock = rep->br_startblock;
+		__entry->new_blockcount = rep->br_blockcount;
+		__entry->new_state = rep->br_state;
+	),
+	TP_printk("dev %d:%d ino 0x%llx startoff 0x%llx startblock 0x%llx fsbcount 0x%llx state 0x%x new_startoff 0x%llx new_startblock 0x%llx new_fsbcount 0x%x new_state 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->startoff,
+		  __entry->startblock,
+		  __entry->blockcount,
+		  __entry->state,
+		  __entry->new_startoff,
+		  __entry->new_startblock,
+		  __entry->new_blockcount,
+		  __entry->new_state)
+);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index 8507a1185b2b45..1153e6a603fccf 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -29,6 +29,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_bmap_util.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -539,98 +540,6 @@ xrep_cow_find_mapping(
 	return -EFSCORRUPTED;
 }
 
-#define REPLACE_LEFT_SIDE	(1U << 0)
-#define REPLACE_RIGHT_SIDE	(1U << 1)
-
-/*
- * Given a CoW fork mapping @got and a replacement mapping @rep, map the space
- * described by @rep into the cow fork, pushing aside @got as necessary.  @icur
- * must point to iext tree leaf containing @got.
- */
-static inline void
-xrep_cow_replace_mapping(
-	struct xfs_inode	*ip,
-	struct xfs_iext_cursor	*icur,
-	struct xfs_bmbt_irec	*got,
-	struct xfs_bmbt_irec	*rep)
-{
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
-	xfs_fileoff_t		rep_endoff =
-			rep->br_startoff + rep->br_blockcount;
-	xfs_fileoff_t		got_endoff =
-			got->br_startoff + got->br_blockcount;
-	uint32_t		state = BMAP_COWFORK;
-
-	ASSERT(rep->br_blockcount > 0);
-	ASSERT(!isnullstartblock(got->br_startblock));
-	ASSERT(got->br_startoff <= rep->br_startoff);
-	ASSERT(got_endoff >= rep_endoff);
-
-	trace_xrep_cow_replace_mapping(ip, got, rep);
-
-	if (got->br_startoff == rep->br_startoff)
-		state |= BMAP_LEFT_FILLING;
-	if (got_endoff == rep_endoff)
-		state |= BMAP_RIGHT_FILLING;
-
-	switch (state & (BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING)) {
-	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
-		/*
-		 * Replacement matches the whole mapping, update the record.
-		 */
-		xfs_iext_update_extent(ip, state, icur, rep);
-		break;
-	case BMAP_LEFT_FILLING:
-		/*
-		 * Replace the first part of the mapping: Update the cursor
-		 * position with the new mapping, then add a record with the
-		 * tail of the old mapping.
-		 */
-		got->br_startoff = rep_endoff;
-		got->br_blockcount -= rep->br_blockcount;
-		got->br_startblock += rep->br_blockcount;
-
-		xfs_iext_update_extent(ip, state, icur, rep);
-		xfs_iext_next(ifp, icur);
-		xfs_iext_insert(ip, icur, got, state);
-		break;
-	case BMAP_RIGHT_FILLING:
-		/*
-		 * Replacing the last part of the mapping.  Shorten the current
-		 * mapping then add a record with the new mapping.
-		 */
-		got->br_blockcount -= rep->br_blockcount;
-
-		xfs_iext_update_extent(ip, state, icur, got);
-		xfs_iext_next(ifp, icur);
-		xfs_iext_insert(ip, icur, rep, state);
-		break;
-	case 0:
-		/*
-		 * Replacing the middle of the extent.  Shorten the current
-		 * mapping, add a new record with the new mapping, and add a
-		 * second new record with the tail of the old mapping.
-		 */
-		got->br_blockcount = rep->br_startoff - got->br_startoff;
-
-		struct xfs_bmbt_irec	new = {
-			.br_startoff	= rep_endoff,
-			.br_blockcount	= got_endoff - rep_endoff,
-			.br_state	= got->br_state,
-			.br_startblock	= got->br_startblock +
-						rep->br_blockcount +
-						got->br_blockcount,
-		};
-
-		xfs_iext_update_extent(ip, state, icur, got);
-		xfs_iext_next(ifp, icur);
-		xfs_iext_insert(ip, icur, rep, state);
-		xfs_iext_next(ifp, icur);
-		xfs_iext_insert(ip, icur, &new, state);
-		break;
-	}
-}
-
 /*
  * Replace the unwritten CoW staging extent backing the given file range with a
  * new space extent that isn't as problematic.
@@ -673,7 +582,7 @@ xrep_cow_replace_range(
 	 * Replace the old mapping with the new one, and commit the metadata
 	 * changes made so far.
 	 */
-	xrep_cow_replace_mapping(sc->ip, &icur, &got, &rep);
+	xfs_bmap_replace_cow_mapping(sc->ip, &icur, &got, &rep);
 
 	xfs_inode_set_cowblocks_tag(sc->ip);
 	error = xfs_defer_finish(&sc->tp);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 3b9f262f8e9128..c88b9ade7389dd 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1744,3 +1744,92 @@ xfs_swap_extents(
 	xfs_trans_cancel(tp);
 	goto out_unlock_ilock;
 }
+
+/*
+ * Given a CoW fork mapping @got and a replacement mapping @rep, map the space
+ * described by @rep into the cow fork, pushing aside @got as necessary.  @icur
+ * must point to iext tree leaf containing @got.
+ */
+void
+xfs_bmap_replace_cow_mapping(
+	struct xfs_inode	*ip,
+	struct xfs_iext_cursor	*icur,
+	struct xfs_bmbt_irec	*got,
+	struct xfs_bmbt_irec	*rep)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
+	xfs_fileoff_t		rep_endoff =
+			rep->br_startoff + rep->br_blockcount;
+	xfs_fileoff_t		got_endoff =
+			got->br_startoff + got->br_blockcount;
+	uint32_t		state = BMAP_COWFORK;
+
+	ASSERT(rep->br_blockcount > 0);
+	ASSERT(!isnullstartblock(got->br_startblock));
+	ASSERT(got->br_startoff <= rep->br_startoff);
+	ASSERT(got_endoff >= rep_endoff);
+
+	trace_xfs_bmap_replace_cow_mapping(ip, got, rep);
+
+	if (got->br_startoff == rep->br_startoff)
+		state |= BMAP_LEFT_FILLING;
+	if (got_endoff == rep_endoff)
+		state |= BMAP_RIGHT_FILLING;
+
+	switch (state & (BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING)) {
+	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
+		/*
+		 * Replacement matches the whole mapping, update the record.
+		 */
+		xfs_iext_update_extent(ip, state, icur, rep);
+		break;
+	case BMAP_LEFT_FILLING:
+		/*
+		 * Replace the first part of the mapping: Update the cursor
+		 * position with the new mapping, then add a record with the
+		 * tail of the old mapping.
+		 */
+		got->br_startoff = rep_endoff;
+		got->br_blockcount -= rep->br_blockcount;
+		got->br_startblock += rep->br_blockcount;
+
+		xfs_iext_update_extent(ip, state, icur, rep);
+		xfs_iext_next(ifp, icur);
+		xfs_iext_insert(ip, icur, got, state);
+		break;
+	case BMAP_RIGHT_FILLING:
+		/*
+		 * Replacing the last part of the mapping.  Shorten the current
+		 * mapping then add a record with the new mapping.
+		 */
+		got->br_blockcount -= rep->br_blockcount;
+
+		xfs_iext_update_extent(ip, state, icur, got);
+		xfs_iext_next(ifp, icur);
+		xfs_iext_insert(ip, icur, rep, state);
+		break;
+	case 0:
+		/*
+		 * Replacing the middle of the extent.  Shorten the current
+		 * mapping, add a new record with the new mapping, and add a
+		 * second new record with the tail of the old mapping.
+		 */
+		got->br_blockcount = rep->br_startoff - got->br_startoff;
+
+		struct xfs_bmbt_irec	new = {
+			.br_startoff	= rep_endoff,
+			.br_blockcount	= got_endoff - rep_endoff,
+			.br_state	= got->br_state,
+			.br_startblock	= got->br_startblock +
+						rep->br_blockcount +
+						got->br_blockcount,
+		};
+
+		xfs_iext_update_extent(ip, state, icur, got);
+		xfs_iext_next(ifp, icur);
+		xfs_iext_insert(ip, icur, rep, state);
+		xfs_iext_next(ifp, icur);
+		xfs_iext_insert(ip, icur, &new, state);
+		break;
+	}
+}

