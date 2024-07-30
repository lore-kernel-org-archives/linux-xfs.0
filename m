Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01963524C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301940; cv=none; b=OCcmcZPDxEoVtv8ToZBPz2l8fbsOEL0N3u8Rc2sr4tKVO/MagTTG5h4QkUZNBiti5ja4YNZ8GHpEE9skXC3rpfjqBHKNMPgb297EkMPgFX15E6ZZKOiPeqzswwNnzgRZ8mRPqe//wLVoRHsUpbJlKZCGNSfPrzmu1c0Y/PHCLQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301940; c=relaxed/simple;
	bh=AZIUSUi6x2OxzhDNhnmvctkAS18Apcdl0iSWEIOPmc8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s9zdpQpr8rZCqWFTNFaCEWJWYeOGVm3uMcXPlVTLwrz8+dpclLxALpIp69GN1OULN+OVhSZP5XfFFfe+luyO7yPXP44OERvWo1hykNxpo2ftX620apJUuFj24BbYqW3wFaui9t5u8s8suIlGzEXwlEvfOo80rxD68Q81x1Z+B5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DGb+MlYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGb+MlYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4BCC32786;
	Tue, 30 Jul 2024 01:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301939;
	bh=AZIUSUi6x2OxzhDNhnmvctkAS18Apcdl0iSWEIOPmc8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DGb+MlYsw6s79f0g3t+Poswb0gkgBE+wHXk8snyPlDJ5oLzWxQ0QS0tGCoVLE4vTl
	 k4+gNfu0+eVQoCW8aCqtX+ewDIOfMDtjpQ4KVE47PLCBRmL2cPli7/opRsOFZAhZ1p
	 QOqfXfYGzHQqIOqm8ihTUxGJ15YeCk5qMomS9i19BY/tFjvXXfEmEdoE0HxhYF4LHY
	 x7s/Hkr2iJfcONSmo/rt+T+L47S0brfP1Ci07bNLpITa/pcyZwXsipKdLinoRn5r2w
	 a04Fsgsw9Es1vhP3/+1YAACB4gRIHuhpknMvmCco2luyluNYcscUgOEwKhBuIKOhGV
	 oecSECi1UD6ng==
Date: Mon, 29 Jul 2024 18:12:19 -0700
Subject: [PATCH 5/7] xfs_scrub: remove pointless spacemap.c arguments
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848522.1349623.6680974103676606882.stgit@frogsfrogsfrogs>
In-Reply-To: <172229848439.1349623.8570132525895775451.stgit@frogsfrogsfrogs>
References: <172229848439.1349623.8570132525895775451.stgit@frogsfrogsfrogs>
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
index 9cefe074c..e35756db2 100644
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

