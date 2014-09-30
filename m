Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DEB048016
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 20:46:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B64218F8039
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 18:46:30 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	A6QtzttuB7VSrPcO for <xfs@oss.sgi.com>;
	Mon, 29 Sep 2014 18:46:28 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: project id inheritance is a directory only flag
Date: Tue, 30 Sep 2014 11:46:04 +1000
Message-Id: <1412041565-18873-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1412041565-18873-1-git-send-email-david@fromorbit.com>
References: <1412041565-18873-1-git-send-email-david@fromorbit.com>
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
Cc: iusty@k1024.org

From: Dave Chinner <dchinner@redhat.com>

xfs_set_diflags() allows it to be set on non-directory inodes, and
this flags errors in xfs_repair. Further, inode allocation allows
the same directory-only flag to be inherited to non-directories.
Make sure directory inode flags don't appear on other types of
inodes.

This fixes several xfstests scratch fileystem corruption reports
(e.g. xfs/050) now that xfstests checks scratch filesystems after
test completion.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 4 ++--
 fs/xfs/xfs_ioctl.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f07b443..8ed049d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -769,6 +769,8 @@ xfs_ialloc(
 					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
 					ip->i_d.di_extsize = pip->i_d.di_extsize;
 				}
+				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+					di_flags |= XFS_DIFLAG_PROJINHERIT;
 			} else if (S_ISREG(mode)) {
 				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_REALTIME;
@@ -789,8 +791,6 @@ xfs_ialloc(
 			if ((pip->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) &&
 			    xfs_inherit_nosymlinks)
 				di_flags |= XFS_DIFLAG_NOSYMLINKS;
-			if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-				di_flags |= XFS_DIFLAG_PROJINHERIT;
 			if ((pip->i_d.di_flags & XFS_DIFLAG_NODEFRAG) &&
 			    xfs_inherit_nodefrag)
 				di_flags |= XFS_DIFLAG_NODEFRAG;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7a6b406..87c3bd1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -968,8 +968,6 @@ xfs_set_diflags(
 		di_flags |= XFS_DIFLAG_NOATIME;
 	if (xflags & XFS_XFLAG_NODUMP)
 		di_flags |= XFS_DIFLAG_NODUMP;
-	if (xflags & XFS_XFLAG_PROJINHERIT)
-		di_flags |= XFS_DIFLAG_PROJINHERIT;
 	if (xflags & XFS_XFLAG_NODEFRAG)
 		di_flags |= XFS_DIFLAG_NODEFRAG;
 	if (xflags & XFS_XFLAG_FILESTREAM)
@@ -981,6 +979,8 @@ xfs_set_diflags(
 			di_flags |= XFS_DIFLAG_NOSYMLINKS;
 		if (xflags & XFS_XFLAG_EXTSZINHERIT)
 			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+		if (xflags & XFS_XFLAG_PROJINHERIT)
+			di_flags |= XFS_DIFLAG_PROJINHERIT;
 	} else if (S_ISREG(ip->i_d.di_mode)) {
 		if (xflags & XFS_XFLAG_REALTIME)
 			di_flags |= XFS_DIFLAG_REALTIME;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
