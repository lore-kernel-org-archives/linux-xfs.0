Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140EAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbiLaBeD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLaBeB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:34:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8ABDEB7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:34:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08943B81E09
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1770C433D2;
        Sat, 31 Dec 2022 01:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450437;
        bh=NUKlXYJQSSuJ1szDdttYAXE53M1+LMIcyNhBZpa1ZoA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Sz1V8G6FdL+hsjvN3Lxy3lRONOmZKMBVDU9EtIkRmil3+ZgiMysNy/ezTO4it3KyT
         P/MLWgho9lfRThbkZ74hn4is3fHAFAFiOFmlR6p43ANxjhJiZC54ZFq2NvSdipZtjX
         kPlpdRiJziMqMK1QW3h5p8hKJuBKEHG+htoI+af3vH0u3TbibJMtoWzhl0hUlLXHAp
         2Wda52YvFxT6AAFBphwPru4Y+2rODmbDKwx//l/DklqeqY86F++GIDWFfTOoUIV51u
         HATgZOGXmvEMLE6qxMPL7bulIVvTXfQSb/JMNqxCxPpyE2cqZ1J46UAuP3HjLZcj8n
         tC4Rmnjm2mrXQ==
Subject: [PATCH 3/3] xfs: enable FITRIM on the realtime device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:59 -0800
Message-ID: <167243867907.713699.3220336734546600556.stgit@magnolia>
In-Reply-To: <167243867862.713699.17132272459502557791.stgit@magnolia>
References: <167243867862.713699.17132272459502557791.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c |  106 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h   |   20 +++++++++
 2 files changed, 125 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 6d3400771e21..f6ee2b8e5e9c 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -19,6 +19,7 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
+#include "xfs_rtbitmap.h"
 
 STATIC int
 xfs_trim_perag_extents(
@@ -168,6 +169,86 @@ xfs_trim_ddev_extents(
 	return last_error;
 }
 
+#ifdef CONFIG_XFS_RT
+static int
+xfs_trim_rtdev_extent(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv)
+{
+	struct block_device	*bdev = xfs_buftarg_bdev(mp->m_rtdev_targp);
+	uint64_t		*blocks_trimmed = priv;
+	xfs_rtblock_t		rbno, rlen;
+	xfs_daddr_t		dbno, dlen;
+	int			error;
+
+	if (fatal_signal_pending(current))
+		return -ERESTARTSYS;
+
+	rbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
+	rlen = xfs_rtx_to_rtb(mp, rec->ar_extcount);
+
+	trace_xfs_discard_rtextent(mp, rbno, rlen);
+
+	dbno = XFS_FSB_TO_BB(mp, rbno);
+	dlen = XFS_FSB_TO_BB(mp, rlen);
+
+	error = blkdev_issue_discard(bdev, dbno, dlen, GFP_NOFS);
+	if (error)
+		return error;
+
+	*blocks_trimmed += rlen;
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
+	struct xfs_rtalloc_rec	low = { }, high = { };
+	xfs_daddr_t		rtdev_daddr;
+	xfs_extlen_t		mod;
+	int			error;
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
+	low.ar_startext = xfs_rtb_to_rtx(mp, XFS_BB_TO_FSB(mp, start), &mod);
+	if (mod)
+		low.ar_startext++;
+	high.ar_startext = xfs_rtb_to_rtx(mp, XFS_BB_TO_FSBT(mp, end), &mod);
+
+	/*
+	 * Walk the free ranges between low and high.  The query_range function
+	 * trims the extents returned.
+	 */
+	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
+	error = xfs_rtalloc_query_range(mp, NULL, &low, &high,
+			xfs_trim_rtdev_extent, blocks_trimmed);
+	xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
+	return error;
+}
+#else
+# define xfs_trim_rtdev_extents(m,s,e,n,b)	(-EOPNOTSUPP)
+#endif /* CONFIG_XFS_RT */
+
 /*
  * trim a range of the filesystem.
  *
@@ -176,6 +257,9 @@ xfs_trim_ddev_extents(
  * addressing. FSB addressing is sparse (AGNO|AGBNO), while the incoming format
  * is a linear address range. Hence we need to use DADDR based conversions and
  * comparisons for determining the correct offset and regions to trim.
+ *
+ * The realtime device is mapped into the FITRIM "address space" immediately
+ * after the data device.
  */
 int
 xfs_ioc_trim(
@@ -183,8 +267,10 @@ xfs_ioc_trim(
 	struct fstrim_range __user	*urange)
 {
 	struct block_device	*bdev = xfs_buftarg_bdev(mp->m_ddev_targp);
+	struct block_device	*rt_bdev = NULL;
 	unsigned int		granularity = bdev_discard_granularity(bdev);
 	struct fstrim_range	range;
+	xfs_rfsblock_t		max_blocks;
 	xfs_daddr_t		start, end, minlen;
 	uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
@@ -194,6 +280,14 @@ xfs_ioc_trim(
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
@@ -213,7 +307,8 @@ xfs_ioc_trim(
 	 * used by the fstrim application.  In the end it really doesn't
 	 * matter as trimming blocks is an advisory interface.
 	 */
-	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
+	max_blocks = mp->m_sb.sb_dblocks + mp->m_sb.sb_rblocks;
+	if (range.start >= XFS_FSB_TO_B(mp, max_blocks) ||
 	    range.minlen > XFS_FSB_TO_B(mp, mp->m_ag_max_usable) ||
 	    range.len < mp->m_sb.sb_blocksize)
 		return -EINVAL;
@@ -227,6 +322,15 @@ xfs_ioc_trim(
 	if (error)
 		last_error = error;
 
+	if (rt_bdev) {
+		error = xfs_trim_rtdev_extents(mp, start, end, minlen,
+				&blocks_trimmed);
+		if (error == -ERESTARTSYS)
+			return error;
+		if (error)
+			last_error = error;
+	}
+
 	if (last_error)
 		return last_error;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ec9aa1914a93..cfb26288394a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2520,6 +2520,26 @@ DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
 DEFINE_DISCARD_EVENT(xfs_discard_exclude);
 DEFINE_DISCARD_EVENT(xfs_discard_busy);
 
+TRACE_EVENT(xfs_discard_rtextent,
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
+);
+
 /* btree cursor events */
 TRACE_DEFINE_ENUM(XFS_BTNUM_BNOi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_CNTi);

