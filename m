Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D996C19F21
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239008AbiHDTk2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbiHDTk0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE56963F3
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:25 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbaaS013546
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6WthS4Uec0axxI14KQX6+y5AY4eEC4kG2n9QVsARoMk=;
 b=Ir1kQvK+1lIBcI4J65iWwrThbbFl/HDXMUlqySjM5qDL1AaLHN3fZ96vVC/lOrPHi/zE
 BcOs741D6hvKfcDGClQfwEKLf1QqVetD+yjLX0ufcHa3GxbBa2riLxFVkUI+gV+XpK59
 1cvQwOSyrX+Q9+XRJZjNOyvO8pXfYD4CRgG0WEtE/iN1jkjPCKCYfQPgx/gCGXnd5NRu
 9IRNFx9cdAJjRUw4wiWYjU4bdUoQT6hMzJt4P67DukHSRqWl3rycTRMpu9XPwr9f+RxL
 mIPSUghhrvRYg9FWjsrO4YbJOJqUNH/2s+covy0ZnsO+O/zIhWjR9ZWNf+SP9aR1BOWE Ow== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmw6tnycy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274IEkVl003021
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34n716-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/mZHDt6MY9BYtvha7wkfB90T80uNJ6o3EU+R5Wjr8V8EDewWh3ywjOaHdF3Qan8Twg95K4KifIcElA5h2jGs/YCSfGENIkDiZARYsZvNUJWD38pcCEhxaGU8dfxjx/JVpaxp5dSVHJ+5Sedjuzh/Ix6yw7eZ7dsafTbMJJ227H7eQUrpobM/5PspPZ5iJcPVZVrm5XzfwWHnTL0ySzlqW66o5S6YWr8hvONEQ6cIwjIK1gzubiL+b/9BdAokTC4WXIms8LcdnBpIC/Ozl5cZuXv7C+cjYBcwZPSlwFDrfq+qLU7RXf8w1hpiySw5qRysQiQJp7ddX2w2zulPaNzdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6WthS4Uec0axxI14KQX6+y5AY4eEC4kG2n9QVsARoMk=;
 b=IGrgqNC195jpyqfJzMCAQug8uOEbrjQD6qL45KMQw5Na9fIUMzhsJR5R4vlWXQTud0ai0CNWRMmKwsKjLwu4GKKB9jenvGwMiWdxrRp/PF4cVFhn0aCoDXC3y6pHmL8r4KtMCpI6AW9UsTF/IKXxxFOHE4Gys5/yMad2tH7/W5o9MWGdkE9NxTLppDDJqFTr5orA7p4C0wxEcsK6JTjUKkrNjfNZMLx3G6GEQvEtXenTmId9GaXDKlLBKc2Vm94dy6YVC1sfCEUeVGjd1heSFbop9kT2KyqGLkb+D57Db8hEp7w4Fhfv/j2YLc0qpzp2BmyuXiX5SJ4dr3cDiAROzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WthS4Uec0axxI14KQX6+y5AY4eEC4kG2n9QVsARoMk=;
 b=s9N286QXoT4fWL2kQ/TF1z7tQbPnt3/qfknRdtUFQGZIaPjFStG6TtdpVkEsMk9UhVPQX/BM32F47Xa0eVZOmq9XmIPJXgeehaXrpdOA22pdWs5sxIN4mx/HboeM8hEtpHsGXYAYHn3+6uw4QDTS68Ofjw809ASWIbBcZzrNGOA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1368.namprd10.prod.outlook.com (2603:10b6:903:22::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Thu, 4 Aug
 2022 19:40:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:22 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 02/18] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
Date:   Thu,  4 Aug 2022 12:39:57 -0700
Message-Id: <20220804194013.99237-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804194013.99237-1-allison.henderson@oracle.com>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b173065-a8e2-4686-13f3-08da76512b39
X-MS-TrafficTypeDiagnostic: CY4PR10MB1368:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qes/D7OHOkFIRhM6Q6BWkPHTV59UIFI9qo+QfVuEmVv8HK3UWS2/DC7HrIIZ6LoMHv1EGXJoPbeMjRi0kZZYDVrINP35bKeb92Opya2Dn5oZezn1Mk/XP7qUywtK2QDZUqvD6mqnHWJJ04gQXnuH/LXU9+JILxbCzrjhUmQ+93o/YWAGDDPa2v2fLDtoXEns62wR+cMw4XrboKEibOatQ9PXIwO7joRDm2Ag6HQFhBxhJB35mqADkI/ZWIXosSvhVxdvmuy5sUCJdKsAJREr/jsIqzEcd6y4717L3e+ENwGw8SE1+hjC6JiNIEVnskpabssigmCkpyTVfrRJZCrVUMk/EOBq0/aKDNMERnzDLI/TAYsEXmNJAlHwRH5+r7vrkhhxxcvBmyjtLo6IIUqUbexGST1UR9dHJU8FYxfznI0w4RsciHELOHL4hwuTOdN4yzE7iY5v/uJVvzPclmhFjeVuimv40K6jfAOJZFW701gnw/y5M/tLw6jUC4wM2lRriXHDuoei9K5v8igyTl6R3NTU872jXJYVlPh8vnzQmgYqfLWVtTFD7HpmRICYK293nIoBo5nRsE7SrzxB/eFT3vEEWuWZf08Zw/ZCzSP/juB8/gl9HHQB7YNamQePG2SFnIaFDqlw1wHxu9J96WtZRMeUoJjfATRo9e1+xKNTmrKtZrl9WddTEXiow8CiUlaGhnf8tlTxaKuMlkGHM4bI8Fs7fFfstUFuNgNX9xkWtXrrbnTWEWufIaJBe3ktC8AjcNjDt3sizWQiFjNYSDn/DKeFAf6P9a+plDcvuAthN/4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(366004)(396003)(39860400002)(376002)(6512007)(6506007)(6486002)(316002)(6916009)(478600001)(41300700001)(52116002)(6666004)(38100700002)(26005)(1076003)(83380400001)(36756003)(44832011)(38350700002)(2906002)(66476007)(66946007)(186003)(8676002)(66556008)(86362001)(8936002)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DjmJEOyK+SFvY++Ew9fncoldXJwk5tXWBlEBKWtTY0i+IaUKfv+FOVR9V64j?=
 =?us-ascii?Q?aHvMopybJWK7Shx1C20aI073vodWFsqkn6iiQustWD7qkQnztgK8q6R89rr2?=
 =?us-ascii?Q?gH9ZqLB9Z/yIdsg3UhFjMom6jFWYnmfsu/x5Chsc78eHdXdn3DFxTlmymrvr?=
 =?us-ascii?Q?OQSnMRm/P+Xd8RUvWQ26V+Dlc7Oka8bLuyEUUsE82301PYmd5qW8+7yHz7+L?=
 =?us-ascii?Q?3RTDd7II7KsDg4brSMtKJlk4BraKJqCBCmJB/me9i9xtAXum2Jl+G+YkbhVy?=
 =?us-ascii?Q?Nz1EOZL6E150qSF9YwLeYDoHjIgZi2VT8ROKPp2MwF6Vy1Grqy2ysUgNYq8S?=
 =?us-ascii?Q?LvVbAOH3ahC9Q8Hkz/U4c3TWqIqRSmnwg5YGS7zi8kijI1Fb/QvfrlDV3EvX?=
 =?us-ascii?Q?mYgC6HsWnM2RucGHjtjUWjSfcKxuAwNaDw6aBNSz7r9WvhH/I7zgTk+BnOaE?=
 =?us-ascii?Q?3Q63fnpzMeObftBjla5Oxx7+y8OUiInDE9QxGnLqSX4N+igbdzKBq+xEA7bb?=
 =?us-ascii?Q?C8XULt0YInM/dJyeKKW/uxh8cwtipb+PgmE+j6ewsvJHvK4W5XPU6BGeYKYk?=
 =?us-ascii?Q?U83MgcTyRcAyB3sTVVRdgNhXTCV6vwhX1sZidpxpoOFSZLiNrDkbpj87jodF?=
 =?us-ascii?Q?xYnFZClKHnKYUXprrDoYqb8RuwiST4Rgq0waY5XY/hdvQTdjtrv2+SJjvKFE?=
 =?us-ascii?Q?CLDQSFttnfNmQrPx50VR6CWRsou6VeQPJnv9QJCCY71zG+b0gUNgALZ8RXoq?=
 =?us-ascii?Q?H+SQnS496rJndPEyHjmT/kmYAqv6W8FyBrtFUWoUg4wJjmt/vf7qdc6lkcze?=
 =?us-ascii?Q?BhTLStoBz5daWNpiPjBV8KrNYCkoeNfc+I8isYueSHfMC0Y6PwD3e2h8reb9?=
 =?us-ascii?Q?2BCeJtWINRMK1vBcvmnUe/95wYAsHztvk9YuEiQQpui7DgfBOTuzWvucKCbq?=
 =?us-ascii?Q?QZTG51NwGxvwQd6aRivpvFNiDhgn1pWl5AW5S0eypUrBP0K3L0xujFyyovoi?=
 =?us-ascii?Q?MFikw09ScLZLRc5iXYogaswXg/dSNkPDMN6i5vzHkzZv+LkDqT3teD9d1We+?=
 =?us-ascii?Q?pltzBjPJtOMJVMtt0paDjteOVnL4tERFjV4sv2XA7HppOLg9TPPa5TOonNcv?=
 =?us-ascii?Q?tI/Vf1GOeUkj2ygXAfU+2a0PgPGPne2oZgiH+8cJpT4BzkA9clQVNT2bzaTB?=
 =?us-ascii?Q?uy088SXuzzTRGJqxwnVJRpse8QDaUsMmEAeYIf9aClV4ByIeK30ddBi4Q4t2?=
 =?us-ascii?Q?ZD8CF+x7aIFeJ421gPQKKc+G9eKy+U5yDRsPErYhJqWzHnxuxF6q94209QG3?=
 =?us-ascii?Q?UE977FiPL1wLASOy7UAqVtU8PeL+HHqBICAxvDPK5MSA3jLXz5fnjmoo/7f3?=
 =?us-ascii?Q?GhvAzI1ss3yjE774vBnVZlFEBKDDpaEyk59963gU8Ge5u6PyL14jmMkeKOPM?=
 =?us-ascii?Q?GbgZq0zphimTrA/wxqjKYJaCBbfXdfEdU9TTm8Ab1pS2A6BLNmM5sWJiRyGX?=
 =?us-ascii?Q?3fmmEhp6wXYHytuBmHidQqPEP2t+RS61mv50M5tNHt8SNSehZxXHIdgF9YIi?=
 =?us-ascii?Q?hMZeyszF5sv8xGrILrHKPCmE6mJtNFHxUV7bexGj8wGLSK5C6bMJXAc+Kh40?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b173065-a8e2-4686-13f3-08da76512b39
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:21.7040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y0nh4D8qpe1Unu34B6LEOOtHupMNP18dQucphJ61+RpeqzcZ640OU3rbMw17b1QHADpsswtE3n+RE8K7TU/o/aCPzizenCimM7R5w24VmWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040085
X-Proofpoint-GUID: UV9NyMX6RwwxrEKoX7WbacViT_DCUgr0
X-Proofpoint-ORIG-GUID: UV9NyMX6RwwxrEKoX7WbacViT_DCUgr0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
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
index 114a3a4930a3..3e4029d2ce41 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with defered ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3022918bf96a..cfdcca95594f 100644
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
index 4d626f4321bc..bc06d6e4164a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -573,5 +573,6 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 
 #endif	/* __XFS_INODE_H__ */
-- 
2.25.1

