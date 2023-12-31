Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFC6C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TiqXbyAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4720C433C7;
	Sun, 31 Dec 2023 22:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063312;
	bh=+o2JqwE17+YmTJMyCMxeMM6k0FZoFhJ4AkKSJCcmE80=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TiqXbyABSMg3+49GjhZtvpUx9mVLwrgUcaIgwj9P4UEXOfvaxWCUDpRKkDub5h96K
	 cUZ8F3yCM+n0jlbRoFIAsuJzjUvKXf2OQfkC9e4eoj0bRsP8FGx30H20ONcPvmrfFr
	 qxXO5tzBkU2jF7cViQlyNZNHIpa97Z/NmMRcaQqGqrAiy2G6yMDGAkNMaY7bn29ZIu
	 XGQFbnDgLVa2yBlGlxLMnjbsqThs3QYc4Dh1xrNd7VTWlg/uSGfHlSUCRzQ3lRGpeQ
	 wAHpeqUFcA39or9Nm9lAXth+G5407rMs4+W4PxxjJbSnPIiMMmRYlefWeG9YcznvNY
	 Via2h+0c5jlCQ==
Date: Sun, 31 Dec 2023 14:55:12 -0800
Subject: [PATCH 2/4] xfs_scrub_all: survive systemd restarts when waiting for
 services
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405002282.1801148.13065805971923682262.stgit@frogsfrogsfrogs>
In-Reply-To: <170405002254.1801148.6324602186356936873.stgit@frogsfrogsfrogs>
References: <170405002254.1801148.6324602186356936873.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_all.in |   78 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 13 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 671d588177a..ab9b491fb4e 100644
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

