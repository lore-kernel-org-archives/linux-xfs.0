Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6FE387F91
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:23:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B0B7AC001
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:23:23 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id HNL60GV0pELdCiuf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:23:21 -0800 (PST)
Subject: [PATCH 06/21] xfsdocs: update types
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:22:57 -0800
Message-ID: <20151111192257.14235.17490.stgit@birch.djwong.org>
In-Reply-To: <20151111192218.14235.13928.stgit@birch.djwong.org>
References: <20151111192218.14235.13928.stgit@birch.djwong.org>
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
To: hch@infradead.org, david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Update the common data types to reflect modern XFS source.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |    8 +++----
 .../XFS_Filesystem_Structure/common_types.asciidoc |   23 ++++++++++++++------
 .../XFS_Filesystem_Structure/data_extents.asciidoc |    4 ++-
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    2 +-
 4 files changed, 23 insertions(+), 14 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index afbbb67..b511324 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -47,11 +47,11 @@ struct xfs_sb
 {
 	__uint32_t		sb_magicnum;
 	__uint32_t		sb_blocksize;
-	xfs_drfsbno_t		sb_dblocks;
-	xfs_drfsbno_t		sb_rblocks;
-	xfs_drtbno_t		sb_rextents;
+	xfs_rfsblock_t		sb_dblocks;
+	xfs_rfsblock_t		sb_rblocks;
+	xfs_rtblock_t		sb_rextents;
 	uuid_t			sb_uuid;
-	xfs_dfsbno_t		sb_logstart;
+	xfs_fsblock_t		sb_logstart;
 	xfs_ino_t		sb_rootino;
 	xfs_ino_t		sb_rbmino;
 	xfs_ino_t		sb_rsumino;
diff --git a/design/XFS_Filesystem_Structure/common_types.asciidoc b/design/XFS_Filesystem_Structure/common_types.asciidoc
index ea2d21f..51909be 100644
--- a/design/XFS_Filesystem_Structure/common_types.asciidoc
+++ b/design/XFS_Filesystem_Structure/common_types.asciidoc
@@ -10,7 +10,7 @@ Unsigned 64 bit absolute xref:Inode_Numbers[inode number].
 Signed 64 bit file offset.
 
 *xfs_daddr_t*::
-Signed 64 bit disk address.
+Signed 64 bit disk address (sectors).
 
 *xfs_agnumber_t*::
 Unsigned 32 bit xref:Allocation_Groups[AG number].
@@ -22,7 +22,10 @@ Unsigned 32 bit AG relative block number.
 Unsigned 32 bit xref:Data_Extents[extent] length in blocks.
 
 *xfs_extnum_t*::
-Signed 32 bit number of extents in a file.
+Signed 32 bit number of extents in a data fork.
+
+*xfs_aextnum_t*::
+Signed 16 bit number of extents in an attribute fork.
 
 *xfs_dablk_t*::
 Unsigned 32 bit block number for xref:Directories[directories] and
@@ -31,19 +34,25 @@ xref:Extended_Attributes[extended attributes].
 *xfs_dahash_t*::
 Unsigned 32 bit hash of a directory file name or extended attribute name.
 
-*xfs_dfsbno_t*::
+*xfs_fsblock_t*::
 Unsigned 64 bit filesystem block number combining
 xref:Allocation_Groups[AG number] and block offset into the AG.
 
-*xfs_drfsbno_t*::
+*xfs_rfsblock_t*::
 Unsigned 64 bit raw filesystem block number.
 
-*xfs_drtbno_t*::
+*xfs_rtblock_t*::
 Unsigned 64 bit extent number in the xref:Real-time_Devices[real-time]
 sub-volume.
 
-*xfs_dfiloff_t*::
+*xfs_fileoff_t*::
 Unsigned 64 bit block offset into a file.
 
-*xfs_dfilblks_t*::
+*xfs_filblks_t*::
 Unsigned 64 bit block count for a file.
+
+*uuid_t*::
+16-byte universally unique identifier (UUID).
+
+*xfs_fsize_t*::
+Signed 64 bit byte size of a file.
diff --git a/design/XFS_Filesystem_Structure/data_extents.asciidoc b/design/XFS_Filesystem_Structure/data_extents.asciidoc
index b71bc52..8b09fee 100644
--- a/design/XFS_Filesystem_Structure/data_extents.asciidoc
+++ b/design/XFS_Filesystem_Structure/data_extents.asciidoc
@@ -217,9 +217,9 @@ struct xfs_bmdr_block {
      __be16                     bb_numrecs;
 };
 struct xfs_bmbt_key {
-     xfs_dfiloff_t              br_startoff;
+     xfs_fileoff_t              br_startoff;
 };
-typedef xfs_dfsbno_t xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
+typedef xfs_fsblock_t xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
 ----
 
 * On disk, the B+tree node starts with the +xfs_bmbr_block_t+ header followed by
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index dfdcc32..7262178 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -88,7 +88,7 @@ struct xfs_dinode_core {
      xfs_timestamp_t           di_mtime;
      xfs_timestamp_t           di_ctime;
      xfs_fsize_t               di_size;
-     xfs_drfsbno_t             di_nblocks;
+     xfs_rfsblock_t            di_nblocks;
      xfs_extlen_t              di_extsize;
      xfs_extnum_t              di_nextents;
      xfs_aextnum_t             di_anextents;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
