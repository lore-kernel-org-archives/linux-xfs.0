Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5658C4360D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A18220872
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TAW6NUOb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfIYVhc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:37:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46056 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbfIYVhc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:37:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYa4D010285;
        Wed, 25 Sep 2019 21:37:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=R70hgIyKXJJpl4QuH/sILArckwUjy35P4RsDGzar/2c=;
 b=TAW6NUObj03KJ7BrHmaxnziAHs1RduKsK4KBxrhBaHBKNNifEMASe1SSyJ7830CeraGf
 SLwD+rhekf9X1F5BS6bin9Rx4m1oBfKS+d+RReqRr8BOkz8jRU2/upZX/McbdoHLu8yy
 rH2wpW3ibKEGjXrTAa2JRTBpAIjtGmX2M9wvWlGAR4uXWVVkgXBY4QkWHy6CatCXJgLn
 VDi6+CWBov19lwC9C6wvV7dEw6cA0Lu2I9IR9wWas28h8A2lqo9zrsb0PfoxaSu0o5AR
 I/0J1s1kXmEWEPFRtNfex4TAfj+FQMZ2giK7u3O5oUqWBbs3f8+BTsDq3K0uhj8GTXgO Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2v5btq7j0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:37:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYQxi078638;
        Wed, 25 Sep 2019 21:35:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2v82tkrgum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:29 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLZTp7020486;
        Wed, 25 Sep 2019 21:35:29 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:35:28 -0700
Subject: [PATCH 05/11] xfs_scrub: only call read_verify_force_io once per
 pool
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:35:27 -0700
Message-ID: <156944732781.298887.18114787426116814408.stgit@magnolia>
In-Reply-To: <156944728875.298887.8311229116097714980.stgit@magnolia>
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There's no reason we need to call read_verify_force_io every AG; we can
just let the request aggregation code do its thing and push when we're
totally done browsing the fsmap information.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c      |   16 +++++-----------
 scrub/read_verify.c |   26 +++++++++++++++++---------
 2 files changed, 22 insertions(+), 20 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index f6274a49..8063d6ce 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -411,7 +411,7 @@ xfs_check_rmap(
 	 */
 	if (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_ATTR_FORK |
 			      FMR_OF_EXTENT_MAP | FMR_OF_SPECIAL_OWNER))
-		goto out;
+		return true;
 
 	/* XXX: Filter out directory data blocks. */
 
@@ -423,16 +423,6 @@ xfs_check_rmap(
 		return false;
 	}
 
-out:
-	/* Is this the last extent?  Fire off the read. */
-	if (map->fmr_flags & FMR_OF_LAST) {
-		ret = read_verify_force_io(rvp);
-		if (ret) {
-			str_liberror(ctx, ret, descr);
-			return false;
-		}
-	}
-
 	return true;
 }
 
@@ -448,6 +438,10 @@ clean_pool(
 	if (!rvp)
 		return 0;
 
+	ret = read_verify_force_io(rvp);
+	if (ret)
+		return ret;
+
 	ret = read_verify_pool_flush(rvp);
 	if (ret)
 		goto out_destroy;
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 980b92b8..73d30817 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -282,22 +282,30 @@ read_verify_schedule_io(
 	return 0;
 }
 
+/* Force any per-thread stashed IOs into the verifier. */
+static int
+force_one_io(
+	struct ptvar		*ptv,
+	void			*data,
+	void			*foreach_arg)
+{
+	struct read_verify_pool	*rvp = foreach_arg;
+	struct read_verify	*rv = data;
+
+	if (rv->io_length == 0)
+		return 0;
+
+	return read_verify_queue(rvp, rv);
+}
+
 /* Force any stashed IOs into the verifier. */
 int
 read_verify_force_io(
 	struct read_verify_pool		*rvp)
 {
-	struct read_verify		*rv;
-	int				ret;
-
 	assert(rvp->readbuf);
-	rv = ptvar_get(rvp->rvstate, &ret);
-	if (ret)
-		return ret;
-	if (rv->io_length == 0)
-		return 0;
 
-	return read_verify_queue(rvp, rv);
+	return ptvar_foreach(rvp->rvstate, force_one_io, rvp);
 }
 
 /* How many bytes has this process verified? */

