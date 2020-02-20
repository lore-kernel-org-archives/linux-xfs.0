Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9738DC5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DA1E21D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SnEsgBfA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgBTBm7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:42:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48784 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgBTBm6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:42:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1cDje039770;
        Thu, 20 Feb 2020 01:42:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3KLbsYP5GZrl6ukWotNTHuBs1Kr6fK9/fwwGm/mknjM=;
 b=SnEsgBfAEa32j/a/m+UiV/G4g4jPk6AveQD2BkbJfK9IV0sFPZb8InCkES3yqwahTlv3
 W+86g7aA/Sgj8+JU7PBqJ5Nrce4GmXMus7Tf1OJEjkzPDHma0CbQKjgCO0K3ps6eMRhp
 Wz/8PRjTQxQRbnLiLN03199ddanPr7IN60sKfGHBA1MQDVR2bCl/Q2kUI2VaBISXr1R+
 O7sSH2fLk6wGDRwDNd1Eos4hLgU3n+phQYh93iTm3q+N1a1fimkbhKg9oAwAlztiUDce
 qbzuLSnBVhNWRhjsi6ImVgJTlSVgz6T4x/KIcLEonpZARwwZ/qI/oBkd+xrZnDkItPy8 pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y8ud16saf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1g8jW188837;
        Thu, 20 Feb 2020 01:42:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2y8ud971fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:55 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1gtCM002005;
        Thu, 20 Feb 2020 01:42:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:42:55 -0800
Subject: [PATCH 03/18] libxfs: remove LIBXFS_EXIT_ON_FAILURE
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:42:52 -0800
Message-ID: <158216297243.602314.7156693497979033081.stgit@magnolia>
In-Reply-To: <158216295405.602314.2094526611933874427.stgit@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=934
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=991 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that all the implicit users of this flag are gone, remove its
definition.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h   |    1 -
 libxfs/libxfs_io.h |    2 +-
 libxfs/rdwr.c      |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index aaac00f6..14113e56 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -126,7 +126,6 @@ typedef struct libxfs_xinit {
 	int		bcache_flags;	/* cache init flags */
 } libxfs_init_t;
 
-#define LIBXFS_EXIT_ON_FAILURE	0x0001	/* exit the program if a call fails */
 #define LIBXFS_ISREADONLY	0x0002	/* disallow all mounted filesystems */
 #define LIBXFS_ISINACTIVE	0x0004	/* allow mounted only if mounted ro */
 #define LIBXFS_DANGEROUSLY	0x0008	/* repairing a device mounted ro    */
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index bb6b689e..560cf0fd 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -86,7 +86,7 @@ bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
 bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
 
 /* b_flags bits */
-#define LIBXFS_B_EXIT		0x0001	/* ==LIBXFS_EXIT_ON_FAILURE */
+#define LIBXFS_B_EXIT		0x0001	/* exit if write fails */
 #define LIBXFS_B_DIRTY		0x0002	/* buffer has been modified */
 #define LIBXFS_B_STALE		0x0004	/* buffer marked as invalid */
 #define LIBXFS_B_UPTODATE	0x0008	/* buffer is sync'd to disk */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index f56303e2..6a75fb12 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -19,7 +19,7 @@
 #include "xfs_trans.h"
 #include "libfrog/platform.h"
 
-#include "libxfs.h"		/* for LIBXFS_EXIT_ON_FAILURE */
+#include "libxfs.h"
 
 /*
  * Important design/architecture note:

