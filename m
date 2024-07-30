Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471724A11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299590; cv=none; b=aGrFo8WyUcGp8YMWR5iFzw04ZstzWkOMZgZfPf7NDUjnJwlRUh0wyPnRlc1dCok0/N/iOeV6Retykp7Z1cAdvullVrex/ZLTfAD7ZaYVUaIOqc90QETPllv4h3zj5xeVmKdexkt7DPyISqtVvwkUkZN3IL7vI2kX/XbOX9IQQlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299590; c=relaxed/simple;
	bh=cZo40OM180rGpzqsYM7vawcLN1dwEbSERuuxyqUBVsQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uEOspGTL/mmC61gehwCR8crC+aieAiNj+VWWELpzgf446PFf+L8JXaAJND+oGnqa7V/mkj7OjABLdl/nZWJByWzNbg/IS1H0HhmA5UzAGP7h/OmooDBv00m1F1mYWhnhBsS8ilYLQLIPVPYgk/HXFhdxH255wu55WIyMzeAqwCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KptFYPdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KptFYPdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241B4C32786;
	Tue, 30 Jul 2024 00:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299590;
	bh=cZo40OM180rGpzqsYM7vawcLN1dwEbSERuuxyqUBVsQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KptFYPdpxgtumcVvedEUH6WUdslYgAzRjRiQFRwwz4WVJbyaWaJfrEH6fbr7lgKKh
	 H+I4BYYO43yl4ysOYvtPFqIjJ+ev09sAdd9Pz+cY8ThvO1N6nbOzYwzij0YvLEsOb6
	 VE00mvQ68iQUNAcA1jFqQn0Hmtm151FieEzdCXfwWH/bfY24KaFYYEZTbdV0YvwsEw
	 ueEljTdjHLFNFwMpGmUzvSrKVPjdoqYw9tu8zxgR9LW8irk+IZDeFxB9U2nKYfSHao
	 /LdEV5uW0Pq0XDYokms2Hb1UYuYymorR4veRmchcDZa+Igw6Z/ymph+q1Qwr1Q1DDF
	 m7tTMs9VQyO5A==
Date: Mon, 29 Jul 2024 17:33:09 -0700
Subject: [PATCH 036/115] xfs: reinstate RT support in
 xfs_bmapi_reserve_delalloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229842948.1338752.18246107009752852124.stgit@frogsfrogsfrogs>
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

Source kernel commit: dc1b17a25c321c8f1b4f90f9d6f8afb1d132b69c

Allocate data blocks for RT inodes using xfs_dec_frextents.  While at
it optimize the data device case by doing only a single xfs_dec_fdblocks
call for the extent itself and the indirect blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 3f70f24ba..1319f1c90 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4063,6 +4063,7 @@ xfs_bmapi_reserve_delalloc(
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
+	uint64_t		fdblocks;
 	int			error;
 	xfs_fileoff_t		aoff = off;
 
@@ -4105,14 +4106,18 @@ xfs_bmapi_reserve_delalloc(
 	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
 	ASSERT(indlen > 0);
 
-	error = xfs_dec_fdblocks(mp, alen, false);
-	if (error)
-		goto out_unreserve_quota;
+	fdblocks = indlen;
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		error = xfs_dec_frextents(mp, xfs_rtb_to_rtx(mp, alen));
+		if (error)
+			goto out_unreserve_quota;
+	} else {
+		fdblocks += alen;
+	}
 
-	error = xfs_dec_fdblocks(mp, indlen, false);
+	error = xfs_dec_fdblocks(mp, fdblocks, false);
 	if (error)
-		goto out_unreserve_blocks;
-
+		goto out_unreserve_frextents;
 
 	ip->i_delayed_blks += alen;
 	xfs_mod_delalloc(ip->i_mount, alen + indlen);
@@ -4136,8 +4141,9 @@ xfs_bmapi_reserve_delalloc(
 
 	return 0;
 
-out_unreserve_blocks:
-	xfs_add_fdblocks(mp, alen);
+out_unreserve_frextents:
+	if (XFS_IS_REALTIME_INODE(ip))
+		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, alen));
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_quota_unreserve_blkres(ip, alen);

