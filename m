Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF673218923
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 23:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731022009; cv=none; b=k7RYDSiGp4WejOe0TBjCYZuoRPrZK5ebZGF1NfLC3x4+SF/yfcH467HEKahv/yvPiuEztwAeSKzE+f1JNdT2QsDpnjQD4clpVEEPc47WEQe5RCfquj9h8A+tTgRTp5AqFZ/fNkBSniyhFR2foeSJvJw4OOu/0XZgi0+AZA1CbLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731022009; c=relaxed/simple;
	bh=HCPwrhHbI/IW77jVQby1kjgx4Qypa1mZnclvIJS0KXg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tJNDhuMQxB+3R1JzY4iEHbunV4Pz5xPEcB9qpxjy/vLwJ5c4HM1Fhr0cxxhS8/3P3KHftqoLGWKBIXQLwy/CE5LlGe7ieKSd/qlJ6U8A0dPSp1FsdD85tC4dMIiILEzX99DR9ZSivqYv5WLWpNvAwMmIpLlH+Nw+le5BPpUpBn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AkNXfExP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AkNXfExP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC80C4CECC;
	Thu,  7 Nov 2024 23:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731022009;
	bh=HCPwrhHbI/IW77jVQby1kjgx4Qypa1mZnclvIJS0KXg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AkNXfExPC7nIa98ZSelCV8YNFrMJnWDV2K0orzC8NDq/OMBJTNakz7+3gVEcap36m
	 EZcLv9OKTlm2wTpDKWTrhazN+PApN5lFpr697nrzzAQHS7Nh5YMTTTlx8K4PI0Es6Z
	 196Whi8dNcQ+IaW4s48t3xq1ig2UJgDRDvlx3x3K3DsnclYqfttdypnvCcgsUCsIFG
	 HXLazLgcLJyoy5NyIMc4PCsfrh6//XMnbCCKcPu5qdN3Fy8DECXtAwqtkd2m8IHm7m
	 896w+oza3PtnlxBh+YsLaK0hv1p0BTTxLi/0i4gSS5FYSQh/vAZlZZXpsLyOLTUCo6
	 06oi5Hr/1lhtQ==
Date: Thu, 07 Nov 2024 15:26:48 -0800
Subject: [PATCH 3/4] design: document metadata directory tree quota changes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173102187918.4143993.5564766739701924424.stgit@frogsfrogsfrogs>
In-Reply-To: <173102187871.4143993.7808162081973053540.stgit@frogsfrogsfrogs>
References: <173102187871.4143993.7808162081973053540.stgit@frogsfrogsfrogs>
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
 

