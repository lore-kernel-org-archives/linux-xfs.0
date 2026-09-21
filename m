Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC1433D4E4
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 06:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971520; cv=none; b=UF/XAXr5WmkbeeHucEcNxQVoxIoUrBrW2mFMVhiyoa+zg5cQ3cK6EXjNW9O4EZK8yWR+QuJoPGHRo8KlO02Ju5ExVOCN/fh9PplrWZDFDnUDxvhSIUJvqBmnCXJousgyVwMqpROO2D3fwQMBJztODIpLsYs4AyjEfKc7vC3pOzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971520; c=relaxed/simple;
	bh=+3rB0IT7YPg4UTs97ejQoqYCr53ZMEyRspt00HtoGsc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SmC42zQiNapIRjFt8WYpyMnoFtgFIGJw58GMPhMypqEqQCU7iYI8X1sHNcfex7LOupyZIZx9pOQL7gognaqeTdyxsratwyxDXydgZQyY/FU/FOCsSoM/HOYP07nX0tNORPDAymptMrc/qEAOE2e4IOzAUDjHPY5MEjs1HoUp1Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KyVoKOm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KyVoKOm3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C5EA51F000FF;
	Mon, 21 Sep 2026 06:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971518;
	bh=RJMp0TSQFFhp/EB1K+ddVwZae3iFq2crB2slsjI+hN0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=KyVoKOm3Q2iHDa9Jik7ghqlzw8Z33PQqtCiruHMTyUdAYrpMzYQVJO3++WTdYITeN
	 uxUnviu9ycw8ZPGSeeFZ8V5v3lzGk/M69QaTxQsisctUy/JolU/MVV+X6NmcZy4+2s
	 JNRh9qFzK0sUVQAWMhi8RUvs/MkpZhBWWoLYN0eMcs9Hk3BGdicwO1Q7G/F6PAusZ7
	 Vd1wSQqGCTUhlLRDeZTzEF0c45xv1jr9TveoVi01DjADsvfsOWnIsPCSpZp6+reHHI
	 nHMu5l9y9371eoBv4IDWZxIsBJCdldDgiLBPBdtoOBQGchixRbA7cyrN0TMwLJ1AFS
	 97MMA2VsuKhYA==
Date: Sun, 20 Sep 2026 23:18:38 -0700
Subject: [PATCH 14/14] xfarray: warn against sorting arrays with identical
 elements
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178996120850.181988.12177498355342705156.stgit@frogsfrogsfrogs>
In-Reply-To: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains about a potential underflow here if xfarray_qsort_push
is called with lo==0.  However, this isn't possible in most cases
because filesystem metadata records cannot be identical.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/xfarray.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 78274ad53097e1..ab15a73b7d3b10 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -693,6 +693,18 @@ xfarray_qsort_push(
 		return -EFSCORRUPTED;
 	}
 
+	/*
+	 * Avoid the integer underflow below in (lo - 1).  This shouldn't
+	 * be possible because the pivot is the median of nine distinct
+	 * filesystem metadata records, so at least four records will be less
+	 * than the pivot, which means the pivot will not be in the low end of
+	 * the range by the time we get here.
+	 */
+	if (lo == 0) {
+		ASSERT(lo != 0);
+		return -EFSCORRUPTED;
+	}
+
 	si->max_stack_used = max_t(uint8_t, si->max_stack_used,
 					    si->stack_depth + 2);
 

