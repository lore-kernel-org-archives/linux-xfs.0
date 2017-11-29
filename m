Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26275 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751936AbdK2BsU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 20:48:20 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT1mIuO000610
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:48:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1mIoF019054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:48:18 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAT1mI6Y015331
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:48:18 GMT
Date: Tue, 28 Nov 2017 17:48:17 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfsdocs: fix some small discrepancies with libxfs
Message-ID: <20171129014817.GD21412@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix some small discrepancies between the current libxfs code and this doc.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 design/XFS_Filesystem_Structure/btrees.asciidoc    |    2 +-
 design/XFS_Filesystem_Structure/dabtrees.asciidoc  |    8 ++++++--
 .../extended_attributes.asciidoc                   |    1 +
 .../internal_inodes.asciidoc                       |    2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/design/XFS_Filesystem_Structure/btrees.asciidoc b/design/XFS_Filesystem_Structure/btrees.asciidoc
index 91a53c4..19680d0 100644
--- a/design/XFS_Filesystem_Structure/btrees.asciidoc
+++ b/design/XFS_Filesystem_Structure/btrees.asciidoc
@@ -104,7 +104,7 @@ Specifies the magic number for the per-AG B+tree block.
 *bb_level*::
 The level of the tree in which this block is found.  If this value is 0, this
 is a leaf block and contains records; otherwise, it is a node block and
-contains keys and pointers.
+contains keys and pointers.  Level values increase towards the root.
 
 *bb_numrecs*::
 Number of records in this block.
diff --git a/design/XFS_Filesystem_Structure/dabtrees.asciidoc b/design/XFS_Filesystem_Structure/dabtrees.asciidoc
index 18247ca..29cfdab 100644
--- a/design/XFS_Filesystem_Structure/dabtrees.asciidoc
+++ b/design/XFS_Filesystem_Structure/dabtrees.asciidoc
@@ -170,7 +170,9 @@ Directory/attribute block info.  The magic number is +XFS_DA_NODE_MAGIC+
 Number of node entries in this block.
 
 *level*::
-The level of this block in the B+tree.
+The level of this block in the B+tree.  Levels start at 1 for blocks
+that point to directory or attribute data blocks and increase towards
+the root.
 
 *hashval*::
 The hash value of a particular record.
@@ -206,7 +208,9 @@ Directory/attribute block info.  The magic number is +XFS_DA3_NODE_MAGIC+
 Number of node entries in this block.
 
 *level*::
-The level of this block in the B+tree.
+The level of this block in the B+tree.  Levels start at 1 for blocks
+that point to directory or attribute data blocks, and increase towards
+the root.
 
 *pad32*::
 Padding to maintain alignment.
diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
index bb773d5..7df2d3d 100644
--- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
+++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
@@ -473,6 +473,7 @@ typedef struct xfs_attr3_leaf_hdr {
      __u8                       holes;
      __u8                       pad1;
      xfs_attr_leaf_map_t        freemap[3];
+     __be32                     pad2;
 } xfs_attr3_leaf_hdr_t;
 
 
diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index e6bf75f..f5c2654 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -59,7 +59,7 @@ struct xfs_disk_dquot {
 };
 struct xfs_dqblk {
      struct xfs_disk_dquot dd_diskdq;
-     char                  dd_fill[32];
+     char                  dd_fill[4];
 
      /* version 5 filesystem fields begin here */
      __be32                dd_crc;
