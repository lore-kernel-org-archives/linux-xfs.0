Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1DB4C96
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300529; cv=none; b=gzxMcGUnDxg2+fxGC6SBI8ZUHqJEJZTP4gx7bxDpggYYuZ4JRxmhv8de4n7iMdaRZSU4LlLVbrAZnq7WF4VcOShQNdjcJlvgaMMr99+X7j2G5CWoaZ6RWhSElyayJyU3T7IkJ4VF1x0S7Kv79aiKtFnd+NOeMIkCOtkghgHXf9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300529; c=relaxed/simple;
	bh=e5ZtPDx+vU3HubB8yjGaccpbo8O9vMsRdvAt55Q5KQ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jog5Vv1biCmx2qBPKWPJq9uWRBg13WtMiEhpyRWp02qH/kI6MVAHNtpTMkCQm6qOT0peVgbD01wLP0ciHQyrKg5S71xmPQNKsouUewSm2AjcwG9WG7akAc06idV6wGJtv6tIpa0fUDgFJNL700bOgP6ixwmE1shacpVqTRb3amg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rSS/3Jpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rSS/3Jpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CD5C32786;
	Tue, 30 Jul 2024 00:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300529;
	bh=e5ZtPDx+vU3HubB8yjGaccpbo8O9vMsRdvAt55Q5KQ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rSS/3JpuhIdGGN1x+zGtuvwEfeR48irnrBUz3pRsU6HM26AIkXHED7NeMy5H+azuy
	 K9qFvcm13CV5h3ea2+6zbqSJK/huA73evohozmHKXjEhYmqc6TAASP5w9dYDm0dXih
	 IZxi9TdOBndrv+uB27TDE9bbrQQYvtYjrenvMPlf/64fkK+KvX/KE4+3ftZK0TpEyJ
	 /SY1DZsc0M/ckHAcAd6c5r8yp4MUGu8+k8cPdnjRGQOzkc45/TKmZZz/kXBgLJnL9t
	 oqLlv0ndgZ8QazINDZx8uASttW4nW7+MCr7pKyJ2a+3Gi5kMXUCBWB0voICpK/T91I
	 /xGZ5YiROeGZw==
Date: Mon, 29 Jul 2024 17:48:48 -0700
Subject: [PATCH 096/115] xfs: lift a xfs_valid_startblock into
 xfs_bmapi_allocate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843815.1338752.10953977831049178873.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 04c609e6e5066294b60329420d3711e990c47abf

xfs_bmapi_convert_delalloc has a xfs_valid_startblock check on the block
allocated by xfs_bmapi_allocate.  Lift it into xfs_bmapi_allocate as
we should assert the same for xfs_bmapi_write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index f236e40d1..5b1c305ec 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4215,6 +4215,11 @@ xfs_bmapi_allocate(
 	if (bma->blkno == NULLFSBLOCK)
 		return -ENOSPC;
 
+	if (WARN_ON_ONCE(!xfs_valid_startblock(bma->ip, bma->blkno))) {
+		xfs_bmap_mark_sick(bma->ip, whichfork);
+		return -EFSCORRUPTED;
+	}
+
 	if (bma->flags & XFS_BMAPI_ZERO) {
 		error = xfs_zero_extent(bma->ip, bma->blkno, bma->length);
 		if (error)
@@ -4707,12 +4712,6 @@ xfs_bmapi_convert_one_delalloc(
 	if (error)
 		goto out_finish;
 
-	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock))) {
-		xfs_bmap_mark_sick(ip, whichfork);
-		error = -EFSCORRUPTED;
-		goto out_finish;
-	}
-
 	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
 	XFS_STATS_INC(mp, xs_xstrat_quick);
 

