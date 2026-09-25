Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F27F284880;
	Fri, 25 Sep 2026 04:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309604; cv=none; b=iRdab+RAhgEfXEowqyRN68u+Fs2NdV+NxGPfLprtjg25sC9h83FuHSnxkNuFAmmoJrFn7mpjq/KmiQpaSaLcEEGVp4CP3VJ+82JFTOpXmyLB/vc/CE7bhavrB3lPD8X0K87a2yVtqzAPtYnpGc0zBnV0yEIt36NoJdZ23g74Uro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309604; c=relaxed/simple;
	bh=e1IS1fnxWTq/eMZWiCv9FDDt1v3qz7prCzgirYb+gSE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OtbOkl+L3lkwMC82gL5xJuvTvrqL+g0eN6Yp4h5f8mAOAeUd5rQKyTuBduyIyKegCgeWSDW6ci5WvgA12tSkeIyKhFLuC7GyYL1jKasccaNhIu6jQABXLAligj6a+m0G8bM5zFbij2r+gd9XVGUhcsGLqadtvA82G6cwqGQDkes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XVT0Q/x3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XVT0Q/x3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 089391F000FF;
	Fri, 25 Sep 2026 04:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790309603;
	bh=oL1DSWkhakaFURSuCPfjGY2TUPFAVmVFszVC3rhy8wY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=XVT0Q/x3uCGQaGW+DxfMCbGaE022ILMpo4qQ7EseQzj3tvviMd8ACQvEqtUfEOQMZ
	 vNNG+T7h2VLa99G2F3jUchS7Waqoj+Th+ITg4Czf0NA3uPRGUVEkkMw4mWK+tYnNsW
	 79De+057jNNQPzdFN2WqIiTDTyuO5uQF2kwJwZrcXz//4yQpvzd5v+4GUfZc9A1lCg
	 ya7d4QfClJRgV099jh8g8C1Qiz3/Fdc3+52TupQaBDXt7Ih0C6xeiKQExeaQp8RsML
	 /e8TntPDEe9Gz9nvh8XKHkTZTEepEjLbcb5v4xy0jExQgr1EPQmlkgvwSe1/shenah
	 2StinQVoM+i8g==
Date: Thu, 24 Sep 2026 21:13:22 -0700
Subject: [PATCH 11/12] xfs: mark overfull dabtree node blocks as corrupt
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179030932282.3344850.1828907677637994070.stgit@frogsfrogsfrogs>
In-Reply-To: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that we need to range-check the dabtree node record count
before using it to index an array.  Fix that.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dabtree.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index d4e5afbde85613..72cd880a5745e7 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -439,6 +439,10 @@ xchk_da_btree_block(
 		node = blk->bp->b_addr;
 		xfs_da3_node_hdr_from_disk(ip->i_mount, &nodehdr, node);
 		btree = nodehdr.btree;
+		if (nodehdr.count > dargs->geo->node_ents) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		*pmaxrecs = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[*pmaxrecs - 1].hashval);
 		if (level == 0) {

