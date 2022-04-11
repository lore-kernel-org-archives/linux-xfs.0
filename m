Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06D0C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239993AbiDKAeL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239706AbiDKAeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:06 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BF30120B8
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4FC5010CE88C
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEMT-6E
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pit-5H
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/17] xfs: convert scrub type flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:33 +1000
Message-Id: <20220411003147.2104423-4-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=625376f6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=48NU_tySdWvFSTkSyFUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned.

This touches xfs_fs.h so affects the user API, but the user API
fields are also unsigned so the flags should really be unsigned,
too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_fs.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 505533c43a92..52c9d8676fa3 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -699,34 +699,34 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_NR	25
 
 /* i: Repair this metadata. */
-#define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
+#define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
 
 /* o: Metadata object needs repair. */
-#define XFS_SCRUB_OFLAG_CORRUPT		(1 << 1)
+#define XFS_SCRUB_OFLAG_CORRUPT		(1u << 1)
 
 /*
  * o: Metadata object could be optimized.  It's not corrupt, but
  *    we could improve on it somehow.
  */
-#define XFS_SCRUB_OFLAG_PREEN		(1 << 2)
+#define XFS_SCRUB_OFLAG_PREEN		(1u << 2)
 
 /* o: Cross-referencing failed. */
-#define XFS_SCRUB_OFLAG_XFAIL		(1 << 3)
+#define XFS_SCRUB_OFLAG_XFAIL		(1u << 3)
 
 /* o: Metadata object disagrees with cross-referenced metadata. */
-#define XFS_SCRUB_OFLAG_XCORRUPT	(1 << 4)
+#define XFS_SCRUB_OFLAG_XCORRUPT	(1u << 4)
 
 /* o: Scan was not complete. */
-#define XFS_SCRUB_OFLAG_INCOMPLETE	(1 << 5)
+#define XFS_SCRUB_OFLAG_INCOMPLETE	(1u << 5)
 
 /* o: Metadata object looked funny but isn't corrupt. */
-#define XFS_SCRUB_OFLAG_WARNING		(1 << 6)
+#define XFS_SCRUB_OFLAG_WARNING		(1u << 6)
 
 /*
  * o: IFLAG_REPAIR was set but metadata object did not need fixing or
  *    optimization and has therefore not been altered.
  */
-#define XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED (1 << 7)
+#define XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED (1u << 7)
 
 #define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR)
 #define XFS_SCRUB_FLAGS_OUT	(XFS_SCRUB_OFLAG_CORRUPT | \
-- 
2.35.1

