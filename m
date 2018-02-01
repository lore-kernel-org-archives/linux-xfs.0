Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57270 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932104AbeBAA5L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 19:57:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w110qbpk025290
        for <linux-xfs@vger.kernel.org>; Thu, 1 Feb 2018 00:57:11 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2fuqf3889k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 01 Feb 2018 00:57:10 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w110vAG2022728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 1 Feb 2018 00:57:10 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w110vAYE012513
        for <linux-xfs@vger.kernel.org>; Thu, 1 Feb 2018 00:57:10 GMT
Date: Wed, 31 Jan 2018 16:57:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: don't allow reflink + realtime filesystems
Message-ID: <20180201005709.GM4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

We don't support realtime filesystems with reflink either, so fail
those mounts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a83a9f0..7aba628 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1684,6 +1684,13 @@ xfs_fs_fill_super(
 		}
 	}
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb) && mp->m_sb.sb_rblocks) {
+		xfs_alert(mp,
+	"reflink not compatible with realtime device!");
+		error = -EINVAL;
+		goto out_filestream_unmount;
+	}
+
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && mp->m_sb.sb_rblocks) {
 		xfs_alert(mp,
 	"reverse mapping btree not compatible with realtime device!");
