Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2606CC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DBF1206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:37:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dzo1nXfX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387802AbfIFDh5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:37:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36756 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732799AbfIFDh5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:37:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863Xpo7104779;
        Fri, 6 Sep 2019 03:37:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=xGlsoG01q2F6ikV9a1IVpBELVHNtOOYIm3lMDOmRT5o=;
 b=Dzo1nXfXaztdaHOu9OBhkiJO8jdFJMtlj4mzHUwtdeqwQaHPATWP/F42Tq61aL+1d+b4
 udwBUY2kXxsd0rBTni7U4h/EgaSSkefKcE5ibqfxMOk8ShUzmk1WKYkOKQNOZ9sMJX5D
 krL6Xvj6FqWh5Bh/U9yC0lcDhlV0nzmqewtyhrlzgAkGKSUjIGDtH4sZnVgskJlO8uM4
 fZiziwA80+oVaZFCzy8v0trFCY24zyEb74EsE9ml8BF0ObYxZuigmrcGQKUmZbyIeAmV
 5AjzmEO2EeRL70E9kDAHi507OodqDC9BPZSQm2YpdK1e1fv/P3A+BGdxgI2nNGkEXihI VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uuf5f8346-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:37:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863XbWu069127;
        Fri, 6 Sep 2019 03:37:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2utvr4jxb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:37:54 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863brK9019525;
        Fri, 6 Sep 2019 03:37:53 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:37:53 -0700
Subject: [PATCH 02/11] xfs_scrub: abort all read verification work
 immediately on error
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:37:53 -0700
Message-ID: <156774107297.2645135.3766760104052020043.stgit@magnolia>
In-Reply-To: <156774106064.2645135.2756383874064764589.stgit@magnolia>
References: <156774106064.2645135.2756383874064764589.stgit@magnolia>
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
 

