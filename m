Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8680FC76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240497AbjDFTUN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240553AbjDFTUL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:20:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77F8E78
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:20:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52D5360EA7
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1075C4339B;
        Thu,  6 Apr 2023 19:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808809;
        bh=wT9udBFCWcz9271A97mSvPJncyaSmuV993Nz3YK5qEQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=fsy+i0PMlm/dvu6h7Imn4WVSuPuu0Jhvo77fMLd6TA9dvdx8McO+WDgpHaEuQezpl
         SCYTHitdq0s4pz1+U1oeuD8/p31ZTcIbVrIKALtxjRYxy4art8W0FDV6FeRzi//7Q8
         IoY+7OhJe/vuNDnPsfCKLnDdFT3Cee7i2xZUrV9uX3g4W5TVgbCSRkXv5LTfQNstOq
         cCyM2y49PS8JP5nDVuH2ZITcBSM4SpnamQ6YBuB4vX7K2dVSAbAXiOUHU4YtCfXRtL
         PEr6L9YkJOpG2PMFfYQE2ubow3+8Eszj3Rh+Aey2BUfEJWG1EX77xmR8IRQP1VBbXh
         chi2ceebZGi1g==
Date:   Thu, 06 Apr 2023 12:20:09 -0700
Subject: [PATCH 2/3] xfs: Hold inode locks in xfs_trans_alloc_dir
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080824290.615105.5317579392693812581.stgit@frogsfrogsfrogs>
In-Reply-To: <168080824260.615105.7346122486674782401.stgit@frogsfrogsfrogs>
References: <168080824260.615105.7346122486674782401.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_trans_alloc_dir to hold locks after return.  Caller will be
responsible for manual unlock.  We will need this later to hold locks
across parent pointer operations

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c |   14 ++++++++++++--
 fs/xfs/xfs_trans.c |    9 +++++++--
 2 files changed, 19 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 07b9aae3150e..cb68e6661c96 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1279,10 +1279,15 @@ xfs_link(
 	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
 		xfs_trans_set_sync(tp);
 
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
+	return error;
 
  error_return:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
+	xfs_iunlock(sip, XFS_ILOCK_EXCL);
  std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
@@ -2518,15 +2523,20 @@ xfs_remove(
 
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto std_return;
+		goto out_unlock;
 
 	if (is_dir && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return 0;
 
  out_trans_cancel:
 	xfs_trans_cancel(tp);
+ out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
  std_return:
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8afc0c080861..7e656dd42362 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1356,6 +1356,8 @@ xfs_trans_alloc_ichange(
  * The caller must ensure that the on-disk dquots attached to this inode have
  * already been allocated and initialized.  The ILOCKs will be dropped when the
  * transaction is committed or cancelled.
+ *
+ * Caller is responsible for unlocking the inodes manually upon return
  */
 int
 xfs_trans_alloc_dir(
@@ -1386,8 +1388,8 @@ xfs_trans_alloc_dir(
 
 	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
 
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, dp, 0);
+	xfs_trans_ijoin(tp, ip, 0);
 
 	error = xfs_qm_dqattach_locked(dp, false);
 	if (error) {
@@ -1410,6 +1412,9 @@ xfs_trans_alloc_dir(
 	if (error == -EDQUOT || error == -ENOSPC) {
 		if (!retried) {
 			xfs_trans_cancel(tp);
+			xfs_iunlock(dp, XFS_ILOCK_EXCL);
+			if (dp != ip)
+				xfs_iunlock(ip, XFS_ILOCK_EXCL);
 			xfs_blockgc_free_quota(dp, 0);
 			retried = true;
 			goto retry;

