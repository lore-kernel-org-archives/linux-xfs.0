Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6941B7E88
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:27:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B5048F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:27:59 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id WUpIqMY2znjDlB5J (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:27:57 -0700 (PDT)
Subject: [PATCH 093/119] xfs: swap inode reflink flags when swapping inode
	extents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:27:51 -0700
Message-ID: <146612687170.12839.4966658279995436156.stgit@birch.djwong.org>
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

When we're swapping the extents of two inodes, be sure to swap the
reflink inode flag too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 3d71a17..a5f5515 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1735,6 +1735,8 @@ xfs_swap_extents(
 	int		taforkblks = 0;
 	__uint64_t	tmp;
 	int		lock_flags;
+	struct xfs_ifork	*cowfp;
+	__uint64_t	f;
 
 	/* XXX: we can't do this with rmap, will fix later */
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
@@ -1948,6 +1950,19 @@ xfs_swap_extents(
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
