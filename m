Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5346C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GcxLieqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ACEC433C7;
	Sun, 31 Dec 2023 22:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063594;
	bh=vcFCGSqG+2f8TFc7yDSntLQEDJ6LhrJINJfPlfywuVg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GcxLieqjFzeV8fEPkf71ttQ6KDA202+mcloQxfldZQu+meVuQSmV/NEtfaCGa+Gmw
	 OTCDax61mRmoNpdQ+9b8BYjH9RcG4FJ510lxiyGXV+8mAFZApRuo55ueqSe65GxfPj
	 AnM9FSnsGL4nL38yz3UbKehofXsEkKUwA90QyIj2mr1i5J/6r2J0hVJrKE2QYSVOyY
	 76pa3fKJHKq3uUoUaqP4KasmwmeLM2bOVqSMMDd8rqrGyp+tgUS5WenzFV3wIipSbo
	 ooTV7Cca9R1M7RXcaqON+B11ezjNZVnwRJash4JnHODAtBGGpEXyclcAHkhgCkce/4
	 Z9pg7kERdh5Vw==
Date: Sun, 31 Dec 2023 14:59:53 -0800
Subject: [PATCH 4/5] xfs_scrub_all: convert systemctl calls to dbus
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405003402.1801694.3826549062268269438.stgit@frogsfrogsfrogs>
In-Reply-To: <170405003347.1801694.9862582977773516679.stgit@frogsfrogsfrogs>
References: <170405003347.1801694.9862582977773516679.stgit@frogsfrogsfrogs>
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

Convert the systemctl invocations to direct dbus calls, which decouples
us from the CLI in favor of direct API calls.  This spares us from some
of the insanity of divining service state from program outputs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/control         |    2 +
 scrub/xfs_scrub_all.in |   96 +++++++++++++++++++++++++++++++-----------------
 2 files changed, 63 insertions(+), 35 deletions(-)


diff --git a/debian/control b/debian/control
index 344466de016..31773e53a19 100644
--- a/debian/control
+++ b/debian/control
@@ -8,7 +8,7 @@ Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
 Package: xfsprogs
-Depends: ${shlibs:Depends}, ${misc:Depends}, python3:any
+Depends: ${shlibs:Depends}, ${misc:Depends}, python3-dbus, python3:any
 Provides: fsck-backend
 Suggests: xfsdump, acl, attr, quota
 Breaks: xfsdump (<< 3.0.0)
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index d5d1d13a255..a09566efdcd 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -15,6 +15,7 @@ import sys
 import os
 import argparse
 import signal
+import dbus
 from io import TextIOWrapper
 from pathlib import Path
 from datetime import timedelta
@@ -168,25 +169,57 @@ class scrub_service(scrub_control):
 	'''Control object for xfs_scrub systemd service.'''
 	def __init__(self, mnt, scrub_media):
 		self.unitname = path_to_serviceunit(mnt, scrub_media)
+		self.prop = None
+		self.unit = None
+		self.bind()
+
+	def bind(self):
+		'''Bind to the dbus proxy object for this service.'''
+		sysbus = dbus.SystemBus()
+		systemd1 = sysbus.get_object('org.freedesktop.systemd1',
+					    '/org/freedesktop/systemd1')
+		manager = dbus.Interface(systemd1,
+				'org.freedesktop.systemd1.Manager')
+		path = manager.LoadUnit(self.unitname)
+
+		svc_obj = sysbus.get_object('org.freedesktop.systemd1', path)
+		self.prop = dbus.Interface(svc_obj,
+				'org.freedesktop.DBus.Properties')
+		self.unit = dbus.Interface(svc_obj,
+				'org.freedesktop.systemd1.Unit')
+
+	def state(self):
+		'''Retrieve the active state for a systemd service.  As of
+		systemd 249, this is supposed to be one of the following:
+		"active", "reloading", "inactive", "failed", "activating",
+		or "deactivating".  These strings are not localized.'''
+		global debug
+
+		try:
+			return self.prop.Get('org.freedesktop.systemd1.Unit', 'ActiveState')
+		except Exception as e:
+			if debug:
+				print(e, file = sys.stderr)
+			return 'failed'
 
 	def wait(self, interval = 1):
 		'''Wait until the service finishes.'''
+		global debug
 
-		# As of systemd 249, the is-active command returns any of the
-		# following states: active, reloading, inactive, failed,
-		# activating, deactivating, or maintenance.  Apparently these
-		# strings are not localized.
-		while True:
-			try:
-				for l in backtick(['systemctl', 'is-active', self.unitname]):
-					if l == 'failed':
-						return 1
-					if l == 'inactive':
-						return 0
-			except:
-				return -1
-
+		# Use a poll/sleep loop to wait for the service to finish.
+		# Avoid adding a dependency on python3 glib, which is required
+		# to use an event loop to receive a dbus signal.
+		s = self.state()
+		while s not in ['failed', 'inactive']:
+			if debug:
+				print('waiting %s %s' % (self.unitname, s))
 			time.sleep(interval)
+			s = self.state()
+		if debug:
+			print('waited %s %s' % (self.unitname, s))
+		if s == 'failed':
+			return 1
+		return 0
 
 	def start(self):
 		'''Start the service and wait for it to complete.  Returns -1
@@ -194,34 +227,29 @@ class scrub_service(scrub_control):
 		failed.'''
 		global debug
 
-		cmd = ['systemctl', 'start', self.unitname]
+		if debug:
+			print('starting %s' % self.unitname)
+
 		try:
-			if debug:
-				print(' '.join(cmd))
-			proc = subprocess.Popen(cmd, stdout = DEVNULL())
-			proc.wait()
-			ret = proc.returncode
-		except:
+			self.unit.Start('replace')
+			return self.wait()
+		except Exception as e:
+			print(e, file = sys.stderr)
 			return -1
 
-		if ret != 1:
-			return ret
-
-		# If systemctl-start returns 1, it's possible that the service
-		# failed or that dbus/systemd restarted and the client program
-		# lost its connection -- according to the systemctl man page, 1
-		# means "unit not failed".
-		return self.wait()
-
 	def stop(self):
 		'''Stop the service.'''
 		global debug
 
-		cmd = ['systemctl', 'stop', self.unitname]
 		if debug:
-			print(' '.join(cmd))
-		x = subprocess.Popen(cmd)
-		x.wait()
+			print('stopping %s' % self.unitname)
+
+		try:
+			self.unit.Stop('replace')
+			return self.wait()
+		except Exception as e:
+			print(e, file = sys.stderr)
+			return -1
 
 def run_service(mnt, scrub_media, killfuncs):
 	'''Run scrub as a service.'''

