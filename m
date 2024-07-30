Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5A2524C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300545; cv=none; b=L+XmxFdQS3/VL0/gtT6Xq+CxRjPdV7IgrwpN8Kxs8LDQ1Z32X6Z9/W08+6oBL+GZeizoBH7ZOI4DU4N3+qlCUJl3yKQKDX2aytiOo3Ifg6kGTnfT8rWNKWn+llpomLdB3aEpr3y769EFwwcmY8VCb28LUpJJ6Hfa4zDBCQDGEBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300545; c=relaxed/simple;
	bh=NGyz5UT8zoUzViZ2q9ccTy/j4MymOMJOsLVL9CQ0YK8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kLDVTfC8X5c1VJP0WVYB7n0lnN1jTYxz+iHzmJv/doxMIjFh7W6+nWjFoYF0G4u0IG/d/QmQes++qjVrr2S3rUyNk6N2hRuE7tbtqhEvNLlUgHrM6Xne9JqloY8LsIxVmiX29JUJyIwU9NqAn5zSOtmuvx0vOYRY0AGDQi7wOgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qf7tfhg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qf7tfhg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B4EC32786;
	Tue, 30 Jul 2024 00:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300545;
	bh=NGyz5UT8zoUzViZ2q9ccTy/j4MymOMJOsLVL9CQ0YK8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qf7tfhg8ABekjz2mqzITAuU/E1smY7YMz0lrA7Y6ZfFGssQNPbGbX1DoyGi7XI+zy
	 OQiEg0IxcixU6Tl4YSKhNrfmNTARjl3/rErB/5+OyB6vlKrOwaH5ClNqO3zhN7izx+
	 W3VfxufNuX5xePgIXDYfTD4lm1wUUSWwjE/ij+0Zaju7AtE015X5r3VfkkzdSm/d1w
	 /j/nn2xq+VEC+xC5agP0OLW2prQipu7c1rRe4ickv1cbtm2bIGag2TzLcgBatnR5+p
	 RbW+zmj2geL1bweNMEOpmQBXrWkHphj6Le6f4t+e/KiSDmzAJ/8X5pe7/jVw9ZmbIG
	 Nr5ovXoaSxs/w==
Date: Mon, 29 Jul 2024 17:49:04 -0700
Subject: [PATCH 097/115] xfs: don't open code XFS_FILBLKS_MIN in
 xfs_bmapi_write
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843828.1338752.6331388440954453471.stgit@frogsfrogsfrogs>
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

Source kernel commit: 9d06960341ec5f45d3d65bdead3fbce753455e8a

XFS_FILBLKS_MIN uses min_t and thus does the comparison using the correct
xfs_filblks_t type.  Use it in xfs_bmapi_write and slightly adjust the
comment document th potential pitfall to take account of this

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5b1c305ec..87f0a2853 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4522,14 +4522,11 @@ xfs_bmapi_write(
 			 * allocation length request (which can be 64 bits in
 			 * length) and the bma length request, which is
 			 * xfs_extlen_t and therefore 32 bits. Hence we have to
-			 * check for 32-bit overflows and handle them here.
+			 * be careful and do the min() using the larger type to
+			 * avoid overflows.
 			 */
-			if (len > (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN)
-				bma.length = XFS_MAX_BMBT_EXTLEN;
-			else
-				bma.length = len;
+			bma.length = XFS_FILBLKS_MIN(len, XFS_MAX_BMBT_EXTLEN);
 
-			ASSERT(len > 0);
 			ASSERT(bma.length > 0);
 			error = xfs_bmapi_allocate(&bma);
 			if (error) {

