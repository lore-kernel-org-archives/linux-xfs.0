Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2484021CC5A
	for <linux-xfs@vger.kernel.org>; Thu, 20 Mar 2025 16:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742488562; cv=none; b=aEFoLYAsB+x+zQlXVcJtSfVe1Oji6AeWZU7t2hlkA/Gyazb4d/6pioYdHItK3Grla/KBq2MjaxroQUuu1RxEOwVyb4fehQfcHcnE5RUnm2LELIPrOeIHN854kcTE7WlrzHGgJEbHqoGiC1or0OJrfG+tWQIzXF9OaWXayeHEf8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742488562; c=relaxed/simple;
	bh=1Es6zk2wUVBHCh2wBCpcM8dfvypHDhfnn952GEcvgMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F1KBpFdEa1RezOnIQyzRx1wVPwyZpKFPSpKgkvzJHIRx2006vqn1BDbEzrHF7H7KUt76mRCAS/hwxrrjNqLnRTislnFO8P87CYCUxsBOeyIaHiqwoLxEboZKoGWvR60JTXyx04P5DXkNAfnfDCe2nHu6lTQKVywt0b6zGu32WzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZeF/3+HT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZeF/3+HT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B72AC4CEEC;
	Thu, 20 Mar 2025 16:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742488561;
	bh=1Es6zk2wUVBHCh2wBCpcM8dfvypHDhfnn952GEcvgMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZeF/3+HTQPo4kmmoxQ4wCxhAqIC+i6mm860diN+Il5xuRoeEugFOvKByqLapUuSdK
	 Re05d0VvVdhl7buRFRNRO4MxUIQ6c3xKwGIBuvcQrbhduTnS1DoWas27QthWNhD4p7
	 KqLTAhqGIG/QM3FGv8RXq8URFOXCWqTFyRhbBvBWI9AR4Y2qNG1p8l2+PFEir1wKRr
	 TuVKxNHh6LfLC89CrKG3NMBSv7Gi5o1ETQhGOl5/wFoGug2iq8kNREUEKZrqg+CBHf
	 Cbu19rOYZUXxL0mwZW2dWr19owy1dbam1VxDnpGwP52jTNXjI1fX332DWKaRZ57im6
	 vRjSBhIq8gVdA==
Date: Thu, 20 Mar 2025 09:36:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] design: document changes for the realtime refcount btree
Message-ID: <20250320163600.GD2803749@frogsfrogsfrogs>
References: <20250320162836.GV89034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250320162836.GV89034@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Update the ondisk format documentation to reflect the realtime refcount
btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../internal_inodes.asciidoc                       |    5 -
 .../journaling_log.asciidoc                        |   10 +
 design/XFS_Filesystem_Structure/magic.asciidoc     |    3 
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    2 
 design/XFS_Filesystem_Structure/realtime.asciidoc  |    6 -
 .../XFS_Filesystem_Structure/rtrefcountbt.asciidoc |  172 ++++++++++++++++++++
 6 files changed, 191 insertions(+), 7 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/rtrefcountbt.asciidoc

diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index 9cfb2c29b1e6fe..551c799e4f9953 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -27,6 +27,7 @@ of those inodes have been deallocated and may be reused by future features.
 | xref:Real-Time_Bitmap_Inode[Realtime Bitmap]   | /rtgroups/*.bitmap
 | xref:Real-Time_Summary_Inode[Realtime Summary] | /rtgroups/*.summary
 | xref:Real_time_Reverse_Mapping_Btree[Realtime Reverse Mapping B+tree] | /rtgroups/*.rmap
+| xref:Real_time_Refcount_Btree[Realtime Reference Count+tree] | /rtgroups/*.refcount
 |=====
 
 Metadata files are flagged by the +XFS_DIFLAG2_METADATA+ flag in the
@@ -301,4 +302,6 @@ xref:Real-Time_Bitmap_Inode[Bitmap Inode] and the
 xref:Real-Time_Summary_Inode[Summary Inode].
 
 Each realtime group can allocate one inode to managing a
-xref:Real_time_Reverse_Mapping_Btree[reverse-index of space] usage.
+xref:Real_time_Reverse_Mapping_Btree[reverse-index of space] usage, and
+a second one to manage xref:Real_time_Refcount_Btree[reference counts] of space
+usage.
diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index fe8a127aa9abe0..8d5f50d26308c9 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -586,8 +586,9 @@ struct xfs_cui_log_format {
 ----
 
 *cui_type*::
-The signature of an CUI operation, 0x1242.  This value is in host-endian order,
-not big-endian like the rest of XFS.
+The signature of an CUI operation, 0x1242.  For a realtime CUI, this vlaue is
+0x124e.  This value is in host-endian order, not big-endian like the rest of
+XFS.
 
 *cui_size*::
 Size of this log item.  Should be 1.
@@ -621,8 +622,9 @@ struct xfs_cud_log_format {
 ----
 
 *cud_type*::
-The signature of an RUD operation, 0x1243.  This value is in host-endian order,
-not big-endian like the rest of XFS.
+The signature of an RUD operation, 0x1243.  For a realtime CUD, this value is
+0x124f.  This value is in host-endian order, not big-endian like the rest of
+XFS.
 
 *cud_size*::
 Size of this log item.  Should be 1.
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index 655f638304ec5d..f9e32df4f9f882 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -51,6 +51,7 @@ relevant chapters.  Magic numbers tend to have consistent locations:
 | +XFS_REFC_CRC_MAGIC+		| 0x52334643	| R3FC	| xref:Reference_Count_Btree[Reference Count B+tree], v5 only
 | +XFS_MD_MAGIC+		| 0x5846534d	| XFSM	| xref:Metadata_Dumps[Metadata Dumps]
 | +XFS_RTSB_MAGIC+		| 0x46726F67	| Frog	| xref:Realtime_Groups[Realtime Groups]
+| +XFS_RTREFC_CRC_MAGIC+	| 0x52434e54	| RCNT	| xref:Real_time_Refcount_Btree[Real-Time Reference Count B+tree], v5 only
 |=====
 
 The magic numbers for log items are at offset zero in each log item, but items
@@ -82,6 +83,8 @@ are not aligned to blocks.
 | +XFS_LI_EFD_RT+		| 0x124b        |       | xref:EFD_Log_Item[Extent Freeing Done Log Item]
 | +XFS_LI_RUI_RT+		| 0x124c        |       | xref:RUI_Log_Item[Reverse Mapping Update Intent]
 | +XFS_LI_RUD_RT+		| 0x124d        |       | xref:RUD_Log_Item[Reverse Mapping Update Done]
+| +XFS_LI_CUI_RT+		| 0x124e        |       | xref:CUI_Log_Item[Reference Count Update Intent]
+| +XFS_LI_CUD_RT+		| 0x124f        |       | xref:CUD_Log_Item[Reference Count Update Done]
 |=====
 
 = Theoretical Limits
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index bd192e3a929281..ab4a503b4da6df 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -183,6 +183,7 @@ typedef enum xfs_dinode_fmt {
      XFS_DINODE_FMT_BTREE,
      XFS_DINODE_FMT_UUID,
      XFS_DINODE_FMT_RMAP,
+     XFS_DINODE_FMT_REFCOUNT
 } xfs_dinode_fmt_t;
 ----
 
@@ -205,6 +206,7 @@ enum xfs_metafile_type {
      XFS_METAFILE_RTBITMAP,
      XFS_METAFILE_RTSUMMARY,
      XFS_METAFILE_RTRMAP,
+     XFS_METAFILE_RTREFCOUNT,
 };
 ----
 
diff --git a/design/XFS_Filesystem_Structure/realtime.asciidoc b/design/XFS_Filesystem_Structure/realtime.asciidoc
index ab47a12a50f46b..16641525e20128 100644
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
@@ -312,6 +311,7 @@ Each realtime group has the following characteristics:
          * Free space bitmap
          * Summary of free space
          * Reverse space mapping btree
+         * Reference count btree
 
 The free space metadata are the same as described in the previous sections,
 except that their scope covers only a single rtgroup.  The other structures are
@@ -395,3 +395,5 @@ meta_uuid = 7e55b909-8728-4d69-a1fa-891427314eea
 ----
 
 include::rtrmapbt.asciidoc[]
+
+include::rtrefcountbt.asciidoc[]
diff --git a/design/XFS_Filesystem_Structure/rtrefcountbt.asciidoc b/design/XFS_Filesystem_Structure/rtrefcountbt.asciidoc
new file mode 100644
index 00000000000000..98639928ca19ce
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/rtrefcountbt.asciidoc
@@ -0,0 +1,172 @@
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
+number can be found by resolving the path +/rtgroups/$rgno.refcount+ in the
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
+added between the root and the leaves.
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
+xfs_db> path -m /rtgroups/0.refcount
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
