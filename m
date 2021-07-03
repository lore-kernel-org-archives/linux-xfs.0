Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EA2C07E95
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 03:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07E1361421
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 03:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhGCDDy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhGCDDy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:03:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36ED361416
        for <linux-xfs@vger.kernel.org>; Sat,  3 Jul 2021 03:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281281;
        bh=PSK1DpjzIlyvvq7PqKq1WGiwBGsQ4WXoTTwu9qYYczQ=;
        h=Date:From:To:Subject:From;
        b=plb9TL6SsuUfDlbZY7gBAtC4qm7Fek2HgsOE5ZUH5F87xcx/DwVRSDRrP9kqMy9rj
         YxCzRTuf99OU5yJj/taQhyaVdvaYBd0Fz2ppacVYs85sb+dx9jv3w42rlbrZItw3/f
         jiR/d5fcNfH0bs6163B6yswlg5vMdQE2CH5hPDoqLE4oLdJBp+9rLDzLm9HExnks1f
         kibFlv4bCtiR/LbtFt1VSvdcHuLgRXAKKePWXyurvclA7atkGo/3lqT2zvOsTmbTpY
         OgG8BJFcSamSTndUXJ3cyBlg8zy39+yN8e21CPCjYdPaJEzSJrQzVghUxJ5I/AqsJT
         vgT7tcutTMF2A==
Date:   Fri, 2 Jul 2021 20:01:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix warnings in compat_ioctl code
Message-ID: <20210703030120.GB24788@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix some compiler warnings about unused variables.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl32.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index e6506773ba55..ebcc342e3bf8 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -439,7 +439,6 @@ xfs_file_compat_ioctl(
 	struct inode		*inode = file_inode(filp);
 	struct xfs_inode	*ip = XFS_I(inode);
 	void			__user *arg = compat_ptr(p);
-	int			error;
 
 	trace_xfs_file_compat_ioctl(ip);
 
@@ -460,6 +459,7 @@ xfs_file_compat_ioctl(
 		return xfs_compat_ioc_fsgeometry_v1(ip->i_mount, arg);
 	case XFS_IOC_FSGROWFSDATA_32: {
 		struct xfs_growfs_data	in;
+		int			error;
 
 		if (xfs_compat_growfs_data_copyin(&in, arg))
 			return -EFAULT;
@@ -472,6 +472,7 @@ xfs_file_compat_ioctl(
 	}
 	case XFS_IOC_FSGROWFSRT_32: {
 		struct xfs_growfs_rt	in;
+		int			error;
 
 		if (xfs_compat_growfs_rt_copyin(&in, arg))
 			return -EFAULT;
