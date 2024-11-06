Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FB7209F30
	for <linux-xfs@vger.kernel.org>; Wed,  6 Nov 2024 19:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920768; cv=none; b=q9JmIP8vHqvbscMlSGr7siA7E8b7Lpn+4AMdXQxoqJ+48bRextFl7btPDjKYCDxO9rG++jijyyP1QQuX/vuCt1IMarck58E0Yb26rhVJC+pSqN5+JtjctKqJRpLhQs+49siXxGuTiJ8FYXMSQUBZfuHtiSDWF61kfGCZXF2wnvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920768; c=relaxed/simple;
	bh=9kfW7BfX3FdAXkVGFEXR5iCW8wddquKx2RWw/VzvHL0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jXuUsgiUbBFaE66XUqUOeZOhAu3ltXedLtoI4ByvM77Rm7VpZSFmKYi4qzhP14GQyZZn0VweWpb02ah/V1UGFzmzpQdo66K/rIl/fS5RiZADpWrBRs6xZh6CMMpiWHmZJj8WZQSaO9F0RlMv335rwFHBQTNDh/t5q9F1BUjNWIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O0gUYqM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0gUYqM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34884C4CEC6;
	Wed,  6 Nov 2024 19:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730920766;
	bh=9kfW7BfX3FdAXkVGFEXR5iCW8wddquKx2RWw/VzvHL0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O0gUYqM8MQgA9gKPIxvB9gewT+VuGWtMh+8KiSZEyGqghWw7aXCkd3tgUsf+FWolR
	 rcoqqjbIDHGQvL5J8dkDKpFZAXO21NIcF0lCNmqXWQ2jxfjCbA+EYZz0J3WGRXnsUu
	 vGEIHS3fFUQL7VYZaB3/OmwFSOK1XC3QUFr+8wLYjD1wWWEbd0tVq5efUlYl3tx5tS
	 iIhP9IifHm+lv/GPCC6+/RzzPOREAywiKW8V9ZnXhJWRH5vfTsN/memcFPMRlbRXj9
	 1b0A+XjJvtL1p1NseD5S778s1oLTLaUGEfmJT7T25vrzhiK5pbPPUMeQadvswmwKY0
	 YAYH3mCDJFedg==
Date: Wed, 06 Nov 2024 11:19:25 -0800
Subject: [PATCH 3/4] design: document metadata directory tree quota changes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173092059744.2883258.7281058243421376662.stgit@frogsfrogsfrogs>
In-Reply-To: <173092059696.2883258.7093773656482973762.stgit@frogsfrogsfrogs>
References: <173092059696.2883258.7093773656482973762.stgit@frogsfrogsfrogs>
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
---
 .../allocation_groups.asciidoc                     |    3 +++
 .../internal_inodes.asciidoc                       |    3 +++
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    3 +++
 3 files changed, 9 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 9f92be49a7a095..86daf9cdd30a0c 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -293,6 +293,9 @@ Quota flags. It can be a combination of the following flags:
 | +XFS_PQUOTA_CHKD+		| Project quotas have been checked.
 |=====
 
+If the +XFS_SB_FEAT_INCOMPAT_METADIR+ feature is enabled, the +sb_qflags+ field
+will persist across mounts if no quota mount options are provided.
+
 *sb_flags*::
 Miscellaneous flags.
 
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

