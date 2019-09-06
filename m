Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB75C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9747C206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:36:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M6b969kx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732613AbfIFDgC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:36:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34822 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732247AbfIFDgB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:36:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863Xr0J104870;
        Fri, 6 Sep 2019 03:35:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gbBYq6EKozui7h6lMmOb2lYViOhD2Ph7WE3EXCNNfLI=;
 b=M6b969kxovJ+S2bPR+GUzfGwAQXuotHvcRJzztsejapH+k5W8sywIseUxT4K0oQD1CxE
 crGwL4uwGEEDJwnnbIaZqufFuy1epgx+0TnTVk7mU8IOrcvv3eIcdSm3i50smsjuFCEa
 NmnzxTimZ0JXqEkE/2ENij8Cx8qmrmbMjZyhRb40bgvFnL6mcRspWfBk9n4eBZ6WufoA
 AYP8JRwt+ayv2+bczwD/DrNyfv6yuCnVuiUsHsasX/+B+RK2hW3/AWyqFHHuF8B67flF
 bndrz263upJVvNaa83eLs+lJwxz11WyKV+EH32d+SEYeuwTcSOUrzwZ+Bwap0LZGqW09 OA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uuf5f82yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:35:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XaYe069097;
        Fri, 6 Sep 2019 03:35:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2utvr4jv1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:35:59 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863Zwiu004520;
        Fri, 6 Sep 2019 03:35:58 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:35:58 -0700
Subject: [PATCH 2/4] xfs_spaceman: remove open-coded per-ag bulkstat
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:35:54 -0700
Message-ID: <156774095455.2644581.13226600292393218725.stgit@magnolia>
In-Reply-To: <156774093859.2644581.13218735172589605186.stgit@magnolia>
References: <156774093859.2644581.13218735172589605186.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=998
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that xfrog_bulkstat supports per-AG bulkstat, we can get rid of the
open coded one in spaceman.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 spaceman/health.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)


diff --git a/spaceman/health.c b/spaceman/health.c
index b6e1fcd9..e70fd6fd 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -268,28 +268,22 @@ report_bulkstat_health(
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
 	while ((error = xfrog_bulkstat(&file->xfd, breq) == 0) &&
 			breq->hdr.ocount > 0) {
 		for (i = 0; i < breq->hdr.ocount; i++) {
-			if (breq->bulkstat[i].bs_ino > lastino)
-				goto out;
 			snprintf(descr, sizeof(descr) - 1, _("inode %"PRIu64),
 					breq->bulkstat[i].bs_ino);
 			report_sick(descr, inode_flags,
@@ -301,7 +295,7 @@ report_bulkstat_health(
 		errno = error;
 		perror("bulkstat");
 	}
-out:
+
 	free(breq);
 	return error;
 }

