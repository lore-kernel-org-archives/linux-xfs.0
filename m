Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F80C43381
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E3F364E2A
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhBACEy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:04:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhBACEw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:04:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E97964E28;
        Mon,  1 Feb 2021 02:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145051;
        bh=uLc5pK5LO7wEQz18AhHMhVq5QSHYJCHF+kMynuACPK8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Gbj/hAT/hNIAbMU9ujQQ2wx+qCKydxOha+CkA3bMZZK8Ggdpzyfgnes+4yusDorJ1
         Vwq+Igup7moey1qT0vAq+obAXNu4kvJu+7od/patpEMzCyuWdDVpwen4Dcs/jkyRTf
         56EZ8DhbbMNHF5sjZsD40HIDJGXBv02/cPZFJc6/3vry2ZMtaAkqugSLEVuRV9o6Ki
         j7YICApG5wkl1ghPl+VjjAvGsUdJ74Sb4V6LC9U+3ce8imGeR2a6cG8JJZGCMYOyWc
         khS7t0o8RrIfO9l+ESIlURUZ1bXhUpOyoMrB459jvSd0Uv6DuqF7stVCcLpTjFbcQP
         QWX8rzXRM3mIw==
Subject: [PATCH 04/17] xfs: remove xfs_trans_unreserve_quota_nblks completely
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:04:11 -0800
Message-ID: <161214505142.139387.8659398857543450856.stgit@magnolia>
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

xfs_trans_cancel will release all the quota resources that were reserved
on behalf of the transaction, so get rid of the explicit unreserve step.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c |   11 ++++-------
 fs/xfs/xfs_iomap.c     |    6 ++----
 fs/xfs/xfs_quota.h     |    2 --
 fs/xfs/xfs_reflink.c   |    5 +----
 4 files changed, 7 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 792809debaaa..ae2d98af693c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -820,12 +820,12 @@ xfs_alloc_file_space(
 		error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks,
 						      0, quota_flag);
 		if (error)
-			goto error1;
+			goto error;
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
-			goto error0;
+			goto error;
 
 		xfs_trans_ijoin(tp, ip, 0);
 
@@ -833,7 +833,7 @@ xfs_alloc_file_space(
 					allocatesize_fsb, alloc_type, 0, imapp,
 					&nimaps);
 		if (error)
-			goto error0;
+			goto error;
 
 		/*
 		 * Complete the transaction
@@ -856,10 +856,7 @@ xfs_alloc_file_space(
 
 	return error;
 
-error0:	/* unlock inode, unreserve quota blocks, cancel trans */
-	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
-
-error1:	/* Just cancel transaction */
+error:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 514e6ae010e0..de0e371ba4dd 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -253,7 +253,7 @@ xfs_iomap_write_direct(
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
-		goto out_res_cancel;
+		goto out_trans_cancel;
 
 	xfs_trans_ijoin(tp, ip, 0);
 
@@ -265,7 +265,7 @@ xfs_iomap_write_direct(
 	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb, bmapi_flags, 0,
 				imap, &nimaps);
 	if (error)
-		goto out_res_cancel;
+		goto out_trans_cancel;
 
 	/*
 	 * Complete the transaction
@@ -289,8 +289,6 @@ xfs_iomap_write_direct(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 
-out_res_cancel:
-	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
 out_trans_cancel:
 	xfs_trans_cancel(tp);
 	goto out_unlock;
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 1d1a1634ea29..31d0de899cc4 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -164,8 +164,6 @@ xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
 #define xfs_qm_unmount_quotas(mp)
 #endif /* CONFIG_XFS_QUOTA */
 
-#define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
-	xfs_trans_reserve_quota_nblks(tp, ip, -(nblks), -(ninos), flags)
 #define xfs_trans_reserve_quota(tp, mp, ud, gd, pd, nb, ni, f) \
 	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
 				f | XFS_QMOPT_RES_REGBLKS)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index bea64ed5a57f..15435229bc1f 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -411,7 +411,7 @@ xfs_reflink_allocate_cow(
 			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, cmap,
 			&nimaps);
 	if (error)
-		goto out_unreserve;
+		goto out_trans_cancel;
 
 	xfs_inode_set_cowblocks_tag(ip);
 	error = xfs_trans_commit(tp);
@@ -436,9 +436,6 @@ xfs_reflink_allocate_cow(
 	trace_xfs_reflink_convert_cow(ip, cmap);
 	return xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
 
-out_unreserve:
-	xfs_trans_unreserve_quota_nblks(tp, ip, (long)resblks, 0,
-			XFS_QMOPT_RES_REGBLKS);
 out_trans_cancel:
 	xfs_trans_cancel(tp);
 	return error;

