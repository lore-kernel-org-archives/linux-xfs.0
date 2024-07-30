Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A95FD528
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301799; cv=none; b=BfzkSZGfYHm4NDrbIsDhmZ5TTxS/8vtVoSJftoZoZbQToMaeIWcCMmwIxwM12Y8l1C0GOn1buBw9GmYGPtrNfdzQnhpA7Iz8HUwMndhmlk0Xmkid/sU1rWXwV4kTJzsz6q6G1xSRXZCnP9zfaEfbxb+iHh7oIhtFq02hPPBvmhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301799; c=relaxed/simple;
	bh=RLr8v64eJCBKjvQ0cZ/KwSE/5/mcsOPxY5+dQj9wUJM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=olzYS4YCdrJiw1/bvfknMaX3zGQpKclLTYGpiJ1AmeF9YNbfHbsoEmeWdy+evXbk6hZmYkxFVAnQ6zhYXG6Prob2Wf/hRiBBjxNbRe11TTns+B4CQVgW1sd0nilE3y1ELeNF4tshug55zKfcRsw97XKX3dhN48WetYtQKGr3gFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBZ7VORr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBZ7VORr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8ACC32786;
	Tue, 30 Jul 2024 01:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301798;
	bh=RLr8v64eJCBKjvQ0cZ/KwSE/5/mcsOPxY5+dQj9wUJM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CBZ7VORrBuK0KDDz8nXDCIIjxChpbCWkzd8GaSPE8fjffvCbRrTjSK+axpGSHNLdf
	 Xs8nckzYg3U5RAOia9EZ6kVmMsH7rEUgQTT2Ymd913upuPqR/fB1sSjuCsY6gTLgMg
	 QdrDvDkF5YwsRmx4B192qu7UI3knwejOZ0hR18bc/f5Qni5p+COOceS4TC9+arJxDM
	 UoIPYOOC1+ugnI5SGk+mJbqBvKyqiGkv+k3J7ag2ccgzDtH6st+nzEWoTsK9JuU6KB
	 d/+YikStXpRMRo265uropY5HI+PPVkkirRc54AVAuvHzjmGav0VVJxJrwfeNQIXlKv
	 keHThxs3m/p0Q==
Date: Mon, 29 Jul 2024 18:09:58 -0700
Subject: [PATCH 3/7] xfs_scrub: collapse trim_filesystem
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848078.1349330.4131439093892039359.stgit@frogsfrogsfrogs>
In-Reply-To: <172229848026.1349330.12889405227098722037.stgit@frogsfrogsfrogs>
References: <172229848026.1349330.12889405227098722037.stgit@frogsfrogsfrogs>
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

Collapse this two-line helper into the main function since it's trivial.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase8.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 07726b5b8..e577260a9 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -21,15 +21,6 @@
 
 /* Phase 8: Trim filesystem. */
 
-/* Trim the unused areas of the filesystem if the caller asked us to. */
-static void
-trim_filesystem(
-	struct scrub_ctx	*ctx)
-{
-	fstrim(ctx);
-	progress_add(1);
-}
-
 /* Trim the filesystem, if desired. */
 int
 phase8_func(
@@ -47,7 +38,8 @@ phase8_func(
 		return 0;
 
 maybe_trim:
-	trim_filesystem(ctx);
+	fstrim(ctx);
+	progress_add(1);
 	return 0;
 }
 

