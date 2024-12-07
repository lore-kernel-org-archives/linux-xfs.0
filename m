Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB28322B
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530633; cv=none; b=e5whbNRJMKGJlzykZ/GBMkqGx76XIPSq4Pg2Z+8L2Q4KWYaev6KKn6A0NZ9+bvH+XM3NqHVs/lb+WNrz9uZ8r25qtCksUtm/K/eIfL3ES8XaqhYpBNOWZXQ6Da3zVBLv+ea0rTjwCoaEKMGMONZ+el/wDkN0CYObnesyHgiHwIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530633; c=relaxed/simple;
	bh=xnBhOAryebC+Vwdwnr/jisnEmdHDTN7am1RQt/mtWIU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bpbPMp7RyGzU6jM7pbPfAbC7WydTXlVPIu7AJLo7rzToRzwEX3XOhV5F/3nCAtVouuVqPFr4rc9LhpVJPT2m5FzebAY3oP1yMuRtPTfdQKex3oJfbrX0gb5zkiJXn1SjdB626tD+AVKtLZEh8EH6n63sLJHFJq70UkEzzWr7uS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ORjVeWrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ORjVeWrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469EEC4CED1;
	Sat,  7 Dec 2024 00:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530633;
	bh=xnBhOAryebC+Vwdwnr/jisnEmdHDTN7am1RQt/mtWIU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ORjVeWrG+rhzTLIyo1N/WwOj2/M2ZQ0vqDa0bz3uwF1WvRv+tnIs79cnRWVNHp4od
	 WKDqXqx3yMSlrVYtzFTCyOedcu42T3M1XzCaSmFa56PQubzMyuWFqMGsn2RDh+iq4l
	 jjPx47tpru/qV9hWQC5Khs1tNPVdRKrH1CM1rvoaDMikmpE1qOz+7nyMoYlshJQ77R
	 15QikJLWigVbLHTQFJKqj1HzrEL2Q3I/nGtReeMSzEN15bqyl/YlXTWMMuHrTJkeq1
	 SYy0PD95SXowJnl6VGJ5+nvR+baR5fQc4TfdaYdwGp3avkKvbc7AUskp8SwrE1IxIZ
	 TAxBZQLmtr+ew==
Date: Fri, 06 Dec 2024 16:17:12 -0800
Subject: [PATCH 47/50] xfs_scrub: trim realtime volumes too
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752664.126362.6074533714975702330.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On the kernel side, the XFS realtime groups patchset added support for
FITRIM of the realtime volume.  This support doesn't actually require
there to be any realtime groups, so teach scrub to run through the whole
region.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase8.c |   32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 1c88460c33962b..adb177ecdafbeb 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -59,7 +59,8 @@ fstrim_fsblocks(
 	struct scrub_ctx	*ctx,
 	uint64_t		start_fsb,
 	uint64_t		fsbcount,
-	uint64_t		minlen_fsb)
+	uint64_t		minlen_fsb,
+	bool			ignore_einval)
 {
 	uint64_t		start = cvt_off_fsb_to_b(&ctx->mnt, start_fsb);
 	uint64_t		len = cvt_off_fsb_to_b(&ctx->mnt, fsbcount);
@@ -72,6 +73,8 @@ fstrim_fsblocks(
 		run = min(len, FSTRIM_MAX_BYTES);
 
 		error = fstrim(ctx, start, run, minlen);
+		if (error == EINVAL && ignore_einval)
+			error = EOPNOTSUPP;
 		if (error == EOPNOTSUPP) {
 			/* Pretend we finished all the work. */
 			progress_add(len);
@@ -193,7 +196,8 @@ fstrim_datadev(
 		 */
 		progress_add(geo->blocksize);
 		fsbcount = min(geo->datablocks - fsbno, geo->agblocks);
-		error = fstrim_fsblocks(ctx, fsbno, fsbcount, minlen_fsb);
+		error = fstrim_fsblocks(ctx, fsbno, fsbcount, minlen_fsb,
+				false);
 		if (error)
 			return error;
 	}
@@ -201,15 +205,35 @@ fstrim_datadev(
 	return 0;
 }
 
+/* Trim the realtime device. */
+static int
+fstrim_rtdev(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_fsop_geom	*geo = &ctx->mnt.fsgeom;
+
+	/*
+	 * The fstrim ioctl pretends that the realtime volume is in the address
+	 * space immediately after the data volume.  Ignore EINVAL if someone
+	 * tries to run us on an older kernel.
+	 */
+	return fstrim_fsblocks(ctx, geo->datablocks, geo->rtblocks, 0, true);
+}
+
 /* Trim the filesystem, if desired. */
 int
 phase8_func(
 	struct scrub_ctx	*ctx)
 {
+	int			error;
+
 	if (!fstrim_ok(ctx))
 		return 0;
 
-	return fstrim_datadev(ctx);
+	error = fstrim_datadev(ctx);
+	if (error)
+		return error;
+	return fstrim_rtdev(ctx);
 }
 
 /* Estimate how much work we're going to do. */
@@ -223,6 +247,8 @@ phase8_estimate(
 	if (fstrim_ok(ctx)) {
 		*items = cvt_off_fsb_to_b(&ctx->mnt,
 				ctx->mnt.fsgeom.datablocks);
+		*items += cvt_off_fsb_to_b(&ctx->mnt,
+				ctx->mnt.fsgeom.rtblocks);
 	} else {
 		*items = 0;
 	}

