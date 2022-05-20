Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE5EC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350003AbiETTAx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348725AbiETTAs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95531094
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIp8gE010015
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=0TGBiYRtId0jc/V7bsvUDbch4ADcYfty7vGiBhEKejg=;
 b=EqO7TmGmXoe3k/vyRqomhu7eu67zVB8Bfeo8RFmz1VnapeKmXYdZPI0YHE/NFCwc9rUp
 hZDQIOAVb60NZr4blcH3FcigPaKbFYnF8XPhfyRR50DTT+3ZO2qIzAG9BUZwA1TX1koF
 1oouflEF+4Bvo5/YGPgsHa6s5g8sOimnxT7sEnLp3/ek8GEOvNPnsHlj9Kx443wMSThA
 7kbuXr58EPKk7WccD+TnrvwVxnop3nA2CA+KY/uqbJPIgCCDlep7NvobrKbQO+a4wDqc
 4QaOoeUf7RqgIsuBwZBI6vTcZKRSv/j6V1rkHsbSAmJaze4JdBTcs6H+4XXywSWHqu/W ag== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241sfvp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KInrM9031336
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:43 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37csr1tm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KE9bckBENzhyT6v0gZiAqZ2MdijMbFBNjkGqu0QfMhoTkwNcWPruS7L4wctVU7TvbcpzD7AQ/+JCw56YLkhriZah9Wt8naK8uKXd+zSc35m5azO154qTIoICG06Mwu+iMXqZC5sXEkan1KDwYLCwJNObrWN8fH1kpswnn3oybNyxvjA9eVQPOHZi3kx+ZrQ+I374W6aACJRkTnSaK2CSs2DiW/z5gzrsREH3b/ivCpR98msTyfnms83NgdnASx9f54Ho7T0optwfVW30j6FtYGRAafdNIQYkRtiI1uHtA4kz0NXIWuc6b25pWnYgaNLiNThgwrH4581mzu7pufZDew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TGBiYRtId0jc/V7bsvUDbch4ADcYfty7vGiBhEKejg=;
 b=Y1yr4HV7AtHJra40bir+kHcoL6Fnn78BcI18HdGBB4Mo6eDc1+cPxB63GEPKafYLOB+cZ6Z6plDSBXVjj3rfVGOx6nq8t+SMMP/wKFamw2qW8hZklRHzpD1oT5mslMBpFJhystipiXCeQaI2nG5BaN872e7r1B5ISZzQ5uZ3llIJrOcaWP61BFX1l7fb8k1bJ4IxAeahO6imbUWcM3upQaerSFDTSJM3TFqD+6Lcp87izcFsBXFXxg8E+LfKPF+Ggn5hJPnC3Ru+UO6bRd3CB3ZgO4cOnBDEBLtIFNzvzjO1YsW+o//k6ZZMqyAIm0YE/jAuhcPcrPa10qBfaiHA4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TGBiYRtId0jc/V7bsvUDbch4ADcYfty7vGiBhEKejg=;
 b=IEhmMoC9nQAbFc3goMY8lV7RCfnpnDkDvevwbQfi3BHu9Oqzu2jTbQmlXTXGQdhu/dhU2GNmLwJcTvNIkts7tIwyT4K07hVsRY2RBAPmC5xTTJ1Djkgx6dUxDSRtnICJEHGixRlKOG7yPdQ29LrrbKBUhmxDsImQVmaOXRUvqBY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:00:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:41 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 05/18] xfsprogs: Fix double unlock in defer capture code
Date:   Fri, 20 May 2022 12:00:18 -0700
Message-Id: <20220520190031.2198236-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220520190031.2198236-1-allison.henderson@oracle.com>
References: <20220520190031.2198236-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 284a9afc-c2e4-4a9a-502c-08da3a93079b
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3658E6B0FA7E0C1C4F42A31395D39@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KqXnjt830/lRvbxt8gFxtjhpiDejAN5my9WnHERMGSbOx++ReGmerydiyZrbjFvEAo/HO2/OSRh7BoJOKNjeDeBuxQcDLZ5J6VILbYME2DcSp5zJ8mh8x/wr3tkcnCuW0CRksEt2xXdmrd7jfjX3KR0YfSShleQZzinyB5JT//z87YwFDL5Vqb5itxitKqdS9C/J+Bop1hLLfbeEAg6gZ9vTDM86idfceLjZbj+K3ZWHNc7c+csL+Ce9JUxab0oIaatYQyNWxn/EF/BDbmcv/my8CSQ7zsAPUSnxpE5rCJ6dLp6TMWRk3DodkUgcBb+HcTbrghonhOLSg9Q/IR93ABw7vBH8ds/1lT5kYd95fw9GKHb1CwOpKc/7AqJAQpTSZwtwB7CS/C4T6dmUzEzi6DuB6+25a9KA7kqGF5BlLIcv5v1QFFXlaK1Ms/UpKizv6FapAAmuns98fePB2jMtHfciDVQyqXiEl41Q+QXI+AqnAu9/Ez95b0g9G+Ic5cSk3wlxx/6e9gj1dzlY2SBoHgP31PzRLpuDo5mK08rlOzViVFeGdqRkg15b1TOkRF8mwyhC9d7fVybx/jixvBZgSUwV+4FThP9XHNEPHh/09aRAP6LYy2z933DR+z42eQBY1/O9154LP8zCwwp8uRDCGKavleJr73G7KqleFOieB33HNqMTcHX2WiEkm3THQQui6aTldoV95UpQbqX5eJJnVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(86362001)(316002)(66946007)(2906002)(38100700002)(6916009)(8676002)(66556008)(66476007)(5660300002)(8936002)(44832011)(1076003)(508600001)(26005)(52116002)(6506007)(36756003)(83380400001)(6666004)(186003)(6486002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iGPeDeb90GhbMK5jWZ6tNHL7CyJtGBVTuKRnRfwEhQ9skuGZcGYXIKiZ7gel?=
 =?us-ascii?Q?foU5gloHuE/v8IpiWigcoEAQo0wFywl1vWabICbDy6ImfFrUDmnhx0LSY9UO?=
 =?us-ascii?Q?JrjZ2P/w2sGZbiWNKuhBGqnYeNrlB/W3dX1fbIINFWTWGt8jQLuPyLp8094F?=
 =?us-ascii?Q?XQZEFneLdDEoVD8KS/1oqkooF8sN95SWank1itnb6GhjlkyBtnYgSwa51It9?=
 =?us-ascii?Q?S3q4lLqCpiwHSAH+LCeq2bNzDug58dL26OX61zj/+cgnsY4OvPftPYR0i2DN?=
 =?us-ascii?Q?ooMoF9HwJpm4VEBvRnzidvL4Cvm0sGSaJR282EH2p2iG7dgM62KGh6wXwGmF?=
 =?us-ascii?Q?5XXpTaDAquKochKD7CEmQTbS/w8LtuQ7yYaglgHjFUUg3Vh4JTljnMtl401X?=
 =?us-ascii?Q?IMTqtpiMpwjFvzBCmJ7+hfRmUM7IrYsoQlmeYZG5A8CyndjVwYKD9EU0F+rm?=
 =?us-ascii?Q?F9LJyqmfRxL4QoNG4NnFoE9us/waKOR3ovtPCo4TAppdU45RiH5+m4ZGCFv/?=
 =?us-ascii?Q?B2vnrM9bqP9DWmpiaJKPlMHSWBhpXqp/Pz43m4ZAb4AZ0B2eT+9tNBuFr7Wd?=
 =?us-ascii?Q?Ssc7EKfrl36+dR3883WeJoV384q8THg2DqF5vf2djlNTHbeSDS9DiHRjqpG6?=
 =?us-ascii?Q?+yySDLU694JXK04X2GHEWklkaaY0bfZiamcBOVr1vS8npLBgZwriBTO2kqi/?=
 =?us-ascii?Q?iwyq+A3sidvjCVCXFSd7n33NkuGTj/lEVuL0Wu1yu0lLdnic9JrpLmDhioCr?=
 =?us-ascii?Q?3eFS07ClyP2hS6LDBcybOF3x+CvqU58FW3BdYk17XsexSb+jyWQ2p1R5Lp6c?=
 =?us-ascii?Q?hH3guyPNNqehy6P4+bd9/D+cIjWNRplW6ubrVOcvJ3kQd+EpItZHgkvsqOhi?=
 =?us-ascii?Q?oQrT3BQKsWPLGOGTlB+C/GcfxvttCsFF+rdqQNSKXrhZwcRe6Zx2Fflxb8SV?=
 =?us-ascii?Q?3jWVy33IALMbECmn4kgCXDOuscErN0iAugLCmzQHL7ydfpjGu4SHhyl5DKdE?=
 =?us-ascii?Q?UT6zbHskTSOJWYvlv+gG5yrO5CicdX6g+YuLkM/pOGJpWd5lJCm65Yc1/kxY?=
 =?us-ascii?Q?g6DqUYOtUnQkUUmr6i9+UPLWxvFlRRXcfar/aPqkqe1g6XIxpRnuQmUnHy1Y?=
 =?us-ascii?Q?zsxsXyX00I7EFKZzOe5GtVnUbjZCiu232z4zhg3rHrC3TSldpmEM6PLTFm5y?=
 =?us-ascii?Q?QUK2XHTbBk5+2CjI/vy85t3gRXwkCOvBorhbp+Qwyl2xLor9CvtKtk4wyTgz?=
 =?us-ascii?Q?MrZcoXTB6haAS3Re+v73MRNGKEfngHUHwl6ygsS6QxvSGuf3nykn2I77zHNL?=
 =?us-ascii?Q?JnwMA6Bw+iR8Qpag1I8i7OPNkYnQeC5VzB9vsO29CKdEujkhFdBPHzaQmKrs?=
 =?us-ascii?Q?bjcnMyMAqoSeF5DrywGVDiQZ/LTxypSS4/DzZJneWjbIiBJhoJFSbtK6o7Pc?=
 =?us-ascii?Q?r6whxEhIo6gjXd+jCSk1aJjwooOSjqKExHEhIwVd2EUU+VPOH8Y43MmaM2N8?=
 =?us-ascii?Q?P6pCdkQz5XNaHk9kLzvtmatm81igYZTg0OaDsU81maqvoH1lO8qf2MBwB8Li?=
 =?us-ascii?Q?8pEDlYXUpKeIhnPmciiFeTXGeDA6XQ60XTIzNLu/TWZ9GWX7fdXbUa/Nno2h?=
 =?us-ascii?Q?DdOeND3dZ4MrEAnsE+9aWekZmOfaf8AckhqqD5gWoDiZnppgDIYZXASPZRIY?=
 =?us-ascii?Q?cpScRHNsppa/9QhA/9XwWIjYJxUKsnPBIbDtnb7D/XeV7kv1fhJqhKD32ZDr?=
 =?us-ascii?Q?AtuCRQX5Ww3fyTMiMaRtU+qNYAsteXc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 284a9afc-c2e4-4a9a-502c-08da3a93079b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:38.9506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7i/CHYwGxE6o966Lfu/faEPFOrMP9+MpLcnlOSo9npe3kedQ5cizDnDDuj3+B1ZBUDdoK256muobTbxtZV1kSa+s++1uxLBsUDt9AFdL5ww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200119
X-Proofpoint-GUID: YkW3_5EKBIIcUcl8ccqZTtxwY20g-v8P
X-Proofpoint-ORIG-GUID: YkW3_5EKBIIcUcl8ccqZTtxwY20g-v8P
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 7b3ec2b20e44f579c022ad62243aa18c04c6addc

The new deferred attr patch set uncovered a double unlock in the
recent port of the defer ops capture and continue code.  During log
recovery, we're allowed to hold buffers to a transaction that's being
used to replay an intent item.  When we capture the resources as part
of scheduling a continuation of an intent chain, we call xfs_buf_hold
to retain our reference to the buffer beyond the transaction commit,
but we do /not/ call xfs_trans_bhold to maintain the buffer lock.
This means that xfs_defer_ops_continue needs to relock the buffers
before xfs_defer_restore_resources joins then tothe new transaction.

Additionally, the buffers should not be passed back via the dres
structure since they need to remain locked unlike the inodes.  So
simply set dr_bufs to zero after populating the dres structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_defer.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index d654a7d9af82..3a2576c14ee9 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -776,17 +776,25 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
+	unsigned int			i;
+
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
-	/* Lock and join the captured inode to the new transaction. */
+	/* Lock the captured resources to the new transaction. */
 	if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
 		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
+
+	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
+		pthread_mutex_lock(&dfc->dfc_held.dr_bp[i]->b_lock);
+
+	/* Join the captured resources to the new transaction. */
 	xfs_defer_restore_resources(tp, &dfc->dfc_held);
 	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
+	dres->dr_bufs = 0;
 
 	/* Move captured dfops chain and state to the transaction. */
 	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
-- 
2.25.1

