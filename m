Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDA4C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l97yP97y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E363CC433C7;
	Sun, 31 Dec 2023 23:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064719;
	bh=t8z4aU5BY9zzwEaSSbnEsTYMkLWykRneMq7u0qgtBik=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l97yP97yyPrhx9Nb29Mz2sQTYxsq2CmSqQ1b5/mSqIenqtJJY05OHkdMtASr8mD/B
	 /mt+CvgU+Dyj67IpCu5rg2FQ8WEg71FvD6NeKzIkxjCB5kCk7q16N6duJvN42KsgT8
	 g4jMi6QLkTkNCOkgF2qiUhGBpuG61tKmssC7EoEgJG9qWg34HaVHshscH4hpGFl9eY
	 exR84zuqGypA8tLrx0AtvG42CyLni02DyFFaQyKNTZaVIK2CDNnCcUZUQ5BqYLGXV8
	 oHzHugLrj7HVNpJif2jRNSB4VJkepCpG67Q+JjXFQQeaFg8M1XMLhaM3dGQj2VPaLa
	 einEuzBfStBVg==
Date: Sun, 31 Dec 2023 15:18:39 -0800
Subject: [PATCH 2/6] xfs: teach online scrub to find directory tree structure
 problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007459.1805996.13319683096140892679.stgit@frogsfrogsfrogs>
In-Reply-To: <170405007429.1805996.15935827855068032438.stgit@frogsfrogsfrogs>
References: <170405007429.1805996.15935827855068032438.stgit@frogsfrogsfrogs>
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

Create a new scrubber that detects corruptions within the directory tree
structure itself.  It can detect directories with multiple parents;
loops within the directory tree; and directory loops not accessible from
the root.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c                     |    5 +++++
 libxfs/xfs_fs.h                     |    3 ++-
 man/man2/ioctl_xfs_scrub_metadata.2 |   14 ++++++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index baaa4b4d940..a2146e228f5 100644
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
 
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index efa68a2d82a..48f38694f12 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -719,9 +719,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
+#define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	28
+#define XFS_SCRUB_TYPE_NR	29
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 75ae52bb584..44aa139b297 100644
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

