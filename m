Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C623B0585;
	Thu, 30 Jul 2026 05:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785389257; cv=none; b=KSQmRW64AwEnZPXGjqaplQxVmG85TxTiFPSDXa9pw8iMCNwgSHsSmSPPkbkjz7Lbat4efNTvTD5sLt0DI/M0KBH9jhAai94//ZCKGqiAHlw5HLjpR4kCih5s89EhDubUEUXpscyJRSTgzfCGEgwqMospX/dsOuBkf0gbqGQMuXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785389257; c=relaxed/simple;
	bh=wF6quXi3RPiJx9hQCANHZIG6+TXsCXZrirZl6rWYh54=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kOTscuUuqvhltqw3hH4xBh0rQhyNTP/i3RnsZQcgP/a0C4Wb3jgcqCVlJzv0BhCMAJLAOEt8czQUmZr2cWHJsO0Mj7L7v1qMRAeFGaL+lcwjDzKoPykV3UrCqsv0IAcYbZSykzX+W3rie8uDXPB9U9MY7oTE6wEubcRMxEqzKFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BlsuI0Mz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BlsuI0Mz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3A3961F00A3A;
	Thu, 30 Jul 2026 05:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785389256;
	bh=ysAWRofeXPZcJkultPkpVeKmZke1ylrpEMkqBGZFC1c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=BlsuI0Mz8UilfQbxbvRbqymxXvmMjCpZdRhoFIEnZJw4FdVfrlfwaQX1BDY0144FE
	 tL/3N2QhhtZlHsOH0hA20L+SNhXtk1DEAa/VujVw40jXaYckLwad3toKQl27ll+IOx
	 uvMOhv8XmOpp5EmNC2AeD9s8ybeGdJI+UxSCcpUbE2+qPIHGNHoMaH11K1jGgxRQUA
	 L8KP4Q2OHOymnReapwN9VAyV+ur3iAebmbjZfzjcPyjL4hpn/PZqudkGBQSshirwC7
	 DoO/r9UuIzV+eowj5maSMaZbz6dchfE7siGnh4n442xKyXAYOb1MOz27p4g8vt0Dfw
	 e/F5/YRt90z4A==
Date: Wed, 29 Jul 2026 22:27:35 -0700
Subject: [PATCH 6/6] xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178538913008.4070956.1052714188976376785.stgit@frogsfrogsfrogs>
In-Reply-To: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
References: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The _maxlevels_ondisk functions are used to compute the size of
in-memory btree cursors for each btree type.  Unfortunately, LOLLM
noticed that the rtrmap and rtrefcount versions of these functions
forget to account for the inode root, which means that we could access
beyond the end of the cursor given a sufficiently large btree.  Fix
this.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 9abe03a0e4f978 ("xfs: introduce realtime refcount btree ondisk definitions")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |    7 +++++--
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |    4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index f27b80a199ba2e..971cb27400b042 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
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
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index c264bc5651c0a6..0cb2113d5b4045 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
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

