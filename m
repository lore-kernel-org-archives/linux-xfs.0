Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([54.37.238.230]:53370 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbeJGFNQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Oct 2018 01:13:16 -0400
From: Adam Borowski <kilobyte@angband.pl>
Date: Sun,  7 Oct 2018 00:08:11 +0200
Message-Id: <20181006220811.21482-1-kilobyte@angband.pl>
In-Reply-To: <20181005234009.GJ12041@dastard>
References: <20181005234009.GJ12041@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2] xfs: add a define for statfs magic to uapi
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>

Needed by userspace programs that call fstatfs().

It'd be natural to publish XFS_SB_MAGIC in uapi, but while these two have
identical values, they have different semantic meaning: one is an enum
cookie meant for statfs, the other a signature of the on-disk format.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
> > include/uapi/linux/magic.h would get:
> >
> > #define XFS_STATFS_MAGIC      0x58465342      /* 'XFSB' */
>
> $ man statfs |grep 0x5846
>            XFS_SUPER_MAGIC       0x58465342

Indeed, not only it is documented this way, but almost every other
filesystem has the define named FOO_SUPER_MAGIC.  Thus, inventing something
else doesn't seem to be a good idea to me.

On the other hand, this might be considered bikeshedding, and you're the
maintainer of this particular shed...


 fs/xfs/xfs_super.c         | 5 +++--
 include/uapi/linux/magic.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 207ee302b1bb..90b08051a4f3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -43,6 +43,7 @@
 #include <linux/dax.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/magic.h>
 #include <linux/mount.h>
 #include <linux/mempool.h>
 #include <linux/writeback.h>
@@ -1097,7 +1098,7 @@ xfs_fs_statfs(
 	xfs_extlen_t		lsize;
 	int64_t			ffree;
 
-	statp->f_type = XFS_SB_MAGIC;
+	statp->f_type = XFS_SUPER_MAGIC;
 	statp->f_namelen = MAXNAMELEN - 1;
 
 	id = huge_encode_dev(mp->m_ddev_targp->bt_dev);
@@ -1650,7 +1651,7 @@ xfs_fs_fill_super(
 	 * we must configure the block size in the superblock before we run the
 	 * full mount process as the mount process can lookup and cache inodes.
 	 */
-	sb->s_magic = XFS_SB_MAGIC;
+	sb->s_magic = XFS_SUPER_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
 	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
 	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 1a6fee974116..96c24478d8ce 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -29,6 +29,7 @@
 #define HPFS_SUPER_MAGIC	0xf995e849
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
+#define XFS_SUPER_MAGIC		0x58465342	/* "XFSB" */
 #define PSTOREFS_MAGIC		0x6165676C
 #define EFIVARFS_MAGIC		0xde5e81e4
 #define HOSTFS_SUPER_MAGIC	0x00c0ffee
-- 
2.19.1
