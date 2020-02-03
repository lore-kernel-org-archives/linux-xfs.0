Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E870BC35249
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B94B82166E
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f+4nul8t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgBCR7F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 12:59:05 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21383 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728474AbgBCR7F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 12:59:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580752743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1EjJz5KdVbkA6I6TdN9r6hpvijYX4ZdASjtTvSKLcdU=;
        b=f+4nul8th2kcc4xF/i3dHGFevozWZ1xjpEflwaDCdMLFK8g51Pxfw4ovol42FMlJw32YCZ
        cCzace8UKzD1wk0bEJolZaHeetnqFq3Ef0N1vvu1yWoDf3LTGzNLSOPBOWLGFR8DJEb95S
        X5VeRj8G5czru0BdE825jxTz2Aru6F8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-S1TEvqMvNeaQF0Fieu90Qw-1; Mon, 03 Feb 2020 12:59:01 -0500
X-MC-Unique: S1TEvqMvNeaQF0Fieu90Qw-1
Received: by mail-wm1-f72.google.com with SMTP id p26so84377wmg.5
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2020 09:59:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1EjJz5KdVbkA6I6TdN9r6hpvijYX4ZdASjtTvSKLcdU=;
        b=oysi/ta0Hwo0jxD0lfnk9oitNk8lOwAld0GDw8GUEbyDx5G6cKJ3/Cqy8jBtaTW7tk
         nFSRP5K/RJ8o6EQ6bPewa0iMlXfzBWIZAjWpN/69qYo8zLkYRdVWIpaCILUMBf7uzKZr
         LJDtD2BIAF+HjZq9c191XFSmfMxUZa/Fd/+pFrnNwMtxlRfoHyF5EGz+zoPC6Gg8GjjH
         fMuUavgZ0TQTbWn/HfamKMEfUh3VVjKAGqElCbUhkChJCJjGZVqUA9WeQlpyRyKWxYAt
         kBkq5Q8tJHC2cqnEI3XZXgbscRSHlt7BfF4/kspKiOUeAP2viRpsYlGfczKa0++RE+Yi
         ITKw==
X-Gm-Message-State: APjAAAX2HB2wJzvx3ldrNuTKnKENKF2UsR32EZyJSBVc12ZGr40ykPCw
        bGMDr+yv5ZsGWXEyBCNcApSTer5ozc6HeqT8H4isoLSmCRCvbAo7kRu7FEQfoB1oOVHReiVptTC
        zV6ocYeXOA0hA8YAz8MOr
X-Received: by 2002:a7b:cf12:: with SMTP id l18mr273950wmg.66.1580752740134;
        Mon, 03 Feb 2020 09:59:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqxAaAKR+3K1KM/0QLOYkkbJdz3UKgUIWE9/+Fx1kvUnp7+oEArzxUFQ35dZ4NdKdm9FC6rN/Q==
X-Received: by 2002:a7b:cf12:: with SMTP id l18mr273914wmg.66.1580752739643;
        Mon, 03 Feb 2020 09:58:59 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id a132sm212274wme.3.2020.02.03.09.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 09:58:59 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v2 2/7] xfs: Update checking excl. locks for ilock
Date:   Mon,  3 Feb 2020 18:58:45 +0100
Message-Id: <20200203175850.171689-3-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203175850.171689-1-preichl@redhat.com>
References: <20200203175850.171689-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c |  2 +-
 fs/xfs/libxfs/xfs_bmap.c        | 10 +++++-----
 fs/xfs/libxfs/xfs_rtbitmap.c    |  2 +-
 fs/xfs/libxfs/xfs_trans_inode.c |  6 +++---
 fs/xfs/xfs_dquot.c              |  4 ++--
 fs/xfs/xfs_inode.c              |  4 ++--
 fs/xfs/xfs_inode_item.c         |  4 ++--
 fs/xfs/xfs_iops.c               |  4 ++--
 fs/xfs/xfs_qm.c                 | 10 +++++-----
 fs/xfs/xfs_reflink.c            |  2 +-
 fs/xfs/xfs_rtalloc.c            |  4 ++--
 fs/xfs/xfs_trans_dquot.c        |  2 +-
 12 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 8b7f74b3bea2..5607c5551095 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -577,7 +577,7 @@ xfs_attr_rmtval_stale(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_buf		*bp;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_CORRUPT(mp, map->br_startblock == DELAYSTARTBLOCK) ||
 	    XFS_IS_CORRUPT(mp, map->br_startblock == HOLESTARTBLOCK))
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9a6d7a84689a..318c006b4b50 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1238,7 +1238,7 @@ xfs_iread_extents(
 	struct xfs_btree_cur	*cur;
 	int			error;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_CORRUPT(mp,
 			   XFS_IFORK_FORMAT(ip, whichfork) !=
@@ -4402,7 +4402,7 @@ xfs_bmapi_write(
 	ASSERT(tp != NULL);
 	ASSERT(len > 0);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!(flags & XFS_BMAPI_REMAP));
 
 	/* zeroing is for currently only for data extents, not metadata */
@@ -4678,7 +4678,7 @@ xfs_bmapi_remap(
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT(len > 0);
 	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
 			   XFS_BMAPI_NORMAP)));
 	ASSERT((flags & (XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC)) !=
@@ -5329,7 +5329,7 @@ __xfs_bunmapi(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(len > 0);
 	ASSERT(nexts >= 0);
 
@@ -5700,7 +5700,7 @@ xfs_bmse_merge(
 	blockcount = left->br_blockcount + got->br_blockcount;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(xfs_bmse_can_merge(left, got, shift));
 
 	new = *left;
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index f42c74cb8be5..4ba9dea9bdf0 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -974,7 +974,7 @@ xfs_rtfree_extent(
 	mp = tp->t_mountp;
 
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
-	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
 	error = xfs_rtcheck_alloc_range(mp, tp, bno, len);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 2b8ccb5b975d..bac474d97574 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -29,7 +29,7 @@ xfs_trans_ijoin(
 {
 	xfs_inode_log_item_t	*iip;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	if (ip->i_itemp == NULL)
 		xfs_inode_item_init(ip, ip->i_mount);
 	iip = ip->i_itemp;
@@ -58,7 +58,7 @@ xfs_trans_ichgtime(
 	struct timespec64	tv;
 
 	ASSERT(tp);
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 
 	tv = current_time(inode);
 
@@ -88,7 +88,7 @@ xfs_trans_log_inode(
 	struct inode	*inode = VFS_I(ip);
 
 	ASSERT(ip->i_itemp != NULL);
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 
 	/*
 	 * Don't bother with i_lock for the I_DIRTY_TIME check here, as races
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index d223e1ae90a6..74d9d00d45ef 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -862,7 +862,7 @@ xfs_qm_dqget_inode(
 	if (error)
 		return error;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(xfs_inode_dquot(ip, type) == NULL);
 
 	id = xfs_qm_id_for_quotatype(ip, type);
@@ -919,7 +919,7 @@ xfs_qm_dqget_inode(
 	}
 
 dqret:
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	trace_xfs_dqget_miss(dqp);
 	*O_dqpp = dqp;
 	return 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 80874c80df6d..a19c6ddaea6f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1574,7 +1574,7 @@ xfs_itruncate_extents_flags(
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
 	       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(new_size <= XFS_ISIZE(ip));
@@ -2805,7 +2805,7 @@ xfs_ifree(
 	int			error;
 	struct xfs_icluster	xic = { 0 };
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(ip->i_d.di_nextents == 0);
 	ASSERT(ip->i_d.di_anextents == 0);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 8bd5d0de6321..6396d7b2038c 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -440,7 +440,7 @@ xfs_inode_item_pin(
 {
 	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 
 	trace_xfs_inode_pin(ip, _RET_IP_);
 	atomic_inc(&ip->i_pincount);
@@ -574,7 +574,7 @@ xfs_inode_item_release(
 	unsigned short		lock_flags;
 
 	ASSERT(ip->i_itemp != NULL);
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 
 	lock_flags = iip->ili_lock_flags;
 	iip->ili_lock_flags = 0;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 81f2f93caec0..eba2ec2a59f1 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -598,7 +598,7 @@ xfs_setattr_mode(
 	struct inode		*inode = VFS_I(ip);
 	umode_t			mode = iattr->ia_mode;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 
 	inode->i_mode &= S_IFMT;
 	inode->i_mode |= mode & ~S_IFMT;
@@ -611,7 +611,7 @@ xfs_setattr_time(
 {
 	struct inode		*inode = VFS_I(ip);
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 
 	if (iattr->ia_valid & ATTR_ATIME)
 		inode->i_atime = iattr->ia_atime;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 0b0909657bad..dfe155cbaa55 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -253,7 +253,7 @@ xfs_qm_dqattach_one(
 	struct xfs_dquot	*dqp;
 	int			error;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	error = 0;
 
 	/*
@@ -323,7 +323,7 @@ xfs_qm_dqattach_locked(
 	if (!xfs_qm_need_dqattach(ip))
 		return 0;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
 		error = xfs_qm_dqattach_one(ip, ip->i_d.di_uid, XFS_DQ_USER,
@@ -354,7 +354,7 @@ xfs_qm_dqattach_locked(
 	 * Don't worry about the dquots that we may have attached before any
 	 * error - they'll get detached later if it has not already been done.
 	 */
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	return error;
 }
 
@@ -1754,7 +1754,7 @@ xfs_qm_vop_chown(
 				 XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
 
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_RUNNING(ip->i_mount));
 
 	/* old dquot */
@@ -1915,7 +1915,7 @@ xfs_qm_vop_create_dqattach(
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b0ce04ffd3cd..1d570ad1cfc9 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -359,7 +359,7 @@ xfs_reflink_allocate_cow(
 	xfs_filblks_t		resaligned;
 	xfs_extlen_t		resblks = 0;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	if (!ip->i_cowfp) {
 		ASSERT(!xfs_is_reflink_inode(ip));
 		xfs_ifork_init_cow(ip);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6209e7b6b895..35906b3c2825 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1121,7 +1121,7 @@ xfs_rtallocate_extent(
 	xfs_fsblock_t	sb;		/* summary file block number */
 	xfs_buf_t	*sumbp;		/* summary file block buffer */
 
-	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 	ASSERT(minlen > 0 && minlen <= maxlen);
 
 	/*
@@ -1278,7 +1278,7 @@ xfs_rtpick_extent(
 	uint64_t	seq;		/* sequence number of file creation */
 	uint64_t	*seqp;		/* pointer to seqno in inode */
 
-	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
 	seqp = (uint64_t *)&VFS_I(mp->m_rbmip)->i_atime;
 	if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM)) {
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index d1b9869bc5fa..ed3a78e6a295 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -808,7 +808,7 @@ xfs_trans_reserve_quota_nblks(
 
 	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
 				XFS_TRANS_DQ_RES_RTBLKS ||
 	       (flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
-- 
2.24.1

