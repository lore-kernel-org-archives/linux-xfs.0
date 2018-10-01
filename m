Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43424 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725740AbeJAXoH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 19:44:07 -0400
Subject: [PATCH 8/8] xfs_scrub_all: fix systemd escaping again
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Oct 2018 10:05:11 -0700
Message-ID: <153841351155.27952.8070566787187802754.stgit@magnolia>
In-Reply-To: <153841345236.27952.5050172703525712660.stgit@magnolia>
References: <153841345236.27952.5050172703525712660.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Matthias Bodenbinder <matthias@bodenbinder.de>

From: Darrick J. Wong <darrick.wong@oracle.com>

Apparently newer versions of systemd than the one on this author's
laptop <cough> now complain about lack of (path) escaping in unit instance
variable contents:

 # xfs_scrub_all
 Scrubbing /home...
  Invalid unit name "xfs_scrub@/home" was escaped as "xfs_scrub@-home"
 (maybe you should use systemd-escape?)
 Starting Online XFS Metadata Check for /home...

So change the systemd_escape() function to escape paths unconditionally
to make the warning go away.

Reported-by: Matthias Bodenbinder <matthias@bodenbinder.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/xfs_scrub_all.in |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index f7d9e6c7..c4e9899d 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -82,11 +82,16 @@ def run_killable(cmd, stdout, killfuncs, kill_fn):
 # actually /can/ escape the dashes correctly if it is told that this is a path
 # (and not a unit name), but it didn't do this prior to January 2017, so fix
 # this for them.
+#
+# systemd path escaping also drops the initial slash so we add that back in so
+# that log messages from the service units preserve the full path and users can
+# look up log messages using full paths.  However, for "/" the escaping rules
+# do /not/ drop the initial slash, so we have to special-case that here.
 def systemd_escape(path):
 	'''Escape a path to avoid mangled systemd mangling.'''
 
-	if '-' not in path:
-		return path
+	if path == '/':
+		return '-'
 	cmd = ['systemd-escape', '--path', path]
 	try:
 		proc = subprocess.Popen(cmd, stdout = subprocess.PIPE)
