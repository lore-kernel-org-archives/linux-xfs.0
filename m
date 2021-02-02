Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D934FC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF40264EDA
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBBCE7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 21:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231168AbhBBCE6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 21:04:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A24C64EDF;
        Tue,  2 Feb 2021 02:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612231483;
        bh=xYdAMKL3sI/3pyb+Pv5isSaHkjxuUo2cSzs3rUikjzQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rivXvjAyWA8+5XJda2xsK3VzAU9zqE/8XwIQ/1P10vlEXRDxgqqgjAcTJg3UjNC6u
         YoD9P18B6ey018gpz3qcEETvKorCHScBX9ZSMFgkFURrKqjHqVbII38EtBj1vgZ1j6
         3APebU/c9bgwmtN4FvB3l3YzaEoUQ1sEqbZJXvO2nGvKs21zI5wm25e/QIPETXvNTV
         YIoX9+JZYLyj68Wdbm8snbdnOhuQyJn0SQ7Mq2UEYIzEUVPpl/rGa2CowgZSHNLKRd
         edeENfSYMsOLOv3CHSPtsKYAjFaunMPuOSULxqDt11ot6zTzMQ5JTprZ4JAfKIBv9s
         yZzMeAk8m09Eg==
Subject: [PATCH 15/16] xfs: rename code to error in xfs_ioctl_setattr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Mon, 01 Feb 2021 18:04:43 -0800
Message-ID: <161223148300.491593.4733623201150889540.stgit@magnolia>
In-Reply-To: <161223139756.491593.10895138838199018804.stgit@magnolia>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
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
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 78ee201eb7cb..38ee66d999d8 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1435,13 +1435,13 @@ xfs_ioctl_setattr(
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
@@ -1452,36 +1452,36 @@ xfs_ioctl_setattr(
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
 
 	tp = xfs_ioctl_setattr_get_trans(ip, pdqp);
 	if (IS_ERR(tp)) {
-		code = PTR_ERR(tp);
+		error = PTR_ERR(tp);
 		goto error_free_dquots;
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
@@ -1521,7 +1521,7 @@ xfs_ioctl_setattr(
 	else
 		ip->i_d.di_cowextsize = 0;
 
-	code = xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
 
 	/*
 	 * Release any dquot(s) the inode had kept before chown.
@@ -1529,13 +1529,13 @@ xfs_ioctl_setattr(
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

