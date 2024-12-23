Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA9B2837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994943; cv=none; b=csDTbNfkFuv8AShrY6hdg1iMkabuxpJuqrFSdn3IoAvlqgrldzLbeQYTORRgtbjH4AS0dIuTycvMUJ63hEF1yOxt/yPykzldFuKmrYsvKK22/iZl3drULp+eifnCYkU85Jhj4YHn7FzbOzTeoj0CsGrX3fXykzKiRzvDO7RWTQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994943; c=relaxed/simple;
	bh=btFNYgGxjZJesvHa1HZnZ5aBoD4kVJ6xlGRjoeLWD+0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WUvSpBSmiH4AZQLLoTLnaMKexfKSP9RRqSwQ/qSY5VfD0l39SGGEdFUaFIgHt01UTradThW+el5zuIBQS1ifw3hbtruuDiRFy/HHoKHFDTx/wD2yiO7AtW8pAb1ArSq3BFo1jDhI8ckkyK6/0RULvlKiEpabyEJAOdmlTqDEfgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s3yznO25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s3yznO25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892DDC4CED3;
	Mon, 23 Dec 2024 23:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994943;
	bh=btFNYgGxjZJesvHa1HZnZ5aBoD4kVJ6xlGRjoeLWD+0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s3yznO25U1uAOxU8Hwk7uwbpZD3odpaiPnpHtM5k0E611xCEa3vW6oSXMYnNpcvPY
	 SghHa0F/Zy9gTnGKjKayMxiO3PzEQPKnABS7g49bD/r0ahgRpSGiUFwqXNZOdglWKi
	 frDppb59Fl7gAlGNRBF7ruQmKi8LqL/ZsdLyEt1Abc8+Wtjjpe9SXYgpa2vNA9CDSB
	 ZtPX0E/SfXHevyQjcbaKm6uMTA3Alp1DKiYczL5tt3SneH9uYRvklPbcTXp2ez8TXJ
	 SUC8JcJeQjpevjrT+ZmjV89ymiGNEwKF/pE08jt4EmbEqrZRR+O6Jx4U+uhwErs90F
	 A+0W5MOvMwx/w==
Date: Mon, 23 Dec 2024 15:02:23 -0800
Subject: [PATCH 22/37] xfs: cross-reference realtime bitmap to realtime rmapbt
 scrubber
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499419097.2380130.9752227538996480381.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're checking the realtime rmap btree entries, cross-reference
those entries with the realtime bitmap too.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rtrmap.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 7b5f932bcd947f..515c2a9b02cdae 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -142,6 +142,20 @@ xchk_rtrmapbt_check_mergeable(
 	memcpy(&cr->prev_rec, irec, sizeof(struct xfs_rmap_irec));
 }
 
+/* Cross-reference with other metadata. */
+STATIC void
+xchk_rtrmapbt_xref(
+	struct xfs_scrub	*sc,
+	struct xfs_rmap_irec	*irec)
+{
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	xchk_xref_is_used_rt_space(sc,
+			xfs_rgbno_to_rtb(sc->sr.rtg, irec->rm_startblock),
+			irec->rm_blockcount);
+}
+
 /* Scrub a realtime rmapbt record. */
 STATIC int
 xchk_rtrmapbt_rec(
@@ -162,6 +176,7 @@ xchk_rtrmapbt_rec(
 
 	xchk_rtrmapbt_check_mergeable(bs, cr, &irec);
 	xchk_rtrmapbt_check_overlapping(bs, cr, &irec);
+	xchk_rtrmapbt_xref(bs->sc, &irec);
 	return 0;
 }
 

