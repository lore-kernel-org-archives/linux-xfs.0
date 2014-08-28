Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 741527F3F
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 23:23:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E655EAC006
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 21:23:12 -0700 (PDT)
Received: from mail-we0-f181.google.com (mail-we0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id WE5F0qkHvzMHwGq7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 27 Aug 2014 21:23:10 -0700 (PDT)
Received: by mail-we0-f181.google.com with SMTP id x48so181764wes.12
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 21:23:09 -0700 (PDT)
From: Iustin Pop <iusty@k1024.org>
Subject: [PATCH] xfs: fix behaviour of XFS_IOC_FSSETXATTR on directories
Date: Wed, 27 Aug 2014 21:22:53 -0700
Message-Id: <1409199773-16802-1-git-send-email-iusty@k1024.org>
In-Reply-To: <20140718191314.GB27801@teal.hq.k1024.org>
References: <20140718191314.GB27801@teal.hq.k1024.org>
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
Cc: hch@infradead.org, Iustin Pop <iusty@k1024.org>

Currently, the ioctl handling code for XFS_IOC_FSSETXATTR treats all
targets as regular files: it refuses to change the extent size if
extents are allocated. This is wrong for directories, as there the
extent size is only used as a default for children.

The patch fixes this by only checking for allocated extents for regular
files; it leaves undefined what it means to set an extent size on a
non-regular, non-directory inode. Additionally, when setting a non-zero
extent size, the appropriate flags (EXTSIZE, respectively EXTSZINHERIT)
are enforced for regular files and directories.

Signed-off-by: Iustin Pop <iusty@k1024.org>
---
 A patch against xfstests to test for the fixed behaviour will follow
 shortly.

 fs/xfs/xfs_ioctl.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 8bc1bbc..5b9acd2 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1116,14 +1116,32 @@ xfs_ioctl_setattr(
 	}
 
 	if (mask & FSX_EXTSIZE) {
-		/*
-		 * Can't change extent size if any extents are allocated.
-		 */
-		if (ip->i_d.di_nextents &&
-		    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) !=
-		     fa->fsx_extsize)) {
-			code = XFS_ERROR(EINVAL);	/* EFBIG? */
-			goto error_return;
+		if (S_ISDIR(ip->i_d.di_mode)) {
+			/*
+			 * Enforce setting the EXTSZINHERIT flag when
+			 * a non-zero extent size has been specified.
+			 */
+			if (fa->fsx_extsize) {
+				fa->fsx_xflags |= XFS_XFLAG_EXTSZINHERIT;
+			}
+		} else if (S_ISREG(ip->i_d.di_mode)) {
+			/*
+			 * For a regular file, we can't change extent
+			 * size if any extents are allocated.
+			 */
+			if (ip->i_d.di_nextents &&
+			    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) !=
+			     fa->fsx_extsize)) {
+				code = XFS_ERROR(EINVAL);	/* EFBIG? */
+				goto error_return;
+			}
+			/*
+			 * Enforce setting the EXTSIZE flag when
+			 * a non-zero extent size has been specified.
+			 */
+			if (fa->fsx_extsize) {
+				fa->fsx_xflags |= XFS_XFLAG_EXTSIZE;
+			}
 		}
 
 		/*
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
