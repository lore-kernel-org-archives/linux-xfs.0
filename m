Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942F9C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6609221D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:35:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g1z3//Ip"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfIYVfG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:35:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59382 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbfIYVfF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:35:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYU0V054871;
        Wed, 25 Sep 2019 21:35:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=xGlsoG01q2F6ikV9a1IVpBELVHNtOOYIm3lMDOmRT5o=;
 b=g1z3//IpBSO8wsKDX2zoJ+M3mWl5zlSzWemThWLh/9y2SpiA2h/+pnJG34YiDzpMrv1p
 noBw/QaS2tw3owzvwRYREVuqulN7KNc/YnRn8zYTY5AGKAfrHVXL1V60rHKMbk8B++GJ
 hDRmRmcqhSO1F2XRTl0sP874OBHbDkSUjSgXeZ3LpNirWpS6jS1FO3/1cCjiYBLfM2Fi
 38MMDdzBqnbwtJYoNP+lk3TlkU6hqYZaSCF3q6+sU2xmSt6f07vl+REm0ViCk6XGblBC
 IEhK4jiq6Qk4a4CpZG6+g4oStUYze0Wiwe4GE92rcQ3HsDi+foKhQHF3EzcY+CkoD7s9 uA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v5cgr7exh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYRO0011404;
        Wed, 25 Sep 2019 21:35:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v829w4yfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:35:02 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLZ2sF014671;
        Wed, 25 Sep 2019 21:35:02 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:35:01 -0700
Subject: [PATCH 02/11] xfs_scrub: abort all read verification work
 immediately on error
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:35:00 -0700
Message-ID: <156944730076.298887.7324643890664422671.stgit@magnolia>
In-Reply-To: <156944728875.298887.8311229116097714980.stgit@magnolia>
References: <156944728875.298887.8311229116097714980.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new abort function to the read verify pool code so that the caller
can immediately abort all pending verification work if things start
going wrong.  There's no point in waiting for queued work to run if
we've already decided to bail.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c      |    6 +++---
 scrub/read_verify.c |   10 ++++++++++
 scrub/read_verify.h |    1 +
 3 files changed, 14 insertions(+), 3 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index d9285fee..4c81ee7b 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -514,16 +514,16 @@ _("Could not create data device media verifier."));
 
 out_rtpool:
 	if (vs.rvp_realtime) {
-		read_verify_pool_flush(vs.rvp_realtime);
+		read_verify_pool_abort(vs.rvp_realtime);
 		read_verify_pool_destroy(vs.rvp_realtime);
 	}
 out_logpool:
 	if (vs.rvp_log) {
-		read_verify_pool_flush(vs.rvp_log);
+		read_verify_pool_abort(vs.rvp_log);
 		read_verify_pool_destroy(vs.rvp_log);
 	}
 out_datapool:
-	read_verify_pool_flush(vs.rvp_data);
+	read_verify_pool_abort(vs.rvp_data);
 	read_verify_pool_destroy(vs.rvp_data);
 out_rbad:
 	bitmap_free(&vs.r_bad);
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 00627307..301e9b48 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -117,6 +117,16 @@ read_verify_pool_init(
 	return NULL;
 }
 
+/* Abort all verification work. */
+void
+read_verify_pool_abort(
+	struct read_verify_pool		*rvp)
+{
+	if (!rvp->errors_seen)
+		rvp->errors_seen = ECANCELED;
+	workqueue_terminate(&rvp->wq);
+}
+
 /* Finish up any read verification work. */
 void
 read_verify_pool_flush(
diff --git a/scrub/read_verify.h b/scrub/read_verify.h
index 5fabe5e0..f0ed8902 100644
--- a/scrub/read_verify.h
+++ b/scrub/read_verify.h
@@ -19,6 +19,7 @@ struct read_verify_pool *read_verify_pool_init(struct scrub_ctx *ctx,
 		struct disk *disk, size_t miniosz,
 		read_verify_ioerr_fn_t ioerr_fn,
 		unsigned int submitter_threads);
+void read_verify_pool_abort(struct read_verify_pool *rvp);
 void read_verify_pool_flush(struct read_verify_pool *rvp);
 void read_verify_pool_destroy(struct read_verify_pool *rvp);
 

