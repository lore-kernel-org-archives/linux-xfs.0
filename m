Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FCC192B82
	for <linux-xfs@vger.kernel.org>; Thu, 20 Mar 2025 16:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742488118; cv=none; b=sLDe3GH9dSHTXsYRVPlOeRA+LOQL5iZo/o58cNzOne28jTWrpGxwSCGiKbB5+Pj/PnX58tRp4euqwMwDOsfBoFc22IKj6JxBB6lS4GBZUKBiiHHql94GnIqL8DFVj/GQFjz7yOhBRMQ+9RMn3unNKpXjt+uKNBz2Lo0z6RTkczY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742488118; c=relaxed/simple;
	bh=JNu5Xbs3hZjK9jbPeVbAqi1s8+5GSr3WBB/DaXtt7Zo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=M3WW8ZFcY0qOyXxNYEBSRgV3fMSH7B99U8pOlX3Oxb7ZiF4ZkQy8jHjAnLc8/jm/wvPg7m5D5qNkK4eyJcvJgpL10aVBGDlLze/tUvPjH44l8JN1EnejGdo4/iFK05EwUeQZ60cdfALZh0EoAFoGKktWGuokWkQ9ElLGGdnZj1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X73QbRuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X73QbRuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9492DC4CEDD;
	Thu, 20 Mar 2025 16:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742488117;
	bh=JNu5Xbs3hZjK9jbPeVbAqi1s8+5GSr3WBB/DaXtt7Zo=;
	h=Date:From:To:Cc:Subject:From;
	b=X73QbRuHEY4z0m6k8qnxAmqdCmUMI+py1qqkVfC29977Gt2iofg57hqQZQeVewJ3C
	 5+I1DXoiZ0arY0Qs19pgz0tfotXQN79jpz/RLhbup8LP/7uUwcKc1ws5desShOIz4u
	 fK+x8Ctbl4YW5TUf8jpmvF2n3NJYKij2VfFfxmFqeViPz7EaJ11iTdxZ8yfZYHTlHA
	 N0kK5Q3ETI9A/3H77fmSjycQXOf7dGjjp341wwMU/EsgHaxPPaXSWTizE2BKZZwWDS
	 iQ4En7w3Gee/4trm8vPlcT+yioKL0grwekMXmi+Xybifjr73tvi8sNYaO494ATn4ft
	 gejxjsBoa9Ekw==
Date: Thu, 20 Mar 2025 09:28:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] design: document the revisions to the realtime rmap
 formats
Message-ID: <20250320162836.GV89034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Update the realtime rmap ondisk format documentation, since it's changed
a bit since the introduction of the metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../internal_inodes.asciidoc                       |    4 
 .../journaling_log.asciidoc                        |   22 +-
 design/XFS_Filesystem_Structure/magic.asciidoc     |    4 
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    1 
 design/XFS_Filesystem_Structure/realtime.asciidoc  |    5 
 design/XFS_Filesystem_Structure/rtrmapbt.asciidoc  |  215 ++++++++------------
 6 files changed, 115 insertions(+), 136 deletions(-)

diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index 40eb57233ce7c0..9cfb2c29b1e6fe 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -26,6 +26,7 @@ of those inodes have been deallocated and may be reused by future features.
 | xref:Quota_Inodes[Project Quota]               | /quota/project
 | xref:Real-Time_Bitmap_Inode[Realtime Bitmap]   | /rtgroups/*.bitmap
 | xref:Real-Time_Summary_Inode[Realtime Summary] | /rtgroups/*.summary
+| xref:Real_time_Reverse_Mapping_Btree[Realtime Reverse Mapping B+tree] | /rtgroups/*.rmap
 |=====
 
 Metadata files are flagged by the +XFS_DIFLAG2_METADATA+ flag in the
@@ -298,3 +299,6 @@ Checksum of the DQ block.
 There are two inodes allocated to managing the real-time device's space, the
 xref:Real-Time_Bitmap_Inode[Bitmap Inode] and the
 xref:Real-Time_Summary_Inode[Summary Inode].
+
+Each realtime group can allocate one inode to managing a
+xref:Real_time_Reverse_Mapping_Btree[reverse-index of space] usage.
diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index 6b9d65c38260bf..fe8a127aa9abe0 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -352,8 +352,9 @@ typedef struct xfs_efi_log_format {
 ----
 
 *efi_type*::
-The signature of an EFI operation, 0x1236.  This value is in host-endian order,
-not big-endian like the rest of XFS.
+The signature of an EFI operation, 0x1236.  For a realtime extent, this
+value will be 0x124a.  This value is in host-endian order, not big-endian like
+the rest of XFS.
 
 *efi_size*::
 Size of this log item.  Should be 1.
@@ -390,8 +391,9 @@ typedef struct xfs_efd_log_format {
 ----
 
 *efd_type*::
-The signature of an EFD operation, 0x1237.  This value is in host-endian order,
-not big-endian like the rest of XFS.
+The signature of an EFD operation, 0x1237.  For a realtime EFD, this value will
+be 0x124b.  This value is in host-endian order, not big-endian like the rest of
+XFS.
 
 *efd_size*::
 Size of this log item.  Should be 1.
@@ -478,14 +480,15 @@ struct xfs_rui_log_format {
      __uint16_t                rui_type;
      __uint16_t                rui_size;
      __uint32_t                rui_nextents;
-     __uint64_t                rui_id;	
+     __uint64_t                rui_id;
      struct xfs_map_extent     rui_extents[1];
 };
 ----
 
 *rui_type*::
-The signature of an RUI operation, 0x1240.  This value is in host-endian order,
-not big-endian like the rest of XFS.
+The signature of an RUI operation, 0x1240.  For a realtime RUI, this value will
+be 0x124c.  This value is in host-endian order, not big-endian like the rest of
+XFS.
 
 *rui_size*::
 Size of this log item.  Should be 1.
@@ -519,8 +522,9 @@ struct xfs_rud_log_format {
 ----
 
 *rud_type*::
-The signature of an RUD operation, 0x1241.  This value is in host-endian order,
-not big-endian like the rest of XFS.
+The signature of an RUD operation, 0x1241.  For a realtime RUD, this value will
+be 0x124d.  This value is in host-endian order, not big-endian like the rest of
+XFS.
 
 *rud_size*::
 Size of this log item.  Should be 1.
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index 5da29b9ef9f3a8..655f638304ec5d 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -78,6 +78,10 @@ are not aligned to blocks.
 | +XFS_LI_ATTRD+		| 0x1247        |       | xref:ATTRD_Log_Item[Extended Attribute Update Done]
 | +XFS_LI_XMI+			| 0x1248        |       | xref:XMI_Log_Item[File Mapping Exchange Intent]
 | +XFS_LI_XMD+			| 0x1249        |       | xref:XMD_Log_Item[File Mapping Exchange Done]
+| +XFS_LI_EFI_RT+		| 0x124a        |       | xref:EFI_Log_Item[Extent Freeing Intent Log Item]
+| +XFS_LI_EFD_RT+		| 0x124b        |       | xref:EFD_Log_Item[Extent Freeing Done Log Item]
+| +XFS_LI_RUI_RT+		| 0x124c        |       | xref:RUI_Log_Item[Reverse Mapping Update Intent]
+| +XFS_LI_RUD_RT+		| 0x124d        |       | xref:RUD_Log_Item[Reverse Mapping Update Done]
 |=====
 
 = Theoretical Limits
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index 6e52e5fd3d6c1e..bd192e3a929281 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -204,6 +204,7 @@ enum xfs_metafile_type {
      XFS_METAFILE_PRJQUOTA,
      XFS_METAFILE_RTBITMAP,
      XFS_METAFILE_RTSUMMARY,
+     XFS_METAFILE_RTRMAP,
 };
 ----
 
diff --git a/design/XFS_Filesystem_Structure/realtime.asciidoc b/design/XFS_Filesystem_Structure/realtime.asciidoc
index 3a72eb5175ad89..ab47a12a50f46b 100644
--- a/design/XFS_Filesystem_Structure/realtime.asciidoc
+++ b/design/XFS_Filesystem_Structure/realtime.asciidoc
@@ -299,7 +299,9 @@ The summary counts were excerpted for brevity.
 To reduce metadata contention for space allocation and remapping activities
 being applied to realtime files, the realtime volume can be split into
 allocation groups, just like the data volume.  The free space information is
-still contained in a single file that applies to the entire volume.
+still contained in a single file that applies to the entire volume.  This
+sharding enables code reuse between the data and realtime reverse mapping
+indexes and supports parallelism of reverse mapping and online fsck activities.
 
 Each realtime allocation group can contain up to (2^31^ - 1) filesystem blocks,
 regardless of the underlying realtime extent size.
@@ -309,6 +311,7 @@ Each realtime group has the following characteristics:
          * Group 0 has a super block describing overall filesystem info
          * Free space bitmap
          * Summary of free space
+         * Reverse space mapping btree
 
 The free space metadata are the same as described in the previous sections,
 except that their scope covers only a single rtgroup.  The other structures are
diff --git a/design/XFS_Filesystem_Structure/rtrmapbt.asciidoc b/design/XFS_Filesystem_Structure/rtrmapbt.asciidoc
index 3a109b207654ff..b8d174f24d943a 100644
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
+number can be found by resolving the path +/rtgroups/$rgno.rmap+ in the
+metadata directory tree.  The B+tree blocks themselves are stored on the data
+volume.  The structures used for an inode's B+tree root are:
 
 [source, c]
 ----
@@ -32,52 +29,52 @@ struct xfs_rtrmap_root {
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
+header and is followed first by an array of doubled up +xfs_rmap_key+ values
+and then an array of +xfs_rtrmap_ptr_t+ values.  The size of both arrays is
+specified by the header's +bb_numrecs+ value.
 
-Each record in the real-time reverse-mapping B+tree has the following
-structure:
+* The root node in the inode can only contain up to 14 leaf records or 7
+key/pointer pairs for a standard 512 byte inode before a new level of nodes is
+added between the root and the leaves.
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
+The length of this extent, in rt blocks.
 
 *rm_owner*::
-A 64-bit number describing the owner of this extent.  This must be an
-inode number, because the real-time device is for file data only.
+A 64-bit number describing the owner of this extent.  This must be
++XFS_RMAP_OWN_FS+ for the first extent in the realtime group zero if realtime
+superblocks are enabled.  For all other records, it must be an inode number,
+because the real-time volume does not store any other metadata.
 
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
@@ -85,7 +82,7 @@ the flag in the xref:Data_Extents[extent record] format which means
 +XFS_EXT_UNWRITTEN+.
 
 *rm_offset*::
-The 54-bit logical file block offset, if +rm_owner+ describes an
+The 61-bit logical file block offset, if +rm_owner+ describes an
 inode.
 
 [NOTE]
@@ -96,30 +93,30 @@ The key has the following structure:
 
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
@@ -130,105 +127,71 @@ This example shows a real-time reverse-mapping B+tree from a freshly
 populated root filesystem:
 
 ----
-xfs_db> sb 0
-xfs_db> addr rrmapino
+xfs_db> path -m /rtgroups/0.rmap
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
