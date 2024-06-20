Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EA114387F
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925252; cv=none; b=mYC2M2H4+2ZqY5p6hv/FPEO4Su3OIk8rsRd+JcxSZxmffHK2aOsf+smYCOUfe//JO/C2kOKd1PmijEjyzLpiZhft9oEtgV2gFhPRE+CV/A/Sd2GrOWyXbmKv4X2L9VkDpV4nWOovMuOD7pTCjjmrQWawCTw+BEPVB2cGyuu9qi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925252; c=relaxed/simple;
	bh=930eoyYif2aR7xU90lFvQmdoLWBDG1Mey9JRIHAiMJI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IS6jB/ytkDD7YdRblPAbMIKtGzsFM0bzuXuy5Rdz6DGsrs14rwOLmz0zNZ3KkCH/xplgLRg4/259CeXFLBYMY8Kt5uTBzmW5qlJEkOQInaPqMWVBbDBV2HnC5WKM1yWldFBqjWZTeH6Yw05sljgGs1fQzk61BrbSfyJSze35xv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZBfltuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZBfltuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8306DC4AF08;
	Thu, 20 Jun 2024 23:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925251;
	bh=930eoyYif2aR7xU90lFvQmdoLWBDG1Mey9JRIHAiMJI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AZBfltuWGUlMomHhNvEQQHk8gKyTOR0pQRUaUSHnSPrucFlnOAt58UeA6pMhSYPQs
	 jONOsIvRo0iddJqYJcK4s8pQYXTTttVAteqw5KuIKFqVuvdhrtZKBisXRn8QBAKXLL
	 micNgJH7yVq1GANIJ8n9oh3xTouYMxt6af5TkPv/l6f09VUM4Y/kvNqMVl8g/rSbvg
	 9lbAH8wT6iESV8afoFE6oIazuSRg1murQlMkHq6Z+aFO4gyPz942tNGc3pshByV4vI
	 8v5axPRyq+Z0TGBPcV5Sj7vqMy2L+RqIdlsoUTHwazOJuVInsuZPXkCrMO2aRlWC25
	 S8O+kEuI6Z9tg==
Date: Thu, 20 Jun 2024 16:14:11 -0700
Subject: [PATCH 3/6] xfs: allow unlinked symlinks and dirs with zero size
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, chandanbabu@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171892459283.3192151.16340949131696263994.stgit@frogsfrogsfrogs>
In-Reply-To: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
References: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

