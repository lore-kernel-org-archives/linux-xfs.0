Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2C7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbiLaAhl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaAhl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:37:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF241E3EE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:37:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA25F61CDB
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C25C433D2;
        Sat, 31 Dec 2022 00:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447059;
        bh=4nZtJ11DLX5lc564XkimLUgmbiYzY0OZB272KCDex0c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rVA2f348snv3MagUkzQIns38ypDhRQnJghBBj78YqirjQL99j1lGgp1RMQ5viJ69I
         RZA2fU11CJDxtPfjVCV1YH3KKUJDfC2rQq0VKPcG0G6m7bEGKbhyeGUzHE2R6YIOh3
         AObn+ygNH8m+lucOqh6wxw6hK4gcK2X8YyNUTKGRgoolENKorsNmORl4tQY9V7EHoR
         Mi5AHEZGDweHeOFXLS8MZFH/DHzP4R+59tb28CRcjfQD+L4mJO1h3S+/CV+U1PF7tL
         h6JT2n0N0ZpD/mNk0HpQqSsYt2tKAeyEv3sEhrJwScZDLR3+WfXhtFuPHqUaurCuzM
         QoX9ms+PYoJOw==
Subject: [PATCH 2/4] xfs_scrub_all: enable periodic file data scrubs
 automatically
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:38 -0800
Message-ID: <167243871819.718563.17339870560556373949.stgit@magnolia>
In-Reply-To: <167243871794.718563.17643569431631339696.stgit@magnolia>
References: <167243871794.718563.17643569431631339696.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
 scrub/xfs_scrub_all.in         |   74 +++++++++++++++++++++++++++++++++++++++-
 scrub/xfs_scrub_all.service.in |    6 ++-
 7 files changed, 106 insertions(+), 5 deletions(-)
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
index c0de6000c2a..50ebb9f75d8 100644
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
index f65148e5469..f773995dcd7 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -118,6 +118,7 @@ xfs_scrub_all: xfs_scrub_all.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
+		   -e "s|@stampfile@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
 	$(Q)chmod a+x $@
 
@@ -132,6 +133,7 @@ install: $(INSTALL_SCRUB)
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
 		   -e "s|@pkg_lib_dir@|$(PKG_LIB_SCRIPT_DIR)|g" \
+		   -e "s|@pkg_state_dir@|$(PKG_STATE_DIR)|g" \
 		   -e "s|@pkg_name@|$(PKG_NAME)|g" \
 		   < $< > $@
 
@@ -153,6 +155,7 @@ install-scrub: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 $(XFS_SCRUB_ALL_PROG) $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 -d $(PKG_STATE_DIR)
 
 install-dev:
 
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index eeb52b651b5..db307f78ebb 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -15,6 +15,10 @@ import sys
 import os
 import argparse
 from io import TextIOWrapper
+from pathlib import Path
+from datetime import timedelta
+from datetime import datetime
+from datetime import timezone
 
 retcode = 0
 terminate = False
@@ -221,6 +225,63 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		cond.notify()
 		cond.release()
 
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
+		raise Exception(f"{args.auto_media_scan_interval}: Invalid media scan interval.")
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
+
+	return res
+
 def main():
 	'''Find mounts, schedule scrub runs.'''
 	def thr(mnt, devs):
@@ -235,13 +296,24 @@ def main():
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
index c1c6012b47d..4938404ee95 100644
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

