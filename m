Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0936FBF3
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 17:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718214409; cv=none; b=QHZ7HZwmaNrZcwQmh86CfWhA6hyF8GzHo7SEl+ihf3g20TKIgyQnQblhLnmkw6LkVU7dkbf8AHw1E8yxUiLfPjc0v4eoI6YoC3oJrwZyDgHEJh4OJW/or2iEIQZ/9AODDFXAnT35dB552i+/tBMm60MPeZozxjvKL9RGaYD4ISU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718214409; c=relaxed/simple;
	bh=eCQS3+kBLk5wZYhEuiR8GNLNJuYzZfobYehJGQ9vFf0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rs4x1n/yVyQZNUjGOkdDOtyKCsLoYCLlPHHkVHsurovR8zjF/ZWfXQFEFKb++2G7F7/l5wJkzHN2X17HKs0o3aBJOs2pJ2CZOrPOKJd5iy/cOGl1wEmeMQBdwpZwrVduLxPeny8vnP5Vs/1/CpIIJHYHSc3SaVs5f0L9NOqfFmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFYx+vJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFYx+vJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D1EC116B1;
	Wed, 12 Jun 2024 17:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718214408;
	bh=eCQS3+kBLk5wZYhEuiR8GNLNJuYzZfobYehJGQ9vFf0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BFYx+vJBKFIljTZ/BFsl91EuLTk3ALjwphzzPHCAw3cb2DAHOAc4MfS9KYkqGMAF8
	 pe1c055eVLVwLmNt35KHQJdmGP3PVmyE/vnOaaJob3tG1jqUoaijNgX0LWUkAoELxt
	 MnO4WlC+elNrh5eZK1aW4lMmMnq+a3Jb+VHGURLUOt0/5ZFVv/TG/LW6Ge2oG1zq/9
	 kWCARMkzdX7JrEvGNMDnUCoKqeMs88E3wkpmZsAccMS8o47WVsxWHK2oCZWiqPMvvk
	 e9n+hudLBPRnV3MxjfGatSIVwgDnzSLQVBexDCaM4U+MChnlrg9YETl+ez3q+dEA47
	 HoACfZBsbxY7w==
Date: Wed, 12 Jun 2024 10:46:48 -0700
Subject: [PATCH 1/5] xfs: don't treat append-only files as having
 preallocations
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171821431777.3202459.4876836906447539030.stgit@frogsfrogsfrogs>
In-Reply-To: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
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

The XFS XFS_DIFLAG_APPEND maps to the VFS S_APPEND flag, which forbids
writes that don't append at the current EOF.

But the commit originally adding XFS_DIFLAG_APPEND support (commit
a23321e766d in xfs xfs-import repository) also checked it to skip
releasing speculative preallocations, which doesn't make any sense.

Another commit (dd9f438e3290 in the xfs-import repository) late extended
that flag to also report these speculation preallocations which should
not exist in getbmap.

Remove these checks as nothing XFS_DIFLAG_APPEND implies that
preallocations beyond EOF should exist.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    9 ++++-----
 fs/xfs/xfs_icache.c    |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ac2e77ebb54c..eb8056b1c906 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -331,8 +331,7 @@ xfs_getbmap(
 		}
 
 		if (xfs_get_extsz_hint(ip) ||
-		    (ip->i_diflags &
-		     (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))
+		    (ip->i_diflags & XFS_DIFLAG_PREALLOC))
 			max_len = mp->m_super->s_maxbytes;
 		else
 			max_len = XFS_ISIZE(ip);
@@ -526,10 +525,10 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/*
-	 * Do not free real preallocated or append-only files unless the file
-	 * has delalloc blocks and we are forced to remove them.
+	 * Do not free real extents in preallocated files unless the file has
+	 * delalloc blocks and we are forced to remove them.
 	 */
-	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
+	if (ip->i_diflags & XFS_DIFLAG_PREALLOC)
 		if (!force || ip->i_delayed_blks == 0)
 			return false;
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0953163a2d84..41b8a5c4dd69 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1158,7 +1158,7 @@ xfs_inode_free_eofblocks(
 	if (xfs_can_free_eofblocks(ip, false))
 		return xfs_free_eofblocks(ip);
 
-	/* inode could be preallocated or append-only */
+	/* inode could be preallocated */
 	trace_xfs_inode_free_eofblocks_invalid(ip);
 	xfs_inode_clear_eofblocks_tag(ip);
 	return 0;

