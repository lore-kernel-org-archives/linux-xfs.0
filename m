Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97BC644
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 01:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elsCBCwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E0BC433C8;
	Mon,  1 Jan 2024 01:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071321;
	bh=qygAneixeXbjVazM2K+8R/TDi187TP87qezbpzAY6dw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=elsCBCwXssusrepk45MsnkMOUhYX3aTWDZdmRIxxW7DjkXbp1bYsyyocNxbvAk7sF
	 wXKzNLRZdd/0CmgDVyxDUaAV/zj5rXBK9jpgt1iCGH89SgFF/By+ye+3/pCBWaYUV2
	 giH6thBxRZaTNY7YEV/cvup305S7PX09+oFN9NSgxL8PXUDg9sha4lMmZvkIvNgzaw
	 iVWQLvjhohm4ZO4Z7U2gMn9id2RmLTIfBK/We3xJgMADxz6gsWJtBkvrazIx6mbkIJ
	 V2Q2eywKlTnjP0/dp/Irj2CgowbPzBoqvt8ld97Pl9OENtpETgeuRGPrPIKGj9d+d5
	 qCCmA0uKH5Wnw==
Date: Sun, 31 Dec 2023 17:08:41 +9900
Subject: [PATCH 2/2] design: document realtime groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: darrick.wong@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405037312.1829872.18288088417905820652.stgit@frogsfrogsfrogs>
In-Reply-To: <170405037287.1829872.4170922148688875113.stgit@frogsfrogsfrogs>
References: <170405037287.1829872.4170922148688875113.stgit@frogsfrogsfrogs>
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

Document the ondisk changes for realtime allocation groups.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../allocation_groups.asciidoc                     |   19 ++
 design/XFS_Filesystem_Structure/magic.asciidoc     |    1 
 design/XFS_Filesystem_Structure/realtime.asciidoc  |  182 ++++++++++++++++++++
 3 files changed, 202 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 08151c7c..ab8868d0 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -55,6 +55,13 @@ struct xfs_sb
 	xfs_fsblock_t		sb_logstart;
 	xfs_ino_t		sb_rootino;
 	xfs_ino_t		sb_rbmino;
+	union {
+		xfs_ino_t	sb_rsumino;
+		struct {
+			xfs_rgnumber_t	sb_rgcount;
+			xfs_rgblock_t	sb_rgblocks;
+		};
+	};
 	xfs_ino_t		sb_rsumino;
 	xfs_agblock_t		sb_rextsize;
 	xfs_agblock_t		sb_agblocks;
@@ -150,6 +157,14 @@ to the inode for the root of the metadata directory tree.
 Summary inode for real-time bitmap if the +XFS_SB_FEAT_INCOMPAT_METADIR+
 feature is not enabled.
 
+*sb_rgcount*::
+Count of realtime groups in the filesystem, if the
++XFS_SB_FEAT_INCOMPAT_RTGROUPS+ feature is enabled.
+
+*sb_rgblocks*::
+Maximum number of filesystem blocks that can be contained within a realtime
+group, if the +XFS_SB_FEAT_INCOMPAT_RTGROUPS+ feature is enabled.
+
 *sb_rextsize*::
 Realtime extent size in blocks.
 
@@ -473,6 +488,10 @@ metadata directory tree] for more information.
 Directory parent pointers.  See the section about xref:Parent_Pointers[parent
 pointers] for more information.
 
+| +XFS_SB_FEAT_INCOMPAT_RTGROUPS+ |
+Realtime allocation groups.  See the section about the xref:Realtime_Groups[
+realtime groups] for more information.
+
 |=====
 
 *sb_features_log_incompat*::
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index 613e50c0..c83f59a2 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -48,6 +48,7 @@ relevant chapters.  Magic numbers tend to have consistent locations:
 | +XFS_RTRMAP_CRC_MAGIC+	| 0x4d415052	| MAPR	| xref:Real_time_Reverse_Mapping_Btree[Real-Time Reverse Mapping B+tree], v5 only
 | +XFS_REFC_CRC_MAGIC+		| 0x52334643	| R3FC	| xref:Reference_Count_Btree[Reference Count B+tree], v5 only
 | +XFS_MD_MAGIC+		| 0x5846534d	| XFSM	| xref:Metadata_Dumps[Metadata Dumps]
+| +XFS_RTSB_MAGIC+		| 0x58524750	| XRGP	| xref:Realtime_Groups[Realtime Groups]
 |=====
 
 The magic numbers for log items are at offset zero in each log item, but items
diff --git a/design/XFS_Filesystem_Structure/realtime.asciidoc b/design/XFS_Filesystem_Structure/realtime.asciidoc
index 11426e8f..f5fdb4e5 100644
--- a/design/XFS_Filesystem_Structure/realtime.asciidoc
+++ b/design/XFS_Filesystem_Structure/realtime.asciidoc
@@ -47,4 +47,186 @@ This data structure is not particularly space efficient, however it is a very
 fast way to provide the same data as the two free space B+trees for regular
 files since the space is preallocated and metadata maintenance is minimal.
 
+[[Realtime_Groups]]
+== Realtime Groups
+
+To reduce metadata contention for space allocation and remapping activities
+being applied to realtime files, the realtime volume can be split into
+allocation groups, just like the data volume.  The free space information is
+still contained in a single file that applies to the entire volume.
+
+Each realtime allocation group can contain up to (2^31^ - 1) filesystem blocks,
+regardless of the underlying realtime extent size.
+
+Each realtime group has the following characteristics:
+
+         * A super block describing overall filesystem info
+         * Free space bitmap
+         * Summary of free space
+
+Each of these structures are expanded upon in the following sections.
+
+[[Realtime_Group_Superblocks]]
+=== Superblocks
+
+The first block of each realtime group contains a superblock.  These fields
+must match their counterparts in the filesystem superblock on the data device.
+
+[source, c]
+----
+struct xfs_rtsb {
+	__be32		rsb_magicnum;
+	__be32		rsb_blocksize;
+	__be64		rsb_rblocks;
+
+	__be64		rsb_rextents;
+	__be64		rsb_lsn;
+
+	__be32		rsb_rgcount;
+	char		rsb_fname[XFSLABEL_MAX];
+
+	uuid_t		rsb_uuid;
+
+	__be32		rsb_rextsize;
+	__be32		rsb_rbmblocks;
+
+	__be32		rsb_rgblocks;
+	__u8		rsb_blocklog;
+	__u8		rsb_sectlog;
+	__u8		rsb_rextslog;
+	__u8		rsb_pad;
+
+	__le32		rsb_crc;
+	__le32		rsb_pad2;
+
+	uuid_t		rsb_meta_uuid;
+
+	/* must be padded to 64 bit alignment */
+};
+----
+
+*rsb_magicnum*::
+Identifies the filesystem. Its value is +XFS_RTSB_MAGIC+ ``XRGP'' (0x58524750).
+
+*rsb_blocksize*::
+The size of a basic unit of space allocation in bytes. Typically, this is 4096
+(4KB) but can range from 512 to 65536 bytes.
+
+*rsb_rblocks*::
+Number blocks in the real-time disk device.
+
+*rsb_rextents*::
+Number of extents on the real-time device.
+
+*rsb_lsn*::
+Log sequence number of the last superblock update.
+
+*rsb_rgcount*::
+Count of realtime groups in the filesystem, if the
++XFS_SB_FEAT_INCOMPAT_RTGROUPS+ feature is enabled.
+
+*rsb_fname[12]*::
+Name for the filesystem. This value can be used in the mount command.
+
+*rsb_uuid*::
+UUID (Universally Unique ID) for the filesystem. Filesystems can be mounted by
+the UUID instead of device name.
+
+*rsb_rextsize*::
+Realtime extent size in blocks.
+
+*rsb_rbmblocks*::
+Number of real-time bitmap blocks.
+
+*rsb_rgblocks*::
+Maximum number of filesystem blocks that can be contained within a realtime
+group, if the +XFS_SB_FEAT_INCOMPAT_RTGROUPS+ feature is enabled.
+
+*rsb_blocklog*::
+log~2~ value of +sb_blocksize+. In other terms, +sb_blocksize = 2^sb_blocklog^+.
+
+*rsb_sectlog*::
+log~2~ value of +sb_sectsize+.
+
+*rsb_rextslog*::
+log~2~ value of +sb_rextents+.
+
+*rsb_pad*::
+Must be zero.
+
+*rsb_crc*::
+Superblock checksum.
+
+*rsb_pad2*::
+Must be zero.
+
+*rsb_meta_uuid*::
+If the +XFS_SB_FEAT_INCOMPAT_META_UUID+ feature is set, then the UUID field in
+all metadata blocks must match this UUID.  If not, the block header UUID field
+must match +sb_uuid+.
+
+==== xfs_db rtgroup Superblock Example
+
+A filesystem is made on a multidisk filesystem with the following command:
+
+----
+# mkfs.xfs -r rtgroups=1,rgcount=4,rtdev=/dev/sdb /dev/sda -f
+meta-data=/dev/sda               isize=512    agcount=4, agsize=1298176 blks
+         =                       sectsz=512   attr=2, projid32bit=1
+         =                       crc=1        finobt=1, sparse=1, rmapbt=1
+         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
+         =                       metadir=1
+data     =                       bsize=4096   blocks=5192704, imaxpct=25
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
+log      =internal log           bsize=4096   blocks=16384, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=1
+realtime =/dev/sdb               extsz=4096   blocks=5192704, rtextents=5192704
+         =                       rgcount=4    rgsize=1298176 blks
+----
+
+And in xfs_db, inspecting the realtime group superblock and then the regular
+superblock:
+
+----
+# xfs_db -R /dev/sdb /dev/sda
+xfs_db> rtsb 0
+xfs_db> print
+magicnum = 0x58524750
+blocksize = 4096
+rblocks = 5192704
+rextents = 5192704
+uuid = c52adb8a-48a6-4325-b251-d4dcb30889ea
+rextsize = 1
+rgblocks = 1048576
+rgcount = 5
+rbmblocks = 161
+fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
+blocklog = 12
+sectlog = 9
+rextslog = 22
+crc = 0x36872867 (correct)
+lsn = 0
+meta_uuid = c52adb8a-48a6-4325-b251-d4dcb30889ea
+xfs_db> sb 0
+xfs_db> print magicnum blocksize rblocks rextents uuid rextsize rgblocks \
+rgcount rbmblocks fname blocklog sectlog rextslog crc lsn meta_uuid
+magicnum = 0x58465342
+blocksize = 4096
+rblocks = 5192704
+rextents = 5192704
+uuid = c52adb8a-48a6-4325-b251-d4dcb30889ea
+rextsize = 1
+rgblocks = 1048576
+rgcount = 5
+rbmblocks = 161
+fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
+blocklog = 12
+sectlog = 9
+rextslog = 22
+crc = 0xfbd2b2d2 (correct)
+lsn = 0
+meta_uuid = c52adb8a-48a6-4325-b251-d4dcb30889ea
+----
+
 include::rtrmapbt.asciidoc[]

