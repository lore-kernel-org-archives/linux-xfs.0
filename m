Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 632F97CBA
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 07:00:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1897F8F8035
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 05:00:55 -0700 (PDT)
Received: from mail-pa0-f66.google.com (mail-pa0-f66.google.com
	[209.85.220.66]) by cuda.sgi.com with ESMTP id 9rg5GfMUjAY7fEvm
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2016 05:00:52 -0700 (PDT)
Received: by mail-pa0-f66.google.com with SMTP id q2so11865405pap.0
	for <xfs@oss.sgi.com>; Tue, 02 Aug 2016 05:00:52 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH v2 RESEND] fs: return EPERM on immutable inode
Date: Tue,  2 Aug 2016 19:58:28 +0800
Message-Id: <1470139108-13115-1-git-send-email-guaneryu@gmail.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: open list <linux-kernel@vger.kernel.org>, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>, "open list:GFS2 FILE SYSTEM" <cluster-devel@redhat.com>, Eryu Guan <guaneryu@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Bob Peterson <rpeterso@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>

In most cases, EPERM is returned on immutable inode, and there're only a
few places returning EACCES. I noticed this when running LTP on
overlayfs, setxattr03 failed due to unexpected EACCES on immutable
inode.

So converting all EACCES to EPERM on immutable inode.

Acked-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
v2:
- update commit log to mention that it's found by running LTP

 fs/gfs2/inode.c    | 2 +-
 fs/namei.c         | 2 +-
 fs/utimes.c        | 3 ++-
 fs/xfs/xfs_ioctl.c | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index e0621ca..e4da0ec 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1800,7 +1800,7 @@ int gfs2_permission(struct inode *inode, int mask)
 	}
 
 	if ((mask & MAY_WRITE) && IS_IMMUTABLE(inode))
-		error = -EACCES;
+		error = -EPERM;
 	else
 		error = generic_permission(inode, mask);
 	if (gfs2_holder_initialized(&i_gh))
diff --git a/fs/namei.c b/fs/namei.c
index c386a32..adb0414 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -410,7 +410,7 @@ int __inode_permission(struct inode *inode, int mask)
 		 * Nobody gets write access to an immutable file.
 		 */
 		if (IS_IMMUTABLE(inode))
-			return -EACCES;
+			return -EPERM;
 
 		/*
 		 * Updating mtime will likely cause i_uid and i_gid to be
diff --git a/fs/utimes.c b/fs/utimes.c
index 85c40f4..794f5f5 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -92,10 +92,11 @@ static int utimes_common(struct path *path, struct timespec *times)
 		 * then we need to check permissions, because
 		 * inode_change_ok() won't do it.
 		 */
-		error = -EACCES;
+		error = -EPERM;
                 if (IS_IMMUTABLE(inode))
 			goto mnt_drop_write_and_out;
 
+		error = -EACCES;
 		if (!inode_owner_or_capable(inode)) {
 			error = inode_permission(inode, MAY_WRITE);
 			if (error)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9a7c878..3d6820f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -232,7 +232,7 @@ xfs_open_by_handle(
 	}
 
 	if ((fmode & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
-		error = -EACCES;
+		error = -EPERM;
 		goto out_dput;
 	}
 
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
