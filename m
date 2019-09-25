Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA234C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AAFE21D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:33:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fyqQGoEn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfIYVdX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:33:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57534 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbfIYVdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:33:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLT2ka050614;
        Wed, 25 Sep 2019 21:33:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=uw9cThtc8VJWIDacMX5Ruihq+ybpedlrMHJlaKHmHR4=;
 b=fyqQGoEnf9ySL7bAyZ1AxLRi2hxryO1gtnrPTWaMWh03osqOL0IQ47/Oi0opuRt3rIOw
 NaT40xuzXAoIp7BUw7/Akc/GMP4m5S2Jn1GkxrqGCg0UtPlPe3s4qfoXnH/r7cZ4tw5H
 0gsoAqBoXbeTnezw67OI3lfjJ7O+yd03Nr6CqmJIOEI56fnwesL1mio7DLK9Y+KzMzgv
 ruBqq2NGKbfBSKKr8alThrGP0NGZYSlOWX3E48TdoIQ/KK3DBNDn0dFabSNIa14Y7b61
 71sa2zVcZOXxIspE98F4g5ALytNxJ6B4lIhicMOzgHoVW3U9N62yZsHZr5Jc+7p5Jz/w LQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v5cgr7eqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:33:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTObL194434;
        Wed, 25 Sep 2019 21:33:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v829w4wjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:33:10 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLX9hS014275;
        Wed, 25 Sep 2019 21:33:09 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:33:09 -0700
Subject: [PATCH 2/4] xfs_spaceman: remove open-coded per-ag bulkstat
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Wed, 25 Sep 2019 14:33:08 -0700
Message-ID: <156944718836.297551.759888543573443808.stgit@magnolia>
In-Reply-To: <156944717403.297551.9871784842549394192.stgit@magnolia>
References: <156944717403.297551.9871784842549394192.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that xfrog_bulkstat supports per-AG bulkstat, we can get rid of the
open coded one in spaceman.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 spaceman/health.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)


diff --git a/spaceman/health.c b/spaceman/health.c
index b195a229..8fd985a2 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -268,30 +268,24 @@ report_bulkstat_health(
 {
 	struct xfs_bulkstat_req	*breq;
 	char			descr[256];
-	uint64_t		startino = 0;
-	uint64_t		lastino = -1ULL;
 	uint32_t		i;
 	int			error;
 
-	if (agno != NULLAGNUMBER) {
-		startino = cvt_agino_to_ino(&file->xfd, agno, 0);
-		lastino = cvt_agino_to_ino(&file->xfd, agno + 1, 0) - 1;
-	}
-
-	breq = xfrog_bulkstat_alloc_req(BULKSTAT_NR, startino);
+	breq = xfrog_bulkstat_alloc_req(BULKSTAT_NR, 0);
 	if (!breq) {
 		perror("bulk alloc req");
 		exitcode = 1;
 		return 1;
 	}
 
+	if (agno != NULLAGNUMBER)
+		xfrog_bulkstat_set_ag(breq, agno);
+
 	do {
 		error = xfrog_bulkstat(&file->xfd, breq);
 		if (error)
 			break;
 		for (i = 0; i < breq->hdr.ocount; i++) {
-			if (breq->bulkstat[i].bs_ino > lastino)
-				goto out;
 			snprintf(descr, sizeof(descr) - 1, _("inode %"PRIu64),
 					breq->bulkstat[i].bs_ino);
 			report_sick(descr, inode_flags,
@@ -304,7 +298,7 @@ report_bulkstat_health(
 		errno = error;
 		perror("bulkstat");
 	}
-out:
+
 	free(breq);
 	return error;
 }

