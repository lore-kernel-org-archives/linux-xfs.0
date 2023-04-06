Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E86C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjDFTeo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjDFTeo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:34:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0641935BE
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:34:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 900B560EFE
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BFBC433D2;
        Thu,  6 Apr 2023 19:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809682;
        bh=cuKAPtdDdWMKk5ITd6PLYZtOC6OERwGsCeXE46BfPQ0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hvqWjHNwicl4JOmiXi/ZTtPB2CS4H3TXjJ5LKtDYdy2ocM78MPurMjlGo/21huJ9U
         oDgPUIN/dqD9JlMQ2eXUBXitqwTGqIkyRqzp8b8VsKCf2KQv9ol8EnQYP60qTz0aTF
         8cExLkEQHPugnIghe31JM2m+/VOzs8DMELNm/MYZFk2EJVOMh9gCOuAbc+l0mh48Xu
         WQCYWDpGohcADBDoODvAHMvAVP6ECcTMLsaPApnyBXp4vGdFHxljy0Pr3sp7G/bPPY
         gqu5XDYeFcUudmnbf9nn9A1zsde4I7aGzyve3NrSwTWnVAQCiR0SJW95GrX1Iz4R3b
         4C1zgSlyC/PbA==
Date:   Thu, 06 Apr 2023 12:34:41 -0700
Subject: [PATCH 12/32] xfs: add a libxfs header file for staging new ioctls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827715.616793.7225609100253350537.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new xfs_fs_staging.h header where we can land experimental
ioctls without committing them to any stable interfaces anywhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h        |    1 +
 include/xfs.h           |    1 +
 libxfs/Makefile         |    1 +
 libxfs/libxfs_priv.h    |    1 +
 libxfs/xfs_fs_staging.h |   18 ++++++++++++++++++
 5 files changed, 22 insertions(+)
 create mode 100644 libxfs/xfs_fs_staging.h


diff --git a/include/libxfs.h b/include/libxfs.h
index cc57e8887..3340e2af3 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -23,6 +23,7 @@
 
 #include "xfs_types.h"
 #include "xfs_fs.h"
+#include "xfs_fs_staging.h"
 #include "xfs_arch.h"
 
 #include "xfs_shared.h"
diff --git a/include/xfs.h b/include/xfs.h
index e97158c8d..c4a95bec9 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -44,5 +44,6 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
 /* Include deprecated/compat pre-vfs xfs-specific symbols */
 #include <xfs/xfs_fs_compat.h>
 #include <xfs/xfs_fs.h>
+#include <xfs/xfs_fs_staging.h>
 
 #endif	/* __XFS_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 89d29dc97..951df6231 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -14,6 +14,7 @@ LTLDFLAGS += -static
 
 # headers to install in include/xfs
 PKGHFILES = xfs_fs.h \
+	xfs_fs_staging.h \
 	xfs_types.h \
 	xfs_da_format.h \
 	xfs_format.h \
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ff027dbe3..411cafb26 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -56,6 +56,7 @@
 #include "xfs_arch.h"
 
 #include "xfs_fs.h"
+#include "xfs_fs_staging.h"
 #include "libfrog/crc32c.h"
 
 #include <sys/xattr.h>
diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
new file mode 100644
index 000000000..bc97193dd
--- /dev/null
+++ b/libxfs/xfs_fs_staging.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Copyright (C) 2020-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_FS_STAGING_H__
+#define __XFS_FS_STAGING_H__
+
+/*
+ * Experimental system calls, ioctls and data structures supporting them.
+ * Nothing in here should be considered part of a stable interface of any kind.
+ *
+ * If you add an ioctl here, please leave a comment in xfs_fs.h marking it
+ * reserved.  If you promote anything out of this file, please leave a comment
+ * explaining where it went.
+ */
+
+#endif /* __XFS_FS_STAGING_H__ */

