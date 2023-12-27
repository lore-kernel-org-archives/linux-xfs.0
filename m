Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D5D7ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 01:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RWKnjk8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD7BC433C7;
	Mon,  1 Jan 2024 01:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071337;
	bh=+/QX8rx8zzRCJ6ECGhch8ojIkwuqSG19X5+V5wu1uLw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RWKnjk8yTq6L6UJwF5XlWtYXH9qLaQRcNwzdjxCUxq0oHtsV/biI0MEihGTdXPE0H
	 /rMSniBxrOrhK6ckJ4N3V7o1fxHBu+5SUoQCY8MqA/bqJX8g0OVob0oLy1GATEtX65
	 fYFTHfpJW+bqRzIXERJdWewV1dvkABo8nraXpuErCYq78c8QiYXtIzTaA4F1eR+qFe
	 jxOY3BpM/NBdwmefgwDlYj0rm3z32SAri6Jn9Dn+9FPEGxLCAl794TQFT7baKEeibX
	 xJ7v3S5cn/Mv68gh5slfmfp3IJrLixYRJriG+ek5a3uzfnFI/QEQ4qFqhN1+i4VFdy
	 dP9E2u3g5KBqA==
Date: Sun, 31 Dec 2023 17:08:56 +9900
Subject: [PATCH 1/1] design: document the revisions to the realtime rmap
 formats
From: "Darrick J. Wong" <djwong@kernel.org>
To: darrick.wong@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405037638.1829975.7851817593974485088.stgit@frogsfrogsfrogs>
In-Reply-To: <170405037626.1829975.16480777008172979264.stgit@frogsfrogsfrogs>
References: <170405037626.1829975.16480777008172979264.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update the realtime rmap ondisk format documentation, since it's changed
a bit since the introduction of the metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../allocation_groups.asciidoc                     |    8 -
 .../internal_inodes.asciidoc                       |    4 
 .../journaling_log.asciidoc                        |    9 +
 design/XFS_Filesystem_Structure/realtime.asciidoc  |    5 
 design/XFS_Filesystem_Structure/rtrmapbt.asciidoc  |  216 ++++++++------------
 5 files changed, 105 insertions(+), 137 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index ab8868d0..51ed106f 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -112,7 +112,6 @@ struct xfs_sb
 	xfs_ino_t		sb_pquotino;
 	xfs_lsn_t		sb_lsn;
 	uuid_t			sb_meta_uuid;
-	xfs_ino_t		sb_rrmapino;
 };
 ----
 *sb_magicnum*::
@@ -534,13 +533,6 @@ If the +XFS_SB_FEAT_INCOMPAT_META_UUID+ feature is set, then the UUID field in
 all metadata blocks must match this UUID.  If not, the block header UUID field
 must match +sb_uuid+.
 
-*sb_rrmapino*::
-If the +XFS_SB_FEAT_RO_COMPAT_RMAPBT+ feature is set and a real-time
-device is present (+sb_rblocks+ > 0), this field points to an inode
-that contains the root to the
-xref:Real_time_Reverse_Mapping_Btree[Real-Time Reverse Mapping B+tree].
-This field is zero otherwise.
-
 === xfs_db Superblock Example
 
 A filesystem is made on a single disk with the following command:
diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index e07b5f19..7da0cdf6 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -30,6 +30,7 @@ of those inodes have been deallocated and may be reused by future features.
 | Project Quotas                                 | /quota/project
 | xref:Real-Time_Bitmap_Inode[Realtime Bitmap]   | /realtime/bitmap
 | xref:Real-Time_Summary_Inode[Realtime Summary] | /realtime/summary
+| xref:Real_time_Reverse_Mapping_Btree[Realtime Reverse Mapping B+tree] | /realtime/*.rmap
 |=====
 
 Metadata files are flagged by the +XFS_DIFLAG2_METADATA+ flag in the
@@ -322,3 +323,6 @@ Checksum of the DQ block.
 There are two inodes allocated to managing the real-time device's space, the
 xref:Real-Time_Bitmap_Inode[Bitmap Inode] and the
 xref:Real-Time_Summary_Inode[Summary Inode].
+
+Each realtime group can allocate one inode to managing a
+xref:Real_time_Reverse_Mapping_Btree[reverse-index of space] usage.
diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index c91fbb6a..52513b18 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -332,7 +332,10 @@ typedef struct xfs_extent_64 {
 Start block of this extent.
 
 *ext_len*::
-Length of this extent.
+Length of this extent.  If the highest bit of this field is set
+(+XFS_EFI_REALTIME_EXT+), this EFI applies to blocks on the realtime volume.
+The realtime block range must be converted to a range of realtime extents
+before further processing occurs.
 
 The ``extent freeing intent'' operation comes first; it tells the log that XFS
 wants to free some extents.  This record is crucial for correct log recovery
@@ -464,6 +467,8 @@ reverse mapping operation we want.  The upper three bytes are flag bits.
 | +XFS_RMAP_EXTENT_ATTR_FORK+	| Extent is for the attribute fork.
 | +XFS_RMAP_EXTENT_BMBT_BLOCK+	| Extent is for a block mapping btree block.
 | +XFS_RMAP_EXTENT_UNWRITTEN+	| Extent is unwritten.
+| +XFS_RMAP_EXTENT_REALTIME+	| Extent describes a range of blocks on the
+realtime volume.
 |=====
 
 The ``rmap update intent'' operation comes first; it tells the log that XFS
@@ -478,7 +483,7 @@ struct xfs_rui_log_format {
      __uint16_t                rui_type;
      __uint16_t                rui_size;
      __uint32_t                rui_nextents;
-     __uint64_t                rui_id;	
+     __uint64_t                rui_id;
      struct xfs_map_extent     rui_extents[1];
 };
 ----
diff --git a/design/XFS_Filesystem_Structure/realtime.asciidoc b/design/XFS_Filesystem_Structure/realtime.asciidoc
index f5fdb4e5..77d947ba 100644
--- a/design/XFS_Filesystem_Structure/realtime.asciidoc
+++ b/design/XFS_Filesystem_Structure/realtime.asciidoc
@@ -53,7 +53,9 @@ files since the space is preallocated and metadata maintenance is minimal.
 To reduce metadata contention for space allocation and remapping activities
 being applied to realtime files, the realtime volume can be split into
 allocation groups, just like the data volume.  The free space information is
-still contained in a single file that applies to the entire volume.
+still contained in a single file that applies to the entire volume.  This
+sharding enables code reuse between the data and realtime reverse mapping
+indexes and supports parallelism of reverse mapping and online fsck activities.
 
 Each realtime allocation group can contain up to (2^31^ - 1) filesystem blocks,
 regardless of the underlying realtime extent size.
@@ -63,6 +65,7 @@ Each realtime group has the following characteristics:
          * A super block describing overall filesystem info
          * Free space bitmap
          * Summary of free space
+         * Reverse space mapping
 
 Each of these structures are expanded upon in the following sections.
 
diff --git a/design/XFS_Filesystem_Structure/rtrmapbt.asciidoc b/design/XFS_Filesystem_Structure/rtrmapbt.asciidoc
index 3a109b20..d6c21127 100644
--- a/design/XFS_Filesystem_Structure/rtrmapbt.asciidoc
+++ b/design/XFS_Filesystem_Structure/rtrmapbt.asciidoc
@@ -1,11 +1,8 @@
 [[Real_time_Reverse_Mapping_Btree]]
-=== Real-Time Reverse-Mapping B+tree
-
-[NOTE]
-This data structure is under construction!  Details may change.
+=== Reverse-Mapping B+tree
 
 If the reverse-mapping B+tree and real-time storage device features
-are enabled, the real-time device has its own reverse block-mapping
+are enabled, each real-time group has its own reverse block-mapping
 B+tree.
 
 As mentioned in the chapter about xref:Reconstruction[reconstruction],
@@ -19,10 +16,10 @@ This B+tree is only present if the +XFS_SB_FEAT_RO_COMPAT_RMAPBT+
 feature is enabled and a real time device is present.  The feature
 requires a version 5 filesystem.
 
-The real-time reverse mapping B+tree is rooted in an inode's data
-fork; the inode number is given by the +sb_rrmapino+ field in the
-superblock.  The B+tree blocks themselves are stored in the regular
-filesystem.  The structures used for an inode's B+tree root are:
+The rtgroup reverse mapping B+tree is rooted in an inode's data fork; the inode
+number can be found by resolving the path +/realtime/$rgno.rmap+ in the
+metadata directory tree.  The B+tree blocks themselves are stored on the data
+volume.  The structures used for an inode's B+tree root are:
 
 [source, c]
 ----
@@ -32,52 +29,53 @@ struct xfs_rtrmap_root {
 };
 ----
 
-* On disk, the B+tree node starts with the +xfs_rtrmap_root+ header
-followed by an array of +xfs_rtrmap_key+ values and then an array of
-+xfs_rtrmap_ptr_t+ values. The size of both arrays is specified by the
-header's +bb_numrecs+ value.
+* If the B+tree contains only a single level, the ondisk data fork area begins
+with a +xfs_rtrmap_root+ header followed by an array of +xfs_rmap_rec+ leaf
+records.
 
-* The root node in the inode can only contain up to 10 key/pointer
-pairs for a standard 512 byte inode before a new level of nodes is
-added between the root and the leaves.  +di_forkoff+ should always
-be zero, because there are no extended attributes.
+* Otherwise, the ondisk data fork area begins with the +xfs_rtrmap_root+
+header and is followed first by an array of doubled up +xfs_refcount_key+
+values and then an array of +xfs_rtrmap_ptr_t+ values.  The size of both arrays
+is specified by the header's +bb_numrecs+ value.
 
-Each record in the real-time reverse-mapping B+tree has the following
-structure:
+* The root node in the inode can only contain up to 14 leaf records or 7
+key/pointer pairs for a standard 512 byte inode before a new level of nodes is
+added between the root and the leaves.  +di_forkoff+ should always be zero,
+because there are no extended attributes.
+
+Each record in an rtgroup reverse-mapping B+tree has the same structure as an
+AG reverse mapping btree:
 
 [source, c]
 ----
-struct xfs_rtrmap_rec {
-     __be64                     rm_startblock;
-     __be64                     rm_blockcount;
+struct xfs_rmap_rec {
+     __be32                     rm_startblock;
+     __be32                     rm_blockcount;
      __be64                     rm_owner;
      __be64                     rm_fork:1;
      __be64                     rm_bmbt:1;
      __be64                     rm_unwritten:1;
-     __be64                     rm_unused:7;
-     __be64                     rm_offset:54;
+     __be64                     rm_offset:61;
 };
 ----
 
 *rm_startblock*::
-Real-time device block number of this record.
+rtgroup block number of this record.
 
 *rm_blockcount*::
-The length of this extent, in real-time blocks.
+The length of this extent, in filesystem blocks.
 
 *rm_owner*::
-A 64-bit number describing the owner of this extent.  This must be an
-inode number, because the real-time device is for file data only.
+A 64-bit number describing the owner of this extent.  This must be
++XFS_RMAP_OWN_FS+ for the first extent in the realtime group.  For all other
+records, it must be an inode number, because the real-time volume does not
+store any other metadata.
 
 *rm_fork*::
-If +rm_owner+ describes an inode, this can be 1 if this record is for
-an attribute fork.  This value will always be zero for real-time
-extents.
+This value will always be zero.
 
 *rm_bmbt*::
-If +rm_owner+ describes an inode, this can be 1 to signify that this
-record is for a block map B+tree block.  In this case, +rm_offset+ has
-no meaning.  This value will always be zero for real-time extents.
+This value will always be zero.
 
 *rm_unwritten*::
 A flag indicating that the extent is unwritten.  This corresponds to
@@ -85,7 +83,7 @@ the flag in the xref:Data_Extents[extent record] format which means
 +XFS_EXT_UNWRITTEN+.
 
 *rm_offset*::
-The 54-bit logical file block offset, if +rm_owner+ describes an
+The 61-bit logical file block offset, if +rm_owner+ describes an
 inode.
 
 [NOTE]
@@ -96,30 +94,30 @@ The key has the following structure:
 
 [source, c]
 ----
-struct xfs_rtrmap_key {
-     __be64                     rm_startblock;
+struct xfs_rmap_key {
+     __be32                     rm_startblock;
      __be64                     rm_owner;
      __be64                     rm_fork:1;
      __be64                     rm_bmbt:1;
      __be64                     rm_reserved:1;
-     __be64                     rm_unused:7;
-     __be64                     rm_offset:54;
+     __be64                     rm_offset:61;
 };
 ----
 
-* All block numbers are 64-bit real-time device block numbers.
+* All block numbers in records and keys are 32-bit real-time group block
+numbers.
 
 * The +bb_magic+ value is ``MAPR'' (0x4d415052).
 
-* The +xfs_btree_lblock_t+ header is used for intermediate B+tree node as well
-as the leaves.
+* The +struct xfs_btree_lblock+ header is used for intermediate B+tree node as
+well as the leaves.
 
 * Each pointer is associated with two keys.  The first of these is the
 "low key", which is the key of the smallest record accessible through
 the pointer.  This low key has the same meaning as the key in all
 other btrees.  The second key is the high key, which is the maximum of
 the largest key that can be used to access a given record underneath
-the pointer.  Recall that each record in the real-time reverse mapping
+the pointer.  Recall that each record in the rtgroup reverse mapping
 b+tree describes an interval of physical blocks mapped to an interval
 of logical file block offsets; therefore, it makes sense that a range
 of keys can be used to find to a record.
@@ -130,105 +128,71 @@ This example shows a real-time reverse-mapping B+tree from a freshly
 populated root filesystem:
 
 ----
-xfs_db> sb 0
-xfs_db> addr rrmapino
+xfs_db> path -m /realtime/0.rmap
 xfs_db> p
 core.magic = 0x494e
 core.mode = 0100000
 core.version = 3
-core.format = 5 (rtrmapbt)
+core.format = 5 (rmap)
 ...
-u3.rtrmapbt.level = 3
-u3.rtrmapbt.numrecs = 1
-u3.rtrmapbt.keys[1] = [startblock,owner,offset,attrfork,bmbtblock,startblock_hi,
-		       owner_hi,offset_hi,attrfork_hi,bmbtblock_hi]
-	1:[1,132,1,0,0,1705337,133,54431,0,0]
-u3.rtrmapbt.ptrs[1] = 1:671
+u3.rtrmapbt.level = 1
+u3.rtrmapbt.numrecs = 3
+u3.rtrmapbt.keys[1-3] = [startblock,owner,offset,attrfork,bmbtblock,
+			 startblock_hi,owner_hi,offset_hi,attrfork_hi,
+			 bmbtblock_hi] 
+1:[0,-3,0,0,0,682,10015,681,0,0] 
+2:[228,10014,227,0,0,454,10014,453,0,0] 
+3:[456,10014,455,0,0,682,10014,681,0,0]
+u3.rtrmapbt.ptrs[1-3] = 1:10 2:11 3:12
+---
+
+This is a two-level tree, so we should follow it towards the leaves.
+
+---
 xfs_db> addr u3.rtrmapbt.ptrs[1]
 xfs_db> p
 magic = 0x4d415052
-level = 2
-numrecs = 8
-leftsib = null
-rightsib = null
-bno = 5368
-lsn = 0x400000000
-uuid = 98bbde42-67e7-46a5-a73e-d64a76b1b5ce
-owner = 131
-crc = 0x2560d199 (correct)
-keys[1-8] = [startblock,owner,offset,attrfork,bmbtblock,startblock_hi,owner_hi,
-	     offset_hi,attrfork_hi,bmbtblock_hi]
-	1:[1,132,1,0,0,17749,132,17749,0,0]
-	2:[17751,132,17751,0,0,35499,132,35499,0,0]
-	3:[35501,132,35501,0,0,53249,132,53249,0,0]
-	4:[53251,132,53251,0,0,1658473,133,7567,0,0]
-	5:[1658475,133,7569,0,0,1667473,133,16567,0,0]
-	6:[1667475,133,16569,0,0,1685223,133,34317,0,0]
-	7:[1685225,133,34319,0,0,1694223,133,43317,0,0]
-	8:[1694225,133,43319,0,0,1705337,133,54431,0,0]
-ptrs[1-8] = 1:134 2:238 3:345 4:453 5:795 6:563 7:670 8:780
-----
-
-We arbitrarily pick pointer 7 (twice) to traverse downwards:
-
-----
-xfs_db> addr ptrs[7]
-xfs_db> p
-magic = 0x4d415052
-level = 1
-numrecs = 36
-leftsib = 563
-rightsib = 780
-bno = 5360
-lsn = 0
-uuid = 98bbde42-67e7-46a5-a73e-d64a76b1b5ce
-owner = 131
-crc = 0x6807761d (correct)
-keys[1-36] = [startblock,owner,offset,attrfork,bmbtblock,startblock_hi,owner_hi,
-	      offset_hi,attrfork_hi,bmbtblock_hi]
-	1:[1685225,133,34319,0,0,1685473,133,34567,0,0]
-	2:[1685475,133,34569,0,0,1685723,133,34817,0,0]
-	3:[1685725,133,34819,0,0,1685973,133,35067,0,0]
-	...
-	34:[1693475,133,42569,0,0,1693723,133,42817,0,0]
-	35:[1693725,133,42819,0,0,1693973,133,43067,0,0]
-	36:[1693975,133,43069,0,0,1694223,133,43317,0,0]
-ptrs[1-36] = 1:669 2:672 3:674...34:722 35:723 36:725
-xfs_db> addr ptrs[7]
-xfs_db> p
-magic = 0x4d415052
 level = 0
-numrecs = 125
-leftsib = 678
-rightsib = 681
-bno = 5440
+numrecs = 115
+leftsib = null
+rightsib = 11
+bno = 80
 lsn = 0
-uuid = 98bbde42-67e7-46a5-a73e-d64a76b1b5ce
-owner = 131
-crc = 0xefce34d4 (correct)
-recs[1-125] = [startblock,blockcount,owner,offset,extentflag,attrfork,bmbtblock]
-	1:[1686725,1,133,35819,0,0,0]
-	2:[1686727,1,133,35821,0,0,0]
-	3:[1686729,1,133,35823,0,0,0]
-	...
-	123:[1686969,1,133,36063,0,0,0]
-	124:[1686971,1,133,36065,0,0,0]
-	125:[1686973,1,133,36067,0,0,0]
+uuid = 23d157a4-8ca7-4fca-8782-637dc6746105
+owner = 133
+crc = 0x4c046e7d (correct)
+recs[1-115] = [startblock,blockcount,owner,offset,extentflag,attrfork,bmbtblock] 
+1:[0,1,-3,0,0,0,0] 
+2:[1,682,10015,0,0,0,0] 
+3:[2,1,10014,1,0,0,0] 
+4:[4,1,10014,3,0,0,0] 
+5:[6,1,10014,5,0,0,0] 
+6:[8,1,10014,7,0,0,0] 
+7:[10,1,10014,9,0,0,0] 
+8:[12,1,10014,11,0,0,0] 
+9:[14,1,10014,13,0,0,0] 
+...
+112:[220,1,10014,219,0,0,0] 
+113:[222,1,10014,221,0,0,0] 
+114:[224,1,10014,223,0,0,0] 
+115:[226,1,10014,225,0,0,0]
 ----
 
-Several interesting things pop out here.  The first record shows that
-inode 133 has mapped real-time block 1,686,725 at offset 35,819.  We
-confirm this by looking at the block map for that inode:
+Several interesting things pop out here.  The first record shows that inode
+10,014 has mapped real-time block 225 at offset 225.  We confirm this by
+looking at the block map for that inode:
 
 ----
-xfs_db> inode 133
+xfs_db> inode 10014
 xfs_db> p core.realtime
 core.realtime = 1
-xfs_db> bmap
-data offset 35817 startblock 1686723 (1/638147) count 1 flag 0
-data offset 35819 startblock 1686725 (1/638149) count 1 flag 0
-data offset 35821 startblock 1686727 (1/638151) count 1 flag 0
+xfs_db> bmap 220 10
+data offset 221 startblock 222 (0/222) count 1 flag 0
+data offset 223 startblock 224 (0/224) count 1 flag 0
+data offset 225 startblock 226 (0/226) count 1 flag 0
+data offset 227 startblock 228 (0/228) count 1 flag 0
+data offset 229 startblock 230 (0/230) count 1 flag 0
 ----
 
-Notice that inode 133 has the real-time flag set, which means that its
+Notice that inode 10,014 has the real-time flag set, which means that its
 data blocks are all allocated from the real-time device.

