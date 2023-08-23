Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13083EE49A5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Aug 2023 01:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjHWBAv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 21:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbjHWBAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2023 21:00:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63C1CF9
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2023 18:00:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 658F8637EE
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 01:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC7CC433C8;
        Wed, 23 Aug 2023 01:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692752447;
        bh=6HqDPEj2NEjSF3Q6LeuK9E5KsiGOb74P+ueStkYtU9w=;
        h=Date:From:To:Cc:Subject:From;
        b=ImL9/1TaMSv2MHQm46oPmyd//AxKHWLDGn5o6K+fdi0Vv42VaSKHtX3SXuZlNQ1lb
         RGoMS8jB/dxTpa8QWR8FH+YkMm9IprRKcULRTrmtlx86kw4YtQ9s2Fa0wHxkDg0F1B
         9jdd8WumcsWU5DvRYowj0DpLDezkeBtIBeZ67y9FsB4rgaG3N/cqo3JXsgVDNhin0l
         ReDp0VxLkrgMBuNhjX7A15V5vd/EU9yL7l/UoNya28JTA+rJas6Y+uxg3BTJtLXqcv
         nw/pqQJHiDqB3GL9LUPxGcmqs2A0Tf9h+8PkWF9KWGD40Crl+9kx5ZE1vYebyhp2jK
         /Js9GHwif5p0g==
Date:   Tue, 22 Aug 2023 18:00:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix an agbno overflow in __xfs_getfsmap_datadev
Message-ID: <20230823010046.GD11286@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Dave Chinner reported that xfs/273 fails if the AG size happens to be an
exact power of two.  I traced this to an agbno integer overflow when the
current GETFSMAP call is a continuation of a previous GETFSMAP call, and
the last record returned was non-shareable space at the end of an AG.

__xfs_getfsmap_datadev sets up a data device query by converting the
incoming fmr_physical into an xfs_fsblock_t and cracking it into an agno
and agbno pair.  In the (failing) case of where fmr_blockcount of the
low key is nonzero and the record was for a non-shareable extent, it
will add fmr_blockcount to start_fsb and info->low.rm_startblock.

If the low key was actually the last record for that AG, then this
addition causes info->low.rm_startblock to point beyond EOAG.  When the
rmapbt range query starts, it'll return an empty set, and fsmap moves on
to the next AG.

Or so I thought.  Remember how we added to start_fsb?

If agsize < 1<<agblklog, start_fsb points to the same AG as the original
fmr_physical from the low key.  We run the rmapbt query, which returns
nothing, so getfsmap zeroes info->low and moves on to the next AG.

If agsize == 1<<agblklog, start_fsb now points to the next AG.  We run
the rmapbt query on the next AG with the excessively large
rm_startblock.  If this next AG is actually the last AG, we'll set
info->high to EOFS (which is now has a lower rm_startblock than
info->low), and the ranged btree query code will return -EINVAL.  If
it's not the last AG, we ignore all records for the intermediate AGs.

Oops.

Fix this by decoding start_fsb into agno and agbno only after making
adjustments to start_fsb.  This means that info->low.rm_startblock will
always be set to a valid agbno, and we always start the rmapbt iteration
in the correct AG.

While we're at it, fix the predicate for determining if an fsmap record
represents non-shareable space to include file data on pre-reflink
filesystems.

Reported-by: Dave Chinner <david@fromorbit.com>
Fixes: 63ef7a35912dd ("xfs: fix interval filtering in multi-step fsmap queries")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 10403ba9b58f..736e5545f584 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -565,6 +565,19 @@ xfs_getfsmap_rtdev_rtbitmap(
 }
 #endif /* CONFIG_XFS_RT */
 
+static inline bool
+rmap_not_shareable(struct xfs_mount *mp, const struct xfs_rmap_irec *r)
+{
+	if (!xfs_has_reflink(mp))
+		return true;
+	if (XFS_RMAP_NON_INODE_OWNER(r->rm_owner))
+		return true;
+	if (r->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			   XFS_RMAP_UNWRITTEN))
+		return true;
+	return false;
+}
+
 /* Execute a getfsmap query against the regular data device. */
 STATIC int
 __xfs_getfsmap_datadev(
@@ -598,7 +611,6 @@ __xfs_getfsmap_datadev(
 	 * low to the fsmap low key and max out the high key to the end
 	 * of the AG.
 	 */
-	info->low.rm_startblock = XFS_FSB_TO_AGBNO(mp, start_fsb);
 	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
 	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
 	if (error)
@@ -608,12 +620,9 @@ __xfs_getfsmap_datadev(
 
 	/* Adjust the low key if we are continuing from where we left off. */
 	if (info->low.rm_blockcount == 0) {
-		/* empty */
-	} else if (XFS_RMAP_NON_INODE_OWNER(info->low.rm_owner) ||
-		   (info->low.rm_flags & (XFS_RMAP_ATTR_FORK |
-					  XFS_RMAP_BMBT_BLOCK |
-					  XFS_RMAP_UNWRITTEN))) {
-		info->low.rm_startblock += info->low.rm_blockcount;
+		/* No previous record from which to continue */
+	} else if (rmap_not_shareable(mp, &info->low)) {
+		/* Last record seen was an unshareable extent */
 		info->low.rm_owner = 0;
 		info->low.rm_offset = 0;
 
@@ -621,8 +630,10 @@ __xfs_getfsmap_datadev(
 		if (XFS_FSB_TO_DADDR(mp, start_fsb) >= eofs)
 			return 0;
 	} else {
+		/* Last record seen was a shareable file data extent */
 		info->low.rm_offset += info->low.rm_blockcount;
 	}
+	info->low.rm_startblock = XFS_FSB_TO_AGBNO(mp, start_fsb);
 
 	info->high.rm_startblock = -1U;
 	info->high.rm_owner = ULLONG_MAX;
