Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52018 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752076AbeA3Dg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jan 2018 22:36:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0U3WbLG013189
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2018 03:36:58 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2ftfd208bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2018 03:36:57 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0U3avKI028748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2018 03:36:57 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0U3auUO026797
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2018 03:36:56 GMT
Date: Mon, 29 Jan 2018 19:36:56 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix u32 type usage in sb validation function
Message-ID: <20180130033656.GK9068@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't use u32, use uint32_t, because this won't work in xfsprogs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_sb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 46af6aa..a55f7a4 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -118,8 +118,8 @@ xfs_mount_validate_sb(
 	bool		check_inprogress,
 	bool		check_version)
 {
-	u32		agcount = 0;
-	u32		rem;
+	uint32_t	agcount = 0;
+	uint32_t	rem;
 
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
 		xfs_warn(mp, "bad magic number");
