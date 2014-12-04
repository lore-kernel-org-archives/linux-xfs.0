Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6BEAE7F3F
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 22:14:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EFFFBAC002
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 20:14:43 -0800 (PST)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id YZHCJqn7QKn7FQBd
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Dec 2014 20:14:41 -0800 (PST)
Received: by mail-wg0-f50.google.com with SMTP id k14so21382912wgh.23
	for <xfs@oss.sgi.com>; Wed, 03 Dec 2014 20:14:40 -0800 (PST)
From: Iustin Pop <iustin@k1024.org>
Subject: [PATCH] xfs: fix behaviour of XFS_IOC_FSSETXATTR on directories
Date: Thu,  4 Dec 2014 05:14:26 +0100
Message-Id: <1417666466-31820-1-git-send-email-iustin@k1024.org>
In-Reply-To: <20140829004607.GX20518@dastard>
References: <20140829004607.GX20518@dastard>
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
To: david@fromorbit.com
Cc: Iustin Pop <iustin@k1024.org>, xfs@oss.sgi.com

Currently, the ioctl handling code for XFS_IOC_FSSETXATTR treats all
targets as regular files: it refuses to change the extent size if
extents are allocated. This is wrong for directories, as there the
extent size is only used as a default for children.

The patch fixes this issue and improves validation of flag
combinations:

- only disallow extent size changes after extents have been allocated
  for regular files
- only allow XFS_XFLAG_EXTSIZE for regular files
- only allow XFS_XFLAG_EXTSZINHERIT for directories
- automatically clear the flags if the extent size is zero

Thanks to Dave Chinner for guidance on the proper fix for this issue.

Signed-off-by: Iustin Pop <iustin@k1024.org>
---
 Trying to revive this fix. Note that this patch is on top of
 git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git master, which
 seems to have no commits since Oct 26; let me know if I should rebase it on
 top of something else.

 fs/xfs/xfs_ioctl.c | 59 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 24c926b..67e3ab1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1113,34 +1113,49 @@ xfs_ioctl_setattr(
 	}
 
 	if (mask & FSX_EXTSIZE) {
-		/*
-		 * Can't change extent size if any extents are allocated.
+		code = -EINVAL;
+
+		/* Validate the flags are set appropriately per the
+		 * inode type.
 		 */
-		if (ip->i_d.di_nextents &&
-		    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) !=
-		     fa->fsx_extsize)) {
-			code = -EINVAL;	/* EFBIG? */
+		if ((fa->fsx_xflags & XFS_XFLAG_EXTSIZE) &&
+		    !S_ISREG(ip->i_d.di_mode))
+			goto error_return;
+		if ((fa->fsx_xflags & XFS_XFLAG_EXTSZINHERIT) &&
+		    !S_ISDIR(ip->i_d.di_mode))
 			goto error_return;
-		}
 
 		/*
-		 * Extent size must be a multiple of the appropriate block
-		 * size, if set at all. It must also be smaller than the
-		 * maximum extent size supported by the filesystem.
-		 *
-		 * Also, for non-realtime files, limit the extent size hint to
-		 * half the size of the AGs in the filesystem so alignment
-		 * doesn't result in extents larger than an AG.
+		 * Dissalow changing extent size on regular files with
+		 * allocated extents.
 		 */
-		if (fa->fsx_extsize != 0) {
+		if (S_ISREG(ip->i_d.di_mode) && ip->i_d.di_nextents &&
+		    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) !=
+		     fa->fsx_extsize))
+			goto error_return;
+
+		/* If the extent size is zero, clear the inode flags. */
+		if (fa->fsx_extsize == 0) {
+			fa->fsx_xflags &= ~(XFS_XFLAG_EXTSIZE |
+					    XFS_XFLAG_EXTSZINHERIT);
+		} else {
+			/*
+			 * Extent size must be a multiple of the
+			 * appropriate block size, if set at all. It
+			 * must also be smaller than the maximum
+			 * extent size supported by the filesystem.
+			 *
+			 * Also, for non-realtime files, limit the
+			 * extent size hint to half the size of the
+			 * AGs in the filesystem so alignment doesn't
+			 * result in extents larger than an AG.
+			 */
 			xfs_extlen_t    size;
 			xfs_fsblock_t   extsize_fsb;
 
 			extsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_extsize);
-			if (extsize_fsb > MAXEXTLEN) {
-				code = -EINVAL;
+			if (extsize_fsb > MAXEXTLEN)
 				goto error_return;
-			}
 
 			if (XFS_IS_REALTIME_INODE(ip) ||
 			    ((mask & FSX_XFLAGS) &&
@@ -1149,16 +1164,12 @@ xfs_ioctl_setattr(
 				       mp->m_sb.sb_blocklog;
 			} else {
 				size = mp->m_sb.sb_blocksize;
-				if (extsize_fsb > mp->m_sb.sb_agblocks / 2) {
-					code = -EINVAL;
+				if (extsize_fsb > mp->m_sb.sb_agblocks / 2)
 					goto error_return;
-				}
 			}
 
-			if (fa->fsx_extsize % size) {
-				code = -EINVAL;
+			if (fa->fsx_extsize % size)
 				goto error_return;
-			}
 		}
 	}
 
-- 
2.1.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
