Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB56C47095
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D6120B80
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:20:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lwXgnq9z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgJESUL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:20:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgJESUL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 14:20:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095I9kOJ101734;
        Mon, 5 Oct 2020 18:20:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=vdugsOCdNwNMoIMG58jHywfX3ScUzyDR7YmEooLTY/A=;
 b=lwXgnq9ztHxnk4WxEelTAhlMNDZEmItzSFWpWrUnFtnMvEFzHkp9bjLmNG5EHhnvl9kZ
 FbLJLKmDUv72r0pwmJSp4qAhQMKnjKH9UUqJFgfFFNNv5Jk2GNyODWgN1eBr4yAlhCJx
 H5i/t5P5AIr0JrcQ38Y/JNmJJfWA+jM+wOmYQnWGAbY87jLcMP9RJro6k8Ouhst9vDbN
 0mnxJ6jnZAOGBdcdKmbW44w2TB5/Oz/v7nFND/DNWzhDupcx6Oa3iNITiz3MJbO4jel/
 3IgQ/TOrF1yXCyW804HSlwmmIv3pGhRYGYNXAlctTvL3V7IazWFkdfdHOQN17SsuCAZU Nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33xhxmpyqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 18:20:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IB7Gj109433;
        Mon, 5 Oct 2020 18:20:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33yyje7d4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 18:20:03 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 095IK2A1015485;
        Mon, 5 Oct 2020 18:20:02 GMT
Received: from localhost (/10.159.154.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 11:20:02 -0700
Subject: [PATCH 1/5] xfs: remove xfs_defer_reset
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@lst.de, bfoster@redhat.com
Date:   Mon, 05 Oct 2020 11:20:01 -0700
Message-ID: <160192200106.2568681.17380231431810984455.stgit@magnolia>
In-Reply-To: <160192199449.2568681.679506644186725342.stgit@magnolia>
References: <160192199449.2568681.679506644186725342.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=3 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove this one-line helper since the assert is trivially true in one
call site and the rest obscures a bitmask operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
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

