Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6938B4A03
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 01:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fdsw1F/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8E8C433C7;
	Mon,  1 Jan 2024 01:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071290;
	bh=zYPbCxmcUtiVpsptffJLPtI1tEQpZQ+Kb8VAkAPEKT8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Fdsw1F/+rq/8/Y4C7H8pG1Ia+14XAqqh5ocqQbSDfxi5kIFDTaQClYUjCTOFbCiFm
	 XveeXrauXkQqdRmw080qHDslZfDNNphEGQDXhFCvEPImmCffc5YKL3GV6Pn6BcVgPo
	 bLbLwOoTNGU3sc6S7GinYkq6Rw8qOjNmIr/SUqIvQ5DR6Oj5VLtXEIzxFYnsExSFWn
	 nqSS2miYy/4mX4FvAOGNKUxeXmKuWR57FOkb6MwYgBjHbYWwTbYGNATSg+kzeMvEw7
	 JRbUa+PmcMSCLAdIfbBE6RL/2suojLjzbhXrOXcqrE4au6V1toZtpKEselF4pWO1xi
	 wBu1xfb+tQstg==
Date: Sun, 31 Dec 2023 17:08:09 +9900
Subject: [PATCH 1/1] design: document the changes required to handle metadata
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: darrick.wong@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405036972.1829793.7906279959045843752.stgit@frogsfrogsfrogs>
In-Reply-To: <170405036960.1829793.10647088428067526884.stgit@frogsfrogsfrogs>
References: <170405036960.1829793.10647088428067526884.stgit@frogsfrogsfrogs>
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

Document the ondisk format changes for metadata directories.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../allocation_groups.asciidoc                     |   23 +++
 .../internal_inodes.asciidoc                       |  142 ++++++++++++++++++++
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    5 +
 3 files changed, 165 insertions(+), 5 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 7b128838..c91a06bf 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -142,10 +142,13 @@ start of the first possible inode chunk in AG 0.  This is 128 when using a 4KB
 block size.
 
 *sb_rbmino*::
-Bitmap inode for real-time extents.
+Bitmap inode for real-time extents if the +XFS_SB_FEAT_INCOMPAT_METADIR+
+feature is not enabled.  If the metadir feature is enabled, this field points
+to the inode for the root of the metadata directory tree.
 
 *sb_rsumino*::
-Summary inode for real-time bitmap.
+Summary inode for real-time bitmap if the +XFS_SB_FEAT_INCOMPAT_METADIR+
+feature is not enabled.
 
 *sb_rextsize*::
 Realtime extent size in blocks.
@@ -262,12 +265,16 @@ maintained in the first superblock.
 *sb_uquotino*::
 Inode for user quotas. This and the following two quota fields only apply if
 +XFS_SB_VERSION_QUOTABIT+ flag is set in +sb_versionnum+. Refer to
-xref:Quota_Inodes[quota inodes] for more information.
+xref:Quota_Inodes[quota inodes] for more information.  If the
++XFS_SB_FEAT_INCOMPAT_METADIR+ feature is enabled, the user quota file is found
+through the metadata directory tree and this field must be zero.
 
 *sb_gquotino*::
 Inode for group or project quotas. Group and project quotas cannot be used at
 the same time on v4 filesystems.  On a v5 filesystem, this inode always stores
-group quota information.
+group quota information.  If the +XFS_SB_FEAT_INCOMPAT_METADIR+ feature is
+enabled, the group quota file is found through the metadata directory tree and
+this field must be zero.
 
 *sb_qflags*::
 Quota flags. It can be a combination of the following flags:
@@ -458,6 +465,10 @@ xfs_repair before it can be mounted.
 Large file fork extent counts.  This greatly expands the maximum number of
 space mappings allowed in data and extended attribute file forks.
 
+| +XFS_SB_FEAT_INCOMPAT_METADIR+ |
+Metadata directory tree.  See the section about the xref:Metadata_Directories[
+metadata directory tree] for more information.
+
 |=====
 
 *sb_features_log_incompat*::
@@ -488,7 +499,9 @@ Sparse inode alignment, in fsblocks.  Each chunk of inodes referenced by a
 sparse inode B+tree record must be aligned to this block granularity.
 
 *sb_pquotino*::
-Project quota inode.
+Project quota inode.  If the +XFS_SB_FEAT_INCOMPAT_METADIR+ feature is enabled,
+the project quota file is found through the metadata directory tree and this
+field must be zero.
 
 *sb_lsn*::
 Log sequence number of the last superblock update.
diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index 84e4cb96..42020a5f 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -5,6 +5,148 @@ XFS allocates several inodes when a filesystem is created. These are internal
 and not accessible from the standard directory structure. These inodes are only
 accessible from the superblock.
 
+[[Metadata_Directories]]
+== Metadata Directory Tree
+
+If the +XFS_SB_FEAT_INCOMPAT_METADIR+ feature is enabled, the +sb_rbmino+ field
+in the superblock points to the root of a directory tree containing metadata
+files.  This directory tree is completely internal to the filesystem and should
+not be exposed to user programs.
+
+Certain types of filesystem metadata can be stored in regular (but hidden)
+files.  Prior to the metadata directory feature, the superblock contained
+pointers to these files.
+
+When this feature is enabled, metadata files should be found by walking the
+metadata directory tree.  The superblock fields that formerly pointed to (some)
+of those inodes have been deallocated and may be reused by future features.
+
+.Metadata Directory Paths
+[options="header"]
+|=====
+| Metadata File                                  | Location
+| User xref:Quota_Inodes[Quotas]                 | /quota/user
+| Group Quotas                                   | /quota/group
+| Project Quotas                                 | /quota/project
+| xref:Real-Time_Bitmap_Inode[Realtime Bitmap]   | /realtime/bitmap
+| xref:Real-Time_Summary_Inode[Realtime Summary] | /realtime/summary
+|=====
+
+Metadata files are flagged by the +XFS_DIFLAG2_METADATA+ flag in the
++di_flags2+ field.  Metadata files must have their user, group, and project IDs
+set to zero, and must be chmod 0000.
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
+dblocks = 2579968
+rblocks = 0
+rextents = 0
+uuid = 9b535856-7d4c-4c11-a059-42199f602b03
+logstart = 2097159
+rootino = 128
+metadirino = 129
+rextsize = 1
+agblocks = 644992
+agcount = 4
+rbmblocks = 0
+logblocks = 3693
+...
+----
+
+Notice how the listing no longer includes the realtime bitmap or summary
+inodes, but does include the root of the metadata directory tree
+(+metadirino+).
+
+----
+xfs_db> path -m /
+xfs_db> ls
+129                directory      0x0000002e   1 .
+129                directory      0x0000172e   2 ..
+130                directory      0xce7fe1eb   8 realtime
+133                directory      0x1ebbfa66   5 quota
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
+core.nlinkv2 = 4
+core.onlink = 0
+core.projid_lo = 0
+core.projid_hi = 0
+core.uid = 0
+core.gid = 0
+...
+v3.inumber = 129
+v3.uuid = 9b535856-7d4c-4c11-a059-42199f602b03
+v3.reflink = 0
+v3.cowextsz = 0
+v3.dax = 0
+v3.bigtime = 1
+v3.metadata = 1
+u3.sfdir3.hdr.count = 2
+u3.sfdir3.hdr.i8count = 0
+u3.sfdir3.hdr.parent.i4 = 129
+u3.sfdir3.list[0].namelen = 8
+u3.sfdir3.list[0].offset = 0x60
+u3.sfdir3.list[0].name = "realtime"
+u3.sfdir3.list[0].inumber.i4 = 130
+u3.sfdir3.list[0].filetype = 2
+u3.sfdir3.list[1].namelen = 5
+u3.sfdir3.list[1].offset = 0x78
+u3.sfdir3.list[1].name = "quota"
+u3.sfdir3.list[1].inumber.i4 = 133
+u3.sfdir3.list[1].filetype = 2
+----
+
+The root of the metadata directory is a short format directory, and looks just
+like any other directory.  The only difference is that the metadata flag is
+set, and the directory can only be viewed in the XFS debugger.
+
+----
+xfs_db> path -m /quota/user
+xfs_db> dblock 0
+xfs_db> p
+diskdq.magic = 0x4451
+diskdq.version = 0x1
+diskdq.type = 0x1
+diskdq.id = 0
+diskdq.blk_hardlimit = 0
+diskdq.blk_softlimit = 0
+diskdq.ino_hardlimit = 0
+diskdq.ino_softlimit = 0
+diskdq.bcount = 0
+diskdq.icount = 6
+diskdq.itimer = 0
+diskdq.btimer = 0
+diskdq.iwarns = 0
+diskdq.bwarns = 0
+diskdq.rtb_hardlimit = 0
+diskdq.rtb_softlimit = 0
+diskdq.rtbcount = 0
+diskdq.rtbtimer = 0
+diskdq.rtbwarns = 0
+crc = 0x7ada5c8b (correct)
+lsn = 0
+uuid = 9b535856-7d4c-4c11-a059-42199f602b03
+----
+
+Observe that we can use the xfs_db +path+ command to navigate the metadata
+directory tree to the user quota file and display its contents.
+
 [[Quota_Inodes]]
 == Quota Inodes
 
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index 34c06487..964a9611 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -383,6 +383,11 @@ will be copied to all newly created files and directories.
 Files with this flag set may have up to (2^48^ - 1) extents mapped to the data
 fork and up to (2^32^ - 1) extents mapped to the attribute fork.  This flag
 requires the +XFS_SB_FEAT_INCOMPAT_NREXT64+ feature to be enabled.
+| +XFS_DIFLAG2_METADATA+	|
+This file contains filesystem metadata.  This feature requires the
++XFS_SB_FEAT_INCOMPAT_METADIR+ feature to be enabled.  Metadata files must have
+their user, group, and project IDs set to zero, and the permissions bits of the
+mode must be zero.  Only directories and regular files can have this flag set.
 |=====
 
 *di_cowextsize*::

