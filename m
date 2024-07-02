Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF4E9449
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882454; cv=none; b=lkzyuA9ibnt7nh5lct27AL/ajDrRNJ8geohmQIoPg4MT7fbPxRSjuMse/0uPSGWRY7jz/2J5shNb7O2IbLVv/a+3t3NgdBFYpbMTgzhxOturWkPFg3M4TTkhsRVRBffx24FgMVON9MTS5PO9coYSBmozTdvLyivwoBZKeH4zd28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882454; c=relaxed/simple;
	bh=4+R1Q2bAGC2xE7hAEm3oqp2ncRFlEbNW5E2lo21U50s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hp9p2Mjt6+2hprLP0Gt5jdZhc8n6eUZMR5xXDjNwUK6ZQOCcs9tMSJV3qghgSJkl5x3wXRm7rKXikaYYbiY7brN11/WfbdSaRGCA50i++a9Tr5EXB5i8Z/J0B+HXFTJjbi3xYVjX5ZqXj2+Ba+99KCgmnD5eEltyNA9PMA2aehU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KUyB7pMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUyB7pMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B41C116B1;
	Tue,  2 Jul 2024 01:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882454;
	bh=4+R1Q2bAGC2xE7hAEm3oqp2ncRFlEbNW5E2lo21U50s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KUyB7pMRC5MKSjl9zaUMXA1NaJfWTDEMypONIUG4pWOxzoPTChaxHiw/+RI1QKo4P
	 tcLe0g+RQdYzuuYpXvGlHEYlDVx01yu6KFGuKfCxlRn4zBUY0wR2oNaCHqZzpQIeHZ
	 EVE/kNVQVZ/YgRwyYFICEisPkjWlqzEBaZPSSUrPzeUfg8MxThPWDRSv8aeEvpBrmC
	 UVxL77IPGwLVBfwK3Qp+UepVqULeQEEnLYk87czcSv8rsIF+Umo62qrf36cezIm3iT
	 Sqt5KpXHBpCfKJLe5ea/VxWjNZmvKKIo4j3qBqZ4Xlb8tN5ahoVAH3KxV0hYTXZUdu
	 Fy5OKYHN5NAYA==
Date: Mon, 01 Jul 2024 18:07:33 -0700
Subject: [PATCH 5/6] xfs_scrub_all: trigger automatic media scans once per
 month
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119485.2008463.18281382305199915261.stgit@frogsfrogsfrogs>
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

Teach the xfs_scrub_all background service to trigger an automatic scan
of all file data once per month.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile                 |    8 +++++++-
 scrub/xfs_scrub_all.cron.in    |    2 +-
 scrub/xfs_scrub_all.service.in |    2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)


diff --git a/scrub/Makefile b/scrub/Makefile
index 091a5c94baa1..0e09ed127b82 100644
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
index e08a9daf9259..e6633e091c42 100644
--- a/scrub/xfs_scrub_all.cron.in
+++ b/scrub/xfs_scrub_all.cron.in
@@ -3,4 +3,4 @@
 # Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
 # Author: Darrick J. Wong <djwong@kernel.org>
 #
-10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all
+10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all --auto-media-scan-interval @media_scan_interval@
diff --git a/scrub/xfs_scrub_all.service.in b/scrub/xfs_scrub_all.service.in
index 9ecc3af0c1f6..8ed682989048 100644
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

