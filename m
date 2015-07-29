Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0413329E0E
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:34:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7C5CFAC002
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 15:34:51 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mwMOvjYTimhvewtD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 15:34:50 -0700 (PDT)
Subject: [PATCH 17/24] xfs: clear inode reflink flag when freeing blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 Jul 2015 15:34:47 -0700
Message-ID: <20150729223447.17414.7298.stgit@birch.djwong.org>
In-Reply-To: <20150729223258.17414.91354.stgit@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Clear the inode reflink flag when freeing or truncating all blocks
in a file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |    8 ++++++++
 fs/xfs/xfs_inode.c     |    6 ++++++
 2 files changed, 14 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 345ea79..0091186 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1330,6 +1330,14 @@ xfs_free_file_space(
 		}
 
 		/*
+		 * Clear the reflink flag if we freed everything.
+		 */
+		if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
+			ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		}
+
+		/*
 		 * complete the transaction
 		 */
 		error = xfs_bmap_finish(&tp, &free_list, &committed);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3da9f4d..1d97238 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1566,6 +1566,12 @@ xfs_itruncate_extents(
 	}
 
 	/*
+	 * Clear the reflink flag if we truncated everything.
+	 */
+	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip))
+		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+
+	/*
 	 * Always re-log the inode so that our permanent transaction can keep
 	 * on rolling it forward in the log.
 	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
