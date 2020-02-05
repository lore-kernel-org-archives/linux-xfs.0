Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D82C35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DCD3214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:47:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EDUa9LrY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbgBEArl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:47:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34542 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727619AbgBEArl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:47:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150dv1I103602;
        Wed, 5 Feb 2020 00:47:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ii7PIM9vxuk6Of+iLz1AlGtSJ3A8GJXC3T/Hpgf/p90=;
 b=EDUa9LrYcmVv0YZwk++DtLJPXwvF7N2889eYQ8Iao4e4fLjUlJwpikCZGp+1awTlp27n
 Ubf4DFUIPmMk5tkbYuzLbbgrjTtVSlrQU/eA2oR1FEQPnA/SH6mk7Sz+69LZuTI1yuMY
 iRE/ZpTOkax4C+kxaHrbuRtMBkYvmQbomTe2BdFg4xFHHdJS8ji7TvSDHRzHlx4qhX3n
 ZFC5gPMaEI8l1d7Cbyk4stOYdBSxYHyvZn/dt7olMcy17vMX7VnKIXVyUzlZzhCtO0jO
 x/VPb1+jX/iznmOPV1u/1BNBA9ssMAMMcTjxzzFfj4dmJvt+qyQBh4pPtZKubij/7dsO uA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xykbp00ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:47:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150cu1T165876;
        Wed, 5 Feb 2020 00:47:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xykbqge5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:47:39 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0150lcJh010673;
        Wed, 5 Feb 2020 00:47:38 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:47:38 -0800
Subject: [PATCH 2/4] libxfs: complain when write IOs fail
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:47:37 -0800
Message-ID: <158086365728.2079905.9556999948179065078.stgit@magnolia>
In-Reply-To: <158086364511.2079905.3531505051831183875.stgit@magnolia>
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=842
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=899 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Complain whenever a metadata write fails.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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

