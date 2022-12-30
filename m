Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCF7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbiLaBmH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiLaBmG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:42:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218AD13DEA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:42:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B297361C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1915FC433EF;
        Sat, 31 Dec 2022 01:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450924;
        bh=0rk92Ad0iwfxQ/oamTCC1FFnXI7tvagXjJ0kvhmUgmk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=B+3tgr6bMZ50vi4UtHpcfP7jqoYjpslNCqlEnJHO+/gIdcF/S8EbXIZpkwcBzBotN
         V8DAfpD50XsT2OydukdLoDpTbqKlcypxNtORp2FqyVFh8Ygnu1SM5C9RBJYSxmXFFH
         R3lNCJJxZbv2JaqHMtyO5JKiouu1GzOww4pE5cP7TzsArssaf2OA46ZHdKPeDYybG6
         o9JHkSWu2FW+SlwTVcgV5Knv23sElAc2mp3JaM2hjSYrLyZxlsrGpnEv8IYV2nYHCH
         VbQbwXtu7Dy6+LPn3VETWDYqtrKO8X1wk68sulHP76URN2obDz/DWXMlI5BoJyZml2
         jJJ0lzU+1cmAQ==
Subject: [PATCH 20/38] xfs: fix integer overflows in the fsmap rtbitmap
 backend
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:18 -0800
Message-ID: <167243869884.715303.13207234516175118417.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
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
 fs/xfs/xfs_fsmap.c |   54 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index e330a7e55d1d..b5e7ae77cab9 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -163,6 +163,8 @@ struct xfs_getfsmap_info {
 	struct xfs_rtgroup	*rtg;		/* rt group info, if needed */
 	struct xfs_perag	*pag;		/* AG info, if applicable */
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
+	/* daddr of low fsmap key when we're using the rtbitmap */
+	xfs_daddr_t		low_daddr;
 	u64			missing_owner;	/* owner of holes */
 	u32			dev;		/* device id */
 	struct xfs_rmap_irec	low;		/* low rmap key */
@@ -240,16 +242,29 @@ xfs_getfsmap_format(
 	xfs_fsmap_from_internal(rec, xfm);
 }
 
+static inline bool
+xfs_getfsmap_rec_before_start(
+	struct xfs_getfsmap_info	*info,
+	const struct xfs_rmap_irec	*rec,
+	xfs_daddr_t			rec_daddr)
+{
+	if (info->low_daddr != -1ULL)
+		return rec_daddr < info->low_daddr;
+	return xfs_rmap_compare(rec, &info->low) < 0;
+}
+
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
@@ -259,12 +274,15 @@ xfs_getfsmap_helper(
 	if (fatal_signal_pending(current))
 		return -EINTR;
 
+	if (len_daddr == 0)
+		len_daddr = XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+
 	/*
 	 * Filter out records that start before our startpoint, if the
 	 * caller requested that.
 	 */
-	if (xfs_rmap_compare(rec, &info->low) < 0) {
-		rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+	if (xfs_getfsmap_rec_before_start(info, rec, rec_daddr)) {
+		rec_daddr += len_daddr;
 		if (info->next_daddr < rec_daddr)
 			info->next_daddr = rec_daddr;
 		return 0;
@@ -283,7 +301,7 @@ xfs_getfsmap_helper(
 
 		info->head->fmh_entries++;
 
-		rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+		rec_daddr += len_daddr;
 		if (info->next_daddr < rec_daddr)
 			info->next_daddr = rec_daddr;
 		return 0;
@@ -329,7 +347,7 @@ xfs_getfsmap_helper(
 	if (error)
 		return error;
 	fmr.fmr_offset = XFS_FSB_TO_BB(mp, rec->rm_offset);
-	fmr.fmr_length = XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+	fmr.fmr_length = len_daddr;
 	if (rec->rm_flags & XFS_RMAP_UNWRITTEN)
 		fmr.fmr_flags |= FMR_OF_PREALLOC;
 	if (rec->rm_flags & XFS_RMAP_ATTR_FORK)
@@ -346,7 +364,7 @@ xfs_getfsmap_helper(
 
 	xfs_getfsmap_format(mp, &fmr, info);
 out:
-	rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
+	rec_daddr += len_daddr;
 	if (info->next_daddr < rec_daddr)
 		info->next_daddr = rec_daddr;
 	return 0;
@@ -382,7 +400,7 @@ xfs_getfsmap_datadev_helper(
 	fsb = XFS_AGB_TO_FSB(mp, cur->bc_ag.pag->pag_agno, rec->rm_startblock);
 	rec_daddr = XFS_FSB_TO_DADDR(mp, fsb);
 
-	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
+	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr, 0);
 }
 
 /* Transform a bnobt irec into a fsmap */
@@ -406,7 +424,7 @@ xfs_getfsmap_datadev_bnobt_helper(
 	irec.rm_offset = 0;
 	irec.rm_flags = 0;
 
-	return xfs_getfsmap_helper(cur->bc_tp, info, &irec, rec_daddr);
+	return xfs_getfsmap_helper(cur->bc_tp, info, &irec, rec_daddr, 0);
 }
 
 /* Execute a getfsmap query against the regular data device. */
@@ -650,7 +668,7 @@ xfs_getfsmap_logdev(
 	rmap.rm_offset = 0;
 	rmap.rm_flags = 0;
 
-	return xfs_getfsmap_helper(tp, info, &rmap, 0);
+	return xfs_getfsmap_helper(tp, info, &rmap, 0, 0);
 }
 
 #ifdef CONFIG_XFS_RT
@@ -664,16 +682,22 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 {
 	struct xfs_getfsmap_info	*info = priv;
 	struct xfs_rmap_irec		irec;
-	xfs_daddr_t			rec_daddr;
+	xfs_rtblock_t			rtbno;
+	xfs_daddr_t			rec_daddr, len_daddr;
+
+	rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
+	rec_daddr = XFS_FSB_TO_BB(mp, rtbno);
+
+	rtbno = xfs_rtx_to_rtb(mp, rec->ar_extcount);
+	len_daddr = XFS_FSB_TO_BB(mp, rtbno);
 
 	irec.rm_startblock = xfs_rtx_to_rtb(mp, rec->ar_startext);
-	rec_daddr = XFS_FSB_TO_BB(mp, irec.rm_startblock);
 	irec.rm_blockcount = xfs_rtx_to_rtb(mp, rec->ar_extcount);
 	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
 	irec.rm_offset = 0;
 	irec.rm_flags = 0;
 
-	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr);
+	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr, len_daddr);
 }
 
 /* Actually query the realtime bitmap. */
@@ -741,6 +765,7 @@ xfs_getfsmap_rtdev_rtbitmap(
 
 	/* Set up search keys */
 	info->low.rm_startblock = start_fsb;
+	info->low_daddr = XFS_FSB_TO_BB(mp, start_fsb);
 	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
 	if (error)
 		return error;
@@ -778,7 +803,7 @@ xfs_getfsmap_rtdev_helper(
 			rec->rm_startblock);
 	rec_daddr = xfs_rtb_to_daddr(mp, rtbno);
 
-	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr);
+	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr, 0);
 }
 
 /* Actually query the rtrmap btree. */
@@ -1122,6 +1147,7 @@ xfs_getfsmap(
 		info.last = false;
 		info.pag = NULL;
 		info.rtg = NULL;
+		info.low_daddr = -1ULL;
 		error = handlers[i].fn(tp, dkeys, &info);
 		if (error)
 			break;

