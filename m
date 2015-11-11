Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0AAEC7F78
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:23:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A5D2F8F8035
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:23:09 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Wsf33AhLyf4rJpZi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:23:02 -0800 (PST)
Subject: [PATCH 03/21] xfsdocs: restore the old rendering of structure field
	definitions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:22:38 -0800
Message-ID: <20151111192238.14235.56734.stgit@birch.djwong.org>
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

Restore the rendering of the on-disk struct fields to resemble that of
the old SGI book, with bold field names on one line and the
description indented below.  This is a lot more readable than letting
the whole field and description run together as one long line.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |  136 ++++++++++----------
 .../XFS_Filesystem_Structure/common_types.asciidoc |   28 ++--
 .../internal_inodes.asciidoc                       |   38 +++---
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   50 ++++---
 4 files changed, 126 insertions(+), 126 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index a3721c2..afbbb67 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -92,59 +92,59 @@ struct xfs_sb
 	__uint32_t		sb_features2;
 };
 ----
-.sb_magicnum
+*sb_magicnum*::
 Identifies the filesystem. It's value is +XFS_SB_MAGIC = 0x58465342 "XFSB"+.
 
-.sb_blocksize
+*sb_blocksize*::
 The size of a basic unit of space allocation in bytes. Typically, this is 4096
 (4KB) but can range from 512 to 65536 bytes.
 
-.sb_dblocks
+*sb_dblocks*::
 Total number of blocks available for data and metadata on the filesystem.
 
-.sb_rblocks
+*sb_rblocks*::
 Number blocks in the real-time disk device. Refer to
 xref:Real-time_Devices[real-time sub-volumes] for more information.
 
-.sb_rextents
+*sb_rextents*::
 Number of extents on the real-time device.
 
-.sb_uuid
+*sb_uuid*::
 UUID (Universally Unique ID) for the filesystem. Filesystems can be mounted by
 the UUID instead of device name.
 
-.sb_logstart
+*sb_logstart*::
 First block number for the journaling log if the log is internal (ie. not on a
 separate disk device). For an external log device, this will be zero (the log
 will also start on the first block on the log device).
 
-.sb_rootino
+*sb_rootino*::
 Root inode number for the filesystem. Typically, this is 128 when using a
 4KB block size.
 
-.sb_rbmino
+*sb_rbmino*::
 Bitmap inode for real-time extents.
 
-.sb_rsumino
+*sb_rsumino*::
 Summary inode for real-time bitmap.
 
-.sb_rextsize
+*sb_rextsize*::
 Realtime extent size in blocks.
 
-.sb_agblocks
+*sb_agblocks*::
 Size of each AG in blocks. For the actual size of the last AG, refer to the
 xref:AG_Free_Space_Management[free space] +agf_length+ value.
 
-.sb_agcount
+*sb_agcount*::
 Number of AGs in the filesystem.
 
-.sb_rbmblocks
+*sb_rbmblocks*::
 Number of real-time bitmap blocks.
 
-.sb_logblocks
+*sb_logblocks*::
 Number of blocks for the journaling log.
 
-.sb_versionnum
+*sb_versionnum*::
 Filesystem version number. This is a bitmask specifying the features enabled
 when creating the filesystem. Any disk checking tools or drivers that do not
 recognize any set bits must not operate upon the filesystem. Most of the flagsi
@@ -174,72 +174,72 @@ Version 2 directories are used. This is always set.
 Set if the sb_features2 field in the superblock contains more flags.
 |=====
 
-.sb_sectsize
+*sb_sectsize*::
 Specifies the underlying disk sector size in bytes. Majority of the time, this
 is 512 bytes. This determines the minimum I/O alignment including Direct I/O.
 
-.sb_inodesize
+*sb_inodesize*::
 Size of the inode in bytes. The default is 256 (2 inodes per standard sector)
 but can be made as large as 2048 bytes when creating the filesystem.
 
-.sb_inopblock
+*sb_inopblock*::
 Number of inodes per block. This is equivalent to +sb_blocksize / sb_inodesize+.
 
-.sb_fname[12]
+*sb_fname[12]*::
 Name for the filesystem. This value can be used in the mount command.
 
-.sb_blocklog
+*sb_blocklog*::
 log~2~ value of +sb_blocksize+. In other terms, +sb_blocksize = 2^sb_blocklog^+.
 
-.sb_sectlog
+*sb_sectlog*::
 log~2~ value of +sb_sectsize+.
 
-.sb_inodelog
+*sb_inodelog*::
 log~2~ value of +sb_inodesize+.
 
-.sb_inopblog
+*sb_inopblog*::
 log~2~ value of +sb_inopblock+.
 
-.sb_agblklog
+*sb_agblklog*::
 log~2~ value of +sb_agblocks+ (rounded up). This value is used to generate inode
 numbers and absolute block numbers defined in extent maps.
 
-.sb_rextslog
+*sb_rextslog*::
 log~2~ value of +sb_rextents+.
 
-.sb_inprogress
+*sb_inprogress*::
 Flag specifying that the filesystem is being created.
 
-.sb_imax_pct
+*sb_imax_pct*::
 Maximum percentage of filesystem space that can be used for inodes. The default
 value is 5%.
 
-.sb_icount
+*sb_icount*::
 Global count for number inodes allocated on the filesystem. This is only
 maintained in the first superblock.
 
-.sb_ifree
+*sb_ifree*::
 Global count of free inodes on the filesystem. This is only maintained in the
 first superblock.
 
-.sb_fdblocks
+*sb_fdblocks*::
 Global count of free data blocks on the filesystem. This is only maintained in
 the first superblock.
 
-.sb_frextents
+*sb_frextents*::
 Global count of free real-time extents on the filesystem. This is only
 maintained in the first superblock.
 
-.sb_uquotino
+*sb_uquotino*::
 Inode for user quotas. This and the following two quota fields only apply if
 +XFS_SB_VERSION_QUOTABIT+ flag is set in +sb_versionnum+. Refer to
 xref:Quota_Inodes[quota inodes] for more information
 
-.sb_gquotino
+*sb_gquotino*::
 Inode for group or project quotas. Group and Project quotas cannot be used at
 the same time.
 
-.sb_qflags
+*sb_qflags*::
 Quota flags. It can be a combination of the following flags:
 
 .Superblock quota flags
@@ -255,37 +255,37 @@ Quota flags. It can be a combination of the following flags:
 | +XFS_GQUOTA_ACCT+		| Group quota accounting is enabled.
 |=====
 
-.sb_flags
+*sb_flags*::
 Miscellaneous flags.
 
-.sb_shared_vn
+*sb_shared_vn*::
 Reserved and must be zero ("vn" stands for version number).
 
-.sb_inoalignmt
+*sb_inoalignmt*::
 Inode chunk alignment in fsblocks.
 
-.sb_unit
+*sb_unit*::
 Underlying stripe or raid unit in blocks.
 
-.sb_width
+*sb_width*::
 Underlying stripe or raid width in blocks.
 
-.sb_dirblklog
+*sb_dirblklog*::
 log~2~ multiplier that determines the granularity of directory block allocations
 in fsblocks.
 
-.sb_logsectlog
+*sb_logsectlog*::
 log~2~ value of the log subvolume's sector size. This is only used if the
 journaling log is on a separate disk device (i.e. not internal).
 
-.sb_logsectsize
+*sb_logsectsize*::
 The log's sector size in bytes if the filesystem uses an external log device.
 
-.sb_logsunit
+*sb_logsunit*::
 The log device's stripe or raid unit size. This only applies to version 2 logs
 +XFS_SB_VERSION_LOGV2BIT+ is set in +sb_versionnum+.
 
-.sb_features2
+*sb_features2*::
 Additional version flags if +XFS_SB_VERSION_MOREBITSBIT+ is set in
 +sb_versionnum+. The currently defined additional features include:
 
@@ -417,45 +417,45 @@ struct xfs_agf {
 The rest of the bytes in the sector are zeroed. +XFS_BTNUM_AGF+ is set to 2,
 index 0 for the count B+tree and index 1 for the size B+tree.
 
-.agf_magicnum
+*agf_magicnum*::
 Specifies the magic number for the AGF sector: "XAGF" (0x58414746).
 
-.agf_versionnum
+*agf_versionnum*::
 Set to +XFS_AGF_VERSION+ which is currently 1.
 
-.agf_seqno
+*agf_seqno*::
 Specifies the AG number for the sector.
 
-.agf_length
+*agf_length*::
 Specifies the size of the AG in filesystem blocks. For all AGs except the last,
 This must be equal to the superblock's +sb_agblocks+ value. For the last AG,
 this could be less than the +sb_agblocks+ value. It is this value that should
 be used to determine the size of the AG.
 
-.agf_roots
+*agf_roots*::
 Specifies the block number for the root of the two free space B+trees.
 
-.agf_levels
+*agf_levels*::
 Specifies the level or depth of the two free space B+trees. For a fresh AG, this
 will be one, and the "roots" will point to a single leaf of level 0.
 
-.agf_flfirst
+*agf_flfirst*::
 Specifies the index of the first "free list" block. Free lists are covered in
 more detail later on.
 
-.agf_fllast
+*agf_fllast*::
 Specifies the index of the last "free list" block.
 
-.agf_flcount
+*agf_flcount*::
 Specifies the number of blocks in the "free list".
 
-.agf_freeblks
+*agf_freeblks*::
 Specifies the current number of free blocks in the AG.
 
-.agf_longest
+*agf_longest*::
 Specifies the number of blocks of longest contiguous free space in the AG.
 
-.agf_btreeblks
+*agf_btreeblks*::
 Specifies the number of blocks used for the free space B+trees. This is only
 used if the +XFS_SB_VERSION2_LAZYSBCOUNTBIT+ bit is set in +sb_features2+.
 
@@ -688,37 +688,37 @@ struct xfs_agi {
      __be32              agi_unlinked[64];
 }
 ----
-.agi_magicnum
+*agi_magicnum*::
 Specifies the magic number for the AGI sector: "XAGI" (0x58414749).
 
-.agi_versionnum
+*agi_versionnum*::
 Set to +XFS_AGI_VERSION+ which is currently 1.
 
-.agi_seqno
+*agi_seqno*::
 Specifies the AG number for the sector.
 
-.agi_length
+*agi_length*::
 Specifies the size of the AG in filesystem blocks.
 
-.agi_count
+*agi_count*::
 Specifies the number of inodes allocated for the AG.
 
-.agi_root
+*agi_root*::
 Specifies the block number in the AG containing the root of the inode B+tree.
 
-.agi_level
+*agi_level*::
 Specifies the number of levels in the inode B+tree.
 
-.agi_freecount
+*agi_freecount*::
 Specifies the number of free inodes in the AG.
 
-.agi_newino
+*agi_newino*::
 Specifies AG relative inode number most recently allocated.
 
-.agi_dirino
+*agi_dirino*::
 Deprecated and not used, it's always set to NULL (-1).
 
-.agi_unlinked[64]
+*agi_unlinked[64]*::
 Hash table of unlinked (deleted) inodes that are still being referenced. Refer
 to xref:Unlinked_Pointer[unlinked list pointers] for more information.
 
diff --git a/design/XFS_Filesystem_Structure/common_types.asciidoc b/design/XFS_Filesystem_Structure/common_types.asciidoc
index 5b52271..ea2d21f 100644
--- a/design/XFS_Filesystem_Structure/common_types.asciidoc
+++ b/design/XFS_Filesystem_Structure/common_types.asciidoc
@@ -3,47 +3,47 @@
 All the following XFS types can be found in xfs_types.h. NULL values are always
 -1 on disk (ie. all bits for the value set to one).
 
-.xfs_ino_t
+*xfs_ino_t*::
 Unsigned 64 bit absolute xref:Inode_Numbers[inode number].
 
-.xfs_off_t
+*xfs_off_t*::
 Signed 64 bit file offset.
 
-.xfs_daddr_t
+*xfs_daddr_t*::
 Signed 64 bit disk address.
 
-.xfs_agnumber_t
+*xfs_agnumber_t*::
 Unsigned 32 bit xref:Allocation_Groups[AG number].
 
-.xfs_agblock_t
+*xfs_agblock_t*::
 Unsigned 32 bit AG relative block number.
 
-.xfs_extlen_t
+*xfs_extlen_t*::
 Unsigned 32 bit xref:Data_Extents[extent] length in blocks.
 
-.xfs_extnum_t
+*xfs_extnum_t*::
 Signed 32 bit number of extents in a file.
 
-.xfs_dablk_t
+*xfs_dablk_t*::
 Unsigned 32 bit block number for xref:Directories[directories] and
 xref:Extended_Attributes[extended attributes].
 
-.xfs_dahash_t
+*xfs_dahash_t*::
 Unsigned 32 bit hash of a directory file name or extended attribute name.
 
-.xfs_dfsbno_t
+*xfs_dfsbno_t*::
 Unsigned 64 bit filesystem block number combining
 xref:Allocation_Groups[AG number] and block offset into the AG.
 
-.xfs_drfsbno_t
+*xfs_drfsbno_t*::
 Unsigned 64 bit raw filesystem block number.
 
-.xfs_drtbno_t
+*xfs_drtbno_t*::
 Unsigned 64 bit extent number in the xref:Real-time_Devices[real-time]
 sub-volume.
 
-.xfs_dfiloff_t
+*xfs_dfiloff_t*::
 Unsigned 64 bit block offset into a file.
 
-.xfs_dfilblks_t
+*xfs_dfilblks_t*::
 Unsigned 64 bit block count for a file.
diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index c3a3510..b69bea2 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -62,14 +62,14 @@ struct xfs_dqblk {
 };
 ----
 
-.d_magic
+*d_magic*::
 Specifies the signature where these two bytes are 0x4451 (+XFS_DQUOT_MAGIC+),
 or "DQ" in ASCII.
 
-.d_version
+*d_version*::
 Specifies the structure version, currently this is one (+XFS_DQUOT_VERSION+).
 
-.d_flags
+*d_flags*::
 Specifies which type of ID the structure applies to:
 
 [source, c]
@@ -79,71 +79,71 @@ Specifies which type of ID the structure applies to:
 #define XFS_DQ_GROUP 0x0004
 ----
 
-.d_id</term>
+*d_id*::
 The ID for the quota structure. This will be a uid, gid or projid based on the
 value of +d_flags+.
 
-.d_blk_hardlimit
+*d_blk_hardlimit*::
 Specifies the hard limit for the number of filesystem blocks the ID can own. The
 ID will not be able to use more space than this limit. If it is attempted,
 +ENOSPC+ will be returned.
 
-.d_blk_softlimit
+*d_blk_softlimit*::
 Specifies the soft limit for the number of filesystem blocks the ID can own.
 The ID can temporarily use more space than by +d_blk_softlimit+ up to
 +d_blk_hardlimit+. If the space is not freed by the time limit specified by ID
 zero's +d_btimer+ value, the ID will be denied more space until the total
 blocks owned goes below +d_blk_softlimit+.
 
-.d_ino_hardlimit
+*d_ino_hardlimit*::
 Specifies the hard limit for the number of inodes the ID can own. The ID will
 not be able to create or own any more inodes if +d_icount+ reaches this value.
 
-.d_ino_softlimit
+*d_ino_softlimit*::
 Specifies the soft limit for the number of inodes the ID can own. The ID can
 temporarily create or own more inodes than specified by d_ino_softlimit up to
 d_ino_hardlimit. If the inode count is not reduced by the time limit specified
 by ID zero's d_itimer value, the ID will be denied from creating or owning more
 inodes until the count goes below d_ino_softlimit.
 
-.d_bcount
+*d_bcount*::
 Specifies how many filesystem blocks are actually owned by the ID.
 
-.d_icount
+*d_icount*::
 Specifies how many inodes are actually owned by the ID.
 
-.d_itimer
+*d_itimer*::
 Specifies the time when the ID's +d_icount+ exceeded +d_ino_softlimit+. The soft
 limit will turn into a hard limit after the elapsed time exceeds ID zero's
 +d_itimer+ value. When d_icount goes back below +d_ino_softlimit+, +d_itimer+
 is reset back to zero.
 
-.d_btimer
+*d_btimer*::
 Specifies the time when the ID's +d_bcount+ exceeded +d_blk_softlimit+. The soft
 limit will turn into a hard limit after the elapsed time exceeds ID zero's
 +d_btimer+ value. When d_bcount goes back below +d_blk_softlimit+, +d_btimer+
 is reset back to zero.
 
-.d_iwarns
-.d_bwarns
-.d_rtbwarns
+*d_iwarns*::
+*d_bwarns*::
+*d_rtbwarns*::
 Specifies how many times a warning has been issued. Currently not used.
 
-.d_rtb_hardlimit
+*d_rtb_hardlimit*::
 Specifies the hard limit for the number of real-time blocks the ID can own. The
 ID cannot own more space on the real-time subvolume beyond this limit.
 
-.d_rtb_softlimit
+*d_rtb_softlimit*::
 Specifies the soft limit for the number of real-time blocks the ID can own. The
 ID can temporarily own more space than specified by +d_rtb_softlimit+ up to
 +d_rtb_hardlimit+. If +d_rtbcount+ is not reduced by the time limit specified
 by ID zero's +d_rtbtimer value+, the ID will be denied from owning more space
 until the count goes below +d_rtb_softlimit+.
 
-.d_rtbcount
+*d_rtbcount*::
 Specifies how many real-time blocks are currently owned by the ID.
 
-.d_rtbtimer
+*d_rtbtimer*::
 Specifies the time when the ID's +d_rtbcount+ exceeded +d_rtb_softlimit+. The
 soft limit will turn into a hard limit after the elapsed time exceeds ID zero's
 +d_rtbtimer+ value. When +d_rtbcount+ goes back below +d_rtb_softlimit+,
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index 017f607..dfdcc32 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -101,20 +101,20 @@ struct xfs_dinode_core {
 };
 ----
 
-.di_magic
+*di_magic*::
 The inode signature where these two bytes are 0x494e, or "IN" in ASCII.
 
-.di_mode
+*di_mode*::
 Specifies the mode access bits and type of file using the standard S_Ixxx values
 defined in stat.h.
 
-.di_version
+*di_version*::
 Specifies the inode version which currently can only be 1 or 2. The inode
 version specifies the usage of the +di_onlink+, +di_nlink+ and +di_projid+
 values in the inode core. Initially, inodes are created as v1 but can be
 converted on the fly to v2 when required.
 
-.di_format
+*di_format*::
 
 Specifies the format of the data fork in conjunction with the +di_mode+ type.
 This can be one of several values. For directories and links, it can be "local"
@@ -137,34 +137,34 @@ typedef enum xfs_dinode_fmt {
 } xfs_dinode_fmt_t;
 ----
 
-.di_onlink
+*di_onlink*::
 In v1 inodes, this specifies the number of links to the inode from directories.
 When the number exceeds 65535, the inode is converted to v2 and the link count
 is stored in +di_nlink+.
 
-.di_uid
+*di_uid*::
 Specifies the owner's UID of the inode. 
 
-.di_gid
+*di_gid*::
 Specifies the owner's GID of the inode.
 
-.di_nlink
+*di_nlink*::
 Specifies the number of links to the inode from directories. This is maintained
 for both inode versions for current versions of XFS. Old versions of XFS did not
 support v2 inodes, and therefore this value was never updated and was classed as
 reserved space (part of +di_pad+).
 
-.di_projid
+*di_projid*::
 Specifies the owner's project ID in v2 inodes. An inode is converted to v2 if
 the project ID is set. This value must be zero for v1 inodes.
 
-.di_pad[8]
+*di_pad[8]*::
 Reserved, must be zero.
 
-.di_flushiter
+*di_flushiter*::
 Incremented on flush.
 
-.di_atime
+*di_atime*::
 
 Specifies the last access time of the files using UNIX time conventions the
 following structure. This value maybe undefined if the filesystem is mounted
@@ -178,24 +178,24 @@ struct xfs_timestamp {
 };
 ----
 
-.di_mtime
+*di_mtime*::
 Specifies the last time the file was modified.
 
-.di_ctime
+*di_ctime*::
 Specifies when the inode's status was last changed.
 
-.di_size
+*di_size*::
 Specifies the EOF of the inode in bytes. This can be larger or smaller than the
 extent space (therefore actual disk space) used for the inode. For regular
 files, this is the filesize in bytes, directories, the space taken by directory
 entries and for links, the length of the symlink.
 
-.di_nblocks
+*di_nblocks*::
 Specifies the number of filesystem blocks used to store the inode's data
 including relevant metadata like B+trees. This does not include blocks used for
 extended attributes.
 
-.di_extsize
+*di_extsize*::
 Specifies the extent size for filesystems with real-time devices and an extent
 size hint for standard filesystems. For normal filesystems, and with
 directories, the +XFS_DIFLAG_EXTSZINHERIT+ flag must be set in +di_flags+ if
@@ -204,13 +204,13 @@ di_extsize value and have +XFS_DIFLAG_EXTSIZE+ set in their +di_flags+. When a
 file is written to beyond allocated space, XFS will attempt to allocate
 additional disk space based on this value.
 
-.di_nextents
+*di_nextents*::
 Specifies the number of data extents associated with this inode.
 
-.di_anextents
+*di_anextents*::
 Specifies the number of extended attribute extents associated with this inode.
 
-.di_forkoff
+*di_forkoff*::
 Specifies the offset into the inode's literal area where the extended attribute
 fork starts. This is an 8-bit value that is multiplied by 8 to determine the
 actual offset in bytes (ie. attribute data is 64-bit aligned). This also limits
@@ -220,19 +220,19 @@ an extended attribute is created. When in attribute is added, the nature of
 Refer to xref:Extended_Attribute_Versions[Extended Attribute Versions] for more
 details.
 
-.di_aformat
+*di_aformat*::
 
 Specifies the format of the attribute fork. This uses the same values as
 +di_format+, but restricted to "local", "extents" and "btree" formats for
 extended attribute data.
 
-.di_dmevmask
+*di_dmevmask*::
 DMAPI event mask.
 
-.di_dmstate
+*di_dmstate*::
 DMAPI state.
 
-.di_flags
+*di_flags*::
 Specifies flags associated with the inode. This can be a combination of the
 following values:
 
@@ -271,7 +271,7 @@ Specifies the inode is to be ignored when defragmenting the filesystem.
 
 |=====
 
-.di_gen
+*di_gen*::
 A generation number used for inode identification. This is used by tools that do
 inode scanning such as backup tools and xfsdump. An inode's generation number
 can change by unlinking and creating a new file that reuses the inode.  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
