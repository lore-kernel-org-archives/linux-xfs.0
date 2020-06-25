Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D1FC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 193FA20706
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:19:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QCHuwpPO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388928AbgFYBTy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 21:19:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388930AbgFYBTy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 21:19:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P18EwR062715;
        Thu, 25 Jun 2020 01:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iOIz7iJRT4RnvHofFJ+IFuiI0IFSC/27gmbFEfesA6o=;
 b=QCHuwpPOtjAPGpElcWqS2+iahyTMwhaoqgvyUTCrLZNlGPBM35eTPDLICKAwSXQWe7bH
 oYhzsEJZCzTENS9ZmkXudPTzalrdjTOKiP3sFfTf8TaP5Aa1xr/61k13ax1Yc7lzktYn
 2Z6npnc2GDz0bwUn/jYLcU2mdnqLhTp9okUynBdH7EvqzeGaXh1sInOEhwvHUQ8q7CgJ
 VCNNBshASPu1XpLxjy1xVElh+HQVmLdUadQ7g4sAuh1cSrX89trKDLp5USBCUz8DHxDi
 pyhN9W0ORp6kz2ErqKKYuh20Hj06o1cKWi0eQSquzFJso9SR8BZkcBfMscUHFMo/PwAk sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31uustnvvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 01:19:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P17tRo180600;
        Thu, 25 Jun 2020 01:17:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31uur0fx2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 01:17:50 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05P1HlGu009682;
        Thu, 25 Jun 2020 01:17:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 01:17:46 +0000
Subject: [PATCH 1/9] xfs: fix reflink quota reservation accounting error
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Date:   Wed, 24 Jun 2020 18:17:45 -0700
Message-ID: <159304786592.874036.13697964290841630094.stgit@magnolia>
In-Reply-To: <159304785928.874036.4735877085735285950.stgit@magnolia>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=1 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250004
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

Quota reservations are supposed to account for the blocks that might be
allocated due to a bmap btree split.  Reflink doesn't do this, so fix
this to make the quota accounting more accurate before we start
rearranging things.

Fixes: 862bb360ef56 ("xfs: reflink extents from one file to another")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 107bf2a2f344..d89201d40891 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1003,6 +1003,7 @@ xfs_reflink_remap_extent(
 	xfs_filblks_t		rlen;
 	xfs_filblks_t		unmap_len;
 	xfs_off_t		newlen;
+	int64_t			qres;
 	int			error;
 
 	unmap_len = irec->br_startoff + irec->br_blockcount - destoff;
@@ -1025,13 +1026,19 @@ xfs_reflink_remap_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	/* If we're not just clearing space, then do we have enough quota? */
-	if (real_extent) {
-		error = xfs_trans_reserve_quota_nblks(tp, ip,
-				irec->br_blockcount, 0, XFS_QMOPT_RES_REGBLKS);
-		if (error)
-			goto out_cancel;
-	}
+	/*
+	 * Reserve quota for this operation.  We don't know if the first unmap
+	 * in the dest file will cause a bmap btree split, so we always reserve
+	 * at least enough blocks for that split.  If the extent being mapped
+	 * in is written, we need to reserve quota for that too.
+	 */
+	qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	if (real_extent)
+		qres += irec->br_blockcount;
+	error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
+			XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		goto out_cancel;
 
 	trace_xfs_reflink_remap(ip, irec->br_startoff,
 				irec->br_blockcount, irec->br_startblock);

