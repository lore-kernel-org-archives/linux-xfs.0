Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28645 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbdGNXak (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2017 19:30:40 -0400
Date: Fri, 14 Jul 2017 16:30:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_db: redirect printfs when metadumping to stdout
Message-ID: <20170714233032.GC4224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, David Shaw <dshaw@jabberwocky.com>

If we're metadumping to stdout, we don't want xfs_db's various dbprintf
statements dumping to stdout because that'll corrupt the metadump.
Therefore, let outf point to the existing stdout and redirect stdout to
stderr for the duration of the dump operation.

Reported-by: David Shaw <dshaw@jabberwocky.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/metadump.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index e046f60..e6e153d 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2874,6 +2874,7 @@ metadump_f(
 	xfs_agnumber_t	agno;
 	int		c;
 	int		start_iocur_sp;
+	bool		stdout_metadump = false;
 	char		*p;
 
 	exitcode = 1;
@@ -2989,6 +2990,8 @@ metadump_f(
 			return 0;
 		}
 		outf = stdout;
+		stdout = stderr;
+		stdout_metadump = true;
 	} else {
 		outf = fopen(argv[optind], "wb");
 		if (outf == NULL) {
@@ -3020,9 +3023,11 @@ metadump_f(
 		exitcode = write_index() < 0;
 
 	if (progress_since_warning)
-		fputc('\n', (outf == stdout) ? stderr : stdout);
+		fputc('\n', stdout_metadump ? stderr : stdout);
 
-	if (outf != stdout)
+	if (stdout_metadump)
+		stdout = outf;
+	else
 		fclose(outf);
 
 	/* cleanup iocur stack */
