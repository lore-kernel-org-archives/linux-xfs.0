Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63697C433EA
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 389F62071B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 01:51:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o/hrRpsV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgGOBvT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 21:51:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48268 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOBvT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:51:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1la0L167807;
        Wed, 15 Jul 2020 01:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SPTN7qKlNVE+rq+/bd8sCstwVESyGs3CSuk1842VTeI=;
 b=o/hrRpsVgfsIztVCbu8uC8o0cPrRsPhoutRsGe6tNUZmjVw9lB5+QWC7LLSDHX9qkTNM
 2Jrkoq787F9nzILKKQWGcczHcEZO+H1O7jvHaq9SlNZt4h4I+55ovJt91GglJFjRirY/
 5UkR1OLojKQKBrT+/4D7Z/Mu/1GjXp11Mg3Gu9y0iAVxnTe4085C2mKzooBL/8zPyZV4
 sMtX4K15fN9abR+s9DVtAKG9mwIboJNerQPbMKsaNZbkRIMaPcLrks8xdyW8Fpkl+cw6
 6iY9qiDLAKE7vx+FIdP7Cz16L99EWXU3jm8aTPZACqGlCcQMep4MmJaFQWA640FBUfp3 Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cm8mn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 01:51:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1laUZ184561;
        Wed, 15 Jul 2020 01:51:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 327qb5wq47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 01:51:16 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06F1pFbi023482;
        Wed, 15 Jul 2020 01:51:15 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:51:15 -0700
Subject: [PATCH 06/26] xfs: refactor quotacheck flags usage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:51:14 -0700
Message-ID: <159477787448.3263162.11425861807454204294.stgit@magnolia>
In-Reply-To: <159477783164.3263162.2564345443708779029.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We only use the XFS_QMOPT flags in quotacheck to signal the quota type,
so rip out all the flags handling and just pass the type all the way
through.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 9c455ebd20cb..939ee728d9af 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -902,17 +902,13 @@ xfs_qm_reset_dqcounts_all(
 	xfs_dqid_t		firstid,
 	xfs_fsblock_t		bno,
 	xfs_filblks_t		blkcnt,
-	uint			flags,
+	xfs_dqtype_t		type,
 	struct list_head	*buffer_list)
 {
 	struct xfs_buf		*bp;
-	int			error;
-	xfs_dqtype_t		type;
+	int			error = 0;
 
 	ASSERT(blkcnt > 0);
-	type = flags & XFS_QMOPT_UQUOTA ? XFS_DQTYPE_USER :
-		(flags & XFS_QMOPT_PQUOTA ? XFS_DQTYPE_PROJ : XFS_DQTYPE_GROUP);
-	error = 0;
 
 	/*
 	 * Blkcnt arg can be a very big number, and might even be
@@ -972,7 +968,7 @@ STATIC int
 xfs_qm_reset_dqcounts_buf(
 	struct xfs_mount	*mp,
 	struct xfs_inode	*qip,
-	uint			flags,
+	xfs_dqtype_t		type,
 	struct list_head	*buffer_list)
 {
 	struct xfs_bmbt_irec	*map;
@@ -1048,7 +1044,7 @@ xfs_qm_reset_dqcounts_buf(
 			error = xfs_qm_reset_dqcounts_all(mp, firstid,
 						   map[i].br_startblock,
 						   map[i].br_blockcount,
-						   flags, buffer_list);
+						   type, buffer_list);
 			if (error)
 				goto out;
 		}
@@ -1292,7 +1288,7 @@ xfs_qm_quotacheck(
 	 * We don't log our changes till later.
 	 */
 	if (uip) {
-		error = xfs_qm_reset_dqcounts_buf(mp, uip, XFS_QMOPT_UQUOTA,
+		error = xfs_qm_reset_dqcounts_buf(mp, uip, XFS_DQTYPE_USER,
 					 &buffer_list);
 		if (error)
 			goto error_return;
@@ -1300,7 +1296,7 @@ xfs_qm_quotacheck(
 	}
 
 	if (gip) {
-		error = xfs_qm_reset_dqcounts_buf(mp, gip, XFS_QMOPT_GQUOTA,
+		error = xfs_qm_reset_dqcounts_buf(mp, gip, XFS_DQTYPE_GROUP,
 					 &buffer_list);
 		if (error)
 			goto error_return;
@@ -1308,7 +1304,7 @@ xfs_qm_quotacheck(
 	}
 
 	if (pip) {
-		error = xfs_qm_reset_dqcounts_buf(mp, pip, XFS_QMOPT_PQUOTA,
+		error = xfs_qm_reset_dqcounts_buf(mp, pip, XFS_DQTYPE_PROJ,
 					 &buffer_list);
 		if (error)
 			goto error_return;

