Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC2C4A11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299606; cv=none; b=cuG2xwclN9PnkocR1qFgbrZqjnfHrmVnLvqG1fDmxM13Arb2ocmmjimQIyW3K0rDDEqhW2VaanOp6eD2iA6teCQ71g/ca26rLkbC2nVSDeLfRyqSxGa2lC2jWois5cY+jUs51DGH6vIw45cfo9u+wif+s6KFw7enjQJYBGGgL1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299606; c=relaxed/simple;
	bh=jJewfFYSRD3Gmd9yR0B6v+3LkTqvUldBSiCinzqOUQc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g4vDePQLE3nsnLpAoiTTdcRPX35CGHcDHdB7loWZ0k7kTlds0okxnO7PIPx3wtj+TFBBmctR8f4H0uFV7R8gE2ksc7Am30c5fqoNy53QZnhs2bXGQODPPJd3eBXOU3jaz2atoqADTTy6ibZM6c7KBw2yPXME/vuQRtFOGqdc9kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qaYisE48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qaYisE48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42BFC32786;
	Tue, 30 Jul 2024 00:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299605;
	bh=jJewfFYSRD3Gmd9yR0B6v+3LkTqvUldBSiCinzqOUQc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qaYisE48WIpFFx7mw/ad4Ii8DCWQ/ROJjX0FcYnuClE+dJXMf7Y4vIxTRTF8XqoWO
	 qdgtFEb9jlfUvZP0Ii8NhufIjE1s+RoZuQV2pdN0Bueg+a42QOZ6Y3TMtcHqDMfd7E
	 5Mg59WMLQiyn9lDE/vDhfvrLb0wKvHQb2A+7dx5tBxe09Gz7lpzhO7R82m/6jaYdVq
	 9BLpNSc57IdwkbmtVsoKrTLd/NyPPfy0FdtSwycOusCcT1tip+Toxg7ghTz/LQFN4U
	 b2G5d0etWo3kctlwCHjTafWMFVtIGIwmTYm2k4ltBO/sYWXpwcmVLK8KLwtTsRWGev
	 mw/2261i/vumA==
Date: Mon, 29 Jul 2024 17:33:25 -0700
Subject: [PATCH 037/115] xfs: cleanup fdblock/frextent accounting in
 xfs_bmap_del_extent_delay
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229842962.1338752.10553908934303557340.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 7e77d57a1fea5f6bfe166210385ba9f227a606d1

The code to account fdblocks and frextents in xfs_bmap_del_extent_delay
is a bit weird in that it accounts frextents before the iext tree
manipulations and fdblocks after it.  Given that the iext tree
manipulations cannot fail currently that's not really a problem, but
still odd.  Move the frextent manipulation to the end, and use a
fdblocks variable to account of the unconditional indirect blocks and
the data blocks only freed for !RT.  This prepares for following
updates in the area and already makes the code more readable.

Also remove the !isrt assert given that this code clearly handles
rt extents correctly, and we'll soon reinstate delalloc support for
RT inodes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1319f1c90..5de8c72a8 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4913,6 +4913,7 @@ xfs_bmap_del_extent_delay(
 	xfs_fileoff_t		del_endoff, got_endoff;
 	xfs_filblks_t		got_indlen, new_indlen, stolen;
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
+	uint64_t		fdblocks;
 	int			error = 0;
 	bool			isrt;
 
@@ -4928,15 +4929,11 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got->br_startoff <= del->br_startoff);
 	ASSERT(got_endoff >= del_endoff);
 
-	if (isrt)
-		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
-
 	/*
 	 * Update the inode delalloc counter now and wait to update the
 	 * sb counters as we might have to borrow some blocks for the
 	 * indirect block accounting.
 	 */
-	ASSERT(!isrt);
 	error = xfs_quota_unreserve_blkres(ip, del->br_blockcount);
 	if (error)
 		return error;
@@ -5013,12 +5010,15 @@ xfs_bmap_del_extent_delay(
 
 	ASSERT(da_old >= da_new);
 	da_diff = da_old - da_new;
-	if (!isrt)
-		da_diff += del->br_blockcount;
-	if (da_diff) {
-		xfs_add_fdblocks(mp, da_diff);
-		xfs_mod_delalloc(mp, -da_diff);
-	}
+	fdblocks = da_diff;
+
+	if (isrt)
+		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
+	else
+		fdblocks += del->br_blockcount;
+
+	xfs_add_fdblocks(mp, fdblocks);
+	xfs_mod_delalloc(mp, -(int64_t)fdblocks);
 	return error;
 }
 

