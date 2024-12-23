Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B13B2837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995537; cv=none; b=qGEX4LZ09jgudIFk9+PlMQMqLKC6fnjtazijJ14+7Ex5i3mlScaWqjsx4bNmTKOM4TnyF/kAot74xEgqQqifeI6Gvzdw1um1gMmSMWcRC8PBjds/D6cAFQ5swAUfhWjqoPmxMyZWhuni0lkQsq8nKwNtG6dnv6wpgwc/xmScd7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995537; c=relaxed/simple;
	bh=VRLOkXc1cCynwrHe5ZW4IxKjxfg05aSERfyWn2Adics=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=izV9JhdkHlu87hLTJ5/ylWK7IxfqjOGsyGIZl3hc5g0Oekfzmqxcx0W9lwPiFTn8o2HEaWM8TMp6S+q9bMOEBnfoC8qhV/AVL03rp5zmBwEbj2LZHanSy016WNrF8CN+4+Ih75ikS1iyKbLt48imkKl2kDWNode52k1oj1z1+y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9eNY0Zs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9eNY0Zs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5129DC4CED3;
	Mon, 23 Dec 2024 23:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995537;
	bh=VRLOkXc1cCynwrHe5ZW4IxKjxfg05aSERfyWn2Adics=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h9eNY0ZsEtDKlyvMItzNDMogo9QTnElfjiOX7ZlI1t2H8LyfCVYpXT2COVlZI9CY4
	 Wn4TWaiidAnoYMpY85L2+L5Yp1WTw4/r5PqaA0EHfPYVpkhRlkk30oyuhJ5/08EQDA
	 hY/FLRCw4U3WQOE1w6PT2UJytoZAu+46CmHE4DFq4eqvXruv4eB9n7z4qro6n++S2i
	 e37yBdhL6AxtsoqTQs+wEdeoL9TFDMI+CQbRSmBxpZwz666/bXt4Yu/iZVo90YnoXu
	 zrx39l/8fxa81VPKfwmlZO4lbeLvisLllgFqJwmmYKPes8lf+5dy8PpNge7J+v7QHX
	 fzCGE/eyXgtWA==
Date: Mon, 23 Dec 2024 15:12:16 -0800
Subject: [PATCH 23/43] xfs: fix xfs_get_extsz_hint behavior with realtime
 alwayscow files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420333.2381378.7463011044780185856.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

