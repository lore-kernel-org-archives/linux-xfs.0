Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5CFaNpE261453 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 10:36:23 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id yVI757ldKEC3bF6r
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jun 2012 08:36:22 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so1150512pbb.26
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 08:36:22 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/2] xfs: add FALLOC_FL_ZERO_RANGE to fallocate
Date: Tue, 12 Jun 2012 17:36:04 +0200
Message-Id: <1339515364-17374-3-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

This is implemented in the same way as the other fallocate modes.  All of
them map to XFS ioctls that are implemented by xfs_change_file_space.

However, we need to cap the length to the inode size if the user requested
FALLOC_FL_KEEP_SIZE.

Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 fs/xfs/xfs_file.c |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9f7ec15..c811cf9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -818,33 +818,45 @@ xfs_file_fallocate(
 	loff_t		new_size = 0;
 	xfs_flock64_t	bf;
 	xfs_inode_t	*ip = XFS_I(inode);
-	int		cmd = XFS_IOC_RESVSP;
+	int		cmd;
 	int		attr_flags = XFS_ATTR_NOLOCK;
 
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
+		     FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
 
+	BUG_ON((mode & FALLOC_FL_PUNCH_HOLE) && (mode & FALLOC_FL_ZERO_RANGE));
+
 	bf.l_whence = 0;
 	bf.l_start = offset;
 	bf.l_len = len;
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
-	if (mode & FALLOC_FL_PUNCH_HOLE)
-		cmd = XFS_IOC_UNRESVSP;
-
-	/* check the new inode size is valid before allocating */
-	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
-	    offset + len > i_size_read(inode)) {
-		new_size = offset + len;
-		error = inode_newsize_ok(inode, new_size);
-		if (error)
-			goto out_unlock;
+	if (offset + len > i_size_read(inode)) {
+		if (mode & FALLOC_FL_KEEP_SIZE) {
+			if (offset > i_size_read(inode))
+				goto out_unlock;
+			len = i_size_read(inode) - offset;
+		} else {
+			/* check validity of new inode size before allocating */
+			new_size = offset + len;
+			error = inode_newsize_ok(inode, new_size);
+			if (error)
+				goto out_unlock;
+		}
 	}
 
 	if (file->f_flags & O_DSYNC)
 		attr_flags |= XFS_ATTR_SYNC;
 
+	if (mode & FALLOC_FL_PUNCH_HOLE)
+		cmd = XFS_IOC_UNRESVSP;
+	else if (mode & FALLOC_FL_ZERO_RANGE)
+		cmd = XFS_IOC_ZERO_RANGE;
+	else
+		cmd = XFS_IOC_RESVSP;
+
 	error = -xfs_change_file_space(ip, cmd, &bf, 0, attr_flags);
 	if (error)
 		goto out_unlock;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
