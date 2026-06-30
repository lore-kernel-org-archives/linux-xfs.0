Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3947386334
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781439; cv=none; b=MG0dxjg+tXQrU/gXk1gI1lKGDYwG0oXhQjBMfFNk98q1lNH5Yb6V3C5Ix81U+Nn+fFaZKAxsJa0/Tx5CTAEpWIBjbHbmGW2KRnmln5YKWpn5NRlTw+vXWN94gWL5m5EtHz4hhA4TxH6m/vGvH9R8CoDzss5L1OMpior2+O3fO4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781439; c=relaxed/simple;
	bh=jx0Y0+QpgENvUskiGuBUMZU3MWFDQCI5nArVUiPjBRs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hZkwOA6yhvJmuL5Tryp/PATo9V61uwZOgXC4uRdtcXHk+5n36VlpxcxIiQM8+I8jKmnXYGPv5lYXy6kKg+43aVYx7mJXfmo8RYi6vLJg3qKLyTuG7+3BiQJBvv4NcpkOmaVN156+UAeUbZNAofgkSRK8B+jBjGO4O2BELEoZicQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtvK85v1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtvK85v1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CFFCC1F000E9;
	Tue, 30 Jun 2026 01:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781437;
	bh=iOR7xN4oTtVriVdW9auvhewmd7ZND8RK8Nbawihzh08=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=jtvK85v1MDrS0V857nq711h7yQcyzzphdh74FmlAXVs4GZdTjgHv3VDLZnLY+Q/dv
	 QqInyMoW9+R2bA0FrY1qhzOHgYKDXK9DApJxDL6R88+j9LT5UxhIGewkVgTi6BxMg8
	 HnlIHMBVkgLsygKdsV/z9OPH8pqQjf/6xCt1LzG0fO8oTRnFBkziDT72TeH57ToYq8
	 pxPxwIya5nHE5wYKGHnLw+AR2YEsHPmRTnuMiBpuPIwhrFYwzeZ65S1UuD8P65xPY0
	 LpPCkWrckxV+Ad6/5G4587sOrh2XTj0IONfAe61W/yx9mU0MC7oen2sfIaXQAKWnUU
	 1Wg/AzhTSdggA==
Date: Mon, 29 Jun 2026 18:03:57 -0700
Subject: [PATCH 5/6] mkfs: PQUOTA shouldn't conflict with GQNOENFORCE
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278129898.858323.347624126934023375.stgit@frogsfrogsfrogs>
In-Reply-To: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex points out that project quota isn't incompatible with
non-enforcing group quota in the kernel, so those shouldn't be
incompatible in mkfs either.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 525f826429a868 ("mkfs: add quota flags when setting up filesystem")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3da11c664255b1..a4864c37a8821b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -976,7 +976,7 @@ static struct opt_params mopts = {
 		  .defaultval = 1,
 		},
 		{ .index = M_PQUOTA,
-		  .conflicts = { { &mopts, M_GQNOENFORCE },
+		  .conflicts = { { &mopts, M_PQNOENFORCE },
 				 { NULL, LAST_CONFLICT } },
 		  .minval = 0,
 		  .maxval = 1,

