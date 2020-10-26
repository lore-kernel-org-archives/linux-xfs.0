Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D44DC2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30AF120872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e8w3ORbY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407237AbgJZXiU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:38:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45654 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407215AbgJZXiU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:38:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPA6r177080;
        Mon, 26 Oct 2020 23:38:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=G3h6FISMEAUdxMuFCO/yAMinYINLIgvskpuy9WL+t6A=;
 b=e8w3ORbYOy4sMNb8AWGmOeyGnNqmJ3b2mI7CoqnRJRpjbL8PB+ETJ4eXILfxiUt1Xy0o
 wi6QTi+GdzkoWOtZUKksjalirHLJHmADKArG9KfeH0DQg/tsvoAs6a3046HL87cohFPN
 mYpq0xrPEnYAyh8dzLnPghrLk1ZSWNz1qbXKNhODJMA3bgkyL0Kj0EDOVjH8khvyMnQo
 92MG4WJLehVx2QzikxTwWPBkgPA9FB1v8Sta5nITm8Vh2+rsVy6ki+CCzjlin7CmfTTE
 GDt7z1ldbQnwuMKeMkt08hhl7f8AeToRVHHn61XUOxxX4/wOgEkDeN6KLrDhlS3Df55+ Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9saqdar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:38:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQNI8058329;
        Mon, 26 Oct 2020 23:38:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwukraam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:38:14 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNcEbs008899;
        Mon, 26 Oct 2020 23:38:14 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:38:14 -0700
Subject: [PATCH 12/21] xfs: remove xfs_defer_reset
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:38:13 -0700
Message-ID: <160375549306.882906.3246201026571961959.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: b80b29d602a8879829fbf89115e9e6877806a2da

Remove this one-line helper since the assert is trivially true in one
call site and the rest obscures a bitmask operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_defer.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 1d1eac62d9cf..4f844b04641b 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -310,22 +310,6 @@ xfs_defer_trans_roll(
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
@@ -475,7 +459,10 @@ xfs_defer_finish(
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
 
@@ -549,8 +536,7 @@ xfs_defer_move(
 	 * that behavior.
 	 */
 	dtp->t_flags |= (stp->t_flags & XFS_TRANS_LOWMODE);
-
-	xfs_defer_reset(stp);
+	stp->t_flags &= ~XFS_TRANS_LOWMODE;
 }
 
 /*

