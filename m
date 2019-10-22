Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6403CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB8C420B7C
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BnrNbtKT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbfJVSrB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:47:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43442 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731007AbfJVSrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:47:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiQYd109597;
        Tue, 22 Oct 2019 18:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=GHmSu/cN81VoWu90qoGG88vj6/fswWi4T12BGEvjgYk=;
 b=BnrNbtKTiFV+YP2anoOzH1sdbGde1/+TZ1chwwMqXf6nfNDvusTbUrDMn6JYVf6OYXWT
 D+GkQunR6GKqlut9Vr0r8k/L3qrydwrdUUwvuExG05wXrpzYpKR++48Cc1ddWpGdrTNj
 K2NJtH3drX4a0tOCxFGwfbnolOpCj+1hk4dF3PwvStEQotpduPSNflrsh0qmsoLkjlh+
 N780tOY5xDT2xJnHQwJb9UUnUKE5yE8bWQo5ou3AcO5WdzgWqZr9hXVmMiFcquCGbwLQ
 sMPFAqd6A53PnsDdW4wAS1sWBreHbC8aKXJJHKpmrEYNksr5k9gyVGgThLLRCApnHOMy cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vqswtgujc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:46:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhlRV148116;
        Tue, 22 Oct 2019 18:46:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vsp400t4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:46:58 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIkvuY002292;
        Tue, 22 Oct 2019 18:46:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:46:57 -0700
Subject: [PATCH 4/5] xfs_scrub: don't allow error or negative error
 injection interval
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:46:56 -0700
Message-ID: <157177001659.1458930.2704912012566010203.stgit@magnolia>
In-Reply-To: <157176999124.1458930.5678023201951458107.stgit@magnolia>
References: <157176999124.1458930.5678023201951458107.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=942
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't allow zero or negative values from XFS_SCRUB_DISK_ERROR_INTERVAL
to slip into the system.  This is a debugging knob so we don't need to
be rigorous, but we can at least take care of obvious garbage values.

Coverity-id: 1454842
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/disk.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/scrub/disk.c b/scrub/disk.c
index 214a5346..8a8a411b 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -303,6 +303,10 @@ disk_simulate_read_error(
 		interval = strtoull(p, NULL, 10);
 		interval &= ~((1U << disk->d_lbalog) - 1);
 	}
+	if (interval <= 0) {
+		interval = -1;
+		return 0;
+	}
 
 	/*
 	 * We simulate disk errors by pretending that there are media errors at

