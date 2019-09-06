Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AABEC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59EFB206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dnXA19EF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392132AbfIFDea (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:34:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33304 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392128AbfIFDea (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:34:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XvJm105018;
        Fri, 6 Sep 2019 03:34:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/jdZlyEQ50y2ae2IghUP3PSW9UoCx3jwJH+IxpSHBGI=;
 b=dnXA19EFac15FHRqZjLuajDUhhmXhAwZyo+KtCYY2FAhI2V16BHp/GOTQQWAlpICU/uL
 jKiddyfH2hCdM18mST0UGKhQFJnMmzu49OTkFyAvCZczu7R+U1pvYTM1QCdPO7z0pf/C
 GL0qioPWSn9RGCilt8SoDRFXB2Atm9F1jxDngpPv06JK8KIiwe2e7LV8zqltlsbfBEij
 Pj5kevCfeg5xOlMkekV5BtX/vJwoa3aEzn3JbjR8B/RagTbFNmLbwZWPc11g+3o4l/s2
 1J2tyrsI4fY3qYW32/GePN7xgOWyt4Ke3bUM9tcKEzxWW4syQGNcrybgRRpJZAx5JXvr rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uuf5f82ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:34:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XTDB188675;
        Fri, 6 Sep 2019 03:34:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2utpmc73xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:34:18 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863YHw5003626;
        Fri, 6 Sep 2019 03:34:17 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:34:17 -0700
Subject: [PATCH 3/3] xfs_scrub: remove unnecessary wakeup wait in
 scan_fs_tree
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Thu, 05 Sep 2019 20:34:16 -0700
Message-ID: <156774085609.2643257.18220893434559330906.stgit@magnolia>
In-Reply-To: <156774083707.2643257.15738851266613887341.stgit@magnolia>
References: <156774083707.2643257.15738851266613887341.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We don't need to wait on the condition variable if directory tree
scanning has already finished by the time we've finished queueing all
the directory work items.  This is easy to trigger when the workqueue is
single-threaded, but in theory it could happen any time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 scrub/vfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/scrub/vfs.c b/scrub/vfs.c
index f8bc98c0..1a1482dd 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -246,7 +246,8 @@ scan_fs_tree(
 	 * about to tear everything down.
 	 */
 	pthread_mutex_lock(&sft.lock);
-	pthread_cond_wait(&sft.wakeup, &sft.lock);
+	if (sft.nr_dirs)
+		pthread_cond_wait(&sft.wakeup, &sft.lock);
 	assert(sft.nr_dirs == 0);
 	pthread_mutex_unlock(&sft.lock);
 

