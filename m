Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837082563
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300811; cv=none; b=JWQ05YN9nVepjoqRIeITExe5zjL5uvr9wFjfP0Yaj1FIZ9cvsImryRH+zCOMSKBwFtiL+bVeKIXOPZNZDF9cZvVm3IxZ9qwqFb3MxpJBRhbs6vo3H0KaCDgzvzXxWxxE4rEWNoK74qLHH8J0dsQo6zPS1Hc/QeU4c3NUdGBHbvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300811; c=relaxed/simple;
	bh=yCNbpqZYC4Y5sQix+p9Zpx6CnZT5QE80CxHom56av+k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cz9cPtJ36oijAWauroAaqwbH81ggzoJBN1XziG5V5vvvd6IvlC56tDAEcCe66JMscSMGSAdd9ktEVB9M92Wax7733NzdfmK4TBSBWDS0lMnsmG5JA8y2BS8wa/ac6onB3EKK50ItksQhN1Ud4e8cPwSh8/vd+e3gvBG2SxmRw5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOw90Qyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOw90Qyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D70C32786;
	Tue, 30 Jul 2024 00:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300811;
	bh=yCNbpqZYC4Y5sQix+p9Zpx6CnZT5QE80CxHom56av+k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lOw90QyzrjkOUgjvVQsEAJDq3WveCS0reXX7bOy+GLWhPKiLdK1NiFYl081eptLPU
	 tdadkByU/KuGD42cnO9zz75YaSs7+bcvaGdWrq5mp2RF5vg0GWoMkU/f58QZMmTPuI
	 8s0fIlQQorOl7UxK5bv3YziLZiuS2fmTSL+3WLAhmsqezJPNM3y0EaLKQ9e4A3T0YA
	 VQr+nbWS4J/kwRMwma8/0oMJG3rMELw951IDf8/6sV++t/Pk4XTc/s0ffViGK6/1Bz
	 tuKf2b6DbumYv2bOZGzVUbWdXmLO1+PwFNSjOEsfsmaTp7PgWDu4R3aiinBL/en4DK
	 fNnXglK9+EvYg==
Date: Mon, 29 Jul 2024 17:53:30 -0700
Subject: [PATCH 114/115] xfs: allow unlinked symlinks and dirs with zero size
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229844043.1338752.16084080686221125367.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 1ec9307fc066dd8a140d5430f8a7576aa9d78cd3

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
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_inode_buf.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 5c4e66a25..856659cc3 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -376,10 +376,13 @@ xfs_dinode_verify_fork(
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
@@ -525,9 +528,19 @@ xfs_dinode_verify(
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

