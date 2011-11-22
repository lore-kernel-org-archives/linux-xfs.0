Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM8KMdD128284 for <xfs@oss.sgi.com>; Tue, 22 Nov 2011 02:20:22 -0600
Message-ID: <4ECB5B21.7080508@oracle.com>
Date: Tue, 22 Nov 2011 16:19:45 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] Introduce SEEK_DATA/SEEK_HOLE to XFS V2
Reply-To: jeff.liu@oracle.com
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
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, aelder@sgi.com

Hello,

This is the V2 attempt to add SEEK_DATA/SEEK_HOLE to XFS.

Changes:
========
1. Merge xfs_find_desired_extent() and xfs_seek_data_hole() into xfs_seek_extent(), and place it at xfs_file.c.
2. Using two different routines xfs_seek_data()/xfs_seek_hole() to handle SEEK_DATA/SEEK_HOLE requests respectively.
3. Remove some worthless result checking code from xfs_file_llseek().
4. s/xfs_mount_t/struct xfs_mount/g.

Tests:
======
In addition to the seek_test.c I have used previously, I have also done a large sparse file copy tests, it works to me.

Hope I have not made obvious stupid mistakes this time. :-P.
Any comments are appreciated!


Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_file.c |  188 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 187 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 753ed9b..bb2be00 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1141,8 +1141,194 @@ xfs_vm_page_mkwrite(
 	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
 }
 
+STATIC int
+xfs_seek_data(
+	struct xfs_inode *ip,
+	loff_t *start)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp;
+	xfs_fileoff_t		fsbno;
+	xfs_filblks_t		len;
+	loff_t			startoff = *start;
+	int			error = 0;
+
+	fsbno = XFS_B_TO_FSBT(mp, *start);
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	len = XFS_B_TO_FSB(mp, ip->i_size);
+
+	for (;;) {
+		struct xfs_bmbt_irec	map[2];
+		int			nmap = 2;
+		loff_t			seekoff;
+
+		error = xfs_bmapi_read(ip, fsbno, len - fsbno, map, &nmap,
+				       XFS_BMAPI_ENTIRE);
+		if (error)
+			break;
+
+		/* No extents at given offset, must be beyond EOF */
+		if (!nmap) {
+			error = ENXIO;
+			break;
+		}
+
+		seekoff = XFS_FSB_TO_B(mp, fsbno);
+
+		/*
+		 * Hole handling for unwritten extents landed in a hole.
+		 * If the next extent is a data  extent, then return the
+		 * start of it, otherwise we need to move the start offset
+		 * and map more blocks.
+		 */
+		if (map[0].br_startblock == HOLESTARTBLOCK) {
+			if (map[1].br_startblock == HOLESTARTBLOCK) {
+				fsbno = map[1].br_startoff +
+					map[1].br_blockcount;
+			} else {
+				*start = max_t(loff_t, seekoff,
+				       XFS_FSB_TO_B(mp, map[1].br_startoff));
+				break;
+			}
+		}
+
+		/*
+		 * Landed in an in-memory data extent or in an allocated
+		 * extent.
+		 */
+		if (map[0].br_startoff == DELAYSTARTBLOCK ||
+		    map[0].br_state == XFS_EXT_NORM) {
+			*start = max_t(loff_t, seekoff,
+				       XFS_FSB_TO_B(mp, map[0].br_startoff));
+			break;
+		}
+
+		/* return ENXIO if beyond eof */
+		if (XFS_FSB_TO_B(mp, fsbno) > ip->i_size) {
+			error = ENXIO;
+			break;
+		}
+	}
+
+	if (*start < startoff)
+		*start = startoff;
+
+	return error;
+}
+
+STATIC int
+xfs_seek_hole(
+	struct xfs_inode *ip,
+	loff_t *start)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error = 0;
+	loff_t			seekoff = *start;
+	loff_t			holeoff;
+	xfs_fileoff_t		fsbno;
+
+	fsbno = XFS_B_TO_FSBT(mp, *start);
+	error = xfs_bmap_first_unused(NULL, ip, 1, &fsbno, XFS_DATA_FORK);
+	if (error)
+		return error;
+
+	holeoff = XFS_FSB_TO_B(mp, fsbno);
+	if (holeoff <= seekoff)
+		*start = seekoff;
+	else
+		*start = min_t(loff_t, holeoff, ip->i_size);
+
+	return error;
+}
+
+STATIC int
+xfs_seek_extent(
+	struct inode		*inode,
+	loff_t			*start,
+	u32			type)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp;
+	int			lock;
+	int			error = 0;
+
+	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
+	    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
+	    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+		return XFS_ERROR(EINVAL);
+
+	lock = xfs_ilock_map_shared(ip);
+
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		error = EIO;
+		goto out_lock;
+	}
+
+	XFS_STATS_INC(xs_blk_mapr);
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+
+	ASSERT(ifp->if_ext_max ==
+	      XFS_IFORK_SIZE(ip, XFS_DATA_FORK) / (uint)sizeof(xfs_bmbt_rec_t));
+
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		if (error)
+			goto out_lock;
+	}
+
+	if (type == SEEK_HOLE)
+		error = xfs_seek_hole(ip, start);
+	else
+		error = xfs_seek_data(ip, start);
+
+out_lock:
+	xfs_iunlock_map_shared(ip, lock);
+
+	if (error)
+		return -error;
+
+	return 0;
+}
+
+STATIC loff_t
+xfs_file_llseek(
+	struct file *file,
+	loff_t offset,
+	int origin)
+{
+	struct inode *inode = file->f_mapping->host;
+	int ret;
+
+	switch (origin) {
+	case SEEK_END:
+	case SEEK_CUR:
+		offset = generic_file_llseek(file, offset, origin);
+		goto out;
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		if (offset >= i_size_read(inode)) {
+			ret = -ENXIO;
+			goto error;
+		}
+
+		ret = xfs_seek_extent(inode, &offset, origin);
+		if (ret)
+			goto error;
+	}
+
+	if (offset != file->f_pos)
+		file->f_pos = offset;
+
+out:
+	return offset;
+
+error:
+	return ret;
+}
+
 const struct file_operations xfs_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= xfs_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read	= xfs_file_aio_read,
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
