Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C98EC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D677564E2D
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhBACFi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:05:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231270AbhBACFa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:05:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 431BB64E32;
        Mon,  1 Feb 2021 02:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145113;
        bh=7fzLQ6AEVsB1FRNLxhjNnHlW53/fzM/yKmAGD6z//v0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d5aZDcmE1Tf+U8Me7cZNXSm3sBf1O/GxjPL4UwdpJTvYGvwGpoH28ta5I04J+F1nO
         I2rbYezIRZ8AhskTyQ8nkT86xFv1AELPyHZLgtE/RkMX8QShYvzzTWKRTnJuIM7GUB
         kw2by5UiflT7KTB5rGiHuCwjVDIL5D0f9w7FXU+Ymip+cxeVsiP+r9tNDHkJ6kdNF1
         Ra9jgzUmvgzMbqcT7RCnophA33Wya19zoWKbSAD03+qeQiIIA0nQiHVKDvRqr7JcLW
         DUhbv/NsBG2FdpEDdPmaYzdmaSpE96LKxAlfwAhzWiWJ7ejSbM5xAeikbooE76K0PF
         PYLQ01ZXXTmUQ==
Subject: [PATCH 15/17] xfs: rename code to error in xfs_ioctl_setattr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:05:12 -0800
Message-ID: <161214511286.139387.10118392312750611346.stgit@magnolia>
In-Reply-To: <161214502818.139387.7678025647736002500.stgit@magnolia>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rename the 'code' variable to 'error' to follow the naming convention of
most other functions in xfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 73cfee8007a8..cf2167b84f5b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1436,13 +1436,13 @@ xfs_ioctl_setattr(
 	struct xfs_trans	*tp;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_dquot	*olddquot = NULL;
-	int			code;
+	int			error;
 
 	trace_xfs_ioctl_setattr(ip);
 
-	code = xfs_ioctl_setattr_check_projid(ip, fa);
-	if (code)
-		return code;
+	error = xfs_ioctl_setattr_check_projid(ip, fa);
+	if (error)
+		return error;
 
 	/*
 	 * If disk quotas is on, we make sure that the dquots do exist on disk,
@@ -1453,44 +1453,44 @@ xfs_ioctl_setattr(
 	 * because the i_*dquot fields will get updated anyway.
 	 */
 	if (XFS_IS_QUOTA_ON(mp)) {
-		code = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
+		error = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
 				VFS_I(ip)->i_gid, fa->fsx_projid,
 				XFS_QMOPT_PQUOTA, NULL, NULL, &pdqp);
-		if (code)
-			return code;
+		if (error)
+			return error;
 	}
 
 	xfs_ioctl_setattr_prepare_dax(ip, fa);
 
 	tp = xfs_ioctl_setattr_get_trans(ip);
 	if (IS_ERR(tp)) {
-		code = PTR_ERR(tp);
+		error = PTR_ERR(tp);
 		goto error_free_dquots;
 	}
 
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
 	    ip->i_d.di_projid != fa->fsx_projid) {
-		code = xfs_trans_reserve_quota_chown(tp, ip, NULL, NULL, pdqp,
+		error = xfs_trans_reserve_quota_chown(tp, ip, NULL, NULL, pdqp,
 				capable(CAP_FOWNER));
-		if (code)	/* out of quota */
+		if (error)	/* out of quota */
 			goto error_trans_cancel;
 	}
 
 	xfs_fill_fsxattr(ip, false, &old_fa);
-	code = vfs_ioc_fssetxattr_check(VFS_I(ip), &old_fa, fa);
-	if (code)
+	error = vfs_ioc_fssetxattr_check(VFS_I(ip), &old_fa, fa);
+	if (error)
 		goto error_trans_cancel;
 
-	code = xfs_ioctl_setattr_check_extsize(ip, fa);
-	if (code)
+	error = xfs_ioctl_setattr_check_extsize(ip, fa);
+	if (error)
 		goto error_trans_cancel;
 
-	code = xfs_ioctl_setattr_check_cowextsize(ip, fa);
-	if (code)
+	error = xfs_ioctl_setattr_check_cowextsize(ip, fa);
+	if (error)
 		goto error_trans_cancel;
 
-	code = xfs_ioctl_setattr_xflags(tp, ip, fa);
-	if (code)
+	error = xfs_ioctl_setattr_xflags(tp, ip, fa);
+	if (error)
 		goto error_trans_cancel;
 
 	/*
@@ -1530,7 +1530,7 @@ xfs_ioctl_setattr(
 	else
 		ip->i_d.di_cowextsize = 0;
 
-	code = xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
 
 	/*
 	 * Release any dquot(s) the inode had kept before chown.
@@ -1538,13 +1538,13 @@ xfs_ioctl_setattr(
 	xfs_qm_dqrele(olddquot);
 	xfs_qm_dqrele(pdqp);
 
-	return code;
+	return error;
 
 error_trans_cancel:
 	xfs_trans_cancel(tp);
 error_free_dquots:
 	xfs_qm_dqrele(pdqp);
-	return code;
+	return error;
 }
 
 STATIC int

