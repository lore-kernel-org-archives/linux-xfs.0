Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DF9205E26
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114388; cv=none; b=Rg6NcOg5EeVvQ7PuJZMUVHxQxB2egSLB56GwNZOXqVQXWdwQAh1rhFk/57gbUU1ROcIzMGap6/zVBAuLzvMJbtRn4+9v9j++nfqoPKP5W+vu7odqKGbWVta7rALs0AcXNQ+pIUIg9K6vycKudk2hPsrORkDGAD5Tk7wXdvHdSQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114388; c=relaxed/simple;
	bh=crWEkosGiOC4Si8MJV/8jUeFh4QIXl78E2+GZMeroko=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fcipCAnyEHGmnKfziFLMc46tjw5J6Q2c8r5qFrrt1dXYavTJvX1jV03aZjSs4sav3NRqDGkDkCvSxzsjU2oyfLqiidxlCc8g79752KIu/sgPVIF1dGwO3+AG/qb19tFgpk4LB9MoNG9xl2KThXltKzfGBWQuJqzKf1jiCOFwCHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vAHr6+9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vAHr6+9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712ADC4CEF7;
	Tue, 10 Mar 2026 03:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114388;
	bh=crWEkosGiOC4Si8MJV/8jUeFh4QIXl78E2+GZMeroko=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vAHr6+9OKHfhUJLQOCQT76LhdONTHARhYUBFMcsfhk0XMoeIoVmKA4uilBiB2vyb5
	 GuEp0telE8MxPqeScCIIWw/i8u2aqT+d65XV+ipMK7ebPG+OMB0YQr0f7EggeMQUdB
	 hjTXYjNQ3a1lAywgFuoJdmZypZC4kn5+Xmrr5fqgL2L8OI3utStruadzETaHJ8m8Rb
	 d4VlTZ8GfKtgdwxl2KcFmCmyCDsKqLuqnR7DZFOtXt9WlmoNrQwhmMhIf7faFZwygY
	 gPY6qlz6FkG8nzIK2abQgBFALbPKiQZucThPY+ABpVkTcI+MeSAZuasTVN+Fj5lPoI
	 VtLIKI9n/ksfQ==
Date: Mon, 09 Mar 2026 20:46:27 -0700
Subject: [PATCH 15/28] xfs_healer: don't start service if kernel support
 unavailable
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177311401736.1183235.5429386610769734021.stgit@frogsfrogsfrogs>
In-Reply-To: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
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
 healer/xfs_healer.c           |   47 ++++++++++++++++++++++++++++++++---------
 healer/xfs_healer@.service.in |    1 +
 3 files changed, 39 insertions(+), 10 deletions(-)


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
index 1a26ffe830e5fe..8c48d2d9ee8c2d 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -191,8 +191,14 @@ healer_nproc(
 	return ctx->foreground ? platform_nproc() : 1;
 }
 
+enum mon_state {
+	MON_START,
+	MON_EXIT,
+	MON_ERROR,
+};
+
 /* Set ourselves up to monitor the given mountpoint for health events. */
-static int
+static enum mon_state
 setup_monitor(
 	struct healer_ctx	*ctx)
 {
@@ -203,7 +209,7 @@ setup_monitor(
 	ret = xfd_open(&ctx->mnt, ctx->mntpoint, O_RDONLY);
 	if (ret) {
 		perror(ctx->mntpoint);
-		return -1;
+		return MON_ERROR;
 	}
 
 	ret = try_capture_fsinfo(ctx);
@@ -274,6 +280,16 @@ setup_monitor(
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
@@ -305,7 +321,7 @@ setup_monitor(
 	}
 	ctx->queue_active = true;
 
-	return 0;
+	return MON_START;
 
 out_mon_fp:
 	if (ctx->mon_fp)
@@ -318,7 +334,7 @@ setup_monitor(
 	if (ctx->mnt.fd >= 0)
 		close(ctx->mnt.fd);
 	ctx->mnt.fd = -1;
-	return -1;
+	return MON_ERROR;
 }
 
 /* Monitor the given mountpoint for health events. */
@@ -395,6 +411,7 @@ usage(void)
 	fprintf(stderr, _("  --foreground  Process events as soon as possible.\n"));
 	fprintf(stderr, _("  --quiet       Do not log health events to stdout.\n"));
 	fprintf(stderr, _("  --repair      Always repair corrupt metadata.\n"));
+	fprintf(stderr, _("  --supported   Check that health monitoring is supported.\n"));
 	fprintf(stderr, _("  -V            Print version.\n"));
 
 	exit(EXIT_FAILURE);
@@ -407,6 +424,7 @@ enum long_opt_nr {
 	LOPT_HELP,
 	LOPT_QUIET,
 	LOPT_REPAIR,
+	LOPT_SUPPORTED,
 	LOPT_SVCNAME,
 
 	LOPT_MAX,
@@ -439,6 +457,7 @@ main(
 		[LOPT_HELP]	   = {"help", no_argument, NULL, 0 },
 		[LOPT_QUIET]	   = {"quiet", no_argument, &ctx.log, 0 },
 		[LOPT_REPAIR]	   = {"repair", no_argument, &ctx.want_repair, 1 },
+		[LOPT_SUPPORTED]   = {"supported", no_argument, &ctx.support_check, 1 },
 		[LOPT_SVCNAME]	   = {"svcname", no_argument, &ctx.print_svcname, 1 },
 
 		[LOPT_MAX]	   = {NULL, 0, NULL, 0 },
@@ -490,14 +509,22 @@ main(
 		return EXIT_SUCCESS;
 	}
 
-	ret = setup_monitor(&ctx);
-	if (ret)
-		goto out_events;
+	switch (setup_monitor(&ctx)) {
+	case MON_ERROR:
+		ret = -1;
+		break;
+	case MON_EXIT:
+		ret = 0;
+		break;
+	case MON_START:
+		ret = 0;
+		monitor(&ctx);
+		break;
+	}
 
-	monitor(&ctx);
-
-out_events:
 	teardown_monitor(&ctx);
 	free((char *)ctx.fsname);
+	if (ctx.support_check)
+		return systemd_service_exit_now(ret);
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
 

