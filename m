Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088F87462
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882251; cv=none; b=JqlYdoNFUPwlJCHOkfJkWj+p7OK20mvDxxkA3FM/QC3mkFztpa3BNQ6VjYeSMbVB0SlnaudyKLi4mR4kSMbn7z8V2NoyWcBPV0tYuso0pKcQ+e2eoXkw5ttraw/bmmEghHLQW3FPuEqTMjtDX4pevosJPRsB2pZwmHU2xEs1AMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882251; c=relaxed/simple;
	bh=wsi9lUn02PXj7trVw16TbeljPEw1vzlqXH8L/eiIQvM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fxgt6inOlXqk5lamNRlcshadqJwEdDjFN7JNl2D701gBceEmxej0dpdDfCss3WlUiGu4i0h9HDA4ZaoVhr9+vGTFWp5Gl1QILVej3EKlHDWblL3q3PYttAa40D6RpBC3n83YldDYbLASuY5I3l+E8z1HOEisWciv9+6U8v1O0bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KpQ3wo1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KpQ3wo1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8916C116B1;
	Tue,  2 Jul 2024 01:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882250;
	bh=wsi9lUn02PXj7trVw16TbeljPEw1vzlqXH8L/eiIQvM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KpQ3wo1UCXbzE97cL3ePWQfmXIarhGJeUjOutVLQ+KUnSkTJMrPxLJCUMQVb5oOON
	 wC/qto6sR4ywjpVJXubcF0useuQ2SvEUIW2wHfyE20aYNArsAolxhDSovP7uW0Xu8j
	 6jQr3UMw8yC4sI1NWtBZwz/lX3Yic+Q+vBi45QzlXlJluFDh1cDInWXO2m0s4TGJEW
	 uQeYMnjDPH3E/eImwFaK1t+N+T+4HNaLsmZAzpLBE35/Sf0I9B7XkdBBDbIU9XmtUc
	 9LSA/Q/sCTU7oGj/TtZNTBdgl0XcS8PpKyOzCw2AK0HBdaSgWojOe79aBApfNCn5Y+
	 wWpmtptdNd8fg==
Date: Mon, 01 Jul 2024 18:04:10 -0700
Subject: [PATCH 5/7] xfs_scrub: remove pointless spacemap.c arguments
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118656.2007921.16506722349320949924.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
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

Remove unused parameters from the full-device spacemap scan functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/spacemap.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)


diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 9cefe074c6f6..e35756db2eed 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -132,7 +132,6 @@ scan_ag_rmaps(
 static void
 scan_dev_rmaps(
 	struct scrub_ctx	*ctx,
-	int			idx,
 	dev_t			dev,
 	struct scan_blocks	*sbx)
 {
@@ -170,7 +169,7 @@ scan_rt_rmaps(
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	scan_dev_rmaps(ctx, agno, ctx->fsinfo.fs_rtdev, arg);
+	scan_dev_rmaps(ctx, ctx->fsinfo.fs_rtdev, arg);
 }
 
 /* Iterate all the reverse mappings of the log device. */
@@ -182,7 +181,7 @@ scan_log_rmaps(
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	scan_dev_rmaps(ctx, agno, ctx->fsinfo.fs_logdev, arg);
+	scan_dev_rmaps(ctx, ctx->fsinfo.fs_logdev, arg);
 }
 
 /*
@@ -210,8 +209,7 @@ scrub_scan_all_spacemaps(
 		return ret;
 	}
 	if (ctx->fsinfo.fs_rt) {
-		ret = -workqueue_add(&wq, scan_rt_rmaps,
-				ctx->mnt.fsgeom.agcount + 1, &sbx);
+		ret = -workqueue_add(&wq, scan_rt_rmaps, 0, &sbx);
 		if (ret) {
 			sbx.aborted = true;
 			str_liberror(ctx, ret, _("queueing rtdev fsmap work"));
@@ -219,8 +217,7 @@ scrub_scan_all_spacemaps(
 		}
 	}
 	if (ctx->fsinfo.fs_log) {
-		ret = -workqueue_add(&wq, scan_log_rmaps,
-				ctx->mnt.fsgeom.agcount + 2, &sbx);
+		ret = -workqueue_add(&wq, scan_log_rmaps, 0, &sbx);
 		if (ret) {
 			sbx.aborted = true;
 			str_liberror(ctx, ret, _("queueing logdev fsmap work"));

