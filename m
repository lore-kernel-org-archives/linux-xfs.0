Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D89E7464
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302222; cv=none; b=orr8fkmSnAl28erb1n5zMFBhjHqvl5mKiSMho+aWQ/MankRHR70+SbMPY++kl2W//OT/IBYji8lQsV90ZJV+ZtctmFdIhcqz5diQ3zbptBqDzbQFbXLsSljBor9SMYRc3UxN+rS6p2CJtybRkoo3t2FVDEXo3AuMASs1iC//CRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302222; c=relaxed/simple;
	bh=lfjtvYRmkSEbR/T6lQa31y3p8E0z9tE3pSvcLZKrAdU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GYHceNT5Yms82SE/8Qq7bhXxky3Z29jrISI07IUTAl2kNKPXw2zGR4YiamKw9PiqC69/2X4iLoDJEdeMG1TyvHZZBcLg9HfGVhIwgC0NHvos9mfWXSveUFfUhTfm7ZacR12NEWeFrseOQ0qVv4ACsSCXyx/fVEr6ndwMEQw4w4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ke7iz06F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ke7iz06F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6364C32786;
	Tue, 30 Jul 2024 01:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302221;
	bh=lfjtvYRmkSEbR/T6lQa31y3p8E0z9tE3pSvcLZKrAdU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ke7iz06FuSWjSwUXBvgSa6ffcrhGxBec/A2NIOl0o1c/w5dfN6hn5riDfczw/NDh6
	 atMho8No0pQb6iJQZrTF84wIODRyJi7bHPbNHVnU+bGzcZM0d8AsZCj8GPij0Uc0bc
	 6wwzSJbyyzecWdyZq6hEbBdDi267qhnCe4zpn5IKUnPuJMhjzeYEk5dK3jBzDjZs4N
	 EF6/vXfk6m5nDyR/f4+PSAut5sU0GO8LPKMYgm2KYrnN7JQO8Yw/GJu9KXCk2H+48X
	 r/WCrBgRMjue+SEMva4YO7DWMqjoqZliYA4Shhb6x+dnU2CKWQSLgrCJ9n0JL5aMT4
	 Zm/D727AQ2u6g==
Date: Mon, 29 Jul 2024 18:17:01 -0700
Subject: [PATCH 4/5] xfs_scrub_all: convert systemctl calls to dbus
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229849704.1350420.15182762451486145269.stgit@frogsfrogsfrogs>
In-Reply-To: <172229849638.1350420.756131243612881227.stgit@frogsfrogsfrogs>
References: <172229849638.1350420.756131243612881227.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 debian/control         |    2 +
 scrub/xfs_scrub_all.in |   96 +++++++++++++++++++++++++++++++-----------------
 2 files changed, 63 insertions(+), 35 deletions(-)


diff --git a/debian/control b/debian/control
index 344466de0..31773e53a 100644
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
index 8954b4740..f2e916513 100644
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

