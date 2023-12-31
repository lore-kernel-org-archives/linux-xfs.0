Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6C5C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MW3ff7Yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7A3C433C8;
	Sun, 31 Dec 2023 22:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063516;
	bh=cREqmF11WOSgj3dv3C1Z5rvCR+vlsPycL3IviEbUH6o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MW3ff7Yz9yUOdrKNUixF4vZvDBHzcVloY/ttT0GcTiBbeUQwlskvpY6341MzV3PYv
	 6+ZUZPU9ETykZDL2WiQlL66/jAFfZF01GX5zs6x38VZaYt3FImmST+xr6b8vZUJC6f
	 vlbzg22LiC3LeqkuGQldmmlCzSenWXALrr5JKLu4cnO+0Nw6fwhGMgciqrdsc6OBBO
	 1VmYUDxDZKbPGVvURwc+e0k2w/iPGKVXEgun0Uiz4Ew/ArROTbfouss7va3VNwPl6s
	 SC6yjN6s3M44Q60TyHc1B0jVwrVwWu6SAng1Im6gN4Nwo0PQ21Nj0fVEz64HokUZC/
	 RyiywFniWKoNQ==
Date: Sun, 31 Dec 2023 14:58:35 -0800
Subject: [PATCH 5/6] xfs_scrub_all: trigger automatic media scans once per
 month
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405003044.1801496.10016485559976748652.stgit@frogsfrogsfrogs>
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

Teach the xfs_scrub_all background service to trigger an automatic scan
of all file data once per month.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile                 |    8 +++++++-
 scrub/xfs_scrub_all.cron.in    |    2 +-
 scrub/xfs_scrub_all.service.in |    2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)


diff --git a/scrub/Makefile b/scrub/Makefile
index 4c7bbb30d20..7bd3a355478 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -120,6 +120,9 @@ ifeq ($(HAVE_HDIO_GETGEO),yes)
 LCFLAGS += -DHAVE_HDIO_GETGEO
 endif
 
+# Automatically trigger a media scan once per month
+XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL=1mo
+
 LDIRT = $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) *.service *.cron
 
 default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) $(OPTIONAL_TARGETS)
@@ -155,11 +158,14 @@ install: $(INSTALL_SCRUB)
 		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
 		   -e "s|@pkg_libexec_dir@|$(PKG_LIBEXEC_DIR)|g" \
 		   -e "s|@pkg_state_dir@|$(PKG_STATE_DIR)|g" \
+		   -e "s|@media_scan_interval@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL)|g" \
 		   < $< > $@
 
 %.cron: %.cron.in $(builddefs)
 	@echo "    [SED]    $@"
-	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" < $< > $@
+	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
+		   -e "s|@media_scan_interval@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL)|g" \
+		   < $< > $@
 
 install-systemd: default $(SYSTEMD_SERVICES)
 	$(INSTALL) -m 755 -d $(SYSTEMD_SYSTEM_UNIT_DIR)
diff --git a/scrub/xfs_scrub_all.cron.in b/scrub/xfs_scrub_all.cron.in
index c4d36958e76..650e0ca92b8 100644
--- a/scrub/xfs_scrub_all.cron.in
+++ b/scrub/xfs_scrub_all.cron.in
@@ -3,4 +3,4 @@
 # Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
 # Author: Darrick J. Wong <djwong@kernel.org>
 #
-10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all
+10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all --auto-media-scan-interval @media_scan_interval@
diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index 2042c9b987d..7cfe3a1bc42 100644
--- a/scrub/xfs_scrub_all.service.in
+++ b/scrub/xfs_scrub_all.service.in
@@ -12,7 +12,7 @@ After=paths.target multi-user.target network.target network-online.target system
 [Service]
 Type=oneshot
 Environment=SERVICE_MODE=1
-ExecStart=@sbindir@/xfs_scrub_all
+ExecStart=@sbindir@/xfs_scrub_all --auto-media-scan-interval @media_scan_interval@
 SyslogIdentifier=xfs_scrub_all
 
 # Create the service underneath the scrub background service slice so that we

