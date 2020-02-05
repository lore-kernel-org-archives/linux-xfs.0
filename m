Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D58C35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CAC0214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:46:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AAKPz++8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgBEAq3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:46:29 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33782 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727627AbgBEAq3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:46:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150eRod103884;
        Wed, 5 Feb 2020 00:46:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=pZsTRJVzXjcAMsmwaAVS3YjEAyOBOdxUOT/qvTdcVAs=;
 b=AAKPz++8I79DyJLqTMiJrRqwmdv8qRcjRA8PMbTdVJ2EsL51ZPIwZow+kVFOkC3bfzv/
 FDip9p1zfbRMnBS87HWBIg4CPU5cdauu64oiPaFwRBR9D2OvhaJRyb4O/AcF5J8GBc0y
 mZ4uZHUR7/wbJEb1bfAnn8pY+4lGkj4e+2NB/58oizv0N2ig6QzG7vSt+BcRnsGjufEO
 ZqkMxRPWBmYivYZ4RC+0eYsMcSXyS2vdBHOf0RhK7j3aUcoJEXXkFyDGoSF7/OfpmLdI
 mY3ZXfdypEYIth6DHiQkS+qOoaS0OxBakwctB/uZLfKuFaXz47gtx3kRffUmkSynl9k8 bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xykbp00kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150cvLi165904;
        Wed, 5 Feb 2020 00:46:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xykbqgcds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:46:24 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0150kNBi010114;
        Wed, 5 Feb 2020 00:46:23 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:46:22 -0800
Subject: [PATCH 2/4] libfrog: remove libxfs.h dependencies in fsgeom.c and
 linux.c
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Date:   Tue, 04 Feb 2020 16:46:20 -0800
Message-ID: <158086358002.2079557.9233731246621270812.stgit@magnolia>
In-Reply-To: <158086356778.2079557.17601708483399404544.stgit@magnolia>
References: <158086356778.2079557.17601708483399404544.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

libfrog isn't supposed to depend on libxfs, so don't include the header
file in the libfrog source code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 libfrog/fsgeom.c |    4 +++-
 libfrog/linux.c  |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 19a4911f..bd93924e 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -2,7 +2,9 @@
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc. All Rights Reserved.
  */
-#include "libxfs.h"
+#include "platform_defs.h"
+#include "xfs.h"
+#include "bitops.h"
 #include "fsgeom.h"
 #include "util.h"
 
diff --git a/libfrog/linux.c b/libfrog/linux.c
index 79bd79eb..41a168b4 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -9,8 +9,8 @@
 #include <sys/ioctl.h>
 #include <sys/sysinfo.h>
 
-#include "libxfs_priv.h"
-#include "xfs_fs.h"
+#include "platform_defs.h"
+#include "xfs.h"
 #include "init.h"
 
 extern char *progname;

