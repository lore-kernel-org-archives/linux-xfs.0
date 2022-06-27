Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233F3CCA482
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 06:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiF0GIt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 02:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiF0GIs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 02:08:48 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F06F71148
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 23:08:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C02C810E78C0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 16:08:45 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5hvQ-00BZW5-7e
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 16:08:44 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5hvQ-0011gc-6H
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 16:08:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: remove a superflous hash lookup when inserting new buffers
Date:   Mon, 27 Jun 2022 16:08:40 +1000
Message-Id: <20220627060841.244226-6-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627060841.244226-1-david@fromorbit.com>
References: <20220627060841.244226-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62b9496d
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=G2QS8jrCtKGMujaOrHwA:9
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
---
 fs/xfs/xfs_buf.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 3bcb691c6d95..3461ef3ebc1c 100644
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

