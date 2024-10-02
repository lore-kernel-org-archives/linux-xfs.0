Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A8E1D0BA8
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 14:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727881162; cv=none; b=YdImQAoUaMV78uvqzTraGMl8Ye8uPvWoWpnHj6/WyI1lwj2rHhaQBD6Ve5mSso0Z+Gg9HFppSllTBjwqIuCRreYvPXi/PNMQU7SxZwFvHPpnHrks9aptKBgY/SEyBKSYxtPueAmD8X8Xsqt43S3a3MExcFZqhhKuE2Xi2545cNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727881162; c=relaxed/simple;
	bh=9Epu+RanUTvYjEWUanBLlngtcNIUkk+oW77vlue7OqY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=K+eOGxvmuU1EgG5hR679W/vi50CcpsrWEnCf5uGUB+RjeJU6fcxm3+n/ZAkUO2dMzukwLrdSPyweeK94aA22LEU9fkhNsMeUFwNuOH0NtqWlQlDiNaVF0lYoPr6ZhClJ+W7Hg++9imqROjn9b5rSJRMulSFqkGEF9I5vk37svCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NRqcpaGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NRqcpaGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61F0C4CEC2;
	Wed,  2 Oct 2024 14:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727881161;
	bh=9Epu+RanUTvYjEWUanBLlngtcNIUkk+oW77vlue7OqY=;
	h=Date:From:To:Cc:Subject:From;
	b=NRqcpaGwz+lTrhefCdfq0riXNpmaXUykFqujbtPb2Qb+w3jLit5bkkgHARPv7OvtB
	 xpwOHU3xcGqsz7Mak2nwY5Nrnh1av+ZUoZL+l9jePVyk9fKyTeAEjhvJuM9+4Qh5+e
	 VaG4wTfbvawO4913AjN4n2u8WSbZtEHOTPzu3YbIM0a8HEwmyeqgP1qcpwjgJjKe9e
	 OFuls/tTd9C5hi14gSEvQRWE+dssHPqh7j5GTAW+ai//sUfI0qOA6Nou6AzoQYQVHz
	 CIZ531NT4kM9/5LUQwKohNw2DagZ32nUnxT4o35uOgRVd0J22hU2xLLAkt2fLje+Dz
	 T/KldPv1roy8A==
Date: Wed, 2 Oct 2024 07:59:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix simplify extent lookup in xfs_can_free_eofblocks
Message-ID: <20241002145921.GA21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

In commit 11f4c3a53adde, we tried to simplify the extent lookup in
xfs_can_free_eofblocks so that it doesn't incur the overhead of all the
extra stuff that xfs_bmapi_read does around the iext lookup.

Unfortunately, this causes regressions on generic/603, xfs/108,
generic/219, xfs/173, generic/694, xfs/052, generic/230, and xfs/441
when always_cow is turned on.  In all cases, the regressions take the
form of alwayscow files consuming rather more space than the golden
output is expecting.  I observed that in all these cases, the cause of
the excess space usage was due to CoW fork delalloc reservations that go
beyond EOF.

For alwayscow files we allow posteof delalloc CoW reservations because
all writes go through the CoW fork.  Recall that all extents in the CoW
fork are accounted for via i_delayed_blks, which means that prior to
this patch, we'd invoke xfs_free_eofblocks on first close if anything
was in the CoW fork.  Now we don't do that.

Fix the problem by reverting the removal of the i_delayed_blks check.

Fixes: 11f4c3a53adde ("xfs: simplify extent lookup in xfs_can_free_eofblocks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 053d567c91084..b0e0f83ff348a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -542,10 +542,15 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/*
-	 * Check if there is an post-EOF extent to free.
+	 * Check if there is an post-EOF extent to free.  If there are any
+	 * delalloc blocks attached to the inode (data fork delalloc
+	 * reservations or CoW extents of any kind), we need to free them so
+	 * that inactivation doesn't fail to erase them.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
+	if (ip->i_delayed_blks)
+		found_blocks = true;
+	else if (xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
 		found_blocks = true;
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	return found_blocks;
