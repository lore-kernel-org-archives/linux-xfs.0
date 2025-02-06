Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81294197A8E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882028; cv=none; b=ONW6K1gZS6aHkVMZpLWZQvEeMnxa/fW1rBWfVpKJRi5xxH9s4ztpLNj5bMDMuqC5vlfHYowsqSeeIQob4ceGUQmX1SqV2SY6UTYh/5GExQd7Sdnrf9s6w0OrlNoRx9P6iKs9Al1R1SC7WDFbUl4udp0u4WziSzJ0o+lVCMNMzng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882028; c=relaxed/simple;
	bh=aIdxrs3PLpCvP97XyrwNj5h1u95W77s46wMEq9iuvsI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=brBJRrPOWYWGd/WQ9Np5K3sy/CdOGSsfoc8GBsSE2Z3CFqAd8FA4qsw3QrLS5Yri8NkaoUbi3zDdl7gpXfhTTjPhMjnuFUzTbznKwMFPvZxIqOAiv0VJYsvUwogMazoximRmY6sTqeKckrZ4ii/8k3lzH1pq3bz9f+tJGBmYETY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LNZNao3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNZNao3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F271AC4CEDD;
	Thu,  6 Feb 2025 22:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882028;
	bh=aIdxrs3PLpCvP97XyrwNj5h1u95W77s46wMEq9iuvsI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LNZNao3cLADHVxU+bDpJWAGILFKJeuN4f94Zd2s7FZZUhlfbJNDCsA6DWM9hOAdz+
	 X1f6Dfk0EApJwWamQzhtjWbZQl/M6rkNFRvwyx2EP1sUTgZ4OGcmI1Rk1cUrhEJJt9
	 G9RAfTZl2iiPngjKG1864PKOOEqGWHZnyOlMqmMwsZl0O4pKbCN/Hot8g7t4IwK5xK
	 fkOeeTU12ijAzIyggIBztYlBZ2oyZqxSfyr6gfUElF2t1eQMLxoJNBALgM9Mj5+XAh
	 4ZsDck+G//9m6uFy4vS/wg8F+Cbbk72iWt2lQ8PvDcrgjOC9fzAJyOx/XBe2zUpJzs
	 4e+2XW88gh3gQ==
Date: Thu, 06 Feb 2025 14:47:07 -0800
Subject: [PATCH 46/56] xfs: fix xfs_get_extsz_hint behavior with realtime
 alwayscow files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087496.2739176.18025891457855598209.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 6853d23badd0f1852d3b711128924e2456d27634

Currently, we (ab)use xfs_get_extsz_hint so that it always returns a
nonzero value for realtime files.  This apparently was done to disable
delayed allocation for realtime files.

However, once we enable realtime reflink, we can also turn on the
alwayscow flag to force CoW writes to realtime files.  In this case, the
logic will incorrectly send the write through the delalloc write path.

Fix this by adjusting the logic slightly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 9cfbdb85c975a5..ed969983cccd1b 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6494,9 +6494,8 @@ xfs_get_extsz_hint(
 	 * No point in aligning allocations if we need to COW to actually
 	 * write to them.
 	 */
-	if (xfs_is_always_cow_inode(ip))
-		return 0;
-	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
+	if (!xfs_is_always_cow_inode(ip) &&
+	    (ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
 		return ip->i_extsize;
 	if (XFS_IS_REALTIME_INODE(ip) &&
 	    ip->i_mount->m_sb.sb_rextsize > 1)

