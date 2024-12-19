Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5921990BA
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637142; cv=none; b=uw1M+TxBIJZbwRJXH+eB1b+0kyawFlpEkmakOURLZ1n8kAQ9bTWXbEtK41IAnVZYRedN8WvQkQaBYIsyJSVVIb09vOngioD9O7WV0G6zTfbvsc0SHn1KxDUbfzpm/iGqbxhz+G3+GJTJmZNfkdxcUoqHflQ3fxL2NHFWDvilY74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637142; c=relaxed/simple;
	bh=VRLOkXc1cCynwrHe5ZW4IxKjxfg05aSERfyWn2Adics=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r6eDhdfeyB8iZXqy3uu8kPfQQLOMIVCMNrE5s+ljqPxJMKcn/S4EPOBL3yiUcnd5EqUzPCjIMQdTXlCE17fL8ZvN4ua1WablBpN7yJkkss9e6TxZcnsbfJQlhH51gqP0/iSSWDZYJxpbRwFIJxd8VfqPrj31tpUtb1oCrb0Y1sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WWzL6skB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WWzL6skB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FE0C4CECE;
	Thu, 19 Dec 2024 19:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637142;
	bh=VRLOkXc1cCynwrHe5ZW4IxKjxfg05aSERfyWn2Adics=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WWzL6skBeQIYrsfcph8N0JRr4dNNEHimYYZ7qhEDiQiitYEp5KfrHoPONFdlIVZqH
	 rFBFs9g5J5s77OQ/1Uj8SvKeCaC6RAG65j+Q9T3GU+Gera+BnTNEn6K7h6hbERMORg
	 KasD4YEeJ34u2TPWhFed+2Ej2K1PlEYU0MXwhnTCPxVKo/VYjG9oEGM4o/n5shv39I
	 NeMuMlUqDyRm6NKKlfZwmNbgP4PakD7uCqWe4Gzu/UC6aZ6QhWLUOOPCvNN1rg1VQe
	 triod1kpY9CAoxWCo7mAJqTFPlXLBCOGI8G1g7Xo3ByvFGUS+9zWXP50Eb+XQHldni
	 WdF8lGtdiTOeQ==
Date: Thu, 19 Dec 2024 11:39:01 -0800
Subject: [PATCH 23/43] xfs: fix xfs_get_extsz_hint behavior with realtime
 alwayscow files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581372.1572761.7820351190559401263.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
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

