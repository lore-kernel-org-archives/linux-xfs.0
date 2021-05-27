Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC18C4708E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 04:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4300061073
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 04:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhE0Exn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 00:53:43 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47000 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234405AbhE0Exl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 00:53:41 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 292351043897
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 14:52:06 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm804-005h1A-O9
        for linux-xfs@vger.kernel.org; Thu, 27 May 2021 14:52:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm804-004qgT-GT
        for linux-xfs@vger.kernel.org; Thu, 27 May 2021 14:52:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs: xfs_itruncate_extents has no extent count limitation
Date:   Thu, 27 May 2021 14:51:59 +1000
Message-Id: <20210527045202.1155628-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527045202.1155628-1-david@fromorbit.com>
References: <20210527045202.1155628-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=m78L4NlQDRkRyoOWfzwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Ever since we moved to freeing of extents by deferred operations,
we've already freed extents via individual transactions. Hence the
only limitation of how many extents we can mark for freeing in a
single xfs_bunmapi() call bound only by how many deferrals we want
to queue.

That is xfs_bunmapi() doesn't actually do any AG based extent
freeing, so there's no actually transaction reservation used up by
calling bunmapi with a large count of extents to be freed. RT
extents have always been freed directly by bunmapi, but that doesn't
require modification of large number of blocks as there are no
btrees to split.

Some callers of xfs_bunmapi assume that the extent count being freed
is bound by geometry (e.g. directories) and these can ask bunmapi to
free up to 64 extents in a single call. These functions just work as
tehy stand, so there's no reason for truncate to have a limit of
just two extents per bunmapi call anymore.

Increase XFS_ITRUNC_MAX_EXTENTS to 64 to match the number of extents
that can be deferred in a single loop to match what the directory
code already uses.

For realtime inodes, where xfs_bunmapi() directly frees extents,
leave the limit at 2 extents per loop as this is all the space that
the transaction reservation will cover.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0369eb22c1bb..db220eaa34b8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -40,9 +40,18 @@ kmem_zone_t *xfs_inode_zone;
 
 /*
  * Used in xfs_itruncate_extents().  This is the maximum number of extents
- * freed from a file in a single transaction.
+ * we will unmap and defer for freeing in a single call to xfs_bunmapi().
+ * Realtime inodes directly free extents in xfs_bunmapi(), so are bound
+ * by transaction reservation size to 2 extents.
  */
-#define	XFS_ITRUNC_MAX_EXTENTS	2
+static inline int
+xfs_itrunc_max_extents(
+	struct xfs_inode	*ip)
+{
+	if (XFS_IS_REALTIME_INODE(ip))
+		return 2;
+	return 64;
+}
 
 STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
 STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
@@ -1402,7 +1411,7 @@ xfs_itruncate_extents_flags(
 	while (unmap_len > 0) {
 		ASSERT(tp->t_firstblock == NULLFSBLOCK);
 		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
-				flags, XFS_ITRUNC_MAX_EXTENTS);
+				flags, xfs_itrunc_max_extents(ip));
 		if (error)
 			goto out;
 
-- 
2.31.1

