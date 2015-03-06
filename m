Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 94F657F4E
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 10:54:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7150C8F8050
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 08:54:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QsADAhEuBzlg2HiU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Mar 2015 08:54:09 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t26Gs89D011334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 6 Mar 2015 11:54:08 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t26Gs7vc004553
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 6 Mar 2015 11:54:08 -0500
Message-ID: <54F9DBAE.2070002@redhat.com>
Date: Fri, 06 Mar 2015 10:54:06 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: take XFS_IOLOCK_EXCL if suid removal is required
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
To: xfs-oss <xfs@oss.sgi.com>

This sequence:

# rm -f sparsefile
# truncate --size=1m sparsefile
# chmod ugo+rws sparsefile
# ls -l sparsefile
-rwSrwSrw-. 1 root root 1048576 Mar  6 10:29 sparsefile
# su tester

$ xfs_io -d -c "pwrite 0 4096" sparsefile
wrote 4096/4096 bytes at offset 0
4 KiB, 1 ops; 0.0000 sec (21.505 KiB/sec and 5.3763 ops/sec)
$ exit

will lead to a WARN_ON() in notify change, because i_mutex is
not held, and we get to notify_change via suid removal with
only XFS_IOLOCK_SHARED held, i.e. no i_mutex.

Upgrade the lock to XFS_IOLOCK_EXCL in this case.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a2e1cb8..e64d5b1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -541,7 +541,7 @@ xfs_zero_eof(
  *
  * Called with the iolocked held either shared and exclusive according to
  * @iolock, and returns with it held.  Might upgrade the iolock to exclusive
- * if called for a direct write beyond i_size.
+ * if called for a direct write beyond i_size or if suid removal is required.
  */
 STATIC ssize_t
 xfs_file_aio_write_checks(
@@ -551,6 +551,7 @@ xfs_file_aio_write_checks(
 	int			*iolock)
 {
 	struct inode		*inode = file->f_mapping->host;
+	struct dentry		*dentry = file->f_path.dentry;
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error = 0;
 
@@ -569,9 +570,12 @@ restart:
 	 * write.  If zeroing is needed and we are currently holding the
 	 * iolock shared, we need to update it to exclusive which implies
 	 * having to redo all checks before.
+	 *
+	 * We also must be locked exclusively if this write will require
+	 * suid removal; notify_change expects i_mutex to be locked.
 	 */
-	if (*pos > i_size_read(inode)) {
-		bool	zero = false;
+	if (*pos > i_size_read(inode) || should_remove_suid(dentry)) {
+		bool	z = false;
 
 		if (*iolock == XFS_IOLOCK_SHARED) {
 			xfs_rw_iunlock(ip, *iolock);
@@ -579,9 +583,12 @@ restart:
 			xfs_rw_ilock(ip, *iolock);
 			goto restart;
 		}
-		error = xfs_zero_eof(ip, *pos, i_size_read(inode), &zero);
-		if (error)
-			return error;
+
+		if (*pos > i_size_read(inode) ) {
+			error = xfs_zero_eof(ip, *pos, i_size_read(inode), &z);
+			if (error)
+				return error;
+		}
 	}
 
 	/*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
