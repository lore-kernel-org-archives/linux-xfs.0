Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CED6C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 17:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240981AbiBARSI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 12:18:08 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44990 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240704AbiBARSH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 12:18:07 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211HE4q8004872
        for <linux-xfs@vger.kernel.org>; Tue, 1 Feb 2022 17:18:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=hMQzRRAUkVDuXLu3tkUomGJH7DUy1NHg6ib9JW+X4os=;
 b=TeVLTxgV8OrRwHVPkY1PGPmfSgu5kpe41V4XKYoEVid4WK8uqbXNO+2+9XzSO5N/9HpB
 f/frnDr3zhmzg+WTAQlltsFuWrYNSPSpcptAHr2nthPtvieWIsWdnfU/+d2Zw66UjQzs
 X3VSMF1NArO1do3gNzWWtfGHkK5OpaqKpEK3zMajl2W9AJqzWScxVTnhqmC784yYeyw8
 9FZ6LGGTOfJWY6Xm1dtFoGeT5DstnlpGgQJacMwkVDMDBboo6VlUuKFW+BBEHuUdqj44
 ADyMePz5FQqMVSMYsRdzDH+24Qz8UkwhmHCrwL18bkL/c9ZksPX2K17hinox5Hc5y/1L gQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9wbhhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 17:18:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211HFf7v044953
        for <linux-xfs@vger.kernel.org>; Tue, 1 Feb 2022 17:18:06 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by aserp3030.oracle.com with ESMTP id 3dvumftbhw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 17:18:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ypi9wq5zpTPRlwsUFkNnG5wnWy/RxmKlxf6H17yK1Y7QydEvMnlkppAplSWkTVdyeHBg3JbHEkDIx8+Qzg1P7hTx5eJfVgi5j3+81EFcKFFL27+ZDl4j34MMNfoRnTPnt9c7I7mmwXFt33XohmExXquPU5DzRKsjTRV68cVAUEkvhSx/0a40lwWuv29pkmuyvCMkVPUegpehTZEewukHnLlDRoi2T9RaHZhuGYOqoPbErd8sUniodCPYi9WbWTcbVAxgDcj/45TkZwC2ThfuHzxvHxp1bA2V1an+Sl6dzXRc9oUSB8bRU613Q6icXjEb2cVdtqWTszyldx6X1TcOiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMQzRRAUkVDuXLu3tkUomGJH7DUy1NHg6ib9JW+X4os=;
 b=Pz0RtwjtVU2jWXQ/2EUtLB3+GpermVTmpJ7HUlf0Z0paLh84JreUyZ4ijNHaavRXrMy7kMo3mNs7PDVW3ZMU+11aKoZyv/XbPyPvMKbCQ5P8cmGjiYUOcH3+hCShU1bYf0TuxcYMW0bbM3R9S7c40Sq7rLpYrZTDtGYxyxxpTgeCsmPvIaFhxUib4JtgZmbS9TcS2xd3UlLFTeeeWSazbqXnPm7bNTRKxfxSAEBznJVP/TmXFr65PQxfsAN3OH4LM3BaFPnADIwnYPRi8CCyfimsuE4mHTXMmqqFvAzGmH7UYKUqykG3qjFE1Jc13dg+F4r+3cl5fiyYA+sPB+sBYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMQzRRAUkVDuXLu3tkUomGJH7DUy1NHg6ib9JW+X4os=;
 b=E049UnL7RyuKC+8qUjTW2fJW1cgHxmybRLvAj4okZLkNSswXC5psShknJj3DieeeplsAtDJqyK5Iy6hYMcKHG4BHRpUSJl4gNTn6i+aCupJgIRWDGe5tUXe2OOtE75QUv548X67LsQST5C5mz4F+LPnhaVmptN8XIm+GVjMkBi4=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 CY4PR1001MB2344.namprd10.prod.outlook.com (2603:10b6:910:44::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 1 Feb
 2022 17:18:03 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b%3]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 17:18:03 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v3 2/2] xfsprogs: add leaf to node error tag
Date:   Tue,  1 Feb 2022 17:17:55 +0000
Message-Id: <20220201171755.22651-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220201171755.22651-1-catherine.hoang@oracle.com>
References: <20220201171755.22651-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:208:23d::31) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19ca908d-8be3-42cf-0df2-08d9e5a6cded
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2344:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB23449E5BD4F1C3155E6A89D989269@CY4PR1001MB2344.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ej9O/gcM3i0bsenQd0hsF0VdmI8mj+dfPHX9UqP7CTbjdNfgg+b6DgnvJo+GYWDfpH0+OQtEVANlE5GvKgVAzXRS6BWQJ16X1TRz0SR4miserRm21GefNMEsKtH1Nu+TTqwZErRTs4royViXjSW6pUVZYl4CFg1p5jgZtVKATY6qCUh6dEPs8G80XmwZgZ9571QCr0I1a0N0KmGP14Ohg8WdiyYYr5K6RUwDKLwD/21xDM/ozhlHYJPZ8x8maLFmm6NHjJnl9QaYkXFnmI+tcqnYXu+SLsPe+EiFgkCUrWblGQQPXErkuYRGrgtMg2pI3/9AM+bu5NiJ+2jWDA+bNOorZXyqqVit/4tzwMDXaqGaWN4OKWafjoey93ANuzQ/b9qtnFtasgOgcgu8VE1PU9YVg+D6/EbwtAvo44THrIr+T2t6PgY36q+ad3tlyfFLTEGS+eoeNmuKS+0docmcmSbRutjwaUSZDuOw2t9RvcisR5Bq55bWSGk8f4mEg/8buCSRwo30xd180PQoF6aBzSWM1JFuDpRLO1S5w4Yt6LOUue3Q1y4NtVymAPWs1GlziJikITqqkEk7VFkuMGzqJFQtDLp3WxxCQyz9TU0oXTlgpGxPhv8ODEK6L5MdTAVyUgBn+U8QVhmnl/F2kV3AzUyz0AM+pxmddt+6l8lzn77W426cu3pANlZQZUn1E1W3h3sMtLv88fGVHRZwCatVwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(66476007)(66556008)(38350700002)(6486002)(316002)(86362001)(6666004)(66946007)(8676002)(8936002)(36756003)(6916009)(508600001)(52116002)(5660300002)(1076003)(186003)(26005)(6512007)(6506007)(2906002)(44832011)(2616005)(83380400001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CKQ7WUBGPtVsHQDxgn0at9GO6tMzT5jEnMvxnWpvoHqNnrc97HSZ0h+vQMhg?=
 =?us-ascii?Q?TKTCzfa6UosEOYHeMlTAGwkXQyXBHrrSxqFc3So8+nWNKUp4L9Lp1n+XalCf?=
 =?us-ascii?Q?vHpIfOePmlX97XCarTGAXdlhSy6ZFyShnp57eWFDHcWJoyGhM6kvuPOw8kb9?=
 =?us-ascii?Q?PncyghGPRcrps3vmNjTj7eDcNWf17wnjyW5KQIW0pdEiiHTfqwKfaJHjD31M?=
 =?us-ascii?Q?aLr02UDBuyxugTlKFNGtphuWnkLMKxwOgdvb/uezz3FJAFhrpO5ao8mH9nfh?=
 =?us-ascii?Q?/WrPtp7pAVB5ykRJFiQjkiTJwq3xCZ/0VvQqykvGqdcKrvNUlSc+gqwnMEEK?=
 =?us-ascii?Q?Mmbnd0xk5ZZ2H/sirsWXEF8Tntp///86xSjcWH2nHWe8L0HANGZSP4BmhAgI?=
 =?us-ascii?Q?V9hTnCGiagDCsUSQDOZuN+xrVp5VKXgwcQOg1zqUdx2fn5MQPPL6Nw6RMX+j?=
 =?us-ascii?Q?BzjdOqItbrkhIXG+coQwApA3U/cz3j55zf3pImQv1vcSsr369/gUrtn4R6UO?=
 =?us-ascii?Q?1ElAnRPMvUOw7Dx9dFywaZGHXk8DZsBA5Dsvim+lhntt2vqK/n19JHZRSGhT?=
 =?us-ascii?Q?oiSfg1tRz/DEgQW5kJiKPoTthlA7MvDETmHo4jg5UPwzudhVLL9EmPrlJ5ux?=
 =?us-ascii?Q?ckKbI/6NGTFQYGtm46242sbLI8dqcNy9GzsxRSkolutKmpWMp37oA/Vq04n9?=
 =?us-ascii?Q?qSw58+/5vp/81Pb4WRCZ5Ni7HnlOy0UeF6a6zw9Qq9R67z9tv0dJ1fs3M9ki?=
 =?us-ascii?Q?Fh0ToCpRqf5l5x9uwpAgayeEecSFI41RTeBKfhJrffsWBefeZhQatIpRllrv?=
 =?us-ascii?Q?blRbvXl0CNuiEFkFv1GVW7hRn43mc6fsYhBKPnLZnyV2N5/jfwr1anNGtWon?=
 =?us-ascii?Q?JB8qOjXOlreKm4/UbtnW7rbkWO9flye6m0L8BGijrnrpy25gcadBF9CZNkTT?=
 =?us-ascii?Q?tlpZy0mKi52jhU1bwAUM5hmnTG16STb7ffsZb/HoAu17xyyXIwymDaKBsYhf?=
 =?us-ascii?Q?LMZYSSFxBXRjBuOh0UHXzCCEzajI8lhL1PjVakMXI/BAE62Kfq7Dqk/gW24n?=
 =?us-ascii?Q?5WQRRe8kma+IYjkHMcNQeX6rn/8Z3sM++OnyNp7X0MinADbk7u6dFTGBj9Yo?=
 =?us-ascii?Q?pLyErIpR+M0IukmQaaUPqd1OX2VBCffHGDtu7npA6b2CNtZp4iVVRt6rbp0U?=
 =?us-ascii?Q?QRpcE3TmG0278iNSw06wko5vTvJS8uI2bErmVNqKIKYkBioIWRa6Cv5I71WG?=
 =?us-ascii?Q?7TVlBhlOt438Jiw1mPyWN0Yu9o1ALisJJV+lRONOaB7ChqbPIBQOBjYlu60y?=
 =?us-ascii?Q?9XDU0yHj6X0PQq7bJsrXuPDiwY7zW9rkuV/t6V1t9RL0iE6TbyGYhGMHXjHT?=
 =?us-ascii?Q?aFhL4u7DcxRatGXXZWzf9oDVCJii1vH50jIFSlH0LCe/NeooiPeIIVsB3mwd?=
 =?us-ascii?Q?keHmtVWIijnPyLbhtB8D2+Wd+yl/P0J84YAr6dh/fYxWrn+VqB3UpzhMtwP/?=
 =?us-ascii?Q?G6+lG5f9ighTgxy54LRE3TTH1DUosv7DyzUNHErGQVMi/TCQEp0bUlCbT8hM?=
 =?us-ascii?Q?lqb0xDnnC8X66Ws7w2rkfVX3v1/cPpR7EhD1zUZfsdXhv2aUclzN1vBjunEB?=
 =?us-ascii?Q?p3eTd2L2FwmQqITbc6KghbhyVpoYAOtRLdQ09Yix3hqImrh54tBjpu1mfYWg?=
 =?us-ascii?Q?XG+Zdw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19ca908d-8be3-42cf-0df2-08d9e5a6cded
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 17:18:03.3082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x87niUQ/mIRKWiQhKpONb1hOyJ4M8OwY/bVmpU54LrlKNXVEJscy7BbF1UL/TIM0DSXRIGyN5Q8fSlsyOes/qx6R6HgvhueoPGg/eGVvzy8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2344
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202010097
X-Proofpoint-ORIG-GUID: 6-8iOeXdwTHIv2O-wt_qyvfGLR4yXRqR
X-Proofpoint-GUID: 6-8iOeXdwTHIv2O-wt_qyvfGLR4yXRqR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_attr3_leaf_to_node to test log attribute
recovery and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c            | 1 +
 libxfs/xfs_attr_leaf.c | 5 +++++
 libxfs/xfs_errortag.h  | 4 +++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index a7ad4df4..c211fcbc 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -60,6 +60,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
 		{ XFS_ERRTAG_LARP,			"larp" },
 		{ XFS_ERRTAG_DA_LEAF_SPLIT,		"da_leaf_split" },
+		{ XFS_ERRTAG_LARP_LEAF_TO_NODE,		"larp_leaf_to_node" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 6c0997c5..0f40a1ec 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1181,6 +1181,11 @@ xfs_attr3_leaf_to_node(
 
 	trace_xfs_attr_leaf_to_node(args);
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_LARP_LEAF_TO_NODE)) {
+		error = -EIO;
+		goto out;
+	}
+
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error)
 		goto out;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 6d06a502..74b75319 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -61,7 +61,8 @@
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
 #define XFS_ERRTAG_DA_LEAF_SPLIT			40
-#define XFS_ERRTAG_MAX					41
+#define XFS_ERRTAG_LARP_LEAF_TO_NODE			41
+#define XFS_ERRTAG_MAX					42
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -107,5 +108,6 @@
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
 #define XFS_RANDOM_DA_LEAF_SPLIT			1
+#define XFS_RANDOM_LARP_LEAF_TO_NODE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.25.1

