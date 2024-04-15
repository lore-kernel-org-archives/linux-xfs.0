Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8032E852
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225324; cv=none; b=t28iwY6tkMffrYL8yKwochj3lbnzeI8tIiwQ0o2N3SBxEzuN2SqkyNEthrYifhIdJnTLt6fFmueqRliPB66RZ7PNrQGdP/q6+BvNOtnqQzbSr9jmnvpzcwQbsTowJ/Ar53ogl4cF+KaaJTGk4q8hQnM38qlMg5yyPljGxZ1vNxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225324; c=relaxed/simple;
	bh=NMSSh5yzG0K10c+BAGwBoRNHiPpNMDdb61xeFCFgd8o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UTyRtjqhOeIxN8oJYhhsyEGylyRSPRGXYe3/prG0CI8IHyWwkYoYTytxqgFTR35ewoFEFyvP0WgjYEb0XBJOkg3dnXPBPiKy+t55IzOZpJ4RNXyTOXwKI+hDcTzDdlnNCxBVYVjkSdhs6y10MOyo+3113tlmDfgFHXIzZLsfIIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+H0F7nH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+H0F7nH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B29C113CC;
	Mon, 15 Apr 2024 23:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225324;
	bh=NMSSh5yzG0K10c+BAGwBoRNHiPpNMDdb61xeFCFgd8o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T+H0F7nHAkiQIx1ae+hOPQ3wZ8X2sXz27HJUE7RPbb6Q46yx4gwSDIFfBGRmlFWeY
	 51U2ckX/12vuuHSKavA2oVX1h1Bgrwr/2zLROzC9DARdp5dzUwK1SWGx9LW6vKmJYj
	 MfFL24a0YVIz5v3FSKtLuF9q2C5jNM9bqwM929lABEpbJMRBbSiqDkNIk7yj4iBrZp
	 /ZZJOJyjwjgsC3K4ti3i/b8ewuz423xMSbJCXhvhTShidx//MLWA1pLL5cpbYNGhKZ
	 s1UOT/PzZFv0pibXETWDHEUiFFGPhAHbwLHMW95RvwCV6kWg3DlNY9v2B1sPRoeO+l
	 eBSr+u4giBITg==
Date: Mon, 15 Apr 2024 16:55:23 -0700
Subject: [PATCH 1/4] xfs: check unused nlink fields in the ondisk inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322385407.91610.11084727615642799710.stgit@frogsfrogsfrogs>
In-Reply-To: <171322385380.91610.2309150776734623689.stgit@frogsfrogsfrogs>
References: <171322385380.91610.2309150776734623689.stgit@frogsfrogsfrogs>
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

v2/v3 inodes use di_nlink and not di_onlink; and v1 inodes use di_onlink
and not di_nlink.  Whichever field is not in use, make sure its contents
are zero, and teach xfs_scrub to fix that if it is.

This clears a bunch of missing scrub failure errors in xfs/385 for
core.onlink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    8 ++++++++
 fs/xfs/scrub/inode_repair.c   |   12 ++++++++++++
 2 files changed, 20 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d0dcce462bf4..d79002343d0b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -491,6 +491,14 @@ xfs_dinode_verify(
 			return __this_address;
 	}
 
+	if (dip->di_version > 1) {
+		if (dip->di_onlink)
+			return __this_address;
+	} else {
+		if (dip->di_nlink)
+			return __this_address;
+	}
+
 	/* don't allow invalid i_size */
 	di_size = be64_to_cpu(dip->di_size);
 	if (di_size & (1ULL << 63))
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 0dde5df2f8d3..e3b74ea50fde 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -516,6 +516,17 @@ xrep_dinode_mode(
 	return 0;
 }
 
+/* Fix unused link count fields having nonzero values. */
+STATIC void
+xrep_dinode_nlinks(
+	struct xfs_dinode	*dip)
+{
+	if (dip->di_version > 1)
+		dip->di_onlink = 0;
+	else
+		dip->di_nlink = 0;
+}
+
 /* Fix any conflicting flags that the verifiers complain about. */
 STATIC void
 xrep_dinode_flags(
@@ -1377,6 +1388,7 @@ xrep_dinode_core(
 	iget_error = xrep_dinode_mode(ri, dip);
 	if (iget_error)
 		goto write;
+	xrep_dinode_nlinks(dip);
 	xrep_dinode_flags(sc, dip, ri->rt_extents > 0);
 	xrep_dinode_size(ri, dip);
 	xrep_dinode_extsize_hints(sc, dip);

