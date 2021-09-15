Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AFFC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03F9760EE3
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhIOXIA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhIOXIA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:08:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91C02606A5;
        Wed, 15 Sep 2021 23:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747200;
        bh=+NNk8NJIZuoJAGUQRQyXuasKf+moBwnT8d4wAJnO3NU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Dk1uHBOlVE6165tY8S/FAqRe0uLzX/NCmiEohJqrBGCk6Gg4gYJtr/6eXr4RT8r8o
         h2TovNH+fuByujgV1GDqKZtNRLk2nQx6deDHc2Q5ir+ctWR2gvWe6byGR3StHI9PaT
         S9BTKhtx7OMBiOc2YRLUW8xTahDthCQ4dKRxU49t2/GA2zeJdeANWQc+95UUm4vNgl
         u86fenut8ZJ6jxoYrp6bwHz5N6mzRxSoI6gTrSx0fVM+Y+Y32tyCX5O7PSFbFd2g/6
         mnXaMlCUkJtfgEzyXMZ0hX3FsH1gYMxqs3Hi1N/fue1YpvmNw2/gayjPO2mUH4EhvY
         KIQGtZDnGmkoQ==
Subject: [PATCH 01/61] mkfs: move mkfs/proto.c declarations to mkfs/proto.h
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:06:40 -0700
Message-ID: <163174720034.350433.11964220787370567480.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

These functions are only used by mkfs, so move them to a separate header
file that isn't in an internal library.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_multidisk.h |    5 -----
 mkfs/proto.c            |    1 +
 mkfs/proto.h            |   13 +++++++++++++
 mkfs/xfs_mkfs.c         |    1 +
 4 files changed, 15 insertions(+), 5 deletions(-)
 create mode 100644 mkfs/proto.h


diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
index abfb50ce..a16a9fe2 100644
--- a/include/xfs_multidisk.h
+++ b/include/xfs_multidisk.h
@@ -42,9 +42,4 @@
 #define XFS_NOMULTIDISK_AGLOG		2	/* 4 AGs */
 #define XFS_MULTIDISK_AGCOUNT		(1 << XFS_MULTIDISK_AGLOG)
 
-/* proto.c */
-extern char *setup_proto (char *fname);
-extern void parse_proto (xfs_mount_t *mp, struct fsxattr *fsx, char **pp);
-extern void res_failed (int err);
-
 #endif	/* __XFS_MULTIDISK_H__ */
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 6b22cc6a..ef130ed6 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -7,6 +7,7 @@
 #include "libxfs.h"
 #include <sys/stat.h>
 #include "libfrog/convert.h"
+#include "proto.h"
 
 /*
  * Prototypes for internal functions.
diff --git a/mkfs/proto.h b/mkfs/proto.h
new file mode 100644
index 00000000..9ccbddf6
--- /dev/null
+++ b/mkfs/proto.h
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2001,2004-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef MKFS_PROTO_H_
+#define MKFS_PROTO_H_
+
+extern char *setup_proto (char *fname);
+extern void parse_proto (xfs_mount_t *mp, struct fsxattr *fsx, char **pp);
+extern void res_failed (int err);
+
+#endif /* MKFS_PROTO_H_ */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9c14c04e..16e347e5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -11,6 +11,7 @@
 #include "libfrog/fsgeom.h"
 #include "libfrog/topology.h"
 #include "libfrog/convert.h"
+#include "proto.h"
 #include <ini.h>
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))

