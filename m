Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A82CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236093AbiLaB2t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbiLaB2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:28:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795B11C93A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15E9661CAB
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BCAC433EF;
        Sat, 31 Dec 2022 01:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450126;
        bh=OpzWkWaDZ5JicG7K9cUyUmAtVR7YHhUa4ekNcDHQw6s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hj8ra8aJAjRvvmiSW5Ad1/qDiIbfRfS6AC7KRkrfYyhbjy4Bz1EgWBvIenrWJRcJd
         +XeWH9itvgFU4QORoaOyz/NFyUTId04r87VrdEFexcUvrEjvi+NAy0nh5Hjgu+XjOI
         sxWyJHyJSYCtymuFWjrcwLJZWgUN6i81G2TdC4WAWVh2guAKog6IBJTYYGrVnlgiSy
         xD0qHuF5UcBTCbv5svMhT39juuljrZWXzjsfvnbeEAtkhsCzDbknoLB7XrImOzKutU
         Bwxb57Bg9i5jRFuglXq+KLTk27xNbB8LrPUnJlVlIQhl/NPxncEwnKi1k62eYFSjM9
         M/+RRuJveh76A==
Subject: [PATCH 05/22] xfs: write secondary realtime superblocks to disk
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:53 -0800
Message-ID: <167243867341.712847.732913902847227497.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create some library functions to make it easy to update all the
secondary realtime superblocks on disk; this will be used by growfs,
xfs_db, mkfs, and xfs_repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.c |  117 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |    2 +
 2 files changed, 119 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index e9655e699f4f..037506b73384 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -382,3 +382,120 @@ xfs_rtgroup_log_super(
 	xfs_rtgroup_update_super(rtsb_bp, sb_bp);
 	xfs_trans_ordered_buf(tp, rtsb_bp);
 }
+
+/* Initialize a secondary realtime superblock. */
+static int
+xfs_rtgroup_init_secondary_super(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_buf		*bp;
+	struct xfs_rtsb		*rsb;
+	xfs_rtblock_t		rtbno;
+	int			error;
+
+	ASSERT(rgno != 0);
+
+	error = xfs_buf_get_uncached(mp->m_rtdev_targp, XFS_FSB_TO_BB(mp, 1),
+			0, &bp);
+	if (error)
+		return error;
+
+	rtbno = xfs_rgbno_to_rtb(mp, rgno, 0);
+	bp->b_maps[0].bm_bn = xfs_rtb_to_daddr(mp, rtbno);
+	bp->b_ops = &xfs_rtsb_buf_ops;
+	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
+
+	rsb = bp->b_addr;
+	rsb->rsb_magicnum = cpu_to_be32(XFS_RTSB_MAGIC);
+	rsb->rsb_blocksize = cpu_to_be32(mp->m_sb.sb_blocksize);
+	rsb->rsb_rblocks = cpu_to_be64(mp->m_sb.sb_rblocks);
+
+	rsb->rsb_rextents = cpu_to_be64(mp->m_sb.sb_rextents);
+
+	memcpy(&rsb->rsb_uuid, &mp->m_sb.sb_uuid, sizeof(rsb->rsb_uuid));
+
+	rsb->rsb_rgcount = cpu_to_be32(mp->m_sb.sb_rgcount);
+	memcpy(&rsb->rsb_fname, &mp->m_sb.sb_fname, XFSLABEL_MAX);
+
+	rsb->rsb_rextsize = cpu_to_be32(mp->m_sb.sb_rextsize);
+	rsb->rsb_rbmblocks = cpu_to_be32(mp->m_sb.sb_rbmblocks);
+
+	rsb->rsb_rgblocks = cpu_to_be32(mp->m_sb.sb_rgblocks);
+	rsb->rsb_blocklog = mp->m_sb.sb_blocklog;
+	rsb->rsb_sectlog = mp->m_sb.sb_sectlog;
+	rsb->rsb_rextslog = mp->m_sb.sb_rextslog;
+
+	memcpy(&rsb->rsb_meta_uuid, &mp->m_sb.sb_meta_uuid,
+			sizeof(rsb->rsb_meta_uuid));
+
+	*bpp = bp;
+	return 0;
+}
+
+/*
+ * Update all the realtime superblocks to match the new state of the primary.
+ * Because we are completely overwriting all the existing fields in the
+ * secondary superblock buffers, there is no need to read them in from disk.
+ * Just get a new buffer, stamp it and write it.
+ *
+ * The rt super buffers do not need to be kept them in memory once they are
+ * written so we mark them as a one-shot buffer.
+ */
+int
+xfs_rtgroup_update_secondary_sbs(
+	struct xfs_mount	*mp)
+{
+	LIST_HEAD		(buffer_list);
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		start_rgno = 1;
+	int			saved_error = 0;
+	int			error = 0;
+
+	for_each_rtgroup_from(mp, start_rgno, rtg) {
+		struct xfs_buf		*bp;
+
+		error = xfs_rtgroup_init_secondary_super(mp, rtg->rtg_rgno,
+				&bp);
+		/*
+		 * If we get an error reading or writing alternate superblocks,
+		 * continue.  If we break early, we'll leave more superblocks
+		 * un-updated than updated.
+		 */
+		if (error) {
+			xfs_warn(mp,
+		"error allocating secondary superblock for rt group %d",
+				rtg->rtg_rgno);
+			if (!saved_error)
+				saved_error = error;
+			continue;
+		}
+
+		xfs_buf_oneshot(bp);
+		xfs_buf_delwri_queue(bp, &buffer_list);
+		xfs_buf_relse(bp);
+
+		/* don't hold too many buffers at once */
+		if (rtg->rtg_rgno % 16)
+			continue;
+
+		error = xfs_buf_delwri_submit(&buffer_list);
+		if (error) {
+			xfs_warn(mp,
+	"write error %d updating a secondary superblock near rt group %u",
+				error, rtg->rtg_rgno);
+			if (!saved_error)
+				saved_error = error;
+			continue;
+		}
+	}
+	error = xfs_buf_delwri_submit(&buffer_list);
+	if (error) {
+		xfs_warn(mp,
+	"write error %d updating a secondary superblock near rt group %u",
+			error, start_rgno);
+	}
+
+	return saved_error ? saved_error : error;
+}
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index c6db6b0d2ae5..d8723fabeb57 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -201,10 +201,12 @@ xfs_rgblock_t xfs_rtgroup_block_count(struct xfs_mount *mp,
 void xfs_rtgroup_update_super(struct xfs_buf *rtsb_bp,
 		const struct xfs_buf *sb_bp);
 void xfs_rtgroup_log_super(struct xfs_trans *tp, const struct xfs_buf *sb_bp);
+int xfs_rtgroup_update_secondary_sbs(struct xfs_mount *mp);
 #else
 # define xfs_rtgroup_block_count(mp, rgno)	(0)
 # define xfs_rtgroup_update_super(bp, sb_bp)	((void)0)
 # define xfs_rtgroup_log_super(tp, sb_bp)	((void)0)
+# define xfs_rtgroup_update_secondary_sbs(mp)	(0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */

