Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6974580D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:03:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1AC1AC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:25 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id YAQg9Op9Eb1FM0zP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:22 -0800 (PST)
Subject: [PATCH 62/76] xfs: clear inode reflink flag when freeing blocks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:03:19 -0800
Message-ID: <20151219090319.12713.43908.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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
index 983d8f6..dd5a2f7 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1390,6 +1390,14 @@ xfs_free_file_space(
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
 		error = xfs_bmap_finish(&tp, &free_list, &committed, NULL);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 55a7e00..a323631 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1613,6 +1613,12 @@ xfs_itruncate_extents(
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
