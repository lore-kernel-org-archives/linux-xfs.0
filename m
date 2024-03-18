Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1653C2D
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 18:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710786809; cv=none; b=OrkkRr0Vi5iakFW6j0hdkskqsOlGvzRzoBmm0WFZ7PVVgZHJ7ewRobr4T0c9j1qhBOMEXMRubQrWrF2K+ZLInZ1mQgZfWxz6OLt7AD6lj4+B3LkjVThPD5elbkA84cKu5UY0G9jvyszrLU5R0U3qeMqJpR59GxmXtvyF5JWpxc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710786809; c=relaxed/simple;
	bh=PHbGWezeLBMiyYShE//ZowMgrKimdvCxyp5pj3DknHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f0Gw1SE0IMvnZxQmkZEeInurnWsZow3AtLtkhU+bNRMBB5xU+QSuuhoeNawryUkY3m0ofbJ1n6jfrjF7j+jRW8GOqrSF+qvfPA7y8+8SHYMZqvY+NzWZLX4EMAla5d3BtrTdz10ahycSVMgT5ICrq/MKj+EVOjXNkh7M2Kt4u5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fVpFvuKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVpFvuKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E62C433F1;
	Mon, 18 Mar 2024 18:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710786809;
	bh=PHbGWezeLBMiyYShE//ZowMgrKimdvCxyp5pj3DknHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fVpFvuKpCvQ3XF6HaSrsVinzLSQL1mhByCoihvB+Thko1ZHSwt0AUbBLMyIQOUtVh
	 /MYgWiBopOgIiq7WVbh6LDAg8cREc0Xw7euBR8gUsWgLNIEK/tyriLG71sVu4LcmgE
	 JR1Mrrlm9+g305713WhvYATczmTaCFn3C7FgW3FSOnO8MmOXgiezLHDhKQVYh74j4n
	 MRFpN7+xLX7h0xnS/m7wJ2asiyYrG4aBp0NeD3+U6a21x7hjxIWQlx6lpkVPRLJODQ
	 eTDbK4vHpeJUnTBhP3aMmFYSXT6Ou5rYrWuOVrl1kePmPSDxag9upm1nixo/cES4BR
	 Kvge7o/iSVQ1w==
Date: Mon, 18 Mar 2024 11:33:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH v24.5.1 7/8] xfs_repair: don't create block maps for data
 files
Message-ID: <20240318183329.GL1927156@frogsfrogsfrogs>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434829.2065824.5706231368777334384.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434829.2065824.5706231368777334384.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Repair only queries inode block maps for inode forks that map filesystem
metadata.  IOWs, it only uses it for directories, quota files, symlinks,
and realtime space metadata.  It doesn't use it for regular files or
realtime files, so exclude its use for these files to reduce processing
times for heavily fragmented regular files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v24.5.1: add a comment about why we do skip this now
---
 repair/dinode.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index bf93a5790877..94f5fdcb4a37 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1930,8 +1930,14 @@ process_inode_data_fork(
 	if (*nextents > be64_to_cpu(dino->di_nblocks))
 		*nextents = 1;
 
-
-	if (dino->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
+	/*
+	 * Repair doesn't care about the block maps for regular file data
+	 * because it never tries to read data blocks.  Only spend time on
+	 * constructing a block map for directories, quota files, symlinks,
+	 * and realtime space metadata.
+	 */
+	if (dino->di_format != XFS_DINODE_FMT_LOCAL &&
+	    (type != XR_INO_RTDATA && type != XR_INO_DATA))
 		*dblkmap = blkmap_alloc(*nextents, XFS_DATA_FORK);
 	*nextents = 0;
 
