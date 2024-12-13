Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469B18472
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052575; cv=none; b=F5MHc57zibTU0nvf/p08oGnRQ7RTD8J05ChBnQHzuPcgCWMw/cdc7KvarlfbYf5e0mCZeWI98gXs3C1DYshV38dnkSTLyxqeoY3BgtwZPEhd5NS1OL4aX27wpvj4Uw4GlZBSyKNByQ2Ig28W8GXihogk6/qhXqAp/W5LqYT4NvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052575; c=relaxed/simple;
	bh=GCXPgY5lQ1RodmppYQbfE8OnUP2H3/yOHKGY3wG2TEc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ulDVG6jpRQkng8ATzq1tV9SAthd3ED6F54vYV3+QfrAWMFZEWFPLe9QG/nuj3PhOleTc9BLeVAEcKUkmgxZMCaHjA3xyr+QqnGnHp6Z0+12CSw4UW7pZRZm65TJMLN6dqBgEr4mHBpXEq/7j8tDOd5ySURKX2FIUAjXv43s6/m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8SVhb4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8SVhb4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0157C4CED4;
	Fri, 13 Dec 2024 01:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052574;
	bh=GCXPgY5lQ1RodmppYQbfE8OnUP2H3/yOHKGY3wG2TEc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L8SVhb4w/7ptdQLDqYi0VVILm4ZgaE45bko+GG7a6yJh2Oka0e1N8xe1l0FzZ9hL/
	 zWqmSYtjfE+M2z/BvC9fOYUzHIVMnoBy7SVafHz+/rPszohe6abfsqBD46bHILhYU/
	 2KDkWRuc6s/o3dU+cUrjjGQJmU+fAHW3+Vlu8MZwgIy09p7EfGl7Dp7uAoIYCRGEIm
	 FIw85T2vhG5axtmx/7X9Gb55+jw+2oIrYLClQD58AeXHHX0xDhdEzvpUsT7fWQcGa5
	 0jLPqctOvgnSI49PG0+CzXQaFZCWHtydBK1/ZHsec6nZnm7wvCSz3k6yAz8kZxakTZ
	 PHX5tMcae7ShA==
Date: Thu, 12 Dec 2024 17:16:14 -0800
Subject: [PATCH 23/43] xfs: fix xfs_get_extsz_hint behavior with realtime
 alwayscow files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124961.1182620.16706223069367374184.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Currently, we (ab)use xfs_get_extsz_hint so that it always returns a
nonzero value for realtime files.  This apparently was done to disable
delayed allocation for realtime files.

However, once we enable realtime reflink, we can also turn on the
alwayscow flag to force CoW writes to realtime files.  In this case, the
logic will incorrectly send the write through the delalloc write path.

Fix this by adjusting the logic slightly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d63713630236e7..ae3d33d6076102 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6500,9 +6500,8 @@ xfs_get_extsz_hint(
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

