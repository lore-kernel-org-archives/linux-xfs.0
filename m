Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F52FA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 458912087E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="plm7+Htc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbfKHHII (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:08:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHHII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:08:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873hcw054894
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:08:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=JMSi1systEtUfadWWRlvtH7S17nJZe4Rgt3ChIFQJzg=;
 b=plm7+HtcHw3maxWVhNA9ekmmgqsJgdL11nFrHkCFTidsO5d87caUkmVOt3K5QBl2DXFG
 zbVQAHeE0lQqV1OzvCjeG0uY2ASTi4Rq2dyy9XLubbh7oezJxWUIES6JjqC82D1IuYbH
 WL+qoks33oplCoEfZB9c+fWVFKG6g6Pr124lc4xCLi8N+GD6WD6OiLI5xueHX3/P5Syk
 AYw2fvb1mn8o6FAnv5JEY0AQ6X+5zxhSGiw5/iyDUBspjZBUbCJYAJ84g3+EmnRf4eBn
 qOaS2iPm4uee6poxf3PqjiPCnPS1TE3PO8JXh9omGNixVFit+jeOsWNXUP2mCqtBhl9U mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w41w13bxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:08:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8737xs059474
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:06:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w4k30haxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:06:06 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA8766XB014357
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:06:06 GMT
Received: from localhost (/10.159.155.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 23:06:06 -0800
Subject: [PATCH 06/10] xfs: report symlink block corruption errors to the
 health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 07 Nov 2019 23:06:05 -0800
Message-ID: <157319676510.834783.10204474278449519548.stgit@magnolia>
In-Reply-To: <157319672612.834783.1318671695966912922.stgit@magnolia>
References: <157319672612.834783.1318671695966912922.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080069
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
index 6e8eed4f4955..ce94ee0fe10a 100644
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
 

