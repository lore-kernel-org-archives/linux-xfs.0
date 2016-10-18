Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37415 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754955AbcJRXgi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2016 19:36:38 -0400
Date: Tue, 18 Oct 2016 16:36:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libxfs: clean up _calc_dquots_per_chunk
Message-ID: <20161018233635.GE20337@birch.djwong.org>
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

(This is the xfsprogs patch.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_dquot_buf.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 433abe4..aae8854 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -200,7 +200,6 @@ xfs_dquot_buf_verify_crc(
 		ndquots = mp->m_quotainfo->qi_dqperchunk;
 	else
 		ndquots = xfs_calc_dquots_per_chunk(bp->b_length);
-//					XFS_BB_TO_FSB(mp, bp->b_length));
 
 	for (i = 0; i < ndquots; i++, d++) {
 		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
