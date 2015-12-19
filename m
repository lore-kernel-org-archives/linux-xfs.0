Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AAE3280D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:05:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BB8BAC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:17 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id GoDt6B1KFkT9iksG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:13 -0800 (PST)
Subject: [PATCH 03/53] repair: request inode buffers sized to fit one inode
	cluster
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:05:10 -0800
Message-ID: <20151219090510.14255.28756.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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

In get_agino_buf, grab inode buffers using the same size as the inode
processing code.  Since the inode processing code uses that same
buffer size, this means that get_agino_buf can serve requests from the
cache instead of pointlessly dropping the cache entry and screaming
about it.

(This function is currently unused, but the refink flag fixer code
wants to use it.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 43142d6..269f9d8 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -850,7 +850,8 @@ get_agino_buf(xfs_mount_t	 *mp,
 	if ((irec = find_inode_rec(mp, agno, agino)) == NULL)
 		return(NULL);
 
-	size = XFS_FSB_TO_BB(mp, MAX(1, XFS_INODES_PER_CHUNK/inodes_per_block));
+	size = MAX(1, XFS_FSB_TO_BB(mp,
+			mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog));
 	bp = libxfs_readbuf(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno,
 		XFS_AGINO_TO_AGBNO(mp, irec->ino_startnum)), size, 0,
 		&xfs_inode_buf_ops);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
