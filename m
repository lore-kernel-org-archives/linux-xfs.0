Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 29A2F859E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:48:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DDF7D304059
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:48:54 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id eWxw3WMJjYFPIgbb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:48:51 -0700 (PDT)
Subject: [PATCH 6/6] xfsdocs: document refcount btree and reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:48:46 -0700
Message-ID: <146612812605.25586.14230585950316760238.stgit@birch.djwong.org>
In-Reply-To: <146612808918.25586.1147874927753492795.stgit@birch.djwong.org>
References: <146612808918.25586.1147874927753492795.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Document the reference count btree and talk a little bit about how
the reflink feature uses it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |   20 ++
 .../XFS_Filesystem_Structure/directories.asciidoc  |    1 
 design/XFS_Filesystem_Structure/docinfo.xml        |    2 
 .../journaling_log.asciidoc                        |  207 ++++++++++++++++++++
 design/XFS_Filesystem_Structure/magic.asciidoc     |    5 
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   25 ++
 .../XFS_Filesystem_Structure/refcountbt.asciidoc   |  145 ++++++++++++++
 design/XFS_Filesystem_Structure/reflink.asciidoc   |   40 ++++
 design/XFS_Filesystem_Structure/rmapbt.asciidoc    |    2 
 .../xfs_filesystem_structure.asciidoc              |    4 
 10 files changed, 446 insertions(+), 5 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/refcountbt.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/reflink.asciidoc


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 8ced83a..ece7f8b 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -13,6 +13,7 @@ Each AG has the following characteristics:
          * Free space management
          * Inode allocation and tracking
          * Reverse block-mapping index (optional)
+         * Data block reference count index (optional)
 
 Having multiple AGs allows XFS to handle most operations in parallel without
 degrading performance as the number of concurrent accesses increases.
@@ -386,6 +387,12 @@ Reverse mapping B+tree.  Each allocation group contains a B+tree containing
 records mapping AG blocks to their owners.  See the section about
 xref:Reconstruction[reconstruction] for more details.
 
+| +XFS_SB_FEAT_RO_COMPAT_REFLINK+ |
+Reference count B+tree.  Each allocation group contains a B+tree to track the
+reference counts of AG blocks.  This enables files to share data blocks safely.
+See the section about xref:Reflink_Deduplication[reflink and deduplication] for
+more details.
+
 |=====
 
 *sb_features_incompat*::
@@ -546,7 +553,9 @@ struct xfs_agf {
 
      /* version 5 filesystem fields start here */
      uuid_t              agf_uuid;
-     __be64              agf_spare64[16];
+     __be32              agf_refcount_root;
+     __be32              agf_refcount_level;
+     __be64              agf_spare64[15];
 
      /* unlogged fields, written during buffer writeback. */
      __be64              agf_lsn;
@@ -608,6 +617,12 @@ used if the +XFS_SB_VERSION2_LAZYSBCOUNTBIT+ bit is set in +sb_features2+.
 The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
 depending on which features are set.
 
+*agf_refcount_root*::
+Block number for the root of the reference count B+tree, if enabled.
+
+*agf_refcount_root*::
+Depth of the reference count B+tree, if enabled.
+
 *agf_spare64*::
 Empty space in the logged part of the AGF sector, for use for future features.
 
@@ -1238,4 +1253,5 @@ By placing the real time device (and the journal) on separate high-performance
 storage devices, it is possible to reduce most of the unpredictability in I/O
 response times that come from metadata operations.
 
-None of the XFS per-AG B+trees are involved with real time files.
+None of the XFS per-AG B+trees are involved with real time files.  It is not
+possible for real time files to share data blocks.
diff --git a/design/XFS_Filesystem_Structure/directories.asciidoc b/design/XFS_Filesystem_Structure/directories.asciidoc
index bccf912..1758c4e 100644
--- a/design/XFS_Filesystem_Structure/directories.asciidoc
+++ b/design/XFS_Filesystem_Structure/directories.asciidoc
@@ -1419,6 +1419,7 @@ The hash value of a particular record.
 The directory/attribute logical block containing all entries up to the
 corresponding hash value.
 
+//
 * The freeindex's +bests+ array starts from the end of the block and grows to the
 start of the block.
 
diff --git a/design/XFS_Filesystem_Structure/docinfo.xml b/design/XFS_Filesystem_Structure/docinfo.xml
index 44f944a..f5e62bc 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -136,6 +136,8 @@
 				<member>Move the b+tree info to a separate chapter.</member>
 				<member>Discuss overlapping interval b+trees.</member>
 				<member>Discuss new log items for atomic updates.</member>
+				<member>Document the reference-count btree.</member>
+				<member>Discuss block sharing, reflink, &amp; deduplication.</member>
 			</simplelist>
 		</revdescription>
 	</revision>
diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index 0fbbcee..e772a84 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -211,6 +211,10 @@ magic number to distinguish themselves.  Buffer data items only appear after
 | +XFS_LI_ICREATE+		| 0x123f        | xref:Inode_Create_Log_Item[Inode Creation]
 | +XFS_LI_RUI+			| 0x1240        | xref:RUI_Log_Item[Reverse Mapping Update Intent]
 | +XFS_LI_RUD+			| 0x1241        | xref:RUD_Log_Item[Reverse Mapping Update Done]
+| +XFS_LI_CUI+			| 0x1242        | xref:CUI_Log_Item[Reference Count Update Intent]
+| +XFS_LI_CUD+			| 0x1243        | xref:CUD_Log_Item[Reference Count Update Done]
+| +XFS_LI_BUI+			| 0x1244        | xref:BUI_Log_Item[File Block Mapping Update Intent]
+| +XFS_LI_BUD+			| 0x1245        | xref:BUD_Log_Item[File Block Mapping Update Done]
 |=====
 
 [[Log_Transaction_Headers]]
@@ -516,6 +520,209 @@ A 64-bit number that binds the corresponding RUI log item to this RUD log item.
 Variable-length array of reverse mappings.  The array length is given by
 +rud_nextents+.
 
+[[CUI_Log_Item]]
+=== Reference Count Updates Intent
+
+The next two operation types work together to handle reference count updates.
+Naturally, the ranges of extents having reference count updates can be
+expressed in terms of physical extents:
+
+[source, c]
+----
+struct xfs_phys_extent {
+     __uint64_t                pe_startblock;
+     __uint32_t                pe_len;
+     __uint32_t                pe_flags;
+};
+----
+
+*pe_startblock*::
+Filesystem block of this extent.
+
+*pe_len*::
+The length of this extent.
+
+*pe_flags*::
+The lower byte of this field is a type code indicating what sort of
+reverse mapping operation we want.  The upper three bytes are flag bits.
+
+.Reference count update log intent types
+[options="header"]
+|=====
+| Value				  | Description
+| +XFS_REFCOUNT_EXTENT_INCREASE+  | Increase the reference count for this extent.
+| +XFS_REFCOUNT_EXTENT_DECREASE+  | Decrease the reference count for this extent.
+| +XFS_REFCOUNT_EXTENT_ALLOC_COW+ | Reserve an extent for staging copy on write.
+| +XFS_REFCOUNT_EXTENT_FREE_COW+  | Unreserve an extent for staging copy on write.
+|=====
+
+The ``reference count update intent'' operation comes first; it tells the log
+that XFS wants to update some reference counts.  This record is crucial for
+correct log recovery because it enables us to spread a complex metadata update
+across multiple transactions while ensuring that a crash midway through the
+complex update will be replayed fully during log recovery.
+
+[source, c]
+----
+struct xfs_cui_log_format {
+     __uint16_t                cui_type;
+     __uint16_t                cui_size;
+     __uint32_t                cui_nextents;
+     __uint64_t                cui_id;	
+     struct xfs_map_extent     cui_extents[1];
+};
+----
+
+*cui_type*::
+The signature of an CUI operation, 0x1242.  This value is in host-endian order,
+not big-endian like the rest of XFS.
+
+*cui_size*::
+Size of this log item.  Should be 1.
+
+*cui_nextents*::
+Number of reference count updates.
+
+*cui_id*::
+A 64-bit number that binds the corresponding RUD log item to this RUI log item.
+
+*cui_extents*::
+Variable-length array of reference count update information.
+
+[[CUD_Log_Item]]
+=== Completion of Reference Count Updates
+
+The ``reference count update done'' operation complements the ``reference count
+update intent'' operation.  This second operation indicates that the update
+actually happened, so that log recovery needn't replay the update.  The CUD and
+the actual updates are typically found in a new transaction following the
+transaction in which the CUI was logged.
+
+[source, c]
+----
+struct xfs_cud_log_format {
+      __uint16_t               cud_type;
+      __uint16_t               cud_size;
+      __uint32_t               cud_nextents;
+      __uint64_t               cud_rui_id;
+      struct xfs_map_extent    cud_extents[1];
+};
+----
+
+*cud_type*::
+The signature of an RUD operation, 0x1243.  This value is in host-endian order,
+not big-endian like the rest of XFS.
+
+*cud_size*::
+Size of this log item.  Should be 1.
+
+*cud_nextents*::
+Number of reverse mappings.
+
+*cud_id*::
+A 64-bit number that binds the corresponding CUI log item to this CUD log item.
+
+*cud_extents*::
+Variable-length array of reverse mappings.  The array length is given by
++cud_nextents+.
+
+[[BUI_Log_Item]]
+=== File Block Mapping Intent
+
+The next two operation types work together to handle deferred file block
+mapping updates.  The extents to be mapped are expressed via the
++xfs_map_extent+ structure discussed in the section about
+xref:RUI_Log_Item[reverse mapping intents].
+
+The lower byte of the +me_flags+ field is a type code indicating what sort of
+file block mapping operation we want.  The upper three bytes are flag bits.
+
+.File block mapping update log intent types
+[options="header"]
+|=====
+| Value				| Description
+| +XFS_BMAP_EXTENT_MAP+		| Add a mapping for file data.
+| +XFS_BMAP_EXTENT_UNMAP+	| Remove a mapping for file data.
+|=====
+
+.File block mapping update log intent flags
+[options="header"]
+|=====
+| Value				| Description
+| +XFS_BMAP_EXTENT_ATTR_FORK+	| Extent is for the attribute fork.
+| +XFS_BMAP_EXTENT_UNWRITTEN+	| Extent is unwritten.
+|=====
+
+The ``file block mapping update intent'' operation comes first; it tells the
+log that XFS wants to map or unmap some extents in a file.  This record is
+crucial for correct log recovery because it enables us to spread a complex
+metadata update across multiple transactions while ensuring that a crash midway
+through the complex update will be replayed fully during log recovery.
+
+[source, c]
+----
+struct xfs_bui_log_format {
+     __uint16_t                bui_type;
+     __uint16_t                bui_size;
+     __uint32_t                bui_nextents;
+     __uint64_t                bui_id;	
+     struct xfs_map_extent     bui_extents[1];
+};
+----
+
+*bui_type*::
+The signature of an BUI operation, 0x1244.  This value is in host-endian order,
+not big-endian like the rest of XFS.
+
+*bui_size*::
+Size of this log item.  Should be 1.
+
+*bui_nextents*::
+Number of file mappings.
+
+*bui_id*::
+A 64-bit number that binds the corresponding BUD log item to this BUI log item.
+
+*bui_extents*::
+Variable-length array of file block mappings to update.
+
+[[BUD_Log_Item]]
+=== Completion of File Block Mapping Updates
+
+The ``file block mapping update done'' operation complements the ``file block
+mapping update intent'' operation.  This second operation indicates that the
+update actually happened, so that log recovery needn't replay the update.  The
+BUD and the actual updates are typically found in a new transaction following
+the transaction in which the BUI was logged.
+
+[source, c]
+----
+struct xfs_bud_log_format {
+      __uint16_t               bud_type;
+      __uint16_t               bud_size;
+      __uint32_t               bud_nextents;
+      __uint64_t               bud_rui_id;
+      struct xfs_map_extent    bud_extents[1];
+};
+----
+
+*bud_type*::
+The signature of an BUD operation, 0x1245.  This value is in host-endian order,
+not big-endian like the rest of XFS.
+
+*bud_size*::
+Size of this log item.  Should be 1.
+
+*bud_nextents*::
+Number of file block mappings.
+
+*bud_id*::
+A 64-bit number that binds the corresponding BUI log item to this BUD log item.
+
+*bud_extents*::
+Variable-length array of file block mappings.  The array length is given by
++bud_nextents+.
+
 [[Inode_Log_Item]]
 === Inode Updates
 
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index 10fd15f..bc172f3 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -45,6 +45,7 @@ relevant chapters.  Magic numbers tend to have consistent locations:
 | +XFS_ATTR3_LEAF_MAGIC+	| 0x3bee	|     	| xref:Leaf_Attributes[Leaf Attribute], v5 only
 | +XFS_ATTR3_RMT_MAGIC+		| 0x5841524d	| XARM	| xref:Remote_Values[Remote Attribute Value], v5 only
 | +XFS_RMAP_CRC_MAGIC+		| 0x524d4233	| RMB3	| xref:Reverse_Mapping_Btree[Reverse Mapping B+tree], v5 only
+| +XFS_REFC_CRC_MAGIC+		| 0x52334643	| R3FC	| xref:Reference_Count_Btree[Reference Count B+tree], v5 only
 |=====
 
 The magic numbers for log items are at offset zero in each log item, but items
@@ -64,6 +65,10 @@ are not aligned to blocks.
 | +XFS_LI_ICREATE+		| 0x123f        |       | xref:Inode_Create_Log_Item[Inode Creation Log Item]
 | +XFS_LI_RUI+			| 0x1240        |       | xref:RUI_Log_Item[Reverse Mapping Update Intent]
 | +XFS_LI_RUD+			| 0x1241        |       | xref:RUD_Log_Item[Reverse Mapping Update Done]
+| +XFS_LI_CUI+			| 0x1242        |       | xref:CUI_Log_Item[Reference Count Update Intent]
+| +XFS_LI_CUD+			| 0x1243        |       | xref:CUD_Log_Item[Reference Count Update Done]
+| +XFS_LI_BUI+			| 0x1244        |       | xref:BUI_Log_Item[File Block Mapping Update Intent]
+| +XFS_LI_BUD+			| 0x1245        |       | xref:BUD_Log_Item[File Block Mapping Update Done]
 |=====
 
 = Theoretical Limits
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index dc1fad2..4415c38 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -109,7 +109,8 @@ struct xfs_dinode_core {
      __be64                    di_changecount;
      __be64                    di_lsn;
      __be64                    di_flags2;
-     __u8                      di_pad2[16];
+     __be32                    di_cowextsize;
+     __u8                      di_pad2[12];
      xfs_timestamp_t           di_crtime;
      __be64                    di_ino;
      uuid_t                    di_uuid;
@@ -215,7 +216,7 @@ including relevant metadata like B+trees. This does not include blocks used for
 extended attributes.
 
 *di_extsize*::
-Specifies the extent size for filesystems with real-time devices and an extent
+Specifies the extent size for filesystems with real-time devices or an extent
 size hint for standard filesystems. For normal filesystems, and with
 directories, the +XFS_DIFLAG_EXTSZINHERIT+ flag must be set in +di_flags+ if
 this field is used. Inodes created in these directories will inherit the
@@ -279,7 +280,7 @@ For directory inodes, new inodes inherit the +di_projid+ value.
 For directory inodes, symlinks cannot be created.
 
 | +XFS_DIFLAG_EXTSIZE+		|
-Specifies the extent size for real-time files or a and extent size hint for regular files.
+Specifies the extent size for real-time files or an extent size hint for regular files.
 
 | +XFS_DIFLAG_EXTSZINHERIT+	|
 For directory inodes, new inodes inherit the +di_extsize+ value.
@@ -323,8 +324,26 @@ Specifies extended flags associated with a v3 inode.
 | +XFS_DIFLAG2_DAX+		|
 For a file, enable DAX to increase performance on persistent-memory storage.
 If set on a directory, files created in the directory will inherit this flag.
+| +XFS_DIFLAG2_REFLINK+		|
+This inode shares (or has shared) data blocks with another inode.
+| +XFS_DIFLAG2_COWEXTSIZE+	|
+For files, this is the extent size hint for copy on write operations; see
++di_cowextsize+ for details.  For directories, the value in +di_cowextsize+
+will be copied to all newly created files and directories.
 |=====
 
+*di_cowextsize*::
+Specifies the extent size hint for copy on write operations.  When allocating
+extents for a copy on write operation, the allocator will be asked to align
+its allocations to either +di_cowextsize+ blocks or +di_extsize+ blocks,
+whichever is greater.  The +XFS_DIFLAG2_COWEXTSIZE+ flag must be set if this
+field is used.  If this field and its flag are set on a directory file, the
+value will be copied into any files or directories created within this
+directory.  During a block sharing operation, this value will be copied from
+the source file to the destination file if the sharing operation completely
+overwrites the destination file's contents and the destination file does not
+already have +di_cowextsize+ set.
+
 *di_pad2*::
 Padding for future expansion of the inode.
 
diff --git a/design/XFS_Filesystem_Structure/refcountbt.asciidoc b/design/XFS_Filesystem_Structure/refcountbt.asciidoc
new file mode 100644
index 0000000..dbbb98e
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/refcountbt.asciidoc
@@ -0,0 +1,145 @@
+[[Reference_Count_Btree]]
+== Reference Count B+tree
+
+[NOTE]
+This data structure is under construction!  Details may change.
+
+To support the sharing of file data blocks (reflink), each allocation group has
+its own reference count B+tree, which grows in the allocated space like the
+inode B+trees.  This data could be gleaned by performing an interval query of
+the reverse-mapping B+tree, but doing so would come at a huge performance
+penalty.  Therefore, this data structure is a cache of computable information.
+
+This B+tree is only present if the +XFS_SB_FEAT_RO_COMPAT_REFLINK+
+feature is enabled.  The feature requires a version 5 filesystem.
+
+Each record in the reference count B+tree has the following structure:
+
+[source, c]
+----
+struct xfs_refcount_rec {
+     __be32                     rc_startblock;
+     __be32                     rc_blockcount;
+     __be32                     rc_refcount;
+};
+----
+
+*rc_startblock*::
+AG block number of this record.
+
+*rc_blockcount*::
+The length of this extent.
+
+*rc_refcount*::
+Number of mappings of this filesystem extent.
+
+Node pointers are an AG relative block pointer:
+
+[source, c]
+----
+struct xfs_refcount_key {
+     __be32                     rc_startblock;
+};
+----
+
+* As the reference counting is AG relative, all the block numbers are only
+32-bits.
+* The +bb_magic+ value is "R3FC" (0x52334643).
+* The +xfs_btree_sblock_t+ header is used for intermediate B+tree node as well
+as the leaves.
+
+=== xfs_db refcntbt Example
+
+For this example, an XFS filesystem was populated with a root filesystem and
+a deduplication program was run to create shared blocks:
+
+----
+xfs_db> agf 0
+xfs_db> addr refcntroot
+xfs_db> p
+magic = 0x52334643
+level = 1
+numrecs = 6
+leftsib = null
+rightsib = null
+bno = 36892
+lsn = 0x200004ec2
+uuid = f1f89746-e00b-49c9-96b3-ecef0f2f14ae
+owner = 0
+crc = 0x75f35128 (correct)
+keys[1-6] = [startblock] 1:[14] 2:[65633] 3:[65780] 4:[94571] 5:[117201] 6:[152442]
+ptrs[1-6] = 1:7 2:25836 3:25835 4:18447 5:18445 6:18449
+xfs_db> addr ptrs[3]
+xfs_db> p
+magic = 0x52334643
+level = 0
+numrecs = 80
+leftsib = 25836
+rightsib = 18447
+bno = 51670
+lsn = 0x200004ec2
+uuid = f1f89746-e00b-49c9-96b3-ecef0f2f14ae
+owner = 0
+crc = 0xc3962813 (correct)
+recs[1-80] = [startblock,blockcount,refcount]
+        1:[65780,1,2] 2:[65781,1,3] 3:[65785,2,2] 4:[66640,1,2]
+        5:[69602,4,2] 6:[72256,16,2] 7:[72871,4,2] 8:[72879,20,2]
+        9:[73395,4,2] 10:[75063,4,2] 11:[79093,4,2] 12:[86344,16,2]
+----
+
+Record 6 in the reference count B+tree for AG 0 indicates that the AG extent
+starting at block 72,256 and running for 16 blocks has a reference count of 2.
+This means that there are two files sharing the block:
+
+----
+xfs_db> blockget -n
+xfs_db> fsblock 72256
+xfs_db> blockuse
+block 72256 (0/72256) type rldata inode 25169197
+----
+
+The blockuse type changes to ``rldata'' to indicate that the block is shared
+data.  Unfortunately, blockuse only tells us about one block owner.  If we
+happen to have enabled the reverse-mapping B+tree, we can use it to find all
+inodes that own this block:
+
+----
+xfs_db> agf 0
+xfs_db> addr rmaproot
+...
+xfs_db> addr ptrs[3]
+...
+xfs_db> addr ptrs[7]
+xfs_db> p
+magic = 0x524d4233
+level = 0
+numrecs = 22
+leftsib = 65057
+rightsib = 65058
+bno = 291478
+lsn = 0x200004ec2
+uuid = f1f89746-e00b-49c9-96b3-ecef0f2f14ae
+owner = 0
+crc = 0xed7da3f7 (correct)
+recs[1-22] = [startblock,blockcount,owner,offset,extentflag,attrfork,bmbtblock]
+        1:[68957,8,3201,0,0,0,0] 2:[68965,4,25260953,0,0,0,0]
+        ...
+        18:[72232,58,3227,0,0,0,0] 19:[72256,16,25169197,24,0,0,0]
+        20:[72290,75,3228,0,0,0,0] 21:[72365,46,3229,0,0,0,0]
+----
+
+Records 18 and 19 intersect the block 72,256; they tell us that inodes 3,227
+and 25,169,197 both claim ownership.  Let us confirm this:
+
+----
+xfs_db> inode 25169197
+xfs_db> bmap
+data offset 0 startblock 12632259 (3/49347) count 24 flag 0
+data offset 24 startblock 72256 (0/72256) count 16 flag 0
+data offset 40 startblock 12632299 (3/49387) count 18 flag 0
+xfs_db> inode 3227
+xfs_db> bmap
+data offset 0 startblock 72232 (0/72232) count 58 flag 0
+----
+
+Inodes 25,169,197 and 3,227 both contain mappings to block 0/72,256.
diff --git a/design/XFS_Filesystem_Structure/reflink.asciidoc b/design/XFS_Filesystem_Structure/reflink.asciidoc
new file mode 100644
index 0000000..8f52b90
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/reflink.asciidoc
@@ -0,0 +1,40 @@
+[[Reflink_Deduplication]]
+= Sharing Data Blocks
+
+On a traditional filesystem, there is a 1:1 mapping between a logical block
+offset in a file and a physical block on disk, which is to say that physical
+blocks are not shared.  However, there exist various use cases for being able
+to share blocks between files -- deduplicating files saves space on archival
+systems; creating space-efficient clones of disk images for virtual machines
+and containers facilitates efficient datacenters; and deferring the payment of
+the allocation cost of a file system tree copy as long as possible makes
+regular work faster.  In all of these cases, a write to one of the shared
+copies *must* not affect the other shared copies, which means that writes to
+shared blocks must employ a copy-on-write strategy.  Sharing blocks in this
+manner is commonly referred to as ``reflinking''.
+
+XFS implements block sharing in a fairly straightforward manner.  All existing
+data fork structures remain unchanged, save for the addition of a
+per-allocation group xref:Reference_Count_Btree[reference count B+tree].  This
+data structure tracks reference counts for all shared physical blocks, with a
+few rules to maintain compatibility with existing code: If a block is free, it
+will be tracked in the free space B+trees.  If a block is owned by a single
+file, it appears in neither the free space nor the reference count B+trees.  If
+a block is shared, it will appear in the reference count B+tree with a
+reference count >= 2.  The first two cases are established precedent in XFS, so
+the third case is the only behavioral change.
+
+When a filesystem block is shared, the block mapping in the destination file is
+updated to point to that filesystem block and the reference count B+tree records
+are updated to reflect the increased refcount.  If a shared block is written, a
+new block will be allocated, the dirty data written to this new block, and the
+file's block mapping updated to point to the new block.  If a shared block is
+unmapped, the reference count records are updated to reflect the decreased
+refcount and the block is also freed if its reference count becomes zero.  This
+enables users to create space efficient clones of disk images and to copy
+filesystem subtrees quickly, using the standard Linux coreutils packages.
+
+Deduplication employs the same mechanism to share blocks and copy them at write
+time.  However, the kernel confirms that the contents of both files are
+identical before updating the destination file's mapping.  This enables XFS to
+be used by userspace deduplication programs such as +duperemove+.
diff --git a/design/XFS_Filesystem_Structure/rmapbt.asciidoc b/design/XFS_Filesystem_Structure/rmapbt.asciidoc
index a8a210b..0ec72c1 100644
--- a/design/XFS_Filesystem_Structure/rmapbt.asciidoc
+++ b/design/XFS_Filesystem_Structure/rmapbt.asciidoc
@@ -53,6 +53,8 @@ absolute inode number, but can also correspond to one of the following:
 | +XFS_RMAP_OWN_AG+             | Per-allocation group B+tree blocks.  This means free space B+tree blocks, blocks on the freelist, and reverse-mapping B+tree blocks.
 | +XFS_RMAP_OWN_INOBT+          | Per-allocation group inode B+tree blocks.  This includes free inode B+tree blocks.
 | +XFS_RMAP_OWN_INODES+         | Inode chunks
+| +XFS_RMAP_OWN_REFC+           | Per-allocation group refcount B+tree blocks.  This will be used for reflink support.
+| +XFS_RMAP_OWN_COW+		| Blocks that have been reserved for a copy-on-write operation that has not completed.
 |=====
 
 *rm_fork*::
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 1b8658d..7916fbe 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -48,6 +48,8 @@ include::overview.asciidoc[]
 
 include::metadata_integrity.asciidoc[]
 
+include::reflink.asciidoc[]
+
 include::reconstruction.asciidoc[]
 
 include::common_types.asciidoc[]
@@ -70,6 +72,8 @@ include::allocation_groups.asciidoc[]
 
 include::rmapbt.asciidoc[]
 
+include::refcountbt.asciidoc[]
+
 include::journaling_log.asciidoc[]
 
 include::internal_inodes.asciidoc[]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
