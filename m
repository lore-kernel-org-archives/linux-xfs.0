Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3B9188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992626; cv=none; b=eemJz25AsSecSs51qgNws8vk6E/Zk/2x5Fxnqki3wNIVDY2y85Qj9iRQrkemOHn8yObA6ffB4XsykIKp1c0Ay/BqIpJzcB9BnFliAWsUJjrbQcHIfM4p1vaGwyfTFl1mFjEmo/wcgdA/oimNUr1iZ9+JyMrw7NyU300vNF1wJDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992626; c=relaxed/simple;
	bh=E2w7rNJD26HBEMQXdsDCzzac2xRRSRBnqzWIsyPYYpY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AyVeuO75Zh5GVOJbyEzIiX14hbKqdn57Ad/Kmw+XYTPPxp3MnRrDETG1fN75pLDQL/5t3CsfFBMVzDIbriqgF3zN+YO8m+/zc2DfqYpMOfV/GdPIxHIWlqlPvfkyuTqHNKCKxamHOYjfVcTXMR+0et53ZIz7dgQVl3EXXrlxraA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WfX24ZMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WfX24ZMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D53AC4CED3;
	Mon, 23 Dec 2024 22:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992626;
	bh=E2w7rNJD26HBEMQXdsDCzzac2xRRSRBnqzWIsyPYYpY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WfX24ZMk/QyW5eprF4Q/OsV8QlAOC7L4+r2G/Ccs7Nh7dMZ8KhXnB8p9d7s6CKcoo
	 vcfzhAUJlE67JGBKh5CpZKptr451GzsUUMaJVS59STYRsFhl4bSBDCC4zsMtJpN+As
	 Uqvo6Bb1KF/R8OoQKQ1smQ10p3kFqmDCUg+hUkerrR+d9Ri+h1CwXp7QWygRG9vCJc
	 sSDxrZQiwgwqRPA6lmiH1ZF/HsPr+2U4xVRCXaAfrKLzX5zMQh2yqlFNKgXVZiR3YD
	 h0RuCqcEthP9Is0gVkv1/Jo8De15oksXoyUUeuW/1qfbcpcsfRsCX6KkdMQ5HvImWE
	 1PkTdNgJ8T6RQ==
Date: Mon, 23 Dec 2024 14:23:45 -0800
Subject: [PATCH 46/51] xfs_scrub: cleanup fsmap keys initialization
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944508.2297565.5711210921054427793.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Use the good old array notations instead of pointer arithmetics.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
[djwong: fold scan_rtg_rmaps cleanups into next patch]
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase6.c   |   17 ++++++++---------
 scrub/spacemap.c |   32 +++++++++++++++-----------------
 2 files changed, 23 insertions(+), 26 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index e4f26e7f1dd93e..fc63f5aad0bd7b 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -495,7 +495,7 @@ report_ioerr(
 	uint64_t			length,
 	void				*arg)
 {
-	struct fsmap			keys[2];
+	struct fsmap			keys[2] = { };
 	struct ioerr_filerange		fr = {
 		.physical		= start,
 		.length			= length,
@@ -506,14 +506,13 @@ report_ioerr(
 	dev = disk_to_dev(dioerr->ctx, dioerr->disk);
 
 	/* Go figure out which blocks are bad from the fsmap. */
-	memset(keys, 0, sizeof(struct fsmap) * 2);
-	keys->fmr_device = dev;
-	keys->fmr_physical = start;
-	(keys + 1)->fmr_device = dev;
-	(keys + 1)->fmr_physical = start + length - 1;
-	(keys + 1)->fmr_owner = ULLONG_MAX;
-	(keys + 1)->fmr_offset = ULLONG_MAX;
-	(keys + 1)->fmr_flags = UINT_MAX;
+	keys[0].fmr_device = dev;
+	keys[0].fmr_physical = start;
+	keys[1].fmr_device = dev;
+	keys[1].fmr_physical = start + length - 1;
+	keys[1].fmr_owner = ULLONG_MAX;
+	keys[1].fmr_offset = ULLONG_MAX;
+	keys[1].fmr_flags = UINT_MAX;
 	return -scrub_iterate_fsmap(dioerr->ctx, keys, report_ioerr_fsmap,
 			&fr);
 }
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index e35756db2eed43..4b7fae252d86ca 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -96,21 +96,20 @@ scan_ag_rmaps(
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_blocks	*sbx = arg;
-	struct fsmap		keys[2];
+	struct fsmap		keys[2] = { };
 	off_t			bperag;
 	int			ret;
 
 	bperag = (off_t)ctx->mnt.fsgeom.agblocks *
 		 (off_t)ctx->mnt.fsgeom.blocksize;
 
-	memset(keys, 0, sizeof(struct fsmap) * 2);
-	keys->fmr_device = ctx->fsinfo.fs_datadev;
-	keys->fmr_physical = agno * bperag;
-	(keys + 1)->fmr_device = ctx->fsinfo.fs_datadev;
-	(keys + 1)->fmr_physical = ((agno + 1) * bperag) - 1;
-	(keys + 1)->fmr_owner = ULLONG_MAX;
-	(keys + 1)->fmr_offset = ULLONG_MAX;
-	(keys + 1)->fmr_flags = UINT_MAX;
+	keys[0].fmr_device = ctx->fsinfo.fs_datadev;
+	keys[0].fmr_physical = agno * bperag;
+	keys[1].fmr_device = ctx->fsinfo.fs_datadev;
+	keys[1].fmr_physical = ((agno + 1) * bperag) - 1;
+	keys[1].fmr_owner = ULLONG_MAX;
+	keys[1].fmr_offset = ULLONG_MAX;
+	keys[1].fmr_flags = UINT_MAX;
 
 	if (sbx->aborted)
 		return;
@@ -135,16 +134,15 @@ scan_dev_rmaps(
 	dev_t			dev,
 	struct scan_blocks	*sbx)
 {
-	struct fsmap		keys[2];
+	struct fsmap		keys[2] = { };
 	int			ret;
 
-	memset(keys, 0, sizeof(struct fsmap) * 2);
-	keys->fmr_device = dev;
-	(keys + 1)->fmr_device = dev;
-	(keys + 1)->fmr_physical = ULLONG_MAX;
-	(keys + 1)->fmr_owner = ULLONG_MAX;
-	(keys + 1)->fmr_offset = ULLONG_MAX;
-	(keys + 1)->fmr_flags = UINT_MAX;
+	keys[0].fmr_device = dev;
+	keys[1].fmr_device = dev;
+	keys[1].fmr_physical = ULLONG_MAX;
+	keys[1].fmr_owner = ULLONG_MAX;
+	keys[1].fmr_offset = ULLONG_MAX;
+	keys[1].fmr_flags = UINT_MAX;
 
 	if (sbx->aborted)
 		return;

