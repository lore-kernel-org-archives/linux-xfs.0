Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD21F7CB7
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 18:36:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26BAEAC001
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 16:36:25 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id V8Qvq7kdnbL69tBh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 16:36:17 -0800 (PST)
Subject: [PATCH 6/6] xfsdocs: document the extended rmap btree
From: "Darrick J. Wong" <djwong@alder.djwong.org>
Date: Fri, 04 Mar 2016 16:35:45 -0800
Message-ID: <20160305003545.28327.99480.stgit@birch.djwong.org>
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

The reverse mapping btree now comes in two flavors: a fat one for
reflink filesystems supporting overlapped interval queries and a thin
one for filesystems that don't share blocks.  Document the new on-disk
formats.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 design/XFS_Filesystem_Structure/docinfo.xml     |   16 +++
 design/XFS_Filesystem_Structure/magic.asciidoc  |    1 
 design/XFS_Filesystem_Structure/rmapbt.asciidoc |  108 +++++++++++++++++++++--
 3 files changed, 116 insertions(+), 9 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/docinfo.xml b/design/XFS_Filesystem_Structure/docinfo.xml
index 009376f..7d32260 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -138,4 +138,20 @@
 			</simplelist>
 		</revdescription>
 	</revision>
+	<revision>
+		<revnumber>3.1415</revnumber>
+		<date>March 2016</date>
+		<author>
+			<firstname>Darrick</firstname>
+			<surname>Wong</surname>
+			<email></email>
+		</author>
+		<revdescription>
+			<simplelist>
+				<member>Move the b+tree discussion to a separate chapter.</member>
+				<member>Discuss overlapping interval b+trees.</member>
+				<member>Document the reverse mapping btree changes when reflink is enabled.</member>
+			</simplelist>
+		</revdescription>
+	</revision>
 </revhistory>
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index 7caf20e..5ce19a5 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -45,6 +45,7 @@ relevant chapters.  Magic numbers tend to have consistent locations:
 | +XFS_ATTR3_LEAF_MAGIC+	| 0x3bee	|     	| xref:Leaf_Attributes[Leaf Attribute], v5 only
 | +XFS_ATTR3_RMT_MAGIC+		| 0x5841524d	| XARM	| xref:Remote_Values[Remote Attribute Value], v5 only
 | +XFS_RMAP_CRC_MAGIC+		| 0x524d4233	| RMB3	| xref:Reverse_Mapping_Btree[Reverse Mapping B+tree], v5 only
+| +XFS_RMAPX_CRC_MAGIC+		| 0x34524d42	| 4RMB	| xref:Reverse_Mapping_Btree[Reverse Mapping B+tree], v5 only
 | +XFS_REFC_CRC_MAGIC+		| 0x52334643	| R3FC	| xref:Reference_Count_Btree[Reference Count B+tree], v5 only
 |=====
 
diff --git a/design/XFS_Filesystem_Structure/rmapbt.asciidoc b/design/XFS_Filesystem_Structure/rmapbt.asciidoc
index 2be28fa..bfdc74e 100644
--- a/design/XFS_Filesystem_Structure/rmapbt.asciidoc
+++ b/design/XFS_Filesystem_Structure/rmapbt.asciidoc
@@ -81,18 +81,40 @@ For the moment, there is a requirement that all records in the data or
 attribute forks must match exactly with the corresponding entry in the
 reverse-mapping B+tree.  This may be lifted in future versions of the patchset.
 
-For the reverse-mapping B+tree, the key definition is larger than the usual AG
-block number.  On a classic XFS filesystem, each block has only one owner, which
-means that +rm_startblock+ is sufficient to uniquely identify each record.
-However, shared block support (reflink) on XFS breaks that assumption; now
-filesystem blocks can be linked to any logical block offset of any file inode.
-Therefore, the key must include the owner and offset information to preserve the
-1 to 1 relation between key and record.  The key has the following structure:
+=== Reverse Mapping B+tree without Shared Blocks
+
+For the reverse-mapping B+tree on a filesystem that does not support sharing
+file data blocks, we can uniquely identify each record using only the per-AG
+block number.  The key has the following structure:
 
 [source, c]
 ----
 struct xfs_rmap_key {
      __be32                     rm_startblock;
+};
+----
+
+* As the reference counting is AG relative, all the block numbers are only
+32-bits.
+* The +bb_magic+ value is "RMB3" (0x524d4233).
+* The +xfs_btree_sblock_t+ header is used for intermediate B+tree node as well
+as the leaves.
+
+=== Reverse Mapping B+tree with Shared Blocks
+
+For the reverse-mapping B+tree on a filesystem that supports sharing of file
+data blocks, the key definition is larger than the usual AG block number.  On a
+classic XFS filesystem, each block has only one owner, which means that
++rm_startblock+ is sufficient to uniquely identify each record.  However,
+shared block support (reflink) on XFS breaks that assumption; now filesystem
+blocks can be linked to any logical block offset of any file inode.  Therefore,
+the key must include the owner and offset information to preserve the 1 to 1
+relation between key and record.  The key has the following structure:
+
+[source, c]
+----
+struct xfs_rmapx_key {
+     __be32                     rm_startblock;
      __be64                     rm_owner;
      __be64                     rm_fork:1;
      __be64                     rm_bmbt:1;
@@ -102,9 +124,17 @@ struct xfs_rmap_key {
 
 * As the reference counting is AG relative, all the block numbers are only
 32-bits.
-* The +bb_magic+ value is "RMB3" (0x524d4233).
+* The +bb_magic+ value is "4RMB" (0x34524d42).
 * The +xfs_btree_sblock_t+ header is used for intermediate B+tree node as well
 as the leaves.
+* Each pointer is associated with two keys.  The first of these is the "low
+key", which is the key of the smallest record accessible through the pointer.
+This low key has the same meaning as the key in all other btrees.  The second
+key is the high key, which is the maximum of the largest key that can be used
+to access a given record underneath the pointer.  Recall that each record
+in the reverse mapping b+tree describes an interval of physical blocks mapped
+to an interval of logical file block offsets; therefore, it makes sense that
+a range of keys can be used to find to a record.
 
 === xfs_db rmapbt Example
 
@@ -112,7 +142,7 @@ This example shows a reverse-mapping B+tree from a freshly formatted root
 filesystem:
 
 ----
-xfs_db> agi 0
+xfs_db> agf 0
 xfs_db> addr rmaproot
 xfs_db> p
 magic = 0x524d4233
@@ -222,3 +252,63 @@ magic = 0x524d4233
 
 As you can see, the reverse block-mapping B+tree is an important secondary
 metadata structure, which can be used to reconstruct damaged primary metadata.
+Now let's look at an extend rmap btree:
+
+----
+xfs_db> agf 0
+xfs_db> addr rmaproot
+xfs_db> p
+magic = 0x34524d42
+level = 1
+numrecs = 5
+leftsib = null
+rightsib = null
+bno = 6368
+lsn = 0x100000d1b
+uuid = 400f0928-6b88-4c37-af1e-cef1f8911f3f
+owner = 0
+crc = 0x8d4ace05 (correct)
+keys[1-5] = [startblock,owner,offset,attrfork,bmbtblock,startblock_hi,owner_hi,offset_hi,attrfork_hi,bmbtblock_hi]
+1:[0,-3,0,0,0,705,132,681,0,0]
+2:[24,5761,0,0,0,548,5761,524,0,0]
+3:[24,5929,0,0,0,380,5929,356,0,0]
+4:[24,6097,0,0,0,212,6097,188,0,0]
+5:[24,6277,0,0,0,807,-7,0,0,0]
+ptrs[1-5] = 1:5 2:771 3:9 4:10 5:11
+----
+
+The second pointer stores both the low key [24,5761,0,0,0] and the high key
+[548,5761,524,0,0], which means that we can expect block 771 to contain records
+starting at physical block 24, inode 5761, offset zero; and that one of the
+records can be used to find a reverse mapping for physical block 548, inode
+5761, and offset 524:
+
+----
+xfs_db> addr ptrs[2]
+xfs_db> p
+magic = 0x34524d42
+level = 0
+numrecs = 168
+leftsib = 5
+rightsib = 9
+bno = 6168
+lsn = 0x100000d1b
+uuid = 400f0928-6b88-4c37-af1e-cef1f8911f3f
+owner = 0
+crc = 0xd58eff0e (correct)
+recs[1-168] = [startblock,blockcount,owner,offset,extentflag,attrfork,bmbtblock]
+1:[24,525,5761,0,0,0,0]
+2:[24,524,5762,0,0,0,0]
+3:[24,523,5763,0,0,0,0]
+...
+166:[24,360,5926,0,0,0,0]
+167:[24,359,5927,0,0,0,0]
+168:[24,358,5928,0,0,0,0]
+----
+
+Observe that the first record in the block starts at physical block 24, inode
+5761, offset zero, just as we expected.  Note that this first record is also
+indexed by the highest key as provided in the node block; physical block 548,
+inode 5761, offset 524 is the very last block mapped by this record.  Furthermore,
+note that record 168, despite being the last record in this block, has a lower
+maximum key (physical block 382, inode 5928, offset 23) than the first record.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
