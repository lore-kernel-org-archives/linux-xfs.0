Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27D3E7F8B
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:23:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E22A98F8040
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:23:31 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id pG66NlIBsratYcwV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:23:29 -0800 (PST)
Subject: [PATCH 07/21] xfsdocs: make example section titles consistent
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:23:03 -0800
Message-ID: <20151111192303.14235.77696.stgit@birch.djwong.org>
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

Make the section titles of the examples consistently formatted.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |    6 +++---
 .../XFS_Filesystem_Structure/data_extents.asciidoc |    6 +++---
 .../XFS_Filesystem_Structure/directories.asciidoc  |   16 ++++++++--------
 .../extended_attributes.asciidoc                   |   16 ++++++++--------
 .../symbolic_links.asciidoc                        |    8 ++++----
 5 files changed, 26 insertions(+), 26 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index b511324..a86274c 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -308,7 +308,7 @@ its parent inode. The primary purpose for this information is in backup systems.
 |=====
 
 
-=== xfs_db superblock example
+=== xfs_db Superblock Example
 
 A filesystem is made on a single SATA disk with the following command:
 
@@ -548,7 +548,7 @@ image::images/16.png[]
 The presence of these reserved block guarantees that the free space B+trees can
 be updated if any blocks are freed by extent changes in a full AG.
 
-==== xfs_db AGF Examples
+==== xfs_db AGF Example
 
 These examples are derived from an AG that has been deliberately fragmented.
 The AGF:
@@ -772,7 +772,7 @@ And a 2-level inode B+tree:
 image::images/20b.png[]
 
 
-==== xfs_db AGI examples
+==== xfs_db AGI Example
 TODO
 
 [[Real-time_Devices]]
diff --git a/design/XFS_Filesystem_Structure/data_extents.asciidoc b/design/XFS_Filesystem_Structure/data_extents.asciidoc
index 8b09fee..7850165 100644
--- a/design/XFS_Filesystem_Structure/data_extents.asciidoc
+++ b/design/XFS_Filesystem_Structure/data_extents.asciidoc
@@ -88,7 +88,7 @@ The number of extents that can fit in the inode depends on the inode size and
 can up to 19 extents with this format. Beyond this, extents have to use the
 B+tree format.
 
-=== xfs_db: Inode data fork extents
+=== xfs_db Inode Data Fork Extents Example
 
 An 8MB file with one extent:
 
@@ -268,9 +268,9 @@ bits in size.
 .Single level extent B+tree
 image::images/35.png[]
 
-.Multi-level extent B+tree
+.Multiple level extent B+tree
 image::images/36.png[]
 
-=== BMBT xfs_db Example
+=== xfs_db bmbt Example
 
 TODO
diff --git a/design/XFS_Filesystem_Structure/directories.asciidoc b/design/XFS_Filesystem_Structure/directories.asciidoc
index beabe20..7d84117 100644
--- a/design/XFS_Filesystem_Structure/directories.asciidoc
+++ b/design/XFS_Filesystem_Structure/directories.asciidoc
@@ -47,7 +47,7 @@ typedef __uint32_t xfs_dir2_dataptr_t;
 
 
 [[Shortform_Directories]]
-== Shortform Directories
+== Short Form Directories
 
 * Directory entries are stored within the inode.
 
@@ -86,7 +86,7 @@ typedef struct xfs_dir2_sf_entry {
 } xfs_dir2_sf_entry_t;
 ----
 
-.Shortform Directory layout
+.Short form directory layout
 image::images/39.png[]
 
 * Inode numbers are stored using 4 or 8 bytes depending on whether all the inode
@@ -107,7 +107,7 @@ typedef union {
 } xfs_dir2_inou_t;
 ----
 
-=== Shortform Directory xfs_db Example
+=== xfs_db Short Form Directory Example
 
 A directory is created with 4 files, all inode numbers fitting within 4 bytes:
 
@@ -325,7 +325,7 @@ lookup speed for large directories. If they were not stored, the hashes have to
 be calculated for all entries each time a lookup occurs in a directory.
 
 
-=== Block Directory xfs_db Example
+=== xfs_db Block Directory Example
 
 A directory is created with 8 entries, directory block size = filesystem block size:
 
@@ -585,7 +585,7 @@ block's +bestfree[0].length+ value.
 .Leaf directory free entry detail
 image::images/48.png[]
 
-=== Leaf Directory xfs_db Example
+=== xfs_db Leaf Directory Example
 
 For this example, a directory was created with 256 entries (frame000000.tst to
 frame000255.tst) and then deleted some files (frame00005*, frame00018* and
@@ -905,10 +905,10 @@ less than or equal to +hdr.nused. hdr.nused+ should be the same as the index of
 the last data directory block plus one (i.e. when the last data block is freed,
 +nused+ and +nvalid+ are decremented).
 
-.Node Directory Layout
+.Node directory layout
 image::images/54.png[]
 
-=== Node Directory xfs_db Example
+=== xfs_db Node Directory Example
 
 With the node directory examples, we are using a filesystems with 4KB block
 size, and a 16KB directory size. The directory has over 2000 entries:
@@ -1111,7 +1111,7 @@ that B+trees can handle:
 required hundreds of thousand files with quite long file names (or millions with
 shorter names) to get a second freeindex block.
 
-=== B+tree Directory xfs_db Example
+=== xfs_db B+tree Directory Example
 
 A directory has been created with 200,000 entries with each entry being 100
 characters long. The filesystem block size and directory block size are 4KB:
diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
index 51f7ff7..747217c 100644
--- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
+++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
@@ -41,7 +41,7 @@ The following four sections describe each of the on-disk formats.
 
 
 [[Shortform_Attributes]]
-== Shortform Attributes
+== Short Form Attributes
 
 When the all extended attributes can fit within the inode's attribute fork, the
 inode's +di_aformat+ is set to "local" and the attributes are stored in the
@@ -67,7 +67,7 @@ typedef struct xfs_attr_sf_hdr xfs_attr_sf_hdr_t;
 typedef struct xfs_attr_sf_entry xfs_attr_sf_entry_t;
 ----
 
-.Shortform attribute layout
+.Short form attribute layout
 image::images/64.png[]
 
 
@@ -89,7 +89,7 @@ immediately follows the name in the array.
 | +XFS_ATTR_SECURE+		| The attribute's namespace is "secure".
 |=====
 
-=== Shortform attribute xfs_db example
+=== xfs_db Short Form Attribute Example
 
 A file is created and two attributes are set:
 
@@ -387,7 +387,7 @@ using the +xfs_attr_leaf_name_local_t+ structure. For large attribute values
 that cannot be stored within the leaf, separate filesystem blocks are allocated
 to store the value. They use the +xfs_attr_leaf_name_remote_t+ structure.
 
-.Leaf Attribute layout
+.Leaf attribute layout
 image::images/69.png[]
 
 Both local and remote entries can be interleaved as they are only addressed by
@@ -403,7 +403,7 @@ crash during the time that the bit is set. The bit is cleared when attribute
 has finished being setup. This is done because some large attributes cannot
 be created inside a single transaction.
 
-=== Leaf Attribute xfs_db Example
+=== xfs_db Leaf Attribute Example
 
 A single 30KB extended attribute is added to an inode:
 
@@ -538,10 +538,10 @@ to lookup, you read the node's btree array and first +hashval+ in the array that
 exceeds the given hash and it can then be found in the block pointed to by the
 +before+ value. 
 
-.Node Attribute layout
+.Node attribute layout
 image::images/72.png[]
 
-=== Node Attribute xfs_db Example
+=== xfs_db Node Attribute Example
 
 An inode with 1000 small attributes with the naming "attribute_n" where 'n' is a
 number:
@@ -685,7 +685,7 @@ Attributes.
 Refer to the previous section on B+tree Data Extents for more information on XFS
 B+tree extents.
 
-=== B+tree Attribute xfs_db Example
+=== xfs_db B+tree Attribute Example
 
 Added 2000 attributes with 729 byte values to a file:
 
diff --git a/design/XFS_Filesystem_Structure/symbolic_links.asciidoc b/design/XFS_Filesystem_Structure/symbolic_links.asciidoc
index af88a1c..939c440 100644
--- a/design/XFS_Filesystem_Structure/symbolic_links.asciidoc
+++ b/design/XFS_Filesystem_Structure/symbolic_links.asciidoc
@@ -7,16 +7,16 @@ Symbolic links to a file can be stored in one of two formats: "local" and
 
 
 [[Shortform_Symbolic_Links]]
-== Shortform Symbolic Links
+== Short Form Symbolic Links
 
 Symbolic links are stored with the "local" +di_format+ if the symbolic link can
 fit within the inode's data fork. The link data is an array of characters
 (+di_symlink+ array in the data fork union).
 
-.Symbolic link shortform layout
+.Symbolic link short form layout
 image::images/61.png[]
 
-=== Shortform symbolic link xfs_db example
+=== xfs_db Short Form Symbolic Link Example
 
 A short symbolic link to a file is created:
 
@@ -66,7 +66,7 @@ characters.
 .Symbolic link extent layout
 image::images/62.png[]
 
-=== Symbolic link extent xfs_db example
+=== xfs_db Symbolic Link Extent Example
 
 A longer link is created (greater than 156 bytes):
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
