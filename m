Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC3A23C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881166; cv=none; b=qwZOeDXjk/JVDgImfx0HUWaopPgW7iQbGedG5e983UNcPHIffmqZbzMWw6hG/GIlsS9Xv0gbM+MbnwUsQwqQm6Hwi52kkyTsN+mR8c1CtBBBeZFutqMt3E/bYg97kqgnS4WoTg8QnBY7G381CE/N1XCoHyrVUmU9BAuxsa9MMng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881166; c=relaxed/simple;
	bh=BjdxM0GDvnEPNbKX3BpZOGpoTFfLke3heb61iO6gWeg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ukmXRYWtJN+6aJtJXZaRe4YuzWMtxC5QHFN7gfeO1dG/CRoUEZI7TRpr1XMgbT+O/1ptNXRaDDcjGT3CpNhOdQ8tHjiKx8FH9f5ixx3JFKRFqPECVgTc52vCb5CEtgnhAxhBjkKRObXfi+dU4eUVX91qMoe8Em8y4lumH92AeGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cRj1wdd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cRj1wdd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943E0C4CEDD;
	Thu,  6 Feb 2025 22:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881166;
	bh=BjdxM0GDvnEPNbKX3BpZOGpoTFfLke3heb61iO6gWeg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cRj1wdd3VsGVpWHQ8G+PtlTzZq2hzJh7wkDEujCbcU93ljhxjufNYMrzo5UF/gGJl
	 Tqc1n11DaXuJGRMf6nXFJHpSnTHwnVs2DYM54GrR7b7rhvwKPiOJ83cf4EaYli5agv
	 N/PP1q3K89AtJqQEqN/h04dCWhBcb9uA9wGmKelWhZJtEJvbVlI7cOxio6FWkY1NrU
	 vOejRgnZeuhEUvoehEuJiXGvm3ip9mVsAft/g45p5hktq/ILSom+ooLkJSuLMF/Uaz
	 HjXFkv9yiLn+CA/YbYQnUrBuigbDhwMxyIDQPl23SVj2qplWApon5uKAMK5m5Icx6O
	 sKSqB1N+3jwow==
Date: Thu, 06 Feb 2025 14:32:46 -0800
Subject: [PATCH 08/17] xfs_scrub: selectively re-run bulkstat after re-running
 inumbers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086183.2738568.5501883032377295543.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In the phase 3 inode scan, don't bother retrying the inumbers ->
bulkstat conversion unless inumbers returns the same startino and there
are allocated inodes.  If inumbers returns data for a totally different
inobt record, that means the whole inode chunk was freed.

Cc: <linux-xfs@vger.kernel.org> # v5.18.0
Fixes: 245c72a6eeb720 ("xfs_scrub: balance inode chunk scan across CPUs")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index c32dfb624e3e95..8bdfa0b35d6172 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -60,6 +60,8 @@ bulkstat_for_inumbers(
 	int			i;
 	int			error;
 
+	assert(inumbers->xi_allocmask != 0);
+
 	/* First we try regular bulkstat, for speed. */
 	breq->hdr.ino = inumbers->xi_startino;
 	breq->hdr.icount = inumbers->xi_alloccount;
@@ -246,11 +248,24 @@ scan_ag_bulkstat(
 		case ESTALE: {
 			stale_count++;
 			if (stale_count < 30) {
-				ireq->hdr.ino = inumbers->xi_startino;
+				uint64_t	old_startino;
+
+				ireq->hdr.ino = old_startino =
+					inumbers->xi_startino;
 				error = -xfrog_inumbers(&ctx->mnt, ireq);
 				if (error)
 					goto err;
-				goto retry;
+				/*
+				 * Retry only if inumbers returns the same
+				 * inobt record as the previous record and
+				 * there are allocated inodes in it.
+				 */
+				if (!si->aborted &&
+				    ireq->hdr.ocount > 0 &&
+				    inumbers->xi_alloccount > 0 &&
+				    inumbers->xi_startino == old_startino)
+					goto retry;
+				goto out;
 			}
 			str_info(ctx, descr_render(&dsc_bulkstat),
 _("Changed too many times during scan; giving up."));

