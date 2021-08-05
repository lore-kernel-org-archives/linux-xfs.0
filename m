Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CBCC4320A
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 07:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA7DB61078
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 07:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbhHEHBM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Aug 2021 03:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237793AbhHEHBI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Aug 2021 03:01:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7343610A8;
        Thu,  5 Aug 2021 07:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628146854;
        bh=yokYWD1tjuNDzTrjaBfWY808haOS544B8ctjtlnGfNM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BC7TvOEEz+mq+8fyjlz6uFy848sd1MXXBWCgvBuBkIGc77z3iU+IZ5MGeu9Jf01ql
         LlkBTPtdHcbqm0eVQpzDQNARfR5Kf0+qgW0oDe6CmDvsUDtUCmbvrixztiFqFn94/l
         pK2GLOfmnTLnLTBAiJ3g2tw0/5g1GANgwvpLLCveaTEuCDBPDEcpMBRR4NKfMgcUMe
         QKvxLkXv7dRkXkQWh32zlz3bOPsmNI3v5bMQHn4ZXs76Ssf2FvNb0zOzHHyDyFw7gn
         xe5c/fiVFBlYjIZjgfXeQEf7FBMXpwclJXQFTg5X58333/JOwECHTmGP0rD82dW3wP
         Qx1MlR5iSXD3w==
Subject: [PATCH 2/5] xfs: drop experimental warnings for bigtime and
 inobtcount
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>,
        Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org
Date:   Thu, 05 Aug 2021 00:00:54 -0700
Message-ID: <162814685444.2777088.14865867141337716049.stgit@magnolia>
In-Reply-To: <162814684332.2777088.14593133806068529811.stgit@magnolia>
References: <162814684332.2777088.14593133806068529811.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

These two features were merged a year ago, userspace tooling have been
merged, and no serious errors have been reported by the developers.
Drop the experimental tag to encourage wider testing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Bill O'Donnell <billodo@redhat.com>
---
 fs/xfs/xfs_super.c |    8 --------
 1 file changed, 8 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2bab18ed73b9..c4ba5c712284 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1599,10 +1599,6 @@ xfs_fs_fill_super(
 	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
 		sb->s_flags |= SB_I_VERSION;
 
-	if (xfs_sb_version_hasbigtime(&mp->m_sb))
-		xfs_warn(mp,
- "EXPERIMENTAL big timestamp feature in use. Use at your own risk!");
-
 	if (mp->m_flags & XFS_MOUNT_DAX_ALWAYS) {
 		bool rtdev_is_dax = false, datadev_is_dax;
 
@@ -1658,10 +1654,6 @@ xfs_fs_fill_super(
 		goto out_filestream_unmount;
 	}
 
-	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
-		xfs_warn(mp,
- "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
-
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;

