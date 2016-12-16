Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:43617 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753925AbcLPEpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 23:45:31 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1cHkKb-00023m-RU
        for linux-xfs@vger.kernel.org; Fri, 16 Dec 2016 15:41:17 +1100
Received: from dave by discord.disaster.area with local (Exim 4.88)
        (envelope-from <david@fromorbit.com>)
        id 1cHkKb-0005Zs-QS
        for linux-xfs@vger.kernel.org; Fri, 16 Dec 2016 15:41:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] libxcmd: merge command() and iterate_command()
Date: Fri, 16 Dec 2016 15:41:12 +1100
Message-Id: <20161216044115.21287-4-david@fromorbit.com>
In-Reply-To: <20161216044115.21287-1-david@fromorbit.com>
References: <20161216044115.21287-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Simplify the command loop further by merging the command loop
iteration checks with the command execution function. This removes
all visibility of command iteration from the main command execution
loop, and enables us to factor and clean up the command loop
processing neatly.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 libxcmd/command.c | 110 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 66 insertions(+), 44 deletions(-)

diff --git a/libxcmd/command.c b/libxcmd/command.c
index 789aeb5c5e5a..2c94a3199115 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -125,22 +125,30 @@ add_user_command(char *optarg)
 }
 
 /*
- * To detect one-shot commands, they will return a negative index. If we
- * get a negative index on entry, we've already run the one-shot command,
- * so we abort straight away.
+ * Run a command, iterating as necessary. Return 0 for success, non-zero
+ * if an error occurred. Errors terminate loop iteration immediately.
  */
 static int
 iterate_command(
 	const cmdinfo_t	*ct,
-	int		index)
+	int		argc,
+	char		**argv)
 {
-	if (index < 0)
+	int		error = 0;
+	int		j;
+
+	/* if there's nothing to iterate, we're done! */
+	if (!iter_func)
 		return 0;
-	if (ct->flags & CMD_FLAG_ONESHOT)
-		return -1;
-	if (iter_func)
-		return iter_func(index);
-	return 0;
+
+	for (j = iter_func(0); j; j = iter_func(j)) {
+		error = command(ct, argc, argv);
+		if (error)
+			break;
+
+	}
+
+	return error;
 }
 
 void
@@ -150,14 +158,55 @@ add_command_iterator(
 	iter_func = func;
 }
 
-void
-command_loop(void)
+static int
+process_input(
+	char	*input,
+	bool	iterate)
 {
-	int		c, i, j = 0, done = 0;
-	char		*input;
 	char		**v;
 	const cmdinfo_t	*ct;
+	int		c = 0;
+	int		error = 0;
+
+	v = breakline(input, &c);
+	if (!c)
+		goto out;
+
+	ct = find_command(v[0]);
+	if (!ct) {
+		fprintf(stderr, _("command \"%s\" not found\n"), v[0]);
+		goto out;
+	}
+
+	/* oneshot commands don't iterate */
+	if (!iterate || (ct->flags & CMD_FLAG_ONESHOT))
+		error = command(ct, c, v);
+	else
+		error = iterate_command(ct, c, v);
+out:
+	doneline(input, v);
+	return error;
+}
+
+void
+command_loop(void)
+{
+	char	*input;
+	int	done = 0;
+	int	i;
+
+	if (!cmdline) {
+		/* interactive mode */
+		while (!done) {
+			input = fetchline();
+			if (!input)
+				break;
+			done = process_input(input, false);
+		}
+		return;
+	}
 
+	/* command line mode */
 	for (i = 0; !done && i < ncmdline; i++) {
 		input = strdup(cmdline[i]);
 		if (!input) {
@@ -166,37 +215,10 @@ command_loop(void)
 				cmdline[i], strerror(errno));
 			exit(1);
 		}
-		v = breakline(input, &c);
-		if (c) {
-			ct = find_command(v[0]);
-			if (ct) {
-				j = 0;
-				while (!done && (j = iterate_command(ct, j)))
-					done = command(ct, c, v);
-			} else
-				fprintf(stderr, _("command \"%s\" not found\n"),
-					v[0]);
-		}
-		doneline(input, v);
-	}
-	if (cmdline) {
-		free(cmdline);
-		return;
-	}
-	while (!done) {
-		if ((input = fetchline()) == NULL)
-			break;
-		v = breakline(input, &c);
-		if (c) {
-			ct = find_command(v[0]);
-			if (ct)
-				done = command(ct, c, v);
-			else
-				fprintf(stderr, _("command \"%s\" not found\n"),
-					v[0]);
-		}
-		doneline(input, v);
+		done = process_input(input, true);
 	}
+	free(cmdline);
+	return;
 }
 
 void
-- 
2.10.2

