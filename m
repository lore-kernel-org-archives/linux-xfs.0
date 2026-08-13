Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9437C3D9DA1;
	Thu, 13 Aug 2026 05:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786598745; cv=none; b=Vr28vXYhOEoowOY7V46Ff1c4fGWV8kq5xXY1y2nCA18YdqpI7jS/TrfE2nhU3iq4tPqCOp44D74++HaFUHvGglqDEwyWbSL0tiJdYkp9s9d5xIX5H+Fc5URDPQhCcCsr0ibCNPjUbBw5ibGi/LX6B5s7bTB971ZCVBRaJvwv6lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786598745; c=relaxed/simple;
	bh=iQyGX+TvXmlJlAFIVIOt2jRXuHrq2StCJZHpeS/JFXI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=doal2Nlqccl92DQ46Ij0kyiX44Sxu+Adr6mxLYqtBu7fQluKsjNxizYH4qL6AlPUm40504hq0R1fdSbPUaFdJn/7KOF/pK/ciEKhu5efrwEFTcChaTTh+K9yf1LYhaiQB3wMADDgB+6QGvL//JNdgPSJsachgw6OcslVmhweYQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kFef4POq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFef4POq"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 30AC91F000E9;
	Thu, 13 Aug 2026 05:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786598741;
	bh=JyIPgucinyVOJrb//pRotBnp8f673kJ7k1OeBgxqqYE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kFef4POqXrBfrnEs4Aa4q2/E99NkPssuttjWVeRF63431OIVsN0zP9xkQRaol07u+
	 X1KllTtgmQRxgkXODAIFIvgXUbrgHy6Xeb1Rs5Ocn6R0QyEijdbw14qQv1B87TqHd5
	 1AXmBwnWOatynyrgXvjVHr6BK9yD79ZgbTnaXgMtRrlGqmg8KxSfBssCPOvxiJHXv9
	 ZwCykaS+jc00MzcDiTXVqLenvInxKHNWYM3r3WjMJjWNykl0a0CHXDC29DJtfO/oae
	 qcvF38lN3Ck5mpj+njXFdoC4MdEV4rJdo9oNfFS5is6JWwRwkZ0BK9J6HFohWudMSC
	 NMTlm5AJ59vKA==
Date: Wed, 12 Aug 2026 22:25:40 -0700
Subject: [PATCH 1/6] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178659861897.833922.17703139818760252058.stgit@frogsfrogsfrogs>
In-Reply-To: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

It's possible to construct an in-memory rtrmap btree for filesystems
that don't have the rmap feature enabled.  The kernel doesn't do this,
but xfs_repair will, if asked to reindex a filesystem that has rtreflink
enabled but not rtrmap.  Therefore, we must create the cursor with
enough levels to handle a maximally sized btree possible.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 4a61f12eb11958 ("xfs: create a shadow rmap btree during realtime rmap repair")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 0cb2113d5b4045..a15e460a1ec7f4 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -618,7 +618,7 @@ xfs_rtrmapbt_mem_cursor(
 	struct xfs_btree_cur	*cur;
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rtrmapbt_mem_ops,
-			mp->m_rtrmap_maxlevels, xfs_rtrmapbt_cur_cache);
+			xfs_rtrmapbt_maxlevels_ondisk(), xfs_rtrmapbt_cur_cache);
 	cur->bc_mem.xfbtree = xfbt;
 	cur->bc_nlevels = xfbt->nlevels;
 	cur->bc_group = xfs_group_hold(rtg_group(rtg));

