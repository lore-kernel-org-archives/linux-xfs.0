Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59890C25B06
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238897AbiHDTkf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239066AbiHDTk3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3359B559E
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:28 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbRX7015052
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=+NzCibinHp779v1IovjYIjGazBzPOeOx99XbFZqICBo=;
 b=dQMM/FtAVFCzBwXEkmwgVB9Z0qWxseGciQ2Rvct4WLQasBsk/lINXMYgr6YyYLYheSKH
 XC3VQOIdgt5ted0Hbmxd+5NNanfleGWzfh754KIHV1SDAXZlqsldWSTwHsg45gyKdUMb
 Ryly1stTktGrHliBYzCxF2AXwn1Ynr2PlZUWcG4nmpN7KYKpi9rZJwRiJIvpseVKE0MA
 23RjKqlJpU3Km/I4b5IDQP08ttjUVlgsxudWKfVvAPyRN7GtRzJWKpwI0kQYnVVWcM58
 0X3f7ao+LpTik7AB9mj4L3jkl0pYZr4b74czF6xvOglq2IgcMCWsGsPfqjaNdlSFqg/7 Hw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu2cdn43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274IH90h007562
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34b93d-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDHddrFqd283th2EweubijQs6Cr8eVuSUeCN4yWC0A/Ry3R1DQm82krJQw3pkCR6FENillOcGq9SVrqrpCnz93F8gsGeTf+eos5zb12kiK2TwkrxW7ik8YpqsVqkxs0P4mnk9Pp5GMfcBj4DMOMtiurAjr2IxwAQl6HO4HgoPGmRSIjr1BcC9TpXDBHsIhp4VrteZThonEPV32/uXv6dO1d0SAs6XbiMGbni6WyppjsS3Wa9WzKAwmbW5XyHXu4Te23ygCmop6tur4kagMgzbkkko2TYa8TuenM9BPyBcCsIbUgxtYp1ctkp0lPlJhnamEzwhpCl2V91rHH0ZVr9wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+NzCibinHp779v1IovjYIjGazBzPOeOx99XbFZqICBo=;
 b=Hf0WHr3WhfAi1zZwXlSCnhkJrw2moN8UYQjHzmU6DnTUKcmjm7q1QfTYoIUAhUDek/V/lEj6sBmfl2/Hj+0r6SxuXLunW8IoKXPlPWTYQhSrOOcjhml/A4wd6pwwO1oM53g350gf539AwoKGTNtYRFxURXDAUB0X92wUkoBx2rPUITKUci1JGLLo4a52nZE9ClvHIOIJIfJYJl2JSwjwLlHFlEjss6/qd2ReG0FkJcKqsoTZ5xVDZN9sRBDuqRRF9m59kawVHGt+QDHS7iI3uLcpooru+kVeer0XxkpMWkwu0KW4IbrpxOveh7Sypc8YfcMi5Gf7mSYKecAUS9DbjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NzCibinHp779v1IovjYIjGazBzPOeOx99XbFZqICBo=;
 b=FhkP0iPu+009b2RCrrJaAyCbbGOMFu5RZahCxdtOTLF3422UXLYaBTUwJEhlNY6x0IBu9lYLNmpnW2Iya8SpWgqWHNT/CDT26/oVkxdZJ9xx//8loMgIpa0D7VZgWh5+/0pAqcMZifxZI6Np7vJYK5yVnPiDlxQG4Azu3wvLmeQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5040.namprd10.prod.outlook.com (2603:10b6:5:3b0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:40:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:24 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 07/18] xfs: get directory offset when replacing a directory name
Date:   Thu,  4 Aug 2022 12:40:02 -0700
Message-Id: <20220804194013.99237-8-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: fc3811e2-ea28-4d1a-6428-08da76512c2c
X-MS-TrafficTypeDiagnostic: DS7PR10MB5040:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /23LVzZIeOwgpaD+wsagE/eY67K8xmi/bYcns05EqoQ2Da0+oyzef7qcFsoAiTDTOoygcZDtsUEa2unVxT7ZyMF1R72rV9bzmaf2D24u5716Ddeml3CMjp3FU1IXL3++q2wI7uH+CdWhjgTwp8WNgO2EzyVwhkpNBIqE2Jjq9yBh7ZLZLK4yuDKwWwI4al5NEua8YfVvE045Pe0TEg1wShyFuxVL6xyCJx11vrrJpJwJwmVvEKkUAZQXaIdCZ8b7Oht2cRrhKPpdTN22L8lPVcCiPkkzfOvd2weN0PmfvOBtsfrkDd+cAWE3DncKWHhV8gccSX2fvuL8bEbNyNIU9kTUNvyE+RtIXeDtvjlEU4zlaCH2iK0qLlCuuGAWb7dFmMstPGqtSeIbYNuBol52+eHy1iOMpxeuB0VA2GBwsMnJj1JaTI8zA1zt+COiLZLW2iZhEBa8s9d74fnAYoNTkvv5b6xVO/IQUpbE2PQ87SmVlG/2gNOt1F84CNHKeFp+OxJK8UbpO3YuOhsr9pl3sMU1L+pDzpWTiIOr4GPEqU3pyU9809cFSomg0Dtn3lfFHRirsJkISpqAmho9DVY6JvtcGz0b9PwQ+Aa8tN2qtrEJYoPsdrJYN/zmEysF+CzIdOf8dOMVUiwElPm4cyUi/cBn2K3TycDZao/fOvCkgEUTAqthtYG+49BDrCx4TOMKeI8nGqyVrndnL9d3REq6RM3eMys1TVcGMG+DLsp1bh/6JXdc0uQFyvv1zRJ7X1jM64FDU1QdCdsobzf8T7HWJeUv47wrE/R4wQBaMLKiCvs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(136003)(39860400002)(346002)(396003)(41300700001)(6486002)(36756003)(2616005)(6666004)(2906002)(83380400001)(478600001)(316002)(1076003)(52116002)(66556008)(66946007)(26005)(6916009)(6512007)(66476007)(6506007)(8676002)(86362001)(8936002)(186003)(38350700002)(38100700002)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FhgmIeM97qC6PR/cWyJ0C/Rrcumhk024w/OjL3REbsHQ4N88gYRZ7gWRSb4D?=
 =?us-ascii?Q?daxqTVzwGxKyOKCB5nXXBMaO4EkQDpvmy5EOvsRKQaiprPcM+L6sMZB3YM6Q?=
 =?us-ascii?Q?RcliLl7dO8BzLg+QKf+twyy59VxCoRRfVeWZEhZwmY8pTYKvCcH1ieMUWT/O?=
 =?us-ascii?Q?l36R6JiKfW8MRPKh+oy5XypcpA09ZmVIwTUO9TOXNnUfNkRZWscXlOZUj+P3?=
 =?us-ascii?Q?lRMt61wfe/Zd7P3cF1W4TnV8x1By71b/mRBqAX0QZpCkUUyXUSrr2ytzX4z4?=
 =?us-ascii?Q?VHL/i20ITZZomecFm/6dwTzrX2LCFpNS2XOhMlvgh6lPowecpeCZRNeP/GP2?=
 =?us-ascii?Q?EA1ZJ/fnxnxQ4zXfSouEakPopSQu0x3vM5afL2v8QD1WfmA/6qLf8VRYtcsY?=
 =?us-ascii?Q?lIs5HFJAGxRXOPfI0hf4tRrGoVnFmuWDnarT7bZfO4ydAzjwu68HF+m2/+5h?=
 =?us-ascii?Q?VKEvfZdxypN2u0Dlo8ZcQT0Jm4WtGwQUHj61R3Th3pq3FnuwwZsEQ9Sg2bVG?=
 =?us-ascii?Q?4P1pbVvsCp9FmNNawrVE/Yeob0CJCYtFXTu8d5HQ3pkOi75gxsAsdrfCd8Qe?=
 =?us-ascii?Q?7acnXivweT4PGCv2Dq1kYdfti3+vKkIHKFwm2arN2CZpIdy9jrC3g0trsjMQ?=
 =?us-ascii?Q?TChvRNTLmJS5UzeQu6n8EtXif9bx9o5CIbxrBpuOxXBIh+50J6imIkVN3veE?=
 =?us-ascii?Q?cf1Tp0SkRIwCpg5WvSvZBppQOxK9lWpcWnTbeqVvP8wDk6mGlksgE8ofupGt?=
 =?us-ascii?Q?cZO7oB511Z97565Ns8+4Q6gxS0Zt8626rxFC+rABjD0Xgqgj8FzIJ6p/cPFf?=
 =?us-ascii?Q?Yoz4pvOOpyZt9SoTEy5zL5nuwsv6iqKTV85KXpYvCYdtNIt0v+LLelGXzKK1?=
 =?us-ascii?Q?TpvgKZo9oxm1k+yfySL7k/bH7+DmLSmiJo7dLQZ5cViXIe4eH+ski5VAl1UC?=
 =?us-ascii?Q?XoR8njSo9vz/Re1uwBPKp2uFAs1Hc5g89ueHCDGBwAndbEYqUifWuI2H2Wuv?=
 =?us-ascii?Q?wJhYvF6iVJLvsvsYvbqGWnNede4F2864T13ZUZreX8xn1OynJYix+lo1v6hL?=
 =?us-ascii?Q?CnWxPGDEk9UGUx7X9lv2UfE2f8Rx0sP/4ts49VJJclbPS1QbrOkOS7dDS2wC?=
 =?us-ascii?Q?PS4/GA3VYGj7HmZChMxFVZ1jXEUOyXhGRbLo/YvSrtC2g2dPM3DY4Xp9slpE?=
 =?us-ascii?Q?lHVKruLdeWWHOgcatpwtuyQEsLaeMkV0Pw+ZRKyXTNP7PcsKSN1ijXEGTSZ7?=
 =?us-ascii?Q?uxaxNegNucEy6opzhxVp8nSNQwXUQXqLt0T2WLc1MRkOHNcqCzQXy23AU+yj?=
 =?us-ascii?Q?NCjCBmFVRAD3vKJZ8TTAuUHdCIDQDLBTJYS+CruHnVHIBab3HK8tLR5Tyhwk?=
 =?us-ascii?Q?37IWdvJRSK3V4nAfRwSGZUqLAg5gillsxZ4oWRh33LynGGa68vek4BPsEgK+?=
 =?us-ascii?Q?jKZDcXThz4SmgQ8uAtzgz7Ujn+ie5hXSoHTHusgH5oz+fCrJj8ZngZGipPgV?=
 =?us-ascii?Q?mHJ7dP4RmXXMvAaTfKnNsNJTpPkpfvk4UUm+pdYfKohA1qf4lyKOGgvzHA0B?=
 =?us-ascii?Q?X63YM5V0uawvxFEjxW6ZMa39LAT0zQTdGB8E1IX9AfVEuAHdGL7uHosO5ABv?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc3811e2-ea28-4d1a-6428-08da76512c2c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:23.3443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vs4kW8ehokDOehUeCbGlOQWe5Xb+QyctNHm7+KkeUY9IfxT2LvMNLMwt8Vhaaw/WTNlS1GokRCMOuqIN3z0Bs6SKkQUUYg/MBtxWFxpmix4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5040
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=952 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-GUID: 4m_sCasf7GmQpCzmeqhLdOXGDEyEiBvh
X-Proofpoint-ORIG-GUID: 4m_sCasf7GmQpCzmeqhLdOXGDEyEiBvh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

[dchinner: forward ported and cleaned up]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
           Changed typedefs to raw struct types]

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c       |  8 ++++++--
 fs/xfs/libxfs/xfs_dir2.h       |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
 fs/xfs/xfs_inode.c             | 16 ++++++++--------
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index e62ec568f42d..e603323ce7a3 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -482,7 +482,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -498,7 +498,8 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -546,6 +547,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index c581d3b19bc6..fd943c0c00a0 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -50,7 +50,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index d36f3f1491da..0f3a03e87278 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -885,9 +885,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index c13763c16095..958b9fea64bd 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1518,6 +1518,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 39cbdeafa0f6..53cd0d5d94f7 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2242,6 +2242,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(leafhdr.ents[blk->index].address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 2dc1d8d52228..2a8df4ede1a1 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1109,6 +1109,8 @@ xfs_dir2_sf_replace(
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
 				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ce888f844053..09876ba10a42 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2487,7 +2487,7 @@ xfs_remove(
 		 */
 		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
-					tp->t_mountp->m_sb.sb_rootino, 0);
+					tp->t_mountp->m_sb.sb_rootino, 0, NULL);
 			if (error)
 				return error;
 		}
@@ -2627,12 +2627,12 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
@@ -2646,7 +2646,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
+						dp1->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -2670,7 +2670,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
+						dp2->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -3004,7 +3004,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3038,7 +3038,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					target_dp->i_ino, spaceres, NULL);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3077,7 +3077,7 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
+					spaceres, NULL);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres, NULL);
-- 
2.25.1

