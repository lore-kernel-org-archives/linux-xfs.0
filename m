Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5493F188CA1
	for <linux-xfs@vger.kernel.org>; Fri,  7 Jun 2024 16:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717776738; cv=none; b=TZNbP+7GJug5ojbCf3V5kW1BOLmJHu/91OOeQA5rOpeeTBq4Wwpiht88FeH0E8bgG62hHbAwTDqgnjf8mThgl8bhyHW6MccHJ4IACeL601Nn93jB3UtmCBBFsqBUBIfNMdtq6MzXg9cFlc56Oln9OlW2z1pG3BuEatHfghg+WIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717776738; c=relaxed/simple;
	bh=5qa8VS3V/4udlgPEvhsK6bqYE77ijHJV3T8LC1D07no=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sweDNxkZliJjjXickC8Ed6gPoDMqM9Nc8AYMob2v7kbETFrfXc97Qb6CTpMSQgcoQ575XL6ShL7res/PbnPJ/7YfesZDNMdSl5ZJFDX7k7uRW2F2r2FP4ywb2l186PuARUBb+S/svs5teCiBaXG/sPFp5Mcp3EWS4+GCIxXJBOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJLCvwFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJLCvwFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA10CC2BBFC;
	Fri,  7 Jun 2024 16:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717776737;
	bh=5qa8VS3V/4udlgPEvhsK6bqYE77ijHJV3T8LC1D07no=;
	h=Date:From:To:Cc:Subject:From;
	b=NJLCvwFJ/hAaOYYlZ1oN6G5zsu1vIPmqgCzI1uNxXDUjgSEMxr0w9LOCJv0Tye1aq
	 PCRzo3V3sb0wy/YdtlcgfDKAMc8g+wL/x7Upj78pg2sVp8EXwWUMt+bL2rtMbBe96I
	 AHMHE8Rr0Ytsk+HtAx2fqUrmXwSKqf72TlmozW6I+6eAwqA8twJQt4fE/07ACzX6J0
	 d0MVJm5edn/Ja74oM87u2gE4CY2fMRLIwbm91tCS6vn+Ut1GgodEmxXWkHCQwEFPqg
	 5RN1PnLHMsmhA4AmIZORO+ymRcRGgCDAEK/9zt54ehEgVrA69wSEEdd4E5arxrjKtG
	 mYBq2DPtKk3kQ==
Date: Fri, 7 Jun 2024 09:12:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: allow unlinked symlinks and dirs with zero size
Message-ID: <20240607161217.GR52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

For a very very long time, inode inactivation has set the inode size to
zero before unmapping the extents associated with the data fork.
Unfortunately, newer commit 3c6f46eacd876 changed the inode verifier to
prohibit zero-length symlinks and directories.  If an inode happens to
get logged in this state and the system crashes before freeing the
inode, log recovery will also fail on the broken inode.

Therefore, allow zero-size symlinks and directories as long as the link
count is zero; nobody will be able to open these files by handle so
there isn't any risk of data exposure.

Fixes: 3c6f46eacd876 ("xfs: sanity check directory inode di_size")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 9caf9aa2221d3..afe06cfd6f0cc 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -612,9 +612,23 @@ xfs_dinode_verify(
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
+			else
+				ASSERT(0);
+		} else {
+			if (dip->di_onlink)
+				return __this_address;
+			else
+				ASSERT(0);
+		}
+	}
 
 	fa = xfs_dinode_verify_nrext64(mp, dip);
 	if (fa)
