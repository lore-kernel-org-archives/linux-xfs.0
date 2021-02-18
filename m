Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9CBBC433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79E6664EB8
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 18:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbhBRSr4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 13:47:56 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45896 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbhBRQyv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 11:54:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGng84069662
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=l6b16MAQbxMsiJhEoTskf+iZK7WIOMVBXVOUwYmPxVo=;
 b=URiO8OarmpqSqrRrdg2PTbQbM2Fq9rVX0QzdbqvNiQB65jkIk00FZ0VZIaJN5nrlzhyw
 b0PlSUeqvvCyv1ARinPJ2JEFQGJD4cul+yMIM1FTrEnEPfvy3wBIOWZZaOCPDC44xcEZ
 dPvdGCZP4SsMMDKjYi2T4Pof6IcORj27YjKHcFpvc1XJA/4/Dkn/6NNN1JfXNvnpdsJE
 cnpfSSWONhAJTesLJ9nuCT3fNHQCdQjVwtl3gk2odawyFfL1KrZVa+hcoFmhYkDVaccY
 aPaBCQIgVot+HKdFmwswwGU2rJS8P58mlNG00eXZd6p8FOfEQ0XCXJPeoFl4Vov6x4az wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ae4pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11IGoG3T155234
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 36prp1ruuc-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 18 Feb 2021 16:54:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/93qc4YX5GSFXYgh/fX+YnIDB851zxvOHXNKQz6GA4Diyvwh77vqDCAWZsvVQsFmN4hh/6lECJKAJcLaVI65ksMbsbHTegfsPDqmQDh3yqM+/CuVSn1VoC00bvU0kWjlGbgj/iyLEyvboAD1cmgc7CTTkJ2OviHBo7fXzmkq637fxFBSzpyrGlaw8MM12K84cyz8rRt1sVjxJO9KOgsukiYBd+a2ZML/vuQZnGrrCFTLQyZ6ZC64a8Gbl1nPKd8NGJgA3HzCS3r6v5D8BWACWj1dY6gVx/DD270jSi3m7FKIq6UvQTxgNUNAnSDefwJuW0uSJQfUHCve6PoP+D1xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6b16MAQbxMsiJhEoTskf+iZK7WIOMVBXVOUwYmPxVo=;
 b=QagbiP6Ec7AS/xvZXcYqdCD2TRBq9Y50ypHwlAENEEqoJpFSpELx6MPs7aQR8Ezwtusr+BbWhxoqY78Nrdb8oLxJA+UccC6Fk48mLdOCbCA06tPtUhaldZeLVfRyKUURQWpOyQriDIPHnBuBmbTBh60RK7dVViHihvZcg5QHGpwduc5FlVM782Po6WFf+5mnQlji1shAT5kjT8aoUsi6llVyHHAESLYK1xgiswjPtvs3hIPIfQ1+fGk+dkpn/J+vqHwi9HVxdjrZ5WYZWLOOrYjLkqft3XibQQF3OUL5h6SspKhDzzLWP+aZ4FuV38tw7q51z2VgtTHrnxEeq8FHPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6b16MAQbxMsiJhEoTskf+iZK7WIOMVBXVOUwYmPxVo=;
 b=VscIFKZEF01BBYM0g/pv+Dni2te98fwSiX3EPnr5vmGBrf8IX7x/GpjLhzyvZv+tS1AZCpDU8HpM6vsTcSiBwws0L+TUXNsqKsZpm6EJTDawxZR6i3E5YkShOMjF5n7D5o+FZ7rsMbmFm6h3p/FibmSLoXUTi9BKdmBPCZtSoEM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3381.namprd10.prod.outlook.com (2603:10b6:a03:15b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 16:54:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 16:54:07 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v15 09/22] xfs: Hoist xfs_attr_leaf_addname
Date:   Thu, 18 Feb 2021 09:53:35 -0700
Message-Id: <20210218165348.4754-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218165348.4754-1-allison.henderson@oracle.com>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 16:54:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87d9bced-45c7-4d2a-1cce-08d8d42dce18
X-MS-TrafficTypeDiagnostic: BYAPR10MB3381:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3381163C1DDCCC7A10B33DD095859@BYAPR10MB3381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TtI/M73zZWYZHzXXzKJNp+2VbouN4MfDR8XUlqzq+myEL1EioktepBeGAO2zTwlZHN6ywZ5UrjZ1hD1ACrDmmIEPBfSMn23PGEBiarxCL+6EpZndXBglsTkiRTbp6ogI0UGfOQpRtu/06nqgvrOUB9KuuHhy08cdjzRyzt4l88wbGFN0pRTMVuJtZ5Q0SPlOs4E/3qRpDEd1ljN9r2/dwEJAVLX74ILN7kChraA9Khp8SA5DpONqdn5PCu4MZYOSVweGcJyzd41rfibfwYQ9t6dtIQgxKQeCyRCEBbpe4/xUY5Os/qojNev848SUfTvOvgxkmiXW0v2YwQEsUwHdSysANimMU5RsOU3IG4NR+PA/UmSCA8PghMVp/YpO8uOrTg2pu3bJMWLD6vEO5suWnr3YjLFqQP9dgclrWgAonx0gdMZQnfW5+oBcV2R6fKmUmCv6ClV9rnyE9HEHEBSZAHpMJ6qPyvEpb39eBaeqtl6FuLchTvBFunMfqYrPAtSWfG+IwE/JHgEcJaZrQEadtP33YPZcqD4SVKNpXtmtb2PdGeVy0i6hWbYqfYEfsgpK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(186003)(26005)(1076003)(16526019)(66556008)(8936002)(69590400012)(36756003)(6512007)(66946007)(6916009)(6666004)(86362001)(478600001)(52116002)(5660300002)(66476007)(8676002)(2616005)(2906002)(83380400001)(316002)(956004)(6506007)(44832011)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nvR7/9r+uFbEalwk5VXgbPXUqOWnHpcIKtXI+mcT9IjugSF2ZZ8WRbvnHYfI?=
 =?us-ascii?Q?NXikqBv4cCBNRGon4fqDUnTCgT6ArjpvJyGyC2Lv1KHKt8Ao9lTih9IKSjBU?=
 =?us-ascii?Q?cgQjNzxAZf7tVpQLiHCQppP7HFdhqYyo4IFIRhzpc8NLmwgLJa+mHJSq0ABA?=
 =?us-ascii?Q?zGl6729j2apE28ACUi3mXd3B9B+PQkm0lxeacZTUeaRCz7NrcVGgJYjQgfDc?=
 =?us-ascii?Q?Nk5Wrzne8bOIq6LsCdJdJfLixv2mGMXsCKaet1LrludPbX8bm7hRAzQzzwQV?=
 =?us-ascii?Q?9i3Tpa/YyD6NwBx1x2TC/Ov2F3bUli1SFyzd31/X7yKKGBqxbMxlMnH94Lug?=
 =?us-ascii?Q?zmVGC48Y+rbp4F4hDfCpJUc/nMSa03+DQPK1OIB7aRg3A9SWMt5HHQm/3Kei?=
 =?us-ascii?Q?nyNZhEw7HCNmWfB3ouI6OC1YLGjzszbwUE3J/RQcDOYy+rynksV25Z3K6pcR?=
 =?us-ascii?Q?lGXlqmXZr9bxUTWt/oeEic7gZXJ4ngKE1kZEkcYYtwWuYD3RxAGEzYR+CoBW?=
 =?us-ascii?Q?cYRCMxrJgRxo/TixnJeimXUIvA4lULy83aWqJjh/lHk6GSDho1VhzvstZmAo?=
 =?us-ascii?Q?ACjqxZLIBDKy8JOJSy++MDO3tSA+evB5mjgAsy6/AxhvBe5YCnUu8XduUaEj?=
 =?us-ascii?Q?DyZ/Qs4YGSOhm+Dxd/JD3Qo86Wgj9A5OsmhwlzFMRfEyVoUBMvjdZGckpMiS?=
 =?us-ascii?Q?n09qys0q9H9QKqOdGr9/xZgx+wuBqkLaEP/EcAcr8FMNky6cp36S7gVh+UKm?=
 =?us-ascii?Q?E8N6LPVaGGhWbpeY+1js7jn3Rec+gluA1nIjOp1xFR5wEKdZNCP660kFVK8l?=
 =?us-ascii?Q?3y+9he4uW4snP3YnsYdrcmqwKrMXo/+pAKl0gZUDc9niWBcwTxKX0vrrjIO9?=
 =?us-ascii?Q?d42fLx3si3bIduXxmxrRNM6iRhgoy7Y/ZXvFubDS8HPEie9DA3eFKKwZ/dSl?=
 =?us-ascii?Q?O1B8hJ/n5rKqQe6MiYlLhXWeQNgfdwnBBUwze216lQryyQMqxeWqLCzaiSzj?=
 =?us-ascii?Q?ElIn0YsxVEa5Wc4UX1WR1MBESAwZF17Bcvww4lvtA1xAO/IB7j9Qh4exFTGT?=
 =?us-ascii?Q?K/CP3iOaYs3YNK+T6ABLdExO6GDayBv6J1c7GhYIvvobWKSeQZdUAbcblNNG?=
 =?us-ascii?Q?p5o64X/1JHGWu1suEOkJxmt/ZZbqC8xgfHCCbVG1zUXbj/2Hs2HEGdY6ORBa?=
 =?us-ascii?Q?/2vGaBIpU6ZjmX9N0GYf1Ab+cE4T8VFDxoxeQpjpNteuDUpsxdUotxUxSnyS?=
 =?us-ascii?Q?OeDOvM2oWkrCYPGo2rsJanYNx88MIK1DW5pkHnqJ11C9aMEkNtAAKdxzLdOB?=
 =?us-ascii?Q?mMSJ0ia0kr2FAcLAZvPQNe3N?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d9bced-45c7-4d2a-1cce-08d8d42dce18
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 16:54:07.0642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kUjY7HVxmU2nGRKT80dh2wlJKLwcyCvIbJHDFDCane6kYnjAd9KyvRwnffeeDDwXwvwsVoxj2/n8EaavO5jsO++L+ROc+uBpYUiFSC67J3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch hoists xfs_attr_leaf_addname into the calling function.  The
goal being to get all the code that will require state management into
the same scope. This isn't particuarly asetheic right away, but it is a
preliminary step to to manageing the state machine code.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
 1 file changed, 96 insertions(+), 113 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 19a532a..bfd4466 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -44,9 +44,9 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  * Internal routines when attribute list is one block.
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
+STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -269,8 +269,9 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		*bp = NULL;
 	struct xfs_da_state     *state = NULL;
-	int			error = 0;
+	int			forkoff, error = 0;
 	int			retval = 0;
 
 	/*
@@ -286,10 +287,101 @@ xfs_attr_set_args(
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_addname(args);
-		if (error != -ENOSPC)
+		error = xfs_attr_leaf_try_add(args, bp);
+		if (error == -ENOSPC)
+			goto node;
+		else if (error)
+			return error;
+
+		/*
+		 * Commit the transaction that added the attr name so that
+		 * later routines can manage their own transactions.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			return error;
+
+		/*
+		 * If there was an out-of-line value, allocate the blocks we
+		 * identified for its storage and copy the value.  This is done
+		 * after we create the attribute so that we don't overflow the
+		 * maximum size of a transaction and/or hit a deadlock.
+		 */
+		if (args->rmtblkno > 0) {
+			error = xfs_attr_rmtval_set(args);
+			if (error)
+				return error;
+		}
+
+		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+			/*
+			 * Added a "remote" value, just clear the incomplete
+			 *flag.
+			 */
+			if (args->rmtblkno > 0)
+				error = xfs_attr3_leaf_clearflag(args);
+
+			return error;
+		}
+
+		/*
+		 * If this is an atomic rename operation, we must "flip" the
+		 * incomplete flags on the "new" and "old" attribute/value pairs
+		 * so that one disappears and one appears atomically.  Then we
+		 * must remove the "old" attribute/value pair.
+		 *
+		 * In a separate transaction, set the incomplete flag on the
+		 * "old" attr and clear the incomplete flag on the "new" attr.
+		 */
+
+		error = xfs_attr3_leaf_flipflags(args);
+		if (error)
+			return error;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			return error;
+
+		/*
+		 * Dismantle the "old" attribute/value pair by removing a
+		 * "remote" value (if it exists).
+		 */
+		xfs_attr_restore_rmt_blk(args);
+
+		if (args->rmtblkno) {
+			error = xfs_attr_rmtval_invalidate(args);
+			if (error)
+				return error;
+
+			error = xfs_attr_rmtval_remove(args);
+			if (error)
+				return error;
+		}
+
+		/*
+		 * Read in the block containing the "old" attr, then remove the
+		 * "old" attr from that block (neat, huh!)
+		 */
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
+					   &bp);
+		if (error)
 			return error;
 
+		xfs_attr3_leaf_remove(bp, args);
+
+		/*
+		 * If the result is small enough, shrink it all into the inode.
+		 */
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff)
+			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
+			/* bp is gone due to xfs_da_shrink_inode */
+
+		return error;
+node:
 		/*
 		 * Promote the attribute list to the Btree format.
 		 */
@@ -731,115 +823,6 @@ xfs_attr_leaf_try_add(
 	return retval;
 }
 
-
-/*
- * Add a name to the leaf attribute list structure
- *
- * This leaf block cannot have a "remote" value, we only call this routine
- * if bmap_one_block() says there is only one block (ie: no remote blks).
- */
-STATIC int
-xfs_attr_leaf_addname(
-	struct xfs_da_args	*args)
-{
-	int			error, forkoff;
-	struct xfs_buf		*bp = NULL;
-	struct xfs_inode	*dp = args->dp;
-
-	trace_xfs_attr_leaf_addname(args);
-
-	error = xfs_attr_leaf_try_add(args, bp);
-	if (error)
-		return error;
-
-	/*
-	 * Commit the transaction that added the attr name so that
-	 * later routines can manage their own transactions.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		return error;
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
-
-		return error;
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
-
-	error = xfs_attr3_leaf_flipflags(args);
-	if (error)
-		return error;
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-	if (error)
-		return error;
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
-	/*
-	 * Read in the block containing the "old" attr, then remove the "old"
-	 * attr from that block (neat, huh!)
-	 */
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
-				   &bp);
-	if (error)
-		return error;
-
-	xfs_attr3_leaf_remove(bp, args);
-
-	/*
-	 * If the result is small enough, shrink it all into the inode.
-	 */
-	forkoff = xfs_attr_shortform_allfit(bp, dp);
-	if (forkoff)
-		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
-		/* bp is gone due to xfs_da_shrink_inode */
-
-	return error;
-}
-
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
-- 
2.7.4

