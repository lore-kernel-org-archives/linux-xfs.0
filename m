Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052048F40
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302081; cv=none; b=ufQdQzs3JsgH6hgl0bb30dIg6d+UMLtz2cYd7ATO78IEWWntmSHJ56SSP8F/wY8UHU+BckJOT3NHsY5LmnvtOrdRXAe4+tPsO2WQn1RV4nQHbbyO+9qn1Xug03U2rKZREGgEZeQn1hTYwcoo/FKpDrhvFTMGXQvajel8YWOcgUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302081; c=relaxed/simple;
	bh=F0Z0N7fa6PShlvZPhgqIpndE5jMiy2Dv/vMTW3HifBg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n7XQcmLrq12jXk5VxdHUCy6kRuHlD7gb+sLEdajguuGMAh1W6SfGzRLXxGeXVfGRKp7b7uE9wf7DppSLHIci+9mDbfse/inOSK/f0mDgYvITYHsypcc8b74YJFRM2jdjrDZsLNqbkCftBz2S1Ce+KLA183eMm1FKqejB0UrQEtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZ/jz7LN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZ/jz7LN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C939BC32786;
	Tue, 30 Jul 2024 01:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302080;
	bh=F0Z0N7fa6PShlvZPhgqIpndE5jMiy2Dv/vMTW3HifBg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BZ/jz7LNQB/DO+CSD/w4pN/NbSSdW30PsoMdS9zbjuB3ZT35wf/aFKuxPsdQmq7bh
	 YkvGZIXPGgCBlMgPjnp1R1y/2ZcKnt2jsNCq99bf0DIF/eheIS8nl+kus8D4TGu8lo
	 zAsbC7ILN/SET0OmC002OC6utUNe0wpllLBEAPT7/c/LT9f2UK7DgncnATPa963c1s
	 om9+Tz8+7cN1x3sQqvIWw/RqUYKJUEaanVHHQNzuXIVQSWSq1a0DgRXjgG86dZtey6
	 BV8ZOXiiMSlm0piJELqP0/njPUUpckQ87mJkZ40nJAZR/WsZQypT4JVUtc7gQSVT4+
	 PRUT6f1muXqPw==
Date: Mon, 29 Jul 2024 18:14:40 -0700
Subject: [PATCH 1/6] xfs_scrub_all: only use the xfs_scrub@ systemd services
 in service mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229849261.1350165.10506383191812810534.stgit@frogsfrogsfrogs>
In-Reply-To: <172229849240.1350165.13200329618269649031.stgit@frogsfrogsfrogs>
References: <172229849240.1350165.13200329618269649031.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/Makefile              |    5 ++++-
 scrub/xfs_scrub@.service.in |    2 +-
 scrub/xfs_scrub_all.in      |   11 ++++++++---
 3 files changed, 13 insertions(+), 5 deletions(-)


diff --git a/scrub/Makefile b/scrub/Makefile
index 2a257e080..2050fe28f 100644
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
index a8dd9052f..5fa5f3282 100644
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
index d0ab27fd3..f27251fa5 100644
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

