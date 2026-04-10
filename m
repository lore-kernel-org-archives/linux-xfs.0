Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BDC35BDA0
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802015; cv=none; b=cHxq/UsBWb1UtVKknW/1dFHv2T4Z8x4gAsi93kYEIMpCw057OMKPzgZhZo1YYZl/TNUqF2NrlAT2Y2nvGE+dCGFr1LogypchwGnlTRLC9XFCNuq907/UmHBUP/zkNBjj8lAQzDeCpG3tMEIHUA491YF5DJ9duLCjoC2KhFm6RYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802015; c=relaxed/simple;
	bh=dCXCaEh792qNO/1FXYHSa+oSVCJE5gVv/uWzXDoKcXQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iit5Ie0mn4pOe7dp1jJRsYqAS4pH01zpNmhchb/bXIa+xIgS6X4eVFPpXEEILGjfji2z8HKpxnvIZEoq8I+5L6WBX71y5BKpZ0paddPlL2EfJJI7Mz/vJ/uPfc1ZVZrszNl03E1CIfoqvyma1XDbakjuCe+siY9GUzeHV9ieLIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msoXiCER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msoXiCER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0D9C19421;
	Fri, 10 Apr 2026 06:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775802015;
	bh=dCXCaEh792qNO/1FXYHSa+oSVCJE5gVv/uWzXDoKcXQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=msoXiCERcIP9ZpgPs6fCsbnpzxGEYPMOyWIElbAQjNu8sj1NkW9Kld79foGcvMyGD
	 6Vp9cMgxhUtUoRQ4t3UaAX1EsZVr9K7Uc0vStuPw+I9YkTlfR8W9j1dPt2VGfRiNw8
	 Ay8M4gUzqrdwGdwVx89S9Kn8CocDMrTpBWv3JnROlnA7ENWe8GuLO0XWFRXkM7sB5M
	 wqUD27YBWHnzufiuqASzLx9Em0q63ToluduK5qOvyqhZf6MGIGx1TFCzKxTwtsOCof
	 BN/Zg0QbPTjyOeSE89u4wuJkdgJoHcV996P06n9LsRfHiDbin3mmHRHL6SpyPMxu44
	 kn8RCb5xAwZ2g==
Date: Thu, 09 Apr 2026 23:20:14 -0700
Subject: [PATCH 11/21] xfs_scrub: rename nr_io_threads
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577385234.2090237.6143733154813318851.stgit@frogsfrogsfrogs>
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

This variable really describes the number of threads that we should
start up to scan metadata.  Rename it to reduce confusion with the media
verification code, which also initiates IO.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

