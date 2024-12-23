Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C9E194AE8
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995647; cv=none; b=VnVrrwCSo0Q5XbpwLdV+W6ctyEhk9OzIOw8zqqlSwfY3SXj3jTHX+/+sAftUUtQCbvC6QjgDya0lgDRH+mDc410jgksOFwaENQ44zIvytQzbLVYujgfoGGNzqugP3o5CaXtK1D64ooxuEV+LsoM4UoPnD3mSNwcy50w2BEG1Sr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995647; c=relaxed/simple;
	bh=ByPfk/XXp61zOcqBHegZJzNiuVEycV3NwP8idkgyA/c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oGO+pO3twEh3Ewrh6RJSByVio3c1ij2YjkG/23oUcgwPbqOlB6IgRtggzWF+6z5d5l3wMWocuuySNwY4I/d3QNb3kIC8I70QymxWTqtTVggXNQsSoRyu5p40zcQyqKdWgti3XilYQ4OBQs/2H/K+aNSDYlpfi4ACER+n5FWZdT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWpJvdWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWpJvdWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E425C4CED3;
	Mon, 23 Dec 2024 23:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995646;
	bh=ByPfk/XXp61zOcqBHegZJzNiuVEycV3NwP8idkgyA/c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HWpJvdWpZHw57MaUIigZEvJcOYl/dgjber8vxz+lKoxtQuDg+33pbR9+ZTkz1TbaW
	 qnnPYHPDoPayqvJk06zd0tYeV4yCRU6QMQh/j7dpzVdSomNuBUhuz9QnL7Ymz0QuT/
	 x7fGbOhPrIRPztoR1OLomk0csDpd+97RW1i6sMWA4Fr+HHHhlzdpCBcCOwl4wTH2Bo
	 LwtumPcnKAxLe69QAdpaV2FKhFLVgP1WXDX430BrZbOkyl+bRA/7yA0MzyYBuPU50S
	 zUPq+Xyf1IUm6OScNBIih5uuX2z+UIIE3PBAb5F2PZUITjm/YLxpzdx6dtU5UF2b98
	 zCqnzmuH/8Bmw==
Date: Mon, 23 Dec 2024 15:14:06 -0800
Subject: [PATCH 30/43] xfs: allow overlapping rtrmapbt records for shared data
 extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420453.2381378.10652201347907925710.stgit@frogsfrogsfrogs>
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

