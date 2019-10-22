Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C689CA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4A73218AE
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 18:47:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FKmraRNe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732316AbfJVSrI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:47:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47010 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbfJVSrI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:47:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiOX4089222;
        Tue, 22 Oct 2019 18:47:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=1Q7U8ovR4HM4dSD1x6mOguBZ0U5CFJ5wJYkmutZqwnk=;
 b=FKmraRNeiCaLtFTvWNWbXG+V0n7Zm47cAcYu7+h71qOr2ADAhTTo/Z+sOoZsNEWKhDIu
 /QzSXIMqkS/gjTMZ8X9Y6HcMkwLmx5gbCQwIuyEIjKzbcDDFfmcLhx19+qOqm5NSfQ3n
 elFD0IAmM7VbmvdI838av4U/Xwe14MtT9w8zUcRTELaBqr53Xiwjy6FUDxT7+q+yNOIV
 0BMNjyraFSvJxSQiqos+PEMkloN6pdx6EFBbOvtelJj2yBi+a9eWXQ94FXeW30/ghxpw
 CLk2RJ1QBhL8XXbjj1kplxpio3SThBjKrCOKXbbpk5TlFN1DyDWl0+WT2Yj6xdFnkxsd RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vqu4qrjtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhOKc125191;
        Tue, 22 Oct 2019 18:47:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vsx239njq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:47:04 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIl3TC024688;
        Tue, 22 Oct 2019 18:47:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:47:03 -0700
Subject: [PATCH 5/5] libfrog: fix workqueue_add error out
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:47:02 -0700
Message-ID: <157177002278.1458930.9155151793278556546.stgit@magnolia>
In-Reply-To: <157176999124.1458930.5678023201951458107.stgit@magnolia>
References: <157176999124.1458930.5678023201951458107.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=961
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't forget to unlock before erroring out.

Coverity-id: 1454843
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/workqueue.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index 07f11a7b..a93bba3d 100644
--- a/libfrog/workqueue.c
+++ b/libfrog/workqueue.c
@@ -142,8 +142,11 @@ workqueue_add(
 	if (wq->next_item == NULL) {
 		assert(wq->item_count == 0);
 		ret = pthread_cond_signal(&wq->wakeup);
-		if (ret)
-			goto out_item;
+		if (ret) {
+			pthread_mutex_unlock(&wq->lock);
+			free(wi);
+			return ret;
+		}
 		wq->next_item = wi;
 	} else {
 		wq->last_item->next = wi;
@@ -153,9 +156,6 @@ workqueue_add(
 	pthread_mutex_unlock(&wq->lock);
 
 	return 0;
-out_item:
-	free(wi);
-	return ret;
 }
 
 /*

