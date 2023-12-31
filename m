Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B22F9C4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u9b4C8qz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF41EC433C7;
	Sun, 31 Dec 2023 20:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054661;
	bh=JHzyb1F/dLoLvbfZVwWpWbSRSQ4Hw3QpGir02FOv1vo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u9b4C8qzQYrq7grpaLJmXuaKdUOeItBS9VPPeP/In/yUvjou7JrEaOcRb6Dy1bl1+
	 jytKRAYv40A31j6AOn90ls64MNa5DxlCqoKu8n92WskluSldnTxB0YxKd4TBOltAfr
	 Vx6Az4M26w2bbJat7cHBmwo9KMgHBsaxXvE1fqDL66E/6BW/OpoqAAPf2YjN17ceoZ
	 AqhUBr7eUoQvcoqRj1RMW2rJy+CN7P/tGkBeyp01KbWcz6wCIBPQ+xzHq3XohvuEK+
	 z8Jb3f1kDN0W2ALOo2fe5CQ0Cxhu6jsP6yaSuAcBXQryjiv1/PRhEd0Q/mCgm9WTsv
	 x76rsjN9erQkA==
Date: Sun, 31 Dec 2023 12:31:01 -0800
Subject: [PATCH 1/4] xfs: hide private inodes from bulkstat and handle
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833883.1752674.17498571281575427642.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833858.1752674.247392515267008994.stgit@frogsfrogsfrogs>
References: <170404833858.1752674.247392515267008994.stgit@frogsfrogsfrogs>
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

We're about to start adding functionality that uses internal inodes that
are private to XFS.  What this means is that userspace should never be
able to access any information about these files, and should not be able
to open these files by handle.  Callers are not allowed to link these
files into the directory tree, which should suffice to make these
private inodes actually private.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_export.c |    2 +-
 fs/xfs/xfs_itable.c |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 7cd09c3a82cb5..4b03221351c0f 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -160,7 +160,7 @@ xfs_nfs_get_inode(
 		}
 	}
 
-	if (VFS_I(ip)->i_generation != generation) {
+	if (VFS_I(ip)->i_generation != generation || IS_PRIVATE(VFS_I(ip))) {
 		xfs_irele(ip);
 		return ERR_PTR(-ESTALE);
 	}
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 14462614fcc8d..4610660f267e6 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -97,6 +97,14 @@ xfs_bulkstat_one_int(
 	vfsuid = i_uid_into_vfsuid(idmap, inode);
 	vfsgid = i_gid_into_vfsgid(idmap, inode);
 
+	/* If this is a private inode, don't leak its details to userspace. */
+	if (IS_PRIVATE(inode)) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		xfs_irele(ip);
+		error = -EINVAL;
+		goto out_advance;
+	}
+
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */

