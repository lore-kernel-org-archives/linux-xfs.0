Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042C3C4360C
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDA0C205F4
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:40:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GtVW1yEA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbfIYVki (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:40:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43426 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728732AbfIYVki (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:40:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdQIP061490;
        Wed, 25 Sep 2019 21:40:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Cc5znIrxvF9nLIQ7RE9n5lplDgbplDA/XOkxBfCU+rc=;
 b=GtVW1yEA+H4tIqN6/HH+JHhOhEC2vR8uh9toOwjNs5gltsi2puW4ETTZw4hvZHE33B/4
 Qn5M1j44eOM5vZKiJribHkBzsVGmrp7s1CcQJq8Rcy0s50dPykANtW0kGRxGKM6/6QeA
 wq+ggYwGjUkj32A60JS6dndQywiCzWa8YT3whnxiRpdza6F+RB3Gq7/XStmIpROa40it
 KBkvZqoy6LgWTKPt8i9JfhEa7303v1mcTHpcZlcY3vr8gnX/S1P6PNno/MQtjcMiiiPC
 ixmE9IeZF8amC41WnruvLH5bgI3eTt4D5/brfW+zyS8IqxbHjvPYypiL68Ko1PaV+23F SQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tyhqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:40:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdNlR033582;
        Wed, 25 Sep 2019 21:40:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v7vnyuvgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:40:34 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLd7SA017586;
        Wed, 25 Sep 2019 21:39:07 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:39:07 -0700
Subject: [PATCH 10/18] xfs_scrub: remove moveon from phase 7 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:39:06 -0700
Message-ID: <156944754618.301514.16246827692063674825.stgit@magnolia>
In-Reply-To: <156944748487.301514.14685083474028866113.stgit@magnolia>
References: <156944748487.301514.14685083474028866113.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in the phase 7 code with a direct integer
error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase7.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)


diff --git a/scrub/phase7.c b/scrub/phase7.c
index 452d56ad..ff51c634 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -73,7 +73,7 @@ count_block_summary(
 
 /* Add all the summaries in the per-thread counter */
 static int
-xfs_add_summaries(
+add_summaries(
 	struct ptvar		*ptv,
 	void			*data,
 	void			*arg)
@@ -93,8 +93,8 @@ xfs_add_summaries(
  * filesystem we'll be content if the summary counts are within 10% of
  * what we observed.
  */
-bool
-xfs_scan_summary(
+int
+phase7_func(
 	struct scrub_ctx	*ctx)
 {
 	struct summary_counts	totalcount = {0};
@@ -113,7 +113,6 @@ xfs_scan_summary(
 	unsigned long long	r_bfree;
 	unsigned long long	f_files;
 	unsigned long long	f_free;
-	bool			moveon;
 	bool			complain;
 	bool			scrub_all = scrub_data > 1;
 	int			ip;
@@ -123,33 +122,31 @@ xfs_scan_summary(
 	action_list_init(&alist);
 	error = xfs_scrub_fs_summary(ctx, &alist);
 	if (error)
-		return false;
+		return error;
 	error = action_list_process(ctx, ctx->mnt.fd, &alist,
 			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
 	if (error)
-		return false;
+		return error;
 
 	/* Flush everything out to disk before we start counting. */
 	error = syncfs(ctx->mnt.fd);
 	if (error) {
 		str_errno(ctx, ctx->mntpoint);
-		return false;
+		return error;
 	}
 
 	error = ptvar_alloc(scrub_nproc(ctx), sizeof(struct summary_counts),
 			&ptvar);
 	if (error) {
 		str_liberror(ctx, error, _("setting up block counter"));
-		return false;
+		return error;
 	}
 
 	/* Use fsmap to count blocks. */
 	error = scrub_scan_all_spacemaps(ctx, count_block_summary, ptvar);
-	if (error) {
-		moveon = false;
+	if (error)
 		goto out_free;
-	}
-	error = ptvar_foreach(ptvar, xfs_add_summaries, &totalcount);
+	error = ptvar_foreach(ptvar, add_summaries, &totalcount);
 	if (error) {
 		str_liberror(ctx, error, _("counting blocks"));
 		goto out_free;
@@ -160,15 +157,14 @@ xfs_scan_summary(
 	error = scrub_count_all_inodes(ctx, &counted_inodes);
 	if (error) {
 		str_liberror(ctx, error, _("counting inodes"));
-		moveon = false;
-		goto out;
+		return error;
 	}
 
 	error = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
 			&r_bfree, &f_files, &f_free);
 	if (error) {
 		str_liberror(ctx, error, _("estimating verify work"));
-		return false;
+		return error;
 	}
 
 	/*
@@ -277,11 +273,15 @@ _("%.1f%s data counted; %.1f%s file data media verified.\n"),
 		fflush(stdout);
 	}
 
-	moveon = true;
-
-out:
-	return moveon;
+	return 0;
 out_free:
 	ptvar_free(ptvar);
-	return moveon;
+	return error;
+}
+
+bool
+xfs_scan_summary(
+	struct scrub_ctx	*ctx)
+{
+	return phase7_func(ctx) == 0;
 }

