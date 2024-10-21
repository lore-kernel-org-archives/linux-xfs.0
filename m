Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B552CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548374; cv=none; b=Z9LPFcoPy+RG60SYRDvmNA1i/VhvqVCYI0sOJQxUjViU2Y8BSpxG40PLRI0H7f10loyBv1z73kKdptzB0QYepAGfuqEpxr+vDAKJIwNF/nHkK8Gmka9UadmSuntO0qFfaNFnCrnZKln3gdRWh/2UP/GQWFlkkaCzQ+Na0MeDgow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548374; c=relaxed/simple;
	bh=lkGovIsttTsWnI5XxwaiAlstodfHJn2lT63mm52PJu0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RBu5BxhEme8F9yoTI6dnoKv/bTjHZgLylQNQvCExbTUb7D7yu8gnc1+ood+jLWfN226ejAlvsp/3AbF/r9PoNEnq3xsz8b6SzTx0Gq5SJJvznP7BTKJQVQVGGoy/soXhIzRm4xf6b/oVToX/Y1iSmmV5bVD9RY4hwtFfUAfIBGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8+GwuhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8+GwuhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62862C4CEC3;
	Mon, 21 Oct 2024 22:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548374;
	bh=lkGovIsttTsWnI5XxwaiAlstodfHJn2lT63mm52PJu0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E8+GwuhNyvHVgTi92Gmf0bjbXA93TUT3p8VtDtnY3ELkyowilteOq1zHSqzVVfWsJ
	 NMiNhp9lwz2szwkt4GKDSJO3tNOnGzZAovvs0+gh5cz0beUsXUKO/j6qPEx8bF9G7c
	 IhLTOcHg1Kw55iDmyG65UeFYoHa+PZC3Zhh0hCyz1sv8Mm4p8q3SQCBWuFh6dc2kxV
	 m64kEuAMegQ8S22E36RpQ9yfRksdcfUWvsgqqhgGCOpB3eBxykattAUBdyOZni6eVF
	 DIp/IG3AmYpTyIsTFJfpY69MydumLGTrnAmpXA/SaDLCpZNxbFYbpYZTsJdEDdFXuv
	 /HbdTXujwHYTg==
Date: Mon, 21 Oct 2024 15:06:13 -0700
Subject: [PATCH 28/37] xfs: ensure st_blocks never goes to zero during COW
 writes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783894.34558.13885243332803707200.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
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

