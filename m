Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EE857314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423235; cv=none; b=b/QlxlD5D1aIiTLnFjYWeUs6So55GLX+j52Nnbjz+5h4zf4qRXNBbiuzJfixm6rwGobcd2ie/VHPBvxgak1qYV73U6uKLGLqvvmH0/RkRMEUWpnzdrnMXIfvvhrfdFbUZSQKFMRxADfxmjVDU9qE0rbzABSm2JYoe7NgRoSriJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423235; c=relaxed/simple;
	bh=Io+jTxNWfM/A4Yw8tuhkbdbAk30IAW7OqXXb9mlpwYs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BCG0PRTjdCwIZEgAeXis7XHD8um9oX2g9MP4j6GHFhPu7HdVLVZDW8gRQvfR6fo+r42ClQ4FIyxUr0CIN6ZzKbKJaz8i4w3i9m7CMGPZdIr3rVbCpBihbnsYND0uedg7//G5/TBY/6SOV7RuidvWYhyK6XFnN0aOoHPdMvbpDFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pBBMxZHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pBBMxZHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F17C433C7;
	Tue, 26 Mar 2024 03:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423235;
	bh=Io+jTxNWfM/A4Yw8tuhkbdbAk30IAW7OqXXb9mlpwYs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pBBMxZHG/22XeRfyGqIPi8xJ8unshFuIjDiPTeqQlOfXWRk8gJIY/8f9ZG2x8OglJ
	 DH3gX1JxaH1d7pCLXytFzfqHkLY+CIwQydPjSHVAyJnwObiUEaGdmq5uK8A5zYhAA+
	 uE/YTNmbRLql5Ggv9//4FEwt6kzseX1J/J4tQAk9N0VwGx9/9vwMZM/Ik8xB51jB6F
	 gclk2L67u6OSqRIb90D03y613PeToPO3wPvxx1ujvDy8L/pR19BlYdhNw4vLM3c7kK
	 s7pJwYK9IYTf5mYz91Di8JtyzrW3388Up/U2JFLZzK78gYqlKQe/lp6Eh6R02oBPpD
	 9zOCREumP6LoQ==
Date: Mon, 25 Mar 2024 20:20:34 -0700
Subject: [PATCH 1/2] xfs_repair: adjust btree bulkloading slack computations
 to match online repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142128246.2213983.9506659892438571126.stgit@frogsfrogsfrogs>
In-Reply-To: <171142128229.2213983.6809200974790500472.stgit@frogsfrogsfrogs>
References: <171142128229.2213983.6809200974790500472.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Adjust the lowspace threshold in the new btree block slack computation
code to match online repair, which uses a straight 10% instead of magic
shifting to approximate that without division.  Repairs aren't that
frequent in the kernel; and userspace can always do u64 division.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 repair/bulkload.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/repair/bulkload.c b/repair/bulkload.c
index 8dd0a0c3908b..0117f69416cf 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -106,9 +106,10 @@ bulkload_claim_block(
  * exceptions to this rule:
  *
  * (1) If someone turned one of the debug knobs.
- * (2) The AG has less than ~9% space free.
+ * (2) The AG has less than ~10% space free.
  *
- * Note that we actually use 3/32 for the comparison to avoid division.
+ * In the latter case, format the new btree blocks almost completely full to
+ * minimize space usage.
  */
 void
 bulkload_estimate_ag_slack(
@@ -124,8 +125,8 @@ bulkload_estimate_ag_slack(
 	bload->leaf_slack = bload_leaf_slack;
 	bload->node_slack = bload_node_slack;
 
-	/* No further changes if there's more than 3/32ths space left. */
-	if (free >= ((sc->mp->m_sb.sb_agblocks * 3) >> 5))
+	/* No further changes if there's more than 10% space left. */
+	if (free >= sc->mp->m_sb.sb_agblocks / 10)
 		return;
 
 	/*

