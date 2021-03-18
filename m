Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0158C4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C18A64F68
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhCRWe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:34:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232532AbhCRWeV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 18:34:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76CFC64E89;
        Thu, 18 Mar 2021 22:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616106861;
        bh=mGWdbAl7TGgwdLcTYl3tZPtKkrnHfhghD4tmWo25ukk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uuW65s6gbqjmQ5AYAnToeE7CqRPlB5annDiGu9MBOVl6xs5kUO87Ku9DwUqBp5uY7
         cCATUf8ycXMNcTYi1AV44XEYu2Yszrj3j38jM6z/txnGuelPWK+uZDrhli0n86oRYc
         2k3pBYdIGh6etc5cqL0mpR795j5h2MBcPmbSjdNntUpxlUd+4Bqf+WxnSVzGa3f/Y5
         PXYHhbdle3CaqiIUzlHp2GvU5xfmkpElENlRrggAv7nt15OrI32L9LUqa4n9rZUbbT
         GICrzR+YFuXFvqiKYcIfXU9rCBivIK+PT1jKe07g6l4y9nKfH14FEpVeBkJA6RsozE
         c9B4WH7bLOxAA==
Subject: [PATCH 4/7] xfs: force inode garbage collection before fallocate when
 space is low
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 18 Mar 2021 15:34:21 -0700
Message-ID: <161610686113.1887744.9067269399291399929.stgit@magnolia>
In-Reply-To: <161610683869.1887744.8863884017621115954.stgit@magnolia>
References: <161610683869.1887744.8863884017621115954.stgit@magnolia>
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
index d4ceba5370c7..f3fb64cc8a7c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -28,6 +28,7 @@
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_sb.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -720,6 +721,44 @@ xfs_free_eofblocks(
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
@@ -804,6 +843,11 @@ xfs_alloc_file_space(
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

