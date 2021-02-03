Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C53BC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 12:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A21F64E40
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 12:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhBCMmK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 07:42:10 -0500
Received: from verein.lst.de ([213.95.11.211]:50969 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhBCMmF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 07:42:05 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9C0A768AFE; Wed,  3 Feb 2021 13:41:18 +0100 (CET)
Date:   Wed, 3 Feb 2021 13:41:17 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH -next] xfs: Fix unused variable 'mp' warning
Message-ID: <20210203124117.GA16923@lst.de>
References: <1612341558-22171-1-git-send-email-zhangshaokun@hisilicon.com> <20210203093037.v2bhmjqrq7n5mlxx@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203093037.v2bhmjqrq7n5mlxx@wittgenstein>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I don't think declaring a variable inside a switch statement is a good
idea.  This is what I had lying around but never got around finishing
up and submitting:

---
From 5e79886f08ca4dd96c9a508a380dfeb73cd4b529 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Wed, 3 Feb 2021 13:38:27 +0100
Subject: xfs: remove the possibly unused mp variable in xfs_file_compat_ioctl

The mp variable in xfs_file_compat_ioctl is only used when
BROKEN_X86_ALIGNMENT is define.  Remove it and just open code the
dereference in a few places.

Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl32.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index e11139e18021c1..daf73cb53a05bb 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -420,7 +420,6 @@ xfs_file_compat_ioctl(
 {
 	struct inode		*inode = file_inode(filp);
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
 	void			__user *arg = compat_ptr(p);
 	int			error;
 
@@ -429,7 +428,7 @@ xfs_file_compat_ioctl(
 	switch (cmd) {
 #if defined(BROKEN_X86_ALIGNMENT)
 	case XFS_IOC_FSGEOMETRY_V1_32:
-		return xfs_compat_ioc_fsgeometry_v1(mp, arg);
+		return xfs_compat_ioc_fsgeometry_v1(ip->i_mount, arg);
 	case XFS_IOC_FSGROWFSDATA_32: {
 		struct xfs_growfs_data	in;
 
@@ -438,7 +437,7 @@ xfs_file_compat_ioctl(
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
-		error = xfs_growfs_data(mp, &in);
+		error = xfs_growfs_data(ip->i_mount, &in);
 		mnt_drop_write_file(filp);
 		return error;
 	}
@@ -450,7 +449,7 @@ xfs_file_compat_ioctl(
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
-		error = xfs_growfs_rt(mp, &in);
+		error = xfs_growfs_rt(ip->i_mount, &in);
 		mnt_drop_write_file(filp);
 		return error;
 	}
@@ -480,7 +479,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_FSBULKSTAT_32:
 	case XFS_IOC_FSBULKSTAT_SINGLE_32:
 	case XFS_IOC_FSINUMBERS_32:
-		return xfs_compat_ioc_fsbulkstat(mp, cmd, arg);
+		return xfs_compat_ioc_fsbulkstat(ip->i_mount, cmd, arg);
 	case XFS_IOC_FD_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_FSHANDLE_32: {
-- 
2.29.2

