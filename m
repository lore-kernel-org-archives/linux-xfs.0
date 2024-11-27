Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB70C2C8
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732666760; cv=none; b=HsXIlvlvUWaoFBmvXzrKgQICYlGoaNV2fr80pxwkcVeuWWayHbUoKfP8oKlTPgL1fzfUpczEmaGQMZRDaIWw0qnYzAZgjEjMEWgt0XFz419BNnDkonOVs4XNwP/8mK9KYGHOWlWYikdbXlxxGmYQpM8fXr+sWfG8ec3ao/ZRgUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732666760; c=relaxed/simple;
	bh=4QMLy8jvBiAI+fxLXOf9Eo59XkO0n2tdIrPZoN4WRzQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vBRGDqFCttiWqFjYYTwJUlxYoL8uXYc/iVAMKme5gn4BCmWXXEGH0B3tFffZ//8w0PJFPewWbbMS8Y2frbQRebpK9vGZBjYkF9d1fHh0ucQN1R1VcWJ4yrnsqzfbprAY6X8VUqMF/x70PZrVOzzfWCupaBpvzF7Fca1H6kg85Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AlhSyy5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AlhSyy5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15129C4CECF;
	Wed, 27 Nov 2024 00:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732666760;
	bh=4QMLy8jvBiAI+fxLXOf9Eo59XkO0n2tdIrPZoN4WRzQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AlhSyy5DXtwd8HR72Uv06CAmIFc8ZHGM3yssJuyFb+dtOyymVsZJfSXXSZrrTVqD/
	 +/gkC6ECLURQCuLG3KZb4chbzZlGhUSD1vslhFuySlFW0mKYZRwuUrlC0ICZjUxs5z
	 mz0dGTHLHeTzt2kllk5A3yrkGPzdB7L+PgtQgI2JnAUC8lj+EqxrhACHfzyzPr7T/i
	 RON1TbJCltsqjaaZMX2kuyHKOPmPlIZco0Lfj+o4rZmSVXNI2YtG4/NuL+FcIw9oHp
	 wVuVNcdyPT88iOEKfMfJkNK6Y55bsLU6MzYw3Iaj39BtyGiNEVaTWnwKbtBXh2qqTy
	 2dDO5If6lZSSA==
Date: Tue, 26 Nov 2024 16:19:19 -0800
Subject: [PATCH 05/10] design: document the changes required to handle
 metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173266662285.996198.10934163595962023057.stgit@frogsfrogsfrogs>
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

Document the ondisk format changes for metadata directories.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 .../internal_inodes.asciidoc                       |  113 ++++++++++++++++++++
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   22 ++++
 .../XFS_Filesystem_Structure/superblock.asciidoc   |   14 +-
 3 files changed, 142 insertions(+), 7 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index 84e4cb969ce392..eaa0a50aa848f3 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -5,6 +5,119 @@ XFS allocates several inodes when a filesystem is created. These are internal
 and not accessible from the standard directory structure. These inodes are only
 accessible from the superblock.
 
+[[Metadata_Directories]]
+== Metadata Directory Tree
+
+If the +XFS_SB_FEAT_INCOMPAT_METADIR+ feature is enabled, the +sb_metadirino+
+field in the superblock points to the root of a directory tree containing
+metadata files.  This directory tree is completely internal to the filesystem
+and must not be exposed to user programs.
+
+When this feature is enabled, metadata files should be found by walking the
+metadata directory tree.  The superblock fields that formerly pointed to (some)
+of those inodes have been deallocated and may be reused by future features.
+
+.Metadata Directory Paths
+[options="header"]
+|=====
+| Metadata File                                  | Location
+|=====
+
+Metadata files are flagged by the +XFS_DIFLAG2_METADATA+ flag in the
++di_flags2+ field.  Metadata files must have the following properties:
+
+* Must be either a directory or a regular file.
+* chmod 0000
+* User and group IDs set to zero.
+* The +XFS_DIFLAG_IMMUTABLE+, +XFS_DIFLAG_SYNC+, +XFS_DIFLAG_NOATIME+, +XFS_DIFLAG_NODUMP+, and +XFS_DIFLAG_NODEFRAG+ flags must all be set in +di_flags+.
+* For a directory, the +XFS_DIFLAG_NOSYMLINKS+ flag must also be set.
+* The +XFS_DIFLAG2_METADATA+ flag must be set in +di_flags2+.
+* The +XFS_DIFLAG2_DAX+ flag must not be set.
+
+=== Metadata Directory Example
+
+This example shows a metadta directory from a freshly formatted root
+filesystem:
+
+----
+xfs_db> sb 0
+xfs_db> p
+magicnum = 0x58465342
+blocksize = 4096
+dblocks = 5192704
+rblocks = 0
+rextents = 0
+uuid = cbf2ceef-658e-46b0-8f96-785661c37976
+logstart = 4194311
+rootino = 128
+rbmino = 130
+rsumino = 131
+...
+meta_uuid = 00000000-0000-0000-0000-000000000000
+metadirino = 129
+...
+----
+
+Notice how the listing includes the root of the metadata directory tree
+(+metadirino+).
+
+----
+xfs_db> path -m /
+xfs_db> ls
+8          129                directory      0x0000002e   1 . (good)
+10         129                directory      0x0000172e   2 .. (good)
+12         33685632           directory      0x2d18ab4c   8 rtgroups (good)
+----
+
+Here we use the +path+ and +ls+ commands to display the root directory of
+the metadata directory.  We can navigate the directory the old way, too:
+
+----
+xfs_db> p
+core.magic = 0x494e
+core.mode = 040000
+core.version = 3
+core.format = 1 (local)
+core.onlink = 0
+core.uid = 0
+core.gid = 0
+...
+v3.flags2 = 0x8000000000000018
+v3.cowextsize = 0
+v3.crtime.sec = Wed Aug  7 10:22:36 2024
+v3.crtime.nsec = 273744000
+v3.inumber = 129
+v3.uuid = 7e55b909-8728-4d69-a1fa-891427314eea
+v3.reflink = 0
+v3.cowextsz = 0
+v3.dax = 0
+v3.bigtime = 1
+v3.nrext64 = 1
+v3.metadata = 1
+u3.sfdir3.hdr.count = 1
+u3.sfdir3.hdr.i8count = 0
+u3.sfdir3.hdr.parent.i4 = 129
+u3.sfdir3.list[0].namelen = 8
+u3.sfdir3.list[0].offset = 0x60
+u3.sfdir3.list[0].name = "rtgroups"
+u3.sfdir3.list[0].inumber.i4 = 33685632
+u3.sfdir3.list[0].filetype = 2
+----
+
+The root of the metadata directory is a short format directory, and looks just
+like any other directory.  The only difference is that the metadata flag is
+set, and the directory can only be viewed in the XFS debugger.
+
+----
+xfs_db> path -m /rtgroups/0.rmap
+btdump
+u3.rtrmapbt.recs[1] = [startblock,blockcount,owner,offset,extentflag,attrfork,bmbtblock]
+1:[0,1,-3,0,0,0,0]
+----
+
+Observe that we can use the xfs_db +path+ command to navigate the metadata
+directory tree to the user quota file and display its contents.
+
 [[Quota_Inodes]]
 == Quota Inodes
 
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index 34c064871cb255..02ec0d12bb57e5 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -78,7 +78,10 @@ struct xfs_dinode_core {
      __uint16_t                di_mode;
      __int8_t                  di_version;
      __int8_t                  di_format;
-     __uint16_t                di_onlink;
+     union {
+          __uint16_t           di_onlink;
+          __uint16_t           di_metatype;
+     };
      __uint32_t                di_uid;
      __uint32_t                di_gid;
      __uint32_t                di_nlink;
@@ -188,6 +191,17 @@ In v1 inodes, this specifies the number of links to the inode from directories.
 When the number exceeds 65535, the inode is converted to v2 and the link count
 is stored in +di_nlink+.
 
+*di_metatype*::
+If the +XFS_SB_FEAT_INCOMPAT_METADIR+ feature is enabled, the +di_onlink+ field
+is redefined to declare the intended contents of files in the metadata
+directory tree.
+
+[source, c]
+----
+enum xfs_metafile_type {
+};
+----
+
 *di_uid*::
 Specifies the owner's UID of the inode.
 
@@ -383,6 +397,12 @@ will be copied to all newly created files and directories.
 Files with this flag set may have up to (2^48^ - 1) extents mapped to the data
 fork and up to (2^32^ - 1) extents mapped to the attribute fork.  This flag
 requires the +XFS_SB_FEAT_INCOMPAT_NREXT64+ feature to be enabled.
+| +XFS_DIFLAG2_METADATA+	|
+This file contains filesystem metadata.  This feature requires the
++XFS_SB_FEAT_INCOMPAT_METADIR+ feature to be enabled.  See the section about
+xref:Metadata_Directories[metadata directories] for more information on
+metadata inode properties.  Only directories and regular files can have this
+flag set.
 |=====
 
 *di_cowextsize*::
diff --git a/design/XFS_Filesystem_Structure/superblock.asciidoc b/design/XFS_Filesystem_Structure/superblock.asciidoc
index 79e8c30dc93e79..56877615ae81bf 100644
--- a/design/XFS_Filesystem_Structure/superblock.asciidoc
+++ b/design/XFS_Filesystem_Structure/superblock.asciidoc
@@ -69,7 +69,7 @@ struct xfs_dsb {
 	__be64		sb_pquotino;
 	__be64		sb_lsn;
 	uuid_t		sb_meta_uuid;
-	__be64		sb_rrmapino;
+	__be64		sb_metadirino;
 
 	/* must be padded to 64 bit alignment */
 };
@@ -438,6 +438,10 @@ information.
 Directory parent pointers.  See the section about xref:Parent_Pointers[parent
 pointers] for more information.
 
+| +XFS_SB_FEAT_INCOMPAT_METADIR+ |
+Metadata directory tree.  See the section about the xref:Metadata_Directories[
+metadata directory tree] for more information.
+
 |=====
 
 *sb_features_log_incompat*::
@@ -471,11 +475,9 @@ If the +XFS_SB_FEAT_INCOMPAT_META_UUID+ feature is set, then the UUID field in
 all metadata blocks must match this UUID.  If not, the block header UUID field
 must match +sb_uuid+.
 
-*sb_rrmapino*::
-If the +XFS_SB_FEAT_RO_COMPAT_RMAPBT+ feature is set and a real-time
-device is present (+sb_rblocks+ > 0), this field points to an inode
-that contains the root to the
-xref:Real_time_Reverse_Mapping_Btree[Real-Time Reverse Mapping B+tree].
+*sb_metadirino*::
+If the +XFS_SB_FEAT_RO_INCOMPAT_METADIR+ feature is set, this field points to
+the inode of the root directory of the metadata directory tree.
 This field is zero otherwise.
 
 === xfs_db Superblock Example

