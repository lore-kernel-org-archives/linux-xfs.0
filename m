Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE754C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1FC521D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F7ZObNhk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfIYVcM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:32:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34670 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfIYVcM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:32:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTMrk053985;
        Wed, 25 Sep 2019 21:32:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/jdZlyEQ50y2ae2IghUP3PSW9UoCx3jwJH+IxpSHBGI=;
 b=F7ZObNhk4vKiaDRPxB3tyf/cpUVC4LGR9g37vlxKw++Sc9Hcyk1qR2rBmF6q1qWMW/6s
 UdKG37gqZU458bKiv/T1ntbeBOnkBVSoqgMIzdn/RV8F2NkndvdS1vghboJmDlBhOSIv
 Nf2OZjzwz6u/BB1zioKkV7Ipr06ZYcGcW2qZolzU0jxRoQUZTQZiuiDvP4YrXN4U7Wye
 X8IIsTCOICd6rFG5H/oUU/mGhuuElaEzQNn2uzh7eME5cwCUmGvRfWSAWgCg6XPBj2Bv
 seUGr3NphdjzdRFr0xHEaW9ER29H9vpkkiLGeAwswtnHyjmhrztcY2URNliOwp/z6UNU Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tygp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:32:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTDXp011629;
        Wed, 25 Sep 2019 21:32:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2v7vnyujfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:31:59 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLVxC8013512;
        Wed, 25 Sep 2019 21:31:59 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:31:59 -0700
Subject: [PATCH 3/3] xfs_scrub: remove unnecessary wakeup wait in
 scan_fs_tree
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Wed, 25 Sep 2019 14:31:57 -0700
Message-ID: <156944711783.296293.10730420610767677847.stgit@magnolia>
In-Reply-To: <156944709972.296293.5229534796146134040.stgit@magnolia>
References: <156944709972.296293.5229534796146134040.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250173
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
 

