Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC04C35247
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9062721582
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 17:59:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XvWiZH68"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgBCR7G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 12:59:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39376 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728278AbgBCR7F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 12:59:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580752744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NGRmFzCW9EzSzTykkNFuSP5Yv9tuXzFPXb7FKqe7oIg=;
        b=XvWiZH68mUB+JOgcDG+3dEobFCJzk7UwMBMY1xP9ItTwFWCcikOf5A7lll9hmPdzEKh+Vd
        ejXQBRpVOeIANeYgPm4BXjUoOKFzCeDVdZGoo8Bgth8tiLPHy/k0SJqvo1ygjRbNGmcbTR
        CsoMJokFPtP9Mc8l+Ql6xY29xA6Ew1s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-G_BOR8u4OJOCyLb-N3ClnA-1; Mon, 03 Feb 2020 12:59:03 -0500
X-MC-Unique: G_BOR8u4OJOCyLb-N3ClnA-1
Received: by mail-wr1-f71.google.com with SMTP id n23so2111622wra.20
        for <linux-xfs@vger.kernel.org>; Mon, 03 Feb 2020 09:59:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NGRmFzCW9EzSzTykkNFuSP5Yv9tuXzFPXb7FKqe7oIg=;
        b=XZ7/g45Q3EeZ0spQr+4bbYjCaphHpXV2zfc2RL9vWpAwcPzClnHF0CatvJLw9HQPWX
         Ppx9moV7/TbQsSQko1gq786z6+r8csi/JWHe7Qgj3n+MmiDTaVe5VNX4KAyhFAPkMBDn
         Y5jiQC1IvBPvAKXsKEgZ5CdkMIvMISA3ZQMeyezJSG379F8InLOqa7zj4tVQbsqEf6nX
         fngW1NXr+gs7X1wCBZdrId7Q2AK0n/GsVd0cVWBbZRoa/zlbyNlignSenqmU18qqQkjo
         Rr9CUYD4B8dAoeX/ymrINffUfTQUvUG1BfEvqzbk1aL2ArHgywJwFSHfJ5aFWjkzLQfA
         doIA==
X-Gm-Message-State: APjAAAV3eFhrqbDgnJANUONxTKzhnRvE6xOsDKssAXC55xtD32Ta8/lG
        II7nyCpkyZ2up5+W+Us2xHhw+sTcFjS7dwVwhnVM/CJF9mtu7v+5g9dAe+zA3sM3eR0r5n85RqH
        EZHea7lyug/dClJx0rBgy
X-Received: by 2002:a05:600c:2c06:: with SMTP id q6mr254611wmg.154.1580752741599;
        Mon, 03 Feb 2020 09:59:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqzUGowvOj3mN9Oqt7uHtd344sI3cDRX3HqYaDqrXlduWCAcsqm85GhM7ypRcdv9d1R/igEkWg==
X-Received: by 2002:a05:600c:2c06:: with SMTP id q6mr254594wmg.154.1580752741391;
        Mon, 03 Feb 2020 09:59:01 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id a132sm212274wme.3.2020.02.03.09.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 09:59:00 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v2 3/7] xfs: Update checking read or write locks for ilock
Date:   Mon,  3 Feb 2020 18:58:46 +0100
Message-Id: <20200203175850.171689-4-preichl@redhat.com>
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
 fs/xfs/libxfs/xfs_attr.c       | 2 +-
 fs/xfs/libxfs/xfs_bmap.c       | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/xfs_attr_list.c         | 2 +-
 fs/xfs/xfs_inode.c             | 6 +++---
 fs/xfs/xfs_qm.c                | 2 +-
 fs/xfs/xfs_symlink.c           | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e6149720ce02..e692225d2e64 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -107,7 +107,7 @@ xfs_attr_get_ilocked(
 	struct xfs_inode	*ip,
 	struct xfs_da_args	*args)
 {
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 
 	if (!xfs_inode_hasattr(ip))
 		return -ENOATTR;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 318c006b4b50..86a9fe2a7629 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3906,7 +3906,7 @@ xfs_bmapi_read(
 	ASSERT(*nmap >= 1);
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK|XFS_BMAPI_ENTIRE|
 			   XFS_BMAPI_COWFORK)));
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index ad2b9c313fd2..ffb5731a73da 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -560,7 +560,7 @@ xfs_iextents_copy(
 	struct xfs_bmbt_irec	rec;
 	int64_t			copied = 0;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 	ASSERT(ifp->if_bytes > 0);
 
 	for_each_xfs_iext(ifp, &icur, &rec) {
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index d37743bdf274..a52539a0fd63 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -511,7 +511,7 @@ xfs_attr_list_int_ilocked(
 {
 	struct xfs_inode		*dp = context->dp;
 
-	ASSERT(xfs_isilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 
 	/*
 	 * Decide on what work routines to call based on the inode size.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a19c6ddaea6f..d7cb2886ca81 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2859,7 +2859,7 @@ static void
 xfs_iunpin(
 	struct xfs_inode	*ip)
 {
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 
 	trace_xfs_inode_unpin_nowait(ip, _RET_IP_);
 
@@ -3723,7 +3723,7 @@ xfs_iflush(
 
 	XFS_STATS_INC(mp, xs_iflush_count);
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
@@ -3855,7 +3855,7 @@ xfs_iflush_int(
 	struct xfs_dinode	*dip;
 	struct xfs_mount	*mp = ip->i_mount;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index dfe155cbaa55..757c8cc00e39 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1802,7 +1802,7 @@ xfs_qm_vop_chown_reserve(
 	int			error;
 
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	delblks = ip->i_delayed_blks;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index d762d42ed0ff..20179f173688 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -41,7 +41,7 @@ xfs_readlink_bmap_ilocked(
 	int			fsblocks = 0;
 	int			offset;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+	ASSERT(xfs_is_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 
 	fsblocks = xfs_symlink_blocks(mp, pathlen);
 	error = xfs_bmapi_read(ip, 0, fsblocks, mval, &nmaps, 0);
-- 
2.24.1

