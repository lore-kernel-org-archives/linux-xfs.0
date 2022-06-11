Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50FAC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 09:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiFKJmW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Jun 2022 05:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiFKJmR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 05:42:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460BB1147A
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 02:42:15 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25B1hoNT021293
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=EjtZpq1EAMMepYAQThwYQIl5awvyr4bz3cUlT/x2sp4=;
 b=ZYRm2JDbKYF/Wq++UBz6kL/uwOrkhFUqOnNeXck+wgaXuWQIKsnRoOkd6N+I/tSPIbea
 ctJZlC2duaepzsI31K/jWmVuF5FvsjFNFtObtkUsn7MV/FgVXPJmm9W3VoSSrrUP/mEu
 a7T9fTB5ZVlebtHnqj2B4Uv8Z8Yq3IRoZ6rWOXtaWdF4SJNYEwUY9EEqFSKYrixXZu1Y
 vrIDqAXLfXoGni5OiKbErfk5X0OE16ehoMSlOoTQe4EkQ324cwHAwvviLjtIj8uuOCRi
 SxyGEnQvu3cq7LS4UwiulJtQ11tiPWZJZ6yJesSGhtW0Ho8rL5SoUG4A/et/FndXQJzn WQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhn08c73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25B9allJ001303
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gmhg0m9ta-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 09:42:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzSCCdXKkV4CuVrw+Zm3/YuowOsBnDxBYgLhJ8DCiq3UBQYyw9e3Wi9vT9WwsTqUqpsEc+rjlT2iI+MaJDFD6PxbzwKqrVcNOhvbJE7Bzw+xwEf7NCpUfFQi7QpDXbGIQFtEaciSxposLR6kGZ4zu8rZiZRgOQh3VVQ4a0YohHtxjLC6eEnOvWPEjsPEfAYziT0yT/mrn6ldnD+Pc9NiNy2vkjt8sf29tBNBCzk2ld0bwMAtepwIUzyGojcOYfgXFA0Y1OFBeNo9Gi2rFfScgIpYBed90SYUfClTrK2K30irbJgLUwQAh7RougjE8ZT9GHn9oXy7OZQ4N+vdHf0hRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjtZpq1EAMMepYAQThwYQIl5awvyr4bz3cUlT/x2sp4=;
 b=LSFobjNOjBbf+vV2VNCoyBXAaSe2685VJxuBMyihR4HF2fiOUw2KFZQHG8xROS7nWqlb+2c2AlFhOBGLsf7BVdf9gb3OgpqE0n4VTiruiDMK2K/ixZA6tQd3cVrV3kFrh+9B6i7gbEw80Z355b4YG8wfQ5HlnBvETzGFWzD1o/w8NFtGEepbovTqqy583+Rzl6IQ2oE2Y01ChUwTTIJdyspfm3oqi5MAqrixgWGn2et1uHP+b9im/PlmS+9olvnFJOZ9+XZNcbMhvw2JT0n0SD7C+LR1Po2o/+xDcGmbc4qU61A5FM2gXBWIMatAwOwCumZJziXXV4gXBpFKDBjw+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjtZpq1EAMMepYAQThwYQIl5awvyr4bz3cUlT/x2sp4=;
 b=Pi4OiCU85sArFFHznACfmeYg0FLSO59KUztZ9jPWeuoi72OksksGnEfPxj5ZKuieaU8H7rrtXKjwm4QX1jkvNF50yFhwbf3XN3HrEVOWK1bO75Utu6QSfhKC76884eswdeGIJLWy6TJf1siIuS182qgHbF3sKfNSJ/PeCXl4nD8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4606.namprd10.prod.outlook.com (2603:10b6:a03:2da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Sat, 11 Jun
 2022 09:42:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%7]) with mapi id 15.20.5332.013; Sat, 11 Jun 2022
 09:42:10 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 15/17] xfs: Add helper function xfs_attr_list_context_init
Date:   Sat, 11 Jun 2022 02:41:58 -0700
Message-Id: <20220611094200.129502-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220611094200.129502-1-allison.henderson@oracle.com>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f067db57-6497-495b-9de4-08da4b8ea7ff
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4606:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46067C4745097AD28E614B0F95A99@SJ0PR10MB4606.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 00vuUOtp6PxNal4WP4PXiD28D7LVWjTptIeApeIC+xwpkLn4kH2sJDDStLRVH+RZ0LSSi5u+NS9JUdv/86hJhAZ8LYIv5SMzZishjGk383Yoaq39S2pEltZFOb5zsnb41LD/2BK3WuMhA4whq1MmmuBTHC4t/VWkAlp6Dcntczzc6JImD+dXXlEq2vwkYdmsQbmfMiG2LgoWe1lHhk7Fn5XOhy0/I9Gk31Q2i+ns6w2Koy48+ho38ZWPmmOu5PO6BEBJOZu42pHxxkyKCXdau+WOMyX8hQGYXDzCoP360oTdrKIv4ZzrQMMS1hOI5sguGgELo+cNAtXYh56CQvwhmOpHu7BeqDw16rqWKA92Hr7qniGKpQDLdwYncFJB0F6AWKgz08J8g6ee2EdrdLt0yfRA1IHa2vzgRW73/p1x6Xmo2fRdEgeEVP6OBBLQkBIPnD00eZFnikfhQfu76ybOtah9H4Gnp4G1xOMYGqSoxoDsI7Uk4ilpKlDkH5qoEiSvsnODeHJYnS0kFSQY0k1whlvK8XzMAXNDaUCORJ3c1VHiKNAC3QVLPtaV/LGlCzdQCuaHr0JyBd7vpkUNc6VdL8k4VVjCfNaRd9Mux5e79ZOyGdar1bd+5/Sue3GOsxdU4Q5ZGHJTXStIJtaDSkcJuDCNU/twtyXJg2mnvZE7fWbcJbWcbY3JHFWrFHY4dFKZncKATjss9uy+b4R0jT9JUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6486002)(44832011)(86362001)(2906002)(186003)(83380400001)(36756003)(66946007)(66556008)(66476007)(8676002)(5660300002)(508600001)(8936002)(6916009)(316002)(2616005)(6666004)(6506007)(52116002)(6512007)(26005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fQ58Pj5lQxMJgDp89yTxDhqKyiT4cE1kM4sWZZ76V6gzi60++TEA8zAY0jMP?=
 =?us-ascii?Q?M0Ya9UwJ6D9/l5q1yVtRssFY+3rZNgJewpE4SURHLoZbDcBNy05itmRWw53D?=
 =?us-ascii?Q?iMQoB/EC+FbnJFKbplxONCdc4zT5/v0pok8O6xL7aWDzdcM4iYwawA0TrCYu?=
 =?us-ascii?Q?COYOnsbc7Sbrvq435d1wfwSN36IQTkUwSFrC2EDVgSEVOwU1kMd9aE3pTU+/?=
 =?us-ascii?Q?6lAlZkouC1mWtbuuVwnWo5fPIk9w8jff8o39/b+PYolMOfoqJgtArh2ci0+W?=
 =?us-ascii?Q?yrzUk1jqygG9bdEbi5hZZEABONs3b0j4nEUOT5exzXOC7z1RPThvgrUy+H8C?=
 =?us-ascii?Q?+mxFCxRlBShzlTJ+YzPLUviKsUNfJbjz1AC1UmEjqpSJuzePnli3CH8FG7iI?=
 =?us-ascii?Q?HFj9PFFcjHAE26nd7mHJU46JAVH9TtvnMroS/5mWruxEYZY9c/19wcqdtmfj?=
 =?us-ascii?Q?t60768fsHBh3sfo9fCYav1IEyWS21NTfo0j5djFxqsg4cAhbMTkVcAhluaZw?=
 =?us-ascii?Q?pPhv6HJ7takDPdqv/WYmZN8GauoybEz9fOXxaFN9k8IDfeR7ONn9GjG/L+AY?=
 =?us-ascii?Q?wjqpqAg8zw4ylc/gG6ecrZKKQO35ILaMJBneDDhl9W42r67rEKgBnsC90N8d?=
 =?us-ascii?Q?1I7uBdR4Et5dxObgZOqfBtR2qn7htVw/d70LHFDd5wcw9GW8/5MCf/1II18B?=
 =?us-ascii?Q?xCHBacD+CUulluNTCsfN1ohUqDlSxXN4Srkl4GOfKSUMrSy6PR3icbEzZXny?=
 =?us-ascii?Q?+pAP3TKACF3kdIabU7SIgWZAETInT7QNf/cB2uZ4CVd8f4fMc/hzGIFbv1Jx?=
 =?us-ascii?Q?dJp0RWdNOhY6VsrF2oK/AHva5X+oAWpazPubA4ipMDOmBDYnfq1LVwazbj/c?=
 =?us-ascii?Q?hiHE0EM+QeI3cQgx6Po2a3TRSR9MisxwPGuiAbA/VkO4CLdstakzPQkuIkA9?=
 =?us-ascii?Q?OkSRXl8PYZGb3PwixwOI9El/hP4nRdQf09CKGph/BMso9zfiTHl7ZG4ZZDkM?=
 =?us-ascii?Q?RbLxaB4X9/Ur8jCJKw3vmbCIrNhYUNmqMLjLYKysiW/GW2jW0V2LN2xoxEqA?=
 =?us-ascii?Q?4n4LT2w1HtGflIw1nMFp/tdrHSGe0lastkxkS9rfALqD7QqQpxqzD0XPjDpL?=
 =?us-ascii?Q?pr9lhmitFLxvrc8mcTkkFFLRgU2m9zUHS3kXe6OdWVeTsZcDNQPGe4djy462?=
 =?us-ascii?Q?m4Klj2bqWnwcoCP+h4sOL4rt8vJci+MOXjuOWGUvBCp7dkxy/LBKbZG/uXps?=
 =?us-ascii?Q?IAJc40YOZPV4Gcg7pg6yJif2ezRhh1gfDjqidRBkH8pt5fL/gUiRFH5hw7NC?=
 =?us-ascii?Q?lb0aMFW3uXTJzIgn+om8nThgdkvcB7NW1vgx+hxFTY1+buKyP6zHoCvQOyvx?=
 =?us-ascii?Q?YxnknAGheH/em0JCPRM2oIs3rJIx5XsWQpNMRrTdWjuOBkaxHAkcnN8Nfh0O?=
 =?us-ascii?Q?ga7opdKIuKkXrk9nbQF2Ar05iAu4zkVvft28MCTfMJDzHVJ2lbn8tPVktkbC?=
 =?us-ascii?Q?VTSSgEYATx6+MH8bcK3camtYdA6w7MfTjHqoBDDZhJCUb15Tbvtf5mI8WDaw?=
 =?us-ascii?Q?rze/9oopZ8l2pLZ0hZnD4BJygADx+/UJFot1LXbBvMKqrJh9Ahx05aeGcq4k?=
 =?us-ascii?Q?rIPFHkbRTLYly7zjXTc0d1rf5kxXJc1kD5IyAIlZ7r6oGqx8FjiMT6moon+7?=
 =?us-ascii?Q?jl6OeKp9GhNf/Yub2/PaEn39ROs1JZQAvezeCjLElntpIrKh79U3HY0yWLUS?=
 =?us-ascii?Q?Bh12Yv27qUYwc3pcG/8xoDLM353DPMA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f067db57-6497-495b-9de4-08da4b8ea7ff
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2022 09:42:10.3270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWThaRh2LTS2qymVgZImSiDYeSLiYjdBAtqxmIg2xRohtrImooiC75LzvTCSS8szTC3t4aLasXGjfOJdJix1IJXZxGvCbbi+ga34vhhXAaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-11_04:2022-06-09,2022-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206110038
X-Proofpoint-GUID: V6BCdqC8fyID6JQRxk6rnzjvYIYW0uJJ
X-Proofpoint-ORIG-GUID: V6BCdqC8fyID6JQRxk6rnzjvYIYW0uJJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_list_context_init used by
xfs_attr_list. This function initializes the xfs_attr_list_context
structure passed to xfs_attr_list_int. We will need this later to call
xfs_attr_list_int_ilocked when the node is already locked.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_file.c  |  1 +
 fs/xfs/xfs_ioctl.c | 54 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_ioctl.h |  2 ++
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e2f2a3a94634..884827f024fd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -17,6 +17,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5a364a7d58fd..e1612e99e0c5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -369,6 +369,40 @@ xfs_attr_flags(
 	return 0;
 }
 
+/*
+ * Initializes an xfs_attr_list_context suitable for
+ * use by xfs_attr_list
+ */
+int
+xfs_ioc_attr_list_context_init(
+	struct xfs_inode		*dp,
+	char				*buffer,
+	int				bufsize,
+	int				flags,
+	struct xfs_attr_list_context	*context)
+{
+	struct xfs_attrlist		*alist;
+
+	/*
+	 * Initialize the output buffer.
+	 */
+	context->dp = dp;
+	context->resynch = 1;
+	context->attr_filter = xfs_attr_filter(flags);
+	context->buffer = buffer;
+	context->bufsize = round_down(bufsize, sizeof(uint32_t));
+	context->firstu = context->bufsize;
+	context->put_listent = xfs_ioc_attr_put_listent;
+
+	alist = context->buffer;
+	alist->al_count = 0;
+	alist->al_more = 0;
+	alist->al_offset[0] = context->bufsize;
+
+	return 0;
+}
+
+
 int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
@@ -378,7 +412,6 @@ xfs_ioc_attr_list(
 	struct xfs_attrlist_cursor __user *ucursor)
 {
 	struct xfs_attr_list_context	context = { };
-	struct xfs_attrlist		*alist;
 	void				*buffer;
 	int				error;
 
@@ -410,21 +443,10 @@ xfs_ioc_attr_list(
 	if (!buffer)
 		return -ENOMEM;
 
-	/*
-	 * Initialize the output buffer.
-	 */
-	context.dp = dp;
-	context.resynch = 1;
-	context.attr_filter = xfs_attr_filter(flags);
-	context.buffer = buffer;
-	context.bufsize = round_down(bufsize, sizeof(uint32_t));
-	context.firstu = context.bufsize;
-	context.put_listent = xfs_ioc_attr_put_listent;
-
-	alist = context.buffer;
-	alist->al_count = 0;
-	alist->al_more = 0;
-	alist->al_offset[0] = context.bufsize;
+	error = xfs_ioc_attr_list_context_init(dp, buffer, bufsize, flags,
+			&context);
+	if (error)
+		return error;
 
 	error = xfs_attr_list(&context);
 	if (error)
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index d4abba2c13c1..ca60e1c427a3 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -35,6 +35,8 @@ int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
 		      size_t bufsize, int flags,
 		      struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list_context_init(struct xfs_inode *dp, char *buffer,
+		int bufsize, int flags, struct xfs_attr_list_context *context);
 
 extern struct dentry *
 xfs_handle_to_dentry(
-- 
2.25.1

