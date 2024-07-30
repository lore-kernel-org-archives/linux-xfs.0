Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D354628EB
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302143; cv=none; b=m7wOaKkxZlY1Ccx95upSLK0yVjPNaDlfA39lT0BheHx104oczO+dEyObtQyatSYVKhU7TTHIWjzHoMFqK2TWGr2DkDC087wkQKZTBNLDDG6MTrPcZQkrX2Kc8U2pDE8GhqIn192NRZZKNRvTabq7sln327YOvdKfAOMbaWrEJEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302143; c=relaxed/simple;
	bh=PoKvsvQx3iu+GW6wML8A7+WLfUMfZEr/9Rfh3UYJcyU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KfCOIFSxnyt0x2JxrAOnOusp1gSBkHRvajDlbN3ICd3s7WC8DbAYB5HSEyNDzenem+nv2ZR7Tj/UyFmIw5t4VCN/DZRuuTSn1uUn6jxVsp6me9ghGuf5piK6MfhWfBPynLmJzheF2cnLg9k8a6WkIaKNqtNG5ouSD1aGqC75K2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evdSIUWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evdSIUWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE66C32786;
	Tue, 30 Jul 2024 01:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302143;
	bh=PoKvsvQx3iu+GW6wML8A7+WLfUMfZEr/9Rfh3UYJcyU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=evdSIUWS1JAugRnKbiaD9Tvv89NKu0v+UCo2ptkz4ALeJNoBcbNZ2b/hAaEY8xxu2
	 u5wSMiocZyWcBIEBHVnkJDJlbjurNdgIc6kPCz0ScULTBMIoXuNnWxWgXvUIzCk6A+
	 XgP2+owLNtjHI44uL3X1YynToY62bqMTvY8Qfo8L+2JSgJq31ldbfQZlJHr6C57wH9
	 wx1UnI5BbrnoM0Qiw8Z4k5fSRnt/sU6TkaXXcCovZveZxlnCeixm6uhsehejmMcbZS
	 k58YNf4n9iB+wMLrEK2vV2beuxnMnS2lggV6XKdqEqh5TcmPFZVhjG89Jtigpeptvk
	 wuy5cblP+vaCA==
Date: Mon, 29 Jul 2024 18:15:42 -0700
Subject: [PATCH 5/6] xfs_scrub_all: trigger automatic media scans once per
 month
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229849322.1350165.1379324570551390512.stgit@frogsfrogsfrogs>
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

Teach the xfs_scrub_all background service to trigger an automatic scan
of all file data once per month.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/Makefile                 |    8 +++++++-
 scrub/xfs_scrub_all.cron.in    |    2 +-
 scrub/xfs_scrub_all.service.in |    2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)


diff --git a/scrub/Makefile b/scrub/Makefile
index 091a5c94b..0e09ed127 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -108,6 +108,9 @@ CFILES += unicrash.c
 LCFLAGS += -DHAVE_LIBICU $(LIBICU_CFLAGS)
 endif
 
+# Automatically trigger a media scan once per month
+XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL=1mo
+
 LDIRT = $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) *.service *.cron
 
 default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) $(OPTIONAL_TARGETS)
@@ -143,11 +146,14 @@ install: $(INSTALL_SCRUB)
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
index e08a9daf9..e6633e091 100644
--- a/scrub/xfs_scrub_all.cron.in
+++ b/scrub/xfs_scrub_all.cron.in
@@ -3,4 +3,4 @@
 # Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
 # Author: Darrick J. Wong <djwong@kernel.org>
 #
-10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all
+10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all --auto-media-scan-interval @media_scan_interval@
diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index 9ecc3af0c..8ed682989 100644
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

