Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B72439340
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871561; cv=none; b=cXoU8SWnpGSfTLflm3wqRCWn3FVdamDid2LgqfQjJ3uUwwwpPqvSAB/2+tDj3jo94v1SW97AKFRRdVvNzgI2kB5gMQ8KFjs25k97yGsiEX63YVcS8/BjoM1R0EbbN1QVU47vZP0gV6SNfAEWJWB9O86HF48yvBp8jku/bLXa6uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871561; c=relaxed/simple;
	bh=9WCfjWiJLO+se5d1BxCBgyePnTXPj67+8h961SYMosE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i/3656KOvNrs7FgavmcsZy3v7qOsEZ+VkIFKTviP1cri3m/e2CN857Wnqp8alQO3CXkHjzw7VY7O50P3TsvjIhBARfTAPrAkM1stix5fT/UK8z+jF1X2VGbgTZ+KI6ue+bv0jLIGmc+w6KOJuT71lFAKm/Q39wyrEg1GUWSeOig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8Wf/o2n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8Wf/o2n"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BA9561F000FF;
	Tue, 13 Oct 2026 06:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871559;
	bh=2i1saqC9R9UowHcUAua+Ax2URMzbMfFVhQDM67b8DQ8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Q8Wf/o2na0NeCswoMwUvBK/32SQqv5uP+wR8KQLpxfG93cjs5V2GKwqHPTG4rTRsG
	 A+t3P4WnX+pFVd5mLAekjncpiyXk5wWo4E44hosOKp6911iZY0jvVzr7yVq0/Fw9hS
	 Q9/RlB6IDLVCj84RXe3wOJcApKgi+IRwVcKKHafckVrk4/PYLCAduQX4BqRXiUWNKY
	 GRPNzaLzAjozPsp23ZJwyXl1W/pJwU4BvPWxB0m9+7PuQpOjhwR99DiEZGDEOUsOn2
	 EcfoEXblPaWMLTg5kuYChW3GyZuU82ZiJADhCV+RhwCmvYzEPoafqnfvYLzrWX4GgD
	 0+P/im3Vvk94w==
Date: Mon, 12 Oct 2026 23:05:59 -0700
Subject: [PATCH 03/12] xfs: avoid oversized space allocations when
 regenerating metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179186107203.1898400.12816656579213384487.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that the btree block preallocation code can be asked to
allocate more than XFS_MAX_BMBT_EXTLEN blocks.  If the allocation
succeeds, the reservation will be stored in a single autoreap record.
Unfortunately, the autoreap code uses deferred frees to get rid of
unused space and that code complains if it's given too much space to get
rid of all once.  Fix this theoretical problem by constraining the
allocation size since it's unlikely that we're going to need that much
space for a btree.  We don't fix the core code because the runtime users
of deferred frees are freeing file space or single btree blocks and we
want to catch problems there.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/newbt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index a7554f925b7440..1f28ca1647f8d3 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -280,7 +280,7 @@ xrep_newbt_alloc_ag_blocks(
 			.mp		= mp,
 			.oinfo		= xnr->oinfo,
 			.minlen		= 1,
-			.maxlen		= nr_blocks,
+			.maxlen		= min(XFS_MAX_BMBT_EXTLEN, nr_blocks),
 			.prod		= 1,
 			.resv		= xnr->resv,
 		};
@@ -354,7 +354,7 @@ xrep_newbt_alloc_file_blocks(
 			.mp		= mp,
 			.oinfo		= xnr->oinfo,
 			.minlen		= 1,
-			.maxlen		= nr_blocks,
+			.maxlen		= min(XFS_MAX_BMBT_EXTLEN, nr_blocks),
 			.prod		= 1,
 			.resv		= xnr->resv,
 		};

