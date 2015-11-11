Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 67FE729E1A
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:25:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2147AC004
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:25:09 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id CyMUx7vfG69TFkBH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:25:07 -0800 (PST)
Subject: [PATCH 20/21] xfsdocs: document refcount btree and reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:24:41 -0800
Message-ID: <20151111192441.14235.71964.stgit@birch.djwong.org>
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

Document the reference count btree and talk a little bit about how
the reflink feature uses it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |   20 ++-
 .../XFS_Filesystem_Structure/directories.asciidoc  |    1 
 design/XFS_Filesystem_Structure/docinfo.xml        |    2 
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   10 +
 .../XFS_Filesystem_Structure/refcountbt.asciidoc   |  145 ++++++++++++++++++++
 design/XFS_Filesystem_Structure/reflink.asciidoc   |   40 ++++++
 .../xfs_filesystem_structure.asciidoc              |    4 +
 7 files changed, 218 insertions(+), 4 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/refcountbt.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/reflink.asciidoc


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index a385a94..5de9548 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -13,6 +13,7 @@ Each AG has the following characteristics:
          * Free space management
          * Inode allocation and tracking
          * Reverse block-mapping index (optional)
+         * Data block reference count index (optional)
 
 Having multiple AGs allows XFS to handle most operations in parallel without
 degrading performance as the number of concurrent accesses increases.
@@ -380,6 +381,12 @@ Reverse mapping B+tree.  Each allocation group contains a B+tree containing
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
@@ -539,7 +546,9 @@ struct xfs_agf {
 
      /* version 5 filesystem fields start here */
      uuid_t              agf_uuid;
-     __be64              agf_spare64[16];
+     __be32              agf_refcount_root;
+     __be32              agf_refcount_level;
+     __be64              agf_spare64[15];
 
      /* unlogged fields, written during buffer writeback. */
      __be64              agf_lsn;
@@ -601,6 +610,12 @@ used if the +XFS_SB_VERSION2_LAZYSBCOUNTBIT+ bit is set in +sb_features2+.
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
 
@@ -1287,4 +1302,5 @@ By placing the real time device (and the journal) on separate high-performance
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
index 19eb135..fed339d 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -119,6 +119,8 @@
 		<revdescription>
 			<simplelist>
 				<member>Document the reverse-mapping btree.</member>
+				<member>Document the reference-count btree.</member>
+				<member>Discuss block sharing, reflink, &amp; deduplication.</member>
 			</simplelist>
 		</revdescription>
 	</revision>
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index 4aabc55..ed15285 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -313,8 +313,14 @@ Counts the number of changes made to the attributes in this inode.
 Log sequence number of the last inode write.
 
 *di_flags2*::
-Specifies extended flags associated with a v3 inode.  There are no flags defined
-currently.
+Specifies extended flags associated with a v3 inode.
+
+.Version 3 Inode flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_DIFLAG2_REFLINK+		| This inode shares (or has shared) data blocks with another inode.
+|=====
 
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
index 0000000..f39e6ff
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
+updated to point to that filesystem block and the reference count btree records
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
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 4d089b6..4eec464 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -48,6 +48,8 @@ include::overview.asciidoc[]
 
 include::metadata_integrity.asciidoc[]
 
+include::reflink.asciidoc[]
+
 include::reconstruction.asciidoc[]
 
 include::common_types.asciidoc[]
@@ -66,6 +68,8 @@ include::allocation_groups.asciidoc[]
 
 include::rmapbt.asciidoc[]
 
+include::refcountbt.asciidoc[]
+
 include::journaling_log.asciidoc[]
 
 include::internal_inodes.asciidoc[]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
