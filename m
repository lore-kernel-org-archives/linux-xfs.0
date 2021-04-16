Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6C0C433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51E4D61184
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241678AbhDPJVa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:21:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46566 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbhDPJV1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:21:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G98aCJ036454
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=WZ3nWaVIGdeD7O/E53SOGUNw4rHx3zLUXh2w/JoNiTg=;
 b=m9TwE7pR4EyX5DOO9CHd24KC5BUlMPDOA6HN5+SFKc/1WFV3BOtm11yByB6dcm68fyHh
 NiK9pRiSNAIIRsoGJwjnw6/1ZJCLt8/nQ8ETafOf848C9aPYyRz6O6I9CKNvF4Jxf+E1
 8F+sjtUtF6Y2pl5UFgqmCiEtS4eD/tE5wXKaruIW8Qq2Rodu9xVWonuLUnu+CkMuCD6S
 N6YPscIsUKNeymivIshGMs2BoPPEbZpyCjQ6XQXp4VXRFUfiLDQmwZufmN80Y95AlkQF
 mIWTC+hBhHHObtqq/DtJw3DKi/tHJ+PFraF2TdvsT9mXPXo7qpa0/wqn2CA2CHUjmR8S Vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37u3ymrjae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXT0077147
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:01 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 37uny2cegt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jD3NzwR2LXOLc+mGZeFZiFbD0Rp4/pmHTdIYC8nhb0uX7fBQW2/EeJ6RFVMpXl3MK4zyXidX4uUFVi2BhfCFHFxryun/dJwhDb8nSFTE3WvOcC/MZKOIqKrivxjGetkS/Vu5+f5vv/W9dUb67WN87LNpKv3la1xx8T21PXRCJMVwZXUgtc6HwvXSls83jVSBSjieRKwm6tHnWwvfppq8SlDkAbsN49cZhRFr8GzLKPYtuNyx9kszqYV8+jPZ/xUPVZVe6slp9gdCXqzxhlPcXjytEbeWOcfZRlCQzM3Ezdz/Lmv+73nxIM3N8wG/N0bHxr5qMkI17JRy30pmwcZQKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZ3nWaVIGdeD7O/E53SOGUNw4rHx3zLUXh2w/JoNiTg=;
 b=B2+U99+ANPke5QLQBeWgvvqZMlsjGOjAmcjwYYpfL2eVJARnGdJxpeBAZV0ITiYxRth0NWWUQTiqMcLE6M+CwyRlebjjqtrzOxv4Lg+nQEza+mwVPfIY0YMerw/U+2XPOGDzaJQxivN7S1ENMaveGqjQhACBlJbdEtHZd1ptVNrBPouF3IgjH8jkEZkLyW7sh/rjSXr2+cLwIRi3aCPRVF4FaU1srxsGieNJw1sRRpce0WuoZJm5TTPZUtUPvrSnVWkc9mP/6RsBwua4GKmPvfNkBe1FPw/JMHHs7y2yVmzijTrjZdRntEt2y3bqVKA1+IUIR4hxKCuNjtJGqrfFSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZ3nWaVIGdeD7O/E53SOGUNw4rHx3zLUXh2w/JoNiTg=;
 b=rp0SJl3DLXQBMeXEFydQQxu0/F/+25raRvW7OP96DA2gx8EfzbuvXZWneUg+OOQJsUyeIBn+yaKs5WNnuwrwUaKqfGMjimtHLNSYMJpYhqzoMIuw1mcaXRNceI5tKlemAu19EphZU1jJpZ/cIYsD9FuJJkMnoafBnvU+kwvbFHQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2567.namprd10.prod.outlook.com (2603:10b6:a02:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 16 Apr
 2021 09:20:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:20:58 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 03/11] xfs: Hoist xfs_attr_set_shortform
Date:   Fri, 16 Apr 2021 02:20:37 -0700
Message-Id: <20210416092045.2215-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416092045.2215-1-allison.henderson@oracle.com>
References: <20210416092045.2215-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:20:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c70cb21c-e293-4a16-16f2-08d900b8f210
X-MS-TrafficTypeDiagnostic: BYAPR10MB2567:
X-Microsoft-Antispam-PRVS: <BYAPR10MB25679D1F0EF717CB590FA990954C9@BYAPR10MB2567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ulgi3rFGRMItLsfmrIZsmc1g4N6ORZglKMbrwvucV+U4KMKdgHYYdXRRa6lgkOYD/yOr9VhrSib+wKm94KQsMwMWQZW/m/0/oYMSvlRiT59IggoABQBMle6Wa/7GjZ/e8c+197kkLYopor6TadGG0ho/tJEETn5qHWoJKinDSr3IDbmiyXmQL/Ssm4h3gDVFdpgePEud8vZ7qaro95sM0ud2m3AgExa+wgReZaEn69bHZcDYVajgjLBc2SUNxvOxRIeQPq+tjEDKb2+JqpIXCswl5J5vA5eWl6smXdYQx4Z18NMFOCAv+B1jsiFOC7FQYMd0XHRe5OaA2OLZpOdCM5/5anVIovKv7EssNm1Aud6KogxYbSVVWt9TikCzhOPz7aDJIHaFbUrQUqnCuz64aV+rT8WHwX1FvOuJKTbxERS1BZdJQccceNjkmauYIG660cZ7g3EvktWYZK5fj0OzQme3iUbiY2LxvmqfX2Lj2JSxN+m+/Ru9D8zki9VpvV1sRkQYSni021RaTffr3a5SOSrvtf8zvdZkMlNQK8OCyIT0+LqE+IqhdLJ/d0CO0mNHeQ2iGHLuqrIaZFOCDI/A+8jKUA2c+wCa3r0Xa4mT1+l1/bSboaxfr7BjpykPlENBLK92szLjelNFoqHEQTtCj2uMar/2Fvaqz7BpWZFAEpdkfApwkpURA70y32VIgCG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(396003)(376002)(16526019)(8676002)(36756003)(44832011)(8936002)(38350700002)(52116002)(6666004)(69590400012)(83380400001)(2616005)(86362001)(66556008)(26005)(6512007)(6486002)(316002)(186003)(2906002)(1076003)(38100700002)(6506007)(66476007)(6916009)(5660300002)(956004)(508600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?r+vz4qUsWLcOvAehjFZ3jViHm1Ie6LpbhLoPvyNfvnhH5+HPZraI5oGbZWWD?=
 =?us-ascii?Q?I5VijrhlaldrTDxlHkQGnCFjPCkwOOh8jpoRINuBl5C0QjZ8Ul0VCl2Efuzs?=
 =?us-ascii?Q?IjWN4zVkmyz+Wzh8ir8apiJB5VnuNW6PMLe1XOVn1OeuuH6Crmyzry8p9feq?=
 =?us-ascii?Q?G45wJNLCJxYSWtc85BCR72eInTUIS3voJgnt0AoWAsOqZaN0zNbzrAUhOaLL?=
 =?us-ascii?Q?Wc5KMZ1qoH1QUtnYGuGaObwUjYIF08jcLi1P85MZEeXVtgXpq52FDgkLSQrC?=
 =?us-ascii?Q?g0CqN2vZHq3Fi/R8DT/5k6zr8pTVUl3D+ugQ28N48H1CSQUzB431PruUUh4y?=
 =?us-ascii?Q?huAjXyK2vJ2xJtqA4Ys6PxqZYbP5NothWCfojwDIhjzmt61KKejRweSDOPpx?=
 =?us-ascii?Q?YjUkifB0oM9eVBFkT5i82InZjaZP1hdNv09wycQCZVGZj8tK/9ChYruCTci9?=
 =?us-ascii?Q?V5/b6o3AxnvCG0jgXcAKYAiq4D3jUf7yyPHHppFnJpMgNPxNCqfiU3NkNjqt?=
 =?us-ascii?Q?mvPc1/2GTr3GnlxakMwDIHGdRhZiGIAo8wgG+Ef5nXEzCoZ2Tj5TLL9FJJ2z?=
 =?us-ascii?Q?64O1R59vJsThqs+lYOTemqvw4aHzEDybw0guEwSf2u/71j+ZgIhUA8kBRjna?=
 =?us-ascii?Q?UHkuC13KEk6HeyBuWqU+NaDqufvfYiiFuiN4tSIUXbrQbDHFUlYfx4aArFY1?=
 =?us-ascii?Q?zbO5dRNg9/tumi//QxKcOMqyn6StWcbFMXSY5fzCKBqHsvptOQ3l+hjIPEjF?=
 =?us-ascii?Q?tR35VNPAf3285sGSTy1eaF9+fv6skhuOSKmrZ7UFYMMB4kyu5bZDxm5XxCP/?=
 =?us-ascii?Q?Ur4ecYEqqerFeFsD7+q8mI8ZXWLN4/3xxVo68s0sZNYvgpISW4B9+NFghwdO?=
 =?us-ascii?Q?2QuV1/ZXJ9ApRvvtMi5rM2AKk6fALDwOrXGPJgC3l1y3cuKQ3NMfoCE2dyNs?=
 =?us-ascii?Q?asRkWypCN7gy9s5GNdOcqRAKE6JoWtgU2v09wlCdyl8mU1DYkdyrQoob4y6N?=
 =?us-ascii?Q?asDuSqkYwHgC9HbdFXKof3PWZhWqbrrKcubnAjVY21RxDOULGWkWlG8Sy1yE?=
 =?us-ascii?Q?v9T6Aq3jyxfOk98l9GizRu92rxar7TfKPVSZiTAWiYdI1W5VLAeGlEHS/KvO?=
 =?us-ascii?Q?QE0QZhvDhpTXYjWM5ZE/RyW/8i6coRgkHQ+Zrqi/Z6OQrqqK9cg54cqWdGiY?=
 =?us-ascii?Q?6xO3gIkxVQhj0seOI1mCeQcsL6egPOUCwOws5nWzy/HvMKIg/mHA7up78Sr8?=
 =?us-ascii?Q?qRPt7AarcnkEkT3zjyMgG2ZXGSfEm4wmk6K5EJ58s/kJY9psdeWc6Dbhdjxl?=
 =?us-ascii?Q?6Cy2M2ozyUxsDMWuwV8boQF3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c70cb21c-e293-4a16-16f2-08d900b8f210
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:20:58.6282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4cX1/lZ5DNEqAY0LCjpH0c152IGd1nZHnNPSERDlxEezFDyk5HCexqfVm+BDU2UgSZIyzkO+TRve/RlN455++q+NNtRW11RzVY590j1NiIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2567
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-GUID: Bmt9hpHfXHePpfCS18_NDE_NfkZ5l_Xc
X-Proofpoint-ORIG-GUID: Bmt9hpHfXHePpfCS18_NDE_NfkZ5l_Xc
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists xfs_attr_set_shortform into the calling function. This
will help keep all state management code in the same scope.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 81 ++++++++++++++++--------------------------------
 1 file changed, 27 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1832bbf..6987ee5 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -217,53 +217,6 @@ xfs_attr_is_shortform(
 }
 
 /*
- * Attempts to set an attr in shortform, or converts short form to leaf form if
- * there is not enough room.  If the attr is set, the transaction is committed
- * and set to NULL.
- */
-STATIC int
-xfs_attr_set_shortform(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**leaf_bp)
-{
-	struct xfs_inode	*dp = args->dp;
-	int			error, error2 = 0;
-
-	/*
-	 * Try to add the attr to the attribute list in the inode.
-	 */
-	error = xfs_attr_try_sf_addname(dp, args);
-	if (error != -ENOSPC) {
-		error2 = xfs_trans_commit(args->trans);
-		args->trans = NULL;
-		return error ? error : error2;
-	}
-	/*
-	 * It won't fit in the shortform, transform to a leaf block.  GROT:
-	 * another possible req'mt for a double-split btree op.
-	 */
-	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
-	if (error)
-		return error;
-
-	/*
-	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
-	 * push cannot grab the half-baked leaf buffer and run into problems
-	 * with the write verifier. Once we're done rolling the transaction we
-	 * can release the hold and add the attr to the leaf.
-	 */
-	xfs_trans_bhold(args->trans, *leaf_bp);
-	error = xfs_defer_finish(&args->trans);
-	xfs_trans_bhold_release(args->trans, *leaf_bp);
-	if (error) {
-		xfs_trans_brelse(args->trans, *leaf_bp);
-		return error;
-	}
-
-	return 0;
-}
-
-/*
  * Set the attribute specified in @args.
  */
 int
@@ -272,7 +225,7 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error = 0;
+	int			error2, error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -281,16 +234,36 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
+		/*
+		 * Try to add the attr to the attribute list in the inode.
+		 */
+		error = xfs_attr_try_sf_addname(dp, args);
+		if (error != -ENOSPC) {
+			error2 = xfs_trans_commit(args->trans);
+			args->trans = NULL;
+			return error ? error : error2;
+		}
+
+		/*
+		 * It won't fit in the shortform, transform to a leaf block.
+		 * GROT: another possible req'mt for a double-split btree op.
+		 */
+		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+		if (error)
+			return error;
 
 		/*
-		 * If the attr was successfully set in shortform, the
-		 * transaction is committed and set to NULL.  Otherwise, is it
-		 * converted from shortform to leaf, and the transaction is
-		 * retained.
+		 * Prevent the leaf buffer from being unlocked so that a
+		 * concurrent AIL push cannot grab the half-baked leaf buffer
+		 * and run into problems with the write verifier.
 		 */
-		error = xfs_attr_set_shortform(args, &leaf_bp);
-		if (error || !args->trans)
+		xfs_trans_bhold(args->trans, leaf_bp);
+		error = xfs_defer_finish(&args->trans);
+		xfs_trans_bhold_release(args->trans, leaf_bp);
+		if (error) {
+			xfs_trans_brelse(args->trans, leaf_bp);
 			return error;
+		}
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-- 
2.7.4

