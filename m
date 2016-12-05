Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:36274 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbcLENXj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 08:23:39 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] xfs_io: support -c "open foo" command
Date: Mon,  5 Dec 2016 15:03:37 +0200
Message-Id: <1480943017-6175-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

There is an undocumented and possibly unused feature in xfs_io
where all commands are executed per file in the file args list.

This feature creates ambiguity when trying to execute commands
such as "open" and "file" from command line and result in an
endless loop in the command loop code.

Also, when running xfs_io -c <cmd> without any file args, xfs_io
exits without doing anything. This behavior is also undocumented
and makes very little sense.

Change the behavior of xfs_io to execute each command specified
with -c <cmd> exactly once, regardless of the number of files in
the file args list.

This enables writing proper xfs_io scripts in command line, which
include "open" and "file" commands.

This change does not modify the behavior of xfs_io in the most
commonly used case of single file argument in command line and
no "open" and "file" commands in command line.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 io/init.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

v2:
- Fix the case of multiple file args

v1:
- Fix the case of zero file args

diff --git a/io/init.c b/io/init.c
index a9191cf..82b6700 100644
--- a/io/init.c
+++ b/io/init.c
@@ -90,14 +90,15 @@ init_commands(void)
 	cowextsize_init();
 }
 
+/*
+ * Return true for first call and false for the next call,
+ * to execute each command once.
+ */
 static int
 init_args_command(
 	int	index)
 {
-	if (index >= filecount)
-		return 0;
-	file = &filetable[index++];
-	return index;
+	return !index;
 }
 
 static int
-- 
2.7.4

