Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC859449
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882532; cv=none; b=D6LyHzZcS9n7c8t80WHl080CloXc83qigmmgp5ywFse2nfiQQQXdfjowzGhwWJIj2KJoOm65tT6tPV+2uYMSejdsgJa5ExVGgm9IBgld6OxtBmXQn5SYyYXnxiClgg23on36bNAx5XmDa2pxtFK1LHFOgIDwLBooSOJyNQ+6nrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882532; c=relaxed/simple;
	bh=I2tMiyF5go41YuIuljvw4aoYS9iLoBKsWmqCzX/QuuA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UuPZvRXR0v+CrtzSYk7QvrNXCa+00kqeWTVmGfA9e6IqN/7V1xz9bR8jV2urJUZ7gNPRdVWBE6guQb0y5lA0yoOMXSzmKZb/SIENc/KjTFvTGT2G/AvKxmHWXs0pZk76fY+GOs7L0RzO5iCuXXARGl9xyUfZKzmYKLvKWn4HtbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pkDZ46dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pkDZ46dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5541BC116B1;
	Tue,  2 Jul 2024 01:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882532;
	bh=I2tMiyF5go41YuIuljvw4aoYS9iLoBKsWmqCzX/QuuA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pkDZ46dcsEvkVs+/UWRvGXa+tilC5NcORvVUM1Abkhmk95tqp/bER94tf2IRP2boN
	 h4Djx6JONuejJpUDGPy+EGeY0aa8Xi6CYYbCvQ4jOKLFrnau9/7ONNphJUuoxKE0a8
	 svjjGLB5xPQJWpOX2qnbRVA7NrYDRdpGmrbBy6bzUtnUWFveAxKUXYgQEB6oqsrYCb
	 olxy3GnPceghDY5pk2Qp4apLbor5cRQq5G0rOhLhSH87q/pUUcJp0BfY3b2uNqOLaD
	 XCuqAr3oiNua7wyg+aHjmmmKUf58JnlHg7sjg65nHiMRwKcYZrV5FIi42+y8T/Gwdd
	 EtUlvyg796Mjg==
Date: Mon, 01 Jul 2024 18:08:51 -0700
Subject: [PATCH 4/5] xfs_scrub_all: convert systemctl calls to dbus
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119875.2008718.8969308689929459520.stgit@frogsfrogsfrogs>
In-Reply-To: <171988119806.2008718.11057954097670233571.stgit@frogsfrogsfrogs>
References: <171988119806.2008718.11057954097670233571.stgit@frogsfrogsfrogs>
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
index 344466de0161..31773e53a19a 100644
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
index d5d1d13a2552..a09566efdcd8 100644
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

