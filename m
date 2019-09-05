Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B86C0030B
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A03452082C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ohzNOfNe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389871AbfIEWTn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59682 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389859AbfIEWTk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ9b2049766
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=G17WWMgreYDdXTNddUrD02l9SQyuQ+Oqa+VSNklXFTI=;
 b=ohzNOfNefaAUZesfyqB/RJCcj534OFRogDcOmU8MMN9hn4Cezf70MMsIWBuUxlHDmpHx
 R+mzEs0Osme0iSBHFlWyWTP8upWvGR2OF/yiD0tWE/Fweafyzv38UfO/HDepYd7ijVMa
 uKT4GokFHUiYhDNz0sap97OvYhkc519tU2fiNUwh06dbulON78XaMU8gdD67KUXmC21J
 ZRPySf2BJO/axxV6v8eaDbJolh8lSpDkSq1lT4YPYs+CfoEYvCHIIlqT34GEVznWKHPo
 1w6rmlhmfh6h8PZeQQzYYhRsflHtOOXiUKiF4X5SdpgHB8aicjWDgDf6ksQlv57bYxYq Kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uuarc822x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIehG123415
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2uthq27vbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:38 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MJ5UE001711
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:05 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:19:05 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 19/21] xfs_io: Add delayed attributes error tag
Date:   Thu,  5 Sep 2019 15:18:53 -0700
Message-Id: <20190905221855.17555-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221855.17555-1-allison.henderson@oracle.com>
References: <20190905221855.17555-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test
delayed attribute recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_errortag.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index cabfc3e..05bd4db 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -54,6 +54,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_FORCE_SCRUB_REPAIR,	"force_repair" },
 		{ XFS_ERRTAG_FORCE_SUMMARY_RECALC,	"bad_summary" },
 		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
+		{ XFS_ERRTAG_DELAYED_ATTR,		"delayed_attr" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 79e6c4f..85d5850 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -55,7 +55,8 @@
 #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
-#define XFS_ERRTAG_MAX					35
+#define XFS_ERRTAG_DELAYED_ATTR				35
+#define XFS_ERRTAG_MAX					36
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -95,5 +96,6 @@
 #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
+#define XFS_RANDOM_DELAYED_ATTR				1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.7.4

