Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371B8C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjEZAl3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjEZAl2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:41:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A55EE
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:41:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67821615B8
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B67C433EF;
        Fri, 26 May 2023 00:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061685;
        bh=Jr6xNIGIMRyaRjn2XDK5Mg7sskO1qcQuRVglPtVzBIg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Vz+DTbvROdi+pjsyB4Csi6jkCSKWdq3hoRzuyxIGFCr4bukZ0V0EjcFlNLoVV8v3G
         VRfeGqKwmFrz9cY45rc8XvmAz2YI8gFBUPdjA7H8se9InPPAmWAZ0iG/e++V3tKrvM
         HJ6KxxyMhpmgEdbodAR6ioms8Ncw3M9PC+34HNk6YJoVQPN2BOybDlPoyiQu77gaqx
         BGJln04AHNz8SfGZpPNzINt4hPOcAqXxNu8sFv96PCzTRqAxD4ChD1U2SSEAultGDJ
         3Bl4WktjY3qjvDQVS6uPirrDO9cgp7mmfpPUKiHiPEaCVrmP5eg246hjeL02a94DpM
         aM7bW6ouj59+g==
Date:   Thu, 25 May 2023 17:41:25 -0700
Subject: [PATCH 1/7] xfs: fix interval filtering in multi-step fsmap queries
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055211.3727958.995533710406403787.stgit@frogsfrogsfrogs>
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

I noticed a bug in ranged GETFSMAP queries:

# xfs_io -c 'fsmap -vvvv' /opt
 EXT: DEV  BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET           TOTAL
   0: 8:80 [0..7]:               static fs metadata                  0  (0..7)                  8
<snip>
   9: 8:80 [192..223]:           137                0..31            0  (192..223)             32
# xfs_io -c 'fsmap -vvvv -d 208 208' /opt
#

That's not right -- we asked what block maps block 208, and we should've
received a mapping for inode 137 offset 16.  Instead, we get nothing.

The root cause of this problem is a mis-interaction between the fsmap
code and how btree ranged queries work.  xfs_btree_query_range returns
any btree record that overlaps with the query interval, even if the
record starts before or ends after the interval.  Similarly, GETFSMAP is
supposed to return a recordset containing all records that overlap the
range queried.

However, it's possible that the recordset is larger than the buffer that
the caller provided to convey mappings to userspace.  In /that/ case,
userspace is supposed to copy the last record returned to fmh_keys[0]
and call GETFSMAP again.  In this case, we do not want to return
mappings that we have already supplied to the caller.  The call to
xfs_btree_query_range is the same, but now we ignore any records that
start before fmh_keys[0].

Unfortunately, we didn't implement the filtering predicate correctly.
The predicate should only be called when we're calling back for more
records.  Accomplish this by setting info->low.rm_blockcount to a
nonzero value and ensuring that it is cleared as necessary.  As a
result, we no longer want to adjust dkeys[0] in the main setup function
because that's confusing.

This patch doesn't touch the logdev/rtbitmap backends because they have
bigger problems that will be addressed by subsequent patches.

Found via xfs/556 with parent pointers enabled.

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   67 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 59e7d1a14b67..6ddcda2c1218 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -162,7 +162,14 @@ struct xfs_getfsmap_info {
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	u64			missing_owner;	/* owner of holes */
 	u32			dev;		/* device id */
-	struct xfs_rmap_irec	low;		/* low rmap key */
+	/*
+	 * Low rmap key for the query.  If low.rm_blockcount is nonzero, this
+	 * is the second (or later) call to retrieve the recordset in pieces.
+	 * xfs_getfsmap_rec_before_start will compare all records retrieved
+	 * by the rmapbt query to filter out any records that start before
+	 * the last record.
+	 */
+	struct xfs_rmap_irec	low;
 	struct xfs_rmap_irec	high;		/* high rmap key */
 	bool			last;		/* last extent? */
 };
@@ -237,6 +244,17 @@ xfs_getfsmap_format(
 	xfs_fsmap_from_internal(rec, xfm);
 }
 
+static inline bool
+xfs_getfsmap_rec_before_start(
+	struct xfs_getfsmap_info	*info,
+	const struct xfs_rmap_irec	*rec,
+	xfs_daddr_t			rec_daddr)
+{
+	if (info->low.rm_blockcount)
+		return xfs_rmap_compare(rec, &info->low) < 0;
+	return false;
+}
+
 /*
  * Format a reverse mapping for getfsmap, having translated rm_startblock
  * into the appropriate daddr units.
@@ -260,7 +278,7 @@ xfs_getfsmap_helper(
 	 * Filter out records that start before our startpoint, if the
 	 * caller requested that.
 	 */
-	if (xfs_rmap_compare(rec, &info->low) < 0) {
+	if (xfs_getfsmap_rec_before_start(info, rec, rec_daddr)) {
 		rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
 		if (info->next_daddr < rec_daddr)
 			info->next_daddr = rec_daddr;
@@ -606,9 +624,27 @@ __xfs_getfsmap_datadev(
 	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
 	if (error)
 		return error;
-	info->low.rm_blockcount = 0;
+	info->low.rm_blockcount = XFS_BB_TO_FSBT(mp, keys[0].fmr_length);
 	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
 
+	/* Adjust the low key if we are continuing from where we left off. */
+	if (info->low.rm_blockcount == 0) {
+		/* empty */
+	} else if (XFS_RMAP_NON_INODE_OWNER(info->low.rm_owner) ||
+		   (info->low.rm_flags & (XFS_RMAP_ATTR_FORK |
+					  XFS_RMAP_BMBT_BLOCK |
+					  XFS_RMAP_UNWRITTEN))) {
+		info->low.rm_startblock += info->low.rm_blockcount;
+		info->low.rm_owner = 0;
+		info->low.rm_offset = 0;
+
+		start_fsb += info->low.rm_blockcount;
+		if (XFS_FSB_TO_DADDR(mp, start_fsb) >= eofs)
+			return 0;
+	} else {
+		info->low.rm_offset += info->low.rm_blockcount;
+	}
+
 	info->high.rm_startblock = -1U;
 	info->high.rm_owner = ULLONG_MAX;
 	info->high.rm_offset = ULLONG_MAX;
@@ -659,12 +695,8 @@ __xfs_getfsmap_datadev(
 		 * Set the AG low key to the start of the AG prior to
 		 * moving on to the next AG.
 		 */
-		if (pag->pag_agno == start_ag) {
-			info->low.rm_startblock = 0;
-			info->low.rm_owner = 0;
-			info->low.rm_offset = 0;
-			info->low.rm_flags = 0;
-		}
+		if (pag->pag_agno == start_ag)
+			memset(&info->low, 0, sizeof(info->low));
 
 		/*
 		 * If this is the last AG, report any gap at the end of it
@@ -901,21 +933,17 @@ xfs_getfsmap(
 	 * blocks could be mapped to several other files/offsets.
 	 * According to rmapbt record ordering, the minimal next
 	 * possible record for the block range is the next starting
-	 * offset in the same inode. Therefore, bump the file offset to
-	 * continue the search appropriately.  For all other low key
-	 * mapping types (attr blocks, metadata), bump the physical
-	 * offset as there can be no other mapping for the same physical
-	 * block range.
+	 * offset in the same inode. Therefore, each fsmap backend bumps
+	 * the file offset to continue the search appropriately.  For
+	 * all other low key mapping types (attr blocks, metadata), each
+	 * fsmap backend bumps the physical offset as there can be no
+	 * other mapping for the same physical block range.
 	 */
 	dkeys[0] = head->fmh_keys[0];
 	if (dkeys[0].fmr_flags & (FMR_OF_SPECIAL_OWNER | FMR_OF_EXTENT_MAP)) {
-		dkeys[0].fmr_physical += dkeys[0].fmr_length;
-		dkeys[0].fmr_owner = 0;
 		if (dkeys[0].fmr_offset)
 			return -EINVAL;
-	} else
-		dkeys[0].fmr_offset += dkeys[0].fmr_length;
-	dkeys[0].fmr_length = 0;
+	}
 	memset(&dkeys[1], 0xFF, sizeof(struct xfs_fsmap));
 
 	if (!xfs_getfsmap_check_keys(dkeys, &head->fmh_keys[1]))
@@ -960,6 +988,7 @@ xfs_getfsmap(
 		info.dev = handlers[i].dev;
 		info.last = false;
 		info.pag = NULL;
+		info.low.rm_blockcount = 0;
 		error = handlers[i].fn(tp, dkeys, &info);
 		if (error)
 			break;

