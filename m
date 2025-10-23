Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5639015E97
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178263; cv=none; b=Fq71CoZCpfIyMHsUJOsCeDDOmnurbUs0nqOLhjF5VF/CNwfs00EOELaz3X/X36UdlytTmoxs1UmedKvG5mwLm5A8JRyzvOU16p+vnkoFopN3IUpNr56MT9ryPuF/Xiv1BwyUxu/6HlCeswMq1Zq1BLCEAB1lEeuI9uYPTeJlwaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178263; c=relaxed/simple;
	bh=Wz6k1kQ1sfI4kxwW0pF21M4n9+mxUpt2gycmgj4Fk3E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rej7ARsK5AFJ7isECyE4OFpmAVJA4NWzRUNcuY6UHc0ckzB3nCZ3ysBhwUUPQTdGGbGntB/A2Zo8diauGp3OSgTvNDSAA2KDfp+SqUPP8njjeLsHWQO0gCmTSRcf4xT+exS/+6UZVxCC4myCrQ+fs0Lfmw5m7bvAHs8B7BACZTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLYLjWpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLYLjWpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81AFC4CEE7;
	Thu, 23 Oct 2025 00:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178262;
	bh=Wz6k1kQ1sfI4kxwW0pF21M4n9+mxUpt2gycmgj4Fk3E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LLYLjWpz3TUv3rRpJEY/sjWHWj7VEqpIDUJTVYQwsrsafAmqnrYbeaKD/+jrdbBj5
	 ysoOPLvrmB7gnPFAQ3eeppGt5je6gPmQYPaZcfi31hJUqT8dNv8bhJf1vX85d2YN4l
	 RyrQDrb8FkhDbPkzn9Br9RZUe0ivK6cvVzIS0UKEYKmuJQHeQCsKxSU6mVjTt1LABp
	 EzdjfAw5JWWe0bY1umAMzOMUfRl2Lf3VNSxAebFvtd2tMTWFAnMGq61wpLhgacPSHM
	 VFkib9Y4qWIZznqMGvrIMWOfVzuS5FzvrqBBcKIKOCix2NRjEQmZckZPJ+8Okc4iFJ
	 dOBrloGbkVP/A==
Date: Wed, 22 Oct 2025 17:11:02 -0700
Subject: [PATCH 21/26] xfs_healer: run full scrub after lost corruption events
 or targeted repair failure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747861.1028044.561788349560553919.stgit@frogsfrogsfrogs>
In-Reply-To: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
References: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we fail to perform a spot repair of metadata or the kernel tells us
that it lost corruption events due to queue limits, initiate a full run
of the online fsck service to try to fix the error.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile         |    1 +
 healer/xfs_healer.py.in |   59 +++++++++++++++++++++++++++++++++++++++++------
 include/builddefs.in    |    1 +
 scrub/Makefile          |    7 ++----
 4 files changed, 57 insertions(+), 11 deletions(-)


diff --git a/healer/Makefile b/healer/Makefile
index a30e0714309295..798c6f2c8a58e0 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -34,6 +34,7 @@ $(XFS_HEALER_PROG): $(XFS_HEALER_PROG).in $(builddefs) $(TOPDIR)/libfrog/gettext
 		   -e '/@INIT_GETTEXT@/r $(TOPDIR)/libfrog/gettext.py' \
 		   -e '/@INIT_GETTEXT@/d' \
 		   -e "s|@pkg_data_dir@|$(PKG_DATA_DIR)|g" \
+		   -e "s|@scrub_svcname@|$(XFS_SCRUB_SVCNAME)|g" \
 		   < $< > $@
 	$(Q)chmod a+x $@
 
diff --git a/healer/xfs_healer.py.in b/healer/xfs_healer.py.in
index 4c6ab2662f6f50..a96c9e812f5791 100644
--- a/healer/xfs_healer.py.in
+++ b/healer/xfs_healer.py.in
@@ -23,6 +23,7 @@ import ctypes.util
 from enum import Enum
 import collections
 import time
+import subprocess
 
 try:
 	# Not all systems will have this json schema validation libarary,
@@ -262,6 +263,17 @@ class fshandle(object):
 		self.handle.ha_fid.fid_ino = ino
 		self.handle.ha_fid.fid_gen = gen
 
+	def instance_unit_name(self, service_template):
+		'''Compute the systemd instance unit name for this mountpoint.'''
+
+		cmd = ['systemd-escape', '--template', service_template,
+		       '--path', self.mountpoint]
+
+		proc = subprocess.Popen(cmd, stdout = subprocess.PIPE)
+		proc.wait()
+		for line in proc.stdout:
+			return line.decode(sys.stdout.encoding).strip()
+
 def libhandle_load():
 	'''Load libhandle and set things up.'''
 	global libhandle
@@ -776,7 +788,7 @@ def report_shutdown(event):
 	msg = _("filesystem shut down due to")
 	printlogln(f"{printf_prefix}: {msg} {some_reasons}")
 
-def handle_event(lines, fh):
+def handle_event(lines, fh, everything):
 	'''Handle an event asynchronously.'''
 	global log
 	global has_parent
@@ -832,6 +844,8 @@ def handle_event(lines, fh):
 	# messages.
 	if event['type'] == 'lost':
 		report_lost(event)
+		if want_repair and not everything:
+			run_full_repair(fh)
 		return
 
 	if event['type'] == 'running':
@@ -919,13 +933,14 @@ def monitor(mountpoint, event_queue, check, **kwargs):
 	global has_rmapbt
 	use_autofsck = want_repair is None
 
-	def event_loop(mon_fd, event_queue, fh):
+	def event_loop(mon_fd, event_queue, fh, everything):
 		# Ownership of mon_fd (and hence responsibility for closing it)
 		# is transferred to the mon_fp object.
 		with os.fdopen(mon_fd) as mon_fp:
 			nr = 0
 			for lines in health_reports(mon_fp):
-				event_queue.submit(handle_event, lines, fh)
+				event_queue.submit(handle_event, lines, fh,
+						everything)
 
 				# Periodically run the garbage collector to
 				# constrain memory usage in the main thread.
@@ -1018,7 +1033,7 @@ def monitor(mountpoint, event_queue, check, **kwargs):
 
 	try:
 		# mon_fd is consumed by this function
-		event_loop(mon_fd, event_queue, fh)
+		event_loop(mon_fd, event_queue, fh, everything)
 	except Exception as e:
 		eprintln(f"{mountpoint}: {e}")
 		return 1
@@ -1081,6 +1096,8 @@ def repair_wholefs(event, fd):
 			outcome = RepairOutcome.from_oflags(oflags)
 			report = outcome.report()
 			printlogln(f"{printf_prefix}: {struct}: {report}")
+			if outcome == RepairOutcome.Failed:
+				return outcome
 		except Exception as e:
 			eprintln(f"{printf_prefix}: {struct}: {e}")
 
@@ -1097,6 +1114,8 @@ def repair_group(event, fd, group_type):
 			outcome = RepairOutcome.from_oflags(oflags)
 			report = outcome.report()
 			printlogln(f"{printf_prefix}: {struct}: {report}")
+			if outcome == RepairOutcome.Failed:
+				return outcome
 		except Exception as e:
 			eprintln(f"{printf_prefix}: {struct}: {e}")
 
@@ -1115,6 +1134,8 @@ def repair_inode(event, fd):
 			outcome = RepairOutcome.from_oflags(oflags)
 			report = outcome.report()
 			printlogln(f"{prefix} {structure}: {report}")
+			if outcome == RepairOutcome.Failed:
+				return outcome
 		except Exception as e:
 			eprintln(f"{prefix} {structure}: {e}")
 
@@ -1134,20 +1155,44 @@ def repair_metadata(event, fh):
 
 	try:
 		if event['domain'] in ['fs', 'realtime']:
-			repair_wholefs(event, fd)
+			outcome = repair_wholefs(event, fd)
 		elif event['domain'] in ['perag', 'rtgroup']:
-			repair_group(event, fd, event['domain'])
+			outcome = repair_group(event, fd, event['domain'])
 		elif event['domain'] == 'inode':
-			repair_inode(event, fd)
+			outcome = repair_inode(event, fd)
 		else:
 			domain = event['domain']
 			msg = _("Unknown metadata domain")
 			raise Exception(f"{msg} \"{domain}\".")
+
+		# Transform into a full repair if we failed to fix this item.
+		if outcome == RepairOutcome.Failed:
+			run_full_repair(fh)
 	except Exception as e:
 		eprintln(f"{printf_prefix}: {e}")
 	finally:
 		os.close(fd)
 
+def run_full_repair(fh):
+	'''Run a full repair of the filesystem using the background fsck.'''
+	global printf_prefix
+
+	try:
+		unit_name = fh.instance_unit_name("@scrub_svcname@")
+		cmd = ['systemctl', 'start', '--no-block', unit_name]
+
+		proc = subprocess.Popen(cmd)
+		proc.wait()
+		if proc.returncode == 0:
+			msg = _("Full repair: Repairs in progress.")
+			printlogln(f"{printf_prefix}: {msg}")
+		else:
+			msg = _("Could not start xfs_scrub service.")
+			eprintln(f"{printf_prefix}: {msg}");
+	except Exception as e:
+		eprintln(f"{printf_prefix}: {e}")
+
+
 def main():
 	global debug
 	global log
diff --git a/include/builddefs.in b/include/builddefs.in
index ddcc784361f0b9..7cf6e0782788ca 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -62,6 +62,7 @@ MKFS_CFG_DIR	= @datadir@/@pkg_name@/mkfs
 PKG_STATE_DIR	= @localstatedir@/lib/@pkg_name@
 
 XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP=$(PKG_STATE_DIR)/xfs_scrub_all_media.stamp
+XFS_SCRUB_SVCNAME=xfs_scrub@.service
 
 CC		= @cc@
 BUILD_CC	= @BUILD_CC@
diff --git a/scrub/Makefile b/scrub/Makefile
index 6375d77a291bcb..18f476de24252b 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -8,7 +8,6 @@ include $(builddefs)
 
 SCRUB_PREREQS=$(HAVE_GETFSMAP)
 
-scrub_svcname=xfs_scrub@.service
 scrub_media_svcname=xfs_scrub_media@.service
 
 ifeq ($(SCRUB_PREREQS),yes)
@@ -21,7 +20,7 @@ XFS_SCRUB_SERVICE_ARGS = -b -o autofsck
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
-	$(scrub_svcname) \
+	$(XFS_SCRUB_SVCNAME) \
 	xfs_scrub_fail@.service \
 	$(scrub_media_svcname) \
 	xfs_scrub_media_fail@.service \
@@ -123,7 +122,7 @@ xfs_scrub_all.timer: xfs_scrub_all.timer.in $(builddefs)
 $(XFS_SCRUB_ALL_PROG): $(XFS_SCRUB_ALL_PROG).in $(builddefs) $(TOPDIR)/libfrog/gettext.py
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
-		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
+		   -e "s|@scrub_svcname@|$(XFS_SCRUB_SVCNAME)|g" \
 		   -e "s|@scrub_media_svcname@|$(scrub_media_svcname)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
 		   -e "s|@stampfile@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP)|g" \
@@ -137,7 +136,7 @@ $(XFS_SCRUB_ALL_PROG): $(XFS_SCRUB_ALL_PROG).in $(builddefs) $(TOPDIR)/libfrog/g
 xfs_scrub_fail: xfs_scrub_fail.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
-		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
+		   -e "s|@scrub_svcname@|$(XFS_SCRUB_SVCNAME)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g"  < $< > $@
 	$(Q)chmod a+x $@
 

