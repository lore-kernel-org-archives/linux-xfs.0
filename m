Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3EB5C4743F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBAF061249
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhFGW1N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhFGW1N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jun 2021 18:27:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B18BE61185;
        Mon,  7 Jun 2021 22:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623104721;
        bh=OzsaTxmOGcLr1uqu9Y9wrb3NymgLpFGVwmejBehm+ek=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mIHhsgYEiMRQjH/nG0zMFwNuILKDZp4P2hOTFJ6k7pIPZA9GvhmVjizvMmZqaxVzO
         AthVChgLl2Q3MnrmQYKSjnVaTYkwI5822MxGRxV0gL9AWJDjJpYG7o7Igs8TKNVu5p
         xB92LeGLJzJ7eROBAwD1dkYj68pC5MjQAqIonv9LcGOqnz3fJqu7M3+q+Eqk2b4ZJQ
         50KSRK7Aip/YPkL8FWXC2xLTgFocS9zFalfbjmkd7w3GHdna1Mfk0/LRBH/SJKAkKd
         zvnXUsppo/nqzZaB895zPiyV1OQkIoDcPtz5MPfBVRy4cq7ezrYNhZxm2B4q13I482
         ZV3a9fboder9Q==
Subject: [PATCH 5/9] xfs: force inode garbage collection before fallocate when
 space is low
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Mon, 07 Jun 2021 15:25:21 -0700
Message-ID: <162310472140.3465262.3509717954267805085.stgit@locust>
In-Reply-To: <162310469340.3465262.504398465311182657.stgit@locust>
References: <162310469340.3465262.504398465311182657.stgit@locust>
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
 fs/xfs/xfs_bmap_util.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c    |    8 ++++++++
 fs/xfs/xfs_icache.h    |    1 +
 3 files changed, 52 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 997eb5c6e9b4..a1be77fe89d6 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -28,6 +28,8 @@
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -767,6 +769,43 @@ xfs_free_eofblocks(
 	return error;
 }
 
+/*
+ * If the target device (or some part of it) is full enough that it won't to be
+ * able to satisfy the entire request, try to free inactive files to free up
+ * space.  While it's perfectly fine to fill a preallocation request with a
+ * bunch of short extents, we prefer to slow down preallocation requests to
+ * combat long term fragmentation in new file data.
+ */
+static int
+xfs_alloc_consolidate_freespace(
+	struct xfs_inode	*ip,
+	xfs_filblks_t		wanted)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_agnumber_t		agno;
+
+	if (!xfs_has_inodegc_work(mp))
+		return 0;
+
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		if (sbp->sb_frextents * sbp->sb_rextsize >= wanted)
+			return 0;
+		goto free_space;
+	}
+
+	for_each_perag(mp, agno, pag) {
+		if (pag->pagf_freeblks >= wanted) {
+			xfs_perag_put(pag);
+			return 0;
+		}
+	}
+
+free_space:
+	return xfs_inodegc_free_space(mp, NULL);
+}
+
 int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
@@ -851,6 +890,10 @@ xfs_alloc_file_space(
 			rblocks = 0;
 		}
 
+		error = xfs_alloc_consolidate_freespace(ip, allocatesize_fsb);
+		if (error)
+			break;
+
 		/*
 		 * Allocate and setup the transaction.
 		 */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index a7ca6b988e29..8016e90b7b6d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1965,6 +1965,14 @@ xfs_inodegc_start(
 	xfs_inodegc_queue(mp);
 }
 
+/* Are there files waiting for inactivation? */
+bool
+xfs_has_inodegc_work(
+	struct xfs_mount	*mp)
+{
+	return radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG);
+}
+
 /* XFS Inode Cache Walking Code */
 
 /*
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d03d46f83316..1f693e7fe6c8 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -85,6 +85,7 @@ void xfs_inodegc_flush(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
 int xfs_inodegc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icw);
+bool xfs_has_inodegc_work(struct xfs_mount *mp);
 
 /*
  * Process all pending inode inactivations immediately (sort of) so that a

