Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D49C07E9B
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A64B61CD1
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhGGWYP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 18:24:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23264 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230116AbhGGWYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 18:24:11 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167MKQM6012937
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=t3Zj38a0pXIwRoQkAIoa//3MUQDnz9909N7/U/DKhNA=;
 b=evzrDI9kruMjMhfHt/31OOrRxLVfXxCeDmBK+pRI9SZAmpUPb9aO3O9/vcK/FllN7Kp0
 20HsuL/1qxtw48G3oRXvuJXRnbDBg/bZxB0maMPfRyMwcvCXLXdHOftdRwsIv1R31IKm
 LCZdZ7TVooJSVTGfqb/W9BTeluxuxJESFby1h2XfyKYxBxliLBvTCigjBU/fL9cjwAky
 FCUPtO4IWn9sUD/MblDnzZBWzz5XaA6xp8EPjndC568l9VoM6gQKB48KaPDbREf54+Vx
 9c9rSmBSVtm6o/KKU/cbOK7Xn9+OWx5/5CdY+NDOqubkfK7DWINMfj7IuLcrQtgDdZj+ kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39nbsxs6rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167MKYSj092507
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 39k1ny0hp5-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XpkrveffPjMXttnStH2AWOGsT8+U+1NxVGKWGu+ooWQOmT2Ta2MKQy225vFsWIDF55gZVr7CNMcXyEx0rnVN4qW6cNYGaDD3m8ceeu5Zh1gBEapY+5ikuGQmyswziDOFqoNfFp4p2OiKivRZp1u6GHXdI8rIXJGTrr4wxBYEXGrMZcuOYjvHB1rllaCZZ703R/kP3lOmg6ozCxMUOcFqzwHYOHWGXIa6exesAH+2N7OSgv4rHd6KNXFuTHNvufNMNaYqc8pzyTkMP438QkrAaBlmx41vbDjOyEEd/GgsSuxTEwXrSUAF93+0yJLzFwmcLzRVA+rH9AKxMHNgH+2rVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3Zj38a0pXIwRoQkAIoa//3MUQDnz9909N7/U/DKhNA=;
 b=mEOsyt0CubAanqGgE9z0HIbZnyYU4RIZ4khwIWJkhgUYAzBioDVyTkaL7Zz7w8vgFMF0vcQ+O6i92iL2tmscLd4WC6SrXU/SpHJGqfmJHvo0erefvv7DHgPKheot2EnhcdZOuWZZ1X2Z/JErt5iol7trOn8IqjKDD1PqFJikElZ/E14SOAjyVITmTtYOJOiS+Y6fss4CLxeXXyTM5VJ4o2YCt+BEKAhlS6CvQ+IFSPUYR4fKF2Ec0E5R7p6WNwUQh0wI4M6sCW28/4Yo5Gfp9vplhAM9yEcCMpTIKPWMwc20ZUpItJw9FDEzOmD5o7vi4tqRV0VnwuK2OpchrhcWJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3Zj38a0pXIwRoQkAIoa//3MUQDnz9909N7/U/DKhNA=;
 b=BaYUfH3A0S8D40172e90ngIIDCbyUhUAIRLdUXlKlMf/ag3DXoD1orCnXTuvr4jM416u06KbefLizXJ+MshzgjsvT/AJkruZTf7rt1FPAmVt4PJ0VhlCuBGiLQhMgYsmU4QUO2xbueoaQTjVjzrTRL4s9tVm715bDuywVeGz9kc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2760.namprd10.prod.outlook.com (2603:10b6:a02:a9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Wed, 7 Jul
 2021 22:21:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.020; Wed, 7 Jul 2021
 22:21:26 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v21 09/13] xfs: Remove unused xfs_attr_*_args
Date:   Wed,  7 Jul 2021 15:21:07 -0700
Message-Id: <20210707222111.16339-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707222111.16339-1-allison.henderson@oracle.com>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Wed, 7 Jul 2021 22:21:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b6b806c-1606-4ebd-0d2a-08d941958f85
X-MS-TrafficTypeDiagnostic: BYAPR10MB2760:
X-Microsoft-Antispam-PRVS: <BYAPR10MB276038EEE6A77EA8415A9720951A9@BYAPR10MB2760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OCS7eO2Iy2Om02l0X6EzjPFfAtTfBshnHM36/2QH40tGWKEJP8Vk4kEufeRXRgSe3A458lw6DR5qRdeUDb3+03hX0yo3gf6/vTLlQwct5NVR/cklUY5s13S9DsQv/Zcd7MRTAeakM9PJD4AM6eKabTYqNoBBFnKkLkdpwRW3ZZn9T2HsivZv3LGcDEs3F8pQbPOaGde3BBKMPzFwnI4aHe65P7DvMwPriAscxSHvo4nLVSO/DomfFGpYwbvGGJRxAStA12+TDdASyY2H2pcTOqebH43KDamVN7acX9qe15Ic7HiGo2iQBsQavceFuSl4IlFtzHvs8uU4Rj5DUiaEP0buzUCniKqvNUQgSwmCjtEXSr8JdBRK8pWyZrf869KoWSWDgDRmyrYCZnh5LWop4axYlcO3+uWCsXKEPNk4mHuEik19SeuEyUYPEYyNIV+0gjffvIvcoodqkq69HlqVe5ux9uuXU31jPK5VDyzBcwKHZZ5LUWhq5+A4o1l8VRke7tMPbIXVkqqqbiOM9DCoEJC8KvNtwIJqczeKL3mLt2bQaC8S0Xp06k131hHgpiYIdHtVIXYXfZer+9bWHLkzWOX0/AsatwQUIvOQm2QI17tuqOS4Hsc77hgBsJK7jSJl+qIxTSVerqdQpr++vhRkdcWQjYU4VaHesRuyR/taG8iejMDoO2AclX+6Y9oJ+d7EH5rxXWmw3QqsN5ZcTiqYqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(478600001)(83380400001)(8676002)(2616005)(6512007)(956004)(5660300002)(44832011)(66476007)(66556008)(186003)(2906002)(8936002)(86362001)(6916009)(36756003)(38350700002)(26005)(316002)(1076003)(52116002)(6486002)(66946007)(38100700002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jOHEPrypwrh4bHutmK2vrMgyMemqlot5J3eHtXiEwhfq03YCQiNDE0NORyS5?=
 =?us-ascii?Q?qm1ymGtXzYhO4C9BeXCmXFrEmnsZxVkfG5YrdjkaH+mmy7Zx1NmLtkKZZ290?=
 =?us-ascii?Q?BFm30l3QtT1H5mkXtmJTqsnJM2Fji+r/ra3lknx4t49ZuAN1lLZF8yNEOw5P?=
 =?us-ascii?Q?AzPlaa06XxbIdbJ5mpBSUWgcr0FNzMFTDalFl0+qEIPn++hOB3qN/OIDDeb2?=
 =?us-ascii?Q?VTZajTPIbAiDP57bdvTcDQ1gpTltSpslFEZEN7BZ0YbZf8cRX74mLPfFD9FR?=
 =?us-ascii?Q?9mt7i5JLxTTKbRFfUuwaPwt+XNpgRyQYOu9uxyx+tGcYp05t9/qV46p6veu7?=
 =?us-ascii?Q?v3rgKMkI173ydjKG/lZwwpWqwpFdDIsPH4Ej5sOlY9nmEdr47onMRzOm+6JM?=
 =?us-ascii?Q?y6mgfdxnU1i8axYrOj0k0PFjk7fvXVhNSa2IQkPInoPKEMQ57mswuBabQ/jR?=
 =?us-ascii?Q?bkV5lobkUfDNRz8sfbqudIZgNlfCffNF11InraskFIKIFP84RXxahNYbPGIP?=
 =?us-ascii?Q?GmIOYju3h2NmjOlW41RjHbbiLdym4R91Igc7l87gjbP4JXe8mNpron011tK3?=
 =?us-ascii?Q?igNN96sFbvhlRaJnAIH/cLEIvbBstUR83rd0g44o10CO6AI6ZDiXzZBGAgRv?=
 =?us-ascii?Q?rJ8zhJOq7h1tCtYDiptnmN/628qWKNGYVQoLhRLwxuER/q/GOsgjC971CqQl?=
 =?us-ascii?Q?nj6vKssi1I7/8yAit5+Ru+FmshXjyYPdrEH2JqN9SveUkyx+vqkIQyr+s743?=
 =?us-ascii?Q?1nzcJNw4vnOu7YjygJiXTsxAHyuzgm40jejjm++wAlhullWIQSPgB3cgdIYK?=
 =?us-ascii?Q?YNfsTOJpim0tg5qSBBV8plrJ1acWmeHtqd1Vm7x63WEh1SHa7wdBhCWpMztY?=
 =?us-ascii?Q?6NWyyVsu8ljjiDJg4rH6gD/tVhKoCNqJUheZZpZcvL5fWJwH2a90ZdJI/oe8?=
 =?us-ascii?Q?nxnAM0k1uvhz2kd7JPAEhDBdQN8KYMTJz2j0cvgvJrrEpMQ6rpEWTUm5Plyy?=
 =?us-ascii?Q?AyY/3gJ1Mb6Z+32OhxiY25XpE85PAH98YEkncmIbSqhIflVLpPRbeg1gG2Cc?=
 =?us-ascii?Q?FU24TCmI/mXLFuWs4NU7jbQ1s5OZXJ9QH/+I5EVi0uisaqc7QAEfEox27HZM?=
 =?us-ascii?Q?zuiZgzmowjFpuS1J+VfXj1ySaXvFTiQBdwMRG+YNDooHn88wtVGD3O33lXiM?=
 =?us-ascii?Q?4ppda2k47sRWWbdDFIXtWpzYMTo0cKY3Kp5ky/qaC4BBc3rR9CFWNxf30e2m?=
 =?us-ascii?Q?TMtNtZh36DAwkNaYVmC7ote2Db3xmfxk9pp2Ki3Tz9mWT0YBB7yoNneO9Ery?=
 =?us-ascii?Q?uxwbHe6Qo3vBvpAR/Ejwf97v?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b6b806c-1606-4ebd-0d2a-08d941958f85
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:21:26.5520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16EfvQ1PuUcFBruPP7mZV6r1hMtjI6T7vhilncmbOgdIhn3uK8c2n64XELamgML535430X2c9YuNnPFJXel6uizS0vZdNXvgrlVIBkaTK4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070128
X-Proofpoint-ORIG-GUID: NRFfWfbIRRWgk7wvjHI14nMHJllTRorL
X-Proofpoint-GUID: NRFfWfbIRRWgk7wvjHI14nMHJllTRorL
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
---
 fs/xfs/libxfs/xfs_attr.c        | 96 +++--------------------------------------
 fs/xfs/libxfs/xfs_attr.h        | 10 ++---
 fs/xfs/libxfs/xfs_attr_remote.c |  1 -
 fs/xfs/xfs_attr_item.c          |  6 +--
 4 files changed, 10 insertions(+), 103 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index becf9c0..cbf544f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -243,67 +243,13 @@ xfs_attr_is_shortform(
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
+	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
 	int				error = 0;
 
 	/*
@@ -336,7 +282,6 @@ xfs_attr_sf_addname(
 	 * add.
 	 */
 	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
-	dac->flags |= XFS_DAC_DEFER_FINISH;
 	return -EAGAIN;
 }
 
@@ -349,10 +294,10 @@ xfs_attr_sf_addname(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac,
-	struct xfs_buf			**leaf_bp)
+	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args              *args = dac->da_args;
+	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
@@ -369,7 +314,7 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_sf_addname(dac, leaf_bp);
+			return xfs_attr_sf_addname(dac);
 		if (*leaf_bp != NULL) {
 			xfs_trans_bhold_release(args->trans, *leaf_bp);
 			*leaf_bp = NULL;
@@ -395,7 +340,6 @@ xfs_attr_set_iter(
 				 * be a node, so we'll fall down into the node
 				 * handling code below
 				 */
-				dac->flags |= XFS_DAC_DEFER_FINISH;
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
 				return -EAGAIN;
@@ -684,32 +628,6 @@ xfs_has_attr(
 }
 
 /*
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
-/*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
  */
@@ -1262,7 +1180,6 @@ xfs_attr_node_addname(
 			 * this. dela_state is still unset by this function at
 			 * this point.
 			 */
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			trace_xfs_attr_node_addname_return(
 					dac->dela_state, args->dp);
 			return -EAGAIN;
@@ -1277,7 +1194,6 @@ xfs_attr_node_addname(
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		dac->flags |= XFS_DAC_DEFER_FINISH;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1528,7 +1444,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 			dac->dela_state = XFS_DAS_RM_NAME;
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			return -EAGAIN;
 		}
 
@@ -1555,7 +1470,6 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->flags |= XFS_DAC_DEFER_FINISH;
 			dac->dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
 					dac->dela_state, args->dp);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index d638d12..859dbef 100644
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
@@ -517,11 +516,8 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-		      struct xfs_buf **leaf_bp);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac);
 int xfs_has_attr(struct xfs_da_args *args);
-int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 1669043..e29c2b9 100644
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
index eda6ae3..a1ea055 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -292,7 +292,6 @@ int
 xfs_trans_attr_finish_update(
 	struct xfs_delattr_context	*dac,
 	struct xfs_attrd_log_item	*attrdp,
-	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	struct xfs_da_args		*args = dac->da_args;
@@ -305,7 +304,7 @@ xfs_trans_attr_finish_update(
 	switch (op_flags) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		error = xfs_attr_set_iter(dac, leaf_bp);
+		error = xfs_attr_set_iter(dac);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
@@ -432,7 +431,7 @@ xfs_attr_finish_item(
 	 */
 	dac->da_args->trans = tp;
 
-	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
+	error = xfs_trans_attr_finish_update(dac, done_item,
 					     attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
@@ -648,7 +647,6 @@ xfs_attri_item_recover(
 	xfs_trans_ijoin(args.trans, ip, 0);
 
 	error = xfs_trans_attr_finish_update(&attr.xattri_dac, done_item,
-					     &attr.xattri_dac.leaf_bp,
 					     attrp->alfi_op_flags);
 	if (error == -EAGAIN) {
 		/*
-- 
2.7.4

