Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972E1C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhLNIrY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:24 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6536 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231742AbhLNIrX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:23 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7QMdq004125;
        Tue, 14 Dec 2021 08:47:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=uIrdsVYwm0BnHC5NNMCHUJOzUPKtAm/+q6squx43amk=;
 b=nbxffslILL4qj7/JGit1vGxXzT6GCWiaoslyuRzzORcmA2/cyIOVrtV8WZ6N/PWT+QX3
 h3LPZOHUQ0wWOTJD/zh2Q9mSA99Sao+8ZVOLrmWNC6XA2YRkQeE1gx6T2aydCuHerrDI
 06+A6hldtJI8ZT/1TdDS1Nx/kbfvkCn/szL1j1bmppymihFA/pjxY2fkirKFmCOJApVK
 VP5oBLp3G+SmrACIZDnA1sQoUHiszv+ftmlZ/C9fcbeVTgHTVKwlTQ50TIu2fuLmcXrh
 61RGDfk59kiOPq6HMwQ67VQDH+lVNWmSUMF8ia81hBbfAaYAn1V8GQAruTzv+dnM1W7t cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3py3380-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8eR06074137;
        Tue, 14 Dec 2021 08:47:20 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3020.oracle.com with ESMTP id 3cxmr9ygby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:47:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxWfxD/o1tuhNVrp2WgcnrHoHym7zL010hymD3FkRsGy+CmGGN5pK+uMS4/UhJu+B+LvRNpwrTqtqCXV4+rt19+UCMFETriE87Vg9GSrnyilJnM4YLb8kw0D4dDZm8Rb97Z6o8zJdUWSG6TByBDJUjUbIFAvSDXnxofCq3a6bHVG7OpKPsnLEhFHCZkhG29XWSTfPgZTROFmXFRlZ2f0scNY1d97FPartDY7jTtlFxmT3xvfgSRoXKuoaVsS5vtHEMG/2PlP5MX+svRVojN+CNpwNsme+3C6/g8Obz5zgH6ET++Utp/d2cl0Up1PY/TmX4cBpF9T3smr6T+eHngo1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIrdsVYwm0BnHC5NNMCHUJOzUPKtAm/+q6squx43amk=;
 b=bbEwkZgGrssANvsYEFGvLJ7Q6i9C6zFkGNAbUfsH4U54Eq/AssB7MmUbOVuocx6ocAq7tGLpU3wcMA3YhKRIZJWgOw9nqmgPOTOh9SKKqdVYZ9BxyDcHszfVjGN7bDOO098/gE/c4VCxG3VUeno5bof1lTWeUdCBEZB1h/eV+UtIkyzy3/OSG0gEjLiw9TTO4k4wIJeGHiEk1hnmsIJl6H8Qpy0oo29JWZi+u6TawndkIQfBWL/1AIk9PKweHcpDeqR5Eqk+BbXPM1e2LZyTjKByTx2PtzUQXukek7ZqJOdsgucUNKjipER7Qp+k3iWA5SPbH/tWFUNtTPz6bBZFSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIrdsVYwm0BnHC5NNMCHUJOzUPKtAm/+q6squx43amk=;
 b=Z5BU1kOeCqBaarJG0obnZhJhqTAoIE99D0N56BWb3ZT6y1t39PiBAvF+v5HRbVMMsS8U+pg3EzXMjTE95pwXdFHlWH3RyQkdWhpyKNPQ2931EuiUF2tJIJNYtg+T31c6vdf1gomtmhiuXPgDxqHgBA2ssTf931Acg70DKnbq52M=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:47:18 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:47:18 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 10/16] xfs: Use xfs_rfsblock_t to count maximum blocks that can be used by BMBT
Date:   Tue, 14 Dec 2021 14:15:13 +0530
Message-Id: <20211214084519.759272-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084519.759272-1-chandan.babu@oracle.com>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43277a99-02b7-4e94-2360-08d9bede55ea
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB305480C9E7DF7836C0A56E6AF6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5vFuiF9KGTub8gJVNQzZ0W70Du2T8Sv98frSBvHphCy7LIJWqc7pkhA7G2z+seJO8LLBc7VmVzFAQ8WW/gcmlAyVcVxzfU+Wg54rygOgszL/XOq5jFzuet4SuNjUfMvEZhRNgVnPx+GI/rr3EFVsN6XLgdd1uBXchzSoHQ+nwStM5ak5wtPmMN/tF194J8TSkYTLNp7YzXk2+ueCARtbK3rzoHUKhMD9NYVP7kthCjAix2rD5H0WBVlzjsB1bk7plHH8uSRL/+OGyJxUojYKHOqowUxqNqakpEw+UHymWdNii+CwWZYtRRV2nn+tGlR7jsB3Gq8Mwzx5cjalKE878bmVo609o108HWtDitw8XS4z89+/BwWQXAW901ZCi/kjlKUfoE60QAZtbPkE3+T8pv7sP6o64+7t1E53njU3LCfo6KmdPKsHOctmHTqGaWHoj9YHf9iuHRg5Wi/sToYkXlHU+VApP/O0Ng+lPXJBzPIBtKPU6bwDW38PkiqcF1GIZWTOG48V1coBbIpseKMCWWeJ7KLKIzr+ubXsw8C+ZOcfsA33bYVeuYfdn1d1TEXTPeYJy0q1nAbXOiFJVA3AmZx61JWYAFwO30VI/Fe0FaR9rYJrSMpRJLIoukoOkFhGCZMx2+UHJXLcwUA50NFwaJ0zaEzpW5WAu3R03cnRjNWuygXPlScqNMUEGI2Pjamfh68Ki25xKOVsG1dcL0tsSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(4744005)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(2616005)(6666004)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KE+nqJk+EdTDcl1nBQhjXmLNV6INdqsPlbbshPU6s4Y84WkY5tf5eCnubvdz?=
 =?us-ascii?Q?ftglLKLmgC9jzU4kseBhWQtieX9p8ERE97L3uCmp1yabo5kKjTTJ52zj5P6A?=
 =?us-ascii?Q?IENjot9hp2XflU46zfR3PMoKTk7G0wk+uGmgB609mh9I8+ZWIby7C2lI6nBZ?=
 =?us-ascii?Q?39r2gDSgLcFYNbJRZTs9QlpgaDKMbdP23ULe1t+VF+pyuzfyxCf3kAigViZV?=
 =?us-ascii?Q?vm5NPJe9F9vosb8NQF5tK0o7/XMamdO7U8Wyt8GGqgHtYCDHOd5Q1QPXbSTm?=
 =?us-ascii?Q?FnDpWK/8Ks83NXMZ2R9N0yD6+H0++Q4F+mgndIMsW2krc9Mfdhi2e3U1HoAb?=
 =?us-ascii?Q?4UjnLz7QUntDi07/Qg9UtDL839oeZo7UuHo9CZlKS2g+6xt/IeOIprQn82oK?=
 =?us-ascii?Q?tFiTCV8ICO4eizPADz9eFvlr+RLR7KkP8yAuZ0zZNYlVPVTgYr4cXthubRym?=
 =?us-ascii?Q?RZcchg4jCthd8g8DvcLGrMvIx/a3NaCDjCtRIsquLCeMVfYFk5dudRkMs6ZI?=
 =?us-ascii?Q?GcO/KNTCEcIrcRoRPP50gJfQO10/U5iQ4VKHJIppG666Ne8WsfhBBn+gcXTU?=
 =?us-ascii?Q?28xNiLim0NxJ3NU69usN61LknpS/5wscWbnGMFKangaL5s1GWaIWmWOMO0e8?=
 =?us-ascii?Q?Voqr/xQLtqSpQXeCd05pM9uBOV4TttN+ZPWMar2vCG3DLjM2LVneZZbZmLTL?=
 =?us-ascii?Q?X7DRjypFJesg4AmfjLqQgix8zdjlbJqC/ab4vKeW66nlhbtMZbDZzYlrWfzq?=
 =?us-ascii?Q?9Ju3KtGWFj+9U9z6AFs80Z6WpQTjwrifPQFWaOkF/sRrOxDpqh9gQ+UWEacZ?=
 =?us-ascii?Q?PLs0b+3S2zApNTJEL0UfPx5DeAIx3YcvP1aFAkO/qWVnlMWMFyPMpYuZxa1c?=
 =?us-ascii?Q?IDQQAivgIQ7bBxkpc6w2r5yYezl2rHEqXBjlYv6cmLI9IhD/PmNY4fRB4TgA?=
 =?us-ascii?Q?xQjCDVDOqiIDSUlVbmA9i7GJbkv/qfMqfFWKX6BtIH3zwZLvnZNwKxn6NJ1g?=
 =?us-ascii?Q?ROR4IgT0c3NdXfFRViGkIUbYf+GZIq7chPM6mHgQGyX2YVFPvA4zJoeFVrTn?=
 =?us-ascii?Q?Egz8T3y7/6vCCFWRG3NRbgYoP6GBPGqNu5Saq3HdDXef6SEGFOuYFwNGJUAf?=
 =?us-ascii?Q?BBW/GHndf97aonicQpPqyNffjM4+ZZEbICv9t+lM5nMIzUq3rp7pjvR7/nzz?=
 =?us-ascii?Q?X9RDDZIVV7TZmWPgWQ3hBclho/Bw18OsF+ABHCW6yM2zLVibEbwWaF37lw9p?=
 =?us-ascii?Q?rXXl4gIzvLzQ2brkmR7ky6k2BqxWChcAGklbGTNGolJPUFftppbUxOUtVO0W?=
 =?us-ascii?Q?AyuTFYXdejRuAatQt/fj3kv0dmUEdtsr10FKjsRg8onfO7uzHMPHt16NZPWQ?=
 =?us-ascii?Q?6R1BMMxKiqiYAhvCJDY7NNwpL1Ryx96mDIOnzls5IjDJYk5T4UOaf6+ifekN?=
 =?us-ascii?Q?dfDH5Ms6b0vkKi6Yn/OHvT5szCitwuiMoHNu5jwE7PyiMGabd+pNaKv76Slt?=
 =?us-ascii?Q?duKRKAlbEb31S7wZ23WiA7X1MAJ/ahtFaVtRrjXlnoAeOHR+WMhcIn6tu/Px?=
 =?us-ascii?Q?8D2Kk/EX6J9NDBa/M+2EwwNVCxgoy5aD1XCXN4ND1B3w3MAZMSNaH2DNQwNw?=
 =?us-ascii?Q?Qq/k9eYYEPE44KhjPVEsddo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43277a99-02b7-4e94-2360-08d9bede55ea
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:47:18.6724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: knQF7otAWqiJ+zAxzradzoIuLtQ/VmFVFYJhcQWi26247Tir3h1QPT2eL9SuoCNSo6jfaXRat8yrPxFBrq+ERQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: WzOA03iilThM5deQsUf3PDzGd7qS4-Do
X-Proofpoint-GUID: WzOA03iilThM5deQsUf3PDzGd7qS4-Do
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4071dee181b1..4113622e9733 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -53,8 +53,8 @@ xfs_bmap_compute_maxlevels(
 	int		whichfork)	/* data or attr fork */
 {
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
+	xfs_rfsblock_t	maxblocks;	/* max blocks at this level */
 	int		level;		/* btree level */
-	uint		maxblocks;	/* max blocks at this level */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
-- 
2.30.2

