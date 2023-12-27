Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF93A7F9
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 01:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJiMt0tQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB316C433C8;
	Mon,  1 Jan 2024 01:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071352;
	bh=+iR2EduwwULqnF9Zqa94EzOOo52MERGgHwX2HT7u734=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KJiMt0tQ+MIB18kbHkIkD4BE8Yzr+cd7IVqHMTmjCUSOTja7FltIeKCXfmHNfDrpc
	 M1Bp3PmMbtMv37WNXiS2gs96i3h0+6qL6pnRD0tZK9862qwY1CzSftJophYMPHYPrC
	 1lQf9LDmA3XDaikgaXOj52m7F+PgeuGknBvc0ZziTwYzl9t4A8VfwQ3l2GEfZOCObf
	 /H9s2BYtkbICiOpa3RpMyiw6JG2xjc5NTlTTuHW9P8PKBgLSJo/HdRM+4E4HghF8RD
	 FAWeF221gs27d85L7ia4XfmJ85tJ6cFWFnwOcy2Gco/TvOtLgM1MSSoH1n4hGHK9a8
	 f8BnlvwNk8zFg==
Date: Sun, 31 Dec 2023 17:09:12 +9900
Subject: [PATCH 1/1] design: document changes for the realtime refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: darrick.wong@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405037968.1831712.9678120862666082728.stgit@frogsfrogsfrogs>
In-Reply-To: <170405037956.1831712.9546527653473091013.stgit@frogsfrogsfrogs>
References: <170405037956.1831712.9546527653473091013.stgit@frogsfrogsfrogs>
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

Update the ondisk format documentation to reflect the realtime refcount
btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../internal_inodes.asciidoc                       |    5 -
 .../journaling_log.asciidoc                        |    9 +
 design/XFS_Filesystem_Structure/magic.asciidoc     |    1 
 design/XFS_Filesystem_Structure/realtime.asciidoc  |    5 -
 .../XFS_Filesystem_Structure/rtrefcountbt.asciidoc |  173 ++++++++++++++++++++
 5 files changed, 190 insertions(+), 3 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/rtrefcountbt.asciidoc


diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index 7da0cdf6..0fc758c6 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -31,6 +31,7 @@ of those inodes have been deallocated and may be reused by future features.
 | xref:Real-Time_Bitmap_Inode[Realtime Bitmap]   | /realtime/bitmap
 | xref:Real-Time_Summary_Inode[Realtime Summary] | /realtime/summary
 | xref:Real_time_Reverse_Mapping_Btree[Realtime Reverse Mapping B+tree] | /realtime/*.rmap
+| xref:Real_time_Refcount_Btree[Realtime Reference Count+tree] | /realtime/*.refcount
 |=====
 
 Metadata files are flagged by the +XFS_DIFLAG2_METADATA+ flag in the
@@ -325,4 +326,6 @@ xref:Real-Time_Bitmap_Inode[Bitmap Inode] and the
 xref:Real-Time_Summary_Inode[Summary Inode].
 
 Each realtime group can allocate one inode to managing a
-xref:Real_time_Reverse_Mapping_Btree[reverse-index of space] usage.
+xref:Real_time_Reverse_Mapping_Btree[reverse-index of space] usage, and
+a second one to manage xref:Real_time_Refcount_Btree[reference counts] of space
+usage.
diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index 52513b18..2c7b7383 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -569,6 +569,15 @@ reverse mapping operation we want.  The upper three bytes are flag bits.
 | +XFS_REFCOUNT_EXTENT_FREE_COW+  | Unreserve an extent for staging copy on write.
 |=====
 
+.Reference count update log intent flags
+[options="header"]
+|=====
+| Value				  | Description
+| +XFS_REFCOUNT_EXTENT_REALTIME+  | Extent describes a range of blocks on the
+realtime volume.  The range must be aligned to the realtime extent size,
+because extents cannot be partially shared.
+|=====
+
 The ``reference count update intent'' operation comes first; it tells the log
 that XFS wants to update some reference counts.  This record is crucial for
 correct log recovery because it enables us to spread a complex metadata update
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index c83f59a2..19ee52b8 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -49,6 +49,7 @@ relevant chapters.  Magic numbers tend to have consistent locations:
 | +XFS_REFC_CRC_MAGIC+		| 0x52334643	| R3FC	| xref:Reference_Count_Btree[Reference Count B+tree], v5 only
 | +XFS_MD_MAGIC+		| 0x5846534d	| XFSM	| xref:Metadata_Dumps[Metadata Dumps]
 | +XFS_RTSB_MAGIC+		| 0x58524750	| XRGP	| xref:Realtime_Groups[Realtime Groups]
+| +XFS_RTREFC_CRC_MAGIC+	| 0x52434e54	| RCNT	| xref:Real_time_Refcount_Btree[Real-Time Reference Count B+tree], v5 only
 |=====
 
 The magic numbers for log items are at offset zero in each log item, but items
diff --git a/design/XFS_Filesystem_Structure/realtime.asciidoc b/design/XFS_Filesystem_Structure/realtime.asciidoc
index 77d947ba..5d0b47a2 100644
--- a/design/XFS_Filesystem_Structure/realtime.asciidoc
+++ b/design/XFS_Filesystem_Structure/realtime.asciidoc
@@ -14,8 +14,7 @@ By placing the real time device (and the journal) on separate high-performance
 storage devices, it is possible to reduce most of the unpredictability in I/O
 response times that come from metadata operations.
 
-None of the XFS per-AG B+trees are involved with real time files.  It is not
-possible for real time files to share data blocks.
+None of the XFS per-AG B+trees are involved with real time files.
 
 [[Real-Time_Bitmap_Inode]]
 == Free Space Bitmap Inode
@@ -233,3 +232,5 @@ meta_uuid = c52adb8a-48a6-4325-b251-d4dcb30889ea
 ----
 
 include::rtrmapbt.asciidoc[]
+
+include::rtrefcountbt.asciidoc[]
diff --git a/design/XFS_Filesystem_Structure/rtrefcountbt.asciidoc b/design/XFS_Filesystem_Structure/rtrefcountbt.asciidoc
new file mode 100644
index 00000000..617badbf
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/rtrefcountbt.asciidoc
@@ -0,0 +1,173 @@
+[[Real_time_Refcount_Btree]]
+=== Reference Count B+tree
+
+If the reflink and real-time storage device features are enabled, each
+real-time group has its own reference count B+tree.
+
+As mentioned in the chapter about xref:Reflink_Deduplication[sharing data
+blocks], this data structure is necessary to track how many times each extent
+in the realtime volume has been mapped.  This is how the copy-on-write code
+determines what to do when a realtime file is written.
+
+This B+tree is only present if the +XFS_SB_FEAT_RO_COMPAT_REFLINK+ feature is
+enabled and a real time device is present.  The feature requires a version 5
+filesystem.
+
+The rtgroup reference count B+tree is rooted in an inode's data fork; the inode
+number can be found by resolving the path +/realtime/$rgno.refcount+ in the
+metadata directory tree.  superblock.  The B+tree blocks themselves are stored
+in the regular filesystem.  The structures used for an inode's B+tree root are:
+
+[source, c]
+----
+struct xfs_rtrefcount_root {
+     __be16                     bb_level;
+     __be16                     bb_numrecs;
+};
+----
+
+* If the B+tree contains only a single level, the ondisk data fork area begins
+with a +xfs_rtrefcount_root+ header followed by an array of +xfs_refcount_rec+
+leaf records.
+
+* Otherwise, the ondisk data fork area begins with the +xfs_rtrefcount_root+
+header and is followed first by an array of +xfs_refcount_key+ values and then
+an array of +xfs_rtrefcount_ptr_t+ values.  The size of both arrays is
+specified by the header's +bb_numrecs+ value.
+
+* The root node in the inode can only contain up to 28 leaf records or
+key/pointer pairs for a standard 512 byte inode before a new level of nodes is
+added between the root and the leaves.  +di_forkoff+ should always be zero,
+because there are no extended attributes.
+
+Each record in an rtgroup reference count B+tree has the same structure as an
+AG reference count btree:
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
+rtgroup block number of this record.  Note that reference count records are
+tracked in units of realtime blocks, not realtime extents.
+However, records must be aligned to the realtime extent size in accordance with
+the existing realtime extent handling strategy.  The high bit
+(+XFS_REFC_COW_FLAG+) is set for all records referring to an extent that is
+being used to stage a copy on write operation.  This reduces recovery time
+during mount operations.  The reference count of these staging events must only
+be 1.
+
+*rc_blockcount*::
+The length of this extent, in filesystem blocks.
+
+*rc_refcount*::
+Number of times this extent has been shared.
+
+The key has the following structure:
+
+[source, c]
+----
+struct xfs_refcount_key {
+     __be32                     rc_startblock;
+};
+----
+
+* All block numbers are 32-bit rtgroup device block numbers, though the
+key should be aligned to the realtime extent size.
+
+* The +bb_magic+ value is ``RCNT'' (0x52434354).
+
+* The +struct xfs_btree_lblock+ header is used for intermediate B+tree node as
+well as the leaves.
+
+==== xfs_db rtrefcountbt Example
+
+This example shows a real-time reference count B+tree from a freshly
+populated filesystem.  One directory tree has been reflinked:
+
+----
+xfs_db> path -m /realtime/0.refcount
+xfs_db> p
+core.magic = 0x494e
+core.mode = 0100000
+core.version = 3
+core.format = 6 (refcount)
+...
+v3.inumber = 134
+v3.uuid = 23d157a4-8ca7-4fca-8782-637dc6746105
+v3.reflink = 0
+v3.cowextsz = 0
+v3.dax = 0
+v3.bigtime = 1
+v3.nrext64 = 1
+v3.metadata = 1
+u3.rtrefcbt.level = 1
+u3.rtrefcbt.numrecs = 2
+u3.rtrefcbt.keys[1-2] = [startblock,cowflag] 
+1:[4,0] 
+2:[344,0]
+u3.rtrefcbt.ptrs[1-2] = 1:8 2:9
+----
+
+Notice that this is a two-level refcount btree; we must continue towards the
+leaf level.
+
+----
+xfs_db> addr u3.rtrefcbt.ptrs[2]
+xfs_db> p
+magic = 0x52434e54
+level = 0
+numrecs = 170
+leftsib = 8
+rightsib = null
+bno = 72
+lsn = 0
+uuid = 23d157a4-8ca7-4fca-8782-637dc6746105
+owner = 134
+crc = 0x21e04c3 (correct)
+recs[1-170] = [startblock,blockcount,refcount,cowflag] 
+1:[344,1,2,0] 
+2:[346,1,2,0] 
+3:[348,1,2,0] 
+4:[350,1,2,0] 
+5:[352,1,2,0] 
+6:[354,1,2,0] 
+...
+----
+
+This indicates that realtime block 354 is shared.  Let's use the realtime
+reverse mapping information to find which files are sharing these blocks:
+
+----
+xfs_db> fsmap -r 354 354
+0: 0/1 len 682 owner 10015 offset 0 bmbt 0 attrfork 0 extflag 0
+1: 0/354 len 1 owner 10014 offset 353 bmbt 0 attrfork 0 extflag 0
+----
+
+It looks as though inodes 10,014 and 10,015 share this block.  Let us confirm
+this by navigating to those inodes and dumping the data fork mappings:
+
+----
+xfs_db> inode 10015
+xfs_db> p core.realtime
+core.realtime = 1
+xfs_db> bmap
+data offset 0 startblock 1 (0/1) count 682 flag 0
+xfs_db> inode 10014
+xfs_db> p core.realtime
+core.realtime = 1
+xfs_db> bmap 350 10
+data offset 351 startblock 352 (0/352) count 1 flag 0
+data offset 353 startblock 354 (0/354) count 1 flag 0
+data offset 355 startblock 356 (0/356) count 1 flag 0
+data offset 357 startblock 358 (0/358) count 1 flag 0
+data offset 359 startblock 360 (0/360) count 1 flag 0
+----
+
+Notice that both inodes have their realtime flags set, and both of them map
+a data fork extent to the same realtime block 354.

