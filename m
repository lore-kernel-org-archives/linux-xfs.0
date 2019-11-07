Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AA8FA372C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 996582077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:02:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lRJmfQgq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732713AbfKGDCF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:02:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56250 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGDCF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:02:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72x4HQ039055;
        Thu, 7 Nov 2019 03:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=v4ti762spoPVL5QOUV9JdIOFaoVYSoZiPeopgsv7NHU=;
 b=lRJmfQgqbW12qRQney7t+STvn4nzR7cxtylrtT1DGYZZDOg59ymqf/ouZEDGC6S16hxP
 Y/LTe7wRC/1QyQKsM4tXgzZtDqJ37G4jQHIro3FNnO6XYbbS6FEEQAceTUZ53u5rgRiA
 lkmmbQ8RD/WFvZPT2/S25Bl1rQ1ao7NDaHEgt68sprhOGtqeMsw0aSpl4CZ90anhiALO
 gE/szcu6aZM5OzAUGJ9ceV1ER402q1gSIxKv2d50C9d6La9/dDtqjQIHhTZ+6jUpqy3S
 M6pywtkdEkIxvV4hWt7qAG/k4oC8YCeAq8upcfHhcMOtyA9MOkSidVItAIa50UBpY8Qt BA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w41w0u0ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 03:01:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72wK51052223;
        Thu, 7 Nov 2019 03:01:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w41wfshg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 03:01:59 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA731uAR002838;
        Thu, 7 Nov 2019 03:01:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:01:55 -0800
Subject: [PATCH 1/4] xfs: add a XFS_IS_CORRUPT macro
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 06 Nov 2019 19:01:54 -0800
Message-ID: <157309571493.45542.17191993682067205278.stgit@magnolia>
In-Reply-To: <157309570855.45542.14663613458519550414.stgit@magnolia>
References: <157309570855.45542.14663613458519550414.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new macro, XFS_IS_CORRUPT, which we will use to integrate some
corruption reporting when the corruption test expression is true.  This
will be used in the next patch to remove the ugly XFS_WANT_CORRUPT*
macros.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_linux.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 2271db4e8d66..64bbbcc77851 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -229,6 +229,10 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
 
+#define XFS_IS_CORRUPT(mp, expr)	\
+	(unlikely(expr) ? assfail((mp), #expr, __FILE__, __LINE__), \
+			  true : false)
+
 #else	/* !DEBUG */
 
 #ifdef XFS_WARN
@@ -236,9 +240,16 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : asswarn(NULL, #expr, __FILE__, __LINE__))
 
+#define XFS_IS_CORRUPT(mp, expr)	\
+	(unlikely(expr) ? asswarn((mp), #expr, __FILE__, __LINE__), \
+			  true : false)
+
 #else	/* !DEBUG && !XFS_WARN */
 
-#define ASSERT(expr)	((void)0)
+#define ASSERT(expr)		((void)0)
+#define XFS_IS_CORRUPT(mp, expr)	\
+	(unlikely(expr) ? XFS_ERROR_REPORT(#expr, XFS_ERRLEVEL_LOW, (mp)), \
+			  true : false)
 
 #endif /* XFS_WARN */
 #endif /* DEBUG */

