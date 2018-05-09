Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40124 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934775AbeEIOnZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 May 2018 10:43:25 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3E86140200A3
        for <linux-xfs@vger.kernel.org>; Wed,  9 May 2018 14:43:25 +0000 (UTC)
Received: from odin.usersys.redhat.com (ovpn-204-180.brq.redhat.com [10.40.204.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B878F10B2B45
        for <linux-xfs@vger.kernel.org>; Wed,  9 May 2018 14:43:24 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] io: Document shutdown -f
Date: Wed,  9 May 2018 16:43:20 +0200
Message-Id: <20180509144320.15746-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add help and manpage information for xfs_io shutdown -f

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 io/shutdown.c     | 10 ++++++++++
 man/man8/xfs_io.8 |  9 ++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/io/shutdown.c b/io/shutdown.c
index 022a0e9a..d5e84182 100644
--- a/io/shutdown.c
+++ b/io/shutdown.c
@@ -47,6 +47,15 @@ shutdown_f(
 	return 0;
 }
 
+static void
+shutdown_help(void)
+{
+	printf(_(
+"\n"
+" -f -- force log to disk before shut down\n"
+"\n"));
+}
+
 void
 shutdown_init(void)
 {
@@ -56,6 +65,7 @@ shutdown_init(void)
 	shutdown_cmd.argmax = 1;
 	shutdown_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK;
 	shutdown_cmd.args = _("[-f]");
+	shutdown_cmd.help = shutdown_help;
 	shutdown_cmd.oneline =
 		_("shuts down the filesystem where the current file resides");
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index c3ab532d..d7b2d004 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1007,8 +1007,15 @@ Note \-\- this can be useful for exercising out of space behavior.
 Only available in expert mode and requires privileges.
 .TP
 .BR shutdown " [ " \-f " ]"
-Force the filesystem to shutdown (with or without flushing the log).
+Force the filesystem to shutdown.
 Only available in expert mode and requires privileges.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-f
+Force a log flush before shutting the filesystem down.
+.PD
+.RE
 .TP
 .BR stat " [ " \-v "|" \-r " ]"
 Selected statistics from
-- 
2.14.3

