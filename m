Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DD3C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 23:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbiGGXxH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 19:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236983AbiGGXxF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 19:53:05 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0901C6D551
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 16:53:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 88C7762C519
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 09:53:03 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9bIs-00FoXk-39
        for linux-xfs@vger.kernel.org; Fri, 08 Jul 2022 09:53:02 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o9bIs-004bX9-1p
        for linux-xfs@vger.kernel.org;
        Fri, 08 Jul 2022 09:53:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: remove a superflous hash lookup when inserting new buffers
Date:   Fri,  8 Jul 2022 09:52:58 +1000
Message-Id: <20220707235259.1097443-6-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707235259.1097443-1-david@fromorbit.com>
References: <20220707235259.1097443-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62c771df
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=G2QS8jrCtKGMujaOrHwA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Currently on the slow path insert we repeat the initial hash table
lookup before we attempt the insert, resulting in a two traversals
of the hash table to ensure the insert is valid. The rhashtable API
provides a method for an atomic lookup and insert operation, so we
can avoid one of the hash table traversals by using this method.

Adapted from a large patch containing this optimisation by Christoph
Hellwig.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 374c4e508b12..1a6542e01bec 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -623,8 +623,15 @@ xfs_buf_find_insert(
 	}
 
 	spin_lock(&pag->pag_buf_lock);
-	bp = rhashtable_lookup(&pag->pag_buf_hash, cmap, xfs_buf_hash_params);
+	bp = rhashtable_lookup_get_insert_fast(&pag->pag_buf_hash,
+			&new_bp->b_rhash_head, xfs_buf_hash_params);
+	if (IS_ERR(bp)) {
+		error = PTR_ERR(bp);
+		spin_unlock(&pag->pag_buf_lock);
+		goto out_free_buf;
+	}
 	if (bp) {
+		/* found an existing buffer */
 		atomic_inc(&bp->b_hold);
 		spin_unlock(&pag->pag_buf_lock);
 		error = xfs_buf_find_lock(bp, flags);
@@ -635,10 +642,8 @@ xfs_buf_find_insert(
 		goto out_free_buf;
 	}
 
-	/* The buffer keeps the perag reference until it is freed. */
+	/* The new buffer keeps the perag reference until it is freed. */
 	new_bp->b_pag = pag;
-	rhashtable_insert_fast(&pag->pag_buf_hash, &new_bp->b_rhash_head,
-			       xfs_buf_hash_params);
 	spin_unlock(&pag->pag_buf_lock);
 	*bpp = new_bp;
 	return 0;
-- 
2.36.1

