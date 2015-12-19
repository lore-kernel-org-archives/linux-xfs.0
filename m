Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2074580D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:04:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97556AC005
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:02 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id n3SuUadsKF25tQSD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:01 -0800 (PST)
Subject: [PATCH 68/76] xfs: swap inode reflink flags when swapping inode
	extents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:03:58 -0800
Message-ID: <20151219090358.12713.15718.stgit@birch.djwong.org>
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

When we're swapping the extents of two inodes, be sure to swap the
reflink inode flag too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 61d616e..7bee3c7 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1782,6 +1782,8 @@ xfs_swap_extents(
 	int		lock_flags;
 	xfs_fsblock_t	firstfsb;
 	struct xfs_trans_res	tres = {.tr_logres = 262144, .tr_logcount = 1, .tr_logflags = 0};
+	struct xfs_ifork	*cowfp;
+	__uint64_t	f;
 
 	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
 	if (!tempifp) {
@@ -2010,6 +2012,19 @@ xfs_swap_extents(
 		break;
 	}
 
+	/* Do we have to swap reflink flags? */
+	if ((ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK) ^
+	    (tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)) {
+		f = ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
+		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+		ip->i_d.di_flags2 |= tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
+		tip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+		tip->i_d.di_flags2 |= f & XFS_DIFLAG2_REFLINK;
+		cowfp = ip->i_cowfp;
+		ip->i_cowfp = tip->i_cowfp;
+		tip->i_cowfp = cowfp;
+	}
+
 	xfs_trans_log_inode(tp, ip,  src_log_flags);
 	xfs_trans_log_inode(tp, tip, target_log_flags);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
