Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57879CA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29F3C21924
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O5cQYEdz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfJ2XbV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:31:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49126 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJ2XbV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:31:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNSnFe010501
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=IeXIB4hfpCehcGatiKkGooz2WKRyIKeWNw4gyfU0D6Q=;
 b=O5cQYEdzPoONUCxtQ2DEatsbsoSOHPT78GGjzwDASukcUDtaVi40BSaIvKG3W2BL0frK
 0UvwmC7w4DkfBe0rlgZBsXMxgecbY47suPidagPFwn7XRL9DbD6FUc4Jp3F8olQs0/0z
 ru7u8DcfUpo+cPHLpCmhJ8rHE2y6nM/11d5Q/0/fRkbOtD/zyRp4u+Mj7iJWlL5ccMXG
 gE2Q/tMz/L68uZWsRpnLfqhKqbGhW9b0PI/5GrRmH3//fANr6M9tN/FPweTIAhkDldrk
 zfWggwzEXH7if//IwqscTuS3R0CK8ErAOG7HH9SpOEk70JbGaIDI7iz65/RzB93KtQU8 3Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vxwhfgaxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNRk6t069158
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vxwhuvfjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:19 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TNVIj9011917
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:31:18 -0700
Subject: [PATCH 4/5] xfs: drop the _safe behavior from the xbitmap foreach
 macro
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:31:17 -0700
Message-ID: <157239187744.1267044.8462804098576192461.stgit@magnolia>
In-Reply-To: <157239185264.1267044.16039786238721573306.stgit@magnolia>
References: <157239185264.1267044.16039786238721573306.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

It's not safe to edit bitmap intervals while we're iterating them with
for_each_xbitmap_extent.  None of the existing callers actually need
that ability anyway, so drop the safe variable.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bitmap.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index e198983db610..7a7554fb2793 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -12,8 +12,9 @@
 #include "xfs_btree.h"
 #include "scrub/bitmap.h"
 
-#define for_each_xbitmap_extent(bex, n, bitmap) \
-	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list)
+/* Iterate each interval of a bitmap.  Do not change the bitmap. */
+#define for_each_xbitmap_extent(bex, bitmap) \
+	list_for_each_entry((bex), &(bitmap)->list, list)
 
 /*
  * Set a range of this bitmap.  Caller must ensure the range is not set.
@@ -45,10 +46,9 @@ void
 xbitmap_destroy(
 	struct xbitmap		*bitmap)
 {
-	struct xbitmap_range	*bmr;
-	struct xbitmap_range	*n;
+	struct xbitmap_range	*bmr, *n;
 
-	for_each_xbitmap_extent(bmr, n, bitmap) {
+	list_for_each_entry_safe(bmr, n, &bitmap->list, list) {
 		list_del(&bmr->list);
 		kmem_free(bmr);
 	}
@@ -307,10 +307,9 @@ xbitmap_hweight(
 	struct xbitmap		*bitmap)
 {
 	struct xbitmap_range	*bmr;
-	struct xbitmap_range	*n;
 	uint64_t		ret = 0;
 
-	for_each_xbitmap_extent(bmr, n, bitmap)
+	for_each_xbitmap_extent(bmr, bitmap)
 		ret += bmr->len;
 
 	return ret;
@@ -323,10 +322,10 @@ xbitmap_walk(
 	xbitmap_walk_fn	fn,
 	void			*priv)
 {
-	struct xbitmap_range	*bex, *n;
+	struct xbitmap_range	*bex;
 	int			error;
 
-	for_each_xbitmap_extent(bex, n, bitmap) {
+	for_each_xbitmap_extent(bex, bitmap) {
 		error = fn(bex->start, bex->len, priv);
 		if (error)
 			break;

