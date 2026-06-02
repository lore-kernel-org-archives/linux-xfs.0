Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89104199931
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 04:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780376301; cv=none; b=F8Qs2BV4bSKosQ5r8tj/wmuvVwZvec4LH7n1JL1Qtd45dwapLwasw3oebSQD/ODU3bj/eAh2bnrCxgXlWXkOl9S2xcfrRVMK5vI0Ken8RnKxmwsBKd43YqQTsKKl12ith7wHlrmXEIO+l7FoO/kruX7jIJ1jPNJjL6t8hueXmPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780376301; c=relaxed/simple;
	bh=uDpMfTyuPIBMrfFdmiWIJq0XcJmdqW87UeIYTQ8YhNA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GKzYu6p/6X4lMSSdvPjt4X3a1zYsbXvn/pMj1Zpkkztlp92wnFx0bHI4J5XXH7aSmWvAUdffA2/x5oTNG7yyh5rPevhdUtj2fAsBtrArI7hct+dz5iRGkGPpF0hDdjUMNfXdPvYNEzutYGBSCQIPe5575F/c51aFmELC6hXnEaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KfREPPRU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KfREPPRU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 178D01F00893;
	Tue,  2 Jun 2026 04:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780376300;
	bh=NQnuyCUuXVXXmHeYQYWQGxePQK1ubUClnfsoUSnIoUU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=KfREPPRUwafKOUmskuvfqFVLfLcYSP48NZPdOIowsdC9ReIvrfT2iueibWZOBjrdq
	 4XkOlzyJNALoBVwRmlz5mJkaSPXoXb71jbgJwomDp5UNls22tgjRT1BZ7Dt5w4M0Wu
	 PcllYPGHXkVBKBNGqnbFzJqYI8Q80iNC/ow2X9u6WkiE5sQNfkYAZQRRr6cgRE4sRK
	 P9lxlEUm/NPbkzq23NVQ8LLOiPbEt6/b1cLpcdYj++Ib7tPNs5rh2ARtppQQkhl5ap
	 0dZPSNrqeTk5TXg3Gbwtp3BXt7qG7m4PrWkDsa2uK0wcqcrwq7gM7/K5w/BTt4k8tg
	 PWgJ6JnP2vJhg==
Date: Mon, 01 Jun 2026 21:58:19 -0700
Subject: [PATCH 1/7] xfs_healer: fix error reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178037627061.588879.3503165728247541179.stgit@frogsfrogsfrogs>
In-Reply-To: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex complains about incorrect error reporting logic here -- in the
first place we totally fail to pick up errno; in the second, we do, but
with inverted sign.  Fix both.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: b9b03770197d19 ("xfs_healer: create daemon to listen for health events")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
index 36e52a71bebfa7..4ea8d86ac9114a 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -453,7 +453,7 @@ setup_monitor(
 	 * the kernel as quickly as we can.  Note that the kernel won't accrue
 	 * more than 32K of internal events before it starts dropping them.
 	 */
-	ret = workqueue_create_bound(&ctx->event_queue, ctx, healer_nproc(ctx),
+	ret = -workqueue_create_bound(&ctx->event_queue, ctx, healer_nproc(ctx),
 			1048576 / sizeof(struct xfs_health_monitor_event));
 	if (ret) {
 		errno = ret;
@@ -503,10 +503,12 @@ monitor(
 
 		nr = fread(hme, sizeof(*hme), 1, ctx->mon_fp);
 		if (ferror(ctx->mon_fp)) {
+			int error = errno;
+
 			pthread_mutex_lock(&ctx->conlock);
 			fprintf(stderr, "%s: %s: %s\n", ctx->mntpoint,
 					_("error reading event file"),
-					strerror(ret));
+					strerror(error));
 			pthread_mutex_unlock(&ctx->conlock);
 			free(hme);
 			ret = -1;
@@ -521,7 +523,7 @@ monitor(
 			mounted = false;
 
 		/* handle_event owns hme if the workqueue_add succeeds */
-		ret = workqueue_add(&ctx->event_queue, handle_event, 0, hme);
+		ret = -workqueue_add(&ctx->event_queue, handle_event, 0, hme);
 		if (ret) {
 			pthread_mutex_lock(&ctx->conlock);
 			fprintf(stderr, "%s: %s: %s\n", ctx->mntpoint,
@@ -529,6 +531,7 @@ monitor(
 					strerror(ret));
 			pthread_mutex_unlock(&ctx->conlock);
 			free(hme);
+			ret = -1;
 			break;
 		}
 	} while (nr > 0 && mounted);

