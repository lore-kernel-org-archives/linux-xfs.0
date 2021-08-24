Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA254C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFD046128A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhHXWpi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 18:45:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50140 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230396AbhHXWph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 18:45:37 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OJMfk5030398
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=OePTOhm3QQIxzhLWAS2JnKE9a9ppYu8Dg7JhuAi4l+E=;
 b=WC6hWDHT0sWVYEia35XArr8y036hJvWihGkj6AdpRllyCigVvXpwDq01yd9kYOvgcVpX
 ME/Sou4bhJhi7eD5FRAUy8e5jI6LX+rOE8102SFRcLbg0ct0UGzftN4PPKe/GtOjqrbu
 CS+tOxZowDHSXyd1Frc3Y85fv7ssJPzg4fK+o0/cSBdPWfxZv7AQy+TuIq0IcyTPRbmK
 Y2RSKJrwYpb++ZPCE8ODEpb0LRlf+eFScp1tBijWW+BlPPfpx/lXAh39uyXQrh0IDEdB
 qnaTlGPowAqk+f8Y+80KoQKkfaqed7NMqpYsOFxKaeUIhsZ6RLwyBXrl02dqgKMC59ZZ Dg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=OePTOhm3QQIxzhLWAS2JnKE9a9ppYu8Dg7JhuAi4l+E=;
 b=sTM2lrRMWjNpvc/G5E4JOi8bkYjYSjdMfXU14juHEdd6Pt+DOc1es4oAQpZK9K8rM1Ev
 LHPve4h3b6r6mjJPQdjHs/smbodGI25BrMeyPFryyRbUCXJHJ0HKxTK3Zt0FCJZCPXRu
 HhtRQJvcvht8rnXUCAgyKCVIUneIegUoIwx+DTxnIycuIBphZuoCBT++itpGaitzzPub
 COrgglWp2xHZiNDJJ/bLDGhYN8ASRzNnKP0ELJR8Scfe/kb6zZKnBMm3NL0QIfpiWE0o
 y2R3N8sielTYQk22i277NcN9vBU9+EkcW0ggrCYCHnDnTvxOKJPRs55UZ0McjZH1brfG +Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amv67a7xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OMfYQ7025324
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3ajpky4yms-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBmYU+IjhrDTj0yYrbfRfCprR4xKBUNgT36S7PvX9Iz9ViVUIDTdayHdc63QBmKelDYMsiGKZgGd7TUxA87+mvibrIZjfP4eZfzdUkq/LEx+pWDbTloEU/uMnWDQS9PpizHHpufhNlXNB1shLW1gCjtsZzKtxkjURvYNg/ifewK6wIw66nSpyMwesNwOhKVe/6SZC38kicYdwgh4occwnyVXmLufXZ/JZQX/8cpcudfyGIgI3IrMl3vsqgJ98ucayiQGF++WRhtgiACTE8QbgxiAEZpaAPuEiMxE6VbdACWmW5wB6wIqTVjr0KZADxz9KFNGND84bZWSxUxM7xFG9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OePTOhm3QQIxzhLWAS2JnKE9a9ppYu8Dg7JhuAi4l+E=;
 b=OXTf4sekmsg2xHbf4fgWUvddXSAcw1EX5DzGDT5Wuj3NLU9pIBIiZAlbFnlGYp9ksjN+s+rP1Nge/vs9udoKEKds9kL7A98f9V2L2n1WhWLlRe6DH/C82TPRbDdwtbQ9BIjHSVmlGOoq9DHapXvvn0NWB6gaLXn4O5Io+VB2l4E6WpnxyNRCCDrICK24t+Q4q4VO5cZ95HKzHZrGR4He/QohjKVAO0rBYPf07CoIWABwld2MxkQj57c2kSERu0/q+gsBPvXA7q28NSPnLQNRn38gwyGKC0SbWfgBwtNECXBhgWPUMTt7vtv4TauOK+d2BPlaMq3j7e8zFAIBIAYczA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OePTOhm3QQIxzhLWAS2JnKE9a9ppYu8Dg7JhuAi4l+E=;
 b=b/Hi/Tkj3eCZbuU1hzvOzkl/PpCnD6YqZEVBXDDS3ZAwjNFos2tpHBMJ5FpxOv+Uv7gypE4SWAIJte5Yz4xXh+417XvcdESgPJL5ZLIRqNeLNv6EY2ptZPwHAePDBKplOLjAg/FcABStJKTuonQWY1OyZnLOQDtctnunHWMS7GY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 22:44:47 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 22:44:47 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v24 07/11] xfs: Remove unused xfs_attr_*_args
Date:   Tue, 24 Aug 2021 15:44:30 -0700
Message-Id: <20210824224434.968720-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824224434.968720-1-allison.henderson@oracle.com>
References: <20210824224434.968720-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:44:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06449859-cf0c-4546-d064-08d96750c45f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4653:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4653B2767C2F2B7A6EFCE4F595C59@SJ0PR10MB4653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nFeBu+2io9/vQHKvKN3Oa/Jcop3dvkZsczTlZ6RW6U63HOcTt5F3g/G56W9DrIMETUhxbXECFokNGrZK7xl1xmT9hK4GHqE3PZd+ZPrIUTlVTxmE7Rjzk22v+6eJ9dZS4YRQnrtCjGJe38Sjgn8EJwp7nNV/TyhB2Wq3Rk/BTXHJOTK8TqWXS3jG7s5M/Hqw5/yY/bdacRo7YihS46PVoY9lmGfBRfUF7UY3JK4rCq6SwEkrHZH/S8QgY/ejH0kGsBmELQ5d25m1EgEw5aAdaTVIfKVwqzjazVVPv0AFN/25IREHqmUrXW+dMyDhGqne6P9dXLglKpIIsojmzWJm+MBzuj/vu6trqATCP9i3RQsp1jKzEcq1Exjdlq+7S+P1w5Z8+3dWu/CTjLZyZqO573FpqItvhBh1RteSb1n28C9aHYMk220HqIMlGwZL3cI4ajSxEGJGWgLk/BfQISUb8DMNfA/M5ZmYw9gPOGH/XarSg7NTTOf4wm95j7N4tn4lhmZoa2Ygk3trUaIIzYvWF/b/HLmDGxW6k94nUaAHR3ox06V0kWFAGQOc2n7jEWSCEYCAyvNFnzwtfI+opt6lvWCu+MdADyb7/kzXWUY8PYwvqdA3roVVRj9jdMDFFYRspcX+WPgkoSDR2L5inpnZYY/AqnrnnbUaXjpQDwSb7CKaspXX/xBJzKtEtT7esyVU6o6cC+Pp9x+rEKnyAaUasg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(66476007)(86362001)(66946007)(83380400001)(6486002)(6512007)(2906002)(52116002)(186003)(6506007)(66556008)(508600001)(8676002)(316002)(956004)(8936002)(36756003)(26005)(44832011)(5660300002)(2616005)(38100700002)(38350700002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wsBXVUtSeYsK1LOpBWhFHUWzcDFb4538Y+pZEGliir/KQuSlruTO+RQ+qGt+?=
 =?us-ascii?Q?09E8wqu2wNumeV3GNxMwGiHM9KP1ocupbaluOGUzVgc29eA6iNzviGQn6szQ?=
 =?us-ascii?Q?qhGn3vCzR8HjFFL+/P9kVF/qbCz6tgRmKW5B7FIR6ayPp6yBOyS4nFgrFCJd?=
 =?us-ascii?Q?KNx/zfAKG1qHnh1eZaTYMW4LRrm4sMlWoMkAjONrOCgVdB3Dom6pnEuf69Qz?=
 =?us-ascii?Q?69rENY9QTgQdoEhaLDX2N2qKDyDWj7/aXK9WWZvKqfzurtBvHcVC8JtDxhWq?=
 =?us-ascii?Q?3/7AI5ikM6OrqLUwZ3WMkujH5+4H4ykbJd8o7keiW1inAGZTgNs/gOBuuFkd?=
 =?us-ascii?Q?8MHEMJ1IxSEaVYDdGYqDT0MgvO5BNAvx2t3/UKHawIzjMP5Ud7cRoz9cSfMr?=
 =?us-ascii?Q?y93CfHCGW7W+1BreiIpIIx2Pzw1Qi8NGdLJi5sU0lkJ4/zNDv/v2FwVLtYYu?=
 =?us-ascii?Q?zSxnjdHAj3chcQE7sRjfNCrnpWPfGhDZeYm2WsC7FaGhfMFRxBlcSfS9Pq+3?=
 =?us-ascii?Q?rpnWGhx8mhBYPDK4j7QSfImaHVwTDFdw8KWYEz7sEtqXdDubh//bQBfK8dx+?=
 =?us-ascii?Q?3/lPpWjyfTyWM7cjCRrlB/cemAE63f2Dtmju3ATEojYncAe9UayMYhJG3wf3?=
 =?us-ascii?Q?OR83yaXxLH2aOSbiNJQtYpLzvBY8UQTRREB3j64qHawNaaRCR19uM8PnoOTp?=
 =?us-ascii?Q?/JrVDscdn4hukvcksO+XP2cGZ7+VgBy+PO1Jt9BCEzCkJeWG8PexgRJMjHaU?=
 =?us-ascii?Q?du/2cJxi2o6DtdaXagRxg5B3ydh2oXgCFe3sj5JMsNFwTpyzqA/Hr/Z6N+Nw?=
 =?us-ascii?Q?Bpe3dImroZakR/scOHFg7CpbAZLG3UF1o7kaNvZ9yZ4TvouldvKHzcbdF9S0?=
 =?us-ascii?Q?x0es67dwNTt76vfZ1kooZXi5x8Xrmp9lgCW46MNTQIifoN4v0ufcbz2t4REZ?=
 =?us-ascii?Q?WuLgRHb4jQvbc0WVEpoe0lQkfxGpqU0OOhY0EGbyyG/nHSr/7CTr74M+jc8m?=
 =?us-ascii?Q?zClKxkAJwZ4J8agSkZnZpFOWsSENbJUbXXbFYWGnHesC8XBTFhZ1gEgwTt6R?=
 =?us-ascii?Q?D+BKZ6tS06LqRBpHddWGW938lKvvaqc2CnNm3qA3rJWqDCNpYQ+dvuZv1SNH?=
 =?us-ascii?Q?nu8xcEVkgBGjrtimhdVh5jQQ5CWCR5VeTfH3UqFQj+4/jxia9gytwPGYskuW?=
 =?us-ascii?Q?7IrJAvWHeIj0KHjqGLRf9Txkt2gV/9x+iqFiIsKg0s44f0d3aZwKjxVFgv5D?=
 =?us-ascii?Q?CAzyAfxTWSIZA8ba/YmvQrr/D5ucodoklQS2jsQ8cNilrpx+k88jrHISrNTq?=
 =?us-ascii?Q?QdLnDfnh5HYRBuphTfWg6dZJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06449859-cf0c-4546-d064-08d96750c45f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:44:44.0837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qZOomViSR6jXpaBOz6D2iRE/1gCxPd/wBK56SMT6OJ3u+eHNbUVmnHMqvJFGil7b7lAdUVh1c2z6+0UifDVI82eE6M+4MbMHWNhX3ScxAxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240141
X-Proofpoint-ORIG-GUID: tfcAXloi33UK7pcdLZf_9EH4Uz4ukxEu
X-Proofpoint-GUID: tfcAXloi33UK7pcdLZf_9EH4Uz4ukxEu
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
These high level loops are now driven by the delayed operations code,
and can be removed.

Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
since we only have one caller that passes dac->leaf_bp

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 106 +++-----------------------------
 fs/xfs/libxfs/xfs_attr.h        |  10 +--
 fs/xfs/libxfs/xfs_attr_remote.c |   1 -
 fs/xfs/xfs_attr_item.c          |   6 +-
 4 files changed, 14 insertions(+), 109 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 6877683e2e35..d62ab53c3b07 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -244,64 +244,9 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Checks to see if a delayed attribute transaction should be rolled.  If so,
- * transaction is finished or rolled as needed.
- */
-STATIC int
-xfs_attr_trans_roll(
-	struct xfs_delattr_context	*dac)
-{
-	struct xfs_da_args		*args = dac->da_args;
-	int				error;
-
-	if (dac->flags & XFS_DAC_DEFER_FINISH) {
-		/*
-		 * The caller wants us to finish all the deferred ops so that we
-		 * avoid pinning the log tail with a large number of deferred
-		 * ops.
-		 */
-		dac->flags &= ~XFS_DAC_DEFER_FINISH;
-		error = xfs_defer_finish(&args->trans);
-	} else
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-
-	return error;
-}
-
-/*
- * Set the attribute specified in @args.
- */
-int
-xfs_attr_set_args(
-	struct xfs_da_args		*args)
-{
-	struct xfs_buf			*leaf_bp = NULL;
-	int				error = 0;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_set_iter(&dac, &leaf_bp);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error) {
-			if (leaf_bp)
-				xfs_trans_brelse(args->trans, leaf_bp);
-			return error;
-		}
-	} while (true);
-
-	return error;
-}
-
 STATIC int
 xfs_attr_sf_addname(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -320,7 +265,7 @@ xfs_attr_sf_addname(
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &dac->leaf_bp);
 	if (error)
 		return error;
 
@@ -329,7 +274,7 @@ xfs_attr_sf_addname(
 	 * push cannot grab the half-baked leaf buffer and run into problems
 	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
+	xfs_trans_bhold(args->trans, dac->leaf_bp);
 
 	/*
 	 * We're still in XFS_DAS_UNINIT state here.  We've converted
@@ -337,7 +282,6 @@ xfs_attr_sf_addname(
 	 * add.
 	 */
 	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
-	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
@@ -350,8 +294,7 @@ xfs_attr_sf_addname(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args              *args = dac->da_args;
 	struct xfs_inode		*dp = args->dp;
@@ -370,14 +313,14 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_sf_addname(dac, leaf_bp);
-		if (*leaf_bp != NULL) {
-			xfs_trans_bhold_release(args->trans, *leaf_bp);
-			*leaf_bp = NULL;
+			return xfs_attr_sf_addname(dac);
+		if (dac->leaf_bp != NULL) {
+			xfs_trans_bhold_release(args->trans, dac->leaf_bp);
+			dac->leaf_bp = NULL;
 		}
 
 		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args, *leaf_bp);
+			error = xfs_attr_leaf_try_add(args, dac->leaf_bp);
 			if (error == -ENOSPC) {
 				error = xfs_attr3_leaf_to_node(args);
 				if (error)
@@ -396,7 +339,6 @@ xfs_attr_set_iter(
 				 * be a node, so we'll fall down into the node
 				 * handling code below
 				 */
-				dac->flags |= XFS_DAC_DEFER_FINISH;
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
 				return -EAGAIN;
@@ -687,32 +629,6 @@ xfs_attr_lookup(
 	return xfs_attr_node_hasname(args, NULL);
 }
 
-/*
- * Remove the attribute specified in @args.
- */
-int
-xfs_attr_remove_args(
-	struct xfs_da_args	*args)
-{
-	int				error;
-	struct xfs_delattr_context	dac = {
-		.da_args	= args,
-	};
-
-	do {
-		error = xfs_attr_remove_iter(&dac);
-		if (error != -EAGAIN)
-			break;
-
-		error = xfs_attr_trans_roll(&dac);
-		if (error)
-			return error;
-
-	} while (true);
-
-	return error;
-}
-
 /*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
@@ -1275,7 +1191,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_node_addname_return(
 					dac->dela_state, args->dp);
 			return -EAGAIN;
@@ -1290,7 +1205,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1544,7 +1458,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 			dac->dela_state = XFS_DAS_RM_NAME;
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_remove_iter_return(dac->dela_state, args->dp);
 			return -EAGAIN;
 		}
@@ -1572,7 +1485,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
 					dac->dela_state, args->dp);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0f326c28ab7c..efb7ac4fc41c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -457,9 +457,8 @@ enum xfs_delattr_state {
 /*
  * Defines for xfs_delattr_context.flags
  */
-#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
-#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
-#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
+#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
+#define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -517,10 +516,7 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-		      struct xfs_buf **leaf_bp);
-int xfs_attr_remove_args(struct xfs_da_args *args);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 83b95be9ded8..c806319134fb 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -695,7 +695,6 @@ xfs_attr_rmtval_remove(
 	 * the parent
 	 */
 	if (!done) {
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
 		return -EAGAIN;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c6d5ed34b424..928c0076a2fd 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -285,7 +285,6 @@ STATIC int
 xfs_trans_attr_finish_update(
 	struct xfs_delattr_context	*dac,
 	struct xfs_attrd_log_item	*attrdp,
-	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	struct xfs_da_args		*args = dac->da_args;
@@ -295,7 +294,7 @@ xfs_trans_attr_finish_update(
 
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
@@ -405,7 +404,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
+	error = xfs_trans_attr_finish_update(dac, done_item,
 					     attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
@@ -617,7 +616,6 @@ xfs_attri_item_recover(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
-					   &attr->xattri_dac.leaf_bp,
 					   attrp->alfi_op_flags);
 	if (ret == -EAGAIN) {
 		/* There's more work to do, so add it to this transaction */
-- 
2.25.1

