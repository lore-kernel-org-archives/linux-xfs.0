Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C2F027CA1
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 09:16:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 609AB304101
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 07:16:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aNQetku6HaHl9XBu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 16 Aug 2016 07:16:54 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id BD193C04B320
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 14:16:53 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-57-220.rdu2.redhat.com
	[10.10.57.220])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7GEGp7h012243
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 10:16:53 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v2 2/3] xfs_quota: changes to accomodate hoisted ioctl defs
Date: Tue, 16 Aug 2016 09:16:37 -0500
Message-Id: <1471356998-2876-3-git-send-email-billodo@redhat.com>
In-Reply-To: <1471356998-2876-1-git-send-email-billodo@redhat.com>
References: <1471356998-2876-1-git-send-email-billodo@redhat.com>
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

The kernel commit to make the ioctl promotion (334e580a6f) moved
the definitions for the XFS ioctl to uapi/linux/fs.h for the
following reason:

    Hoist the ioctl definitions for the XFS_IOC_FS[SG]SETXATTR API
    from fs/xfs/libxfs/xfs_fs.h to include/uapi/linux/fs.h so that
    the ioctls can be used by all filesystems, not just XFS. This
    enables (initially) ext4 to use the ioctl to set project IDs on
    inodes.

This means we now need to handle this change in userspace as the
uapi/linux/fs.h file may not contain the definitions (i.e. new
xfsprogs/ old linux uapi files) xfsprogs needs to build. Hence we
need to massage the definition in xfs_fs.h to take the values from
the system header if it exists, otherwise keep the old definitions
for compatibility and platforms other than linux..

This patch was originally submitted by Dave Chinner
(http://oss.sgi.com/archives/xfs/2016-02/msg00108.html)

Resubmitting with changes to accomodate upstream changes since
initial submission.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 libxfs/xfs_fs.h | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 085ea6f..6ecb7f2 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -35,10 +35,41 @@ struct dioattr {
 };
 #endif
 
+/* check whether we have to define FS_IOC_FS[GS]ETXATTR ourselves */
+#ifndef FS_IOC_FSGETXATTR
+struct fsxattr {
+	__u32		fsx_xflags;	/* xflags field value (get/set) */
+	__u32		fsx_extsize;	/* extsize field value (get/set)*/
+	__u32		fsx_projid;	/* project identifier (get/set) */
+	unsigned char	fsx_pad[12];
+};
+
+/*
+ * Flags for the fsx_xflags field
+ */
+#define FS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
+#define FS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
+#define FS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
+#define FS_XFLAG_APPEND		0x00000010	/* all writes append */
+#define FS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
+#define FS_XFLAG_NOATIME	0x00000040	/* do not update access time */
+#define FS_XFLAG_NODUMP		0x00000080	/* do not include in backups */
+#define FS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
+#define FS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
+#define FS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
+#define FS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
+#define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
+#define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
+#define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
+#define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
+
+#define FS_IOC_FSGETXATTR     _IOR ('X', 31, struct fsxattr)
+#define FS_IOC_FSSETXATTR     _IOW ('X', 32, struct fsxattr)
+
+#endif
+
 /*
- * Flags for the bs_xflags/fsx_xflags field in XFS_IOC_FS[GS]ETXATTR[A]
- * These are for backwards compatibility only. New code should
- * use the kernel [4.5 onwards] defined FS_XFLAG_* definitions directly.
+ * Flags for the bs_xflags/fsx_xflags field in FS_IOC_FS[GS]ETXATTR[A]
  */
 #define	XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME
 #define	XFS_XFLAG_PREALLOC	FS_XFLAG_PREALLOC
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
