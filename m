Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584BB37F32F
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789364994; cv=none; b=l5ZtyA8EtjlgAgeck1nP7DU9l0VySBe+fG+UJi7zaDch2u6a0dj/h6Ml7E1d2AOVCttFnzUdPVKDwtZz3qe8/LZKQdtqf+4htBBkfmeSi3V2jvgtZA+B/ihoJuRJdlNo59AgL3VSXiD5bVQ3S0q5qrQLM/VtPWrarAYCt3fQrU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789364994; c=relaxed/simple;
	bh=OOyWV/uLo+dwCr9FOXt7NnYxra0vdt/Wdic7jFdFwgc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t92nLhwXUrWO17WBM5faeGNF83Bup+g0qg0pzwl1qRLe1pu6N+YRzTApM8LgfSaPzpSperdnVLUf/uICRe6Lr8zhdQUQNqjr6yrYLQZ1K4kF92Z7+YS4OTUgtyNHMBPVbn3ZB2DYddrpYVURe6jSVKoQjvjSMFhUQRLiMOmddt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dIR2Y1y2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dIR2Y1y2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 19BFF1F00893;
	Mon, 14 Sep 2026 05:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789364991;
	bh=/Hlq2nRQ0WSbpJB+rFEI0vKGeyMeRMpS3c7y4LaPQ5s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=dIR2Y1y22zVJyeju9ZsVZKunwOFsWmmv3MvB1cc2SwruurCYSwSyz/gqaiBiRZEKR
	 3ZKItoHOdplIELv30LJ7Iaa1DtF5G9Zsd4GO5BtI6+/ns3su6D9fVcUy7H8BBeFQXO
	 fxhVZkHEQXX62IEKlXPZinqfR4juxw8PMp+QgYGI15y3FPcf9NlysJqsJ+WAZE6aJr
	 Nhr66nTeMQYtkshK2Y/I9JWGKRWw0KLpcU932z73+BCe5i3In3HLm/FyU4AlJ+vgRV
	 gOTkmPNuSsThLg13TlmZGsBP002NuVKD1p3wVOrTffjhbVchpM/EePEJgPj2lJPPN1
	 qxWpCyhUZRyJQ==
Date: Sun, 13 Sep 2026 22:49:50 -0700
Subject: [PATCH 1/7] libfrog: hoist xfsquotactl out of xfs_quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178936484825.2108717.5578837464044937948.stgit@frogsfrogsfrogs>
In-Reply-To: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
References: <178936484773.2108717.13238892511050788442.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Hoist this generic function to libfrog so that we can share it with
xfs_spaceman later on.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/quotactl.h |   28 ++++++++++++++++++++++++++++
 quota/quota.h      |   18 +-----------------
 libfrog/Makefile   |    2 ++
 libfrog/quotactl.c |    2 +-
 quota/Makefile     |    2 +-
 5 files changed, 33 insertions(+), 19 deletions(-)
 create mode 100644 libfrog/quotactl.h
 rename quota/linux.c => libfrog/quotactl.c (97%)


diff --git a/libfrog/quotactl.h b/libfrog/quotactl.h
new file mode 100644
index 00000000000000..f76d02567408a0
--- /dev/null
+++ b/libfrog/quotactl.h
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef LIBFROG_QUOTACTL_H_
+#define LIBFROG_QUOTACTL_H_
+
+#include "xqm.h"
+
+/*
+ * System call definitions mapping to platform-specific quotactl
+ */
+extern int xfsquotactl(int __cmd, const char *__device,
+			uint __type, uint __id, void * __addr);
+enum {
+	XFS_QUOTAON,	/* enable accounting/enforcement */
+	XFS_QUOTAOFF,	/* disable accounting/enforcement */
+	XFS_GETQUOTA,	/* get disk limits and usage */
+	XFS_SETQLIM,	/* set disk limits */
+	XFS_GETQSTAT,	/* get quota subsystem status */
+	XFS_QUOTARM,	/* free disk space used by dquots */
+	XFS_QSYNC,	/* flush delayed allocate space */
+	XFS_GETQSTATV,	/* newer version of quota stats */
+	XFS_GETNEXTQUOTA, /* get disk limits and usage */
+};
+
+#endif /* LIBFROG_QUOTACTL_H_ */
diff --git a/quota/quota.h b/quota/quota.h
index ece920ef6c1b46..82132e88c671c7 100644
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -9,6 +9,7 @@
 #include "xqm.h"
 #include "libfrog/paths.h"
 #include "libfrog/projects.h"
+#include "libfrog/quotactl.h"
 #include <stdbool.h>
 
 /*
@@ -20,23 +21,6 @@ enum {
 	XFS_RTBLOCK_QUOTA =	0x4,
 };
 
-/*
- * System call definitions mapping to platform-specific quotactl
- */
-extern int xfsquotactl(int __cmd, const char *__device,
-			uint __type, uint __id, void * __addr);
-enum {
-	XFS_QUOTAON,	/* enable accounting/enforcement */
-	XFS_QUOTAOFF,	/* disable accounting/enforcement */
-	XFS_GETQUOTA,	/* get disk limits and usage */
-	XFS_SETQLIM,	/* set disk limits */
-	XFS_GETQSTAT,	/* get quota subsystem status */
-	XFS_QUOTARM,	/* free disk space used by dquots */
-	XFS_QSYNC,	/* flush delayed allocate space */
-	XFS_GETQSTATV,	/* newer version of quota stats */
-	XFS_GETNEXTQUOTA, /* get disk limits and usage */
-};
-
 /*
  * Utility routines
  */
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 6ada83407e48c5..b0e8d1a10cd0c7 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -33,6 +33,7 @@ logging.c \
 paths.c \
 projects.c \
 ptvar.c \
+quotactl.c \
 radix-tree.c \
 randbytes.c \
 scrub.c \
@@ -67,6 +68,7 @@ logging.h \
 paths.h \
 projects.h \
 ptvar.h \
+quotactl.h \
 radix-tree.h \
 randbytes.h \
 scrub.h \
diff --git a/quota/linux.c b/libfrog/quotactl.c
similarity index 97%
rename from quota/linux.c
rename to libfrog/quotactl.c
index 63e0d34ce28c4e..ffef72b44eeadf 100644
--- a/quota/linux.c
+++ b/libfrog/quotactl.c
@@ -4,7 +4,7 @@
  * All Rights Reserved.
  */
 
-#include "quota.h"
+#include "libfrog/quotactl.h"
 #include <sys/quota.h>
 
 #ifndef PRJQUOTA
diff --git a/quota/Makefile b/quota/Makefile
index da5a1489e468b2..296cea44129e7f 100644
--- a/quota/Makefile
+++ b/quota/Makefile
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_quota
 HFILES = init.h quota.h
 CFILES = init.c util.c \
-	edit.c free.c linux.c path.c project.c quot.c quota.c report.c state.c
+	edit.c free.c path.c project.c quot.c quota.c report.c state.c
 
 LLDLIBS = $(LIBXCMD) $(LIBFROG)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)

