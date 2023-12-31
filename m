Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA34C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EGW9H0Z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E85CC433C7;
	Sun, 31 Dec 2023 22:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063500;
	bh=QttrNkfp3tOidNScs7Rpm8muwol/4gX2S2xxGyYyKk0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EGW9H0Z2MrcKl7/9rhTrXMkOuUTgaoXncQS1iBniMr+LIF23wuE2KUaa/9ucXhvBL
	 uPlNTREiiMLwsbQv8/fjrdTiOwqCIJfsPWyomxxHD8V8mqWbqCDs2JKcq5ADdgjYb7
	 4l8QLJ0HiPtlcBy8ZI776xAnVq7GRaUOeaqAAOT3QaynVpVlEiFGSf3VkpScPRGw98
	 NmDAEpCmhZ6JJCGhSqQzw8xAf1+ElReRKin+sDTwbKAD7SakFJKPkIzLyhuwCuiovB
	 GyAM/APNDG5OCIB91e9AgXAjFhPcJgRGjEDI8hSbIUHe/VdgQhYJAj2hQ9f+PXSvVv
	 Wx5oaZMVER+8w==
Date: Sun, 31 Dec 2023 14:58:19 -0800
Subject: [PATCH 4/6] xfs_scrub_all: enable periodic file data scrubs
 automatically
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405003032.1801496.12050413623153786031.stgit@frogsfrogsfrogs>
In-Reply-To: <170405002977.1801496.15279364480135878968.stgit@frogsfrogsfrogs>
References: <170405002977.1801496.15279364480135878968.stgit@frogsfrogsfrogs>
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

Enhance xfs_scrub_all with the ability to initiate a file data scrub
periodically.  The user must specify the period, and they may optionally
specify the path to a file that will record the last time the file data
was scrubbed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/rules                   |    3 +-
 include/builddefs.in           |    3 ++
 man/man8/Makefile              |    7 +++-
 man/man8/xfs_scrub_all.8.in    |   15 ++++++++
 scrub/Makefile                 |    3 ++
 scrub/xfs_scrub_all.in         |   76 +++++++++++++++++++++++++++++++++++++++-
 scrub/xfs_scrub_all.service.in |    6 ++-
 7 files changed, 108 insertions(+), 5 deletions(-)
 rename man/man8/{xfs_scrub_all.8 => xfs_scrub_all.8.in} (63%)


diff --git a/debian/rules b/debian/rules
index 57baad625c5..97fbbbfa1ab 100755
--- a/debian/rules
+++ b/debian/rules
@@ -34,7 +34,8 @@ configure_options = \
 	--disable-ubsan \
 	--disable-addrsan \
 	--disable-threadsan \
-	--enable-lto
+	--enable-lto \
+	--localstatedir=/var
 
 options = export DEBUG=-DNDEBUG DISTRIBUTION=debian \
 	  INSTALL_USER=root INSTALL_GROUP=root \
diff --git a/include/builddefs.in b/include/builddefs.in
index f5138b5098f..daac1b5d18a 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -59,6 +59,9 @@ PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
 PKG_LOCALE_DIR	= @datadir@/locale
 PKG_DATA_DIR	= @datadir@/@pkg_name@
 MKFS_CFG_DIR	= @datadir@/@pkg_name@/mkfs
+PKG_STATE_DIR	= @localstatedir@/lib/@pkg_name@
+
+XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP=$(PKG_STATE_DIR)/xfs_scrub_all_media.stamp
 
 CC		= @cc@
 BUILD_CC	= @BUILD_CC@
diff --git a/man/man8/Makefile b/man/man8/Makefile
index 272e45aebc2..5be76ab727a 100644
--- a/man/man8/Makefile
+++ b/man/man8/Makefile
@@ -11,11 +11,12 @@ ifneq ("$(ENABLE_SCRUB)","yes")
   MAN_PAGES = $(filter-out xfs_scrub%,$(shell echo *.$(MAN_SECTION)))
 else
   MAN_PAGES = $(shell echo *.$(MAN_SECTION))
+  MAN_PAGES += xfs_scrub_all.8
 endif
 MAN_PAGES	+= mkfs.xfs.8
 MAN_DEST	= $(PKG_MAN_DIR)/man$(MAN_SECTION)
 LSRCFILES	= $(MAN_PAGES)
-DIRT		= mkfs.xfs.8
+DIRT		= mkfs.xfs.8 xfs_scrub_all.8
 
 default : $(MAN_PAGES)
 
@@ -29,4 +30,8 @@ mkfs.xfs.8: mkfs.xfs.8.in
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e 's|@mkfs_cfg_dir@|$(MKFS_CFG_DIR)|g' < $^ > $@
 
+xfs_scrub_all.8: xfs_scrub_all.8.in
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e 's|@stampfile@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP)|g' < $^ > $@
+
 install-dev :
diff --git a/man/man8/xfs_scrub_all.8 b/man/man8/xfs_scrub_all.8.in
similarity index 63%
rename from man/man8/xfs_scrub_all.8
rename to man/man8/xfs_scrub_all.8.in
index 86a9b3eced2..0aa87e23716 100644
--- a/man/man8/xfs_scrub_all.8
+++ b/man/man8/xfs_scrub_all.8.in
@@ -18,6 +18,21 @@ operations can be run in parallel so long as no two scrubbers access
 the same device simultaneously.
 .SH OPTIONS
 .TP
+.B \--auto-media-scan-interval
+Automatically enable the file data scan (i.e. the
+.B -x
+flag) if it has not been run in the specified interval.
+The interval must be a floating point number with an optional unit suffix.
+Supported unit suffixes are
+.IR y ", " q ", " mo ", " w ", " d ", " h ", " m ", and " s
+for years, 90-day quarters, 30-day months, weeks, days, hours, minutes, and
+seconds, respectively.
+If no units are specified, the default is seconds.
+.TP
+.B \--auto-media-scan-stamp
+Path to a file that will record the last time the media scan was run.
+Defaults to @stampfile@.
+.TP
 .B \-h
 Display help.
 .TP
diff --git a/scrub/Makefile b/scrub/Makefile
index fb909c55eb5..4c7bbb30d20 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -130,6 +130,7 @@ xfs_scrub_all: xfs_scrub_all.in $(builddefs)
 		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
 		   -e "s|@scrub_media_svcname@|$(scrub_media_svcname)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
+		   -e "s|@stampfile@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP)|g" \
 		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
 	$(Q)chmod a+x $@
@@ -153,6 +154,7 @@ install: $(INSTALL_SCRUB)
 		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
 		   -e "s|@pkg_libexec_dir@|$(PKG_LIBEXEC_DIR)|g" \
+		   -e "s|@pkg_state_dir@|$(PKG_STATE_DIR)|g" \
 		   < $< > $@
 
 %.cron: %.cron.in $(builddefs)
@@ -173,6 +175,7 @@ install-scrub: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 $(XFS_SCRUB_ALL_PROG) $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_STATE_DIR)
 
 install-udev: $(UDEV_RULES)
 	$(INSTALL) -m 755 -d $(UDEV_RULE_DIR)
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index afba0dbe891..9d5cbd2a648 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -16,6 +16,10 @@ import os
 import argparse
 import signal
 from io import TextIOWrapper
+from pathlib import Path
+from datetime import timedelta
+from datetime import datetime
+from datetime import timezone
 
 retcode = 0
 terminate = False
@@ -248,6 +252,65 @@ def wait_for_termination(cond, killfuncs):
 		fn()
 	return True
 
+def scan_interval(string):
+	'''Convert a textual scan interval argument into a time delta.'''
+
+	if string.endswith('y'):
+		year = timedelta(seconds = 31556952)
+		return year * float(string[:-1])
+	if string.endswith('q'):
+		return timedelta(days = 90 * float(string[:-1]))
+	if string.endswith('mo'):
+		return timedelta(days = 30 * float(string[:-2]))
+	if string.endswith('w'):
+		return timedelta(weeks = float(string[:-1]))
+	if string.endswith('d'):
+		return timedelta(days = float(string[:-1]))
+	if string.endswith('h'):
+		return timedelta(hours = float(string[:-1]))
+	if string.endswith('m'):
+		return timedelta(minutes = float(string[:-1]))
+	if string.endswith('s'):
+		return timedelta(seconds = float(string[:-1]))
+	return timedelta(seconds = int(string))
+
+def utcnow():
+	'''Create a representation of the time right now, in UTC.'''
+
+	dt = datetime.utcnow()
+	return dt.replace(tzinfo = timezone.utc)
+
+def enable_automatic_media_scan(args):
+	'''Decide if we enable media scanning automatically.'''
+	already_enabled = args.x
+
+	try:
+		interval = scan_interval(args.auto_media_scan_interval)
+	except Exception as e:
+		raise Exception('%s: Invalid media scan interval.' % \
+				args.auto_media_scan_interval)
+
+	p = Path(args.auto_media_scan_stamp)
+	if already_enabled:
+		res = True
+	else:
+		try:
+			last_run = p.stat().st_mtime
+			now = utcnow().timestamp()
+			res = last_run + interval.total_seconds() < now
+		except FileNotFoundError:
+			res = True
+
+	if res:
+		# Truncate the stamp file to update its mtime
+		with p.open('w') as f:
+			pass
+		if not already_enabled:
+			print('Automatically enabling file data scrub.')
+			sys.stdout.flush()
+
+	return res
+
 def main():
 	'''Find mounts, schedule scrub runs.'''
 	def thr(mnt, devs):
@@ -262,13 +325,24 @@ def main():
 			action = "store_true")
 	parser.add_argument("-x", help = "Scrub file data after filesystem metadata.", \
 			action = "store_true")
+	parser.add_argument("--auto-media-scan-interval", help = "Automatically scrub file data at this interval.", \
+			default = None)
+	parser.add_argument("--auto-media-scan-stamp", help = "Stamp file for automatic file data scrub.", \
+			default = '@stampfile@')
 	args = parser.parse_args()
 
 	if args.V:
 		print("xfs_scrub_all version @pkg_version@")
 		sys.exit(0)
 
-	scrub_media = args.x
+	if args.auto_media_scan_interval is not None:
+		try:
+			scrub_media = enable_automatic_media_scan(args)
+		except Exception as e:
+			print(e)
+			sys.exit(16)
+	else:
+		scrub_media = args.x
 
 	fs = find_mounts()
 
diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index f746f7b69f6..2042c9b987d 100644
--- a/scrub/xfs_scrub_all.service.in
+++ b/scrub/xfs_scrub_all.service.in
@@ -34,11 +34,13 @@ CapabilityBoundingSet=
 NoNewPrivileges=true
 RestrictSUIDSGID=true
 
-# Make the entire filesystem readonly.  We don't want to hide anything because
-# we need to find all mounted XFS filesystems in the host.
+# Make the entire filesystem readonly except for the media scan stamp file
+# directory.  We don't want to hide anything because we need to find all
+# mounted XFS filesystems in the host.
 ProtectSystem=strict
 ProtectHome=read-only
 PrivateTmp=false
+BindPaths=@pkg_state_dir@
 
 # No network access except to the systemd control socket
 PrivateNetwork=true

