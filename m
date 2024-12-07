Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FDD7482
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530602; cv=none; b=RjRnd2QiFwz//+k7yC23iP59V7AKJboUUND9/hJi8Pdzno6A/yCO3TcYG+QiYVXEx+rHMY26NhdhhXQcnK43cG6CQ+Y4Vj4u/WvImDH0pQgdPaIH5IRW2HoaG2BOtTAopuCiS0qNW2f05V7R9pjRbUyv8/Px0c0lFH0cOdxCUH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530602; c=relaxed/simple;
	bh=6oaT7ZJX8Yinv1Q35SykGGJMtAXS/4/h9hTpeNjtAeQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MFkDoM03LUEQvepRGQyfbb9O/enKP6cSawKKsvm3ezcVvng0E5L+EAuccPMG5Owe2o5twJdYV9mlgl1yQIWwFji3/pjUTw1c/3acUYHaysVJJJZ+fEG0u63I89dY2WNzx1H/XYcUOxx3G+ah1Yr1k5B+lCobIforM40R0DS7jW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OfJntGty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfJntGty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BCFC4CED1;
	Sat,  7 Dec 2024 00:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530601;
	bh=6oaT7ZJX8Yinv1Q35SykGGJMtAXS/4/h9hTpeNjtAeQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OfJntGtyGpeu0GS4nHdD4AZsKpLCBpbuOGT06cEgyaVAzezSj/6o2k3PQvgDkulFX
	 adGbreuaNX+4pTdCfjsjUl2QzGExuLITkwLJgDtPDHnPReQen1iGfefYOnfL5vAzjY
	 Dn+Bh7rSjGXA9z39Mr8YNLaVMjvtFdQreqr5/KFvwgHPYPlpLAFjxBrpNER4TzNVRO
	 WQ2yEeS9i3FsP1yh2hnIAd9YyQYINgmbPAYmAv4HiaHXViZ5rMCYS24xYNRz8/w6cr
	 U+k37VFX5dmYJKRhotr/qW/NW6sxeBfxMZFvqs79TLsmuyH/x4y/LNw0h6TA5Etw4n
	 CZFM/dUQ1aeNA==
Date: Fri, 06 Dec 2024 16:16:41 -0800
Subject: [PATCH 45/50] xfs_scrub: check rtgroup metadata directory connections
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752633.126362.18289089881619449643.stgit@frogsfrogsfrogs>
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

Run the rtgroup metapath scrubber during phase 5 to ensure that any
rtgroup metadata files are still connected to the metadir tree after
we've pruned any bad links.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase5.c |   24 ++++++++++++++++++++++--
 scrub/scrub.h  |    4 +++-
 2 files changed, 25 insertions(+), 3 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 4d0a76a529b55d..22a22915dbc68d 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -750,6 +750,7 @@ static int
 queue_metapath_scan(
 	struct workqueue	*wq,
 	bool			*abortedp,
+	xfs_rgnumber_t		rgno,
 	uint64_t		type)
 {
 	struct fs_scan_item	*item;
@@ -762,7 +763,7 @@ queue_metapath_scan(
 		str_liberror(ctx, ret, _("setting up metapath scan"));
 		return ret;
 	}
-	scrub_item_init_metapath(&item->sri, type);
+	scrub_item_init_metapath(&item->sri, rgno, type);
 	scrub_item_schedule(&item->sri, XFS_SCRUB_TYPE_METAPATH);
 	item->abortedp = abortedp;
 
@@ -785,6 +786,7 @@ run_kernel_metadir_path_scrubbers(
 	const struct xfrog_scrub_descr	*sc;
 	uint64_t		type;
 	unsigned int		nr_threads = scrub_nproc_workqueue(ctx);
+	xfs_rgnumber_t		rgno;
 	bool			aborted = false;
 	int			ret, ret2;
 
@@ -804,7 +806,7 @@ run_kernel_metadir_path_scrubbers(
 		if (sc->group != XFROG_SCRUB_GROUP_FS)
 			continue;
 
-		ret = queue_metapath_scan(&wq, &aborted, type);
+		ret = queue_metapath_scan(&wq, &aborted, 0, type);
 		if (ret) {
 			str_liberror(ctx, ret,
  _("queueing metapath scrub work"));
@@ -812,6 +814,24 @@ run_kernel_metadir_path_scrubbers(
 		}
 	}
 
+	/* Scan all rtgroup metadata files */
+	for (rgno = 0;
+	     rgno < ctx->mnt.fsgeom.rgcount && !aborted;
+	     rgno++) {
+		for (type = 0; type < XFS_SCRUB_METAPATH_NR; type++) {
+			sc = &xfrog_metapaths[type];
+			if (sc->group != XFROG_SCRUB_GROUP_RTGROUP)
+				continue;
+
+			ret = queue_metapath_scan(&wq, &aborted, rgno, type);
+			if (ret) {
+				str_liberror(ctx, ret,
+  _("queueing metapath scrub work"));
+				goto wait;
+			}
+		}
+	}
+
 wait:
 	ret2 = -workqueue_terminate(&wq);
 	if (ret2) {
diff --git a/scrub/scrub.h b/scrub/scrub.h
index bb94a11dcfce71..24b5ad629c5158 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -118,9 +118,11 @@ scrub_item_init_file(struct scrub_item *sri, const struct xfs_bulkstat *bstat)
 }
 
 static inline void
-scrub_item_init_metapath(struct scrub_item *sri, uint64_t metapath)
+scrub_item_init_metapath(struct scrub_item *sri, xfs_rgnumber_t rgno,
+		uint64_t metapath)
 {
 	memset(sri, 0, sizeof(*sri));
+	sri->sri_agno = rgno;
 	sri->sri_ino = metapath;
 }
 

