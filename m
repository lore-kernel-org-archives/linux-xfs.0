Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36196 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdHaUfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 16:35:02 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7VKZ1Ja023162
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7VKZ0aY011282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:00 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7VKZ0vR024725
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 20:35:00 GMT
Subject: [PATCH 15/19] xfs: enable realtime rmap btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Aug 2017 13:34:58 -0700
Message-ID: <150421169810.17458.16479166319701227352.stgit@magnolia>
In-Reply-To: <150421160433.17458.10817316901867396010.stgit@magnolia>
References: <150421160433.17458.10817316901867396010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5044352..fd31943 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1662,16 +1662,9 @@ xfs_fs_fill_super(
 		"DAX and reflink have not been tested together!");
 	}
 
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-		if (mp->m_sb.sb_rblocks) {
-			xfs_alert(mp,
-	"EXPERIMENTAL reverse mapping btree not compatible with realtime device!");
-			error = -EINVAL;
-			goto out_filestream_unmount;
-		}
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		xfs_alert(mp,
 	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
-	}
 
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
 		xfs_alert(mp,

