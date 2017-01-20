Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29243 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753217AbdATUZe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 15:25:34 -0500
Subject: [PATCH 2/5] xfs_db: fix the 'source' command when passed as a -c
 option
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 20 Jan 2017 12:25:28 -0800
Message-ID: <148494392855.5256.2805905613919243845.stgit@birch.djwong.org>
In-Reply-To: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
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
index e60ac66..46af024 100644
--- a/db/init.c
+++ b/db/init.c
@@ -254,7 +254,6 @@ main(
 	char	**v;
 	int	start_iocur_sp;
 
-	pushfile(stdin);
 	init(argc, argv);
 	start_iocur_sp = iocur_sp;
 
@@ -269,6 +268,7 @@ main(
 		goto close_devices;
 	}
 
+	pushfile(stdin);
 	while (!done) {
 		if ((input = fetchline()) == NULL)
 			break;
diff --git a/db/input.c b/db/input.c
index 8f65190..7b12c97 100644
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
@@ -156,7 +162,9 @@ fetchline_internal(void)
 
 	rval = NULL;
 	for (rlen = iscont = 0; ; ) {
-		if (inputstacksize == 1) {
+		if (curinput == NULL)
+			return NULL;
+		if (interactive_input()) {
 			if (iscont)
 				dbprintf("... ");
 			else
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
 

