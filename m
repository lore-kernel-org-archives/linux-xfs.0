Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7BDCA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1C7F2067D
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:09:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZNLHtvms"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbfKEBJj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 20:09:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35330 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbfKEBJj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 20:09:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA519bJp135454
        for <linux-xfs@vger.kernel.org>; Tue, 5 Nov 2019 01:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=sP124s2JvyaJM01GrU+SzmyawcMEZx+3zy5VdIdowmY=;
 b=ZNLHtvmss0RBfsYO/ZEAlzjH4Qt2HyX+dZSC5ig8Ow6hbrcMV97SyQ/gJEAhSVYYs4NY
 1O3NVHLZ/NZMBgt6+j5jdox2Wh7/tWucgsfTktQiCah8dirDrZI1nwSK23bOIBfqA7Wk
 htIzrbX93dmoketq0iJ2CMI7gr9Y5wGGz2oE4caOlSGMp+D4T9rRADSJIgNrA78YWolx
 mbH/QH494qIhSILqX+lus7nCpIkx8DCIIcVFSSrxyxIipmsujTjVS6jst4tx2WzJUFxL
 TLOV5uunZ5vtsHGXfDUr4MraN3Wdr1U0/OqSyEo4QJlnRn3gFkVdIogZ+JU6DfuNB4ma NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w11rptxx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 01:09:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA519UWj140326
        for <linux-xfs@vger.kernel.org>; Tue, 5 Nov 2019 01:09:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w2wcgayeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 01:09:37 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA519aBU002111
        for <linux-xfs@vger.kernel.org>; Tue, 5 Nov 2019 01:09:36 GMT
Received: from localhost (/10.159.233.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 17:09:35 -0800
Date:   Mon, 4 Nov 2019 17:09:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 3/6] xfs: make the assertion message functions take a
 mount parameter
Message-ID: <20191105010935.GW4153244@magnolia>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
 <157281986300.4151907.2698280321479729910.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157281986300.4151907.2698280321479729910.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050007
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
v2: fix indentation and drop externs
---
 fs/xfs/xfs_linux.h   |    6 +++---
 fs/xfs/xfs_message.c |   16 ++++++++++++----
 fs/xfs/xfs_message.h |    4 ++--
 3 files changed, 17 insertions(+), 9 deletions(-)

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
index 21451c62cd1a..e0f9d3b6abe9 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -86,17 +86,25 @@ xfs_alert_tag(
 }
 
 void
-asswarn(char *expr, char *file, int line)
+asswarn(
+	struct xfs_mount	*mp,
+	char			*expr,
+	char			*file,
+	int			line)
 {
-	xfs_warn(NULL, "Assertion failed: %s, file: %s, line: %d",
+	xfs_warn(mp, "Assertion failed: %s, file: %s, line: %d",
 		expr, file, line);
 	WARN_ON(1);
 }
 
 void
-assfail(char *expr, char *file, int line)
+assfail(
+	struct xfs_mount	*mp,
+	char			*expr,
+	char			*file,
+	int			line)
 {
-	xfs_emerg(NULL, "Assertion failed: %s, file: %s, line: %d",
+	xfs_emerg(mp, "Assertion failed: %s, file: %s, line: %d",
 		expr, file, line);
 	if (xfs_globals.bug_on_assert)
 		BUG();
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 7f040b04b739..0b05e10995a0 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -57,8 +57,8 @@ do {									\
 #define xfs_debug_ratelimited(dev, fmt, ...)				\
 	xfs_printk_ratelimited(xfs_debug, dev, fmt, ##__VA_ARGS__)
 
-extern void assfail(char *expr, char *f, int l);
-extern void asswarn(char *expr, char *f, int l);
+void assfail(struct xfs_mount *mp, char *expr, char *f, int l);
+void asswarn(struct xfs_mount *mp, char *expr, char *f, int l);
 
 extern void xfs_hex_dump(const void *p, int length);
 
