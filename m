Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4184C47087
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3459610FC
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhEYT5D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:03 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49622 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhEYT5A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:57:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJnhV9038678
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Lsy5ghd5NCGtPxPjv0dZ32L1JJiBdQdTUN4+qBdRad0=;
 b=vdLBE0HkjZEsqKSriwIxflzkwInLJMEd+kMYaZCchF2gzu7DwQXOJS/V3zhJgjUblR3Y
 apFXlZxELlZRNsHBV7LOBMwjYtODkUEle2LvfJ2JftRAZbTw8jNk6mwQQuiQ0O0NsdWD
 39Ge97ue0smKWTCXv0ALxS2EcWHfcif32Q1j9nRS7Kna04BZZOPlEpmZb3oSaU8J5zNs
 SOgJdFphGqp0PqbJutfXD7UfZDImBkQ+wKUxQdGRRv0MLc6w/pSV9DEvb4Xkl8mXOTC0
 hqeKJgLVmXSw50dYDf0gtWdDB733K342McwxEqMvPjTA8NXpZ6SdAVkaxeKS7+QgnxX9 bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38pqfcf6dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJotnT143650
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 38rehawt3d-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhIEV4N3XvixH0D0eYj/bJ6Fi9K/MAX3WNdMOVc0IgYsJM9j/XfRhWkpRk8GPZx5p6MZjSnN8v8vbOyPkG8gduK7kgGTdtDm4RHTNkI3VxYbAeuUupUUEArRaA9K5zLiiGKuRYWSlqPgD4SNS61fuLwguHrguEqGtRERfSD3tHd7/yNdjKTc0bn11Dt+QFNY9kjvkGkcxnGmTOIgyHIzNOnbK3rsTu2PqnTSgPRLQkdJrUT8YbJsSfyFEFQ9EuHgptA7tcbA3T9i47TdoLHFykCKzbtlpQnr4IUPi5W/A2igKfSpYsmEEsuz0OtdQ1cMmW7sazM9grOtg80QIwnDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lsy5ghd5NCGtPxPjv0dZ32L1JJiBdQdTUN4+qBdRad0=;
 b=oMxlkJVfS9jPDSjsEAnDLzc+8/PalpdaxmerDxcbtz/6Vkb0p3DauB9zjoaLFo5KjyEkvyXPlvgTd/BJhU9mQD1FNdx7gxx/XNy7rvb7TW5jiKGJlf0g9dYj2W/5MquC0TG6RTAqGaxHxS+920OGbcVQ0GX2jFCHhj0quzREmuUmGeO5V/5eJXnd2nj7wmMN8bDXqvy/9r6VG1FdyTV8F4BCGaO5Gyr+ryEXf3UP9zVT4oK3jlMVhZPKNVrCbMIHxBjUXG635F/sAG1Fad9FGkgQzzwD4VL8NzytWgW22tliSCT28PUhYAQfI9DXbe0xU2BTkH+lLlCwDeoBDDCrLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lsy5ghd5NCGtPxPjv0dZ32L1JJiBdQdTUN4+qBdRad0=;
 b=noBHo/trx/ZDNsFHlf3fleqmFkY/L0XKS41sPbSk1MF3JmqSHvEuXqqqb6jQf5YOkJSfcowMl6/ImVGIVxKGSL78v/o7V/nGwMaOVFiI95o621eygkYaUqDtKHptpgraoRRcmUZy7v/TxHChftcLX6Xzp0l4ga1ZEcsUULgvXj4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3144.namprd10.prod.outlook.com (2603:10b6:a03:15c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 25 May
 2021 19:55:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 19:55:27 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v19 02/14] xfs: Add xfs_attr_node_remove_name
Date:   Tue, 25 May 2021 12:54:52 -0700
Message-Id: <20210525195504.7332-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210525195504.7332-1-allison.henderson@oracle.com>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 19:55:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0521cd6-6e60-4c90-4024-08d91fb70aa4
X-MS-TrafficTypeDiagnostic: BYAPR10MB3144:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3144DF07346BE1D7E8B91B2795259@BYAPR10MB3144.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F0rNMJkhPXivGoWZktnnxXHzI+gnBKbRIU8Pn0z2BhOq3+kk79VhlIRdjCNGaBOz7/aLKcmzCEQVtCAr+0Dj/7RWtVhQp71FJ/f5vL3ARPrXQkG+igR2Gv1UIt8M6ShKzlLeMCKa4tlT8cxdAkMtbw+DzvCqDLtoE/2ZrI0oSnkJmkCz0c2FJVXWgr5CYAyeLWv8ovYC0F2emHfJpdYk0wf2FvbpumPa3GMeMy8Afm9n+Z+a6eWs2qObmq6qG/Qnyb3+g5RgoC1ztfMtzhnuvyxielUbdvaS4Zh+xj3wk0BGCPVvwq6czYuhOSeSbp7LH3zQ+q/qbGF/CKnAFtncPsGkLNBOV9jq0/0dOwm8ZRpVqaLMxxV9A63ifOzjJ03cUU7Niz5xbxPLraiKm2A8+wQ7k5VRAEoRrOAjR2Ah8DvrV8fA0PZ4lcjhknTjMOkVUvTLuvHs3Ji8zNhfvibalpzTf6/k6mfwZZORce58zPi8vZ3+64RoQ8VWQVRaqH53eWrt4p+UZdJzXyN6qNi4ucl/HmrJeX70oGfq8YatJjNKULR97OAS9HbIhYhSC8C9B4BIsnnw2cLfAx+2kR2NgzwZt5DZ3GuKhfH0oUbaxlMYJfQDb7DZ68HnQZohDS7OJJKpAo6qPtGNJMgup1mgLyIVu5rfQwC4sXsRX8eXs+CmLQDKY1nOyzBKR2CMtKf9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(346002)(396003)(376002)(8936002)(6486002)(6916009)(8676002)(2906002)(26005)(36756003)(6512007)(38350700002)(478600001)(66476007)(38100700002)(83380400001)(66556008)(6666004)(186003)(956004)(52116002)(2616005)(44832011)(86362001)(16526019)(1076003)(66946007)(5660300002)(6506007)(316002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Juvjd42NkcTSiDWGBppAWjsJFxuFijO+Rww2pXW8NfafyCjfRDoZoXMw8ajk?=
 =?us-ascii?Q?qm5aA8CGqCw6RTQYKNHYlTegQJ3CiDiHMdQvXeNZPyTRMOb7EExMwK3NTm4/?=
 =?us-ascii?Q?wYW5sPVqTeb+wPUhWicsMlGmPyM9rSzT4FyLEfl5+xg3DNpMQHP+2wIlC5hQ?=
 =?us-ascii?Q?xmzUAoQanyi4COI1F1jwiZjBt8/LkBGxE3br6XPkyP+dL8axp+vrP1AmAShD?=
 =?us-ascii?Q?5DHL8l3+x7urqTciBOKyn+ZML3tDiz4gK5mSOqr9gRAMJ3K0Cd/qnyv75jFL?=
 =?us-ascii?Q?lHTgolUdXEjyaldlUoJmlN8gO1d0mtC8O9l9/Ux06WI4CvXODsUY93fgyRdM?=
 =?us-ascii?Q?uuM3MnJuDs428edvIfgAHn0Te0EnWzkS4ydQkSoGnR7DcV7oKePhNdEnvIC7?=
 =?us-ascii?Q?L6u6aiiMxJzM5fhcaq4PWDe+uc80R+hc4MHdY+0OeGybVW//iTzrngU3GbY8?=
 =?us-ascii?Q?XvpRkkHNxublLMP3Okwh+VZestKTRl1Sc7Ef0Tf16Tq6KYgBl0yPwQ3QfPOh?=
 =?us-ascii?Q?EDTfDlg0q4Zi7WvUXedDxMyTXH+m1/vn9sW3Rw89FblsEU7aC/XY8CsBpye0?=
 =?us-ascii?Q?ThJ6v0Y2UmMagK4Key321AeXi8nKgzGsgCi8HnuqMcdyI9lOx9/of35bwJTc?=
 =?us-ascii?Q?sPgo1Fjne3/JIHXQrtLWvwlCpmirav54xw0B5ViEe+knH88wDMnha1Ni5Vbe?=
 =?us-ascii?Q?63TIY1g4O5DHz5EZNN7wiyQI2cFSkXV+iSx4T/ycsbw6cXe6zAz0EaBnwVIQ?=
 =?us-ascii?Q?VirRDV6wrBn9r+WLiAb7spRdmtR37eB5a0xbYSYPMvbnrMFWWFYgJCMHUnmU?=
 =?us-ascii?Q?Nm2jsBJlepLD7ggOAXDfxVvwmu7xgwATReB0iX4RHYa1UNPpE1rNYilg71EG?=
 =?us-ascii?Q?h410UGoL2sRfNJxzTkAEEmmGbY30QZJ6SczsCmwnu9APSN5nh0kqkAMvBwZc?=
 =?us-ascii?Q?Sh3Zn4fTNocODOtFPOPP/e4BfHsQkGqz3KTH4sd8msFL4W/w8JFkaxt3n9ZD?=
 =?us-ascii?Q?chij20m78+ktcl6rPjr2OhJHzfPJFxaz1TBzTDdSdxGIYAlmDlRU8LpjPbJi?=
 =?us-ascii?Q?bwTG83aWpPlj+WCHbSLB3La1ic3dE9dKrhEjtp0BFwLWXo0zKWH76QNPZ8DR?=
 =?us-ascii?Q?AqHE+tIfK4tcwbixgNeFp4FGxQC0kR9hwsDcf+a/vOabyZEkxkbJ5VCGwH3F?=
 =?us-ascii?Q?5ijKOtTLgmscsb7g+Pve2QhrpkISCCaR/ZSfo0w4Pn3C6166BD9bSt2CE5Gn?=
 =?us-ascii?Q?Sb9/3hYFvToUxBML3Pb4ybRynxu+R31HCkuAmwpvGjWemKi2UWtqRtHOMb+6?=
 =?us-ascii?Q?CWv+B2pjyTGI6qGunwTwqaQp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0521cd6-6e60-4c90-4024-08d91fb70aa4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:26.8987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/HP0ATXUa4Pvm6Iq1SQkv0LHktFZg0ulX4eBGH7QZOnu/8UOyT3rxuqMkSpvJo9fVztqUOYR84I1TdP9CSM07WRlEQ8lTQhNcVyN3t7Qg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3144
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
X-Proofpoint-ORIG-GUID: 1S413AUnrpVQSF6aCQAaDmSybI6nfj8K
X-Proofpoint-GUID: 1S413AUnrpVQSF6aCQAaDmSybI6nfj8K
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch pulls a new helper function xfs_attr_node_remove_name out
of xfs_attr_node_remove_step.  This helps to modularize
xfs_attr_node_remove_step which will help make the delayed attribute
code easier to follow

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 190b46d..8a08d5b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1214,6 +1214,25 @@ int xfs_attr_node_removename_setup(
 	return 0;
 }
 
+STATIC int
+xfs_attr_node_remove_name(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	struct xfs_da_state_blk	*blk;
+	int			retval;
+
+	/*
+	 * Remove the name and update the hashvals in the tree.
+	 */
+	blk = &state->path.blk[state->path.active-1];
+	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
+	retval = xfs_attr3_leaf_remove(blk->bp, args);
+	xfs_da3_fixhashpath(state, &state->path);
+
+	return retval;
+}
+
 /*
  * Remove a name from a B-tree attribute list.
  *
@@ -1226,7 +1245,6 @@ xfs_attr_node_removename(
 	struct xfs_da_args	*args)
 {
 	struct xfs_da_state	*state;
-	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
@@ -1254,14 +1272,7 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 	}
-
-	/*
-	 * Remove the name and update the hashvals in the tree.
-	 */
-	blk = &state->path.blk[ state->path.active-1 ];
-	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	retval = xfs_attr3_leaf_remove(blk->bp, args);
-	xfs_da3_fixhashpath(state, &state->path);
+	retval = xfs_attr_node_remove_name(args, state);
 
 	/*
 	 * Check to see if the tree needs to be collapsed.
-- 
2.7.4

