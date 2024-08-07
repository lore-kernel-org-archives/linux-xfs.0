Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0C9144D11
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 19:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723058081; cv=none; b=JKRn1WaNajHjQgFJZvC2TGGvJGexELmb8bsYUJX6sFphYLGdqcG7GoPs/dhyPfBJvVZm/q+hsSIWP/8UjbH91pe4M5WfhJaLK5hmCW46CCXlQRL0N1aseB+QsSbg67bTqCk/tQn4GhHV/lwspSfygDSizl1TVq1SMXkKK3AXDqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723058081; c=relaxed/simple;
	bh=OXw/5vWLjPeoPYWIx+/x9r8jow5ET0ubh6Dxl+/5U1E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ask5MI9Z32BNcb2iq4zDQpEmzg84oEOtMVo7wSBdv0HPZEmIup+1wMaqVIGiNeIEW70C9cnzOntkj/99Atj48SLEHDCokfb7LC+IMjmzRlVI+rgQFiBJcpmMtVz9iDt4gdyd8eMvp/pzteC7XQagUnXv4SxLJ+tcOS50d1zrsrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EwYGD62J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EwYGD62J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1D1C32781;
	Wed,  7 Aug 2024 19:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723058081;
	bh=OXw/5vWLjPeoPYWIx+/x9r8jow5ET0ubh6Dxl+/5U1E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EwYGD62JBAUc3v5vdAZeejpGZ40p6Qizs/aQgb9tfefaT1aD70eL++NJXXTUHzBKV
	 QZR6r8qx6fX1ITydDfp87eRzK0ZzekbILNMuotnic9UgeQFD9QWMAIRMe/7/1TXr73
	 iZ+FTToXNsblO4GfazQ4cJrxeqQ3sgqmIIn2wOmWldmISaOPhI/hzG9vG+DVtSgkQI
	 wAalK1gcMMXyOOGem2Vv+RTILch78hBZnPkiInXbMmYcEwYed2eiF1Qfx80OLG7VKw
	 aH4UvRZ/+s3ovp2E0BPlohY1LBRLYff6bboW24Orek37Ce/m3vifwCIUrtStDoIjQ1
	 HX3L49hnc//Og==
Date: Wed, 07 Aug 2024 12:14:40 -0700
Subject: [PATCH 3/5] design: document the parent pointer ondisk format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172305794133.969463.2869086475470560475.stgit@frogsfrogsfrogs>
In-Reply-To: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs>
References: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs>
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
 .../extended_attributes.asciidoc                   |   95 ++++++++++++++++++++
 2 files changed, 99 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index e22c7344..d7fd63ea 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -468,6 +468,10 @@ flag has user-visible impacts, which is why it is a permanent incompat flag.
 See the section about xref:XMI_Log_Item[mapping exchange log intents] for more
 information.
 
+| +XFS_SB_FEAT_INCOMPAT_PARENT+ |
+Directory parent pointers.  See the section about xref:Parent_Pointers[parent
+pointers] for more information.
+
 |=====
 
 *sb_features_log_incompat*::
diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
index 19bff70f..4000c002 100644
--- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
+++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
@@ -90,6 +90,7 @@ A combination of the following:
 | +XFS_ATTR_SECURE+		| The attribute's namespace is ``secure''.
 | +XFS_ATTR_INCOMPLETE+		| This attribute is being modified.
 | +XFS_ATTR_LOCAL+		| The attribute value is contained within this block.
+| +XFS_ATTR_PARENT+		| This attribute is a parent pointer.
 |=====
 
 .Short form attribute layout
@@ -911,6 +912,100 @@ Log sequence number of the last write to this block.
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
+Parent pointers are stored in the private ATTR_PARENT namespace within the
+extended attribute structure.  Attribute names in this namespace use a custom
+hash function, which is defined as the dirent name hash of the dirent name XORd
+with the upper and lower 32 bits of the parent inumber.  This hash function
+reduces collisions if the same file is hard linked into multiple directories
+under identical names.
+
+The attribute name contains the dirent name in
+the parent, and the attribute value contains a file handle to the parent
+directory:
+
+[source, c]
+----
+struct xfs_parent_rec {
+	__be64	p_ino;
+	__be32	p_gen;
+};
+----
+
+*p_ino*::
+Inode number of the parent directory.
+
+*p_gen*::
+Generation number of the parent directory.
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
+8          16777344           directory      0x0000002e   1 . (good)
+10         128                directory      0x0000172e   2 .. (good)
+15         132                regular        0x9a01678c  10 config.sys (good)
+xfs_db> path /b/config.sys
+xfs_db> p a
+a.sfattr.hdr.totsize = 56
+a.sfattr.hdr.count = 2
+a.sfattr.list[0].namelen = 12
+a.sfattr.list[0].valuelen = 12
+a.sfattr.list[0].root = 0
+a.sfattr.list[0].secure = 0
+a.sfattr.list[0].parent = 1
+a.sfattr.list[0].name = "autoexec.bat"
+a.sfattr.list[0].parent_dir.inumber = 131
+a.sfattr.list[0].parent_dir.gen = 3204669414
+a.sfattr.list[1].namelen = 10
+a.sfattr.list[1].valuelen = 12
+a.sfattr.list[1].root = 0
+a.sfattr.list[1].secure = 0
+a.sfattr.list[1].parent = 1
+a.sfattr.list[1].name = "config.sys"
+a.sfattr.list[1].parent_dir.inumber = 16777344
+a.sfattr.list[1].parent_dir.gen = 4137450876
+
+----
+
+In this example, +/a+ and +/b+ are subdirectories of the root.  A regular file
+is hardlinked into both subdirectories, under different names.  Directory +/a+
+is inode 131 and has an entry +autoexec.bat+ pointing to the child file.
+Directory +/b+ is inode 16777344 and has an entry +config.sys+ pointing to the
+same child file.
+
+Within the child file, notice that there are two parent pointers in the
+extended attribute structure.  The first parent pointer tells us that directory
+inode 131 should have an entry +autoexec.bat+ pointing down to the child; the
+second parent pointer tells us that directory inode 16777344 should have an
+entry +config.sys+ pointing down to the child.
+
 == Key Differences Between Directories and Extended Attributes
 
 Directories and extended attributes share the function of mapping names to

