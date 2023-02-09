Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261D2C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjBIICq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBIICo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:44 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A356B2E0C5
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:43 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197PxV3016268
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=VwiWWfWXG177Gwi0Y5OEGfnBjOP1g5QYuW9dKH3bVjA=;
 b=kAZVntFqNy5rQRgKMJ6MhPN5lNCNVZX1W0cwmdKp8egfx+gVLu2yt31PFsR3VcbvYpYM
 8tQkIjjWTLT6PZO2I7pqQRhTT1CvhNNRSd6KWqe7eXRCWOQ1dGEnAGCXNgc3xKMELJMK
 bl1gHhjMQ45/ROA6Bd6TT1AXaL/S4deUqe8bN7qHosrpppd8Fiq5Fj9+36euxVB9Qp1s
 XBDQgJF1RZNa3eNmB0x3nIuUwLJQSJbcAxYTHE1Ln55IKSKJgnj5wEDUw3oyhxxw3tza
 WMrujTO3akiJZ2yqXrNh1NF1lnp7OA9TjM4vMGmRRT+cR7q7X/Ongmb8nh5DUWNn70FM ww== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe9nj4em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196jIut035773
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdter9va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGKaIxXHgM0p0wVvHUSa7/5/hhgLZOu08ykaAyskIHH6awHeY5rLr5/XyoDApZ3+hgC12cCxhReLfGxjcTf7yUdZveLLWo2w+eSQyx/qb9p3SD/DW+WQz58TY9vUf7b9wolIXJ4vuVfXtwGUAYhe09TrHrWbqSZCKCwsXCsskFy6xxozr9mdbqifoAjwywTbbJ5xx7K0M48dNEjRjt1pMiDMh4P2or2tiJu7X6wQKCA/Nfj6CDGNumchEumA6BvMHku4C/jacUj860VyP0gJVZR0PcAvKOisjalAviGKfl6YzkAEmEbcJGgn4wb+/OKDqhFefGGKl6aM+OXLtZE9Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwiWWfWXG177Gwi0Y5OEGfnBjOP1g5QYuW9dKH3bVjA=;
 b=nV2b4o8B11d4mFTQujvZ7kfN6gi9VlWUpJaLEK+YLMXmQWu+0i6Q9WNTmUYC7TUbG7t8vKSa0ZPIUj4INkzOgN92GB7vO89WuJbuumoI4KPicT/xSY0n+SzfzdzyGYCM1Y//SnzoMzorjgBviEMeCzbBn7izE0Xw0Z0tD3I5OCHAj0m4UZMZRP9PpNubraIZsxvjEpVrmCmIMJGT59phPXPHfNWvW+ngI+JL7SVa1qbR8muNjaDrdHKZYrwiv45VDpXHOju1GBr8H0BMcxwp1yeLCcN4kJXQniNr+pmHSeaSQrMKH+XAMrdN+MH90nmeLd+pKBHxfYoEiTBZKsNmvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwiWWfWXG177Gwi0Y5OEGfnBjOP1g5QYuW9dKH3bVjA=;
 b=P5NepUey07ixObgWyJJCkc/CqbA/10NEcge3JwmHv07kzkfN3QneF/o3gt5RR92hrdZt5o4OsYq8lwaHU9ZaCsbLQfwPjOzUT+olzG1Y9KyrPCn0p1sbH7ngU6BBszOOuMwJvnuuYfz3Ot9awvPUUZfMtbWJh9RpXU/I4C6uWa8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB5095.namprd10.prod.outlook.com (2603:10b6:408:123::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 08:02:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:40 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 28/28] xfs: add xfs_trans_mod_sb tracing
Date:   Thu,  9 Feb 2023 01:01:46 -0700
Message-Id: <20230209080146.378973-29-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0229.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BN0PR10MB5095:EE_
X-MS-Office365-Filtering-Correlation-Id: 318ff12a-b990-40e2-20b9-08db0a7403ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JpL+VEI+pBO0x+m262kkGRJbKPwI6Mlo9kiKifaFkB40QmzHVl05Gi/M8LkPsvA8NWpgWBCX8PAwOL58U2RJfwx0gNiGHACVLLG5F7uYNMegfQZsKY0yc6wZHbrXxMAn0LfSUHxvBdCzHYTl0zbHIq3E2qQK8p7ATfZbV6xiuJLngFa1nihDbQbeB8FE6BMl9SIXvLA/WPsUr/EktHglT/nhMNj5zLZbo2rkge7+DiO3wmFGn+lawBh647Lw/6fsbDdu3QbCC2IAhkaNXtEvdL+RZzDajTinXFKNMfcUq05nTCsRaLvkkh3kuxRDJVQk8fxdiveCLQBQ3mVxBPcVC9fQwH8S3wuVz7t5HZ29cwhHpec4H1ViM3MTW8YkTnqWNG/Aq6RFWpLuiuDphj5HuNzhW5FfeBaYaAPsmZ6auNBNWa8hbUrSzVzaKiVK1XgWrOIrzOss4hcFPz9RodOiQIKG36Vt7n5zxpwFrr5+MGmFWpoYB67Tck2ve/Gk9pVfTYuVDOZewcSuSMocrOIwYhpTOZYQWHvH0U1EG6syUJGqc2twCP/U0qpt4ZBJzjj+fV6mdwqzHm+FSybbSFkI7khYD+0Dt4zC9INqTDzgkXJ6dw+QGYGwiIZvK3QqW/K3gaqO1p45CyIP5hVDf2pNwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199018)(1076003)(6506007)(6512007)(26005)(186003)(38100700002)(9686003)(2616005)(2906002)(6486002)(83380400001)(316002)(41300700001)(478600001)(8936002)(6916009)(8676002)(66476007)(66556008)(86362001)(66946007)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h64fbX4BtLNjQe5b9hf2Sg9h26cExdDJWEX9/GKv106TQWDh7Jhnm9UpQd1L?=
 =?us-ascii?Q?SE1nzfoHLQybLm8KA8FqmjQv7mjfkluUTjQgXUj9//HTkpVsJuhQc8+ysGiS?=
 =?us-ascii?Q?52NK04w4w8taUWOZLI5cffuSrSWxZR5BpPdZY+FA3hO40tbB6C9dX38K40+z?=
 =?us-ascii?Q?veco/UB52kbt8TzQFKdd2ecWy2G6xCXfTPaci7UM/GHMjEqcHmjRbjRcuUFn?=
 =?us-ascii?Q?62yYqLPfgal4Tjrw/+njpWjmWShUoCqc6BlKOcddQnQNvC9IplT+/rLGIHYb?=
 =?us-ascii?Q?XoHQY2aw9EvOWcgFHCFvOQrf+KpQMmOhlTzcdj98jqciYXvJzW7jT03xtAfw?=
 =?us-ascii?Q?0xp+9oimOx88HNE3gMgaTfjmF/zXtPGmc9y3u6zTFjtJQ3D+3TdP3R5PioIE?=
 =?us-ascii?Q?uIgZvbPlVMsS/5QRiQbCA91FHkVZs8orIDnGNjNPUIogZiLhiguJaAHKjasX?=
 =?us-ascii?Q?cBp8ZWp20EV85fTcP9bWZdiO0Qqq6hNMlYHpMxzM39EKDblZvQTJtiStmGiF?=
 =?us-ascii?Q?yXB3RmWoIF3SZOXWVgdE8cOyuUcUy2CLTxwBXJwOpy2Z8ff8DN7eFul6BqXJ?=
 =?us-ascii?Q?aRfZ6dJ9IiPMBGohmtWg1MV8GVGeAE0+j2WaRlrZFubFtCrzk73Pq767cMv6?=
 =?us-ascii?Q?iLaBO3r3hYb60i3zRibfxHmHE8rMydBUYvLpQEzZFt/LcUm2EqgCVo4VbBl7?=
 =?us-ascii?Q?5pFa2kYGCzeV/aCpjIf3DAHan7eoLYm8vTLe2fYxoFt7fZZYB2vV0QnKiD0A?=
 =?us-ascii?Q?+EgpL5MOiekcdTcHhnpq8yN/s5mrzrUMYhP15L8y8gNUmYbxr9HVMXmOsOAI?=
 =?us-ascii?Q?gpMkGf8FlDeDcbNJKpwMaPhDux8CRNkBSrtYUSQTTHLcoOM9NZFcDf0GISbr?=
 =?us-ascii?Q?yRIqfuF0RKjFp3z/wGITSIS6CfgfFZaZ6NY8/pqeF4nqameAUewQTRmaDN3m?=
 =?us-ascii?Q?KwivfBHIs9i2gbePx1TJNN/Aik6BPPfJle2yYDOrCmVooRcKCPhM3K5isULd?=
 =?us-ascii?Q?ZxcyK7JxdXtL8ndqJ+bDJDaC7Appv93asNJY0hsIgVYLzuCD//mCPLkh8bUx?=
 =?us-ascii?Q?CimibJHXRZzaPAb6I07S5WNtiABMjf6o9x7XDb02baK39b+gawH7UoP7fPzl?=
 =?us-ascii?Q?XBq9JT1h1qSOumIwhNzZb2MK6ni1Taiq4RQ5w0ILNMbedrJ1ogaARDhRiHoo?=
 =?us-ascii?Q?Z2GWgABGFo09ZGMRaSVRq2OZZiCS0e1U6NIhq2Ljkga5GOJzF6AINUUp82tD?=
 =?us-ascii?Q?sAfCu+HUuNMGfCOqpfBkxhYtWkmhnjMoBpvzM1vHPDOhO6U64pWh2bpj2MvY?=
 =?us-ascii?Q?vKJoqFZ1QwlgIJiaLRJpA7QXTRO3Kt3VUyajRXzmKKL4jr/miGZ0gVzq9ZEz?=
 =?us-ascii?Q?EmZP0BBEm8pLdO/w/vQ86Ind5TnN94ERJxwxvWAaGDa3+lN1Fl6f7DTSdPZs?=
 =?us-ascii?Q?zPGcQIpgR+JF6qKT6LuF0IGoMvbZhBYQGFBp5MC7Vvlpr+gP4HlO4rpSeTBA?=
 =?us-ascii?Q?nqbNY3auvxr5Mcz7BzdxSzI5Zqqc//n6rDWeIBpN7ycEohWz58TrvU52lD1v?=
 =?us-ascii?Q?li8fB03+o8mNovagOybRZMlEhJE7d+a0F6D6MzaGxCGzp5W+6IKFIfshCB+5?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MhwLQBdIGr22PxzEEKRDToYnXwkJO5AfuX2XXoNqA+LFTrNkmUTkvwAxHELibhFvwi95E+HiSu1ht+Ytzb++Z+jwm4euSkHarasEHP+OrXgsTDkKKfGl0yG63IRrF3h2xRrm90WVwHgwAYCmZPn2LqqtrjknIilVVqkE0GaLWMqrXfOxoY4ju5+Wu3nJ3sBUoCIwqIwy9tVvjMzl1mQpma0PZpnbo9o5vLaM6KXbK4FTwNA4XhBX31vUgh/IA9PfGBFjNdS3VTBCulJjfzbIMoNOYiyp/XhNklSYtgq+l0pK2Domo7dWq/oukVW9aRw2QNlnv9OTJFXVUmBipTjyIKu4dqVc6EgePJoW19W2DFdXnXlGm9ru0VxQOXPEN53rQFR6wnj0jGSQRhWraPG9i9XQlPIXfuimTmClwUv2qA67dgYSy2ZozrlKMPyo+UXIHI+SJL6ExoZhH0AJw2HPVjOw6eLzopM0JCpEW0TzJP/+air1QyQWFi/2Tuwvm+FOwF+eVVSnuKqIwxSosrkYP2hpYdpL7R+1IM78euZ9wKcSQPB9DmnTzVOQ41Hjvp36tu6idkluFStYBV/Wg2rOsDgFY2hPx65rFOtCZQHCxO3Jsh37jJrxdfCsZzYoL+SslTmPu523BWr//whlWVbp2r5EtjqMb4vFeKhDIHEg3531hrYXaGNpd+I/YgZVSWF2/zzkT/GkKR6hiCR46fzNyYPV5qhX1nkNhf7+fxmVDx0tY3eHiBMgh0aJCcBAmOiK
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 318ff12a-b990-40e2-20b9-08db0a7403ba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:39.9957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nOsYaC3SGlIJFnwfLdbpyQ//y/7MgidBTHCHwuX1Fd2T+nLnII0pSJg+u+y653mz4Lr6NQ5M1UIHCvA+oNCv1tYpTw5YVJ3HSUsTJf1txHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5095
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: fmk8-lkFkHuXiifdAhXNJXkyW3OqPXsr
X-Proofpoint-GUID: fmk8-lkFkHuXiifdAhXNJXkyW3OqPXsr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Reservationless operations are not allowed with parent pointers because
the attr expansion may cause a shutdown if  an operation is retried without
reservation and succeeds without enough space for the parent pointer.  Add
tracing to detect if this shutdown occurs.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_trans.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 43f4b0943f49..bfb7e87e7794 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -375,8 +375,10 @@ xfs_trans_mod_sb(
 		 */
 		if (delta < 0) {
 			tp->t_blk_res_used += (uint)-delta;
-			if (tp->t_blk_res_used > tp->t_blk_res)
+			if (tp->t_blk_res_used > tp->t_blk_res) {
+				xfs_err(mp, "URK blkres 0x%x used 0x%x", tp->t_blk_res, tp->t_blk_res_used);
 				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			}
 		} else if (delta > 0 && (tp->t_flags & XFS_TRANS_RES_FDBLKS)) {
 			int64_t	blkres_delta;
 
-- 
2.25.1

