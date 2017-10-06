Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25268 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbdJFVtH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 17:49:07 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v96Ln66Y009059
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Oct 2017 21:49:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v96Ln6oP028493
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Oct 2017 21:49:06 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v96Ln5El005223
        for <linux-xfs@vger.kernel.org>; Fri, 6 Oct 2017 21:49:06 GMT
Date: Fri, 6 Oct 2017 14:49:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfsdocs: move dir-attr btree sections to a separate chapter
Message-ID: <20171006214904.GO7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

Instead of scattering dabtree documentation across two sections underneath
the directory chapter, just give them a separate chapter.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 design/XFS_Filesystem_Structure/btrees.asciidoc    |    2 
 design/XFS_Filesystem_Structure/dabtrees.asciidoc  |  219 ++++++++++++++++++++
 .../XFS_Filesystem_Structure/directories.asciidoc  |  157 --------------
 .../xfs_filesystem_structure.asciidoc              |    2 
 4 files changed, 223 insertions(+), 157 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/dabtrees.asciidoc

diff --git a/design/XFS_Filesystem_Structure/btrees.asciidoc b/design/XFS_Filesystem_Structure/btrees.asciidoc
index 306e061..91a53c4 100644
--- a/design/XFS_Filesystem_Structure/btrees.asciidoc
+++ b/design/XFS_Filesystem_Structure/btrees.asciidoc
@@ -1,4 +1,4 @@
-= B+trees
+= Fixed Length Record B+trees
 
 XFS uses b+trees to index all metadata records.  This well known data structure
 is used to provide efficient random and sequential access to metadata records
diff --git a/design/XFS_Filesystem_Structure/dabtrees.asciidoc b/design/XFS_Filesystem_Structure/dabtrees.asciidoc
new file mode 100644
index 0000000..18247ca
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/dabtrees.asciidoc
@@ -0,0 +1,219 @@
+[[Directory_Attribute_Btree]]
+= Variable Length Record B+trees
+
+Directories and extended attributes are implemented as a simple
+key-value record store inside the blocks pointed to by the data or
+attribute fork of a file.  Blocks referenced by either data structure
+are block offsets of an inode fork, not physical blocks.
+
+Directory and attribute data are stored as a linear array of
+variable-length records in the low blocks of a fork.  Both data types
+share the property that record keys and record values are both arbitrary
+and unique sequences of bytes.  See the respective sections about
+xref:Directories[directories] or xref:Extended_Attributes[attributes]
+for more information about the exact record formats.
+
+The dir/attr b+tree (or "dabtree"), if present, computes a hash of the
+record key to produce the b+tree key, and b+tree keys are used to index
+the fork block in which the record may be found.  Unlike the
+fixed-length b+trees, the variable length b+trees can index the same key
+multiple times.  B+tree keypointers and records both take this format:
+
+----
++---------+--------------+
+| hashval | before_block |
++---------+--------------+
+----
+
+The "before block" is the block offset in the inode fork of the block in
+which we can find the record whose hashed key is "hashval".  The hash
+function is as follows:
+
+[source, c]
+----
+#define rol32(x,y)             (((x) << (y)) | ((x) >> (32 - (y))))
+
+xfs_dahash_t
+xfs_da_hashname(const uint8_t *name, int namelen)
+{
+	xfs_dahash_t hash;
+
+	/*
+	 * Do four characters at a time as long as we can.
+	 */
+	for (hash = 0; namelen >= 4; namelen -= 4, name += 4)
+		hash = (name[0] << 21) ^ (name[1] << 14) ^ (name[2] << 7) ^
+		       (name[3] << 0) ^ rol32(hash, 7 * 4);
+
+	/*
+	 * Now do the rest of the characters.
+	 */
+	switch (namelen) {
+	case 3:
+		return (name[0] << 14) ^ (name[1] << 7) ^ (name[2] << 0) ^
+		       rol32(hash, 7 * 3);
+	case 2:
+		return (name[0] << 7) ^ (name[1] << 0) ^ rol32(hash, 7 * 2);
+	case 1:
+		return (name[0] << 0) ^ rol32(hash, 7 * 1);
+	default: /* case 0: */
+		return hash;
+	}
+}
+----
+
+[[Directory_Attribute_Block_Header]]
+== Block Headers
+
+* Tree nodes, leaf and node xref:Directories[directories], and leaf and
+node xref:Extended_Attributes[extended attributes] use the
++xfs_da_blkinfo_t+ filesystem block header.  The structure appears as
+follows:
+
+[source, c]
+----
+typedef struct xfs_da_blkinfo {
+     __be32                     forw;
+     __be32                     back;
+     __be16                     magic;
+     __be16                     pad;
+} xfs_da_blkinfo_t;
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
+// split lists
+
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
+[[Directory_Attribute_Internal_Node]]
+== Internal Nodes
+
+The nodes of a dabtree have the following format:
+
+[source, c]
+----
+typedef struct xfs_da_intnode {
+     struct xfs_da_node_hdr {
+           xfs_da_blkinfo_t     info;
+           __uint16_t           count;
+           __uint16_t           level;
+     } hdr;
+     struct xfs_da_node_entry {
+           xfs_dahash_t         hashval;
+           xfs_dablk_t          before;
+     } btree[1];
+} xfs_da_intnode_t;
+----
+
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
diff --git a/design/XFS_Filesystem_Structure/directories.asciidoc b/design/XFS_Filesystem_Structure/directories.asciidoc
index 9bb50bd..06d682e 100644
--- a/design/XFS_Filesystem_Structure/directories.asciidoc
+++ b/design/XFS_Filesystem_Structure/directories.asciidoc
@@ -915,85 +915,6 @@ typedef struct xfs_dir2_leaf_tail {
 *bestcount*::
 Number of best free entries.
 
-[[Directory_Attribute_Block_Header]]
-=== Directory and Attribute Block Headers
-
-* Leaf nodes in directories and xref:Extended_Attributes[extended attributes]
-use the +xfs_da_blkinfo_t+ filesystem block header.  The structure appears as
-follows:
-
-[source, c]
-----
-typedef struct xfs_da_blkinfo {
-     __be32                     forw;
-     __be32                     back;
-     __be16                     magic;
-     __be16                     pad;
-} xfs_da_blkinfo_t;
-----
-
-*forw*::
-Logical block offset of the previous B+tree block at this level.
-
-*back*::
-Logical block offset of the next B+tree block at this level.
-
-*magic*::
-Magic number for this directory/attribute block.
-
-*pad*::
-Padding to maintain alignment.
-
-// split lists
-
-* On a v5 filesystem, the leaves use the +struct xfs_da3_blkinfo_t+ filesystem
-block header. This header is used in the same place as +xfs_da_blkinfo_t+:
-
-[source, c]
-----
-struct xfs_da3_blkinfo {
-     /* these values are inside xfs_da_blkinfo */
-     __be32                     forw;
-     __be32                     back;
-     __be16                     magic;
-     __be16                     pad;
-
-     __be32                     crc;
-     __be64                     blkno;
-     __be64                     lsn;
-     uuid_t                     uuid;
-     __be64                     owner;
-};
-----
-
-*forw*::
-Logical block offset of the previous B+tree block at this level.
-
-*back*::
-Logical block offset of the next B+tree block at this level.
-
-*magic*::
-Magic number for this directory/attribute block.
-
-*pad*::
-Padding to maintain alignment.
-
-*crc*::
-Checksum of the directory/attribute block.
-
-*blkno*::
-Block number of this directory/attribute block.
-
-*lsn*::
-Log sequence number of the last write to this block.
-
-*uuid*::
-The UUID of this block, which must match either +sb_uuid+ or +sb_meta_uuid+
-depending on which features are set.
-
-*owner*::
-The inode number that this directory/attribute block belongs to.
-
 // split lists
 
 * The magic number of the leaf block is +XFS_DIR2_LEAF1_MAGIC+ (0xd2f1); on a
@@ -1371,84 +1292,8 @@ you read the node's +btree+ array and first +hashval+ in the array that exceeds
 the given hash and it can then be found in the block pointed to by the +before+
 value. 
 
-[[Directory_Attribute_Internal_Node]]
-=== Directory and Attribute Internal Nodes
-
-The hashing B+tree of a directory or an extended attribute fork uses nodes with
-the following format:
-
-[source, c]
-----
-typedef struct xfs_da_intnode {
-     struct xfs_da_node_hdr {
-           xfs_da_blkinfo_t     info;
-           __uint16_t           count;
-           __uint16_t           level;
-     } hdr;
-     struct xfs_da_node_entry {
-           xfs_dahash_t         hashval;
-           xfs_dablk_t          before;
-     } btree[1];
-} xfs_da_intnode_t;
-----
-
-*info*::
-Directory/attribute block info.  The magic number is +XFS_DA_NODE_MAGIC+
-(0xfebe).
-
-*count*::
-Number of node entries in this block.
-
-*level*::
-The level of this block in the B+tree.
-
-*hashval*::
-The hash value of a particular record.
-
-*before*::
-The directory/attribute logical block containing all entries up to the
-corresponding hash value.
-
-* On a v5 filesystem, the directory/attribute node blocks have the following
-structure:
-
-[source, c]
-----
-struct xfs_da3_intnode {
-     struct xfs_da3_node_hdr {
-           struct xfs_da3_blkinfo    info;
-           __uint16_t                count;
-           __uint16_t                level;
-           __uint32_t                pad32;
-     } hdr;
-     struct xfs_da_node_entry {
-           xfs_dahash_t              hashval;
-           xfs_dablk_t               before;
-     } btree[1];
-};
-----
-
-*info*::
-Directory/attribute block info.  The magic number is +XFS_DA3_NODE_MAGIC+
-(0x3ebe).
-
-*count*::
-Number of node entries in this block.
-
-*level*::
-The level of this block in the B+tree.
-
-*pad32*::
-Padding to maintain alignment.
-
-*hashval*::
-The hash value of a particular record.
-
-*before*::
-The directory/attribute logical block containing all entries up to the
-corresponding hash value.
+// split lists
 
-//
 * The freeindex's +bests+ array starts from the end of the block and grows to the
 start of the block.
 
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 4b0a054..5dba1c7 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -68,6 +68,8 @@ Global Structures
 
 include::btrees.asciidoc[]
 
+include::dabtrees.asciidoc[]
+
 include::allocation_groups.asciidoc[]
 
 include::rmapbt.asciidoc[]
