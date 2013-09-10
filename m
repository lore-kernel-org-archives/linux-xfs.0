Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 07DFF7F53
	for <xfs@oss.sgi.com>; Tue, 10 Sep 2013 17:34:53 -0500 (CDT)
Message-Id: <20130910213624.726953044@sgi.com>
Date: Tue, 10 Sep 2013 17:36:30 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: v2 change the immutable in xfs_open_by_handle
Content-Disposition: inline;
	filename=v2-xfs-change-immutable-in-xfs_open_by_handle.patch
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
Cc: Greg Banks <gbanks@sgi.com>

This patch allows clients like DMF to modify an immutable file
without changing the immutable capability on the file, which
would expose the file to change.

This patch is restricted to holders of the CAP_LINUX_IMMUTABLE,
so no addition security risk has been introduced.

Signed-off-by: Greg Banks <gbanks@sgi.com>
Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 v1->v2 fix the FMODE_WRITE test.

 fs/xfs/xfs_ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/fs/xfs/xfs_ioctl.c
===================================================================
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -237,7 +237,9 @@ xfs_open_by_handle(
 		goto out_dput;
 	}
 
-	if ((fmode & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
+	if ((fmode & FMODE_WRITE) &&
+	    IS_IMMUTABLE(inode) &&
+	    !capable(CAP_LINUX_IMMUTABLE)) {
 		error = -XFS_ERROR(EACCES);
 		goto out_dput;
 	}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
