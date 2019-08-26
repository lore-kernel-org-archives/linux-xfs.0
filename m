Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A089DC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 711A021872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:33:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WhCcQ/lK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbfHZVdc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:33:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55202 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbfHZVdc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:33:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLR5BG003477;
        Mon, 26 Aug 2019 21:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Sh6JPQbdTA8RXDd2/t01YIXfT+PkKXYLpcc12issULQ=;
 b=WhCcQ/lKtokHj5aYeDvkU7u/WTh1c47VFqjifkVsqt2ihy6Ms7jb01gPcz7B2X1jy2r4
 lL8zKQrRKuK6s1vhZyrphiuLls02BBxAQmprOyZ1T8jdAJL+d7iR3cx1iE1juLCU4ErN
 O6pwj8lHPfRrhRKgbBtskPjdKc/M2gZa00XinH1o5A8Hv5xv/WP5EuLdcdu7QGV+prkt
 S0JyLJIvvY2hqeCLw4DMevgN9ujkGx2MNZIwdFVDdfu1GSh1EB5AEDKATaGW5Fiq38Vj
 E6C+X0LvfElSFjfWB5d+9jW7P6CcgOaam/eTQllr7uT+aVJm9jpNCuzxpPwOR9Q+6IJg 3w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2umqbe80wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:33:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLXUnu021076;
        Mon, 26 Aug 2019 21:33:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2umj2xw140-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:33:29 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLXBPs006594;
        Mon, 26 Aug 2019 21:33:11 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:33:10 -0700
Subject: [PATCH 3/3] xfs_scrub: relabel verified data block counts in output
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:33:09 -0700
Message-ID: <156685518994.2843597.12295070894043864755.stgit@magnolia>
In-Reply-To: <156685517121.2843597.6446249713201700075.stgit@magnolia>
References: <156685517121.2843597.6446249713201700075.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260199
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

Relabel the count of verified data blocks to make it more obvious that
we were only looking for file data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase7.c    |   13 ++++++++-----
 scrub/xfs_scrub.c |    2 ++
 2 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/scrub/phase7.c b/scrub/phase7.c
index 065a19dc..a7a1bdf5 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -116,6 +116,7 @@ xfs_scan_summary(
 	unsigned long long	f_free;
 	bool			moveon;
 	bool			complain;
+	bool			scrub_all = scrub_data > 1;
 	int			ip;
 	int			error;
 
@@ -244,14 +245,15 @@ _("%.*f%s inodes counted; %.*f%s inodes checked.\n"),
 	}
 
 	/*
-	 * Complain if the checked block counts are off, which
+	 * Complain if the data file verification block counts are off, which
 	 * implies an incomplete check.
 	 */
-	if (ctx->bytes_checked &&
+	if (scrub_data &&
 	    (verbose ||
 	     !within_range(ctx, used_data + used_rt,
 			ctx->bytes_checked, absdiff, 1, 10,
-			_("verified blocks")))) {
+			scrub_all ? _("verified blocks") :
+				    _("verified file data blocks")))) {
 		double		b1, b2;
 		char		*b1u, *b2u;
 
@@ -262,8 +264,9 @@ _("%.*f%s inodes counted; %.*f%s inodes checked.\n"),
 
 		b1 = auto_space_units(used_data + used_rt, &b1u);
 		b2 = auto_space_units(ctx->bytes_checked, &b2u);
-		fprintf(stdout,
-_("%.1f%s data counted; %.1f%s data verified.\n"),
+		fprintf(stdout, scrub_all ?
+_("%.1f%s data counted; %.1f%s disk media verified.\n") :
+_("%.1f%s data counted; %.1f%s file data media verified.\n"),
 				b1, b1u, b2, b2u);
 		fflush(stdout);
 	}
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index c4138807..3e7c1c64 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -432,6 +432,8 @@ run_scrub_phases(
 		/* Turn on certain phases if user said to. */
 		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data) {
 			sp->fn = xfs_scan_blocks;
+			if (scrub_data > 1)
+				sp->descr = _("Verify disk integrity.");
 		} else if (sp->fn == REPAIR_DUMMY_FN &&
 			   ctx->mode == SCRUB_MODE_REPAIR) {
 			sp->descr = _("Repair filesystem.");

