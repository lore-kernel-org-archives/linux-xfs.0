Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30E1BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o+3jVyFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927F0C433C8;
	Sun, 31 Dec 2023 21:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057728;
	bh=O6z0JlnwMAByEIQvEi57ERslYMQC+6A5kD+BDwbJ+KU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o+3jVyFtKDo3ZvXJBvuWnqGqo3+QpLIDdS9xWH8QfliTb9Vc0AWnIj5YeztV5dZ9S
	 z9pGRVw4PuAnn4bkudEpq2VlX7SFRlOvqvrdXFtidfWc63HZJu41nMeLe51OG4bZE1
	 H6FBAed9DaFJeyTOPlHxvA3Pm7JSIibwgvRTH1HFeaYgYyEyz3+QUysqMgxcSKpAR8
	 TS5ainuYtUszuMngA7wKN9glY6a9btFhQYC976PkZEFvGaKNKKg2d2cKkvl9f6hJXv
	 811UVZgmv388RrQ+fPTbFIivdnXd3zLTiBOaCs9hUIVmELS0TSxJ1CL9h3paorl1Mm
	 v0sKfL+QDYtCg==
Date: Sun, 31 Dec 2023 13:22:08 -0800
Subject: [PATCH 1/1] xfs: enable FITRIM on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846975.1763756.7829043057977943548.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846958.1763756.2429460281828066199.stgit@frogsfrogsfrogs>
References: <170404846958.1763756.2429460281828066199.stgit@frogsfrogsfrogs>
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
"space" immediately after the data device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c |  225 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trace.h   |   29 ++++++
 2 files changed, 248 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index d235f60c166c6..6febfd6caa500 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -19,6 +19,7 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Notes on an efficient, low latency fstrim algorithm
@@ -514,6 +515,197 @@ xfs_trim_extents(
 
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
+	struct block_device	*bdev = xfs_buftarg_bdev(mp->m_rtdev_targp);
+	struct xfs_rtx_busy	*busyp;
+	struct bio		*bio = NULL;
+	struct blk_plug		plug;
+	int			error = 0;
+
+	blk_start_plug(&plug);
+	list_for_each_entry(busyp, &tr->extent_list, list) {
+		trace_xfs_discard_rtextent(mp, busyp->bno, busyp->length);
+
+		error = __blkdev_issue_discard(bdev,
+				XFS_FSB_TO_BB(mp, busyp->bno),
+				XFS_FSB_TO_BB(mp, busyp->length),
+				GFP_NOFS, &bio);
+		if (error && error != -EOPNOTSUPP) {
+			xfs_info(mp,
+	 "discard failed for rtextent [0x%llx,%llu], error %d",
+				 (unsigned long long)busyp->bno,
+				 (unsigned long long)busyp->length,
+				 error);
+			break;
+		}
+	}
+	xfs_discard_free_rtdev_extents(tr);
+
+	if (bio)
+		submit_bio(bio);
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
+	busyp = kmem_zalloc(sizeof(struct xfs_rtx_busy), 0);
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
+		tr.stop_rtx = low.ar_startext +
+					xfs_rtbitmap_rtx_per_rbmblock(mp);
+		xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
+		error = xfs_rtalloc_query_range(mp, NULL, &low, &high,
+				xfs_trim_gather_rtextent, &tr);
+		xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
+
+		if (error == -ECANCELED)
+			error = 0;
+		if (error) {
+			xfs_discard_free_rtdev_extents(&tr);
+			break;
+		}
+
+		if (list_empty(&tr.extent_list))
+			break;
+
+		error = xfs_discard_rtdev_extents(mp, &tr);
+		if (error)
+			break;
+
+		low.ar_startext = tr.restart_rtx;
+	} while (!xfs_trim_should_stop() && low.ar_startext <= high.ar_startext);
+
+	return error;
+}
+#else
+# define xfs_trim_rtdev_extents(m,s,e,n,b)	(-EOPNOTSUPP)
+#endif /* CONFIG_XFS_RT */
+
 /*
  * trim a range of the filesystem.
  *
@@ -522,6 +714,9 @@ xfs_trim_extents(
  * addressing. FSB addressing is sparse (AGNO|AGBNO), while the incoming format
  * is a linear address range. Hence we need to use DADDR based conversions and
  * comparisons for determining the correct offset and regions to trim.
+ *
+ * The realtime device is mapped into the FITRIM "address space" immediately
+ * after the data device.
  */
 int
 xfs_ioc_trim(
@@ -530,9 +725,12 @@ xfs_ioc_trim(
 {
 	struct xfs_perag	*pag;
 	struct block_device	*bdev = xfs_buftarg_bdev(mp->m_ddev_targp);
+	struct block_device	*rt_bdev = NULL;
 	unsigned int		granularity = bdev_discard_granularity(bdev);
 	struct fstrim_range	range;
+	xfs_rfsblock_t		max_blocks;
 	xfs_daddr_t		start, end, minlen;
+	xfs_daddr_t		ddev_end;
 	xfs_agnumber_t		agno;
 	uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
@@ -542,6 +740,14 @@ xfs_ioc_trim(
 	if (!bdev_max_discard_sectors(bdev))
 		return -EOPNOTSUPP;
 
+	if (mp->m_rtdev_targp) {
+		rt_bdev = xfs_buftarg_bdev(mp->m_rtdev_targp);
+		if (!bdev_max_discard_sectors(rt_bdev))
+			return -EOPNOTSUPP;
+		granularity = max(granularity,
+				  bdev_discard_granularity(rt_bdev));
+	}
+
 	/*
 	 * We haven't recovered the log, so we cannot use our bnobt-guided
 	 * storage zapping commands.
@@ -561,7 +767,8 @@ xfs_ioc_trim(
 	 * used by the fstrim application.  In the end it really doesn't
 	 * matter as trimming blocks is an advisory interface.
 	 */
-	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
+	max_blocks = mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks;
+	if (range.start >= XFS_FSB_TO_B(mp, max_blocks) ||
 	    range.minlen > XFS_FSB_TO_B(mp, mp->m_ag_max_usable) ||
 	    range.len < mp->m_sb.sb_blocksize)
 		return -EINVAL;
@@ -569,12 +776,11 @@ xfs_ioc_trim(
 	start = BTOBB(range.start);
 	end = start + BTOBBT(range.len) - 1;
 
-	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
-		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;
-
 	agno = xfs_daddr_to_agno(mp, start);
-	for_each_perag_range(mp, agno, xfs_daddr_to_agno(mp, end), pag) {
-		error = xfs_trim_extents(pag, start, end, minlen,
+	ddev_end = min_t(xfs_daddr_t, end,
+			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1);
+	for_each_perag_range(mp, agno, xfs_daddr_to_agno(mp, ddev_end), pag) {
+		error = xfs_trim_extents(pag, start, ddev_end, minlen,
 					  &blocks_trimmed);
 		if (error)
 			last_error = error;
@@ -585,6 +791,13 @@ xfs_ioc_trim(
 		}
 	}
 
+	if (rt_bdev) {
+		error = xfs_trim_rtdev_extents(mp, start, end, minlen,
+				&blocks_trimmed);
+		if (error)
+			last_error = error;
+	}
+
 	if (last_error)
 		return last_error;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d23566e841cba..063b1ee79de2f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2506,6 +2506,35 @@ DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
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
 /* btree cursor events */
 TRACE_DEFINE_ENUM(XFS_BTNUM_BNOi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_CNTi);

