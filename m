Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42898 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfCAX2T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:28:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NOI5c122749
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:18 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qtupeten3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:28:17 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NSGeK001428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:17 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x21NSGYV029763
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:16 GMT
Subject: [PATCH 13/23] xfs_repair: reinitialize the root directory nlink
 correctly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:28:15 -0800
Message-ID: <155148289561.16677.8657255567421403873.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In mk_root_dir, we reinitialize the root directory inode with a link
count of 1.  This differs from mkfs parseproto, which initializes the
root to have a link count of 2.  The nlink discrepancy in repair is
caught and corrected during phase 7, but this is unnecessary since we
should set it properly in the first place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 9477bc25..8a50b350 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -891,7 +891,7 @@ mk_root_dir(xfs_mount_t *mp)
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
-	set_nlink(VFS_I(ip), 1);	/* account for . */
+	set_nlink(VFS_I(ip), 2);	/* account for . and .. */
 
 	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
 	if (ip->i_d.di_version == 3) {
