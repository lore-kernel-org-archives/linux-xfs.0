Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756726AbeEJJKh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 05:10:37 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D1E8859A3
        for <linux-xfs@vger.kernel.org>; Thu, 10 May 2018 09:10:37 +0000 (UTC)
Received: from odin.usersys.redhat.com (ovpn-204-180.brq.redhat.com [10.40.204.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A815463AF9
        for <linux-xfs@vger.kernel.org>; Thu, 10 May 2018 09:10:36 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH V2] xfs_io: Document shutdown -f
Date: Thu, 10 May 2018 11:10:30 +0200
Message-Id: <20180510091030.15619-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add help and manpage information for xfs_io shutdown -f

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

V2:
	Add more detailed information about what shutdown command does

 io/shutdown.c     | 16 ++++++++++++++++
 man/man8/xfs_io.8 | 16 +++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/io/shutdown.c b/io/shutdown.c
index 022a0e9a..8ac64d63 100644
--- a/io/shutdown.c
+++ b/io/shutdown.c
@@ -47,6 +47,21 @@ shutdown_f(
 	return 0;
 }
 
+static void
+shutdown_help(void)
+{
+	printf(_(
+"\n"
+" Shuts down the filesystem and prevents any further IO from occurring.\n"
+"\n"
+" With no arguments, shutdown will not attempt to flush completed transactions\n"
+" to disk before marking the log as being shut down. Simulating an IO error\n"
+" behavior.\n"
+"\n"
+" -f -- Flush completed transactions to disk before shut down.\n"
+"\n"));
+}
+
 void
 shutdown_init(void)
 {
@@ -56,6 +71,7 @@ shutdown_init(void)
 	shutdown_cmd.argmax = 1;
 	shutdown_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK;
 	shutdown_cmd.args = _("[-f]");
+	shutdown_cmd.help = shutdown_help;
 	shutdown_cmd.oneline =
 		_("shuts down the filesystem where the current file resides");
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index c3ab532d..d4c28a0a 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1007,8 +1007,22 @@ Note \-\- this can be useful for exercising out of space behavior.
 Only available in expert mode and requires privileges.
 .TP
 .BR shutdown " [ " \-f " ]"
-Force the filesystem to shutdown (with or without flushing the log).
+Force a shutdown of the filesystem, but keep consistency. It does not unmount
+the filesystem, but prevents any other IO to happen on it.
 Only available in expert mode and requires privileges.
+.PP
+.RS
+By default, XFS will not attempt to flush completed transactions to disk before
+marking the log as being shut down.
+.RE
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-f
+Force XFS to flush all completed transactions to disk before marking the log as
+shut down.
+.PD
+.RE
 .TP
 .BR stat " [ " \-v "|" \-r " ]"
 Selected statistics from
-- 
2.14.3

