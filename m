Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E854D2563
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530618; cv=none; b=F74U6x0XUFInnd0rIPrATifWkXIFQx3uAJV5rkdb4VW6Y49TLfLy5oiQvx6vN+frZOszUCV2qA9L0bG22muPWEAlnQXfiSkmcIzUmD1kJf0DBZdzflsaVThlWc98s9CKBZlVyE8H1gUdlpJ/tZa31jLbd7Agi4W+xk+aQICInaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530618; c=relaxed/simple;
	bh=70FzFzhXysQRVXEv2NrcZvFxdZKKKCj+J7wslTu5Ap0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sINZG3YbxiGT2UyAQ28sUpN9dO2PmpCQ/+dbcb7fGIC1vW+ooGBmwwMHMdcHVL5w5EJUzrhkjTNaAv2M0aDEHPxZqUxrs1MbFMAFfPDl2XHBu3wz8kDTOMTsoFGStm0e4p5EXuRg3DggaIN8FTWIi/c/aYAul82yYUWJQLgfaOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nk72k64Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nk72k64Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7405FC4CED1;
	Sat,  7 Dec 2024 00:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530617;
	bh=70FzFzhXysQRVXEv2NrcZvFxdZKKKCj+J7wslTu5Ap0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nk72k64ZFq8HtfYUSj77RJMv/OpbUtyHXcruMJe62CHUNq4vhHhQoMnnj6hh0M0v3
	 Jt0btRzrVMnroFufdD16EUq2y5KrOdsWg9PhNxz3TRmi5ANO/R3nQZqPH57v1+Zsoj
	 ymm9vz5EGxrR7gOhU/Ga2K0ayzLsIwXeangDsmwbYIIgWeOFzmcMUBE0MEHM/s+CKY
	 GQFvwvD+3hHCDm7Lh87LFi05b0KVCdGjaxfTk5Mqd880qKhFJWNyUW/30fUtBFv+Yg
	 W36/M5cEQPimn/nmNZO52kxJT23Jvp0CHDviLn2FT9AQA+x/+Ml/rNY40Pcw30p4q7
	 KgO28Alt7jdWw==
Date: Fri, 06 Dec 2024 16:16:57 -0800
Subject: [PATCH 46/50] xfs_scrub: call GETFSMAP for each rt group in parallel
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752648.126362.13619225422874515961.stgit@frogsfrogsfrogs>
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

If realtime groups are enabled, we should take advantage of the sharding
to speed up the spacemap scans.  Do so by issuing per-rtgroup GETFSMAP
calls.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/spacemap.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 64 insertions(+), 8 deletions(-)


diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index e35756db2eed43..5b6bad138ce502 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -128,6 +128,45 @@ scan_ag_rmaps(
 	}
 }
 
+/* Iterate all the reverse mappings of a realtime group. */
+static void
+scan_rtg_rmaps(
+	struct workqueue	*wq,
+	xfs_agnumber_t		rgno,
+	void			*arg)
+{
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	struct scan_blocks	*sbx = arg;
+	struct fsmap		keys[2];
+	off_t			bperrg = bytes_per_rtgroup(&ctx->mnt.fsgeom);
+	int			ret;
+
+
+	memset(keys, 0, sizeof(struct fsmap) * 2);
+	keys->fmr_device = ctx->fsinfo.fs_rtdev;
+	keys->fmr_physical = (xfs_rtblock_t)rgno * bperrg;
+	(keys + 1)->fmr_device = ctx->fsinfo.fs_rtdev;
+	(keys + 1)->fmr_physical = ((rgno + 1) * bperrg) - 1;
+	(keys + 1)->fmr_owner = ULLONG_MAX;
+	(keys + 1)->fmr_offset = ULLONG_MAX;
+	(keys + 1)->fmr_flags = UINT_MAX;
+
+	if (sbx->aborted)
+		return;
+
+	ret = scrub_iterate_fsmap(ctx, keys, sbx->fn, sbx->arg);
+	if (ret) {
+		char		descr[DESCR_BUFSZ];
+
+		snprintf(descr, DESCR_BUFSZ, _("dev %d:%d rtgroup %u fsmap"),
+					major(ctx->fsinfo.fs_datadev),
+					minor(ctx->fsinfo.fs_datadev),
+					rgno);
+		str_liberror(ctx, ret, descr);
+		sbx->aborted = true;
+	}
+}
+
 /* Iterate all the reverse mappings of a standalone device. */
 static void
 scan_dev_rmaps(
@@ -208,14 +247,6 @@ scrub_scan_all_spacemaps(
 		str_liberror(ctx, ret, _("creating fsmap workqueue"));
 		return ret;
 	}
-	if (ctx->fsinfo.fs_rt) {
-		ret = -workqueue_add(&wq, scan_rt_rmaps, 0, &sbx);
-		if (ret) {
-			sbx.aborted = true;
-			str_liberror(ctx, ret, _("queueing rtdev fsmap work"));
-			goto out;
-		}
-	}
 	if (ctx->fsinfo.fs_log) {
 		ret = -workqueue_add(&wq, scan_log_rmaps, 0, &sbx);
 		if (ret) {
@@ -232,6 +263,31 @@ scrub_scan_all_spacemaps(
 			break;
 		}
 	}
+	if (ctx->fsinfo.fs_rt) {
+		for (agno = 0; agno < ctx->mnt.fsgeom.rgcount; agno++) {
+			ret = -workqueue_add(&wq, scan_rtg_rmaps, agno, &sbx);
+			if (ret) {
+				sbx.aborted = true;
+				str_liberror(ctx, ret,
+						_("queueing rtgroup fsmap work"));
+				break;
+			}
+		}
+
+		/*
+		 * If the fs doesn't have any realtime groups, scan the entire
+		 * volume all at once, since the above loop did nothing.
+		 */
+		if (ctx->mnt.fsgeom.rgcount == 0) {
+			ret = -workqueue_add(&wq, scan_rt_rmaps, 0, &sbx);
+			if (ret) {
+				sbx.aborted = true;
+				str_liberror(ctx, ret,
+						_("queueing rtdev fsmap work"));
+				goto out;
+			}
+		}
+	}
 out:
 	ret = -workqueue_terminate(&wq);
 	if (ret) {

