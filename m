Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85552C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbiBXNEk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbiBXNEj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:04:39 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBA4230E67
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:07 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYEUx007294;
        Thu, 24 Feb 2022 13:04:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=iNV55zyITuNYkqP55QbvGKD/9pnnByfTysigs8xxDIs=;
 b=bSftBdj8LMgPzXdYjSQc5riUPxP7yRF5p6aNWOUIhrhKeP92JKLzc6sSBsrgtRfsCURP
 S1AXg/OHM35KmFqGVLYYGJbWluQtBHrPi5o1Py9vLnSfcfbmEhl/fHmCMJ7iUKYiJ/Yk
 OApTpi552jkKqsEV3cZf2KkYJkW0fb/qI8QowXoKfCS5uDFXWHJJdylqBVgfPr+DcrkV
 /I88cpcDlRjiM2mFfnKoz6R07er/qcuLyVGe5i5GPIqvS2UeqGLtGRgCcwUEb4UYmFTA
 0ztMtAgk9PfwSCRF/tt7jV6Txljay7Jlvtgo+GCkK6cv3NSCmD9s7Yd2GAEAGPZVMtdw 2Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ectsx7b4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD1gjp039583;
        Thu, 24 Feb 2022 13:04:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3eannxderm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOj5dn4nE/X29+R27gG4rMKvNZL55I1ZwUM/5B/r5eeEJCnW6acEqjZnaCU5yGzsRUE8/SvhJJyWyprtcJe6HRV1EpW03CugQj2R4LLB6hCgI6LPUIVKVwuW9f67vXHy2EWlRSwdTBkpWNTCrrm7zbAxGCCh4Q1VbPu2zYhCACCHBDBPcXsx1D4s20pCX3tr2WIh/5gg4MX2GSo/1DdcpoiWyRQD+RTzRo4J2NZL2277htgxWxSyni3I9cOi+pNJIGgIKMYVZWkOQU5rhvQw+QAwS1b582/PvUu0Co0TtU2Xp8g1idAclV9cauAgg/JC5uoy1FBt0BuaCxacH+8z0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNV55zyITuNYkqP55QbvGKD/9pnnByfTysigs8xxDIs=;
 b=gWGzWr+fvaOlwaJHWVV2vpREbtYgUDUnkkzxIj3e59QRhQp7igxDDFzcdVFjN0vWhbUrfQ/xsUlMia67kgFv69cBlwi7c5YHM5SqQ+kg1RzvqtUyAD+o8kxG1ynSje9KZrAX6F8nt+kNEhzcon+t+jOyrONu0awCSVZHfv74g+n2tAdYN+DsGPco9Awdm01KeDyByBPlK0TjeqUivCU8Dytzo6QudJK59bJ5hScC9Q0Lby05jF+L0ruF2qxC2wpHk+SSaLwHCTa0wIiH4t7KashZHtW2Iw23xllLf3AqcEoA9k0qqWjoVMtOXJVa08tboCQukV0NwgF8qrJimDKHbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNV55zyITuNYkqP55QbvGKD/9pnnByfTysigs8xxDIs=;
 b=qj7uI2KL9FosyP04m3WyDlZ0aXXg/hHeYcxqHiMjlcosvpuFuUKnZbkVje9Vk4lyDeEkcmN3jEJa8VtM3bgWY/m+9tBTEIOFw2WYLJWp0ng3rxW/uKWN6YYUzc7fzoewdca9FgcqO5Y/CYnUke0Xx5GWVjy4f+AzQXSXsEsqQxs=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:04:01 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:01 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 02/19] xfsprogs: Move extent count limits to xfs_format.h
Date:   Thu, 24 Feb 2022 18:33:23 +0530
Message-Id: <20220224130340.1349556-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 970a8798-2f2b-458a-805f-08d9f7962033
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB463486F4D5495B42F3DB83D3F63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qnX9YrHiLfae2pGQ1zL78emWdUKsRoMVLR6LM5duhJoUOsdi9rUNvdzCC6ioa0Gn36CPnj8tVRs9OSdYex8wEv7OWVWnEtxvSMKoJ10SmXNnv06YpGIckZ2bZdW8/uQlaM6Md5Lz72vYvkrYCa9zUyktA368w06LNzjB/p/O2wlDy7LrBkQICs0HCD3c+biTguAA9yZr2GuUnytOMRWCwACE2VECEILazCk1YyN1g1eSIfWhlvAPnhc4spC61mm5mi3EN70WAwZqCIcG9yIOnb3FdKmBZo59UH4xZdXvjzfjHNeINlO3p3rebRN+p4dwkJy3dy7KpuRb7ZPevrGGcYEBmP9O8x30gwa1VV0UdCKvh0PL4lBWZvqKcqAHXH3t59knPLR7tHbmP2gtmI75UHnIS1Nb5gkCQIRu/4Qt1joU5gVfAGHSSwFksnickNqYUlQ+M6erV8DeBgR/lVQ4j7tR8cPZqioIsxIcff/8xsnOdlBbW2mBcumo/OSJJ0Pkbao3k6H4OJX2gmI3ZEUohzSQm/0v5hGaGLEtsS/9copErAtzHMPVmUf9XuSDhRq+fMVRltvRzq59t3lHVObLX0nodPi7xORRrzAoikKEa4PoQf6V3GC/8ztMXkhqiuS7tRk3MGDevO5QZi6S4RElFtcN/SPVWi7aIP3Eda55XSYTpySLQAB1dw8K3ZDcVqe7mWA2jhCpxhN2Iq3S9kBDUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(6666004)(38100700002)(38350700002)(508600001)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(2616005)(186003)(26005)(6506007)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+2SGPtiGu2gqy8TaguYkAiOlNQeLLp301N/BJIzA426FYnGf+z4ERt23t3PI?=
 =?us-ascii?Q?MDIybvy/8tV0BXw7eXhOasJo9ISCe4eOBmKGma2xwK2fAg0eilAI3FbxfNP4?=
 =?us-ascii?Q?8wlG8mLu7jEO6hcYPy4e7jOlYR7zMFRqw4eMBEje3PR32OlrYeyeZ1tOwHs8?=
 =?us-ascii?Q?2PwRKF68yryKZTgQqzF+2f03PFFuuXVl/XpKYxTny8WcvhJ4ETOHAcltaNvA?=
 =?us-ascii?Q?nF5ViIs5sNViZLr0RKsf5GMSZPWBGQwGydxPC8G1w9SA3MAT7VU0oyN78EVz?=
 =?us-ascii?Q?VzjG4gZHpqeWZHbZnHm+RpVciwWJs71ZetvNJtdWuaKEs2ZipAIBekb05i1Z?=
 =?us-ascii?Q?GGV5LQaS241pDjdnIuUincpdCG5QXNExFB+/EDZeD0LjcDfqQzV6Zq4vyVc+?=
 =?us-ascii?Q?RV4LCFv06l840X3fMGaZLIF+PvKQ21PPcMRFRDlyyhIOZVJY7Gge8MX60Qr5?=
 =?us-ascii?Q?Py2tEx2pDuhd8KCw1/RKTDl0+OqB4KJ9GDOY+DY6fQB60PjUUHnjl3cD5dz/?=
 =?us-ascii?Q?BURHhzjJkEaUQUjKaDlTVm0v1trFm6qdDQzZdhW0JqNHwhszGB3wdRbK6ivq?=
 =?us-ascii?Q?+rX85RUKeYCYQMa8zGYfYM4Lnd7GljHzkzKGGL2YjRBJ15Ba1C5ZmKSSxHps?=
 =?us-ascii?Q?L5apOmWVOlkkKYFuKPaiCnk/gzpz3AKTNTdSGzKJOrou55FVdr7cDy94+Uxa?=
 =?us-ascii?Q?lkY9+im8v0YslHF1h3LFY9RXOwLzYQkYhQjsNLjFVJWWpmWKl7Qjv510pDDH?=
 =?us-ascii?Q?AOIXRIDiU1m335DHPettKRYna4Sya8+WPTKn0sNgQzn5oTDhGNtCNkV7lBpF?=
 =?us-ascii?Q?2YAdvAheBwqeCRAwQPE0TrVFHjFi/gsd378SII99+f2EUXdjopkkV0C5JNWO?=
 =?us-ascii?Q?rlJJF2IjjnZfFupqbuKxG2zzdeBu2cvaAFd29DwHXLFL4J+VtF/oUkwWIdgW?=
 =?us-ascii?Q?2lFkjf3gGQFTGLi9tG3FmCSpiJBstjb6xfdHhp7b9DrGEMf/8gbUx7B79jOo?=
 =?us-ascii?Q?wolW6OdV2kaVbWnsR/TGnI+/4C6LNC7XUJxsi2HWTALNZiUnRgF3ZQNJ3TFZ?=
 =?us-ascii?Q?CfX8aWBadZ4q80vEV1R6eI69RnnojouMC0KoPhosaOTG70seBra+XZG4dCqe?=
 =?us-ascii?Q?YFcCOWON+Jo0ptLv7VXc+GkJVMSrhdn7NBgNXj1zmfqyjtry9JYIpDm2v2/4?=
 =?us-ascii?Q?3Xta5ZCDskHkMFcnYi1tXeBmJpShz31JzaeAFbWvHyfSZMVnlKs4spmAbjsb?=
 =?us-ascii?Q?6zbtgIIi0wmynDN5b1Y0hX8YYIYxgjRCA/vAln28i6/KVms8/ghD0EIzofnY?=
 =?us-ascii?Q?rVW6O42pQ6zgZdZEIohz34WFQK+7JibQid0l1X/kCg95Th42tAkgZ5KRT6l9?=
 =?us-ascii?Q?l1cdpjdAAn9bCF2lyxPCHBSp1IO+jxgcq5W6WEq7EKSMH2lMknFTzCuONx3c?=
 =?us-ascii?Q?lqyOZUNImz/6jLSr9n17hE1Ql+D2b0+Apn0MMKOFTPC6OgrDsL3W6pJnRbf1?=
 =?us-ascii?Q?KGMCo1sJ5ri2sbZG4zPaOOlZkO1WNdSx/RXmXVqNM1o+VQPsfM0b/NCOPrUT?=
 =?us-ascii?Q?jF038clOaqCxeny+d7uHvIYuWNa3rvWav62IFANNdvvqk4UoDDXSr00KZHWI?=
 =?us-ascii?Q?dm6ZBAmu+VujEGBxTZwpiOw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 970a8798-2f2b-458a-805f-08d9f7962033
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:00.9693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2SBFXTmadFqBjyEoX+wi2CgZd+Q2/zZLeazFFIH6wK6sje3R7+Uk9XtrPZL8N0cPMRHGGPyWdIXbIX+0Vzx1bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: ZaJ4YPXtCie6yNiAniay1VZMx7TrZ9cC
X-Proofpoint-GUID: ZaJ4YPXtCie6yNiAniay1VZMx7TrZ9cC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maximum values associated with extent counters i.e. Maximum extent length,
Maximum data extents and Maximum xattr extents are dictated by the on-disk
format. Hence move these definitions over to xfs_format.h.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_format.h | 7 +++++++
 libxfs/xfs_types.h  | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d665c04e..d75e5b16 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index b6da06b4..794a54cb 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
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

