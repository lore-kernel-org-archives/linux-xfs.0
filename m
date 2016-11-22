Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30951 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934372AbcKVSXY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 13:23:24 -0500
Date: Tue, 22 Nov 2016 10:23:16 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 09/16] xfs: fix btree cursor error cleanups
Message-ID: <20161122182316.GO16813@birch.djwong.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830453519.26713.18162571688396930045.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830453519.26713.18162571688396930045.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

From: Brian Foster <bfoster@redhat.com>

Source kernel commit: f307080a626569f89bc8fbad9f936b307aded877

The btree cursor cleanup function takes an error parameter that
affects how buffers are released from the cursor. All buffers are
released in the event of error. Several callers do not specify the
XFS_BTREE_ERROR flag in the event of error, however. This can cause
buffers to hang around locked or with an elevated hold count and
thus lead to umount hangs in the event of errors.

Fix up the xfs_btree_del_cursor() callers to pass XFS_BTREE_ERROR if
the cursor is being torn down due to error.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_ialloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index f0f243e..5c88b0b 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2232,7 +2232,7 @@ xfs_imap_lookup(
 	}
 
 	xfs_trans_brelse(tp, agbp);
-	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	if (error)
 		return error;
 
