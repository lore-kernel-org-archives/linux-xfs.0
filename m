Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBFA200C7
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504621; cv=none; b=grAr2e6uT8wA+BzMQKN3Cw2NlNEnCWZsZjwhwm0HJlUsh4CBWIGO2bWqAOEoc0fVaQIkcM/89ruIRj/RVE/h+gd2g5wt54Vy0ht9wjr1Xa5uZtRjsaj12Dz0/9K2729YJnTkeAsY8eYeAdpyn+aiY/rPLHoQU/IVpB+82dp2ads=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504621; c=relaxed/simple;
	bh=0Q+RBJMbNt+S7XvCuiJvXQTHKJzBvEousT48+U3R4wY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W1ty7x1QoSQUoIiAnuQ0Wv/dm8gSzXTc9t52h4u1c6yp5fyssjzUahSm4Rc8mQoV8LXcuDYZWvC4VlrK89DJhPFfZ58wophowvo6h04yNzEOUXtCarTxuc4aFaTPfB9SV/6Hmtd+zM3CKbV+C9DfAXVFEGz8dCA8WUEgBFusxwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2z5JG3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2z5JG3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C239C433C7;
	Wed, 27 Mar 2024 01:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504621;
	bh=0Q+RBJMbNt+S7XvCuiJvXQTHKJzBvEousT48+U3R4wY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l2z5JG3tcL3bd5XpOgCZMfZyc3hpMMddoEQAaNIWH8z7Tcq6CCEtTmZPo9B7KvQLB
	 X0vlQH7bjn9Owjv7IRNldal0qBEOF2ihPS5YlVbIRhIIZyjbe4K68omGsKB1WvXZNJ
	 gbj9KDq8KATCrq3MtX+RsXFjfCaaCLoqZz2aavw2j6f2Oe/5OGGaTDZcnXwVMB+PwF
	 3CF+3CgKu/7xZyTdktQiahLuEZuMAnCiZRKoFClPVZrRdLC9lXPadLqeVdmPm1LsCr
	 AkPE0OapbDkHVfmMbS9aDqt5ys1A5OqxFRkmWYmctjfuXvK338cn+HH0QQurQAIIgf
	 fvbOmomDF+h/w==
Date: Tue, 26 Mar 2024 18:57:00 -0700
Subject: [PATCH 1/4] xfs: hide private inodes from bulkstat and handle
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171150381270.3217090.1064500138522339556.stgit@frogsfrogsfrogs>
In-Reply-To: <171150381244.3217090.9947909454314511808.stgit@frogsfrogsfrogs>
References: <171150381244.3217090.9947909454314511808.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/xfs_export.c |    2 +-
 fs/xfs/xfs_iops.c   |    3 +++
 fs/xfs/xfs_itable.c |    8 ++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)


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
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 55ed2d1023d67..7f0c840f0fd2f 100644
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
index 95fc31b9f87d6..c0757ab994957 100644
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

