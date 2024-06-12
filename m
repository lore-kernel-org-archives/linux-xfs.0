Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4F71CD38
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 17:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718214455; cv=none; b=DCDx10oVgpKZbiGqZ3RO4Fwv0MSdQDZo6RqCuWm38uvRFLxCxstk4L+w+mvtP5VIwASncc97Go6Cn7LKbriYO/viN0eXQK+kML0kgx9ZnFDMOlq44iMSQnNQCULUSAbm1TAt6qWlJ0Zs0qz5pT51ADqEGnsIwTTXne1dxqpX8RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718214455; c=relaxed/simple;
	bh=pEpJHPi7lZqBL/ylH2TPITQI2eV2Ar/z89opG8SCOcM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mu+X/SezbNE95MRg/ZzL+hPiXwJTzZ8XYaDsado66fi0HnZDuj/cvQLBMjol/x309lfEfofNQGTf9RcLoNm9wkQZ9s+ooS/zFCD8CYIx5aK8tOWmeDY9gYheAJdSfua3Hdr0CvViApbSqrMfG4GZf5TR3zhpD5esr6j7LljPdnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsxZiU6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsxZiU6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D28C116B1;
	Wed, 12 Jun 2024 17:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718214455;
	bh=pEpJHPi7lZqBL/ylH2TPITQI2eV2Ar/z89opG8SCOcM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XsxZiU6gT3lSz7UvXSNKce9ZDqGCLGu2v+wcFt0D2tPwSImTc8+kUX21Ij8IqillH
	 lYZoNVPQb1yFdDF6Oajl5+PnEeq2FK2OWCqIf5gAOB1I533ger0aeOmCXobVqFvvJH
	 veaePULUjTwFYfrzi5gu3HVSi6xvUssvO6PfZ+eakQU8LqQ2FOVX5dxxcPiCkUhPRX
	 dGpAJxkJyo9J9FjgkngMTHAc2Sr55FPua6KuBVmNz20jjcnEoxplSG7fdNSpfX4Kvm
	 +qpS8EQAn24O8gKrHjIbJdvdM85rYPcALpMl9HBBV1aH8AVVSTR43LKgeTvLP0h2b+
	 EWbdFnDXkn2tA==
Date: Wed, 12 Jun 2024 10:47:35 -0700
Subject: [PATCH 4/5] xfs: allow unlinked symlinks and dirs with zero size
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171821431829.3202459.12883328416929434536.stgit@frogsfrogsfrogs>
In-Reply-To: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
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

For a very very long time, inode inactivation has set the inode size to
zero before unmapping the extents associated with the data fork.
Unfortunately, commit 3c6f46eacd876 changed the inode verifier to
prohibit zero-length symlinks and directories.  If an inode happens to
get logged in this state and the system crashes before freeing the
inode, log recovery will also fail on the broken inode.

Therefore, allow zero-size symlinks and directories as long as the link
count is zero; nobody will be able to open these files by handle so
there isn't any risk of data exposure.

Fixes: 3c6f46eacd876 ("xfs: sanity check directory inode di_size")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index e7a7bfbe75b4..513b50da6215 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -379,10 +379,13 @@ xfs_dinode_verify_fork(
 		/*
 		 * A directory small enough to fit in the inode must be stored
 		 * in local format.  The directory sf <-> extents conversion
-		 * code updates the directory size accordingly.
+		 * code updates the directory size accordingly.  Directories
+		 * being truncated have zero size and are not subject to this
+		 * check.
 		 */
 		if (S_ISDIR(mode)) {
-			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			if (dip->di_size &&
+			    be64_to_cpu(dip->di_size) <= fork_size &&
 			    fork_format != XFS_DINODE_FMT_LOCAL)
 				return __this_address;
 		}
@@ -528,9 +531,19 @@ xfs_dinode_verify(
 	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
 		return __this_address;
 
-	/* No zero-length symlinks/dirs. */
-	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
-		return __this_address;
+	/*
+	 * No zero-length symlinks/dirs unless they're unlinked and hence being
+	 * inactivated.
+	 */
+	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0) {
+		if (dip->di_version > 1) {
+			if (dip->di_nlink)
+				return __this_address;
+		} else {
+			if (dip->di_onlink)
+				return __this_address;
+		}
+	}
 
 	fa = xfs_dinode_verify_nrext64(mp, dip);
 	if (fa)

