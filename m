Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07294C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA656206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:02:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Oq3WOQQu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgAABCL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:02:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49134 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbgAABCK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:02:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010x7iH103974
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=IeXIB4hfpCehcGatiKkGooz2WKRyIKeWNw4gyfU0D6Q=;
 b=Oq3WOQQuqt+rE8ZfcQYviPrO9r4BUOfE17PwqJNWJ/VCZVS3adHV2BIFZJVnGIDK27fU
 dqR4aiWLQyeL+jlRi/dLOlU/ITKI9YVYTScBkBoH/RajBMP1nmVRpe0ZtjjB/nF4Mp2x
 pEDUX2ia8XZOK2cE/HQJXuaLClSr0py2l9VVIICh/w/CFgMEBzd2S37MrTDoEaMwR4sd
 rgHbeJRWg68etrjTeifkjT2uorY3mfpjqQrXEABS6yvx0NeolSSjPVsxAbo1Kj0GKC0s
 XPSjJZLpfh6LchfgFWBFhOzJoVLyQYP4S5hOK1xuhAxh+4y/mBTdw+EhWiqCqmbe1z+D 5g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xftk25e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:02:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010wgUc172117
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:02:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2x8bsrftsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:02:08 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 001127I2023586
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:02:07 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:02:07 -0800
Subject: [PATCH 4/5] xfs: drop the _safe behavior from the xbitmap foreach
 macro
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:02:05 -0800
Message-ID: <157784052567.1357533.8141343844304083466.stgit@magnolia>
In-Reply-To: <157784050067.1357533.242585262978035395.stgit@magnolia>
References: <157784050067.1357533.242585262978035395.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
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

