Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DA0C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A607561A45
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhCZAWo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhCZAWR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:22:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15B92619D3;
        Fri, 26 Mar 2021 00:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718137;
        bh=SVNj8KRoxD3nH0o7MP5NORya3u81qIzy+rkc1BxipCE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C0gSltf7l9D3lWwuTimGFcE6qR1i0g/YpaaDEafWZ28n3DTyWQ2oIPhRCnV52BnVo
         RTyKNLp20atAkM2JiJz9r/qJaqmvGgRX9OHyYFL2WvZy+TKshGfd6mtjN+B4Kd1eBK
         21OLuoR6MbsKBTYDCqmOu29z8mVSf9mn2mreBdEKZSULmzA1eyY/kZ1B6maR1ZEBY0
         Q8hZoM/I4aZ7YH3pwdNYIcI5UlVpBt8VyXuAoUh7ZG+0WVZLWh8rP8VSZdnS4eicgs
         /RIAUSPr1liMwHas4m0ffl0JASu2o6sr+Mlq1y/odn3L3fvgyh3+rYlC9lkbXLIr4C
         whDWw7Ywb3GMw==
Subject: [PATCH 5/9] xfs: force inode garbage collection before fallocate when
 space is low
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:22:16 -0700
Message-ID: <161671813674.622901.3730021302919248675.stgit@magnolia>
In-Reply-To: <161671810866.622901.16520335819131743716.stgit@magnolia>
References: <161671810866.622901.16520335819131743716.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Generally speaking, when a user calls fallocate, they're looking to
preallocate space in a file in the largest contiguous chunks possible.
If free space is low, it's possible that the free space will look
unnecessarily fragmented because there are unlinked inodes that are
holding on to space that we could allocate.  When this happens,
fallocate makes suboptimal allocation decisions for the sake of deleted
files, which doesn't make much sense, so scan the filesystem for dead
items to delete to try to avoid this.

Note that there are a handful of fstests that fill a filesystem, delete
just enough files to allow a single large allocation, and check that
fallocate actually gets the allocation.  These tests regress because the
test runs fallocate before the inode gc has a chance to run, so add this
behavior to maintain as much of the old behavior as possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e79e3d1ff38d..507d18418142 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -28,6 +28,7 @@
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_sb.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -727,6 +728,44 @@ xfs_free_eofblocks(
 	return error;
 }
 
+/*
+ * If we suspect that the target device is full enough that it isn't to be able
+ * to satisfy the entire request, try a non-sync inode inactivation scan to
+ * free up space.  While it's perfectly fine to fill a preallocation request
+ * with a bunch of short extents, we'd prefer to do the inactivation work now
+ * to combat long term fragmentation in new file data.  This is purely for
+ * optimization, so we don't take any blocking locks and we only look for space
+ * that is already on the reclaim list (i.e. we don't zap speculative
+ * preallocations).
+ */
+static int
+xfs_alloc_reclaim_inactive_space(
+	struct xfs_mount	*mp,
+	bool			is_rt,
+	xfs_filblks_t		allocatesize_fsb)
+{
+	struct xfs_perag	*pag;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_extlen_t		free;
+	xfs_agnumber_t		agno;
+
+	if (is_rt) {
+		if (sbp->sb_frextents * sbp->sb_rextsize >= allocatesize_fsb)
+			return 0;
+	} else {
+		for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+			pag = xfs_perag_get(mp, agno);
+			free = pag->pagf_freeblks;
+			xfs_perag_put(pag);
+
+			if (free >= allocatesize_fsb)
+				return 0;
+		}
+	}
+
+	return xfs_inodegc_free_space(mp, NULL);
+}
+
 int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
@@ -811,6 +850,11 @@ xfs_alloc_file_space(
 			rblocks = 0;
 		}
 
+		error = xfs_alloc_reclaim_inactive_space(mp, rt,
+				allocatesize_fsb);
+		if (error)
+			break;
+
 		/*
 		 * Allocate and setup the transaction.
 		 */

