Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 63C3C7DDA
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:36:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2847A8F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:36:36 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id HHlZ1ztlKT4b4pKa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:36:34 -0700 (PDT)
Subject: [PATCH 42/71] xfs: cancel CoW reservations and clear inode reflink
	flag when freeing blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:36:30 -0700
Message-ID: <147216819041.867.11860151583478539823.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

When we're freeing blocks (truncate, punch, etc.), clear all CoW
reservations in the range being freed.  If the file block count
drops to zero, also clear the inode reflink flag.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0c25a76..8c971fd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -49,6 +49,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_reflink.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -1586,6 +1587,18 @@ xfs_itruncate_extents(
 			goto out;
 	}
 
+	/* Remove all pending CoW reservations. */
+	error = xfs_reflink_cancel_cow_blocks(ip, &tp, first_unmap_block,
+			last_block);
+	if (error)
+		goto out;
+
+	/*
+	 * Clear the reflink flag if we truncated everything.
+	 */
+	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip))
+		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+
 	/*
 	 * Always re-log the inode so that our permanent transaction can keep
 	 * on rolling it forward in the log.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
