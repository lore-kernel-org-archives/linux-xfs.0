Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63200C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DF0264E07
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhA2CTE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 21:19:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhA2CTC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 21:19:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCA6764E0C;
        Fri, 29 Jan 2021 02:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886701;
        bh=rTYtZ3Ms2i+e7ecbSAy4uKOpFLj6N3Ofq1HXFtVzdT4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TmEUDv0q4iMRp0NTK381TfmPYz4g2TfS4Cn3Oz4cF/2yxnxS8HQSWAGKhFIVhc7B/
         Ij6B32/FtqDxANkxY72fxGyOSQtrh25AAVspaNGMC+tOKPF/KvG//H4geocSmb+R1c
         a0pBTR5fHooyNBHs/n+bUSkMj5erxlHdcIhvtXhOTbCY7VP+98p4xXC+uS3uUfcfLl
         ab5cQh90XIEVr3eVvT8SmPzWxx3COD8yjQWilcllZXiRSrt/7SoRzKyiXxkMyutPQa
         lboLeQXpolmcBWVZTVV41VySKLRlGnyNuUKMkiL4V3osEMvncC1J/k6KhDbI4LVed/
         3Y5oX3AswseBw==
Subject: [PATCH 06/12] xfs: try worst case space reservation upfront in
 xfs_reflink_remap_extent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Thu, 28 Jan 2021 18:18:20 -0800
Message-ID: <161188670052.1943978.11127149994884507361.stgit@magnolia>
In-Reply-To: <161188666613.1943978.971196931920996596.stgit@magnolia>
References: <161188666613.1943978.971196931920996596.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've converted xfs_reflink_remap_extent to use the new
xfs_trans_alloc_inode API, we can focus on its slightly unusual behavior
with regard to quota reservations.

Since it's valid to remap written blocks into a hole, we must be able to
increase the quota count by the number of blocks in the mapping.
However, the incore space reservation process requires us to supply an
asymptotic guess before we can gain exclusive access to resources.  We'd
like to reserve all the quota we need up front, but we also don't want
to fail a written -> allocated remap operation unnecessarily.

The solution is to make the remap_extents function call the transaction
allocation function twice.  The first time we ask to reserve enough
space and quota to handle the absolute worst case situation, but if that
fails, we can fall back to the old strategy: ask for the bare minimum
space reservation upfront and increase the quota reservation later if we
need to.

Later in this patchset we change the transaction and quota code to try
to reclaim space if we cannot reserve free space or quota.
Restructuring the remap_extent function in this manner means that if the
fallback increase fails, we can pass that back to the caller knowing
that the transaction allocation already tried freeing space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 27f875fa7a0d..086866f6e71f 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -991,6 +991,7 @@ xfs_reflink_remap_extent(
 	xfs_off_t		newlen;
 	int64_t			qdelta = 0;
 	unsigned int		resblks;
+	bool			quota_reserved = true;
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
 	int			iext_delta = 0;
@@ -1006,10 +1007,26 @@ xfs_reflink_remap_extent(
 	 * the same index in the bmap btree, so we only need a reservation for
 	 * one bmbt split if either thing is happening.  However, we haven't
 	 * locked the inode yet, so we reserve assuming this is the case.
+	 *
+	 * The first allocation call tries to reserve enough space to handle
+	 * mapping dmap into a sparse part of the file plus the bmbt split.  We
+	 * haven't locked the inode or read the existing mapping yet, so we do
+	 * not know for sure that we need the space.  This should succeed most
+	 * of the time.
+	 *
+	 * If the first attempt fails, try again but reserving only enough
+	 * space to handle a bmbt split.  This is the hard minimum requirement,
+	 * and we revisit quota reservations later when we know more about what
+	 * we're remapping.
 	 */
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
-			false, &tp);
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
+			resblks + dmap->br_blockcount, 0, false, &tp);
+	if (error == -EDQUOT || error == -ENOSPC) {
+		quota_reserved = false;
+		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
+				resblks, 0, false, &tp);
+	}
 	if (error)
 		goto out;
 
@@ -1076,7 +1093,7 @@ xfs_reflink_remap_extent(
 	 * before we started.  That should have removed all the delalloc
 	 * reservations, but we code defensively.
 	 */
-	if (!smap_real && dmap_written) {
+	if (!quota_reserved && !smap_real && dmap_written) {
 		error = xfs_trans_reserve_quota_nblks(tp, ip,
 				dmap->br_blockcount, 0, false);
 		if (error)

