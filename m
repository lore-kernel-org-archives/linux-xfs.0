Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47F1C28CBC
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92BD720747
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 01:07:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AK6/yDo7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgEGBHq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:07:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56002 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbgEGBHp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 21:07:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470xr7s123277;
        Thu, 7 May 2020 01:05:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8nYWWP+IeTjsZWOcRJ3cKykyqfworPANGe64Enffw6M=;
 b=AK6/yDo71pTrbpgpp4tXKZ0enDl1lafQL0VHLZ+dgL8r5PiTyrS+meizKVMfopgiB6G4
 q56E37pPOKf9yVVfPuWNlrA9oqGq5TVMBcqAEzS9eJUIGgQYu/tutgnuOE9epR1cm7AL
 dFs4TLqg42vygqAlhz1zsKyc/r3U4EHLxoaIAmYA1sqe/CLC6qv9V4PyKqA4HNtkMVwZ
 /i4CuQzPjkaIZf24wjyLE447keB0opzMRcqpAellyhTCzzSzviqrlh7QHJSteDgBxxs2
 9HWnot7ZNbvzQGUuJZvEIFXWLL/sguZBL+8FQtYYKCPwGT6cmAv3wEISH3MQzbswQPyC bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30usgq4jm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:05:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0470urtm190327;
        Thu, 7 May 2020 01:03:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30sjdwsv3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 May 2020 01:03:42 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04713fbB032078;
        Thu, 7 May 2020 01:03:41 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 18:03:40 -0700
Subject: [PATCH 18/25] xfs: refactor xlog_item_is_intent now that we're done
 converting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 06 May 2020 18:03:37 -0700
Message-ID: <158881341704.189971.9418165129953886860.stgit@magnolia>
In-Reply-To: <158881329912.189971.14392758631836955942.stgit@magnolia>
References: <158881329912.189971.14392758631836955942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005070004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've finished converting all types of log intent items to
provide an ->iop_recover function, we can convert the "is this an intent
item?" predicate to look for a non-null iop_recover pointer.

Move the predicate closer to the functions that use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 65081a3efeff..e21cb9c33faa 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2546,20 +2546,6 @@ xlog_recover_process_data(
 	return 0;
 }
 
-/* Is this log item a deferred action intent? */
-static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
-{
-	switch (lip->li_type) {
-	case XFS_LI_EFI:
-	case XFS_LI_RUI:
-	case XFS_LI_CUI:
-	case XFS_LI_BUI:
-		return true;
-	default:
-		return false;
-	}
-}
-
 /* Take all the collected deferred ops and finish them in order. */
 static int
 xlog_finish_defer_ops(
@@ -2594,6 +2580,12 @@ xlog_finish_defer_ops(
 	return xfs_trans_commit(tp);
 }
 
+/* Is this log item a deferred action intent? */
+static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
+{
+	return lip->li_ops->iop_recover != NULL;
+}
+
 /*
  * When this is called, all of the log intent items which did not have
  * corresponding log done items should be in the AIL.  What we do now

