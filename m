Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582D4C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 17:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238561AbiAJRvz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 12:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238605AbiAJRvz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 12:51:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730E9C061748
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 09:51:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 107ED60A27
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 17:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D9AC36AE3;
        Mon, 10 Jan 2022 17:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641837114;
        bh=3sV3aqUSxekODf+OYrcrmCU5YJdQPPJAgSHRImBmzLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t/wy6AEePSyxCeXJofkfGLaqFcDfJVdDsHISadxq+BI29PEO2by3+RB7wNPk2vgcm
         eQNfvogsIPQP0dl1LQIli4qHag/I5zWMScer1PYCwobVQKcWGkOPlNZewKxJ7Q7b2l
         GBGBIB/zDoNT8J5bJAyOuBl2/jqxiWjWfTel3e4ne+npv6EiIwBR37ZSwG64jZj9jF
         htepJgjbBg0AsLRTXVgg6A0fV04P1IigpevuJ8LjfGysAjeS9VLjabOxWsNG60jOc2
         d7rtzYy4kjyFzt4oXoC7DYv38hSXbpDGYKUNvvL4/dV4huXBoPITpwbOhiVvEwmITK
         B72SbiU7fvCRQ==
Date:   Mon, 10 Jan 2022 09:51:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH 2/2] xfs: hide the XFS_IOC_{ALLOC,FREE}SP* definitions
Message-ID: <20220110175154.GX656707@magnolia>
References: <20220110174827.GW656707@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110174827.GW656707@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've made these ioctls defunct, move them from xfs_fs.h to
xfs_ioctl.c, which effectively removes them from the publicly supported
ioctl interfaces for XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |    8 ++++----
 fs/xfs/xfs_ioctl.c     |    9 +++++++++
 2 files changed, 13 insertions(+), 4 deletions(-)

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
