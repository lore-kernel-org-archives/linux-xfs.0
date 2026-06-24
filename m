Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989592F87B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 18:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782324919; cv=none; b=nvdc5ETbWZoOaH8CSItOZo4Cd2UPuGRJKgUL18CK2m80R8e122QHOx3DtXOViFFcqSILk3fSifamAkQ0/v1Lhu9n/Gn0UuhBhvBrcUNKf6ox7vlpULXePKkqa0GjqnmKompcZGJL9t4sWfbKwMRR/Q6ERS10kk+UW6NKVV7/I+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782324919; c=relaxed/simple;
	bh=Ib6d5p+LvzvsXflge5xT9CzRlDVQ31EIqkoEzuy0cYg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCnZUjGSfzTWHtzhSJ2VdaBxwiNURCnG5hKYdg5sy4BHnWNGGWdnm6rS+U9QpSY9zdEoa2NYbFD77gvdOWwe6WsPNNH+HpzyG9tJdz46WjcKWGd9CrR4U0ooGrim+9YejQHouHacHieEkoWDhaEDR/OuJabcycU1s0YOvPm0+8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+rYw0h8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+rYw0h8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2DF041F000E9;
	Wed, 24 Jun 2026 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324918;
	bh=NCkdVr3uu9L/9pXpmz3lGDIwSP12dH13b/fJC1sgs68=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=C+rYw0h8/8Jx4MCjnlzyymm/c9T0xU8Tguebj/9TkEmdswJ4+6TbTDjrXBojzjOfa
	 AmI06gDPw3t/6JVmq5mBkEs4jTYp/6Z9W8xRy+UG/Kj5kYDOHBXuA35b3dKcRCR3s8
	 hH6oSCmavZje3ID8F0eAGqCzaQalffxxdYffRY5MhlSpWPmZ05qVXRr3ovURmh/Z4f
	 3CvTvJ59LGrs+geN8l8l/s4Y3qhhbaOF/oAknyO4i8ThxEcvPlMsspQlxC9RqqPTvU
	 99bKfEG+2Zm3x007SCCEgo8osbIILjqLCArZby1q83HYOpypUqJ6/se5b4OQ9Cmwxo
	 FjTSRR9OHiT8Q==
Date: Wed, 24 Jun 2026 11:15:17 -0700
Subject: [PATCH 03/11] xfs_scrub: handle media scans of internal rt devices
 correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178232484494.915780.16900802517191563379.stgit@frogsfrogsfrogs>
In-Reply-To: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex noticed media scans of internal rt devices don't work at all
correctly.  First, we fail to allocate a ctx->verify_disks[XFS_DEV_RT]
for the internal rt section, and even if we did, phase 6 doesn't
allocate media_verify_state.rvp[XFS_DEV_RT] if there's a media error on
an internal rt volume, so we'll crash there too.

Fix both issues to make it work properly.

Cc: <linux-xfs@vger.kernel.org> # v6.15.0
Fixes: 37591ef3f4f14c ("xfs_scrub: support internal RT device")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase1.c   |    7 +++++--
 scrub/phase6.c   |    4 ++--
 scrub/spacemap.c |    2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 34a2b3aec030eb..6ac59264b50bb7 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -101,7 +101,8 @@ scrub_cleanup(
 		disk_close(ctx->verify_disks[XFS_DEV_DATA]);
 	if (ctx->verify_disks[XFS_DEV_LOG])
 		disk_close(ctx->verify_disks[XFS_DEV_LOG]);
-	if (ctx->verify_disks[XFS_DEV_RT])
+	if (ctx->verify_disks[XFS_DEV_RT] &&
+	    ctx->verify_disks[XFS_DEV_RT] != ctx->verify_disks[XFS_DEV_DATA])
 		disk_close(ctx->verify_disks[XFS_DEV_RT]);
 	fshandle_destroy();
 	error = -xfd_close(&ctx->mnt);
@@ -232,7 +233,9 @@ configure_xfs_verify_fallback(
 		}
 	}
 
-	if (ctx->fsinfo.fs_rt) {
+	if (ctx->mnt.fsgeom.rtstart) {
+		ctx->verify_disks[XFS_DEV_RT] = ctx->verify_disks[XFS_DEV_DATA];
+	} else if (ctx->fsinfo.fs_rt || ctx->mnt.fsgeom.rtstart) {
 		ctx->verify_disks[XFS_DEV_RT] = disk_open(ctx->fsinfo.fs_rt);
 		if (!ctx->verify_disks[XFS_DEV_RT]) {
 			str_error(ctx, ctx->mntpoint,
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 2278ae5ad3dfd7..aef817add4157b 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -744,7 +744,7 @@ phase6_func(
 			goto out_datapool;
 		}
 	}
-	if (ctx->fsinfo.fs_rt) {
+	if (ctx->fsinfo.fs_rt || ctx->mnt.fsgeom.rtstart) {
 		ret = alloc_pool(ctx, &vs, XFS_DEV_RT);
 		if (ret) {
 			str_liberror(ctx, ret,
@@ -843,7 +843,7 @@ phase6_estimate(
 	 * nr_threads appropriately to handle that many threads.
 	 */
 	*nr_threads = read_verify_nproc(ctx);
-	if (ctx->fsinfo.fs_rt)
+	if (ctx->fsinfo.fs_rt || ctx->mnt.fsgeom.rtstart)
 		*nr_threads += read_verify_nproc(ctx);
 	if (ctx->fsinfo.fs_log)
 		*nr_threads += read_verify_nproc(ctx);
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 1ee4d1946d3db7..8f595ad94c5991 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -266,7 +266,7 @@ scrub_scan_all_spacemaps(
 			break;
 		}
 	}
-	if (ctx->fsinfo.fs_rt) {
+	if (ctx->fsinfo.fs_rt || ctx->mnt.fsgeom.rtstart) {
 		for (agno = 0; agno < ctx->mnt.fsgeom.rgcount; agno++) {
 			ret = -workqueue_add(&wq, scan_rtg_rmaps, agno, &sbx);
 			if (ret) {

