Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D43F539A
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608752; cv=none; b=nfOh+Gxhm1baAPPmakbKwOIqQXozKQtnLdwAGgqT8Vt+FYA/cK+6LFgcILAu7qtsWY+oG6tZ9ZgsoyBBJMVq1mLXpAqc04rJjdb02kNy1I2CQD1qN+QQbWMqc5BrgkSze6wvs1DZJuDgCVYEr0Xwev30CD5I1Tr6jhAO6CQ8ncw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608752; c=relaxed/simple;
	bh=oOiTGul6Y6dOHkU4GThTSMMYzYDjg7eqnFtTJkIedxw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WhnyVuNtxYEz0zHBUIp8lV7U1txtzongpXbU9LjNte5B0lWFWKus1uDVDaOFwcE62G+Tw42P8IimVd8FhEtYty9We4kZzl7OAxSffB3W6UzKDwfYxWRZUABEEhhQZ1kZf44HomVLtgJqlN0oyhCjkwbdtc1c73OakubVBNOBr1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TT6Viulv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TT6Viulv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C84CC4CEC5;
	Fri, 11 Oct 2024 01:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608751;
	bh=oOiTGul6Y6dOHkU4GThTSMMYzYDjg7eqnFtTJkIedxw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TT6ViulvQTTHEOLUN5sCFU3e2tDAyN2fgqa62QO1o8HvARRSRNBk7z2olakZ/5Xp0
	 4hDnWUKMwGNUDvbZVe1bF5ClZgOYUXu2Hi4SF1vZgJMu0dcLFSP3YmU4vlX+s4wHjM
	 k8cHelQTMSiZkQBWSJzmf+XVgUVXSM1fKxm4ikfAgP9fkCoV+Yswy8GrL1r6555crd
	 fYv3Xrp+RcNe/RAbRQ4V/glhFRDnQAQBW8Y/xzZ4nFwZs1U6UdB2/YDsS6IUjeLdad
	 teuNSHCpJtUmHEm/eUEYWbZlhhGNlXhtMlEHGcGdU7QDzlm/yIQB6LSoRp9V4Mhq/B
	 drfZR4i1v4pUQ==
Date: Thu, 10 Oct 2024 18:05:51 -0700
Subject: [PATCH 16/36] xfs: force swapext to a realtime file to use the file
 content exchange ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644517.4178701.10943871228346370890.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

xfs_swap_extent_rmap does not use log items to track the overall
progress of an attempt to swap the extent mappings between two files.
If the system crashes in the middle of swapping a partially written
realtime extent, the mapping will be left in an inconsistent state
wherein a file can point to multiple extents on the rt volume.

The new file range exchange functionality handles this correctly, so all
callers must upgrade to that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 9d654664a00dbd..aa745cc5922246 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1528,6 +1528,18 @@ xfs_swap_extents(
 		goto out_unlock;
 	}
 
+	/*
+	 * The rmapbt implementation is unable to resume a swapext operation
+	 * after a crash if the allocation unit size is larger than a block.
+	 * This (deprecated) interface will not be upgraded to handle this
+	 * situation.  Defragmentation must be performed with the commit range
+	 * ioctl.
+	 */
+	if (XFS_IS_REALTIME_INODE(ip) && xfs_has_rtgroups(ip->i_mount)) {
+		error = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	error = xfs_qm_dqattach(ip);
 	if (error)
 		goto out_unlock;

