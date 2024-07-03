Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BEC194138
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 21:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720043294; cv=none; b=pJ4dJruDSK6o2iMEQOpfS7ZgmPULQsUJdAgNrdfKT+dV6Y9RuGD6c138SVLyDqYZkQ7zHZ78l+N79a/rYKE3ukHN31nnh7Siq1b0KZg08SrLMtBYnQKNCrY2PLYho3jB3tWPCCHxkGhdBpkAMdc2lnTnmEfFxtXtqcXngesiITU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720043294; c=relaxed/simple;
	bh=aTMDkRgYaVo9ArqPd454SvW7rAU3hz520D7Vrg4eJJM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MYS5tpDj4mAQD5F+w00ohvrz1aiJvjywXH5px+1Pb+X/D1aF4PXbwMbQZXaVzSJmIWUZBTjylCrnhpBColGDbiTi6c6eXLRXC3VI4oze9pDbRLF6Ko3do26etXJalsHwRG8+9tHBUZpf7muwmPziG99yARg6bs41n0QtoPRd8RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ChmPnHSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ChmPnHSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F59FC4AF0F;
	Wed,  3 Jul 2024 21:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720043293;
	bh=aTMDkRgYaVo9ArqPd454SvW7rAU3hz520D7Vrg4eJJM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ChmPnHSBMN0GcVISLaYirr8OI8szDcZ3u6e13SA1Fbgg4ShyH9Y0hA7L1FnCPe6mA
	 mvpdRaICnf01k+3SoQmZlKWRE9jsTJsXtTwgFhict6LtUfFy/l0GJQ3NsHMtJMAGYa
	 OhIu/FIiO1P3isCkmOjq7gpD3DDBMQOTdPzE7j7RdpS1Tx8wvNJdm1mnkMkFd2Js8K
	 2NColufPIzkSI71F07qc9tzUUQJ/MgY2XQlYP1cYHlpPI4uVL6iCe1OPM5e6Dm/idd
	 vqt9N0hbfBqsWQ24DPJvT/74037Z2PbRlG91K0TweoHSC4RCHovjXM8U9yzI24+XFW
	 aDb6HG86NjsbA==
Date: Wed, 03 Jul 2024 14:48:13 -0700
Subject: [PATCH 5/7] xfs_scrub: remove pointless spacemap.c arguments
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172004320078.3392477.5123786167352450693.stgit@frogsfrogsfrogs>
In-Reply-To: <172004320006.3392477.3715065852637381644.stgit@frogsfrogsfrogs>
References: <172004320006.3392477.3715065852637381644.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

