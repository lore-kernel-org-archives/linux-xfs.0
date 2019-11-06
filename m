Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96A6C5DF62
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 04:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77041214D8
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 04:58:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jbbczOQa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730528AbfKFE6O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 23:58:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50208 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbfKFE6O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 23:58:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64sG9U101075;
        Wed, 6 Nov 2019 04:58:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=77bJ7LxGfIhgZAIEZ8e7Xh7x+d/nP5byuFhEhf15xFA=;
 b=jbbczOQa0VMJPepCDu7k8Sb9agsjVlUYL+GYPhktSj25gwSQtp4CWZy06Ch62PUxG+9e
 CDNqFFk16auGQQAu9AdgkIMFlLtPPwQ7U+PZwltmgbwMEEUPxmNeN8+DZqk2FNUB5t4b
 cR5fsNbHb4wNsyW/c7492ZpQEEDwVGGwvJ4pX5/8h8YDIXvJ8aJwC6JWjsCf8iOWQ6cZ
 DnOYlIO3a9o6ncOHM4pYeTOLRuzKCR8ZqTx35p0Tjw848QxK9r5+UzxxftwHwL6A5ukV
 O5PCasNHXIz7inhBQbdDKtVoZp6t+VtQ//X1Z5SqZzPMCBUyjHyTQPboQIAklqODyXt2 /A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w11rq35e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:58:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64s2mL052420;
        Wed, 6 Nov 2019 04:58:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w35pq7ut8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:58:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA64w5E3014928;
        Wed, 6 Nov 2019 04:58:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 20:58:05 -0800
Date:   Tue, 5 Nov 2019 20:58:04 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     hch@infradead.org
Subject: [PATCH v2 4/6] xfs: add a XFS_IS_CORRUPT macro
Message-ID: <20191106045804.GE4153244@magnolia>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
 <157281987010.4151907.6435110079992395504.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157281987010.4151907.6435110079992395504.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060051
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060051
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
v2: change name, start regenerating the rest of the patches...
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
