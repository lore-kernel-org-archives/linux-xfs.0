Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455F0C43446
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A1C361A4F
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhCZAcK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:32:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56930 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbhCZAbz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0OvcA057503
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=IHf2NOtiIJbxuz/62hLPHgQ/JnLB4MFXPIxOExIJ1Yg=;
 b=bvV47Xn0Rx/JRq3OWTOcSLPAqfmvMStrFIe0m7QQqHdskxqTcPAGT/tsop/n0l5A+1JP
 CUV7VF6jHhQ8KO1P4Rx6CKlqiMCEICbLHPfBFPy17SfSIcuRg5FleCqA+ySEzUdLoCB9
 vUyl7VvTQEyJId7YEX1UX/KIWh8SQqMkX66urHW7XnXN6r3pgmrz6tYGcjAcX50l3XsD
 HTLtV+Yo7GtsvHyV/7zq7DX6l4w9ItZgkuJhPNiiWSdROOon3mKsEIB4ITV261+8UWx+
 v8eaLXI4c3kLUDcDXR9B8/GgoO2HrLTc1UKmsNiaNv9m4GVAR3aHBxzOZN/HzKwB3BnZ EQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37h13e8h4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PKkX155633
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by userp3030.oracle.com with ESMTP id 37h13x047t-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeD6da0nAvDbav/4dt+Y80UYOTLX6aUsgkshBbRpBCTS0D1ia5XF+AvL0ODotBJJHMkZv/XYvH4TB1K4gI6SpT7u2jGX27V36nCMc2ViTrzbJp/q9vOzIusTFjoSL/YERYdaEuskYYfMlepzlNb4oT70NvYHFfqa9ERgxBrOUVloemtAyH7sWQ4/pTYF2DKLN6Dc9v1ZtiyJIiVvoFZQQhVZDFmVk/fJVcmo9xFGDOus5R57w11VRL/hSsIKaT/xtj6UJo6xxAjm1BRGANIsObIgHTBYPPErBSz1oo/ia4zVYY6gMXtn0OH4HzWUmSQ/eJ8imjG54yWUsyi4XenX4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHf2NOtiIJbxuz/62hLPHgQ/JnLB4MFXPIxOExIJ1Yg=;
 b=CEPxo3Mj7jdFb9ZHRcGfmm4z0au8Nenw0SodcCYkTaA2IK+VKd9kKvbZ1g/kPOBH6i/TaEmvBG+b0lyc0iIsFHrSLsXw3bGvD4e0KROtnmWOrLAKjueIhejhYi9u3ejDIRxZwvhi2/2HtXbX+meDX5G7YSq/w1XU5U1UNoDeLdcyijqP6Z2NqKAmZ7jh2LohC/AQiJoFaNteJHIhRxQa3xWHiXDL3qeW0X9WMrfoe2rtA8pA3X+p2KcPCrn8f2fFwmuetm6FJAhqll5Iwr1zeVKJkD/nKqbTcg25zLgvpIvBBGP22NNt/sh60mfZCjjAiZeIsKnNNi0UkRmK88O3XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHf2NOtiIJbxuz/62hLPHgQ/JnLB4MFXPIxOExIJ1Yg=;
 b=hy5lN29kIMQv+E4ib5gRugtpF/juIg6+XawALJCPRVFDbWsSqvCHJIyrFs70xhoWisG/U8MKG+ZySIxsSw33iS08WEQKoGywy/MqHvLX/94PKGbm033gk96WGpJIUByXw1EgGarXOiLyc8Ki5srO1cYBnucuz9BFuh/5h0mamrI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3924.namprd10.prod.outlook.com (2603:10b6:a03:1b3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Fri, 26 Mar
 2021 00:31:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:50 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 21/28] xfsprogs: Add helper xfs_attr_set_fmt
Date:   Thu, 25 Mar 2021 17:31:24 -0700
Message-Id: <20210326003131.32642-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ef95c94-1456-48f1-62fb-08d8efee8bba
X-MS-TrafficTypeDiagnostic: BY5PR10MB3924:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3924C4BFAB6B8D70E426028795619@BY5PR10MB3924.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z6nK3sHMBboMsD7RZX8FlDAw4mKS66fEEYXNobHKEsCyTNQmH0cMbEW19EwmExdTPBiteCJ6a1nMtW8Yb6x/PB7Kk3Si6H+pYaoE6obcJYrTVsHdsUVBfh9DXkm4A5TcaOtnPGXf9OeS7oi2PBHrtUpGkg3HV4GfEeJ2uwhIjeS4sMd4vLgiCJ4uFm/hzH/5b4K8x7aYS9JUng4HopDi7U+xmRuYV+N7vXPhOMkGk/AKgkuMW0rslz/aHxEZ7Z8mamwr+9q26YdgkuW/XpdcUHaNhE+DU06EAzXXzpE4Mf9kYwuaUnlSObgDQ7NsQUvmoB+3/rPaV27tGdYZP3tn86hCruNkwCYrKTk31e7YLRlVEjUPQklzu2TtBhIKSsdtR7elOqBI9dACIUF++02xpiOPKSd1XuGNoxxcZe4vgL37+YBUsnAu7llyY95syYdV7WZZ+QwcSHllW8fvusBrinVLr/sV0yuO4tkH3zu+KLiy+382GrVL49ZEcBxVkhs1hpE5LfmwA34RdElcyRKlGeUzSDSc1Vt0FaOJr2oZ/jSVdZmmQWtcVdZcomnpmOn11uxx1RhBVq+zh/g3yFyANgadT2e5DeNMd31wgMh7nkEnCP3cYhBUjOfn220JZJ26QrC7R2i4xozc8HTm8bYq5IgyjLB4m3eGw1NGAeIS1Puta4mOnVNae96seMdnMVsa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(396003)(366004)(6512007)(956004)(52116002)(316002)(83380400001)(8676002)(2616005)(8936002)(6506007)(6486002)(1076003)(38100700001)(26005)(186003)(66476007)(69590400012)(44832011)(86362001)(66946007)(66556008)(5660300002)(6666004)(36756003)(478600001)(16526019)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3DOsH9NhP0trC4QnTcyow3LI00EfxqXHZsC9XgooZo4klbGUlsn+OBAH2d7W?=
 =?us-ascii?Q?kOHpGVgvMXaZ1+1pCw2v8U3l9gFTE401IQXf5/vVk8vmBm6n6g/xm+4J+XJT?=
 =?us-ascii?Q?9Kga4ECWjU3hk96DZW/8gAYQvgdQ6z+YjPa4lqUieiCG3LlohmiM1mf9ToH8?=
 =?us-ascii?Q?vdgoQsajv+28o2cSHO/ZrhxwHt/EVjiak2bK6d2gTpcgXQVUrkt7Gnn9rMm0?=
 =?us-ascii?Q?7QqDfWZfO3OO+N7SuQJ0ESBrsIbwi16PiDPi/v7PUeYAHjvbzg+O265wqwSl?=
 =?us-ascii?Q?NWNt8oGJu/m007mTTvXrjgdNV6HJoAzjaa4V9ewgNUkj+aYwAs9TkynmRXdW?=
 =?us-ascii?Q?CsIcd8cKUe6JYo57pxooDv1SBtj41JEZcZQE4D78Zxj429qTx6xDYHWAGpCW?=
 =?us-ascii?Q?L2VGgpXzZBMjbXsxkLXVOC81swiiBGiyJfVt/7rtlAqhszsMVRorLtucbB4M?=
 =?us-ascii?Q?RDv0kDxKMHGUR+I+AeZCYgBhN7UQpxp9+Q40TqwiquFAuO8wtTybXnwCdhBy?=
 =?us-ascii?Q?tMjyenYdUciJIJvVcBubYdrWxZW1FqdAQTNzUKlxtQzch3aPF1zXQtNHEQVv?=
 =?us-ascii?Q?zth/qj4XO9nUhfEyDM5LY2EmXoxZOVMg9maAGkNaYXeAMOcLQ+DuUtqvcuqI?=
 =?us-ascii?Q?Q92X8j3Lff4e7I5yRAKFX8Uz0+4d7a6XNdRiPp4i9G1GXJjhOCeaHknEBMzw?=
 =?us-ascii?Q?gJVJQ/JddBUcBWJhCr0eoXi66lkbbdXVRdjk+4Van+s6TnNsKrjgY6JzbDcY?=
 =?us-ascii?Q?FINn2WrNNqxhDuSfZ5/0iOR2yYc2OxN7Mht39mXcZ5+2P4L4CggU/Qg+zNq9?=
 =?us-ascii?Q?X++AxP6PIWXiLbNy6QzlFDkZ8UxnO1HIP5TzMbM3YdH+TijYNaWbGHZIsU+D?=
 =?us-ascii?Q?SDRdqk+q92Rt3jBlApseZbyMV6SjDlYH6+Wt7BvwJCAaTFiju/FCxwy5JxX5?=
 =?us-ascii?Q?5xHlVEeJeEBIuyflYlykUIqYp9DhfS3iRWO6/MwZy+6bkE1lapeJ+J4T/0yp?=
 =?us-ascii?Q?aSjg26KVmAlhL2EadcVyBuHfQet6ZYvpgknjRoyE63LdjkVHF+7+5shK4OTY?=
 =?us-ascii?Q?ZQDy9jjY5VaX5HlHUoxFjRuhNq+HRoVDjxWsXG1mvBUrUCGZ32k1D4ycHSbJ?=
 =?us-ascii?Q?fyyFNPusK+AAV2IzjkChpw+m2Zqvw2zlkL2zanuUhQIjOFfoLGp3UNtVR+Wv?=
 =?us-ascii?Q?ZTbrzEpWOgjraziERIe1M1UWVxZ6HMjuC+zB24mK1DtNidy9S1q+RKiYticf?=
 =?us-ascii?Q?8zY+Vu+h6vl2m/d9B0umuvJ8J8DCsyeB+YDQBPkWdNPoAKir2ZAd4YDw79wg?=
 =?us-ascii?Q?klvrTbtAKWEY+RArI4Sk4g8j?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef95c94-1456-48f1-62fb-08d8efee8bba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:49.9941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ucj+GaT8Yr6YPY21Pi4CYb4dqGBZffs7O8Rhif/CkklOl2eV3aRmvrCsFcCAISRCve679/zYD1jTONaguoM6RKk/KcFBrp/fceAjrjQltgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3924
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-ORIG-GUID: bMsEtOAT9vkXuQ-MvEWkT7C_njvVhQ9i
X-Proofpoint-GUID: bMsEtOAT9vkXuQ-MvEWkT7C_njvVhQ9i
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 45b71a4f3fd8bc8d47adcbdfd859ed736a54e66b

This patch adds a helper function xfs_attr_set_fmt.  This will help
isolate the code that will require state management from the portions
that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
no further action is needed.  It returns -EAGAIN when shortform has been
transformed to leaf, and the calling function should proceed the set the
attr in leaf form.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>

---
 libxfs/xfs_attr.c | 79 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2eca705..1db60ef 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -216,6 +216,48 @@ xfs_attr_is_shortform(
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
@@ -224,8 +266,7 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
-	int			error2, error = 0;
+	int			error;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -234,36 +275,9 @@ xfs_attr_set_args(
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
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
@@ -297,8 +311,7 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	error = xfs_attr_node_addname(args);
-	return error;
+	return xfs_attr_node_addname(args);
 }
 
 /*
-- 
2.7.4

