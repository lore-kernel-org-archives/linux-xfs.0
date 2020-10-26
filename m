Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD949C55178
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B00720874
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:32:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0bjFxqEn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406350AbgJZXcS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:32:18 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41292 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406297AbgJZXcR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:32:17 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPI5o177109;
        Mon, 26 Oct 2020 23:32:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yl4CouYa+M0qURVPVz3diPwJMMwTBvS+AAPV7GvCDT8=;
 b=0bjFxqEnQ/lA3aV4SNEF+jTYCjmHlzWCQ2cdqif2JZNuNElfaruBpzahJI/JYSvyTmnq
 +CjzF5rSRGwVBcFFYo39nhYDnGOeYvWfpWQAcy04TQ6zRubapOqUfpboT1tUiksU/7X9
 wN1NHOqRdDwOJXTY7Yj5LK8uBpXbqVUvtNfAQ1eHJx6F87B8sjHs5O5Wud3OoTib4gxY
 WvHH5cRZzBw6EErzSqBMnl1EAThmmIlDggJy7lahsRdFaC6mHI9qkXK7iyl0JXXcRxH5
 hlTyOLmnvG3mmX1lH7UdLI0g9W0y2O8YS6wy86Qvp+EjVffZJCopJ7uUAB0mRE9pGm/Y 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9saqctm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:32:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQEeN032501;
        Mon, 26 Oct 2020 23:32:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cx1q29y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:32:15 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNWE6n004683;
        Mon, 26 Oct 2020 23:32:14 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:32:06 -0700
Subject: [PATCH 2/5] xfs: remove unnecessary parameter from
 scrub_scan_estimate_blocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:32:05 -0700
Message-ID: <160375512596.879169.13683347692314634844.stgit@magnolia>
In-Reply-To: <160375511371.879169.3659553317719857738.stgit@magnolia>
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=2 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The only caller that cares about the file counts uses it to compute the
number of files used, so return that and save a parameter.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/fscounters.c |    8 +++-----
 scrub/fscounters.h |    2 +-
 scrub/phase6.c     |    7 +++----
 scrub/phase7.c     |    5 +----
 4 files changed, 8 insertions(+), 14 deletions(-)


diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index e9901fcdf6df..9a240d49477b 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -116,7 +116,7 @@ scrub_count_all_inodes(
 }
 
 /*
- * Estimate the number of blocks and inodes in the filesystem.  Returns 0
+ * Estimate the number of blocks and used inodes in the filesystem.  Returns 0
  * or a positive error number.
  */
 int
@@ -126,8 +126,7 @@ scrub_scan_estimate_blocks(
 	unsigned long long		*d_bfree,
 	unsigned long long		*r_blocks,
 	unsigned long long		*r_bfree,
-	unsigned long long		*f_files,
-	unsigned long long		*f_free)
+	unsigned long long		*f_files_used)
 {
 	struct xfs_fsop_counts		fc;
 	int				error;
@@ -141,8 +140,7 @@ scrub_scan_estimate_blocks(
 	*d_bfree = fc.freedata;
 	*r_blocks = ctx->mnt.fsgeom.rtblocks;
 	*r_bfree = fc.freertx;
-	*f_files = fc.allocino;
-	*f_free = fc.freeino;
+	*f_files_used = fc.allocino - fc.freeino;
 
 	return 0;
 }
diff --git a/scrub/fscounters.h b/scrub/fscounters.h
index 1fae58a6b287..13bd9967f004 100644
--- a/scrub/fscounters.h
+++ b/scrub/fscounters.h
@@ -9,7 +9,7 @@
 int scrub_scan_estimate_blocks(struct scrub_ctx *ctx,
 		unsigned long long *d_blocks, unsigned long long *d_bfree,
 		unsigned long long *r_blocks, unsigned long long *r_bfree,
-		unsigned long long *f_files, unsigned long long *f_free);
+		unsigned long long *f_files_used);
 int scrub_count_all_inodes(struct scrub_ctx *ctx, uint64_t *count);
 
 #endif /* XFS_SCRUB_FSCOUNTERS_H_ */
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 8d976732d8e1..87828b60fbed 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -719,12 +719,11 @@ phase6_estimate(
 	unsigned long long	d_bfree;
 	unsigned long long	r_blocks;
 	unsigned long long	r_bfree;
-	unsigned long long	f_files;
-	unsigned long long	f_free;
+	unsigned long long	dontcare;
 	int			ret;
 
-	ret = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree,
-				&r_blocks, &r_bfree, &f_files, &f_free);
+	ret = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
+			&r_bfree, &dontcare);
 	if (ret) {
 		str_liberror(ctx, ret, _("estimating verify work"));
 		return ret;
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 96876f7c0596..bc652ab6f44a 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -111,8 +111,6 @@ phase7_func(
 	unsigned long long	d_bfree;
 	unsigned long long	r_blocks;
 	unsigned long long	r_bfree;
-	unsigned long long	f_files;
-	unsigned long long	f_free;
 	bool			complain;
 	int			ip;
 	int			error;
@@ -160,7 +158,7 @@ phase7_func(
 	}
 
 	error = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
-			&r_bfree, &f_files, &f_free);
+			&r_bfree, &used_files);
 	if (error) {
 		str_liberror(ctx, error, _("estimating verify work"));
 		return error;
@@ -177,7 +175,6 @@ phase7_func(
 	/* Report on what we found. */
 	used_data = cvt_off_fsb_to_b(&ctx->mnt, d_blocks - d_bfree);
 	used_rt = cvt_off_fsb_to_b(&ctx->mnt, r_blocks - r_bfree);
-	used_files = f_files - f_free;
 	stat_data = totalcount.dbytes;
 	stat_rt = totalcount.rbytes;
 

