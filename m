Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A7D1854
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309772; cv=none; b=tjg4FOZ22xUT1d5KVeUuD/VqEnUdNVt/NSBg6WTVO5TLFgH6JZF5g5xI2hn+abZge/3rZDpLTJgpkhMk4cQGj/saNPZyuOXPUmayitsnM9nvfo/cXr7wpopBmzB73SimaajUmgGJHri3BZKczxTAUfrQ5vbdHTc6oa7S3Jd7YFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309772; c=relaxed/simple;
	bh=2m/hE3Ml48X65EVuMVNhDQbet/3EvvvdAO4kJg8xkHA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aunqxH5SKft6evPTlgBeJfWWzc1+fc9VoDsTULADQwUCsp7yGKdscrNKOOk0jRHi8FBQoAJ5G4lL/RU4PCpbNgO2tZ3YcJ8JXQjiAlqvRz9osMAyXnb8QzIQ636RfVEQrdMKPfHyf9Y4dBPgDV0QL+Hi5ea54aBi0bcqHnOe4jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgTlMw3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgTlMw3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8167C32786;
	Tue, 30 Jul 2024 03:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309771;
	bh=2m/hE3Ml48X65EVuMVNhDQbet/3EvvvdAO4kJg8xkHA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KgTlMw3GTdgSYij8wlhxrTQGDTaLedFAZ2YkCJjSNjkt883sYFxoVWPXZ38wOBNJs
	 JBdhpYLJ2qcAidtqh3EiwfC4zoMWQSjDaoHIj/f5fWjKZGg/frmGvshPse2h+pSBpA
	 TPIlMDVLnrBbXZFUKjB/vfyyHSx5SkBqo3gDoocxZciBy1xdlh0QrO0ZvrbGXA/1iw
	 ZoZJLkdS43srt8Fh0BMWG+WKNMMUKic6CkaCI+HQ4+U2NmqW8WIW8JMLnqNdB5EGBh
	 DRieoZyVocLDwOdYzqkDSNu9e3utW2nzFj+6Wb/15glu3QgMTau+YmUH9khlU6soLx
	 7+mnvgfM6CILw==
Date: Mon, 29 Jul 2024 20:22:51 -0700
Subject: [PATCH 2/3] xfs_scrub: use the self_healing fsproperty to select mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230941373.1544199.13557360920806714540.stgit@frogsfrogsfrogs>
In-Reply-To: <172230941338.1544199.12238614551925293396.stgit@frogsfrogsfrogs>
References: <172230941338.1544199.12238614551925293396.stgit@frogsfrogsfrogs>
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

Now that we can set properties on xfs filesystems, make the xfs_scrub
background service query the self_healing property to figure out which
mode (dry run, optimize, repair, none) it should use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile                    |    3 +--
 scrub/xfs_scrub@.service.in       |    2 +-
 scrub/xfs_scrub_media@.service.in |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)


diff --git a/scrub/Makefile b/scrub/Makefile
index 653aafd171b5..b0022cb7f005 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -17,7 +17,7 @@ INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all
 XFS_SCRUB_FAIL_PROG = xfs_scrub_fail
 XFS_SCRUB_ARGS = -p
-XFS_SCRUB_SERVICE_ARGS = -b
+XFS_SCRUB_SERVICE_ARGS = -b -o fsprops_advise
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
@@ -146,7 +146,6 @@ install-pkg: $(INSTALL_SCRUB)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
-		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
 		   -e "s|@pkg_libexec_dir@|$(PKG_LIBEXEC_DIR)|g" \
 		   -e "s|@pkg_state_dir@|$(PKG_STATE_DIR)|g" \
 		   -e "s|@media_scan_interval@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL)|g" \
diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index 5fa5f328200e..fb38319e95c1 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -22,7 +22,7 @@ RequiresMountsFor=%f
 [Service]
 Type=oneshot
 Environment=SERVICE_MODE=1
-ExecStart=@sbindir@/xfs_scrub @scrub_service_args@ @scrub_args@ -M /tmp/scrub/ %f
+ExecStart=@sbindir@/xfs_scrub @scrub_service_args@ -M /tmp/scrub/ %f
 SyslogIdentifier=%N
 
 # Run scrub with minimal CPU and IO priority so that nothing else will starve.
diff --git a/scrub/xfs_scrub_media@.service.in b/scrub/xfs_scrub_media@.service.in
index e670748ced51..98cd1ac44fbe 100644
--- a/scrub/xfs_scrub_media@.service.in
+++ b/scrub/xfs_scrub_media@.service.in
@@ -22,7 +22,7 @@ RequiresMountsFor=%f
 [Service]
 Type=oneshot
 Environment=SERVICE_MODE=1
-ExecStart=@sbindir@/xfs_scrub @scrub_service_args@ @scrub_args@ -M /tmp/scrub/ -x %f
+ExecStart=@sbindir@/xfs_scrub @scrub_service_args@ -M /tmp/scrub/ -x %f
 SyslogIdentifier=%N
 
 # Run scrub with minimal CPU and IO priority so that nothing else will starve.

