Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34428 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfE2A0A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 May 2019 20:26:00 -0400
Date: Tue, 28 May 2019 17:25:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: inode btree scrubber should calculate im_boffset
 correctly
Message-ID: <20190529002545.GB5231@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

The im_boffset field is in units of bytes, whereas XFS_INO_OFFSET
returns a value in units of inodes.  Convert the units so that scrub on
a 64k-block filesystem works correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 693eb51f5efb..9b47117180cb 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -252,7 +252,8 @@ xchk_iallocbt_check_cluster(
 	ir_holemask = (irec->ir_holemask & cluster_mask);
 	imap.im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
 	imap.im_len = XFS_FSB_TO_BB(mp, mp->m_blocks_per_cluster);
-	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino);
+	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino) <<
+			mp->m_sb.sb_inodelog;
 
 	if (imap.im_boffset != 0 && cluster_base != 0) {
 		ASSERT(imap.im_boffset == 0 || cluster_base == 0);
