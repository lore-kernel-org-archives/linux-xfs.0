Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB101D7E31
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 21:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013795; cv=none; b=Y0HgYD8g67G7P9UAgtFBXxZ7jSTR70Ex9Qo//OTjhUpHu6CqoE9mqxpd6h3BXbzSZlTJYtaIEzSSIpk/XZoP/k98rfENewe/3oIZvNDBdeyPkzuVuHyoO30LI/kIg+dAdBFb6EtMgjaetuRrxQjs4Gztcq1nk2zQlcdlbI04kDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013795; c=relaxed/simple;
	bh=iKaZMKP7+odSOYjqN0idLV75zfw6DKwDuqeUpcez4U0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOx6aHZ3nVsfsOcOuWWD2CUX4hWQwRrKNmOAn2Gv7TUg5UrZQTHqIpl05jDK3HVdS9oXyYH08XpR9pUfiPnJKGY/pEOfScpzSadE7V1BXoz9YavJgJftmQy18bIok+nx1wVAn51jplpAYOoyIapQwCQ+ra+McnHly3A8OB8xWkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UMAN5S77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UMAN5S77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9E1C4CED2;
	Mon, 27 Jan 2025 21:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738013795;
	bh=iKaZMKP7+odSOYjqN0idLV75zfw6DKwDuqeUpcez4U0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UMAN5S773yNTW+80ye4TtEObkyTdbIdcV1kyLRqdtMpiHyPzgU3KlYkGdsNtRw6Bh
	 vchHkNJW6TdZkgw9oJ6UAAuDlhgkURzBSOzFbjcbrYJpTzzuAcLfmXQ1e/TRs21Jnx
	 8lZyEDM5aEgb/Sy6ktGPZjtU/6l1zjfKqUD0PWjrkLWqndsb1uSXlsgIFwB62bqV1q
	 Tnr+JsUUgipHBUFBa97R6/RcwnXv2Jx9bbYw8U6RFMJvbOVgO/hTjhporpvGIU88ny
	 T6XFHiQQB5JX7occxxrwCBtvKRlerEPzP4aKtaBYmbNpmuA+B3EJTKN37DPyHQkoz/
	 VdrDk0JIWbtGQ==
Date: Mon, 27 Jan 2025 13:36:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, hch@lst.de
Subject: [PATCH v2] xfs_scrub_all.timer: don't run if /var/lib/xfsprogs is
 readonly
Message-ID: <20250127213634.GJ1611770@frogsfrogsfrogs>
References: <20250122020025.GL1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122020025.GL1611770@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

The xfs_scrub_all program wants to write a state file into the package
state dir to keep track of how recently it performed a media scan.
Don't allow the systemd timer to run if that path isn't writable.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 267ae610a3d90f ("xfs_scrub_all: enable periodic file data scrubs automatically")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v2: add some comments to timer file
---
 scrub/Makefile               |    6 +++++-
 scrub/xfs_scrub_all.timer    |   16 ----------------
 scrub/xfs_scrub_all.timer.in |   23 +++++++++++++++++++++++
 3 files changed, 28 insertions(+), 17 deletions(-)
 delete mode 100644 scrub/xfs_scrub_all.timer
 create mode 100644 scrub/xfs_scrub_all.timer.in

diff --git a/scrub/Makefile b/scrub/Makefile
index 1e1109048c2a83..934b9062651bf1 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -108,10 +108,14 @@ endif
 # Automatically trigger a media scan once per month
 XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL=1mo
 
-LDIRT = $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) *.service *.cron
+LDIRT = $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) *.service *.cron xfs_scrub_all.timer
 
 default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(XFS_SCRUB_FAIL_PROG) $(OPTIONAL_TARGETS)
 
+xfs_scrub_all.timer: xfs_scrub_all.timer.in $(builddefs)
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@pkg_state_dir@|$(PKG_STATE_DIR)|g" < $< > $@
+
 xfs_scrub_all: xfs_scrub_all.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
diff --git a/scrub/xfs_scrub_all.timer b/scrub/xfs_scrub_all.timer
deleted file mode 100644
index f0c557fc380391..00000000000000
--- a/scrub/xfs_scrub_all.timer
+++ /dev/null
@@ -1,16 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-or-later
-#
-# Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
-# Author: Darrick J. Wong <djwong@kernel.org>
-
-[Unit]
-Description=Periodic XFS Online Metadata Check for All Filesystems
-
-[Timer]
-# Run on Sunday at 3:10am, to avoid running afoul of DST changes
-OnCalendar=Sun *-*-* 03:10:00
-RandomizedDelaySec=60
-Persistent=true
-
-[Install]
-WantedBy=timers.target
diff --git a/scrub/xfs_scrub_all.timer.in b/scrub/xfs_scrub_all.timer.in
new file mode 100644
index 00000000000000..a6bde69e947e23
--- /dev/null
+++ b/scrub/xfs_scrub_all.timer.in
@@ -0,0 +1,23 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Copyright (C) 2018-2025 Oracle.  All Rights Reserved.
+# Author: Darrick J. Wong <djwong@kernel.org>
+
+[Unit]
+Description=Periodic XFS Online Metadata Check for All Filesystems
+
+# The xfs_scrub_all program records the last time that it performed a media
+# scan in @pkg_state_dir@.  If this path is not writable, the program
+# aborts and systemd records this as a failure.  Disable the timer if the path
+# is not writable.  This should be an uncommon situation since most
+# readonly-root systems set that up to be writable (and possibly volatile).
+ConditionPathIsReadWrite=@pkg_state_dir@
+
+[Timer]
+# Run on Sunday at 3:10am, to avoid running afoul of DST changes
+OnCalendar=Sun *-*-* 03:10:00
+RandomizedDelaySec=60
+Persistent=true
+
+[Install]
+WantedBy=timers.target
