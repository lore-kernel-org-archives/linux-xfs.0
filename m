Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5226C22CBC6
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498249; cv=none; b=orqUMbn1/mt/5cOnZF3oYWztkMbqwpKsXN+MkWp6xVAr6BpNCZstTLj1plp6owS7RYvFsRdk//v5NdX8zUJWh6joTT09PYvb1gSyqZAfdDEqtrYHEpkwCcye2V0/Nyc6OV7kCTkdZH2kWDbN9c1vjWMcSdcxUn03bYGvEVGUz7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498249; c=relaxed/simple;
	bh=xRI+AyIBTB1/ijOh6NTz0MHkuhvSLrGQ7amAAjX6YHk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qlL3aofizQn/BSvmn1pqi6Z3Irwzef+W6oa+z+iinAaqKYcE0Hj7aC0SfRPNufK76BCvzgnLIeLr6jUzJxS1yl1kviTYwIe9mrKH6exnC56OrJsOyn6LW6J0g1DHnUjfxYcM8y/J3lMv0NGXTVRZ84zwXG3G0YwVnWLlsPbGewk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=owdJJ5kS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="owdJJ5kS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C69C19423;
	Tue,  3 Mar 2026 00:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498249;
	bh=xRI+AyIBTB1/ijOh6NTz0MHkuhvSLrGQ7amAAjX6YHk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=owdJJ5kSdMCL/Z1lYA8wvVjyWM+lWhh/BQ1l57dhQcWnXrD3wyhXBo1UGvNtBn9oY
	 4ygy9+bGqw285dZGg0+P8biJ+nl9BUYf24fy1TtCenp1GT2QtuWQhTWF9bGttt64wj
	 9PiG4CW5W8hrSBQkeexV2hAvnyEzKWUd8PipmEFik4HTyk21qTbyGOhjUuGNHe9uyf
	 TYTHil8RrDF0PAWgsGQaatihDy5gGWbDCL5yY//Hhjwk5SbI9AZgxDDM1vlWncMpvG
	 0B7apJZuoOYQ0EZHybnl0tYK6foOFOkKbTBF8KwXoDrzrs6ZninGjy58s8syqWF8HX
	 oqSopf/eHHn4g==
Date: Mon, 02 Mar 2026 16:37:28 -0800
Subject: [PATCH 14/26] xfs_healer: don't start service if kernel support
 unavailable
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783546.482027.2803579025725758958.stgit@frogsfrogsfrogs>
In-Reply-To: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
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
---
 healer/xfs_healer.h           |    1 +
 healer/xfs_healer.c           |   55 +++++++++++++++++++++++++++++++----------
 healer/xfs_healer@.service.in |    1 +
 3 files changed, 43 insertions(+), 14 deletions(-)


diff --git a/healer/xfs_healer.h b/healer/xfs_healer.h
index 6d12921245934c..93cca394e9fdd1 100644
--- a/healer/xfs_healer.h
+++ b/healer/xfs_healer.h
@@ -26,6 +26,7 @@ struct healer_ctx {
 	int			everything;
 	int			foreground;
 	int			want_repair;
+	int			support_check;
 
 	/* fd and fs geometry for mount */
 	struct xfs_fd		mnt;
diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
index 2f431f18c69318..69e5368f6ee794 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -154,8 +154,14 @@ healer_nproc(
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
@@ -166,7 +172,7 @@ setup_monitor(
 	ret = xfd_open(&ctx->mnt, ctx->mntpoint, O_RDONLY);
 	if (ret) {
 		perror(ctx->mntpoint);
-		return -1;
+		return MON_ERROR;
 	}
 
 	if (ctx->want_repair) {
@@ -175,7 +181,7 @@ setup_monitor(
 			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
  _("XFS online repair is not supported, exiting"));
 			close(ctx->mnt.fd);
-			return -1;
+			return MON_ERROR;
 		}
 
 		/* Check for backref metadata that makes repair effective. */
@@ -201,7 +207,7 @@ setup_monitor(
 			fprintf(stderr, "%s: %s: %s\n", ctx->mntpoint,
 					_("creating weak fshandle"),
 					strerror(errno));
-			return -1;
+			return MON_ERROR;
 		}
 	}
 
@@ -227,7 +233,17 @@ setup_monitor(
 			perror(ctx->mntpoint);
 			break;
 		}
-		return -1;
+		return MON_ERROR;
+	}
+
+	/*
+	 * At this point, we know that the kernel is capable of repairing the
+	 * filesystem and telling us that it needs repairs.  If the user only
+	 * wanted us to check for the capability, we're done.
+	 */
+	if (ctx->support_check) {
+		close(mon_fd);
+		return MON_EXIT;
 	}
 
 	/*
@@ -239,7 +255,7 @@ setup_monitor(
 	if (!ctx->mon_fp) {
 		close(mon_fd);
 		perror(ctx->mntpoint);
-		return -1;
+		return MON_ERROR;
 	}
 
 	/* Increase the buffer size so that we can reduce kernel calls */
@@ -258,11 +274,11 @@ setup_monitor(
 		errno = ret;
 		fprintf(stderr, "%s: %s: %s\n", ctx->mntpoint,
 				_("worker threadpool setup"), strerror(errno));
-		return -1;
+		return MON_ERROR;
 	}
 	ctx->queue_active = true;
 
-	return 0;
+	return MON_START;
 }
 
 /* Monitor the given mountpoint for health events. */
@@ -376,6 +392,7 @@ usage(void)
 	fprintf(stderr, _("  --foreground  Process events as soon as possible.\n"));
 	fprintf(stderr, _("  --quiet       Do not log health events to stdout.\n"));
 	fprintf(stderr, _("  --repair      Always repair corrupt metadata.\n"));
+	fprintf(stderr, _("  --supported   Check that health monitoring is supported.\n"));
 	fprintf(stderr, _("  -V            Print version.\n"));
 
 	exit(EXIT_FAILURE);
@@ -388,6 +405,7 @@ enum long_opt_nr {
 	LOPT_HELP,
 	LOPT_QUIET,
 	LOPT_REPAIR,
+	LOPT_SUPPORTED,
 
 	LOPT_MAX,
 };
@@ -418,6 +436,7 @@ main(
 		[LOPT_HELP]	   = {"help", no_argument, NULL, 0 },
 		[LOPT_QUIET]	   = {"quiet", no_argument, &ctx.log, 0 },
 		[LOPT_REPAIR]	   = {"repair", no_argument, &ctx.want_repair, 1 },
+		[LOPT_SUPPORTED]   = {"supported", no_argument, &ctx.support_check, 1 },
 
 		[LOPT_MAX]	   = {NULL, 0, NULL, 0 },
 	};
@@ -461,15 +480,23 @@ main(
 		goto out;
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
 out:
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
 

