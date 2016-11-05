Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51281 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbcKEAIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:08:47 -0400
Subject: [PATCH 07/16] libxfs: fix whitespace to match the kernel
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:08:42 -0700
Message-ID: <147830452288.26713.1685153640691389461.stgit@birch.djwong.org>
In-Reply-To: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Fix some minor whitespace errors so that my automated libxfs diff
scanning will stop reporting this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_dir2_node.c  |    2 ++
 libxfs/xfs_format.h     |    1 -
 libxfs/xfs_inode_buf.c  |    1 -
 libxfs/xfs_inode_fork.c |    1 +
 4 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index df599f9..b75b432 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -2146,12 +2146,14 @@ xfs_dir2_node_replace(
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
+
 	/*
 	 * We have to save new inode number and ftype since
 	 * xfs_da3_node_lookup_int() is going to overwrite them
 	 */
 	inum = args->inumber;
 	ftype = args->filetype;
+
 	/*
 	 * Lookup the entry to change in the btree.
 	 */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 172fdfb..8628bab 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -473,7 +473,6 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
 #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
-
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 4796a59..8732359 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -537,7 +537,6 @@ xfs_iread(
 	}
 
 	ASSERT(ip->i_d.di_version >= 2);
-
 	ip->i_delayed_blks = 0;
 
 	/*
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 8212f77..2799e2d 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -29,6 +29,7 @@
 #include "xfs_attr_sf.h"
 #include "xfs_da_format.h"
 
+
 kmem_zone_t *xfs_ifork_zone;
 
 STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);

