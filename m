Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761801DA21
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224699; cv=none; b=YQR+UwiCy7yMOWaxI6d0VvZFdfviTGcrUUsfnBIAneXkGSnzcknbtPQ60D1w+Er3YKrjwuZg5ZQXbKvZsSyHGa/6EU+uLa68Vkim+EzyVldpZTDt1Q32a6l939qkdxIvazuCMiywLTL7u1FUvGsUQXj7FRMrrZls5jl1KC7scRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224699; c=relaxed/simple;
	bh=hIYGTMyO0xEBWcCHAx5a68P3A5bqf7KqJHJhQuYoDpQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tkBFRuNShBBu852ypQB6s0VGkvB2gGeoXpm+78upPlGVL6GmMuUjrlslfn5BbsGCpqE/x8QYkNh2/qXMSaiBFr1TfPDk0GIjBOJrHe0xhpfxE0jL/mrTOo+Yu/0yedFPpdRKMbtdaZWzQ+R71E4rS4iH1RoS0eNtoGEF8Eo0mNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnlZDqPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnlZDqPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7D4C32783;
	Mon, 15 Apr 2024 23:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224699;
	bh=hIYGTMyO0xEBWcCHAx5a68P3A5bqf7KqJHJhQuYoDpQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gnlZDqPfPnIg0WiCk2IUZw4F1dkee9nPfNn1fiTP9j8Dip9VHf1wKydeL+oKqNj0p
	 vSelATb1s2YMuE3K0nZNOnL1UtV80it+5CfCsbkGCmV/b69wUeHO6D9BeoVHAgEN+o
	 fuMfh58idmoFbzCg++ZQcYHAyhvmtpuGU/FN7NX7lQ5gvRQ2bW6Yi20J7E+Sy8si7u
	 o9bZdCHl/oKG/4sw42aJHygDS2f7HCtwl/ichOR98GJykpLOvygigB3WVoG3Mn9+AD
	 C219BiU7Tez/Bw4JpEV13C/ev4jZd9wObedkD5/aUR+taEQKv6zJyuEsFBj+Vod3y7
	 P/8yDC/n/SSJQ==
Date: Mon, 15 Apr 2024 16:44:58 -0700
Subject: [PATCH 1/4] xfs: hide private inodes from bulkstat and handle
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171322381807.87900.7591580168149492444.stgit@frogsfrogsfrogs>
In-Reply-To: <171322381780.87900.770231063979470318.stgit@frogsfrogsfrogs>
References: <171322381780.87900.770231063979470318.stgit@frogsfrogsfrogs>
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
to open these files by handle.

To prevent users from ever finding the file or mis-interactions with the
security apparatus, set S_PRIVATE on the inode.  Don't allow bulkstat,
open-by-handle, or linking of S_PRIVATE files into the directory tree.
This should keep private inodes actually private.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_export.c |    2 +-
 fs/xfs/xfs_iops.c   |    3 +++
 fs/xfs/xfs_itable.c |    8 ++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 7cd09c3a82cb..4b03221351c0 100644
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
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 55ed2d1023d6..7f0c840f0fd2 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -365,6 +365,9 @@ xfs_vn_link(
 	if (unlikely(error))
 		return error;
 
+	if (IS_PRIVATE(inode))
+		return -EPERM;
+
 	error = xfs_link(XFS_I(dir), XFS_I(inode), &name);
 	if (unlikely(error))
 		return error;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 95fc31b9f87d..c0757ab99495 100644
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

