Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4F8257CBD
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:27:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 13C598F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:27:51 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id dEjiwVcGGwAnVPSu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:27:48 -0700 (PDT)
Subject: [PATCH 7/7] xfsdocs: document the realtime reverse mapping btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:27:42 -0700
Message-ID: <147216766221.32447.9777486170830928374.stgit@birch.djwong.org>
In-Reply-To: <147216761636.32447.4229640006064129056.stgit@birch.djwong.org>
References: <147216761636.32447.4229640006064129056.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |    8 +
 design/XFS_Filesystem_Structure/docinfo.xml        |   14 +
 .../internal_inodes.asciidoc                       |    2 
 design/XFS_Filesystem_Structure/magic.asciidoc     |    1 
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    6 -
 design/XFS_Filesystem_Structure/rtrmapbt.asciidoc  |  234 ++++++++++++++++++++
 6 files changed, 263 insertions(+), 2 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/rtrmapbt.asciidoc


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index cafa8b7..7ba636a 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -105,6 +105,7 @@ struct xfs_sb
 	xfs_ino_t		sb_pquotino;
 	xfs_lsn_t		sb_lsn;
 	uuid_t			sb_meta_uuid;
+	xfs_ino_t		sb_rrmapino;
 };
 ----
 *sb_magicnum*::
@@ -449,6 +450,13 @@ If the +XFS_SB_FEAT_INCOMPAT_META_UUID+ feature is set, then the UUID field in
 all metadata blocks must match this UUID.  If not, the block header UUID field
 must match +sb_uuid+.
 
+*sb_rrmapino*::
+If the +XFS_SB_FEAT_COMPAT_RMAPBT+ feature is set and a real-time
+device is present (+sb_rblocks+ > 0), this field points to an inode
+that contains the root to the
+xref:Real_time_Reverse_Mapping_Btree[Real-Time Reverse Mapping B+tree].
+This field is zero otherwise.
+
 === xfs_db Superblock Example
 
 A filesystem is made on a single disk with the following command:
diff --git a/design/XFS_Filesystem_Structure/docinfo.xml b/design/XFS_Filesystem_Structure/docinfo.xml
index f5e62bc..5cdcf6c 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -141,4 +141,18 @@
 			</simplelist>
 		</revdescription>
 	</revision>
+	<revision>
+		<revnumber>3.1415</revnumber>
+		<date>July 2016</date>
+		<author>
+			<firstname>Darrick</firstname>
+			<surname>Wong</surname>
+			<email></email>
+		</author>
+		<revdescription>
+			<simplelist>
+				<member>Document the real-time reverse-mapping btree.</member>
+			</simplelist>
+		</revdescription>
+	</revision>
 </revhistory>
diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index 9ace3ea..e6bf75f 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -201,3 +201,5 @@ rtbitmap location, and positive if there are any.
 This data structure is not particularly space efficient, however it is a very
 fast way to provide the same data as the two free space B+trees for regular
 files since the space is preallocated and metadata maintenance is minimal.
+
+include::rtrmapbt.asciidoc[]
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index bc172f3..77bed6d 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -45,6 +45,7 @@ relevant chapters.  Magic numbers tend to have consistent locations:
 | +XFS_ATTR3_LEAF_MAGIC+	| 0x3bee	|     	| xref:Leaf_Attributes[Leaf Attribute], v5 only
 | +XFS_ATTR3_RMT_MAGIC+		| 0x5841524d	| XARM	| xref:Remote_Values[Remote Attribute Value], v5 only
 | +XFS_RMAP_CRC_MAGIC+		| 0x524d4233	| RMB3	| xref:Reverse_Mapping_Btree[Reverse Mapping B+tree], v5 only
+| +XFS_RTRMAP_CRC_MAGIC+	| 0x4d415052	| MAPR	| xref:Real_time_Reverse_Mapping_Btree[Real-Time Reverse Mapping B+tree], v5 only
 | +XFS_REFC_CRC_MAGIC+		| 0x52334643	| R3FC	| xref:Reference_Count_Btree[Reference Count B+tree], v5 only
 |=====
 
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index 4415c38..02d44ac 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -141,7 +141,8 @@ the associated metadata or data; or ``btree'' where the inode contains a B+tree
 root node which points to filesystem blocks containing the metadata or data.
 Migration between the formats depends on the amount of metadata associated with
 the inode. ``dev'' is used for character and block devices while ``uuid'' is
-currently not used.
+currently not used.  ``rmap'' indicates that a reverse-mapping B+tree
+is rooted in the fork.
 
 [source, c]
 ----
@@ -150,7 +151,8 @@ typedef enum xfs_dinode_fmt {
      XFS_DINODE_FMT_LOCAL,
      XFS_DINODE_FMT_EXTENTS,
      XFS_DINODE_FMT_BTREE,
-     XFS_DINODE_FMT_UUID
+     XFS_DINODE_FMT_UUID,
+     XFS_DINODE_FMT_RMAP,
 } xfs_dinode_fmt_t;
 ----
 
diff --git a/design/XFS_Filesystem_Structure/rtrmapbt.asciidoc b/design/XFS_Filesystem_Structure/rtrmapbt.asciidoc
new file mode 100644
index 0000000..3a109b2
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/rtrmapbt.asciidoc
@@ -0,0 +1,234 @@
+[[Real_time_Reverse_Mapping_Btree]]
+=== Real-Time Reverse-Mapping B+tree
+
+[NOTE]
+This data structure is under construction!  Details may change.
+
+If the reverse-mapping B+tree and real-time storage device features
+are enabled, the real-time device has its own reverse block-mapping
+B+tree.
+
+As mentioned in the chapter about xref:Reconstruction[reconstruction],
+this data structure is another piece of the puzzle necessary to
+reconstruct the data or attribute fork of a file from reverse-mapping
+records; we can also use it to double-check allocations to ensure that
+we are not accidentally cross-linking blocks, which can cause severe
+damage to the filesystem.
+
+This B+tree is only present if the +XFS_SB_FEAT_RO_COMPAT_RMAPBT+
+feature is enabled and a real time device is present.  The feature
+requires a version 5 filesystem.
+
+The real-time reverse mapping B+tree is rooted in an inode's data
+fork; the inode number is given by the +sb_rrmapino+ field in the
+superblock.  The B+tree blocks themselves are stored in the regular
+filesystem.  The structures used for an inode's B+tree root are:
+
+[source, c]
+----
+struct xfs_rtrmap_root {
+     __be16                     bb_level;
+     __be16                     bb_numrecs;
+};
+----
+
+* On disk, the B+tree node starts with the +xfs_rtrmap_root+ header
+followed by an array of +xfs_rtrmap_key+ values and then an array of
++xfs_rtrmap_ptr_t+ values. The size of both arrays is specified by the
+header's +bb_numrecs+ value.
+
+* The root node in the inode can only contain up to 10 key/pointer
+pairs for a standard 512 byte inode before a new level of nodes is
+added between the root and the leaves.  +di_forkoff+ should always
+be zero, because there are no extended attributes.
+
+Each record in the real-time reverse-mapping B+tree has the following
+structure:
+
+[source, c]
+----
+struct xfs_rtrmap_rec {
+     __be64                     rm_startblock;
+     __be64                     rm_blockcount;
+     __be64                     rm_owner;
+     __be64                     rm_fork:1;
+     __be64                     rm_bmbt:1;
+     __be64                     rm_unwritten:1;
+     __be64                     rm_unused:7;
+     __be64                     rm_offset:54;
+};
+----
+
+*rm_startblock*::
+Real-time device block number of this record.
+
+*rm_blockcount*::
+The length of this extent, in real-time blocks.
+
+*rm_owner*::
+A 64-bit number describing the owner of this extent.  This must be an
+inode number, because the real-time device is for file data only.
+
+*rm_fork*::
+If +rm_owner+ describes an inode, this can be 1 if this record is for
+an attribute fork.  This value will always be zero for real-time
+extents.
+
+*rm_bmbt*::
+If +rm_owner+ describes an inode, this can be 1 to signify that this
+record is for a block map B+tree block.  In this case, +rm_offset+ has
+no meaning.  This value will always be zero for real-time extents.
+
+*rm_unwritten*::
+A flag indicating that the extent is unwritten.  This corresponds to
+the flag in the xref:Data_Extents[extent record] format which means
++XFS_EXT_UNWRITTEN+.
+
+*rm_offset*::
+The 54-bit logical file block offset, if +rm_owner+ describes an
+inode.
+
+[NOTE]
+The single-bit flag values +rm_unwritten+, +rm_fork+, and +rm_bmbt+
+are packed into the larger fields in the C structure definition.
+
+The key has the following structure:
+
+[source, c]
+----
+struct xfs_rtrmap_key {
+     __be64                     rm_startblock;
+     __be64                     rm_owner;
+     __be64                     rm_fork:1;
+     __be64                     rm_bmbt:1;
+     __be64                     rm_reserved:1;
+     __be64                     rm_unused:7;
+     __be64                     rm_offset:54;
+};
+----
+
+* All block numbers are 64-bit real-time device block numbers.
+
+* The +bb_magic+ value is ``MAPR'' (0x4d415052).
+
+* The +xfs_btree_lblock_t+ header is used for intermediate B+tree node as well
+as the leaves.
+
+* Each pointer is associated with two keys.  The first of these is the
+"low key", which is the key of the smallest record accessible through
+the pointer.  This low key has the same meaning as the key in all
+other btrees.  The second key is the high key, which is the maximum of
+the largest key that can be used to access a given record underneath
+the pointer.  Recall that each record in the real-time reverse mapping
+b+tree describes an interval of physical blocks mapped to an interval
+of logical file block offsets; therefore, it makes sense that a range
+of keys can be used to find to a record.
+
+==== xfs_db rtrmapbt Example
+
+This example shows a real-time reverse-mapping B+tree from a freshly
+populated root filesystem:
+
+----
+xfs_db> sb 0
+xfs_db> addr rrmapino
+xfs_db> p
+core.magic = 0x494e
+core.mode = 0100000
+core.version = 3
+core.format = 5 (rtrmapbt)
+...
+u3.rtrmapbt.level = 3
+u3.rtrmapbt.numrecs = 1
+u3.rtrmapbt.keys[1] = [startblock,owner,offset,attrfork,bmbtblock,startblock_hi,
+		       owner_hi,offset_hi,attrfork_hi,bmbtblock_hi]
+	1:[1,132,1,0,0,1705337,133,54431,0,0]
+u3.rtrmapbt.ptrs[1] = 1:671
+xfs_db> addr u3.rtrmapbt.ptrs[1]
+xfs_db> p
+magic = 0x4d415052
+level = 2
+numrecs = 8
+leftsib = null
+rightsib = null
+bno = 5368
+lsn = 0x400000000
+uuid = 98bbde42-67e7-46a5-a73e-d64a76b1b5ce
+owner = 131
+crc = 0x2560d199 (correct)
+keys[1-8] = [startblock,owner,offset,attrfork,bmbtblock,startblock_hi,owner_hi,
+	     offset_hi,attrfork_hi,bmbtblock_hi]
+	1:[1,132,1,0,0,17749,132,17749,0,0]
+	2:[17751,132,17751,0,0,35499,132,35499,0,0]
+	3:[35501,132,35501,0,0,53249,132,53249,0,0]
+	4:[53251,132,53251,0,0,1658473,133,7567,0,0]
+	5:[1658475,133,7569,0,0,1667473,133,16567,0,0]
+	6:[1667475,133,16569,0,0,1685223,133,34317,0,0]
+	7:[1685225,133,34319,0,0,1694223,133,43317,0,0]
+	8:[1694225,133,43319,0,0,1705337,133,54431,0,0]
+ptrs[1-8] = 1:134 2:238 3:345 4:453 5:795 6:563 7:670 8:780
+----
+
+We arbitrarily pick pointer 7 (twice) to traverse downwards:
+
+----
+xfs_db> addr ptrs[7]
+xfs_db> p
+magic = 0x4d415052
+level = 1
+numrecs = 36
+leftsib = 563
+rightsib = 780
+bno = 5360
+lsn = 0
+uuid = 98bbde42-67e7-46a5-a73e-d64a76b1b5ce
+owner = 131
+crc = 0x6807761d (correct)
+keys[1-36] = [startblock,owner,offset,attrfork,bmbtblock,startblock_hi,owner_hi,
+	      offset_hi,attrfork_hi,bmbtblock_hi]
+	1:[1685225,133,34319,0,0,1685473,133,34567,0,0]
+	2:[1685475,133,34569,0,0,1685723,133,34817,0,0]
+	3:[1685725,133,34819,0,0,1685973,133,35067,0,0]
+	...
+	34:[1693475,133,42569,0,0,1693723,133,42817,0,0]
+	35:[1693725,133,42819,0,0,1693973,133,43067,0,0]
+	36:[1693975,133,43069,0,0,1694223,133,43317,0,0]
+ptrs[1-36] = 1:669 2:672 3:674...34:722 35:723 36:725
+xfs_db> addr ptrs[7]
+xfs_db> p
+magic = 0x4d415052
+level = 0
+numrecs = 125
+leftsib = 678
+rightsib = 681
+bno = 5440
+lsn = 0
+uuid = 98bbde42-67e7-46a5-a73e-d64a76b1b5ce
+owner = 131
+crc = 0xefce34d4 (correct)
+recs[1-125] = [startblock,blockcount,owner,offset,extentflag,attrfork,bmbtblock]
+	1:[1686725,1,133,35819,0,0,0]
+	2:[1686727,1,133,35821,0,0,0]
+	3:[1686729,1,133,35823,0,0,0]
+	...
+	123:[1686969,1,133,36063,0,0,0]
+	124:[1686971,1,133,36065,0,0,0]
+	125:[1686973,1,133,36067,0,0,0]
+----
+
+Several interesting things pop out here.  The first record shows that
+inode 133 has mapped real-time block 1,686,725 at offset 35,819.  We
+confirm this by looking at the block map for that inode:
+
+----
+xfs_db> inode 133
+xfs_db> p core.realtime
+core.realtime = 1
+xfs_db> bmap
+data offset 35817 startblock 1686723 (1/638147) count 1 flag 0
+data offset 35819 startblock 1686725 (1/638149) count 1 flag 0
+data offset 35821 startblock 1686727 (1/638151) count 1 flag 0
+----
+
+Notice that inode 133 has the real-time flag set, which means that its
+data blocks are all allocated from the real-time device.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
