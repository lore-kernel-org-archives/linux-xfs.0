Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33461C2D0DD
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0924D206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:05:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ST529jWy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgAABF1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:05:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgAABF1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:05:27 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115MXN089341
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=YN+PFl4subygroghfOAaYKilxE0Pu0J9St+HQhtiMtg=;
 b=ST529jWyrHn84HvP4Rwa42yuTUpSVHGXUk1Gph1wrqLuukIgWOhJMU2YfEdrmzciPMyK
 9GSB+JSLk63NNo3QTQuaSswGjVkXd0Xc6xzBjrXqrbY4xrb7mRjUrzwmpO3upeo8Rbx6
 qQCtzYDDT5ids9LdAVt893KzqBD1fA0o1K1weAULOlq8Kgv+29A2GxBK7fF4UU+V/qu/
 +y6bJEvW/5eKSdvcw/Zk+gRov5LyamLSxNBNC6zEg2jEgyYPx5EACqBYw8QcwktPW/9n
 knkyruhp3tRwAShiPCfjKznPX652uZYYtdyNdj3KTANcvmeM8tXElLomqaZgx/shr5Vu jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x5ypqjw8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:05:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115DZo006646
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2x8guedxby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:05:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00115O4d004342
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:24 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:05:24 -0800
Subject: [PATCH 06/10] xfs: report symlink block corruption errors to the
 health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:05:22 -0800
Message-ID: <157784072197.1360095.3618092623137892441.stgit@magnolia>
In-Reply-To: <157784067947.1360095.12276226432994685051.stgit@magnolia>
References: <157784067947.1360095.12276226432994685051.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter corrupt symbolic link blocks, we should report
that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iops.c    |    5 ++++-
 fs/xfs/xfs_symlink.c |    6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 8afe69ca188b..f698351cee5d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -21,6 +21,7 @@
 #include "xfs_dir2.h"
 #include "xfs_iomap.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
@@ -481,8 +482,10 @@ xfs_vn_get_link_inline(
 	 * if_data is junk.
 	 */
 	link = ip->i_df.if_u1.if_data;
-	if (XFS_IS_CORRUPT(ip->i_mount, !link))
+	if (XFS_IS_CORRUPT(ip->i_mount, !link)) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 		return ERR_PTR(-EFSCORRUPTED);
+	}
 	return link;
 }
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index bedd9a8be75f..bc6cf78a44ef 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -21,6 +21,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_health.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -63,6 +64,8 @@ xfs_readlink_bmap_ilocked(
 			xfs_buf_relse(bp);
 
 			/* bad CRC means corrupted metadata */
+			if (xfs_metadata_is_sick(error))
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 			if (error == -EFSBADCRC)
 				error = -EFSCORRUPTED;
 			goto out;
@@ -75,6 +78,7 @@ xfs_readlink_bmap_ilocked(
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			if (!xfs_symlink_hdr_ok(ip->i_ino, offset,
 							byte_cnt, bp)) {
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 				error = -EFSCORRUPTED;
 				xfs_alert(mp,
 "symlink header does not match required off/len/owner (0x%x/Ox%x,0x%llx)",
@@ -130,6 +134,7 @@ xfs_readlink(
 			 __func__, (unsigned long long) ip->i_ino,
 			 (long long) pathlen);
 		ASSERT(0);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -520,6 +525,7 @@ xfs_inactive_symlink(
 			 __func__, (unsigned long long)ip->i_ino, pathlen);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		ASSERT(0);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 		return -EFSCORRUPTED;
 	}
 

