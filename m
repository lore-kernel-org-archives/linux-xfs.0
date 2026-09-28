Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5823A43F8AE;
	Mon, 28 Sep 2026 06:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576198; cv=none; b=O+5ca0q9CQRkwn6YirMw5XGpGZnI9pFop/Og1Zbx3UV8ETM1OgvY3rgoOXDUsIueAOmidmhUHtolFq6CmHqG8RxcL0C3Ws+Bfug1PAIP/MTinG+SjXw2CHFJPcRo13AHtHr9g87UmdWPQuplg8/NbfrJfH7AXTbGtCvP5ZsKKkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576198; c=relaxed/simple;
	bh=WgDgaE7U8IIl/Zi2YysUUCiGYGz6k3g+UQExPlhTxo4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a4BV/XP3h1W6CgmfabPUrXeCoGYgNNPQoro0bo/fdIFTOFa4eCzjHkW92QNPKEceFBc8IWQwL95Ci2FbS/HFTwxf3pZVJd/uneNXrlKUVBWDhk84L8dMhQaZ6EY6m+an+ECu6uNEsuQGFVAwG4wWH8COVoQkeoOSdr32UJ9bnFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YO5+gatv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YO5+gatv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9A7E71F000FF;
	Mon, 28 Sep 2026 06:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576196;
	bh=2Q+RNCq5Z0eQfiLO/EYVAf8hbkEidTe4j27P649mQUY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YO5+gatvkNs6Za36X8oBcuwkz0Shu7OZFBenh8XDcvV8gTFHvAGYPg/jKqUdPrDBC
	 CD9Udgv6r9/6aQCHVwC6zhJOMjQuw07EZ2nZ9MJm66h0FjKiGCtee68526FcWYMxJx
	 30TLEHNtfv3HOeC7BTmUjmJVeyIrIUnUlSCEgU9A0uq7ht5E8YDgqXLWetrq8+d2KW
	 o6skRxWq5+QK3AE1UtEnC8gLrtgBulM+u+CMusR2olBrdL9h3fWR/JX1BA/X94CroA
	 hgPfnm5xSvmiefIGAcnfyoYgyYPOMrUT5QrnW9rA+MKZFiuHRIvqcBbeAUYcP2fM2U
	 v/FAXwU9nO5Pw==
Date: Sun, 27 Sep 2026 23:16:36 -0700
Subject: [PATCH 03/12] xfs: abort dirtree repair if the live update hook dies
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179057612661.479634.452473932902566402.stgit@frogsfrogsfrogs>
In-Reply-To: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that if the live update hook for the directory tree repair
code hits an error, it will set dl->aborted and stops working.  If the
repair code ever sees that condition, it ought to bail out immediately
instead of continuing with obsolete data.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dirtree_repair.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index 1d1eafcf6eb598..5a5857ee71d82d 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -813,6 +813,11 @@ xrep_dirtree(
 	 */
 	mutex_lock(&dl->lock);
 	do {
+		if (dl->aborted) {
+			error = -EIO;
+			break;
+		}
+
 		/*
 		 * Decide what we're going to do, then do it.  An -ESTALE
 		 * return here means the scan results are invalid and we have

