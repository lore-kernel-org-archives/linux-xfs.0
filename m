Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B273C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbiCAKkz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbiCAKky (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:40:54 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2966E372
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:13 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2219eH9X013711;
        Tue, 1 Mar 2022 10:40:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=LNbi5Yh6ZLH9WdE7OeKLnm0Pecr0XTe7WfHMkgVn79I=;
 b=x9zZfxBs2gxd01KMX89hMzj/2L7S5Vj/9jjOAkEEBVkVGqEjxCbolzDsm6LvNgbGDGFj
 o8Msy8YHD7ewEWedW8whQDjKK3y704ii+4nNkJbTir3XXCvUTSJPhgoeDET6xWIxomTG
 70imy5px+6r2UyYbJlMUKV+BatHm7iczAMVy3XE8BF4pPBt9FxsmdNAPGuJW6QkxvEBz
 8gN2EgRrwrvs62NmuVMkHMGpJwYO8VRQac3rw0/Nu46HDsqzsiJG75OGV065sDZkgvgU
 zigm9DdG5SkyKLQAeidyYUQh/L4qt6u5gOvdhUGRkmy5phNi0p48HK2fERQvdd+f43Hr Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehh2eg5kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221Aaovo034126;
        Tue, 1 Mar 2022 10:40:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by aserp3020.oracle.com with ESMTP id 3efc1455eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhZyRmFHJmZA+pgCIWccGGL1VL/BgVVAILjVeamPSIWXdGBkVnZUGkabIBzI1DkXzk6Br/GbD54yDDad3wQ7wT8dLv43CMLIJqfrzLXE0qvLeVVGi+PO7Dzoy4sOdFgas0bzDJh3/2hR2Tq7/QP6oNGghuX1rmRYGtJXmUHTky+1hca0uFo5U6aGtxxrfMIldPGvy/IVWbDWqJAoY8U5UAPqnpDxdCDF9a+4EgmX6mf5zvMmzRaE6qm9q4YadZEFpPDqsMScHMiNXOybjLD4NDetPlMbKE+GZB+FWvyjr8eMBcIcxcLgKVc9WXEBeDbIWl8ajLsqZ6Ac8LbahmZxyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LNbi5Yh6ZLH9WdE7OeKLnm0Pecr0XTe7WfHMkgVn79I=;
 b=a6Hgxh15dqVqRf74ma4LrLyYpCMsRGro+/K2EPYlFvsgEPSutXLUzLSGTkeZgzw1Lsl2LWQQomy5qneIuJurZrgOSxjTeMMrOYLDyaYIoJY9Cg6Myy99wv86CCVWofrQ+CZxNjtUqQJSmYyR7n992yvKv7ALedlws6KbiKxlOQAhLJ4YiDX6tJTsF4JpdGNvNUuHoW/qEJZJnotqb598Qw+2tJe+qYriAjFPMxiWeRn9DxNTXaDt7gykLW7LXyQJ48TFMZQjaX4jBKKKC6uYPDiI8iUdQRlXoGTrUWyUqoV6nIwkv1Zmozb9B3AvCVhbNySVay5x394KzrsJBGtttw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNbi5Yh6ZLH9WdE7OeKLnm0Pecr0XTe7WfHMkgVn79I=;
 b=PouqAlVsL/SG8E6c4CcD3T9xRYMEdRnmvPN3vSyqhJevEKl+2tFgADgxcrLK4iHj84hO6SImRzVQnpnhhBH58tcwFboRmGMo8D59Ku+/vRfaWonq2Bm7kj1soJFn2eV9kManJ6dJH5L1EU1WpiAn0lZwbc2fcMj1+VAjhbaQtM8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:00 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:00 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 01/17] xfs: Move extent count limits to xfs_format.h
Date:   Tue,  1 Mar 2022 16:09:22 +0530
Message-Id: <20220301103938.1106808-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 205de950-c73c-4ba4-405c-08d9fb6fd623
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB416067605A7B36570307B766F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /JV2Dz46z64qfD173UZOoda9Wo/EVk4pmVotz9PXpfbyK2hEP4+3j31u3veRIp7iMuN7DdnjWCZjmgj7r9c6DeN14mty5vlD112pBESkEDJ6m97BAk4n0GU6lTTXyrFc/aiO5+0jwyjVfzQI48uASuuRXhzEtlTQhNYQ5g2z3xs7pChO+wy4D2OOxJBptf6sf8+jWMBo3LzJwPTfNxaSH45n+qrI1CrVe9bcXMMYBMxEiOX5tiCFET/jUG2oWqd79v7hbNITG9VED87WrLgDtF4Nk9DKZUh32HYpYztrC+QlnpqbqQ7sH9FLykEuCB+vWERpQJTA4xQOD5OlP8jtnvC7iAKS7YWP6VPbKqkSEQtrKDFUdzB2+im5w1gInDwUD3fJmbuUoPXxsr9Xet9qrP3w3WF62L3FB1WFPOtBTlB9PCdUju4juKId49i2MxuqknBHqFCZ9ZiebnuaHTWtTOT4kp1PSwYqeQtdDaOa9dSpuH0ghvGgHqWEJkWKtj2MkQXvxCEAUt1eQ+EtGLnPeFCfqx3pGXj+RDOFUbe1jIOhxmTal3rVIMwYTjHPh53tqJ+5lrf3ATEC5PYOEgfH8VS0XpOThz9WKYnEcwXgeBVIwJB5c6Et8A9mSWsuUCQPq++flFX0ugmMU7U3ap5ZUt6RRw53gdNGNLLYemka5mxieLW25K6j78MwD2QhydQapHALJG8H8zF37GTnDfB61Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qMUuvuP7exHx7Da7tn074Dqv8r3qDdr3O9hUT8/HVOzuoX13PDBsCfv3i7O9?=
 =?us-ascii?Q?34dDYIbe0A03Z3HORPQk2iX8SjqY267Ya2BRN1nm09m+KwPhA7MdaCQPJneO?=
 =?us-ascii?Q?vXZwfdYxYAhYxVyjJ8FYrl8+Suytv5cdfN/VECSxrd5lguXyRQSihOzmdwM7?=
 =?us-ascii?Q?SNXzI/tJP7Fo0k3406mVeZaXaZaJAnTE6XcdrdvNnmyWGIuSKbqrlroQjNEd?=
 =?us-ascii?Q?sND8CH3KjMU6DXKJqyiq4JZ9QPrnNqa8QTaYfc44tTE6fPdkxkOgqoFrDzMu?=
 =?us-ascii?Q?Lym2mbb76US2A2zY2kaXOg20youKK/oLna6AW+GnLYx2H66+U40Yuwm+WZ8y?=
 =?us-ascii?Q?smVEYOvvlApv2k6/ExvVOiEXos2ZM2Y6JKlSiX2nplI3mq+DVCZ4my/hSgUH?=
 =?us-ascii?Q?PEC2sc6A81xFKwBfIblDm1zFcVt3pBgvm0GX+LH3JT+2JRmE8m21Ksv4bGr0?=
 =?us-ascii?Q?xHh9WfmpnIHTEoIXMZkXgUc2CDdvGrO9Bym49l/ZBKaeSpSY/vmJcpzrNPgd?=
 =?us-ascii?Q?dkGhaAGkAuLpaLbagsIh3NSbG4MWEPyXVHOPjH/Ueb+gGrSWvvAEq6ZT/gl1?=
 =?us-ascii?Q?jSBC8CON9eaCl5UOYVRDKnLWCrsXVbKI+5X8L3EbQnD9B5NEvAodUTW1IQa1?=
 =?us-ascii?Q?P064o3MyfsggNChPDUG11iOipK0VyRdmAg49/fTXhzvTLHbXo0DDkVQ3jWFz?=
 =?us-ascii?Q?z5xwgge9v65DuSZborRnqdjlkP4PRfImE2PeZIi//1ORxp23mQ300RwUtgCz?=
 =?us-ascii?Q?PwjNeQC9XfSnhVlfcd7zOQA7CIlTYCN3+WYLR+MPnWi301hsKzP2ReKsQ1qa?=
 =?us-ascii?Q?8AgduLJyyayN+qWchXEKuFFjAAuq6oDqPe/JQZYQNtWrSCz8x76ZcQv7r8qi?=
 =?us-ascii?Q?95WIzBcbD7SWgYCeAEVxCkD6OqWrxdoa7dZI3D3PpsvLXwDL8u9NC+zsj96/?=
 =?us-ascii?Q?OfN1gpi0TaIsypWzFD5g4iC6VQUaJ/fpwdhXsnhGF+OACT4zPcG0AM17Bwwy?=
 =?us-ascii?Q?KaB47ZKtJHGrWZc0R0+M65KkblASVXyi2kqcszdix8f9ysIk8UVzFJVwk3BX?=
 =?us-ascii?Q?HYEf9ZoJ5mhAVg2Vw+iFJZsY3Fk8Zxb0vjX/01NVJPDak6MTN/in4eUDs/mY?=
 =?us-ascii?Q?lklFuyTnxfd7qLF9AjL7MKot+2NFWZNcYGEccS3R7P3THsVuFM3/9w16/Yyr?=
 =?us-ascii?Q?4gt+bN+XSym0JIyl3ftAWflzPseh0ZBAOt8Zm+6Qd13bQiRtskwzN0CguHsH?=
 =?us-ascii?Q?dhvN76yfHO6jSkOEHAgjQOvw8NTFM7tjUkRb4rWfLDuPSa0NhjaHPVbpz760?=
 =?us-ascii?Q?FgFQVsQjBl9eTNQK3fUXCf2QCqi2CKm7PbHZEH7NM8RltKWeTD6da7UD01Ez?=
 =?us-ascii?Q?m4+UsV3HBw1THcuGDsf2gLKDgMfwIH1LT4ulygaFUsdvmcc3/ri10Mm2H/UJ?=
 =?us-ascii?Q?sUQPpn+yGt6HVg9XZ2KoQnMTuHp07SjQakK71pAq+hAJ0XnlX/uVPA79FJMX?=
 =?us-ascii?Q?QcNlciC3UxwKb804tDaJe3RBoaIBWKubw0aAEAPqbiJjSanU7j9raamBUhMh?=
 =?us-ascii?Q?n8Iw/0E9mUSCXnmrGDNzV/Wwtvvb+D0lcr7SLBoxjLFj5Cp169gkEGHHhxYf?=
 =?us-ascii?Q?Z1M7feOP2faoflS1vwEANFE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 205de950-c73c-4ba4-405c-08d9fb6fd623
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:00.4242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sgXf5O1ikXGyS7a8bZ2uk3+s5GojRhEG4Q5IgR0UreFwF8MyegiR2ESOSarMmJ5l1xfMt1dpjJKUQa0LQUEqsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: ZQI-uRKX8TQ92KiRz-XQq5RIMNqBhQvZ
X-Proofpoint-GUID: ZQI-uRKX8TQ92KiRz-XQq5RIMNqBhQvZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maximum values associated with extent counters i.e. Maximum extent length,
Maximum data extents and Maximum xattr extents are dictated by the on-disk
format. Hence move these definitions over to xfs_format.h.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 7 +++++++
 fs/xfs/libxfs/xfs_types.h  | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d665c04e69dd..d75e5b16da7e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -869,6 +869,13 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
+/*
+ * Max values for extlen, extnum, aextnum.
+ */
+#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
+#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
+#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+
 /*
  * Inode minimum and maximum sizes.
  */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b6da06b40989..794a54cbd0de 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -56,13 +56,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLFSINO	((xfs_ino_t)-1)
 #define	NULLAGINO	((xfs_agino_t)-1)
 
-/*
- * Max values for extlen, extnum, aextnum.
- */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
-
 /*
  * Minimum and maximum blocksize and sectorsize.
  * The blocksize upper limit is pretty much arbitrary.
-- 
2.30.2

