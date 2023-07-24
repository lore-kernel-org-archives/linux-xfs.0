Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292C8EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjGXEht (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjGXEhr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:37:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A453F122
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:37:46 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NNnXb6018552;
        Mon, 24 Jul 2023 04:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=aS7aNBYCuCoCy9DN+ETg4jVMG9CziEaLI/hvKubgldo=;
 b=CprH75KrtBB2KhdLfWmFCMgc4dLwdsrQBOm/wd75fLeEUqolMSmGhF0UnZFba9J2exov
 4icNsifC9DI0O1SVQzocfu3y+A78oiyUpAVyPLGKueMXJMSUNrCly24SvJWV46qaIkZZ
 v4BCAwlvrGS/+Qza7crm4NoDZ1corKC8Ek8QFfFeZC+O85zJMknnoSrENlaCyz63lA8A
 gh2Wrm9BohlcdhgVq4Q66HnTZu0vfnj81Db7GdDPp7UdcxtrroctfWxQQgkPe+eJ5Ft4
 om+zl2SInJLPI0Hs5D2JZxLZOKSwFDQqqeqY+8uACyxozWNFI50gvTOeFcubxbVxyXwF xA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s075d1u1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O440SG029092;
        Mon, 24 Jul 2023 04:37:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j96jjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kp+fAw+dReMhHJWpSEW8LMkh7wX0w8+WNqqHFsiUOcZYybKXP7+y4dXa18s6CgkBSP8ohqRn9ytj0gbxlyyPFkugnUXzFZ8fCBHZifiKvOM9uwOj+fNgrFrnlKXFYnyCgc/U/UdnhBR7WKyAh2hwmrIYi51TN6jrG/tKTLFBiRgylHb77/3zxTIcKctyAmDkRt92x6c6iDogmXuEsz8pkyB0YEP6TkySZpmilvR/IM3gsEUEf2JaPhy7FW50U/cNUzgiF57RjEbc2H68hgJQOsSNh1Kxy6xWXZKD48coiFNBRFPnRFq9ic/qI7T8v4wfr+ZhfOIFaGjYj9leyYA7JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aS7aNBYCuCoCy9DN+ETg4jVMG9CziEaLI/hvKubgldo=;
 b=PLHZtjBvMUx8liT4co4XTmrXydSNho7cYTss+7k4pppJms54wj++u1/pF8p4C0eal6prY4ewYLHJp8U/lgUFxwXb0Hf5GXxxS2acaw1N7KaH9/3z6+vUiiFDAEzZRc4myqAhpZxf7pK557v9v60mAx0+eI3HX8K8JdZm5KBcWYfRJi4jGL/Whw0DXvAcAjmfw994xTLZKIz0NzlTQXA7S8h4APNpaqKB7ZrP9AsalklG4ebrWif20T2lUtrtvZUsAFB4EnSZSsjujIgvWEUHZH/xQ43A08d+ekVoFuvqN5n533AAbpBabxm5zcSbvs50Xr54sPWiL6U/XsBKGW8XqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aS7aNBYCuCoCy9DN+ETg4jVMG9CziEaLI/hvKubgldo=;
 b=MBrhnv+mmAVfeMAlisggYioz20ZI66x5V6tvZUKo9cqb6Vpx4q+2YHIU9bn6azGAMZeWxpYuET1G/m3Usz58BcWfCt8It0347jKg3YcJVGwt9Bcmg7sXul7SJL7skiyP5WBLVSzoFjJUMLeQ+TQbV4njbXgJgQny6zi2v4D81ag=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:37:40 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:37:40 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 12/23] xfs_db: Add support to read from external log device
Date:   Mon, 24 Jul 2023 10:05:16 +0530
Message-Id: <20230724043527.238600-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0016.jpnprd01.prod.outlook.com (2603:1096:405::28)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: 46142786-2573-4a05-38a7-08db8bffb680
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TPG4MEguzD2G9yazJCDHjZuqeJTIYRLNImyYVsEBFTynK6u5C0uhKF55hB9YaSkI1UhDEXHxTvVJaKugcOS1tVkc9gVDi5mtevHmbxzTw5PwU7KhyAst3/QhMLoaOKG87V8rnYN4DHrmuO/fTR7nspeWMVx32nx0nJaeMU/9PVta0EyH8dLEdLLPKXKtNjm6Zx503jeTPu9P09y2J90TKcveZglUb575KCRuGksifcpo2DvF4uZOcWtwgAbrg006WkkvBcuulr47X0iOOIHgT7Qv9gOiS7CUzEK3+ZUf8WfQqswx9TNbOOi+wrfsXqzDishtR+iQlJPe+y0f7Mxs25sAanXIiwqsMD+7+rsF/KKm7d8432iFM+JonelYiVs+PDjrJU1G96w33ZDvm7jdaCEIo+/0oilzocIk9SU1vFCvkWEJSLey3k0yGBfrOrszKFFB+eR4c1WfowjNjtsBOwDgD1L2YrtXQ8JFvCD2negvZFHBpt2+/rI8VV1zccmAuNUhRhtpLzIhQArtHHgD7cZWCnmbY6SACkksoz8v1UCw0zAnmDeuO66xgLAUiCM8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vJL/V7J0VIp9yB+UkwAy3xqsXXP/qEUZsBmx1xL0exppU3Za3HB2IBkdTsZj?=
 =?us-ascii?Q?uVWyBMauiy67Qjqhe5tSQ0GlYXXsabdcYhjDc1NW5UrTMlYZ01SaqTzamg+p?=
 =?us-ascii?Q?tmcoi/hMEXnnYiMBckv32Yy56tvbItqluPvqdI6EhdNvHIJtPAKU1cALDHM+?=
 =?us-ascii?Q?WT3M2CM8INSp+BZzud/UdTP7KaSd+5ihUDLYLybRFtsr0QRHvfNTN+TS+yPy?=
 =?us-ascii?Q?ccAr1jQwudK3BZtE6cV7JXqvoU9C5l6qIQCHy5Cx56eNtW8ESdOv71IaC0s7?=
 =?us-ascii?Q?y0LwgA1ueE3duimO3KBF6zivcwiJI94gmrd3Y9/If+XpQu8/Y3Qh/aCHV1i5?=
 =?us-ascii?Q?Od+YTpXAOqSHEhsNjxYSIDvbB2YDlkw4OQwmdrTnMUnyUdz5Av1E0gG/IptE?=
 =?us-ascii?Q?M6/jxcY+9H7AzxK6iUitA9RfQ2UWkIFoB5TPQWwZxbuXWmXYcEGisTqpSZe7?=
 =?us-ascii?Q?94vOPBLCRaILnUwJYKJ5Uhsmbo8CsuRcxY1xfa/B1WuhvslMGUnGbu2yusG/?=
 =?us-ascii?Q?+2NzXfGUpq4aZZjt4MFPdQEEUA45iRyKbqESPKKoPWPbqREJjCPt5ity1ExI?=
 =?us-ascii?Q?zCJjHk1Xmz03MEX4YpK+RV7OLDyEEuwFBniHUGltJiZ7hzgBKZabZwWZB1Ba?=
 =?us-ascii?Q?ah3eb227tUwDd4TJ6hMwrM+S6xjNiKT7O4pWDPbfkNAz/2E36tvX7SKHnhGf?=
 =?us-ascii?Q?Y5X7AdXInCqFz8wU/EG6QVyaRWGHwRXsfSP+U5Eq+HwHWecMyD3wGEh9No+4?=
 =?us-ascii?Q?1VQYw5h72MRT/a7yhvgtTPPJyBgcdbBP6BJP+x5HfMA5Z+fPVZL7P74wAk6O?=
 =?us-ascii?Q?6ZwKHUb9RBY1k29l3OrQYz5MlS16YhcgZVpA7Xdob7x/CahlSIC0M+zQblGt?=
 =?us-ascii?Q?SCaIUpepQCmq3frUudjCHt2yyNYHSmGIM9a7hudX+iXJ0s00BSRsqkzJDyZ/?=
 =?us-ascii?Q?KsfOFLRLyajURRvw9Fr3OOgzFdDB/o8UDEcNEvVhzmYQ3Ff/Lzx+7QyC6zb9?=
 =?us-ascii?Q?FhJiICZnY9mg4Owa2j5RxK6ub3BDf2bvtZmyA9iT/sdm8UMG42HlFWRPWjKP?=
 =?us-ascii?Q?p8SCNO0wTIQvcWdGdSorCzmraHPfQV3hb+5i6Olol6ynMazU+NGVuAzY79Vm?=
 =?us-ascii?Q?Udacs7rWWoiMcxFWBAkuXVRYl/Lz1/pP/frUQLauxwoR1cnXl6h/mTOoxMsK?=
 =?us-ascii?Q?ZIpwC9UpD+JvcYleh4n1j38hQSbbA/0iP7EAiZk2tI34HDCfFloq55jVef/D?=
 =?us-ascii?Q?qjBKJ/Kke7ILDoeOjUKcYV/wG+2HtILj4TMRs9pBwBYwFaCECEVHj+3+39bn?=
 =?us-ascii?Q?+ra57lLDNxM9Pxh3XwZCLVAHqbYXTlSC1lbT7oDB1Rwtke73uqEwXgBaPGWn?=
 =?us-ascii?Q?S5y4kZOke5OZ6pDBUqDa8SMfrYWb98PLf0LXlHg/CSjDx2rDI8EFwZxC5Yyw?=
 =?us-ascii?Q?Lwn+m1E/6zoUDhuvu63jdQoCemPZWJjYX24vWQG2bzZx0tKneiXmA6XjJWaL?=
 =?us-ascii?Q?gLBpfOajnLJPeQWbbwni+8Cky8vK/Vrpnt8eomj+wkFChi90dOi2MRKDfnFR?=
 =?us-ascii?Q?tkCRMyeV5e16ZKrpuLQNU0grfEfJOTJSPWaM6fp5SwZldat2mriUF4yjp/rD?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nnpdAI5+NTmDtjvaJKmAzWrWFgFdV9Vp3jELio5xYbKGVlFoS8Aw/6YDYGtqUm+Rnp6UthEhgPgMFuk8BXlnf3ijUxghgdC/YvWOwFGcbluF8BDr5iPWoMo7Y47p1BEqLLf71WITGPUnfJ2rd6izSq4w16QzlRd3i5duSgOpBNM4NKOlNnAqogvnaOjkc4zbWX6nQzUMVhHs9W7wb2qzF48u1UvDk9EO1TN5LRYKn99On0ra5qbBrrLBq+y6KFERIr5XUGle59EOvW/Sa5fqxWHSagFHNXTFBGezVQ47/o2rrQlBolQ8c7/taAavQaUmMaR1OW0OWuBUz4Njdq2Ac2QpyB9isSRxZvTg36jG6iC+8ofZQN7oIhnfvD8aka7REk8oBkzH9oe3l4G6zK9U2R3DvfAkV2xkgIMpiiMBST/AD2794AU9G16zRtmvcZdxJs+7kgXcvQY2Ml33cQzcA358EIcgH4QD0nuzZFa5UGUwaUPTSHhTZNJ+iLr8KBoOCEdXgB+13MDgUqpfqZdf8tuV+/P/dHGC543RGZuJY72cukCIPm8Q91s8C9BqRNC56HJWJnebFzOCDYYUMS42aSfJK4oZkPIA2f83+B2fjM12gjIgD4dXImq/RcZVyb47sb1cYN2BjT3RQAs9SXOWv/YMKcLquvqmZ55xsEuvPZwiDdmwBWN0uJOxrA4wcknyEuHLluN8FGNkdG88FVRcya2TO6ZtMYFBhL5+z85cRoDNqglRveHSvG2PphFkFj7XnkaSnOLBQSWMIKvKItiG5v8rv1IrYx9JSyrs/NtpQeU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46142786-2573-4a05-38a7-08db8bffb680
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:37:39.9857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SRZ9tG0TaBHZtquxOi6GyQq2dWGGPJWniKKMzdgh49N7h9qo/7zuj1pRRAam12D/tz/Vp0174VNlW8jJJQTeNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307240041
X-Proofpoint-ORIG-GUID: dHNRbtUjZ0IIeiQZhhx6psjibckvo6Rr
X-Proofpoint-GUID: dHNRbtUjZ0IIeiQZhhx6psjibckvo6Rr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit introduces a new function set_log_cur() allowing xfs_db to read
from an external log device. This is required by a future commit which will
add the ability to dump metadata from external log devices.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/io.c | 56 +++++++++++++++++++++++++++++++++++++++++++-------------
 db/io.h |  2 ++
 2 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/db/io.c b/db/io.c
index 3d257236..5ccfe3b5 100644
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
@@ -589,6 +590,35 @@ set_cur(
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
+	if (mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
+		fprintf(stderr, "no external log specified\n");
+		exitcode = 1;
+		return;
+	}
+
+	__set_cur(mp->m_logdev_targp, type, blknum, len, ring_flag, bbmap);
+}
+
+
 void
 set_iocur_type(
 	const typ_t	*type)
diff --git a/db/io.h b/db/io.h
index c29a7488..bd86c31f 100644
--- a/db/io.h
+++ b/db/io.h
@@ -49,6 +49,8 @@ extern void	push_cur_and_set_type(void);
 extern void	write_cur(void);
 extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
 			int len, int ring_add, bbmap_t *bbmap);
+extern void	set_log_cur(const struct typ *type, xfs_daddr_t blknum,
+			int len, int ring_add, bbmap_t *bbmap);
 extern void     ring_add(void);
 extern void	set_iocur_type(const struct typ *type);
 extern void	xfs_dummy_verify(struct xfs_buf *bp);
-- 
2.39.1

