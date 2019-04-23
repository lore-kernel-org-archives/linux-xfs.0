Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50354 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727673AbfDWPHl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 11:07:41 -0400
Date: Tue, 23 Apr 2019 08:07:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: make tr_growdata a permanent transaction
Message-ID: <20190423150709.GG4676@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>

From: Brian Foster <bfoster@redhat.com>

The growdata transaction is used by growfs operations to increase
the data size of the filesystem. Part of this sequence involves
extending the size of the last preexisting AG in the fs, if
necessary. This is implemented by freeing the newly available
physical range to the AG.

tr_growdata is not a permanent transaction, however, and block
allocation transactions must be permanent to handle deferred frees
of AGFL blocks. If the grow operation extends an existing AG that
requires AGFL fixing, assert failures occur due to a populated dfops
list on a non-permanent transaction and the AGFL free does not
occur. This is reproduced (rarely) by xfs/104.

Change tr_growdata to a permanent transaction with a default log
count. This increases initial transaction reservation size, but
growfs is an infrequent and non-performance critical operation and
so should have minimal impact. Also add an assert in the block
allocation path to make this transaction requirement explicit and
obvious to future callers.

Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: add a comment to the assert]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index f99a7aefe418..83f4ee2afc49 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -876,9 +876,13 @@ xfs_trans_resv_calc(
 	resp->tr_sb.tr_logres = xfs_calc_sb_reservation(mp);
 	resp->tr_sb.tr_logcount = XFS_DEFAULT_LOG_COUNT;
 
+	/* growdata requires permanent res; it can free space to the last AG */
+	resp->tr_growdata.tr_logres = xfs_calc_growdata_reservation(mp);
+	resp->tr_growdata.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
+	resp->tr_growdata.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
 	/* The following transaction are logged in logical format */
 	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
-	resp->tr_growdata.tr_logres = xfs_calc_growdata_reservation(mp);
 	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
 	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
 	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
