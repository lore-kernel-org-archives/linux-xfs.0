Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC7CC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 16:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF0AE20738
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 16:50:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="clfkvveA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgEWQuS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 12:50:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54054 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgEWQuR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 12:50:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NGgWr1165576;
        Sat, 23 May 2020 16:49:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=i0N33mgwHZ/0Fz39zo3dkbyTWGxO2teVQwcGFQXeNmM=;
 b=clfkvveAZU/uooNJN0zx7Rrvx61yhYyZbEA4ATZZIJcnZhSmiSLkP5vWUAnQOaSzBDft
 Gn0w2YeOeOKqL1K37xFZjGouSWT/gs1zXVwMReZXcsq09kbZFqX8N1p0sXt5hZSMBcct
 zO2V/IB2UBkz+wzHg5R2oLhh0l8SsLYn2h+BMx6Xnv+5odyzIrnVfRS5dAocM3yEpk0V
 XD0cnomQzyIwn5icijn6vBCl1upmDM0Sw7gsAReGxhMbwTDs+7Pgv0T8SwVja00u5HnN
 A87kwLj51PGJ1Jhk7mAk2RjaqpiumGResxoWYfhRnM9U58TTONziC/GXaHfviRjsJEpB /Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 316vfn14cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 16:49:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NGge8j183362;
        Sat, 23 May 2020 16:49:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 316rxrvrg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 16:49:40 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04NGnemM011255;
        Sat, 23 May 2020 16:49:40 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 23 May 2020 09:49:39 -0700
Subject: [PATCH 1/4] xfs: don't fail unwritten extent conversion on writeback
 due to edquot
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Date:   Sat, 23 May 2020 09:49:38 -0700
Message-ID: <159025257837.493629.12588914534574751097.stgit@magnolia>
In-Reply-To: <159025257178.493629.12621189512718182426.stgit@magnolia>
References: <159025257178.493629.12621189512718182426.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005230138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=1
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005230138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During writeback, it's possible for the quota block reservation in
xfs_iomap_write_unwritten to fail with EDQUOT because we hit the quota
limit.  This causes writeback errors for data that was already written
to disk, when it's not even guaranteed that the bmbt will expand to
exceed the quota limit.  Irritatingly, this condition is reported to
userspace as EIO by fsync, which is confusing.

We wrote the data, so allow the reservation.  That might put us slightly
above the hard limit, but it's better than losing data after a write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index bb590a267a7f..ac970b13b1f8 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -563,7 +563,7 @@ xfs_iomap_write_unwritten(
 		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-				XFS_QMOPT_RES_REGBLKS);
+				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES);
 		if (error)
 			goto error_on_bmapi_transaction;
 

