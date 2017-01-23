Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22049 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbdAWXlQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2017 18:41:16 -0500
Date: Mon, 23 Jan 2017 15:41:07 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 2/5] xfs_db: fix the 'source' command when passed as a -c
 option
Message-ID: <20170123234107.GE31202@birch.djwong.org>
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494392855.5256.2805905613919243845.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148494392855.5256.2805905613919243845.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

The 'source' command is supposed to read commands out of a file and
execute them.  This works great when done from an interactive command
line, but it doesn't work at all when invoked from the command line
because we never actually do anything with the opened file.

So don't load stdin into the input stack when we're only executing
command line options, and use that to decide if source_f is executing
from the command line so that we can actually run the input loop.  We'll
use this for the per-field fuzzing xfstests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: clean up some warts, handle recursive source'ing properly
---
 db/init.c  |    2 +-
 db/input.c |   43 +++++++++++++++++++++++++++++++++----------
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/db/init.c b/db/init.c
index 6ebe6b7..ee0d16e 100644
--- a/db/init.c
+++ b/db/init.c
@@ -237,7 +237,6 @@ main(
 	bool	insane_agcount;
 	int	start_iocur_sp;
 
-	pushfile(stdin);
 	init(argc, argv, &insane_agcount);
 	start_iocur_sp = iocur_sp;
 
@@ -252,6 +251,7 @@ main(
 		goto close_devices;
 	}
 
+	pushfile(stdin);
 	while (!done) {
 		if ((input = fetchline()) == NULL)
 			break;
diff --git a/db/input.c b/db/input.c
index 8f65190..0cb77bb 100644
--- a/db/input.c
+++ b/db/input.c
@@ -156,7 +156,7 @@ fetchline_internal(void)
 
 	rval = NULL;
 	for (rlen = iscont = 0; ; ) {
-		if (inputstacksize == 1) {
+		if (curinput == stdin) {
 			if (iscont)
 				dbprintf("... ");
 			else
@@ -181,18 +181,24 @@ fetchline_internal(void)
 		}
 		if (ferror(curinput) || feof(curinput) ||
 		    (len = strlen(buf)) == 0) {
-			popfile();
-			if (curinput == NULL) {
+			/*
+			 * No more input at this inputstack level; pop
+			 * our fd off and return so that a lower
+			 * level fetchline can handle us.  If this was
+			 * an interactive session, print a newline
+			 * because ^D doesn't emit one.
+			 */
+			if (curinput == stdin)
 				dbprintf("\n");
-				return NULL;
-			}
+
+			popfile();
 			iscont = 0;
 			rlen = 0;
 			if (rval) {
 				xfree(rval);
 				rval = NULL;
 			}
-			continue;
+			return NULL;
 		}
 		if (inputstacksize == 1)
 			logprintf("%s", buf);
@@ -225,7 +231,9 @@ fetchline(void)
 
 	if (inputstacksize == 1) {
 		line = readline(get_prompt());
-		if (line && *line) {
+		if (!line)
+			dbprintf("\n");
+		else if (line && *line) {
 			add_history(line);
 			logprintf("%s", line);
 		}
@@ -314,12 +322,27 @@ source_f(
 	char	**argv)
 {
 	FILE	*f;
+	int	c, done = 0;
+	char	*input;
+	char	**v;
 
 	f = fopen(argv[1], "r");
-	if (f == NULL)
+	if (f == NULL) {
 		dbprintf(_("can't open %s\n"), argv[0]);
-	else
-		pushfile(f);
+		return 0;
+	}
+
+	/* Run the sourced commands now. */
+	pushfile(f);
+	while (!done) {
+		if ((input = fetchline_internal()) == NULL)
+			break;
+		v = breakline(input, &c);
+		if (c)
+			done = command(c, v);
+		doneline(input, v);
+	}
+
 	return 0;
 }
 
