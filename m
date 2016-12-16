Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63564 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753925AbcLPEpc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 23:45:32 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1cHkKb-00023n-SF
        for linux-xfs@vger.kernel.org; Fri, 16 Dec 2016 15:41:17 +1100
Received: from dave by discord.disaster.area with local (Exim 4.88)
        (envelope-from <david@fromorbit.com>)
        id 1cHkKb-0005Zv-RC
        for linux-xfs@vger.kernel.org; Fri, 16 Dec 2016 15:41:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] libxcmd: don't check generic library commands
Date: Fri, 16 Dec 2016 15:41:13 +1100
Message-Id: <20161216044115.21287-5-david@fromorbit.com>
In-Reply-To: <20161216044115.21287-1-david@fromorbit.com>
References: <20161216044115.21287-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The generic "help" and "quit" commands have different methods of
skipping user provided command check functions that may prevent them
from running. xfs_quota use CMD_ALL_FSTYPES and xfs_io uses
CMD_FLAG_ONESHOT.  Add a new CMD_FLAG_LIBRARY to indicate commands
that should not be checked against application specific check
functions so they are always present and can be run regardless of
the context in which they are run.

This gets rid of the CMD_ALL_FSTYPES flag, and enables us to remove
the ONESHOT check in xfs_io so we use only app specific flags for
determining if app commands should run or not.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 include/command.h | 1 +
 io/init.c         | 3 ---
 libxcmd/command.c | 4 ++++
 libxcmd/help.c    | 2 +-
 libxcmd/quit.c    | 2 +-
 quota/init.c      | 4 ----
 6 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/command.h b/include/command.h
index 637ee06e6e9a..348002cbe3ed 100644
--- a/include/command.h
+++ b/include/command.h
@@ -27,6 +27,7 @@
  */
 #define CMD_FLAG_ONESHOT	(1<<31)
 #define CMD_FLAG_FOREIGN_OK	(1<<30)	/* command not restricted to XFS */
+#define CMD_FLAG_LIBRARY	(1<<29)	/* command provided by libxcmd */
 
 typedef int (*cfunc_t)(int argc, char **argv);
 typedef void (*helpfunc_t)(void);
diff --git a/io/init.c b/io/init.c
index 34009b024833..5ce627ef22c9 100644
--- a/io/init.c
+++ b/io/init.c
@@ -109,9 +109,6 @@ static int
 init_check_command(
 	const cmdinfo_t	*ct)
 {
-	if (ct->flags & CMD_FLAG_ONESHOT)
-		return 1;
-
 	if (!file && !(ct->flags & CMD_NOFILE_OK)) {
 		fprintf(stderr, _("no files are open, try 'help open'\n"));
 		return 0;
diff --git a/libxcmd/command.c b/libxcmd/command.c
index 2c94a3199115..decc442a9d03 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -48,6 +48,10 @@ static int
 check_command(
 	const cmdinfo_t	*ci)
 {
+	/* always run internal library supplied commands */
+	if (ci->flags & CMD_FLAG_LIBRARY)
+		return 1;
+
 	if (check_func)
 		return check_func(ci);
 	return 1;
diff --git a/libxcmd/help.c b/libxcmd/help.c
index bc31d6df1d8a..f888377cabf7 100644
--- a/libxcmd/help.c
+++ b/libxcmd/help.c
@@ -89,7 +89,7 @@ help_init(void)
 	help_cmd.cfunc = help_f;
 	help_cmd.argmin = 0;
 	help_cmd.argmax = 1;
-	help_cmd.flags = CMD_FLAG_ONESHOT | CMD_ALL_FSTYPES;
+	help_cmd.flags = CMD_FLAG_ONESHOT | CMD_FLAG_LIBRARY;
 	help_cmd.args = _("[command]");
 	help_cmd.oneline = _("help for one or all commands");
 
diff --git a/libxcmd/quit.c b/libxcmd/quit.c
index 19431015aee2..1e1ba986f2ba 100644
--- a/libxcmd/quit.c
+++ b/libxcmd/quit.c
@@ -39,7 +39,7 @@ quit_init(void)
 	quit_cmd.cfunc = quit_f;
 	quit_cmd.argmin = -1;
 	quit_cmd.argmax = -1;
-	quit_cmd.flags = CMD_FLAG_ONESHOT | CMD_ALL_FSTYPES;
+	quit_cmd.flags = CMD_FLAG_ONESHOT | CMD_FLAG_LIBRARY;
 	quit_cmd.oneline = _("exit the program");
 
 	add_command(&quit_cmd);
diff --git a/quota/init.c b/quota/init.c
index 193f6421fd59..d45dc4c5461e 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -117,10 +117,6 @@ init_check_command(
 	if (!fs_path)
 		return 1;
 
-	/* Always run commands that are valid for all fs types. */
-	if (ct->flags & CMD_ALL_FSTYPES)
-		return 1;
-
 	/* If it's an XFS filesystem, always run the command. */
 	if (!(fs_path->fs_flags & FS_FOREIGN))
 		return 1;
-- 
2.10.2

