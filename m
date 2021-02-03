Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03979C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 17:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2A9264F84
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 17:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhBCRdj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 12:33:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44930 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbhBCRdh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 12:33:37 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1l7M1M-0006Kw-BV; Wed, 03 Feb 2021 17:32:52 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-xfs@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH -next] xfs: remove the possibly unused mp variable in xfs_file_compat_ioctl
Date:   Wed,  3 Feb 2021 18:30:10 +0100
Message-Id: <20210203173009.462205-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <https://lore.kernel.org/linux-xfs/20210203171633.GX7193@magnolia>
References: <https://lore.kernel.org/linux-xfs/20210203171633.GX7193@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

The mp variable in xfs_file_compat_ioctl is only used when
BROKEN_X86_ALIGNMENT is define.  Remove it and just open code the
dereference in a few places.

Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
As mentioned in the thread, I'd take this on top of Christoph's patch if
people are ok with this:
https://git.kernel.org/brauner/h/idmapped_mounts
---
 fs/xfs/xfs_ioctl32.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 926427b19573..33c09ec8e6c0 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -438,7 +438,6 @@ xfs_file_compat_ioctl(
 {
 	struct inode		*inode = file_inode(filp);
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
 	void			__user *arg = compat_ptr(p);
 	int			error;
 
@@ -458,7 +457,7 @@ xfs_file_compat_ioctl(
 		return xfs_ioc_space(filp, &bf);
 	}
 	case XFS_IOC_FSGEOMETRY_V1_32:
-		return xfs_compat_ioc_fsgeometry_v1(mp, arg);
+		return xfs_compat_ioc_fsgeometry_v1(ip->i_mount, arg);
 	case XFS_IOC_FSGROWFSDATA_32: {
 		struct xfs_growfs_data	in;
 
@@ -467,7 +466,7 @@ xfs_file_compat_ioctl(
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
-		error = xfs_growfs_data(mp, &in);
+		error = xfs_growfs_data(ip->i_mount, &in);
 		mnt_drop_write_file(filp);
 		return error;
 	}
@@ -479,7 +478,7 @@ xfs_file_compat_ioctl(
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
-		error = xfs_growfs_rt(mp, &in);
+		error = xfs_growfs_rt(ip->i_mount, &in);
 		mnt_drop_write_file(filp);
 		return error;
 	}

base-commit: f736d93d76d3e97d6986c6d26c8eaa32536ccc5c
-- 
2.30.0

