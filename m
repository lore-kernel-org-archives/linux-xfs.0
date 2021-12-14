Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95002C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhLNItp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:49:45 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30526 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230102AbhLNItn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:49:43 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7QMeT004125;
        Tue, 14 Dec 2021 08:49:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Yfb+UyCobwelTzMQ6rnilnINkxKx5BR7DN1la4TOR9o=;
 b=htMG33o0Ojft/sIRUxZnKF0bZSeCBUsjXTq6KgWDLQcW6rgoVUsJdZhQGD6u47J3jZ9I
 M214ZjAx0/w2m6Bvx65yxDC2hTJ4kihE3u5q7vMrMckREQ8bWYKRFNGN88adYEDTnlAY
 XCBx7rJ9gyERWcR1ail9CaTY7548cTLt+BHFkiikJyAK83I9rsvkxRw72kfr4MULOJl6
 FaD13DwOcj0RtKsUBszUttEdNqM42WTZnHCiVyehIle7gW/mqPQVC5CSgwG6PGkvY4bm
 y9c3qb2lC6LV69e2fFAMIwaZ/8bshJpfMU8XxhGdpklPU6q0FNWJ8B3BLrwbfyj4/Zdv Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3py33d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8foUw104459;
        Tue, 14 Dec 2021 08:49:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3030.oracle.com with ESMTP id 3cvj1djssr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axxxqsnVIn9kF+0aMtTlfZ3QWBUmcTFqG94EGRFy7Hvp8xOE6eRA7kGgyPxAS7cYBViVdRGtoVJr6lttKFH9x4QvjuAC7MyFb+1nOTBKQIJ2VxsumxE7ym4iSbbTg/C0qGQ5qzqvg5zHuj4TG+T4/JMdS+dMia7CTPxTcPNdbFp90WHrZzFyP45Ere2UghxJg3knz1MkvCjDAd5DRQnTP8NUTd4hBUnAdkRLqCNe9RBU3cgkVyiSaRHhcw9xxAMz4CZdaTKG/CoDAypuXfmAwkBKfIhhGedka5GlQU59BmkbdddAWf4Lk/f0f1NAKCSh1gAb+wCUIiT6KzmvzGFFCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yfb+UyCobwelTzMQ6rnilnINkxKx5BR7DN1la4TOR9o=;
 b=i8taLkedcU4D/UUZGjW0wOIfU4bhmpmdWoxQlARit22bLJMxiWWLmChKVUZP+1h98EHZCqa6GFRlsPVkz/I5OfXuIfBj7nKn3ll4iWV1BMP+IietinJ2BQ1/A5Zk8FS6Qy5jf1Kqx+9hYEWcPe0s2QligszB/k/zX2xpLKUZRSiZH1jbl24zz9U8qE/pNoM4AA9BxK1covFNdWgjwTFhjzgJrtokSwXA/o8owbFYCtkFwFdhjHnGjLd4RUERO7srn2LZq+75S56YNSb2TydfSLHMxTd/KNPs6vBGf6ADdfAzhM43WlOUUB+PsxwAMXWwyw5plMtRQdGYGPElxBiy1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yfb+UyCobwelTzMQ6rnilnINkxKx5BR7DN1la4TOR9o=;
 b=HsgVNDyT/ErYq8W6DpH9hHcpJrheJpPZw7x5tFIhmF+XpqEgAxK3MD68lNRqn9c9eLOwkhq75nD0QXJ7W4O68PXozgyfAU3FYY43q6kZXqbAE3uih8/bCwNarLIxhbrR4BvFjW/8wKkaSiuoUtpIB9kwVCaMEuKprlYTJCFoEbc=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:49:38 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:49:38 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 02/20] xfsprogs: Move extent count limits to xfs_format.h
Date:   Tue, 14 Dec 2021 14:17:53 +0530
Message-Id: <20211214084811.764481-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214084811.764481-1-chandan.babu@oracle.com>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a698719-faa8-41c9-1cae-08d9bedea987
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2656FB58345B83E4B9E5AF2BF6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XK8blUVL3RidaD9/ONlmLIgXoJ0rPO3oKZoM8x5JK2TTnIrmia+In/0resszw/8uH7r2EWPtcfEJ+YhsYRaW21p4BlTDpM5hMEzfmQ4P4zpm9xGVzGbIBWymQew5Z0QsCnW3hUHafJZUFhKdUlrdQY8J55t/5pbBd6XS/1+M6nMNGs92zWjh6uEj4W+pLdA3PAzgFRMMtEKxm4do/pnQJJSEZwlQnHQ4Irint7Qjp/fd+brcrFqWbzzOEuHO2BR36qBresWVa3Kgqh9HmCkuEiDX7yimi2Jm3Pp8s0tpsjlrIgFJEhDydp/DDf4iHkGnWyFfF7ZpntwBvegJTXqSJ46z3cz1MdTflvm9DK8LEWKdDBPlAF38FZUg/9zZC6w9yDijF9B8HcK76SVkRiRxWHHyebUd78+8OSKtyyBuDEKc83n6bXs+mzgbpU1HUic+O90Lw+2ecifSCQjHmlmcwVclXZ2BWcVzxu8zhSl7SGXRhd5Ndi0I3YueplVQCtUaLqm8mfYSGQ5mHZM2UeEdwf5j8hjvJG3eDeuh9+uY7y9Ufos45g9Z4cc14Wus8RuRq0HCPX6AQVyRYysgB65dN5LKY1PlqWtAndX2981UBKeE56aC339joCGinp+037EjXVy77YhvI/ZHfvsHEjigO7i+XLGhPzTdHM0XS1XorcPHRoMrb/61c2mGuetMiTQR0adyNIYEqm+vdeC5HXiT+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(83380400001)(2616005)(36756003)(4326008)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eEweJ50R6qsNi5/sZVTCDpmig6YoYose4cRH038ad/QrCCbzBcoADdr3KAQD?=
 =?us-ascii?Q?bXMmrzV7TY38KyBMGjPTtszUmXYUetHWMP5vcQ1TLUWjfkIr60PMMe6/VFW+?=
 =?us-ascii?Q?0q+LzMheZ8RK6Z6FiM3CIAgKG5dah1Wsl3kkYzn3jiR0996/ayIr3rhUun3b?=
 =?us-ascii?Q?RCJsyqfrNLxY66R/HOWuTJ5MrNOJefZDy/FWlpWQQpBLDpUBXnhuYaJ3yR42?=
 =?us-ascii?Q?KfzPbbOMmFt0Fy2WCp5TAR4RpkTRbuqQQdEQZYkNqYhwJ33YyNwHvVGgbzBG?=
 =?us-ascii?Q?RUkIust/ejBw5xshLttJY3DBZLGibTh0ePUohErLSXT6ibZCiYPb/dEujYgW?=
 =?us-ascii?Q?5uVE4QtmfvbA1i0j2P2wRSkbKVAKWloLKkf9qBRx/nF44SvA5TQ8cQ0gL4Jq?=
 =?us-ascii?Q?8rSdIchDEeOdzNZESTwkfbALEroT6elwlR0POMEiBXYNpVKWXAcA2W18MtaQ?=
 =?us-ascii?Q?ctNc//07Ymz2sFdedOCrEkg26IVh1gNsdfvkZONlON/iVuqPCJ/+naHiBOqA?=
 =?us-ascii?Q?BLWOk3+muYPWECacRO2hoPHAVS5OYVVd9JA4Lph4tUToJT9xg93nI8zIBdhj?=
 =?us-ascii?Q?xpJctoi7OsRGcrkffMVGN/jjgFC5jP7WczB4IcKpcolSRdaQxLaeYa/NeJXM?=
 =?us-ascii?Q?rNhZrSdJOzRQ3vSvnHJ6xdK+TfOG6TXZzXyQinpGKGZ12/efWv0N3u54jph1?=
 =?us-ascii?Q?Iz0Cxk0e7bLAfWYD1eV+qQLLvLHZxfrC9kPr6FPdfECxgNs+YjGXNN3O2qhI?=
 =?us-ascii?Q?jhYbhQu29gY7W4DPh9Q0JJZ9rsyAItiS1SDo2/npxBMqzSt+wf01fO7IDLJh?=
 =?us-ascii?Q?jmL9BWpu4lgf7UisPkQLIBSGyucNAJbDjWTnxuDpFA3e44CxLBMCv/VxUrBo?=
 =?us-ascii?Q?J8Hz6BWie2teRqNwiHKLK4QKiwHBL5X/gQBLtYt2oJLOAAVYwx2y+wDpi/P1?=
 =?us-ascii?Q?RKk2QrNhSbot/J3NZgZAEzHN2tM2gTNVW4at5euE6KxJjMj+U3DaZZYMhSLc?=
 =?us-ascii?Q?gSB50yktvcmMbRCUjvYd+COdAMBN4RKXuudU3ECU/RMecou6BUXQUxUtMmW2?=
 =?us-ascii?Q?ZgN2FlCVu6fH+2e6a9hAFAYJn5Vmwn6pmrdqk/8Ir2L7ettC/e2ivpo1G36c?=
 =?us-ascii?Q?0o1RMNOvYvG9iHwOzoFPeXtuMohHiUcSScMQqTL/8wPmEf5rEl75Y7uBqncA?=
 =?us-ascii?Q?1Uw86P6VS+OPnGwl7jfhmvsHAlOLjw0Q2Perf6wVdB5LKKM+0l0p3vBIXeIg?=
 =?us-ascii?Q?K3Cg5kRuH/ga50CRjZWJJgn3SFJPwFuzkgXXBragh4GgiNwfgPEOv0n4gplZ?=
 =?us-ascii?Q?I8PvlCH2WHzCBe1iFFGsc1O1R4mY54L/9I9usdC6fgoy8qM01rOldbfkefUB?=
 =?us-ascii?Q?sOBPqLgCsKCCA+VQdeF+5STJebp9da0qf79twXwCXLtESXJODUiSPz9X9RRr?=
 =?us-ascii?Q?FlJwehGeMeSbkJV5Kn2R2SfzNlBQlkZmd6GTA8VdqixdjzXQ5IR9Rqs3zS7o?=
 =?us-ascii?Q?x+9L+F3q8nGWYDKuDDnmlQb+87Y6j+suFkqbWKjqBMQ1M4qHBcjY2R06C8Yb?=
 =?us-ascii?Q?anIDhe5T/uunmwY1NRtefmBlYlDhIBf9sEJMQ972DlLJKwdK69Ky6xfcwyCL?=
 =?us-ascii?Q?USeMI+Xnct300Z3HpcApYzc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a698719-faa8-41c9-1cae-08d9bedea987
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:49:38.9232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nsfcwq9oxexe6BjplUa55zN5yjMqvENqti8WqM/5RVgKRcOEqUfVEmTcMO2kcFCFmMHbmXlkeJ1p/uUurVwaOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: sB9j2S7H9QwsIGrChvJzO2VAioOO60Xb
X-Proofpoint-GUID: sB9j2S7H9QwsIGrChvJzO2VAioOO60Xb
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
index 37570cf0..1e31c31c 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1051,6 +1051,13 @@ enum xfs_dinode_fmt {
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
index 0870ef6f..7ff162b1 100644
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

