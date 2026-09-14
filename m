Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8B131ED93
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789365093; cv=none; b=RYyW2abJI3n+kkaubByaHJqFMUQyNR70bO9+S4tuJTZzZj83r02FccyrtSkD1NZgSVScg3AeobsolN7Fdtjwec9AS6O90HBjftBqznpbdOxAsPRxUEA8RIvwyOa/PVAzPEcA/11W6/kuvRMBpj2oSpHUuyfT0sMp1g2oE4VyrP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789365093; c=relaxed/simple;
	bh=JqXDdofdQSmpeXk0Xpmf4ghLc9t/liPsqaoMktYWDrc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YJkmwqYLm3L1LRDYP2CHZwWQ65TZsqiK6JpHvbKRQYDz6AxTaO0vPLhSqsR4JhG1UxCb4+5+c41T8CkKciioZHoyukY2eqn7579xr0+75Z1R0GsrLsGZfUlRy4tYBO5y21feyrZVybH6qtu5QA0573AV5lcmyQAblPeHKPjMlTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZYjbKvb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZYjbKvb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F348C1F000FF;
	Mon, 14 Sep 2026 05:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789365085;
	bh=cAIxkeRKowDeeBWEXJ1lG8zNU2S2GDEQwvGg8o5F5Ds=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=XZYjbKvbguvetwulRRRCnLmooLsFbyQ9apsTupc2votyD0grHSJYXt0xD3VaKcJ5n
	 8ZFjukEWh0Xf9wyaG2qVLKRL1/6/xjv8YsGzONhrx6uAmNsV6hN2UrS1hk1gzqNnq0
	 NveMQG/hJjhZlyZoE38vtNDKodJ9LVVAG89s0ius7bTXiD8oboAknFcyoTqvJA0S+f
	 GxqO+DhTYCDrfuQrKF+6vfVLCdgvsAIT3fUM1jVvj9faUCmYwEz140r+eY+vm752QJ
	 DDIuN8nPGFtESurBDpuPvVUBToo7prKqGt6MYHWiR9i1myLVKjPtiOG8QPO0PzVuGl
	 A0BHELkVHa4eQ==
Date: Sun, 13 Sep 2026 22:51:24 -0700
Subject: [PATCH 7/7] xfs_spaceman: port makecfg to use xfsquotactl
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178936484936.2108717.8402857786114618949.stgit@frogsfrogsfrogs>
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

Port this code to use our xfsquotactl function, which means that we can
call quotactl_fd/quotactl in the same manner as xfs_quota does.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 spaceman/info.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/spaceman/info.c b/spaceman/info.c
index bacc48e8aa796f..56c7a05c3f81ec 100644
--- a/spaceman/info.c
+++ b/spaceman/info.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
-#include <sys/quota.h>
 #include "libxfs.h"
 #include "command.h"
 #include "init.h"
@@ -11,8 +10,8 @@
 #include "libfrog/fsgeom.h"
 #include "libfrog/fsproperties.h"
 #include "libfrog/fsprops.h"
+#include "libfrog/quotactl.h"
 #include "space.h"
-#include "include/xqm.h"
 
 static void
 info_help(void)
@@ -126,8 +125,8 @@ get_qflags(
 	*qflags = 0;
 
 	/* GETQSTAT returns qflags for all quota types, not just user */
-	ret = quotactl(QCMD(Q_XGETQSTAT, USRQUOTA), f->fs_path.fs_name, 0,
-			(void *)&qstat);
+	ret = xfsquotactl(f->xfd.fd, f->fs_path.fs_name, XFS_GETQSTAT,
+			XFS_USER_QUOTA, 0, (void *)&qstat);
 	if (ret) {
 		/*
 		 * ENOSYS means quota is not enabled or compiled in; ENODEV

