Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E9C1CDA30
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416560; cv=none; b=jJVXdEhlAqN2Q5DB2q1ehU9OziUZIT/HWCKzbWKbXqwQ1u+SKYdR8qpjz46Iu8Q3n3Jzt4bvC96ycSojBo48/dC1bQGUGffqjk6/liBWj+4d05mHBmgSImJbZY3WutXEJmEnRwhQTlHr2ho2can7H9D3bpdrsRX1pp8B+w21x7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416560; c=relaxed/simple;
	bh=lkGovIsttTsWnI5XxwaiAlstodfHJn2lT63mm52PJu0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l3s2fGOhPqJsCR4MlkfrRSM1WMmrqY+1y5RBcNqf2fGNORN/r1H926l/Qax3DAKnypuhzFaxIeB6PBAA047flKMp1DLL4oxuVoIMV0pBILTbNGjGsKvgPJ5W9eyfWC0rIdBS8cWvAa/UOndEEGgonO98qkVyPZHbXZlMWw7+wOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ExVC1KN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ExVC1KN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02431C4CEC3;
	Thu, 31 Oct 2024 23:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416560;
	bh=lkGovIsttTsWnI5XxwaiAlstodfHJn2lT63mm52PJu0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ExVC1KN5aur+gTjn84j51y+2QDGyhflIfc2sEd2UPP/Tz+L5Y77jbxEjfykAFqM+X
	 SXaOVHHCAGjIVKSt2/z6KYBy66U9Bmk5G0yD90VaVtRSIncQNtPY9cMhvph62rxdRr
	 PIYspNg0fxrk7Z7q7vAMUu4DWJheKaaz95featTejzjt5LkU0HJynneVWp+0Xg6MC/
	 VGObfNWx52X5APdWRwRI5AvMk2igWuPx5TDYALP3LDxLyFZrWrQHV8noTSYhNVKaTE
	 LqvoMXTsxKO4Y4b+pbT7RcuFmQ/+8KmVWytqo8Nf5GT+8nhNfQiiBijVeHSdvMi/v/
	 lDZl2+uepQx0w==
Date: Thu, 31 Oct 2024 16:15:59 -0700
Subject: [PATCH 28/41] xfs: ensure st_blocks never goes to zero during COW
 writes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566344.962545.6846033905640077089.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 90fa22da6d6b41dc17435aff7b800f9ca3c00401

COW writes remove the amount overwritten either directly for delalloc
reservations, or in earlier deferred transactions than adding the new
amount back in the bmap map transaction.  This means st_blocks on an
inode where all data is overwritten using the COW path can temporarily
show a 0 st_blocks.  This can easily be reproduced with the pending
zoned device support where all writes use this path and trips the
check in generic/615, but could also happen on a reflink file without
that.

Fix this by temporarily add the pending blocks to be mapped to
i_delayed_blks while the item is queued.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/defer_item.c |   14 ++++++++++++++
 libxfs/xfs_bmap.c   |    1 +
 2 files changed, 15 insertions(+)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 98a291c7b785e1..2b48ed14d67bcb 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -520,6 +520,17 @@ xfs_bmap_defer_add(
 	trace_xfs_bmap_defer(bi);
 
 	xfs_bmap_update_get_group(tp->t_mountp, bi);
+
+	/*
+	 * Ensure the deferred mapping is pre-recorded in i_delayed_blks.
+	 *
+	 * Otherwise stat can report zero blocks for an inode that actually has
+	 * data when the entire mapping is in the process of being overwritten
+	 * using the out of place write path. This is undone in xfs_bmapi_remap
+	 * after it has incremented di_nblocks for a successful operation.
+	 */
+	if (bi->bi_type == XFS_BMAP_MAP)
+		bi->bi_owner->i_delayed_blks += bi->bi_bmap.br_blockcount;
 	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
 }
 
@@ -541,6 +552,9 @@ xfs_bmap_update_cancel_item(
 {
 	struct xfs_bmap_intent		*bi = bi_entry(item);
 
+	if (bi->bi_type == XFS_BMAP_MAP)
+		bi->bi_owner->i_delayed_blks -= bi->bi_bmap.br_blockcount;
+
 	xfs_bmap_update_put_group(bi);
 	kmem_cache_free(xfs_bmap_intent_cache, bi);
 }
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4ee8d9b07a0ca7..c014325a5d7d9c 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4850,6 +4850,7 @@ xfs_bmapi_remap(
 	}
 
 	ip->i_nblocks += len;
+	ip->i_delayed_blks -= len; /* see xfs_bmap_defer_add */
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (ifp->if_format == XFS_DINODE_FMT_BTREE)

