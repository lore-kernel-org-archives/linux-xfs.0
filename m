Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF7D5C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 23:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346780AbiAKXWy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 18:22:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41138 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346779AbiAKXWy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 18:22:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B567B81BE7
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jan 2022 23:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A29C36AE3;
        Tue, 11 Jan 2022 23:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641943371;
        bh=jfprXxCAz9CumA9aM7YLHwN1GbTC84I/eCUxOikuLsI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NGIJmZ13DQHGAHVOXdyovNpUt0AwclRUto1fP+A+GtR8ewqytx6WH6XuY3/9QzN23
         Og7cY78zqKVPxIT5a1nQ+Muv1PC+JBJIpPAdYDqcSWRLVaPbvQq3igY78DkX3gKS9R
         pZx73dtljCSAfTVgH5s7lZ2S1X9o8+9ePveSeXkEivEJS8oQPCeYdocRk0Rxg6JyKf
         8PH9OXtHq4bHaN47oJhbq845YMN38h8fn4GPPz+H2WNp6mJW7QQYEJmfulyjBU1j3q
         kbAzOfyMFjC0sWYvBFHPCUQ6E6NKr3BEEDiey0DLgMFoVnUXWOtvxWXGEektdkD8ok
         IjCESkTRuACyA==
Subject: [PATCH 2/3] xfs: remove the XFS_IOC_{ALLOC,FREE}SP* definitions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 11 Jan 2022 15:22:51 -0800
Message-ID: <164194337151.3069025.17880180520706863793.stgit@magnolia>
In-Reply-To: <164194336019.3069025.16691952615002573445.stgit@magnolia>
References: <164194336019.3069025.16691952615002573445.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've made these ioctls defunct, move them from xfs_fs.h to
xfs_ioctl.c, which effectively removes them from the publicly supported
ioctl interfaces for XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
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
index 64a7ef4a7298..03a6198c97f6 100644
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

