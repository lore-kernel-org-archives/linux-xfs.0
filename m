Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9E55B29E0F
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 01:38:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D8EC8F8033
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 23:38:51 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XrIFBLCUUPzvE7c3 for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 23:38:49 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ugr4p-0008Fo-U9
	for xfs@oss.sgi.com; Mon, 27 May 2013 16:38:39 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ugr4p-0003xY-QH
	for xfs@oss.sgi.com; Mon, 27 May 2013 16:38:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/9] xfs: kill suid/sgid through the truncate path.
Date: Mon, 27 May 2013 16:38:25 +1000
Message-Id: <1369636707-15150-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1369636707-15150-1-git-send-email-david@fromorbit.com>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
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

XFS has failed to kill suid/sgid bits correctly when truncating
files of non-zero size since commit c4ed4243 ("xfs: split
xfs_setattr") introduced in the 3.1 kernel. Fix it.

Fix it.

cc: stable kernel <stable@vger.kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c |   47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d82efaa..ca9ecaa 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -455,6 +455,28 @@ xfs_vn_getattr(
 	return 0;
 }
 
+static void
+xfs_setattr_mode(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct iattr		*iattr)
+{
+	struct inode	*inode = VFS_I(ip);
+	umode_t		mode = iattr->ia_mode;
+
+	ASSERT(tp);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+		mode &= ~S_ISGID;
+
+	ip->i_d.di_mode &= S_IFMT;
+	ip->i_d.di_mode |= mode & ~S_IFMT;
+
+	inode->i_mode &= S_IFMT;
+	inode->i_mode |= mode & ~S_IFMT;
+}
+
 int
 xfs_setattr_nonsize(
 	struct xfs_inode	*ip,
@@ -606,18 +628,8 @@ xfs_setattr_nonsize(
 	/*
 	 * Change file access modes.
 	 */
-	if (mask & ATTR_MODE) {
-		umode_t mode = iattr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			mode &= ~S_ISGID;
-
-		ip->i_d.di_mode &= S_IFMT;
-		ip->i_d.di_mode |= mode & ~S_IFMT;
-
-		inode->i_mode &= S_IFMT;
-		inode->i_mode |= mode & ~S_IFMT;
-	}
+	if (mask & ATTR_MODE)
+		xfs_setattr_mode(tp, ip, iattr);
 
 	/*
 	 * Change file access or modified times.
@@ -714,9 +726,8 @@ xfs_setattr_size(
 		return XFS_ERROR(error);
 
 	ASSERT(S_ISREG(ip->i_d.di_mode));
-	ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
-			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
-			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+	ASSERT((mask & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
+			ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
 
 	if (!(flags & XFS_ATTR_NOLOCK)) {
 		lock_flags |= XFS_IOLOCK_EXCL;
@@ -860,6 +871,12 @@ xfs_setattr_size(
 		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
+	/*
+	 * Change file access modes.
+	 */
+	if (mask & ATTR_MODE)
+		xfs_setattr_mode(tp, ip, iattr);
+
 	if (mask & ATTR_CTIME) {
 		inode->i_ctime = iattr->ia_ctime;
 		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
