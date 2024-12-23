Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E75433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992610; cv=none; b=Hfz8fUHHieGtwQs3H2q7toNeU71okog/MIyhiOmtldiaYvAuwW2MhFfvMR8eovFdYdWMZ4+4LatPy3U48ktWIfix3IKRxj1JlALSbv1QX7bo5z7XNi9/8VE+KdLAaz72B+wTCnPyB//pEk66jxprnSlG4L3Z3zRo88sq9zqHqB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992610; c=relaxed/simple;
	bh=PuAP7/rY6o5EhuWCa4z57JS1pAiPZp2R+fiPcBuUTPo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hxxs+Ihiiv9/J+VCxjMAlKjBLcTLJilNqcwWIMcUjyBjFQJh+suGA9D/7KrM3g+0gScaaIttMQu4KyfYr56y8KQ9co6txQcht32DRBYGPJqxA+KfRfZodVVlt5P8hq2dW96ZymMlTgto6a6I9NP3p08OO1wAP67gpI7pX6lCVus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t4EdyTO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t4EdyTO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D8CC4CED3;
	Mon, 23 Dec 2024 22:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992610;
	bh=PuAP7/rY6o5EhuWCa4z57JS1pAiPZp2R+fiPcBuUTPo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t4EdyTO+211CY31S3z39MXl+VHIHYATWgUXNCNCTBW59DUgfjl6/HCAYNoQPpgRkm
	 7aAdnPYHdOTLHr8EwxXggOGoFJfKRq5AQf02K+xqjNXYPvB7vsVCg8RJgg2fbkvdcU
	 +VQlPDZ1WQRQoD6ksKGYnDUeVAe0lOJqnih9YiKInj4WfZRRzebb/dfBNaujCyFaau
	 LuJe8UoC+WjaDqPkaWxTVwvAXNCSbfhi9VAmevauoPHZ3Glgapp82uqjLXAmq0uTwy
	 iJk/mQgirnKkLtLYLEGqWFk+92U/OBMtMzLHVT+K73EarLu6dNAhAEFMlLp1i+UuJC
	 EqVqShzi3sj9Q==
Date: Mon, 23 Dec 2024 14:23:30 -0800
Subject: [PATCH 45/51] xfs_scrub: check rtgroup metadata directory connections
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944492.2297565.3738699429295344848.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

