Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83236C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59EA0206C0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:20:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V33WLkpa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389074AbgFYBUk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 21:20:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50690 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388930AbgFYBUj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 21:20:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P16raD081807;
        Thu, 25 Jun 2020 01:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZcZHQ5Kn3rGbgmzbSz17s+XOi7AYr1Q0oB9iyByf4w8=;
 b=V33WLkpaJE/rlQKdlqkgQUcB6KIoPhnnRQkS7G8YrIIUUg1juU41S986++hMGnEyKPC0
 iwlk3VoybTgp5qHGf0Q5dmdDAYpawy4YSbEvAgqiCls9f4jPyyZaunW9aBYE0rb3g7jw
 aiawpMqB9O7crbCPlE/2Vm11vT/CkG/3MR3JzycaPOyFdRdrW1lDCvR3TGG/WLGBBg+O
 RywHfy2RcqU488pR05OC+N0kV6dSBMldHTUHtRdYinTuFsTDhpS1IvSAcjPtEeHKSjvN
 673/zd9nnWnyVfftiZL7XqFSiA9pSJ8QLzhhxe67do1W/6B8MK5mysS4TGYsdJDcTJCN bA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31uut5nv5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 01:20:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P18Bjf157959;
        Thu, 25 Jun 2020 01:18:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31uur7tmd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 01:18:33 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05P1IWBH009917;
        Thu, 25 Jun 2020 01:18:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 01:18:32 +0000
Subject: [PATCH 8/9] xfs: refactor locking and unlocking two inodes against
 userspace IO
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        edwin@etorok.net
Date:   Wed, 24 Jun 2020 18:18:31 -0700
Message-ID: <159304791141.874036.1859363040705399580.stgit@magnolia>
In-Reply-To: <159304785928.874036.4735877085735285950.stgit@magnolia>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=1
 phishscore=0 impostorscore=0 cotscore=-2147483648 priorityscore=1501
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the two functions that we use to lock and unlock two inodes to
block userspace from initiating IO against a file, whether via system
calls or mmap activity.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c    |    2 +-
 fs/xfs/xfs_reflink.c |   52 +++++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_reflink.h |    3 +--
 3 files changed, 34 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b375fae811f2..f189bdcbeddd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1065,7 +1065,7 @@ xfs_file_remap_range(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_log_force_inode(dest);
 out_unlock:
-	xfs_reflink_remap_unlock(file_in, file_out);
+	xfs_reflink_remap_unlock(src, dest);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return remapped > 0 ? remapped : ret;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4238d43c773f..81190e963c8a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1281,24 +1281,42 @@ xfs_iolock_two_inodes_and_break_layout(
 	return 0;
 }
 
-/* Unlock both inodes after they've been prepped for a range clone. */
+/*
+ * Lock two files so that userspace cannot initiate I/O via file syscalls or
+ * mmap activity.
+ */
+static int
+xfs_reflink_remap_lock(
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*ip2)
+{
+	int			ret;
+
+	ret = xfs_iolock_two_inodes_and_break_layout(VFS_I(ip1), VFS_I(ip2));
+	if (ret)
+		return ret;
+	if (ip1 == ip2)
+		xfs_ilock(ip1, XFS_MMAPLOCK_EXCL);
+	else
+		xfs_lock_two_inodes(ip1, XFS_MMAPLOCK_EXCL,
+				    ip2, XFS_MMAPLOCK_EXCL);
+	return 0;
+}
+
+/* Unlock both files to allow IO and mmap activity. */
 void
 xfs_reflink_remap_unlock(
-	struct file		*file_in,
-	struct file		*file_out)
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*ip2)
 {
-	struct inode		*inode_in = file_inode(file_in);
-	struct xfs_inode	*src = XFS_I(inode_in);
-	struct inode		*inode_out = file_inode(file_out);
-	struct xfs_inode	*dest = XFS_I(inode_out);
-	bool			same_inode = (inode_in == inode_out);
+	bool			same_inode = (ip1 == ip2);
 
-	xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
+	xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
 	if (!same_inode)
-		xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
-	inode_unlock(inode_out);
+		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
+	inode_unlock(VFS_I(ip2));
 	if (!same_inode)
-		inode_unlock(inode_in);
+		inode_unlock(VFS_I(ip1));
 }
 
 /*
@@ -1363,18 +1381,12 @@ xfs_reflink_remap_prep(
 	struct xfs_inode	*src = XFS_I(inode_in);
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
-	bool			same_inode = (inode_in == inode_out);
 	int			ret;
 
 	/* Lock both files against IO */
-	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
+	ret = xfs_reflink_remap_lock(src, dest);
 	if (ret)
 		return ret;
-	if (same_inode)
-		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
-	else
-		xfs_lock_two_inodes(src, XFS_MMAPLOCK_EXCL, dest,
-				XFS_MMAPLOCK_EXCL);
 
 	/* Check file eligibility and prepare for block sharing. */
 	ret = -EINVAL;
@@ -1425,7 +1437,7 @@ xfs_reflink_remap_prep(
 
 	return 0;
 out_unlock:
-	xfs_reflink_remap_unlock(file_in, file_out);
+	xfs_reflink_remap_unlock(src, dest);
 	return ret;
 }
 
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 3e4fd46373ab..ceeb59b86b29 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -56,7 +56,6 @@ extern int xfs_reflink_remap_blocks(struct xfs_inode *src, loff_t pos_in,
 		loff_t *remapped);
 extern int xfs_reflink_update_dest(struct xfs_inode *dest, xfs_off_t newlen,
 		xfs_extlen_t cowextsize, unsigned int remap_flags);
-extern void xfs_reflink_remap_unlock(struct file *file_in,
-		struct file *file_out);
+extern void xfs_reflink_remap_unlock(struct xfs_inode *ip1, struct xfs_inode *ip2);
 
 #endif /* __XFS_REFLINK_H */

