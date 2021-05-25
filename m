Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80620C47088
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69C4E61279
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 19:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhEYT5G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 15:57:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52442 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbhEYT5C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 15:57:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJnFUX162078
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/0kr+2CVZ0D/nnuFADMy7+oShmgC1zOjuTk0MG5Scb4=;
 b=Af5KxUw0W/ZlP8iFZeOc941FKm91Vwi/ZFgBMTeVzrfki0zWrrZVFdASdiszyvAnNHzW
 8BLZvdNSdHUYbSVXxfuTbivRW5kaT8uF8+AKhLgduoRkx90wWKYCROuLUKHQ+y0CIDRJ
 PMlUNFgn0cwOBOPmglqaKxBlZwOOyJKZeZdoK39n2F+Gfg95kj8DSFXEbWR4Q8V6bgAq
 iwQdu7Ptan497mPpsH4Yr+MxI3AG+Use4nyLXi4YaitBCgl91cF1u4fJ0cHYg18ce+50
 15egf6z6VkxtNyc9flP5VuiYBmevazR9oOzWdlJ3KYitto61KOW3LeLq4CqPnwk02GRQ RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38rne42qcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PJtH9h101715
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:30 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3030.oracle.com with ESMTP id 38pq2uhp2u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 19:55:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RO3R1D1vjWqmoTCXL9UJ01VFAX8NDrxaL3XwnydH835tHa4w2PohWUjGRR8Fkyp6HFLpRq0vCDDT0eXRQqfvzUt5aWRd7/AxVnMIDK0cO7cSYTkMYubHshnpapnGI7oVwHkKqplgDq4EjApdO+X5K8DICpd7Tw1bjCCXDR0ioaqe5nagK1o0slEbt4+KxdXKspskEP138fLe50hR9CHDE831Bo3D84BfVQ3cN09aPC4natmBCM9NHPv7u+8ekir7NPAt6W6U/aQI4axT8wuDs+FKZjn0zJs+treLPiykBllbg4YHyUU1/o1g/lV/JC84/XCcctuUOb2UDZnQq0dvcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0kr+2CVZ0D/nnuFADMy7+oShmgC1zOjuTk0MG5Scb4=;
 b=QPm7QePC95cyP7i2fEHBPuhbNF6Uc4p26AlsROMgAAoKKLyqMGXKT9U3zP2NSzITUYw7Tg20h4EAaC5K/wZ4aBAgLTGagVLINSewFAUOQ+9rgphzXIrHhqS62h5sGs+Jqf1eKRMAMfdvHNwGodqEuZ+fLu1YhWwMxqvc1z8r8nYc9q/0vjQmVZyvWFZLj693SksOdVdYEbZYz+RDFk4q7/yYrsi6fDr4FpDeGuHjr6wI3LBDN9I42Wlt+S0E/75f8MjP0pa2mCstMRjfGHCjBChx339uSLHpvSb+SU2j2OcmWUHaFiYTP9jvBQBKE7w4T1+7T4SxsuTtayj/KJoa6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0kr+2CVZ0D/nnuFADMy7+oShmgC1zOjuTk0MG5Scb4=;
 b=injmqmW73Ef/sYBdWHulgqdOyC2f9mUwCO3Qvxx9Z5ji9QQQbtFRVc8yJgYEniGv/qEtjeIpUGHPre0NTsrDNqjb9JL/hqUYa8uFO3YE0y9iPQNX6wJDsL1QVYhJx4r1q2XRHt7MOR4kchGwguf7xizJyMSwghuchG3/4iH9zM8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4478.namprd10.prod.outlook.com (2603:10b6:a03:2d4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 19:55:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 19:55:28 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v19 06/14] xfs: Hoist xfs_attr_node_addname
Date:   Tue, 25 May 2021 12:54:56 -0700
Message-Id: <20210525195504.7332-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210525195504.7332-1-allison.henderson@oracle.com>
References: <20210525195504.7332-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.210.54) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Tue, 25 May 2021 19:55:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f2e00ed-32c5-4928-42b7-08d91fb70b90
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4478:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4478269B9327B0411D5ADCA095259@SJ0PR10MB4478.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CZIj3R5P9Uqp9wjoN1tqch6zcOzPg5UayuEIi647fLKLk0DD3MCv+mmXtraqTpk425b0WMmzgxxhYlEx1tek1uJXAkwaIykdZ9OoJtTOMvs2x3MIGNOGRS3/WBVvRL4QaOxDKxGR+Ie8Kc2ZCNs1WM5Xl2vsQZCpDILbcsvFoci+dROtBXqMteWBuDTBXAK1A0ZgjlNWRYausOS379nb9SV/sdS7FD7V8UlhCteWHb/8nH2psPF0WVME0vPT3gLjJr4wcV7pL/HeIbmBviF4oAXuzD4Ns7Pce/QgOFaeoiJo29vZMv9DkKEkbvjUUWbCGSYq6WBu4VUIBmx2UOTTvYjaRVSsPWN3OJOjzJUv2J9d/S9zP4CbW0seTseuO/5aTLieHqLeOd2oZYwl7/5blBrufiDrn6ugX93MA61oqsqYNvlh2EqSLNrlOn6e5sEkh43ogksRu0QIl4pixjs22DpWjdum9KpSXczVrHDvrcRanVrJFvVT31t1naOMmoOdSyeAIWEzJEDjvkoSzZz3sQ+666QoVqqo+Hwp0gko4Z+pEnt+yVdIYTFmFUbRumZs+pmbU86HNAeKtiBXYUDqs0iWT/Q7pBPz2wVv2StWxzTMjSHVend/SvqtmT70Cx0gqrkhAB8YwUBzQ5+RrYAu1kUx0WPdZbi/IDrIHtElct+VyOfWWtkP9MgjPOQIYEr8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(396003)(366004)(5660300002)(66556008)(66476007)(83380400001)(38350700002)(38100700002)(6666004)(66946007)(6916009)(36756003)(316002)(6506007)(86362001)(52116002)(2906002)(8676002)(2616005)(6512007)(1076003)(26005)(956004)(6486002)(8936002)(478600001)(44832011)(186003)(16526019)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?B082XEAscNkh8ib6VjriKDyteQI75Ndmrlu4jpMpaoMDPJc2vumkHkmBdI53?=
 =?us-ascii?Q?sLN4hw3wesQzapfcvcjFV4QV3JC8Zx9n2PWO5Vn0H/iJs9vkHMbtmH3DOZU6?=
 =?us-ascii?Q?BR3lFQuFduAcDU9u6I93+lqGrlnT3OjryHdPo8N7zPWLGXG5EjSxA8sWpqE0?=
 =?us-ascii?Q?KsVex09VV1eiNX7etY6XBsO08qF34G0fN+m80UB1j3dzbm30qbZGhfB93XDN?=
 =?us-ascii?Q?UBmNpx0eESkNmIyV/IeesrPQ6cqkBfmySeXi3mPMU20zxDQpaOvNvmCQHK0x?=
 =?us-ascii?Q?Cmp6d2/BQ5Fuhe/nPY7YKP3XS4U81vHrZZ6gtU08UDfhQm762977wH68fRgf?=
 =?us-ascii?Q?VwEKnDxqGlTs2wHbT3KhXkNyR9H8Vmw4O3MhFuob45HVI3g3w4D1s5ccyzUg?=
 =?us-ascii?Q?aETAlpNANAnxaA2c974Ra735iAiry5dLXi27LrH/m4ySe7lMbxB3FmDTwGjl?=
 =?us-ascii?Q?0+iEO/kCxDj+tRr5cabgwKa8jWhgYUlC1MVNs45UIZQ/dURI9XisOTNGTzgC?=
 =?us-ascii?Q?BVoa0wht7A4mUiZW/vhjg3LAh31qJJ92hSr1QrGnzLbmL0W6T0BmUKf0fD87?=
 =?us-ascii?Q?K9hMQL2u/TsoWwHL3Z2l0bFFFTlMopu/V57HRJZR/NRBJgwRBA0oy/XdMeCX?=
 =?us-ascii?Q?Rf2sfMVXvo+sxuv+eNgBsuz4U25xLeFbTf3QoQY11cagbNJjhykkXqsxJtdy?=
 =?us-ascii?Q?siB9vQncU1LINOREMcxhVOdTombIx4Y6O4PENn/vuyGaZifUXjdl4HyiF0pY?=
 =?us-ascii?Q?jhodFXLNVIDLwizCFcjpwVT4tT2sXZAO1mwCIDdZd++/0uX1fexHw8lxZF3S?=
 =?us-ascii?Q?RdCbAVLv8LBku6GlblpERwsMD8BysIjPiVgrl7sWAyz+jQJyJ8Q+r3xNAzsu?=
 =?us-ascii?Q?V5VQantj+y8yakKj4sFvUY232o2olo8mkbZIC7qlWFvDwTyb+upimGntrhMz?=
 =?us-ascii?Q?PbJ69fGttlErpmYQKyJZjHg7dg02BQK+vSj5MwiyqGJGV6NG/IX9kC67t9Mu?=
 =?us-ascii?Q?7CdmMZty5OWRipfclU1YAyu25V93+jaUiPMrNbMXzqY7bIYl6LCQTkkTplBt?=
 =?us-ascii?Q?ZXIRZwu/43u408pYGo43A5lNb2snZRfQt+/gQY0hitdlIIloi2giehYBvRav?=
 =?us-ascii?Q?s7EQBglBmd87VHUx73NBqFuiU2KtZ6qY/ZMIN0dD5SnesMy0wiQkvobWpWg4?=
 =?us-ascii?Q?0PH9aKfVR20qfFb7FZZ5MtkLW3eDDZFQXMRnyuTZTCFDivnhZnEw5qYGzYYi?=
 =?us-ascii?Q?7plUJcKlypUaMSG+wf5sIuXHgs19/r+M7jB9lqvMqrXAH0je1GpGFUv5MRUd?=
 =?us-ascii?Q?DHu4HkjbSA/0VZQR/k9MLJ16?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f2e00ed-32c5-4928-42b7-08d91fb70b90
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 19:55:28.4459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2VxAX2/C7Ok7OwR4FEj5Ph2y4giRnR0kmBQEB5ebGBxVO58BIRaocDcrQp/jSIAg0EIcVYvm5aq4NqvzllSek2nW9dDLoooCg87P8OH8oE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4478
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250122
X-Proofpoint-ORIG-GUID: 0B19QxPVRGM2kTBGVfaQ5bhhPot1BnG-
X-Proofpoint-GUID: 0B19QxPVRGM2kTBGVfaQ5bhhPot1BnG-
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250121
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
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 159 ++++++++++++++++++++++-------------------------
 1 file changed, 75 insertions(+), 84 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5f56b05..b35c742 100644
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
@@ -290,8 +291,8 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_da_state     *state;
-	int			error;
+	struct xfs_da_state     *state = NULL;
+	int			error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -342,7 +343,75 @@ xfs_attr_set_args(
 			return error;
 		error = xfs_attr_node_addname(args, state);
 	} while (error == -EAGAIN);
+	if (error)
+		return error;
 
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
+
+	error = xfs_attr_node_addname_clear_incomplete(args);
+out:
 	return error;
 }
 
@@ -968,7 +1037,7 @@ xfs_attr_node_addname(
 {
 	struct xfs_da_state_blk	*blk;
 	struct xfs_inode	*dp;
-	int			retval, error;
+	int			error;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -976,8 +1045,8 @@ xfs_attr_node_addname(
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
-	retval = xfs_attr3_leaf_add(blk->bp, state->args);
-	if (retval == -ENOSPC) {
+	error = xfs_attr3_leaf_add(blk->bp, state->args);
+	if (error == -ENOSPC) {
 		if (state->path.active == 1) {
 			/*
 			 * Its really a single leaf node, but it had
@@ -1023,88 +1092,10 @@ xfs_attr_node_addname(
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
-	if (error)
-		goto out;
-	retval = 0;
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

