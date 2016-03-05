Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 500217CA1
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:36:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1586B8F8035
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 16:36:03 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id u6ve5KBaYrpvcJeF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 16:35:58 -0800 (PST)
Subject: [PATCH 3/6] xfsdocs: move the discussions of short and long format
	btrees to a separate chapter
From: "Darrick J. Wong" <djwong@alder.djwong.org>
Date: Fri, 04 Mar 2016 16:35:24 -0800
Message-ID: <20160305003524.28327.95523.stgit@birch.djwong.org>
In-Reply-To: <20160305003505.28327.95288.stgit@birch.djwong.org>
References: <20160305003505.28327.95288.stgit@birch.djwong.org>
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

Move the discussion of short and long format btrees into a separate
chapter.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |   59 ------
 design/XFS_Filesystem_Structure/btrees.asciidoc    |  200 ++++++++++++++++++++
 .../XFS_Filesystem_Structure/data_extents.asciidoc |   71 -------
 .../xfs_filesystem_structure.asciidoc              |    2 
 4 files changed, 206 insertions(+), 126 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/btrees.asciidoc


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 7dd67ce..8656636 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -612,65 +612,6 @@ Checksum of the AGF sector.
 *agf_spare2*::
 Empty space in the unlogged part of the AGF sector.
 
-[[Short_Format_Btrees]]
-=== Short Format B+trees
-
-Each allocation group uses a ``short format'' B+tree to index various
-information about the allocation group.  The structure is called short format
-because all block pointers are AG block numbers.  The trees use the following
-header:
-
-[source, c]
-----
-struct xfs_btree_sblock {
-     __be32                    bb_magic;
-     __be16                    bb_level;
-     __be16                    bb_numrecs;
-     __be32                    bb_leftsib;
-     __be32                    bb_rightsib;
-
-     /* version 5 filesystem fields start here */
-     __be64                    bb_blkno;
-     __be64                    bb_lsn;
-     uuid_t                    bb_uuid;
-     __be32                    bb_owner;
-     __le32                    bb_crc;
-};
-----
-
-*bb_magic*::
-Specifies the magic number for the per-AG B+tree block.
-
-*bb_level*::
-The level of the tree in which this block is found.  If this value is 0, this
-is a leaf block and contains records; otherwise, it is a node block and
-contains keys and pointers.
-
-*bb_numrecs*::
-Number of records in this block.
-
-*bb_leftsib*::
-AG block number of the left sibling of this B+tree node.
-
-*bb_rightsib*::
-AG block number of the right sibling of this B+tree node.
-
-*bb_blkno*::
-FS block number of this B+tree block.
-
-*bb_lsn*::
-Log sequence number of the last write to this block.
-
-*bb_uuid*::
-The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
-depending on which features are set.
-
-*bb_owner*::
-The AG number that this B+tree block ought to be in.
-
-*bb_crc*::
-Checksum of the B+tree block.
-
 [[AG_Free_Space_Btrees]]
 === AG Free Space B+trees
 
diff --git a/design/XFS_Filesystem_Structure/btrees.asciidoc b/design/XFS_Filesystem_Structure/btrees.asciidoc
new file mode 100644
index 0000000..c67669c
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/btrees.asciidoc
@@ -0,0 +1,200 @@
+= B+trees
+
+XFS uses b+trees to index all metadata records.  This well known data structure
+is used to provide efficient random and sequential access to metadata records
+while minimizing seek times.  There are two btree formats: a short format
+for records pertaining to a single allocation group, since all block pointers
+in an AG are 32-bits in size; and a long format for records pertaining to a
+file, since file data can have 64-bit block offsets.  Each b+tree block is
+either a leaf node containing records, or an internal node containing keys and
+pointers to other b+tree blocks.  The tree consists of a root block which may
+point to some number of other blocks; blocks in the bottom level of the b+tree
+contains only records.
+
+Leaf blocks of both types of b+trees have the same general format: a header
+describing the data in the block, and an array of records.  The specific header
+formats are given in the next two sections, and the record format is provided
+by the b+tree client itself.  The generic b+tree code does not have any
+specific knowledge of the record format.
+
+----
++--------+------------+------------+
+| header |   record   | records... |
++--------+------------+------------+
+----
+
+Internal node blocks of both types of b+trees also have the same general
+format: a header describing the data in the block, an array of keys, and an
+array of pointers.  Each pointer may be associated with one or two keys.  The
+first key uniquely identifies the first record accessible via the leftmost path
+down the branch of the tree.
+
+If the records in a b+tree are indexed by an interval, then a range of keys can
+uniquely identify a single record.  For example, if a record covers blocks
+12-16, then any one of the keys 12, 13, 14, 15, or 16 return the same record.
+In this case, the key for the record describing "12-16" is 12.  If none of the
+records overlap, we only need to store one key.
+
+This is the format of a standard b+tree node:
+
+----
++--------+---------+---------+---------+---------+
+| header |   key   | keys... |   ptr   | ptrs... |
++--------+---------+---------+---------+---------+
+----
+
+If the b+tree records do not overlap, performing a b+tree lookup is simple.
+Start with the root.  If it is a leaf block, perform a binary search of the
+records until we find the record with a lower key than our search key.  If the
+block is a node block, perform a binary search of the keys until we find a
+key lower than our search key, then follow the pointer to the next block.
+Repeat until we find a record.
+
+However, if b+tree records contain intervals and are allowed to overlap, the
+internal nodes of the b+tree become larger:
+
+----
++--------+---------+----------+---------+-------------+---------+---------+
+| header | low key | high key | low key | high key... |   ptr   | ptrs... |
++--------+---------+----------+---------+-------------+---------+---------+
+----
+
+The low keys are exactly the same as the keys in the non-overlapping b+tree.
+High keys, however, are a little different.  Recall that a record with a key
+consisting of an interval can be referenced by a number of keys.  Since the low
+key of a record indexes the low end of that key range, the high key indexes the
+high end of the key range.  Returning to the example above, the high key for
+the record describing "12-16" is 16.  The high key recorded in a b+tree node
+is the largest of the high keys of all records accessible under the subtree
+rooted by the pointer.  For a level 1 node, this is the largest high key in
+the pointed-to leaf node; for any other node, this is the largest of the high
+keys in the pointed-to node.
+
+Nodes and leaves use the same magic numbers.
+
+[[Short_Format_Btrees]]
+== Short Format B+trees
+
+Each allocation group uses a ``short format'' B+tree to index various
+information about the allocation group.  The structure is called short format
+because all block pointers are AG block numbers.  The trees use the following
+header:
+
+[source, c]
+----
+struct xfs_btree_sblock {
+     __be32                    bb_magic;
+     __be16                    bb_level;
+     __be16                    bb_numrecs;
+     __be32                    bb_leftsib;
+     __be32                    bb_rightsib;
+
+     /* version 5 filesystem fields start here */
+     __be64                    bb_blkno;
+     __be64                    bb_lsn;
+     uuid_t                    bb_uuid;
+     __be32                    bb_owner;
+     __le32                    bb_crc;
+};
+----
+
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
+[[Long_Format_Btrees]]
+== Long Format B+trees
+
+If an inode's block map requires more records than fit into the inode's fork
+area, it will use a b+tree to index the records.  The nodes and leaves of this
+B+tree use the +xfs_btree_lblock+ declaration:
+
+[source, c]
+----
+struct xfs_btree_lblock {
+     __be32                    bb_magic;
+     __be16                    bb_level;
+     __be16                    bb_numrecs;
+     __be64                    bb_leftsib;
+     __be64                    bb_rightsib;
+
+     /* version 5 filesystem fields start here */
+     __be64                    bb_blkno;
+     __be64                    bb_lsn;
+     uuid_t                    bb_uuid;
+     __be64                    bb_owner;
+     __le32                    bb_crc;
+     __be32                    bb_pad;
+};
+----
+
+*bb_magic*::
+Specifies the magic number for the BMBT block: ``BMAP'' (0x424d4150).
+On a v5 filesystem, this is ``BMA3'' (0x424d4133).
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
+// force-split the lists
+
+* Long format b+trees are rooted in an inode, not a separate block.
+
diff --git a/design/XFS_Filesystem_Structure/data_extents.asciidoc b/design/XFS_Filesystem_Structure/data_extents.asciidoc
index a39045d..530406d 100644
--- a/design/XFS_Filesystem_Structure/data_extents.asciidoc
+++ b/design/XFS_Filesystem_Structure/data_extents.asciidoc
@@ -203,9 +203,10 @@ u.bmx[0-1] = [startoff,startblock,blockcount,extentflag]
 [[Btree_Extent_List]]
 == B+tree Extent List
 
-To manage extent maps that cannot fit in the inode fork area, XFS uses long
-format B+trees.  The root node of the B+tree is stored in the inode's data
-fork.  All block pointers for extent B+trees are 64-bit absolute block numbers.
+To manage extent maps that cannot fit in the inode fork area, XFS uses
+xref:Long_Format_Btrees[long format B+trees].  The root node of the B+tree is
+stored in the inode's data fork.  All block pointers for extent B+trees are
+64-bit absolute block numbers.
 
 For a single level B+tree, the root node points to the B+tree's leaves. Each
 leaf occupies one filesystem block and contains a header and an array of extents
@@ -242,70 +243,6 @@ standard 256 byte inode before a new level of nodes is added between the root
 and the leaves. This will be less if +di_forkoff+ is not zero (i.e. attributes
 are in use on the inode).
 
-[[Long_Format_Btrees]]
-=== Long Format B+trees
-
-The subsequent nodes and leaves of the B+tree use the +xfs_btree_lblock+
-declaration:
-
-[source, c]
-----
-struct xfs_btree_lblock {
-     __be32                    bb_magic;
-     __be16                    bb_level;
-     __be16                    bb_numrecs;
-     __be64                    bb_leftsib;
-     __be64                    bb_rightsib;
-
-     /* version 5 filesystem fields start here */
-     __be64                    bb_blkno;
-     __be64                    bb_lsn;
-     uuid_t                    bb_uuid;
-     __be64                    bb_owner;
-     __le32                    bb_crc;
-     __be32                    bb_pad;
-};
-----
-
-*bb_magic*::
-Specifies the magic number for the BMBT block: ``BMAP'' (0x424d4150).
-On a v5 filesystem, this is ``BMA3'' (0x424d4133).
-
-*bb_level*::
-The level of the tree in which this block is found.  If this value is 0, this
-is a leaf block and contains records; otherwise, it is a node block and
-contains keys and pointers.
-
-*bb_numrecs*::
-Number of records in this block.
-
-*bb_leftsib*::
-FS block number of the left sibling of this B+tree node.
-
-*bb_rightsib*::
-FS block number of the right sibling of this B+tree node.
-
-*bb_blkno*::
-FS block number of this B+tree block.
-
-*bb_lsn*::
-Log sequence number of the last write to this block.
-
-*bb_uuid*::
-The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
-depending on which features are set.
-
-*bb_owner*::
-The AG number that this B+tree block ought to be in.
-
-*bb_crc*::
-Checksum of the B+tree block.
-
-*bb_pad*::
-Pads the structure to 64 bytes.
-
-// force-split the lists
-
 * For intermediate nodes, the data following +xfs_btree_lblock+ is the same as
 the root node: array of +xfs_bmbt_key+ value followed by an array of
 +xfs_bmbt_ptr_t+ values that starts halfway through the block (offset 0x808 for
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index f580aab..62502b3 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -62,6 +62,8 @@ Global Structures
 
 :leveloffset: 1
 
+include::btrees.asciidoc[]
+
 include::allocation_groups.asciidoc[]
 
 include::journaling_log.asciidoc[]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
