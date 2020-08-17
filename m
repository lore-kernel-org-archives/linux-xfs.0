Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0773FC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D59E12063A
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:59:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OjZYP7w2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgHQW7O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:59:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52056 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgHQW7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:59:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvu3o052952;
        Mon, 17 Aug 2020 22:59:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5/vhehjIWMNnKaMyo8ThWFz415yix7tfO2/Olnh/8k8=;
 b=OjZYP7w2DVFR4b93R4P3fS6RVgDJ8vkGnDkRtqaEsULvE5eSUumgkwsJursOhYojltG+
 ILekVLt5jM7OjLk9sxEus2r24Zmih21+J78cT/9rEkt3OqupuE9kmKEmWvj0pz9hWkW2
 KRC56swdjtL1YatqoZ4D6w/Vmdn6969YApZMHtHMOlCyhM1cYudsL4OzyxAjtKpnFAah
 ynFujkn5gmDie+y4Mc3NgM3+erYqEGZRKTpTUc7fFdFJ91Oec1OhjvKres6kXdvfZR6P
 /ZHBHTWMsEE4Qqqw54b9foDzMk2DuOUE3lkEPDtcNAB8dJvuiNzlASToUHdDf1zEmmHg ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32x7nm9jqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:59:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwAXU084875;
        Mon, 17 Aug 2020 22:59:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32xsfr59as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:59:07 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HMx7VW025401;
        Mon, 17 Aug 2020 22:59:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:59:06 -0700
Subject: [PATCH 02/18] xfs: explicitly define inode timestamp range
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:59:06 -0700
Message-ID: <159770514598.3958786.15730645159608118691.stgit@magnolia>
In-Reply-To: <159770513155.3958786.16108819726679724438.stgit@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Formally define the inode timestamp ranges that existing filesystems
support, and switch the vfs timetamp ranges to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    4 ++++
 libxfs/xfs_format.h      |   19 +++++++++++++++++++
 2 files changed, 23 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 99bc5b936da7..4ee02473df0d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -14,6 +14,10 @@ struct timespec64 {
 	long		tv_nsec;		/* nanoseconds */
 };
 
+#define U32_MAX		((uint32_t)~0U)
+#define S32_MAX		((int32_t)(U32_MAX >> 1))
+#define S32_MIN		((int32_t)(-S32_MAX - 1))
+
 /*
  * This file defines all the kernel based functions we expose to userspace
  * via the libxfs_* namespace. This is kept in a separate header file so
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 88cbcb7950c3..f2a851e49ec3 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -849,11 +849,30 @@ struct xfs_agfl {
 	    ASSERT(xfs_daddr_to_agno(mp, d) == \
 		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
 
+/*
+ * XFS Timestamps
+ * ==============
+ *
+ * Inode timestamps consist of signed 32-bit counters for seconds and
+ * nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC 1970.
+ */
 typedef struct xfs_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
 	__be32		t_nsec;		/* timestamp nanoseconds */
 } xfs_timestamp_t;
 
+/*
+ * Smallest possible timestamp with traditional timestamps, which is
+ * Dec 13 20:45:52 UTC 1901.
+ */
+#define XFS_INO_TIME_MIN	((int64_t)S32_MIN)
+
+/*
+ * Largest possible timestamp with traditional timestamps, which is
+ * Jan 19 03:14:07 UTC 2038.
+ */
+#define XFS_INO_TIME_MAX	((int64_t)S32_MAX)
+
 /*
  * On-disk inode structure.
  *

