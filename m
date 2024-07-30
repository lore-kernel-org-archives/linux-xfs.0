Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442EA8C11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302942; cv=none; b=UwBNYAehfuPNBqdUSztxda/6xuGfB5B4Nqx7np6h4nwLc0Uqimhk9AwQRojEMJryK5tX5h0wsBDdpIKDbjI014N0cL/MYMYWpf6uK/vuIe7toPn4A8WGriHnZzQGBlbeYv+fQbkocYloV5/WdMwzj5lLEddiAt31VQratY3Hf8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302942; c=relaxed/simple;
	bh=bUzoM8JcwN/EyEtCWav//TsriJ/r/TX3NIO3Cd03KDU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OS+yVTRTR69fVEa0o6vu9eJt6bVT2OJoJm0caU4CpePOp2PL8/XPXW/Cf8YM2j/D6AhZ899xKioAZ0KnBR0wOz1/SpKEd6knTvQFjpq2X46VXAfiusjq4Xb9vfBTMkgnIQ4B7ctGgOu3vTOS7MrOOZkKt0Oa0dV9tGGNutZk/qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XujjVqIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XujjVqIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A0AC32786;
	Tue, 30 Jul 2024 01:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302941;
	bh=bUzoM8JcwN/EyEtCWav//TsriJ/r/TX3NIO3Cd03KDU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XujjVqINc/EfUmm9Z+GiYJf27PAh6rParNhZu0x/4l5BQS4YOJKnkhmKVewQqGrLD
	 xlz8XBg3crg6HH/ZzDDKZvrGXlacFSImTF61cqrKHoTlDPQBAOOBJOMyK7NWlkLeCn
	 eW5ObAQSpQbh511AdnzCp3yrh2hzZkA8rMayzTye0pxZsOhOx36Xw/3Hdb+2MhbI6J
	 9OQd7x05V9su9lo65Naayhp4Yuki0rP0eMoJgbEajbiMUw4UCo6bQ+9vbr04RF9cJy
	 jl/mLrsl31nyce05JT6viZAqButCL91VzGMHSOvBliC2DbRd/AGCJDSufbPWx0K2mk
	 MNww5G6rct8ow==
Date: Mon, 29 Jul 2024 18:29:01 -0700
Subject: [PATCH 1/5] libfrog: add directory tree structure scrubber to scrub
 library
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229851982.1353015.10476795952994317131.stgit@frogsfrogsfrogs>
In-Reply-To: <172229851966.1353015.1969020594980513131.stgit@frogsfrogsfrogs>
References: <172229851966.1353015.1969020594980513131.stgit@frogsfrogsfrogs>
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

Make it so that scrub clients can detect corruptions within the
directory tree structure itself.  Update the documentation for the scrub
ioctl to mention this new functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/scrub.c                     |    5 +++++
 man/man2/ioctl_xfs_scrub_metadata.2 |   14 ++++++++++++++
 2 files changed, 19 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index baaa4b4d9..a2146e228 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -149,6 +149,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "retained health records",
 		.group	= XFROG_SCRUB_GROUP_NONE,
 	},
+	[XFS_SCRUB_TYPE_DIRTREE] = {
+		.name	= "dirtree",
+		.descr	= "directory tree structure",
+		.group	= XFROG_SCRUB_GROUP_INODE,
+	},
 };
 #undef DEP
 
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 75ae52bb5..44aa139b2 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -148,6 +148,20 @@ that points back to the subdirectory.
 The inode to examine can be specified in the same manner as
 .BR XFS_SCRUB_TYPE_INODE "."
 
+.TP
+.B XFS_SCRUB_TYPE_DIRTREE
+This scrubber looks for problems in the directory tree structure such as loops
+and directories accessible through more than one path.
+Problems are detected by walking parent pointers upwards towards the root.
+Loops are detected by comparing the parent directory at each step against the
+directories already examined.
+Directories with multiple paths are detected by counting the parent pointers
+attached to a directory.
+Non-directories do not have links pointing away from the directory tree root
+and can be skipped.
+The directory to examine can be specified in the same manner as
+.BR XFS_SCRUB_TYPE_INODE "."
+
 .TP
 .B XFS_SCRUB_TYPE_SYMLINK
 Examine the target of a symbolic link for obvious pathname problems.

