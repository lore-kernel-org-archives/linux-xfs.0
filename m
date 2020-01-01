Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E71C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76E7820718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:18:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k+rchHD0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgAABSi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:18:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56910 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABSi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:18:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EWU9092092
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:18:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=mxTZb9O9gox2iUj6KTFO8IDZXoLRh6IkV5OYfd/IrMQ=;
 b=k+rchHD0T/Z0Ew6ydWvaO4DT5vMoWKtNMzGP7QnwT4Pu+y3C7Qs/j6oR3CeDCHV+7B1y
 Pe3p7mS4Vk9JaU4vcf7w65k351MfTplyYSKDSXWvURnGwPbsV1n/PKzCJr15+CnqNAED
 LASs40zqoRoNwxhBVzf4XmIaZ8vhpX9U3wgxpopFyIzKg+kEiRjWfug2c/ZQWtcbT6n2
 MyU8TD3eXBUCQV47gU19C82WngJiXUZyretAsH1RGEIfjbYRzrTslbSLlzE28Y2ZmEq5
 cqJH9fEw19MnGXJLtaxgiSPV9DRmmI0RGS8MRI5wnlcqj2bmwy2Tmz4SUcbRR08UOIfv kA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:18:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011I80J056895
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:18:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x7medfgsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:18:36 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011IXav014860
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:18:34 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:18:32 -0800
Subject: [PATCH 21/21] xfs: report realtime rmap btree corruption errors to
 the health system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:18:30 -0800
Message-ID: <157784151051.1368137.9892653832705151596.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter corrupt realtime rmap btree blocks, we should
report that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c |    7 ++++++-
 fs/xfs/xfs_health.c            |    3 +++
 fs/xfs/xfs_rtalloc.c           |    1 +
 3 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 758bf44693ba..93e80435c113 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -78,8 +78,13 @@ xfs_iformat_fork(
 			error = xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
 			break;
 		case XFS_DINODE_FMT_RMAP:
-			if (!xfs_sb_version_hasrtrmapbt(&ip->i_mount->m_sb))
+			if (!xfs_sb_version_hasrtrmapbt(&ip->i_mount->m_sb)) {
+				xfs_inode_verifier_error(ip, -EFSCORRUPTED,
+						__func__, dip, sizeof(*dip),
+						__this_address);
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 				return -EFSCORRUPTED;
+			}
 			error = xfs_iformat_rmap(ip, dip);
 			break;
 		default:
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index e328b048edb0..fc0cea221985 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -505,6 +505,9 @@ xfs_btree_mark_sick(
 		xfs_bmap_mark_sick(cur->bc_private.b.ip,
 				   cur->bc_private.b.whichfork);
 		return;
+	case XFS_BTNUM_RTRMAP:
+		xfs_rt_mark_sick(cur->bc_mp, XFS_SICK_RT_RMAPBT);
+		return;
 	case XFS_BTNUM_BNO:
 		mask = XFS_SICK_AG_BNOBT;
 		break;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 765f648ffe2b..ccbaebafba9b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1326,6 +1326,7 @@ xfs_rtmount_inodes(
 		if (XFS_IS_CORRUPT(mp,
 				   mp->m_rrmapip->i_d.di_format !=
 				   XFS_DINODE_FMT_RMAP)) {
+			xfs_rt_mark_sick(mp, XFS_SICK_RT_RMAPBT);
 			error = -EFSCORRUPTED;
 			goto out_rrmap;
 		}

