Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23487 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751230AbdGPTyX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Jul 2017 15:54:23 -0400
Date: Sun, 16 Jul 2017 12:54:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] xfs_db: redirect printfs when metadumping to stdout
Message-ID: <20170716195415.GE4224@magnolia>
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
v2: Better comments.
---
 db/metadump.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index e046f60..b58acef 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2874,6 +2874,7 @@ metadump_f(
 	xfs_agnumber_t	agno;
 	int		c;
 	int		start_iocur_sp;
+	bool		stdout_metadump = false;
 	char		*p;
 
 	exitcode = 1;
@@ -2988,7 +2989,15 @@ metadump_f(
 			free(metablock);
 			return 0;
 		}
+		/*
+		 * Redirect stdout to stderr for the duration of the
+		 * metadump operation so that dbprintf and other messages
+		 * are sent to the console instead of polluting the
+		 * metadump stream.
+		 */
 		outf = stdout;
+		stdout = stderr;
+		stdout_metadump = true;
 	} else {
 		outf = fopen(argv[optind], "wb");
 		if (outf == NULL) {
@@ -3020,9 +3029,11 @@ metadump_f(
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
