Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C148C4321E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Dec 2022 00:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiLAAVm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiLAAVl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2022 19:21:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68B0D2
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 16:21:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ED6D60DFB
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 00:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B04C433C1;
        Thu,  1 Dec 2022 00:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669854099;
        bh=0gvgo88ptiFXxPpSGD1uWAvFCQD1a49r6TOT3jrwSkk=;
        h=Date:From:To:Cc:Subject:From;
        b=kAlSnY9VAbAcRmUnmUaACz6nI2ayZyrWnMXme6KNHKv9EpX26c7wsT0vKb8lqQ8KH
         nB0HPhcbLGLAflbVnaBFPE2gYJ7bo052s/78we5rmeAcOJg83m1n4Q84tqa9McskiL
         r7zI19qrrwAi/2QRHn10XRuaLJBKPz0K4Vs4cltZptQXuO1LF6OTx9HHNjgkSIJMLY
         iWkfUqBTOALDGNtdK7u7LTU0zMtupB/+ZFwKoUcAd6VP3r1ezDMS9CFTiHdnyjns/d
         JcwvahjYxrNa5mCBpCzC1ql31z6u3BCdl8f5pDqkBC5937prrwaS6pxpFtkb4oMflr
         RaiJX9DaPvbEw==
Date:   Wed, 30 Nov 2022 16:21:39 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: invalidate xfs_bufs when allocating cow extents
Message-ID: <Y4fzk0YCTA9qC45l@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While investigating test failures in xfs/17[1-3] in alwayscow mode, I
noticed through code inspection that xfs_bmap_alloc_userdata isn't
setting XFS_ALLOC_USERDATA when allocating extents for a file's CoW
fork.  COW staging extents should be flagged as USERDATA, since user
data are persisted to these blocks before being remapped into a file.

This mis-classification has a few impacts on the behavior of the system.
First, the filestreams allocator is supposed to keep allocating from a
chosen AG until it runs out of space in that AG.  However, it only does
that for USERDATA allocations, which means that COW allocations aren't
tied to the filestreams AG.  Fortunately, few people use filestreams, so
nobody's noticed.

A more serious problem is that xfs_alloc_ag_vextent_small looks for a
buffer to invalidate *if* the USERDATA flag is set and the AG is so full
that the allocation had to come from the AGFL because the cntbt is
empty.  The consequences of not invalidating the buffer are severe --
if the AIL incorrectly checkpoints a buffer that is now being used to
store user data, that action will clobber the user's written data.

Fix filestreams and yet another data corruption vector by flagging COW
allocations as USERDATA.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 56b9b7db38bb..0d56a8d862e8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4058,7 +4058,7 @@ xfs_bmap_alloc_userdata(
 	 * the busy list.
 	 */
 	bma->datatype = XFS_ALLOC_NOBUSY;
-	if (whichfork == XFS_DATA_FORK) {
+	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
 		bma->datatype |= XFS_ALLOC_USERDATA;
 		if (bma->offset == 0)
 			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
