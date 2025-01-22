Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF6338B
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 02:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737511226; cv=none; b=rz8XfiVxp9wiBmQI1SeCUIdcmsPTAIeEZNRZWb4XoI0jHVWmL0rEkT2LGmYX9u+xKg7RYRPAShgpln1ourpM/ExUwdpYuhZ4jf1dCbuqPeAJs82ix5lrxyaso1aSFOFii512vkBNO5L6p9l1k2IQFCIKvh/a9gUkOdt7jB5yqmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737511226; c=relaxed/simple;
	bh=YPZhOfbJNID2FJNGBWnATembOB47GNez6G6QvekNtWI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=p/TKuJMINRSPOA5Jt+hy4g+xdGBeS9OgCurQdtjq96aPKgXVvXsX9p6OTSpfyi53qVfdXmZPZOCE6J8XmLNni650a6Rssa+5HsCMLPcE9j5py3ZenPuMfkhvI1bXSKNGHTJ/J0Zhq2ID9bbt7QxKVxLhAz42fjWumjD/Ygg8cvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJU37b2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJU37b2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BCAC4CEDF;
	Wed, 22 Jan 2025 02:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737511225;
	bh=YPZhOfbJNID2FJNGBWnATembOB47GNez6G6QvekNtWI=;
	h=Date:From:To:Cc:Subject:From;
	b=dJU37b2SrCO5oM22ozFcRWC7qeNfrjkz5K8+d0ZdVnlB61cofsbHQRzzpiGVSqKXC
	 nmayUZ8JsCGHK5O82t3C4U5eK8FJsHWbe0Qze93M2gN8rbMWy7j0jcNYt+GuGfxo+z
	 mES+plODXk57e14pFTaxK2FB2YD3kl/tNZm/JWVDFEJS55ih9tjxle9Rj7iaiwEVOx
	 d5EBPlKPbKj7m9uvA7Vu9jDhNJ50PPteIKCpoDbc+x1AT5lDUXymmicdPa+GXW7esA
	 fdr6NyhOpd0KImPe6RgdCz98E+ridsLe9AQPHQ5vYGuxLmCPG7+qpE1f06km5hAFs/
	 7GzB0EYDFEMDg==
Date: Tue, 21 Jan 2025 18:00:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, hch@lst.de
Subject: [PATCH] xfs_scrub_all.timer: don't run if /var/lib/xfsprogs is
 readonly
Message-ID: <20250122020025.GL1611770@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

The xfs_scrub_all program wants to write a state file into the package
state dir to keep track of how recently it performed a media scan.
Don't allow the systemd timer to run if that path isn't writable.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 267ae610a3d90f ("xfs_scrub_all: enable periodic file data scrubs automatically")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/Makefile               |    6 +++++-
 scrub/xfs_scrub_all.timer.in |    3 ++-
 2 files changed, 7 insertions(+), 2 deletions(-)
 rename scrub/{xfs_scrub_all.timer => xfs_scrub_all.timer.in} (77%)

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
diff --git a/scrub/xfs_scrub_all.timer b/scrub/xfs_scrub_all.timer.in
similarity index 77%
rename from scrub/xfs_scrub_all.timer
rename to scrub/xfs_scrub_all.timer.in
index f0c557fc380391..9008f036d496c0 100644
--- a/scrub/xfs_scrub_all.timer
+++ b/scrub/xfs_scrub_all.timer.in
@@ -1,10 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 #
-# Copyright (C) 2018-2024 Oracle.  All Rights Reserved.
+# Copyright (C) 2018-2025 Oracle.  All Rights Reserved.
 # Author: Darrick J. Wong <djwong@kernel.org>
 
 [Unit]
 Description=Periodic XFS Online Metadata Check for All Filesystems
+ConditionPathIsReadWrite=@pkg_state_dir@
 
 [Timer]
 # Run on Sunday at 3:10am, to avoid running afoul of DST changes
