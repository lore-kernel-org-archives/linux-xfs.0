Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFCFC636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBMEFN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBMEFM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:05:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF55DEC58
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:05:10 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iH7Y018548;
        Mon, 13 Feb 2023 04:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=nvZj4BgeB/EP19oo2qBvJ161wCiOlGb2L1Sym0y98l8=;
 b=zzgxFoFa9bUjq9UY97N7qI0a08ySWRy6cqMEebSaInWh2CphHPrb/Cz5lDrqtWu+2fyF
 Lq/Dfp8vE3SsiwTDHsvTiMihoJ5lrZIy5RF23quAe9TcG7p2ZHGAdJhkgBCD60pogsas
 GSlfSetK/82n3NNLXA+uabJoNrhrkSL9NohbTK1Aaw+O+ohDcwRMmLdiKgVT+jedwGaK
 gQwYR3GkrrG8yxr1GsCqEehJ2nHHdVZh2mWNuNE28XwB6VrkCKze63Ukyyr9Ym0Yf9ju
 LL+FZwpDjqu1jkvTMD/EhrkRUykvuv7BaTn/nlxYxXxOR97mndUe04zxRRLZi76EEil/ 2w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2w9sv1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D30H51028784;
        Mon, 13 Feb 2023 04:05:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3jwvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cg5/yRh0E/Y2SYOhpP+XmqNOq80d1VewI7e2jKeqMmNVOKgrwQvwF3EybaH9obLgDjiCDu0oHT4++9K5qc5i7rwFZpKoSfpKZPkFAX3P1DDw2+3myxywlUJBHToe7bi4O4QoMXBln6sXgWRuCoiUC60Iuow8Vuu0+4XFuSJQQse17CothCSes3POv+5Lxy/a/a2Uk0kb6rFmmRLKRGtfA/786tz3/uc9Zof4AwEwvykB2l8hH2Ozyg7RelOwGcmHQaXw9/COfWlNVyjB4z8+ehyM0Q5BBhVGVdmpkHNo8x7CIcN+PBZjfKC2Fw4Dhfk5QmxJBBj9/n3unMPQ28Qyqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvZj4BgeB/EP19oo2qBvJ161wCiOlGb2L1Sym0y98l8=;
 b=G+8NN3dqthJtQ/WF5iUdSL+sw2VSMwHpv/cbZJaZvSfUrWaS6Z9Wf1jgoDdjIcY15YPrQqgr3fblVdEJSELo8njPQZf49Up8aVEZv5QsCGYjhX2ATqq+vECF4UCYhu/iuI1xInC5V6pbxOcKKlUm1uAfZh/fbN5vpvwAjLC+Oyja2sVrV78+37detmQLC4QKcr7QnBnQqVZPuZgqECRrrtgnoX+d69ws6h/RCNk3PXbs9IaeiRAXye6ktSi56GCRTGaJb6Xz/3YHQzctQJcUSLEzHnjJ+RzV4HF+GbYiwZq0as+a6mtNx1URx+TLi53py6lV5JN1fW40nozWmvNKOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvZj4BgeB/EP19oo2qBvJ161wCiOlGb2L1Sym0y98l8=;
 b=P5ZbSfkMNntc8tZmDqnivIQMuBCdlPwceTN7Oy/93NpbN/chMEI107W8JAY9eaqbvax3kmUANt/WfMpptW8VinWlTnjR5BrTLRfH9a1gseyB9sLTswlCOv6JiQTcWZiJcqrirPw+IRisuaWPkEFaUcY04u1eI+OqovU3KuZaOv8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA2PR10MB4492.namprd10.prod.outlook.com (2603:10b6:806:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Mon, 13 Feb
 2023 04:05:02 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:05:02 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 01/25] xfs: remove the xfs_efi_log_item_t typedef
Date:   Mon, 13 Feb 2023 09:34:21 +0530
Message-Id: <20230213040445.192946-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0018.apcprd04.prod.outlook.com
 (2603:1096:4:197::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dcd74a2-e894-4d74-2eb3-08db0d777b5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JmU2ZLkHRgkAKY4OkzDblFh/wHR5x6i/KJQIfADpC+jufEZZW9KDJc/QvletrDZYEm6SjfoKofEiLMh7Ptl2gfBafQOOnh4NfznEdIu2FxmllphbGyZtJj/J63OwVao03CSFmBkeMlWrHwaAWO/Xm+woeGPNafU/6TnKO4ivcA7EO4yWDB9x8qlTH3LlFrsSJcOy5vASoAzcl3SKLPWqGsJbdxvqB+54tScD9jJn/FgxBJSwfcD1ZbKYvVXtBrHpVEJ4Zdm1nZfN4pF8FQiwmRVB54nLQNO+I3lBDGczVUTCsrTh9TH+v1jdg7xc/wWr1/l6dQHcNpIP9SdrBUILqW0hkLaUTGV8t2a7JsZ2FAz2T0coJAU/Oo4a0e7FLIWr6h4pRyF2wDllYSS9PP7A3OL1J3CDWTly15lg79qxcCngo8n8DvL5hqcqjGTsoug13SEobBV0hqpy/p2I1ovASxMZCUu2LLVZWRtw/QqwGlJc5fRtI625ofytBQK76RXDQ0IPS56DpwXbkXiZKfKMTuK/UlBgx36bppyFYZIMy2dFJOCi6LTb//CoCrjhL1U/1hCYAYb7Rnr+nAhNapjCVG0qbXT8toMyaFybwIcPDthtAAvBT70ygiGUqvqUKi+gmAvB+wrMJRxyQmzlsXLjCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199018)(26005)(1076003)(6512007)(5660300002)(8936002)(6506007)(186003)(83380400001)(36756003)(86362001)(38100700002)(2616005)(2906002)(316002)(478600001)(6486002)(6916009)(8676002)(66556008)(66476007)(41300700001)(6666004)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tCQ4AIc2S1BtSTcOiJaTZXxLdMuPMxcM58XWnvi96Zr0dPA8jkVaCFX4X1p0?=
 =?us-ascii?Q?DAqM+0xHXUH2ZLNFxsXr4nfUrRTJjeAWFqGaZVPXwV9QospeyjcRDQM110lO?=
 =?us-ascii?Q?xwte5gZAMx1pfJPBfyE9ONy5zr6iK1CgmdL/qlREb0dkPYfkI1L6VuMJthMz?=
 =?us-ascii?Q?eBZp6Qq7UG6OVG0P9yVBtd5uN55Wvt2aPx2dqdknykGOVbzEc5YjYtYuWLqD?=
 =?us-ascii?Q?4GqeWbhezbiGniPxo99/7PPXXv5CgZGPFt83ATQ7xnLIfcycoOF/obIAHPfC?=
 =?us-ascii?Q?lbLusID31AKSooIq6kc+saQNm0NOavkq18M5ASgG2OW6NdhezeduC4LgMSWb?=
 =?us-ascii?Q?yz5Ul+l8GCrTT1jA4KJqtVyWRLIuCh9+qVT64M8ptWGkVfphrcoPEejcqMD4?=
 =?us-ascii?Q?m/FnNT0zCj/a7MCXK9ei3+UfxGhA2UfeBTe+Aej+dpfxEoILQ0/GIRqOkB1F?=
 =?us-ascii?Q?/1//RVv6QLypT+o/++rscoJaYfhjPoDhDt/FxJ3wjT6SW7PLk5p60yMV2y2A?=
 =?us-ascii?Q?/bQcHraGj6SwrCsNQIkddzJgVkmGqBHxbEQgo0my201E7ey/6cJ1rpPahoyy?=
 =?us-ascii?Q?u46Npoy3B1QmjT3mGVW5AyYRdh1Vay2XpOY6pNc9/0/k++l/u6zcTwpX+lYp?=
 =?us-ascii?Q?UbcW0LqvNSHteAwi3BLv3NhIc/sr61ddHRTlXdt1NNluUwRBucFsFMmIuvt0?=
 =?us-ascii?Q?zmIf9UDZgGLa1AkVpgGHmVQ4d90dno5zuBVKr6GWfHms2jUJZ9rUYc665hXd?=
 =?us-ascii?Q?rTYbBKcub0R56zSmQRqtEXD+GfUbNS8Kxc1nr638+DnDoqFKBuq/pj9UAOg6?=
 =?us-ascii?Q?wlZyRE/EUjaDnrhC/O5nWml0ZBFHmkMM+CxSd5OU2rnAGF5hDKxAPqd65niL?=
 =?us-ascii?Q?HM+l2KlLrdp9nrF6/XMdvL/lQ6JGWZ9cM5YeQ8k+mbzJuIB1EOQmovWUkzbM?=
 =?us-ascii?Q?pK+zt3wrrMhutTmmKvWFzv4y1Mz+l3pAlHLYnlgpSXjB7fE65ehsfsLMc14u?=
 =?us-ascii?Q?qmKWLy6U+/3MdnB4eUYZ9sHHUqsKOm+5pJEIwSSWsrz6fpmQ+Q8YX0SqDWSH?=
 =?us-ascii?Q?OaMAqTm7cW46+Ny69mlMouv8wT4SQW81CHsd6lsRP2Oeqomflo1JoXVPJNRk?=
 =?us-ascii?Q?KJb+5nf2Sse1utlQT9Q97qJ3lZuc7U9IneJJWCBtC9+XVdJCp2TYrphL9cz+?=
 =?us-ascii?Q?mhKCtMtq80oDBPOD9goNKssB3d/74UkZWBT89lVAl1hL6CibStptOusqqxZX?=
 =?us-ascii?Q?lqsJ73nDYbhefSLTciDVh11uIJRpkCf93tQR77zcE2qSCQz3wDV3OdS1PT07?=
 =?us-ascii?Q?iOh1awbKXHPtpGciBqUUS3RZ1diavHKY8Pp0C6XITzBF5EasR8xDsnzENt9l?=
 =?us-ascii?Q?IZvKvKVTUXpcrr1PjgjSyG5jTYzzVZcGj4RuSZEAKbmeJ+RMLxvYmxgubTZE?=
 =?us-ascii?Q?RhMLrU83Uuda9FL/u35j3XJH3SieBosXwfD3/0jvyIiJJbPtjj76zqRGwmrL?=
 =?us-ascii?Q?clMRVZQmk5g4CdyLm/0tjbys28A0xZJqPgVsODIvo/ghZRaqoFFuTVU+c0mv?=
 =?us-ascii?Q?ckcj3OK2tDRJqQ8eyRWwtvHR622RKmuJ5zMJy1LoqCEgkXcjSO55RE8R8Tnz?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gczHS4IJM62iizBJnp1U0+utfikSzLrDFM22MaMPILzyaeS33/LQxsj4DQWuQg5Mmj4yz7drwR4aHrSepCNGfylSvKR1HQOu9DujB1Hz0TBqCbVD0DwELAzFBFT7NTWayw/kOw3SRiMBxc5hPphTBzwmUE7AFpFTRhocHxZw4w4IXN2FNj1Vr4ohApeS0zYOi029OP3sfDFwqz+tXrWDGSqacq2gqRcsLr7wLQMA8gcF6s8H/ZdxGpEIoaoepx7FfIPSFbmSXHlyaDejiKGIeEt5axr5SDcx60wVhoIM8YPa/2ss6PMc6SMQars7EvEdc9no/KWpIVKUtRrWXW62eaRsVrjZRrSqzqLs0b4DtydXvxRKEK+U2LwdYvgE4ku7nh5MMwmZ5GFeuYFT80yRLJeBv/xjbE8oJVrOCnO58A/ZM19iS8euUo6w0ExjVEPVVtRy1ZD/Rh7CBefVsEHN1qhBA4swHMeKasJW1LKHFvBg59vpXE0pJ9nYXiPOFw5li8r+PT0zZoyQIXRo8yDoH53La+NA3JsDopO51rh+LDMwuBsmuwYpQ9Bju2/xCm/Xk8noJNapaGdNe8vMkI6LqyytSr1Mccg8m+m/VlVRS84TrI3xoFUnbL8bYdUOQ234nPZ3dyakE3gfeumrqOWp58NEwUuAekyQjRXnDOdjaSn4Dqqd6Pmk1YxRHSY0nPVj3bbTfmXdVUTffRDJA3VKzysv00P+bRvNqucbafvIE3jQBs3Jjtg1YZ1DyoTmJzNsaxvB7g2+3UTUCLjNlnWEthhZKlQqjgb1dl0Ar7OdvBt+H+EyYW4jmrmb8OQKivnl
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dcd74a2-e894-4d74-2eb3-08db0d777b5d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:05:02.5968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R+Udf33VLBgBhbMRlgriIsAYDLuJzJLkki8z2J3ivbk4u6NEBfvGY8v1l7qx326T8oETnKK1EVTZwhbvjBc6GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130036
X-Proofpoint-GUID: pCoyzw5hJ5AQMfMf6EmIBQpW0EykyO2x
X-Proofpoint-ORIG-GUID: pCoyzw5hJ5AQMfMf6EmIBQpW0EykyO2x
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 82ff450b2d936d778361a1de43eb078cc043c7fe upstream.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_extfree_item.c |  2 +-
 fs/xfs/xfs_extfree_item.h | 10 +++++-----
 fs/xfs/xfs_log_recover.c  |  4 ++--
 fs/xfs/xfs_super.c        |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a05a1074e8f8..d3ee862086fb 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -161,7 +161,7 @@ xfs_efi_init(
 
 	ASSERT(nextents > 0);
 	if (nextents > XFS_EFI_MAX_FAST_EXTENTS) {
-		size = (uint)(sizeof(xfs_efi_log_item_t) +
+		size = (uint)(sizeof(struct xfs_efi_log_item) +
 			((nextents - 1) * sizeof(xfs_extent_t)));
 		efip = kmem_zalloc(size, 0);
 	} else {
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 16aaab06d4ec..b9b567f35575 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -50,13 +50,13 @@ struct kmem_zone;
  * of commit failure or log I/O errors. Note that the EFD is not inserted in the
  * AIL, so at this point both the EFI and EFD are freed.
  */
-typedef struct xfs_efi_log_item {
+struct xfs_efi_log_item {
 	struct xfs_log_item	efi_item;
 	atomic_t		efi_refcount;
 	atomic_t		efi_next_extent;
 	unsigned long		efi_flags;	/* misc flags */
 	xfs_efi_log_format_t	efi_format;
-} xfs_efi_log_item_t;
+};
 
 /*
  * This is the "extent free done" log item.  It is used to log
@@ -65,7 +65,7 @@ typedef struct xfs_efi_log_item {
  */
 typedef struct xfs_efd_log_item {
 	struct xfs_log_item	efd_item;
-	xfs_efi_log_item_t	*efd_efip;
+	struct xfs_efi_log_item *efd_efip;
 	uint			efd_next_extent;
 	xfs_efd_log_format_t	efd_format;
 } xfs_efd_log_item_t;
@@ -78,10 +78,10 @@ typedef struct xfs_efd_log_item {
 extern struct kmem_zone	*xfs_efi_zone;
 extern struct kmem_zone	*xfs_efd_zone;
 
-xfs_efi_log_item_t	*xfs_efi_init(struct xfs_mount *, uint);
+struct xfs_efi_log_item	*xfs_efi_init(struct xfs_mount *, uint);
 int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
 					    xfs_efi_log_format_t *dst_efi_fmt);
-void			xfs_efi_item_free(xfs_efi_log_item_t *);
+void			xfs_efi_item_free(struct xfs_efi_log_item *);
 void			xfs_efi_release(struct xfs_efi_log_item *);
 
 int			xfs_efi_recover(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 46b1e255f55f..cffa9b695de8 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3384,7 +3384,7 @@ xlog_recover_efd_pass2(
 	struct xlog_recover_item	*item)
 {
 	xfs_efd_log_format_t	*efd_formatp;
-	xfs_efi_log_item_t	*efip = NULL;
+	struct xfs_efi_log_item	*efip = NULL;
 	struct xfs_log_item	*lip;
 	uint64_t		efi_id;
 	struct xfs_ail_cursor	cur;
@@ -3405,7 +3405,7 @@ xlog_recover_efd_pass2(
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 	while (lip != NULL) {
 		if (lip->li_type == XFS_LI_EFI) {
-			efip = (xfs_efi_log_item_t *)lip;
+			efip = (struct xfs_efi_log_item *)lip;
 			if (efip->efi_format.efi_id == efi_id) {
 				/*
 				 * Drop the EFD reference to the EFI. This
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f1407900aeef..b86612699a15 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1920,7 +1920,7 @@ xfs_init_zones(void)
 	if (!xfs_efd_zone)
 		goto out_destroy_buf_item_zone;
 
-	xfs_efi_zone = kmem_zone_init((sizeof(xfs_efi_log_item_t) +
+	xfs_efi_zone = kmem_zone_init((sizeof(struct xfs_efi_log_item) +
 			((XFS_EFI_MAX_FAST_EXTENTS - 1) *
 				sizeof(xfs_extent_t))), "xfs_efi_item");
 	if (!xfs_efi_zone)
-- 
2.35.1

