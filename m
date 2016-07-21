Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64E147CAF
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:56:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1AD2D304048
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:56:21 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ry2chXjU3Lo0IA6N (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:56:19 -0700 (PDT)
Subject: [PATCH 02/47] vfs: support FS_XFLAG_REFLINK and FS_XFLAG_COWEXTSIZE
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:56:14 -0700
Message-ID: <146907697404.25461.4210564656872865210.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Introduce XFLAGs for the new XFS reflink inode flag and the CoW extent
size hint, and actually plumb the CoW extent size hint into the fsxattr
structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/uapi/linux/fs.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3b00f7c..fb371a5 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -157,7 +157,8 @@ struct fsxattr {
 	__u32		fsx_extsize;	/* extsize field value (get/set)*/
 	__u32		fsx_nextents;	/* nextents field value (get)	*/
 	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
+	__u32		fsx_cowextsize;	/* CoW extsize field value (get/set)*/
+	unsigned char	fsx_pad[8];
 };
 
 /*
@@ -178,6 +179,8 @@ struct fsxattr {
 #define FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
+#define FS_XFLAG_REFLINK	0x00010000	/* file is reflinked */
+#define FS_XFLAG_COWEXTSIZE	0x00020000	/* CoW extent size allocator hint */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
