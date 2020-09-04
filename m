Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0B7C433E2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 03:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A155620E65
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 03:11:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hm75ukK2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbgIDDLH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 23:11:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48248 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729712AbgIDDLG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 23:11:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0843APic161856
        for <linux-xfs@vger.kernel.org>; Fri, 4 Sep 2020 03:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=HFTy0tkp18cdfwSzXH0CBTT9uv2ob36FI0f8eEO3TdY=;
 b=Hm75ukK2xiXA6yNHMCcCx0SpmeTr/XCab7cx/SRBhu1UiAaCeGsotOY1pL6TnevKsASz
 g/ab8P+k7nvvF8Q6wfYlSYNu++FSoyb5KpWAYz1bwVcfwgI2jv+fu8DlKCxi8dLm0FR/
 uNpTZ+Q/v4ZP7TajsM0bVldQX/PdR3cSrfffvQbXIrNCaiHqscbIg1tWofIFJzolB4uc
 UGIf1OHKI/unD96nqVDhSwruMJBlm0Y6b2uhYRh9dTppYe185vcCCC5yyAnYOCJynUhM
 phB5lvVlqdbcONRwdTMdOEmDqOdpxMXHEp/mvCAfliNgJmicH+CdYmDlj310rqiJdkca xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 337eymm5e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2020 03:11:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0843AkMB129594
        for <linux-xfs@vger.kernel.org>; Fri, 4 Sep 2020 03:11:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3380xbv3v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2020 03:11:02 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0843B1nG026224
        for <linux-xfs@vger.kernel.org>; Fri, 4 Sep 2020 03:11:01 GMT
Received: from localhost (/10.159.152.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Sep 2020 20:11:01 -0700
Date:   Thu, 3 Sep 2020 20:11:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: force the log after remapping a synchronous-writes file
Message-ID: <20200904031100.GZ6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9733 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009040028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9733 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Commit 5833112df7e9 tried to make it so that a remap operation would
force the log out to disk if the filesystem is mounted with mandatory
synchronous writes.  Unfortunately, that commit failed to handle the
case where the inode or the file descriptor require mandatory
synchronous writes.

Refactor the check into into a helper that will look for all three
conditions, and now we can treat reflink just like any other synchronous
write.

Fixes: 5833112df7e9 ("xfs: reflink should force the log out if mounted with wsync")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c31cd3be9fb2..ee43f137830c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1008,6 +1008,21 @@ xfs_file_fadvise(
 	return ret;
 }
 
+/* Does this file, inode, or mount want synchronous writes? */
+static inline bool xfs_file_sync_writes(struct file *filp)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(filp));
+
+	if (ip->i_mount->m_flags & XFS_MOUNT_WSYNC)
+		return true;
+	if (filp->f_flags & (__O_SYNC | O_DSYNC))
+		return true;
+	if (IS_SYNC(file_inode(filp)))
+		return true;
+
+	return false;
+}
+
 STATIC loff_t
 xfs_file_remap_range(
 	struct file		*file_in,
@@ -1065,7 +1080,7 @@ xfs_file_remap_range(
 	if (ret)
 		goto out_unlock;
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
 		xfs_log_force_inode(dest);
 out_unlock:
 	xfs_iunlock2_io_mmap(src, dest);
