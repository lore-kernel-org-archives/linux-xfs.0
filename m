Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5522E7F56
	for <xfs@oss.sgi.com>; Sun, 16 Aug 2015 06:34:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49754304059
	for <xfs@oss.sgi.com>; Sun, 16 Aug 2015 04:34:13 -0700 (PDT)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id lVbsHPfOclmpgvuO for
	<xfs@oss.sgi.com>; Sun, 16 Aug 2015 04:34:11 -0700 (PDT)
Received: from [192.168.0.220] (cpc2-stev6-2-0-cust318.9-2.cable.virginm.net
	[213.107.89.63]) (Authenticated sender: roger)
	by omni.filmlight.ltd.uk (Postfix) with ESMTPSA id 415508671E8
	for <xfs@oss.sgi.com>; Sun, 16 Aug 2015 12:34:11 +0100 (BST)
From: Roger Willcocks <roger@filmlight.ltd.uk>
Subject: [PATCH] v3 inodes are only valid on crc-enabled filesystems
Message-Id: <F80944E7-F176-450B-A98E-87A0F6DC196A@filmlight.ltd.uk>
Date: Sun, 16 Aug 2015 12:34:24 +0100
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
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
To: xfs@oss.sgi.com

Fix an xfs_repair regression reported by Leslie Rhorer where a bad
(v3) inode version number was not reset.

Signed-off-by: Roger Willcocks <roger@filmlight.ltd.uk>
---
db/check.c             |  2 +-
include/libxfs.h       |  2 +-
include/xfs_dinode.h   | 10 +++++++++-
libxfs/xfs_inode_buf.c |  2 +-
repair/dinode.c        |  7 +++----
repair/prefetch.c      |  2 +-
6 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/db/check.c b/db/check.c
index c4c972f..b5c3b8e 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2637,7 +2637,7 @@ process_inode(
		error++;
		return;
	}
-	if (!XFS_DINODE_GOOD_VERSION(idic.di_version)) {
+	if (!xfs_dinode_good_version(mp, idic.di_version)) {
		if (isfree || v)
			dbprintf(_("bad version number %#x for inode %lld\n"),
				idic.di_version, ino);
diff --git a/include/libxfs.h b/include/libxfs.h
index 962e319..450a38f 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -51,7 +51,6 @@
#include <xfs/xfs_alloc_btree.h>
#include <xfs/xfs_ialloc_btree.h>
#include <xfs/xfs_attr_sf.h>
-#include <xfs/xfs_dinode.h>
#include <xfs/xfs_inode_fork.h>
#include <xfs/xfs_inode_buf.h>
#include <xfs/xfs_alloc.h>
@@ -279,6 +278,7 @@ extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 */
#include <xfs/xfs_da_format.h>
#include <xfs/xfs_da_btree.h>
+#include <xfs/xfs_dinode.h>
#include <xfs/xfs_dir2.h>

/*
diff --git a/include/xfs_dinode.h b/include/xfs_dinode.h
index 623bbe8..2079061 100644
--- a/include/xfs_dinode.h
+++ b/include/xfs_dinode.h
@@ -19,7 +19,15 @@
#define	__XFS_DINODE_H__

#define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
-#define XFS_DINODE_GOOD_VERSION(v)	((v) >= 1 && (v) <= 3)
+
+static inline bool
+xfs_dinode_good_version(struct xfs_mount *mp, __u8 version)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		return version == 3;
+
+	return version == 1 || version == 2;
+}

typedef struct xfs_timestamp {
	__be32		t_sec;		/* timestamp seconds */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index de16ed9..c79b90b 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -78,7 +78,7 @@ xfs_inode_buf_verify(
		dip = (struct xfs_dinode *)xfs_buf_offset(bp,
					(i << mp->m_sb.sb_inodelog));
		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
-			    XFS_DINODE_GOOD_VERSION(dip->di_version);
+			xfs_dinode_good_version(mp, dip->di_version);
		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
						XFS_ERRTAG_ITOBP_INOTOBP,
						XFS_RANDOM_ITOBP_INOTOBP))) {
diff --git a/repair/dinode.c b/repair/dinode.c
index 035212c..b76066b 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -129,7 +129,7 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
		dinoc->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
	}

-	if (!XFS_DINODE_GOOD_VERSION(dinoc->di_version) ||
+	if (!xfs_dinode_good_version(mp, dinoc->di_version) ||
	    (!fs_inode_nlink && dinoc->di_version > 1))  {
		__dirty_no_modify_ret(dirty);
		if (xfs_sb_version_hascrc(&mp->m_sb))
@@ -2331,9 +2331,8 @@ process_dinode_int(xfs_mount_t *mp,
		}
	}

-	if (!XFS_DINODE_GOOD_VERSION(dino->di_version) ||
-	    (!fs_inode_nlink && dino->di_version > 1) ||
-	    (xfs_sb_version_hascrc(&mp->m_sb) && dino->di_version < 3) )  {
+	if (!xfs_dinode_good_version(mp, dino->di_version) ||
+	    (!fs_inode_nlink && dino->di_version > 1)) {
		retval = 1;
		if (!uncertain)
			do_warn(_("bad version number 0x%x on inode %" PRIu64 "%c"),
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 7ea0d36..3631ff5 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -419,7 +419,7 @@ pf_read_inode_dirs(
		if (be16_to_cpu(dino->di_magic) != XFS_DINODE_MAGIC)
			continue;

-		if (!XFS_DINODE_GOOD_VERSION(dino->di_version) ||
+		if (!xfs_dinode_good_version(mp, dino->di_version) ||
				(!fs_inode_nlink && dino->di_version > 1))
			continue;

-- 
2.5.0.rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
