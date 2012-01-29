Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0T8a5RU005378 for <xfs@oss.sgi.com>; Sun, 29 Jan 2012 02:36:05 -0600
Message-ID: <4F2504DD.5020503@oracle.com>
Date: Sun, 29 Jan 2012 16:35:41 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support to XFS V6
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
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>, Chris Mason <chris.mason@oracle.com>

Hello,

Sorry for the delay!! I just got back from vacation.

This is the V6 to introduce SEEK_DATA/SEEK_HOLE support to XFS.
As we have discussed previously, I have removed the dirty data probing stuff and just treating unwritten extents as data in this post.

Changes to V6:
--------------
* remove xfs_has_unwritten_buffer() for now.
* xfs_bmapi_read() returns the br_state == XFS_EXT_NORM for a hole, so we need to check its startblock is not a "nullstartblock" in this case.
* call i_size_read() after taking the ilock shared, otherwise, isize could be stale.
* remove "ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK)" from xfs_seek_data() since it will not used.
* in xfs_file_llseek(), return -EINVAL rather than -EOPNOTSUPP if whence is not valid according to http://linux.die.net/man/2/lseek.
* s/int lock/uint lock/ in both xfs_seek_data() and xfs_seek_hole().
* s/out_lock/out_unlock/ in both functions too.

Tests:
------
* seek_sanity_tester:
http://permalink.gmane.org/gmane.comp.file-systems.xfs.general/42514

*seek_copy_tester:
http://permalink.gmane.org/gmane.comp.file-systems.xfs.general/42522


Thank you!
-Jeff


Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_file.c |  168 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 167 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 753ed9b..41a045f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1141,8 +1141,174 @@ xfs_vm_page_mkwrite(
 	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
 }
 
+STATIC loff_t
+xfs_seek_data(
+	struct file		*file,
+	loff_t			start,
+	u32			type)
+{
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	loff_t			uninitialized_var(offset);
+	xfs_fsize_t		isize;
+	xfs_fileoff_t		fsbno;
+	xfs_filblks_t		len;
+	uint			lock;
+	int			error;
+
+	lock = xfs_ilock_map_shared(ip);
+
+	isize = i_size_read(inode);
+	if (start >= isize) {
+		error = ENXIO;
+		goto out_unlock;
+	}
+
+	fsbno = XFS_B_TO_FSBT(mp, start);
+	len = XFS_B_TO_FSB(mp, isize);
+	for (;;) {
+		struct xfs_bmbt_irec	map[2];
+		int			nmap = 2;
+		loff_t			seekoff;
+
+		error = xfs_bmapi_read(ip, fsbno, len - fsbno, map, &nmap,
+				       XFS_BMAPI_ENTIRE);
+		if (error)
+			goto out_unlock;
+
+		/* No extents at given offset, must be beyond EOF */
+		if (nmap == 0) {
+			error = ENXIO;
+			goto out_unlock;
+		}
+
+		seekoff = XFS_FSB_TO_B(mp, fsbno);
+
+		if ((map[0].br_state == XFS_EXT_NORM &&
+		     !isnullstartblock(map[0].br_startblock)) ||
+		    map[0].br_startblock == DELAYSTARTBLOCK) {
+			offset = max_t(loff_t, seekoff,
+				       XFS_FSB_TO_B(mp, map[0].br_startoff));
+			break;
+		} else if (map[0].br_state == XFS_EXT_UNWRITTEN) {
+			offset = max_t(loff_t, seekoff,
+				       XFS_FSB_TO_B(mp, map[0].br_startoff));
+			break;
+		} else if (map[0].br_startblock == HOLESTARTBLOCK) {
+			if (nmap == 1) {
+				error = ENXIO;
+				goto out_unlock;
+			}
+
+			if ((map[1].br_state == XFS_EXT_NORM &&
+			     !isnullstartblock(map[1].br_startblock)) ||
+			    map[1].br_startblock == DELAYSTARTBLOCK) {
+				offset = max_t(loff_t, seekoff,
+					XFS_FSB_TO_B(mp, map[1].br_startoff));
+				break;
+			} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
+				offset = max_t(loff_t, seekoff,
+					XFS_FSB_TO_B(mp, map[1].br_startoff));
+				break;
+			} else if (map[1].br_startblock == HOLESTARTBLOCK) {
+				fsbno = map[1].br_startoff +
+					map[1].br_blockcount;
+			} else {
+				BUG();
+			}
+		} else {
+			BUG();
+		}
+
+		if (XFS_FSB_TO_B(mp, fsbno) > isize) {
+			error = ENXIO;
+			goto out_unlock;
+		}
+	}
+
+	if (offset < start)
+		offset = start;
+
+	if (offset != file->f_pos)
+		file->f_pos = offset;
+
+out_unlock:
+	xfs_iunlock_map_shared(ip, lock);
+
+	if (error)
+		return -error;
+	return offset;
+}
+
+STATIC loff_t
+xfs_seek_hole(
+	struct file		*file,
+	loff_t			start,
+	u32			type)
+{
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	loff_t			uninitialized_var(offset);
+	loff_t			holeoff;
+	xfs_fsize_t		isize;
+	xfs_fileoff_t		fsbno;
+	uint			lock;
+	int			error;
+
+	lock = xfs_ilock_map_shared(ip);
+
+	isize = i_size_read(inode);
+	if (start >= isize) {
+		error = ENXIO;
+		goto out_unlock;
+	}
+
+	fsbno = XFS_B_TO_FSBT(mp, start);
+	error = xfs_bmap_first_unused(NULL, ip, 1, &fsbno, XFS_DATA_FORK);
+	if (error)
+		goto out_unlock;
+
+	holeoff = XFS_FSB_TO_B(mp, fsbno);
+	if (holeoff <= start)
+		offset = start;
+	else
+		offset = min_t(loff_t, holeoff, isize);
+
+	if (offset != file->f_pos)
+		file->f_pos = offset;
+
+out_unlock:
+	xfs_iunlock_map_shared(ip, lock);
+
+	if (error)
+		return -error;
+	return offset;
+}
+
+STATIC loff_t
+xfs_file_llseek(
+	struct file	*file,
+	loff_t		offset,
+	int		origin)
+{
+	switch (origin) {
+	case SEEK_END:
+	case SEEK_CUR:
+	case SEEK_SET:
+		return generic_file_llseek(file, offset, origin);
+	case SEEK_DATA:
+		return xfs_seek_data(file, offset, origin);
+	case SEEK_HOLE:
+		return xfs_seek_hole(file, offset, origin);
+	default:
+		return -EINVAL;
+	}
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
