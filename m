Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1C04A11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299058; cv=none; b=NIw304V2LcGDZKUNc9fuByEr/YSq+RWz35YvavnSOrujuJcSUukKeiQKkVVqqmdW+/OMyxCClEfHl1I8ylxbG62tvYNSRILdHvwxXiD8iaf8DIICZYfYjw7kmKuJc9Cg8Al/yb485cO1Se8PFM3fXsFk/pF1oAm3W6DZZpOBa1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299058; c=relaxed/simple;
	bh=JBm9mNyug9b6rR4eufBNYi9QlnfU14j4a9IakzZEGYc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k8sWwvhgiafvLYtqzrarJlSWu4M3X4ZE4VI4AbyGmG6lqIpu1oaldt78d9EwzkdsP1NNOloEPc2T163m3L1WQYrHHPyfWcdlHl+jBejCCwmWCPNMVwMVb7qRryO64CCN3qX4sG5kPDuoIwDPNDrRWwgFkBv4ZqUYPfKybaFyYVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lhn13/K9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lhn13/K9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7C6C32786;
	Tue, 30 Jul 2024 00:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299058;
	bh=JBm9mNyug9b6rR4eufBNYi9QlnfU14j4a9IakzZEGYc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lhn13/K9LI996witdXvP3nrt8lgc6UbYvBQY1iDeu7IuCTnvznlyjVxrEst1qM38+
	 pOXDNHEvn4PJk2DPfB5rVss4KErAf4U2wO+J8+dBGT2qvbnG7pIoYDuuqZbD9R9NLK
	 83GPqNB+qGRUhitBBDpSuhiba5ame4pHqhq8H2fGEZ7T72ElFaeoNDAfUH98GPq84V
	 XgJ4FJANc9+UksBfATV/5lkewkz8bSwNhAhoqNxs6VQ7RomhlS1KcrA2wHuRxpg4vd
	 UFmoq6NU/nX/e0A3CmkTePN9rP8cCxt67xyVNfwbY3tE/OkoIAHDRPGWE56HkQWHl7
	 P1Ma2pydgiZbA==
Date: Mon, 29 Jul 2024 17:24:17 -0700
Subject: [PATCH 002/115] xfs: constify xfs_bmap_is_written_extent
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842469.1338752.8458228431845610563.stgit@frogsfrogsfrogs>
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

Source kernel commit: 15f78aa3eb07645e7bef15a53b4ae1c757907d2c

This predicate doesn't modify the structure that's being passed in, so
we can mark it const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index f76625953..b8bdbf156 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -158,7 +158,7 @@ static inline bool xfs_bmap_is_real_extent(const struct xfs_bmbt_irec *irec)
  * Return true if the extent is a real, allocated extent, or false if it is  a
  * delayed allocation, and unwritten extent or a hole.
  */
-static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
+static inline bool xfs_bmap_is_written_extent(const struct xfs_bmbt_irec *irec)
 {
 	return xfs_bmap_is_real_extent(irec) &&
 	       irec->br_state != XFS_EXT_UNWRITTEN;

