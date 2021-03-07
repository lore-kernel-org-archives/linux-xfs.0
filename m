Return-Path: <SRS0=xiMZ=IF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7692BC43381
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 20:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5341C65166
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Mar 2021 20:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhCGU0G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Mar 2021 15:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232861AbhCGUZq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Mar 2021 15:25:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74BA465165;
        Sun,  7 Mar 2021 20:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615148746;
        bh=bxcSmHnpNAOf0EwIHZI2H2x8Jekl70PoUI8QxLCEfNI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Pr5yuoW4rAP//GBb4Qs1DNYf2FxZqXm/cl/g1RbLvbqZ/hEAK1fpRN8qZj6CYYF1g
         ceWlD+eTQZJ34PWFp1Nh3KIuNi/kyk9yqcNhOP5/oj4gwaBujXCIVKQoRmNxmeAqLP
         VtaxtRLT51NbFHl4dryb2gjApCq0SVFzgrZDH6vhwwlOXHUwDPS3UCIWS8uBTShj0J
         kcCX/RLm74VteYbPGsgsgIryEgKJ9kGILF3FTLpqBB3hPcDDj4MeSoSRnuvD3nMTpp
         vz/wviSIYvBVPQz3c6ulPFvgrx4IQsYtKD7jQv9K09BtODaOI3vnmJ4N3+vhoOtfDp
         asG2IIZaJiYVg==
Subject: [PATCH 1/4] xfs: fix quota accounting when a mount is idmapped
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Date:   Sun, 07 Mar 2021 12:25:46 -0800
Message-ID: <161514874609.698643.4736582270457949683.stgit@magnolia>
In-Reply-To: <161514874040.698643.2749449122589431232.stgit@magnolia>
References: <161514874040.698643.2749449122589431232.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Nowadays, we indirectly use the idmap-aware helper functions in the VFS
to set the initial uid and gid of a file being created.  Unfortunately,
we didn't convert the quota code, which means we attach the wrong dquots
to files created on an idmapped mount.

Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/xfs/xfs_inode.c   |   14 ++++++++------
 fs/xfs/xfs_symlink.c |    3 ++-
 2 files changed, 10 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 46a861d55e48..f93370bd7b1e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1007,9 +1007,10 @@ xfs_create(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
-					XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
-					&udqp, &gdqp, &pdqp);
+	error = xfs_qm_vop_dqalloc(dp, fsuid_into_mnt(mnt_userns),
+			fsgid_into_mnt(mnt_userns), prid,
+			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
+			&udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
@@ -1157,9 +1158,10 @@ xfs_create_tmpfile(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
-				XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
-				&udqp, &gdqp, &pdqp);
+	error = xfs_qm_vop_dqalloc(dp, fsuid_into_mnt(mnt_userns),
+			fsgid_into_mnt(mnt_userns), prid,
+			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
+			&udqp, &gdqp, &pdqp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 1379013d74b8..7f368b10ded1 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -182,7 +182,8 @@ xfs_symlink(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, current_fsuid(), current_fsgid(), prid,
+	error = xfs_qm_vop_dqalloc(dp, fsuid_into_mnt(mnt_userns),
+			fsgid_into_mnt(mnt_userns), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)

