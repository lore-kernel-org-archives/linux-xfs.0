Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4EA14373D
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925133; cv=none; b=cyoQSYHaBgREDe5MzygrAU+3blW7in4mY/u5ehSmTb8l699BKmfFBHQhRmvGvNZ+bOkEGkCVQO1+BXpMILXT2DE0kifAs4rUYIfr+Tsw66JgfH0Pa0GXRLL4he/xcGMqdnUOj7HHO5IVZ9PlQagHcdTd249t+XH70eLhKpDPXek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925133; c=relaxed/simple;
	bh=XvzU6phsDsn2Kl5+LsGzIeVG/HnxBirsxGhUCMKYLyk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NWXTfFTmNYg0nxxzuvvE+m8+pQ6rUOh5BWSfZ9T44zkhFxWatM22tUcMXa6drp1f1Vul+ujKjeOrXSlNgg0Q+7/4eQP4NsADEYPsgqQSTebW+ZxR4WB32r3fvHpmZlmJ/r4q17LdrHrXn0Mv53nRcXXmdeuF9c1DQr527GkQP+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oaj0OFkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oaj0OFkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826C8C2BD10;
	Thu, 20 Jun 2024 23:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925133;
	bh=XvzU6phsDsn2Kl5+LsGzIeVG/HnxBirsxGhUCMKYLyk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oaj0OFkEVVgrK8JJXuiWzLaWOiGa0c64MW4q6Wk7QLQ6nqOesBfP3jVtO1bTtErFD
	 Sv3lIGH0ASfYP0lhFnypsCJFqyQZXXH0byw/tOus7NRJj+5Mm52B29c2j2Mn+Q3yR0
	 7UsWCA8CI3bscR1rQIFrG/Du4U9PIV02m0pk6jKRDjyAW9QIYOqxYpiD7xeDmbMnYf
	 v6IRl9ZIHf/fvtEqTXGuaLb+hjguN3m3q7Rpe+kwMDEG5yYE6yZBCXR0ksOaUrBnXa
	 e5/CC/vHz+ig+M8P0uSol/CKzY+piuzIyVUhJthDoV4BIwDfgOgzwjNXCSy9U6lbmS
	 n8ASSN7MQAD2g==
Date: Thu, 20 Jun 2024 16:12:13 -0700
Subject: [PATCH 1/1] xfs: enable FITRIM on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Konst Mayer <cdlscpmv@gmail.com>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892420308.3185132.6252829732531290655.stgit@frogsfrogsfrogs>
In-Reply-To: <171892420288.3185132.3927361357396911761.stgit@frogsfrogsfrogs>
References: <171892420288.3185132.3927361357396911761.stgit@frogsfrogsfrogs>
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

Implement FITRIM for the realtime device by pretending that it's
"space" immediately after the data device.  We have to hold the
rtbitmap ILOCK while the discard operations are ongoing because there's
no busy extent tracking to prevent reallocations.

Cc: Konst Mayer <cdlscpmv@gmail.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c |  252 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h   |   29 ++++++
 2 files changed, 274 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 25fe3b932b5a6..3ad5b0505848b 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -20,6 +20,7 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Notes on an efficient, low latency fstrim algorithm
@@ -383,6 +384,217 @@ xfs_trim_extents(
 
 }
 
+#ifdef CONFIG_XFS_RT
+struct xfs_trim_rtdev {
+	/* list of rt extents to free */
+	struct list_head	extent_list;
+
+	/* pointer to count of blocks trimmed */
+	uint64_t		*blocks_trimmed;
+
+	/* minimum length that caller allows us to trim */
+	xfs_rtblock_t		minlen_fsb;
+
+	/* restart point for the rtbitmap walk */
+	xfs_rtxnum_t		restart_rtx;
+
+	/* stopping point for the current rtbitmap walk */
+	xfs_rtxnum_t		stop_rtx;
+};
+
+struct xfs_rtx_busy {
+	struct list_head	list;
+	xfs_rtblock_t		bno;
+	xfs_rtblock_t		length;
+};
+
+static void
+xfs_discard_free_rtdev_extents(
+	struct xfs_trim_rtdev	*tr)
+{
+	struct xfs_rtx_busy	*busyp, *n;
+
+	list_for_each_entry_safe(busyp, n, &tr->extent_list, list) {
+		list_del_init(&busyp->list);
+		kfree(busyp);
+	}
+}
+
+/*
+ * Walk the discard list and issue discards on all the busy extents in the
+ * list. We plug and chain the bios so that we only need a single completion
+ * call to clear all the busy extents once the discards are complete.
+ */
+static int
+xfs_discard_rtdev_extents(
+	struct xfs_mount	*mp,
+	struct xfs_trim_rtdev	*tr)
+{
+	struct block_device	*bdev = mp->m_rtdev_targp->bt_bdev;
+	struct xfs_rtx_busy	*busyp;
+	struct bio		*bio = NULL;
+	struct blk_plug		plug;
+	xfs_rtblock_t		start = NULLRTBLOCK, length = 0;
+	int			error = 0;
+
+	blk_start_plug(&plug);
+	list_for_each_entry(busyp, &tr->extent_list, list) {
+		if (start == NULLRTBLOCK)
+			start = busyp->bno;
+		length += busyp->length;
+
+		trace_xfs_discard_rtextent(mp, busyp->bno, busyp->length);
+
+		error = __blkdev_issue_discard(bdev,
+				XFS_FSB_TO_BB(mp, busyp->bno),
+				XFS_FSB_TO_BB(mp, busyp->length),
+				GFP_NOFS, &bio);
+		if (error)
+			break;
+	}
+	xfs_discard_free_rtdev_extents(tr);
+
+	if (bio) {
+		error = submit_bio_wait(bio);
+		if (error == -EOPNOTSUPP)
+			error = 0;
+		if (error)
+			xfs_info(mp,
+	 "discard failed for rtextent [0x%llx,%llu], error %d",
+				 (unsigned long long)start,
+				 (unsigned long long)length,
+				 error);
+		bio_put(bio);
+	}
+	blk_finish_plug(&plug);
+
+	return error;
+}
+
+static int
+xfs_trim_gather_rtextent(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv)
+{
+	struct xfs_trim_rtdev		*tr = priv;
+	struct xfs_rtx_busy		*busyp;
+	xfs_rtblock_t			rbno, rlen;
+
+	if (rec->ar_startext > tr->stop_rtx) {
+		/*
+		 * If we've scanned a large number of rtbitmap blocks, update
+		 * the cursor to point at this extent so we restart the next
+		 * batch from this extent.
+		 */
+		tr->restart_rtx = rec->ar_startext;
+		return -ECANCELED;
+	}
+
+	rbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
+	rlen = xfs_rtx_to_rtb(mp, rec->ar_extcount);
+
+	/* Ignore too small. */
+	if (rlen < tr->minlen_fsb) {
+		trace_xfs_discard_rttoosmall(mp, rbno, rlen);
+		return 0;
+	}
+
+	busyp = kzalloc(sizeof(struct xfs_rtx_busy), GFP_KERNEL);
+	if (!busyp)
+		return -ENOMEM;
+
+	busyp->bno = rbno;
+	busyp->length = rlen;
+	INIT_LIST_HEAD(&busyp->list);
+	list_add_tail(&busyp->list, &tr->extent_list);
+	*tr->blocks_trimmed += rlen;
+
+	tr->restart_rtx = rec->ar_startext + rec->ar_extcount;
+	return 0;
+}
+
+static int
+xfs_trim_rtdev_extents(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		start,
+	xfs_daddr_t		end,
+	xfs_daddr_t		minlen,
+	uint64_t		*blocks_trimmed)
+{
+	struct xfs_rtalloc_rec	low = { };
+	struct xfs_rtalloc_rec	high = { };
+	struct xfs_trim_rtdev	tr = {
+		.blocks_trimmed	= blocks_trimmed,
+		.minlen_fsb	= XFS_BB_TO_FSB(mp, minlen),
+	};
+	struct xfs_trans	*tp;
+	xfs_daddr_t		rtdev_daddr;
+	int			error;
+
+	INIT_LIST_HEAD(&tr.extent_list);
+
+	/* Shift the start and end downwards to match the rt device. */
+	rtdev_daddr = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	if (start > rtdev_daddr)
+		start -= rtdev_daddr;
+	else
+		start = 0;
+
+	if (end <= rtdev_daddr)
+		return 0;
+	end -= rtdev_daddr;
+
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks) - 1)
+		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks) - 1;
+
+	/* Convert the rt blocks to rt extents */
+	low.ar_startext = xfs_rtb_to_rtxup(mp, XFS_BB_TO_FSB(mp, start));
+	high.ar_startext = xfs_rtb_to_rtx(mp, XFS_BB_TO_FSBT(mp, end));
+
+	/*
+	 * Walk the free ranges between low and high.  The query_range function
+	 * trims the extents returned.
+	 */
+	do {
+		tr.stop_rtx = low.ar_startext + (mp->m_sb.sb_blocksize * NBBY);
+		xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
+		error = xfs_rtalloc_query_range(mp, tp, &low, &high,
+				xfs_trim_gather_rtextent, &tr);
+
+		if (error == -ECANCELED)
+			error = 0;
+		if (error) {
+			xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
+			xfs_discard_free_rtdev_extents(&tr);
+			break;
+		}
+
+		if (list_empty(&tr.extent_list)) {
+			xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
+			break;
+		}
+
+		error = xfs_discard_rtdev_extents(mp, &tr);
+		xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
+		if (error)
+			break;
+
+		low.ar_startext = tr.restart_rtx;
+	} while (!xfs_trim_should_stop() && low.ar_startext <= high.ar_startext);
+
+	xfs_trans_cancel(tp);
+	return error;
+}
+#else
+# define xfs_trim_rtdev_extents(m,s,e,n,b)	(-EOPNOTSUPP)
+#endif /* CONFIG_XFS_RT */
+
 /*
  * trim a range of the filesystem.
  *
@@ -391,6 +603,9 @@ xfs_trim_extents(
  * addressing. FSB addressing is sparse (AGNO|AGBNO), while the incoming format
  * is a linear address range. Hence we need to use DADDR based conversions and
  * comparisons for determining the correct offset and regions to trim.
+ *
+ * The realtime device is mapped into the FITRIM "address space" immediately
+ * after the data device.
  */
 int
 xfs_ioc_trim(
@@ -400,19 +615,28 @@ xfs_ioc_trim(
 	struct xfs_perag	*pag;
 	unsigned int		granularity =
 		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
+	struct block_device	*rt_bdev = NULL;
 	struct fstrim_range	range;
-	xfs_daddr_t		start, end;
+	xfs_daddr_t		start, end, ddev_end;
 	xfs_extlen_t		minlen;
 	xfs_agnumber_t		start_agno, end_agno;
 	xfs_agblock_t		start_agbno, end_agbno;
+	xfs_rfsblock_t		max_blocks;
 	uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (!bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev))
+	if (mp->m_rtdev_targp)
+		rt_bdev = mp->m_rtdev_targp->bt_bdev;
+	if (!bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev) &&
+	    (!rt_bdev || !bdev_max_discard_sectors(rt_bdev)))
 		return -EOPNOTSUPP;
 
+	if (rt_bdev)
+		granularity = max(granularity,
+				  bdev_discard_granularity(rt_bdev));
+
 	/*
 	 * We haven't recovered the log, so we cannot use our bnobt-guided
 	 * storage zapping commands.
@@ -433,19 +657,25 @@ xfs_ioc_trim(
 	 * used by the fstrim application.  In the end it really doesn't
 	 * matter as trimming blocks is an advisory interface.
 	 */
-	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
+	max_blocks = mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks;
+	if (range.start >= XFS_FSB_TO_B(mp, max_blocks) ||
 	    range.minlen > XFS_FSB_TO_B(mp, mp->m_ag_max_usable) ||
 	    range.len < mp->m_sb.sb_blocksize)
 		return -EINVAL;
 
 	start = BTOBB(range.start);
-	end = min_t(xfs_daddr_t, start + BTOBBT(range.len),
-		    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) - 1;
+	end = start + BTOBBT(range.len) - 1;
+
+	if (!bdev_max_discard_sectors(mp->m_ddev_targp->bt_bdev))
+		goto rt_discard;
+
+	ddev_end = min_t(xfs_daddr_t, end,
+			 XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1);
 
 	start_agno = xfs_daddr_to_agno(mp, start);
 	start_agbno = xfs_daddr_to_agbno(mp, start);
-	end_agno = xfs_daddr_to_agno(mp, end);
-	end_agbno = xfs_daddr_to_agbno(mp, end);
+	end_agno = xfs_daddr_to_agno(mp, ddev_end);
+	end_agbno = xfs_daddr_to_agbno(mp, ddev_end);
 
 	for_each_perag_range(mp, start_agno, end_agno, pag) {
 		xfs_agblock_t	agend = pag->block_count;
@@ -464,6 +694,14 @@ xfs_ioc_trim(
 		start_agbno = 0;
 	}
 
+rt_discard:
+	if (rt_bdev && bdev_max_discard_sectors(rt_bdev)) {
+		error = xfs_trim_rtdev_extents(mp, start, end, minlen,
+				&blocks_trimmed);
+		if (error)
+			last_error = error;
+	}
+
 	if (last_error)
 		return last_error;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 654ad6f574680..56c8333a470bb 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2463,6 +2463,35 @@ DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
 DEFINE_DISCARD_EVENT(xfs_discard_exclude);
 DEFINE_DISCARD_EVENT(xfs_discard_busy);
 
+DECLARE_EVENT_CLASS(xfs_rtdiscard_class,
+	TP_PROTO(struct xfs_mount *mp,
+		 xfs_rtblock_t rtbno, xfs_rtblock_t len),
+	TP_ARGS(mp, rtbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rtblock_t, rtbno)
+		__field(xfs_rtblock_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_rtdev_targp->bt_dev;
+		__entry->rtbno = rtbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d rtbno 0x%llx rtbcount 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rtbno,
+		  __entry->len)
+)
+
+#define DEFINE_RTDISCARD_EVENT(name) \
+DEFINE_EVENT(xfs_rtdiscard_class, name, \
+	TP_PROTO(struct xfs_mount *mp, \
+		 xfs_rtblock_t rtbno, xfs_rtblock_t len), \
+	TP_ARGS(mp, rtbno, len))
+DEFINE_RTDISCARD_EVENT(xfs_discard_rtextent);
+DEFINE_RTDISCARD_EVENT(xfs_discard_rttoosmall);
+DEFINE_RTDISCARD_EVENT(xfs_discard_rtrelax);
+
 DECLARE_EVENT_CLASS(xfs_btree_cur_class,
 	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp),
 	TP_ARGS(cur, level, bp),

