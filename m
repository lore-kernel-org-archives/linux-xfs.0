Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8B3C47087
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2DC36101B
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhEYT5F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37898 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbhEYT5B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:57:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJnOxN034959
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=gVd0enhwIWaYRhCmoYWj67z08taQidFZsLD19HHO84Q=;
 b=ICw1Y0l9weGkpuTHsow67zzjGHeEdYUM/tYtFWG2Kj5ey6bZHRiUqkf3euh7HoOTt2Qy
 emyGmGGzZErb3vakJNeLIFTVWjseg56HK3/DdcrTDm7Ef4NuUSwOAPXNgDrArUFRSX2x
 5/NCIKCEyWeSeYCXNprpB6nhw2XYKjIIzb2wbxNsQ67N6RQANvKX9fko/ZGsDY9Hrby3
 KvasJafGr7bPY90icRh9JALdv5qa3hEr38FvFpsEuYrcDvpbEfUNM3yMO2VsOocUsaQp
 VvcKtm5SqqlSKlAbrpAWkEX80FyQRKcNhz3w6+S6Ihgi8W/rhhjPGtp2OJaUtQnR6qtj Qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38q3q8xkjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJotnU143650
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 38rehawt3d-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/RibRB4j0NdF7n9HriD2CoOS4/nslQOT/EHOBZyGr/kEdVSEebwd2szdqNE0MyWWUOVNRE+v+UwH95yzUN+zlBuONT+Fws0K5F5sNRA1+imFTIDZLrmzxe4mUYHvdmssk4O20oKeFoj+A03+ySoxdjaYwUKw0KH4gkURds/qtc4mBzOOexM79xFkkOHcHRwFarXOZ66WX97vIFIpRjzZtEdPmhXo+P1YK07ufudUuqykTqfHA2xUtBJIGdJZ7EBWJLbI8EgA3mr5/uXvC0PFTtmgfzq/G3PS4fqOmxEIZlrPIpxPCqLey+5WrV80rpxm/JfHYzO48q0+YHGgSXdaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVd0enhwIWaYRhCmoYWj67z08taQidFZsLD19HHO84Q=;
 b=V4AplUqZaDNlHGEnJpM4EPoXc4hxUXeRNE7azkxgCEvgiAjpVYUDRxGbGJuWt8SKqDjfTuAhW1thsvPaE2f9bH+Jb7/MONAK8ehm+acnF0vtcdoCftitpfr7ZAyF86JgvduzllMmz4a1Sr4WsVlQ9iOiSKdBHwwadm3cERCqp4CvoOqBHjLNLqUObIfcYhZ33ocHjxVZ+lIiJc0iMVRrut7CBmSBsIiBoUb8d+V4xR1BR7cBgBd0Grip8R8HcfIHX4sPuJvbPyrRkG0IK4rtwRldD2A9706r5MWNwG7tTqtIX04dTI+qKEgBQ3dM5NYxD/QEyp9NaklWEyU7wva6XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVd0enhwIWaYRhCmoYWj67z08taQidFZsLD19HHO84Q=;
 b=NYd0IdMtZjgQAhA2Dr9Ekh/Y8JaZrImo/fHEmGnI8DBgJs7PRtmxuazCimtt/AoVG30hgfHKQOw/ic+Ogsj+BVcZFHHjxa4L1rPYqqe5X+nSPN2sF4KaLW662s5pFG/6zcgLNpvyORjGt0SAckqlB17RyYs4Eve4u/WicFmhhKE=
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
Subject: [PATCH v19 03/14] xfs: Refactor xfs_attr_set_shortform
Date:   Tue, 25 May 2021 12:54:53 -0700
Message-Id: <20210525195504.7332-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210525195504.7332-1-allison.henderson@oracle.com>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 19:55:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03c93017-0695-4813-6327-08d91fb70ae8
X-MS-TrafficTypeDiagnostic: BYAPR10MB3144:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3144A13C1D70B197FDE3F1E195259@BYAPR10MB3144.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WLKxpsncQYkKa98YhSEIoj0AVBqoNjMV7rjwu5/CBJs2tOyuQEvdMIiywxsEWyNWzfKleCCjasrCr591wrfAokMKx+x69FNt/I7HxdtrWz1jmU0v12tRxr/fvHWuuDJove/fRlbhA5KxFk0sdpFa5RvT2kFe2JohFohZmWkc5yCdBIxGudvqBqTYbuNlB/kISurV5jL/5Lo2VORB5bNiH2hGyY5E0N6YxJKh35oli39KqXyWUk2iqwx0+FGlKbCzHfmbQ9kmIlhkkDn4qweGBv1L6hPBv6Ig32iiMZwGA9DJgpI1aULxmfS2EaG+6kb+qceWnwF1BRhUl46HgXtNpCLzqW86lmf2vkyjrhuKcp/Ev0d3yr9RUahoxXZmnigilKuRiwRMeIJsOkguBYzT/XslP+GpI6/h4doF8MNj37FS836CcbGegJBtX+HLY91xXFvm7fsP7QAnP00Yt0tb84hcYn2DZkwmd953OOS9Fh34sztK9z850/0S2s1RF8Qz+ja5eK0N+fwYzmY3ZwwjZJv3uOIjJRVTVaumyldKLdkJSTMlES3wGCph184VIr+8YxhwAVZnwfirdjN+g+PNbIwMl33HCVnFJSfMumyaU9yugDUFzwn3CkOY7rxNq1n60PQAYeLquSfyTJ0johbksLZfhlHHix+y+t6Jx+5/kGGqZwIVF4mD62hd+mvJZgft
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(346002)(396003)(376002)(8936002)(6486002)(6916009)(8676002)(2906002)(26005)(36756003)(6512007)(38350700002)(478600001)(66476007)(38100700002)(83380400001)(66556008)(6666004)(186003)(956004)(52116002)(2616005)(44832011)(86362001)(16526019)(1076003)(66946007)(5660300002)(6506007)(316002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Gm5+TJH8Thytf2o1PnnSdTbAvoybz704rtxt2r7qlJqIQN2kHNInZa5CcJ2a?=
 =?us-ascii?Q?KhSw7GAXEgAL6B1qVjB+GpMRHEGIvbJK9kt1Yvf7d9QIZTZZ5iTpNGqHEmtW?=
 =?us-ascii?Q?eVXq9h6mHhz/FAYkTBwXhYFO6N9RQIJbyVjYkkz6tKoaemcR8ran6mx1kD5+?=
 =?us-ascii?Q?QI0QhQh6KP9UAiusPklAryji9b7cNcTpfIzS4U+KnIqDzToNC+9sa09VhfCT?=
 =?us-ascii?Q?WFpL0bSHGzSP2uuotWaT5glL0B2wmKklIzfaRsES80weW6fw/JLpHGhgysbX?=
 =?us-ascii?Q?m1gsqwbCGnkgCzNxTko5VHmHqQsVIUV2SeaxoKwQ2PJO2cPRbAtr6/auzC18?=
 =?us-ascii?Q?Dk1Fv/B5kbMjrPpVDWwaSNtTpOC4TXxeTaBrXVI5qTzBXPtqKvgM8ryVpDLt?=
 =?us-ascii?Q?oGTtK5q7yfDjWL8B4UghAYqawCrImgSo3e7m7LeIbMJLd7UqtliPvIHma/RE?=
 =?us-ascii?Q?XmlL+Xl4bZNq3SJ+GnwBylX96hY8IdwQfWRyULCrAURKGV0gqCk7FuJ7BWs6?=
 =?us-ascii?Q?r91UutniuP8q12nfa6azwEQFiNwPF5NzCuXrU/+fEpzvLbypqcfLP2tKXLmq?=
 =?us-ascii?Q?t/Mj3aKFe5ZriWOL0V/b7lclHRDfXVQE293EpVQVr4IrHPS22e1N8PpgpIZb?=
 =?us-ascii?Q?zVr1ezxlkZs4kzzYcTCzy4IIBR4iGNfDp0XUmthCxGZXWLfQqyy21GsW9cu2?=
 =?us-ascii?Q?InjX8gJQs+kmXvxdjsgVYFkbnYGA0zoIANP8S6rrnwebORxosF98qjRXZoTZ?=
 =?us-ascii?Q?z9BqbCVojSDCasUAbchfNstJkK0teEvTpbUax1SnKLr7YrvA6jLAhcF+Zbtu?=
 =?us-ascii?Q?Vu3zQv6gwz2uzz9aAij7Ui1ELom6+RYuoF3RHFhoXy8fyI2+2JkmAsd6ZFPl?=
 =?us-ascii?Q?gURiOti4MkLOwzAcY06tNk1s7AgfVJVtUu/jQdyEZdxGAH6MEgCYGxXtmdap?=
 =?us-ascii?Q?goQrHd59xLrHrMt07FeOgU1wMitpnmfmHhSS5SfdawLVVj5EkPz+3yJoYVoF?=
 =?us-ascii?Q?nbVDaiT+krewrL95exfFo1OnN0n2lzwbQ0NEvrq1gwN4g8uxVQxBoM0JzzZi?=
 =?us-ascii?Q?S1e5SZDWGt4wwjZ7TdYQhhndE+OrzVHLvyRXupo7GshfkFLGG4r5g4ZgI4wu?=
 =?us-ascii?Q?mwTaiyvb+Q6iPdj2b4mRzCh9Y8PvW07sj835bYEtskYHECdhm/wv15DJTsLR?=
 =?us-ascii?Q?TGxAGiuUFeM2kuv5ztGvXxrCYYsCiyrHc0FVcTdoNOZpH8v1TXx9thL6sOtO?=
 =?us-ascii?Q?MtmW7BCbm6oKYdezaPyYegikLEkfrZx+rj6smLIPhxHGnT70m9XkTDNDbSfj?=
 =?us-ascii?Q?U/im+cKPrfSR90Anegy8Deng?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03c93017-0695-4813-6327-08d91fb70ae8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:27.3572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YjrlJjLS0iWyuKuJAxybzHfKtA3LoS6q2Q2ohi9f10tLPvETa99chNo2IeSLBvOVmlMA0GqaWepkvyDupnVG7fCQhUi4zXvqsgZE/2JnIcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3144
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
X-Proofpoint-GUID: HTD8JZJRvAcHvDu-qkkpKqI3j4oN-ImK
X-Proofpoint-ORIG-GUID: HTD8JZJRvAcHvDu-qkkpKqI3j4oN-ImK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch is actually the combination of patches from the previous
version (v18).  Initially patch 3 hoisted xfs_attr_set_shortform, and
the next added the helper xfs_attr_set_fmt. xfs_attr_set_fmt is similar
the old xfs_attr_set_shortform. It returns 0 when the attr has been set
and no further action is needed. It returns -EAGAIN when shortform has
been transformed to leaf, and the calling function should proceed the
set the attr in leaf form.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8a08d5b..0ec1547 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -236,16 +236,11 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
-/*
- * Attempts to set an attr in shortform, or converts short form to leaf form if
- * there is not enough room.  If the attr is set, the transaction is committed
- * and set to NULL.
- */
 STATIC int
-xfs_attr_set_shortform(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**leaf_bp)
+xfs_attr_set_fmt(
+	struct xfs_da_args	*args)
 {
+	struct xfs_buf          *leaf_bp = NULL;
 	struct xfs_inode	*dp = args->dp;
 	int			error, error2 = 0;
 
@@ -258,29 +253,29 @@ xfs_attr_set_shortform(
 		args->trans = NULL;
 		return error ? error : error2;
 	}
+
 	/*
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
 	if (error)
 		return error;
 
 	/*
 	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
 	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier. Once we're done rolling the transaction we
-	 * can release the hold and add the attr to the leaf.
+	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
+	xfs_trans_bhold(args->trans, leaf_bp);
 	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, *leaf_bp);
+	xfs_trans_bhold_release(args->trans, leaf_bp);
 	if (error) {
-		xfs_trans_brelse(args->trans, *leaf_bp);
+		xfs_trans_brelse(args->trans, leaf_bp);
 		return error;
 	}
 
-	return 0;
+	return -EAGAIN;
 }
 
 /*
@@ -291,8 +286,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
-	int			error = 0;
+	int			error;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -301,15 +295,8 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
-
-		/*
-		 * If the attr was successfully set in shortform, the
-		 * transaction is committed and set to NULL.  Otherwise, is it
-		 * converted from shortform to leaf, and the transaction is
-		 * retained.
-		 */
-		error = xfs_attr_set_shortform(args, &leaf_bp);
-		if (error || !args->trans)
+		error = xfs_attr_set_fmt(args);
+		if (error != -EAGAIN)
 			return error;
 	}
 
@@ -344,8 +331,7 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	error = xfs_attr_node_addname(args);
-	return error;
+	return xfs_attr_node_addname(args);
 }
 
 /*
-- 
2.7.4

