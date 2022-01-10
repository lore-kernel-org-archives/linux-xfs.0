Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0AD0C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 19:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245063AbiAJT7D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 14:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245157AbiAJT65 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 14:58:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F47FC061748
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 11:58:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DC59B817D3
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 19:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B2CC36AE3;
        Mon, 10 Jan 2022 19:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641844734;
        bh=OI1NizlHy/knwqRFgjoWMbzuTh0cNtwYZH/3RdkW0KM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CF8YLjaPKK+i/LRv4Boi37hYOlBJYGoCRPhrTkIcnS/PxPagHPB18G29DcR/gV+Ap
         OVNDBvqu2stqYyIY0KTtbnVBErbCTgCskHOCs6ZGZmFHEL1oDLejmZOgttT9g3qAlk
         AGAk5OAexTCnOoSDR97vHJN9w+rWbY0BvpFSxIDMuEaYch57yibbiwf8YjsI+l0FBh
         lgVIXHGnVeHNtSzkHC0gdxaP9Jf07ddbod+aHrunD3dsNTpMo75iW48etToJPvUh9s
         1Yj916KFaIDrcsNtKf//mHEclLK7RU6c6jponZb4ne8mA2LZDmHfCL8mBNGc3Wm/gc
         c56HMrVwOfwHQ==
Date:   Mon, 10 Jan 2022 11:58:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2 2/2] xfs: hide the XFS_IOC_{ALLOC,FREE}SP* definitions
Message-ID: <20220110195854.GY656707@magnolia>
References: <20220110174827.GW656707@magnolia>
 <20220110175154.GX656707@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110175154.GX656707@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've made these ioctls defunct, move them from xfs_fs.h to
xfs_ioctl.c, which effectively removes them from the publicly supported
ioctl interfaces for XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: nuke the 32-bit compat definitions too
---
 fs/xfs/libxfs/xfs_fs.h |    8 ++++----
 fs/xfs/xfs_ioctl.c     |    9 +++++++++
 fs/xfs/xfs_ioctl32.h   |    4 ----
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c43877c8a279..49c0e583d6bb 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -781,13 +781,13 @@ struct xfs_scrub_metadata {
  * For 'documentation' purposed more than anything else,
  * the "cmd #" field reflects the IRIX fcntl number.
  */
-#define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
-#define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
+/*	XFS_IOC_ALLOCSP ------- deprecated 10	 */
+/*	XFS_IOC_FREESP -------- deprecated 11	 */
 #define XFS_IOC_DIOINFO		_IOR ('X', 30, struct dioattr)
 #define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
 #define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR
-#define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
-#define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
+/*	XFS_IOC_ALLOCSP64 ----- deprecated 36	 */
+/*	XFS_IOC_FREESP64 ------ deprecated 37	 */
 #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)
 #define XFS_IOC_FSSETDM		_IOW ('X', 39, struct fsdmidata)
 #define XFS_IOC_RESVSP		_IOW ('X', 40, struct xfs_flock64)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 38b2a1e881a6..15ec3d4a1516 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1854,6 +1854,15 @@ xfs_fs_eofblocks_from_user(
 	return 0;
 }
 
+/*
+ * These long-unused ioctls were removed from the official ioctl API in 5.17,
+ * but retain these definitions so that we can log warnings about them.
+ */
+#define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
+#define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
+#define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
+#define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
+
 /*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.
diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
index 9929482bf358..fc5a91f3a5e0 100644
--- a/fs/xfs/xfs_ioctl32.h
+++ b/fs/xfs/xfs_ioctl32.h
@@ -154,10 +154,6 @@ typedef struct compat_xfs_flock64 {
 	__s32		l_pad[4];	/* reserve area */
 } compat_xfs_flock64_t;
 
-#define XFS_IOC_ALLOCSP_32	_IOW('X', 10, struct compat_xfs_flock64)
-#define XFS_IOC_FREESP_32	_IOW('X', 11, struct compat_xfs_flock64)
-#define XFS_IOC_ALLOCSP64_32	_IOW('X', 36, struct compat_xfs_flock64)
-#define XFS_IOC_FREESP64_32	_IOW('X', 37, struct compat_xfs_flock64)
 #define XFS_IOC_RESVSP_32	_IOW('X', 40, struct compat_xfs_flock64)
 #define XFS_IOC_UNRESVSP_32	_IOW('X', 41, struct compat_xfs_flock64)
 #define XFS_IOC_RESVSP64_32	_IOW('X', 42, struct compat_xfs_flock64)
