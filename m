Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731243AbfHOMzk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Aug 2019 08:55:40 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DEFE4308A958
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2019 12:55:40 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D7065DA8B
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2019 12:55:40 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 3/4] xfs: randomly fall back to near mode lookup algorithm in debug mode
Date: Thu, 15 Aug 2019 08:55:37 -0400
Message-Id: <20190815125538.49570-4-bfoster@redhat.com>
In-Reply-To: <20190815125538.49570-1-bfoster@redhat.com>
References: <20190815125538.49570-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The last block scan is the dominant near mode allocation algorithm
for a newer filesystem with fewer, large free extents. Add debug
mode logic to randomly fall back to lookup mode to improve
regression test coverage.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7753b61ba532..d550aa5597bf 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1266,6 +1266,7 @@ xfs_alloc_ag_vextent_near(
 	int			i;
 	xfs_agblock_t		bno;
 	xfs_extlen_t		len;
+	bool			lastblock;
 
 	/* handle unitialized agbno range so caller doesn't have to */
 	if (!args->min_agbno && !args->max_agbno)
@@ -1291,7 +1292,12 @@ xfs_alloc_ag_vextent_near(
 	 * Otherwise run the optimized lookup search algorithm from the current
 	 * location to the end of the tree.
 	 */
-	if (xfs_btree_islastblock(acur.cnt, 0)) {
+	lastblock = xfs_btree_islastblock(acur.cnt, 0);
+#ifdef DEBUG
+	if (lastblock)
+		lastblock = prandom_u32() & 1;
+#endif
+	if (lastblock) {
 		int	j;
 
 		trace_xfs_alloc_cur_lastblock(args);
-- 
2.20.1
