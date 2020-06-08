Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C7AC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 00:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66D252074B
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 00:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591660936;
	bh=Np/18VTjMQTgXAU2+Qtj3agACDKByRn0eKzYZu+q/Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=i2uyWsoExffeoLllWYqTdaQraaqOq74bdWSjiUnJ3WSI9j2iqiQAVepkGXhiGSrC/
	 vys5dcqakzJZtXbFu+wa4hkdiZyGAZuaobIPiEt62Inlepk2XkqdEwvE3EwpqpIqYv
	 rnK+XJNAWA4Z41wbMgt4DGN1fPksEzQbldNAu+gg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732682AbgFIACO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731260AbgFHXWI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jun 2020 19:22:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94DBF2074B;
        Mon,  8 Jun 2020 23:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658527;
        bh=Np/18VTjMQTgXAU2+Qtj3agACDKByRn0eKzYZu+q/Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vvb98FbaBfcZkxFx4hZvlgI1Lu5usKiuiXZJnh1QFE1jZV+JYq9rif2ndQIlwkzrU
         /Q5wJHFax1GcUZJY6boJQ84GkqWX7g8+4KdyH7dxZtei2bJdZeZUqvilJPD8ZHWIwy
         eSRjgVflxeAIQRtw1yRLOXHr//3l37jANnOEqTtI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 152/175] xfs: measure all contiguous previous extents for prealloc size
Date:   Mon,  8 Jun 2020 19:18:25 -0400
Message-Id: <20200608231848.3366970-152-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit f0322c7cc05eb23ef034775f9b39254cbd4f3678 ]

When we're estimating a new speculative preallocation length for an
extending write, we should walk backwards through the extent list to
determine the number of number of blocks that are physically and
logically contiguous with the write offset, and use that as an input to
the preallocation size computation.

This way, preallocation length is truly measured by the effectiveness of
the allocator in giving us contiguous allocations without being
influenced by the state of a given extent.  This fixes both the problem
where ZERO_RANGE within an EOF can reduce preallocation, and prevents
the unnecessary shrinkage of preallocation when delalloc extents are
turned into unwritten extents.

This was found as a regression in xfs/014 after changing delalloc writes
to create unwritten extents during writeback.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iomap.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f780e223b118..2edcb09690f6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -397,15 +397,17 @@ xfs_iomap_prealloc_size(
 	loff_t			count,
 	struct xfs_iext_cursor	*icur)
 {
+	struct xfs_iext_cursor	ncur = *icur;
+	struct xfs_bmbt_irec	prev, got;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	struct xfs_bmbt_irec	prev;
-	int			shift = 0;
 	int64_t			freesp;
 	xfs_fsblock_t		qblocks;
-	int			qshift = 0;
 	xfs_fsblock_t		alloc_blocks = 0;
+	xfs_extlen_t		plen;
+	int			shift = 0;
+	int			qshift = 0;
 
 	if (offset + count <= XFS_ISIZE(ip))
 		return 0;
@@ -420,7 +422,7 @@ xfs_iomap_prealloc_size(
 	 */
 	if ((mp->m_flags & XFS_MOUNT_DFLT_IOSIZE) ||
 	    XFS_ISIZE(ip) < XFS_FSB_TO_B(mp, mp->m_dalign) ||
-	    !xfs_iext_peek_prev_extent(ifp, icur, &prev) ||
+	    !xfs_iext_prev_extent(ifp, &ncur, &prev) ||
 	    prev.br_startoff + prev.br_blockcount < offset_fsb)
 		return mp->m_writeio_blocks;
 
@@ -433,16 +435,28 @@ xfs_iomap_prealloc_size(
 	 * preallocation size.
 	 *
 	 * If the extent is a hole, then preallocation is essentially disabled.
-	 * Otherwise we take the size of the preceding data extent as the basis
-	 * for the preallocation size. If the size of the extent is greater than
-	 * half the maximum extent length, then use the current offset as the
-	 * basis. This ensures that for large files the preallocation size
-	 * always extends to MAXEXTLEN rather than falling short due to things
-	 * like stripe unit/width alignment of real extents.
+	 * Otherwise we take the size of the preceding data extents as the basis
+	 * for the preallocation size. Note that we don't care if the previous
+	 * extents are written or not.
+	 *
+	 * If the size of the extents is greater than half the maximum extent
+	 * length, then use the current offset as the basis. This ensures that
+	 * for large files the preallocation size always extends to MAXEXTLEN
+	 * rather than falling short due to things like stripe unit/width
+	 * alignment of real extents.
 	 */
-	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
-		alloc_blocks = prev.br_blockcount << 1;
-	else
+	plen = prev.br_blockcount;
+	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
+		if (plen > MAXEXTLEN / 2 ||
+		    isnullstartblock(got.br_startblock) ||
+		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
+		    got.br_startblock + got.br_blockcount != prev.br_startblock)
+			break;
+		plen += got.br_blockcount;
+		prev = got;
+	}
+	alloc_blocks = plen * 2;
+	if (alloc_blocks > MAXEXTLEN)
 		alloc_blocks = XFS_B_TO_FSB(mp, offset);
 	if (!alloc_blocks)
 		goto check_writeio;
-- 
2.25.1

