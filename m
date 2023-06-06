Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9A3C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbjFFJam (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237484AbjFFJaj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:30:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C1EE62
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:30:38 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3565qoro017272;
        Tue, 6 Jun 2023 09:30:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=akciax8ZojrrEBxVK+N6neGuysZjYM0hnAO0E5CO8qw=;
 b=DI7/svWhuB+QNZ8TfNExrIVPAgha6I2EBMXVaIRr0+J1gx51F93i+JLiqo0vj08sRn9M
 AOoTV5I+tVWHQmWTyYGEUbQ2PJ95UifP0jlHkLgCxDFokcKuvQ2awmaGD5zaoLJPSVNL
 cE1nUzpPFzKMOcPIj3DGW5i7kRetNg49bwbffhsmViM0m0WvKC43TL6TxVmp8omcMNWF
 gW1FUC83Laf2RyExjlaOqK7q7/3mIDiVKWqimdycdaZHMuJH9OKziRb2VZLSg3vboBtZ
 +TLiyK3CzmjY7F+JJBrM5ey4r5Q/rBp8CCG9t5nyVL6hHInN7CUjLihFKCdYPm7TeKeu Kw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2c515r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3567pE7m024146;
        Tue, 6 Jun 2023 09:30:34 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tkgve1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzaVwYjAF2Rau1kOwVrJ1Jku4L3Jk5lJV+hDLQGKF3Sz7GcvpoRtKU6utWio2wkWnvyA+qLOEHaaBEQncyD5tcrMekS9MGD2OkKPZAn8FczLFAvLV4zKAuxZd+zf05tAoUv/iTbMc/03EsuGa1HnjkFNVZX2cWEinZx8NPUAvuGSWJE+5MenrPCMbVFoshGYnmaNO8GbwoI+nZ2AX6ZYQV/+3AIQt9KDVgwO+MEResbT78vIu2RUDv99GUgaQPvl5UFPlWDggP9oNTMg4n/ybtY0KSy14zzHaUjh/PeX1xmqJ78i4J8SnWaxH3I1ZzkS6qduulzgATjazh26EmEhzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=akciax8ZojrrEBxVK+N6neGuysZjYM0hnAO0E5CO8qw=;
 b=fRleFEXV793qdI/+SQqd4rGiXy2bd/UGs/p5e1V3fNgbU7BV7UnaoY9f/1q9x2NzYJ3KaNivWN1k+FEp48YMPP9Gylq2fEhZm8C8Og2IrbtQIn4L6KKagC6UjQATJQ3kVxeZiPWBggoyyvfFNGcTnGplGuPsKDZss47aw2jIs6VRDl3HxlITq5VVz0k9dzwYAiBimsmuATNjH/cM8GGYpaLG2S2A28b3OAzzhGPY6lJhzWYOkHFlghJ1jaCT/+KJWtsm54yMe7bAb45g25dJiupfvMrONl8Y4ERIbg6HgWuJLVSpYPwzt6DBvmJniyiM/DMPt7CSS32IbcJTOqq5dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akciax8ZojrrEBxVK+N6neGuysZjYM0hnAO0E5CO8qw=;
 b=av0l1F/ZWS9MfwQyG2JNh6k4o+CSjtdxtgfr4rVA6+c+9cjIj0FN13HkyPocQMW6irXW0EHBr5tPyn/U7P8U2dQjveup6g6jxSHB/I5yYi06g6VZRSLe3mGnvbi+y/iY5R/t0xii8NIqj+GmttA3Qn/NCp3adLory/gUYvJwJyM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:30:32 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:30:32 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 18/23] mdrestore: Introduce struct mdrestore_ops
Date:   Tue,  6 Jun 2023 14:58:01 +0530
Message-Id: <20230606092806.1604491-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0042.apcprd06.prod.outlook.com
 (2603:1096:404:2e::30) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: 1145b1df-e9cf-4613-8966-08db6670acd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DfWRBzzkvVoCA79X3Lj+UYct+TgyXLOAiFY9eaj2Habmzwyyz609husxBIO23CQRZPITxgf9v0p53NY3XurDE+KGt1msePPxQGbh+D+JI3+riEQw+RuAGKQrl9OY8FaMNml1bIse27UnbiO6KXjP+mZQW/xDv1L9HjVmTHUJalsLh+f6+cDGg6eKWhSE1LD3m0uO3AM3uIvVHH+6lTaJwusu74P06+2q5+zzqCmcKl+cokr7+mNLYyd/F2PFC94LqCf5/ysjbP9SdLe4BfPrd8aZUctoqLR6/SjeE7DRHwy+CSSInpSt44G+XOdlHsiHXzR58F6XhAe1bWFK/9N3d+O6csRUJ4ovBJ632JV9CCLM/4lF0fKMDwqAUAljegBjOSoE7YkntjWF+F1p4enIYZbKmTGTFpuqkRai/OoKhpM5o3E87r/TAhU3L2vB7ay7kdMg5ARIAD4ziSRrtaILUKbVK5gW74Fdr6oBNCPlvmse6XFLHQPtNEe+TwAAVgYzVyffLRlXY2WKCHIbZVh7SCV7mSoqIbCo2H/YTZr75btzpMoRbHZYFtDYXMPcF9hY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(8676002)(4326008)(66556008)(6916009)(66476007)(66946007)(8936002)(5660300002)(316002)(41300700001)(2906002)(478600001)(38100700002)(6512007)(1076003)(6506007)(26005)(86362001)(186003)(36756003)(6486002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oCdSyuOggfHvIk2jcUoocuwI3zlY6f1+/6Dwl+K4qQcBgonasJFQ/ZemM+Ql?=
 =?us-ascii?Q?XXwc50GcWXbwK9DF13FFLbwGNRQVFZjjbLniO3i6GRh1euzVQFzSB+gy9MwZ?=
 =?us-ascii?Q?t5lzNC0gP6bGONITjLjnZxAFO1yNQKQic6pnT7UoE8a7vhmPCH4kR4jNMcVQ?=
 =?us-ascii?Q?7g9OhFR0qTAv1pa32s6Q5Wt7DzufAs4yftw7E0+fl7iAUnzcbasdB3aplcH7?=
 =?us-ascii?Q?EQp4Nzm4L32LBC4kD2WWGX9SN8pPVqcYWWm2FDRZKDPjxLBMKddF0/bIsByU?=
 =?us-ascii?Q?NCKYipayjAJZ4UrAbKtT6/w2pu8L5of4kDgjYnBIOJi+fvy8xuxfg/KTaFxZ?=
 =?us-ascii?Q?53hEjO6LQokwapPV/NLaoM+gE1hQs/z+RWUx8lJw/Pm7PikaLZ00v6ahYw+D?=
 =?us-ascii?Q?zdh8nlayWSO4zewwdG4OVOuztK/QmbdK6AvkD5BNbnASfLLEBnQfsHnfLA7p?=
 =?us-ascii?Q?wxuMwjMsj9yctNN3pEF7BXR93AkWIhtc2RTuvcI2nEpj+Yev2pW5K1mt288v?=
 =?us-ascii?Q?Smab27lXDzJrNbQaU94AmiEXOg1zjKVE58zRlRX27HEWNkFwQE44ADmhzfzJ?=
 =?us-ascii?Q?4GsvOq4wRKYbBrPtIOv1WgJrcYeDtYOuGS2LN50G+9WQNlCjs04egymtMveO?=
 =?us-ascii?Q?mgdzpxO+eTClWfawhEtkViZM0xOr2WuhCnG+T7rvurnPDZxtPElKd9e1MjX4?=
 =?us-ascii?Q?wgiYAau05Ry/wWMoW3CbwHwmkjhC8RWanDNK2Rn1FmsNauycQOaYs8znf82K?=
 =?us-ascii?Q?1labvMQ3JF/WKs1A0XEIw1uQEjFbbOXkLnOQ0S1GC9BIs54GeEp1bY1EK3o1?=
 =?us-ascii?Q?J+okiRLln5vYZd3GYqf8gtNN6GbL3WGBq7sfeOYW5/uxG42cE5Qo7DixPdoH?=
 =?us-ascii?Q?Ywh2nPEJyXHLUEuhJm3oGGVRxfr4MYsNIakPRI5FMTN0PANjElY3RaOYMpXm?=
 =?us-ascii?Q?qIbVv7HNVBue+NVOeBNc72SGiC1bskBLOVmZSGQUPIbGtNKOPk1hubwd8VHf?=
 =?us-ascii?Q?l4KFTmtfimGl+UAhXuQbUMwv2C1GIPOr2kNml2KzfGFy8SnshyewNaljX/kQ?=
 =?us-ascii?Q?OIXKTSpBMrhF4pBFWtLj06RyjXHBjws1GBGDgjodmTAfLmiBdA+Xhwj/fPIf?=
 =?us-ascii?Q?daziYLbqiFR/0WNs903GAAfyy6urgSrN7Q9fogfOLknF6W19XzedI5mB6/D6?=
 =?us-ascii?Q?ufMAXWMO+ddPZ5M3FlXbIKObwnkq6+O8Z4JOyW5SpcGtehtdMdyinZlBRkND?=
 =?us-ascii?Q?1nQa0yik0J5J/tzo3DF5sxYKtlCck+GJOVOQrO9D88RpClwJLA7fYJDVBuBr?=
 =?us-ascii?Q?w3VPQJZIjw/mCsKEG+bUrGIdH/Hhhki/w6JLRa18EfP/FygrUjfZ6s+fWtCl?=
 =?us-ascii?Q?zBcq1lJhdTn9fSwzs5k1Okdd4jI22pM6Q87dhx6+4oCkE68/m4L/tNkUQdAN?=
 =?us-ascii?Q?4+XnkOGSoiMpC3R30XQSkxwOwaZUFagvt9vaQs8Od5T2sUcrFVsBpMHtUokf?=
 =?us-ascii?Q?20Ct+tGl7fUnGYwr9uJLBBF5hrzgyWc2c4z/Titr+dmqszgLXdrIl/tjfJvb?=
 =?us-ascii?Q?ShYG8/huLJaH9PJyJ2dxLbzjdb7Ft1FK2ncYu2ynB1LfBCT+7Mamu7wj9WSP?=
 =?us-ascii?Q?8Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: kJa6KEM9z21MsFZudp3fHNhdBvHABicBjL7YHBeNfIElvHgevh1Aj5oht8zZagaZmV6URKD9MP9NnQE2nolmPcFCh5kQ5dZaZjxQgFBCZv6L7GWIQIY3n3DNwb4OgKY3ZW8Ch4OgCuWqL2qL/NjY2Z5je1nuYUk5IaJfBmpjtjTKUr8GS6zpPyZy2UdG1Of+6xmJRyYP9xfmi+3cX/qjbMrjH7UIUwBhRbeLjVzDR1mAGBm50RMDcqQVypPnfYUrjlPtegiRkUy1gpjXxA2t/uJXKxyI3bsJRKZ1mqakHsyBjgxHz9NyYuZ3egtMh0WSxtBU7aeGNU5CodigiohOhgBpEUY+vxnFFFOGburBWGQEXn9dkFegpmFzqufV0FVsGSmipGkdo32Wfz3o8ChEEk4zpR3NJg/wEJnaw5MYmNnaCqkL1vrZ1iVtYTmPd63f0Qzl8Uk2IYhRJ6dPfAfkyIl3Xa3ryLAvbkAT5CkTi68oaNP8KpdEkevFVNsd8rhr7U/HStLfucIid++VlIIQRcA5p4/7TS7QE2211l2sVkmn7Lm64n0DFOP4Z/WusidlMWzD7Wm2hNWOqqjMBaPbjPkZBy/VpCesSdZqSL9lct1xcvfvGgyaa9et3EBZ5aTEfk/VwYh9xrCCOeMdY4RCzl2200KcFb+f1eRZPHsxeKhgTjYHU3/46S6r7dWSFMSSqtiTRnM8cqO+9R8i8EmkWn9JAtd/4St9V0pKIqvsTa3rUFnqnPi4L106cvJbED3G5nhbdLfdjtjMEFhYHKS4Wdf9aZnOXGyEm2Tj6lgIo18=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1145b1df-e9cf-4613-8966-08db6670acd3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:30:32.5581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xVM4EgRwy4ZYFXuwOUeP31cYqJQnysJNChenIuaLGYIBWoJdBciWiG4BFOEVfbAz9zhEdJP32dJtb8JALVuXPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060080
X-Proofpoint-ORIG-GUID: 4SdhqGJMqcaz8ahg33NDABsg13O7rjHD
X-Proofpoint-GUID: 4SdhqGJMqcaz8ahg33NDABsg13O7rjHD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We will need two sets of functions to work with two versions of metadump
formats. This commit adds the definition for 'struct mdrestore_ops' to hold
pointers to version specific mdrestore functions.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 61e06598..08f52527 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -8,10 +8,18 @@
 #include "xfs_metadump.h"
 #include <libfrog/platform.h>
 
+struct mdrestore_ops {
+	void (*read_header)(void *header, FILE *md_fp);
+	void (*show_info)(void *header, const char *md_file);
+	void (*restore)(void *header, FILE *md_fp, int ddev_fd,
+			bool is_target_file);
+};
+
 static struct mdrestore {
-	bool	show_progress;
-	bool	show_info;
-	bool	progress_since_warning;
+	struct mdrestore_ops	*mdrops;
+	bool			show_progress;
+	bool			show_info;
+	bool			progress_since_warning;
 } mdrestore;
 
 static void
-- 
2.39.1

