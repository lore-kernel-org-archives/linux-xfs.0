Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD04FC6194
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBB382077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:03:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q+AnjFrw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732771AbfKGDDt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:03:49 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56554 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732304AbfKGDDt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:03:49 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72x4eX023946
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=9lXyuxfqkpHD6xajPCsZpMtHnoiwOpHP5NtnnOUWDB0=;
 b=Q+AnjFrwb9mg1EKFERH5axUE6X23KBCRPvQEUtcNJTMFJwyqT71O2CIwGP+metr2Hvyz
 atWidzyGnLcnWSuQL9tkI+StY9hp6UxMllYRtSkeTay3ehsqTPj9+UrdSd47Rzv6j2k4
 3J5FbOZ3cTRpPa/CxVq2pUDYQmbiS+C+MXij7Wrl6kUDLdm4tYaZyXJ/hgDhGMvBIDgB
 1FdBM/f2ZdMYngrDNdozIau1Jv7uwI978vewH9xl6/0DRzrAjq7QDAZMYcVxgMSlkeyp
 +viqf3GUFvQGnyNpI7qzgZcB81u/+kn1d4+JPGWH7rG464VAyf17JB6NNR1SAPvbG9eR Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w41w0u0py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:03:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA733gFc180346
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w41wds6tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:03:46 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA733hbG004978
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:03:43 -0800
Subject: [PATCH 06/10] xfs: report symlink block corruption errors to the
 health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 Nov 2019 19:03:41 -0800
Message-ID: <157309582151.46704.5903688272813644793.stgit@magnolia>
In-Reply-To: <157309578380.46704.8292405543138526332.stgit@magnolia>
References: <157309578380.46704.8292405543138526332.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter corrupt symbolic link blocks, we should report
that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iops.c    |    2 ++
 fs/xfs/xfs_symlink.c |    6 ++++++
 2 files changed, 8 insertions(+)


diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c4711a8c565e..ce94ee0fe10a 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -21,6 +21,7 @@
 #include "xfs_dir2.h"
 #include "xfs_iomap.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
@@ -482,6 +483,7 @@ xfs_vn_get_link_inline(
 	 */
 	link = ip->i_df.if_u1.if_data;
 	if (XFS_IS_CORRUPT(ip->i_mount, !link)) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 	return link;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index a25502bc2071..f5926985d24f 100644
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
@@ -502,6 +507,7 @@ xfs_inactive_symlink(
 			 __func__, (unsigned long long)ip->i_ino, pathlen);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		ASSERT(0);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 		return -EFSCORRUPTED;
 	}
 

