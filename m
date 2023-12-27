Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F3A4A05
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 01:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iIaO9nvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926EBC433C7;
	Mon,  1 Jan 2024 01:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071274;
	bh=OJzQdA7vAYsjcWIc1V/dtiDc277/PJgnujmvH2ABOtU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iIaO9nvPWAORqybet1djohPHjnelhUBexTLwTQQ0qS3PcssIAFSRWMHYfiQmupZ0o
	 k8T3uYFIvl8tC0Frw3utsKxqYlEqfs17OMs8XVaquqXjCmMUBUmOkQAnNsUIpX0VBO
	 ZgCFx8Yk0bwSKwwrHZAKwC1fS4b00m8PjeJhOYX8jF8iiMkZ+Ft1pkfusqYInAYQ7X
	 jvz8UKhlfQBsn0zCOoe2mGA+voeDdM/sm3j3L0D2qUojYLKGJF5aZhsn7pq3Co7q7J
	 ZfG4dn9PIEfZg2cbI6W+KE7n41drwcp1fvsO0vbMremQoey4S0UyZ0hrjDQ9d2iyDZ
	 Qe3aWznggCdTA==
Date: Sun, 31 Dec 2023 17:07:54 +9900
Subject: [PATCH 1/1] design: document the parent pointer ondisk format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405036551.1829491.4726867159555229702.stgit@frogsfrogsfrogs>
In-Reply-To: <170405036539.1829491.7832722721100300824.stgit@frogsfrogsfrogs>
References: <170405036539.1829491.7832722721100300824.stgit@frogsfrogsfrogs>
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

Add parent pointers to the ondisk format documentation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../allocation_groups.asciidoc                     |    4 +
 .../extended_attributes.asciidoc                   |   94 ++++++++++++++++++++
 2 files changed, 98 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index c91a06bf..bd825207 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -469,6 +469,10 @@ space mappings allowed in data and extended attribute file forks.
 Metadata directory tree.  See the section about the xref:Metadata_Directories[
 metadata directory tree] for more information.
 
+| +XFS_SB_FEAT_INCOMPAT_PARENT+ |
+Directory parent pointers.  See the section about xref:Parent_Pointers[parent
+pointers] for more information.
+
 |=====
 
 *sb_features_log_incompat*::
diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
index 19bff70f..6f905a1b 100644
--- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
+++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
@@ -90,6 +90,7 @@ A combination of the following:
 | +XFS_ATTR_SECURE+		| The attribute's namespace is ``secure''.
 | +XFS_ATTR_INCOMPLETE+		| This attribute is being modified.
 | +XFS_ATTR_LOCAL+		| The attribute value is contained within this block.
+| +XFS_ATTR_PARENT+		| This attribute is a parent pointer.
 |=====
 
 .Short form attribute layout
@@ -911,6 +912,99 @@ Log sequence number of the last write to this block.
 Filesystems formatted prior to v5 do not have this header in the remote block.
 Value data begins immediately at offset zero.
 
+[[Parent_Pointers]]
+== Directory Parent Pointers
+
+If this feature is enabled, each directory entry pointing from a parent
+directory to a child file has a corresponding back link from the child file
+back to the parent.  In other words, if directory P has an entry "foo" pointing
+to child C, then child C will have a parent pointer entry "foo" pointing to
+parent P.  This redundancy enables validation and repairs of the directory tree
+if the tree structure is damaged.
+
+Parent pointers are stored in a private namespace within the extended attribute
+structure.  The attribute name contains the following binary structure, and
+the attribute value contains the directory entry name.
+
+[source, c]
+----
+struct xfs_parent_name_rec {
+	__be64	p_ino;
+	__be32	p_gen;
+	__be32	p_namehash;
+};
+----
+
+*p_ino*::
+Inode number of the parent directory.
+
+*p_gen*::
+Generation number of the parent directory.
+
+*p_namehash*::
+The directory name hash of the directory entry name in the parent.
+
+=== xfs_db Parent Pointer Example
+
+Create a directory tree with the following structure, assuming that the
+XFS filesystem is mounted on +/mnt+:
+
+----
+$ mkdir /mnt/a/ /mnt/b
+$ touch /mnt/a/autoexec.bat
+$ ln /mnt/a/autoexec.bat /mnt/b/config.sys
+----
+
+Now we open this up in the debugger:
+
+----
+xfs_db> path /a
+xfs_db> ls
+8          131                directory      0x0000002e   1 . (good)
+10         128                directory      0x0000172e   2 .. (good)
+12         132                regular        0x5a1f6ea0  12 autoexec.bat (good)
+xfs_db> path /b
+xfs_db> ls
+8          8388736            directory      0x0000002e   1 . (good)
+10         128                directory      0x0000172e   2 .. (good)
+15         132                regular        0x9a01678c  10 config.sys (good)
+xfs_db> path /b/config.sys
+xfs_db> p a
+a.sfattr.hdr.totsize = 64
+a.sfattr.hdr.count = 2
+a.sfattr.list[0].namelen = 16
+a.sfattr.list[0].valuelen = 12
+a.sfattr.list[0].root = 0
+a.sfattr.list[0].secure = 0
+a.sfattr.list[0].parent = 1
+a.sfattr.list[0].parent_ino = 131
+a.sfattr.list[0].parent_gen = 3772462576
+a.sfattr.list[0].parent_namehash = 0x5a1f6ea0
+a.sfattr.list[0].parent_name = "autoexec.bat"
+a.sfattr.list[1].namelen = 16
+a.sfattr.list[1].valuelen = 10
+a.sfattr.list[1].root = 0
+a.sfattr.list[1].secure = 0
+a.sfattr.list[1].parent = 1
+a.sfattr.list[1].parent_ino = 8388736
+a.sfattr.list[1].parent_gen = 1161632072
+a.sfattr.list[1].parent_namehash = 0x9a01678c
+a.sfattr.list[1].parent_name = "config.sys"
+----
+
+In this example, +/a+ and +/b+ are subdirectories of the root.  A regular file
+is hardlinked into both subdirectories, under different names.  Directory +/a+
+is inode 131 and has an entry +autoexec.bat+ pointing to the child file.
+Directory +/b+ is inode 8388736 and has an entry +config.sys+ pointing to the
+same child file.
+
+Within the child file, notice that there are two parent pointers in the
+extended attribute structure.  The first parent pointer tells us that directory
+inode 131 should have an entry +autoexec.bat+ pointing down to the child; the
+second parent pointer tells us that directory inode 8388736 should have an
+entry +config.sys+ pointing down to the child.  Note that the name hashes are
+the same between each directory entry and its parent pointer.
+
 == Key Differences Between Directories and Extended Attributes
 
 Directories and extended attributes share the function of mapping names to

