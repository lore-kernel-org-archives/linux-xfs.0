Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 429E6C35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA74620732
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:10:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V8/iI9r8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBYAKs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:10:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54234 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAKs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:10:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P09M7m033753;
        Tue, 25 Feb 2020 00:10:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aEUgbIu5g9mZM0aIM6XSlPvo223tYkKwcXyzpT3Ps90=;
 b=V8/iI9r8TOjBqU4cPGmpuiulF8mQXhwSlkyRdrocFgn1UCjUTvPSnqnJKWSx0R+MI7Zt
 +FjzzMklBqu0xFUEmqYb09GqlBLncAHJ+gyB75uFZpH+T8Ipfns8SGTWSEvvkOl8nif1
 PyELi68fsut5Vc33Ns6sPr7xiBp/Dbi0pog3jmM1hzG/2+hPRDcLGdVz4w7BMjNrJKFG
 eLtlVJaVNtiiZRySkTiAEn3SdbW8Pa8nOftS5PomyJqoz6cjObx6FFXyf3BQ6XIq9Q7L
 eba8DYy92vF0WYjNP0hYXEx4m+MWPGagoY+4oOqi9jGXW+LI3sig2kS67/vkji4RfImc kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ycppr8gex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:10:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07tV0108964;
        Tue, 25 Feb 2020 00:10:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ybe12emew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:10:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0AgVd029895;
        Tue, 25 Feb 2020 00:10:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:10:41 -0800
Subject: [PATCH 2/7] libxfs: complain when write IOs fail
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Date:   Mon, 24 Feb 2020 16:10:40 -0800
Message-ID: <158258944088.451075.12619398750382430431.stgit@magnolia>
In-Reply-To: <158258942838.451075.5401001111357771398.stgit@magnolia>
References: <158258942838.451075.5401001111357771398.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=966 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
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

