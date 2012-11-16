Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6ia8k067459 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:44:36 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ANu9b6e5M6jBK9so (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:46:41 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6kem7004223
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:46:41 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6keR7024318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:46:40 GMT
Received: from abhmt120.oracle.com (abhmt120.oracle.com [141.146.116.72])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6keNY005614 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:46:40 -0600
Message-ID: <50A5E14B.4030800@oracle.com>
Date: Fri, 16 Nov 2012 14:46:35 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 11/15] xfs: Introduce a helper to check if an AG is empty
	or not
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We need to check if an affected AG is empty or not during FS shrink, this is a helper could be used for this purpose.

Maybe it's better to isolate AG related routines to a dedicated file: xfs_ag.c?
 

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_fsops.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 029ab6d..6623d9a 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -614,6 +614,98 @@ xfs_growfs_log(
 }
 
 /*
+ * Get the reserved blocks of metadatas per AG which are includes:
+ * 	Superblock (1 sector)
+ *	AG free block info (1 sector)
+ *	AG inode B+tree info (1 sector)
+ *	AG internal free list (1 sector)
+ *	Root of inode B+tree (1 block)
+ *	Root of free space B+tree, key is block number (1 block)
+ *	Root of free space B+tree, key is block count  (1 block)
+ *	Free list (4 blocks)
+ * The reserved block number of the aboves can be fetched via:
+ *	XFS_PREALLOC_BLOCKS(mp).
+ *
+ * The left blocks are used for Primary AG only.
+ * - Inodes (64 inodes)
+ */
+static xfs_extlen_t
+xfs_ag_metadata_blocks(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno)
+{
+	xfs_extlen_t	mdblocks;
+
+	mdblocks = XFS_PREALLOC_BLOCKS(mp);
+	/*
+	 * For primary AG, we need to figure out how many blocks are
+	 * reserved for those 64 inodes which are used for the root
+	 * of inodes B+tree.
+	 */
+	if (agno == 0)
+		mdblocks += (64 / mp->m_sb.sb_inopblock);
+
+	return mdblocks;
+}
+
+/*
+ * An empty AG means that there has no data/inodes allocated
+ * at it except those metadata blocks, and the agi_count should
+ * be ZERO.
+ */
+static int
+xfs_ag_is_empty(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno,
+	bool		*empty)
+{
+	xfs_extlen_t	agblocks;
+	xfs_extlen_t	agfblocks;
+	xfs_extlen_t	agmblocks;
+	xfs_extlen_t	agicount;
+	xfs_agf_t	*agf;
+	xfs_agi_t	*agi;
+	xfs_buf_t	*bp;
+	int		error = 0;
+
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			 XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
+			 XFS_FSS_TO_BB(mp, 1), 0);
+	if (!bp) {
+		error = XFS_ERROR(ENOMEM);
+		goto error0;
+	}
+	agf = XFS_BUF_TO_AGF(bp);
+	agmblocks = xfs_ag_metadata_blocks(mp, agno);
+	/*
+	 * The latest AG might has different size to others.
+	 */
+	if (agno == mp->m_sb.sb_agcount - 1)
+		agblocks = (be32_to_cpu(agf->agf_length) - agmblocks);
+	else
+		agblocks = mp->m_sb.sb_agblocks - agmblocks;
+	agfblocks = be32_to_cpu(agf->agf_freeblks);
+	xfs_buf_relse(bp);
+
+	bp = xfs_buf_get(mp->m_ddev_targp,
+			 XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
+			 XFS_FSS_TO_BB(mp, 1), 0);
+	if (!bp) {
+		error = XFS_ERROR(ENOMEM);
+		goto error0;
+	}
+	agi = XFS_BUF_TO_AGI(bp);
+	agicount = be32_to_cpu(agi->agi_count);
+	xfs_buf_relse(bp);
+
+	*empty = ((agblocks == agfblocks && agicount == 0) ?
+		  true : false);
+
+error0:
+	return error;
+}
+
+/*
  * exported through ioctl XFS_IOC_FSCOUNTS
  */
 
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
