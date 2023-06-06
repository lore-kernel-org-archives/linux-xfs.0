Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E55C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbjFFJaC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbjFFJ37 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:29:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0C2E49
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:29:58 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356659Bo014649;
        Tue, 6 Jun 2023 09:29:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=jhn6nq6C7fDc9WQ3zD44XC14Goexu+Z166kOo+NIJqU=;
 b=AvulMe/GHsJo7sjruLdNY8gu15ISpI8J9LYg5Jzbp7k8b0yhgpmlsvuzNlzS1t1DcgtB
 fujANexjRivWFU2DSnNJOuPfadHyzYSxarM9mhyhlf8jTVOI3jerXyCW0xZWwkr/AqpE
 gQdtGa/nXdiDFLpybRVFg5ChTqiDSFRXpnu00lpkH0773KUyFi8uvpnir4f5N5d/cywI
 /ecn6g64g5NicBWLMfZxtJuufPE5JqKkRd7rY8E1B+zUj9MyhAIci9P2uH/oTA4/Zqhg
 j5O3LwJO4A/8D7aWLHx8qhAo+896JsTQ6QJoK6o6LVX1HRVEJsxHNoVrLrb4ubnrOfxK iw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2n4vpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3569IOgp010350;
        Tue, 6 Jun 2023 09:29:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tqcnxe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:29:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAzj2mCLXTn5VoKK14Hm2dJ7WnhDsKXUWWllAHFq+IkZ+UIbBc3JexBljGTi0Eyev1iVGk09fHt7M7KvmA0jnEesaa+pWpl+RFZQ1c7SBU3a+Y4Iw9PEUTI4Gg7gTOkMJtXHF4YWVYhswbmur08+LoAbAnrsudCGeQRYfpFeTQmM0zC132Z85Y8ueO/4QWc8B6xrCZX5q3hFNVYd/HebPWq6yq7L7fQG6eaPKPO9RTyt/HNZ7zMFg78FnCCYwX9oZLGWVBbIfA/NnV/s7tZ1ZcBSSrxbYnbc/JbED2HCik4jH3P94s4M8hRf6HIG8YsouivBseewlwe9RrjjJLlJ8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jhn6nq6C7fDc9WQ3zD44XC14Goexu+Z166kOo+NIJqU=;
 b=K57R1hTLMVnwUKVe8Fcoy8rrWAlcrldjfPSvnTMvH+AXPAorDwAGTOiJCo3qSEZI3cgGJ8IOWl2LrS71Zs6CQuVJ6LhUWmPP1X1hHQJG0NzfurvgmdPwyAB+6x9ke/uWi1Kc56enZTqM2TOoWsHZGTJ5Vioj+O3WqzdkJkbXwN3gwAgQEJFpxKe3/XWJo64Wr3o53InOCH2L32y3ywSoanie71HY1WGw7Yu4rDCAgyBsJIFYFT9QdNF0KW9Dz7r3TCGxo7xFnLQFwxHiSecVCDwX7xI/fj8WmYsWTvKQhnldh1D+56JparDnFeO73lNdTtj5LeXFBJgzhrWHc9hBlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhn6nq6C7fDc9WQ3zD44XC14Goexu+Z166kOo+NIJqU=;
 b=s2gGJzfRU90LadKZafBlN4Q9iXhad7iX3M+fvJHiq+7f3yflVP5GEHkN1t34ROY+8E8GvLqRXSmplZIKwBYCRUv0hrQ7n0rfP1CC1YYchAMfU/qXDVSmGYCosRHeoZyBaUdjrLuhF8Gpl1ha03AIeKouaYo8kbf3vRq+wVJ5BHo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:29:51 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:29:51 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 12/23] xfs_db: Add support to read from external log device
Date:   Tue,  6 Jun 2023 14:57:55 +0530
Message-Id: <20230606092806.1604491-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0328.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3b7::17) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: c95846fe-6826-4356-7095-08db6670941f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EkOS2DLz/9Txn3+1bBb5sP2uTqygFCLJ0s1+TXFtQIaX8xyk2aasnOlkHHwtwzaauWgXxzoG3FYoQVvIqZolmJUQoEAqKImYLAAbhIRPmJHuU3FnnFKWG1KjtkYu10ICk73WLLTZfeFMb7gmn0iFIOAs8nrCP6wony2dMuKrol+dLS/8OAGJfnrPfiLtXerUFeVU33B7nxXS81lrpzZ5m+krCmCF2kxyr2EECIXhGgKAiNsPuiSHiadooFYvKKJY7J/9TZhiMcW3O4Ivvqh0C/9uwsnv/wjtRa1XrQ2ClytQFJEHUz8uDGt+yE2Ejwoi1ryoMwYh0cMoija4O5WUjC9G88LQC4OZbR/o9j6TKqnZnT0AwU1INn6ut/g5cNtGdRwcU7tlXrdFGQqV6EPX2Yk7I8cJGsVvo9rzq6JWnvSmNVqqV0CNNO3/qhgF+5Lklrc7c4xzAa5S8rwenDdXMF55fXK8uSWk3DCfgiNCS2wL3NuLUru66ICNNjhovkLfMDIz9GQzh+2fjySaM6ZOH+FnWmqETHsKMCxha45R6+rP6U7/0nUF3y6sqQemVrNi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Px4GqF1/v3ZindoRQ1uLEmfv9rrk243HlQ9QU6yEE7QpKUX3Ymy6NqoaEL5D?=
 =?us-ascii?Q?CSRI7tlVASJB5sT1KJG5uHsBigPnnXG7k/iwp65/HdhauhRgBb2N0kn+dqRT?=
 =?us-ascii?Q?lRhF5hPuFEGw+TFxYI6oCzO1MoMGmG+iMgTkKHQqgexOlTiBM1E4ZvXSvDcc?=
 =?us-ascii?Q?skVDeCUBoWcx7gmCVw8MHcB9p61VUJWFUnjt1hcGLnQL/nUSWo3xmFgj8rRw?=
 =?us-ascii?Q?zSeyAjIEwv1dm6LKqHT2slVM8y14m9e0fzpp67vuNxOAsDIUbtJwKdg9Kmbx?=
 =?us-ascii?Q?qSWvCICpDRF9XvTaieHq5UYx8jZiyO3MhF4Lpad+aS7UUbgWhX0og8zwDvZe?=
 =?us-ascii?Q?SpLUJosj9aE7G6o/2tjRfUAqOrmBWv0h9pjCE/etv1EEr1qSjKRPbRCIW1Ey?=
 =?us-ascii?Q?Ffd5nLaZ8UeiTV9YOXDDOyGWyQHdZSwRwI8CJgNNdRpwHSZdrGbArLI1ivH6?=
 =?us-ascii?Q?OGxkKe3zRWzCuGbPxO+IL2b6f6iMSuFDc0Ulw0yjvEL17FUrfBSFdZzQ0RFL?=
 =?us-ascii?Q?wrA+G6Knc4cr/zpNb6DgW/qpDXfKgGnLICaD37Ls0hhBvArLDGKxPWP1S9Cw?=
 =?us-ascii?Q?aEYAmxTMoY4h6pgNCyCA5Ov3fuwbMzFdfl1txMjgZ78OOJUxM7LzB6jU9qA+?=
 =?us-ascii?Q?JxNvldSYdDdiQhR6Oel3i04F79ylF8w8y1I1JMrRmcSGof3lHsYkqJ0w07yi?=
 =?us-ascii?Q?I0KzMYFJgRM868jtcmu7ALDYxV0ELe5bwng3cLkUPledNP1iGrLrIV23aWzT?=
 =?us-ascii?Q?fySGnzEn6rVVUElQ3FGEcQNzsnQNDRFV60eAt4x3Yzj9hjU6xG2vgB0sxveK?=
 =?us-ascii?Q?dg9+l4516t6ES1+TqIG7aPvWrZd/ZGL46PlWbAoH02J0JGv/c0zy/2+7npOG?=
 =?us-ascii?Q?JDbZnyNMiif9oYMrkkWuQw1udYsAcXsKhmSrA8kDe6uxtJ7uHCwQksLD6Pk5?=
 =?us-ascii?Q?32B4k5EYPhK3XKGMcQn1W4cAhcHo0lg0oV/POAPKDVzoZEFmnCXgIu/vxgys?=
 =?us-ascii?Q?H9PmuOeCP8CtvpokBy9ukSU7TA5jZKUmj8joqv76/jTA7vO9vuPlESBm7Wrg?=
 =?us-ascii?Q?WeLMxwOpfbPhWWVS+wh3/bqaLDisR4fD1jiT8nz6cpX9MMbwn3CfrFHF81dG?=
 =?us-ascii?Q?lx/4R18gVtR3JNSgz1aHPUFKk8IypDK/u90yoTnRqCtWZblm8wby+aAtEDW7?=
 =?us-ascii?Q?LOrlea/zeMQJD1QskaQuttxyjzDpwerH51L/XkNm2RmeAhmwisWPMlhFPvu/?=
 =?us-ascii?Q?+aSkoTkgFeTrgizZCuVgoHs5PFzFw550SQPYpN/d/5ryO9skYlw3F9FxxnTy?=
 =?us-ascii?Q?ag41gxmR7VOBG64p3DlgLtV29Mpp9qBsVqIaihPzKZB0YU/uPEuZq0DeIZwI?=
 =?us-ascii?Q?H0g3jhwZt/LnnNAZD8J9IS1/SrM3Ljlm5IqRUGi+2963k65s/yWv+ncle9by?=
 =?us-ascii?Q?760Qg/vKEGPLtrZKMn8yRq4gQCoPUndvwTq17uUo7Uyxp5sFj+X0DRge1+Xb?=
 =?us-ascii?Q?lTKcXcJ20Zlmar8dQar+iNeO2euGymQzBxx3f8gHp3/29ILwvYnDGAIZbMFU?=
 =?us-ascii?Q?RRjMueRQM6gBG8G6PgVNIMC9fuh+HjB/pikQBPAbwtcl0KJSUYkBHlELGs+I?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KWW8z7k2oXVR/BLlszWeDzaeP2DZ9irTQKh2P3jE7qNGpVOLvUkTsiG7u5dmJw0F3z/uV875k0s5USSVaqN77g9u8wjQjlsKI2tNRYoqSa1t0infBcDYQgwqCPC/eYbwnV88RW6/4kQJ9VU2GswNa5OqKz15KkZCMnOplRjFx5lpWXMKfKgjY0zHb9O3Un6+wcv2T7XjWdcvCMZj+NOk6+g7x0fXWKh8EDkgBkDAfxOCECv1MtPEOlWIHVqZHufR8tckdM9RR3qO6fuTKGI2vREi+0bqZYMtLUxsqeSnH/EbyckeNQhL/Vj5weCs3f1281AWSZDwQZNkilV64x/YJj6TG1aaLUHBHZCvYzWtSYRFHl0JTueXrGlhpVZqTeBSDyYxTLhd1elzNlQDGcWhb2x2hWx8pZzWGhrvm/CCjb5zRyIT2ZtQ3mICDKyPtIxrnA/O6327MY70l3UxjHpdtrbuthzd7vsJFSgclOTJRIN/mbOtySHGuuFUvUA1O/7zJg1P85YYdQAFzjEPNTgeFNp35zOn5iZdg2ZgS9Y2ozyMmErc5rTGK9e8F58K17Xy/7ZFZTAYOi51a44BXOQMODTAuXm15HiMWnRJ4579HxrD0c6z6q368IOUWdEWCEvoO6Oq9tWQawmditZQ4GrnjA39VJplk162K+cy+Z/7iki2FVL4UJuATKAQfLd0G6jBtKRrpBePfUcg34fKf12fdmCH16yoq19aC4Dx6tcJ1UMmu5Qg/DJKSfzwoBrMa/zhQqB26YjNsYTOMcnt+vBq4M0whr014fvSfcAnnbEBbNk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95846fe-6826-4356-7095-08db6670941f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:29:51.2412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZuM4Quz3QhtkTM+KIv6Ix9P/+O+7IGo4DEB3Fw7fbwuBzuF4YSDDvkALwiExuKcDT82zebL3YOm0VpgawGEl4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060080
X-Proofpoint-GUID: IXcc4fXBRVr8w6fvIgt3RPc2wrJDdJHq
X-Proofpoint-ORIG-GUID: IXcc4fXBRVr8w6fvIgt3RPc2wrJDdJHq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit introduces a new function set_log_cur() allowing xfs_db to read
from an external log device. This is required by a future commit which will
add the ability to dump metadata from external log devices.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/io.c | 57 ++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/db/io.c b/db/io.c
index 3d257236..a6feaba3 100644
--- a/db/io.c
+++ b/db/io.c
@@ -508,18 +508,19 @@ write_cur(void)
 
 }
 
-void
-set_cur(
-	const typ_t	*type,
-	xfs_daddr_t	blknum,
-	int		len,
-	int		ring_flag,
-	bbmap_t		*bbmap)
+static void
+__set_cur(
+	struct xfs_buftarg	*btargp,
+	const typ_t		*type,
+	xfs_daddr_t		 blknum,
+	int			 len,
+	int			 ring_flag,
+	bbmap_t			*bbmap)
 {
-	struct xfs_buf	*bp;
-	xfs_ino_t	dirino;
-	xfs_ino_t	ino;
-	uint16_t	mode;
+	struct xfs_buf		*bp;
+	xfs_ino_t		dirino;
+	xfs_ino_t		ino;
+	uint16_t		mode;
 	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
 	int		error;
 
@@ -548,11 +549,11 @@ set_cur(
 		if (!iocur_top->bbmap)
 			return;
 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
-		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
+		error = -libxfs_buf_read_map(btargp, bbmap->b,
 				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
 				ops);
 	} else {
-		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
+		error = -libxfs_buf_read(btargp, blknum, len,
 				LIBXFS_READBUF_SALVAGE, &bp, ops);
 		iocur_top->bbmap = NULL;
 	}
@@ -589,6 +590,36 @@ set_cur(
 		ring_add();
 }
 
+void
+set_cur(
+	const typ_t	*type,
+	xfs_daddr_t	blknum,
+	int		len,
+	int		ring_flag,
+	bbmap_t		*bbmap)
+{
+	__set_cur(mp->m_ddev_targp, type, blknum, len, ring_flag, bbmap);
+}
+
+void
+set_log_cur(
+	const typ_t	*type,
+	xfs_daddr_t	blknum,
+	int		len,
+	int		ring_flag,
+	bbmap_t		*bbmap)
+{
+	struct xfs_buftarg	*btargp = mp->m_ddev_targp;
+
+	if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev) {
+		ASSERT(mp->m_sb.sb_logstart == 0);
+		btargp = mp->m_logdev_targp;
+	}
+
+	__set_cur(btargp, type, blknum, len, ring_flag, bbmap);
+}
+
+
 void
 set_iocur_type(
 	const typ_t	*type)
-- 
2.39.1

