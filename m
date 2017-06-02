Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21557 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBWTq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 18:19:46 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52MJiYU026002
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:19:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v52MJiY0002077
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:19:44 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v52MJh2X028625
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:19:44 GMT
Date: Fri, 2 Jun 2017 15:19:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/13] xfs: allow reading of already-locked remote symbolic
 link
Message-ID: <20170602221942.GE5636@birch.djwong.org>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Expose the readlink variant that doesn't take the inode lock so that
the scrubber can inspect symlink contents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_symlink.c |    6 +++---
 fs/xfs/xfs_symlink.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index f2cb45e..49380485 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -43,8 +43,8 @@
 #include "xfs_log.h"
 
 /* ----- Kernel only functions below ----- */
-STATIC int
-xfs_readlink_bmap(
+int
+xfs_readlink_bmap_ilocked(
 	struct xfs_inode	*ip,
 	char			*link)
 {
@@ -153,7 +153,7 @@ xfs_readlink(
 	}
 
 
-	error = xfs_readlink_bmap(ip, link);
+	error = xfs_readlink_bmap_ilocked(ip, link);
 
  out:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
index e75245d..aeaee89 100644
--- a/fs/xfs/xfs_symlink.h
+++ b/fs/xfs/xfs_symlink.h
@@ -21,6 +21,7 @@
 
 int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
 		const char *target_path, umode_t mode, struct xfs_inode **ipp);
+int xfs_readlink_bmap_ilocked(struct xfs_inode *ip, char *link);
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_inactive_symlink(struct xfs_inode *ip);
 
