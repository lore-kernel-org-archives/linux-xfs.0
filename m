Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D871CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846310; cv=none; b=S+AQsvEG/1AvyyDk80oOdrF+qCswICsLfi2Ns9nDhi+XWdwbhoeFIFBiNshkD+6YPYhVrngXN/kbXSkjV4VYZ+yyJg5J3WFEm9l5UgA15SUaaYGT1vBWsy996ApHUgbGQgjULh6ZaauSikC70PfvwX49U6vKb+3un1TuS03mbXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846310; c=relaxed/simple;
	bh=tNouS7YhaBVU1aNVTSxkOwpCPnsFB0UPejtxiSyEayM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VXSrkOhvvhq5n7ka481p2sXg+02CmVOuESVOXQSr4+a+n9pN/9+y+GLQzjBQj6EIoFDzO2QJ4d5Tm2RRFsh2DwIZf7QHl6hph/ZTWazD0iuAkBKuzKBlnn89/WuTGshvxD9G9VgOCPljCsjNZUHwlLLkkifRg/D/LEX2IQwsDl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/3KB6lJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/3KB6lJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6280C4CECF;
	Tue,  5 Nov 2024 22:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846310;
	bh=tNouS7YhaBVU1aNVTSxkOwpCPnsFB0UPejtxiSyEayM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V/3KB6lJiSWabO5umVEURXia76TMAgRntWrZnM5G8sJqSuvk+uKu8+Z/1KewqLi1e
	 I4kZthpdz5q1W+Xbmhe4xB42zeMS8hvH/NrMiYAFZx8EQAyQdT8Ut5Vv3/Yx/QSnTw
	 uvAjvRQzANfMYWkSQKMfpxez04G3fF0LgeniyIY/fqfJ7u+WeAogirA+Y1PUnZ/MS1
	 hfSOZ9WS5k5ZNpUiEaD8RGg9LaSDlfQc3xC387gg8EcPFGZtEWsbFaEjU+UeEdbH12
	 XK60UzV+zQCmqqOA1blDZT6oCg0AfUyPELA4tToTW9Saj1Va265wnFo5urN22Q8DLq
	 yfo4AbW4LtITg==
Date: Tue, 05 Nov 2024 14:38:29 -0800
Subject: [PATCH 33/34] xfs: implement busy extent tracking for rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398749.1871887.7611279330387791106.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

For rtgroups filesystems, track newly freed (rt) space through the log
until the rt EFIs have been committed to disk.  This way we ensure that
space cannot be reused until all traces of the old owner are gone.

As a fringe benefit, we now support -o discard on the realtime device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   12 ++++
 fs/xfs/libxfs/xfs_rtgroup.h  |   13 ++++
 fs/xfs/xfs_extent_busy.c     |    6 ++
 fs/xfs/xfs_rtalloc.c         |  127 ++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_trace.h           |   75 +++++++++++++++++++++++++
 5 files changed, 227 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 30220bf8c3f430..4ddfb7e395b38a 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -24,6 +24,7 @@
 #include "xfs_errortag.h"
 #include "xfs_log.h"
 #include "xfs_buf_item.h"
+#include "xfs_extent_busy.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -1120,6 +1121,7 @@ xfs_rtfree_blocks(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	xfs_extlen_t		mod;
+	int			error;
 
 	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
 
@@ -1135,8 +1137,16 @@ xfs_rtfree_blocks(
 		return -EIO;
 	}
 
-	return xfs_rtfree_extent(tp, rtg, xfs_rtb_to_rtx(mp, rtbno),
+	error = xfs_rtfree_extent(tp, rtg, xfs_rtb_to_rtx(mp, rtbno),
 			xfs_extlen_to_rtxlen(mp, rtlen));
+	if (error)
+		return error;
+
+	if (xfs_has_rtgroups(mp))
+		xfs_extent_busy_insert(tp, rtg_group(rtg),
+				xfs_rtb_to_rgbno(mp, rtbno), rtlen, 0);
+
+	return 0;
 }
 
 /* Find all the free records within a given range. */
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 1e51dc62d1143e..7e7e491ff06fa5 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -155,6 +155,19 @@ xfs_rtbno_is_group_start(
 	return (rtbno & mp->m_groups[XG_TYPE_RTG].blkmask) == 0;
 }
 
+/* Convert an rtgroups rt extent number into an rgbno. */
+static inline xfs_rgblock_t
+xfs_rtx_to_rgbno(
+	struct xfs_rtgroup	*rtg,
+	xfs_rtxnum_t		rtx)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+
+	if (likely(mp->m_rtxblklog >= 0))
+		return rtx << mp->m_rtxblklog;
+	return rtx * mp->m_sb.sb_rextsize;
+}
+
 static inline xfs_daddr_t
 xfs_rtb_to_daddr(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 457a27ab837599..ea43c9a6e54c12 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
+#include "xfs_rtgroup.h"
 
 struct xfs_extent_busy_tree {
 	spinlock_t		eb_lock;
@@ -665,9 +666,14 @@ xfs_extent_busy_wait_all(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag = NULL;
+	struct xfs_rtgroup	*rtg = NULL;
 
 	while ((pag = xfs_perag_next(mp, pag)))
 		xfs_extent_busy_wait_group(pag_group(pag));
+
+	if (xfs_has_rtgroups(mp))
+		while ((rtg = xfs_rtgroup_next(mp, rtg)))
+			xfs_extent_busy_wait_group(rtg_group(rtg));
 }
 
 /*
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8520d72afac0d9..7ecea7623a151a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -29,6 +29,7 @@
 #include "xfs_metafile.h"
 #include "xfs_rtgroup.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 /*
  * Return whether there are any free extents in the size range given
@@ -1659,6 +1660,114 @@ xfs_rtalloc_align_minmax(
 	*raminlen = newminlen;
 }
 
+/* Given a free extent, find any part of it that isn't busy, if possible. */
+STATIC bool
+xfs_rtalloc_check_busy(
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,
+	xfs_rtxlen_t		minlen_rtx,
+	xfs_rtxlen_t		maxlen_rtx,
+	xfs_rtxlen_t		len_rtx,
+	xfs_rtxlen_t		prod,
+	xfs_rtxnum_t		rtx,
+	xfs_rtxlen_t		*reslen,
+	xfs_rtxnum_t		*resrtx,
+	unsigned		*busy_gen)
+{
+	struct xfs_rtgroup	*rtg = args->rtg;
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	xfs_agblock_t		rgbno = xfs_rtx_to_rgbno(rtg, rtx);
+	xfs_rgblock_t		min_rgbno = xfs_rtx_to_rgbno(rtg, start);
+	xfs_extlen_t		minlen = xfs_rtxlen_to_extlen(mp, minlen_rtx);
+	xfs_extlen_t		len = xfs_rtxlen_to_extlen(mp, len_rtx);
+	xfs_extlen_t		diff;
+	bool			busy;
+
+	busy = xfs_extent_busy_trim(rtg_group(rtg), minlen,
+			xfs_rtxlen_to_extlen(mp, maxlen_rtx), &rgbno, &len,
+			busy_gen);
+
+	/*
+	 * If we have a largish extent that happens to start before min_rgbno,
+	 * see if we can shift it into range...
+	 */
+	if (rgbno < min_rgbno && rgbno + len > min_rgbno) {
+		diff = min_rgbno - rgbno;
+		if (len > diff) {
+			rgbno += diff;
+			len -= diff;
+		}
+	}
+
+	if (prod > 1 && len >= minlen) {
+		xfs_rgblock_t	aligned_rgbno = roundup(rgbno, prod);
+
+		diff = aligned_rgbno - rgbno;
+
+		*resrtx = xfs_rgbno_to_rtx(mp, aligned_rgbno);
+		*reslen = xfs_extlen_to_rtxlen(mp,
+				diff >= len ? 0 : len - diff);
+	} else {
+		*resrtx = xfs_rgbno_to_rtx(mp, rgbno);
+		*reslen = xfs_extlen_to_rtxlen(mp, len);
+	}
+
+	return busy;
+}
+
+/*
+ * Adjust the given free extent so that it isn't busy, or flush the log and
+ * wait for the space to become unbusy.  Only needed for rtgroups.
+ */
+STATIC int
+xfs_rtallocate_adjust_for_busy(
+	struct xfs_rtalloc_args	*args,
+	xfs_rtxnum_t		start,
+	xfs_rtxlen_t		minlen,
+	xfs_rtxlen_t		maxlen,
+	xfs_rtxlen_t		*len,
+	xfs_rtxlen_t		prod,
+	xfs_rtxnum_t		*rtx)
+{
+	xfs_rtxnum_t		resrtx;
+	xfs_rtxlen_t		reslen;
+	unsigned		busy_gen;
+	bool			busy;
+	int			error;
+
+again:
+	busy = xfs_rtalloc_check_busy(args, start, minlen, maxlen, *len, prod,
+			*rtx, &reslen, &resrtx, &busy_gen);
+	if (!busy)
+		return 0;
+
+	if (reslen < minlen || (start != 0 && resrtx != *rtx)) {
+		/*
+		 * Enough of the extent was busy that we cannot satisfy the
+		 * allocation, or this is a near allocation and the start of
+		 * the extent is busy.  Flush the log and wait for the busy
+		 * situation to resolve.
+		 */
+		trace_xfs_rtalloc_extent_busy(args->rtg, start, minlen, maxlen,
+				*len, prod, *rtx, busy_gen);
+
+		error = xfs_extent_busy_flush(args->tp, rtg_group(args->rtg),
+				busy_gen, 0);
+		if (error)
+			return error;
+
+		goto again;
+	}
+
+	/* Some of the free space wasn't busy, hand that back to the caller. */
+	trace_xfs_rtalloc_extent_busy_trim(args->rtg, *rtx, *len, resrtx,
+			reslen);
+	*len = reslen;
+	*rtx = resrtx;
+
+	return 0;
+}
+
 static int
 xfs_rtallocate_rtg(
 	struct xfs_trans	*tp,
@@ -1740,15 +1849,19 @@ xfs_rtallocate_rtg(
 	}
 
 	if (error) {
-		if (xfs_has_rtgroups(args.mp)) {
-			xfs_rtgroup_unlock(args.rtg, XFS_RTGLOCK_BITMAP);
-			*rtlocked = false;
-		}
+		if (xfs_has_rtgroups(args.mp))
+			goto out_unlock;
 		goto out_release;
 	}
 
-	if (xfs_has_rtgroups(args.mp))
+	if (xfs_has_rtgroups(args.mp)) {
+		error = xfs_rtallocate_adjust_for_busy(&args, start, minlen,
+				maxlen, &len, prod, &rtx);
+		if (error)
+			goto out_unlock;
+
 		xfs_rtgroup_trans_join(tp, args.rtg, XFS_RTGLOCK_BITMAP);
+	}
 
 	error = xfs_rtallocate_range(&args, rtx, len);
 	if (error)
@@ -1764,6 +1877,10 @@ xfs_rtallocate_rtg(
 	xfs_rtgroup_rele(args.rtg);
 	xfs_rtbuf_cache_relse(&args);
 	return error;
+out_unlock:
+	xfs_rtgroup_unlock(args.rtg, XFS_RTGLOCK_BITMAP);
+	*rtlocked = false;
+	goto out_release;
 }
 
 static int
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5f7b461286ab67..d81b5b69a6f3b8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -97,6 +97,7 @@ struct xfs_extent_free_item;
 struct xfs_rmap_intent;
 struct xfs_refcount_intent;
 struct xfs_metadir_update;
+struct xfs_rtgroup;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -1744,6 +1745,80 @@ TRACE_EVENT(xfs_extent_busy_trim,
 		  __entry->tlen)
 );
 
+#ifdef CONFIG_XFS_RT
+TRACE_EVENT(xfs_rtalloc_extent_busy,
+	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rtxnum_t start,
+		 xfs_rtxlen_t minlen, xfs_rtxlen_t maxlen,
+		 xfs_rtxlen_t len, xfs_rtxlen_t prod, xfs_rtxnum_t rtx,
+		 unsigned busy_gen),
+	TP_ARGS(rtg, start, minlen, maxlen, len, prod, rtx, busy_gen),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(xfs_rtxnum_t, start)
+		__field(xfs_rtxlen_t, minlen)
+		__field(xfs_rtxlen_t, maxlen)
+		__field(xfs_rtxlen_t, mod)
+		__field(xfs_rtxlen_t, prod)
+		__field(xfs_rtxlen_t, len)
+		__field(xfs_rtxnum_t, rtx)
+		__field(unsigned, busy_gen)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg_mount(rtg)->m_super->s_dev;
+		__entry->rgno = rtg_rgno(rtg);
+		__entry->start = start;
+		__entry->minlen = minlen;
+		__entry->maxlen = maxlen;
+		__entry->prod = prod;
+		__entry->len = len;
+		__entry->rtx = rtx;
+		__entry->busy_gen = busy_gen;
+	),
+	TP_printk("dev %d:%d rgno 0x%x startrtx 0x%llx minlen %u maxlen %u "
+		  "prod %u len %u rtx 0%llx busy_gen 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno,
+		  __entry->start,
+		  __entry->minlen,
+		  __entry->maxlen,
+		  __entry->prod,
+		  __entry->len,
+		  __entry->rtx,
+		  __entry->busy_gen)
+)
+
+TRACE_EVENT(xfs_rtalloc_extent_busy_trim,
+	TP_PROTO(struct xfs_rtgroup *rtg, xfs_rtxnum_t old_rtx,
+		 xfs_rtxlen_t old_len, xfs_rtxnum_t new_rtx,
+		 xfs_rtxlen_t new_len),
+	TP_ARGS(rtg, old_rtx, old_len, new_rtx, new_len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(xfs_rtxnum_t, old_rtx)
+		__field(xfs_rtxnum_t, new_rtx)
+		__field(xfs_rtxlen_t, old_len)
+		__field(xfs_rtxlen_t, new_len)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg_mount(rtg)->m_super->s_dev;
+		__entry->rgno = rtg_rgno(rtg);
+		__entry->old_rtx = old_rtx;
+		__entry->old_len = old_len;
+		__entry->new_rtx = new_rtx;
+		__entry->new_len = new_len;
+	),
+	TP_printk("dev %d:%d rgno 0x%x rtx 0x%llx rtxcount 0x%x -> rtx 0x%llx rtxcount 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno,
+		  __entry->old_rtx,
+		  __entry->old_len,
+		  __entry->new_rtx,
+		  __entry->new_len)
+);
+#endif /* CONFIG_XFS_RT */
+
 DECLARE_EVENT_CLASS(xfs_agf_class,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_agf *agf, int flags,
 		 unsigned long caller_ip),

