Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF232C43334
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 23:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236957AbiGGXxE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 19:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbiGGXxE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 19:53:04 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A44B56D55D
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 16:53:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BDA4962C54A
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 09:53:02 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9bIs-00FoXg-21
        for linux-xfs@vger.kernel.org; Fri, 08 Jul 2022 09:53:02 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o9bIs-004bX3-0p
        for linux-xfs@vger.kernel.org;
        Fri, 08 Jul 2022 09:53:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] xfs: reduce the number of atomic when locking a buffer after lookup
Date:   Fri,  8 Jul 2022 09:52:57 +1000
Message-Id: <20220707235259.1097443-5-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707235259.1097443-1-david@fromorbit.com>
References: <20220707235259.1097443-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62c771de
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=9nwY-OdOpHHNpxg6w_QA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Avoid an extra atomic operation in the non-trylock case by only
doing a trylock if the XBF_TRYLOCK flag is set. This follows the
pattern in the IO path with NOWAIT semantics where the
"trylock-fail-lock" path showed 5-10% reduced throughput compared to
just using single lock call when not under NOWAIT conditions. So
make that same change here, too.

See commit 942491c9e6d6 ("xfs: fix AIM7 regression") for details.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 81ca951b451a..374c4e508b12 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -534,11 +534,12 @@ xfs_buf_find_lock(
 	struct xfs_buf          *bp,
 	xfs_buf_flags_t		flags)
 {
-	if (!xfs_buf_trylock(bp)) {
-		if (flags & XBF_TRYLOCK) {
+	if (flags & XBF_TRYLOCK) {
+		if (!xfs_buf_trylock(bp)) {
 			XFS_STATS_INC(bp->b_mount, xb_busy_locked);
 			return -EAGAIN;
 		}
+	} else {
 		xfs_buf_lock(bp);
 		XFS_STATS_INC(bp->b_mount, xb_get_locked_waited);
 	}
-- 
2.36.1

