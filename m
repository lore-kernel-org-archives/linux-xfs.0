Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E2FC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 121442186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WU1Kb+Ow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbfHZV3C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:29:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50490 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV3A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:29:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLQuNG003365;
        Mon, 26 Aug 2019 21:28:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=1YniwNiLdOlMW9TPy9kWxX9URwtPJQywOrMmHK5EQkE=;
 b=WU1Kb+Owrf88jLRrlcnLi12SnLifOb+XBctWIhcKPwhr+IUg8PoE/UaLGPq6+gRGfhRx
 0xnU+dOtYtoOTe4qRsLZyeg1tjYs8qsXdz9IC6DNOBJh/M+VqS2cx8/mqojUNJ93hQq+
 ck/uRAMG30heh4glPT7iXJ5MNnOwe0r6qKOdbgt/O0+NT6GPcRE7CE/pAizHy7WXy0fo
 7oXFiRpyEk0PiZcAXIqEa/JDWYdoKWiSzqSIrJumnkRKXpDqyriPKn8zPNGmJtsGKgwN
 50FnUF6+2c444Rqt/LPWIEJSyPoGnvDRN4MW77rrMrBo4fxBc0vqO0l+WwgS9rFArS9l vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2umqbe80a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIs7g184954;
        Mon, 26 Aug 2019 21:28:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2umj2xvwht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:57 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLSucT028500;
        Mon, 26 Aug 2019 21:28:56 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:28:56 -0700
Subject: [PATCH 06/13] libfrog: add missing per-thread variable error
 handling
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:28:55 -0700
Message-ID: <156685493551.2841546.4155863321510387304.stgit@magnolia>
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

Add missing return value checks for everything that the per-thread
variable code calls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/ptvar.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)


diff --git a/libfrog/ptvar.c b/libfrog/ptvar.c
index 6cb58208..ecbbea61 100644
--- a/libfrog/ptvar.c
+++ b/libfrog/ptvar.c
@@ -44,8 +44,12 @@ ptvar_alloc(
 	int		ret;
 
 #ifdef _SC_LEVEL1_DCACHE_LINESIZE
+	long		l1_dcache;
+
 	/* Try to prevent cache pingpong by aligning to cacheline size. */
-	size = max(size, sysconf(_SC_LEVEL1_DCACHE_LINESIZE));
+	l1_dcache = sysconf(_SC_LEVEL1_DCACHE_LINESIZE);
+	if (l1_dcache > 0)
+		size = roundup(size, l1_dcache);
 #endif
 
 	ptv = malloc(PTVAR_SIZE(nr, size));
@@ -88,17 +92,30 @@ ptvar_get(
 	int		*retp)
 {
 	void		*p;
+	int		ret;
 
 	p = pthread_getspecific(ptv->key);
 	if (!p) {
-		pthread_mutex_lock(&ptv->lock);
+		ret = pthread_mutex_lock(&ptv->lock);
+		if (ret) {
+			*retp = ret;
+			return NULL;
+		}
 		assert(ptv->nr_used < ptv->nr_counters);
 		p = &ptv->data[(ptv->nr_used++) * ptv->data_size];
-		pthread_setspecific(ptv->key, p);
+		ret = pthread_setspecific(ptv->key, p);
+		if (ret)
+			goto out_unlock;
 		pthread_mutex_unlock(&ptv->lock);
 	}
 	*retp = 0;
 	return p;
+
+out_unlock:
+	ptv->nr_used--;
+	pthread_mutex_unlock(&ptv->lock);
+	*retp = ret;
+	return NULL;
 }
 
 /* Iterate all of the per-thread variables. */
@@ -111,7 +128,10 @@ ptvar_foreach(
 	size_t		i;
 	int		ret;
 
-	pthread_mutex_lock(&ptv->lock);
+	ret = pthread_mutex_lock(&ptv->lock);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < ptv->nr_used; i++) {
 		ret = fn(ptv, &ptv->data[i * ptv->data_size], foreach_arg);
 		if (ret)

