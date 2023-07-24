Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AF6EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjGXEh4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjGXEhz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:37:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3981A5
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:37:53 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36O2jvwG026582;
        Mon, 24 Jul 2023 04:37:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=H66qGbjV70ou8FWBBgOpLIkBPi9qfcwQl+qUFzfsv6Q=;
 b=DMxPBpiqX2t2iEsPqby2Ww/8rzERqvVt4mLyV/LOyiZ/4Us0epdl4J5z+JOtulX0mBBv
 6EC/NCF1mv2aUEvOYFxp6E18hdZUVHmeEQaUvptQAWjFNDREfV0SD6RkAXYV0a7wW6xZ
 mZ1M4YiIWsVYgN4U0zviGRJbciugsC5SzYKoCNgXa6IcxQn/WuCRbap5A64rLI2F/wxQ
 CtURkeAhEKabex5LpuGRDQTNxoIS8JrZVbdnk8hPY3ecRNkAeEeA1cMTAdwbIVbl6By5
 7OMlv9PfZQ1oX51AGOYmaVFnPLnBvfObrxMowf7eUWGJdK4mhJWa/gb4Rmh9NmyUhp66 Kg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05hdsv9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:50 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O26NSY028227;
        Mon, 24 Jul 2023 04:37:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j96cfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:37:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcDf6SvR3gPCpm/byPY5gH4x6GktfFTcN0Eb56qUWCmgjrC8JxJCrH4yVp4Ojsk8E/+7cI5UXh91pGv/Sk9xsBQd83mNbfRy7GU0yRSn+2YB5ue5hYVLKP05pMXPr8xlmQ8k0Ny4Ir/jVp+eX7W1IhGnCikHE5EST2UhF+QCZCMRV6VlLpg/8WGCPDO4dnikO9J7SZ/X3Vx5tYZKepcR+kmOdiCxfgQtGoTpN8O/A/OLSLYJAEyiQvd/VqJ4cU7rUCuxQuDNPJhZ1HiWIl13PtADmll+7vpLeyyGq0rapcAxMiCYTpbYM4Zo6zOJluAKTk/AbpjVnJ81cRdMJUAgIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H66qGbjV70ou8FWBBgOpLIkBPi9qfcwQl+qUFzfsv6Q=;
 b=MRrXyeuiJ7zRHwMQqBwopJpZ+GHGz2wiehsWSS2Uv9fOXpnBS/lHN7TnZbawL1UoU7ReVWFE3mYyRSij/dwrh1UPJTHXq8TcFUP/+BcAevYZbHvrjoC6L2TN5pXaIIPh5K731P0HndF3h3u0trL+izG3k4F15VFYUSSYpHLSZcnBkfXsvsGRSf7EN5jZLTtjB9DWjB4W35c+9dGdbF9aTQlQ4eLRnNH6TiOVedVw/xHV8cDwGvrn4ZZ7I1ekBzT6AEQdC482aFh8Iq8lIX1UeiTeyi8EjrlrHRysLjQN0TPCMUbhesqW5qDE/yciNhAm7tk/N6Q/RpbbgOUe5y0adg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H66qGbjV70ou8FWBBgOpLIkBPi9qfcwQl+qUFzfsv6Q=;
 b=kohilrwY+fw8ye0+5ahqYuMNRTJEIGHU+dxdLRNEn2z4/JvFlPU+KPJB1FWFIFmLJuynrTP9nk5z5bjmT/npLAQStN/Fs/Af0PjEgnOV+U6AAiJzhnGy50r6WO541hhlYTNwyFMtAfzji7yoBXjO6hR6FifEyZyKUqUPKEM03hc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BLAPR10MB4963.namprd10.prod.outlook.com (2603:10b6:208:326::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:37:47 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:37:46 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 13/23] metadump: Add support for passing version option
Date:   Mon, 24 Jul 2023 10:05:17 +0530
Message-Id: <20230724043527.238600-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0337.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:38e::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: a48ebea6-3651-43c3-d512-08db8bffba7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R32Hwi5XqOlJilJYh8jd8Nj0+UMsWP7P6bBsB+MGHTyoe+7B7kIgEKVukKLuRoXPxagu8zdqN49P+uGbq14SeXxYGekjUX3fH7Z93fiPEGCDSgpzN1SsuxCadc5nsmT4sAXqk7ZFPtiQ80wGrEfrZfDOmgDcYgQxt9Z7sFxC4+Xhsnom4l23ct+0rimGqIBdvwN+2CiAGKQM69DIEuQDpqX5aOKGlCA43D54kvDr/cVdjEMBMQjmkMMMqOeVRB4kTRFUtNRpea3bgUwTbgWz1YMU4aJIc9bTQ/mg8JjHYJfHJZNIyG4wnfMB+7SaTjD93zdi7iZXXFLY73e+nbTL8bP8uoVpL6iiE6LU7BxJc9n3ATAmKzY09oAbycTfoD5U1ragY0uxpZEF3ruh7+LLOxrkK3HMJuxf2tcc94Q060xFkpzV0RnQIbPeyUByK4VtqpyFDk2prspG0dFKtkTQ3y3fz4nCRha3Huc90zNSdYIWTRgH8RRZxqTSZGaa+wo4lYFuhlznT83oWLvBQnOCZV6/v9eENfhC0PZLqRNLK6nb48U84xLZ5PxXomjxmT1R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X9DTgGGWnQ808z/m8dU4cLpMOavJ6YaEy/nLtMOm4t0hsNr/DK2ydhedTQWs?=
 =?us-ascii?Q?4abXgjZ171YQdtdFu3w2fbGT9uazw0hrxNNwLENCRWvdgCU3nH0Ku7qnAH1E?=
 =?us-ascii?Q?4qxvo4/BpIX50CzU9dJyUULT2bzVqJGlxG6g/5JeaoqNJcl430Q/TSeoTD8J?=
 =?us-ascii?Q?KLIAqXnoIYAuVs3Nt/fYlOf3bHmF0PJctfsQMkSH9+R87nl2maKbSITKYYpd?=
 =?us-ascii?Q?0en9Og/kdnXBhVpHXOfnYm9+JMk/ebKkz8Ie1IUhZAPPQyAHFoK3nAFikoSF?=
 =?us-ascii?Q?J8iWHsgmRav6ADoAinttbEebvMA11FxkxGWimwF9X8WscAjMqUIlFt20KC3Z?=
 =?us-ascii?Q?/KjT1IIV41CoGKijRmNYBp/bD7TNM2GvigxfBRPxhGP7Y5mcYrzfeX/j3WMN?=
 =?us-ascii?Q?SixeDu8jN1cOMmTf+Z63jj/P+My5UXzQXgIgodwe9VIbJ2k0/Fw1rGgfLtKP?=
 =?us-ascii?Q?XpNV4HF7aAEqSCe+evJySf7flFgSFGDeZx13L/GRgOjysYhmg/2Ti/+ktIuh?=
 =?us-ascii?Q?yhJGYEHIdfrJUQrnXatFx6t0kfJtlSD2OlVotBm+nkwG/6jeS9mQQK8Jc/KH?=
 =?us-ascii?Q?K5/eT2bCPM2Ig0UfYOEC+CGnuO49HLTDwGmR9j858vwXXX8xwUSqDczJwLwg?=
 =?us-ascii?Q?APX0FH/EM6gVACWMhN7hEFm8eYG+52w6vYEEcEgHLYs1xAes8TDUmhY1Dp6/?=
 =?us-ascii?Q?XisA7A4TzCQvqVhtGgdujz3LEtbiwbb7Kmg/vOeyXj5TL1xQ8vC05OfhsPxe?=
 =?us-ascii?Q?3YZhvs2ckgucDFIW5nCf6120HFfRBO/g9XZPFvIQfoL3RzyJH47rOKSGdfP2?=
 =?us-ascii?Q?6I2rYBmtSStPx9gL/gJ7lp6VC10cXk1se7COP+VIzenh+4Jd5yMonW40g7jJ?=
 =?us-ascii?Q?no4dG3JDPX6HI4MxNsle+Yra9Dz9BjPALoZn8MPB59IWqEUAmMnzwFEIAmwN?=
 =?us-ascii?Q?/2eMmyHAEVSM+NuCZRzvudEjLoaZ9KOP1vMfXw7MfhiGeEaZSmGhdonSamZb?=
 =?us-ascii?Q?5UeQ5c7Wp+l36l8grpHsDj0pIovwRtcQgNirxmb9t/+v1xVPPzwvceEgJrAV?=
 =?us-ascii?Q?K6l1hgPn5qgN+NPFUejHc+E54j219PqA3GpaWixHxvSiKyc28u8/nBq7vVMD?=
 =?us-ascii?Q?7hmdNXSmHPllzFbMw8w6rW7akKXlE2CCxsfelXhd+Sl2YMeZB2PNz0Gu5Hah?=
 =?us-ascii?Q?XQHK/ZGABCe5k76KyhsbFMl5dJyuWQIiXDmU/hRT1pC+ihyY+rXZLK5t4MmT?=
 =?us-ascii?Q?ZwdCW0vyE4jkU9l5ji17d2J6hnxlulgXbc468SB3YqhIwjCBoQ7aOq+cLnkn?=
 =?us-ascii?Q?md3kqSrs8BADD9DKh5Yx31QcwP3dXhaxsipXlc1vAwPlRy7pVRHGdWg7gM+E?=
 =?us-ascii?Q?j2XNjB96zz0pQ1J560VGYrkt/Rj7t8zUpKB3FS4o8+O9E6XJU2L+O635NPAZ?=
 =?us-ascii?Q?PNHbx7vsYXNmFyAGJcJ18fhK7VRiEevE4a3+yZPs//UgrMkcQS+TJclCA+/a?=
 =?us-ascii?Q?4NBKiHETUt8TMVTszN7sOOqGVaPAStaqSjdg9URulrON0JBa/CXU2c0nOvJA?=
 =?us-ascii?Q?sbW0DL/LL4QQcB7M4bu1GERY+hSvH0MPvB6APiT9PyEjak/CeqtjDOd4vtzR?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WAl/TDnvz6j428MhOnGiMb6DwSe4wszp1XoVZLRjybS9vBZhS1sgA5DXVg1LhbFATYexu7SpGcJJTr5yJ5VoPIXSAOC/5TbUEPon2vMBKKOEgwrAMk8f22QrT2g9wD441UUbUuN4ZGdsAO6jIc6ItSJOgAFTIdN9gzbBS99B6Mm+245xILY4uPFQvOWd/gw56Zzx717YVniGqEcqd3QNfF/1pt7eY0ObQ5HSdOhF5DOH7kLu3xsdItFAzCfs9cm+TPhFkSyNCz51U4XBGAfLySV5/uqiNZFRGOLp2yyz7I1fW973dOns1KJRkdG+lax9FpByGelsbSriqMsOXqM0Xz9gENpj/YXsBZ7JhQstBFNFqIuWhWczlOy/oaCItSfpCBm3SASeHExxguLHI2YfSwU+RQmwsV0wmRNAilsWwkm8t2JFs5rEuEMjehMIID5Uho0PzP5Lr5KZ2HeUhTucxPm0knBJf0PbYrzpzZUH6bofOLuENhcF9ht7PI0ZwpE8dgQI7/4+CKXjmH9xZs43BbRFY/dMinOWlH17Pee/BuJvn2M7AIP6fQUJLiHObzpxFd9Ih3mopYLv0SePFZjdMPd7Ib+d/iJBPEjeAQkcKua54L/yMPL4c5CBl+jogBnasQr5P9aA6Zq5MXh/4sIuD9KjAUM6y0/XuqRAXn9RhBMB9DO1uwUtkD9WKAHMVRFhQKb6b0zvF+WDo5yAkErmqZsT67KuqesWfIWlgF6B8s02uvMykTjDXVtM3oJoi8aKajqNbu478dcKGeFY8kPPJej6NJBKrihAySn5bDWrZMQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a48ebea6-3651-43c3-d512-08db8bffba7e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:37:46.7004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cL7vNaJ/qu2i+IzaX03xRU/FWZ1MXVSmY1sk8KnAj+m5JfzUD/6xMimUwpNTc1yM20+ah1xUjzBKJLjjpKX21g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240041
X-Proofpoint-ORIG-GUID: terID1S7hMVJXVXstKO0_1ha-_l8WTvt
X-Proofpoint-GUID: terID1S7hMVJXVXstKO0_1ha-_l8WTvt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The new option allows the user to explicitly specify the version of metadump
to use. However, we will default to using the v1 format.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c           | 81 +++++++++++++++++++++++++++++++++++------
 db/xfs_metadump.sh      |  3 +-
 man/man8/xfs_metadump.8 | 14 +++++++
 3 files changed, 86 insertions(+), 12 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 9b4ed70d..9fe9fe65 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -37,7 +37,7 @@ static void	metadump_help(void);
 
 static const cmdinfo_t	metadump_cmd =
 	{ "metadump", NULL, metadump_f, 0, -1, 0,
-		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
+		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] [-v 1|2] filename"),
 		N_("dump metadata to a file"), metadump_help };
 
 struct metadump_ops {
@@ -74,6 +74,7 @@ static struct metadump {
 	bool			zero_stale_data;
 	bool			progress_since_warning;
 	bool			dirty_log;
+	bool			external_log;
 	bool			stdout_metadump;
 	xfs_ino_t		cur_ino;
 	/* Metadump file */
@@ -107,6 +108,7 @@ metadump_help(void)
 "   -g -- Display dump progress\n"
 "   -m -- Specify max extent size in blocks to copy (default = %d blocks)\n"
 "   -o -- Don't obfuscate names and extended attributes\n"
+"   -v -- Metadump version to be used\n"
 "   -w -- Show warnings of bad metadata information\n"
 "\n"), DEFAULT_MAX_EXT_SIZE);
 }
@@ -2909,8 +2911,20 @@ copy_log(void)
 		print_progress("Copying log");
 
 	push_cur();
-	set_cur(&typtab[TYP_LOG], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
-			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
+	if (metadump.external_log) {
+		ASSERT(mp->m_sb.sb_logstart == 0);
+		set_log_cur(&typtab[TYP_LOG],
+				XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+				mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN,
+				NULL);
+	} else {
+		ASSERT(mp->m_sb.sb_logstart != 0);
+		set_cur(&typtab[TYP_LOG],
+				XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+				mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN,
+				NULL);
+	}
+
 	if (iocur_top->data == NULL) {
 		pop_cur();
 		print_warning("cannot read log");
@@ -3071,6 +3085,8 @@ init_metadump_v2(void)
 		compat_flags |= XFS_MD2_INCOMPAT_FULLBLOCKS;
 	if (metadump.dirty_log)
 		compat_flags |= XFS_MD2_INCOMPAT_DIRTYLOG;
+	if (metadump.external_log)
+		compat_flags |= XFS_MD2_INCOMPAT_EXTERNALLOG;
 
 	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
 
@@ -3131,6 +3147,7 @@ metadump_f(
 	int		outfd = -1;
 	int		ret;
 	char		*p;
+	bool		version_opt_set = false;
 
 	exitcode = 1;
 
@@ -3142,6 +3159,7 @@ metadump_f(
 	metadump.obfuscate = true;
 	metadump.zero_stale_data = true;
 	metadump.dirty_log = false;
+	metadump.external_log = false;
 
 	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
 		print_warning("bad superblock magic number %x, giving up",
@@ -3159,7 +3177,7 @@ metadump_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
+	while ((c = getopt(argc, argv, "aegm:ov:w")) != EOF) {
 		switch (c) {
 			case 'a':
 				metadump.zero_stale_data = false;
@@ -3183,6 +3201,17 @@ metadump_f(
 			case 'o':
 				metadump.obfuscate = false;
 				break;
+			case 'v':
+				metadump.version = (int)strtol(optarg, &p, 0);
+				if (*p != '\0' ||
+				    (metadump.version != 1 &&
+						metadump.version != 2)) {
+					print_warning("bad metadump version: %s",
+						optarg);
+					return 0;
+				}
+				version_opt_set = true;
+				break;
 			case 'w':
 				metadump.show_warnings = true;
 				break;
@@ -3197,12 +3226,42 @@ metadump_f(
 		return 0;
 	}
 
-	/* If we'll copy the log, see if the log is dirty */
-	if (mp->m_sb.sb_logstart) {
+	if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
+		metadump.external_log = true;
+
+	if (metadump.external_log && !version_opt_set)
+		metadump.version = 2;
+
+	if (metadump.version == 2 && mp->m_sb.sb_logstart == 0 &&
+	    !metadump.external_log) {
+		print_warning("external log device not loaded, use -l");
+		return -ENODEV;
+	}
+
+	/*
+	 * If we'll copy the log, see if the log is dirty.
+	 *
+	 * Metadump v1 does not support dumping the contents of an external
+	 * log. Hence we skip the dirty log check.
+	 */
+	if (!(metadump.version == 1 && metadump.external_log)) {
 		push_cur();
-		set_cur(&typtab[TYP_LOG],
-			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
-			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
+		if (metadump.external_log) {
+			ASSERT(mp->m_sb.sb_logstart == 0);
+			set_log_cur(&typtab[TYP_LOG],
+					XFS_FSB_TO_DADDR(mp,
+							mp->m_sb.sb_logstart),
+					mp->m_sb.sb_logblocks * blkbb,
+					DB_RING_IGN, NULL);
+		} else {
+			ASSERT(mp->m_sb.sb_logstart != 0);
+			set_cur(&typtab[TYP_LOG],
+					XFS_FSB_TO_DADDR(mp,
+							mp->m_sb.sb_logstart),
+					mp->m_sb.sb_logblocks * blkbb,
+					DB_RING_IGN, NULL);
+		}
+
 		if (iocur_top->data) {	/* best effort */
 			struct xlog	log;
 
@@ -3278,8 +3337,8 @@ metadump_f(
 	if (!exitcode)
 		exitcode = !copy_sb_inodes();
 
-	/* copy log if it's internal */
-	if ((mp->m_sb.sb_logstart != 0) && !exitcode)
+	/* copy log */
+	if (!exitcode && !(metadump.version == 1 && metadump.external_log))
 		exitcode = !copy_log();
 
 	/* write the remaining index */
diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
index 9852a5bc..9e8f86e5 100755
--- a/db/xfs_metadump.sh
+++ b/db/xfs_metadump.sh
@@ -8,7 +8,7 @@ OPTS=" "
 DBOPTS=" "
 USAGE="Usage: xfs_metadump [-aefFogwV] [-m max_extents] [-l logdev] source target"
 
-while getopts "aefgl:m:owFV" c
+while getopts "aefgl:m:owFv:V" c
 do
 	case $c in
 	a)	OPTS=$OPTS"-a ";;
@@ -20,6 +20,7 @@ do
 	f)	DBOPTS=$DBOPTS" -f";;
 	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
 	F)	DBOPTS=$DBOPTS" -F";;
+	v)	OPTS=$OPTS"-v "$OPTARG" ";;
 	V)	xfs_db -p xfs_metadump -V
 		status=$?
 		exit $status
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index c0e79d77..1732012c 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -11,6 +11,9 @@ xfs_metadump \- copy XFS filesystem metadata to a file
 ] [
 .B \-l
 .I logdev
+] [
+.B \-v
+.I version
 ]
 .I source
 .I target
@@ -74,6 +77,12 @@ metadata such as filenames is not considered sensitive.  If obfuscation
 is required on a metadump with a dirty log, please inform the recipient
 of the metadump image about this situation.
 .PP
+The contents of an external log device can be dumped only when using the v2
+format.
+Metadump in v2 format can be generated by passing the "-v 2" option.
+Metadump in v2 format is generated by default if the filesystem has an
+external log and the metadump version to use is not explicitly mentioned.
+.PP
 .B xfs_metadump
 should not be used for any purposes other than for debugging and reporting
 filesystem problems. The most common usage scenario for this tool is when
@@ -134,6 +143,11 @@ this value.  The default size is 2097151 blocks.
 .B \-o
 Disables obfuscation of file names and extended attributes.
 .TP
+.B \-v
+The format of the metadump file to be produced.
+Valid values are 1 and 2.
+The default metadump format is 1.
+.TP
 .B \-w
 Prints warnings of inconsistent metadata encountered to stderr. Bad metadata
 is still copied.
-- 
2.39.1

