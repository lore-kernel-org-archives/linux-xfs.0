Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03EA35E1B0;
	Mon, 27 Jul 2026 05:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129781; cv=none; b=rkqmKFuPav8l1YeB0SiIMP4v+vxg9ZeJT275AHXtUA4LpZspH/Mk1nAM9UsiGVxKg8AXqlsD9ItElAYWiTn36v1OGxr5vZoSvg40CUL98l1HKgGh9Q3ceJFLhhNoW0Rc+q4dB/3K/4YVxNKcTsvRTZp3lRhnV5f6eE7Y51UXTsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129781; c=relaxed/simple;
	bh=iG3xF+5/qaGt8oIG0+IEwtjf/f2Nv28EzWfFK1nVOL4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hrvd4V7611H3U3jscn8+QFOiX/e56/Dku7/Y8OWcgvP86SqFarUOu9Xfqz4EqGVExNqDQZrLuSkttyDqzhqy2MdZAExTqoIlQR05C3Wv4vXZfaRXcH9Xv3CSlb4kWZkPEjvGFijCPN56BOA/AUHLs7guAcd2WCNNBm/AtkIrdL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K1eR9f3w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K1eR9f3w"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6D21A1F000E9;
	Mon, 27 Jul 2026 05:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129780;
	bh=SAHw5xvZTwvRf7YdBqhXD5HXJAb2iLY1rEFSvv73sBo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=K1eR9f3wmBwg7DfO6SQNZpSQYrRwleoUP1l2vR+hGuAFsqCfsqhZwrDEQaXD8kNwI
	 9wp2zO7vHU2BHZBG+XIgC2+e6CuHnU5ri/J5Zo0qaMHU2fjBj5+IJ4Cxw4iS7iayfY
	 fduYmKetf2aU9dEifvDFLdeiqnRrv+ppALhD5VQrmV6U5QvdSdE1P/6CdcTaElJrhv
	 PYnVwDRCaWRc5I9r4YOPcQA7kVIU0DiKm5vOWOGpbCop6k8sNAKC706/fvpNZrc7f3
	 9FI8xPV7wpg3H4GrGwil/17afir+O/9oMcWW0EHiFRgv67Xybxt9n7nyCaNejbKvPT
	 7eaQQjPMR9nkw==
Date: Sun, 26 Jul 2026 22:22:59 -0700
Subject: [PATCH 1/6] xfs: only check mergeability of bnobt records
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389188.1494795.14947801918852932395.stgit@frogsfrogsfrogs>
In-Reply-To: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
References: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In the cntbt (free space by block count) btree, records are not supposed
to be in startblock order.  Hence the mergeability check is pointless.
Remove it, since it does nothing, as LOLLM points out.

Cc: <stable@vger.kernel.org> # v6.4
Fixes: d5784ae82778d9 ("xfs: flag free space btree records that could be merged")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 48edaa2cb1e079..c666be69f16481 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -136,7 +136,7 @@ xchk_allocbt_rec(
 	const union xfs_btree_rec	*rec)
 {
 	struct xfs_alloc_rec_incore	irec;
-	struct xchk_alloc	*ca = bs->private;
+	struct xchk_alloc		*ca = bs->private;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
 	if (xfs_alloc_check_irec(to_perag(bs->cur->bc_group), &irec) != NULL) {
@@ -144,7 +144,8 @@ xchk_allocbt_rec(
 		return 0;
 	}
 
-	xchk_allocbt_mergeable(bs, ca, &irec);
+	if (bs->sc->sm->sm_type == XFS_SCRUB_TYPE_BNOBT)
+		xchk_allocbt_mergeable(bs, ca, &irec);
 	xchk_allocbt_xref(bs->sc, &irec);
 
 	return 0;

