Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 039347F37
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 22:07:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7983CAC001
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 20:07:29 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xxzUGXmQhgAi6iEr for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2016 20:07:27 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 6/7] xfs: Factor xfs_seek_hole_data into helper
Date: Thu, 21 Jan 2016 22:07:23 -0600
Message-Id: <1453435644-32261-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1453435644-32261-1-git-send-email-sandeen@redhat.com>
References: <1453435644-32261-1-git-send-email-sandeen@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: jack@suse.cz

Factor xfs_seek_hole_data into an unlocked helper which takes
an xfs inode rather than a file for internal use.

Also allow specification of "end" - the vfs lseek interface is
defined such that any offset past eof/i_size shall return -ENXIO,
but we will use this for quota code which does not maintain i_size,
and we want to be able to SEEK_DATA past i_size as well.  So the
lseek path can send in i_size, and the quota code can determine
its own ending offset.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_file.c  |   82 ++++++++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_inode.h |    2 +
 2 files changed, 59 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ebe9b82..5dc7113 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1337,31 +1337,31 @@ out:
 	return found;
 }
 
-STATIC loff_t
-xfs_seek_hole_data(
-	struct file		*file,
+/*
+ * caller must lock inode with xfs_ilock_data_map_shared,
+ * can we craft an appropriate ASSERT?
+ *
+ * end is because the VFS-level lseek interface is defined such that any
+ * offset past i_size shall return -ENXIO, but we use this for quota code
+ * which does not maintain i_size, and we want to SEEK_DATA past i_size.
+ */
+loff_t
+__xfs_seek_hole_data(
+	struct inode		*inode,
 	loff_t			start,
+	loff_t			end,
 	int			whence)
 {
-	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	loff_t			uninitialized_var(offset);
-	xfs_fsize_t		isize;
 	xfs_fileoff_t		fsbno;
-	xfs_filblks_t		end;
-	uint			lock;
+	xfs_filblks_t		lastbno;
 	int			error;
 
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
-
-	lock = xfs_ilock_data_map_shared(ip);
-
-	isize = i_size_read(inode);
-	if (start >= isize) {
+	if (start >= end) {
 		error = -ENXIO;
-		goto out_unlock;
+		goto out_error;
 	}
 
 	/*
@@ -1369,22 +1369,22 @@ xfs_seek_hole_data(
 	 * by fsbno to the end block of the file.
 	 */
 	fsbno = XFS_B_TO_FSBT(mp, start);
-	end = XFS_B_TO_FSB(mp, isize);
+	lastbno = XFS_B_TO_FSB(mp, end);
 
 	for (;;) {
 		struct xfs_bmbt_irec	map[2];
 		int			nmap = 2;
 		unsigned int		i;
 
-		error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
+		error = xfs_bmapi_read(ip, fsbno, lastbno - fsbno, map, &nmap,
 				       XFS_BMAPI_ENTIRE);
 		if (error)
-			goto out_unlock;
+			goto out_error;
 
 		/* No extents at given offset, must be beyond EOF */
 		if (nmap == 0) {
 			error = -ENXIO;
-			goto out_unlock;
+			goto out_error;
 		}
 
 		for (i = 0; i < nmap; i++) {
@@ -1426,7 +1426,7 @@ xfs_seek_hole_data(
 			 * hole at the end of any file).
 		 	 */
 			if (whence == SEEK_HOLE) {
-				offset = isize;
+				offset = end;
 				break;
 			}
 			/*
@@ -1434,7 +1434,7 @@ xfs_seek_hole_data(
 			 */
 			ASSERT(whence == SEEK_DATA);
 			error = -ENXIO;
-			goto out_unlock;
+			goto out_error;
 		}
 
 		ASSERT(i > 1);
@@ -1445,14 +1445,14 @@ xfs_seek_hole_data(
 		 */
 		fsbno = map[i - 1].br_startoff + map[i - 1].br_blockcount;
 		start = XFS_FSB_TO_B(mp, fsbno);
-		if (start >= isize) {
+		if (start >= end) {
 			if (whence == SEEK_HOLE) {
-				offset = isize;
+				offset = end;
 				break;
 			}
 			ASSERT(whence == SEEK_DATA);
 			error = -ENXIO;
-			goto out_unlock;
+			goto out_error;
 		}
 	}
 
@@ -1464,7 +1464,39 @@ out:
 	 * situation in particular.
 	 */
 	if (whence == SEEK_HOLE)
-		offset = min_t(loff_t, offset, isize);
+		offset = min_t(loff_t, offset, end);
+
+	return offset;
+
+out_error:
+	return error;
+}
+
+STATIC loff_t
+xfs_seek_hole_data(
+	struct file		*file,
+	loff_t			start,
+	int			whence)
+{
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	uint			lock;
+	loff_t			offset, end;
+	int			error = 0;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	lock = xfs_ilock_data_map_shared(ip);
+
+	end = i_size_read(inode);
+	offset = __xfs_seek_hole_data(inode, start, end, whence);
+	if (offset < 0) {
+		error = offset;
+		goto out_unlock;
+	}
+
 	offset = vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
 
 out_unlock:
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ca9e119..ed7e933 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -437,6 +437,8 @@ int	xfs_update_prealloc_flags(struct xfs_inode *ip,
 int	xfs_zero_eof(struct xfs_inode *ip, xfs_off_t offset,
 		     xfs_fsize_t isize, bool *did_zeroing);
 int	xfs_iozero(struct xfs_inode *ip, loff_t pos, size_t count);
+loff_t	__xfs_seek_hole_data(struct inode *inode, loff_t start,
+			     loff_t eof, int whence);
 
 
 /* from xfs_iops.c */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
