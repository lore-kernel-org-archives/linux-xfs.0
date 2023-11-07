Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8897EC4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjKGHHw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbjKGHHv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:07:51 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E44410F
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:07:48 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72O5wI014497
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:07:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=Bsj2yfOcsF4w2J4ksTZVgWd6iYAy3HLZhEy+Rfe/788=;
 b=RFnzGJ+7mlKq3JvJmYOrc0cMNk8D+UOEZVyLcHFkKJyCWPRUxxMWYDz2FbFUGJLDcuEv
 ltcLUPUVnKz2RbkJuvJErqROsqKU//gSLarB/sw2KvWdG8vhdRNCffAduZhS31T6LiMI
 tBdk47yf8dhoswVpmnrxHLPaAUS1jNUcEKPt2yZv9nhpFwJYUm1XCYJuP1Vk918pWsgf
 6vAR3lkSLoaKGcSRVzNX3ugEOwUzgrV8Jj5OmRHklnhzQwNwxoH01TDM7lEee4gjfMKE
 tUSzSalJYPagJPa7I8Yg5AV5jspQHMMpoSG+ZxWPsJX4YfTCDGF41kP1vIzPrtE8PERn 1g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5dub5767-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:07:48 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76sc8x020774
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:07:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdd1vcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:07:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TngL0in2b1//kWrr7JD3kmOmFQ0gu6GlcOhFyOPezXKbQ+H+jEx4RgdgMRD7lMaJ46/GwWvF8FMTczmVV5aN+SF9FtteqcMMHhjRSkWAYKZXE+FAY2llg8tH0lbXrz+UVxIVwcJAZ+sLpLSU1QA1hj2UQepRvr/3S/51QLTsClF3okQd7g4gNdo7y2PaGGnVRyMLiAj/QAYw731dKDg0pwKdqSdhZKFdaQfKVtRwge41OcyMp7FP5TRAhSMc9RV3KfB9WE9+9z8wgM/VKROtpHA9pmtSCTJTkN59pKP8QiTaPEv8N475jnS+whuBK4eVbEaPXyd420RwE/EbsgTNkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bsj2yfOcsF4w2J4ksTZVgWd6iYAy3HLZhEy+Rfe/788=;
 b=a8wE0KdYJ7IwLfbg+aZfmcP7k8kTL38GoOblCqJf7qnoDhq+RXhFwTvEUTa4kFDfzM4saOq9MzuZB8RLJCq3X9FtQBOzu/ddnuAr8oYZ+FYyM1Bri9aA+pH7h8vp55E8C6BEKmyJBPr9MI5eQENE1V5SykG2JQ/xMbQ2gJIB/lkv80mCI51q8PgdIhpn77hyjpLvdjeLb1viLF4utx5wRISIKE2bQBOdA7KlfQ1bmo4CDDpqYNGvx0BquSUWtaprfduonLrkTglfEWihjd0IiMSXEyfNoLgGLKL+j9dRdTylxtONUOnsjC3bmCftlQoH7mqY5FnlgC4DEACx4bkBfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bsj2yfOcsF4w2J4ksTZVgWd6iYAy3HLZhEy+Rfe/788=;
 b=VqbgQcNlMKH/ctTbWV19VcWVTVmOyJ7aWsC0s0kVxLtbgZYj65tg8qphGPHFvvLM9uphFWmuONGT4meBDATnRFNC5mtgoDeX9spP+ayD8hOlGmysxw1xaqoP79qi6QyFUdEY/9pIz7g7OkhrEmLPaDbG0fLHgGedjdGPErYiWyE=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by IA1PR10MB7263.namprd10.prod.outlook.com (2603:10b6:208:3f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:07:45 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:07:45 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 03/21] metadump: Declare boolean variables with bool type
Date:   Tue,  7 Nov 2023 12:37:04 +0530
Message-Id: <20231107070722.748636-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::17)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA1PR10MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 3447e4b8-9753-4602-33f3-08dbdf603ddc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQswZOJH1VWIZEumsNELcA3dmwlzdjOWloKTdUw6Zlkec3VA0AxLRp7c9JKWGFlBfn3o13HDqrb07SJuhZLs8kKet8w/Iv0aHjECoyXvA+4Z/inLaryjZlIdHKGAzd1ZEkPmtR4I2yI0bZVTmKROUPStiU/cg/Oj8tQUmWCwsmyCOFAA/znhykxItnQJel6JidoFbnROl4gd7F7X3YZceXJiYeVfzXFuf0kPDkJhqn078cBbSF8APKiyyHzC9+ki4ztkWnIF0jFSRYENI42+DnZBY7Ujg2/udpa9OEtSfGOXukaQaa/0LMWeuHzLYhKToxEAXX57G7g2X473DgW5v81sm+uhq20G4MvWARRflaXS2kVwfTX5tBI/W3AZho/f6NvheX8LT78YCD8bGUPhUh4EurlZg/HCDRO9yrXI1vBSZJpDE5Emhner5KETx7pBxhAlmXQeX+RWNznYudFpimoPVn85/te3SmHo9oP80pmO/SkfRA5yPeMSf1wKsdCAKrCT+/tm0UVxiHxmEEJCtImyHfCzGW8ahvjjnRo+BnoXMMzVXmra99NITcSJ1/8APf0J0g2n8kIxqdcyK7SenOAU+fvqLm+Vf+tmcCQ3FI1X15us3EIzigMAWAFNacQe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(366004)(136003)(230273577357003)(230173577357003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(26005)(1076003)(38100700002)(83380400001)(5660300002)(2616005)(6486002)(6506007)(6666004)(478600001)(6512007)(36756003)(316002)(6916009)(66946007)(66476007)(66556008)(8936002)(8676002)(86362001)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eYkdEaKnGQfb5epBm/531WmIaEU0NjsPC7jYdogP5cFy48G2yBJV1Ms/TotT?=
 =?us-ascii?Q?v31azYn2pRLapxJ3DyGboImFQVJRaIXwpUYJSASzANpn2it7vQV9vJHF39uZ?=
 =?us-ascii?Q?UVXkhm4/m5b7Jz2kcyBE0gstrLbXlZwYoI3ibjxflkaZk0iRkx7eHTnpWU/u?=
 =?us-ascii?Q?BBl1ktr9NP/7oOa7JM7oA3GogM9ZiRroNGS0wT2rxn7cdT8qMJclzUzkIY5B?=
 =?us-ascii?Q?0z2JDEVaeBMx9BmO1XyRLJAnLvCRsUMFGKwN5cMB6BcG5oKo/HqnEy24ERmY?=
 =?us-ascii?Q?V12bd3PWJSrsDnwS+ZbZ1ZoduvmJ1ZPY8DAthbRtJjM3/rAOJRGeNJDbZJSt?=
 =?us-ascii?Q?KXe7cXSlSdvcf0eeZYA3pgyVFhvpG052XdqzjiLe5z2gd9FO1P763D/bO7EW?=
 =?us-ascii?Q?n9RsFRPrN+ftWmbf+MFYi9bQTujCNAPSnF3Hl8/9IdwiD0TCxdALxF5yQzBR?=
 =?us-ascii?Q?hiLy16vcD/HZzRvI9h9rQjpu1+YKFvCE1m4CAjkoC7gqcFTXnIRhNwW2pySF?=
 =?us-ascii?Q?dxZEp67gtdfDPQOB2ciZc2mOOWRPkDyTsWvt91xkmLSuKcn5Pv9jS7YalKIJ?=
 =?us-ascii?Q?APALUy0YgQ909/rBdW4TnslYeGeQqlWbqZSiYsy09gYm70BRsYZBwvFObMsb?=
 =?us-ascii?Q?/EkBqugdxv00I+jBtu33SJ8U6FpZyCHsb4AhwSBnbg+4V0/1ztgOS5Kpqgli?=
 =?us-ascii?Q?rRzFsF4WZwAiZIRlH+3kultd4tMIHMZTc56VctVA3m1jim31zhMTMxZxfx77?=
 =?us-ascii?Q?2aZHCyKklFeb4NwYawEuUQQ2nvnlkSZmlH2EFFqUUekLU3vRjVbG5SbbuXgB?=
 =?us-ascii?Q?xGe/gUlGs1Yrb1S1losKZnt2g0pcvlfmWKEaBI8EBhS6K828Gldt/jLXMSAM?=
 =?us-ascii?Q?6UjkwA8QoaVylDj2WZBzRKR4tDu5z+6yXpNSLvBC0XbTGloLT8ap2jZr9zj/?=
 =?us-ascii?Q?85cPYS+FouPctvGSJrERs/bcwnZVBBVNEMwF95erXUyLr/ySp38HhfmVVa1L?=
 =?us-ascii?Q?AJXvBq2TTuXu6HOyz62I7+2U+Ap63dLEUcdDPztKxSDQ91GumhNQtPt2txEc?=
 =?us-ascii?Q?TAHACZEGjkHdANSVSDlsAXE6xm0Ad2Yvy+Gmosp2i1SqQSWqb3QO8CtyYSPS?=
 =?us-ascii?Q?EJj3h2aUL37kgacSfPrx6IOr7hRFJubNXNmNg+tfRSYmjCRXLvAezUajW9jU?=
 =?us-ascii?Q?/EL5VJdGQxpPMFye1mpb2j3DHigUvQ1bpRbuQqQmfMh2P9yTU4nAju51++EB?=
 =?us-ascii?Q?HxQTxPK5kJY54TwDV89gP/YZbMGYCUQb0U4DvrvRwUQdRvfIcA13qfR5dA++?=
 =?us-ascii?Q?cgnVjdE+QqhuFLDcIgys8kougpGVo4cpkD6qeVs8TXIXP5foRMoaOqgygpQn?=
 =?us-ascii?Q?nkG64tWUwBiMUjUqFtM9jdk5hpDpL3JFL6TKW9voI35WqFOIm3ujretKfCl6?=
 =?us-ascii?Q?itmY7UzvkZ/YiYJRhK52SU/V12WiwVSTQeAzhIQHh/+kmRvmu+JEjPMZNUpk?=
 =?us-ascii?Q?Ql1toIexwKVTjdfgUjmNeE/JfmtH6CBPRmXjh7Ln1a8XTZyOVuQzBK3ShITG?=
 =?us-ascii?Q?zCsYPQEOwvD0zHFeoHBz7RdHR0UHx+2r4v0W/ZzQ7Cix+QsmEC/lJ1eYloCc?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 6+kte8M/Hpn1NyZLF1aDQKPcWgKSRXQc0Oodc5NktE+kx66YsciSpA/melPp4vcmsa1djZ/PlfnVvHXOoXSbywGF6EINutXCzBIohjSiI8D08terQx/O237FUSMWKBG07x5q0MU1GtZjbM3wOKSb9pXERuUrLO4xUrHBue2cWoVCysvOMmL8PBfPWIoV8sK6begrVDzlusZhvDs8+mOhyzkPxcNnnGKpO068fSGFquOlNIoC8/+tP9siE4WgRW1IzBCEgX3BRDuzGYzajCqQ19uUlg88TBcIigAFU8020JO/tVaJyx3j7eE42Gpgz/mCFIPkV3Tec1IPZEo7nJY8rQD/SsFrL5xMMVHyMP+uhMTtKhaL9xZGJc3NMFVR+JjjoHd+czUdOnyUvacL7ml7tsHn1zztKhKvfygQAbiwRLy4rev6FEab9WQVfCgw2sXI3R2mPf/tbXdV2izLjgQlS9cFFKfpViaY5OuBZg31CVf4f3WcMMQutGSGeQ1fexsg5MNGUcl5BMPQNxLzJNh5Epoe7DY3wCHOnfkmrw8zzehJWunE3E+rMGEmuG8E9FbPT+f1wq1Fw8MCPruHIIZyrU+WbWKXp2lnqmDndSBxqZy7DFUaWA3gvfnN2owvjGQ6tB9OSjoUjRNpMWCCtA1b2jNHf134d/t2TpOr9IEsK+517D6EYshwxoH83uHfzO7rdwv8e6ale6Y29COwp+LK+mv/n3JUkXTc6pJiR0+MOW+rjUXBBvs6lHUnk8YcW/qlL3gHcTCR+INM+itm3xmmUA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3447e4b8-9753-4602-33f3-08dbdf603ddc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:07:45.1658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OkIfIeVK9tnAdmbX0/5cjF55JXXnRTu/Dj1GxhnZImoGyzWr7whLUwZ8CtYN35I9OmutCgDGEpy2k572psNaCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311070057
X-Proofpoint-GUID: iHM4XBMO9A1vRZjGkAcSL3UTEuIxwIIh
X-Proofpoint-ORIG-GUID: iHM4XBMO9A1vRZjGkAcSL3UTEuIxwIIh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index dab14e59..14eda688 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -52,13 +52,13 @@ static int		cur_index;
 
 static xfs_ino_t	cur_ino;
 
-static int		show_progress = 0;
-static int		stop_on_read_error = 0;
+static bool		show_progress = false;
+static bool		stop_on_read_error = false;
 static int		max_extent_size = DEFAULT_MAX_EXT_SIZE;
-static int		obfuscate = 1;
-static int		zero_stale_data = 1;
-static int		show_warnings = 0;
-static int		progress_since_warning = 0;
+static bool		obfuscate = true;
+static bool		zero_stale_data = true;
+static bool		show_warnings = false;
+static bool		progress_since_warning = false;
 static bool		stdout_metadump;
 
 void
@@ -101,7 +101,7 @@ print_warning(const char *fmt, ...)
 
 	fprintf(stderr, "%s%s: %s\n", progress_since_warning ? "\n" : "",
 			progname, buf);
-	progress_since_warning = 0;
+	progress_since_warning = false;
 }
 
 static void
@@ -122,7 +122,7 @@ print_progress(const char *fmt, ...)
 	f = stdout_metadump ? stderr : stdout;
 	fprintf(f, "\r%-59s", buf);
 	fflush(f);
-	progress_since_warning = 1;
+	progress_since_warning = true;
 }
 
 /*
@@ -2659,9 +2659,9 @@ metadump_f(
 	char		*p;
 
 	exitcode = 1;
-	show_progress = 0;
-	show_warnings = 0;
-	stop_on_read_error = 0;
+	show_progress = false;
+	show_warnings = false;
+	stop_on_read_error = false;
 
 	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
 		print_warning("bad superblock magic number %x, giving up",
@@ -2682,13 +2682,13 @@ metadump_f(
 	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
 		switch (c) {
 			case 'a':
-				zero_stale_data = 0;
+				zero_stale_data = false;
 				break;
 			case 'e':
-				stop_on_read_error = 1;
+				stop_on_read_error = true;
 				break;
 			case 'g':
-				show_progress = 1;
+				show_progress = true;
 				break;
 			case 'm':
 				max_extent_size = (int)strtol(optarg, &p, 0);
@@ -2699,10 +2699,10 @@ metadump_f(
 				}
 				break;
 			case 'o':
-				obfuscate = 0;
+				obfuscate = false;
 				break;
 			case 'w':
-				show_warnings = 1;
+				show_warnings = true;
 				break;
 			default:
 				print_warning("bad option for metadump command");
-- 
2.39.1

