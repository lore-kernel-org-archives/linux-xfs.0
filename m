Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59912C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjEZByT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjEZByS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:54:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF21189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:54:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A03A64043
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692E7C433EF;
        Fri, 26 May 2023 01:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066056;
        bh=l8VZQf8DOxwT3n2xajETItnp7ZN00fAir7zfdzsbcl0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ppFY6pJdlSGgbGPLsU225RWyYz6PJPVCJaAg+BseVvOIrs1Wg1e2SRI9AILCDyxmD
         YvvZ2+uFMNdA1W3ZiVqT7MfuFPYux6jKUKQujZ6eYV7acYXK6nPzEjH+OFwOHPblf7
         R+L+gdspRHuB0qQtWmeUxY0WeDYOwXTN5qzHyA4Q2NWdCQaJXGY26RFX/+3JJF7ZbN
         SJPFYfBNkj8Z3Ey6pNRdZIMc7Let7WbZkkh1sQ1Hb4ao6h/gnOaCkxF2XgfojGHxq6
         zOx4Gv6cX+n6o+PgHyNrJWEWGWkgm5HD3x3U+YRjESVdBGJEj9RoeK/y9A+r5/gFVb
         ewKRj5MVkOKSA==
Date:   Thu, 25 May 2023 18:54:16 -0700
Subject: [PATCH 2/4] xfs_scrub_all: survive systemd restarts when waiting for
 services
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074202.3745941.14916572151968287634.stgit@frogsfrogsfrogs>
In-Reply-To: <168506074176.3745941.5054006111815853213.stgit@frogsfrogsfrogs>
References: <168506074176.3745941.5054006111815853213.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If xfs_scrub_all detects a running systemd, it will use it to invoke
xfs_scrub subprocesses in a sandboxed and resource-controlled
environment.  Unfortunately, if you happen to restart dbus or systemd
while it's running, you get this:

systemd[1]: Reexecuting.
xfs_scrub_all[9958]: Warning! D-Bus connection terminated.
xfs_scrub_all[9956]: Warning! D-Bus connection terminated.
xfs_scrub_all[9956]: Failed to wait for response: Connection reset by peer
xfs_scrub_all[9958]: Failed to wait for response: Connection reset by peer
xfs_scrub_all[9930]: Scrubbing / done, (err=1)
xfs_scrub_all[9930]: Scrubbing /storage done, (err=1)

The xfs_scrub units themselves are still running, it's just that the
`systemctl start' command that xfs_scrub_all uses to start and wait for
the unit lost its connection to dbus and hence is no longer monitoring
sub-services.

When this happens, we don't have great options -- systemctl doesn't have
a command to wait on an activating (aka running) unit.  Emulate the
functionality we normally get by polling the failed/active statuses.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   78 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 13 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 3fa8491c606..75b3075949c 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -14,6 +14,7 @@ import time
 import sys
 import os
 import argparse
+from io import TextIOWrapper
 
 retcode = 0
 terminate = False
@@ -58,12 +59,18 @@ def find_mounts():
 
 	return fs
 
-def kill_systemd(unit, proc):
-	'''Kill systemd unit.'''
-	proc.terminate()
-	cmd=['systemctl', 'stop', unit]
-	x = subprocess.Popen(cmd)
-	x.wait()
+def backtick(cmd):
+	'''Generator function that yields lines of a program's stdout.'''
+	p = subprocess.Popen(cmd, stdout = subprocess.PIPE)
+	for line in TextIOWrapper(p.stdout, encoding="utf-8"):
+		yield line.strip()
+
+def remove_killfunc(killfuncs, fn):
+	'''Ensure fn is not in killfuncs.'''
+	try:
+		killfuncs.remove(fn)
+	except:
+		pass
 
 def run_killable(cmd, stdout, killfuncs, kill_fn):
 	'''Run a killable program.  Returns program retcode or -1 if we can't start it.'''
@@ -72,10 +79,7 @@ def run_killable(cmd, stdout, killfuncs, kill_fn):
 		real_kill_fn = lambda: kill_fn(proc)
 		killfuncs.add(real_kill_fn)
 		proc.wait()
-		try:
-			killfuncs.remove(real_kill_fn)
-		except:
-			pass
+		remove_killfunc(killfuncs, real_kill_fn)
 		return proc.returncode
 	except:
 		return -1
@@ -96,6 +100,56 @@ def path_to_serviceunit(path):
 	except:
 		return None
 
+def systemctl_stop(unitname):
+	'''Stop a systemd unit.'''
+	cmd = ['systemctl', 'stop', unitname]
+	x = subprocess.Popen(cmd)
+	x.wait()
+
+def systemctl_start(unitname, killfuncs):
+	'''Start a systemd unit and wait for it to complete.'''
+	stop_fn = None
+	cmd = ['systemctl', 'start', unitname]
+	try:
+		proc = subprocess.Popen(cmd, stdout = DEVNULL())
+		stop_fn = lambda: systemctl_stop(unitname)
+		killfuncs.add(stop_fn)
+		proc.wait()
+		ret = proc.returncode
+	except:
+		if stop_fn is not None:
+			remove_killfunc(killfuncs, stop_fn)
+		return -1
+
+	if ret != 1:
+		remove_killfunc(killfuncs, stop_fn)
+		return ret
+
+	# If systemctl-start returns 1, it's possible that the service failed
+	# or that dbus/systemd restarted and the client program lost its
+	# connection -- according to the systemctl man page, 1 means "unit not
+	# failed".
+	#
+	# Either way, we switch to polling the service status to try to wait
+	# for the service to end.  As of systemd 249, the is-active command
+	# returns any of the following states: active, reloading, inactive,
+	# failed, activating, deactivating, or maintenance.  Apparently these
+	# strings are not localized.
+	while True:
+		try:
+			for l in backtick(['systemctl', 'is-active', unitname]):
+				if l == 'failed':
+					remove_killfunc(killfuncs, stop_fn)
+					return 1
+				if l == 'inactive':
+					remove_killfunc(killfuncs, stop_fn)
+					return 0
+		except:
+			remove_killfunc(killfuncs, stop_fn)
+			return -1
+
+		time.sleep(1)
+
 def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 	'''Run a scrub process.'''
 	global retcode, terminate
@@ -110,9 +164,7 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		# Try it the systemd way
 		unitname = path_to_serviceunit(path)
 		if unitname is not None:
-			cmd=['systemctl', 'start', unitname]
-			ret = run_killable(cmd, DEVNULL(), killfuncs, \
-					lambda proc: kill_systemd(unitname, proc))
+			ret = systemctl_start(unitname, killfuncs)
 			if ret == 0 or ret == 1:
 				print("Scrubbing %s done, (err=%d)" % (mnt, ret))
 				sys.stdout.flush()

