Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E7C537F59
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 01:17:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D21EB8F808E
	for <xfs@oss.sgi.com>; Tue, 21 Jan 2014 23:17:24 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CcaTvJ0xa1oGQZ18 for <xfs@oss.sgi.com>;
	Tue, 21 Jan 2014 23:17:21 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1W5s3p-0001YQ-Lh
	for xfs@oss.sgi.com; Wed, 22 Jan 2014 18:17:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1W5s3p-0002k3-Km
	for xfs@oss.sgi.com; Wed, 22 Jan 2014 18:17:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] repair: fix discontiguous directory block support
Date: Wed, 22 Jan 2014 18:17:13 +1100
Message-Id: <1390375033-10483-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1390375033-10483-1-git-send-email-david@fromorbit.com>
References: <1390375033-10483-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

xfs/291 tests fragmented multi-block directories, and xfs_repair
throws lots of lookup badness errors in phase 3:

        - agno = 1
7fa3d2758740: Badness in key lookup (length)
bp=(bno 0x1e040, len 4096 bytes) key=(bno 0x1e040, len 16384 bytes)
        - agno = 2
7fa3d2758740: Badness in key lookup (length)
bp=(bno 0x2d0e8, len 4096 bytes) key=(bno 0x2d0e8, len 16384 bytes)
7fa3d2758740: Badness in key lookup (length)
bp=(bno 0x2d068, len 4096 bytes) key=(bno 0x2d068, len 16384 bytes)
        - agno = 3
7fa3d2758740: Badness in key lookup (length)
bp=(bno 0x39130, len 4096 bytes) key=(bno 0x39130, len 16384 bytes)
7fa3d2758740: Badness in key lookup (length)
bp=(bno 0x391b0, len 4096 bytes) key=(bno 0x391b0, len 16384 bytes)
7fa3d2758740: Badness in key lookup (length)

This is because it is trying to read a directory buffer in full
(16k), but is finding a single 4k block in the cache instead.

The opposite is happening in phase 6 - phase 6 is trying to read 4k
buffers but is finding a 16k buffer there instead.

The problem is caused by the fact that directory buffers can be
represented as compound buffers or as individual buffers depending
on the code reading the directory blocks. The main problem is that
the IO prefetch code doesn't understand compound buffers, so teach
it about compound buffers to make the problem go away.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/prefetch.c | 121 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 100 insertions(+), 21 deletions(-)

diff --git a/repair/prefetch.c b/repair/prefetch.c
index d3491da..ab90b92 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -105,11 +105,12 @@ pf_start_io_workers(
 static void
 pf_queue_io(
 	prefetch_args_t		*args,
-	xfs_fsblock_t		fsbno,
-	int			blen,
+	struct xfs_buf_map	*map,
+	int			nmaps,
 	int			flag)
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
+	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, map[0].bm_bn);
 
 	/*
 	 * Never block on a buffer lock here, given that the actual repair
@@ -117,8 +118,7 @@ pf_queue_io(
 	 * the lock holder is either reading it from disk himself or
 	 * completely overwriting it this behaviour is perfectly fine.
 	 */
-	bp = libxfs_getbuf_flags(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
-			XFS_FSB_TO_BB(mp, blen), LIBXFS_GETBUF_TRYLOCK);
+	bp = libxfs_getbuf_map(mp->m_dev, map, nmaps, LIBXFS_GETBUF_TRYLOCK);
 	if (!bp)
 		return;
 
@@ -167,6 +167,14 @@ pf_read_bmbt_reclist(
 	xfs_bmbt_irec_t		irec;
 	xfs_dfilblks_t		cp = 0;		/* prev count */
 	xfs_dfiloff_t		op = 0;		/* prev offset */
+#define MAP_ARRAY_SZ 4
+	struct xfs_buf_map	map_array[MAP_ARRAY_SZ];
+	struct xfs_buf_map	*map = map_array;
+	int			max_extents = MAP_ARRAY_SZ;
+	int			nmaps = 0;;
+	unsigned int		len = 0;
+	int			ret = 0;
+
 
 	for (i = 0; i < numrecs; i++) {
 		libxfs_bmbt_disk_get_all(rp + i, &irec);
@@ -174,11 +182,11 @@ pf_read_bmbt_reclist(
 		if (((i > 0) && (op + cp > irec.br_startoff)) ||
 				(irec.br_blockcount == 0) ||
 				(irec.br_startoff >= fs_max_file_offset))
-			return 0;
+			goto out_free;
 
 		if (!verify_dfsbno(mp, irec.br_startblock) || !verify_dfsbno(mp,
 				irec.br_startblock + irec.br_blockcount - 1))
-			return 0;
+			goto out_free;
 
 		if (!args->dirs_only && ((irec.br_startoff +
 				irec.br_blockcount) >= mp->m_dirfreeblk))
@@ -188,18 +196,60 @@ pf_read_bmbt_reclist(
 		cp = irec.br_blockcount;
 
 		while (irec.br_blockcount) {
-			unsigned int	len;
+			unsigned int	bm_len;
 
 			pftrace("queuing dir extent in AG %d", args->agno);
 
-			len = (irec.br_blockcount > mp->m_dirblkfsbs) ?
-					mp->m_dirblkfsbs : irec.br_blockcount;
-			pf_queue_io(args, irec.br_startblock, len, B_DIR_META);
-			irec.br_blockcount -= len;
-			irec.br_startblock += len;
+			if (len + irec.br_blockcount >= mp->m_dirblkfsbs) {
+				bm_len = mp->m_dirblkfsbs - len;
+				len = 0;
+			} else {
+				len += irec.br_blockcount;
+				bm_len = irec.br_blockcount;
+			}
+
+			map[nmaps].bm_bn = XFS_FSB_TO_DADDR(mp,
+							irec.br_startblock);
+			map[nmaps].bm_len = XFS_FSB_TO_BB(mp, bm_len);
+			nmaps++;
+
+			if (len == 0) {
+				pf_queue_io(args, map, nmaps, B_DIR_META);
+				nmaps = 0;
+			}
+
+			irec.br_blockcount -= bm_len;
+			irec.br_startblock += bm_len;
+
+			/*
+			 * Handle very fragmented dir2 blocks with dynamically
+			 * allocated buffer maps.
+			 */
+			if (nmaps >= max_extents) {
+				struct xfs_buf_map *old_map = NULL;
+
+				if (map == map_array) {
+					old_map = map;
+					map = NULL;
+				}
+				max_extents *= 2;
+				map = realloc(map, max_extents * sizeof(*map));
+				if (map == NULL) {
+					do_error(
+			_("couldn't malloc dir2 buffer list\n"));
+					exit(1);
+				}
+				if (old_map)
+					memcpy(map, old_map, sizeof(map_array));
+			}
+
 		}
 	}
-	return 1;
+	ret = 1;
+out_free:
+	if (map != map_array)
+		free(map);
+	return ret;
 }
 
 /*
@@ -395,9 +445,28 @@ pf_read_inode_dirs(
 }
 
 /*
- * pf_batch_read must be called with the lock locked.
+ * Discontiguous buffers require multiple IOs to fill, so we can't use any
+ * linearising, hole filling algorithms on them to avoid seeks. Just remove them
+ * for the prefetch queue and read them straight into the cache and release
+ * them.
  */
+static void
+pf_read_discontig(
+	struct prefetch_args	*args,
+	struct xfs_buf		*bp)
+{
+	if (!btree_delete(args->io_queue, XFS_DADDR_TO_FSB(mp, bp->b_bn)))
+		do_error(_("prefetch corruption\n"));
+
+	pthread_mutex_unlock(&args->lock);
+	libxfs_readbufr_map(mp->m_ddev_targp, bp, 0);
+	libxfs_putbuf(bp);
+	pthread_mutex_lock(&args->lock);
+}
 
+/*
+ * pf_batch_read must be called with the lock locked.
+ */
 static void
 pf_batch_read(
 	prefetch_args_t		*args,
@@ -426,8 +495,15 @@ pf_batch_read(
 			max_fsbno = fsbno + pf_max_fsbs;
 		}
 		while (bplist[num] && num < MAX_BUFS && fsbno < max_fsbno) {
-			if (which != PF_META_ONLY ||
-			    !B_IS_INODE(XFS_BUF_PRIORITY(bplist[num])))
+			/*
+			 * Handle discontiguous buffers outside the seek
+			 * optimised IO loop below.
+			 */
+			if ((bplist[num]->b_flags & LIBXFS_B_DISCONTIG)) {
+				pf_read_discontig(args, bplist[num]);
+				bplist[num] = NULL;
+			} else if (which != PF_META_ONLY ||
+				   !B_IS_INODE(XFS_BUF_PRIORITY(bplist[num])))
 				num++;
 			if (num == MAX_BUFS)
 				break;
@@ -664,10 +740,13 @@ pf_queuing_worker(
 		bno = XFS_AGINO_TO_AGBNO(mp, cur_irec->ino_startnum);
 
 		do {
-			pf_queue_io(args, XFS_AGB_TO_FSB(mp, args->agno, bno),
-					blks_per_cluster,
-					(cur_irec->ino_isa_dir != 0) ?
-						B_DIR_INODE : B_INODE);
+			struct xfs_buf_map	map;
+
+			map.bm_bn = XFS_AGB_TO_DADDR(mp, args->agno, bno);
+			map.bm_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
+			pf_queue_io(args, &map, 1,
+				    (cur_irec->ino_isa_dir != 0) ?  B_DIR_INODE
+								 : B_INODE);
 			bno += blks_per_cluster;
 			num_inos += inodes_per_cluster;
 		} while (num_inos < XFS_IALLOC_INODES(mp));
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
