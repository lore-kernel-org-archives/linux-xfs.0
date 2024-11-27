Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C1F8BE5
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732666729; cv=none; b=Mo1rO788AEaMdWE8KuCBBLFET1TQnZyU5UV+HgVMEy0xmbiHl8VI1y0e47yf/WtPhpOOFEGdaNN+0IvutG2HUxiDPW8YyVjRxmlgpMouwuhcJ00N9oiqzKq1wJZdbvgcAYx2AqByO+WfnzwWVAvcYTBsi9DayoTkBE+3YY3nBNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732666729; c=relaxed/simple;
	bh=fN35Jos31uX+mHjYz7ERCWMKd6Zv7/sZonufw4Q2CcU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xj9D/+cxyeJUeBMEZtlYWkdns+OkvbfqPA+n5InEwsjYrJ4+bZ32i8g3qGupmU5cluvW45rlSd2qFIPx+ggnbhEAFbVVoRTrvmtUi0EeXcvgyVgB2YD3O6AMurFWyQ3kmRfVoDvG+Z/bZNvE8n3A18Bp3UiebS+wgdUaZ3KOp9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0puSpiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0puSpiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD58C4CECF;
	Wed, 27 Nov 2024 00:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732666728;
	bh=fN35Jos31uX+mHjYz7ERCWMKd6Zv7/sZonufw4Q2CcU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e0puSpiN7dzqIh8XPhSBpOuRKbgXVUYo8cUApppUQn/5YVCaOEEoxRVp1nQF8s9mZ
	 LoDGJYxYIyX+53/sZOvXGw3uDvBJNwDJDx63x5BHvDmjYmPtZVYnw6NRrHLKuIrNh2
	 DkQkSSZ/wygyEAeQTfPQcP5dOSTJSfHevyK4p6kU1ck8DtzGw4ru62jPBY3mcVhkjo
	 awBEr4ExS3b29zxI7STrSsc2cHJoNncvdYAvNhHVVJG6xmCe0glHrwTDOVWSUUS0tn
	 BJynN35jy4ALUj5yDxEgmEFbTij8qvOo019kzsZhDGNrWxR08T9CkoswNhuRp/ovQ+
	 azjan7mcXn1CQ==
Date: Tue, 26 Nov 2024 16:18:48 -0800
Subject: [PATCH 03/10] design: move superblock documentation to a separate
 file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173266662256.996198.18138050815254201801.stgit@frogsfrogsfrogs>
In-Reply-To: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
References: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Move the ondisk superblock docs to a separate file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 .../allocation_groups.asciidoc                     |  550 --------------------
 .../XFS_Filesystem_Structure/superblock.asciidoc   |  548 ++++++++++++++++++++
 2 files changed, 549 insertions(+), 549 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/superblock.asciidoc


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index d7fd63ea20a646..e2cdaab5e03d3f 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -31,555 +31,7 @@ image::images/6.png[]
 
 Each of these structures are expanded upon in the following sections.
 
-[[Superblocks]]
-== Superblocks
-
-Each AG starts with a superblock. The first one, in AG 0, is the primary
-superblock which stores aggregate AG information. Secondary superblocks are
-only used by xfs_repair when the primary superblock has been corrupted.  A
-superblock is one sector in length.
-
-The superblock is defined by the following structure. The description of each
-field follows.
-
-[source, c]
-----
-struct xfs_sb
-{
-	__uint32_t		sb_magicnum;
-	__uint32_t		sb_blocksize;
-	xfs_rfsblock_t		sb_dblocks;
-	xfs_rfsblock_t		sb_rblocks;
-	xfs_rtblock_t		sb_rextents;
-	uuid_t			sb_uuid;
-	xfs_fsblock_t		sb_logstart;
-	xfs_ino_t		sb_rootino;
-	xfs_ino_t		sb_rbmino;
-	xfs_ino_t		sb_rsumino;
-	xfs_agblock_t		sb_rextsize;
-	xfs_agblock_t		sb_agblocks;
-	xfs_agnumber_t		sb_agcount;
-	xfs_extlen_t		sb_rbmblocks;
-	xfs_extlen_t		sb_logblocks;
-	__uint16_t		sb_versionnum;
-	__uint16_t		sb_sectsize;
-	__uint16_t		sb_inodesize;
-	__uint16_t		sb_inopblock;
-	char			sb_fname[12];
-	__uint8_t		sb_blocklog;
-	__uint8_t		sb_sectlog;
-	__uint8_t		sb_inodelog;
-	__uint8_t		sb_inopblog;
-	__uint8_t		sb_agblklog;
-	__uint8_t		sb_rextslog;
-	__uint8_t		sb_inprogress;
-	__uint8_t		sb_imax_pct;
-	__uint64_t		sb_icount;
-	__uint64_t		sb_ifree;
-	__uint64_t		sb_fdblocks;
-	__uint64_t		sb_frextents;
-	xfs_ino_t		sb_uquotino;
-	xfs_ino_t		sb_gquotino;
-	__uint16_t		sb_qflags;
-	__uint8_t		sb_flags;
-	__uint8_t		sb_shared_vn;
-	xfs_extlen_t		sb_inoalignmt;
-	__uint32_t		sb_unit;
-	__uint32_t		sb_width;
-	__uint8_t		sb_dirblklog;
-	__uint8_t		sb_logsectlog;
-	__uint16_t		sb_logsectsize;
-	__uint32_t		sb_logsunit;
-	__uint32_t		sb_features2;
-	__uint32_t		sb_bad_features2;
-
-	/* version 5 superblock fields start here */
-	__uint32_t		sb_features_compat;
-	__uint32_t		sb_features_ro_compat;
-	__uint32_t		sb_features_incompat;
-	__uint32_t		sb_features_log_incompat;
-
-	__uint32_t		sb_crc;
-	xfs_extlen_t		sb_spino_align;
-
-	xfs_ino_t		sb_pquotino;
-	xfs_lsn_t		sb_lsn;
-	uuid_t			sb_meta_uuid;
-	xfs_ino_t		sb_rrmapino;
-};
-----
-*sb_magicnum*::
-Identifies the filesystem. Its value is +XFS_SB_MAGIC+ ``XFSB'' (0x58465342).
-
-*sb_blocksize*::
-The size of a basic unit of space allocation in bytes. Typically, this is 4096
-(4KB) but can range from 512 to 65536 bytes.
-
-*sb_dblocks*::
-Total number of blocks available for data and metadata on the filesystem.
-
-*sb_rblocks*::
-Number blocks in the real-time disk device. Refer to
-xref:Real-time_Devices[real-time sub-volumes] for more information.
-
-*sb_rextents*::
-Number of extents on the real-time device.
-
-*sb_uuid*::
-UUID (Universally Unique ID) for the filesystem. Filesystems can be mounted by
-the UUID instead of device name.
-
-*sb_logstart*::
-First block number for the journaling log if the log is internal (ie. not on a
-separate disk device). For an external log device, this will be zero (the log
-will also start on the first block on the log device).  The identity of the log
-devices is not recorded in the filesystem, but the UUIDs of the filesystem and
-the log device are compared to prevent corruption.
-
-*sb_rootino*::
-Root inode number for the filesystem.  Normally, the root inode is at the
-start of the first possible inode chunk in AG 0.  This is 128 when using a 4KB
-block size.
-
-*sb_rbmino*::
-Bitmap inode for real-time extents.
-
-*sb_rsumino*::
-Summary inode for real-time bitmap.
-
-*sb_rextsize*::
-Realtime extent size in blocks.
-
-*sb_agblocks*::
-Size of each AG in blocks. For the actual size of the last AG, refer to the
-xref:AG_Free_Space_Management[free space] +agf_length+ value.
-
-*sb_agcount*::
-Number of AGs in the filesystem.
-
-*sb_rbmblocks*::
-Number of real-time bitmap blocks.
-
-*sb_logblocks*::
-Number of blocks for the journaling log.
-
-*sb_versionnum*::
-Filesystem version number. This is a bitmask specifying the features enabled
-when creating the filesystem. Any disk checking tools or drivers that do not
-recognize any set bits must not operate upon the filesystem. Most of the flags
-indicate features introduced over time. If the value of the lower nibble is >=
-4, the higher bits indicate feature flags as follows:
-
-.Version 4 Superblock version flags
-[options="header"]
-|=====
-| Flag				| Description
-| +XFS_SB_VERSION_ATTRBIT+	|
-Set if any inode have extended attributes.  If this bit is set; the
-+XFS_SB_VERSION2_ATTR2BIT+ is not set; and the +attr2+ mount flag is not
-specified, the +di_forkoff+ inode field will not be dynamically adjusted.
-See the section about xref:Extended_Attribute_Versions[extended attribute
-versions] for more information.
-
-| +XFS_SB_VERSION_NLINKBIT+	| Set if any inodes use 32-bit di_nlink values.
-| +XFS_SB_VERSION_QUOTABIT+	|
-Quotas are enabled on the filesystem. This
-also brings in the various quota fields in the superblock.
-
-| +XFS_SB_VERSION_ALIGNBIT+	| Set if sb_inoalignmt is used.
-| +XFS_SB_VERSION_DALIGNBIT+	| Set if sb_unit and sb_width are used.
-| +XFS_SB_VERSION_SHAREDBIT+	| Set if sb_shared_vn is used.
-| +XFS_SB_VERSION_LOGV2BIT+	| Version 2 journaling logs are used.
-| +XFS_SB_VERSION_SECTORBIT+	| Set if sb_sectsize is not 512.
-| +XFS_SB_VERSION_EXTFLGBIT+	| Unwritten extents are used. This is always set.
-| +XFS_SB_VERSION_DIRV2BIT+	|
-Version 2 directories are used. This is always set.
-
-| +XFS_SB_VERSION_MOREBITSBIT+	|
-Set if the sb_features2 field in the superblock contains more flags.
-|=====
-
-If the lower nibble of this value is 5, then this is a v5 filesystem; the
-+XFS_SB_VERSION2_CRCBIT+ feature must be set in +sb_features2+.
-
-*sb_sectsize*::
-Specifies the underlying disk sector size in bytes.  Typically this is 512 or
-4096 bytes. This determines the minimum I/O alignment, especially for direct I/O.
-
-*sb_inodesize*::
-Size of the inode in bytes. The default is 256 (2 inodes per standard sector)
-but can be made as large as 2048 bytes when creating the filesystem.  On a v5
-filesystem, the default and minimum inode size are both 512 bytes.
-
-*sb_inopblock*::
-Number of inodes per block. This is equivalent to +sb_blocksize / sb_inodesize+.
-
-*sb_fname[12]*::
-Name for the filesystem. This value can be used in the mount command.
-
-*sb_blocklog*::
-log~2~ value of +sb_blocksize+. In other terms, +sb_blocksize = 2^sb_blocklog^+.
-
-*sb_sectlog*::
-log~2~ value of +sb_sectsize+.
-
-*sb_inodelog*::
-log~2~ value of +sb_inodesize+.
-
-*sb_inopblog*::
-log~2~ value of +sb_inopblock+.
-
-*sb_agblklog*::
-log~2~ value of +sb_agblocks+ (rounded up). This value is used to generate inode
-numbers and absolute block numbers defined in extent maps.
-
-*sb_rextslog*::
-log~2~ value of +sb_rextents+.
-
-*sb_inprogress*::
-Flag specifying that the filesystem is being created.
-
-*sb_imax_pct*::
-Maximum percentage of filesystem space that can be used for inodes. The default
-value is 5%.
-
-*sb_icount*::
-Global count for number inodes allocated on the filesystem. This is only
-maintained in the first superblock.
-
-*sb_ifree*::
-Global count of free inodes on the filesystem. This is only maintained in the
-first superblock.
-
-*sb_fdblocks*::
-Global count of free data blocks on the filesystem. This is only maintained in
-the first superblock.
-
-*sb_frextents*::
-Global count of free real-time extents on the filesystem. This is only
-maintained in the first superblock.
-
-*sb_uquotino*::
-Inode for user quotas. This and the following two quota fields only apply if
-+XFS_SB_VERSION_QUOTABIT+ flag is set in +sb_versionnum+. Refer to
-xref:Quota_Inodes[quota inodes] for more information.
-
-*sb_gquotino*::
-Inode for group or project quotas. Group and project quotas cannot be used at
-the same time on v4 filesystems.  On a v5 filesystem, this inode always stores
-group quota information.
-
-*sb_qflags*::
-Quota flags. It can be a combination of the following flags:
-
-.Superblock quota flags
-[options="header"]
-|=====
-| Flag				| Description
-| +XFS_UQUOTA_ACCT+		| User quota accounting is enabled.
-| +XFS_UQUOTA_ENFD+		| User quotas are enforced.
-| +XFS_UQUOTA_CHKD+		| User quotas have been checked.
-| +XFS_PQUOTA_ACCT+		| Project quota accounting is enabled.
-| +XFS_OQUOTA_ENFD+		| Other (group/project) quotas are enforced.
-| +XFS_OQUOTA_CHKD+		| Other (group/project) quotas have been checked.
-| +XFS_GQUOTA_ACCT+		| Group quota accounting is enabled.
-| +XFS_GQUOTA_ENFD+		| Group quotas are enforced.
-| +XFS_GQUOTA_CHKD+		| Group quotas have been checked.
-| +XFS_PQUOTA_ENFD+		| Project quotas are enforced.
-| +XFS_PQUOTA_CHKD+		| Project quotas have been checked.
-|=====
-
-*sb_flags*::
-Miscellaneous flags.
-
-.Superblock flags
-[options="header"]
-|=====
-| Flag                          | Description
-| +XFS_SBF_READONLY+            | Only read-only mounts allowed.
-|=====
-
-*sb_shared_vn*::
-Reserved and must be zero (``vn'' stands for version number).
-
-*sb_inoalignmt*::
-Inode chunk alignment in fsblocks.  Prior to v5, the default value provided for
-inode chunks to have an 8KiB alignment.  Starting with v5, the default value
-scales with the multiple of the inode size over 256 bytes.  Concretely, this
-means an alignment of 16KiB for 512-byte inodes, 32KiB for 1024-byte inodes,
-etc.  If sparse inodes are enabled, the +ir_startino+ field of each inode
-B+tree record must be aligned to this block granularity, even if the inode
-given by +ir_startino+ itself is sparse.
-
-*sb_unit*::
-Underlying stripe or raid unit in blocks.
-
-*sb_width*::
-Underlying stripe or raid width in blocks.
-
-*sb_dirblklog*::
-log~2~ multiplier that determines the granularity of directory block allocations
-in fsblocks.
-
-*sb_logsectlog*::
-log~2~ value of the log subvolume's sector size. This is only used if the
-journaling log is on a separate disk device (i.e. not internal).
-
-*sb_logsectsize*::
-The log's sector size in bytes if the filesystem uses an external log device.
-
-*sb_logsunit*::
-The log device's stripe or raid unit size. This only applies to version 2 logs
-+XFS_SB_VERSION_LOGV2BIT+ is set in +sb_versionnum+.
-
-*sb_features2*::
-Additional version flags if +XFS_SB_VERSION_MOREBITSBIT+ is set in
-+sb_versionnum+. The currently defined additional features include:
-
-.Extended Version 4 Superblock flags
-[options="header"]
-|=====
-| Flag				| Description
-| +XFS_SB_VERSION2_LAZYSBCOUNTBIT+ |
-Lazy global counters. Making a filesystem with this bit set can improve
-performance. The global free space and inode counts are only updated in the
-primary superblock when the filesystem is cleanly unmounted.
-
-| +XFS_SB_VERSION2_ATTR2BIT+	|
-Extended attributes version 2. Making a filesystem with this optimises the
-inode layout of extended attributes.  If this bit is set and the +noattr2+
-mount flag is not specified, the +di_forkoff+ inode field will be dynamically
-adjusted.  See the section about xref:Extended_Attribute_Versions[extended
-attribute versions] for more information.
-
-| +XFS_SB_VERSION2_PARENTBIT+	|
-Parent pointers. All inodes must have an extended attribute that points back to
-its parent inode. The primary purpose for this information is in backup systems.
-
-| +XFS_SB_VERSION2_PROJID32BIT+	|
-32-bit Project ID.  Inodes can be associated with a project ID number, which
-can be used to enforce disk space usage quotas for a particular group of
-directories.  This flag indicates that project IDs can be 32 bits in size.
-
-| +XFS_SB_VERSION2_CRCBIT+	|
-Metadata checksumming.  All metadata blocks have an extended header containing
-the block checksum, a copy of the metadata UUID, the log sequence number of the
-last update to prevent stale replays, and a back pointer to the owner of the
-block.  This feature must be and can only be set if the lowest nibble of
-+sb_versionnum+ is set to 5.
-
-| +XFS_SB_VERSION2_FTYPE+	|
-Directory file type.  Each directory entry records the type of the inode to
-which the entry points.  This speeds up directory iteration by removing the
-need to load every inode into memory.
-|=====
-
-*sb_bad_features2*::
-This field mirrors +sb_features2+, due to past 64-bit alignment errors.
-
-*sb_features_compat*::
-Read-write compatible feature flags.  The kernel can still read and write this
-FS even if it doesn't understand the flag.  Currently, there are no valid
-flags.
-
-*sb_features_ro_compat*::
-Read-only compatible feature flags.  The kernel can still read this FS even if
-it doesn't understand the flag.
-
-.Extended Version 5 Superblock Read-Only compatibility flags
-[options="header"]
-|=====
-| Flag				| Description
-| +XFS_SB_FEAT_RO_COMPAT_FINOBT+ |
-Free inode B+tree.  Each allocation group contains a B+tree to track inode chunks
-containing free inodes.  This is a performance optimization to reduce the time
-required to allocate inodes.
-
-| +XFS_SB_FEAT_RO_COMPAT_RMAPBT+ |
-Reverse mapping B+tree.  Each allocation group contains a B+tree containing
-records mapping AG blocks to their owners.  See the section about
-xref:Reconstruction[reconstruction] for more details.
-
-| +XFS_SB_FEAT_RO_COMPAT_REFLINK+ |
-Reference count B+tree.  Each allocation group contains a B+tree to track the
-reference counts of AG blocks.  This enables files to share data blocks safely.
-See the section about xref:Reflink_Deduplication[reflink and deduplication] for
-more details.
-
-| +XFS_SB_FEAT_RO_COMPAT_INOBTCNT+ |
-Inode B+tree block counters.  Each allocation group's inode (AGI) header
-tracks the number of blocks in each of the inode B+trees.  This allows us
-to have a slightly higher level of redundancy over the shape of the inode
-btrees, and decreases the amount of time to compute the metadata B+tree
-preallocations at mount time.
-
-|=====
-
-*sb_features_incompat*::
-Read-write incompatible feature flags.  The kernel cannot read or write this
-FS if it doesn't understand the flag.
-
-.Extended Version 5 Superblock Read-Write incompatibility flags
-[options="header"]
-|=====
-| Flag				| Description
-| +XFS_SB_FEAT_INCOMPAT_FTYPE+ |
-Directory file type.  Each directory entry tracks the type of the inode to
-which the entry points.  This is a performance optimization to remove the need
-to load every inode into memory to iterate a directory.
-
-| +XFS_SB_FEAT_INCOMPAT_SPINODES+ |
-Sparse inodes.  This feature relaxes the requirement to allocate inodes in
-chunks of 64.  When the free space is heavily fragmented, there might exist
-plenty of free space but not enough contiguous free space to allocate a new
-inode chunk.  With this feature, the user can continue to create files until
-all free space is exhausted.
-
-Unused space in the inode B+tree records are used to track which parts of the
-inode chunk are not inodes.
-
-See the chapter on xref:Sparse_Inodes[Sparse Inodes] for more information.
-
-| +XFS_SB_FEAT_INCOMPAT_META_UUID+ |
-Metadata UUID.  The UUID stamped into each metadata block must match the value
-in +sb_meta_uuid+.  This enables the administrator to change +sb_uuid+ at will
-without having to rewrite the entire filesystem.
-
-| +XFS_SB_FEAT_INCOMPAT_BIGTIME+ |
-Large timestamps.  Inode timestamps and quota expiration timers are extended to
-support times through the year 2486.  See the section on
-xref:Timestamps[timestamps] for more information.
-
-| +XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR+ |
-The filesystem is not in operable condition, and must be run through
-xfs_repair before it can be mounted.
-
-| +XFS_SB_FEAT_INCOMPAT_NREXT64+ |
-Large file fork extent counts.  This greatly expands the maximum number of
-space mappings allowed in data and extended attribute file forks.
-
-| +XFS_SB_FEAT_INCOMPAT_EXCHRANGE+ |
-Atomic file mapping exchanges.  The filesystem is capable of exchanging a range
-of mappings between two arbitrary ranges of a file's fork by using log intent
-items to track the progress of the high level exchange operation.  In other
-words, the exchange operation can be restarted if the system goes down, which
-is necessary for userspace to commit of new file contents atomically.  This
-flag has user-visible impacts, which is why it is a permanent incompat flag.
-See the section about xref:XMI_Log_Item[mapping exchange log intents] for more
-information.
-
-| +XFS_SB_FEAT_INCOMPAT_PARENT+ |
-Directory parent pointers.  See the section about xref:Parent_Pointers[parent
-pointers] for more information.
-
-|=====
-
-*sb_features_log_incompat*::
-Read-write incompatible feature flags for the log.  The kernel cannot recover
-the FS log if it doesn't understand the flag.
-
-.Extended Version 5 Superblock Log incompatibility flags
-[options="header"]
-|=====
-| Flag					| Description
-| +XFS_SB_FEAT_INCOMPAT_LOG_XATTRS+	|
-Extended attribute updates have been committed to the ondisk log.
-
-|=====
-
-*sb_crc*::
-Superblock checksum.
-
-*sb_spino_align*::
-Sparse inode alignment, in fsblocks.  Each chunk of inodes referenced by a
-sparse inode B+tree record must be aligned to this block granularity.
-
-*sb_pquotino*::
-Project quota inode.
-
-*sb_lsn*::
-Log sequence number of the last superblock update.
-
-*sb_meta_uuid*::
-If the +XFS_SB_FEAT_INCOMPAT_META_UUID+ feature is set, then the UUID field in
-all metadata blocks must match this UUID.  If not, the block header UUID field
-must match +sb_uuid+.
-
-*sb_rrmapino*::
-If the +XFS_SB_FEAT_RO_COMPAT_RMAPBT+ feature is set and a real-time
-device is present (+sb_rblocks+ > 0), this field points to an inode
-that contains the root to the
-xref:Real_time_Reverse_Mapping_Btree[Real-Time Reverse Mapping B+tree].
-This field is zero otherwise.
-
-=== xfs_db Superblock Example
-
-A filesystem is made on a single disk with the following command:
-
-----
-# mkfs.xfs -i attr=2 -n size=16384 -f /dev/sda7
-meta-data=/dev/sda7              isize=256    agcount=16, agsize=3923122 blks
-         =                       sectsz=512   attr=2
-data     =                       bsize=4096   blocks=62769952, imaxpct=25
-         =                       sunit=0      swidth=0 blks, unwritten=1
-naming   =version 2              bsize=16384
-log      =internal log           bsize=4096   blocks=30649, version=1
-         =                       sectsz=512   sunit=0 blks
-realtime =none                   extsz=65536  blocks=0, rtextents=0
-----
-
-And in xfs_db, inspecting the superblock:
-
-----
-xfs_db> sb
-xfs_db> p
-magicnum = 0x58465342
-blocksize = 4096
-dblocks = 62769952
-rblocks = 0
-rextents = 0
-uuid = 32b24036-6931-45b4-b68c-cd5e7d9a1ca5
-logstart = 33554436
-rootino = 128
-rbmino = 129
-rsumino = 130
-rextsize = 16
-agblocks = 3923122
-agcount = 16
-rbmblocks = 0
-logblocks = 30649
-versionnum = 0xb084
-sectsize = 512
-inodesize = 256
-inopblock = 16
-fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
-blocklog = 12
-sectlog = 9
-inodelog = 8
-inopblog = 4
-agblklog = 22
-rextslog = 0
-inprogress = 0
-imax_pct = 25
-icount = 64
-ifree = 61
-fdblocks = 62739235
-frextents = 0
-uquotino = 0
-gquotino = 0
-qflags = 0
-flags = 0
-shared_vn = 0
-inoalignmt = 2
-unit = 0
-width = 0
-dirblklog = 2
-logsectlog = 0
-logsectsize = 0
-logsunit = 0
-features2 = 8
-----
-
+include::superblock.asciidoc[]
 
 [[AG_Free_Space_Management]]
 == AG Free Space Management
diff --git a/design/XFS_Filesystem_Structure/superblock.asciidoc b/design/XFS_Filesystem_Structure/superblock.asciidoc
new file mode 100644
index 00000000000000..16c31116ffafd4
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/superblock.asciidoc
@@ -0,0 +1,548 @@
+[[Superblocks]]
+== Superblocks
+
+Each AG starts with a superblock. The first one, in AG 0, is the primary
+superblock which stores aggregate AG information. Secondary superblocks are
+only used by xfs_repair when the primary superblock has been corrupted.  A
+superblock is one sector in length.
+
+The superblock is defined by the following structure. The description of each
+field follows.
+
+[source, c]
+----
+struct xfs_sb
+{
+	__uint32_t		sb_magicnum;
+	__uint32_t		sb_blocksize;
+	xfs_rfsblock_t		sb_dblocks;
+	xfs_rfsblock_t		sb_rblocks;
+	xfs_rtblock_t		sb_rextents;
+	uuid_t			sb_uuid;
+	xfs_fsblock_t		sb_logstart;
+	xfs_ino_t		sb_rootino;
+	xfs_ino_t		sb_rbmino;
+	xfs_ino_t		sb_rsumino;
+	xfs_agblock_t		sb_rextsize;
+	xfs_agblock_t		sb_agblocks;
+	xfs_agnumber_t		sb_agcount;
+	xfs_extlen_t		sb_rbmblocks;
+	xfs_extlen_t		sb_logblocks;
+	__uint16_t		sb_versionnum;
+	__uint16_t		sb_sectsize;
+	__uint16_t		sb_inodesize;
+	__uint16_t		sb_inopblock;
+	char			sb_fname[12];
+	__uint8_t		sb_blocklog;
+	__uint8_t		sb_sectlog;
+	__uint8_t		sb_inodelog;
+	__uint8_t		sb_inopblog;
+	__uint8_t		sb_agblklog;
+	__uint8_t		sb_rextslog;
+	__uint8_t		sb_inprogress;
+	__uint8_t		sb_imax_pct;
+	__uint64_t		sb_icount;
+	__uint64_t		sb_ifree;
+	__uint64_t		sb_fdblocks;
+	__uint64_t		sb_frextents;
+	xfs_ino_t		sb_uquotino;
+	xfs_ino_t		sb_gquotino;
+	__uint16_t		sb_qflags;
+	__uint8_t		sb_flags;
+	__uint8_t		sb_shared_vn;
+	xfs_extlen_t		sb_inoalignmt;
+	__uint32_t		sb_unit;
+	__uint32_t		sb_width;
+	__uint8_t		sb_dirblklog;
+	__uint8_t		sb_logsectlog;
+	__uint16_t		sb_logsectsize;
+	__uint32_t		sb_logsunit;
+	__uint32_t		sb_features2;
+	__uint32_t		sb_bad_features2;
+
+	/* version 5 superblock fields start here */
+	__uint32_t		sb_features_compat;
+	__uint32_t		sb_features_ro_compat;
+	__uint32_t		sb_features_incompat;
+	__uint32_t		sb_features_log_incompat;
+
+	__uint32_t		sb_crc;
+	xfs_extlen_t		sb_spino_align;
+
+	xfs_ino_t		sb_pquotino;
+	xfs_lsn_t		sb_lsn;
+	uuid_t			sb_meta_uuid;
+	xfs_ino_t		sb_rrmapino;
+};
+----
+*sb_magicnum*::
+Identifies the filesystem. Its value is +XFS_SB_MAGIC+ ``XFSB'' (0x58465342).
+
+*sb_blocksize*::
+The size of a basic unit of space allocation in bytes. Typically, this is 4096
+(4KB) but can range from 512 to 65536 bytes.
+
+*sb_dblocks*::
+Total number of blocks available for data and metadata on the filesystem.
+
+*sb_rblocks*::
+Number blocks in the real-time disk device. Refer to
+xref:Real-time_Devices[real-time sub-volumes] for more information.
+
+*sb_rextents*::
+Number of extents on the real-time device.
+
+*sb_uuid*::
+UUID (Universally Unique ID) for the filesystem. Filesystems can be mounted by
+the UUID instead of device name.
+
+*sb_logstart*::
+First block number for the journaling log if the log is internal (ie. not on a
+separate disk device). For an external log device, this will be zero (the log
+will also start on the first block on the log device).  The identity of the log
+devices is not recorded in the filesystem, but the UUIDs of the filesystem and
+the log device are compared to prevent corruption.
+
+*sb_rootino*::
+Root inode number for the filesystem.  Normally, the root inode is at the
+start of the first possible inode chunk in AG 0.  This is 128 when using a 4KB
+block size.
+
+*sb_rbmino*::
+Bitmap inode for real-time extents.
+
+*sb_rsumino*::
+Summary inode for real-time bitmap.
+
+*sb_rextsize*::
+Realtime extent size in blocks.
+
+*sb_agblocks*::
+Size of each AG in blocks. For the actual size of the last AG, refer to the
+xref:AG_Free_Space_Management[free space] +agf_length+ value.
+
+*sb_agcount*::
+Number of AGs in the filesystem.
+
+*sb_rbmblocks*::
+Number of real-time bitmap blocks.
+
+*sb_logblocks*::
+Number of blocks for the journaling log.
+
+*sb_versionnum*::
+Filesystem version number. This is a bitmask specifying the features enabled
+when creating the filesystem. Any disk checking tools or drivers that do not
+recognize any set bits must not operate upon the filesystem. Most of the flags
+indicate features introduced over time. If the value of the lower nibble is >=
+4, the higher bits indicate feature flags as follows:
+
+.Version 4 Superblock version flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_SB_VERSION_ATTRBIT+	|
+Set if any inode have extended attributes.  If this bit is set; the
++XFS_SB_VERSION2_ATTR2BIT+ is not set; and the +attr2+ mount flag is not
+specified, the +di_forkoff+ inode field will not be dynamically adjusted.
+See the section about xref:Extended_Attribute_Versions[extended attribute
+versions] for more information.
+
+| +XFS_SB_VERSION_NLINKBIT+	| Set if any inodes use 32-bit di_nlink values.
+| +XFS_SB_VERSION_QUOTABIT+	|
+Quotas are enabled on the filesystem. This
+also brings in the various quota fields in the superblock.
+
+| +XFS_SB_VERSION_ALIGNBIT+	| Set if sb_inoalignmt is used.
+| +XFS_SB_VERSION_DALIGNBIT+	| Set if sb_unit and sb_width are used.
+| +XFS_SB_VERSION_SHAREDBIT+	| Set if sb_shared_vn is used.
+| +XFS_SB_VERSION_LOGV2BIT+	| Version 2 journaling logs are used.
+| +XFS_SB_VERSION_SECTORBIT+	| Set if sb_sectsize is not 512.
+| +XFS_SB_VERSION_EXTFLGBIT+	| Unwritten extents are used. This is always set.
+| +XFS_SB_VERSION_DIRV2BIT+	|
+Version 2 directories are used. This is always set.
+
+| +XFS_SB_VERSION_MOREBITSBIT+	|
+Set if the sb_features2 field in the superblock contains more flags.
+|=====
+
+If the lower nibble of this value is 5, then this is a v5 filesystem; the
++XFS_SB_VERSION2_CRCBIT+ feature must be set in +sb_features2+.
+
+*sb_sectsize*::
+Specifies the underlying disk sector size in bytes.  Typically this is 512 or
+4096 bytes. This determines the minimum I/O alignment, especially for direct I/O.
+
+*sb_inodesize*::
+Size of the inode in bytes. The default is 256 (2 inodes per standard sector)
+but can be made as large as 2048 bytes when creating the filesystem.  On a v5
+filesystem, the default and minimum inode size are both 512 bytes.
+
+*sb_inopblock*::
+Number of inodes per block. This is equivalent to +sb_blocksize / sb_inodesize+.
+
+*sb_fname[12]*::
+Name for the filesystem. This value can be used in the mount command.
+
+*sb_blocklog*::
+log~2~ value of +sb_blocksize+. In other terms, +sb_blocksize = 2^sb_blocklog^+.
+
+*sb_sectlog*::
+log~2~ value of +sb_sectsize+.
+
+*sb_inodelog*::
+log~2~ value of +sb_inodesize+.
+
+*sb_inopblog*::
+log~2~ value of +sb_inopblock+.
+
+*sb_agblklog*::
+log~2~ value of +sb_agblocks+ (rounded up). This value is used to generate inode
+numbers and absolute block numbers defined in extent maps.
+
+*sb_rextslog*::
+log~2~ value of +sb_rextents+.
+
+*sb_inprogress*::
+Flag specifying that the filesystem is being created.
+
+*sb_imax_pct*::
+Maximum percentage of filesystem space that can be used for inodes. The default
+value is 5%.
+
+*sb_icount*::
+Global count for number inodes allocated on the filesystem. This is only
+maintained in the first superblock.
+
+*sb_ifree*::
+Global count of free inodes on the filesystem. This is only maintained in the
+first superblock.
+
+*sb_fdblocks*::
+Global count of free data blocks on the filesystem. This is only maintained in
+the first superblock.
+
+*sb_frextents*::
+Global count of free real-time extents on the filesystem. This is only
+maintained in the first superblock.
+
+*sb_uquotino*::
+Inode for user quotas. This and the following two quota fields only apply if
++XFS_SB_VERSION_QUOTABIT+ flag is set in +sb_versionnum+. Refer to
+xref:Quota_Inodes[quota inodes] for more information.
+
+*sb_gquotino*::
+Inode for group or project quotas. Group and project quotas cannot be used at
+the same time on v4 filesystems.  On a v5 filesystem, this inode always stores
+group quota information.
+
+*sb_qflags*::
+Quota flags. It can be a combination of the following flags:
+
+.Superblock quota flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_UQUOTA_ACCT+		| User quota accounting is enabled.
+| +XFS_UQUOTA_ENFD+		| User quotas are enforced.
+| +XFS_UQUOTA_CHKD+		| User quotas have been checked.
+| +XFS_PQUOTA_ACCT+		| Project quota accounting is enabled.
+| +XFS_OQUOTA_ENFD+		| Other (group/project) quotas are enforced.
+| +XFS_OQUOTA_CHKD+		| Other (group/project) quotas have been checked.
+| +XFS_GQUOTA_ACCT+		| Group quota accounting is enabled.
+| +XFS_GQUOTA_ENFD+		| Group quotas are enforced.
+| +XFS_GQUOTA_CHKD+		| Group quotas have been checked.
+| +XFS_PQUOTA_ENFD+		| Project quotas are enforced.
+| +XFS_PQUOTA_CHKD+		| Project quotas have been checked.
+|=====
+
+*sb_flags*::
+Miscellaneous flags.
+
+.Superblock flags
+[options="header"]
+|=====
+| Flag                          | Description
+| +XFS_SBF_READONLY+            | Only read-only mounts allowed.
+|=====
+
+*sb_shared_vn*::
+Reserved and must be zero (``vn'' stands for version number).
+
+*sb_inoalignmt*::
+Inode chunk alignment in fsblocks.  Prior to v5, the default value provided for
+inode chunks to have an 8KiB alignment.  Starting with v5, the default value
+scales with the multiple of the inode size over 256 bytes.  Concretely, this
+means an alignment of 16KiB for 512-byte inodes, 32KiB for 1024-byte inodes,
+etc.  If sparse inodes are enabled, the +ir_startino+ field of each inode
+B+tree record must be aligned to this block granularity, even if the inode
+given by +ir_startino+ itself is sparse.
+
+*sb_unit*::
+Underlying stripe or raid unit in blocks.
+
+*sb_width*::
+Underlying stripe or raid width in blocks.
+
+*sb_dirblklog*::
+log~2~ multiplier that determines the granularity of directory block allocations
+in fsblocks.
+
+*sb_logsectlog*::
+log~2~ value of the log subvolume's sector size. This is only used if the
+journaling log is on a separate disk device (i.e. not internal).
+
+*sb_logsectsize*::
+The log's sector size in bytes if the filesystem uses an external log device.
+
+*sb_logsunit*::
+The log device's stripe or raid unit size. This only applies to version 2 logs
++XFS_SB_VERSION_LOGV2BIT+ is set in +sb_versionnum+.
+
+*sb_features2*::
+Additional version flags if +XFS_SB_VERSION_MOREBITSBIT+ is set in
++sb_versionnum+. The currently defined additional features include:
+
+.Extended Version 4 Superblock flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_SB_VERSION2_LAZYSBCOUNTBIT+ |
+Lazy global counters. Making a filesystem with this bit set can improve
+performance. The global free space and inode counts are only updated in the
+primary superblock when the filesystem is cleanly unmounted.
+
+| +XFS_SB_VERSION2_ATTR2BIT+	|
+Extended attributes version 2. Making a filesystem with this optimises the
+inode layout of extended attributes.  If this bit is set and the +noattr2+
+mount flag is not specified, the +di_forkoff+ inode field will be dynamically
+adjusted.  See the section about xref:Extended_Attribute_Versions[extended
+attribute versions] for more information.
+
+| +XFS_SB_VERSION2_PARENTBIT+	|
+Parent pointers. All inodes must have an extended attribute that points back to
+its parent inode. The primary purpose for this information is in backup systems.
+
+| +XFS_SB_VERSION2_PROJID32BIT+	|
+32-bit Project ID.  Inodes can be associated with a project ID number, which
+can be used to enforce disk space usage quotas for a particular group of
+directories.  This flag indicates that project IDs can be 32 bits in size.
+
+| +XFS_SB_VERSION2_CRCBIT+	|
+Metadata checksumming.  All metadata blocks have an extended header containing
+the block checksum, a copy of the metadata UUID, the log sequence number of the
+last update to prevent stale replays, and a back pointer to the owner of the
+block.  This feature must be and can only be set if the lowest nibble of
++sb_versionnum+ is set to 5.
+
+| +XFS_SB_VERSION2_FTYPE+	|
+Directory file type.  Each directory entry records the type of the inode to
+which the entry points.  This speeds up directory iteration by removing the
+need to load every inode into memory.
+|=====
+
+*sb_bad_features2*::
+This field mirrors +sb_features2+, due to past 64-bit alignment errors.
+
+*sb_features_compat*::
+Read-write compatible feature flags.  The kernel can still read and write this
+FS even if it doesn't understand the flag.  Currently, there are no valid
+flags.
+
+*sb_features_ro_compat*::
+Read-only compatible feature flags.  The kernel can still read this FS even if
+it doesn't understand the flag.
+
+.Extended Version 5 Superblock Read-Only compatibility flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_SB_FEAT_RO_COMPAT_FINOBT+ |
+Free inode B+tree.  Each allocation group contains a B+tree to track inode chunks
+containing free inodes.  This is a performance optimization to reduce the time
+required to allocate inodes.
+
+| +XFS_SB_FEAT_RO_COMPAT_RMAPBT+ |
+Reverse mapping B+tree.  Each allocation group contains a B+tree containing
+records mapping AG blocks to their owners.  See the section about
+xref:Reconstruction[reconstruction] for more details.
+
+| +XFS_SB_FEAT_RO_COMPAT_REFLINK+ |
+Reference count B+tree.  Each allocation group contains a B+tree to track the
+reference counts of AG blocks.  This enables files to share data blocks safely.
+See the section about xref:Reflink_Deduplication[reflink and deduplication] for
+more details.
+
+| +XFS_SB_FEAT_RO_COMPAT_INOBTCNT+ |
+Inode B+tree block counters.  Each allocation group's inode (AGI) header
+tracks the number of blocks in each of the inode B+trees.  This allows us
+to have a slightly higher level of redundancy over the shape of the inode
+btrees, and decreases the amount of time to compute the metadata B+tree
+preallocations at mount time.
+
+|=====
+
+*sb_features_incompat*::
+Read-write incompatible feature flags.  The kernel cannot read or write this
+FS if it doesn't understand the flag.
+
+.Extended Version 5 Superblock Read-Write incompatibility flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_SB_FEAT_INCOMPAT_FTYPE+ |
+Directory file type.  Each directory entry tracks the type of the inode to
+which the entry points.  This is a performance optimization to remove the need
+to load every inode into memory to iterate a directory.
+
+| +XFS_SB_FEAT_INCOMPAT_SPINODES+ |
+Sparse inodes.  This feature relaxes the requirement to allocate inodes in
+chunks of 64.  When the free space is heavily fragmented, there might exist
+plenty of free space but not enough contiguous free space to allocate a new
+inode chunk.  With this feature, the user can continue to create files until
+all free space is exhausted.
+
+Unused space in the inode B+tree records are used to track which parts of the
+inode chunk are not inodes.
+
+See the chapter on xref:Sparse_Inodes[Sparse Inodes] for more information.
+
+| +XFS_SB_FEAT_INCOMPAT_META_UUID+ |
+Metadata UUID.  The UUID stamped into each metadata block must match the value
+in +sb_meta_uuid+.  This enables the administrator to change +sb_uuid+ at will
+without having to rewrite the entire filesystem.
+
+| +XFS_SB_FEAT_INCOMPAT_BIGTIME+ |
+Large timestamps.  Inode timestamps and quota expiration timers are extended to
+support times through the year 2486.  See the section on
+xref:Timestamps[timestamps] for more information.
+
+| +XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR+ |
+The filesystem is not in operable condition, and must be run through
+xfs_repair before it can be mounted.
+
+| +XFS_SB_FEAT_INCOMPAT_NREXT64+ |
+Large file fork extent counts.  This greatly expands the maximum number of
+space mappings allowed in data and extended attribute file forks.
+
+| +XFS_SB_FEAT_INCOMPAT_EXCHRANGE+ |
+Atomic file mapping exchanges.  The filesystem is capable of exchanging a range
+of mappings between two arbitrary ranges of a file's fork by using log intent
+items to track the progress of the high level exchange operation.  In other
+words, the exchange operation can be restarted if the system goes down, which
+is necessary for userspace to commit of new file contents atomically.  This
+flag has user-visible impacts, which is why it is a permanent incompat flag.
+See the section about xref:XMI_Log_Item[mapping exchange log intents] for more
+information.
+
+| +XFS_SB_FEAT_INCOMPAT_PARENT+ |
+Directory parent pointers.  See the section about xref:Parent_Pointers[parent
+pointers] for more information.
+
+|=====
+
+*sb_features_log_incompat*::
+Read-write incompatible feature flags for the log.  The kernel cannot recover
+the FS log if it doesn't understand the flag.
+
+.Extended Version 5 Superblock Log incompatibility flags
+[options="header"]
+|=====
+| Flag					| Description
+| +XFS_SB_FEAT_INCOMPAT_LOG_XATTRS+	|
+Extended attribute updates have been committed to the ondisk log.
+
+|=====
+
+*sb_crc*::
+Superblock checksum.
+
+*sb_spino_align*::
+Sparse inode alignment, in fsblocks.  Each chunk of inodes referenced by a
+sparse inode B+tree record must be aligned to this block granularity.
+
+*sb_pquotino*::
+Project quota inode.
+
+*sb_lsn*::
+Log sequence number of the last superblock update.
+
+*sb_meta_uuid*::
+If the +XFS_SB_FEAT_INCOMPAT_META_UUID+ feature is set, then the UUID field in
+all metadata blocks must match this UUID.  If not, the block header UUID field
+must match +sb_uuid+.
+
+*sb_rrmapino*::
+If the +XFS_SB_FEAT_RO_COMPAT_RMAPBT+ feature is set and a real-time
+device is present (+sb_rblocks+ > 0), this field points to an inode
+that contains the root to the
+xref:Real_time_Reverse_Mapping_Btree[Real-Time Reverse Mapping B+tree].
+This field is zero otherwise.
+
+=== xfs_db Superblock Example
+
+A filesystem is made on a single disk with the following command:
+
+----
+# mkfs.xfs -i attr=2 -n size=16384 -f /dev/sda7
+meta-data=/dev/sda7              isize=256    agcount=16, agsize=3923122 blks
+         =                       sectsz=512   attr=2
+data     =                       bsize=4096   blocks=62769952, imaxpct=25
+         =                       sunit=0      swidth=0 blks, unwritten=1
+naming   =version 2              bsize=16384
+log      =internal log           bsize=4096   blocks=30649, version=1
+         =                       sectsz=512   sunit=0 blks
+realtime =none                   extsz=65536  blocks=0, rtextents=0
+----
+
+And in xfs_db, inspecting the superblock:
+
+----
+xfs_db> sb
+xfs_db> p
+magicnum = 0x58465342
+blocksize = 4096
+dblocks = 62769952
+rblocks = 0
+rextents = 0
+uuid = 32b24036-6931-45b4-b68c-cd5e7d9a1ca5
+logstart = 33554436
+rootino = 128
+rbmino = 129
+rsumino = 130
+rextsize = 16
+agblocks = 3923122
+agcount = 16
+rbmblocks = 0
+logblocks = 30649
+versionnum = 0xb084
+sectsize = 512
+inodesize = 256
+inopblock = 16
+fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
+blocklog = 12
+sectlog = 9
+inodelog = 8
+inopblog = 4
+agblklog = 22
+rextslog = 0
+inprogress = 0
+imax_pct = 25
+icount = 64
+ifree = 61
+fdblocks = 62739235
+frextents = 0
+uquotino = 0
+gquotino = 0
+qflags = 0
+flags = 0
+shared_vn = 0
+inoalignmt = 2
+unit = 0
+width = 0
+dirblklog = 2
+logsectlog = 0
+logsectsize = 0
+logsunit = 0
+features2 = 8
+----

