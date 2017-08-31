Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25074 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbdHaUNC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:13:02 -0400
Date: Thu, 31 Aug 2017 13:12:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_repair: take the ag_lock before recording rmap for a
 bmbt record
Message-ID: <20170831201255.GP3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: matorola@gmail.com, xfs <linux-xfs@vger.kernel.org>

When the (threaded) inode scanner iterates the blocks of a bmbt tree and
wants to record the bmbt blocks in the in-core rmap database, we have to
take the ag_lock for the AG that the bmbt block is in, or else we can
accidentally corrupt the rmap slab by calling slab_add from two threads.

Reported-by: matorola@gmail.com
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/scan.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/repair/scan.c b/repair/scan.c
index 6c9f5e7..ccf60a6 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -386,7 +386,10 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 
 	/* Record BMBT blocks in the reverse-mapping data. */
 	if (check_dups && collect_rmaps) {
+		agno = XFS_FSB_TO_AGNO(mp, bno);
+		pthread_mutex_lock(&ag_locks[agno].lock);
 		error = rmap_add_bmbt_rec(mp, ino, whichfork, bno);
+		pthread_mutex_unlock(&ag_locks[agno].lock);
 		if (error)
 			do_error(
 _("couldn't add inode %"PRIu64" bmbt block %"PRIu64" reverse-mapping data."),
