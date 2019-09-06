Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF42C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57E77206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:36:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lIV2o+6x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390521AbfIFDgn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:36:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50310 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388688AbfIFDgn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:36:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YJZ6109869;
        Fri, 6 Sep 2019 03:36:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=knduo7mmOzYKtQwIAwV8dAkAygKXoqcWiFpsWzsh43I=;
 b=lIV2o+6x+Imtdm3kHr7ogbYgilJaVdd3rp7d1iU3eBNaUUu1VQhjh6KCMK4rTbwm/snl
 3ZbQMJY9dRmHWNgvFF6pYMxbtL6JQG2wy+7pvI3sBfsWFirDJMjC1Fu0wojpLhjorMbV
 vAi9r+ZzYGFdo8S5nHqtdGPggQkSzMOgvWfh95Ddl2N/351jYDig6xhTswm0PgDY2M+t
 YadmNeS7w0VEnBa360FG2ySm5Sg3Ui4cElrhbyDKvwprev6qkr/TsgKiJpdQZjxpcJiP
 jG98ta5hV+ogYi1Fe2jt+fazHiRU7RrHb5Zt7SjVkCx1ZfDHktdNsd/pFlj7v19MVpxX NQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uuf4n039u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:36:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XdrY069349;
        Fri, 6 Sep 2019 03:36:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2utvr4jvw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:36:41 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863aeTT018985;
        Fri, 6 Sep 2019 03:36:40 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:36:40 -0700
Subject: [PATCH 04/13] xfs_scrub: redistribute read verify pool flush and
 destroy responsibilities
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:36:39 -0700
Message-ID: <156774099994.2644719.15845341004106862142.stgit@magnolia>
In-Reply-To: <156774097496.2644719.4441145106129821110.stgit@magnolia>
References: <156774097496.2644719.4441145106129821110.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
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
index b41f90e0..aff04e76 100644
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
index bb8f09a8..e59d3e67 100644
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

