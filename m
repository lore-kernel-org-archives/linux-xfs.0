Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB16BC4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiKGJCJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiKGJCG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:02:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CF712AFA
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:02:04 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A78mQfd032427
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=MJB1AW2UOPFcnTki9xTmVDwD38jS9Ra5OdgjhRQ7TsY=;
 b=WOMFfedeo+dOZJ30ggf7Zb+hhQ9taBva9Ni0+oqm6f4aKQPJrTG73nERDyP4TI4DHtAq
 BQB4zhJ+yGM8NoQS6CRD+q5Ax5HcqW085syx+eSGXDs2/Ihldx/kXc7LLxXfDj/xlk9O
 lx82+pLMRFo5HtUTQTNVkXe9aLSqYNA5JFvgsw9u0LW5axdHf4K9/NPrBy6UQGv/9Y0+
 aVmAiAQ7Zlzmnuoxe+azXlxN/iXpF77VMEiver5DKBY8kg5VSciBXPiYu38sy6KYrEgK
 mUAYmKWQ3wNDV/DiHYv2yjt4gmSketEgcrNt58sa62xxSMyi9sNO0nTyH7ZQaKoXKXH6 ug== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngk6b7jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:02:03 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77gipo001698
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:02:02 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq0jk0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:02:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bg8tFSpv7pEb7Ogz5bIeHMT9NYwAGM2z3ZQCGojVzb5VVHpbvQ5MVcNxJjf0ybCo1KpwqYzxbX9CNfDKftNAYW0eyxzOJ07ettyIhT84OSZYpgBlKcF/djaILykVnqB5pDHV3XpBun6GoD1Ws3psfo5G3RR9qX7BQSuIRD6+/BSLIyGbe6i1Qo6mJHvGwtyYcyWfCGHd9wN9YuIiZ09OabP0yGjv7w/cap+8M0AoeDyL9tsxpeBtYWrcnhYpGFqwQXQ5p74n0pFDCTGhQ+wFYjkvo/FWNvoVlEw4We4YAvt5y7d9kiE6JHoHpsxSiwKkGH9ivapHnrXD/OgGU3diVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MJB1AW2UOPFcnTki9xTmVDwD38jS9Ra5OdgjhRQ7TsY=;
 b=G7/NfXah/PzQHXGazW/79yw6Y/GpMOHSPci1Nz/scybM/CFOrrsFXaqdJivNehkXG7Uor/i+gJHdsDDBbNuRbjPR22TXsV8KdEgOSVhTSrmJmTwxSGeN5ANj03EbfKiy1Nd1V6D/AnMK7fx0+7elxU2ec7YzZJWCfGa4xnNf7NExy7fKTsXO60BnJntB7xyWYe0TlFjr8GS/hQCGQTv7yj8Npg9CCHYfVrYko82q6QrAclwQaqXG2O40t2Pg0iZJJCT5RTOtlC4O8DeyOep4DYjDI8CV8p+NfT0BPMU2IpetFZRUpQuP8bE6NvlwIw9/0OXNS0qT/0oDI5hP1tDuhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJB1AW2UOPFcnTki9xTmVDwD38jS9Ra5OdgjhRQ7TsY=;
 b=bt4seHHvYDx5zOTP/xxN1g/MIknxAx15mdT0LePsMA9Lk+BU7j6VHbBWpREgiVmHalZfUHbNREJbx1uiB77GAhHfvjw1wyC5EGNfkVX1jpqBhS3GXxqKTsCwWX7sO1LQ7HdAlMwRaVeofr3eh2E8g4gW5DSs4A6HbbwBn+vJl6c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:02:01 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:02:00 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 02/26] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Date:   Mon,  7 Nov 2022 02:01:32 -0700
Message-Id: <20221107090156.299319-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0045.namprd02.prod.outlook.com
 (2603:10b6:a03:54::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: 19cf3c95-8091-4382-a052-08dac09ebb53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uvn88IOGIeEp9cWulvotbZGPdg88UTIGIrCeEpfwYPAbw/1IYBbPWElnGqqrz/1/N2KqEn5Fe6gjABif9f7dwfKdSY+N5S3b+jI18H8kcbGQTLg5jWxAD/uPum5XiO5z9XWZWV9eEHnzwCQLC1timFxCDwie/dhssDmXjklrNfOz4Txu3FzIC2M28a+MOPTKiNkPsAYW7WBkJ8TC60Q4R166dYrAWfcpYYb2BFiPx5MjaQGNckZr4uTBANsAS4jhP6nSjaqLLgUqG9PMY4OGDd1BGOlcbzpI9JjJ5rzpPzb3lZvsjx39ajT3EMyNyLnwr9tzOAOYDmxLvjHWSJA1B0E9VIJdrseesPyII4HQcF59jtkJP/wyWKvXcmYToKyGgiSD5Z4uPqd6d6jXGqCmyRQtA0Cg0/yjMHX9n0K9pDUqmnA+TfEpfL03ZfmMKrz34t540XDgkn/Bb+hBbmrQdhktt4oecQjqI4oXOsiLjMqUunlPIh4SS9gkUbCbFvoP7jk9xFhk0ezSx911eyysjR+tRPWeVg+STGoSwmaF0xoKqBk0QQTwIAl4oHgzndR9XiXjy3l1V9E1J8jAQWClWvxYJMpYpsA83jlnpQwQtKJdkGywff2MLIjsjNlEb2bfrJzHFbc2Npjf+X8IdN/e3+0UdqyE5PQHw1fYLDS0hAQNZhJPrIitiYpCy2/EVogS/C7SbiSUav7wBtgF55+YTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y1FbUPjvEq0Cb/rrsULIje2MwmNTLVJJyQUTDhhc/5DSxL1wYWDW1AGTSEqR?=
 =?us-ascii?Q?uShuivSXwlAWqFckx7JZcrij70zTSR2L6ABivpPHB0AeBUf2dNEYlwBzyMa1?=
 =?us-ascii?Q?cE/qRyVn/Q+POYu2OjciPINqhukLqXPZN0ZSDqP85l47xhDHZNr++xe88jG4?=
 =?us-ascii?Q?ouD73qg2wo75JPzQiItnNfyav8qk1COH8JMM6Ra/NLNrk1y+/7FV+IGYsT3R?=
 =?us-ascii?Q?wwtAr3oEgbc8W07B+MA9Dbz2fGQrz09csPa+mRBoBrOlHFv5ek44v16+wzBu?=
 =?us-ascii?Q?sijPqs2lKezjfoaVhdnbXxCJHPt694GsaVjVtmp6fW+1Gp9LklVFxS1Uhj5I?=
 =?us-ascii?Q?VRTZRU0RPUtlk6cSTn0Obhahgtvn1TI0H17wnG0qL9bdCpkTofAgME47bHCM?=
 =?us-ascii?Q?RyjZaQQp+dt0wG1GtBB0G1OqU/mY5TuMohiHpT7N5OdkC24DSCW/RLGiL6UT?=
 =?us-ascii?Q?1d4pr8kY8E/sw9XKZ08IEFaVq2MQJ4O8znihFsiqdGkLxHwHVq7SOPizVqV9?=
 =?us-ascii?Q?UnKCAZYh+eVPEbCMZ2tLvhzCeuj81/sLsDx0vOWeUqaOT4B9Mrj/x+tBAcLw?=
 =?us-ascii?Q?u6qq65iAVwsHlxIIcgMVXepZWx5lm6NB2aZPHDr9ohi3Tw8/BF9fMUhgK8u5?=
 =?us-ascii?Q?g4cSfnL3gWJB4Fs7s9cA68F0vHxxmJ6mXD43jhvGjGs6fQeFXPWSCGjePEr3?=
 =?us-ascii?Q?SYBXdSVBer7tosNC+sI35Dk5qWagq6xmyuzQFJM8T466Yoyw66nf2eYwVBZQ?=
 =?us-ascii?Q?y5LuW/qn05X71g3Osvz9H/bBgBO6gmgQAIIMULetZAQh2ZZ05HZSQ02N02Ro?=
 =?us-ascii?Q?QqvHg6PmzY3TzD1dBcT1jwbB/xA5E9xCuAfIYTrTY67mKkHgUETa1CLrxoEe?=
 =?us-ascii?Q?SsIwfWB3Q5c5Bd/P0vj++d6093+jwuzCELj0MfPZt9C358VRPiaeDCz9U+oH?=
 =?us-ascii?Q?2nWT2NTngUhJoJacBwHSmUDNBizjB6yUH5CFsalVonCU/8m7/tobrJZY2meA?=
 =?us-ascii?Q?H+xDZBChsmMMaDR17FKghPLC+A73DnU2bVVj2faFLgE0cl6zHSvwAd705GRj?=
 =?us-ascii?Q?PDAD4ihxSQ8hrzjjBuV9wJrhiRf+oE/FgVTpyTJ7FEQUpmOg1ES+I7vmi/As?=
 =?us-ascii?Q?ee1JC3d+Z3QYKLarOJmy4erW0OtAaJB3Av5HVxwHV7M3+OWkCKFM5fXdWIai?=
 =?us-ascii?Q?AxIPsKjAjDZIljz4Gd2VMmeT46b9yit/+BEvHtHqSCt/t/XZIktmwwtvckqK?=
 =?us-ascii?Q?R1DxRC2Bja1WWJ3wZunNCwdY89o1pq6DxJCoSxmNshK0gcXclwp/Z5o9grnQ?=
 =?us-ascii?Q?g6B1p0+kOB+noKPStyJARAqMYbJWahA8akRViI27vfhjap0aIl1U75pqzWs6?=
 =?us-ascii?Q?rBAwLrOvjMZMjpFcpuWpfFNlsoY8lK0vWoz/65he6wlbxH4VwmJhDowtWnYC?=
 =?us-ascii?Q?h/k69EBgb65G0tZppnIUrpKNqA33EQEs+4WShIwoNoy1qXMfmYZ8r3GrW1Hn?=
 =?us-ascii?Q?PTVXIeiHEzkWnVng6BlazMINsLd7ke6Jfqgpvq6IAaipvvNSTH4e2ab2pASy?=
 =?us-ascii?Q?oPeeguK3kjuWubIcygaOmsGnlwsJorkJvmV1YvBWllKKcbXcgZNPgBxawIXB?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19cf3c95-8091-4382-a052-08dac09ebb53
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:02:00.7470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mOrVFsCG4OWhTebJuxQHAhZULVvwXVaB9Q5ZH4aPvpkDrX0c7yYJoT9YNETmfi2i8t7Ej/dVMen1WwBeDY9hW57D9Vmm1Tf63cYjiWu47hE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-ORIG-GUID: 59t8770VASD1JmvsqTdXmNnDAd6E63Vz
X-Proofpoint-GUID: 59t8770VASD1JmvsqTdXmNnDAd6E63Vz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 28 ++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h |  8 +++++++-
 fs/xfs/xfs_inode.c        |  2 +-
 fs/xfs/xfs_inode.h        |  1 +
 4 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5a321b783398..c0279b57e51d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -820,13 +820,37 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
-	unsigned int			i;
+	unsigned int			i, j;
+	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
+	struct xfs_inode		*temp;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		/*
+		 * Renames with parent pointer updates can lock up to 5 inodes,
+		 * sorted by their inode number.  So we need to make sure they
+		 * are relocked in the same way.
+		 */
+		memset(sips, 0, sizeof(sips));
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++)
+			sips[i] = dfc->dfc_held.dr_ip[i];
+
+		/* Bubble sort of at most 5 inodes */
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
+			for (j = 1; j < dfc->dfc_held.dr_inos; j++) {
+				if (sips[j]->i_ino < sips[j-1]->i_ino) {
+					temp = sips[j];
+					sips[j] = sips[j-1];
+					sips[j-1] = temp;
+				}
+			}
+		}
+
+		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos, XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 114a3a4930a3..fdf6941f8f4d 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index aa303be11576..2e7d43ad770e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -447,7 +447,7 @@ xfs_lock_inumorder(
  * lock more than one at a time, lockdep will report false positives saying we
  * have violated locking orders.
  */
-static void
+void
 xfs_lock_inodes(
 	struct xfs_inode	**ips,
 	int			inodes,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fa780f08dc89..2eaed98af814 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -574,5 +574,6 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 
 #endif	/* __XFS_INODE_H__ */
-- 
2.25.1

