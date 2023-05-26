Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C72C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjEZAlp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjEZAlo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:41:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A121EE
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05D6D61B68
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EB2C433D2;
        Fri, 26 May 2023 00:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061701;
        bh=y+1xgJ0M7V92QHnj18r+F07C+NSR0/CBtWPqwsRz4ng=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=UlEgFf3Qw46n8uwR6WNGzfb9UedkOvoBEfAPRgITogvpy5Gv/D6usG3/aKqYmfgst
         2vvVALKr5uyC5Iw609kQUvUWxOsAWY40XCtk0X+MlLoP4vX2O9hyQTm045ezdDGXd0
         ps5Y5fcY8yI2hDAhITTQg1rfkjFQ7G3pXQCG6pbRv4MG4Q7jNwRUDpAQsEa5/J0CbL
         WISm9Cpk2lvhAZgpj0g4ZH0KHNsaUzW26Vpj5B+NGQ8QnFJg6f6rM1O4fX2TmVYu7q
         6MlZzEBXXHJeiR9UF1CnOZOlNAadG4KMjOazDGz/o1nj+wOWQpun3IkwcxyHySmsmH
         Wjvirog4nywGA==
Date:   Thu, 25 May 2023 17:41:40 -0700
Subject: [PATCH 2/7] xfs: fix integer overflows in the fsmap rtbitmap and
 logdev backends
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055226.3727958.6527603465567915311.stgit@frogsfrogsfrogs>
In-Reply-To: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
References: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It's not correct to use the rmap irec structure to hold query key
information to query the rtbitmap because the realtime volume can be
longer than 2^32 fsblocks in length.  Because the rt volume doesn't have
allocation groups, introduce a daddr-based record filtering algorithm
and compute the rtextent values using 64-bit variables.  The same
problem exists in the external log device fsmap implementation, so use
the same solution to fix it too.

After this patch, all the code that touches info->low and info->high
under xfs_getfsmap_logdev and __xfs_getfsmap_rtdev are unnecessary.
Cleaning this up will be done in subsequent patches.

Fixes: 4c934c7dd60c ("xfs: report realtime space information via the rtbitmap")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   90 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 64 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 6ddcda2c1218..901918116d3d 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -160,6 +160,8 @@ struct xfs_getfsmap_info {
 	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
 	struct xfs_perag	*pag;		/* AG info, if applicable */
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
+	/* daddr of low fsmap key when we're using the rtbitmap */
+	xfs_daddr_t		low_daddr;
 	u64			missing_owner;	/* owner of holes */
 	u32			dev;		/* device id */
 	/*
@@ -250,6 +252,8 @@ xfs_getfsmap_rec_before_start(
 	const struct xfs_rmap_irec	*rec,
 	xfs_daddr_t			rec_daddr)
 {
+	if (info->low_daddr != -1ULL)
+		return rec_daddr < info->low_daddr;
 	if (info->low.rm_blockcount)
 		return xfs_rmap_compare(rec, &info->low) < 0;
 	return false;
@@ -257,14 +261,16 @@ xfs_getfsmap_rec_before_start(
 
 /*
  * Format a reverse mapping for getfsmap, having translated rm_startblock
- * into the appropriate daddr units.
+ * into the appropriate daddr units.  Pass in a nonzero @len_daddr if the
+ * length could be larger than rm_blockcount in struct xfs_rmap_irec.
  */
 STATIC int
 xfs_getfsmap_helper(
 	struct xfs_trans		*tp,
 	struct xfs_getfsmap_info	*info,
 	const struct xfs_rmap_irec	*rec,
-	xfs_daddr_t			rec_daddr)
+	xfs_daddr_t			rec_daddr,
+	xfs_daddr_t			len_daddr)
 {
 	struct xfs_fsmap		fmr;
 	struct xfs_mount		*mp = tp->t_mountp;
@@ -274,12 +280,15 @@ xfs_getfsmap_helper(
 	if (fatal_signal_pending(current))
 		return -EINTR;
 
+	if (len_daddr == 0)
+		len_daddr = XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+
 	/*
 	 * Filter out records that start before our startpoint, if the
 	 * caller requested that.
 	 */
 	if (xfs_getfsmap_rec_before_start(info, rec, rec_daddr)) {
-		rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+		rec_daddr += len_daddr;
 		if (info->next_daddr < rec_daddr)
 			info->next_daddr = rec_daddr;
 		return 0;
@@ -298,7 +307,7 @@ xfs_getfsmap_helper(
 
 		info->head->fmh_entries++;
 
-		rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+		rec_daddr += len_daddr;
 		if (info->next_daddr < rec_daddr)
 			info->next_daddr = rec_daddr;
 		return 0;
@@ -338,7 +347,7 @@ xfs_getfsmap_helper(
 	if (error)
 		return error;
 	fmr.fmr_offset = XFS_FSB_TO_BB(mp, rec->rm_offset);
-	fmr.fmr_length = XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+	fmr.fmr_length = len_daddr;
 	if (rec->rm_flags & XFS_RMAP_UNWRITTEN)
 		fmr.fmr_flags |= FMR_OF_PREALLOC;
 	if (rec->rm_flags & XFS_RMAP_ATTR_FORK)
@@ -355,7 +364,7 @@ xfs_getfsmap_helper(
 
 	xfs_getfsmap_format(mp, &fmr, info);
 out:
-	rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+	rec_daddr += len_daddr;
 	if (info->next_daddr < rec_daddr)
 		info->next_daddr = rec_daddr;
 	return 0;
@@ -376,7 +385,7 @@ xfs_getfsmap_datadev_helper(
 	fsb = XFS_AGB_TO_FSB(mp, cur->bc_ag.pag->pag_agno, rec->rm_startblock);
 	rec_daddr = XFS_FSB_TO_DADDR(mp, fsb);
 
-	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
+	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr, 0);
 }
 
 /* Transform a bnobt irec into a fsmap */
@@ -400,7 +409,7 @@ xfs_getfsmap_datadev_bnobt_helper(
 	irec.rm_offset = 0;
 	irec.rm_flags = 0;
 
-	return xfs_getfsmap_helper(cur->bc_tp, info, &irec, rec_daddr);
+	return xfs_getfsmap_helper(cur->bc_tp, info, &irec, rec_daddr, 0);
 }
 
 /* Set rmap flags based on the getfsmap flags */
@@ -427,9 +436,13 @@ xfs_getfsmap_logdev(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_rmap_irec		rmap;
+	xfs_daddr_t			rec_daddr, len_daddr;
+	xfs_fsblock_t			start_fsb;
 	int				error;
 
 	/* Set up search keys */
+	start_fsb = XFS_BB_TO_FSBT(mp,
+				keys[0].fmr_physical + keys[0].fmr_length);
 	info->low.rm_startblock = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
 	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
 	error = xfs_fsmap_owner_to_rmap(&info->low, keys);
@@ -438,6 +451,10 @@ xfs_getfsmap_logdev(
 	info->low.rm_blockcount = 0;
 	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
 
+	/* Adjust the low key if we are continuing from where we left off. */
+	if (keys[0].fmr_length > 0)
+		info->low_daddr = XFS_FSB_TO_BB(mp, start_fsb);
+
 	error = xfs_fsmap_owner_to_rmap(&info->high, keys + 1);
 	if (error)
 		return error;
@@ -451,7 +468,7 @@ xfs_getfsmap_logdev(
 	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
 	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
 
-	if (keys[0].fmr_physical > 0)
+	if (start_fsb > 0)
 		return 0;
 
 	/* Fabricate an rmap entry for the external log device. */
@@ -461,7 +478,9 @@ xfs_getfsmap_logdev(
 	rmap.rm_offset = 0;
 	rmap.rm_flags = 0;
 
-	return xfs_getfsmap_helper(tp, info, &rmap, 0);
+	rec_daddr = XFS_FSB_TO_BB(mp, rmap.rm_startblock);
+	len_daddr = XFS_FSB_TO_BB(mp, rmap.rm_blockcount);
+	return xfs_getfsmap_helper(tp, info, &rmap, rec_daddr, len_daddr);
 }
 
 #ifdef CONFIG_XFS_RT
@@ -475,16 +494,22 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 {
 	struct xfs_getfsmap_info	*info = priv;
 	struct xfs_rmap_irec		irec;
-	xfs_daddr_t			rec_daddr;
+	xfs_rtblock_t			rtbno;
+	xfs_daddr_t			rec_daddr, len_daddr;
+
+	rtbno = rec->ar_startext * mp->m_sb.sb_rextsize;
+	rec_daddr = XFS_FSB_TO_BB(mp, rtbno);
+	irec.rm_startblock = rtbno;
+
+	rtbno = rec->ar_extcount * mp->m_sb.sb_rextsize;
+	len_daddr = XFS_FSB_TO_BB(mp, rtbno);
+	irec.rm_blockcount = rtbno;
 
-	irec.rm_startblock = rec->ar_startext * mp->m_sb.sb_rextsize;
-	rec_daddr = XFS_FSB_TO_BB(mp, irec.rm_startblock);
-	irec.rm_blockcount = rec->ar_extcount * mp->m_sb.sb_rextsize;
 	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
 	irec.rm_offset = 0;
 	irec.rm_flags = 0;
 
-	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr);
+	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr, len_daddr);
 }
 
 /* Execute a getfsmap query against the realtime device. */
@@ -493,23 +518,26 @@ __xfs_getfsmap_rtdev(
 	struct xfs_trans		*tp,
 	const struct xfs_fsmap		*keys,
 	int				(*query_fn)(struct xfs_trans *,
-						    struct xfs_getfsmap_info *),
+						    struct xfs_getfsmap_info *,
+						    xfs_rtblock_t start_rtb,
+						    xfs_rtblock_t end_rtb),
 	struct xfs_getfsmap_info	*info)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	xfs_fsblock_t			start_fsb;
-	xfs_fsblock_t			end_fsb;
+	xfs_rtblock_t			start_rtb;
+	xfs_rtblock_t			end_rtb;
 	uint64_t			eofs;
 	int				error = 0;
 
 	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
-	start_fsb = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
-	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
+	start_rtb = XFS_BB_TO_FSBT(mp,
+				keys[0].fmr_physical + keys[0].fmr_length);
+	end_rtb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
 
 	/* Set up search keys */
-	info->low.rm_startblock = start_fsb;
+	info->low.rm_startblock = start_rtb;
 	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
 	if (error)
 		return error;
@@ -517,7 +545,14 @@ __xfs_getfsmap_rtdev(
 	info->low.rm_blockcount = 0;
 	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
 
-	info->high.rm_startblock = end_fsb;
+	/* Adjust the low key if we are continuing from where we left off. */
+	if (keys[0].fmr_length > 0) {
+		info->low_daddr = XFS_FSB_TO_BB(mp, start_rtb);
+		if (info->low_daddr >= eofs)
+			return 0;
+	}
+
+	info->high.rm_startblock = end_rtb;
 	error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
 	if (error)
 		return error;
@@ -528,14 +563,16 @@ __xfs_getfsmap_rtdev(
 	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
 	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
 
-	return query_fn(tp, info);
+	return query_fn(tp, info, start_rtb, end_rtb);
 }
 
 /* Actually query the realtime bitmap. */
 STATIC int
 xfs_getfsmap_rtdev_rtbitmap_query(
 	struct xfs_trans		*tp,
-	struct xfs_getfsmap_info	*info)
+	struct xfs_getfsmap_info	*info,
+	xfs_rtblock_t			start_rtb,
+	xfs_rtblock_t			end_rtb)
 {
 	struct xfs_rtalloc_rec		alow = { 0 };
 	struct xfs_rtalloc_rec		ahigh = { 0 };
@@ -548,8 +585,8 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 	 * Set up query parameters to return free rtextents covering the range
 	 * we want.
 	 */
-	alow.ar_startext = info->low.rm_startblock;
-	ahigh.ar_startext = info->high.rm_startblock;
+	alow.ar_startext = start_rtb;
+	ahigh.ar_startext = end_rtb;
 	do_div(alow.ar_startext, mp->m_sb.sb_rextsize);
 	if (do_div(ahigh.ar_startext, mp->m_sb.sb_rextsize))
 		ahigh.ar_startext++;
@@ -988,6 +1025,7 @@ xfs_getfsmap(
 		info.dev = handlers[i].dev;
 		info.last = false;
 		info.pag = NULL;
+		info.low_daddr = -1ULL;
 		info.low.rm_blockcount = 0;
 		error = handlers[i].fn(tp, dkeys, &info);
 		if (error)

