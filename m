Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17626 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964775AbcI1C6Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:58:25 -0400
Subject: [PATCH 44/63] xfs: swap inode reflink flags when swapping inode
 extents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:58:19 -0700
Message-ID: <147503149954.30303.17772878397099459623.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

When we're swapping the extents of two inodes, be sure to swap the
reflink inode flag too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 427e824..6cf5a76 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1647,6 +1647,8 @@ xfs_swap_extents(
 	int		taforkblks = 0;
 	__uint64_t	tmp;
 	int		lock_flags;
+	struct xfs_ifork	*cowfp;
+	__uint64_t	f;
 
 	/* XXX: we can't do this with rmap, will fix later */
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
@@ -1860,6 +1862,19 @@ xfs_swap_extents(
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
 

