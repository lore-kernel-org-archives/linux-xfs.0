Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA32C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 270C164E30
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhBACHL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:07:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231305AbhBACGX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:06:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58D7464E27;
        Mon,  1 Feb 2021 02:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145166;
        bh=Wz9irf4CKJxCMnu15KxIJHbnjBfJYW5tF/0QseheH5o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eGZ0NEjKHHfKWVtrR9IQZNJV0vwles4Nvb0/SpCc8d4n/kNfdeAPb4FuUjbKUrQh6
         5Mrj5Lhk4smUCBq9Fk8Q8mD0rptlSx2HpYclUukean8/6Lb/oLyxiTTLMce7r5Dayf
         DM/6btRT7UoKBwKeLyf5Bc16Qen/hquDTJ0aVoZ8xsik5sU4Xcagds2vTTH+7Su839
         TIqrYwRf7YrZdx5g9xZ1eZbcf/UlmhBIWmnlVsD2TZ34UAfRhnYIdUTsQ7lFnVpKpI
         It0HOQAoAg9uYaPoubCKfwajgpZjnnEnw7FCkiEZ/stHj3Lv75O3rJU1DOfZ1Xumm8
         9vTwlQF105BMA==
Subject: [PATCH 07/12] xfs: flush eof/cowblocks if we can't reserve quota for
 file blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:06:06 -0800
Message-ID: <161214516600.140945.4401509001858536727.stgit@magnolia>
In-Reply-To: <161214512641.140945.11651856181122264773.stgit@magnolia>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a fs modification (data write, reflink, xattr set, fallocate, etc.)
is unable to reserve enough quota to handle the modification, try
clearing whatever space the filesystem might have been hanging onto in
the hopes of speeding up the filesystem.  The flushing behavior will
become particularly important when we add deferred inode inactivation
because that will increase the amount of space that isn't actively tied
to user data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |    5 +++++
 fs/xfs/xfs_trans.c   |   10 ++++++++++
 2 files changed, 15 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 086866f6e71f..725c7d8e4438 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1092,6 +1092,11 @@ xfs_reflink_remap_extent(
 	 * count.  This is suboptimal, but the VFS flushed the dest range
 	 * before we started.  That should have removed all the delalloc
 	 * reservations, but we code defensively.
+	 *
+	 * xfs_trans_alloc_inode above already tried to grab an even larger
+	 * quota reservation, and kicked off a blockgc scan if it couldn't.
+	 * If we can't get a potentially smaller quota reservation now, we're
+	 * done.
 	 */
 	if (!quota_reserved && !smap_real && dmap_written) {
 		error = xfs_trans_reserve_quota_nblks(tp, ip,
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 466e1c86767f..f62c1c5f210f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -23,6 +23,7 @@
 #include "xfs_inode.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
+#include "xfs_icache.h"
 
 kmem_zone_t	*xfs_trans_zone;
 
@@ -1046,8 +1047,10 @@ xfs_trans_alloc_inode(
 {
 	struct xfs_trans	*tp;
 	struct xfs_mount	*mp = ip->i_mount;
+	bool			retried = false;
 	int			error;
 
+retry:
 	error = xfs_trans_alloc(mp, resv, dblocks,
 			rblocks / mp->m_sb.sb_rextsize,
 			force ? XFS_TRANS_RESERVE : 0, &tp);
@@ -1065,6 +1068,13 @@ xfs_trans_alloc_inode(
 	}
 
 	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
+	if (!retried && (error == -EDQUOT || error == -ENOSPC)) {
+		xfs_trans_cancel(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_blockgc_free_quota(ip, 0);
+		retried = true;
+		goto retry;
+	}
 	if (error)
 		goto out_cancel;
 

