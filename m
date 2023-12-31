Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42652C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbE5Sq45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EE1C433C8;
	Sun, 31 Dec 2023 22:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063187;
	bh=WAPP0k6ISTdx0fyPXkGKCfnq9C7BijfZ3GTghj6ctCs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hbE5Sq45JvhD8lMeqhIS/wYu89zeoe9GU0mrRd19nFecIC5vm76pGIRBiX1U8c3/V
	 q+REfy5jO0JhhHNQWXK3dJgaco2BWi+uXmxoX9PQT01MTNSsFUE4cM9WgUXVAQ9N1f
	 jXu9GX9N7dBWgQ1ykDY3Q0n4LkrB2f9AOoo1LztiGd2xCszJ2gnMBOQU1liRsEJJUd
	 9kxSPj8zGZWd/CVKbVpsEssGADJLKW0bmmeOy7wBvkKwl4jZ1K2mmBVUCfT7WelExj
	 nEFI2cMyAbDYGP2ASM2M+l72AEhu6l7hzPeoSHmkpYKWBCjzN8BBmGUf4KOVMcfHuK
	 8fKEKBTW9Nr5Q==
Date: Sun, 31 Dec 2023 14:53:07 -0800
Subject: [PATCH 3/9] xfs_scrub: fix pathname escaping across all service
 definitions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405001885.1800712.12823520124308059411.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/Makefile                   |   19 +++++++++++++++----
 scrub/xfs_scrub@.service.in      |    6 +++---
 scrub/xfs_scrub_all.in           |   33 +++++++++++----------------------
 scrub/xfs_scrub_fail.in          |    5 ++++-
 scrub/xfs_scrub_fail@.service.in |    4 ++--
 5 files changed, 35 insertions(+), 32 deletions(-)
 rename scrub/{xfs_scrub_fail => xfs_scrub_fail.in} (75%)


diff --git a/scrub/Makefile b/scrub/Makefile
index af94cf0d684..fd47b893956 100644
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
@@ -108,17 +111,25 @@ ifeq ($(HAVE_HDIO_GETGEO),yes)
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
@@ -141,7 +152,7 @@ install-systemd: default $(SYSTEMD_SERVICES)
 	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
 	$(INSTALL) -m 644 $(SYSTEMD_SERVICES) $(SYSTEMD_SYSTEM_UNIT_DIR)
 	$(INSTALL) -m 755 -d $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
-	$(INSTALL) -m 755 xfs_scrub_fail $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
+	$(INSTALL) -m 755 $(XFS_SCRUB_FAIL_PROG) $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
 
 install-crond: default $(CRONTABS)
 	$(INSTALL) -m 755 -d $(CROND_DIR)
diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index d878eeda4fd..043aad12f20 100644
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
index 85f95f135cc..d7d36e1bdb0 100644
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
index 415efaa24d6..0bceda6403d 100755
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
index 187adc17f6d..048b5732459 100644
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

