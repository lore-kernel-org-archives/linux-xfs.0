Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C204C43461
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68BEF61419
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 08:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237331AbhD1IK2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 04:10:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50594 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237171AbhD1IKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 04:10:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S7xb8J035377
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=KKFXo4sujt3AaXUtS7xAiZK703t1SfcnASNuiJzD8ps=;
 b=BdoKtMPyE6WTxy+EMowgsVuQbZToGmDTFckoHUixBCrNm1rPcPyVLRQZLRzJka2g+hNQ
 8BZq5bWzGhrut2Rxm0YC0s+9vWWjn8EfYQk1y8LvbuPw6xeFaFjMfO4IbjUhiJsQdWpM
 RFBxHsHVDsyL4sha82kBKVGTp86bRnzbbJXgU0gMOglXcHSTjyqrRI07JQ6oiQNxCoYm
 0TXuBk24Dc+0KCkAeQUWm+l1kKyWh2PtPDUViKH2ejip5ILSBXP5eSXSQCfyvEEezMb7
 v62ia9GDgbolIJ1KTCsQIluY1HAjm48PEEX8tfAeoXs32TSkTklftXgH/RTal4EV3+h8 Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 385ahbqw9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13S80oJh196107
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:35 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by userp3030.oracle.com with ESMTP id 3848ey69y1-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 08:09:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3r57hElnNQDUax/fke/8+UyCZBeSOI6pq1hg9i11bsrFwv16kmQVwrhJbX1yp9pEK/GKdlkpJ8mNGMLPucyqvI4W5h4IVNk2dbPwnUBNfvQvdVnrhSzvoOM2gtlIwa5QwnjQFLfgPXo9HHURShk1fyBkmVcIG1Pv0YEGg6qLIxKGPuffsIRMLTeRTzcHnX7kIxKqzCU1E/Ch0j2454PdAseT9JtWF6AfKhexRecnswnkP/QEqTUAPjhRotVusWRwsAfh0C/kuy6ZUf+iMni5ggtyEODVpOGRAjLjeQ1KEHvr++sp3qm3jhFF6WLMXqYf5JSSuOSB9A8mZuCAp8F6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKFXo4sujt3AaXUtS7xAiZK703t1SfcnASNuiJzD8ps=;
 b=e83x/PXRaz25tjOO6WTQ8dbmRMu6aJ8wgzu/B6YR/6MsO2mJIL8ERrA3/5l53PymqtjvGsmJdzdO3GdzEG2nqtNoT08gtPI/pNNYqAAtmxS8iua5bKo3somH9TDB89RaUVWF7F2DvDsT4/R7kWetUDhyjGvCEDWXK7ivsL738kHzQzThs3Li0GJyRThDZV1+Fhmqnb0iqQZ8OOOnbBon/VQ6wjUssMZXgLJKFNzr0GQd0lYEFOlG+CJL8l02g5BYvkTwAGvELip256pvu8CamJE8obAXn6eqn0zrI6WboJeB2xOcyOn5X5On7WqxJkHsNRTulOJ8WReAVR1XDFdj4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKFXo4sujt3AaXUtS7xAiZK703t1SfcnASNuiJzD8ps=;
 b=engdTKfPHnvkpK14Y77N+RwD2ipkeknu7rfUGj865Lkaa65UCnrK6vlcDNtUtuBDIixl9ZOlN2++PK4Rkn1D0nFEiwzRJ8yEpyTAI1YXtv64XVnKZN1eEhRq3+x+1xkTV8wsFId4xyV1pXKf9R75ro/MdTIioKyBfpLU/Z3rNKQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB4086.namprd10.prod.outlook.com (2603:10b6:a03:129::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 28 Apr
 2021 08:09:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Wed, 28 Apr 2021
 08:09:32 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v18 04/11] xfs: Add helper xfs_attr_set_fmt
Date:   Wed, 28 Apr 2021 01:09:12 -0700
Message-Id: <20210428080919.20331-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210428080919.20331-1-allison.henderson@oracle.com>
References: <20210428080919.20331-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:a03:74::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:74::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Wed, 28 Apr 2021 08:09:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1391308b-316d-44be-4954-08d90a1cf460
X-MS-TrafficTypeDiagnostic: BYAPR10MB4086:
X-Microsoft-Antispam-PRVS: <BYAPR10MB408642618A07663264EE9CB195409@BYAPR10MB4086.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p/4dJoyJ9jEvnevmeXug6a4QiaPAE+rIk7n9u0qaAts4xWRoUMXv8vUf4jgwD7gMZob/jSs3BufXftLNkaAYQNxfvDP4dgr1wBihyIqsDFpUVL7yl3oZv67esoTwD41twTnu7X5iYrDtFTEeAwQ22sheyY/BmgMG2jSzwUtjetfcn8q4pn1DMKYa6ESC+VyNmsS04zy3Yh8rAMKscWDzBGUGIhzLu5oxgxG3BPh3UX6d6DHLGxFPVx3qwn8t+X6oD33uM0GXkXRtgpCYvTaxVAOI3+yAbm9I1XQkG+6mc5CcR6BYARZPwsooubPblZFM9mqYuW5lzq5MD9EYEXoONrti11/zLNBwyTtkv6opDmE56QR5TE5djOuYWujvG5Fum+kF12l5WRg8lo1Uvj3QsEpuYKyTUGd6jkhLqNdmz2Idlbu/jgHvPe5y70RK9ZorljxWQ8jQ7KFVHtHcVg1dsD/zMx1Np7O43TxSSM5PbDnrXwhMYsHCAi7r5bLEQlGwDcvWvOjjjFHO3gRxbzQIK8Tbfl6pQO/pagCK9EZU8RPqsAglZ1GwekHRi7zhEUMhS7c8xYkV0D9SbKjJ9rk5FgB21e5SVW5s9984zYv3pyIojx+AlCtqAY1Y2BvoHU400kiayBFIWJPWzV0bS2U3j+Me7LalIwATWCQein0NPxVXN6uvkDGXl/xJ6qo6OHRx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(396003)(346002)(83380400001)(8936002)(52116002)(6506007)(66946007)(36756003)(316002)(66476007)(26005)(956004)(6916009)(6486002)(2616005)(6666004)(6512007)(8676002)(478600001)(2906002)(86362001)(1076003)(5660300002)(16526019)(66556008)(186003)(38350700002)(44832011)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QT4LZRZ12o4VqQgrBpS1dDeHu3yRBcoY6hcxv+BIv6TvddB52SOXjX9iJ47Q?=
 =?us-ascii?Q?DnbtwdlfkqV7fHA+QrR688Lbbbl8GD/dI7HkG+XQHk0qDSqTehHaBPpeS1n0?=
 =?us-ascii?Q?kJQ67U40FjVaY0uD9KG3fV8cIFOaTcnBYXdGwWZf0nxskeqCws9p2Q7zrit3?=
 =?us-ascii?Q?OLZtaRnaABZ1FGiqmjt2YeUcDcm5fNb1UWows/r03mgwJk8ua6nfaQ+8CWNM?=
 =?us-ascii?Q?HdrWD5eKPNHchl+lUfxLEd9TGSOcEPedo9lL6DXGKfDaDXw0LOekliGTPYCS?=
 =?us-ascii?Q?NdZEyVf5vrwAQ2x3DaCXNRrBasi34uhBlV3RIRwvGx1AeieqnhH8Uua2HqDi?=
 =?us-ascii?Q?KKLDVMBBn2ytEIQDhCvHnTmMcEDgXo7WIMKQvsb+GhdhSKE5KBnkdw1UlGFM?=
 =?us-ascii?Q?/S/op+bA8ak126bxmcovKDYmF9VO6aQ52mrqeQV9QkgqZ1Zm7pSWfWZ2fNMe?=
 =?us-ascii?Q?ljfTnsNxYHCRtS8ni8Z9KBQ0/+z/3IaKzU5eeOgCQ53BhwXHtHXHSClyp+uS?=
 =?us-ascii?Q?4dukXxzRgKPwx2NB9c/AhdmVn0xcKhH1huB8ETFh9tX2t7fz9hHcuVRorB3I?=
 =?us-ascii?Q?qUkJQFsVRwPFUYacuTWz3EdCRML7K6/mKJzz9IgdKTdwRMOGZvsRG8ilu73m?=
 =?us-ascii?Q?4hdfj5mTfWpikIQ+UxpMXhNpsXhcxc3M7mDnxZsdmVMYMY0RGt6T1q7SlBGH?=
 =?us-ascii?Q?1M2OquDG3SVgUcc3IbkzNCYtKHruR/JcvJ5jegVZvXAAUN2rOekeHA+ATeMj?=
 =?us-ascii?Q?LbpaWwjaRIToRdZARBsUyd+1Ipa2W/4OxpRFTC35EcivPqPWz2JOWIuUOHxv?=
 =?us-ascii?Q?b9Ht9m+IsNmIGsxf88eaTGRyvczcXWe+sNtfHzLnoqy4rlKCHzNOrTHedbNz?=
 =?us-ascii?Q?Fo1uU6GlaLB2FomfTvlHEfnzSGACsSMkIHEGy/EIen6VG2tSNW2GkV7aqsuq?=
 =?us-ascii?Q?g0E4ESDueGdKDDwxua8k3kKr26Oz9knp93QVEikwGdiQx6ctcKY3PVFa3zg+?=
 =?us-ascii?Q?6Sk2ZI/kH6+CxQpTjjTPgj2I+0A/j9ShX+8pC56MRgtpWVb10XNE1lYfAXt2?=
 =?us-ascii?Q?Py+epcFVd7T0wEfElmp94cRTBRMhntgHXZjK4LTmP6Zp+xgEaxorxtjst3sv?=
 =?us-ascii?Q?U0++bGkMRvdhb09EHSwYlTT7kKIRD5zkW2QJjAZC/1ynM+1YRAgphpED8D1q?=
 =?us-ascii?Q?sfGkbV6QrDA9T3MYv+AstOxstewqjys1B6YLzRAQQnN93cQinntB6sOStVQ4?=
 =?us-ascii?Q?TMKUJhITkcpbBHpVpa1G3m6LSn7IP1Gk93Ap5UxF0RA3O8VAXOHtDIxvoOnB?=
 =?us-ascii?Q?EkGaXxJiBOdpJftBN97qOe+K?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1391308b-316d-44be-4954-08d90a1cf460
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:09:32.6551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uGnQUyXdRVCy8q8VcYgHneS4OLThrYXJGjbH5qaYHdHCaRBWYT8IYrIGOZP8O5rmXtqjarCk76M4gLAuKayD05PNwY4QdYV1D/K2vnKDNF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
X-Proofpoint-GUID: jdtp5IM41q732JfUOt4vR6Ri0yx7P9zD
X-Proofpoint-ORIG-GUID: jdtp5IM41q732JfUOt4vR6Ri0yx7P9zD
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_set_fmt.  This will help
isolate the code that will require state management from the portions
that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
no further action is needed.  It returns -EAGAIN when shortform has been
transformed to leaf, and the calling function should proceed the set the
attr in leaf form.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 79 ++++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 32133a0..1a618a2 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -236,6 +236,48 @@ xfs_attr_is_shortform(
 		ip->i_afp->if_nextents == 0);
 }
 
+STATIC int
+xfs_attr_set_fmt(
+	struct xfs_da_args	*args)
+{
+	struct xfs_buf          *leaf_bp = NULL;
+	struct xfs_inode	*dp = args->dp;
+	int			error2, error = 0;
+
+	/*
+	 * Try to add the attr to the attribute list in the inode.
+	 */
+	error = xfs_attr_try_sf_addname(dp, args);
+	if (error != -ENOSPC) {
+		error2 = xfs_trans_commit(args->trans);
+		args->trans = NULL;
+		return error ? error : error2;
+	}
+
+	/*
+	 * It won't fit in the shortform, transform to a leaf block.
+	 * GROT: another possible req'mt for a double-split btree op.
+	 */
+	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+	if (error)
+		return error;
+
+	/*
+	 * Prevent the leaf buffer from being unlocked so that a
+	 * concurrent AIL push cannot grab the half-baked leaf buffer
+	 * and run into problems with the write verifier.
+	 */
+	xfs_trans_bhold(args->trans, leaf_bp);
+	error = xfs_defer_finish(&args->trans);
+	xfs_trans_bhold_release(args->trans, leaf_bp);
+	if (error) {
+		xfs_trans_brelse(args->trans, leaf_bp);
+		return error;
+	}
+
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  */
@@ -244,8 +286,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
-	int			error2, error = 0;
+	int			error;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -254,36 +295,9 @@ xfs_attr_set_args(
 	 * again.
 	 */
 	if (xfs_attr_is_shortform(dp)) {
-		/*
-		 * Try to add the attr to the attribute list in the inode.
-		 */
-		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC) {
-			error2 = xfs_trans_commit(args->trans);
-			args->trans = NULL;
-			return error ? error : error2;
-		}
-
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
-		if (error)
-			return error;
-
-		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf buffer
-		 * and run into problems with the write verifier.
-		 */
-		xfs_trans_bhold(args->trans, leaf_bp);
-		error = xfs_defer_finish(&args->trans);
-		xfs_trans_bhold_release(args->trans, leaf_bp);
-		if (error) {
-			xfs_trans_brelse(args->trans, leaf_bp);
+		error = xfs_attr_set_fmt(args);
+		if (error != -EAGAIN)
 			return error;
-		}
 	}
 
 	if (xfs_attr_is_leaf(dp)) {
@@ -317,8 +331,7 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	error = xfs_attr_node_addname(args);
-	return error;
+	return xfs_attr_node_addname(args);
 }
 
 /*
-- 
2.7.4

