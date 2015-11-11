Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 30F6729DFC
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:24:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3CE9AC005
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:24:36 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id BD7fCrCr8NHfIUU7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:24:32 -0800 (PST)
Subject: [PATCH 15/21] xfsdocs: add documentation of v5 fields
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:24:07 -0800
Message-ID: <20151111192407.14235.89932.stgit@birch.djwong.org>
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

Document the new fields and data structures added in XFS v5 filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |  223 +++++++++++++++++++
 .../XFS_Filesystem_Structure/data_extents.asciidoc |   35 +++
 .../XFS_Filesystem_Structure/directories.asciidoc  |  230 +++++++++++++++++++-
 design/XFS_Filesystem_Structure/docinfo.xml        |   16 +
 .../extended_attributes.asciidoc                   |   81 +++++++
 .../internal_inodes.asciidoc                       |   15 +
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   62 +++++
 .../symbolic_links.asciidoc                        |   45 ++++
 8 files changed, 675 insertions(+), 32 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 9ba26c2..845b359 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -40,8 +40,6 @@ superblock is one sector in length.
 The superblock is defined by the following structure. The description of each
 field follows.
 
-TODO: update for v5 formats.
-
 [source, c]
 ----
 struct xfs_sb
@@ -91,6 +89,20 @@ struct xfs_sb
 	__uint16_t		sb_logsectsize;
 	__uint32_t		sb_logsunit;
 	__uint32_t		sb_features2;
+	__uint32_t		sb_bad_features2;
+
+	/* version 5 superblock fields start here */
+	__uint32_t		sb_features_compat;
+	__uint32_t		sb_features_ro_compat;
+	__uint32_t		sb_features_incompat;
+	__uint32_t		sb_features_log_incompat;
+
+	__uint32_t		sb_crc;
+	xfs_extlen_t		sb_spino_align;
+
+	xfs_ino_t		sb_pquotino;
+	xfs_lsn_t		sb_lsn;
+	uuid_t			sb_meta_uuid;
 };
 ----
 *sb_magicnum*::
@@ -152,8 +164,8 @@ Number of blocks for the journaling log.
 Filesystem version number. This is a bitmask specifying the features enabled
 when creating the filesystem. Any disk checking tools or drivers that do not
 recognize any set bits must not operate upon the filesystem. Most of the flags
-indicate features introduced over time. If the value of the lower nibble is 4,
-the higher bits indicate feature flags as follows:
+indicate features introduced over time. If the value of the lower nibble is >=
+4, the higher bits indicate feature flags as follows:
 
 .Version 4 Superblock version flags
 [options="header"]
@@ -178,13 +190,17 @@ Version 2 directories are used. This is always set.
 Set if the sb_features2 field in the superblock contains more flags.
 |=====
 
+If the lower nibble of this value is 5, then this is a v5 filesystem; the
++XFS_SB_VERSION2_CRCBIT+ feature must be set in +sb_features2+.
+
 *sb_sectsize*::
 Specifies the underlying disk sector size in bytes.  Typically this is 512 or
 4096 bytes. This determines the minimum I/O alignment, especially for direct I/O.
 
 *sb_inodesize*::
 Size of the inode in bytes. The default is 256 (2 inodes per standard sector)
-but can be made as large as 2048 bytes when creating the filesystem.
+but can be made as large as 2048 bytes when creating the filesystem.  On a v5
+filesystem, the default inode size is 512 bytes.
 
 *sb_inopblock*::
 Number of inodes per block. This is equivalent to +sb_blocksize / sb_inodesize+.
@@ -324,12 +340,81 @@ its parent inode. The primary purpose for this information is in backup systems.
 can be used to enforce disk space usage quotas for a particular group of
 directories.  This flag indicates that project IDs can be 32 bits in size.
 
+| +XFS_SB_VERSION2_CRCBIT+	|
+Metadata checksumming.  All metadata blocks have an extended header containing
+the block checksum, a copy of the metadata UUID, the log sequence number of the
+last update to prevent stale replays, and a back pointer to the owner of the
+block.  This feature must be and can only be set if the lowest nibble of
++sb_versionnum+ is set to 5.
+
 | +XFS_SB_VERSION2_FTYPE+	|
 Directory file type.  Each directory entry records the type of the inode to
 which the entry points.  This speeds up directory iteration by removing the
 need to load every inode into memory.
 |=====
 
+*sb_bad_features2*::
+This field mirrors +sb_features2+, due to past 64-bit alignment errors.
+
+*sb_features_compat*::
+Read-write compatible feature flags.  The kernel can still read and write this
+FS even if it doesn't understand the flag.  Currently, there are no valid
+flags.
+
+*sb_features_ro_compat*::
+Read-only compatible feature flags.  The kernel can still read this FS even if
+it doesn't understand the flag.
+
+.Extended Version 5 Superblock Read-Only compatibility flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_SB_FEAT_RO_COMPAT_FINOBT+ |
+Free inode B+tree.  Each allocation group contains a B+tree to track inode chunks
+containing free inodes.  This is a performance optimization to reduce the time
+required to allocate inodes.
+|=====
+
+*sb_features_incompat*::
+Read-write incompatible feature flags.  The kernel cannot read or write this
+FS if it doesn't understand the flag.
+
+.Extended Version 5 Superblock Read-Write incompatibility flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_SB_FEAT_INCOMPAT_FTYPE+ |
+Directory file type.  Each directory entry tracks the type of the inode to
+which the entry points.  This is a performance optimization to remove the need
+to load every inode into memory to iterate a directory.
+
+| +XFS_SB_FEAT_INCOMPAT_META_UUID+ |
+Metadata UUID.  The UUID stamped into each metadata block must match the value
+in +sb_meta_uuid+.  This enables the administrator to change +sb_uuid+ at will
+without having to rewrite the entire filesystem.
+|=====
+
+*sb_features_log_incompat*::
+Read-write incompatible feature flags for the log.  The kernel cannot read or
+write this FS log if it doesn't understand the flag.  Currently, no flags are
+defined.
+
+*sb_crc*::
+Superblock checksum.
+
+*sb_spino_align*::
+Sparse inode alignment.
+
+*sb_pquotino*::
+Project quota inode.
+
+*sb_lsn*::
+Log sequence number of the last superblock update.
+
+*sb_meta_uuid*::
+If the +XFS_SB_FEAT_INCOMPAT_META_UUID+ feature is set, then the UUID field in
+all metadata blocks must match this UUID.  If not, the block header UUID field
+must match +sb_uuid+.
 
 === xfs_db Superblock Example
 
@@ -405,7 +490,7 @@ features2 = 8
 
 The XFS filesystem tracks free space in an allocation group using two B+trees.
 One B+tree tracks space by block number, the second by the size of the free
-space block. This scheme allows XFS to quickly find free space near a given
+space block. This scheme allows XFS to find quickly free space near a given
 block or of a given size.
 
 All block numbers, indexes, and counts are AG relative.
@@ -434,6 +519,15 @@ struct xfs_agf {
      __be32              agf_freeblks;
      __be32              agf_longest;
      __be32              agf_btreeblks;
+
+     /* version 5 filesystem fields start here */
+     uuid_t              agf_uuid;
+     __be64              agf_spare64[16];
+
+     /* unlogged fields, written during buffer writeback. */
+     __be64              agf_lsn;
+     __be32              agf_crc;
+     __be32              agf_spare2;
 };
 ----
 
@@ -483,6 +577,22 @@ Specifies the number of blocks of longest contiguous free space in the AG.
 Specifies the number of blocks used for the free space B+trees. This is only
 used if the +XFS_SB_VERSION2_LAZYSBCOUNTBIT+ bit is set in +sb_features2+.
 
+*agf_uuid*::
+The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
+depending on which features are set.
+
+*agf_spare64*::
+Empty space in the logged part of the AGF sector, for use for future features.
+
+*agf_lsn*::
+Log sequence number of the last AGF write.
+
+*agf_crc*::
+Checksum of the AGF sector.
+
+*agf_spare2*::
+Empty space in the unlogged part of the AGF sector.
+
 [[Short_Format_Btrees]]
 === Short Format B+trees
 
@@ -499,6 +609,13 @@ struct xfs_btree_sblock {
      __be16                    bb_numrecs;
      __be32                    bb_leftsib;
      __be32                    bb_rightsib;
+
+     /* version 5 filesystem fields start here */
+     __be64                    bb_blkno;
+     __be64                    bb_lsn;
+     uuid_t                    bb_uuid;
+     __be32                    bb_owner;
+     __le32                    bb_crc;
 };
 ----
 
@@ -519,6 +636,22 @@ AG block number of the left sibling of this B+tree node.
 *bb_rightsib*::
 AG block number of the right sibling of this B+tree node.
 
+*bb_blkno*::
+FS block number of this B+tree block.
+
+*bb_lsn*::
+Log sequence number of the last write to this block.
+
+*bb_uuid*::
+The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
+depending on which features are set.
+
+*bb_owner*::
+The AG number that this B+tree block ought to be in.
+
+*bb_crc*::
+Checksum of the B+tree block.
+
 [[AG_Free_Space_Btrees]]
 === AG Free Space B+trees
 
@@ -553,7 +686,9 @@ typedef __be32 xfs_alloc_ptr_t;
 * As the free space tracking is AG relative, all the block numbers are only
 32-bits.
 * The +bb_magic+ value depends on the B+tree: ``ABTB'' (0x41425442) for the block
-offset B+tree, ``ABTC'' (0x41425443) for the block count B+tree.
+offset B+tree, ``ABTC'' (0x41425443) for the block count B+tree.  On a v5
+filesystem, these are ``AB3B'' (0x41423342) and ``AB3C'' (0x41423343),
+respectively.
 * The +xfs_btree_sblock_t+ header is used for intermediate B+tree node as well
 as the leaves.
 * For a typical 4KB filesystem block size, the offset for the +xfs_alloc_ptr_t+
@@ -595,6 +730,38 @@ Active elements in the array are specified by the
 xref:AG_Free_Space_Block[AGF's] +agf_flfirst+, +agf_fllast+ and +agf_flcount+
 values. The array is managed as a circular list.
 
+On a v5 filesystem, the following header precedes the free list entries:
+
+[source, c]
+----
+struct xfs_agfl {
+     __be32              agfl_magicnum;
+     __be32              agfl_seqno;
+     uuid_t              agfl_uuid;
+     __be64              agfl_lsn;
+     __be32              agfl_crc;
+};
+----
+
+*agfl_magicnum*::
+Specifies the magic number for the AGFL sector: "XAFL" (0x5841464c).
+
+*agfl_seqno*::
+Specifies the AG number for the sector.
+
+*agfl_uuid*::
+The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
+depending on which features are set.
+
+*agfl_lsn*::
+Log sequence number of the last AGFL write.
+
+*agfl_crc*::
+Checksum of the AGFL sector.
+
+On a v4 filesystem there is no header; the array of free block numbers begins
+at the beginning of the sector.
+
 .AG Free List layout
 image::images/16.png[]
 
@@ -739,6 +906,18 @@ struct xfs_agi {
      __be32              agi_newino;
      __be32              agi_dirino;
      __be32              agi_unlinked[64];
+
+     /*
+      * v5 filesystem fields start here; this marks the end of logging region 1
+      * and start of logging region 2.
+      */
+     uuid_t              agi_uuid;
+     __be32              agi_crc;
+     __be32              agi_pad32;
+     __be64              agi_lsn;
+
+     __be32              agi_free_root;
+     __be32              agi_free_level;
 }
 ----
 *agi_magicnum*::
@@ -775,19 +954,45 @@ Deprecated and not used, this is always set to NULL (-1).
 Hash table of unlinked (deleted) inodes that are still being referenced. Refer
 to xref:Unlinked_Pointer[unlinked list pointers] for more information.
 
+*agi_uuid*::
+The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
+depending on which features are set.
+
+*agi_crc*::
+Checksum of the AGI sector.
+
+*agi_pad32*::
+Padding field, otherwise unused.
+
+*agi_lsn*::
+Log sequence number of the last write to this block.
+
+*agi_free_root*::
+Specifies the block number in the AG containing the root of the free inode
+B+tree.
+
+*agi_free_level*::
+Specifies the number of levels in the free inode B+tree.
 
 [[Inode_Btrees]]
 == Inode B+trees
 
 Inodes are allocated in chunks of 64, and a B+tree is used to track these chunks
 of inodes as they are allocated and freed. The block containing root of the
-B+tree is defined by the AGI's +agi_root+ value.
+B+tree is defined by the AGI's +agi_root+ value.  If the
++XFS_SB_FEAT_RO_COMPAT_FINOBT+ feature is enabled, a second B+tree is used to
+track the chunks containing free inodes; this is an optimization to speed up
+inode allocation.
 
 The B+tree header for the nodes and leaves use the +xfs_btree_sblock+ structure
 which is the same as the header used in the xref:AG_Free_Space_Btrees[AGF
 B+trees].
 
-The magic number of the inode B+tree is ``IABT'' (0x49414254).
+The magic number of the inode B+tree is ``IABT'' (0x49414254).  On a v5
+filesystem, the magic number is ``IAB3'' (0x49414233).
+
+The magic number of the free inode B+tree is ``FIBT'' (0x46494254).  On a v5
+filesystem, the magic number is ``FIB3'' (0x46494254).
 
 Leaves contain an array of the following structure:
 
diff --git a/design/XFS_Filesystem_Structure/data_extents.asciidoc b/design/XFS_Filesystem_Structure/data_extents.asciidoc
index af9ba44..a39045d 100644
--- a/design/XFS_Filesystem_Structure/data_extents.asciidoc
+++ b/design/XFS_Filesystem_Structure/data_extents.asciidoc
@@ -94,8 +94,9 @@ image::images/32.png[]
 
 The number of extents that can fit in the inode depends on the inode size and
 +di_forkoff+. For a default 256 byte inode with no extended attributes, a file
-can have up to 9 extents with this format. Beyond this, extents have to use the
-B+tree format.
+can have up to 9 extents with this format.  On a default v5 filesystem with 512
+byte inodes, a file can have up to 21 extents with this format.  Beyond that,
+extents have to use the B+tree format.
 
 === xfs_db Inode Data Fork Extents Example
 
@@ -242,7 +243,7 @@ and the leaves. This will be less if +di_forkoff+ is not zero (i.e. attributes
 are in use on the inode).
 
 [[Long_Format_Btrees]]
-== Long Format B+trees
+=== Long Format B+trees
 
 The subsequent nodes and leaves of the B+tree use the +xfs_btree_lblock+
 declaration:
@@ -255,11 +256,20 @@ struct xfs_btree_lblock {
      __be16                    bb_numrecs;
      __be64                    bb_leftsib;
      __be64                    bb_rightsib;
+
+     /* version 5 filesystem fields start here */
+     __be64                    bb_blkno;
+     __be64                    bb_lsn;
+     uuid_t                    bb_uuid;
+     __be64                    bb_owner;
+     __le32                    bb_crc;
+     __be32                    bb_pad;
 };
 ----
 
 *bb_magic*::
 Specifies the magic number for the BMBT block: ``BMAP'' (0x424d4150).
+On a v5 filesystem, this is ``BMA3'' (0x424d4133).
 
 *bb_level*::
 The level of the tree in which this block is found.  If this value is 0, this
@@ -275,6 +285,25 @@ FS block number of the left sibling of this B+tree node.
 *bb_rightsib*::
 FS block number of the right sibling of this B+tree node.
 
+*bb_blkno*::
+FS block number of this B+tree block.
+
+*bb_lsn*::
+Log sequence number of the last write to this block.
+
+*bb_uuid*::
+The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
+depending on which features are set.
+
+*bb_owner*::
+The AG number that this B+tree block ought to be in.
+
+*bb_crc*::
+Checksum of the B+tree block.
+
+*bb_pad*::
+Pads the structure to 64 bytes.
+
 // force-split the lists
 
 * For intermediate nodes, the data following +xfs_btree_lblock+ is the same as
diff --git a/design/XFS_Filesystem_Structure/directories.asciidoc b/design/XFS_Filesystem_Structure/directories.asciidoc
index b539535..bccf912 100644
--- a/design/XFS_Filesystem_Structure/directories.asciidoc
+++ b/design/XFS_Filesystem_Structure/directories.asciidoc
@@ -358,7 +358,7 @@ typedef struct xfs_dir2_block {
 ----
 
 *hdr*::
-Directory block header.
+Directory block header.  On a v5 filesystem this is +xfs_dir3_data_hdr_t+.
 
 *u*::
 Union of directory and unused entries.
@@ -383,8 +383,62 @@ Magic number for this directory block.
 *bestfree*::
 An array pointing to free regions in the directory block.
 
+On a v5 filesystem, directory and attribute blocks are formatted with v3
+headers, which contain extra data:
+
 [source, c]
 ----
+struct xfs_dir3_blk_hdr {
+     __be32                     magic;
+     __be32                     crc;
+     __be64                     blkno;
+     __be64                     lsn;
+     uuid_t                     uuid;
+     __be64                     owner;
+};
+----
+
+*magic*::
+Magic number for this directory block.
+
+*crc*::
+Checksum of the directory block.
+
+*blkno*::
+Block number of this directory block.
+
+*lsn*::
+Log sequence number of the last write to this block.
+
+*uuid*::
+The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
+depending on which features are set.
+
+*owner*::
+The inode number that this directory block belongs to.
+
+[source, c]
+----
+struct xfs_dir3_data_hdr {
+     struct xfs_dir3_blk_hdr    hdr;
+     xfs_dir2_data_free_t       best_free[XFS_DIR2_DATA_FD_COUNT];
+     __be32                     pad;
+};
+----
+
+*hdr*::
+The v5 directory/attribute block header.
+
+*best_free*::
+An array pointing to free regions in the directory block.
+
+*pad*::
+Padding to maintain a 64-bit alignment.
+
+Within the block, data structures are as follows:
+
+[source, c]
+-----
 typedef struct xfs_dir2_data_free {
      xfs_dir2_data_off_t        offset;
      xfs_dir2_data_off_t        length;
@@ -494,7 +548,8 @@ Following is a diagram of how these pieces fit together for a block directory.
 .Block directory layout
 image::images/43.png[]
 
-* The magic number in the header is ``XD2B'' (0x58443242).
+* The magic number in the header is ``XD2B'' (0x58443242), or ``XDB3'' (0x58444233)
+on a v5 filesystem.
 
 * The +tag+ in the +xfs_dir2_data_entry_t+ structure stores its offset from the
 start of the block.
@@ -736,7 +791,7 @@ Currently, this is 32GB and in the extent view, a block offset of
 decimal).
 
 * Blocks with directory entries (``data'' extents) have the magic number ``X2D2''
-(0x58443244).
+(0x58443244), or ``XDD3'' (0x58444433) on a v5 filesystem.
 
 * The ``data'' extents have a new header (no ``leaf'' data):
 
@@ -749,7 +804,7 @@ typedef struct xfs_dir2_data {
 ----
 
 *hdr*::
-Data block header.
+Data block header.  On a v5 filesystem, this field is +struct xfs_dir3_data_hdr+.
 
 *u*::
 Union of directory and unused entries, exactly the same as in a block directory.
@@ -769,7 +824,8 @@ typedef struct xfs_dir2_leaf {
 ----
 
 *hdr*::
-Directory leaf header.
+Directory leaf header.  On a v5 filesystem this is +struct
+xfs_dir3_leaf_hdr_t+.
 
 *ents*::
 Hash values of the entries in this block.
@@ -800,6 +856,28 @@ Number of stale/zeroed leaf entries.
 
 [source, c]
 ----
+struct xfs_dir3_leaf_hdr {
+     struct xfs_da3_blkinfo    info;
+     __uint16_t                count;
+     __uint16_t                stale;
+     __be32                    pad;
+};
+----
+
+*info*::
+Leaf B+tree block header.
+
+*count*::
+Number of leaf entries.
+
+*stale*::
+Number of stale/zeroed leaf entries.
+
+*pad*::
+Padding to maintain alignment rules.
+
+[source, c]
+----
 typedef struct xfs_dir2_leaf_tail {
      __uint32_t                bestcount;
 } xfs_dir2_leaf_tail_t;
@@ -839,7 +917,58 @@ Padding to maintain alignment.
 
 // split lists
 
-* The magic number of the leaf block is +XFS_DIR2_LEAF1_MAGIC+ (0xd2f1).
+* On a v5 filesystem, the leaves use the +struct xfs_da3_blkinfo_t+ filesystem
+block header. This header is used in the same place as +xfs_da_blkinfo_t+:
+
+[source, c]
+----
+struct xfs_da3_blkinfo {
+     /* these values are inside xfs_da_blkinfo */
+     __be32                     forw;
+     __be32                     back;
+     __be16                     magic;
+     __be16                     pad;
+
+     __be32                     crc;
+     __be64                     blkno;
+     __be64                     lsn;
+     uuid_t                     uuid;
+     __be64                     owner;
+};
+----
+
+*forw*::
+Logical block offset of the previous B+tree block at this level.
+
+*back*::
+Logical block offset of the next B+tree block at this level.
+
+*magic*::
+Magic number for this directory/attribute block.
+
+*pad*::
+Padding to maintain alignment.
+
+*crc*::
+Checksum of the directory/attribute block.
+
+*blkno*::
+Block number of this directory/attribute block.
+
+*lsn*::
+Log sequence number of the last write to this block.
+
+*uuid*::
+The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
+depending on which features are set.
+
+*owner*::
+The inode number that this directory/attribute block belongs to.
+
+// split lists
+
+* The magic number of the leaf block is +XFS_DIR2_LEAF1_MAGIC+ (0xd2f1); on a
+v5 filesystem it is +XFS_DIR3_LEAF1_MAGIC+ (0x3df1).
 
 * The size of the +ents+ array is specified by +hdr.count+.
 
@@ -1107,13 +1236,15 @@ each ``data'' block. This is not possible with more than one leaf.
 
 * After the ``freeindex'' data moves to its own block, it is possible for the
 leaf data to fit within a single leaf block.  This single leaf block has a
-magic number of +XFS_DIR2_LEAFN_MAGIC+ (0xd2ff).
+magic number of +XFS_DIR2_LEAFN_MAGIC+ (0xd2ff) or on a v5 filesystem,
++XFS_DIR3_LEAFN_MAGIC+ (0x3dff).
 
 * The ``leaf'' blocks eventually change into a B+tree with the generic B+tree
 header pointing to directory ``leaves'' as described in
 xref:Leaf_Directories[Leaf Directories]. Blocks with leaf data still have the
 +LEAFN_MAGIC+ magic number as outlined above.  The top-level tree blocks are
-called ``nodes'' and have a magic number of +XFS_DA_NODE_MAGIC+ (0xfebe).
+called ``nodes'' and have a magic number of +XFS_DA_NODE_MAGIC+ (0xfebe), or on
+a v5 filesystem, +XFS_DA3_NODE_MAGIC+ (0x3ebe).
 
 * Distinguishing between a combined leaf/freeindex block (+LEAF1_MAGIC+), a
 leaf-only block (+LEAFN_MAGIC+), and a btree node block (+NODE_MAGIC+) can only
@@ -1161,6 +1292,50 @@ An array specifying the best free counts in each directory data block.
 
 // split lists
 
+* On a v5 filesystem, the freeindex block uses the following structures:
+
+[source, c]
+----
+struct xfs_dir3_free_hdr {
+     struct xfs_dir3_blk_hdr   hdr;
+     __int32_t                 firstdb;
+     __int32_t                 nvalid;
+     __int32_t                 nused;
+     __int32_t                 pad;
+};
+----
+
+*hdr*::
+v3 directory block header.  The magic number is "XDF3" (0x0x58444633).
+
+*firstdb*::
+The starting directory block number for the bests array.
+
+*nvalid*::
+Number of elements in the bests array.
+
+*nused*::
+Number of valid elements in the bests array.
+
+*pad*::
+Padding to maintain alignment.
+
+[source, c]
+----
+struct xfs_dir3_free {
+     xfs_dir3_free_hdr_t       hdr;
+     __be16                    bests[1];
+};
+----
+
+*hdr*::
+Free block header.
+
+*bests*::
+An array specifying the best free counts in each directory data block.
+
+// split lists
+
 * The location of the leaf blocks can be in any order, the only way to determine
 the appropriate is by the node block hash/before values. Given a hash to look up,
 you read the node's +btree+ array and first +hashval+ in the array that exceeds
@@ -1205,6 +1380,45 @@ The hash value of a particular record.
 The directory/attribute logical block containing all entries up to the
 corresponding hash value.
 
+* On a v5 filesystem, the directory/attribute node blocks have the following
+structure:
+
+[source, c]
+----
+struct xfs_da3_intnode {
+     struct xfs_da3_node_hdr {
+           struct xfs_da3_blkinfo    info;
+           __uint16_t                count;
+           __uint16_t                level;
+           __uint32_t                pad32;
+     } hdr;
+     struct xfs_da_node_entry {
+           xfs_dahash_t              hashval;
+           xfs_dablk_t               before;
+     } btree[1];
+};
+----
+
+*info*::
+Directory/attribute block info.  The magic number is +XFS_DA3_NODE_MAGIC+
+(0x3ebe).
+
+*count*::
+Number of node entries in this block.
+
+*level*::
+The level of this block in the B+tree.
+
+*pad32*::
+Padding to maintain alignment.
+
+*hashval*::
+The hash value of a particular record.
+
+*before*::
+The directory/attribute logical block containing all entries up to the
+corresponding hash value.
+
 * The freeindex's +bests+ array starts from the end of the block and grows to the
 start of the block.
 
diff --git a/design/XFS_Filesystem_Structure/docinfo.xml b/design/XFS_Filesystem_Structure/docinfo.xml
index 9bcecad..8ed38d9 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -90,4 +90,20 @@
 			</simplelist>
 		</revdescription>
 	</revision>
+	<revision>
+		<revnumber>3.1</revnumber>
+		<date>October 2015</date>
+		<author>
+			<firstname>Darrick</firstname>
+			<surname>Wong</surname>
+			<email></email>
+		</author>
+		<revdescription>
+			<simplelist>
+				<member>Add v5 fields.</member>
+				<member>Discuss metadata integrity.</member>
+				<member>Document the free inode B+tree.</member>
+			</simplelist>
+		</revdescription>
+	</revision>
 </revhistory>
diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
index f268d66..bb773d5 100644
--- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
+++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
@@ -322,7 +322,8 @@ with the flags stored as well. The remaining part of the leaf block contains the
 array name/value pairs, where each element varies in length.
 
 Each leaf is based on the +xfs_da_blkinfo_t+ block header declared in the
-section about xref:Directory_Attribute_Block_Header[directories]. The structure
+section about xref:Directory_Attribute_Block_Header[directories].  On a v5
+filesystem, the block header is +xfs_da3_blkinfo_t+.  The structure
 encapsulating all other structures in the attribute block is
 +xfs_attr_leafblock_t+.
 
@@ -459,7 +460,32 @@ size of these entries is determined dynamically.
 A variable-length array of descriptors of remote attributes.  The location and
 size of these entries is determined dynamically.
 
-Each leaf header uses the magic number +XFS_ATTR_LEAF_MAGIC+ (0xfbee).
+On a v5 filesystem, the header becomes +xfs_da3_blkinfo_t+ to accomodate the
+extra metadata integrity fields:
+
+[source, c]
+----
+typedef struct xfs_attr3_leaf_hdr {
+     xfs_da3_blkinfo_t          info;
+     __be16                     count;
+     __be16                     usedbytes;
+     __be16                     firstused;
+     __u8                       holes;
+     __u8                       pad1;
+     xfs_attr_leaf_map_t        freemap[3];
+} xfs_attr3_leaf_hdr_t;
+
+
+typedef struct xfs_attr3_leafblock  {
+     xfs_attr3_leaf_hdr_t          hdr;
+     xfs_attr_leaf_entry_t         entries[1];
+     xfs_attr_leaf_name_local_t    namelist;
+     xfs_attr_leaf_name_remote_t   valuelist;
+} xfs_attr3_leafblock_t;
+----
+
+Each leaf header uses the magic number +XFS_ATTR_LEAF_MAGIC+ (0xfbee).  On a
+v5 filesystem, the magic number is +XFS_ATTR3_LEAF_MAGIC+ (0x3bee).
 
 The hash/index elements in the +entries[]+ array are packed from the top of the
 block. Name/values grow from the bottom but are not packed. The freemap contains
@@ -474,7 +500,8 @@ For attributes with small values (ie. the value can be stored within the leaf),
 the +XFS_ATTR_LOCAL+ flag is set for the attribute. The entry details are stored
 using the +xfs_attr_leaf_name_local_t+ structure. For large attribute values
 that cannot be stored within the leaf, separate filesystem blocks are allocated
-to store the value. They use the +xfs_attr_leaf_name_remote_t+ structure.
+to store the value. They use the +xfs_attr_leaf_name_remote_t+ structure.  See
+xref:Remote_Values[Remote Values] for more information.
 
 .Leaf attribute layout
 image::images/69.png[]
@@ -629,6 +656,7 @@ that exceeds the given hash.  The entry is in the block pointed to by the
 +before+ value. 
 
 Each attribute node block has a magic number of +XFS_DA_NODE_MAGIC+ (0xfebe).
+On a v5 filesystem this is +XFS_DA3_NODE_MAGIC+ (0x3ebe).
 
 .Node attribute layout
 image::images/72.png[]
@@ -834,3 +862,50 @@ is two levels deep. The two blocks at offset 513 and 512 (ie. access using the
 +ablock+ command) are intermediate +xfs_da_intnode_t+ nodes that index all the
 attribute leaves.
 
+[[Remote_Values]]
+== Remote Attribute Values
+
+On a v5 filesystem, all remote value blocks start with this header:
+
+[source, c]
+----
+struct xfs_attr3_rmt_hdr {
+	__be32	rm_magic;
+	__be32	rm_offset;
+	__be32	rm_bytes;
+	__be32	rm_crc;
+	uuid_t	rm_uuid;
+	__be64	rm_owner;
+	__be64	rm_blkno;
+	__be64	rm_lsn;
+};
+----
+
+
+*rm_magic*::
+Specifies the magic number for the remote value block: "XARM" (0x5841524d).
+
+*rm_offset*::
+Offset of the remote value data, in bytes.
+
+*rm_bytes*::
+Number of bytes used to contain the remote value data.
+
+*rm_crc*::
+Checksum of the remote value block.
+
+*rm_uuid*::
+The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
+depending on which features are set.
+
+*rm_owner*::
+The inode number that this remote value block belongs to.
+
+*rm_blkno*::
+Disk block number of this remote value block.
+
+*rm_lsn*::
+Log sequence number of the last write to this block.
+
+Filesystems formatted prior to v5 do not have this header in the remote block.
+Value data begins immediately at offset zero.
diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index c21f8b4..9ace3ea 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -60,6 +60,11 @@ struct xfs_disk_dquot {
 struct xfs_dqblk {
      struct xfs_disk_dquot dd_diskdq;
      char                  dd_fill[32];
+
+     /* version 5 filesystem fields begin here */
+     __be32                dd_crc;
+     __be64                dd_lsn;
+     uuid_t                dd_uuid;
 };
 ----
 
@@ -150,6 +155,16 @@ soft limit will turn into a hard limit after the elapsed time exceeds ID zero's
 +d_rtbtimer+ value. When +d_rtbcount+ goes back below +d_rtb_softlimit+,
 +d_rtbtimer+ is reset back to zero.
 
+*dd_uuid*::
+The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
+depending on which features are set.
+
+*dd_lsn*::
+Log sequence number of the last DQ block write.
+
+*dd_crc*::
+Checksum of the DQ block.
+
 
 [[Real-time_Inodes]]
 == Real-time Inodes
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index da6281b..4aabc55 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -55,7 +55,7 @@ explain the various structures in use within the inode.
 
 The remaining space in the inode after +di_next_unlinked+ where the two forks
 are located is called the inode's ``literal area''. This starts at offset 100
-(0x64) in the inode.
+(0x64) in a version 1 or 2 inode, and offset 176 (0xb0) in a version 3 inode.
 
 The space for each of the two forks in the literal area is determined by the
 inode size, and +di_core.di_forkoff+. The data fork is located between the start
@@ -99,6 +99,20 @@ struct xfs_dinode_core {
      __uint16_t                di_dmstate;
      __uint16_t                di_flags;
      __uint32_t                di_gen;
+
+     /* di_next_unlinked is the only non-core field in the old dinode */
+     __be32                    di_next_unlinked;
+
+     /* version 5 filesystem (inode version 3) fields start here */
+     __le32                    di_crc;
+     __be64                    di_changecount;
+     __be64                    di_lsn;
+     __be64                    di_flags2;
+     __u8                      di_pad2[16];
+     xfs_timestamp_t           di_crtime;
+     __be64                    di_ino;
+     uuid_t                    di_uuid;
+
 };
 ----
 
@@ -110,10 +124,11 @@ Specifies the mode access bits and type of file using the standard S_Ixxx values
 defined in stat.h.
 
 *di_version*::
-Specifies the inode version which currently can only be 1 or 2. The inode
+Specifies the inode version which currently can only be 1, 2, or 3. The inode
 version specifies the usage of the +di_onlink+, +di_nlink+ and +di_projid+
 values in the inode core. Initially, inodes are created as v1 but can be
-converted on the fly to v2 when required.
+converted on the fly to v2 when required.  v3 inodes are created only for v5
+filesystems.
 
 *di_format*::
 Specifies the format of the data fork in conjunction with the +di_mode+ type.
@@ -284,6 +299,35 @@ A generation number used for inode identification. This is used by tools that do
 inode scanning such as backup tools and xfsdump. An inode's generation number
 can change by unlinking and creating a new file that reuses the inode.  
 
+*di_next_unlinked*::
+See the section on xref:Unlinked_Pointer[unlinked inode pointers] for more
+information.
+
+*di_crc*::
+Checksum of the inode.
+
+*di_changecount*::
+Counts the number of changes made to the attributes in this inode.
+
+*di_lsn*::
+Log sequence number of the last inode write.
+
+*di_flags2*::
+Specifies extended flags associated with a v3 inode.  There are no flags defined
+currently.
+
+*di_pad2*::
+Padding for future expansion of the inode.
+
+*di_crtime*::
+Specifies the time when this inode was created.
+
+*di_ino*::
+The full inode number of this inode.
+
+*di_uuid*::
+The UUID of this inode, which must match either +sb_uuid+ or +sb_meta_uuid+
+depending on which features are set.
 
 [[Unlinked_Pointer]]
 == Unlinked Pointer
@@ -311,12 +355,12 @@ image::images/28.png[]
 == Data Fork
 
 The structure of the inode's data fork based is on the inode's type and
-+di_format+. It always starts at offset 100 (0x64) in the inode's space which is
-the start of the inode's ``literal area''. The size of the data fork is determined
-by the type and format. The maximum size is determined by the inode size and
-+di_forkoff+. In code, use the +XFS_DFORK_PTR+ macro specifying +XFS_DATA_FORK+
-for the ``which'' parameter. Alternatively, the +XFS_DFORK_DPTR+ macro can be
-used.
++di_format+. The data fork begins at the start of the inode's ``literal area''.
+This area starts at offset 100 (0x64), or offset 176 (0xb0) in a v3 inode. The
+size of the data fork is determined by the type and format. The maximum size is
+determined by the inode size and +di_forkoff+. In code, use the +XFS_DFORK_PTR+
+macro specifying +XFS_DATA_FORK+ for the ``which'' parameter. Alternatively,
+the +XFS_DFORK_DPTR+ macro can be used.
 
 Each of the following sub-sections summarises the contents of the data fork
 based on the inode type.
diff --git a/design/XFS_Filesystem_Structure/symbolic_links.asciidoc b/design/XFS_Filesystem_Structure/symbolic_links.asciidoc
index 5d2c4e8..bfe5eb9 100644
--- a/design/XFS_Filesystem_Structure/symbolic_links.asciidoc
+++ b/design/XFS_Filesystem_Structure/symbolic_links.asciidoc
@@ -63,6 +63,51 @@ by the data fork's +di_bmx[]+ array. In the significant majority of cases, this
 will be in one filesystem block as a symlink cannot be longer than 1024
 characters.
 
+On a v5 filesystem, the first block of each extent starts with the following
+header structure:
+
+[source, c]
+----
+struct xfs_dsymlink_hdr {
+     __be32                    sl_magic;
+     __be32                    sl_offset;
+     __be32                    sl_bytes;
+     __be32                    sl_crc;
+     uuid_t                    sl_uuid;
+     __be64                    sl_owner;
+     __be64                    sl_blkno;
+     __be64                    sl_lsn;
+};
+-----
+
+*sl_magic*::
+Specifies the magic number for the symlink block: "XSLM" (0x58534c4d).
+
+*sl_offset*::
+Offset of the symbolic link target data, in bytes.
+
+*sl_bytes*::
+Number of bytes used to contain the link target data.
+
+*sl_crc*::
+Checksum of the symlink block.
+
+*sl_uuid*::
+The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
+depending on which features are set.
+
+*sl_owner*::
+The inode number that this symlink block belongs to.
+
+*sl_blkno*::
+Disk block number of this symlink.
+
+*sl_lsn*::
+Log sequence number of the last write to this block.
+
+Filesystems formatted prior to v5 do not have this header in the remote block.
+Symlink data begins immediately at offset zero.
+
 .Symbolic link extent layout
 image::images/62.png[]
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
