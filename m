Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8F6C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4016F60F26
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhKKAUP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Nov 2021 19:20:15 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3842 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230345AbhKKAUN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Nov 2021 19:20:13 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AANdRGc032052
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:17:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=lnfu7zlPZONN0b/sXJ/qBdNNb9b628JfbhSsk2la1no=;
 b=TjkY8tjFztRvmn7Ej0rHbkrRIzZ7zdX5xX8dCNFvhZaAKk3TSYPs+u7d8+XN1JKgEYL9
 /JKO+4PGLAQIggl2vEbq4EWgoTSkLyAsNFLDbYf7JExewNCBcguCXoRG0uRvHrRHji+U
 Iez0J0VjM0yhbBWZrIEPKRFCnZEcn8D5yYoCioMiLR/viJ0aTn8yLt8PdOWuOAEPFz/e
 BLH8UlUzsHGwF79Eh0PuvM//SWKml5d0hO2uPqc+lzYmlswboEa+p0taqz8qCMywKy2N
 xHdbEtt/TvVye9Eh3U35VMK2697TYA68hiEP7gJwbJwowtwgmnJKIImsaQ1HRkGqxu7d Vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c89bqenee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:17:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AB0ALjO178474
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:17:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3020.oracle.com with ESMTP id 3c5hh638b2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 00:17:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwJFVt5wLD28A9y57qN1Qjqd93kkO/M5qKjfYJBXF81GhNjjD7FMDx7Gqgh7xQCSb5G8t8GE32C6jbjJ8mk910tvlylwSokf1UOjR4v5AGg8i0GZPWLhtZKFz1/WmqDNGKmU9vvBE880NDflHi9s6x9L+LuV6A+vAyLTMfaIWncFvrtpqjDpB31ZXpOCzbKOaeodAd+67Qr9R0tkwVUfI+nx1T9r0Q4jzMhDHf1jWuolY2BSjw4p00yKJik4MZNVhitDgh9gpRGDTipqShgkVD9PbuWTOVEgX2uTKlM4S4HwDC95C0AaxLgai8rYeEEWQ1Ordnp1a+CcQx/dfz27+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lnfu7zlPZONN0b/sXJ/qBdNNb9b628JfbhSsk2la1no=;
 b=bo8jJx1ZCdwxz6ZEtL9lXYW7maXRposo/rBWbks5KN7yfuhJ75IxCj/CTcsE6tUTKlNTMkq1O9YNY+p+DqGZVgyiYEHRKQ2lGG490iD/xCqhw+GbiEuQRVva5CBJT6zuSVmi7OfqP75PLV+v1gO8B6wWANsL3U2NMPbA+HAuDDUV/zd/kxVgO4noPggEMcSr6d1y4EpLvKH2izm2l39+xx0J6wOeiieesjE/2BxxjSLu/it6MkdINzetULi951sG1wteuxQoGOh2D+Wij417t+GkwjTx3sbLWTasnmUAORMXoU7i573jvkoL792Rom68xY6mjQQyU5R2rgC6fiqJzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lnfu7zlPZONN0b/sXJ/qBdNNb9b628JfbhSsk2la1no=;
 b=k3ZGJ7VCx+h7xc+FKCezCKSUnpF7BpjI9O5c1G1noz11AXn+jkjgoxFcPk4O/rTRkcxKQ0IUuGw8og2E2VXZYOeTByiLYKUJ+ZyTaAEDHkuQJ7TOo2oK3BUQdEJaiIIkFU1g/ONbeU/fyzWNLbpDH00NZiwBCVK6eGTkE75ebMg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM6PR10MB2889.namprd10.prod.outlook.com (2603:10b6:5:64::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.11; Thu, 11 Nov 2021 00:17:22 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 00:17:22 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 2/2] xfs: add leaf to node error tag
Date:   Thu, 11 Nov 2021 00:17:16 +0000
Message-Id: <20211111001716.77336-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211111001716.77336-1-catherine.hoang@oracle.com>
References: <20211111001716.77336-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:208:91::39) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by BL0PR05CA0029.namprd05.prod.outlook.com (2603:10b6:208:91::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.7 via Frontend Transport; Thu, 11 Nov 2021 00:17:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c0a4ec0-ff39-4504-b214-08d9a4a8a1cd
X-MS-TrafficTypeDiagnostic: DM6PR10MB2889:
X-Microsoft-Antispam-PRVS: <DM6PR10MB288933C9EA7EDD927BEB0F8E89949@DM6PR10MB2889.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0XsLkbtSU3FJtuT+zBvQeTDaBImTLEL737z7p+MYnd15fz3HEulvqcZE7q1dizAySu/rU2r9PGHz0iGHRwIoFck0mn5j8NnHLBoP5r0NISTD6+smHFRBG/Hre12mj6Rev4WKh0jkfuDtV+1EgHA9bI5YcNzpNhFu3TQtM7KYAsvn4zrGU1wNdU/LlEHUdxIKnHzQZmV09cjjrb6KbWWt+0tOx7OFFw3ynJt0XYZUjUMqARWr+GXpBL31MCJoZwI307Ip2VBHMxZ39stPf9L5js1hBl9MhC+qrNxzadwsfQ9CdFDoBGWZMFegVDGzSYLxGOr1YqYqByA0r+Sxkravj1xp21KJWSRepKA1aglnJqAdskB5hm/gT+SCGjHqk4hFIYPGDAk2BrikZAfWy0O3wdPOmlhxClQ//CjrqJsbmp2SKyBeQsp33PxnTDnm/OarVA5nGMSiT2uSxzP0Y1ks04XkcvdpJFGbZbRAnt8aWELGqWtcZhIk8ic6euoZFrbBLF+lYTkwtHxFITtHfKShrpBv489+nILqvCHVE7U+gIUoRXapkDKkFR0jqW6kxbHvh1eA9dKXH6tav5VUFkjlcYJpw6g9zWByl0IfgqnJClRsuvxpUeYB3mbeYj1+maPo48Y61CkncgvGTq9ZF+QWGgrHPJRxSEXXpPVi4FGpvEhhbvJ1WkdrecOH7fnb7w+4fIiHL0idEzBvSNI1b27yMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(66476007)(8676002)(6486002)(36756003)(66946007)(1076003)(66556008)(6512007)(5660300002)(186003)(38100700002)(38350700002)(86362001)(508600001)(2906002)(52116002)(6916009)(6506007)(956004)(44832011)(316002)(6666004)(8936002)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RLrBpDD6kSKDdWHUIvDvgMSRCml44kH7ux5le0kX7AUMqMwvJWvCTv3FmNEo?=
 =?us-ascii?Q?yUuqHbagH8vQFAzqQWLIOu7w6E0OnylHFuQir1AQo2fO1U00Vq2SeBlEAmkb?=
 =?us-ascii?Q?NCS88N2/jI90QH80nbTBGSWCQI/2B5xaHpLxVxmLDH4vx8+RZCDnhT0ZtDvn?=
 =?us-ascii?Q?x387tdGPu2MOromwEK2SEfnU9OD2cb0QuOhDweZE2G63YTNgG4M4AA96olqH?=
 =?us-ascii?Q?Q2XTYA8vcMKHe69x7W7Bapsoj5CiUiVSaNC0+dJov6vDN/cI8ma3zwXr5azM?=
 =?us-ascii?Q?WDo/RTtxOjTI4Z/7BFe2+VahG26Q4IfzFiWNgU7h3/+RurUoDzfAglMGWAG9?=
 =?us-ascii?Q?0cr/H2RS5zuDUr/iw1A2OVrzm2YcsFACwrw60wmALpfrfXK8n1cGHEZGZiLj?=
 =?us-ascii?Q?7i0YUjqa7G8ZnLrHtNAWpADPfmXITmu3zNQ/1nXxZUgoUIC9bKMt62K7qqoO?=
 =?us-ascii?Q?XBSE8/EWo8ZTrlaY11y0kCrNWupoCFMFh32RUeVrSA1qvOXWK5f1PUgjDFaa?=
 =?us-ascii?Q?gET7WnuYI1Vx9wuGEJC2C+GbkvYn5jU+LkvIlVb0tGm67HXRZLtXxESrhqL9?=
 =?us-ascii?Q?kwW9BG6AMuy1Vv7evk5odFaGWQwq06MgaVzamGn3GFXnJTQyhpjmmtHkbxTN?=
 =?us-ascii?Q?EZ8ranmRBPafwp9/nVIvFYTFeC/WcxlVuXHhjlzMIR0zwc3HnOp+nfVZ4lzQ?=
 =?us-ascii?Q?zHSQJwI1T1k9yOj4aNLjCULjXvW/IRxV2gBmQ//ZrUSbc/9PJuwrgKDmvL3S?=
 =?us-ascii?Q?zGWVyJyHBTzW6G8C8v8vZz4+iB1o41GPcQLcEzAOIrreA8A9HFzY5OIVfz0W?=
 =?us-ascii?Q?NCFPZ6yeQzrNIp9aZV3K7eKEmqtNgaDZwiE8Eztj3Btm1bFzlIOjHB06tDjL?=
 =?us-ascii?Q?jstZEd76qtvar7AgWHVLMEowEag7S7EicglyQkfLrQxoGyU2MI6SWgWLFkD3?=
 =?us-ascii?Q?n9KH4gyk4a2hUbns+Ldyk4a+cDY14BZAfobsJtLIrBi/pKOOFTgG0JEuPnVn?=
 =?us-ascii?Q?1msurYtqJzUH7aqYQ7L+LIsS5lbXFITve1MKaASKfTHLe7t5MGvAZwcqW7PE?=
 =?us-ascii?Q?i8hKrEygiJLroSPLObmo+rXvFIyr2n331Ipv6DYBSm/6RL0Jp6UWGxQCad04?=
 =?us-ascii?Q?pU62kM8FJbLDFU8c5/yk1cKfqJFrYVgWItcpHjcf5PDrK+pVjHh9uVwq04wk?=
 =?us-ascii?Q?YEhKfbQBZeNNGudj9TlDsrMm1MTdWv9sdjsnCYz6O1B0+iTALiEwiFQl1AP1?=
 =?us-ascii?Q?6GVMQAEKv/ue7gLR5Vx7gZWwe4/dMoVHEpN3tX7cxXqo0UNg1PwsQDNXpPBP?=
 =?us-ascii?Q?scublti4CNPLQ9ExJbl+xM0TIwSnG/jyA5TSro1OkpvkAKffMJOxS+0/ErNE?=
 =?us-ascii?Q?juOkabGkmqJlaswnxGQ2X7gGi+eSn4ckghQjliVSTwKhTFlkBTsBzKvBTFMR?=
 =?us-ascii?Q?gZa+kIaWzzOW6gYh5HtRBIQ9z3nubLdhtPJTgxV4T9KHUBy6LzYWA/DMX9gE?=
 =?us-ascii?Q?mC/MbQA35k7/ppGi7RDk5wLhGwNhiQ+Xbrld1HYYJyoPUclIlw4Ejcm45x+V?=
 =?us-ascii?Q?Jh1mveynTydBwdU90DtABQivRJMGM5GPDd7y+oHSuqX5MO34/0IkNLZMtHjO?=
 =?us-ascii?Q?hCEt6rnq8IV5hqwoQHeUdv6pOuEiFttWy6lsSGK0o6L2oS6/S0qeNERsh/ce?=
 =?us-ascii?Q?ffcaPQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c0a4ec0-ff39-4504-b214-08d9a4a8a1cd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 00:17:22.6938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q6S0L9yZWMc2fsAlKLJGSeXzkhYLlX46aFTwE66XrpEGGRWzUNdiCOFFJBgt722HgxmR8jrToP/G0W3KAbyqWG3juQD4pGSYJmL289XSMRI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2889
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111100117
X-Proofpoint-GUID: qzzbU946RFGWEpOQArJhheVEuIGi6CeL
X-Proofpoint-ORIG-GUID: qzzbU946RFGWEpOQArJhheVEuIGi6CeL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_attr3_leaf_to_node to test log attribute
recovery and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
 fs/xfs/libxfs/xfs_errortag.h  | 4 +++-
 fs/xfs/xfs_error.c            | 3 +++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 74b76b09509f..fdeb09de74ca 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -28,6 +28,7 @@
 #include "xfs_dir2.h"
 #include "xfs_log.h"
 #include "xfs_ag.h"
+#include "xfs_errortag.h"
 
 
 /*
@@ -1189,6 +1190,11 @@ xfs_attr3_leaf_to_node(
 
 	trace_xfs_attr_leaf_to_node(args);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_LEAF_TO_NODE)) {
+		error = -EIO;
+		goto out;
+	}
+
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 31aeeb94dd5b..cc1650b58723 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -61,7 +61,8 @@
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
 #define XFS_ERRTAG_LEAF_SPLIT				40
-#define XFS_ERRTAG_MAX					41
+#define XFS_ERRTAG_LEAF_TO_NODE				41
+#define XFS_ERRTAG_MAX					42
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -107,5 +108,6 @@
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
 #define XFS_RANDOM_LEAF_SPLIT				1
+#define XFS_RANDOM_LEAF_TO_NODE				1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 732cb66236c1..7f2a71218a82 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -59,6 +59,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
 	XFS_RANDOM_LEAF_SPLIT,
+	XFS_RANDOM_LEAF_TO_NODE,
 };
 
 struct xfs_errortag_attr {
@@ -174,6 +175,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTE
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
 XFS_ERRORTAG_ATTR_RW(leaf_split,	XFS_ERRTAG_LEAF_SPLIT);
+XFS_ERRORTAG_ATTR_RW(leaf_to_node,	XFS_ERRTAG_LEAF_TO_NODE);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -217,6 +219,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
 	XFS_ERRORTAG_ATTR_LIST(leaf_split),
+	XFS_ERRORTAG_ATTR_LIST(leaf_to_node),
 	NULL,
 };
 
-- 
2.25.1

