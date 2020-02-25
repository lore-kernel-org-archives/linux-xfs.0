Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBEDC35DF0
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 310C720838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 00:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KS9/1nVC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgBYANr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 19:13:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50294 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728546AbgBYANr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:13:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07bQt050103;
        Tue, 25 Feb 2020 00:13:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+iL0WDr2F57t3X2Grly3u8G+P/kADCPmR35VpEIIclo=;
 b=KS9/1nVCcwXZUNrsbpdWSdevps/EZ4+xuQEBdMqWFBeEK0AaQhuVtvcGMfTkZ0dYtUtr
 BTHI5aVCS5S3dbxKE8p6wBVJvsFo6YE4u9oauqtu5lpvQ6UsasCsuW1yY2kr+w1Rc+gU
 tWw1qP1w4PfhtVu8OLk8uXFp6jjVr17AGim+v/rdv+7X1Qt19Fn7fRY3GZhZlu3M2mtA
 6Tq9CUMNbo94TQi5VOooXthDuGnOoyqNH2H3+KYjDAclVv4QS/v/4jOtT57uVIOcnKVf
 0qit1MvPhxSRkPYr1hehJTH6c3rlJGTA9zF+tL1GJVgWven6TkwB9GEAwCiQ6VwlmWwG PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ybvr4q3k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:13:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07u8n109006;
        Tue, 25 Feb 2020 00:13:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ybe12erdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:13:44 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0Dhfk031783;
        Tue, 25 Feb 2020 00:13:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:13:43 -0800
Subject: [PATCH 21/25] libxfs: remove dangerous casting between cache_node
 and xfs_buf
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:13:42 -0800
Message-ID: <158258962280.451378.14849100198209417801.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Get rid of all the dangerous casting between cache_node and xfs_buf
since we can use container_of now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 09a2a716..29c9dd68 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -294,8 +294,9 @@ libxfs_bhash(cache_key_t key, unsigned int hashsize, unsigned int hashshift)
 static int
 libxfs_bcompare(struct cache_node *node, cache_key_t key)
 {
-	struct xfs_buf	*bp = (struct xfs_buf *)node;
-	struct xfs_bufkey *bkey = (struct xfs_bufkey *)key;
+	struct xfs_buf		*bp = container_of(node, struct xfs_buf,
+						   b_node);
+	struct xfs_bufkey	*bkey = (struct xfs_bufkey *)key;
 
 	if (bp->b_target->dev == bkey->buftarg->dev &&
 	    bp->b_bn == bkey->blkno) {
@@ -1045,7 +1046,8 @@ static void
 libxfs_brelse(
 	struct cache_node	*node)
 {
-	struct xfs_buf		*bp = (struct xfs_buf *)node;
+	struct xfs_buf		*bp = container_of(node, struct xfs_buf,
+						   b_node);
 
 	if (!bp)
 		return;
@@ -1110,7 +1112,8 @@ static int
 libxfs_bflush(
 	struct cache_node	*node)
 {
-	struct xfs_buf		*bp = (struct xfs_buf *)node;
+	struct xfs_buf		*bp = container_of(node, struct xfs_buf,
+						   b_node);
 
 	if (!bp->b_error && bp->b_flags & LIBXFS_B_DIRTY)
 		return libxfs_bwrite(bp);

