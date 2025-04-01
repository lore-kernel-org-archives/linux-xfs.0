Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D850203714
	for <linux-xfs@vger.kernel.org>; Tue,  1 Apr 2025 14:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743518685; cv=none; b=ZVbJEWrtJMO+K+VHy8yDi+zpUvxQT1vroaWwGYlQ/wopC4mFBeCbAgJSGWMenG5DF1MYrafnRTTA8UlmdaLYlyNoIsGiY0MAo/b6g2+u4sRQGxL8UxzQxGv/zcEBfrjHwH1r6bY0f7ZZLBbPd2mw9dcA2DM2xcqQ/+9HMYaRu0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743518685; c=relaxed/simple;
	bh=zTw3gAdO0l7qhh3c5xGv+Srd7RmGUI5PvuDTHehPi4o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r4hL5u9xjo1MdQIzvG8sj2X5mvAFdMvwORYK48INgcr0vixY2jgLQ3/rq4jJFmuisIqYdFt7omgSyY3sgdnBy4KyAU+UjhZMvq+poX0/7R9ZXwvvvaBLfiYWHysG7UaZ0s6RrMJfx7i3Btc5AHs/aoKmVbqyhPiKXCB61bg90Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q+1nDurO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q+1nDurO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FACC4CEE4;
	Tue,  1 Apr 2025 14:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743518685;
	bh=zTw3gAdO0l7qhh3c5xGv+Srd7RmGUI5PvuDTHehPi4o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q+1nDurOcNFiUYOtGgK4QK7bFYaSKxPGvp8ofYa0Xpq0hnNJ3RsNMrHoTq5g4I3eA
	 mUDx9qd01KxBubmDdPZUGPGbDCGmHmD3sq60Hah1ZO5lE6Lp5IysaDlTTU/dbcTNS8
	 JZUCBK9bbyeKyQCwBRcCE0b/6dd2hHQZCY2nUlUL0Kuh1Li+m6/nqwLXvwjfYMY8AN
	 AabHAJ80iV7ouKZkdaFR+KF5V/kzGQHpVCxJR3Fm1GX+EaFnxVGok7QnkXFv5qCT2V
	 lDdcFmuXRe8M3Bl7xi45XCnEwJIJ5U7LZ6b8pszXKeiKm9NSRVmOl05zpe7YrdhWsL
	 X31XKot0mYkZA==
Date: Tue, 01 Apr 2025 07:44:44 -0700
Subject: [PATCH 5/5] xfs_scrub_all: localize the strings in the program
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <174351857669.2774496.16112531577218148169.stgit@frogsfrogsfrogs>
In-Reply-To: <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>
References: <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use gettext to localize the output of this program.  While we're at it,
convert everything to f-strings to make it easier for translators to
understand the string.  f-strings introduce a runtime requirement of
Python 3.6, which includes Debian 10 and RHEL 7.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/Makefile            |    7 ++++-
 scrub/xfs_scrub_all.py.in |   62 +++++++++++++++++++++++++++------------------
 2 files changed, 42 insertions(+), 27 deletions(-)


diff --git a/scrub/Makefile b/scrub/Makefile
index b8105f69e4cc57..3636a47942e98e 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -116,7 +116,7 @@ xfs_scrub_all.timer: xfs_scrub_all.timer.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@pkg_state_dir@|$(PKG_STATE_DIR)|g" < $< > $@
 
-$(XFS_SCRUB_ALL_PROG): $(XFS_SCRUB_ALL_PROG).in $(builddefs)
+$(XFS_SCRUB_ALL_PROG): $(XFS_SCRUB_ALL_PROG).in $(builddefs) $(TOPDIR)/libfrog/gettext.py
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
@@ -124,7 +124,10 @@ $(XFS_SCRUB_ALL_PROG): $(XFS_SCRUB_ALL_PROG).in $(builddefs)
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
 		   -e "s|@stampfile@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP)|g" \
 		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
-		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
+		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
+		   -e '/@INIT_GETTEXT@/r $(TOPDIR)/libfrog/gettext.py' \
+		   -e '/@INIT_GETTEXT@/d' \
+		   < $< > $@
 	$(Q)chmod a+x $@
 
 xfs_scrub_fail: xfs_scrub_fail.in $(builddefs)
diff --git a/scrub/xfs_scrub_all.py.in b/scrub/xfs_scrub_all.py.in
index fe4bca4b2edb11..515cc144414de6 100644
--- a/scrub/xfs_scrub_all.py.in
+++ b/scrub/xfs_scrub_all.py.in
@@ -7,6 +7,7 @@
 
 # Run online scrubbers in parallel, but avoid thrashing.
 
+@INIT_GETTEXT@
 import subprocess
 import json
 import threading
@@ -115,7 +116,7 @@ class scrub_subprocess(scrub_control):
 		global debug
 
 		if debug:
-			print('run ', ' '.join(self.cmdline))
+			print(_('run '), ' '.join(self.cmdline))
 
 		try:
 			self.proc = subprocess.Popen(self.cmdline)
@@ -132,7 +133,7 @@ class scrub_subprocess(scrub_control):
 		global debug
 
 		if debug:
-			print('kill ', ' '.join(self.cmdline))
+			print(_('kill '), ' '.join(self.cmdline))
 		if self.proc is not None:
 			self.proc.terminate()
 
@@ -270,7 +271,8 @@ class scrub_service(scrub_control):
 		for i in range(0, int(wait_for / interval)):
 			s = self.state()
 			if debug:
-				print('waiting for activation %s %s' % (self.unitname, s))
+				msg = _("waiting for activation")
+				print(f'{msg} {self.unitname} {s}')
 			if s == 'failed':
 				return 1
 			if s != 'inactive':
@@ -284,7 +286,8 @@ class scrub_service(scrub_control):
 
 		s = self.state()
 		if debug:
-			print('waited for startup %s %s' % (self.unitname, s))
+			msg = _('waited for startup')
+			print(f'{msg} {self.unitname} {s}')
 		if s == 'failed':
 			return 1
 		if s != 'inactive':
@@ -307,11 +310,13 @@ class scrub_service(scrub_control):
 		s = self.state()
 		while s not in ['failed', 'inactive']:
 			if debug:
-				print('waiting %s %s' % (self.unitname, s))
+				msg = _("waiting for")
+				print(f'{msg} {self.unitname} {s}')
 			time.sleep(interval)
 			s = self.state()
 		if debug:
-			print('waited %s %s' % (self.unitname, s))
+			msg = _('waited for')
+			print(f'{msg} {self.unitname} {s}')
 		if s == 'failed':
 			return 1
 		return 0
@@ -323,7 +328,8 @@ class scrub_service(scrub_control):
 		global debug
 
 		if debug:
-			print('starting %s' % self.unitname)
+			msg = _("starting")
+			print(f'{msg} {self.unitname}')
 
 		try:
 			last_active = self.last_activation()
@@ -348,7 +354,8 @@ class scrub_service(scrub_control):
 		global debug
 
 		if debug:
-			print('stopping %s' % self.unitname)
+			msg = _('stopping')
+			print(f'{msg} {self.unitname}')
 
 		try:
 			self.__dbusrun(lambda: self.unit.Stop('replace'))
@@ -387,11 +394,13 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		if 'SERVICE_MODE' in os.environ:
 			ret = run_service(mnt, scrub_media, killfuncs)
 			if ret == 32:
-				print("Scrubbing %s disabled by administrator, (err=%d)" % (mnt, ret))
+				msg = _("Scrubbing disabled by administrator")
+				print(f"{mnt}: {msg}, (err={ret})")
 				sys.stdout.flush()
 				return
 			if ret == 0 or ret == 1:
-				print("Scrubbing %s done, (err=%d)" % (mnt, ret))
+				msg = _("Scrubbing done")
+				print(f"{mnt}: {msg}, (err={ret})")
 				sys.stdout.flush()
 				retcode |= ret
 				return
@@ -404,7 +413,8 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		# systemd services are unavailable.
 		ret = run_subprocess(mnt, scrub_media, killfuncs)
 		if ret >= 0:
-			print("Scrubbing %s done, (err=%d)" % (mnt, ret))
+			msg = _("Scrubbing done")
+			print(f"{mnt}: {msg}, (err={ret})")
 			sys.stdout.flush()
 			retcode |= ret
 			return
@@ -412,7 +422,7 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		if terminate:
 			return
 
-		print("Unable to start scrub tool.")
+		print(_("Unable to start scrub tool."))
 		sys.stdout.flush()
 	finally:
 		running_devs -= mntdevs
@@ -426,7 +436,7 @@ def signal_scrubs(signum, cond):
 	global terminate
 
 	if debug:
-		print('Signal handler called with signal', signum)
+		print(_('Signal handler called with signal'), signum)
 		sys.stdout.flush()
 
 	terminate = True
@@ -441,7 +451,7 @@ def wait_for_termination(cond, killfuncs):
 	global terminate
 
 	if debug:
-		print('waiting for threads to terminate')
+		print(_('waiting for threads to terminate'))
 		sys.stdout.flush()
 
 	cond.acquire()
@@ -454,7 +464,7 @@ def wait_for_termination(cond, killfuncs):
 	if not terminate:
 		return False
 
-	print("Terminating...")
+	print(_("Terminating..."))
 	sys.stdout.flush()
 	while len(killfuncs) > 0:
 		fn = killfuncs.pop()
@@ -496,8 +506,8 @@ def enable_automatic_media_scan(args):
 	try:
 		interval = scan_interval(args.auto_media_scan_interval)
 	except Exception as e:
-		raise Exception('%s: Invalid media scan interval.' % \
-				args.auto_media_scan_interval)
+		msg = _("Invalid media scan interval.")
+		raise Exception(f'{args.auto_media_scan_interval}: {msg}')
 
 	p = Path(args.auto_media_scan_stamp)
 	if already_enabled:
@@ -515,7 +525,7 @@ def enable_automatic_media_scan(args):
 		with p.open('w') as f:
 			pass
 		if not already_enabled:
-			print('Automatically enabling file data scrub.')
+			print(_('Automatically enabling file data scrub.'))
 			sys.stdout.flush()
 
 	return res
@@ -532,21 +542,23 @@ def main():
 	global debug
 
 	parser = argparse.ArgumentParser( \
-			description = "Scrub all mounted XFS filesystems.")
-	parser.add_argument("--debug", help = "Enabling debugging messages.", \
+			description = _("Scrub all mounted XFS filesystems."))
+	parser.add_argument("--debug", help = _("Enabling debugging messages."), \
 			action = "store_true")
-	parser.add_argument("-V", help = "Report version and exit.", \
+	parser.add_argument("-V", help = _("Report version and exit."), \
 			action = "store_true")
-	parser.add_argument("-x", help = "Scrub file data after filesystem metadata.", \
+	parser.add_argument("-x", help = _("Scrub file data after filesystem metadata."), \
 			action = "store_true")
-	parser.add_argument("--auto-media-scan-interval", help = "Automatically scrub file data at this interval.", \
+	parser.add_argument("--auto-media-scan-interval", help = _("Automatically scrub file data at this interval."), \
 			default = None)
-	parser.add_argument("--auto-media-scan-stamp", help = "Stamp file for automatic file data scrub.", \
+	parser.add_argument("--auto-media-scan-stamp", help = _("Stamp file for automatic file data scrub."), \
 			default = '@stampfile@')
 	args = parser.parse_args()
 
 	if args.V:
-		print("xfs_scrub_all version @pkg_version@")
+		msg = _("xfs_scrub_all version")
+		pkgver = "@pkg_version@"
+		print(f"{msg} {pkgver}")
 		sys.exit(0)
 
 	if args.debug:

