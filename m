Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D23F1879
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713229349; cv=none; b=bAvwEdEX0kAvvtY9oanQaFE+4xkC5iLb1arSxoWyj2mH4Cl7xnKaUTj9QuDoIA4HaiEYxGISl/+CGNiWSeHMgJrdpduYAGwIcGx1ve1MSs2KjaLewvkjp/GXlHSuqnJwM1PYmBvLKIElNzWf7bWh0BtVcIhFqCiusW2NO0ENv30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713229349; c=relaxed/simple;
	bh=rV4RXkfzLSJweExMMu1ULfoeb1XIwS0cvyUy9ru3GoQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H4dsaUj3bF7OhoVHJ1rECgrT3kWjpDZLMR8HeVrWymAcMPR8q5of3LRScALPqxMcUkU//1hUG9eKq/oek2JJXuwvk/jaIXP63KDPOT4D6yh+LKYkFyhftAHKu63JoVOoYMRdK3Sr3tdzAQIDEBgNNPaaSWqPoRJ9xv3n88SSsFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ow0hN0Oe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ow0hN0Oe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19200C113CC;
	Tue, 16 Apr 2024 01:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713229349;
	bh=rV4RXkfzLSJweExMMu1ULfoeb1XIwS0cvyUy9ru3GoQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ow0hN0OeKXeBJ0LH9DVO6JXK+hpR9SZxrPrThkmOcXA7lwR6rXPS1wnK4wu+Xjd+D
	 kx2bdVOqBzKkbz8fWfpYrawFwQkWUjzEq5EReWKCobySMc3XxneRgwJ8Yd/3MLDuGK
	 +tSNE8PMAwmYiQcgQ3vmDHZmA8W29JCS2i0OwQVmbIkNPR0M8YDnPXI0BGe5lfHPPl
	 bmpNhJXjQHSx/m1iuX0h0prA0GqQmxJZRJboCZApRikCgSU+T2+tAtzhEemusqVLWJ
	 FVomq7FNqaY7BA4wtWZAybDXNi6f6biiLi6qrSXV8kTB7dsuIlpLgDpVTgHXJegyqO
	 Jwmm77PYGAebg==
Date: Mon, 15 Apr 2024 18:02:28 -0700
Subject: [PATCH 1/1] xfs_repair: check num before bplist[num]
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org
Message-ID: <171322884453.214909.10319162748738486901.stgit@frogsfrogsfrogs>
In-Reply-To: <171322884439.214909.5121967705551682559.stgit@frogsfrogsfrogs>
References: <171322884439.214909.5121967705551682559.stgit@frogsfrogsfrogs>
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

smatch complained about checking an array index before indexing the
array, so fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/prefetch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/prefetch.c b/repair/prefetch.c
index de36c5fe2cc9..22efd54bf9eb 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -494,7 +494,7 @@ pf_batch_read(
 						args->last_bno_read, &fsbno);
 			max_fsbno = fsbno + pf_max_fsbs;
 		}
-		while (bplist[num] && num < MAX_BUFS && fsbno < max_fsbno) {
+		while (num < MAX_BUFS && bplist[num] && fsbno < max_fsbno) {
 			/*
 			 * Discontiguous buffers need special handling, so stop
 			 * gathering new buffers and process the list and this

