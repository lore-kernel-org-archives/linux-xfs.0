Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EE6155757;
	Wed,  2 Sep 2026 05:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327784; cv=none; b=drw+gWXlFSSWGJsCIgXZ626TgP3hgEBw5581eVbkyLgwSUNO+g2LCai5TqwS/7dTQqfRC3l4w8PLiWpo1taTlPi4sdoT1MnmvyKIbYoKKxgjylIGq9zlJb8lIBy2+PEh67/irK9CMrdAtAwK5DRaCkQdFZvqtSd5ESDzP/PICaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327784; c=relaxed/simple;
	bh=H4IBtxpXPBcTtWErU1Eo+drKHoUVvyijM6pZiwur2yY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XnudIffsnj0HH1J/C81WiF8fo6Jcs4vFOp46wPGMwwJArNK/OG4JdsYyyYO4tWifcTb52gv4Z53HHfwF46bWtK82TUijOaQaiOYD7NmaGH+kKuA4vCRVz7ernx5Z3kYyZmS283MTvloKQuUeedxgzxt9c2cCMHC3GsypwVkksA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfHMTZxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfHMTZxA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3066C1F000E9;
	Wed,  2 Sep 2026 05:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327783;
	bh=7Ldpd8A7cT5SOIJYckLv7YXgyJaducoaGMq1NTQHgwk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YfHMTZxAOwf/myskWDIpN2mZOahryINWxNJiXHZu5YcFfBHH0vW3joYEmbraYfrOf
	 AxdOIHUYZEnHHGK8xzm2GorEn4GQBcJUwitkS05uywUhIvq0/ia4RzZtfAq+g7FHzD
	 hm8helPNk2V+Dh8QPGVUfCMBdF7vJTKQimgeSkohKk47zT3N8AGJYz3s/B0pgYAbMA
	 X8rntxn0dAemyatMohjlqsHf/idsxExM7nQoeQ4PFJCsEkOGHKrZXt8z3gBYifyC+Q
	 8uzMC0w8DRnBseU4Iil9LYYaXew9VprKGS7w4hhXSQtxVPsjPgbOcRNUhj5GYiOOhE
	 YnYv+fTaBppyA==
Date: Tue, 01 Sep 2026 22:43:02 -0700
Subject: [PATCH 5/6] xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749115.3506928.3514512630579214219.stgit@frogsfrogsfrogs>
In-Reply-To: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
References: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |    7 +++++--
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |    4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 22acc1411aacd8..e2950dbe20681b 100644
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

