Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96ED2C21D8;
	Fri, 11 Sep 2026 05:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106021; cv=none; b=jt2akq9aBjgyPUVgioznSFFj+Uf1XNS5jmuScbvCK84haFyrQxmhSUDQvlmQ5WanvSewwZwXAtRfedlPH6I+z1ebr4Sv38kjmfq1suo47+UKeJf0BNwU4N4C6U90qoULvuDnXeM4FUYW0739PgzKdHgI1mTNNPgTWse5uncQ6KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106021; c=relaxed/simple;
	bh=WdTpimBvuqoHQojFFK5k5Q5mRryS2y8wUFyewx5P8bM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z77a8spF40rp4UhBYbeqwvjf+oMjTzwFtZkz/UJbSOAuRDy4QMtFBz7oOHoSeMlpqx7pgJ2raaSUUQW4i25Ldeovipist4kjrHsqsxGeXmlMKLconnpqBtkX9odK5iiIwJKJBCFbLglBFDpBKKFGgC/SlXp3TOUSleqz3r6s/bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITyexjZ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITyexjZ2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4D76E1F000FF;
	Fri, 11 Sep 2026 05:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789106020;
	bh=HBlzlk8FB6byTGAPB37u/x69FPOCNgu3NtGTwYg9DrM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ITyexjZ2Pal9A2eImzmf2bVJzq4NLwN06QHDoj3CM6obWzcgxOFvYNYchmNNwRmwU
	 y6ljZASF2uTsBkCr2j6tfNRR3x0kKGaJ4QR5f6O70GtNLsceL1PMnRBUU/mtUZ1ZzZ
	 ySCZwi/bglXeMdxzhyvoJYWal0u2rDcMfYmLs6VujqmwcOQyz6I81kg6aJbA7Mbkq8
	 7YBYWZA2pPab0akcCrT+j49HLAE9t8LX8IODg8PGJmDBB8avShtQU/TnRAdcS1/FpV
	 ou+h6qhTMAN7yXN+bKaoTna3iPR4Bo6wIoidGWIaWQr5dWItXg56/wRoL12xWiZn9S
	 rlJWh7Mk43q7w==
Date: Thu, 10 Sep 2026 22:53:39 -0700
Subject: [PATCH 1/6] xfs: check padding field in xfs_ioc_commit_range
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178910162042.174887.10361947656955266052.stgit@frogsfrogsfrogs>
In-Reply-To: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that we don't check the ioctl padding field here, so
let's do that.  I don't think there are many users yet since exchrange
requires a new feature flag, so it's a good time to try to plug this
hole.

Cc: <stable@vger.kernel.org> # v6.12
Fixes: 398597c3ef7fb1 ("xfs: introduce new file range commit ioctls")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_exchrange.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index c69ecd6a19de4f..07090487c581e8 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -902,7 +902,7 @@ xfs_ioc_commit_range(
 
 	if (copy_from_user(&args, argp, sizeof(args)))
 		return -EFAULT;
-	if (args.flags & ~XFS_EXCHANGE_RANGE_ALL_FLAGS)
+	if (args.pad || (args.flags & ~XFS_EXCHANGE_RANGE_ALL_FLAGS))
 		return -EINVAL;
 	if (kern_f->magic != XCR_FRESH_MAGIC)
 		return -EBUSY;

