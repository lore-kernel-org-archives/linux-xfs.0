Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22826 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbdGYQ1v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2017 12:27:51 -0400
Date: Tue, 25 Jul 2017 09:27:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_db: fix metadump redirection (again)
Message-ID: <20170725162740.GP4352@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, anarchy@gentoo.org

In patch 4944defad4 ("xfs_db: redirect printfs when metadumping to
stdout"), we solved the problem of xfs_db printfs ending up in the
metadump stream by reassigning stdout for the duration of a stdout
metadump.  Unfortunately, musl doesn't allow stdout to be reassigned (in
their view "extern FILE *stdout" means "extern FILE * const stdout"), so
we abandon the old approach in favor of playing games with dup() to
switch the raw file descriptors.

While we're at it, fix a regression where an unconverted outf test
allows progress info to end up in the metadump stream.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/metadump.c |   47 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index b58acef..8cdcb37 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -78,6 +78,7 @@ static int		obfuscate = 1;
 static int		zero_stale_data = 1;
 static int		show_warnings = 0;
 static int		progress_since_warning = 0;
+static bool		stdout_metadump;
 
 void
 metadump_init(void)
@@ -137,7 +138,7 @@ print_progress(const char *fmt, ...)
 	va_end(ap);
 	buf[sizeof(buf)-1] = '\0';
 
-	f = (outf == stdout) ? stderr : stdout;
+	f = stdout_metadump ? stderr : stdout;
 	fprintf(f, "\r%-59s", buf);
 	fflush(f);
 	progress_since_warning = 1;
@@ -2874,7 +2875,8 @@ metadump_f(
 	xfs_agnumber_t	agno;
 	int		c;
 	int		start_iocur_sp;
-	bool		stdout_metadump = false;
+	int		outfd = -1;
+	int		ret;
 	char		*p;
 
 	exitcode = 1;
@@ -2994,16 +2996,35 @@ metadump_f(
 		 * metadump operation so that dbprintf and other messages
 		 * are sent to the console instead of polluting the
 		 * metadump stream.
+		 *
+		 * We get to do this the hard way because musl doesn't
+		 * allow reassignment of stdout.
 		 */
-		outf = stdout;
-		stdout = stderr;
+		fflush(stdout);
+		outfd = dup(STDOUT_FILENO);
+		if (outfd < 0) {
+			perror("opening dump stream");
+			goto out;
+		}
+		ret = dup2(STDERR_FILENO, STDOUT_FILENO);
+		if (ret < 0) {
+			perror("redirecting stdout");
+			close(outfd);
+			goto out;
+		}
+		outf = fdopen(outfd, "a");
+		if (outf == NULL) {
+			fprintf(stderr, "cannot create dump stream\n");
+			dup2(outfd, 1);
+			close(outfd);
+			goto out;
+		}
 		stdout_metadump = true;
 	} else {
 		outf = fopen(argv[optind], "wb");
 		if (outf == NULL) {
 			print_warning("cannot create dump file");
-			free(metablock);
-			return 0;
+			goto out;
 		}
 	}
 
@@ -3031,15 +3052,19 @@ metadump_f(
 	if (progress_since_warning)
 		fputc('\n', stdout_metadump ? stderr : stdout);
 
-	if (stdout_metadump)
-		stdout = outf;
-	else
-		fclose(outf);
+	if (stdout_metadump) {
+		fflush(outf);
+		fflush(stdout);
+		ret = dup2(outfd, STDOUT_FILENO);
+		if (ret < 0)
+			perror("un-redirecting stdout");
+	}
+	fclose(outf);
 
 	/* cleanup iocur stack */
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
-
+out:
 	free(metablock);
 
 	return 0;
