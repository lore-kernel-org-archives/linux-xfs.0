Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DD229DB86
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801672; cv=none; b=RifQcv1fyau1yi9cJhqvt7bKjeI4fbsuqP7o9/75e2I2KMQpN6N4iePPy4Qb7mw6LsF0Jy5oMRXMQXn/5TAwpnkr0HoknJbDWeY/TFnCCDk47nqMgEXFZrLWQk8r0lWRwx/aVKFQ5tQtQW/jymvQWL7TxwIilXbXBkEb0/xWocE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801672; c=relaxed/simple;
	bh=mVEhQNAbSqruyqHDRFyYxz4OFsuOGa5PJjbLu7MA1Zo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lPxcjzuxXss+vMxszom9dA8Hir9prH6Vn6mesn/oDN5bnaOHIWhusjBxoqQR57x8CBT7tow2I3yYpdetifEHgPN9EONZ4Gerd0OJtTx6E1qy8oopDH12gQ53UA759yhaCNq1oyOFZnxTvZjKSKzagasL56jaP7oZTK81Kijg1Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JzceyjkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JzceyjkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C84DC19421;
	Fri, 10 Apr 2026 06:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801671;
	bh=mVEhQNAbSqruyqHDRFyYxz4OFsuOGa5PJjbLu7MA1Zo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JzceyjkGohq2YM0/sZV0sD/7yDq3GEHK/XVd6txyG13zbfBSuUY98UA64H6NrCkyl
	 wH1cpdz+W6mvVNJYl4R+Phbh9J85x3q7tTiSE80SLzumddR5LzhSHDMpHwA+f5T4Gs
	 ng86H1LaTcVTMU95pH5Myey5KmC3HM4IRUTfNINPt9iMuerJMpXwr+rjOF4BmUyMYs
	 0c4INsotMtzgPhYH4c3KjbRp5vjrDrPUAqDopeWeb+yeYdOZ12PqV1CENnsDFwj4SW
	 NB/qZ20xi0Dlrt3boDar0xT1g5V/xs+ZH0cwby4FZImC329mTQDMQ6Omzql2JO5YNF
	 7Pq49GZP+L5yg==
Date: Thu, 09 Apr 2026 23:14:31 -0700
Subject: [PATCH 15/26] xfs_healer: don't start service if kernel support
 unavailable
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384507.2089237.5078195987511819537.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
References: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use ExecCondition= in the system service to check if kernel support for
the health monitor is available.  If not, we don't want to run the
service, have it fail, and generate a bunch of silly log messages.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 healer/xfs_healer.h           |    1 +
 healer/xfs_healer.c           |   52 +++++++++++++++++++++++++++++++++--------
 healer/xfs_healer@.service.in |    1 +
 3 files changed, 44 insertions(+), 10 deletions(-)


diff --git a/healer/xfs_healer.h b/healer/xfs_healer.h
index 679bdc95ae48f8..7caa6c66a59c6f 100644
--- a/healer/xfs_healer.h
+++ b/healer/xfs_healer.h
@@ -27,6 +27,7 @@ struct healer_ctx {
 	int			foreground;
 	int			want_repair;
 	int			print_svcname;
+	int			support_check;
 
 	/* fd and fs geometry for mount */
 	struct xfs_fd		mnt;
diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
index d9ab53c153a456..cf26f9c04ef225 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -195,19 +195,27 @@ healer_nproc(
 	return ctx->foreground ? platform_nproc() : 1;
 }
 
+enum mon_state {
+	MON_START,
+	MON_EXIT,
+	MON_ERROR,
+	MON_UNSUPPORTED,
+};
+
 /* Set ourselves up to monitor the given mountpoint for health events. */
-static int
+static enum mon_state
 setup_monitor(
 	struct healer_ctx	*ctx)
 {
 	const long		BUF_SIZE = sysconf(_SC_PAGE_SIZE) * 2;
+	enum mon_state		outcome = MON_ERROR;
 	int			mon_fd;
 	int			ret;
 
 	ret = xfd_open(&ctx->mnt, ctx->mntpoint, O_RDONLY);
 	if (ret) {
 		perror(ctx->mntpoint);
-		return -1;
+		return outcome;
 	}
 
 	ret = try_capture_fsinfo(ctx);
@@ -263,6 +271,7 @@ setup_monitor(
 		case EOPNOTSUPP:
 			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
  _("XFS health monitoring not supported."));
+			outcome = MON_UNSUPPORTED;
 			break;
 		case EEXIST:
 			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
@@ -278,6 +287,16 @@ setup_monitor(
 	close(ctx->mnt.fd);
 	ctx->mnt.fd = -1;
 
+	/*
+	 * At this point, we know that the kernel is capable of repairing the
+	 * filesystem and telling us that it needs repairs.  If the user only
+	 * wanted us to check for the capability, we're done.
+	 */
+	if (ctx->support_check) {
+		close(mon_fd);
+		return MON_EXIT;
+	}
+
 	/*
 	 * mon_fp consumes mon_fd.  We intentionally leave mon_fp attached to
 	 * the context so that we keep the monitoring fd open until we've torn
@@ -309,7 +328,7 @@ setup_monitor(
 	}
 	ctx->queue_active = true;
 
-	return 0;
+	return MON_START;
 
 out_mon_fp:
 	if (ctx->mon_fp)
@@ -322,7 +341,7 @@ setup_monitor(
 	if (ctx->mnt.fd >= 0)
 		close(ctx->mnt.fd);
 	ctx->mnt.fd = -1;
-	return -1;
+	return outcome;
 }
 
 /* Monitor the given mountpoint for health events. */
@@ -412,6 +431,7 @@ usage(void)
 	fprintf(stderr, _("  --foreground  Process events as soon as possible.\n"));
 	fprintf(stderr, _("  --quiet       Do not log health events to stdout.\n"));
 	fprintf(stderr, _("  --repair      Repair corrupt metadata found at runtime.\n"));
+	fprintf(stderr, _("  --supported   Check that health monitoring is supported.\n"));
 	fprintf(stderr, _("  -V            Print version.\n"));
 
 	exit(EXIT_FAILURE);
@@ -424,6 +444,7 @@ enum long_opt_nr {
 	LOPT_HELP,
 	LOPT_QUIET,
 	LOPT_REPAIR,
+	LOPT_SUPPORTED,
 	LOPT_SVCNAME,
 
 	LOPT_MAX,
@@ -456,6 +477,7 @@ main(
 		[LOPT_HELP]	   = {"help", no_argument, NULL, 0 },
 		[LOPT_QUIET]	   = {"quiet", no_argument, &ctx.log, 0 },
 		[LOPT_REPAIR]	   = {"repair", no_argument, &ctx.want_repair, 1 },
+		[LOPT_SUPPORTED]   = {"supported", no_argument, &ctx.support_check, 1 },
 		[LOPT_SVCNAME]	   = {"svcname", no_argument, &ctx.print_svcname, 1 },
 
 		[LOPT_MAX]	   = {NULL, 0, NULL, 0 },
@@ -507,14 +529,24 @@ main(
 		return EXIT_SUCCESS;
 	}
 
-	ret = setup_monitor(&ctx);
-	if (ret)
-		goto out_events;
+	switch (setup_monitor(&ctx)) {
+	case MON_UNSUPPORTED:
+		ret = 1; /* condition not met */
+		break;
+	case MON_ERROR:
+		ret = 255; /* service failed */
+		break;
+	case MON_EXIT:
+		ret = 0;
+		break;
+	case MON_START:
+		ret = monitor(&ctx);
+		break;
+	}
 
-	ret = monitor(&ctx);
-
-out_events:
 	teardown_monitor(&ctx);
 	free((char *)ctx.fsname);
+	if (ctx.support_check)
+		return ret;
 	return systemd_service_exit(ret);
 }
diff --git a/healer/xfs_healer@.service.in b/healer/xfs_healer@.service.in
index 385257872b0cbb..53f89cf9c4333d 100644
--- a/healer/xfs_healer@.service.in
+++ b/healer/xfs_healer@.service.in
@@ -17,6 +17,7 @@ RequiresMountsFor=%f
 [Service]
 Type=exec
 Environment=SERVICE_MODE=1
+ExecCondition=@pkg_libexec_dir@/xfs_healer --supported %f
 ExecStart=@pkg_libexec_dir@/xfs_healer %f
 SyslogIdentifier=%N
 

