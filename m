Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q71EuvvR036483 for <xfs@oss.sgi.com>; Wed, 1 Aug 2012 09:56:57 -0500
Received: from mail-gg0-f181.google.com (mail-gg0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	IAgfz0jw0WTBOApD (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Aug 2012 07:56:55 -0700 (PDT)
Received: by ggnv5 with SMTP id v5so9005368ggn.26
	for <xfs@oss.sgi.com>; Wed, 01 Aug 2012 07:56:55 -0700 (PDT)
Message-ID: <501943B5.4030309@inktank.com>
Date: Wed, 01 Aug 2012 09:56:53 -0500
From: Alex Elder <elder@inktank.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: minor inode64 mount option cleanup
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
To: xfs@oss.sgi.com

Supplying the "inode64" mount option means inode allocations should
not be restricted to "small" inode numbers (within a 32 bit range).
So in xfs_parseargs(), the XFS_MOUNT_SMALL_INUMS flag is cleared if
"inode64" is requested.

If a kernel does not support 64-bit inodes (which may be because it
doesn't support 64-bit block addresses), the "inode64" mount option
is not allowed.  But even though it's treated as an invalid mount
option xfs_parseargs() still clears SMALL_INUMS flag if "inode64" is
requested.

The end result may not actually matter, but I think we should not be
changing any state (clearing the SMALL_INUMS flag) when an invalid
mount option is supplied.

So this just makes sure the SMALL_INUMS flag is only cleared if the
kernel supports big inode numbers.

Signed-off-by: Alex Elder <elder@inktank.com>
---
 fs/xfs/xfs_super.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/fs/xfs/xfs_super.c
===================================================================
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -295,12 +295,13 @@ xfs_parseargs(
 			}
 			dswidth = simple_strtoul(value, &eov, 10);
 		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
+#if XFS_BIG_INUMS
 			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
-#if !XFS_BIG_INUMS
+#else /* !XFS_BIG_INUMS */
 			xfs_warn(mp, "%s option not allowed on this system",
 				this_char);
 			return EINVAL;
-#endif
+#endif /* !XFS_BIG_INUMS */
 		} else if (!strcmp(this_char, MNTOPT_NOUUID)) {
 			mp->m_flags |= XFS_MOUNT_NOUUID;
 		} else if (!strcmp(this_char, MNTOPT_BARRIER)) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
