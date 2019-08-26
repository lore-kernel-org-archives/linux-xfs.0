Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD81DC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F22A2186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h3ycq5Fg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbfHZV2H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:28:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59470 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728112AbfHZV2H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:28:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDlYV000849;
        Mon, 26 Aug 2019 21:28:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=6GcM6GFqTlK2NYMqB8Mysdgv7/cyTxcb+KqVwCc9xzw=;
 b=h3ycq5Fgqxh8uEMXFvI2wFVvhks6bJM980AAOL+fYXTwJ9xro3Ur8DCZyVfvoBxkq8bt
 7jZamuzFfn/z+TejhTxWM9yWRkDYDC6JK9fZqAWZLWw2SGMwuMi2k1uKWU2ZEyi+U7C5
 r7wvpQIMxQN4zK01IieQHiUUb1HHA4JOYExMTDr/HEdjpN4AaIvghqJUEHgBAbO8cnej
 72yhVD7aiafd41KXtEsTt+Ipflcm7yPqWy3OJ6atOTCj9Qm0nKOjPlw20Thj/tWyC2e5
 W/43rt8mUD6OKQldzQnOO+hit0E5rrjTj/5jKhVjOkEHXfDhrMC+m63QjBregdIIO+s8 kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2umpxx055q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIdJw169670;
        Mon, 26 Aug 2019 21:28:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2umhu7wxv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:04 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLS4UJ005406;
        Mon, 26 Aug 2019 21:28:04 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:28:04 -0700
Subject: [PATCH 2/4] xfs_spaceman: remove open-coded per-ag bulkstat
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:28:02 -0700
Message-ID: <156685488294.2841421.13810601288995238059.stgit@magnolia>
In-Reply-To: <156685486843.2841421.7117771040713668517.stgit@magnolia>
References: <156685486843.2841421.7117771040713668517.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
index ff03d074..43b99044 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -265,28 +265,22 @@ report_bulkstat_health(
 {
 	struct xfs_bulkstat_req	*breq;
 	char			descr[256];
-	uint64_t		startino = 0;
-	uint64_t		lastino = -1ULL;
 	uint32_t		i;
 	int			error;
 
-	if (agno != NULLAGNUMBER) {
-		startino = xfrog_agino_to_ino(&file->xfd, agno, 0);
-		lastino = xfrog_agino_to_ino(&file->xfd, agno + 1, 0) - 1;
-	}
-
-	breq = xfrog_bulkstat_alloc_req(128, startino);
+	breq = xfrog_bulkstat_alloc_req(128, 0);
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
@@ -294,7 +288,7 @@ report_bulkstat_health(
 					breq->bulkstat[i].bs_checked);
 		}
 	}
-out:
+
 	free(breq);
 	return error;
 }

