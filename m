Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C22677F08;
	Tue,  6 Aug 2024 18:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968516; cv=none; b=Rh6/qgrVi5Xi41Q3ggWDxbCghQEnPQdEYsFaxpWabJGe7nbIv6UoLktZTMUUHMM0mtIiDiPfQmZP/JWimEd4mizE/UlddqPwwfSTK5d2cWhS8/3oocqkILYQtjVv94cb82Ru5QmN3iX4CYMDYzlCbZzHGYUVXJXLB9ACUW7W4M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968516; c=relaxed/simple;
	bh=ovkuHAbYFi4xciqSBB5QDP6889hCZvDtrha7OUPXVu8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V3nKFFv1B92/NNr1SdwO8eXIdhMgI3/ijmafEyzMhgt/aVK776aGXuXJyajof/MJGjzFJXSAVkP5A+BtichfBxgN3QjCVadZcYfWW+62VElBNPy2HFwFIHWmBM6gPbq0hJ1baxNv4dgAcdUM8s3qbmmuqBI+IDs5V55nfyXj+FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SzdHVTqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SzdHVTqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396E9C32786;
	Tue,  6 Aug 2024 18:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968516;
	bh=ovkuHAbYFi4xciqSBB5QDP6889hCZvDtrha7OUPXVu8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SzdHVTqheFEeeY4PrBhZpG60lrrJAtLorIWwdkI8C1i4Rn0Ys3ZSTetscQrAOU5hd
	 E+5zeoytzi7FreAnOza2nvxaOVw9BAEfQm2k8sZ6sYPzvMxQ2+7hoKXJW5aDeJBvST
	 2iYcJViaZJzuxwjrNYXWZkUB+TPYjDJRE/1HPts7Lxusx3esru3BgwBWVZ733F8puE
	 aKtxCka+4y7/qB+TPBHKcO/dVT8c0IhtJdQBE47Jdgh4DR4a388YDuBttYwt6vADmi
	 4zh3jKfrxgaBJsAwEurSZtZJbmB2siqKn4L3o6NKZNGH5wQZMLib8eJRzdlhuekeIf
	 fcbFMlT4aAtrQ==
Date: Tue, 06 Aug 2024 11:21:55 -0700
Subject: [PATCH 3/4] xfs_scrub: use the autofsck fsproperty to select mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, dchinner@redhat.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <172296825643.3193344.4511195350690630042.stgit@frogsfrogsfrogs>
In-Reply-To: <172296825594.3193344.4163676649578585462.stgit@frogsfrogsfrogs>
References: <172296825594.3193344.4163676649578585462.stgit@frogsfrogsfrogs>
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
background service query the autofsck property to figure out which
operating mode it should use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/Makefile                    |    3 +--
 scrub/xfs_scrub@.service.in       |    2 +-
 scrub/xfs_scrub_media@.service.in |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)


diff --git a/scrub/Makefile b/scrub/Makefile
index 885b43e99..53e8cb02a 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -17,7 +17,7 @@ INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all
 XFS_SCRUB_FAIL_PROG = xfs_scrub_fail
 XFS_SCRUB_ARGS = -p
-XFS_SCRUB_SERVICE_ARGS = -b
+XFS_SCRUB_SERVICE_ARGS = -b -o autofsck
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
@@ -144,7 +144,6 @@ install: $(INSTALL_SCRUB)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
-		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
 		   -e "s|@pkg_libexec_dir@|$(PKG_LIBEXEC_DIR)|g" \
 		   -e "s|@pkg_state_dir@|$(PKG_STATE_DIR)|g" \
 		   -e "s|@media_scan_interval@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL)|g" \
diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index 5fa5f3282..fb38319e9 100644
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
index e670748ce..98cd1ac44 100644
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

