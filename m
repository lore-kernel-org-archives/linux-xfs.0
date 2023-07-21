Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A073EB64DD
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjGUJrH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjGUJrE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:47:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B308F0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:47:03 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMVfY001950;
        Fri, 21 Jul 2023 09:47:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=5KL2dSRBJcX6W/k04xfgLvJGNrMRIWN2CaQHACXy2V0=;
 b=jUEzpWt0Ir9+EZfa8NzqP6LCEEC2tIl8XrlDSdavu7UxPtUCL3T4Ydn3bOCK2w791czS
 Y8NGsxuxwjPyLzU/pr95tJ09K2gVrS53zLlayPbInktXqma8ga3/O7WOiUnun52Cc9CI
 tyVGln31+I1xVQKpXQMNltiQL8gXg40xJvDNOFt4loTLC1tXtiIxdzsGJ4yrQcR1lTnN
 rP1HEDdC03uNpEBFGQVHn5BcM+f8smHUIYMPLH0bXwhdJMVUUPXHCTASad7ctyUiIWaG
 QEtEmUDjaU2TGh2eaNG8M/TWPFshuFU6TXUhVvyDgEvIWAnagfMLKrDAJN+bob7o3fSo 8A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run773kmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:47:01 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L9BbeL038227;
        Fri, 21 Jul 2023 09:47:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw9sqwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:47:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHPlAbUzCB8CfLukXUe8F9S91ukghlNQUjfGAx8XJxxR6jCKzAEEGvdkuUuSe9ogy04wKgVYMa7oMyKnztplAnSSdjibZXChTdIf2zsF2CkIoX60KVTsK0MLhvX3K9uZFClAGTekfJrycTOLEdlM/DAbV7rnmHEH2QARpLbJdenHbSrQHZrvxlEV7G2rhXAr+c5Nj0dqXZp7P+v3wtEtxw90h6zt7aT0MhnZUpYHxpNCSsO60zfyGzhojhfWADJLGOwjL+7HiKCcDRfJWNO45lw5Da7JkPCmsi4UlBJMzEb1cd/FHV5WOgOBmgaNoZsuf7qrhHaxOOhPipHD1zYJvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KL2dSRBJcX6W/k04xfgLvJGNrMRIWN2CaQHACXy2V0=;
 b=MKjAztVbboiY+PlCplnLPGlEGBFpLTEkw9+1t8ZO5eaQIrIKqtoe/S0H9QcOJGavm+8K/OQyOtuBT9CPd9evo3OaenwHL/4bf1MbvlDo5VJjSaX9UV6k4DozvPUePhFgyoWJr0qq2EOnYoQKlAlxV9HiEgUyyILFNEfFUT3ToXXffA0s8DjwgJVdPMbebS+uI5CiD3446mPRp/P0cJyVvEbUNDmvoNXNbze286WGlKD3YM6Q1RcxAZXbO494C1CAYcEDhwCyrUgb/QsYZUy8qRjopetyOEiIe8MKuIVqke203ekeKMQm+K31m5U9Js9JUh8CVMkUGUZD8HqMkSDecQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KL2dSRBJcX6W/k04xfgLvJGNrMRIWN2CaQHACXy2V0=;
 b=Enfj7DcMsKFonvP+0iXC84mAam5KwHIljVDaI+arCGsBwlGEO/X1jYkUPPLo70jhcSklALb9KzwFtUexawzK5ibTtTz/0yNvVOy7ksl333eIysNeKhzWoVdEj290GKnGZdQMLhBS/3btL5Zbwtik7lx12qVsGrydoQ0S2FGz5IM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH7PR10MB6602.namprd10.prod.outlook.com (2603:10b6:510:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25; Fri, 21 Jul
 2023 09:46:58 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:46:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 10/23] metadump: Define metadump v2 ondisk format structures and macros
Date:   Fri, 21 Jul 2023 15:15:20 +0530
Message-Id: <20230721094533.1351868-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0088.apcprd03.prod.outlook.com
 (2603:1096:4:7c::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: 4665f266-f9af-48a0-4ba4-08db89cf6d07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: drJVkqM6izNoc8mZi/RXbqoNvlughtQQzX/IMIPPBbO/Af03eyeMl51SaiOWfx/iGPZLS+aEI1OUmA0O+3L80d0+ckD2xf5kM/DohuXUNK9o9RgdMpE6dE5hd3rZQaTl0eQDAxDjnDlZHeegpLf2o1Odt/edYOfYnos72dZT+mS69XnTMVWimhFP18rygnp3egL9+qvMivMDLo3vbdaD/+i40EqptQuM++SV2NljM1WLj+3+OotZS0O3j9NZuQYzNaVCuZj0G8LFXdDkqSVxUMMGmLkmYU/2dE5uM5DdTxoaWRuc66ij+Ov5lUGr3mPvDTa08+ZJkvezwdHODPUmNclo+Jnt89DmcCAbztXJYbepv9XOeaNjFkmPip/y7Q6AuSVNCzrmCqEqi44/Zt4+zbI7ZvDcz3pTAkRxlrR9GfeuzivIP3g3yE4bT8dKAcUjajtX41oFiNdvl0NsATDeUL2H/FlJ+DD69zBa/IrQZ5RG6pTnOIeDd/T4XBgX/HUYPBi+joxP5N9J53zFYiB+yaP2rt8jt8T2+AqJUbIoGQ0mR0xTjW2styw8D4HdNfGr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199021)(2906002)(83380400001)(66899021)(2616005)(36756003)(86362001)(38100700002)(1076003)(4326008)(6916009)(316002)(66946007)(66476007)(66556008)(26005)(186003)(41300700001)(6506007)(478600001)(6666004)(6486002)(6512007)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Iyzi70HddpRUq6mce5Hckfa5ExvEQIM8rMiuWnd+EDgc0GWPgUkLjdjy9FuF?=
 =?us-ascii?Q?Udq+sL8+0ItiiyPL09ICKdemnD1WVhIYBxqDsgczBgp5ygbTIgWL1tPwuQZY?=
 =?us-ascii?Q?nq5HNl9XPLq2USZPWkaI+zcwnnb24PfkXhZxbQwfxumR9s1Y4WwmdE7Nz6Wf?=
 =?us-ascii?Q?UN41Gb4UUAkdVCtG8sGT+9rgk2ZVtpRWLstO9wkpG4bfcqyJ4PTEfbhURrvg?=
 =?us-ascii?Q?8bSHvKm4pW9W/BwsSN+SyZYvhvJKWcvcdVJZ2TR9/MfZf4shGrxvL1N89uoD?=
 =?us-ascii?Q?An58L6f0RwVv85ZZHVVbPMEwNq385KDjRtZfOFfPmxye+d8ujJJqByOYvfBo?=
 =?us-ascii?Q?S8ssoPXxgIOlIHnRXtw9/+zPVll4OSeU13gU0BeDJxg6R4dQE8duL7QOebg1?=
 =?us-ascii?Q?6qsONW3IcNf8z5GzXrpmGFCp6fbSmi+ShbfAAF+qFLnVRV1BmXOpGmhk6gd/?=
 =?us-ascii?Q?cYXk7HYJvWIZVEo6VZvtvGWMKQjy1ujCcM8ZDzruV43m3cb9kT1wp9xLcyMN?=
 =?us-ascii?Q?RPrttYIxpWWRh4Avtbo3+VaghqZEYuqBsjJv5luG7eaDktnPRewOF0J2gE16?=
 =?us-ascii?Q?+by/RYw9xJlQp3wbMgcHjsSVWEDdzmrjhSi4VIRE/2W74UfiJ/J5izwVuu2u?=
 =?us-ascii?Q?kG82bpNvskimH92WTRp6X3PTiKg1gwk69D8GL7s1d4Rm3pFJqaDA6h6qEE0x?=
 =?us-ascii?Q?pgIlmqEcL34MGUC7KJQqgJWi1y0oxThmKh7qeWcpODs2MQBnwVL8JUbjkFZS?=
 =?us-ascii?Q?lam38pjZF7Em98gCgBKJcgGQ1hNlg6ZUNGVrW5bhNMZDli3b2dy5Do/UYQc1?=
 =?us-ascii?Q?6k3ftrfp8neVtctRDLr+ntynkJzz0dbUGqYBlkVB95gQqyPw7ykBrlEyZbvF?=
 =?us-ascii?Q?FDGA9j+/JhxZ/bCyF0xPwJgiFGuEaNku1Ir3DfIRv8eSXOeJVUR+SKj5oFkj?=
 =?us-ascii?Q?10Ze9rk8qqBguRMnqI1cAw22Rwt9oBMKAfCSPYtU/uTd9+SVco0DYJKDBDxL?=
 =?us-ascii?Q?z5m1P3DewZrYwcZFp8Htk+SW/pouWMGRvW9XVKvDfxjhIyWK+6mk7CuAuz/n?=
 =?us-ascii?Q?rEmd+HZv/w4v8uLnic5NMP1nmAhdCxa9VQdULE10uJEq000Z6aalNjytpVaO?=
 =?us-ascii?Q?meudWJhwj7CvWabxUBZR5vZ8e/hsT8kSxR4Oc/23aCBbkYE7iFE+YldjAdK/?=
 =?us-ascii?Q?tLpb+cXxffKURquBPs6u+O1LYnsioKl9LBjHbElrinw6FSI2Oi3/KyxjwMe+?=
 =?us-ascii?Q?ogMaHHsRR8mMo7VnPK5vCuWN0LOCNhMODaOs6KypMse8L1yiDt1J7g6Z5uCr?=
 =?us-ascii?Q?r3APF6FKUEr3Vng0+I3TWUNWUg3Bvse84CgdKA0UxicbOLZZu0WxGH2LXJ4d?=
 =?us-ascii?Q?05wyUQPRpcFoSD8lcXFU9hsORTwlCbrKeTKbvA6NbkBHYJkjXNKNyKNMnAYU?=
 =?us-ascii?Q?lQbsJcL3qGfEmaTBDOkqdxYCPcoyBXeOl0kjPZkOr1DzohZ6+j3a/UCqgRDD?=
 =?us-ascii?Q?z1wEsH2nXJfduXojR7yFM/H/fbKKRGqO7WYjMaPFqfv2pr5TnfQAos6eJWnn?=
 =?us-ascii?Q?87b4lUVvdBY8xKhwAv/YvGRgfKulMiBocSVzuITAkaVmCEickwtmwbMYeZ2/?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gFiv1rTi0HmVZvgRw9Jl4aJO9pACgIYNIjyD0397TpCnzmpR6UgGyKFfy3P0QLPEDuMUYGA9gjzbVKsoPQAhL528ckZKrkRjzVmawL/SIawIX13dlAI80tojG7zlu1UD1zkt7J4UdkfiZJFB3TBPq6sGvWSkiXgbdKfBrURTATCF/2Zh36UsfuXU/Hn/7lrNtLYDX5VIVan9XDtfADQA7a3Sy4/aV5aZSnpi/L6BK/ADQPOwGti6SQmxTAFMJFBF0+tlnssNvwqpaKq/4jWo8opnxc1vbBDp5ortHDvnCBSC24aYhmt6m8y/M7wyYxNM5CuPHxAbcyGQCUzwIqViCnFEcjr2OJBp5D3+Zp4gJYIS6Gh5AAzPslUhV1dFv4Oi5RbOYbhE/mUetiNIVVppTnad6xBwwo99UTmzyRWGq42Sc3d0WiWyyZeZakU4J/7f0DvUUAbwGum2E7asx9J/M57dO6Vli7j8eo4eWziQsRQGPd5Ralgu8bNdsAQXJU/GZCP2kp38/ZBcn2dg6y8R59nmJ3M9B9jHlUA+ACjMtRG8f1GPja7GsOcwXrjsb5oEKVgl/rvXrzLEERO6xOUJk63EaDVA0U5qnoWjAhc+MUYGdTHX/EQLu837R4gTN2t7GzFth0gkvZY1qwQuCytsY2o7U0VFoO+/JdQ6B5WiwoYtIBHy1WtfVb346ChMaV7WPuFZesGAxa1incDIJ5RdRR0M79wZ1P8Nuss4CB9mHVSeOUospDgIphd46YuN52qoJJE4/aL3hnsc7ByNvOsQuLIKk1hVb9oV7hgupD48s1A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4665f266-f9af-48a0-4ba4-08db89cf6d07
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:46:58.6651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bSsoBdBeckCtoN9spZFI7XaoOYwosgs/naa9MHmRaXaZVEWeCjqD2bdYLGToGaC3ae+pAZflFpSQNe0l+znttQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6602
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307210087
X-Proofpoint-GUID: L_juNGb4gfcQuF-Ce50U4Ohi8DpUZFcV
X-Proofpoint-ORIG-GUID: L_juNGb4gfcQuF-Ce50U4Ohi8DpUZFcV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The corresponding metadump file's disk layout is as shown below,

     |------------------------------|
     | struct xfs_metadump_header   |
     |------------------------------|
     | struct xfs_meta_extent 0     |
     | Extent 0's data              |
     | struct xfs_meta_extent 1     |
     | Extent 1's data              |
     | ...                          |
     | struct xfs_meta_extent (n-1) |
     | Extent (n-1)'s data          |
     |------------------------------|

The "struct xfs_metadump_header" is followed by alternating series of "struct
xfs_meta_extent" and the extent itself.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 include/xfs_metadump.h | 68 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index a4dca25c..50175ef0 100644
--- a/include/xfs_metadump.h
+++ b/include/xfs_metadump.h
@@ -8,7 +8,9 @@
 #define _XFS_METADUMP_H_
 
 #define	XFS_MD_MAGIC_V1		0x5846534d	/* 'XFSM' */
+#define	XFS_MD_MAGIC_V2		0x584D4432	/* 'XMD2' */
 
+/* Metadump v1 */
 typedef struct xfs_metablock {
 	__be32		mb_magic;
 	__be16		mb_count;
@@ -23,4 +25,70 @@ typedef struct xfs_metablock {
 #define XFS_METADUMP_FULLBLOCKS	(1 << 2)
 #define XFS_METADUMP_DIRTYLOG	(1 << 3)
 
+/*
+ * Metadump v2
+ *
+ * The following diagram depicts the ondisk layout of the metadump v2 format.
+ *
+ * |------------------------------|
+ * | struct xfs_metadump_header   |
+ * |------------------------------|
+ * | struct xfs_meta_extent 0     |
+ * | Extent 0's data              |
+ * | struct xfs_meta_extent 1     |
+ * | Extent 1's data              |
+ * | ...                          |
+ * | struct xfs_meta_extent (n-1) |
+ * | Extent (n-1)'s data          |
+ * |------------------------------|
+ *
+ * The "struct xfs_metadump_header" is followed by alternating series of "struct
+ * xfs_meta_extent" and the extent itself.
+ */
+struct xfs_metadump_header {
+	__be32		xmh_magic;
+	__be32		xmh_version;
+	__be32		xmh_compat_flags;
+	__be32		xmh_incompat_flags;
+	__be64		xmh_reserved;
+} __packed;
+
+/*
+ * User-supplied directory entry and extended attribute names have been
+ * obscured, and extended attribute values are zeroed to protect privacy.
+ */
+#define XFS_MD2_INCOMPAT_OBFUSCATED (1 << 0)
+
+/* Full blocks have been dumped. */
+#define XFS_MD2_INCOMPAT_FULLBLOCKS	(1 << 1)
+
+/* Log was dirty. */
+#define XFS_MD2_INCOMPAT_DIRTYLOG (1 << 2)
+
+/* Dump contains external log contents. */
+#define XFS_MD2_INCOMPAT_EXTERNALLOG	(1 << 3)
+
+struct xfs_meta_extent {
+	/*
+	 * Lowest 54 bits are used to store 512 byte addresses.
+	 * Next 2 bits is used for indicating the device.
+	 * 00 - Data device
+	 * 01 - External log
+	 */
+	__be64 xme_addr;
+	/* In units of 512 byte blocks */
+	__be32 xme_len;
+} __packed;
+
+#define XME_ADDR_DEVICE_SHIFT	54
+
+#define XME_ADDR_DADDR_MASK	((1ULL << XME_ADDR_DEVICE_SHIFT) - 1)
+
+/* Extent was copied from the data device */
+#define XME_ADDR_DATA_DEVICE	(0ULL << XME_ADDR_DEVICE_SHIFT)
+/* Extent was copied from the log device */
+#define XME_ADDR_LOG_DEVICE	(1ULL << XME_ADDR_DEVICE_SHIFT)
+
+#define XME_ADDR_DEVICE_MASK	(3ULL << XME_ADDR_DEVICE_SHIFT)
+
 #endif /* _XFS_METADUMP_H_ */
-- 
2.39.1

