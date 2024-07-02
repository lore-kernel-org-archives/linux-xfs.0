Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E471A8479
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882392; cv=none; b=dexWZ4Zjz9c3pDBNnyyia9MXgdJrYDUqGhN/Fdvv/2p7++xPvJweDwIyayzfRIg+/HVC5FJhmE5GhKaSEwIr7Q7mg08Ie+AS7cWyQoaWRVOOYczAez+hjqMmeoVFEuEccn1J2J6gNjCnqF4sLPopIffj+nzZdoR+SlrrOM7iO3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882392; c=relaxed/simple;
	bh=c4Dpv6Xmpw2savvClgcUf2oFyT7M0yRBvu/RApaefGs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FNmOuwPenEgj1W9xb+1gQJ1m7K00HucMmFyq7nBtBym5Ayaup16iU8mQoQdsV97hnMMe6PTlEgy1s6gtj+LApSpV2aLgeztsPCI5K53CYttiT8adDl17yhK47sbVxdobgcn6uJ28heCoB/U9oxnMmPVuxXA+XQ00UE0NewtGpaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g68LvcHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g68LvcHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8381C116B1;
	Tue,  2 Jul 2024 01:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882391;
	bh=c4Dpv6Xmpw2savvClgcUf2oFyT7M0yRBvu/RApaefGs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g68LvcHoqBwM+q3dxnEDcge64wfOaiqmOkdQ91FHuw2B2YRNgpEZ4pzSNYk3Udnyt
	 3XsNWeo+TEmDyxeSyCAWMB2mvMI5eTDvm+6c/e8k8PWjFgLzVwrXOqkDp20hmhr5fn
	 UZdzWEkq7V739CQJNZKChhFecFPLwKbaIpO8cDzX4AQk0Ma1W1808Of5mlzMTYuRHE
	 vreChtShsJutR8OFP4Z++00Mer79KA4QO+aQhNfB4rEl1Q3VMJ9r76zp0LLOe4oHd2
	 kknLnEfi0MbMSzFSXYw7W4Pmr7RGPqq/2gwa8b3X89ezZWnQlHoBYCsrEhyd5j5kuF
	 DvVzrVWJ7gZGA==
Date: Mon, 01 Jul 2024 18:06:31 -0700
Subject: [PATCH 1/6] xfs_scrub_all: only use the xfs_scrub@ systemd services
 in service mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119423.2008463.11698354867151927273.stgit@frogsfrogsfrogs>
In-Reply-To: <171988119402.2008463.10432604765226555660.stgit@frogsfrogsfrogs>
References: <171988119402.2008463.10432604765226555660.stgit@frogsfrogsfrogs>
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
index 2a257e0805cd..2050fe28fc75 100644
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
@@ -113,6 +114,7 @@ xfs_scrub_all: xfs_scrub_all.in $(builddefs)
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
+		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
 	$(Q)chmod a+x $@
 
@@ -132,6 +134,7 @@ install: $(INSTALL_SCRUB)
 %.service: %.service.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
+		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
 		   -e "s|@pkg_libexec_dir@|$(PKG_LIBEXEC_DIR)|g" \
 		   < $< > $@
diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index a8dd9052f0e0..5fa5f328200e 100644
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
index d0ab27fd3060..f27251fa5439 100644
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

