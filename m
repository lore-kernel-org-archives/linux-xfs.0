Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB591A9B3F
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881229; cv=none; b=FWJdf7LvY60mz4ZIZNrERuGHFlAh1Ndpg9S48O7U8KLhcKdBmhz7yaVWkQ6xJ3cAgyBBYuceiUcFM+c1BbQZoMV5Nf4H0idPo9L8RgtFf/4RPOS+qNY87XosRxCsCZecQNYEeYDcYs7sOJ9uMEL29RgFyKQ3zkTfYLgkYRMDqwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881229; c=relaxed/simple;
	bh=usi1lkw+EEgJnxDq/uYMS83/hq4V9riqP0zRXIlkt1E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sYMljl8iDwp4l34IKTkICs9n5mN5O/ooQFc3viJG+KHzg6pwj65uMQsHPbELPw0G7GOF23o2HIqWPiKDt33eywdXk7mhHxafHvOgD2yHDuWL8z95/9SquOoEeWbQXM1loNwaF96GAC/WB2h5ULtlqcPOjQqkbTkZQQRLmUPsavY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dII+C/lY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dII+C/lY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179B9C4CEDD;
	Thu,  6 Feb 2025 22:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881229;
	bh=usi1lkw+EEgJnxDq/uYMS83/hq4V9riqP0zRXIlkt1E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dII+C/lYGvQ7yl+zbY5xH1pa5fNLiwaCpYzpZCSduZXsFFfS4MOwxKS+V+PTXvVB8
	 kAGHPqa58jWmvfBsFCWPNmfLlMshiKixnNH42Jabkq6nanDe17QOfPetImWNTeFBUZ
	 TSgYXatzkXA20wyK0llE3dOkXx/p1MG9FBD9zRj2Exboba3oJ5PDk5KUK8MVaye0eE
	 iytRDiPIxNMtnvBa2AwcIMOxMV0P5b3CbjbhG7eHbF85wUsZglW1Ufn5Bq9QUB2VJb
	 tEco8pawhilDKzweXXmdK7vEIiHEnb5h06vTthz1/typAAOPRK1es/s88CXYWEjk5h
	 DFyWoZ0zkpOUA==
Date: Thu, 06 Feb 2025 14:33:48 -0800
Subject: [PATCH 12/17] xfs_scrub: don't complain if bulkstat fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086244.2738568.15432642060089262298.stgit@frogsfrogsfrogs>
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

If bulkstat fails, we fall back to loading the bulkstat array one
element at a time.  There's no reason to log errors.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 4e4408f9ff2256..4d3ec07b2d9862 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -51,7 +51,6 @@
 static void
 bulkstat_for_inumbers(
 	struct scrub_ctx		*ctx,
-	struct descr			*dsc,
 	const struct xfs_inumbers	*inumbers,
 	struct xfs_bulkstat_req		*breq)
 {
@@ -66,13 +65,7 @@ bulkstat_for_inumbers(
 
 	/* First we try regular bulkstat, for speed. */
 	breq->hdr.ino = inumbers->xi_startino;
-	error = -xfrog_bulkstat(&ctx->mnt, breq);
-	if (error) {
-		char	errbuf[DESCR_BUFSZ];
-
-		str_info(ctx, descr_render(dsc), "%s",
-			 strerror_r(error, errbuf, DESCR_BUFSZ));
-	}
+	xfrog_bulkstat(&ctx->mnt, breq);
 
 	/*
 	 * Bulkstat might return inodes beyond xi_startino + CHUNKSIZE.  Reduce
@@ -239,7 +232,7 @@ scan_ag_bulkstat(
 	descr_set(&dsc_inumbers, &agno);
 	handle_from_fshandle(&handle, ctx->fshandle, ctx->fshandle_len);
 retry:
-	bulkstat_for_inumbers(ctx, &dsc_inumbers, inumbers, breq);
+	bulkstat_for_inumbers(ctx, inumbers, breq);
 
 	/* Iterate all the inodes. */
 	for (i = 0; !si->aborted && i < breq->hdr.ocount; i++, bs++) {

