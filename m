Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B7EC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348552AbiAUFVD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:21:03 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3210 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234931AbiAUFU5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:20:57 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L03rY1001013;
        Fri, 21 Jan 2022 05:20:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xchVTKQTW4IECbvoTNa5POR6is+dNUfG5DRGSLJKnqw=;
 b=bsN/rzGFouJ2yi6VOQv70Kd2M/OBHYI21RHtltHgCez5Cw1SFrsJWHZh2VCLzMBQc1Jb
 36SH1839t3wAsshIP5A9f3e89poZHd41LVrauv2UYVg74v2xv8/aiVqUslx8BKK8t3Ei
 cdeEpzqNxOw4Jrh27LIAnCxTcMANjOIPDrpxzqiVNmbmwCgccjmETfrLmEKhHLjwC4oA
 I557OzJ1Q9YYOhXpzt6ElM08mewAGz/gDo/X7ExUlMyaFaLIfhV0G0vbUW+pkOIYQrOx
 IrU0XJOd1YVOwE04r+CkFLxEDPLy+l1RqdUZwhFFiHQh5ZFnmiVRtk8enseBVtzR86vK mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhy9rcph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5KWJc007076;
        Fri, 21 Jan 2022 05:20:53 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3020.oracle.com with ESMTP id 3dqj0sh10a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:20:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQXBolHChpMCLZME2qtQlWnku7dSKEJaIYNNMp5qcUG3LkagSvShE2Fcd6iqPzP7I29FoSRs0u3ggbA8Oh5kxdrMSY/Ap2iWhLH3Xj0l/sK3LWAMyvVEsJjP0JsjxmY+Aq64GgbaWJ/LAVQpDXDkwixzumhkhty4bULCLsFCiA8Z7+f4/SY+6uD9G55Mmc81M4zfrVTsZ5irBRvXzW1/Q6pkoGzDLHUX9w2qlj6Jx2ub6WONqmj/g/wreSAyV80rMKnAOCD3BdXcWRNQkfBarXoQ6OrqFcrceQT45YgPSHIVWN41Z7m7aQmI80kagOErLcyNEX9ZKuck62uPbbbKAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xchVTKQTW4IECbvoTNa5POR6is+dNUfG5DRGSLJKnqw=;
 b=PX5lqg/00LXf68muGioetwI13+hzr/4zDwh2/kdau8ChEx2pbS6SOivcys7IhFAjHR8Pf6Ut5RVmoG6gXGETQT9ltTOgscqAHQCRo3+pmweo2Kk0IXbxL42YiFRA4YAyPrM2a7pHHi2dCi+/l20df95JfSHP7oVcGBqetJ8Mf9QIawZPcuKLQ/DO0NGAiRz37khvSfUOUFBvXIl1kh1K2gLQxzRqpokDzOnwiwcklyqLdtySrSrBJX9Yv5SnT0owLbVFbeaMoYrNkTMlAV3hpVLZoawazb4gc8fXDwBKu5T55R0JbZUE5W60So9cdfDanSN4eJSwKl2dZq53GbAD3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xchVTKQTW4IECbvoTNa5POR6is+dNUfG5DRGSLJKnqw=;
 b=nNT07b0Wsi5goYoLW5yFserAOeUlnFZRGyp9zeWJ6Rm1ZsLYKgwsaQr1tXO+SPV33+cCcAVDmRQU9nyUxsRHP048KLqrkWCOvTojZM740bcCvdATEb5qGfF6sAyNHUDSOElVQG+GJJwoIUTh1fgNBf78uPna5KPRszGXcAF1q4s=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:20:51 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:20:51 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 06/20] xfsprogs: Use basic types to define xfs_log_dinode's di_nextents and di_anextents
Date:   Fri, 21 Jan 2022 10:50:05 +0530
Message-Id: <20220121052019.224605-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121052019.224605-1-chandan.babu@oracle.com>
References: <20220121052019.224605-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:54::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8c38314-8819-437d-a475-08d9dc9dca59
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB12875DA206C7F6920BB10766F65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:428;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w03CjmG+t15OdqxlDizekFVAvgzYe9cb1sl6LKh8sjoDshtEPEhtWUWXMim40X1xZXLyasz77Q+gOA2SPdaKdbtZyHfWNO8O67TOktiJZZqNtdte2cDE3SaSrvzfEhWPYVXEPR3eyschy4ybWoB2V8zWLMHF8CpA+URYSLdY3Y5vN8QDkwXVy2I9WnvufF3k/kt4UwUg1q/eVg6GyhQK0USWqpNSH39odTL1jvN4ypCIOW9amQpiwQQszk4O3kDfdfB1iQlGwFzMFUt3tToXdWvbTJSqCcso495nv6ZP+weTGifQxcvwUjTZbXalgwcO5u/YZAQ4yxudNPChTwOvyaLVfPdO7sgk9DpGnNAQrkTTt4yAyxjBuV48Ch69+17D9g4MDXxLXAgwsd+OmTft20gVTQRm8hX1YiK+zT16zo2NPWQ7OSP+E1mAusIJf+tQwFE6hfzHB8cfohkX3iJQ3dbWKQEuf7w1czhoGIYsq8e4nAnYgBZM7DcqDz8J9WlUy7OscSmg80tX/VDGRAOf1GSCbtYN2JMO5XETibiyHTRsSrMo4KX2dHKmiVQKra+AGy8Wns8fM+iRdAWsLbiC1pFZ7ImNDzUwo+1eSQjk2LnDcLvm73qwXmssNoTl5toRUJpwwahjWVwzOznqMOfy4gMXXPOBxr73vbFxV9aulgAEM8SQwD23yT46c+L9azt7hr9h7Hui6PhcRc9AETSn3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(6512007)(1076003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B+2Zj8UDrtJE03900r40nOdVIEpvoDSgoOBPSwaPi1+rptD12bEsSJbjdg5i?=
 =?us-ascii?Q?f+iEQ924iFs9aOKH+XoH5pR/ATTipCOj5ZCsvil468cuxPbGbyWU6luvMMQQ?=
 =?us-ascii?Q?yoenb8nO+NevgeAqadbfq6NMgFJ5QdW5Gr2owBNpgCjJEZ/Tygf95T/hpz4j?=
 =?us-ascii?Q?4u6iwT9PmnahKP9pdQ3t3qaXGLoEPg01sWuNutjTiaqljB2m3Cib1+lgZ+y2?=
 =?us-ascii?Q?OV9WD6S8jnb7nt3/sM8eUl04zJUVKz5r6a8Hoo8VJWJF0Dz0dfr21LRpEOLr?=
 =?us-ascii?Q?lYOBtPNfyUgkoBTNOj1vQ8qMdrMgPTLuxFIh4HOJgf5/4tlU/7EM3QLk4h3e?=
 =?us-ascii?Q?HqcxeomTXh+8Xknq9XeKB33UAfz64VyXGlmPQBjKKDPG/u7XHAB2gKHLqYLp?=
 =?us-ascii?Q?vG934SD4UfsqxCPlCIfiQ6BaSVIUpM6zxl+NwzPTUueOQkiQ2eljzbWiH+09?=
 =?us-ascii?Q?O7/IDJYQifv8wQSLlocqMg85PdGveV83IpHDWAQOgtDoicMHMKHuNh5PcDyc?=
 =?us-ascii?Q?jhuIc5a+qaaUnIeUEMxVdxgKcWEVnBadKB+FSgPgnNLIMEOMV46lwzVvxau0?=
 =?us-ascii?Q?5U0SMT357i5XMxcWJ/yd612+/BXpgrDPl/GA39s6mkKDtvn6BVjfbP1hGbXa?=
 =?us-ascii?Q?oO9pOn9o6hzd3Z4DaVpnc/sorV+X/o6svIhgJmF0QcUEZqSYD+1JT/2CnsMd?=
 =?us-ascii?Q?NIeb6HRswr7p8WKMwJq9JJs3lg1ciCuWRhMIw5sm3ylzKtowUwe793F8br7f?=
 =?us-ascii?Q?rOTkvR60i6kdljHU/0xHSW1XYh12oLuxBBQMtsLVmgyU1X3TkAkPsUR2mK1y?=
 =?us-ascii?Q?fUzKy3aUNaUk9jvNPX27dg6vfQmPeRkfOBzM5G4i2NnHHjF/PxdkkAlNaQAd?=
 =?us-ascii?Q?05oJdS481OvVAtEngGqXWhoif7sGBaKocSrscBnyLkWdkTZ5OfoFUspX0bT3?=
 =?us-ascii?Q?LVBvPTJDzQTZNB1igWQeIlLyKWb/vW1X5mizzuyv+bV8OfVO7m3H8kEbjw9w?=
 =?us-ascii?Q?C+pRwv/C5djYEy+syczk2I+cR8yod5v6tTPRn3LgLNFCDY7r/hpSMWgiNLps?=
 =?us-ascii?Q?+1zmarJmkMn3ZGXs6El1kTod5r9eDStFLpey0Rx4OHa9MGUmFJk7Dg1NT2MJ?=
 =?us-ascii?Q?pBpu+ps127Dh2u+PquNLTGEG6w2sESK2gTFVwlXD1KdLFSt6Fe6TDGMQ6xMp?=
 =?us-ascii?Q?tbMdbtw4rdIrD4QAyiHAi8AYIjw15EojGN2bIY2CCqxWiY9tjg4IS6dnJ6jE?=
 =?us-ascii?Q?c52EL35mslEvATU68/Q75lv9GgqojsTqI6hGLcPsQBGb8/q8WgfGoF7Oc+LU?=
 =?us-ascii?Q?aJV5C22gSP40INkqJVpCYQPZcf9vP4nadyixZF6A1tIJh+6FTNCJMl9/fTbd?=
 =?us-ascii?Q?pkuiq+8+rgB/FKkaNeadTFtKXPgfHwRUveba1IoTHn8czBp1uaMqvVWwVVs7?=
 =?us-ascii?Q?KRn5NPoT2Beva0UCl041JbZ/NknC3R16uNFV5DNx5/9MNzI1v2Yr6oP9/+NC?=
 =?us-ascii?Q?2Ri1pLprlj5NMLq73NSp47MHIoyggxaRMmMvoPCSRWEwBUZe1rWnXRjqtehp?=
 =?us-ascii?Q?/ENxl2d/6WdNyHAL0DebiHcC6AAGfRNeBLuSrl4y+hqAri717lFRtBoaQexF?=
 =?us-ascii?Q?iPZSoSpnw6kAt4MOAb34f+k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8c38314-8819-437d-a475-08d9dc9dca59
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:20:51.5296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5bJtT+s7unbSGLIr/HPRQsBAwaxn+0T4WCI89bsqX7eHoNnMtYXwhAIIhX9CRNiEo+C2KsG5RzwHZtm85dYt3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210038
X-Proofpoint-GUID: MyjMjssSNR8uNei-MfU1y-nPaE4kkOg7
X-Proofpoint-ORIG-GUID: MyjMjssSNR8uNei-MfU1y-nPaE4kkOg7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will increase the width of xfs_extnum_t in order to facilitate
larger per-inode extent counters. Hence this patch now uses basic types to
define xfs_log_dinode->[di_nextents|dianextents].

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index b322db52..fd66e702 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -396,8 +396,8 @@ struct xfs_log_dinode {
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint32_t	di_nextents;	/* number of extents in data fork */
+	uint16_t	di_anextents;	/* number of extents in attribute fork*/
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
-- 
2.30.2

