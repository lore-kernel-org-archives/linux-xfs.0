Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 505D0C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A35D64FC8
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCKDGE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:06:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhCKDFq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 22:05:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FC9E64FC4;
        Thu, 11 Mar 2021 03:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615431946;
        bh=HX6mTiI95u1DkubNHBK2b4P+74/gkNrjPnImsNVnKX8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WZNPqJmpirb9joXI7CxJVl1CA9g6/pCp99V7zHoQuz7iieDHCgnmOzthEmCjMsPvQ
         G9Yza3wS3CZKKCg8tcYrbAsiVnDNLNtIeBh8TclOLXyGr+KfEp8cn6CCkyguGnJWWg
         Jj++2RldWh+YE7hYyFDq5qxzBzQ3OnC49+2vptJ7fe4Ab9O9QHcP/pqEvhxJquMSgx
         wdaapUHbBbOlFVHMMMZAsJXLX13Nr5DvPccYW+rWnAA5Uukm5UFNTV3n8vorh6RbdI
         tB1IV0FUBYg0koQxRdn95jzd3w79lLXQcVbQRGhgRo5oZ1MmsarYJRa0cQAd02O1QO
         4c2ddH4zhL/xg==
Subject: [PATCH 01/11] xfs: prevent metadata files from being inactivated
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 10 Mar 2021 19:05:46 -0800
Message-ID: <161543194600.1947934.584103655060069020.stgit@magnolia>
In-Reply-To: <161543194009.1947934.9910987247994410125.stgit@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Files containing metadata (quota records, rt bitmap and summary info)
are fully managed by the filesystem, which means that all resource
cleanup must be explicit, not automatic.  This means that they should
never be subjected automatic to post-eof truncation, nor should they be
freed automatically even if the link count drops to zero.

In other words, xfs_inactive() should leave these files alone.  Add the
necessary predicate functions to make this happen.  This adds a second
layer of prevention for the kinds of fs corruption that was fixed by
commit f4c32e87de7d.  If we ever decide to support removing metadata
files, we should make all those metadata updates explicit.

Rearrange the order of #includes to fix compiler errors, since
xfs_mount.h is supposed to be included before xfs_inode.h

Followup-to: f4c32e87de7d ("xfs: fix realtime bitmap/summary file truncation when growing rt volume")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_iext_tree.c |    2 +-
 fs/xfs/xfs_inode.c            |    4 ++++
 fs/xfs/xfs_inode.h            |    8 ++++++++
 fs/xfs/xfs_xattr.c            |    2 ++
 4 files changed, 15 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index b4164256993d..773cf4349428 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -8,9 +8,9 @@
 #include "xfs_format.h"
 #include "xfs_bit.h"
 #include "xfs_log_format.h"
-#include "xfs_inode.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_inode.h"
 #include "xfs_trace.h"
 
 /*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f93370bd7b1e..12c79962f8c3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1697,6 +1697,10 @@ xfs_inactive(
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return;
 
+	/* Metadata inodes require explicit resource cleanup. */
+	if (xfs_is_metadata_inode(ip))
+		return;
+
 	/* Try to clean out the cow blocks if there are any. */
 	if (xfs_inode_has_cow_data(ip))
 		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 88ee4c3930ae..c2c26f8f4a81 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -185,6 +185,14 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
 }
 
+static inline bool xfs_is_metadata_inode(struct xfs_inode *ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	return ip == mp->m_rbmip || ip == mp->m_rsumip ||
+		xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
+}
+
 /*
  * Check if an inode has any data in the COW fork.  This might be often false
  * even for inodes with the reflink flag when there is no pending COW operation.
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 12be32f66dc1..0d050f8829ef 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -9,6 +9,8 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_da_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_attr.h"
 #include "xfs_acl.h"

