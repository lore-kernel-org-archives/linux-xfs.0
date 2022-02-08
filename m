Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B2A0C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Feb 2022 22:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386316AbiBHWYg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386327AbiBHUJM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Feb 2022 15:09:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D9BC0613CB
        for <linux-xfs@vger.kernel.org>; Tue,  8 Feb 2022 12:09:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB2A2B81CB7
        for <linux-xfs@vger.kernel.org>; Tue,  8 Feb 2022 20:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CB4C004E1;
        Tue,  8 Feb 2022 20:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644350949;
        bh=lUmRtqYg6sZSEddrKka3HU29DE/u84x9Rkp091+cEjM=;
        h=Date:From:To:Cc:Subject:From;
        b=bIer0W90GHeFDuzFZ3VtDlaTIps3YM8lnYNr2/j2KlSTMf+bzjqDlfPSWJBhTGhUN
         njlDU/hckliwjcQJHHseQ/aGfRp1V4P9MkLwm1aLz8jqp5NOmLhfh5XaJr34oHEBXH
         hBJDTO9QZhZ7K0k09Xj0/23iCnMlyNJzv6O6CKWCo/VuOFycadkiZ1BeauIAyaUVoJ
         S4nsp65vmLEeleACNm4hKkfsVwTy8K9g0/9+CSDdNZ1VVvmG43svm3/kkhSnRdPtIe
         oMPa9qFxsB/YrmI1jqPXFoYurmiJBCVXE9d+eGRxOoEzIu5Mb1pLvQyaaMYppH69uC
         rDODv5kUmIfxQ==
Date:   Tue, 8 Feb 2022 12:09:08 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: only bother with sync_filesystem during readonly remount
Message-ID: <20220208200908.GD8313@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit 02b9984d6408, we pushed a sync_filesystem() call from the VFS
into xfs_fs_remount.  The only time that we ever need to push dirty file
data or metadata to disk for a remount is if we're remounting the
filesystem read only, so this really could be moved to xfs_remount_ro.

Once we've moved the call site, actually check the return value from
sync_filesystem.

Fixes: 02b9984d6408 ("fs: push sync_filesystem() down to the file system's remount_fs()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4c0dee78b2f8..d84714e4e46a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1753,6 +1753,11 @@ xfs_remount_ro(
 	};
 	int			error;
 
+	/* Flush all the dirty data to disk. */
+	error = sync_filesystem(mp->m_super);
+	if (error)
+		return error;
+
 	/*
 	 * Cancel background eofb scanning so it cannot race with the final
 	 * log force+buftarg wait and deadlock the remount.
@@ -1831,8 +1836,6 @@ xfs_fs_reconfigure(
 	if (error)
 		return error;
 
-	sync_filesystem(mp->m_super);
-
 	/* inode32 -> inode64 */
 	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
 		mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
