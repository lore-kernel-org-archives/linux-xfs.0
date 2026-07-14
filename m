Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8118F372696;
	Tue, 14 Jul 2026 06:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009236; cv=none; b=hhgcXt9wSvJGRnKi06cIlr0HqB/O8QzPtLY2vOO5ziFGlDydA+3IlHSEagIfSAPd1VazXTZKErr1hRnUVFCsi1mfcUPhwxh614YhQZRMN18w8mQUrAOoXJCF55TiaJ/ZGbAImdzoO0Fyjm4jWnZY4FYWUvA5AnVSEBT8fZ0QyBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009236; c=relaxed/simple;
	bh=EIKwocMY9Mz16Gz80xSOpJj0MFnDIoaOtpxqAdHPjUM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jFCIyTPAms53aDsa8HomBIRjQw5TEKv9qZNMPTi8gIfBi5Nds7sX+t12D1StPzjNbzTBpFB4JbTgW7nAg263B3lUahoKYiX4UbNqyPkKuZnjyrcpYauDV4qZJt0dXx3vBN/brO085VZTtLmhvHmFkPxBWclvgs/d7QVRlwDwL5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YMqPbsMP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMqPbsMP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 594F51F00A3A;
	Tue, 14 Jul 2026 06:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784009235;
	bh=VOnevRL2fUwJn3hTVi1t/RaCUkd0JBF3tRvHqDHD9hY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YMqPbsMPldI+eCjIvRBaMxiKuQMGYGIqnPAbUL5q2ieW7PartREfOiGQGATj0ssAv
	 1U9dl0jJRiujfUljbT4eDxrjQM7gxWecWrnqyr2ZTgvSP0JofOlLPTdkCeZpD79Zoa
	 iRFunq7PFiA1hMhQ5QnI3rAqXK03HNQEg4UY8UBAM4ZR7xkaG4IwDRPRwm7dGreW/Y
	 CpFOrDDdVXSe/Db4sBS/3E7+XPfndAKMMLM2RPtd0nCBapOKVqzSqEPCE61L0CiL66
	 4KVRN2oxUnY3/p3e+ERcF+BbKTHAhGdwTZUEiXSF0bdsdQ/PFFKmjCrxAt2BtVlqH+
	 UF+YINhRt5vnA==
Date: Mon, 13 Jul 2026 23:07:15 -0700
Subject: [PATCH 5/6] xfs: clamp timestamp nanoseconds correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178400716925.268162.444784889317482361.stgit@frogsfrogsfrogs>
In-Reply-To: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed an off-by-one error in the nsec clamping; fix that so that
we never have tv_nsec == 1e9.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/inode_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 493dcf5cc6c159..5565e80691a69e 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1757,7 +1757,7 @@ xrep_clamp_timestamp(
 	struct xfs_inode	*ip,
 	struct timespec64	*ts)
 {
-	ts->tv_nsec = clamp_t(long, ts->tv_nsec, 0, NSEC_PER_SEC);
+	ts->tv_nsec = clamp_t(long, ts->tv_nsec, 0, NSEC_PER_SEC - 1);
 	*ts = timestamp_truncate(*ts, VFS_I(ip));
 }
 

