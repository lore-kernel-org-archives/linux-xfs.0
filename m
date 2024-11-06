Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AAC209694
	for <linux-xfs@vger.kernel.org>; Wed,  6 Nov 2024 19:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920703; cv=none; b=DC4W7igs+Wrxk34x1pnFfvR2xg+7XGJykKZIagRhV3UbS2tE8i9xWwL4hzFSFCkuzk3IzpoiPqAUxKvF+IQfF3cUJKetnTJqO4kRzK7OOzINse4KQomlqb2P4lJx3GdaQXpwXr4mgDSFwR9mwPbPfje/Wp4aw1nUjZukrs0mXLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920703; c=relaxed/simple;
	bh=QfWgaMCz0LkaNInvHysiyVlXtI0toczKpW2azobsgXA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IqF0vbA5E+tVs9TUVheBxN7fjIOadKJi0pnRE2ywW4LWixQMb9DnLLmMBAZZN7pNVxAKh3WMmhlir5YnQACVK3fmV2f5aJ8pkFR7nfO7TB8i1n3PHbFIUohPiOINabkZpcK6UB2zG1rIjAehMZjHkNEMLZQE3bWb4DkWGJv1uio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LBAIgmRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LBAIgmRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C922C4CEC6;
	Wed,  6 Nov 2024 19:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730920703;
	bh=QfWgaMCz0LkaNInvHysiyVlXtI0toczKpW2azobsgXA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LBAIgmRCHjFDmmCBM4ZIB0niXXG+RSc12zVLy8RXRyvLQ5es0GYKNcUngCObd8GZf
	 rHxiMTey9pVQMdgnPKIP0coS7UaQmAss8QcB90qJjCCY9rG7DKH/8GTAs7LVatLa0U
	 84HLj1zw9Sg2w1QcCgYph0ROMaPqWUj6Js+dALVRfhF7DCrTiIsLW5KMtcLYGcAY7d
	 pUAG3PJtHGtfbFVbGGCAE27A577RvGLFgufk487JL5wwvjQMu4qXOiZ6KI6KWaVkSt
	 TV5XHUbCJHF2tjHl8oMZ/JwcWoJVQrZ9sXBW0T5jcvfAGgMHsO28I6Fz95wqHGMrGt
	 5pqjx0kUbMpGg==
Date: Wed, 06 Nov 2024 11:18:22 -0800
Subject: [PATCH 2/2] design: document filesystem properties
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173092058966.2883036.11288763605027275979.stgit@frogsfrogsfrogs>
In-Reply-To: <173092058936.2883036.6877146378997138277.stgit@frogsfrogsfrogs>
References: <173092058936.2883036.6877146378997138277.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that xfsprogs utilities can set properties to coordinate the
behavior of other xfsprogs utilities, record them in the ondisk format
documentation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../fs_properties.asciidoc                         |   28 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    2 +
 2 files changed, 30 insertions(+)
 create mode 100644 design/XFS_Filesystem_Structure/fs_properties.asciidoc


diff --git a/design/XFS_Filesystem_Structure/fs_properties.asciidoc b/design/XFS_Filesystem_Structure/fs_properties.asciidoc
new file mode 100644
index 00000000000000..b639aec9ab6366
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/fs_properties.asciidoc
@@ -0,0 +1,28 @@
+[[Filesystem_Properties]]
+= Filesystem Properties
+
+System administrators can set filesystem-wide properties to coordinate the
+behavior of userspace XFS administration tools.  These properties are recorded
+as extended attributes of the +ATTR_ROOT+ namesace that are set on the root
+directory.
+
+[options="header"]
+|=====
+| Property			| Description
+| +xfs:autofsck+		| Online fsck background scanning behavior
+|=====
+
+*xfs:autofsck*::
+This property controls the behavior of background online fsck.
+Unrecognized values are treated as if the property was not set.
+Check the +xfs_scrub+ manual page for more information.
+
+.autofsck property values
+[options="header"]
+|=====
+| Value				| Description
+| +none+			| Do not perform background scans.
+| +check+			| Only check metadata.
+| +optimize+			| Check and optimize metadata.
+| +repair+			| Check, repair, or optimize metadata.
+|=====
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index a95a5806172a0c..689e2a874c13e9 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -84,6 +84,8 @@ include::journaling_log.asciidoc[]
 
 include::internal_inodes.asciidoc[]
 
+include::fs_properties.asciidoc[]
+
 :leveloffset: 0
 
 Dynamically Allocated Structures

