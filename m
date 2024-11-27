Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CC22907
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732666808; cv=none; b=I87W/B+q4Bj1SMgvt5PNpyGvhwOGdB6RmQf3dhwF8Ovc9wQjxqauoTs1Q/iTr4x+lvXgsel2dCMCh1LlwwILJqs8q3thZhDzGMw147u7lIy9oBX+1eE1a8ACVeGiNwCOnhpBve9C6y7RIOtvx6Y67dog9yJHBuvkTgM28ertf0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732666808; c=relaxed/simple;
	bh=HCPwrhHbI/IW77jVQby1kjgx4Qypa1mZnclvIJS0KXg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NArrpu0BlcrHQ06OsCVfuCGwVSiF0XtBNi9iFRNPx02Ag6irtTgMCuprereWBgjUpVPhx902K1kRKvoF4l/LxvrvqXJAf8AxWZToPVEX+TG3SR4eb26e5nNGqq2tBarwtLSiA5+aDkk9DBWP5C4s5TKh0vEpOdLP10KuVis122Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SiVqnRxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SiVqnRxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23B1C4CECF;
	Wed, 27 Nov 2024 00:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732666808;
	bh=HCPwrhHbI/IW77jVQby1kjgx4Qypa1mZnclvIJS0KXg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SiVqnRxtwS9875z6ahGNVJoQUMPJH/Qcq3aLuz0TnuLfZrOVYWreyWU5Og7Dlmydp
	 Ynqld1UTPaGo5MYVz7bO66I+RuBXlsf3nCegRbr0WDafuhtaDfPfKoXpafkbRdR/5g
	 oP3jQQTC/pNFLk2Ivgd/Q9lbZfIojmODUhPrp9A7GXZmAXEugwHRhDjBUtgjFwRRC7
	 jdmh9ibzacKmfHP6+y1zAV3HAJPtJjV4S6JutMJmHz0PuZNlntDx8ZNScYu/uIFEYz
	 GmtwiF/ctXduX9OcjgxXAmYJivBBI1nqqs6aNQu5TaghDXbnBqurCWs0TCIzbP+qwy
	 g7QOfOoPAWTKA==
Date: Tue, 26 Nov 2024 16:20:07 -0800
Subject: [PATCH 08/10] design: document metadata directory tree quota changes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173266662329.996198.2989351246297986467.stgit@frogsfrogsfrogs>
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

Document the changes to the ondisk quota metadata that came in with
metadata directory trees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 .../internal_inodes.asciidoc                       |    3 +++
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    3 +++
 .../XFS_Filesystem_Structure/superblock.asciidoc   |    3 +++
 3 files changed, 9 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index 5f4d62201cbd67..40eb57233ce7c0 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -21,6 +21,9 @@ of those inodes have been deallocated and may be reused by future features.
 [options="header"]
 |=====
 | Metadata File                                  | Location
+| xref:Quota_Inodes[User Quota]                  | /quota/user
+| xref:Quota_Inodes[Group Quota]                 | /quota/group
+| xref:Quota_Inodes[Project Quota]               | /quota/project
 | xref:Real-Time_Bitmap_Inode[Realtime Bitmap]   | /rtgroups/*.bitmap
 | xref:Real-Time_Summary_Inode[Realtime Summary] | /rtgroups/*.summary
 |=====
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index e28929907147b7..6e52e5fd3d6c1e 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -199,6 +199,9 @@ directory tree.
 [source, c]
 ----
 enum xfs_metafile_type {
+     XFS_METAFILE_USRQUOTA,
+     XFS_METAFILE_GRPQUOTA,
+     XFS_METAFILE_PRJQUOTA,
      XFS_METAFILE_RTBITMAP,
      XFS_METAFILE_RTSUMMARY,
 };
diff --git a/design/XFS_Filesystem_Structure/superblock.asciidoc b/design/XFS_Filesystem_Structure/superblock.asciidoc
index bffb1659d0ba38..f0455304635737 100644
--- a/design/XFS_Filesystem_Structure/superblock.asciidoc
+++ b/design/XFS_Filesystem_Structure/superblock.asciidoc
@@ -259,6 +259,9 @@ Quota flags. It can be a combination of the following flags:
 | +XFS_PQUOTA_CHKD+		| Project quotas have been checked.
 |=====
 
+If the +XFS_SB_FEAT_INCOMPAT_METADIR+ feature is enabled, the +sb_qflags+ field
+will persist across mounts if no quota mount options are provided.
+
 *sb_flags*::
 Miscellaneous flags.
 

