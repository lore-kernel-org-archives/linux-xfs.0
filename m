Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 997937F4E
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 21:20:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8617F30406A
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 19:20:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jpz0750Qt9BCQb0W (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Aug 2014 19:20:24 -0700 (PDT)
Message-ID: <53F55765.6030205@redhat.com>
Date: Wed, 20 Aug 2014 21:20:21 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH RFC] xfs: combine xfs_seek_hole & xfs_seek_data
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
To: xfs-oss <xfs@oss.sgi.com>, Jeff Liu <jeff.liu@oracle.com>

xfs_seek_hole & xfs_seek_data are remarkably similar;
so much so that they could be combined, saving a fair
bit of semi-complex code duplication.

The following patch passes generic/285 and generic/286;
is this worth doing, (maybe cleaning up a bit), or
is it too convoluted & confusing?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 xfs_file.c |  174 +++++++++++++++++--------------------------------------------
 1 file changed, 50 insertions(+), 124 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 076b170..321dde6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -964,7 +964,7 @@ xfs_vm_page_mkwrite(
 
 /*
  * This type is designed to indicate the type of offset we would like
- * to search from page cache for either xfs_seek_data() or xfs_seek_hole().
+ * to search from page cache for xfs_seek_hole_data().
  */
 enum {
 	HOLE_OFF = 0,
@@ -1021,7 +1021,7 @@ xfs_lookup_buffer_offset(
 /*
  * This routine is called to find out and return a data or hole offset
  * from the page cache for unwritten extents according to the desired
- * type for xfs_seek_data() or xfs_seek_hole().
+ * type for xfs_seek_hole_data().
  *
  * The argument offset is used to tell where we start to search from the
  * page cache.  Map is used to figure out the end points of the range to
@@ -1181,9 +1181,10 @@ out:
 }
 
 STATIC loff_t
-xfs_seek_data(
+xfs_seek_hole_data(
 	struct file		*file,
-	loff_t			start)
+	loff_t			start,
+	int			whence)
 {
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -1195,6 +1196,9 @@ xfs_seek_data(
 	uint			lock;
 	int			error;
 
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
 	lock = xfs_ilock_data_map_shared(ip);
 
 	isize = i_size_read(inode);
@@ -1209,6 +1213,7 @@ xfs_seek_data(
 	 */
 	fsbno = XFS_B_TO_FSBT(mp, start);
 	end = XFS_B_TO_FSB(mp, isize);
+
 	for (;;) {
 		struct xfs_bmbt_irec	map[2];
 		int			nmap = 2;
@@ -1229,29 +1234,46 @@ xfs_seek_data(
 			offset = max_t(loff_t, start,
 				       XFS_FSB_TO_B(mp, map[i].br_startoff));
 
-			/* Landed in a data extent */
-			if (map[i].br_startblock == DELAYSTARTBLOCK ||
-			    (map[i].br_state == XFS_EXT_NORM &&
-			     !isnullstartblock(map[i].br_startblock)))
+			/* Landed in the hole we wanted? */
+			if (whence == SEEK_HOLE &&
+			    map[i].br_startblock == HOLESTARTBLOCK)
+				goto out;
+
+			/* Landed in the data extent we wanted? */
+			if (whence == SEEK_DATA &&
+			    (map[i].br_startblock == DELAYSTARTBLOCK ||
+			     (map[i].br_state == XFS_EXT_NORM &&
+			      !isnullstartblock(map[i].br_startblock))))
 				goto out;
 
 			/*
-			 * Landed in an unwritten extent, try to search data
-			 * from page cache.
+			 * Landed in an unwritten extent, try to search
+			 * for hole or data from page cache.
 			 */
 			if (map[i].br_state == XFS_EXT_UNWRITTEN) {
 				if (xfs_find_get_desired_pgoff(inode, &map[i],
-							DATA_OFF, &offset))
+				      whence == SEEK_HOLE ? HOLE_OFF : DATA_OFF,
+							&offset))
 					goto out;
 			}
 		}
 
-		/*
-		 * map[0] is hole or its an unwritten extent but
-		 * without data in page cache.  Probably means that
-		 * we are reading after EOF if nothing in map[1].
-		 */
 		if (nmap == 1) {
+			/*
+			 * The single map didn't have what we were looking for.
+			 * If we were looking for a hole, we are probably
+			 * looking past EOF.  We should fix offset to point
+			 * to the end of the file (i.e., there is an implicit
+			 * hole at the end of any file).
+		 	 */
+			if (whence == SEEK_HOLE) {
+				offset = isize;
+				break;
+			}
+			/*
+			 * If we were looking for data, it's nowhere to be found
+			 */
+			ASSERT(whence == SEEK_DATA);
 			error = -ENXIO;
 			goto out_unlock;
 		}
@@ -1260,125 +1282,30 @@ xfs_seek_data(
 
 		/*
 		 * Nothing was found, proceed to the next round of search
-		 * if reading offset not beyond or hit EOF.
+		 * if the next reading offset is not at or beyond EOF.
 		 */
 		fsbno = map[i - 1].br_startoff + map[i - 1].br_blockcount;
 		start = XFS_FSB_TO_B(mp, fsbno);
 		if (start >= isize) {
+			if (whence == SEEK_HOLE) {
+				offset = isize;
+				break;
+			}
+			ASSERT(whence == SEEK_DATA);
 			error = -ENXIO;
 			goto out_unlock;
 		}
 	}
 
 out:
-	offset = vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
-
-out_unlock:
-	xfs_iunlock(ip, lock);
-
-	if (error)
-		return error;
-	return offset;
-}
-
-STATIC loff_t
-xfs_seek_hole(
-	struct file		*file,
-	loff_t			start)
-{
-	struct inode		*inode = file->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	loff_t			uninitialized_var(offset);
-	xfs_fsize_t		isize;
-	xfs_fileoff_t		fsbno;
-	xfs_filblks_t		end;
-	uint			lock;
-	int			error;
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
-
-	lock = xfs_ilock_data_map_shared(ip);
-
-	isize = i_size_read(inode);
-	if (start >= isize) {
-		error = -ENXIO;
-		goto out_unlock;
-	}
-
-	fsbno = XFS_B_TO_FSBT(mp, start);
-	end = XFS_B_TO_FSB(mp, isize);
-
-	for (;;) {
-		struct xfs_bmbt_irec	map[2];
-		int			nmap = 2;
-		unsigned int		i;
-
-		error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
-				       XFS_BMAPI_ENTIRE);
-		if (error)
-			goto out_unlock;
-
-		/* No extents at given offset, must be beyond EOF */
-		if (nmap == 0) {
-			error = -ENXIO;
-			goto out_unlock;
-		}
-
-		for (i = 0; i < nmap; i++) {
-			offset = max_t(loff_t, start,
-				       XFS_FSB_TO_B(mp, map[i].br_startoff));
-
-			/* Landed in a hole */
-			if (map[i].br_startblock == HOLESTARTBLOCK)
-				goto out;
-
-			/*
-			 * Landed in an unwritten extent, try to search hole
-			 * from page cache.
-			 */
-			if (map[i].br_state == XFS_EXT_UNWRITTEN) {
-				if (xfs_find_get_desired_pgoff(inode, &map[i],
-							HOLE_OFF, &offset))
-					goto out;
-			}
-		}
-
-		/*
-		 * map[0] contains data or its unwritten but contains
-		 * data in page cache, probably means that we are
-		 * reading after EOF.  We should fix offset to point
-		 * to the end of the file(i.e., there is an implicit
-		 * hole at the end of any file).
-		 */
-		if (nmap == 1) {
-			offset = isize;
-			break;
-		}
-
-		ASSERT(i > 1);
-
-		/*
-		 * Both mappings contains data, proceed to the next round of
-		 * search if the current reading offset not beyond or hit EOF.
-		 */
-		fsbno = map[i - 1].br_startoff + map[i - 1].br_blockcount;
-		start = XFS_FSB_TO_B(mp, fsbno);
-		if (start >= isize) {
-			offset = isize;
-			break;
-		}
-	}
-
-out:
 	/*
-	 * At this point, we must have found a hole.  However, the returned
+	 * If at this point we have found the hole we wanted, the returned
 	 * offset may be bigger than the file size as it may be aligned to
-	 * page boundary for unwritten extents, we need to deal with this
+	 * page boundary for unwritten extents.  We need to deal with this
 	 * situation in particular.
 	 */
-	offset = min_t(loff_t, offset, isize);
+	if (whence == SEEK_HOLE)
+		offset = min_t(loff_t, offset, isize);
 	offset = vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
 
 out_unlock:
@@ -1400,10 +1327,9 @@ xfs_file_llseek(
 	case SEEK_CUR:
 	case SEEK_SET:
 		return generic_file_llseek(file, offset, origin);
-	case SEEK_DATA:
-		return xfs_seek_data(file, offset);
 	case SEEK_HOLE:
-		return xfs_seek_hole(file, offset);
+	case SEEK_DATA:
+		return xfs_seek_hole_data(file, offset, origin);
 	default:
 		return -EINVAL;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
