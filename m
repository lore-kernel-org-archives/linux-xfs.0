Return-Path: <SRS0=Bs8E=ZJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E27C432C0
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Nov 2019 19:12:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA6262075C
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Nov 2019 19:12:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nGUXSGgM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfKQTMf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Nov 2019 14:12:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51160 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfKQTMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Nov 2019 14:12:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAHJ8mQt142074;
        Sun, 17 Nov 2019 19:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=6MZuuM327RmkgMQ8gUrc5appBbdcWVXZNw1CJt4rrQY=;
 b=nGUXSGgMDf0dJZHQdvx8ACZYhcAs1FHi6QuTwdmnjSFc5631YhCd0TkdpcZX1T3koWpt
 gPKMVdcku395fj3xsNXOdkZ5ZHFEWDb/BGWi/vMXzm3wlFFsp1mW4GNQlEzrjoYUuSrC
 upp68jbpOwVcqRqzmwz30yED4w8i3a4GU43Q2iSCltARPDoqPSvhRQWtTqMAQUXO2pSO
 8PuitsVSD8yMHp/QfNPxKUGliUkPffwd1LvbJeI6ScydJFn9UTcJKi6Ejb6BxhvPzJjd
 y5ftXcNgMm19E2ONh/X3zSZQh+vNe29RPGpPpae/yszaLHeIUxcgd6IwO0IO5j5XIsGH BQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wa8htccj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Nov 2019 19:12:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAHJ8WGS102913;
        Sun, 17 Nov 2019 19:12:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wau93aj75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Nov 2019 19:12:19 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAHJCIPY006307;
        Sun, 17 Nov 2019 19:12:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 17 Nov 2019 11:12:18 -0800
Date:   Sun, 17 Nov 2019 11:12:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: report corruption only as a regular error
Message-ID: <20191117191217.GU6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9444 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911170182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9444 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911170182
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Redefine XFS_IS_CORRUPT so that it reports corruptions only via
xfs_corruption_report.  Since these are on-disk contents (and not checks
of internal state), we don't ever want to panic the kernel.  This also
amends the corruption report to recommend unmounting and running
xfs_repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_error.c |    2 +-
 fs/xfs/xfs_linux.h |   17 ++++++-----------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 4c0883380d7c..a836cf543ea1 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -335,7 +335,7 @@ xfs_corruption_error(
 	int			linenum,
 	xfs_failaddr_t		failaddr)
 {
-	if (level <= xfs_error_level)
+	if (buf && level <= xfs_error_level)
 		xfs_hex_dump(buf, bufsize);
 	xfs_error_report(tag, level, mp, filename, linenum, failaddr);
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 64bbbcc77851..8738bb03f253 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -229,10 +229,6 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
 
-#define XFS_IS_CORRUPT(mp, expr)	\
-	(unlikely(expr) ? assfail((mp), #expr, __FILE__, __LINE__), \
-			  true : false)
-
 #else	/* !DEBUG */
 
 #ifdef XFS_WARN
@@ -240,20 +236,19 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : asswarn(NULL, #expr, __FILE__, __LINE__))
 
-#define XFS_IS_CORRUPT(mp, expr)	\
-	(unlikely(expr) ? asswarn((mp), #expr, __FILE__, __LINE__), \
-			  true : false)
-
 #else	/* !DEBUG && !XFS_WARN */
 
 #define ASSERT(expr)		((void)0)
-#define XFS_IS_CORRUPT(mp, expr)	\
-	(unlikely(expr) ? XFS_ERROR_REPORT(#expr, XFS_ERRLEVEL_LOW, (mp)), \
-			  true : false)
 
 #endif /* XFS_WARN */
 #endif /* DEBUG */
 
+#define XFS_IS_CORRUPT(mp, expr)	\
+	(unlikely(expr) ? xfs_corruption_error(#expr, XFS_ERRLEVEL_LOW, (mp), \
+					       NULL, 0, __FILE__, __LINE__, \
+					       __this_address), \
+			  true : false)
+
 #define STATIC static noinline
 
 #ifdef CONFIG_XFS_RT
