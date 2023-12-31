Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F5AC127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UahYe9PM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF57C433C8;
	Sun, 31 Dec 2023 22:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063281;
	bh=weZVtNuwuFW8FMAuVzTSxje6A8pHRgD6V4zIxuqzp+Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UahYe9PMC1MFnCKaPZRVqA90qv2Cexzk+1l8BEAPZm262lUJrw+Ga0kxlg31P9v0v
	 b+b+sKT4mmormyhD1Z5OkENmzaRIPlU35L5KH2DOMpLqwRencKmzxRDfjCzXflSPmR
	 RBuEG5Lmyb6CoMIymNnmZvXhGcZH8q/RNXcZgi2jjx9S5LMTfS6ERgHrOR/GxWTpcw
	 5SGBj7XPv77VLUAfawR5LkULTrEVISE5p1SJ9RZ/Cosb8LZC6Bc0D5Wu/nITGef9j3
	 es9fR3TqvzgzS1GN7MwE8Hbah25kf3kuCeA9ZWO8/WKnGh+LnSOKu96JKN4mtS8pFO
	 UZtVGAGLssgZA==
Date: Sun, 31 Dec 2023 14:54:41 -0800
Subject: [PATCH 9/9] xfs_scrub_all.cron: move to package data directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001964.1800712.10514067731814883862.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
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

cron jobs don't belong in /usr/lib.  Since the cron job is also
secondary to the systemd timer, it's really only provided as a courtesy
for distributions that don't use systemd.  Move it to @datadir@, aka
/usr/share/xfsprogs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/builddefs.in |    1 -
 scrub/Makefile       |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)


diff --git a/include/builddefs.in b/include/builddefs.in
index 9d0f9c3bf7c..f5138b5098f 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -51,7 +51,6 @@ PKG_SBIN_DIR	= @sbindir@
 PKG_ROOT_SBIN_DIR = @root_sbindir@
 PKG_ROOT_LIB_DIR= @root_libdir@@libdirsuffix@
 PKG_LIB_DIR	= @libdir@@libdirsuffix@
-PKG_LIB_SCRIPT_DIR	= @libdir@
 PKG_LIBEXEC_DIR	= @libexecdir@/@pkg_name@
 PKG_INC_DIR	= @includedir@/xfs
 DK_INC_DIR	= @includedir@/disk
diff --git a/scrub/Makefile b/scrub/Makefile
index 8fb366c922c..472df48a720 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -26,7 +26,7 @@ INSTALL_SCRUB += install-crond
 CRONTABS = xfs_scrub_all.cron
 OPTIONAL_TARGETS += $(CRONTABS)
 # Don't enable the crontab by default for now
-CROND_DIR = $(PKG_LIB_SCRIPT_DIR)/$(PKG_NAME)
+CROND_DIR = $(PKG_DATA_DIR)
 endif
 
 endif	# scrub_prereqs

