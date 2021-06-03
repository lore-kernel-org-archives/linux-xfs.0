Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FB3C4708F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 03:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B154613B8
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 03:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhFCDOb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 23:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhFCDOb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 23:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30DAC61360;
        Thu,  3 Jun 2021 03:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622689967;
        bh=0e7mPbYmfdK7lIvLKvu78JoFrIZ5rM7fzdYa+rkQGDI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EvxuztGIQ86PylvxITnRb86ObkOoNd+vwNFmGLG/tdFkoghd7PFd15b8X112mCzRq
         FqWxA3HDm+V8uqQV2ThKnhrijpWhbhvvNZB4jLGrty3XLA8X578Rqwp4y7FOeSMJ4q
         NgqxJgUPeAN2aySJAi21tfgJzsVRGMrzsxx6wQmCABd0Gr7WKlvfihW4QnlTgq6Ysz
         D0w/FHEd0QFujOhgh5WgFqwA0GN+dKJ3WJ8evAC4VwwvfIvIYcPuy+O+vCTQUKmvkd
         kA7wN5Y0IuI9HlU8tCDRzcMgZ3hZQTKnsTSdOsxjhE3dMHN4m6ucE8QFvILqIJT8Jn
         7cGcVVqdWI9SA==
Subject: [PATCH 2/3] xfs: drop IDONTCACHE on inodes when we mark them sick
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 02 Jun 2021 20:12:46 -0700
Message-ID: <162268996687.2724138.9307511745121153042.stgit@locust>
In-Reply-To: <162268995567.2724138.15163777746481739089.stgit@locust>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we decide to mark an inode sick, clear the DONTCACHE flag so that
the incore inode will be kept around until memory pressure forces it out
of memory.  This increases the chances that the sick status will be
caught by someone compiling a health report later on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_health.c |    5 +++++
 fs/xfs/xfs_icache.c |    3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 8e0cb05a7142..824e0b781290 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -231,6 +231,11 @@ xfs_inode_mark_sick(
 	ip->i_sick |= mask;
 	ip->i_checked |= mask;
 	spin_unlock(&ip->i_flags_lock);
+
+	/* Keep this inode around so we don't lose the sickness report. */
+	spin_lock(&VFS_I(ip)->i_lock);
+	VFS_I(ip)->i_state &= ~I_DONTCACHE;
+	spin_unlock(&VFS_I(ip)->i_lock);
 }
 
 /* Mark parts of an inode healed. */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c3f912a9231b..0e2b6c05e604 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -23,6 +23,7 @@
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
 #include "xfs_ialloc.h"
+#include "xfs_health.h"
 
 #include <linux/iversion.h>
 
@@ -648,7 +649,7 @@ xfs_iget_cache_miss(
 	 * time.
 	 */
 	iflags = XFS_INEW;
-	if (flags & XFS_IGET_DONTCACHE)
+	if ((flags & XFS_IGET_DONTCACHE) && xfs_inode_is_healthy(ip))
 		d_mark_dontcache(VFS_I(ip));
 	ip->i_udquot = NULL;
 	ip->i_gdquot = NULL;

