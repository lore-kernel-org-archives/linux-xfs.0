Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7A823FC41;
	Fri, 25 Sep 2026 04:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309479; cv=none; b=sgTHTTlGAXT9i+tEysvrQFZtHP2BFV9ddw61ZzlbgYF2SH/YdR/RBG7in1buVkzB0ezgdTNSuv5pbQH7K1y1ETiIBwK2YsdkfTHeKFeH4qPtWrRIjUd2M6jBw/z65cM54pTNb9Psk55wSUdU0tkUAX2kzo/p9+AJZFI0Akc+9yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309479; c=relaxed/simple;
	bh=/2OZr7OfjkiaHWljAlNig4VYVgJ7AU0UOMyVb9CcXZw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gVtchbN7ZuUEULCw+A5GDb3cnILih22l8HsrLLuoijmpeibcLSo8lcWz4M0+3zRXXQFtiCgH2I21tXsBENCMSJygI0pR2yGLe9+kusShPx7oydZqImPoaq1OYFne24EptASETlfzTUT/bYlRe9HV21Aoc2+H6CcehlXvrUamk1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rq/aFccg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rq/aFccg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B25401F000FF;
	Fri, 25 Sep 2026 04:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790309477;
	bh=FYa5l32UHCQOmxWj8gom5faO9N86Y9A7nkqnRVuUYxA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Rq/aFccgafxsarGbaku4q3Htlzy9L2CShqmYXeJR72FqUF6QrrWMUbe8RuHX4svs8
	 +AElj9Ai8kAsm2lYWyS01S8+fQED+1T7qCsJcmmNCdl+08LF10xvU/U3vXfmiT3kD6
	 DFrOrNKLlkUQfbykQbepcHW3qo0sRZAo5xWgqGLGUP7zNRFfXcR+PbODwBrw5QLNid
	 bmdazFQzrvFw1lm7IzxBB5wUws2Fss7lVMqb/gO8F+bLAa70VZDxIdp56pF2L6z5mH
	 /5l1NDZx9zd5cXWlWd++r1MrDMHGYva8aZARSKc+M7hoOjqSAFVtgLMZ5Ir1EJ7eEr
	 H6FbyuQEZSzWA==
Date: Thu, 24 Sep 2026 21:11:17 -0700
Subject: [PATCH 03/12] xfs: fix xchk_stats_estimate_bufsize to allow for the
 trailing null
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179030932113.3344850.7345584822446434482.stgit@frogsfrogsfrogs>
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

LOLLM complains that xchk_stats_estimate_bufsize underestimates the
buffer size by 1 byte because scnprintf wants to store a null byte after
the newline in each line.  Each call to scnprintf overwrites the null
left by the previous call, but we still need the null byte for the last
line in the file.

Cc: <stable@vger.kernel.org> # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/stats.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index 3339cae4b39d14..da2a40a91156f4 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -168,7 +168,8 @@ xchk_stats_estimate_bufsize(
 		ret += field_width + 1;
 	}
 
-	return ret;
+	/* null byte for scnprintf */
+	return ret + 1;
 }
 
 /* Clear all counters. */

