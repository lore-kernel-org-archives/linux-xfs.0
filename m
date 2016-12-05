Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:35168 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbcLEHFJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 02:05:09 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] xfs_io: support -c <cmd> without <file> args
Date: Mon,  5 Dec 2016 09:04:45 +0200
Message-Id: <1480921485-14888-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

There is an undocumented and possibly unused feature in xfs_io
where all commands are executed per file given in the file args list.

This feature creates ambiguity when trying to execute commands
such as "open" and "file" from command line.

When running xfs_io -c <cmd> without any file args, xfs_io exits
without doing anything. This behavior is undocumented and does not
make much sense either.

Change the behavior in the case where no file args are given in
command line to execute every command exactly once, exactly as if
the commands where executed from an interactive shell.

This enables writing proper xfs_io scripts in command line, which
include "open" and "file" commands.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 io/init.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/io/init.c b/io/init.c
index a9191cf..785eb05 100644
--- a/io/init.c
+++ b/io/init.c
@@ -91,7 +91,7 @@ init_commands(void)
 }
 
 static int
-init_args_command(
+per_file_args_command(
 	int	index)
 {
 	if (index >= filecount)
@@ -101,6 +101,13 @@ init_args_command(
 }
 
 static int
+do_once_args_command(
+	int	index)
+{
+	return !index;
+}
+
+static int
 init_check_command(
 	const cmdinfo_t	*ct)
 {
@@ -214,7 +221,12 @@ init(
 	}
 
 	init_commands();
-	add_args_command(init_args_command);
+	/*
+	 * If file args exist, execute all commands for every file.
+	 * Otherwise, execute every command once exactly as in interactive mode.
+	 */
+	add_args_command(filecount ? per_file_args_command :
+			 do_once_args_command);
 	add_check_command(init_check_command);
 }
 
-- 
2.7.4

