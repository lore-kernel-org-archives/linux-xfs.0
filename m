Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A385EFA372C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 682002077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:02:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XLWf9H4O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733053AbfKGDCl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:02:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56968 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGDCl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:02:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72x3XF039028
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=7Bm+ZrwttBlUQJuAWe8NjpIDdwfIy+u5byxSlw0N/l4=;
 b=XLWf9H4OuOpTzfudIUI67SlMVkyxYDm95p85J5vG/cY17lKeH2ImGVb6TFFqpo6iNFxh
 sMSkkgQwanPH3XYQHpMDUT8gvoHJiAr8npOhGnflH/adYXpSicPc89G1N1AFT5/1snU4
 ecM+Xc4NnAIV6GB2Z687DZBNEme90/MGABJDZWSRSKjyDlGkJrTjX7deVhTz99SQB+lv
 BkhIgc1OAuIvwxuPgA5ckXc/iFbqjSKZf02PhW1oymvJ/HpaPd/JFuMH/eA5+O29VOTD
 Mla11Xiq9WL3sfQAmYJFRrc2OFbY2ybL772csktWn4HKUcenaEN0JkHF2iNzFNYyCN2t gQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w0u0h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:02:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72wiwP151838
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w41w8kq0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:02:39 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA732bls003295
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:02:37 -0800
Subject: [PATCH 2/6] xfs: fix missing header includes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 Nov 2019 19:02:31 -0800
Message-ID: <157309575167.46520.15760576794168756429.stgit@magnolia>
In-Reply-To: <157309573874.46520.18107298984141751739.stgit@magnolia>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
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

Some of the xfs source files are missing header includes, so add them
back.  Sparse complains about non-static functions that don't have a
forward declaration anywhere.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c     |    2 ++
 fs/xfs/libxfs/xfs_attr_remote.c |    1 +
 fs/xfs/libxfs/xfs_bit.c         |    1 +
 fs/xfs/libxfs/xfs_sb.c          |    1 +
 fs/xfs/scrub/health.c           |    1 +
 fs/xfs/scrub/scrub.c            |    1 +
 fs/xfs/xfs_acl.c                |    3 ++-
 fs/xfs/xfs_discard.c            |    1 +
 fs/xfs/xfs_ioctl.c              |    1 +
 fs/xfs/xfs_symlink.c            |    1 +
 fs/xfs/xfs_xattr.c              |    1 +
 11 files changed, 13 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 87a9747f1d36..fdfe6dc0d307 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -19,6 +19,8 @@
 #include "xfs_btree.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_ialloc_btree.h"
+#include "xfs_sb.h"
+#include "xfs_ag_resv.h"
 
 /*
  * Per-AG Block Reservations
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 3e39b7d40f25..a6ef5df42669 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -19,6 +19,7 @@
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
 #include "xfs_attr.h"
+#include "xfs_attr_remote.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
 
diff --git a/fs/xfs/libxfs/xfs_bit.c b/fs/xfs/libxfs/xfs_bit.c
index 7071ff98fdbc..40ce5f3094d1 100644
--- a/fs/xfs/libxfs/xfs_bit.c
+++ b/fs/xfs/libxfs/xfs_bit.c
@@ -5,6 +5,7 @@
  */
 #include "xfs.h"
 #include "xfs_log_format.h"
+#include "xfs_bit.h"
 
 /*
  * XFS bit manipulation routines, used in non-realtime code.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ac6cdca63e15..0ac69751fe85 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -10,6 +10,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
+#include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index b2f602811e9d..83d27cdf579b 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -11,6 +11,7 @@
 #include "xfs_sb.h"
 #include "xfs_health.h"
 #include "scrub/scrub.h"
+#include "scrub/health.h"
 
 /*
  * Scrub and In-Core Filesystem Health Assessments
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 15c8c5f3f688..f1775bb19313 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -16,6 +16,7 @@
 #include "xfs_qm.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
+#include "xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 3f2292c7835c..91693fce34a8 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -13,8 +13,9 @@
 #include "xfs_attr.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
-#include <linux/posix_acl_xattr.h>
+#include "xfs_acl.h"
 
+#include <linux/posix_acl_xattr.h>
 
 /*
  * Locking scheme:
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 8ec7aab89044..50966a9912cd 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -13,6 +13,7 @@
 #include "xfs_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_discard.h"
 #include "xfs_error.h"
 #include "xfs_extent_busy.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 800f07044636..364961c23cd0 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -34,6 +34,7 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "xfs_reflink.h"
+#include "xfs_ioctl.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index ed66fd2de327..a25502bc2071 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -17,6 +17,7 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_quota.h"
+#include "xfs_symlink.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index cb895b1df5e4..383f0203d103 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -11,6 +11,7 @@
 #include "xfs_da_format.h"
 #include "xfs_inode.h"
 #include "xfs_attr.h"
+#include "xfs_acl.h"
 
 #include <linux/posix_acl_xattr.h>
 #include <linux/xattr.h>

