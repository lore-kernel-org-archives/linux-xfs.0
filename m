Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EAD1F16B
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895829; cv=none; b=APTXcvFoZBk+lGHKIP+mcvwSz2ZH+rTibMe5QTRS/yiIkE1BI0GFiDyS1mfxPpERLyJLzq5x52Ny1V059S1YXfdotzkarI79w84mDagl3+qTj7SK7WdTkbC4k944xn29xplmBVSYf7b7U1ggMPc4kgF8ITn+CokfMeYPkzn+riw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895829; c=relaxed/simple;
	bh=M0p0gZB1/f4lELMoEmxZ00ezt/85jGtdJokQPi+yO4M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mHHFGd4dPnErIZua9DuEfzEDQxNTSB7Vddr8DKVsBBrUjW0HF4HsDfTWdGorEVnYUVBmSRukSJ3VOEq47/tsTIff4QGe17wPyTJvmlqFGVgHRCZlgT2DiQ+W8WuJvfsY2Wf87y+RhXdHoRdSfA5VtxsV4bBofzZQcZhZ0goQ0ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cKzbAoHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cKzbAoHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0450C19425;
	Thu, 19 Mar 2026 04:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895829;
	bh=M0p0gZB1/f4lELMoEmxZ00ezt/85jGtdJokQPi+yO4M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cKzbAoHwt2Zc6Qenq6QNpBZL2FRHyvtKgH8nR1SWUYTPOBHueS7+3xkQYE7vYiGwF
	 MVhDLEUAYjMDzv7EWc0dqBrQkhIQ8hTke5Nvned08FdYK8f/ATNkTMV38tpjtIRkCk
	 Gh1r5Egx00NGHmDHhnAZH0VwRT4+0mOZW1biNSrLTIkl9zkf3/ORIimbGCqjx3eCOX
	 6+TZzmZLOq33VhXySTprNEU6AOWHBpoWU56gxXKFJDTPPDVvkdcxIJdlsOk33kE+Yg
	 ZPvu0JgjDAwspxn1ORnTL79NLp9R0u/PTmj6frs+RBEH6Sa207A7hMDeKUkTbNYulC
	 SaLCbZa5gMe8A==
Date: Wed, 18 Mar 2026 21:50:29 -0700
Subject: [PATCH 19/22] xfs_scrub: clean up device-related error messages
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177389507289.3681140.5395854061770102183.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
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
---
 scrub/phase6.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index bf9ef3d12690ab..14f1a26ab4ff7f 100644
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

