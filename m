Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49708 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753341AbdGGDbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jul 2017 23:31:45 -0400
Date: Thu, 6 Jul 2017 20:31:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] mkfs: set agblklog when we're verifying minimum log size
Message-ID: <20170707033138.GC4103@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>

In e5cc9d560a ("mkfs: set agsize prior to calculating minimum log
size"), we set the ag size in the superblock structure so that we can
calculate the maximum btree height correctly.  The btree heights are
used to calculate transaction reservation sizes; these sizes are used to
compute the minimum log length; and the minimum log length is checked by
the kernel.

Unfortunately, I didn't realize that some of the btree sizing functions
also depend on the agblklog (log2 of the ag size), so we've been
underestimating the minimum log length allowable, which results in mkfs
formatting filesystems that the kernel refuses to mount.

This can be trivially reproduced by formatting a small (~800M) volume
with rmap and reflink turned on.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/maxtrres.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index fba7818..69ec67a 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -54,6 +54,7 @@ max_trans_res(
 	sbp->sb_blocklog = blocklog;
 	sbp->sb_blocksize = 1 << blocklog;
 	sbp->sb_agblocks = agsize;
+	sbp->sb_agblklog = (uint8_t)libxfs_log2_roundup((unsigned int)agsize);
 	sbp->sb_inodelog = inodelog;
 	sbp->sb_inopblog = blocklog - inodelog;
 	sbp->sb_inodesize = 1 << inodelog;
