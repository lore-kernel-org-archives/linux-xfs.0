Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55380 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbeCUDlF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 23:41:05 -0400
Subject: [PATCH 13/14] xfs_scrub_all: escape paths being passed to systemd
 service instances
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Mar 2018 20:41:00 -0700
Message-ID: <152160366039.8288.1390627066543987632.stgit@magnolia>
In-Reply-To: <152160358015.8288.2700156777231657519.stgit@magnolia>
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

systemd doesn't like unit instance names with slashes in them, so it
replaces them with dashes when it invokes the service.  However, it's
not smart enough to convert the dashes to something else, so when it
unescapes the instance name to feed to xfs_scrub, it turns all dashes
into slashes.  "/moo-cow" becomes "-moo-cow" becomes "/moo/cow", which
is wrong.  systemd actually /can/ escape the dashes correctly if it is
told that this is a path (and not a unit name), but it didn't do this
prior to January 2017, so fix this for them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/xfs_scrub_all.in |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index aed66a1..83c4e21 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -87,6 +87,28 @@ def run_killable(cmd, stdout, killfuncs, kill_fn):
 	except:
 		return -1
 
+# systemd doesn't like unit instance names with slashes in them, so it
+# replaces them with dashes when it invokes the service.  However, it's not
+# smart enough to convert the dashes to something else, so when it unescapes
+# the instance name to feed to xfs_scrub, it turns all dashes into slashes.
+# "/moo-cow" becomes "-moo-cow" becomes "/moo/cow", which is wrong.  systemd
+# actually /can/ escape the dashes correctly if it is told that this is a path
+# (and not a unit name), but it didn't do this prior to January 2017, so fix
+# this for them.
+def systemd_escape(path):
+	'''Escape a path to avoid mangled systemd mangling.'''
+
+	if '-' not in path:
+		return path
+	cmd = ['systemd-escape', '--path', path]
+	try:
+		proc = subprocess.Popen(cmd, stdout = subprocess.PIPE)
+		proc.wait()
+		for line in proc.stdout:
+			return '-' + line.decode(sys.stdout.encoding).strip()
+	except:
+		return path
+
 def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 	'''Run a scrub process.'''
 	global retcode, terminate
@@ -99,7 +121,7 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 			return
 
 		# Try it the systemd way
-		cmd=['systemctl', 'start', 'xfs_scrub@%s' % mnt]
+		cmd=['systemctl', 'start', 'xfs_scrub@%s' % systemd_escape(mnt)]
 		ret = run_killable(cmd, DEVNULL(), killfuncs, \
 				lambda proc: kill_systemd('xfs_scrub@%s' % mnt, proc))
 		if ret == 0 or ret == 1:

