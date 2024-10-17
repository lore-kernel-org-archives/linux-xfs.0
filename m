Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF58218D9B
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190880; cv=none; b=QP0lk715Rb7dOK8zL2otPt2v1+DAA9nwGj1w0Uf/MKoWbJQBphzM0CLHIN1lvJzVgwJntWR0VRt7bQYYDyYgGQQMCqrNo3RhgpzUJTorE8rH1P0C5hPJTkIttKjyFxMSvxCgD1Z6sP9jwVHj5ExC1iYDmmFScRZKKVUfs2AHnGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190880; c=relaxed/simple;
	bh=+5fdu8qdFmVeFNAafbi/xcOTSlv9WIAZG9bIXIFrS9s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kPrcOKjq/4eEG2652UdLgocSaXvenbOy9P//8I0avNIpwVBEiMkP/oV6Kc+YH3LGbAvDY5VkhqV2LUVY9pMf+yFvwIpPCJTmwwpiLBtGHmd9SW/r2Jw8yTOPVnH/Sp09LufL/t1tSyBUujmmM6Ggh/8P59smB0g7J6VX8wQQfLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k61EtU+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k61EtU+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AA5C4CECD;
	Thu, 17 Oct 2024 18:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190879;
	bh=+5fdu8qdFmVeFNAafbi/xcOTSlv9WIAZG9bIXIFrS9s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k61EtU+sqgq3Bvfmi/oO5VCXUuhvO/5qCzi6Be4mUzHaQvx4z7DwtAuI761H+h7PR
	 sdqfVpgyZ1sKif/AIoO5iQQSe9yK2/+CqpWrvc+8bIpICvmjymyykV9Tgm9oZclBs0
	 vkEzBuU1THhnjVEuukZXDufUpYU60ydThT5BbvsPrPaGu6lttGPniAHMPt6Y7ERtma
	 sa5EPzVZSsWbDKVGInAIldk5JDP5DFNkhWeTJLqU/GmW9oA+f8MyLgayaHf6kwNyjF
	 E5hC2faJ7pKOdhhZazeLOGoVYNG6ECMk+C1j0JZNy6bRPKT2uk4QClhY9gklwgtVAD
	 S9t+6iiCVMO8Q==
Date: Thu, 17 Oct 2024 11:47:59 -0700
Subject: [PATCH 01/22] xfs: fix superfluous clearing of info->low in
 __xfs_getfsmap_datadev
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919067875.3449971.12158120435530517646.stgit@frogsfrogsfrogs>
In-Reply-To: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
References: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

The for_each_perag helpers update the agno passed in for each iteration,
and thus the "if (pag->pag_agno == start_ag)" check will always be true.

Add another variable for the loop iterator so that the field is only
cleared after the first iteration.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index ae18ab86e608b5..67140ef8c3232c 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -471,8 +471,7 @@ __xfs_getfsmap_datadev(
 	struct xfs_btree_cur		*bt_cur = NULL;
 	xfs_fsblock_t			start_fsb;
 	xfs_fsblock_t			end_fsb;
-	xfs_agnumber_t			start_ag;
-	xfs_agnumber_t			end_ag;
+	xfs_agnumber_t			start_ag, end_ag, ag;
 	uint64_t			eofs;
 	int				error = 0;
 
@@ -520,7 +519,8 @@ __xfs_getfsmap_datadev(
 	start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
 	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
 
-	for_each_perag_range(mp, start_ag, end_ag, pag) {
+	ag = start_ag;
+	for_each_perag_range(mp, ag, end_ag, pag) {
 		/*
 		 * Set the AG high key from the fsmap high key if this
 		 * is the last AG that we're querying.

