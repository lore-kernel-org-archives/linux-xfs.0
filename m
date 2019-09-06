Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D1BC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F8BD206BB
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:42:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lZC+b4gp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfIFDme (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:42:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41402 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391382AbfIFDme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:42:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863fscG110369;
        Fri, 6 Sep 2019 03:42:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nVy87dfq86TLdO1khKxSxJVFpb5TTwiel/D3+7L414I=;
 b=lZC+b4gpvyDaeuYr+wYik3JCO4O9w0Rr0mIXFBH4sf2xm8Z4U9fxZ61Y2Dj5PuTziDTD
 VX1BVe+j7oXq84LBnrnvxktPppL4bcdt+g1Gp7j1N/EcxJbCyRann64evEuiIQMXg0A5
 qN4EAx1VIdwRYyyRYqShZ59ixEAn731FwxcM4oph5Rj9wdNjOPcRAfaDs52MiO7a3KWp
 ctKOcy5taIOl9dRmURjlyv+9byT/ZWq/mrfDg2b4MBSvMT4vm7ae/Gqg7RFrHqzXXJ/h
 DaBICtVMXs4IWcKZ5WvZ407Da9aTV4IVbSgim8ZFZGf+Ih143s3gzRK7zBGQkdRr3RT6 Ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uufsar037-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:42:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863cT29096174;
        Fri, 6 Sep 2019 03:42:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uu1b99vcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:42:31 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863gU1g024005;
        Fri, 6 Sep 2019 03:42:30 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:42:30 -0700
Subject: [PATCH 15/18] xfs_scrub: remove moveon from phase 2 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:42:30 -0700
Message-ID: <156774135010.2646807.11347689695297088978.stgit@magnolia>
In-Reply-To: <156774125578.2646807.1183436616735969617.stgit@magnolia>
References: <156774125578.2646807.1183436616735969617.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in the phase 2 code with a direct integer
error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase2.c |   88 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 55 insertions(+), 33 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 7388b8e2..81b2b3dc 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -19,13 +19,13 @@
 
 /* Scrub each AG's metadata btrees. */
 static void
-xfs_scan_ag_metadata(
+scan_ag_metadata(
 	struct workqueue		*wq,
 	xfs_agnumber_t			agno,
 	void				*arg)
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	bool				*pmoveon = arg;
+	bool				*aborted = arg;
 	struct action_list		alist;
 	struct action_list		immediate_alist;
 	unsigned long long		broken_primaries;
@@ -33,6 +33,9 @@ xfs_scan_ag_metadata(
 	char				descr[DESCR_BUFSZ];
 	int				ret;
 
+	if (*aborted)
+		return;
+
 	action_list_init(&alist);
 	action_list_init(&immediate_alist);
 	snprintf(descr, DESCR_BUFSZ, _("AG %u"), agno);
@@ -84,48 +87,52 @@ _("Filesystem might not be repairable."));
 
 	/* Everything else gets fixed during phase 4. */
 	action_list_defer(ctx, agno, &alist);
-
 	return;
 err:
-	*pmoveon = false;
+	*aborted = true;
 }
 
 /* Scrub whole-FS metadata btrees. */
 static void
-xfs_scan_fs_metadata(
+scan_fs_metadata(
 	struct workqueue		*wq,
 	xfs_agnumber_t			agno,
 	void				*arg)
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	bool				*pmoveon = arg;
+	bool				*aborted = arg;
 	struct action_list		alist;
 	int				ret;
 
+	if (*aborted)
+		return;
+
 	action_list_init(&alist);
 	ret = xfs_scrub_fs_metadata(ctx, &alist);
-	if (ret)
-		*pmoveon = false;
+	if (ret) {
+		*aborted = true;
+		return;
+	}
 
 	action_list_defer(ctx, agno, &alist);
 }
 
 /* Scan all filesystem metadata. */
-bool
-xfs_scan_metadata(
+int
+phase2_func(
 	struct scrub_ctx	*ctx)
 {
 	struct action_list	alist;
 	struct workqueue	wq;
 	xfs_agnumber_t		agno;
-	bool			moveon = true;
-	int			ret;
+	bool			aborted = false;
+	int			ret, ret2;
 
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating scrub workqueue"));
-		return false;
+		return ret;
 	}
 
 	/*
@@ -135,48 +142,53 @@ xfs_scan_metadata(
 	 */
 	action_list_init(&alist);
 	ret = xfs_scrub_primary_super(ctx, &alist);
-	if (ret) {
-		moveon = false;
+	if (ret)
 		goto out;
-	}
 	ret = action_list_process_or_defer(ctx, 0, &alist);
-	if (ret) {
-		moveon = false;
+	if (ret)
 		goto out;
-	}
 
-	for (agno = 0; moveon && agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = workqueue_add(&wq, xfs_scan_ag_metadata, agno, &moveon);
+	for (agno = 0; !aborted && agno < ctx->mnt.fsgeom.agcount; agno++) {
+		ret = workqueue_add(&wq, scan_ag_metadata, agno, &aborted);
 		if (ret) {
-			moveon = false;
 			str_liberror(ctx, ret, _("queueing per-AG scrub work"));
 			goto out;
 		}
 	}
 
-	if (!moveon)
+	if (aborted)
 		goto out;
 
-	ret = workqueue_add(&wq, xfs_scan_fs_metadata, 0, &moveon);
+	ret = workqueue_add(&wq, scan_fs_metadata, 0, &aborted);
 	if (ret) {
-		moveon = false;
 		str_liberror(ctx, ret, _("queueing per-FS scrub work"));
 		goto out;
 	}
 
 out:
-	ret = workqueue_terminate(&wq);
-	if (ret) {
-		moveon = false;
-		str_liberror(ctx, ret, _("finishing scrub work"));
+	ret2 = workqueue_terminate(&wq);
+	if (ret2) {
+		str_liberror(ctx, ret2, _("finishing scrub work"));
+		if (!ret && ret2)
+			ret = ret2;
 	}
 	workqueue_destroy(&wq);
-	return moveon;
+
+	if (!ret && aborted)
+		ret = ECANCELED;
+	return ret;
 }
 
-/* Estimate how much work we're going to do. */
 bool
-xfs_estimate_metadata_work(
+xfs_scan_metadata(
+	struct scrub_ctx	*ctx)
+{
+	return phase2_func(ctx) == 0;
+}
+
+/* Estimate how much work we're going to do. */
+int
+phase2_estimate(
 	struct scrub_ctx	*ctx,
 	uint64_t		*items,
 	unsigned int		*nr_threads,
@@ -185,5 +197,15 @@ xfs_estimate_metadata_work(
 	*items = scrub_estimate_ag_work(ctx);
 	*nr_threads = scrub_nproc(ctx);
 	*rshift = 0;
-	return true;
+	return 0;
+}
+
+bool
+xfs_estimate_metadata_work(
+	struct scrub_ctx	*ctx,
+	uint64_t		*items,
+	unsigned int		*nr_threads,
+	int			*rshift)
+{
+	return phase2_estimate(ctx, items, nr_threads, rshift) == 0;
 }

