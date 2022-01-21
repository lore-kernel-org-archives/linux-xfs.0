Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA91C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiAUFTj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:19:39 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:33686 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231447AbiAUFTf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:19:35 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L045iE018296;
        Fri, 21 Jan 2022 05:19:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=LNbi5Yh6ZLH9WdE7OeKLnm0Pecr0XTe7WfHMkgVn79I=;
 b=VMQMHcj9mcO1l/JpLo6mmEo5kYeRdLOwXH5vMzO3NBI6JYp5N0E+k/nmV6kMPPO751L2
 zsMitllKcuFYLCkJQTTupmpkXphTPqFUcJJKvpHA09ElulHbRH/1Uacp16el3kkhA/uA
 Y4PPzRl2eTM7bxYZg7pG1sSNgD/RZUG+K3dG4JkeXVZXwupPXzkJ+h2paFjqss+TGhZa
 qZvor8A4ScaUZtaT7OBSgqwjM5EpqiCVpo/w+h9MagbZvEgV5PcPkEoBrtSNpxl2s6KP
 bAq93r3ZP4k3IJ+mPLvKGcw3tLDW4wDm8H8yKBITYjlATdv3N92DZJAbDbD5zkdbT9QX nQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhycgcq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5GoAu082183;
        Fri, 21 Jan 2022 05:19:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3030.oracle.com with ESMTP id 3dqj0vbjy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gB4y4M5sWaYE7rPiPR1dY3CBzHnQpDZwopn4VvvwXagVQJc0hvGUAWDTD0LUFdhhTWg7m2b0LrxzgKgrbLnG1fKkh0XWuM9hkRliMIr9M/7JZ85s5vcIqJPPguE2Vdq8DMsGz9w5RcksXLgzflzpaVYCIc5cz6uUsOmj3Uh75sMhmlvM7o04KyGsUWapl3DCkcChlzJU95sSBJ9wL5eSAoU4TSBi2SKlDDVzTW9+N9z/NQhGVsso7mlZkEVEA7k74WzV/UNFheE4PTZQ5Z9I1rE0AQ0RENALV72A09sAT+OczmMmFAoV5O/9ZZ9AZRIAyHBaFpC4wt+fnJZoAUYzUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LNbi5Yh6ZLH9WdE7OeKLnm0Pecr0XTe7WfHMkgVn79I=;
 b=kab31EFrxVEfM0/H7t7SOTDVExJ1M+czpBKjjFEPDoz9PRVhKREN81LdbFgVzTyOvKJ/U9u7/oIxRN38jD0ltDvZDec8lPuWy9xuV+RxwRvDpng5JB7AO2Mc0niy8h2qBH3TZOyEsebw7KH4Yk6dLHhu6mKcksOKZoW6PCRRvMqHTpfUtEVq4wjiBZP2gXlJk6roYbe6OKttUpi1TkdXVfUC3VBiEEfFEwvzvHxkJXAG5Z28O2xOrH+yS/I2xKN+Qom8OElykDUFXifyNb0yTs8d076zL2OUnUL3o1LeJpDNK4FaonTx4keYKldLT5pw38sqF7O9K2Zdf3bCk+eFUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNbi5Yh6ZLH9WdE7OeKLnm0Pecr0XTe7WfHMkgVn79I=;
 b=GCjxWT7t3RG05Iq4Cy4i1SfWrvAoFk2t934zOJVULfUMEqin/BNv0Xuh+kt/FchVjOJlxE+0xTG0ZLDrXpLcdBvJcjf+1/0aaJFxArGddetLyiQarCTrYGPp9sCxNKTwjHoPOYkeoG5VYt6yvOic4/dxZ7EOMo3MDILBz8x8jPE=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Fri, 21 Jan
 2022 05:19:28 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V5 01/16] xfs: Move extent count limits to xfs_format.h
Date:   Fri, 21 Jan 2022 10:48:42 +0530
Message-Id: <20220121051857.221105-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121051857.221105-1-chandan.babu@oracle.com>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09853f82-82ea-48d7-9c36-08d9dc9d98b2
X-MS-TrafficTypeDiagnostic: BN6PR10MB1236:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12364A8BD30ED0222D789188F65B9@BN6PR10MB1236.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I7YIbVMUUsrGzKfxdVU/QwhYmVUh0FX+CSMk3ILqgMMCwqg8C69flU8qefOO+Ot5MHP9pGF+KoIXvqthktq6U26JMQcIwV+8ywx7KQyqLQFsYeMqxWPgOTMVYwdIZL/HFTqCWOta/2HfMC2K3nJGQx7lwuFTVDL3O9NYd6onm7htVixnIaMwQpD+4mkcaAYJhOaYj72D1OigOxgbCin1jmYks/PXWldSWPmarmYxBcW1oWMjV20fWMq3TF0xwLOfrLIqzeGNSQQMfy+MmSjigSpZ4RjrMH4WtPiq+ogpWPHH380hbFWUGNssSu/ORzkGZSwxc6PBuSbubV5dyQfAMfxkaO3dmKl6V8a0VVkoHW2D6RXZTIZHKaFVXD0+d6JOrq/poqQQdMinaXjGTJdsKvAgoc0NLgNEew7TTG5GQzMG7mqhf3KR1Je9UsaWOfhFatOR0JCs2BLlsWHX2hCWtGETV2u+OTC3V1mX59VrQU3hHewAqDd1aqaJ4bgUoGkG1uC9Rg6lkiEAB8p5iyEKdOBz6R9ym7TL90NUd4nrkD/agt3ImaULEJry9YQxfcOOL69Dfsg1VvKOYibfAVOFcQBvJpI3ZskYoHQXk2nEuSDCF2ZZ5KP10/dqdM7mKsm6fFBzZ1OvPn2DMbsmddtsLSp5msSz50BZ3ezfKWFosBGGfvZEPFKVNKt+PLZPJwGb09jbnY5FzC2WEDFRcgvc0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(2616005)(6506007)(186003)(508600001)(36756003)(26005)(83380400001)(6486002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(2906002)(66946007)(66556008)(66476007)(8936002)(316002)(6512007)(1076003)(4326008)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kr0hQdMGduqqCWl+DJwnOk2OtvhUPYGv+ilDPvV/b1r6IJtYfF9IEbuFDTWv?=
 =?us-ascii?Q?f/3BhwiA23mK4aZJCnBa6uWuQhXNqyw8zUceeS3jzoQCn59sygmdpGT8xXOY?=
 =?us-ascii?Q?3Cl66p8vlPcLR56HMTBbrFaFuMcmYek/vSrYg/MtZxTscChPL2d3dMVu1sGb?=
 =?us-ascii?Q?I6K0jNFiW+OSZKNb9BZp0ovLvnPmp2ZjEJElewtEBSXlVK2fIJxxjYSWUyzO?=
 =?us-ascii?Q?Yb5T+40sukFitPhbv7KNhH5oYi5jDV6AvPOWN+b9kesRnXakk4C+RWjL9T6D?=
 =?us-ascii?Q?IDq4uEJA5aM6MUz0HiopEUXSLuPsBOdhEEKh9JiNyybtaCMZpMtK6616E15H?=
 =?us-ascii?Q?IVIiNrDhteA+DeJ2EB1VMDRFvACjcLCMniHxs4jcklpSDj3qvReuFoeEjAlI?=
 =?us-ascii?Q?KAeVE6aKJf7WQ/fPdHET2jdp/LJ3Uzor8zQmIudd5SOR1cUgXQvoeXpWMy4g?=
 =?us-ascii?Q?IAOyKCbkecS87Sg/uSjIfKFrpg9ODkcGxEf37M7piOq5k758HyEXRobZAa5o?=
 =?us-ascii?Q?QM+9sWPZ0AfVLJl7WRioDIH3q5T4Vpk/ZM+c10W8JX9WSbe36B9XT2wUrvSe?=
 =?us-ascii?Q?cV1cdtGmz5V5YykPh1SMNULK3tMH6tdFtZRFIVt7ELeZUbPum4dbbe53B/2E?=
 =?us-ascii?Q?fmSLvm9JSztUTiWlFAxAXNDWJ059qwcRSq3RfOvSyKyyvBA9jMx+XCOaaPmn?=
 =?us-ascii?Q?neN06O5eJlquA2ODJU7JoVmLr2jw6boe9LkfSvIUWxN0qEjepKHLkZaancdK?=
 =?us-ascii?Q?qXy+4viGiLRWPFuzey718e0GSMiE88T+T8TqUpSqYIgsRH/DZVy1NvEyqMva?=
 =?us-ascii?Q?6p/1uecJTOJJuq//8EOW7L+1BJPP4uv801vkjooRwIXoeHrynetEQ+H9BHFk?=
 =?us-ascii?Q?/5N+ubzD7UNvE1bxc0avf9jvzbk/4NRHOY2wNODcpL4el+HS0DvgMadzpYVF?=
 =?us-ascii?Q?ABPD02fzkp6C6ocznrbcjmEXsUzpCVsi0RlZiMBm/XW6Q9FwJm/aI2tqhpfm?=
 =?us-ascii?Q?hYfJndz82OlW8duHM0obc009KyUeB/s4xe04T0tsqm1Nk+I3riZauBoo+pPg?=
 =?us-ascii?Q?A3kfN3mnp5DHUqXm0d/aSyepm4dC8Ixl4HxGOFZqo69T3hieuVwxeDmXVgMM?=
 =?us-ascii?Q?Gf6sIKp6LjVvnTwWVPN0W+LxWYCL97iXBXd4AGYFLYiU5oXbx90MdsHCfost?=
 =?us-ascii?Q?eaMpvk5kVY6qGq24mAZ3jNg13uDDLgSdeUBBTkhBgA0GVz/SoJXVHVLFbZd1?=
 =?us-ascii?Q?pTo510q4Vo4fXIi3FmihTLF2jDw9LUjitdrrUAFqLjX27QUtF2ef1HHIvvjj?=
 =?us-ascii?Q?Rm8TjXgThveNeGn1lxvIslFqaYtnikaamel61ysYwMwxqrdWhlY92eJhFG+R?=
 =?us-ascii?Q?scnZIr3y4DW6eGM96wjfLylhOhPudKfk8md/yxer2R1P7nUifmoaSg6HbTd3?=
 =?us-ascii?Q?NbemmrGLZZiy+iIFit/rwKceunZSnvmPJWDglm/AZhd2RGNvP2PLokgivy7p?=
 =?us-ascii?Q?fXuh2I7zJSWsAIuPxIOEkyCobLFaUlEkRiMTFj2O9Af3luR6BU3tnPMqc3o7?=
 =?us-ascii?Q?qGhAVnbbVAzjJ5PiGkHCQh8eZ9Z2kKLBc54rlVblDOMQdNUV7kwhrki9/Jf6?=
 =?us-ascii?Q?jrEi6UuvoGck45CpzoAxkfo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09853f82-82ea-48d7-9c36-08d9dc9d98b2
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:28.2098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F9kHmxv6Jzx0rOzGaN6YhmTqwU+Eah7ITvfQVkvbZFxgoRnszoiCa5clZz+LRa/5kULrLFKKCKF+Mk7DsjWD8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1236
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210037
X-Proofpoint-ORIG-GUID: 9aIMCA1Toqc1i_fB6bpMwwVd-I3dr12M
X-Proofpoint-GUID: 9aIMCA1Toqc1i_fB6bpMwwVd-I3dr12M
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maximum values associated with extent counters i.e. Maximum extent length,
Maximum data extents and Maximum xattr extents are dictated by the on-disk
format. Hence move these definitions over to xfs_format.h.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 7 +++++++
 fs/xfs/libxfs/xfs_types.h  | 7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d665c04e69dd..d75e5b16da7e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b6da06b40989..794a54cbd0de 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
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

