Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4L5jpNF250049 for <xfs@oss.sgi.com>; Fri, 21 May 2010 00:45:51 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB895A01D39
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 22:49:24 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	FCfnyIUDWW8iz96D for <xfs@oss.sgi.com>;
	Thu, 20 May 2010 22:49:24 -0700 (PDT)
Received: from dastard (unverified [121.44.31.48])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	25043584-1927428
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 15:18:06 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OFL5Z-0001su-H3
	for xfs@oss.sgi.com; Fri, 21 May 2010 15:48:05 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OFL5T-0000cx-57
	for xfs@oss.sgi.com; Fri, 21 May 2010 15:47:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: Check new inode size is OK before preallocating
Date: Fri, 21 May 2010 15:47:59 +1000
Message-Id: <1274420879-2391-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The new xfsqa test 228 tries to preallocate more space than the
filesystem contains. it should fail, but instead triggers an assert
about lock flags.  The failure is due to the size extension failing
in vmtruncate() due to rlimit being set. Check this before we start
the preallocation to avoid allocating space that will never be used.

Also the path through xfs_vn_allocate already holds the IO lock, so
it should not be present in the lock flags when the setattr fails.
Hence the assert needs to take this into account. This will prevent
other such callers from hitting this incorrect ASSERT.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |   16 +++++++++++++---
 fs/xfs/xfs_vnodeops.c       |    2 +-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 9c8019c..d74914f 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -585,11 +585,20 @@ xfs_vn_fallocate(
 	bf.l_len = len;
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+
+	/* check the new inode size is valid before allocating */
+	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+	    offset + len > i_size_read(inode)) {
+		new_size = offset + len;
+		error = inode_newsize_ok(inode, newsize);
+		if (error)
+			goto out_unlock;
+	}
+
 	error = -xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
 				       0, XFS_ATTR_NOLOCK);
-	if (!error && !(mode & FALLOC_FL_KEEP_SIZE) &&
-	    offset + len > i_size_read(inode))
-		new_size = offset + len;
+	if (error)
+		goto out_unlock;
 
 	/* Change file size if needed */
 	if (new_size) {
@@ -600,6 +609,7 @@ xfs_vn_fallocate(
 		error = -xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
 	}
 
+out_unlock:
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 out_error:
 	return error;
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 9d376be..a06bd62 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -267,7 +267,7 @@ xfs_setattr(
 		if (code) {
 			ASSERT(tp == NULL);
 			lock_flags &= ~XFS_ILOCK_EXCL;
-			ASSERT(lock_flags == XFS_IOLOCK_EXCL);
+			ASSERT(lock_flags == XFS_IOLOCK_EXCL || !need_iolock);
 			goto error_return;
 		}
 		tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
