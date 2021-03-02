Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1BAC433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 192B761494
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245637AbhCCDPq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:15:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2360756AbhCBW3D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 17:29:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7F4F64F16;
        Tue,  2 Mar 2021 22:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614724103;
        bh=J/GN6yPJ8t6nUTd2Aux7fK3VlCE0SSkPm1Eqvx76NjE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p6goIsp6l7QFCjCIWGXg43EwRf7uzBUxZZ0aQxoYLSvRN0ythV7XdfOtBKiYlIjeU
         lXLnooGPzaK6rADj8sXNmxRVFxonXyMVYb4XhIrVX7T5YbGgSm5WWQ4pRYCOxsESY3
         Di4fU87uGRobDD1/yeTQ6o5pEL6u5sRdFnIFG4pIl8JWkrs/XAQf9kmBdRv19GHowR
         o6mL2xXDe+K+B9Jr1Qvc3b6pdxq6ynubHCqq6jfyNOrQE5A3+hLmBcnHCz6Gm96xVs
         x1WgTXERnG8Iqk8fWYyWNYSuBQeZxZId53Dny9/aOETVDpazok1Ng2I+DzgNLy3mbW
         dt4y0nfqBlArw==
Subject: [PATCH 1/3] xfs: fix quota accounting when a mount is idmapped
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Date:   Tue, 02 Mar 2021 14:28:22 -0800
Message-ID: <161472410230.3421449.11155796770029064636.stgit@magnolia>
In-Reply-To: <161472409643.3421449.2100229515469727212.stgit@magnolia>
References: <161472409643.3421449.2100229515469727212.stgit@magnolia>
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

