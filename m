Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47788 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751998AbdIAQkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 12:40:39 -0400
Date: Fri, 1 Sep 2017 09:40:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/2] mkfs: pass a custom cowextsize into the created
 filesystem
Message-ID: <20170901164035.GF3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Create a -d option to mkfs.xfs that enables administrators to set
the CoW extent size hint on the created files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/util.c       |   26 ++++++++++++++++++++++++--
 man/man8/mkfs.xfs.8 |    7 +++++++
 mkfs/xfs_mkfs.c     |   20 ++++++++++++++++++++
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/libxfs/util.c b/libxfs/util.c
index 0e2f29e..4f82d7f 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -175,6 +175,26 @@ libxfs_trans_ichgtime(
 	}
 }
 
+static inline uint16_t
+xflags_to_diflags(
+	__u32		xflags)
+{
+	/* bottom 15 xflag bits correspond to diflag bits */
+	return xflags & 0x7FFF;
+}
+
+static inline uint64_t
+xflags_to_diflags2(
+	__u32		xflags)
+{
+	uint64_t	ret = 0;
+
+	if (xflags & FS_XFLAG_COWEXTSIZE)
+		ret |= XFS_DIFLAG2_COWEXTSIZE;
+
+	return ret;
+}
+
 /*
  * Allocate an inode on disk and return a copy of its in-core version.
  * Set mode, nlink, and rdev appropriately within the inode.
@@ -254,15 +274,17 @@ libxfs_ialloc(
 	ip->i_d.di_extsize = pip ? 0 : fsx->fsx_extsize;
 	ip->i_d.di_dmevmask = 0;
 	ip->i_d.di_dmstate = 0;
-	ip->i_d.di_flags = pip ? 0 : fsx->fsx_xflags;
+	ip->i_d.di_flags = pip ? 0 : xflags_to_diflags(fsx->fsx_xflags);
 
 	if (ip->i_d.di_version == 3) {
 		ASSERT(ip->i_d.di_ino == ino);
 		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid));
 		VFS_I(ip)->i_version = 1;
-		ip->i_d.di_flags2 = 0;
+		ip->i_d.di_flags2 = pip ? 0 :
+				xflags_to_diflags2(fsx->fsx_xflags);
 		ip->i_d.di_crtime.t_sec = (int32_t)VFS_I(ip)->i_mtime.tv_sec;
 		ip->i_d.di_crtime.t_nsec = (int32_t)VFS_I(ip)->i_mtime.tv_nsec;
+		ip->i_d.di_cowextsize = pip ? 0 : fsx->fsx_cowextsize;
 	}
 
 	flags = XFS_ILOG_CORE;
diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 33831c9..bbbe1c5 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -279,6 +279,13 @@ and
 .B agsize
 suboptions are mutually exclusive.
 .TP
+.BI cowextsize= value
+Set the copy-on-write extent size hint on all inodes created by
+.BR mkfs.xfs "."
+The value must be provided in units of filesystem blocks.
+If the value is zero, the default value (currently 32 blocks) will be used.
+Directories will pass on this hint to newly created children.
+.TP
 .BI name= value
 This can be used to specify the name of the special file containing
 the filesystem. In this case, the log section must be specified as
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 024cb02..ea0a317 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -187,6 +187,8 @@ struct opt_params dopts = {
 		"projinherit",
 #define D_EXTSZINHERIT	14
 		"extszinherit",
+#define D_COWEXTSIZE	15
+		"cowextsize",
 		NULL
 	},
 	.subopt_params = {
@@ -303,6 +305,12 @@ struct opt_params dopts = {
 		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
+		{ .index = D_COWEXTSIZE,
+		  .conflicts = { LAST_CONFLICT },
+		  .minval = 0,
+		  .maxval = UINT_MAX,
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
 	},
 };
 
@@ -1638,6 +1646,13 @@ main(
 					fsx.fsx_xflags |=
 						XFS_DIFLAG_EXTSZINHERIT;
 					break;
+				case D_COWEXTSIZE:
+					fsx.fsx_cowextsize = getnum(value,
+							&dopts,
+							D_COWEXTSIZE);
+					fsx.fsx_xflags |=
+						FS_XFLAG_COWEXTSIZE;
+					break;
 				default:
 					unknown('d', value);
 				}
@@ -2142,6 +2157,11 @@ _("reflink not supported without CRC support\n"));
 		sb_feat.reflink = false;
 	}
 
+	if ((fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) && !sb_feat.reflink) {
+		fprintf(stderr,
+_("cowextsize not supported without reflink support\n"));
+		usage();
+	}
 
 	if (nsflag || nlflag) {
 		if (dirblocksize < blocksize ||
