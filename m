Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F9ECA9EB0
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 189AC2190F
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jp1WrYYf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfKCWYe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 17:24:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43986 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfKCWYe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:24:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOFLY061247
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+51urQGa7OGrC+gua2ZKIzWk3a0hOdqL8JP+WiR+zzo=;
 b=jp1WrYYf+o4bAS3uf60KUzBT7PTEGxlMlOEkTCQgqYiGVLgisb1m/h3IsIw/pBm5wJMR
 VOv0QhY9K5B9RyaF8oX3sqL341wfJdah1yQgaWkdHE5YnNAgoQ7YoGY/37+5hToTzdtx
 8zp3I2byqsRJJZ8W9wWJjvZwL3OvOPeFZCol+UU9i4bYalFUSRb1NRQC8Sg14BvF5s5v
 wZUutMMGnlbKIHmqfBo2iY57hd2UWopjy5CFFmAESo61/iyBo/c/iO9EWwGuraCbiiWM
 7PWDCz4FCuc0KuUmn1I5Q03Yf1jl3e3Ud8KgP5TP7ug+U9ayfDzHJG9qroeUSzweKH0O Kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w12eqv04y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOOgo026519
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w1kxk9rjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:32 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA3MOVJ7032076
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 14:24:31 -0800
Subject: [PATCH 4/6] xfs: add a XFS_CORRUPT_ON macro
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:24:30 -0800
Message-ID: <157281987010.4151907.6435110079992395504.stgit@magnolia>
In-Reply-To: <157281984457.4151907.11281776450827989936.stgit@magnolia>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=984
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030234
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new macro, XFS_CORRUPT_ON, which we will use to integrate some
corruption reporting when the corruption test expression is true.  This
will be used in the next patch to remove the ugly XFS_WANT_CORRUPT*
macros.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_linux.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 2271db4e8d66..9265ba9fd028 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -229,6 +229,10 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
 
+#define XFS_CORRUPT_ON(mp, expr)	\
+	(unlikely(expr) ? assfail((mp), #expr, __FILE__, __LINE__), \
+			  true : false)
+
 #else	/* !DEBUG */
 
 #ifdef XFS_WARN
@@ -236,9 +240,16 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : asswarn(NULL, #expr, __FILE__, __LINE__))
 
+#define XFS_CORRUPT_ON(mp, expr)	\
+	(unlikely(expr) ? asswarn((mp), #expr, __FILE__, __LINE__), \
+			  true : false)
+
 #else	/* !DEBUG && !XFS_WARN */
 
-#define ASSERT(expr)	((void)0)
+#define ASSERT(expr)		((void)0)
+#define XFS_CORRUPT_ON(mp, expr)	\
+	(unlikely(expr) ? XFS_ERROR_REPORT(#expr, XFS_ERRLEVEL_LOW, (mp)), \
+			  true : false)
 
 #endif /* XFS_WARN */
 #endif /* DEBUG */

