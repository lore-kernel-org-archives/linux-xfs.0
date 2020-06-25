Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7801AC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 527BC2078D
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:18:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k2CGCO8+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389016AbgFYBSc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 21:18:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53192 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388942AbgFYBSc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 21:18:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P18vu6063553;
        Thu, 25 Jun 2020 01:18:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1y+9UcJ9QW/F15Ki9TLpVJM8Q/1tBDdzVxqZSsHD1u0=;
 b=k2CGCO8+D90gP9sEEg4GrOSxuHcewuDV20wEHUX2DoxA3IJqyK8sBhk63OpJKMgJVfzU
 DjFIHj2q8v0eF7ls42KdsDtb5qrmotNSpBxoPNTG6MXvEVYZuiu306e23d9tSgkanGBk
 w1yZoAV6pelQPB/w6xy/CDpFOvkLTIHCBVXjFikiBD/4/X8Ub14VtV4oItmL3jcgfbqI
 TmPd3d0UOFS2srD3tui/9Gc4Htoa2TKa/D+KKY41hoEtZRUMl2XfkpjxfU8doq5hHaY7
 D5Kryx3JQGv7VYN6eoxhw2JAyLMRXn4S+OsvpHc20N08pTaY0xflHjdmmrypO+a5psmY gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31uustnvry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 01:18:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P19MRd010189;
        Thu, 25 Jun 2020 01:18:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31uurrnpee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 01:18:27 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05P1IQ9e027141;
        Thu, 25 Jun 2020 01:18:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 01:18:26 +0000
Subject: [PATCH 7/9] xfs: fix xfs_reflink_remap_prep calling conventions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        edwin@etorok.net
Date:   Wed, 24 Jun 2020 18:18:24 -0700
Message-ID: <159304790475.874036.14660403277438656965.stgit@magnolia>
In-Reply-To: <159304785928.874036.4735877085735285950.stgit@magnolia>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=1 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix the return value of xfs_reflink_remap_prep so that its return value
conventions match the rest of xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
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
index f1156f121b7d..4238d43c773f 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1364,7 +1364,7 @@ xfs_reflink_remap_prep(
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	bool			same_inode = (inode_in == inode_out);
-	ssize_t			ret;
+	int			ret;
 
 	/* Lock both files against IO */
 	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
@@ -1388,7 +1388,7 @@ xfs_reflink_remap_prep(
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
 			len, remap_flags);
-	if (ret < 0 || *len == 0)
+	if (ret || *len == 0)
 		goto out_unlock;
 
 	/* Attach dquots to dest inode before changing block map */
@@ -1423,7 +1423,7 @@ xfs_reflink_remap_prep(
 	if (ret)
 		goto out_unlock;
 
-	return 1;
+	return 0;
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
 	return ret;

