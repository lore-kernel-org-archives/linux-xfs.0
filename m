Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA584C43462
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE1E3611AB
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241681AbhDPJVc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:21:32 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49778 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241670AbhDPJV3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:21:29 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G99mks042539
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Y47eQKRhCOhDODdrjaSeS4zBFErfK9OK/HDU2O0mncg=;
 b=jpaS7SkzejuWB2eEKVIKDru4/bqFrul1GhjCU6DKwt5p47udkNQSF12i7zS1fU8+QwWJ
 ZdQuCBUuuXUjsuqiiNCi8UUPzUmYyivRvaGQHoxLAxudipA62TeZPoeQBH45y/8oCdzR
 70brrJWbGvQF4Nx8gudruWnimWH1NZw5+GJWYy0MedTpXlNihaTCxXsBGnB9lnJipJrp
 QAoH36W4qrGsEmF+hbHQH3krDfnxRswA2DKLasV6isFjmLy64Gf9l17aUJNGy83itFYd
 PQ8e6h6188znRfSBorR57i0Tev045zKTegQx9Qy+cmt46XelNfp1u6YnXzDEa6ZW/jF7 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37u1hbrpfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXT5077147
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 37uny2cegt-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:21:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmtX1hARRHobCCLeM7a2mPKfFHXIrnsKC5wJHi5AvT18uHgxB+NctraokcB8y+j+MEgM+KtZ/agMXlP8j9CiN8NjDZYOCShJkbKgBb7IClhWXq89fUt+W1Aw1jVh4ilO9i/mz/WUezgpUlffQhtXm+X/19aCJZpvVEVhxgd709wxzEk9B+ubLbD6e7lNyqtgoF6Sp+/VBQZefsKevgqNej0Um82qm8qXcFPESv310bppXyjdRcfHaJo1ihXIt9JZAgqgdhiYNt5q2xRNkjFtjw8RDZ2gAY6bz8L5BnNqGYIHesPSJPXwST2o6mhDk/kkarvE70h9+ckrZRJfN7ZoIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y47eQKRhCOhDODdrjaSeS4zBFErfK9OK/HDU2O0mncg=;
 b=S8k3C3aOSUcU3NNhcCDrS/JSIj3DBXPc6WiilD38xdGGUgQIclcMeroRKgLQY6KR0pLL4zSAM2JYPcJQEH/ARAA1Mxf2IbzPb1XalZZWbgZuN03DJgUjcDCu+kSai7ROT/1bzU3JJIbb1C4LXu30LMu0xUxFYIvVf7/CvklNfeiRqd2wdsw4tdfczkz10vaPKuOKqq4cyrsqwYELME9Vf/Y8E35Kbg5DcN6EokECDpdIH5Y2EX8p7HhoUkw8C6GwvIVc5d4mz+5LKwZ9BLyVlaFWRK0LHhgITTWDt2McBdmfSsaKz9/H3rPW4+Pt+X1TdA2D1irMmbSp5+yRlUUd7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y47eQKRhCOhDODdrjaSeS4zBFErfK9OK/HDU2O0mncg=;
 b=gb0TNhbusCIUdznNR5DtUOpZaWjDy7K2ybdKhwo8ULKw7NOM3iM5ccssV600n8slSLOMzDcQtolV3Wtvk3Zg8psLWE4PYZwrnMwb1YLXjvPL5Hv1M7u23tKxCtUEQzOXNGEuiO+060JelKOS57kL6BwbFxuThBN3/5BMzQDh40U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2567.namprd10.prod.outlook.com (2603:10b6:a02:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 16 Apr
 2021 09:21:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:21:00 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 07/11] xfs: Hoist xfs_attr_node_addname
Date:   Fri, 16 Apr 2021 02:20:41 -0700
Message-Id: <20210416092045.2215-8-allison.henderson@oracle.com>
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
Received: from localhost.localdomain (67.1.222.141) by BY5PR17CA0029.namprd17.prod.outlook.com (2603:10b6:a03:1b8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:20:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4160763b-bfac-4d1a-aa96-08d900b8f2ee
X-MS-TrafficTypeDiagnostic: BYAPR10MB2567:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2567DDED33BDA4D309F0EDBD954C9@BYAPR10MB2567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tnHF8QdfW51ALA91grrpQxfHx+JP9cHXtv08r/dQeblDFMSPAhVZVABBWD1cJ+EIgV0D3GOt9qQKcQN5NbFIuvotZoZPQDd03A4Nb3GbTP/1UuhZdsQfuT4brVF3k9k9ARSPLBznewPBh5JHH65Ne76do1ihxWJJpia0iPFO793NaI2A2NEGu40krhhqJkfM2wZFrQdCaURB3S4z9ARN2i75pFbf1tOhOCK58hhHItPVDFRWmbHPWX5M5aNsEMDMuMSksf+y9IU9QaRV4Ds51PjXSW+eG0WTiieApdeUSO+hJ9IglUe2QnfD8q0XYSodj2LjsGlzn99EBR+CVKKqz9eNkfHjj2qgEwfTaStBijWM8F4VuT9LrWvOHBcc08msXOQJyTq7Wu/OXx96JDzijN7RqyZMzY9RqoFxk9kAdzB6/P52PjEHs3vQO8gnsTEz517k0qh7bOgxH/Urqtya8VkXJB2Gh9DDI0U5Pk4VjBMJe5LfH9ZKE8vatnE8d+KtJ1zlJZDhKbQK2wt/el5OOnNT2GAqq/h1IFeXsQBxzLNdf639+BERR/kG8DuDqt/H8fr85aciQS5GxH4MTvO1d6RPJ5iIAgF9kEz8a84JuKI3p0DVkCzrsL9eWBhGB2ehFItGWzDoy7rVyjGb0a8VFQV5hxUQzvdq1YwStLkS0PYcUYYT6nDqtnvuseOagrPy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(396003)(376002)(16526019)(8676002)(36756003)(44832011)(8936002)(38350700002)(52116002)(6666004)(69590400012)(83380400001)(2616005)(86362001)(66556008)(26005)(6512007)(6486002)(316002)(186003)(2906002)(1076003)(38100700002)(6506007)(66476007)(6916009)(5660300002)(956004)(508600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QkqJjVHP/GnWSI+HOhz5oRyyifxXF62XJFx6g7jEws7wJ03ktem657zP/nuu?=
 =?us-ascii?Q?fY5kxwiV16IZpoCdPOB0yw4YkDiz8l0a0WEVvn9K8ty0BOuWe1fDRDe1zVs7?=
 =?us-ascii?Q?MI6g/dCqSbjP2U0KmZhB5TlTrgb900UZtjmtp1eF+wl2DBe5oETWlLpCpGYE?=
 =?us-ascii?Q?OVM1MCNWqJSsoW+WBrJGdMAX9hwsmo74mXfcazCluYxs/c7V8/IlDjhAcCh7?=
 =?us-ascii?Q?eGwqAZ3ODgAf7OWFpwsbC1rHULQ0jfthRGifJr736+jvCSBek9wyPXschFwv?=
 =?us-ascii?Q?Bcuc5SIGieD5HTwwND1CKCPpT+M0l3VpERMWFclnhCwgLZWGFeNGgOtlSiTg?=
 =?us-ascii?Q?4G5BG/6QKPVY76sOjcJ8xViAgJS1a0nVbr+eaOzfuXYhZIOFt3IeW+473lYu?=
 =?us-ascii?Q?7+r/zXQyLQtzssFXBBrRlBIjXp3ohdkPCAy+idVg7CcHWbNdAUMXRP2o4F4w?=
 =?us-ascii?Q?4/K0RV2mOQ7b8LBl1GWpVcvKz5B/xV+Xi3Gws6ur0rQjZFSycH2/Odwj9Gil?=
 =?us-ascii?Q?61VgjZHuoOd7w+/9NbDFxiEebUUom+lenRy4ODp7cVy/xqhuciAOW4L4/t2T?=
 =?us-ascii?Q?dOIonBUONof7SQMrQXLns2k3/On+yARx7G/9+OpTsAl+ymQx4Mi9fnh+azCN?=
 =?us-ascii?Q?OYJFCJ4/ZIp8vrJU3vXXJU4Tf2n60D9EGkZB0PRzHakyHZ9hqFV627sGX/vj?=
 =?us-ascii?Q?PYb3vqQTbCOOLootToZCV5ZRRKGcMsWCUaQw3oSp3ZiOvgMCyBT9iQbDJl2C?=
 =?us-ascii?Q?y87nHPvACMiRXMz6i5wksVARp8PIHzlvD5bQ5xQ0b7B1zgqvs8pOUMSlSAFF?=
 =?us-ascii?Q?x6jMJ9l9oc4Cjjjlhp3Twn4FBpr+RLz9iQDgpOccuzVmwBBoFvFpJXyWe0YS?=
 =?us-ascii?Q?10jC5GDPcvfVPeat9pil2G/pzi2Va+zGGnX/pcA3aBzAH1GXS6bxGkek4iMg?=
 =?us-ascii?Q?BxLujTDBN/S046pI5PXtZ00OUKDiT0qkk5xU9Uex6gs7pB3xjiEACTTyrDrt?=
 =?us-ascii?Q?Aksof+gzEbEpK9a6h+VgDE+qwLgivEG9bAEQjyAVRc47wEnbTUCT5sK9Yr0E?=
 =?us-ascii?Q?b77V3aB3o2JFKd5o5eqW4HpQ+OkexCO1SLiC6r5ifX1yOwrUMQU8YHK86FkT?=
 =?us-ascii?Q?0rS6EPui4thf+cF7N1ydlNYTVijbn21Zw/kfRyiS3dxhPWcm3hZsfszZqaq+?=
 =?us-ascii?Q?JwzCrmDXs+atNAzeB5DC5M8DXnUndG+FtSVq1M2N9P7sDtoELKtiTj3Fs6FY?=
 =?us-ascii?Q?yDq3MjaS+vMARhtBoTq1NRSa75P+vkA5ztZ3a2FoUBrjDa9uIJrufQUw0aqB?=
 =?us-ascii?Q?bNhfERCGGLlXAaERtmOI7Q4H?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4160763b-bfac-4d1a-aa96-08d900b8f2ee
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:21:00.0709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxRX1kZNjqZ1RE1LCZL5IabSBy75kAiEpC835IQllJ2NCphj7xdikDOWT/cfNoIMMYv/dV7c0U+RfhAr6G9XTY/iCfX2EpFN1RohXpaFchk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2567
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-GUID: qL70anPgNxdTBmQ7v6xc3k8b5GlqfjFi
X-Proofpoint-ORIG-GUID: qL70anPgNxdTBmQ7v6xc3k8b5GlqfjFi
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists the later half of xfs_attr_node_addname into
the calling function.  We do this because it is this area that
will need the most state management, and we want to keep such
code in the same scope as much as possible

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 157 +++++++++++++++++++++++------------------------
 1 file changed, 76 insertions(+), 81 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 16159f6..80212d2 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -52,6 +52,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
  * Internal routines when attribute list is more than one block.
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
+STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
 STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
 				 struct xfs_da_state *state);
 STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
@@ -270,8 +271,8 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_da_state     *state;
-	int			error;
+	struct xfs_da_state     *state = NULL;
+	int			error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -322,8 +323,77 @@ xfs_attr_set_args(
 			return error;
 		error = xfs_attr_node_addname(args, state);
 	} while (error == -EAGAIN);
+	if (error)
+		return error;
+
+	/*
+	 * Commit the leaf addition or btree split and start the next
+	 * trans in the chain.
+	 */
+	error = xfs_trans_roll_inode(&args->trans, dp);
+	if (error)
+		goto out;
+
+	/*
+	 * If there was an out-of-line value, allocate the blocks we
+	 * identified for its storage and copy the value.  This is done
+	 * after we create the attribute so that we don't overflow the
+	 * maximum size of a transaction and/or hit a deadlock.
+	 */
+	if (args->rmtblkno > 0) {
+		error = xfs_attr_rmtval_set(args);
+		if (error)
+			return error;
+	}
+
+	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+		/*
+		 * Added a "remote" value, just clear the incomplete flag.
+		 */
+		if (args->rmtblkno > 0)
+			error = xfs_attr3_leaf_clearflag(args);
+		goto out;
+	}
+
+	/*
+	 * If this is an atomic rename operation, we must "flip" the incomplete
+	 * flags on the "new" and "old" attribute/value pairs so that one
+	 * disappears and one appears atomically.  Then we must remove the "old"
+	 * attribute/value pair.
+	 *
+	 * In a separate transaction, set the incomplete flag on the "old" attr
+	 * and clear the incomplete flag on the "new" attr.
+	 */
+	error = xfs_attr3_leaf_flipflags(args);
+	if (error)
+		goto out;
+	/*
+	 * Commit the flag value change and start the next trans in series
+	 */
+	error = xfs_trans_roll_inode(&args->trans, args->dp);
+	if (error)
+		goto out;
+
+	/*
+	 * Dismantle the "old" attribute/value pair by removing a "remote" value
+	 * (if it exists).
+	 */
+	xfs_attr_restore_rmt_blk(args);
+
+	if (args->rmtblkno) {
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
+
+		error = xfs_attr_rmtval_remove(args);
+		if (error)
+			return error;
+	}
 
+	error = xfs_attr_node_addname_clear_incomplete(args);
+out:
 	return error;
+
 }
 
 /*
@@ -957,7 +1027,7 @@ xfs_attr_node_addname(
 {
 	struct xfs_da_state_blk	*blk;
 	struct xfs_inode	*dp;
-	int			retval, error;
+	int			error;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -965,8 +1035,8 @@ xfs_attr_node_addname(
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
-	retval = xfs_attr3_leaf_add(blk->bp, state->args);
-	if (retval == -ENOSPC) {
+	error = xfs_attr3_leaf_add(blk->bp, state->args);
+	if (error == -ENOSPC) {
 		if (state->path.active == 1) {
 			/*
 			 * Its really a single leaf node, but it had
@@ -1012,85 +1082,10 @@ xfs_attr_node_addname(
 		xfs_da3_fixhashpath(state, &state->path);
 	}
 
-	/*
-	 * Kill the state structure, we're done with it and need to
-	 * allow the buffers to come back later.
-	 */
-	xfs_da_state_free(state);
-	state = NULL;
-
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
-
-	/*
-	 * If there was an out-of-line value, allocate the blocks we
-	 * identified for its storage and copy the value.  This is done
-	 * after we create the attribute so that we don't overflow the
-	 * maximum size of a transaction and/or hit a deadlock.
-	 */
-	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
-		if (error)
-			return error;
-	}
-
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
-		/*
-		 * Added a "remote" value, just clear the incomplete flag.
-		 */
-		if (args->rmtblkno > 0)
-			error = xfs_attr3_leaf_clearflag(args);
-		retval = error;
-		goto out;
-	}
-
-	/*
-	 * If this is an atomic rename operation, we must "flip" the incomplete
-	 * flags on the "new" and "old" attribute/value pairs so that one
-	 * disappears and one appears atomically.  Then we must remove the "old"
-	 * attribute/value pair.
-	 *
-	 * In a separate transaction, set the incomplete flag on the "old" attr
-	 * and clear the incomplete flag on the "new" attr.
-	 */
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		goto out;
-	/*
-	 * Commit the flag value change and start the next trans in series
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		goto out;
-
-	/*
-	 * Dismantle the "old" attribute/value pair by removing a "remote" value
-	 * (if it exists).
-	 */
-	xfs_attr_restore_rmt_blk(args);
-
-	if (args->rmtblkno) {
-		error = xfs_attr_rmtval_invalidate(args);
-		if (error)
-			return error;
-
-		error = xfs_attr_rmtval_remove(args);
-		if (error)
-			return error;
-	}
-
-	error = xfs_attr_node_addname_clear_incomplete(args);
 out:
 	if (state)
 		xfs_da_state_free(state);
-	if (error)
-		return error;
-	return retval;
+	return error;
 }
 
 
-- 
2.7.4

