Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FB0C761A1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2C5121D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tV0bIgH+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgBTBmD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:42:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60216 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727338AbgBTBmD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:42:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1dTSv113434;
        Thu, 20 Feb 2020 01:41:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aEUgbIu5g9mZM0aIM6XSlPvo223tYkKwcXyzpT3Ps90=;
 b=tV0bIgH+oo3Z9T2swBAYOweNmkJbfN4MegVYWmcQd5E5O25wY+BOkjSl/5tU0CTdq4FP
 DCh0R5L4xWPiR6OliqxqXL+D88CsZ3kmfeUJ9yTN/vEjK8LDypXFujY4q2sJwI0716Mc
 MECTlJR0iuiy5/IEtC0h6vYsuc2pzyHdm493CLVUCkVIDnOBqJ8nIxs9YZz33Gkgrpxk
 dZf6ExOh4vePVtHscVf7o7/IdHgg2+R02QzfElWL246OygK1w57sfPlI5wyRyvF7xpEy
 v4jLMjy9PTQ+CPlmrbGvdKKtK/O2X8C0ICnYvkNIYIZPCFLw4XAghGJUEsUZWJOsZqrX Mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2y8udkesv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:41:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1flY2145861;
        Thu, 20 Feb 2020 01:41:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2y8ud4pw74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:41:58 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01K1ft7C002339;
        Thu, 20 Feb 2020 01:41:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:41:55 -0800
Subject: [PATCH 2/8] libxfs: complain when write IOs fail
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 19 Feb 2020 17:41:54 -0800
Message-ID: <158216291420.601264.11744188975956925500.stgit@magnolia>
In-Reply-To: <158216290180.601264.5491208016048898068.stgit@magnolia>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=969 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Complain whenever a metadata write fails.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/rdwr.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 2e9f66cc..8b47d438 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1149,7 +1149,12 @@ libxfs_writebufr(xfs_buf_t *bp)
 			(long long)LIBXFS_BBTOOFF64(bp->b_bn),
 			(long long)bp->b_bn, bp, bp->b_error);
 #endif
-	if (!bp->b_error) {
+	if (bp->b_error) {
+		fprintf(stderr,
+	_("%s: write failed on %s bno 0x%llx/0x%x, err=%d\n"),
+			__func__, bp->b_ops->name,
+			(long long)bp->b_bn, bp->b_bcount, -bp->b_error);
+	} else {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_EXIT |
 				 LIBXFS_B_UNCHECKED);

