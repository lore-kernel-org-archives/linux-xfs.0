Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1952CC76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240180AbjDFTZI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240013AbjDFTZH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:25:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0385FC8
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:25:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 294AC64ADB
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BA6C433D2;
        Thu,  6 Apr 2023 19:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809105;
        bh=wzS87xfDZNF9qGgGmX5GhuD3lQfuuY/neuCP0hG34Eo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=anMQKQlDuk8MtSzZd8lNAVMxBG8K7WIwYPVZAHyQCoqto9/3j/yWdUA/V7fH7kBQe
         FB8/AVnbZRkMSLk8OM/MdE95ZVXoLcaKkBpuFhYZVhezTH+O7epVV05htX/ixAQ/lI
         Si45oUBgPUIPo/TEtuRz/DqEIwxvyH8M9BtaDOT2HaAW+p9JE/bzjeXCOs7Pw9Rvld
         C5ZoAChhjTLoGyMgc3HCfl5hIXD5HDdMeVqzB0PEtgmcsgweGsauLdt/rjYyYbPSk2
         8dbD49swIqTKildId2F2Ex5rT7IdOqYyueaw+WSNQMIQclrhvOEHYg2hvskGqNTzMk
         kjrvJ5euo0dWw==
Date:   Thu, 06 Apr 2023 12:25:05 -0700
Subject: [PATCH 18/23] xfs: add a libxfs header file for staging new ioctls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080824914.615225.16802617517859831531.stgit@frogsfrogsfrogs>
In-Reply-To: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
References: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_fs_staging.h |   18 ++++++++++++++++++
 fs/xfs/xfs_linux.h             |    1 +
 2 files changed, 19 insertions(+)
 create mode 100644 fs/xfs/libxfs/xfs_fs_staging.h


diff --git a/fs/xfs/libxfs/xfs_fs_staging.h b/fs/xfs/libxfs/xfs_fs_staging.h
new file mode 100644
index 000000000000..bc97193dde9d
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_fs_staging.h
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
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index e88f18f85e4b..4cd21a0b3043 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -72,6 +72,7 @@ typedef __u32			xfs_nlink_t;
 #include <asm/unaligned.h>
 
 #include "xfs_fs.h"
+#include "xfs_fs_staging.h"
 #include "xfs_stats.h"
 #include "xfs_sysctl.h"
 #include "xfs_iops.h"

