Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D519DC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3B372186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:30:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YbmAFoF1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfHZVa2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:30:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34042 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728402AbfHZVa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:30:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDlZl000848;
        Mon, 26 Aug 2019 21:30:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=cGTv/Iq0TVJkO8gRRDBYnEryVKmR+1L1vwLi0Fq8xXA=;
 b=YbmAFoF1n+TV7K1z7Q97//awEEtvqS2+cFOPnXUsPbwpLvSm4DFrM8ywT02dVaAlHEO/
 hm78OEL/sbt2dM61zOKD1l2R1YAmkZZA/XksyeHZpucrtc50KkBW1VtggyhiWpur2Uc3
 snmmdIdw8tyE8ttgcJmXHjKpqT+TgDxQi3M/vFS3d68kyNG8wgNjn659LgXyj2BPyGvd
 b5LJ7gA/zpR+rWs9mjunVGRSRPKKMhkeEUiahmFBiltwJmBC6J5GR3HPoD+5l5FLeNj8
 U+mbT6U4lybo8hA8y4UdCD8+Hj6ihcE38xu709yjADI5otneXJcJZJyR2OdNzrzx5bXH lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2umpxx05f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:30:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLItF9185000;
        Mon, 26 Aug 2019 21:30:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2umj2xvxsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:30:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLUOso004638;
        Mon, 26 Aug 2019 21:30:25 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:30:23 -0700
Subject: [PATCH 05/11] xfs_scrub: only call read_verify_force_io once per
 pool
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:30:22 -0700
Message-ID: <156685502209.2841898.17592574499659592500.stgit@magnolia>
In-Reply-To: <156685499099.2841898.18430382226915450537.stgit@magnolia>
References: <156685499099.2841898.18430382226915450537.stgit@magnolia>
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

There's no reason we need to call read_verify_force_io every AG; we can
just let the request aggregation code do its thing and push when we're
totally done browsing the fsmap information.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c      |   16 +++++-----------
 scrub/read_verify.c |   26 +++++++++++++++++---------
 2 files changed, 22 insertions(+), 20 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 010cceef..86d848a0 100644
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
index 3bc56bdc..7cfe834c 100644
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

