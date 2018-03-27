Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751220AbeC0WI6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Mar 2018 18:08:58 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B272E13A9A
        for <linux-xfs@vger.kernel.org>; Tue, 27 Mar 2018 22:08:58 +0000 (UTC)
Subject: [PATCH 1/3] xfs_scrub: synchronize error levels & logging
References: <f7ab3da2-618c-dc1c-6d95-3890cdac2b43@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <3b8c1fd3-46bb-39ea-fca9-63d308cbe6b4@redhat.com>
Date: Tue, 27 Mar 2018 17:08:54 -0500
MIME-Version: 1.0
In-Reply-To: <f7ab3da2-618c-dc1c-6d95-3890cdac2b43@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Having only a subset of the five error_levels present in
the log_level[] array is asking for trouble when someone
tries to __str_log(S_PREEN ...) and overruns the array.

Tie it all together in a single structure that's
initialized together to make the mapping more obvious and
idiot-proof.

Fixes-coverity-id: 1433618
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/scrub/common.c b/scrub/common.c
index 5a37a98..02c6c9d 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -56,18 +56,15 @@ xfs_scrub_excessive_errors(
 	return ret;
 }
 
-static const char *err_str[] = {
-	[S_ERROR]	= "Error",
-	[S_WARN]	= "Warning",
-	[S_REPAIR]	= "Repaired",
-	[S_INFO]	= "Info",
-	[S_PREEN]	= "Optimized",
-};
-
-static int log_level[] = {
-	[S_ERROR]	= LOG_ERR,
-	[S_WARN]	= LOG_WARNING,
-	[S_INFO]	= LOG_INFO,
+static struct {
+	const char *string;
+	int loglevel;
+} err_levels[] = {
+	[S_ERROR]  = { .string = "Error",	.loglevel = LOG_ERR },
+	[S_WARN]   = { .string = "Warning",	.loglevel = LOG_WARNING },
+	[S_REPAIR] = { .string = "Repaired",	.loglevel = LOG_WARNING },
+	[S_INFO]   = { .string = "Info",	.loglevel = LOG_INFO },
+	[S_PREEN]  = { .string = "Optimized",	.loglevel = LOG_INFO }
 };
 
 /* If stream is a tty, clear to end of line to clean up progress bar. */
@@ -106,8 +103,8 @@ __str_out(
 	if (level == S_PREEN && !debug && !verbose)
 		goto out_record;
 
-	fprintf(stream, "%s%s: %s: ", stream_start(stream), _(err_str[level]),
-			descr);
+	fprintf(stream, "%s%s: %s: ", stream_start(stream),
+			err_levels[level].string, descr);
 	if (error) {
 		fprintf(stream, _("%s."), strerror_r(error, buf, DESCR_BUFSZ));
 	} else {
@@ -152,10 +149,6 @@ __str_log(
 	char			buf[LOG_BUFSZ];
 	int			sz;
 
-	/* We only want to hear about optimizing when in debug/verbose mode. */
-	if (level == S_PREEN && !debug && !verbose)
-		return;
-
 	/*
 	 * Skip logging if we're being run as a service (presumably the
 	 * service will log stdout/stderr); if we're being run in a non
@@ -168,11 +161,11 @@ __str_log(
 	snprintf(logname, LOGNAME_BUFSZ, "%s@%s", progname, ctx->mntpoint);
 	openlog(logname, LOG_PID, LOG_DAEMON);
 
-	sz = snprintf(buf, LOG_BUFSZ, "%s: ", _(err_str[level]));
+	sz = snprintf(buf, LOG_BUFSZ, "%s: ", _(err_levels[level].string));
 	va_start(args, format);
 	vsnprintf(buf + sz, LOG_BUFSZ - sz, format, args);
 	va_end(args);
-	syslog(log_level[level], "%s", buf);
+	syslog(err_levels[level].loglevel, "%s", buf);
 
 	closelog();
 }
