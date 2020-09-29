Return-Path: <SRS0=kcSc=DG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389D6C4727C
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE997207F7
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Sep 2020 17:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="s3uSWcGk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgI2Rnc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:43:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39938 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgI2Rnb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Sep 2020 13:43:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THdWQF026444;
        Tue, 29 Sep 2020 17:43:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9LNn76gvaTVsWXdV6Yt3nu1CdLfJ/ABMgI35vik0DBw=;
 b=s3uSWcGkuoAjySH12X9gID0oDjZCbDQmlH8FAm/A5ARJEhIS0ENsWT5pxWYhtHONwBZc
 TGh9DoKpjgkJbaN9mxPDiaED0hhlPHOBV5n+t7rheKmmAKeACPsqzdn2+6mfcA7RJtSv
 dk424QG5bQW32wQ331j/zXyumCAilw4MGet19QPXUcsXJonXjZsFveaDSCtneI0vbmyl
 Ga9BV226TggeH1pACfQPZPMbHwOq/ifNm8TVMtfO9LgdvOAkFbM62eIR4HcIKYCxOp/6
 n9j0jazLOaEEHe0TmZ3iTV+YLoEjxc/A6vfKctTp8MA224M3tiOsTFuMObiXt4/xun1s 6w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33swkkva4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 17:43:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08THekGB111532;
        Tue, 29 Sep 2020 17:43:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33tfdsg000-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 17:43:21 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08THhKrF027878;
        Tue, 29 Sep 2020 17:43:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 10:43:20 -0700
Subject: [PATCH 1/5] xfs: remove xfs_defer_reset
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Date:   Tue, 29 Sep 2020 10:43:18 -0700
Message-ID: <160140139874.830233.6882281372357115912.stgit@magnolia>
In-Reply-To: <160140139198.830233.3093053332257853111.stgit@magnolia>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=3 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290149
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove this one-line helper since the assert is trivially true in one
call site and the rest obscures a bitmask operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 29e9762f3b77..36c103c14bc9 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -312,22 +312,6 @@ xfs_defer_trans_roll(
 	return error;
 }
 
-/*
- * Reset an already used dfops after finish.
- */
-static void
-xfs_defer_reset(
-	struct xfs_trans	*tp)
-{
-	ASSERT(list_empty(&tp->t_dfops));
-
-	/*
-	 * Low mode state transfers across transaction rolls to mirror dfops
-	 * lifetime. Clear it now that dfops is reset.
-	 */
-	tp->t_flags &= ~XFS_TRANS_LOWMODE;
-}
-
 /*
  * Free up any items left in the list.
  */
@@ -477,7 +461,10 @@ xfs_defer_finish(
 			return error;
 		}
 	}
-	xfs_defer_reset(*tp);
+
+	/* Reset LOWMODE now that we've finished all the dfops. */
+	ASSERT(list_empty(&(*tp)->t_dfops));
+	(*tp)->t_flags &= ~XFS_TRANS_LOWMODE;
 	return 0;
 }
 
@@ -551,8 +538,7 @@ xfs_defer_move(
 	 * that behavior.
 	 */
 	dtp->t_flags |= (stp->t_flags & XFS_TRANS_LOWMODE);
-
-	xfs_defer_reset(stp);
+	stp->t_flags &= ~XFS_TRANS_LOWMODE;
 }
 
 /*

