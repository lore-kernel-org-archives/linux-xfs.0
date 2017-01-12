Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51678 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbdALT16 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jan 2017 14:27:58 -0500
Date: Thu, 12 Jan 2017 11:27:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/5] xfs_db: fix the 'source' command when passed as a -c
 option
Message-ID: <20170112192753.GX14038@birch.djwong.org>
References: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148419038856.32674.6479634718673149751.stgit@birch.djwong.org>
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
 db/init.c  |    2 +-
 db/input.c |   29 +++++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/db/init.c b/db/init.c
index db133d7..729ce66 100644
--- a/db/init.c
+++ b/db/init.c
@@ -269,7 +269,6 @@ main(
 	char	**v;
 	int	start_iocur_sp;
 
-	pushfile(stdin);
 	init(argc, argv);
 	start_iocur_sp = iocur_sp;
 
@@ -284,6 +283,7 @@ main(
 		goto close_devices;
 	}
 
+	pushfile(stdin);
 	while (!done) {
 		if ((input = fetchline()) == NULL)
 			break;
diff --git a/db/input.c b/db/input.c
index 8f65190..3255f27 100644
--- a/db/input.c
+++ b/db/input.c
@@ -145,6 +145,12 @@ get_prompt(void)
 	return prompt;
 }
 
+static bool
+interactive_input(void)
+{
+	return inputstacksize == 1 && inputstack[0] == stdin;
+}
+
 static char *
 fetchline_internal(void)
 {
@@ -156,13 +162,15 @@ fetchline_internal(void)
 
 	rval = NULL;
 	for (rlen = iscont = 0; ; ) {
-		if (inputstacksize == 1) {
+		if (interactive_input()) {
 			if (iscont)
 				dbprintf("... ");
 			else
 				dbprintf(get_prompt(), progname);
 			fflush(stdin);
 		}
+		if (curinput == NULL)
+			return NULL;
 		if (seenint() ||
 		    (!fgets(buf, sizeof(buf), curinput) &&
 		     ferror(curinput) && seenint())) {
@@ -183,7 +191,8 @@ fetchline_internal(void)
 		    (len = strlen(buf)) == 0) {
 			popfile();
 			if (curinput == NULL) {
-				dbprintf("\n");
+				if (interactive_input())
+					dbprintf("\n");
 				return NULL;
 			}
 			iscont = 0;
@@ -314,12 +323,28 @@ source_f(
 	char	**argv)
 {
 	FILE	*f;
+	int	c, done = 0;
+	char	*input;
+	char	**v;
 
 	f = fopen(argv[1], "r");
 	if (f == NULL)
 		dbprintf(_("can't open %s\n"), argv[0]);
 	else
 		pushfile(f);
+
+	/* If this isn't an interactive shell, run the commands now. */
+	if (inputstacksize == 0 || inputstack[0] == stdin)
+		return 0;
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
 
