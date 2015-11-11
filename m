Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 129B17FA5
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:23:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7D892AC002
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:23:44 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id QdUdnHsYuJ2URIK9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:23:41 -0800 (PST)
Subject: [PATCH 09/21] xfsdocs: add missing structure field definitions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:23:16 -0800
Message-ID: <20151111192316.14235.12293.stgit@birch.djwong.org>
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

Add missing field definitions for various data structures.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |   32 +++
 .../XFS_Filesystem_Structure/data_extents.asciidoc |   27 ++
 .../XFS_Filesystem_Structure/directories.asciidoc  |  240 ++++++++++++++++++++
 design/XFS_Filesystem_Structure/docinfo.xml        |    1 
 .../extended_attributes.asciidoc                   |   86 +++++++
 5 files changed, 386 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 680f90c..e958039 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -501,6 +501,23 @@ struct xfs_btree_sblock {
 };
 ----
 
+*bb_magic*::
+Specifies the magic number for the per-AG B+tree block.
+
+*bb_level*::
+The level of the tree in which this block is found.  If this value is 0, this
+is a leaf block and contains records; otherwise, it is a node block and
+contains keys and pointers.
+
+*bb_numrecs*::
+Number of records in this block.
+
+*bb_leftsib*::
+AG block number of the left sibling of this B+tree node.
+
+*bb_rightsib*::
+AG block number of the right sibling of this B+tree node.
+
 [[AG_Free_Space_Btrees]]
 === AG Free Space B+trees
 
@@ -519,6 +536,12 @@ struct xfs_alloc_rec {
 };
 ----
 
+*ar_startblock*::
+AG block number of the start of the free space.
+
+*ar_blockcount*::
+Length of the free space.
+
 Node pointers are an AG relative block pointer:
 
 [source, c]
@@ -776,6 +799,15 @@ struct xfs_inobt_rec {
 };
 ----
 
+*ir_startino*::
+The lowest-numbered inode in this chunk.
+
+*ir_freecount*::
+Number of free inodes in this chunk.
+
+*ir_free*::
+A 64 element bitmap showing which inodes in this chunk are free.
+
 Nodes contain key/pointer pairs using the following types:
 
 [source,c]
diff --git a/design/XFS_Filesystem_Structure/data_extents.asciidoc b/design/XFS_Filesystem_Structure/data_extents.asciidoc
index a09fcc2..d1617f1 100644
--- a/design/XFS_Filesystem_Structure/data_extents.asciidoc
+++ b/design/XFS_Filesystem_Structure/data_extents.asciidoc
@@ -33,8 +33,16 @@ struct xfs_bmbt_irec {
 };
 ----
 
+*br_startoff*::
+Logical block offset of this mapping.
 
+*br_startblock*::
+Filesystem block of this mapping.
 
+*br_blockcount*::
+The length of this mapping.
+
+*br_state*::
 The extent +br_state+ field uses the following enum declaration:
 
 [source, c]
@@ -250,6 +258,25 @@ struct xfs_btree_lblock {
 };
 ----
 
+*bb_magic*::
+Specifies the magic number for the BMBT block: "BMAP" (0x424d4150).
+
+*bb_level*::
+The level of the tree in which this block is found.  If this value is 0, this
+is a leaf block and contains records; otherwise, it is a node block and
+contains keys and pointers.
+
+*bb_numrecs*::
+Number of records in this block.
+
+*bb_leftsib*::
+FS block number of the left sibling of this B+tree node.
+
+*bb_rightsib*::
+FS block number of the right sibling of this B+tree node.
+
+// force-split the lists
+
 * For intermediate nodes, the data following +xfs_btree_lblock+ is the same as
 the root node: array of +xfs_bmbt_key+ value followed by an array of
 +xfs_bmbt_ptr_t+ values that starts halfway through the block (offset 0x808 for
diff --git a/design/XFS_Filesystem_Structure/directories.asciidoc b/design/XFS_Filesystem_Structure/directories.asciidoc
index 3521749..2df118e 100644
--- a/design/XFS_Filesystem_Structure/directories.asciidoc
+++ b/design/XFS_Filesystem_Structure/directories.asciidoc
@@ -75,11 +75,35 @@ typedef struct xfs_dir2_sf {
      xfs_dir2_sf_hdr_t         hdr;
      xfs_dir2_sf_entry_t       list[1];
 } xfs_dir2_sf_t;
+----
+
+*hdr*::
+Short form directory header.
+
+*list*::
+An array of variable-length directory entry records.
+
+[source, c]
+----
 typedef struct xfs_dir2_sf_hdr {
      __uint8_t                 count;
      __uint8_t                 i8count;
      xfs_dir2_inou_t           parent;
 } xfs_dir2_sf_hdr_t;
+----
+
+*count*::
+Number of directory entries.
+
+*i8count*::
+Number of directory entries requiring 64-bit entries, if any inode numbers
+require 64-bits.  Zero otherwise.
+
+*parent*::
+The absolute inode number of this directory's parent.
+
+[source, c]
+----
 typedef struct xfs_dir2_sf_entry {
      __uint8_t                 namelen;
      xfs_dir2_sf_off_t         offset;
@@ -89,6 +113,25 @@ typedef struct xfs_dir2_sf_entry {
 } xfs_dir2_sf_entry_t;
 ----
 
+*namelen*::
+Length of the name, in bytes.
+
+*offset*::
+Offset tag used to assist with directory iteration.
+
+*name*::
+The name of the directory entry.  The entry is not NULL-terminated.
+
+*ftype*::
+The type of the inode.  This is used to avoid reading the inode while iterating
+a directory.  The +XFS_SB_VERSION2_FTYPE+ feature must be set, or this field
+will not be present.
+
+*inumber*::
+The inode number that this entry points to.  The length is either 32 or 64
+bits, depending on whether +icount+ or +i8count+, respectively, are set in the
+header.
+
 .Short form directory layout
 image::images/39.png[]
 
@@ -259,18 +302,67 @@ typedef struct xfs_dir2_block {
      xfs_dir2_leaf_entry_t      leaf[1];
      xfs_dir2_block_tail_t      tail;
 } xfs_dir2_block_t;
+----
+
+*hdr*::
+Directory block header.
+
+*u*::
+Union of directory and unused entries.
+
+*leaf*::
+Hash values of the entries in this block.
+
+*tail*::
+Bookkeeping for the leaf entries.
+
+[source, c]
+----
 typedef struct xfs_dir2_data_hdr {
      __uint32_t                 magic;
      xfs_dir2_data_free_t       bestfree[XFS_DIR2_DATA_FD_COUNT];
 } xfs_dir2_data_hdr_t;
+----
+
+*magic*::
+Magic number for this directory block.
+
+*bestfree*::
+An array pointing to free regions in the directory block.
+
+[source, c]
+----
 typedef struct xfs_dir2_data_free {
      xfs_dir2_data_off_t        offset;
      xfs_dir2_data_off_t        length;
 } xfs_dir2_data_free_t;
+----
+
+*offset*::
+Block offset of a free block, in bytes.
+
+*length*::
+Length of the free block, in bytes.
+
+Space inside the directory block can be used for directory entries or unused
+entries.  This is signified via a union of the two types:
+
+[source, c]
+-----
 typedef union {
      xfs_dir2_data_entry_t      entry;
      xfs_dir2_data_unused_t     unused;
 } xfs_dir2_data_union_t;
+----
+
+*entry*::
+A directory entry.
+
+*unused*::
+An unused entry.
+
+[source, c]
+-----
 typedef struct xfs_dir2_data_entry {
      xfs_ino_t                  inumber;
      __uint8_t                  namelen;
@@ -278,21 +370,74 @@ typedef struct xfs_dir2_data_entry {
      __uint8_t                  ftype;
      xfs_dir2_data_off_t        tag;
 } xfs_dir2_data_entry_t;
+----
+
+*inumber*::
+The inode number that this entry points to.
+
+*namelen*::
+Length of the name, in bytes.
+
+*name*::
+The name associated with this entry.
+
+*ftype*::
+The type of the inode.  This is used to avoid reading the inode while iterating
+a directory.  The +XFS_SB_VERSION2_FTYPE+ feature must be set, or this field
+will not be present.
+
+*tag*::
+Starting offset of the entry, in bytes.  This is used for directory iteration.
+
+[source, c]
+-----
 typedef struct xfs_dir2_data_unused {
      __uint16_t                 freetag;  /* 0xffff */
      xfs_dir2_data_off_t        length;
      xfs_dir2_data_off_t        tag;
 } xfs_dir2_data_unused_t;
+----
+
+*freetag*::
+Magic number signifying that this is an unused entry.  Must be 0xFFFF.
+
+*length*::
+Length of this unused entry, in bytes.
+
+*tag*::
+Starting offset of the entry, in bytes.
+
+[source, c]
+-----
 typedef struct xfs_dir2_leaf_entry {
      xfs_dahash_t               hashval;
      xfs_dir2_dataptr_t         address;
 } xfs_dir2_leaf_entry_t;
+----
+
+*hashval*::
+Hash value of the name of the directory entry.  This is used to speed up entry
+lookups.
+
+*address*::
+Block offset of the entry, in eight byte units.
+
+[source, c]
+-----
 typedef struct xfs_dir2_block_tail {
      __uint32_t                 count;
      __uint32_t                 stale;
 } xfs_dir2_block_tail_t;
 ----
 
+*count*::
+Number of leaf entries.
+
+*stale*::
+Number of free leaf entries.
+
+Following is a diagram of how these pieces fit together for a block directory.
+
 .Block directory layout
 image::images/43.png[]
 
@@ -550,6 +695,14 @@ typedef struct xfs_dir2_data {
 } xfs_dir2_data_t;
 ----
 
+*hdr*::
+Data block header.
+
+*u*::
+Union of directory and unused entries, exactly the same as in a block directory.
+
+// split lists
+
 * The "leaf" extent uses the following structures:
 
 [source, c]
@@ -560,16 +713,48 @@ typedef struct xfs_dir2_leaf {
      xfs_dir2_data_off_t       bests[1];
      xfs_dir2_leaf_tail_t      tail;
 } xfs_dir2_leaf_t;
+----
+
+*hdr*::
+Directory leaf header.
+
+*ents*::
+Hash values of the entries in this block.
+
+*bests*::
+An array pointing to free regions in the directory block.
+
+*tail*::
+Bookkeeping for the leaf entries.
+
+[source, c]
+----
 typedef struct xfs_dir2_leaf_hdr {
      xfs_da_blkinfo_t          info;
      __uint16_t                count;
      __uint16_t                stale;
 } xfs_dir2_leaf_hdr_t;
+----
+
+*info*::
+Leaf btree block header.
+
+*count*::
+Number of leaf entries.
+
+*stale*::
+Number of stale/zeroed leaf entries.
+
+[source, c]
+----
 typedef struct xfs_dir2_leaf_tail {
      __uint32_t                bestcount;
 } xfs_dir2_leaf_tail_t;
 ----
 
+*bestcount*::
+Number of best free entries.
+
 [[Directory_Attribute_Block_Header]]
 === Directory and Attribute Block Headers
 
@@ -587,6 +772,20 @@ typedef struct xfs_da_blkinfo {
 } xfs_da_blkinfo_t;
 ----
 
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
+// split lists
+
 * The magic number of the leaf block is +XFS_DIR2_LEAF1_MAGIC+ (0xd2f1).
 
 * The size of the +ents+ array is specified by +hdr.count+.
@@ -879,12 +1078,36 @@ typedef struct xfs_dir2_free_hdr {
      __int32_t                 nvalid;
      __int32_t                 nused;
 } xfs_dir2_free_hdr_t;
+----
+
+*magic*::
+The magic number of the free block, "XD2F" (0x0x58443246).
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
+[source, c]
+----
 typedef struct xfs_dir2_free {
      xfs_dir2_free_hdr_t       hdr;
      xfs_dir2_data_off_t       bests[1];
 } xfs_dir2_free_t;
 ----
 
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
@@ -912,6 +1135,23 @@ typedef struct xfs_da_intnode {
 } xfs_da_intnode_t;
 ----
 
+*info*::
+Directory/attribute block info.  The magic number is +XFS_DA_NODE_MAGIC+
+(0xfebe).
+
+*count*::
+Number of node entries in this block.
+
+*level*::
+The level of this block in the B+tree.
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
index 856c01d..32a502d 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -82,6 +82,7 @@
 		<revdescription>
 			<simplelist>
 				<member>Miscellaneous fixes.</member>
+				<member>Add missing field definitions.</member>
 			</simplelist>
 		</revdescription>
 	</revision>
diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
index 18a4568..2499f12 100644
--- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
+++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
@@ -334,7 +334,16 @@ typedef struct xfs_attr_leaf_map {
      __be16                     base;
      __be16                     size;
 } xfs_attr_leaf_map_t;
+----
+
+*base*::
+Block offset of the free area, in bytes.
+
+*size*::
+Size of the free area, in bytes.
 
+[source, c]
+----
 typedef struct xfs_attr_leaf_hdr {
      xfs_da_blkinfo_t           info;
      __be16                     count;
@@ -344,27 +353,90 @@ typedef struct xfs_attr_leaf_hdr {
      __u8                       pad1;
      xfs_attr_leaf_map_t        freemap[3];
 } xfs_attr_leaf_hdr_t;
+----
+
+*info*::
+Directory/attribute block header.
+
+*count*::
+Number of entries.
+
+*usedbytes*::
+Number of bytes used in the leaf block.
 
+*firstused*::
+Block offset of the first entry in use, in bytes.
+
+*holes*::
+Set to 1 if block compaction is necessary.
+
+*pad1*::
+Padding to maintain alignment to 64-bit boundaries.
+
+[source, c]
+-----
 typedef struct xfs_attr_leaf_entry {
      __be32                     hashval;
      __be16                     nameidx;
      __u8                       flags;
      __u8                       pad2;
 } xfs_attr_leaf_entry_t;
+----
+
+*hashval*::
+Hash value of the attribute name.
+
+*nameidx*::
+Block offset of the name entry, in bytes.
+
+*flags*::
+Attribute flags, as specified xref:Attribute_Flags[above].
+
+*pad2*::
+Pads the structure to 64-bit boundaries.
 
+[source, c]
+----
 typedef struct xfs_attr_leaf_name_local {
      __be16                     valuelen;
      __u8                       namelen;
      __u8                       nameval[1];
 } xfs_attr_leaf_name_local_t;
+----
+
+*valuelen*::
+Length of the value, in bytes.
+
+*namelen*::
+Length of the name, in bytes.
 
+*nameval*::
+The name and the value.  String values are not zero-terminated.
+
+[source, c]
+----
 typedef struct xfs_attr_leaf_name_remote {
      __be32                     valueblk;
      __be32                     valuelen;
      __u8                       namelen;
      __u8                       name[1];
 } xfs_attr_leaf_name_remote_t;
+----
+
+*valueblk*::
+The logical block in the attribute map where the value is located.
 
+*valuelen*::
+Length of the value, in bytes.
+
+*namelen*::
+Length of the name, in bytes.
+
+*nameval*::
+The name.  String values are not zero-terminated.
+
+[source, c]
+----
 typedef struct xfs_attr_leafblock  {
      xfs_attr_leaf_hdr_t           hdr;
      xfs_attr_leaf_entry_t         entries[1];
@@ -373,6 +445,20 @@ typedef struct xfs_attr_leafblock  {
 } xfs_attr_leafblock_t;
 ----
 
+*hdr*::
+Attribute block header.
+
+*entries*::
+A variable-length array of attribute entries.
+
+*namelist*::
+A variable-length array of descriptors of local attributes.  The location and
+size of these entries is determined dynamically.
+
+*valuelist*::
+A variable-length array of descriptors of remote attributes.  The location and
+size of these entries is determined dynamically.
+
 Each leaf header uses the magic number +XFS_ATTR_LEAF_MAGIC+ (0xfbee).
 
 The hash/index elements in the +entries[]+ array are packed from the top of the

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
