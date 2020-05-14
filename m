Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9363C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 20:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98250207E8
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 20:56:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D8VA5RHq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgENU44 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 16:56:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33632 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgENU4z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 16:56:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EKuWG5126685;
        Thu, 14 May 2020 20:56:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=K1EaWQ93hnePwzEvRwkZ7+8pV16/P0+ypIgET85SP7s=;
 b=D8VA5RHqzOlYr24rtqF6DTDv1reydSY+GwmcRuJSYU4ba1ig/Fz/zb51ZuH1+EeSiuDo
 Xc8Od3bwYrhbexmGtSD6XSwvwIJtNonzYw72YGnQkh7RzqEo2O9JkfID9qe3OPZeKL4E
 ZA5t5uKMAnTU/Ob40bKjygLV6cm6+NzKoYWht47X0qmuuR/Kf6yyHoek4ehJkw7gQcsz
 DTTNKr3hqf+zzOMOEnBz2qpYX3TBGtTxkqG9hSVopz3SGSvMW2a4nek4Hj3Y3dQOErmb
 4b0A0023tYQrxXaQt9bSUsWUi4qfAWsW7XeJpq/YEkrj7P8LtRu28gKtQZPWKhdCXnpf rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3100yg536k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 20:56:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EKs5Ym096676;
        Thu, 14 May 2020 20:54:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3100ydcpun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 20:54:45 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04EKsi6u027521;
        Thu, 14 May 2020 20:54:44 GMT
Received: from localhost (/10.159.232.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 13:54:44 -0700
Date:   Thu, 14 May 2020 13:54:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: don't allow SWAPEXT if we'd screw up quota accounting
Message-ID: <20200514205442.GK6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=1 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005140183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since the old SWAPEXT ioctl doesn't know how to adjust quota ids,
bail out of the ids don't match and quotas are enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index cc23a3e23e2d..5e7da27c6e98 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1210,6 +1210,12 @@ xfs_swap_extents_check_format(
 	struct xfs_inode	*ip,	/* target inode */
 	struct xfs_inode	*tip)	/* tmp inode */
 {
+	/* User/group/project quota ids must match if quotas are enforced. */
+	if (XFS_IS_QUOTA_ON(ip->i_mount) &&
+	    (!uid_eq(VFS_I(ip)->i_uid, VFS_I(tip)->i_uid) ||
+	     !gid_eq(VFS_I(ip)->i_gid, VFS_I(tip)->i_gid) ||
+	     ip->i_d.di_projid != tip->i_d.di_projid))
+		return -EINVAL;
 
 	/* Should never get a local format */
 	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL ||
