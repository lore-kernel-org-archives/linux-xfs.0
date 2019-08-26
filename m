Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88135C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44D2E2186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KIKVOaml"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbfHZV3d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:29:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV3c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:29:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLR2rC003451;
        Mon, 26 Aug 2019 21:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=35m8Z8fk2udN2PEnt01db1JLyKdqQpCxo58wMYrHf8I=;
 b=KIKVOamlWCixb0lXdxXvKpNXi9s7H30Hxd9ICZfTASfGVujlpRUciMDFL1GzgxiJocFU
 t8VmacdzO/MaE6jPcJpx7SndNmI7Uaw+7nFwiuNj6wRTzF7F3aMz9mzr+0ECFqDp4QtW
 tKEQ2GiTuKkxYmTCPF9lqIU/wjreTMNF3wUjm8xSYVY2JrE+wwLD0mcQKLZYTW4nhAf6
 /eNtO01jbQXv3LDKKHLVddg0TVyf4bJRF8LsWGI8TJ/VHNLV41wdzrOOWvozMQP+2IaM
 fqezvNKH0YjlZBPI24A9EtMaov4Pk0TP5SKcISl4Pkvnysb2G4ZZfhgQDNQF/uKcwvY0 /A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2umqbe80cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLILxQ170023;
        Mon, 26 Aug 2019 21:29:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2umj278703-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:30 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLTTEg006221;
        Mon, 26 Aug 2019 21:29:29 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:29:29 -0700
Subject: [PATCH 10/13] xfs_scrub: report all progressbar creation failures
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:29:28 -0700
Message-ID: <156685496805.2841546.8507696258514934036.stgit@magnolia>
In-Reply-To: <156685489821.2841546.10616502094098044568.stgit@magnolia>
References: <156685489821.2841546.10616502094098044568.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Always report failures when creating progress bars.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/progress.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/progress.c b/scrub/progress.c
index e5ea1e90..6d4f2c36 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -198,8 +198,10 @@ progress_init_phase(
 	}
 
 	ret = pthread_create(&pt.thread, NULL, progress_report_thread, NULL);
-	if (ret)
+	if (ret) {
+		str_liberror(ctx, ret, _("creating progress reporting thread"));
 		goto out_ptcounter;
+	}
 
 	return true;
 

