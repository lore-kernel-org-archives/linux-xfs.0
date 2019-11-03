Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF80CA9EB0
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDA622190F
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WdoqeyXQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfKCWY2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 17:24:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39412 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfKCWY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:24:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOND7086445
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=EHObrz54/e6bgOd7Kx7phjbPJ1RCHAsujaxROxmfdyY=;
 b=WdoqeyXQGqf+USU+NzJCU/WtEmB+i5sxdi0B21r0QAcT4mTFPgzZH/gJ2kU4yKnBWsBj
 e/B6IocT84QlVwhG8j7pZnIwTJTKI4ppIpqtpOUVgyo9O75d0ge/murkhNPAXnzVhybd
 LPFH+Pta/LqRERLW567SF9Ppa/fRBYPAmmlRvCdTJPqz7g1NnVW2hKheL2Wvt0Qb+aCa
 0Ak4z2626i/InwjdwMtyE8Jr6ZVJb4nF7uusuWxdtrdfVTV6fvRBPpQS7qTPccCQ6jNu
 Ken3xoncBFVruKSijd1rmf0uSoOrhyKkxYn9enp6a2SrLGfrCYWy2OnZjsnpLQd3Qt8Z 7w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w117tm5yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MNG90072633
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w1k8tmspm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:26 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA3MOPnw017874
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 14:24:25 -0800
Subject: [PATCH 3/6] xfs: make the assertion message functions take a mount
 parameter
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:24:23 -0800
Message-ID: <157281986300.4151907.2698280321479729910.stgit@magnolia>
In-Reply-To: <157281984457.4151907.11281776450827989936.stgit@magnolia>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
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

Make the assfail and asswarn functions take a struct xfs_mount so that
we can start tying debugging and corruption messages to a particular
mount.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_linux.h   |    6 +++---
 fs/xfs/xfs_message.c |    8 ++++----
 fs/xfs/xfs_message.h |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index ca15105681ca..2271db4e8d66 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -223,18 +223,18 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 		char *data, unsigned int op);
 
 #define ASSERT_ALWAYS(expr)	\
-	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
+	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
 
 #ifdef DEBUG
 #define ASSERT(expr)	\
-	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
+	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
 
 #else	/* !DEBUG */
 
 #ifdef XFS_WARN
 
 #define ASSERT(expr)	\
-	(likely(expr) ? (void)0 : asswarn(#expr, __FILE__, __LINE__))
+	(likely(expr) ? (void)0 : asswarn(NULL, #expr, __FILE__, __LINE__))
 
 #else	/* !DEBUG && !XFS_WARN */
 
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index c57e8ad39712..333bc2e14f3f 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -86,17 +86,17 @@ xfs_alert_tag(
 }
 
 void
-asswarn(char *expr, char *file, int line)
+asswarn(struct xfs_mount *mp, char *expr, char *file, int line)
 {
-	xfs_warn(NULL, "Assertion failed: %s, file: %s, line: %d",
+	xfs_warn(mp, "Assertion failed: %s, file: %s, line: %d",
 		expr, file, line);
 	WARN_ON(1);
 }
 
 void
-assfail(char *expr, char *file, int line)
+assfail(struct xfs_mount *mp, char *expr, char *file, int line)
 {
-	xfs_emerg(NULL, "Assertion failed: %s, file: %s, line: %d",
+	xfs_emerg(mp, "Assertion failed: %s, file: %s, line: %d",
 		expr, file, line);
 	if (xfs_globals.bug_on_assert)
 		BUG();
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 7f040b04b739..28bd6c0777ab 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -57,8 +57,8 @@ do {									\
 #define xfs_debug_ratelimited(dev, fmt, ...)				\
 	xfs_printk_ratelimited(xfs_debug, dev, fmt, ##__VA_ARGS__)
 
-extern void assfail(char *expr, char *f, int l);
-extern void asswarn(char *expr, char *f, int l);
+extern void assfail(struct xfs_mount *mp, char *expr, char *f, int l);
+extern void asswarn(struct xfs_mount *mp, char *expr, char *f, int l);
 
 extern void xfs_hex_dump(const void *p, int length);
 

