Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BC1C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 21:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243329AbiAJVaB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:30:01 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45910 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345257AbiAJV3w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 16:29:52 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJlgKN011400
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=RBFRgnUZ7OuvjpCopZLAdyUbb0Z90yNIz56EY2GDDDo=;
 b=VRGJmTtENcVzzwQA/2rvWW5vYSKbseo1WjgtWAtEA0BGBjQbIzwyaagpFEItftm3qxag
 d6rqO56uBzgYdKWGbR9TJzsRFe9QTGfPpbXG7lIPOxfWBAaiAv1XDfIKmzvDjfh+7t6Z
 zN3isBhYnjmxiJacpPOqtv1K7qPojtJCDlnSBilf/VGocE4rVDVeGG9AnsOpZQgFww1l
 GkZ+ddc1erFNQ0/ZBYHPUyvEtaTZY9a0o5X8Mh2Kq9RER8fJfCuOK7NtpChYkaI0tONa
 d4c6pYyIJouGXgSmYClD/NHHgjYW3NWwmG6ltoH5XQcfk1tVTgM/TKvlDzM1JeMaL/iM Nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgjdbsrwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:29:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20ALPp5t155517
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:29:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3020.oracle.com with ESMTP id 3df42kktuq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jan 2022 21:29:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvzmlSzMOtePBEucQDuDihn8Z4Umo7pUB2/WxJj0J1nvjZpmh86lAemZZQQRQPzu8NsRuRWct9Ehtq+V4ASTq7Aas8c0E++KP+cyRBV2E1LeeINMDhAifw9XfGIsjmuknpSKYAZrk9J+nSueKDzlr2uB8zJRMezNzjhzbX8HJ8jwe66IbCNTRkPpg/UXJ2U7ZaQsf9dhqlDspXPoTlVz7hKZmkkfm29T/pp1D1558IdPQfaBuh7fB39IYTw1MChS0HDvY5B6bnnquu7YMO/gPy4JNq6tzSF+Qwo3gIIRDuOqaFx7INHihFOk4srlz3Vhuwwf1q+XirkiF2BaE4SSKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBFRgnUZ7OuvjpCopZLAdyUbb0Z90yNIz56EY2GDDDo=;
 b=k4EXsDiWXf2CEcCINGeGpjkdZgYTeWeNP4v7vjk1RUktTosjAqxqh12u5Y/dodBGhLO+qnxRTn+4fB+jeLwAXKeEVlr6euqR40PjDdeVUHrehxbGyTUCz/reEj8Anhyf4u4aleDKBlmn1IKNEP8bIP29rx9DLuUnzXOMfUZcgBoP9ug34N8Dsxp4VEWLa7w5XgpN7dSnqQ6ssTlgVitEO6c3UwHmygZmfwSfSSn4CgLgKeY1eDFIOVQxnACm1BD01WevL8GZfQzfWbjIMhOSUpL3XE0qOy7R7VblHcj1vv/8/CNcP1pvh5a8PMf5q3z3PwdprIJ+cYThYIFOAztphQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBFRgnUZ7OuvjpCopZLAdyUbb0Z90yNIz56EY2GDDDo=;
 b=GM4i4Qt+K5i1bRRZdjX60WlJB8WYIio/rQq6jBbYl1qKdfQnAyGUBsepChrjtXvfxFqBGC78/f4/oaaBOXg1sgFqWXkxKonmw5M+Ltv7tsxxa2xjP7OTu0aHyWEMoSlXo1ROZdqcXcYM817eoGRxi+9p0zZbCbP1mwJuV5WdWwE=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR10MB1484.namprd10.prod.outlook.com (2603:10b6:3:12::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Mon, 10 Jan 2022 21:29:48 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 21:29:48 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v2 2/2] xfsprogs: add leaf to node error tag
Date:   Mon, 10 Jan 2022 21:29:40 +0000
Message-Id: <20220110212940.359823-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220110212940.359823-1-catherine.hoang@oracle.com>
References: <20220110212940.359823-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:805:f2::42) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4a0ff0b-b5d1-4b36-bdfe-08d9d48053f4
X-MS-TrafficTypeDiagnostic: DM5PR10MB1484:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1484880BFB16A859CFEDEEB489509@DM5PR10MB1484.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BC002/oCiWkm5QUGjNDuhtIGACsWvtEQxAcl/ETXL0XU916Td5PVVaG1IFIVXN0HuhSHsvJhqNpGgzJaCNvTkeLKPC2VVdsGNrQYT1C780A58bNmpeVNiySzYC0Wkss5He/8HDUR2m6fVieTnjKM8Ak1q1IkuOxrXqgVXWqpQi4ELWY2GcDQMee5POHa7gDU49h6HwTlZ5j00QldFEs0TohO5MxxLwu/uQEOVUmKRW09t+6bpJ25pQN8ANkXhTUuoesQoSfzGDAWU6EjtdjLzbxCec2LssmCbjujNAdCOKpUndBU2Wq8t8XRj4FNrnjvhSFRIgGZKgg9mCnicnw6TcKG1bxk9eq+apLO+9U997zAtly8ugbLytycs0y0IcsLyi8i1d5PhYzyoItZOUaHSZ3566j9cHJSO5eKMjEn4u/vJnfkmavxRDXtqr5OgjkRmnH/VhJWO/ztB0kO7YPNLw5Z5Ug7lDjhaLygu+slojtUp25ESFv+N9OEghPWj8rAmlCM6Bz2o8aHR323XArOv+GaluE2Vi6yBcnvJbiL5TgFLW8pxXDrEGpRdeldYViNgmdupXq++NuKG9pQf30LiHlUmUDXl4FlJq+eFDagCd6BcN6wMp6IdCoOYHHVsCxj9idXj5rcfFSIbzHkK++j2y7BSV+c1Awizmco5cW8sn4jYdi5TdkGBveNmEoFf+tIzLzIzQTWYyhKRDiAl2+DHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(5660300002)(508600001)(6916009)(66476007)(2906002)(6486002)(66556008)(66946007)(26005)(8936002)(38100700002)(186003)(38350700002)(52116002)(6506007)(6666004)(83380400001)(316002)(36756003)(2616005)(44832011)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ueDWFcqmq8l38/KAQzzEVRihC2OUce9oZ2NLV8BU3UttAtbf23tEsA98VlDm?=
 =?us-ascii?Q?VzGmeMlQRU2OEWqzAjOgxHR1vzoH9PfpFAjc3IQjKY7deAuYTpWlrlmaYNQq?=
 =?us-ascii?Q?6aAVwpBmxIaZ7Qsxn6gyaNlLXLf11mWC2aRUi3cdC68kJni2d3m/aYboWewU?=
 =?us-ascii?Q?Duh+WT7otYpGXdAzBvMtkT6Y6aPNP6vHnIWS+kfM0uAhC5jbf7feaZPxmSNx?=
 =?us-ascii?Q?Qc+na5r1I2mRUvz8PTPE+DKKWvnjyXJsX8UsbVHi+s/4Vvn+owPTsWQfCiFl?=
 =?us-ascii?Q?yUjQ8KhAFtaLEtfBJqSJYBaKpib+MUQvvbW8NA8xi19YozHAWvye2nqvGc8G?=
 =?us-ascii?Q?69ieW9P8o31N0UzfdCdWza+mvf7TeVo1PoIxMS1z82KjxCaog6L+GR77iMAd?=
 =?us-ascii?Q?SR/7kUbph8IiESx7aoxT4jrNpvuowiM2CxiBqeV7/zjG0hzv7dYbOO+/erS7?=
 =?us-ascii?Q?Q1uJwIZ+7aqfuApwTmtdEE+WJ8k0zHRaTbcw39jBzc5SLHUM8zFXMIx1ocUt?=
 =?us-ascii?Q?y0dsF0ovdHpsR11c6UC8VL0emA5iRc4cQ0X+fCFbiJWqE+kZOaSEkYyXfttE?=
 =?us-ascii?Q?tiND1x4whWOtJ/QgeL8o4qVQAEVg57SYI7GmsjEeZZMC/TcZ+me4+qosYTk+?=
 =?us-ascii?Q?juhIngqD4aTtQNYgUnk6RwJjl7A/YNtoPfnfOCCQKlQ1iSEZe7eL/lEEfT+g?=
 =?us-ascii?Q?/tAxSkCoDLVhW50Jrbpvot9exvpd1aEPynDFx/jSsA/Zk3MDWfSH14b+pqkR?=
 =?us-ascii?Q?ZakVSCODeQNi2cNOd42gXJOzhNuPSA4FRLNWIQedcUcJXLw1Wn9qPqDCdJVi?=
 =?us-ascii?Q?b7ss6zgfGjDHMeZqk0F4FwfanOf3fh1DY8WUBsKSkvyVu3jagoKQvMS5hlHd?=
 =?us-ascii?Q?Z1V8t+8i68O5o0rCUScfiszcKZ/5p1rF2cLxBOyaGMEGWMx8eu+q2en7syoV?=
 =?us-ascii?Q?8gz8aXEk5uH5zC895XzrBKSNuQzT2SlDeCWS0EJLxwlYGcc7P9FhILCUp4xj?=
 =?us-ascii?Q?V7hH7S/qxUK5nlGkNNNlSjayeREO5QD2AX8a9TwpDK04Sr9uu9cs2Y0hToFZ?=
 =?us-ascii?Q?VFUgSSvwdDNoMw6+axC33B5uXJWzHKVxXH7fNaqKlwYxtiNWDDquLcKtsEyo?=
 =?us-ascii?Q?zJYFNDPbf7acqc6rL/AwqgFDTKWRmCkxH9d3OkIOL/PDsSitjpNGmJryeN+a?=
 =?us-ascii?Q?++q0MUtSoxojhXIkuQNZNJiQByrEpWEHYN/QG7nwdoy6F7o82su7Muv+d62n?=
 =?us-ascii?Q?Ar1yTC3UKy8hIjhP6Zlie+8Ox2CL+bwXKpfKwDd6f6Y/PjuQLj76V2afAic3?=
 =?us-ascii?Q?ZT91c4perCe7AJ8DVrvT3P1C5O5qd4dE0sWMETkYBQ6Il1/WVucslGngTaCv?=
 =?us-ascii?Q?Aun2RmfdtRn6PMgBJRX2b4gKUauSBZ3ogSfP9m7lf7NQuLi2kR+eYX+IdxvD?=
 =?us-ascii?Q?jFsOCICnbkVeQ2vcERSnEkPWgIgsJt+xEdj00f/XecRSaqUaGfuyR1CrgiGX?=
 =?us-ascii?Q?FkQYzJXG8naYiG1F0Yx1hkh96lqQTZTvL9N7KfmfIKqhUuHHQLvbJucClZCN?=
 =?us-ascii?Q?oGO21RjPCnBF+aUdefRQq/hJF28wlaIomVi98L1GXH6S5AlxGjaEDVPbT2wn?=
 =?us-ascii?Q?p8yHfyluGIJ78j0Rfvv+A2n/m40NJegMxsOFdPSzO4HdRpR1H2fr4rBAbDf2?=
 =?us-ascii?Q?WGkoLw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a0ff0b-b5d1-4b36-bdfe-08d9d48053f4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 21:29:48.1335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9NyxZUgK26NvogfQBibZfPyuX+l6Om9+tEUEuRX1xK/ntW7suxW48O8uR+Ea/cmu6CpU15LIl3vtKFsbQSvlk0GMLxybHRoGi5y8ncGe90A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1484
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100142
X-Proofpoint-GUID: L8oEIXm7RRiSy6OcrMkU-8iSUATkR9_c
X-Proofpoint-ORIG-GUID: L8oEIXm7RRiSy6OcrMkU-8iSUATkR9_c
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
index 51f3e2da..4fc5dec9 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -60,6 +60,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_AG_RESV_FAIL,		"ag_resv_fail" },
 		{ XFS_ERRTAG_LARP,			"larp" },
 		{ XFS_ERRTAG_LARP_LEAF_SPLIT,		"larp_leaf_split" },
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
index 970f3a3f..6d90f064 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -61,7 +61,8 @@
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
 #define XFS_ERRTAG_LARP_LEAF_SPLIT			40
-#define XFS_ERRTAG_MAX					41
+#define XFS_ERRTAG_LARP_LEAF_TO_NODE			41
+#define XFS_ERRTAG_MAX					42
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -107,5 +108,6 @@
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
 #define XFS_RANDOM_LARP_LEAF_SPLIT			1
+#define XFS_RANDOM_LARP_LEAF_TO_NODE			1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.25.1

