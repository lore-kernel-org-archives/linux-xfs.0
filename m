Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0104A1990BA
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637252; cv=none; b=qIQn0XCJJO47+v/DAyqjBA77oHh3sM8Ii9g2v+ziXjrjDpQbyZcJPPqq8G6EbunHOMWK9p6vRdAt0mcCzCdq8tLwf/03iD7KpP7Y3BaBhwM7Odmmq94kZE5qytzRNSBapxOwGnndX75H+ZHEh6/MKiqTv7Q9ZoVUlpqVbOmLuAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637252; c=relaxed/simple;
	bh=ByPfk/XXp61zOcqBHegZJzNiuVEycV3NwP8idkgyA/c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UCFk9pz2kNyelhvsVMRJcCx3b0M0azKsI5V/bBBd2Obc2kUEMbxs2qsdBJQdIJhvzWJg5cI4Mx0emMFTkXap8XiIe5KH7qWybmtfWI9b1mPo3j9eM803TfO1mkWN5E4GP/bq1xky8OiCocr+jRzhLidXvuc0CJQ4gbRV9ye94+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hh+RPcxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hh+RPcxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9142EC4CECE;
	Thu, 19 Dec 2024 19:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637251;
	bh=ByPfk/XXp61zOcqBHegZJzNiuVEycV3NwP8idkgyA/c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hh+RPcxs7OnWHM5y3kikE87TgEkr8Hgf6w0hgQ72hueBQrz+GRbSWxTve+8vH3qCi
	 qsS0WXnfoGMbB/dGJjFvwRHcA94lhxJqCKJPjZGZiU7LNqCbd0GSxn0/sSY5wd9eYP
	 lbjLoH/31FRjjJpMllfs3elOavesziByn23UPaYZ5AMv77aefpwScpZfRZNRx0n182
	 OpUj6DeEQxoLtArUG8F+I1qVlaCXUb/7Db7YQfzVzLLspARvYPBXNIeX+cbThY4VMO
	 JVE31bBLHZJ35lAiQzIred6jAtrFrpZi0VF5xMSeyRu9HbiCi5VSeA7IZTdqcHRX52
	 voIzFtjIpuJxA==
Date: Thu, 19 Dec 2024 11:40:51 -0800
Subject: [PATCH 30/43] xfs: allow overlapping rtrmapbt records for shared data
 extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581493.1572761.8605561965960541842.stgit@frogsfrogsfrogs>
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

Allow overlapping realtime reverse mapping records if they both describe
shared data extents and the fs supports reflink on the realtime volume.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rtrmap.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 3d5419682d6528..12989fe80e8bda 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -78,6 +78,18 @@ struct xchk_rtrmap {
 	struct xfs_rmap_irec	prev_rec;
 };
 
+static inline bool
+xchk_rtrmapbt_is_shareable(
+	struct xfs_scrub		*sc,
+	const struct xfs_rmap_irec	*irec)
+{
+	if (!xfs_has_rtreflink(sc->mp))
+		return false;
+	if (irec->rm_flags & XFS_RMAP_UNWRITTEN)
+		return false;
+	return true;
+}
+
 /* Flag failures for records that overlap but cannot. */
 STATIC void
 xchk_rtrmapbt_check_overlapping(
@@ -99,7 +111,10 @@ xchk_rtrmapbt_check_overlapping(
 	if (pnext <= irec->rm_startblock)
 		goto set_prev;
 
-	xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+	/* Overlap is only allowed if both records are data fork mappings. */
+	if (!xchk_rtrmapbt_is_shareable(bs->sc, &cr->overlap_rec) ||
+	    !xchk_rtrmapbt_is_shareable(bs->sc, irec))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	/* Save whichever rmap record extends furthest. */
 	inext = irec->rm_startblock + irec->rm_blockcount;

