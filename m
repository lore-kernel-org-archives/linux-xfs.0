Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1419FC35DEE
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBCD121927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c95K+GHS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgBYARu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:17:50 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40180 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBYARu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:17:50 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08vxt130054;
        Tue, 25 Feb 2020 00:15:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CW9/sa8p3Zts9fWBcJvIqgn7t/v2RTn1gZQMPBZFpM0=;
 b=c95K+GHSQTmmNmnyenG1rEHzfYXBzkW4GUWYwgE07oSfKpMV0fMNM1Fk3hPswHowjabt
 RmQqHfUGw+e0jFWq7qGzoItJw2H50o7BsMBlINVFmr/bcn6x5wtoFHLgr2BmUqJK9gAU
 PuN8lenHcr5g2GjWzp1xl4z2oA9M6evc3S2pPleM1xPZU2h9NiEU60EuaDVrjr/Nkuoy
 tFpIZCE7d2+UI3ObWd60Z7v8xgzfhMrzbzh/Ir9W95jUpcPOzv1hD6VsUwtYeqQr4zYm
 yO/FYa9iShvQ4FdPoOpBaU17tD+TbkYk8gT8e6ElpO3uPW4PdgVEM7DQSqKQUOKXAfNL FQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yavxrjs52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07vI8109297;
        Tue, 25 Feb 2020 00:15:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ybe12eubn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:15:43 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P0Fgj1001999;
        Tue, 25 Feb 2020 00:15:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:15:42 -0800
Subject: [PATCH 14/14] xfs: remove unnecessary null pointer checks from
 _read_agf callers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Date:   Mon, 24 Feb 2020 16:15:40 -0800
Message-ID: <158258974094.453666.13391513694204695960.stgit@magnolia>
In-Reply-To: <158258964941.453666.10913737544282124969.stgit@magnolia>
References: <158258964941.453666.10913737544282124969.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 706b8c5bc70391be510a5454f307db90b622b279

Drop the null buffer pointer checks in all code that calls
xfs_alloc_read_agf and doesn't pass XFS_ALLOC_FLAG_TRYLOCK because
they're no longer necessary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_refcount.c |    6 ------
 1 file changed, 6 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 71d29486..b8a45b15 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1176,8 +1176,6 @@ xfs_refcount_finish_one(
 				XFS_ALLOC_FLAG_FREEING, &agbp);
 		if (error)
 			return error;
-		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
-			return -EFSCORRUPTED;
 
 		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
 		if (!rcur) {
@@ -1717,10 +1715,6 @@ xfs_refcount_recover_cow_leftovers(
 	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
 	if (error)
 		goto out_trans;
-	if (!agbp) {
-		error = -ENOMEM;
-		goto out_trans;
-	}
 	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno);
 
 	/* Find all the leftover CoW staging extents. */

