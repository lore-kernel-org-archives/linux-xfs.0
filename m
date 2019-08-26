Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81C1C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77A682186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:28:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bzfQQEGA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfHZV2s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:28:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60352 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:28:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDmdg000929;
        Mon, 26 Aug 2019 21:28:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=JHnw/hevPzWZSI+BBkVb5BSaAjoF/AxGvMYMg7lUMG0=;
 b=bzfQQEGA7l1iqD20vxbrmXRNxquqx3R8Evn7mW07R8SIZPdrhBW6vs1nLOO8iPRFjftZ
 Xe4FHY1/OfQOoHyUGAcTo/FaFKWev22q4bX+Nns9a1JW569JYfO7o/g8+RDM+a2qz7/9
 tWRcogrKh1IaH7vyxideVOZvNVdVpQfdbt0bmveBc4dHtqB8pv5Lm3GTYgjmhzQDq1nL
 mI7ExY0u+uQGcSZGbAjZ6zka4Pa2GgQixiH51vem7RIw0BW9vdJ6Y0sYTcvFZEKKHvJ9
 UHZXaXZ+pR29hVZPyC+M/8EsZzp8m2pfPOo7BoOet485NxxKCxNtTnZDhOIgIoCpX+3K LQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2umpxx0595-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIRKg025044;
        Mon, 26 Aug 2019 21:28:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2umj1tk524-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:28:45 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLSiUq003680;
        Mon, 26 Aug 2019 21:28:44 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:28:44 -0700
Subject: [PATCH 04/13] xfs_scrub: redistribute read verify pool flush and
 destroy responsibilities
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:28:43 -0700
Message-ID: <156685492314.2841546.9734309698921494896.stgit@magnolia>
In-Reply-To: <156685489821.2841546.10616502094098044568.stgit@magnolia>
References: <156685489821.2841546.10616502094098044568.stgit@magnolia>
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

Since workqueues now have separate primitives for "wait for all queued
work" and "destroy workqueue", it makes more sense for the read verify
pool code to call the workqueue destructor from its own destructor
function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c      |    9 +++++++--
 scrub/read_verify.c |    2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 3c1e7dc3..3f80bca5 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -511,12 +511,17 @@ _("Could not create data device media verifier."));
 	return moveon;
 
 out_rtpool:
-	if (vs.rvp_realtime)
+	if (vs.rvp_realtime) {
+		read_verify_pool_flush(vs.rvp_realtime);
 		read_verify_pool_destroy(vs.rvp_realtime);
+	}
 out_logpool:
-	if (vs.rvp_log)
+	if (vs.rvp_log) {
+		read_verify_pool_flush(vs.rvp_log);
 		read_verify_pool_destroy(vs.rvp_log);
+	}
 out_datapool:
+	read_verify_pool_flush(vs.rvp_data);
 	read_verify_pool_destroy(vs.rvp_data);
 out_rbad:
 	bitmap_free(&vs.r_bad);
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 7d95ab00..1e38a1a7 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -121,7 +121,6 @@ read_verify_pool_flush(
 	struct read_verify_pool		*rvp)
 {
 	workqueue_terminate(&rvp->wq);
-	workqueue_destroy(&rvp->wq);
 }
 
 /* Finish up any read verification work and tear it down. */
@@ -129,6 +128,7 @@ void
 read_verify_pool_destroy(
 	struct read_verify_pool		*rvp)
 {
+	workqueue_destroy(&rvp->wq);
 	ptvar_free(rvp->rvstate);
 	ptcounter_free(rvp->verified_bytes);
 	free(rvp->readbuf);

