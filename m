Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 25D517EA6
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:27:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DD09F8F8050
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:27:09 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 1a0mxo4KXdgcm6VU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:27:08 -0700 (PDT)
Subject: [PATCH 086/119] xfs: cancel CoW reservations and clear inode
	reflink flag when freeing blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:27:03 -0700
Message-ID: <146612682326.12839.16807060939543436332.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

When we're freeing blocks (truncate, punch, etc.), clear all CoW
reservations in the range being freed.  If the file block count
drops to zero, also clear the inode reflink flag.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   34 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c     |   13 +++++++++++++
 2 files changed, 47 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 79225fb..9285111 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1147,6 +1147,32 @@ xfs_zero_remaining_bytes(
 	return error;
 }
 
+STATIC int
+xfs_free_cow_space(
+	struct xfs_inode	*ip,
+	struct xfs_trans	**tpp,
+	xfs_fileoff_t		startoffset_fsb,
+	xfs_fileoff_t		endoffset_fsb)
+{
+	int			error;
+
+	/* Remove any pending CoW reservations. */
+	error = xfs_reflink_cancel_cow_blocks(ip, tpp, startoffset_fsb,
+			endoffset_fsb);
+	if (error)
+		goto out;
+
+	/*
+	 * Clear the reflink flag if we freed everything.
+	 */
+	if (ip->i_d.di_nblocks == 0) {
+		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+		xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+	}
+out:
+	return error;
+}
+
 int
 xfs_free_file_space(
 	struct xfs_inode	*ip,
@@ -1294,6 +1320,14 @@ xfs_free_file_space(
 		if (error)
 			goto error0;
 
+		/* Remove CoW reservations and inode flag if applicable. */
+		if (done && xfs_is_reflink_inode(ip)) {
+			error = xfs_free_cow_space(ip, &tp, startoffset_fsb,
+					endoffset_fsb);
+			if (error)
+				goto error0;
+		}
+
 		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e08eaea..b8d3c4f 100644
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
