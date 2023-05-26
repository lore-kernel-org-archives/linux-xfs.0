Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EC8C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjEZBxR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjEZBxQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:53:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA8318D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:53:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFEF661B63
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F576C433EF;
        Fri, 26 May 2023 01:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065994;
        bh=CKaqqFUa9VItpKU8fobegZDBfwpbBS5vwFYDuX41bkQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=r6U8YCbjXhw8bRvJ8vLfLyTa80h9sg4SxKTq/WgyVEObnDYDOQ3fpzUssJ3m6Jfty
         YaydVB6c/upd4aGR0R7D7gEerqZ5TpEAJmjjyk+TJMD1OmvkaG0Appvl1Sg7DPrFd7
         cRjKdD1tBoTOhokqGYsGeFzY3AS4tx1pXQvGEU+3z/LlinUXKW5u9CKbcGvPxmANmz
         aKZzKuGGdpgvaJI9nPdTdmnno7c+kG6N1YG23cXZO/sFsHOy9drNipVZmrOIOPs8zR
         H+e0oUffxqP0n94ukicuchTOzriODzw+GTomIpVjoayQ+Vaem1hnwp/WULz1iY9m2J
         XnAdRaA9S/SIw==
Date:   Thu, 25 May 2023 18:53:13 -0700
Subject: [PATCH 3/5] xfs_scrub: fix pathname escaping across all service
 definitions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073873.3745766.7019908892401637437.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
References: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

systemd services provide an "instance name" that can be associated with
a particular invocation of a service.  This allows service users to
invoke multiple copies of a service, each with a unique string.  For
xfs_scrub, we pass the mountpoint of the filesystem as the instance
name.  However, systemd services aren't supposed to have slashes in
them, so we're supposed to escape them.

The canonical escaping scheme for pathnames is defined by the
systemd-escape --path command.  Unfortunately, we've been adding our own
opinionated sauce for years, to work around the fact that --path didn't
exist in systemd before January 2017.  The special sauce is incorrect,
and we no longer care about systemd of 7 years past.

Clean up this mess by following the systemd escaping scheme throughout
the service units.  Now we can use the '%f' specifier in them, which
makes things a lot less complicated.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile                   |   19 +++++++++++++++----
 scrub/xfs_scrub@.service.in      |    6 +++---
 scrub/xfs_scrub_all.in           |   33 +++++++++++----------------------
 scrub/xfs_scrub_fail.in          |    5 ++++-
 scrub/xfs_scrub_fail@.service.in |    4 ++--
 5 files changed, 35 insertions(+), 32 deletions(-)
 rename scrub/{xfs_scrub_fail => xfs_scrub_fail.in} (75%)


diff --git a/scrub/Makefile b/scrub/Makefile
index f6f8ebdc814..0cba97dcddc 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -8,14 +8,17 @@ include $(builddefs)
 
 SCRUB_PREREQS=$(HAVE_OPENAT)$(HAVE_FSTATAT)$(HAVE_GETFSMAP)
 
+scrub_svcname=xfs_scrub@.service
+
 ifeq ($(SCRUB_PREREQS),yesyesyes)
 LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all
+XFS_SCRUB_FAIL_PROG = xfs_scrub_fail
 XFS_SCRUB_ARGS = -b -n
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
-SYSTEMD_SERVICES = xfs_scrub@.service xfs_scrub_all.service xfs_scrub_all.timer xfs_scrub_fail@.service
+SYSTEMD_SERVICES = $(scrub_svcname) xfs_scrub_all.service xfs_scrub_all.timer xfs_scrub_fail@.service
 OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
 endif
 ifeq ($(HAVE_CROND),yes)
@@ -103,17 +106,25 @@ ifeq ($(HAVE_HDIO_GETGEO),yes)
 LCFLAGS += -DHAVE_HDIO_GETGEO
 endif
 
-LDIRT = $(XFS_SCRUB_ALL_PROG) *.service *.cron
+LDIRT = $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) *.service *.cron
 
-default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(OPTIONAL_TARGETS)
+default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) $(OPTIONAL_TARGETS)
 
 xfs_scrub_all: xfs_scrub_all.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
+		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
 	$(Q)chmod a+x $@
 
+xfs_scrub_fail: xfs_scrub_fail.in $(builddefs)
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
+		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
+		   -e "s|@pkg_version@|$(PKG_VERSION)|g"  < $< > $@
+	$(Q)chmod a+x $@
+
 phase5.o unicrash.o xfs.o: $(builddefs)
 
 include $(BUILDRULES)
@@ -136,7 +147,7 @@ install-systemd: default $(SYSTEMD_SERVICES)
 	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
 	$(INSTALL) -m 644 $(SYSTEMD_SERVICES) $(SYSTEMD_SYSTEM_UNIT_DIR)
 	$(INSTALL) -m 755 -d $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
-	$(INSTALL) -m 755 xfs_scrub_fail $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
+	$(INSTALL) -m 755 $(XFS_SCRUB_FAIL_PROG) $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
 
 install-crond: default $(CRONTABS)
 	$(INSTALL) -m 755 -d $(CROND_DIR)
diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index 2eb6be8fee2..81ca2043a82 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -4,7 +4,7 @@
 # Author: Darrick J. Wong <djwong@kernel.org>
 
 [Unit]
-Description=Online XFS Metadata Check for %I
+Description=Online XFS Metadata Check for %f
 OnFailure=xfs_scrub_fail@%i.service
 Documentation=man:xfs_scrub(8)
 
@@ -13,7 +13,7 @@ Type=oneshot
 PrivateNetwork=true
 ProtectSystem=full
 ProtectHome=read-only
-# Disable private /tmp just in case %i is a path under /tmp.
+# Disable private /tmp just in case %f is a path under /tmp.
 PrivateTmp=no
 AmbientCapabilities=CAP_SYS_ADMIN CAP_FOWNER CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_SYS_RAWIO
 NoNewPrivileges=yes
@@ -21,5 +21,5 @@ User=nobody
 IOSchedulingClass=idle
 CPUSchedulingPolicy=idle
 Environment=SERVICE_MODE=1
-ExecStart=@sbindir@/xfs_scrub @scrub_args@ %I
+ExecStart=@sbindir@/xfs_scrub @scrub_args@ %f
 SyslogIdentifier=%N
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index d4cb9bc7bb7..060d8f66bfc 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -81,29 +81,18 @@ def run_killable(cmd, stdout, killfuncs, kill_fn):
 		return -1
 
 # systemd doesn't like unit instance names with slashes in them, so it
-# replaces them with dashes when it invokes the service.  However, it's not
-# smart enough to convert the dashes to something else, so when it unescapes
-# the instance name to feed to xfs_scrub, it turns all dashes into slashes.
-# "/moo-cow" becomes "-moo-cow" becomes "/moo/cow", which is wrong.  systemd
-# actually /can/ escape the dashes correctly if it is told that this is a path
-# (and not a unit name), but it didn't do this prior to January 2017, so fix
-# this for them.
-#
-# systemd path escaping also drops the initial slash so we add that back in so
-# that log messages from the service units preserve the full path and users can
-# look up log messages using full paths.  However, for "/" the escaping rules
-# do /not/ drop the initial slash, so we have to special-case that here.
-def path_to_service(path):
-	'''Escape a path to avoid mangled systemd mangling.'''
+# replaces them with dashes when it invokes the service.  Filesystem paths
+# need a special --path argument so that dashes do not get mangled.
+def path_to_serviceunit(path):
+	'''Convert a pathname into a systemd service unit name.'''
 
-	if path == '/':
-		return 'xfs_scrub@-'
-	cmd = ['systemd-escape', '--path', path]
+	cmd = ['systemd-escape', '--template', '@scrub_svcname@',
+	       '--path', path]
 	try:
 		proc = subprocess.Popen(cmd, stdout = subprocess.PIPE)
 		proc.wait()
 		for line in proc.stdout:
-			return 'xfs_scrub@-%s' % line.decode(sys.stdout.encoding).strip()
+			return line.decode(sys.stdout.encoding).strip()
 	except:
 		return None
 
@@ -119,11 +108,11 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 			return
 
 		# Try it the systemd way
-		svcname = path_to_service(path)
-		if svcname is not None:
-			cmd=['systemctl', 'start', svcname]
+		unitname = path_to_serviceunit(path)
+		if unitname is not None:
+			cmd=['systemctl', 'start', unitname]
 			ret = run_killable(cmd, DEVNULL(), killfuncs, \
-					lambda proc: kill_systemd(svcname, proc))
+					lambda proc: kill_systemd(unitname, proc))
 			if ret == 0 or ret == 1:
 				print("Scrubbing %s done, (err=%d)" % (mnt, ret))
 				sys.stdout.flush()
diff --git a/scrub/xfs_scrub_fail b/scrub/xfs_scrub_fail.in
similarity index 75%
rename from scrub/xfs_scrub_fail
rename to scrub/xfs_scrub_fail.in
index a1bc3b802ff..b154202815b 100755
--- a/scrub/xfs_scrub_fail
+++ b/scrub/xfs_scrub_fail.in
@@ -19,6 +19,9 @@ if [ ! -x "${mailer}" ]; then
 	exit 1
 fi
 
+# Turn the mountpoint into a properly escaped systemd instance name
+scrub_svc="$(systemd-escape --template "@scrub_svcname@" --path "${mntpoint}")"
+
 (cat << ENDL
 To: $1
 From: <xfs_scrub@${hostname}>
@@ -28,4 +31,4 @@ So sorry, the automatic xfs_scrub of ${mntpoint} on ${hostname} failed.
 
 A log of what happened follows:
 ENDL
-systemctl status --full --lines 4294967295 "xfs_scrub@${mntpoint}") | "${mailer}" -t -i
+systemctl status --full --lines 4294967295 "${scrub_svc}") | "${mailer}" -t -i
diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
index 255d272e4cd..93e06a74410 100644
--- a/scrub/xfs_scrub_fail@.service.in
+++ b/scrub/xfs_scrub_fail@.service.in
@@ -4,13 +4,13 @@
 # Author: Darrick J. Wong <djwong@kernel.org>
 
 [Unit]
-Description=Online XFS Metadata Check Failure Reporting for %I
+Description=Online XFS Metadata Check Failure Reporting for %f
 Documentation=man:xfs_scrub(8)
 
 [Service]
 Type=oneshot
 Environment=EMAIL_ADDR=root
-ExecStart=@pkg_lib_dir@/@pkg_name@/xfs_scrub_fail "${EMAIL_ADDR}" %I
+ExecStart=@pkg_lib_dir@/@pkg_name@/xfs_scrub_fail "${EMAIL_ADDR}" %f
 User=mail
 Group=mail
 SupplementaryGroups=systemd-journal

