Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C39C4741F
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0097207D3
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Nov 2020 18:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R38r6jF2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgKJSDl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:03:41 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52302 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgKJSDl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 13:03:41 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAHxrkU048755;
        Tue, 10 Nov 2020 18:03:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=n5gua1aNZh11/qooSP2gzXWLdEBShhM785D9AwVkc0Y=;
 b=R38r6jF2MoBfjzg1hl/PznpzINvEkw9xZ56C81XQPi7B49lD6Z/jSas5a8KW1usCea6f
 hQdtvZ3DVrgfBvR26rrpKdO1Ubxof3//cb/0dVyF/Dq6NuVrUmDJk0hI7ZsjUIK0CPnc
 JTL3Fo5WgFfPg0nox4F/gYCCUr+8j9M/dOtVOpifGfM7rQ1reKslELdzCq2qv50seowm
 asQSCv2xOv7xlxEeNRDVRHb2suoTIG7xbFZ0DyUGpCWJ7kU26mentfU0K6GzF5S6jvpI
 D7vQs6HRNzB1TTIA+670c9SswQIwL85GtH6hKnV92t1KDrHcfDbEUd20slm7s9Pg1ciX KA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34nh3aw96g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 18:03:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAI0r0J081485;
        Tue, 10 Nov 2020 18:03:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34p5g0p2bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 18:03:37 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AAI3a28004847;
        Tue, 10 Nov 2020 18:03:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 10:03:36 -0800
Subject: [PATCH 5/9] xfs_db: report ranges of invalid rt blocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 10 Nov 2020 10:03:35 -0800
Message-ID: <160503141525.1201232.11579138078872600002.stgit@magnolia>
In-Reply-To: <160503138275.1201232.927488386999483691.stgit@magnolia>
References: <160503138275.1201232.927488386999483691.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Copy-pasta the block range reporting code from check_range into
check_rrange so that we don't flood stdout with a ton of low value
messages when a bit flips somewhere in rt metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/check.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)


diff --git a/db/check.c b/db/check.c
index 553249dc9a41..5aede6cca15c 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1569,19 +1569,46 @@ check_rootdir(void)
 	}
 }
 
+static inline void
+report_rrange(
+	xfs_rfsblock_t	low,
+	xfs_rfsblock_t	high)
+{
+	if (low == high)
+		dbprintf(_("rtblock %llu out of range\n"), low);
+	else
+		dbprintf(_("rtblocks %llu..%llu out of range\n"), low, high);
+}
+
 static int
 check_rrange(
 	xfs_rfsblock_t	bno,
 	xfs_extlen_t	len)
 {
 	xfs_extlen_t	i;
+	xfs_rfsblock_t	low = 0;
+	xfs_rfsblock_t	high = 0;
+	bool		valid_range = false;
+	int		cur, prev = 0;
 
 	if (bno + len - 1 >= mp->m_sb.sb_rblocks) {
 		for (i = 0; i < len; i++) {
-			if (!sflag || CHECK_BLIST(bno + i))
-				dbprintf(_("rtblock %llu out of range\n"),
-					bno + i);
+			cur = !sflag || CHECK_BLIST(bno + i) ? 1 : 0;
+			if (cur == 1 && prev == 0) {
+				low = high = bno + i;
+				valid_range = true;
+			} else if (cur == 0 && prev == 0) {
+				/* Do nothing */
+			} else if (cur == 0 && prev == 1) {
+				report_rrange(low, high);
+				valid_range = false;
+			} else if (cur == 1 && prev == 1) {
+				high = bno + i;
+			}
+			prev = cur;
 		}
+		if (valid_range)
+			report_rrange(low, high);
 		error++;
 		return 0;
 	}

