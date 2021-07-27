Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B69BC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E72261107
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235558AbhG0GTx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24764 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235577AbhG0GTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:48 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HBM5010846
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=rpWqdKX7FAN7lNEZ3/WcL1Fs+hjp3kaQvdLlSuyjE58=;
 b=KiCcuXWtF16NrBw1NRmXpJIp+rjngYNAzjom3WyMMIOqbemrUEHulmDCuNbznxtbhNOJ
 YuXsfH/MaRwtTfGGRn46nNc6hpS+GDo8JCbaAx7+fv48aj7Orfagm/o7TTSppLFLrdMj
 L+iYjILF9uUjCYRkU+xb58RvUsFI00pvQRNoQZWu7AkovQDyegVQppY0cLVByTNSLl0F
 ZnEPj+iIuCJCBQkBq9oouDSnlmF6kuzJtRypcsqju/bfoii1DY5qR0CL+EmM66EoqLjq
 RdpJR/+ba6KnUgVgoHq3XQ0d7+HRXZt+/pUMEg3CHtQhPL8FU2OVcvsJMsJLDH+mHgq1 bQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=rpWqdKX7FAN7lNEZ3/WcL1Fs+hjp3kaQvdLlSuyjE58=;
 b=RuWNFyBBAcAUnPDlRi5LcTEL+A9LA+owon9PUw9MIibUdBWrsF5q+wYuR0U1BQJaxmlx
 FMJfk44nE6VfsTEZMx0AYAljyDWabdfQhPEKLsVntVl0Theha6bAdnhSd+mCzAS4Ughv
 D5iZWCOoUuGgar6woRwADjQrM+KTtBg4T5u8uelGqBWmyLkNZfTK94hK2//k03j4NFRo
 GCsgKdbYOkbiZOfy4/Bmz200yyyi/1fDyBFuRplpl9v193KQwEfO3nsieyMczBm5akey
 eH2NxHNgMwjWaWDF0LukrFc8FTDk6qpibGUJP0ynIK2hZF3iQ15Ax0sEuMjTnC9dCQeT bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w0v6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6EiaB065026
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3a234uvnq3-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmgwiHLu2OxBOznbDKsYU2edd6e7j1JZ1xMiiSAL9MCIbdGUKRwVjU7fDmdJQ1Fcy38kmwdRhqsK9D+v7Iqxi5wwOeRg5C7OqzcQ3ef98EdAzW2Y4Me4623M/FBkPf3wCkcrZDVtIhMoDlukk+7HCz7V7xb6Iaq38arZQpkMsopFeXcEz2zMEBf47JcQYYJLeDfK27FAtLnt26aLyF2tfPN24B+4m1w3G/PmlHPCio7iAtLpgFTMy//sI3jUNvs68cCeDJL6zQdPS1yw429X+sPoIdYFYXlymSsqmjEP+P9xeVTT9xveTQ969kpyqEkQFagawElONkUNu+CR1nXttQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpWqdKX7FAN7lNEZ3/WcL1Fs+hjp3kaQvdLlSuyjE58=;
 b=jN0pNqMICgBGee7/FTrLZovw5CKXtpSOvCkrKY4j70oq4GA8TJiSAQomlVzi2UfV+DT+OlhmDBsMAOuhpaWLE8e2pAIRQqAGA0C2aTBatdxcZjIsJUP5Uv50x6qU4QwW9wGuDuz/p0eyHEx4biOhFkgizVE/EG/2XML5JtW7mNNKlidFBrHaAASghtVQZmLi/F5YwlHbmBlV/OaaURl/SqKmvoUT2WUXBFLAU5HJzeIHyXy/ZXtEbX19hfxGmCRG+TONruQBDjC0Okp3Ik1ssRcPu6DQuH5v1NTLornU8lgPHZvQPMDphX2nCKxuJ4qvVanQ8ppDl61QRBAXrhNX1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpWqdKX7FAN7lNEZ3/WcL1Fs+hjp3kaQvdLlSuyjE58=;
 b=BRcBR7hE++f5WOq2VFDCW+eJVHZPy40V9dd+HwTqlUDBmeU/FlzymW5l2JIdrZLhdLzf0Fl9icowwuIfcBZNsxaZ6koGXUk9SQHGOY5+YteTokfTjG07KG9ejg/stlcJa1psl95hyCuKZ4d6ZFWx3OD2NXwBPrWZTkdfFiF1fAc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3669.namprd10.prod.outlook.com (2603:10b6:a03:119::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Tue, 27 Jul
 2021 06:19:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:41 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 06/27] xfsprogs: Hoist xfs_attr_node_addname
Date:   Mon, 26 Jul 2021 23:18:43 -0700
Message-Id: <20210727061904.11084-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad2ca846-ebe7-43e3-4a01-08d950c684ec
X-MS-TrafficTypeDiagnostic: BYAPR10MB3669:
X-Microsoft-Antispam-PRVS: <BYAPR10MB366999261564367F16DC0D7095E99@BYAPR10MB3669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LsyMZ8Kk3+O6fX/W5R4vchWUUKsHBUy7YVmL/UmVzodo+n80RoyuJmnhXDu+z4VXTZhF/Y2r0n15g6VevhCz2T4y8gvKTdNfi+MLD6dXFuPVIQmTLgY5h8gRQ+S97neKIRlw3q8LgoOdW9scg4jRiom2QItVihTmE/GP+c9B8GItJYS/8D60QEKSubIyafm3mu+0DqAMJsvpDizMTcirTAG5sMNdWAL4jc4qtHBbbrELW6Yi3Eke447622JJSoyxkzjYsPB7kEytbS164D7A5R1ZNAx7JV9IMXJYDczgadAnCy8k9o13I1CfkJrQce/wjBXOysG+rI+MHg/SHE/OUqgO5oZBBP/7L8jgMSqLCrpKIc7HHZ+Mc7BJjizlguOaTszELU6hNXmeKOpmMMoO9tgvOAu/JVZ3Tj7d0bcLttcjx92yrI1Hk786VvWUGqAkmI5DLrNOXwTWN0p+F5OzHMjFYAIwTpLvHQpDfTvTZt/qpFpK+TnbwiPKSLPYNAh6L5rK8UItN2jeM4b/l3S8D/nAsyt80RUq/r0G6NOsJ4ILhOVPEqJ3Xqvl+QzG5HCGq3BXvNUXoAMDzvk8XHl6ubdSX23woDjCC8QY/p44mAfKpOkvwaSbUGgZZC/XYdCPNqbIRjhtO/0YT68Ni732lgafY53dk4BASB1tEos1RhZhieKeRohwXjjk6lkD48h2kv/iVqgk43Tfhb+ztOeS2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(44832011)(478600001)(38100700002)(38350700002)(52116002)(2906002)(6486002)(186003)(6512007)(26005)(1076003)(8936002)(8676002)(83380400001)(6506007)(5660300002)(36756003)(6916009)(86362001)(956004)(2616005)(316002)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sTJPo88cHy11dhsy3FC8jMvmBW5N8laxVu1zfvj7sBD/Y59rSICcyLSeS218?=
 =?us-ascii?Q?d29pU3Ot24xYfk4Ov6JIIaIQ8wDx3pYwOmmA9bP0lmPinVVvbimnhW9oCDBU?=
 =?us-ascii?Q?+qCX5lFLWjznuoJozVvMQvXm9xKympQSCu+viGEtd1J8Hd/dfZ3oVvF1usC7?=
 =?us-ascii?Q?y7Bs2ND6f27qNt9wvzliKTAltQIMOWQnWR5poJEl7K/icqpmfDvnpAUiwKMa?=
 =?us-ascii?Q?Ubtyive9ANfwCVu/b1C48jbnm5kWBLcRWyH58cwGwe2A8ml5eoW27TbSCS4U?=
 =?us-ascii?Q?wKD2I8ymQ0KUiVTsu0L4LajEYhma0Ls12hwu4IaqNIjqYzDVclx9t7uzcayx?=
 =?us-ascii?Q?98yoLwAHSzGtm3CgJ7qixW8XeZX6p1WMAK8naZCcl+URcKGNJW5v3R7as/do?=
 =?us-ascii?Q?tnLDVhyiXBm5Gaqb3zATjThhbyXLKCUWtRnpX9UPXSuSC1I4Q17aEY+jGfXN?=
 =?us-ascii?Q?uy2cE8igzeiD1JXxPZhvHiQP/nYDUMEn0EZ/4aKn7b/IibkPyRMwxBC/HtUc?=
 =?us-ascii?Q?ERpHqRrpvxoq6FRFK4SuYM+b5zsIXwlS6T13nuyU0G6OGPbUyzus3gR2+8r8?=
 =?us-ascii?Q?hfadlD24HYNXMjk/XRBSUCpQ7F0oRs974H2g/hiZmtYtIfQHIT2jeq430Nqc?=
 =?us-ascii?Q?yBiXoQ8NrXEhjglyp6XEtmrJa9bUY/UTcqI5aR7Lb6CQ7ReoH/li4T+bfayL?=
 =?us-ascii?Q?SgmV/c8i3sPzNC9DwzROhVZWVOlVeOVNkEdKbL0Xc4gAigGs6djJc1LjLiAS?=
 =?us-ascii?Q?bYLRmE5Ke/wQZuBIHDk1slIrknQvCXtb2nl1+IrVxkkfycxV32DagLk6iSI6?=
 =?us-ascii?Q?pi55rvTxuq18dCOnTPk2+SvMM2zBsvMbBkGzdl50Jzt0H4jVf00vrLN2koxH?=
 =?us-ascii?Q?2835QwvS2HV4ZqrqrlgIwXGiPtuFVmrsrDvGzFwCLkU43ROup/qyyboS/UNX?=
 =?us-ascii?Q?Vs0DT/s5DHXPg2iUNSMoDyrhBavjEn4+ASWQrQpgdvkpoIdCrcE0kjv6+2ud?=
 =?us-ascii?Q?5PL2LgIrI4Lf0foEuMfX+CN0gFvn5CxgkhAdFzXoLV5XmlEppIa/8bDAyN7G?=
 =?us-ascii?Q?LmBSLI0kBaLqqsWD84frifZwJjgmSk/G0MvgXQTeVfa3NDP1MK/NVNSJhCka?=
 =?us-ascii?Q?63WTCdDaKcrLpiOUoH+k6gZNcTqSSakNVywWp7tCckol3JEz9h9uacNHHkcR?=
 =?us-ascii?Q?aiUl3JvIhiAfw8H++4Gvdz+S2XvcQoOyQPOnNQpTV2diF3NZS+pKSybm7UK5?=
 =?us-ascii?Q?M6nua7MZjYVnThlHzF+6ct8ikdya3+CzWfj/HW7lZN6loSRFXMkS08rcW271?=
 =?us-ascii?Q?JySHEbVfqff5VxGCwulPNVmr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad2ca846-ebe7-43e3-4a01-08d950c684ec
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:41.5242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rkqfeg9sTo4MkXpjFv44qiVO+EjFTh2Vvg6rK/XPY1ZDIDEnDmBtxuOTKuKUQGfnaJHJqlXA+q+qpgUm127tFoOKd5Dftd62syhx8nIf3nU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: JoPCiPkTgCYZXO37heU8wWZPaVVX7h_a
X-Proofpoint-GUID: JoPCiPkTgCYZXO37heU8wWZPaVVX7h_a
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 8e7db2a154cf8889319a4d6e5f987998ed21fa1b

This patch hoists the later half of xfs_attr_node_addname into
the calling function.  We do this because it is this area that
will need the most state management, and we want to keep such
code in the same scope as much as possible

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 159 ++++++++++++++++++++++++++----------------------------
 1 file changed, 75 insertions(+), 84 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 32a51d5..16e919d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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

