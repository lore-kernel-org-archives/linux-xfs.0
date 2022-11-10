Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DEDC43219
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiKJVGA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiKJVF4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:05:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967BAC14
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:05:55 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL0b6b006965
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=zSzUbHHsPqry1PuI+/BSOAzzFUmgMyvNAVExvYdxrRc=;
 b=Uh1pFcEmm2olj0WE2sEVUnkYdhx1sd3ichu3PLKtBo/UUszRB6kg8eivFWf8kdYkCNSW
 7i5eiGIXVE8JqF6K6CSL2xcdJg2buqOGew50Of8v6BTxw4f9FMN2loAONbLq5xXHUqnd
 r1H8AItDrTBruGiJjcGnmJQ2zzAun4zmgIgCBR1zuCAQL4E05aSfG0Px/+KO35ZaDDlA
 tPqzySMVktlNQiOdJlR8lzX5N4JboOdOhdt1PzYKs4XQDQzkppHY/okY6AAPSJ/3hF8Q
 lS99/D9UrNLuHpzYnFgr0142mvY5EwtrSanyg6GiRvd2YiNonz28MSRJIhMqznjtdQX6 ZQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8u5r12w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKjqq2009659
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq5harr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TT/uN26oiV6cZiWVoFOd1uF7OfAiBJWIEwZ24r8JSHvPQDYujg68M8exUdm1ijUGjLco1Oyy7db3ssItOV3XV7fwE1TBYCcEfkfPvg3H/9aDfkZam49JDkwImMvIWeX2HApoFNTv8MZt3hc8Tb3z8DBhuMSkPbnatm/2XQbGwVgNeFiwauFtm70iUXDSfDp3i9Xy9CbfVouE0U9cvlIlW4CnsWljcTGvsc1j8R095cieRyoYaVtcfiCfuxuYHFfsO/wyP+BexVIbcR0z1coWgh7dmgYZtpuAKuArN9ZVrPykscKGk02kwAtppMDeEhHeH3+mEQPrinYbBC1UwvE6qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zSzUbHHsPqry1PuI+/BSOAzzFUmgMyvNAVExvYdxrRc=;
 b=X7y6+xJr+UX5NlsDfRihd7n1xirOmvNvmWsPpT7Id1/eTkE1K1WqSHMUKr7OuGOfW6Xb+8IIx8EOFOBgjWbqTGtEtVZMcV/ZebxAZxwEIJwLovn2rchpCKpFIW6aRTEnGZylWMRlz8t+lQbGmn030HKBAue0myMQtDU29bjAwxiqgSbLrpfcQzmvajvLSYL7XbnZVAHn4umHnOpuvBqBNTR50RPy4BaApGl5hREt/o/QzA/W378UrT3qTylIjkuOUhAUqMudPb1HBEZdmE3GrEGi/dYYBSCxQ2y9QfqsvLa8fpfZy5Mh3YwlbOi3eWaU7fankPApl7uMG2JUxbYI5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSzUbHHsPqry1PuI+/BSOAzzFUmgMyvNAVExvYdxrRc=;
 b=ZxjopDbwqKpjCYPoyNKQzy0BWzj04G7xvq50zUuIi/RpfP7kUV2D3kptIPbuTmWTUtRQ63FqhsWQQTUKrcwJR7RaXQtsVoJ2RHere2yV50Pl9bPjXv6u20dGXsMQAspKc8384J1qOWswAyJjqyrE8PtpFun/9Qe4zUDEBpMUxjI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH8PR10MB6527.namprd10.prod.outlook.com (2603:10b6:510:229::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 21:05:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:33 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 03/25] xfsprogs: Increase XFS_DEFER_OPS_NR_INODES to 5
Date:   Thu, 10 Nov 2022 14:05:05 -0700
Message-Id: <20221110210527.56628-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0069.namprd08.prod.outlook.com
 (2603:10b6:a03:117::46) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH8PR10MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 02a76e88-4fd6-4da6-de8b-08dac35f4ed0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CfgQPSIQQJ+JCn6hy0CT2+qPK3MJecZlW5kh3liu1puKrB3rnpfGPpKsEavL8FTvEMT616JNj+2BQp0ZdL1eqKjsXsFqvIw1I+9cYlaJ9yBtD/QWCg1gB8rDEPC3wFwPf9x/+p3MxlFQewgpbSwU6zc52nfCgEV1I2Zxahb3G1EqtNKhHBKWbZkCoyiEiPsQboBz27MlIX2ruSHXv8Udm6znYYk1VKuKYy5iD1VN/1gGylX6omx2bSRYl5UdI9GsVb5XLs5dazueom6PZ/vRr2QdoZhl1XYE83ZXwLIrX+aGk46Y3wXWmccqXMkhcyRRJgvVN+UCHJcwd2GJbxwuukXB4MKvyITGulzoH8s4j+6+9/uKJntvsp0fGyJBJRNnN+oTSIwu7BjJuNtWT8Q2JEGtup/OG5SQcTh7F4bjUghLXHSuQWSU2T+JudBccVbndbHbf4ceFKrKPFTwRcwH9M4TI4ibhiY1LgL1IBhSaHM79kiIXZ219Uglk0TOeHCWIyffB7ZvfTdozoklfuEW2LMXo2PYL4ExgDvTV9oX4DK+0uKYFC7JOS7JwRrIz1S+iO9TjT3wjlFDeA5OcULCjxL4j4mrYgvdp0jX0mmvGhOEEhksVVMxjx2P4YLlauka16dj3rkiYjTQyJUma714uNfhEooHj4B/1Tz9vgFg+whd/sekz4/VcfHXdFFmQfPg6BlZS9MsASPdwwdFhB4cRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(1076003)(186003)(83380400001)(2616005)(478600001)(6486002)(6506007)(9686003)(26005)(6512007)(6666004)(86362001)(38100700002)(2906002)(66946007)(66556008)(66476007)(8676002)(41300700001)(8936002)(6916009)(5660300002)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d5rstqwDAnGrJOnHNUon4VHTxF1WobMs6HMctbDngYNSNtODkmNhCWuRD7jR?=
 =?us-ascii?Q?Tdr+v7FqEs1hT0aj/ET4usYWbnbjho5KfV1qK1AbipKoCxKEGe3qF0ukbroY?=
 =?us-ascii?Q?15Fp8sc1ELH01w7QAbgJ2YvuKi3Qowg9Qd8Ye8iMMrFvKgS0vnwk/YrZZtgC?=
 =?us-ascii?Q?c/UgGeFp0PeeOfAZU8mhmqGeUWM7BZXo+/ribdJbkPta2gW7BfiSRPl+l6Ru?=
 =?us-ascii?Q?jbN+6HqBds8uU1AUvEruqPwURF2Akus6qe9uKOIIEdOhLKqMIYPdMLHaTMNb?=
 =?us-ascii?Q?lCxtwazdxJkvISrAPUVrxk7obpkoG/MWPbxOf+GhZmOHL3zjaHseyf4ViysP?=
 =?us-ascii?Q?KBSW54ttvXtLvm53yirn3oOC20WE8ne75Wz4CfGt1Tcdxp0BqA6LVoauGieH?=
 =?us-ascii?Q?Rni+V5XW6lFCSEJGlDSr1MweVf10Vfx8I9FaAtfzBVP0iqkp2yP78dtVP73e?=
 =?us-ascii?Q?2NbSCmpL/I7bK5815fbRbmO1Gep2xIpPIuluhtwk8+uHkDwrc0w3fBI+fqhl?=
 =?us-ascii?Q?gJqgytH43tMPZ1GR09fJQ89RyXmkdhtVEzGm4aLOEbpfgXMPWL+QuCh+LzIE?=
 =?us-ascii?Q?TemmqKDOfgUW1DGfuVje4TvOQphcPJCtozVqnPwfeOl9qE6nkQssVqYXgc8Z?=
 =?us-ascii?Q?RvVnOegcg9tVhPG8tY83KsQLOznOKrdroa9f4yJi/FxR0HfnfHCEbZ7Lwiej?=
 =?us-ascii?Q?+1ZrW2LdCAQgZ9Zkg2BxOQcfINn92mcvEQI2RBlPiQqHUMjm+0Q00MxHJORw?=
 =?us-ascii?Q?J0q3C7GvJrCUkzejns6c9jxt6vliVR8H05jXhM4yo4rdF242jVneijVR1VDi?=
 =?us-ascii?Q?OZaj06zGb7vaTTyLx8tKX8RZF0RdNJTEArqb0zVt0k2sGWb8VbChupg8ZL/L?=
 =?us-ascii?Q?w2s9vW/ziZfYBFdoP2u7LK+C/Sasc+1Zj9jWle9HJHBMjfLcD1PbVj4+DEHG?=
 =?us-ascii?Q?lQxiaIjB3LcVrK8orfj+p1V5NO4BiMiR0Q16BnhCA45+wxho4eASxQIXPv6D?=
 =?us-ascii?Q?HmhMCDhEwhduHNfGm0C5qcSSRgH1lq5Wva2K4A2JMWH2+96WS+XwjNWOdail?=
 =?us-ascii?Q?FDA+vl64ieDO0tq6eeDDGJtIXdEawaGIV7rnEXjK+DCf8Vjqxc2D1knYtMQs?=
 =?us-ascii?Q?qhcjeOUlTm8w1SKFkUPxi0Xg6BkEteUduyH0aoWoa9Yks1CtNNyGcCQHDuqO?=
 =?us-ascii?Q?xpaCqys1EbfbjhNOB2TuY6T0zEmlQSH5B0Vu0vPPFA7FBO981N4ln5Szv7TR?=
 =?us-ascii?Q?pQT37RSjij1JAq9DRvlowWFeJpKecx1bGcGSn2qDlH7dvZW+pp37fwnil16k?=
 =?us-ascii?Q?4s6Br15Q5F4SGYPDTLFvjFOzIXU+XJPvcWkYnghFM28Ep+NP+bUwQA7OJvv/?=
 =?us-ascii?Q?pvHdaJFqiz27gkJfDEYD+n15X/TGyjwJCrOd/GBnEJSCkOeF9m05J0+DPtpD?=
 =?us-ascii?Q?l7n7sGsP3UwFAErJf1+l8MDZOQh8ZjxFy/GLesT1sFKMcjCRquNHKyanBky/?=
 =?us-ascii?Q?d+QQ0gPGdiZ6K2fRWwi4JObZhQnNFCpxt6fU+jnV98Z7oc7KQ17S8iCsASrR?=
 =?us-ascii?Q?DQgRwyqMjZkoNNAif9GbxLqr7t8aJDuDG/ofrBjrfcmYSsENY15eUJOEXqYH?=
 =?us-ascii?Q?qQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a76e88-4fd6-4da6-de8b-08dac35f4ed0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:33.9060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YF2rRdwgkkGGrOMLZi1AGHDRGzfsBYdS5cYtC6p6WiSmdaXZW78YXJYyey8ywyIuN/Yde8rgzB6V0iX3nf2xPakPNJhcBfOLj9ou4fe1uc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6527
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-ORIG-GUID: S7wP4x7sT8YH_yOH7Ua0OSZoIU25LbvG
X-Proofpoint-GUID: S7wP4x7sT8YH_yOH7Ua0OSZoIU25LbvG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: e9dc6a1e293b7e3843cd3868603801a1af2704c3

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 libxfs/libxfs_priv.h |  1 +
 libxfs/xfs_defer.c   | 28 ++++++++++++++++++++++++++--
 libxfs/xfs_defer.h   |  8 +++++++-
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ad920cd9b6dd..6fd7ce42d3b6 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -477,6 +477,7 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 	__mode = __mode; /* no set-but-unused warning */	\
 })
 #define xfs_lock_two_inodes(ip0,mode0,ip1,mode1)	((void) 0)
+#define xfs_lock_inodes(ips,num_ips,mode)		((void) 0)
 
 /* space allocation */
 #define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index c4f0269d613d..415fcaf56e35 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -815,13 +815,37 @@ xfs_defer_ops_continue(
 	struct xfs_trans		*tp,
 	struct xfs_defer_resources	*dres)
 {
-	unsigned int			i;
+	unsigned int			i, j;
+	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
+	struct xfs_inode		*temp;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		/*
+		 * Renames with parent pointer updates can lock up to 5 inodes,
+		 * sorted by their inode number.  So we need to make sure they
+		 * are relocked in the same way.
+		 */
+		memset(sips, 0, sizeof(sips));
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++)
+			sips[i] = dfc->dfc_held.dr_ip[i];
+
+		/* Bubble sort of at most 5 inodes */
+		for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
+			for (j = 1; j < dfc->dfc_held.dr_inos; j++) {
+				if (sips[j]->i_ino < sips[j-1]->i_ino) {
+					temp = sips[j];
+					sips[j] = sips[j-1];
+					sips[j-1] = temp;
+				}
+			}
+		}
+
+		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos, XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 114a3a4930a3..fdf6941f8f4d 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */
-- 
2.25.1

