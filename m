Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A79F2C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 851BF610A2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 00:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhHLA7S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 20:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233084AbhHLA7R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 20:59:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BDAD601FD;
        Thu, 12 Aug 2021 00:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628729933;
        bh=4pUvnSz8zQSPDjhe6XZ9KfLA9cgqNFBjlWJlF/k/zBE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hKS4/qO1y+Sp3VUu6hHc1B1mFdb2jH3Z9wZaIYk6cjmXOYoaMuD6EExZwZZ97q8k/
         DjiZuIhhe8D8wMdJ/b8Vq3N9JqCTKV6ZuX5Xp4PpTanxheCje0YsBy2df3cm7l0qry
         k9C255WcwSxYxBUSpfmiiiJpmk9f1g4u4zeijUAKK0soFs4bwAwrNLUWTfZ2Q9OXiH
         e1YF+xUHNsYNYrDPQwsE+FPOdfisyF/St1rZxaC8xIKRYPKHQQuRGSc4Zo60hs61sw
         ZJoCqUlASo+/alwFbsTsgGnyHW2ETo6igEJSCWsT7IddoZ6PJMU8FAYQB6jR2lg+vJ
         bgOty+wXJ9/WQ==
Subject: [PATCH 3/3] xfs: make fsmap backend function key parameters const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 11 Aug 2021 17:58:53 -0700
Message-ID: <162872993322.1220643.17973810836146274147.stgit@magnolia>
In-Reply-To: <162872991654.1220643.136984377220187940.stgit@magnolia>
References: <162872991654.1220643.136984377220187940.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are several GETFSMAP backend functions for XFS to cover the three
devices and various feature support.  Each of these functions are passed
pointers to the low and high keys for the dataset that userspace
requested, and a pointer to scratchpad variables that are used to
control the iteration and fill out records.  The scratchpad data can be
changed arbitrarily, but the keys are supposed to remain unchanged (and
under the control of the outermost loop in xfs_getfsmap).

Unfortunately, the data and rt backends modify the keys that are passed
in from the main control loop, which causes subsequent calls to return
incorrect query results.  Specifically, each of those two functions set
the block number in the high key to the size of their respective device.
Since fsmap results are sorted in device number order, if the lower
numbered device is smaller than the higher numbered device, the first
function will set the high key to the small size, and the key remains
unchanged as it is passed into the function for the higher numbered
device.  The second function will then fail to return all of the results
for the dataset that userspace is asking for because the keyspace is
incorrectly constrained.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index a0e8ab58124b..7bcc2ab68b8d 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -61,7 +61,7 @@ xfs_fsmap_to_internal(
 static int
 xfs_fsmap_owner_to_rmap(
 	struct xfs_rmap_irec	*dest,
-	struct xfs_fsmap	*src)
+	const struct xfs_fsmap	*src)
 {
 	if (!(src->fmr_flags & FMR_OF_SPECIAL_OWNER)) {
 		dest->rm_owner = src->fmr_owner;
@@ -171,7 +171,7 @@ struct xfs_getfsmap_info {
 struct xfs_getfsmap_dev {
 	u32			dev;
 	int			(*fn)(struct xfs_trans *tp,
-				      struct xfs_fsmap *keys,
+				      const struct xfs_fsmap *keys,
 				      struct xfs_getfsmap_info *info);
 };
 
@@ -389,7 +389,7 @@ xfs_getfsmap_datadev_bnobt_helper(
 static void
 xfs_getfsmap_set_irec_flags(
 	struct xfs_rmap_irec	*irec,
-	struct xfs_fsmap	*fmr)
+	const struct xfs_fsmap	*fmr)
 {
 	irec->rm_flags = 0;
 	if (fmr->fmr_flags & FMR_OF_ATTR_FORK)
@@ -404,7 +404,7 @@ xfs_getfsmap_set_irec_flags(
 STATIC int
 xfs_getfsmap_logdev(
 	struct xfs_trans		*tp,
-	struct xfs_fsmap		*keys,
+	const struct xfs_fsmap		*keys,
 	struct xfs_getfsmap_info	*info)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
@@ -473,7 +473,7 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 STATIC int
 __xfs_getfsmap_rtdev(
 	struct xfs_trans		*tp,
-	struct xfs_fsmap		*keys,
+	const struct xfs_fsmap		*keys,
 	int				(*query_fn)(struct xfs_trans *,
 						    struct xfs_getfsmap_info *),
 	struct xfs_getfsmap_info	*info)
@@ -481,16 +481,14 @@ __xfs_getfsmap_rtdev(
 	struct xfs_mount		*mp = tp->t_mountp;
 	xfs_fsblock_t			start_fsb;
 	xfs_fsblock_t			end_fsb;
-	xfs_daddr_t			eofs;
+	uint64_t			eofs;
 	int				error = 0;
 
 	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
-	if (keys[1].fmr_physical >= eofs)
-		keys[1].fmr_physical = eofs - 1;
 	start_fsb = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
-	end_fsb = XFS_BB_TO_FSB(mp, keys[1].fmr_physical);
+	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
 
 	/* Set up search keys */
 	info->low.rm_startblock = start_fsb;
@@ -563,7 +561,7 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 STATIC int
 xfs_getfsmap_rtdev_rtbitmap(
 	struct xfs_trans		*tp,
-	struct xfs_fsmap		*keys,
+	const struct xfs_fsmap		*keys,
 	struct xfs_getfsmap_info	*info)
 {
 	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
@@ -576,7 +574,7 @@ xfs_getfsmap_rtdev_rtbitmap(
 STATIC int
 __xfs_getfsmap_datadev(
 	struct xfs_trans		*tp,
-	struct xfs_fsmap		*keys,
+	const struct xfs_fsmap		*keys,
 	struct xfs_getfsmap_info	*info,
 	int				(*query_fn)(struct xfs_trans *,
 						    struct xfs_getfsmap_info *,
@@ -591,16 +589,14 @@ __xfs_getfsmap_datadev(
 	xfs_fsblock_t			end_fsb;
 	xfs_agnumber_t			start_ag;
 	xfs_agnumber_t			end_ag;
-	xfs_daddr_t			eofs;
+	uint64_t			eofs;
 	int				error = 0;
 
 	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
-	if (keys[1].fmr_physical >= eofs)
-		keys[1].fmr_physical = eofs - 1;
 	start_fsb = XFS_DADDR_TO_FSB(mp, keys[0].fmr_physical);
-	end_fsb = XFS_DADDR_TO_FSB(mp, keys[1].fmr_physical);
+	end_fsb = XFS_DADDR_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
 
 	/*
 	 * Convert the fsmap low/high keys to AG based keys.  Initialize
@@ -728,7 +724,7 @@ xfs_getfsmap_datadev_rmapbt_query(
 STATIC int
 xfs_getfsmap_datadev_rmapbt(
 	struct xfs_trans		*tp,
-	struct xfs_fsmap		*keys,
+	const struct xfs_fsmap		*keys,
 	struct xfs_getfsmap_info	*info)
 {
 	info->missing_owner = XFS_FMR_OWN_FREE;
@@ -763,7 +759,7 @@ xfs_getfsmap_datadev_bnobt_query(
 STATIC int
 xfs_getfsmap_datadev_bnobt(
 	struct xfs_trans		*tp,
-	struct xfs_fsmap		*keys,
+	const struct xfs_fsmap		*keys,
 	struct xfs_getfsmap_info	*info)
 {
 	struct xfs_alloc_rec_incore	akeys[2];

