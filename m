Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DACC7C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 16:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9977207DE
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 16:42:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z4H49FqI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgHKQm2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 12:42:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44618 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728975AbgHKQm1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Aug 2020 12:42:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07BGanXq045153;
        Tue, 11 Aug 2020 16:42:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=1n0mw8ZnAQVrWPVQfkyVpoARVriY6+u5qGJ4Lt2Cdw0=;
 b=Z4H49FqIE++NH2odROW3SQCdaOBvWikXJJYfTbgJFcv2swKT/uaEPJxWkq3okxgA1Yj0
 eYZ9e+G/MQvMEIEcNWyH56i4oUA45nts4joShb3yxElpi2Qm28y+8Bj6qCr5o4+l8ltl
 vBpIi1TEHCFpQrMawPoLA/ld1SYMNDAvCcuMUWprMX4vwx3uRnjMhlu54l6ryVVzE+PN
 KJXfUMdLd0wbWrRW9LewUuG5QCutbDvW4v65EKQJPHyYrU7iI+J18DdTzIvxmfZDYO75
 9o63V+JflnKgEqGL8+KZ77pFsS3jGjDpndVD/DAtwQCrPFFs8VMZ9fWvMlu92zmDmD5M oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32sm0mnu2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Aug 2020 16:42:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07BGdI7R100054;
        Tue, 11 Aug 2020 16:42:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32t5y4ekt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Aug 2020 16:42:26 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07BGgPFq012597;
        Tue, 11 Aug 2020 16:42:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Aug 2020 16:42:25 +0000
Subject: [PATCH 1/2] xfs_db: fix nlink usage in check
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 11 Aug 2020 09:42:24 -0700
Message-ID: <159716414414.2135493.1784583001962165153.stgit@magnolia>
In-Reply-To: <159716413625.2135493.4789129138005837744.stgit@magnolia>
References: <159716413625.2135493.4789129138005837744.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008110115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008110115
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

process_inode uses a local convenience variable to abstract the
differences between the ondisk nlink fields in a v1 inode and a v2
inode.  Use this variable for checking and reporting errors.

Fixes: 6526f30e4801 ("xfs_db: stop misusing an onstack inode")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/check.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/db/check.c b/db/check.c
index c2233a0d1ba7..ef0e82d4efa1 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2797,10 +2797,10 @@ process_inode(
 					be64_to_cpu(dip->di_nblocks), ino);
 			error++;
 		}
-		if (dip->di_nlink != 0) {
+		if (nlink != 0) {
 			if (v)
 				dbprintf(_("bad nlink %d for free inode %lld\n"),
-					be32_to_cpu(dip->di_nlink), ino);
+					nlink, ino);
 			error++;
 		}
 		if (dip->di_mode != 0) {

