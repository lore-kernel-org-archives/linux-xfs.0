Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F2410E3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895783; cv=none; b=O/vp5L+Ujl8FTPR5nD3/VdZd6e25KRZkkXyWCWGUw/nEBaHRVFz3txMqf56nlYFvLeYukU5ctF1c/+MfQElCMvPtTIv0v6cGtzqhPdFUnkHbcgeqa0y/UH4RqZcz5CKP7t0woZGYNOQaR7EeD8QHbiq61SIJfczmlsLzjnzOCzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895783; c=relaxed/simple;
	bh=meuZMzM7FeHyNhq/n2tMJ4jAFAgLCVEuMU1dc5wJ0t8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pg+D6YyI/ek0J625ll2xPkhBEjCFXnGv1pdqnWJq9dO/kCLK1nS03uq3u3iBSYYXc2z1YaYg87gitXsilxfpqWHpR27+zej4o88Kairs5IHvEeQww1GrdlEgwrwdqHU59j12lgKKWZ+p2cG3GpwAHigXqZGxg3zrFKfK/+DK22k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPvuNa2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPvuNa2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C67C19425;
	Thu, 19 Mar 2026 04:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895782;
	bh=meuZMzM7FeHyNhq/n2tMJ4jAFAgLCVEuMU1dc5wJ0t8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dPvuNa2pnq6sShcHnChiMvhShpCooue+LICiLQfVbwFm3OWdrGNwwg8+iyfC+nVHG
	 fo9+t6BobDmKcjpd5Uo4C9SUAOm+4eV0vUcHaatYOjwogZ8uXBrEmYV54sPenQJ3/o
	 DwtqMqGzjYaWPuparaN5KwBawpwT2KuVS4olWfuDMoL7ys+twloQ3QUawXltu7AWMZ
	 GRCQ0R0Wvt+Fqy8KQCzyfHjooA9CYnROW7sn/1rBBlm/jCQ2YzpM3bKGSAwGvYFNVz
	 +JJ42XnhBSG80psJ86M9MsdYD2+kXUKH2SL01kqaqeVKLBxMknWe9Jns7vMKd5S3QE
	 rOszpZBOFmArg==
Date: Wed, 18 Mar 2026 21:49:42 -0700
Subject: [PATCH 16/22] xfs_scrub: perform media scanning of the log region
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177389507234.3681140.9786567058827431897.stgit@frogsfrogsfrogs>
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

Scan the log area for media errors because a defect in a region could
prevent the user from being able to perform log recovery.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase6.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index bae4d7c5d92ce0..c1ce222d4ce99f 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -47,6 +47,7 @@ struct media_verify_state {
 	struct read_verify_pool	*rvp_realtime;
 	struct bitmap		*d_bad;		/* bytes */
 	struct bitmap		*r_bad;		/* bytes */
+	struct bitmap		*l_bad;		/* bytes */
 	bool			d_trunc:1;
 	bool			r_trunc:1;
 	bool			l_trunc:1;
@@ -109,6 +110,8 @@ bitmap_for_disk(
 		return vs->d_bad;
 	case XFS_DEV_RT:
 		return vs->r_bad;
+	case XFS_DEV_LOG:
+		return vs->l_bad;
 	default:
 		return NULL;
 	}
@@ -571,6 +574,12 @@ report_all_media_errors(
 		return ret;
 	}
 
+	ret = report_disk_ioerrs(ctx, vs, XFS_DEV_LOG);
+	if (ret) {
+		str_liberror(ctx, ret, _("walking log device io errors"));
+		return ret;
+	}
+
 	ret = report_disk_ioerrs(ctx, vs, XFS_DEV_RT);
 	if (ret) {
 		str_liberror(ctx, ret, _("walking rtdev io errors"));
@@ -617,9 +626,14 @@ check_rmap(
 			map->fmr_flags);
 
 	/* "Unknown" extents should be verified; they could be data. */
-	if ((map->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
-			map->fmr_owner == XFS_FMR_OWN_UNKNOWN)
-		map->fmr_flags &= ~FMR_OF_SPECIAL_OWNER;
+	if ((map->fmr_flags & FMR_OF_SPECIAL_OWNER)) {
+		switch (map->fmr_owner) {
+		case XFS_FMR_OWN_UNKNOWN:
+		case XFS_FMR_OWN_LOG:
+			map->fmr_flags &= ~FMR_OF_SPECIAL_OWNER;
+			break;
+		}
+	}
 
 	/*
 	 * We only care about read-verifying data extents that have been
@@ -762,11 +776,17 @@ phase6_func(
 		goto out_dbad;
 	}
 
+	ret = -bitmap_alloc(&vs.l_bad);
+	if (ret) {
+		str_liberror(ctx, ret, _("creating log badblock bitmap"));
+		goto out_rbad;
+	}
+
 	ret = read_verify_pool_alloc(ctx, XFS_DEV_DATA, remember_ioerr, &vs,
 			&vs.rvp_data);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating datadev media verifier"));
-		goto out_rbad;
+		goto out_lbad;
 	}
 	if (ctx->fsinfo.fs_log) {
 		ret = read_verify_pool_alloc(ctx, XFS_DEV_LOG, remember_ioerr,
@@ -823,16 +843,17 @@ phase6_func(
 	 */
 	if (ret || ret2 || ret3) {
 		ret |= ret2 | ret3; /* caller only cares about non-zero/zero */
-		goto out_rbad;
+		goto out_lbad;
 	}
 	if (bitmap_empty(vs.d_bad) && !vs.d_trunc &&
 	    bitmap_empty(vs.r_bad) && !vs.r_trunc &&
-	    !vs.l_trunc)
-		goto out_rbad;
+	    bitmap_empty(vs.l_bad) && !vs.l_trunc)
+		goto out_lbad;
 
 	/* Scan the whole dir tree to see what matches the bad extents. */
 	ret = report_all_media_errors(ctx, &vs);
 
+	bitmap_free(&vs.l_bad);
 	bitmap_free(&vs.r_bad);
 	bitmap_free(&vs.d_bad);
 	return ret;
@@ -852,6 +873,8 @@ phase6_func(
 out_datapool:
 	read_verify_pool_abort(vs.rvp_data);
 	read_verify_pool_destroy(vs.rvp_data);
+out_lbad:
+	bitmap_free(&vs.l_bad);
 out_rbad:
 	bitmap_free(&vs.r_bad);
 out_dbad:

