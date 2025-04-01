Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F27204F6A
	for <linux-xfs@vger.kernel.org>; Tue,  1 Apr 2025 14:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743518640; cv=none; b=pjSRqTHWTzpeUofPyZ22Mpm/4ll10nC+nU6CwONhHzsQgp2ZTjo4+6Bf4Fh0PGt1G3Cts9m40jJ738BP3hpCqB0KeXKRFusJKwfCUVxj6pBTq3bad2wrwEmzOW3ci5cEzpJUlxrvvyCwh9nYL3VQU3JsZ4CPNP9a4X2nueilI6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743518640; c=relaxed/simple;
	bh=8rTlVDJ+aToZKosU//8UJ/IdNrmOh3lfmaN2RpfoXQY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=moo/JLz1rk4ievmVjNFG/htWOtYz5tfNOOutiCeS4uU7bCjdq5w7cw/f3EfUJzCBkv+xUgIWHmeu3DbLkB7dEKooLveYjfQLgFxVq4LXnmkP9N4mCetD3Rw+MaCfjpC75wxq/kndWyXAoFLKihxQeKs3XQ24Hrgw+xWI8dyE65M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=keKgVGlu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="keKgVGlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB06C4CEE4;
	Tue,  1 Apr 2025 14:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743518637;
	bh=8rTlVDJ+aToZKosU//8UJ/IdNrmOh3lfmaN2RpfoXQY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=keKgVGluQLMWMYxvlpWpq5gQQ5ziUxjKIefrMBPAEJQJJKRg0iuWc81eDH3QTzKye
	 tHhQInz4bk0w5y92JlVpCkgVsIeOyaxyPLT1pHnakVtVzwBpJtho3RfWwzipncfYE7
	 EzyOuG6PBG8n1D/AwRe3etV6n94s8lfm5BdkLx+wi6SXN91ldsHEVo9NI4Pv8NjL21
	 /+PvLI6V+enoYOvaFNy2Ct6a/Cp0WTIBZg+45DalN85kMDE9kLkXZNO52jmAfNQgTZ
	 3xxYiOS/AHNw7SDvS7TpuqFZD2fe2cQdi3Vrq6dfE6wFWhqw7gCSK8nU4xE4nOak1v
	 owTYlmDAtemuw==
Date: Tue, 01 Apr 2025 07:43:57 -0700
Subject: [PATCH 2/5] xfs_scrub_all: rename source code to .py.in
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <174351857614.2774496.4390628685914527083.stgit@frogsfrogsfrogs>
In-Reply-To: <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>
References: <174351857556.2774496.13689449454739654191.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Rename this source code file to have an extention of ".py.in" so that
editors and xgettext can "smartly" detect the source code type from the
file extension.  This will become important for adding localization to
the strings printed.  No functional changes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/Makefile            |    6 +++---
 scrub/xfs_scrub_all.py.in |    0 
 2 files changed, 3 insertions(+), 3 deletions(-)
 rename scrub/{xfs_scrub_all.in => xfs_scrub_all.py.in} (100%)


diff --git a/scrub/Makefile b/scrub/Makefile
index 934b9062651bf1..b8105f69e4cc57 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -14,7 +14,7 @@ scrub_media_svcname=xfs_scrub_media@.service
 ifeq ($(SCRUB_PREREQS),yes)
 LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
-XFS_SCRUB_ALL_PROG = xfs_scrub_all
+XFS_SCRUB_ALL_PROG = xfs_scrub_all.py
 XFS_SCRUB_FAIL_PROG = xfs_scrub_fail
 XFS_SCRUB_ARGS = -p
 XFS_SCRUB_SERVICE_ARGS = -b -o autofsck
@@ -116,7 +116,7 @@ xfs_scrub_all.timer: xfs_scrub_all.timer.in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@pkg_state_dir@|$(PKG_STATE_DIR)|g" < $< > $@
 
-xfs_scrub_all: xfs_scrub_all.in $(builddefs)
+$(XFS_SCRUB_ALL_PROG): $(XFS_SCRUB_ALL_PROG).in $(builddefs)
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
@@ -168,7 +168,7 @@ install-crond: default $(CRONTABS)
 install-scrub: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
-	$(INSTALL) -m 755 $(XFS_SCRUB_ALL_PROG) $(PKG_SBIN_DIR)
+	$(INSTALL) -m 755 $(XFS_SCRUB_ALL_PROG) $(PKG_SBIN_DIR)/xfs_scrub_all
 	$(INSTALL) -m 755 -d $(PKG_STATE_DIR)
 
 install-udev: $(UDEV_RULES)
diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.py.in
similarity index 100%
rename from scrub/xfs_scrub_all.in
rename to scrub/xfs_scrub_all.py.in

