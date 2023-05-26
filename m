Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68849C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjEZB6q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjEZB6p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:58:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CB5E7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:58:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54D4C6179C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2337C433EF;
        Fri, 26 May 2023 01:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066323;
        bh=jvUqwbNeBac59zo2QIDQ6aIAupNJnDlI8rYVjwwWrd0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qQb417kyI8FY5eAdSn96TwAOXuEKeFctVyL3v9UwUHNLtvywsei/Xv6g1i8obVUEQ
         H3dLwD+40hUPg16G25qSQhaYiFo8kdtPHBA9/EzeKUuDsYClzBgrrjv3/reoMSp0c/
         qkz2/9b3jmGo3Mn04zQzYYLTBd8Va+JD5R837S38w4A1AsslgbNX2x9AWcPLgjnTI0
         RfVI5AGfG+LEIxYS0U/L+g719xwWnsgsxoPwgWplJxX2Ors0XjLFqPjkLr4vx8COqL
         j0rPDQ1hhvRZk62KyrFCzFdvuelTgn0jN6664W6aNg7Dh+b5Ntzr3yBs+yJBvt+wGP
         gbjfb1mucnJNw==
Date:   Thu, 25 May 2023 18:58:43 -0700
Subject: [PATCH 4/5] xfs_scrub_all: convert systemctl calls to dbus
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506075261.3746473.9497896664590753230.stgit@frogsfrogsfrogs>
In-Reply-To: <168506075207.3746473.18041622129638673219.stgit@frogsfrogsfrogs>
References: <168506075207.3746473.18041622129638673219.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index a2b3350fe87..b5a770c220d 100644
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

