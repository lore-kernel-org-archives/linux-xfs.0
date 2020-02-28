Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3303C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A038D246AC
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iukrej3i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgB1Xkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:40:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48978 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgB1Xkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:40:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNbowX160796;
        Fri, 28 Feb 2020 23:38:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=t/OMzQ4zWDW1Ox+KUxd+SOlzzrgdlex99YcgaCKeQ+Y=;
 b=iukrej3ijaHyz1RZJfhFzLUaFu+KFb8b7HHyfX1tVJ5cmulMlssg5EVqyg998CJlTpG6
 vXTCZsCXs2/YycEIA11ytnRBjncecYMZL/gJ2fyviskaLiVdOQxLl4PSUX7knb6dv+3W
 vuGoTJfaPbIZ0CIEZ925y3rpEWovsAAKsxK5SD8Iwo+Pp0VV+YwaqILQlndRk8aohR0/
 AsBAtm8VmD5KqWvSw9rEl2HVFoX/SpUnhnYNz5Pf7ddLEcyu5JE0NZnReJ4sv3wC5AnB
 2hMLZS1cac8xjXsms+ivbwP4tRK9fKU/wySbR5WcdAEWuiYQ6B/qMnfTfAB+rC9nxscn EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yf0dmc5wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNcNRN064710;
        Fri, 28 Feb 2020 23:38:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ydj4s34d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:38:34 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01SNcXTS025030;
        Fri, 28 Feb 2020 23:38:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:38:33 -0800
Subject: [PATCH 21/26] libxfs: remove dangerous casting between cache_node
 and xfs_buf
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:38:31 -0800
Message-ID: <158293311167.1549542.8858385148278085051.stgit@magnolia>
In-Reply-To: <158293297395.1549542.18143701542461010748.stgit@magnolia>
References: <158293297395.1549542.18143701542461010748.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Get rid of all the dangerous casting between cache_node and xfs_buf
since we can use container_of now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/rdwr.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index f92c7db9..68e8e014 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -301,8 +301,9 @@ libxfs_bhash(cache_key_t key, unsigned int hashsize, unsigned int hashshift)
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
@@ -1052,7 +1053,8 @@ static void
 libxfs_brelse(
 	struct cache_node	*node)
 {
-	struct xfs_buf		*bp = (struct xfs_buf *)node;
+	struct xfs_buf		*bp = container_of(node, struct xfs_buf,
+						   b_node);
 
 	if (!bp)
 		return;
@@ -1117,7 +1119,8 @@ static int
 libxfs_bflush(
 	struct cache_node	*node)
 {
-	struct xfs_buf		*bp = (struct xfs_buf *)node;
+	struct xfs_buf		*bp = container_of(node, struct xfs_buf,
+						   b_node);
 
 	if (!bp->b_error && bp->b_flags & LIBXFS_B_DIRTY)
 		return libxfs_bwrite(bp);

