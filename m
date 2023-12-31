Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC3CC127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CfdwW7Tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C716C433C7;
	Sun, 31 Dec 2023 22:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063453;
	bh=yH59EttXmve9GQc76N5Q7AnzSXEY+Agxe1TilRnqJJc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CfdwW7TrLv6ClZZR8r0Dg3CY1+juVJsxyZ8ZsERZRP/OJJYzjX/AcupeImdJCqOjC
	 +4Teu0YqXAamhtLCDlp6iLQ0RdddQJElOd6PjREicTDcp5zkGl2sZS52srLEaatNUy
	 KrEsYoIlNu1Uf/GD8ocjAgEY0rfvPk1DG5LfUshaEFi9vvMj7fVMjyD6J65A98X26Q
	 0F5wbOlEuub3twHsnFDHpKCy0gLYqoWeGcJvulyxIjA4vZe4Kg00/6+Y6yFh2iMyzb
	 kVeLKEJDjWazeX3ypuijDwCLMpWhggyzQbZkv6Q1kbi0H8+9quYMofPvR8LzV2uEyv
	 eMQhMZamjVG2Q==
Date: Sun, 31 Dec 2023 14:57:33 -0800
Subject: [PATCH 1/6] xfs_scrub_all: only use the xfs_scrub@ systemd services
 in service mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405002993.1801496.11627094491950853759.stgit@frogsfrogsfrogs>
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

Since the per-mount xfs_scrub@.service definition includes a bunch of
resource usage constraints, we no longer want to use those services if
xfs_scrub_all is being run directly by the sysadmin (aka not in service
mode) on the presumption that sysadmins want answers as quickly as
possible.

Therefore, only try to call the systemd service from xfs_scrub_all if
SERVICE_MODE is set in the environment.  If reaching out to systemd
fails and we're in service mode, we still want to run xfs_scrub
directly.  Split the makefile variables as necessary so that we only
pass -b to xfs_scrub in service mode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile              |    5 ++++-
 scrub/xfs_scrub@.service.in |    2 +-
 scrub/xfs_scrub_all.in      |   11 ++++++++---
 3 files changed, 13 insertions(+), 5 deletions(-)


diff --git a/scrub/Makefile b/scrub/Makefile
index 42b27bfcad7..53a83ff8efb 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -15,7 +15,8 @@ LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all
 XFS_SCRUB_FAIL_PROG = xfs_scrub_fail
-XFS_SCRUB_ARGS = -b -n
+XFS_SCRUB_ARGS = -n
+XFS_SCRUB_SERVICE_ARGS = -b
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
@@ -125,6 +126,7 @@ xfs_scrub_all: xfs_scrub_all.in $(builddefs)
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
+		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
 	$(Q)chmod a+x $@
 
@@ -144,6 +146,7 @@ install: $(INSTALL_SCRUB)
 %.service: %.service.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
+		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
 		   -e "s|@pkg_libexec_dir@|$(PKG_LIBEXEC_DIR)|g" \
 		   < $< > $@
diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index d834f26bd53..10cc135e691 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -22,7 +22,7 @@ RequiresMountsFor=%f
 [Service]
 Type=oneshot
 Environment=SERVICE_MODE=1
-ExecStart=@sbindir@/xfs_scrub @scrub_args@ -M /tmp/scrub/ %f
+ExecStart=@sbindir@/xfs_scrub @scrub_service_args@ @scrub_args@ -M /tmp/scrub/ %f
 SyslogIdentifier=%N
 
 # Run scrub with minimal CPU and IO priority so that nothing else will starve.
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index d0ab27fd306..f27251fa543 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -162,9 +162,10 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		if terminate:
 			return
 
-		# Try it the systemd way
+		# Run per-mount systemd xfs_scrub service only if we ourselves
+		# are running as a systemd service.
 		unitname = path_to_serviceunit(path)
-		if unitname is not None:
+		if unitname is not None and 'SERVICE_MODE' in os.environ:
 			ret = systemctl_start(unitname, killfuncs)
 			if ret == 0 or ret == 1:
 				print("Scrubbing %s done, (err=%d)" % (mnt, ret))
@@ -175,8 +176,12 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 			if terminate:
 				return
 
-		# Invoke xfs_scrub manually
+		# Invoke xfs_scrub manually if we're running in the foreground.
+		# We also permit this if we're running as a cronjob where
+		# systemd services are unavailable.
 		cmd = ['@sbindir@/xfs_scrub']
+		if 'SERVICE_MODE' in os.environ:
+			cmd += '@scrub_service_args@'.split()
 		cmd += '@scrub_args@'.split()
 		cmd += [mnt]
 		ret = run_killable(cmd, None, killfuncs)

