Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44472 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbeGZBVX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 21:21:23 -0400
Subject: [PATCH V3] xfs_io: Document shutdown -f
References: <20180510091030.15619-1-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b83b3da7-2549-0778-580e-2decbefbe790@sandeen.net>
Date: Wed, 25 Jul 2018 17:07:13 -0700
MIME-Version: 1.0
In-Reply-To: <20180510091030.15619-1-cmaiolino@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

From: Carlos Maiolino <cmaiolino@redhat.com>

Add help and manpage information for xfs_io shutdown -f
[sandeen: more editing for clarity]

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Add more detailed information about what shutdown command does
V3: more editing

diff --git a/io/shutdown.c b/io/shutdown.c
index 7ceed7a..052d3de 100644
--- a/io/shutdown.c
+++ b/io/shutdown.c
@@ -35,6 +35,22 @@ shutdown_f(
 	return 0;
 }
 
+static void
+shutdown_help(void)
+{
+	printf(_(
+"\n"
+" Shuts down the filesystem and prevents any further IO from occurring.\n"
+"\n"
+" By default, shutdown will not flush completed transactions to disk\n"
+" before shutting the filesystem down, simulating a disk failure or crash.\n"
+" With -f, the log will be flushed to disk, matching XFS behavior when\n"
+" metadata corruption is encountered.\n"
+"\n"
+" -f -- Flush completed transactions to disk before shut down.\n"
+"\n"));
+}
+
 void
 shutdown_init(void)
 {
@@ -44,6 +60,7 @@ shutdown_init(void)
 	shutdown_cmd.argmax = 1;
 	shutdown_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK;
 	shutdown_cmd.args = _("[-f]");
+	shutdown_cmd.help = shutdown_help;
 	shutdown_cmd.oneline =
 		_("shuts down the filesystem where the current file resides");
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index dd91589..54a077c 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1017,8 +1017,23 @@ Note \-\- this can be useful for exercising out of space behavior.
 Only available in expert mode and requires privileges.
 .TP
 .BR shutdown " [ " \-f " ]"
-Force the filesystem to shutdown (with or without flushing the log).
+Force the filesystem to shut down, preventing any further IO.
+XFS and other filesystems implement this functionality, although implementation
+details may differ slightly.
 Only available in expert mode and requires privileges.
+.PP
+.RS
+By default, XFS will not attempt to flush completed transactions to disk before
+shutting down the filesystem.  This simulates a disk failure or crash.
+.RE
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-f
+Force XFS to flush all completed transactions to disk before shutting down,
+matching XFS behavior when critical corruption is encountered.
+.PD
+.RE
 .TP
 .BR stat " [ " \-v "|" \-r " ]"
 Selected statistics from

