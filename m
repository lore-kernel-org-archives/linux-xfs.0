Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49312 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935685AbcI3DKm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:10:42 -0400
Subject: [PATCH 45/63] xfs: swap inode reflink flags when swapping inode
 extents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:10:33 -0700
Message-ID: <147520503333.29434.7259139315186878604.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When we're swapping the extents of two inodes, be sure to swap the
reflink inode flag too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 6a95a3a..a835e12 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1652,6 +1652,8 @@ xfs_swap_extents(
 	int		taforkblks = 0;
 	__uint64_t	tmp;
 	int		lock_flags;
+	struct xfs_ifork	*cowfp;
+	__uint64_t	f;
 
 	/* XXX: we can't do this with rmap, will fix later */
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
@@ -1865,6 +1867,19 @@ xfs_swap_extents(
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
 

