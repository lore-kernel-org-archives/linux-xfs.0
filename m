Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64EFBC433E5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41FB821924
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 01:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XZ3lAHvC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgGNBcJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 21:32:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53100 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgGNBcJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:32:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1QspU158332
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=LRn2XyYd3Ut/FMMmMM0tOnL9h8/9Gp6jRK6W3tXCnOg=;
 b=XZ3lAHvCS32NlL2XfnCj0enzfi7glEMRXRYGg2ZGMEONocOrVs/J3V2UyO0FNicbcFti
 eAc7je6RpCAuWJlUC5OJmTI3/IpjpHIs02mAEFpdpzqJqY3+TdKCn/ezdW4+U0FcZJjI
 CPN+936cr37qdbNnb5YFeLCfwr8T/gnhA8M2DOf2mknBUEwDim5ugyMk9rkcV2wgMJ0Z
 QIRmeuR0Z+zaJ1GSN2p4P+M2zdG8sfY55sg8JfUipCQIBFqJRTSAYdRj1QGMJDEg4rVJ
 mxb97XqbVWpjgRkjP1+c2U8JL7EdE8QqunV0gr6QtMihLFk1ewunyVhInxKjDVKb26rc lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3275cm2d87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1TYNU107150
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 327q6r5a2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:08 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06E1W7Tc013517
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:32:07 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:32:07 -0700
Subject: [PATCH 06/26] xfs: refactor quotacheck flags usage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 13 Jul 2020 18:32:06 -0700
Message-ID: <159469032681.2914673.14228303787291427994.stgit@magnolia>
In-Reply-To: <159469028734.2914673.17856142063205791176.stgit@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We only use the XFS_QMOPT flags in quotacheck to signal the quota type,
so rip out all the flags handling and just pass the type all the way
through.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c67776eb6bcc..c89d9c444351 100644
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

