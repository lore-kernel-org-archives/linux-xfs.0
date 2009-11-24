Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAOLqXvf169242 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 15:52:33 -0600
Date: Tue, 24 Nov 2009 14:52:53 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: [PATCH XFS] Fix error return for fallocate() on XFS
Message-ID: <20091124215253.GA10693@obsidianresearch.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs-masters@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Noticed that through glibc fallocate would return 28 rather than -1
and errno = 28 for ENOSPC. The xfs routines uses XFS_ERROR format
positive return error codes while the syscalls use negative return codes.
Fixup the two cases in xfs_vn_fallocate syscall to convert to negative.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index cd42ef7..1f3b4b8 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -573,8 +573,8 @@ xfs_vn_fallocate(
 	bf.l_len = len;
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-	error = xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
-				      0, XFS_ATTR_NOLOCK);
+	error = -xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
+				       0, XFS_ATTR_NOLOCK);
 	if (!error && !(mode & FALLOC_FL_KEEP_SIZE) &&
 	    offset + len > i_size_read(inode))
 		new_size = offset + len;
@@ -585,7 +585,7 @@ xfs_vn_fallocate(
 
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = new_size;
-		error = xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
+		error = -xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
 	}
 
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-- 
1.5.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
