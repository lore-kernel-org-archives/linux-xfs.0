Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1458F5E
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609048; cv=none; b=sgrBXyWDqfzTXpGAnYJwhn8rXC01g2P9CiDp5sNq1ULcvKnWhi/Qxa6rwiO8vZoTGlibaJpo6z9O6RppvI3/HxaPefOsYpqcOU2enSHih/UiaBwc3Eik4kjhZ/hW2eI/EO3qNCKIU7aQCunt9cGuwZZDRhrF++cFLbxoeVTqHSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609048; c=relaxed/simple;
	bh=JFMWTrFDGNjoDi3Fp+Cl95H8CzlzP2NYnijS57uq9jA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mtYSBOiA2jcO2SvHR/dOFp8mPYnJ5wPvKoDGPEpraaK/IgBtBT5widQgVgzhiUebh6GOTWM9aDjmCPAGpx3TIwEcUTKnCWw7sFcV7AY/Xdg/liko3J+d4PGVzrD/j6bUsN+gMy81r/gwlTFzfoqfxFWmZKHDSxwDZqOgF7TuiiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5UxDeMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5UxDeMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB11C4CEC5;
	Fri, 11 Oct 2024 01:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609048;
	bh=JFMWTrFDGNjoDi3Fp+Cl95H8CzlzP2NYnijS57uq9jA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L5UxDeMZTd7YrvuIAF1VsDkHpVbldBAhX6AvRwPrcZRALFsMXp5cnA3pvqKZaIcmt
	 D6SULtXiwtcGWSQCTpcUsoPEApcK1Ux9KjYFTKxbCvb+Dv6NaoSMacJhb0kTdiwK1R
	 cJQFVrXjTqbtfb5Ui4dztP7Bl9qwNHM7hRNzV6pQgt64asdPFogqxxg8sIudsE9NJi
	 0GvmGwrcAywTk4LVai5q/ljRvr7Hlj6kzYmLIzJl9rflQvOtg5LzJTgQ5bJKJvY6rI
	 7RyP1vUHgIQL5YNhyMlvjl66TmawcWfvwkebDB7N7EI7P4VwFaE6EImKVVoGiwnReB
	 tT4Ey9MK/M+rA==
Date: Thu, 10 Oct 2024 18:10:47 -0700
Subject: [PATCH 35/36] xfs: implement busy extent tracking for rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644848.4178701.6141796872423816632.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

For rtgroups filesystems, track newly freed (rt) space through the log
until the rt EFIs have been committed to disk.  This way we ensure that
space cannot be reused until all traces of the old owner are gone.

As a fringe benefit, we now support -o discard on the realtime device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   12 ++++
 fs/xfs/libxfs/xfs_rtgroup.h  |   13 ++++
 fs/xfs/xfs_extent_busy.c     |    6 ++
 fs/xfs/xfs_rtalloc.c         |  127 ++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_trace.h           |   75 +++++++++++++++++++++++++
 5 files changed, 227 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 30220bf8c3f430..3623e55fd6860b 100644
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
+		xfs_extent_busy_insert(tp, &rtg->rtg_group,
+				xfs_rtb_to_rgbno(mp, rtbno), rtlen, 0);
+
+	return 0;
 }
 
 /* Find all the free records within a given range. */
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 9b7866607528ea..320ae3d59290e2 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -150,6 +150,19 @@ xfs_rtbno_is_group_start(
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
index d63208a87f1d7e..1f5e1b860d15c4 100644
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
 		xfs_extent_busy_wait_group(&pag->pag_group);
+
+	if (xfs_has_rtgroups(mp))
+		while ((rtg = xfs_rtgroup_next(mp, rtg)))
+			xfs_extent_busy_wait_group(&rtg->rtg_group);
 }
 
 /*
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8f56d5fbe7413a..0575b9553f40a9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -29,6 +29,7 @@
 #include "xfs_metafile.h"
 #include "xfs_rtgroup.h"
 #include "xfs_error.h"
+#include "xfs_trace.h"
 
 /*
  * Return whether there are any free extents in the size range given
@@ -1657,6 +1658,114 @@ xfs_rtalloc_align_minmax(
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
+	busy = xfs_extent_busy_trim(&rtg->rtg_group, minlen,
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
+		error = xfs_extent_busy_flush(args->tp, &args->rtg->rtg_group,
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
@@ -1738,15 +1847,19 @@ xfs_rtallocate_rtg(
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
@@ -1762,6 +1875,10 @@ xfs_rtallocate_rtg(
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
index 64af1470b838f0..7b1ad2e0572645 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -97,6 +97,7 @@ struct xfs_extent_free_item;
 struct xfs_rmap_intent;
 struct xfs_refcount_intent;
 struct xfs_metadir_update;
+struct xfs_rtgroup;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -1749,6 +1750,80 @@ TRACE_EVENT(xfs_extent_busy_trim,
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

