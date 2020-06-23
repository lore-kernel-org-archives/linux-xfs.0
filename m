Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5577AC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 04:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FC2D20771
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 04:03:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B3voj0bF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgFWEDu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 00:03:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33206 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgFWEDu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 00:03:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N3ubWS007924;
        Tue, 23 Jun 2020 04:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=N4SX+HHbEamSiDF671gWJOBMW7P6q2rHPih8I8Ic1Tk=;
 b=B3voj0bF+dmaa2NgfWFyrG7jtfOX0VYQnU47Wfa1yV5CqBGLOLgXuJLnQdRB3euuMQ/v
 /HPPC+8Bo6654BFxV/MAeM46nqgXwRy8ym7xFDXK2ZD6UcF/c+MibzjzVC42kuj4SPLz
 hlNsE9kSVmCvxMNlz/wxSNuZnEfj7h0+JAwj03vOZCqVkNptH7pqa8ZC6Tp3BnovgXIB
 lMK9je9QiVwFCWwmJvgkHiuUubzzw5TZ+Mhsa6p8AzQP8usEPNSZbMVpN2nbo7/POHBP
 xIT1Ck/ygiKL3R4aZUIdNTI1N76rXuWuHfhzLRNOQyTcoajbU3q+RP3172WNClZ7ndjh XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31sebbjsq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 04:03:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N3vdsu107279;
        Tue, 23 Jun 2020 04:01:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31sv1mpxp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 04:01:45 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05N41iO4013577;
        Tue, 23 Jun 2020 04:01:44 GMT
Received: from localhost (/10.159.143.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 04:01:44 +0000
Subject: [PATCH 2/3] xfs: fix xfs_reflink_remap_prep calling conventions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Date:   Mon, 22 Jun 2020 21:01:42 -0700
Message-ID: <159288490208.150128.2169762955647750917.stgit@magnolia>
In-Reply-To: <159288488965.150128.10967331397379450406.stgit@magnolia>
References: <159288488965.150128.10967331397379450406.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=1 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 cotscore=-2147483648 mlxscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=1 clxscore=1015
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix the return value of xfs_reflink_remap_prep so that its return value
conventions match the rest of xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c    |    2 +-
 fs/xfs/xfs_reflink.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 00db81eac80d..b375fae811f2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1035,7 +1035,7 @@ xfs_file_remap_range(
 	/* Prepare and then clone file data. */
 	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
 			&len, remap_flags);
-	if (ret < 0 || len == 0)
+	if (ret || len == 0)
 		return ret;
 
 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index f50a8c2f21a5..dd9ed7d5694d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1341,7 +1341,7 @@ xfs_reflink_remap_prep(
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	bool			same_inode = (inode_in == inode_out);
-	ssize_t			ret;
+	int			ret;
 
 	/* Lock both files against IO */
 	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
@@ -1365,7 +1365,7 @@ xfs_reflink_remap_prep(
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
 			len, remap_flags);
-	if (ret < 0 || *len == 0)
+	if (ret || *len == 0)
 		goto out_unlock;
 
 	/* Attach dquots to dest inode before changing block map */
@@ -1400,7 +1400,7 @@ xfs_reflink_remap_prep(
 	if (ret)
 		goto out_unlock;
 
-	return 1;
+	return 0;
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
 	return ret;

