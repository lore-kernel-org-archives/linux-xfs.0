Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C81ECE588
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD141214AE
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:21:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ipIpAYmV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfJORV7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 13:21:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52020 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfJORV6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 13:21:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FHJ0aI051109;
        Tue, 15 Oct 2019 17:21:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=hWm/rwZRIE/e564edzCu8V2GBvr/9e3s0yKEeSCZMPQ=;
 b=ipIpAYmVYf4xcr14D4etduY+IYcgJnFCMl+AqwfVsarO60UguIIpKUIbPKD/kT20wyLt
 pUYut8qHdRRSvnodfuxhktgvfLH+5MB0RFWNwlmWhnsbfGONf97NxAwVvu3ceszFCX4y
 ztoKyqZVWAfnf6vwhlKEp44hzq0gLOcDrPwHrgZGSvQ/M2K0czJ/uk/fsdo7W2O2RbZV
 P9GQnlXX/InWuUMraQHkeVVAIGDbB9XKPpOrfxSS2PFJUP2pEGgyhe9QZnmgeWk4+qfU
 OEd6gZrL8wq6/aqBWI6Y9IKg+vVK14IRw89m2IIUh8eqMftfUqePByqQCUCq6j+JBmDT 2Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vk6sqhkjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 17:21:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9FHJ67F001354;
        Tue, 15 Oct 2019 17:21:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vn8enjpju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 17:21:56 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9FHLtWa019817;
        Tue, 15 Oct 2019 17:21:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 17:21:54 +0000
Date:   Tue, 15 Oct 2019 10:21:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 02/11] xfs_scrub: abort all read verification work
 immediately on error
Message-ID: <20191015172153.GJ13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9411 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150148
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
v2: fix errors_seen bogosity
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
index d020ce2f..835b9660 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -121,6 +121,16 @@ read_verify_pool_init(
 	return NULL;
 }
 
+/* Abort all verification work. */
+void
+read_verify_pool_abort(
+	struct read_verify_pool		*rvp)
+{
+	if (!rvp->runtime_error)
+		rvp->runtime_error = ECANCELED;
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
 
