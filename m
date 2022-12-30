Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FE5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbiLaAf4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaAfz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:35:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AD712A9B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:35:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A1B5CE1A94
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48597C433EF;
        Sat, 31 Dec 2022 00:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446950;
        bh=PoauaQzO0cPN8emQdPOl+YoqXrb5acYl7m8JTFZJbac=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b3B+582uYI8Nl2hDoy603JJSI8kjGnUq682cZ0JM9tFXvdm4I7xLuxOC43UNv65HE
         agXeKBWukm1PveeoEDl2AAKf2sKR2EK28UB1ccOa09YALuFxxFFmSNdBJ/IlaqG2ZU
         bu26iDx1vm5aIbecDaGC6wM9BT0/Co4cKYb8q0e0worIEjknPxOEwssWpo7UR6CpiF
         qtqv0DsuEMl3smbySccP37WxFxY/BLrJH12b/h42OSdoQTRFvN8lvqWVIVAulxA6fD
         G7/CitH4OY9n2rOykFX4Z1yV1viia188tyXM3fI3NcjzfvoY0CbG0HNZQOr44c2lMa
         2/UBPnmrZhgRQ==
Subject: [PATCH 8/8] xfs_scrub_all: survive systemd restarts when waiting for
 services
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:32 -0800
Message-ID: <167243871205.717702.16197845816644006295.stgit@magnolia>
In-Reply-To: <167243871097.717702.15336500890922415647.stgit@magnolia>
References: <167243871097.717702.15336500890922415647.stgit@magnolia>
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
index 2bdbccffd9c..3e0c48acb39 100644
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
 
-def kill_systemd(unitname, proc):
-	'''Kill systemd unit.'''
-	proc.terminate()
-	cmd = ['systemctl', 'stop', unitname]
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
@@ -107,6 +111,56 @@ def systemd_escape(path):
 	except:
 		return path
 
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
@@ -120,9 +174,7 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 
 		# Try it the systemd way
 		unitname = 'xfs_scrub@%s' % systemd_escape(mnt)
-		cmd = ['systemctl', 'start', unitname]
-		ret = run_killable(cmd, DEVNULL(), killfuncs, \
-				lambda proc: kill_systemd(unitname, proc))
+		ret = systemctl_start(unitname, killfuncs)
 		if ret == 0 or ret == 1:
 			print("Scrubbing %s done, (err=%d)" % (mnt, ret))
 			sys.stdout.flush()

