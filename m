Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55780 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbfAACVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:21:42 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012DuTg168356
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:40 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2pnxedxau1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:21:40 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012LY3m028303
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:34 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012LYxt007835
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:34 GMT
Subject: [PATCH 22/22] xfs: create library function to reset root inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:21:33 -0800
Message-ID: <154630929346.18437.14185691799928569579.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a library function to reset a root inode, which xfs_repair will
take advantage of in xfsprogs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |   24 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    1 +
 2 files changed, 25 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 01a320747ddf..00cda9046c8e 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -416,6 +416,30 @@ xfs_ialloc(
 	return 0;
 }
 
+/*
+ * Forcibly reinitialize a fixed-location inode, such as a filesystem root
+ * directory or the realtime metadata inodes.  The inode must not otherwise be
+ * in use, and the inode's forks must already be empty.
+ */
+int
+xfs_fixed_inode_reset(
+	struct xfs_trans		*tp,
+	umode_t				mode,
+	struct xfs_inode		*ip)
+{
+	struct xfs_ialloc_args	args = {
+		.ops			= &xfs_default_ialloc_ops,
+		.nlink			= S_ISDIR(mode) ? 2 : 1,
+		.mode			= mode,
+	};
+	struct xfs_mount		*mp = tp->t_mountp;
+
+	ip->i_d.di_version = xfs_sb_version_hascrc(&mp->m_sb) ? 3 : 2;
+
+	xfs_inode_init(tp, &args, ip);
+	return 0;
+}
+
 /*
  * Allocates a new inode from disk and return a pointer to the
  * incore copy. This routine will internally commit the current
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 4918379b682e..5a6f1a348a47 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -97,6 +97,7 @@ extern const struct xfs_ialloc_ops xfs_default_ialloc_ops;
 
 int xfs_dir_ialloc(struct xfs_trans **tpp, const struct xfs_ialloc_args *args,
 		   struct xfs_inode **ipp);
+int xfs_fixed_inode_reset(struct xfs_trans *tp, umode_t mode, struct xfs_inode *ip);
 
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_inode *ip);
