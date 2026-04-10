Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34ACB2DAFBB
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802140; cv=none; b=OabYcd+WV7mQc5hL3TY6DYRMc1mRD5eDq+UmfFYgjOkqq9e7Xd/Ste5xfCAJbwCFwxtJFzkTihdhrhWHLsos8yVDVjcHGzSjsFtLvHYyuTErcLIozEO4yYRw9+nygSL9cR+f/eD4UkFruGGH2o0+RtrwERI5sL2rrnImcQr/I/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802140; c=relaxed/simple;
	bh=ymvGLhufBaXhiNkftSeTVxe0h4XA1XxyZ8ME6YQnuzo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DwdsAqtV7BiPRBZ180qmekimwd5M4/+S+prHu21UlAava10THcaxGak1g365LUOhRZQ4SxWIMaPjF5ZquEQtzMrixHVnuCKQoIGDCQQkCLk7aphSJNPntpxtK+kiCGsbFMMsPWs0vTPCHVhIRbGoSLuJINm+b27snnYSpLsQQmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/0WPRcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/0WPRcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D737C19421;
	Fri, 10 Apr 2026 06:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775802140;
	bh=ymvGLhufBaXhiNkftSeTVxe0h4XA1XxyZ8ME6YQnuzo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a/0WPRcXROg9cbomzFLNrE3nSJjL2JqK3PVoQUvICSr1YNBd0dn/PBU9vPoJ6NuDu
	 mPW0PIpsV+Omi8qFgoSezsrmW3/j9F9FfsFReOVcfzBAU/aAJADo6oAf27J6SVmRfq
	 2aZrKRmR+V5WNKhShT1nK8yO6TOgnG1O7fGG4wZM4NXzqwHIn/DtPe7CMtnBI5g+eM
	 OMqgWYN26eb17c6nvQRC12bTofaZfe1/vYshSX4pMjsMQTEP9b3kGLxEBNQPSGXrep
	 dCNKWpBMnKQE6FuN/Ut09ORWEVbohczKJ1y1X92TndDMV+6IwSvxzl/919vq0mGCQt
	 FMkLFRqQUjwNg==
Date: Thu, 09 Apr 2026 23:22:19 -0700
Subject: [PATCH 19/21] xfs_scrub: clean up device-related error messages
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577385382.2090237.1150558611184203049.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
References: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use consistent terminology for the data/log/rt device in the error
messages.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase6.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index ae3b928df0f263..c273420d42ca14 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -551,7 +551,7 @@ report_all_media_errors(
 
 	ret = report_disk_ioerrs(ctx, vs, XFS_DEV_DATA);
 	if (ret) {
-		str_liberror(ctx, ret, _("walking datadev io errors"));
+		str_liberror(ctx, ret, _("walking data device io errors"));
 		return ret;
 	}
 
@@ -563,7 +563,7 @@ report_all_media_errors(
 
 	ret = report_disk_ioerrs(ctx, vs, XFS_DEV_RT);
 	if (ret) {
-		str_liberror(ctx, ret, _("walking rtdev io errors"));
+		str_liberror(ctx, ret, _("walking rt device io errors"));
 		return ret;
 	}
 
@@ -725,14 +725,14 @@ phase6_func(
 
 	ret = alloc_pool(ctx, &vs, XFS_DEV_DATA);
 	if (ret) {
-		str_liberror(ctx, ret, _("creating datadev media verifier"));
+		str_liberror(ctx, ret, _("creating data device media verifier"));
 		return ret;
 	}
 	if (ctx->fsinfo.fs_log) {
 		ret = alloc_pool(ctx, &vs, XFS_DEV_LOG);
 		if (ret) {
 			str_liberror(ctx, ret,
-					_("creating logdev media verifier"));
+					_("creating log device media verifier"));
 			goto out_datapool;
 		}
 	}
@@ -740,7 +740,7 @@ phase6_func(
 		ret = alloc_pool(ctx, &vs, XFS_DEV_RT);
 		if (ret) {
 			str_liberror(ctx, ret,
-					_("creating rtdev media verifier"));
+					_("creating rt device media verifier"));
 			goto out_logpool;
 		}
 	}
@@ -765,15 +765,15 @@ phase6_func(
 
 	ret = clean_pool(&vs, XFS_DEV_DATA, &ctx->bytes_checked, &ok);
 	if (ret)
-		str_liberror(ctx, ret, _("flushing datadev verify pool"));
+		str_liberror(ctx, ret, _("flushing data device verify pool"));
 
 	ret2 = clean_pool(&vs, XFS_DEV_LOG, &ctx->bytes_checked, &ok);
 	if (ret2)
-		str_liberror(ctx, ret2, _("flushing logdev verify pool"));
+		str_liberror(ctx, ret2, _("flushing log device verify pool"));
 
 	ret3 = clean_pool(&vs, XFS_DEV_RT, &ctx->bytes_checked, &ok);
 	if (ret3)
-		str_liberror(ctx, ret3, _("flushing rtdev verify pool"));
+		str_liberror(ctx, ret3, _("flushing rt device verify pool"));
 
 	/*
 	 * If the verify flush didn't work or we found no bad blocks, we're

