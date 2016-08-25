Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9FA29827D
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:53:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14EEAAC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:53:02 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3MT4H9FDIWk4W0jO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:53:01 -0700 (PDT)
Subject: [PATCH 59/71] xfs_repair: fix get_agino_buf to avoid corrupting inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:52:56 -0700
Message-ID: <147216917625.4420.10924742973800299704.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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

The inode buffering code tries to read inodes in units of chunks,
which are the larger of 8K or 1 FSB.  Each chunk gets its own xfs_buf,
which means that get_agino_buf must calculate the disk address of the
chunk and feed that to libxfs_readbuf in order to find the inode data
correctly.  The current code simply grabs the chunk for the start
inode and indexes from that, which corrupts memory because the start
inode and the target inode could be in different inode chunks.  That
causes the assert in rmap.c to blow when we clear the reflink flag.

(Also fix some minor errors in the debugging printfs.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c   |    8 +++---
 repair/dinode.c |   73 +++++++++++++++++++++++++++++++++----------------------
 repair/dinode.h |   12 +++++----
 3 files changed, 54 insertions(+), 39 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 533a064..9fcc319 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1038,9 +1038,9 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 	if (!error)
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 #ifdef IO_DEBUG
-	printf("%lx: %s: read %u bytes, error %d, blkno=0x%llx(0x%llx), %p\n",
-		pthread_self(), __FUNCTION__, , error,
-		(long long)LIBXFS_BBTOOFF64(blkno), (long long)blkno, bp);
+	printf("%lx: %s: read %lu bytes, error %d, blkno=%llu(%llu), %p\n",
+		pthread_self(), __FUNCTION__, buf - (char *)bp->b_addr, error,
+		(long long)LIBXFS_BBTOOFF64(bp->b_bn), (long long)bp->b_bn, bp);
 #endif
 	return error;
 }
@@ -1070,7 +1070,7 @@ libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
 	if (!error)
 		libxfs_readbuf_verify(bp, ops);
 
-#ifdef IO_DEBUG
+#ifdef IO_DEBUGX
 	printf("%lx: %s: read %lu bytes, error %d, blkno=%llu(%llu), %p\n",
 		pthread_self(), __FUNCTION__, buf - (char *)bp->b_addr, error,
 		(long long)LIBXFS_BBTOOFF64(bp->b_bn), (long long)bp->b_bn, bp);
diff --git a/repair/dinode.c b/repair/dinode.c
index 512a668..16e0a06 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -847,43 +847,58 @@ scan_bmbt_reclist(
 }
 
 /*
- * these two are meant for routines that read and work with inodes
- * one at a time where the inodes may be in any order (like walking
- * the unlinked lists to look for inodes).  the caller is responsible
- * for writing/releasing the buffer.
+ * Grab the buffer backing an inode.  This is meant for routines that
+ * work with inodes one at a time in any order (like walking the
+ * unlinked lists to look for inodes).  The caller is responsible for
+ * writing/releasing the buffer.
  */
-xfs_buf_t *
-get_agino_buf(xfs_mount_t	 *mp,
-		xfs_agnumber_t	agno,
-		xfs_agino_t	agino,
-		xfs_dinode_t	**dipp)
+struct xfs_buf *
+get_agino_buf(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino,
+	struct xfs_dinode	**dipp)
 {
-	ino_tree_node_t *irec;
-	xfs_buf_t *bp;
-	int size;
-
-	if ((irec = find_inode_rec(mp, agno, agino)) == NULL)
-		return(NULL);
+	struct xfs_buf		*bp;
+	int			cluster_size;
+	int			ino_per_cluster;
+	xfs_agino_t		cluster_agino;
+	xfs_daddr_t		cluster_daddr;
+	xfs_daddr_t		cluster_blks;
 
-	size = MAX(1, XFS_FSB_TO_BB(mp,
+	/*
+	 * Inode buffers have been read into memory in inode_cluster_size
+	 * chunks (or one FSB).  To find the correct buffer for an inode,
+	 * we must find the buffer for its cluster, add the appropriate
+	 * offset, and return that.
+	 */
+	cluster_size = MAX(mp->m_inode_cluster_size, mp->m_sb.sb_blocksize);
+	ino_per_cluster = cluster_size / mp->m_sb.sb_inodesize;
+	cluster_agino = agino & ~(ino_per_cluster - 1);
+	cluster_blks = XFS_FSB_TO_DADDR(mp, MAX(1,
 			mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog));
-	bp = libxfs_readbuf(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno,
-		XFS_AGINO_TO_AGBNO(mp, irec->ino_startnum)), size, 0,
-		&xfs_inode_buf_ops);
+	cluster_daddr = XFS_AGB_TO_DADDR(mp, agno,
+			XFS_AGINO_TO_AGBNO(mp, cluster_agino));
+
+#ifdef XR_INODE_TRACE
+	printf("cluster_size %d ipc %d clusagino %d daddr %lld sectors %lld\n",
+		cluster_size, ino_per_cluster, cluster_agino, cluster_daddr,
+		cluster_blks);
+#endif
+
+	bp = libxfs_readbuf(mp->m_dev, cluster_daddr, cluster_blks,
+			0, &xfs_inode_buf_ops);
 	if (!bp) {
 		do_warn(_("cannot read inode (%u/%u), disk block %" PRIu64 "\n"),
-			agno, irec->ino_startnum,
-			XFS_AGB_TO_DADDR(mp, agno,
-				XFS_AGINO_TO_AGBNO(mp, irec->ino_startnum)));
-		return(NULL);
+			agno, cluster_agino, cluster_daddr);
+		return NULL;
 	}
 
-	*dipp = xfs_make_iptr(mp, bp, agino -
-		XFS_OFFBNO_TO_AGINO(mp, XFS_AGINO_TO_AGBNO(mp,
-						irec->ino_startnum),
-		0));
-
-	return(bp);
+	*dipp = xfs_make_iptr(mp, bp, agino - cluster_agino);
+	ASSERT(!xfs_sb_version_hascrc(&mp->m_sb) ||
+			XFS_AGINO_TO_INO(mp, agno, agino) ==
+			be64_to_cpu((*dipp)->di_ino));
+	return bp;
 }
 
 /*
diff --git a/repair/dinode.h b/repair/dinode.h
index 5aebf5b..61d0736 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -113,12 +113,12 @@ void
 check_uncertain_aginodes(xfs_mount_t	*mp,
 			xfs_agnumber_t	agno);
 
-xfs_buf_t *
-get_agino_buf(xfs_mount_t	*mp,
-		xfs_agnumber_t	agno,
-		xfs_agino_t	agino,
-		xfs_dinode_t	**dipp);
-
+struct xfs_buf *
+get_agino_buf(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino,
+	struct xfs_dinode	**dipp);
 
 void dinode_bmbt_translation_init(void);
 char * get_forkname(int whichfork);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
