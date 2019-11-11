Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D9AC17442
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 340FE206DF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:18:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HO6R+fYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfKKBSz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 20:18:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59410 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfKKBSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 20:18:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1IiEm103226;
        Mon, 11 Nov 2019 01:18:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=fBujiqu+jwuO9yexsQFo3y7VVEXDIVXsWhYM4m4kdQM=;
 b=HO6R+fYNPDfjTOQIk05B0lqeAIw1hpYOxyp+yZExasecpg+8gCNmZHXJfybjU5h2OyBo
 3tlA5B2OL2R64PWaekZqP1jYkEFW2SDzDkirXcmkYPj0367usxWrWEB1ywnY/ZDvdRUC
 h5rhqbHSUbbWgEghEWIzWH/Lxkc3GiTm3DwZaCwZD+pabZYJvzO39D9aPdB2votB99Ld
 L0kLbjCPUBrTfeABLKdd5GRxbUH0cgPbhlqxZ8RV+nR9U0HN6IHWiC3UxJSPDNf+pU6M
 zSBlMdP/DeQjCcAN/dRAxFiGNAaqpuMK43dqafz0IRNQwFqgUVuvXqZLmoiqHUwnpzV6 MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w5ndpv4kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 01:18:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1IcxO111929;
        Mon, 11 Nov 2019 01:18:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w67kjbvb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 01:18:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAB1HxCf017447;
        Mon, 11 Nov 2019 01:18:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 01:17:59 +0000
Subject: [PATCH 1/3] xfs: add a if_xfs_meta_bad macro for testing and
 logging bad metadata
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.org
Date:   Sun, 10 Nov 2019 17:17:58 -0800
Message-ID: <157343507829.1945685.13191379852906635565.stgit@magnolia>
In-Reply-To: <157343507145.1945685.2940312466469213044.stgit@magnolia>
References: <157343507145.1945685.2940312466469213044.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new macro, if_xfs_meta_bad, which we will use to integrate some
corruption reporting when the corruption test expression is true.  This
will be used in the next patch to remove the ugly XFS_WANT_CORRUPT*
macros.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_linux.h |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 2271db4e8d66..d0fb1e612c42 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -229,6 +229,10 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
 
+#define xfs_meta_bad(mp, expr)	\
+	(unlikely(expr) ? assfail((mp), #expr, __FILE__, __LINE__), \
+			  true : false)
+
 #else	/* !DEBUG */
 
 #ifdef XFS_WARN
@@ -236,13 +240,23 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : asswarn(NULL, #expr, __FILE__, __LINE__))
 
+#define xfs_meta_bad(mp, expr)	\
+	(unlikely(expr) ? asswarn((mp), #expr, __FILE__, __LINE__), \
+			  true : false)
+
 #else	/* !DEBUG && !XFS_WARN */
 
-#define ASSERT(expr)	((void)0)
+#define ASSERT(expr)		((void)0)
+
+#define xfs_meta_bad(mp, expr)	\
+	(unlikely(expr) ? XFS_ERROR_REPORT(#expr, XFS_ERRLEVEL_LOW, (mp)), \
+			  true : false)
 
 #endif /* XFS_WARN */
 #endif /* DEBUG */
 
+#define if_xfs_meta_bad(mp, expr)	if (xfs_meta_bad((mp), (expr)))
+
 #define STATIC static noinline
 
 #ifdef CONFIG_XFS_RT

