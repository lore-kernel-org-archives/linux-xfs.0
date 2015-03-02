Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D5E827F6A
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 07:28:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A7273304048
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 05:28:12 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ocfqXWlXyuOJ5UqM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 05:28:11 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t22DSAOC014717
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 2 Mar 2015 08:28:10 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t22DS9lw012626
	for <xfs@oss.sgi.com>; Mon, 2 Mar 2015 08:28:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v6 17/18] xfs: skip unallocated regions of inode chunks in
	xfs_ifree_cluster()
Date: Mon,  2 Mar 2015 08:28:07 -0500
Message-Id: <1425302888-4962-18-git-send-email-bfoster@redhat.com>
In-Reply-To: <1425302888-4962-1-git-send-email-bfoster@redhat.com>
References: <1425302888-4962-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs_ifree_cluster() is called to mark all in-memory inodes and inode
buffers as stale. This occurs after we've removed the inobt records and
dropped any references of inobt data. xfs_ifree_cluster() uses the
starting inode number to walk the namespace of inodes expected for a
single chunk a cluster buffer at a time. The cluster buffer disk
addresses are calculated by decoding the sequential inode numbers
expected from the chunk.

The problem with this approach is that if the inode chunk being removed
is a sparse chunk, not all of the buffer addresses that are calculated
as part of this sequence may be inode clusters. Attempting to acquire
the buffer based on expected inode characterstics (i.e., cluster length)
can lead to errors and is generally incorrect.

We already use a couple variables to carry requisite state from
xfs_difree() to xfs_ifree_cluster(). Rather than add a third, define a
new internal structure to carry the existing parameters through these
functions. Add an alloc field that represents the physical allocation
bitmap of inodes in the chunk being removed. Modify xfs_ifree_cluster()
to check each inode against the bitmap and skip the clusters that were
never allocated as real inodes on disk.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 17 +++++++----------
 fs/xfs/libxfs/xfs_ialloc.h | 10 ++++++++--
 fs/xfs/xfs_inode.c         | 28 ++++++++++++++++++++--------
 3 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 47be76e..c6d684e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1885,8 +1885,7 @@ xfs_difree_inobt(
 	struct xfs_buf			*agbp,
 	xfs_agino_t			agino,
 	struct xfs_bmap_free		*flist,
-	int				*deleted,
-	xfs_ino_t			*first_ino,
+	struct xfs_icluster		*xic,
 	struct xfs_inobt_rec_incore	*orec)
 {
 	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
@@ -1947,9 +1946,9 @@ xfs_difree_inobt(
 	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
 	    rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
-
-		*deleted = 1;
-		*first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
+		xic->deleted = 1;
+		xic->first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
+		xic->alloc = xfs_inobt_irec_to_allocmask(&rec);
 
 		/*
 		 * Remove the inode cluster from the AGI B+Tree, adjust the
@@ -1974,7 +1973,7 @@ xfs_difree_inobt(
 
 		xfs_difree_inode_chunk(mp, agno, &rec, flist);
 	} else {
-		*deleted = 0;
+		xic->deleted = 0;
 
 		error = xfs_inobt_update(cur, &rec);
 		if (error) {
@@ -2118,8 +2117,7 @@ xfs_difree(
 	struct xfs_trans	*tp,		/* transaction pointer */
 	xfs_ino_t		inode,		/* inode to be freed */
 	struct xfs_bmap_free	*flist,		/* extents to free */
-	int			*deleted,/* set if inode cluster was deleted */
-	xfs_ino_t		*first_ino)/* first inode in deleted cluster */
+	struct xfs_icluster	*xic)	/* cluster info if deleted */
 {
 	/* REFERENCED */
 	xfs_agblock_t		agbno;	/* block number containing inode */
@@ -2170,8 +2168,7 @@ xfs_difree(
 	/*
 	 * Fix up the inode allocation btree.
 	 */
-	error = xfs_difree_inobt(mp, tp, agbp, agino, flist, deleted, first_ino,
-				 &rec);
+	error = xfs_difree_inobt(mp, tp, agbp, agino, flist, xic, &rec);
 	if (error)
 		goto error0;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 4d4b702..12401fe 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -28,6 +28,13 @@ struct xfs_btree_cur;
 /* Move inodes in clusters of this size */
 #define	XFS_INODE_BIG_CLUSTER_SIZE	8192
 
+struct xfs_icluster {
+	bool		deleted;	/* record is deleted */
+	xfs_ino_t	first_ino;	/* first inode number */
+	uint64_t	alloc;		/* inode phys. allocation bitmap for
+					 * sparse chunks */
+};
+
 /* Calculate and return the number of filesystem blocks per inode cluster */
 static inline int
 xfs_icluster_size_fsb(
@@ -90,8 +97,7 @@ xfs_difree(
 	struct xfs_trans *tp,		/* transaction pointer */
 	xfs_ino_t	inode,		/* inode to be freed */
 	struct xfs_bmap_free *flist,	/* extents to free */
-	int		*deleted,	/* set if inode cluster was deleted */
-	xfs_ino_t	*first_ino);	/* first inode in deleted cluster */
+	struct xfs_icluster *ifree);	/* cluster info if deleted */
 
 /*
  * Return the location of the inode in imap, for mapping it into a buffer.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5a44f1c..7f80a17 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2252,9 +2252,9 @@ xfs_iunlink_remove(
  */
 STATIC int
 xfs_ifree_cluster(
-	xfs_inode_t	*free_ip,
-	xfs_trans_t	*tp,
-	xfs_ino_t	inum)
+	xfs_inode_t		*free_ip,
+	xfs_trans_t		*tp,
+	struct xfs_icluster	*xic)
 {
 	xfs_mount_t		*mp = free_ip->i_mount;
 	int			blks_per_cluster;
@@ -2267,13 +2267,26 @@ xfs_ifree_cluster(
 	xfs_inode_log_item_t	*iip;
 	xfs_log_item_t		*lip;
 	struct xfs_perag	*pag;
+	xfs_ino_t		inum;
 
+	inum = xic->first_ino;
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
 	blks_per_cluster = xfs_icluster_size_fsb(mp);
 	inodes_per_cluster = blks_per_cluster << mp->m_sb.sb_inopblog;
 	nbufs = mp->m_ialloc_blks / blks_per_cluster;
 
 	for (j = 0; j < nbufs; j++, inum += inodes_per_cluster) {
+		/*
+		 * The allocation bitmap tells us which inodes of the chunk were
+		 * physically allocated. Skip the cluster if an inode falls into
+		 * a sparse region.
+		 */
+		if ((xic->alloc & XFS_INOBT_MASK(inum - xic->first_ino)) == 0) {
+			ASSERT(((inum - xic->first_ino) %
+				inodes_per_cluster) == 0);
+			continue;
+		}
+
 		blkno = XFS_AGB_TO_DADDR(mp, XFS_INO_TO_AGNO(mp, inum),
 					 XFS_INO_TO_AGBNO(mp, inum));
 
@@ -2431,8 +2444,7 @@ xfs_ifree(
 	xfs_bmap_free_t	*flist)
 {
 	int			error;
-	int			delete;
-	xfs_ino_t		first_ino;
+	struct xfs_icluster	xic = { 0 };
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(ip->i_d.di_nlink == 0);
@@ -2448,7 +2460,7 @@ xfs_ifree(
 	if (error)
 		return error;
 
-	error = xfs_difree(tp, ip->i_ino, flist, &delete, &first_ino);
+	error = xfs_difree(tp, ip->i_ino, flist, &xic);
 	if (error)
 		return error;
 
@@ -2465,8 +2477,8 @@ xfs_ifree(
 	ip->i_d.di_gen++;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	if (delete)
-		error = xfs_ifree_cluster(ip, tp, first_ino);
+	if (xic.deleted)
+		error = xfs_ifree_cluster(ip, tp, &xic);
 
 	return error;
 }
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
