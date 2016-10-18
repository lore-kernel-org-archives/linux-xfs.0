Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37247 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756518AbcJRXgA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2016 19:36:00 -0400
Date: Tue, 18 Oct 2016 16:35:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libxfs: clean up _calc_dquots_per_chunk
Message-ID: <20161018233554.GD20337@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

The function xfs_calc_dquots_per_chunk takes a parameter in units
of basic blocks.  The kernel seems to get the units wrong, but
userspace got 'fixed' by commenting out the unnecessary conversion.
Fix both.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 3cc3cf7..ac9a003 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -191,8 +191,7 @@ xfs_dquot_buf_verify_crc(
 	if (mp->m_quotainfo)
 		ndquots = mp->m_quotainfo->qi_dqperchunk;
 	else
-		ndquots = xfs_calc_dquots_per_chunk(
-					XFS_BB_TO_FSB(mp, bp->b_length));
+		ndquots = xfs_calc_dquots_per_chunk(bp->b_length);
 
 	for (i = 0; i < ndquots; i++, d++) {
 		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
