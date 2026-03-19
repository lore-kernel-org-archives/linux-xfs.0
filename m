Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D0110E3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895705; cv=none; b=BdtivQtvo3t8fJnIabJfP00levmKUavMIfocN86yPOHOhTy3TksSF/DhpmFY/ehk7fO1eaovbBRGgf2O3li1oN+Ml8C528g0h4G1fNc/1XnaJ3ekhcPJo78w5glb3R5NpTr3F+yUY8XqfxkmYypGGOOfKVmkXeKvBcfclBZ/xhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895705; c=relaxed/simple;
	bh=tGAyTrQ53RgQSaZ+K4EACrKEbG4uTQZ1l3LmWPGYo14=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u0ci2+45Vd3lXzEDYszVGs/ytzr1A1MR/RBOI2R7jgyt5i33FWeaeuULBJIZT0VxBPmROnRfRGWGzaethjemtKZJA5zpwUDnw4QfYr133imFnbuiVX75D0bf2DDc13pQbJkPl+toEzBJt515jj7NPidlOv8l/0CLD+6+BL5yB3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sx4F0JVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sx4F0JVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA48EC19425;
	Thu, 19 Mar 2026 04:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895704;
	bh=tGAyTrQ53RgQSaZ+K4EACrKEbG4uTQZ1l3LmWPGYo14=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sx4F0JVX2EapCAmJD/JAEyVpqVO3s9YfcNGWPsuXm8cyvuF3RKNMh4SwvNXXk0fMv
	 TEYl6PtN0nbAfuIZQH+wXQuy6eddbMa9BFhMKTGtTtrsb6wlbbfIupZXkp7RoCrScC
	 dCE/if7E8GaJMwjVZ1orJegNYDtiAAK9oGKwWnr8lrmoaiDqLH5DTKeA3henlb7fB2
	 zW8u3sBK+iewueHspYxgRvAoQf/+xfM0YZhN0JXZchpMbFfl2YYPtyCnFCTAMWqQ+P
	 1t8F4q0pWodZ1hP8HOAyHh0KOzAxErePiHB0NWP+ISKuVEtORDI1uY9xfsEYg5QFQJ
	 gejaMR+Gsq/YA==
Date: Wed, 18 Mar 2026 21:48:24 -0700
Subject: [PATCH 11/22] xfs_scrub: rename nr_io_threads
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177389507141.3681140.14458592412302448426.stgit@frogsfrogsfrogs>
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

This variable really describes the number of threads that we should
start up to scan metadata.  Rename it to reduce confusion with the media
verification code, which also initiates IO.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrub.h |    2 +-
 scrub/common.c    |    2 +-
 scrub/phase1.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index a7e67c37469beb..3009a7cd2d97d0 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -70,7 +70,7 @@ struct scrub_ctx {
 	struct xfs_fd		mnt;
 
 	/* Number of threads for metadata scrubbing */
-	unsigned int		nr_io_threads;
+	unsigned int		nr_scan_threads;
 
 	/* XFS specific geometry */
 	struct fs_path		fsinfo;
diff --git a/scrub/common.c b/scrub/common.c
index 34d91525928305..95bc0c091eae27 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -275,7 +275,7 @@ scrub_nproc(
 {
 	if (force_nr_threads)
 		return force_nr_threads;
-	return ctx->nr_io_threads;
+	return ctx->nr_scan_threads;
 }
 
 /*
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 954a62b7e8d711..16607af4c5f025 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -355,7 +355,7 @@ _("Unable to find realtime device path."));
 		return ECANCELED;
 	}
 
-	ctx->nr_io_threads = disk_heads(ctx->verify_disks[XFS_DEV_DATA]);
+	ctx->nr_scan_threads = disk_heads(ctx->verify_disks[XFS_DEV_DATA]);
 	if (verbose) {
 		fprintf(stdout, _("%s: using %d threads to scrub.\n"),
 				ctx->mntpoint, scrub_nproc(ctx));

