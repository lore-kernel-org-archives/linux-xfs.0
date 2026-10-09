Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1842635C6B8
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589821; cv=none; b=RA8xNym2LdXRzEZLm+bDg2qGoZ2lMZrcWyvtQl0whXEfeTyJzn88Unq2AvM0HsFb+QiPX2tO2ReWDa508OnG3d9zJxvY9hLF3J/CyFZsMt1Yaj6FSeGJqatMQgkxkB2bQDXb8RmMzURCSswxeGlGf/Mrk/Vehj4AsM6BBIbJH0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589821; c=relaxed/simple;
	bh=LsNzLE9BFk/fyJAhvPE+FTaIBXI6jBZbTLvymiY125M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g0tIfcyf5uMfLGi3rE4FUZfvhUZKIaKwTFpCEoXChks1614Ymo3wim7e32gcXp/hpWzH7fO0sqhqrtHaZABSWdRWJ06OynlRa2YLcUWCYoYvyGFODLYBLHJY7Ck8BWsTNQ1BjG1Jvxh7bWHzT9o4BvZ9TUalc2tdGznbRRZqWOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BobmYwNz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BobmYwNz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9B3221F000FF;
	Fri,  9 Oct 2026 23:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589819;
	bh=rw29Uwsl+u0sDZUSUBTM1voGVDunCHk/vBS0rkkHj+E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=BobmYwNzdSBrw+RibxMeyp4jhzcyTKXrqEbV5GMxNt+557Tgkek9INxRQoOcB21db
	 oPp4DVdTzpt5lNZ2JVKfUZU+jLPPyKPNhw2FKa3f45visOLEkNGHaqxeLc3LMVPwsI
	 szrLOf4z+9nWGMf+1jv5aumyvjZ/1sBTiHPCNhq8qciDorb2YYEVBmpQv/zC9qRfl9
	 FZQofLTYBlUS3mW4CX/KVnxNqzNaEWAvSNWL7/5AqgO1XMRTguqO6cQ7Y5QEFiLu2r
	 zADkJaXIm46ke2HbWqGJoRVE/TrWY+KlROSlx6XcvEvPibzxLSIsT9qJxeDRrE68U4
	 0xwptsx9eo1bA==
Date: Fri, 09 Oct 2026 16:50:19 -0700
Subject: [PATCH 18/26] xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179158947697.3719791.8200674327985067459.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: aa301322f72f82f26e4ba0826018d41388ab9896

The _maxlevels_ondisk functions are used to compute the size of
in-memory btree cursors for each btree type.  Unfortunately, LOLLM
noticed that the rtrmap and rtrefcount versions of these functions
forget to account for the inode root, which means that we could access
beyond the end of the cursor given a sufficiently large btree.  Fix
this.

Fixes: 9abe03a0e4f978 ("xfs: introduce realtime refcount btree ondisk definitions")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtrefcount_btree.c |    7 +++++--
 libxfs/xfs_rtrmap_btree.c     |    4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 22acc1411aacd8..e2950dbe20681b 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -489,8 +489,11 @@ xfs_rtrefcountbt_maxlevels_ondisk(void)
 	minrecs[0] = xfs_rtrefcountbt_block_maxrecs(blocklen, true) / 2;
 	minrecs[1] = xfs_rtrefcountbt_block_maxrecs(blocklen, false) / 2;
 
-	/* We need at most one record for every block in an rt group. */
-	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_RGBLOCKS);
+	/*
+	 * We need at most one record for every block in an rt group, and
+	 * one extra level for the inode root.
+	 */
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_RGBLOCKS) + 1;
 }
 
 int __init
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index c264bc5651c0a6..0cb2113d5b4045 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -716,10 +716,12 @@ xfs_rtrmapbt_maxlevels_ondisk(void)
 	 * happens, which means that we must compute the max height based on
 	 * what the btree will look like if it consumes almost all the blocks
 	 * in the data device due to maximal sharing factor.
+	 *
+	 * Add one extra level for the inode root.
 	 */
 	max_dblocks = -1U; /* max ag count */
 	max_dblocks *= XFS_MAX_CRC_AG_BLOCKS;
-	return xfs_btree_space_to_height(minrecs, max_dblocks);
+	return xfs_btree_space_to_height(minrecs, max_dblocks) + 1;
 }
 
 int __init

