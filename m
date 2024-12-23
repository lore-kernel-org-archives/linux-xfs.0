Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCD838F82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989843; cv=none; b=VwHPEGg7OQQ82eMQp5pZtm7J0bvI9Za19ByoOzgM0Swxyr9C1fqMIaSPcIRMCKpuqYVOiAg/xBg9QU9DwAUqj5bV5ebrQYSy9LRgHq0i3HzmJStdssu78JtJW0WW0nnB02i+f2H0mEybJ0RxqAiImd23VP+V4aABPQh7MWaUKxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989843; c=relaxed/simple;
	bh=wZ6mx4jJY7mUN1tTAgIeW+rjz9bTyNpkaT4srN8RcTg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MlsG9J765oxu5Zg7kcnmDsWu0JrbdjcaslpzwO/NZcwNfp6LnDHz62isBH1UvMe0c/Mfqz2I/iXcPqUQuA2V0RNjU23if2PFX1iSp0uEhn1ZAgO5ev34ypm1pQVZBYu4rCwPlk7SesKsBSUdJ6AGrxXEZu//3DwKIuKoL3v0t9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZEcLxJbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZEcLxJbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FBAC4CED3;
	Mon, 23 Dec 2024 21:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989843;
	bh=wZ6mx4jJY7mUN1tTAgIeW+rjz9bTyNpkaT4srN8RcTg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZEcLxJbnvbDUG8HsFe17PH9VIddu2IoA6k++4vP2UDx5fB1AlytOTR0GJXjTXmpKc
	 NTJiM9fsFaKRcDX1ajTUlUdxfKsWIeGYc9OXthnB34UB5n/t1PPMGPZxmAGcJWpKhk
	 YxrEWDOgIH9mbLXHJmGJ6yD3y6DTWmPgds+6xKRQN+PYBqtxDSD/xRYH8jV2xu8Zry
	 exuLyJjtBvM8LRX4IbWmzbWa/OlNVyE6ZsSgplC48B8necnH8NCZixrpYlGpmIPtIS
	 Mb5/DpHFMZ7hrrAu+2nYPuzX+0e1ar8oSxp5eou9QGJf5X0THFmbBOeJuI2c+JbrQ4
	 CXs4urjNhWorg==
Date: Mon, 23 Dec 2024 13:37:23 -0800
Subject: [PATCH 01/36] xfs: remove the redundant xfs_alloc_log_agf
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: leo.lilong@huawei.com, dchinner@redhat.com, cem@kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <173498939961.2293042.2074237386773207035.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Long Li <leo.lilong@huawei.com>

Source kernel commit: 8b9b261594d8ef218ef4d0e732dad153f82aab49

There are two invocations of xfs_alloc_log_agf in xfs_alloc_put_freelist.
The AGF does not change between the two calls. Although this does not pose
any practical problems, it seems like a small mistake. Therefore, fix it
by removing the first xfs_alloc_log_agf invocation.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_alloc.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index f0635b17f18548..355f8ef1a872d3 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3152,8 +3152,6 @@ xfs_alloc_put_freelist(
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
 
-	xfs_alloc_log_agf(tp, agbp, logflags);
-
 	ASSERT(be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp));
 
 	agfl_bno = xfs_buf_to_agfl_bno(agflbp);

