Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DACC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CE5061B64
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Nov 2021 04:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhKQETb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Nov 2021 23:19:31 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36574 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233034AbhKQETZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 23:19:25 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH21HAV030389
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=MOOc+/6a4wdQnjFSXi7P0EMO4POCUWqZ4kXnAdizGy8=;
 b=1HamDhziIonnSBYTjKjYp0UKBIKB4jqlh4rbNOfmuK2ZUYzL0MxuIiqy+8a5U+6xdkWQ
 0BiMY+Np9SoqOddUMuzgbE5GGJAy8M3Tl+WByXifXHhUrw7ZX6EOuE2e5PNYZom5IULw
 uD+qR3YXzA7h6hwjhnEtQ7wfuDMrB2b+el7C1mdoi5nMTJYp8mZbfDzqMsvUWrbGaMEX
 5aJF9MWOY0rjMp81nfsYTx5NFVh9VIeoUAMkm1pkfUYA/KXxl1OTMiK1wECdLj9bWiG9
 xlMofqh9KTpr0vvtpYSy8QbI/Oi3j+OIAPm1XHAqUQDk4PPopeb9CsHL/ew0K1bvlJG8 wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhmnwx86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AH4Aehg037362
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 3ca566dagu-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Nov 2021 04:16:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WB8AZTVW6AxrMIVTRdWGlr8tWh4hIBPekz61tbQy8sg3ipGWHTYnROhV6XRoEpf1DmILFoP8yndrieXl9p8mBiYgUfRosqgApMmV+tlpRBkdwPSxQ5smo32DnYf51RPX5Pv9Tncd4YAaHCtiLDdvk1cWUFSnWQL+7qK2+WK4TQejtamhZxY6c9XuJcPGJDllTciRkdYozmuvxhxU6mA25GOvSaLqW3RKNdpJVubu/VpW8hZe9B+COk2FUGxgT5zSWJKO8CUi/OGT0fR6uSqBKPMQIomAslNl2HHLfu4h2kLCCsizy/IxSEzaXAk0JSlSyVaCgntwqIYxJHboml7HoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MOOc+/6a4wdQnjFSXi7P0EMO4POCUWqZ4kXnAdizGy8=;
 b=P9SuG6u+eoB+1S6T1F5Oh/0Ra9p8YDv7cS3CRTH8zdD2fDOAMVaKscvjjqbRAydUvcGATHUAqmU77AxmtJfGypnbrvSAjrAYSwFyvASYx3X9eu3ktvAfdKr9rCHiZrLGSlb/ChiSjt3yM+9S2mqX0bwjmDWGRdCS0qkLfpUjSboPra4IxOtoAKVn8nkvpwf4x7JOGbu8CuvJ8l2Afzhg8Z8k1UgoB5pUZ4VP/gZ8g1MPU74GCqU+2cggj8dGYKVrjeI0jJkcfgRbpFi54lQLS9GAn4k35tXvEMRZqwA6PoCJskFLYs9zJkxgRJWT/9ybqqLZlZPX6o+nvUjrk4flJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOOc+/6a4wdQnjFSXi7P0EMO4POCUWqZ4kXnAdizGy8=;
 b=zjMq8hZ5kyUFD9KTysB+UCVhtwRMxdSm3IDZrscWEAOIhqFa4hg452GtM0CxdIUlrSLMV754+jJADvOcoEhTYnRbScJdvXDaNg2YIq8P9y4g7BXeCKoxWMPIu/Fmm9OBR1t3fWDSjkDLQRTampZL9lmOrmM/emFJyAwGgpGqY4U=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4446.namprd10.prod.outlook.com (2603:10b6:a03:2d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 04:16:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 04:16:24 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v25 13/14] xfsprogs: Add helper function xfs_attr_leaf_addname
Date:   Tue, 16 Nov 2021 21:16:12 -0700
Message-Id: <20211117041613.3050252-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211117041613.3050252-1-allison.henderson@oracle.com>
References: <20211117041613.3050252-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:217::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from localhost.localdomain (67.1.243.157) by BY3PR04CA0008.namprd04.prod.outlook.com (2603:10b6:a03:217::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Wed, 17 Nov 2021 04:16:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f45288e-f671-4e1d-bc65-08d9a981045b
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4446:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4446966821BC449A009FF010959A9@SJ0PR10MB4446.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVRJ2vQT0d9vyH08pEznP/N/z7RGUZhEkbc9zf0i4BxkgoyoVnlisJW6IVqj0TF81i99xLdYLAy8ldz1nds7+l0o/WpUPAsjGIYWCV2KAuox/0N2Yozim6h9dsOA3HXE2jqlM1jYviKu+BaGe4sye1EzQ3A/zuuSi817lHhzbKUFOCkn9BkhB0XzozEKywGcfZg/HI5h3aFeVKZeNyDlD46wU8wV9cJ8Wk4osCi+t16sGIrikfhafH7okOcOVzm8y84E4hyBiIXkxtCOxNMDH55AgkTCNnXcGLQ11uTLnCJ8wahovAh27ZoaVi3PR0/OVKpsjY2eqATIj6rlPh95ANvi0ImqeTe7e/T6KWnzUbc6dTxO+laVkLhw+jlQyOka/ixkXuJvntt7epog8ul8LaBWezM/26rA7jYjmmpVAZFKHPrn70t8OyCh1xJS1jiUB/7hB9JxSn8i6AnKGkX3J4MeP3gYMgt5V5T8IxQHlYPWSVwmrNKwxuel+ZcSmDjiX3qN+bDCMbZUd/x+SYSO02tGRukOHQD2ztXxQcooxbTJ/1iEsR8Y03qQ9lYUPoeS/tcx/iczC+BwLgGmx/U7IrVmPVCLJXDlG5O34kBU6zO2QN+iwmo84X+3dIwEBp/uO4Vs8p9PmLy+h1/vtNuECZKsi5GlzoBlEpA+DmxAuver2dJgxFZi9f+epkaXnQ9k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(2906002)(956004)(2616005)(83380400001)(38350700002)(38100700002)(26005)(52116002)(5660300002)(316002)(6486002)(6512007)(44832011)(6666004)(8676002)(8936002)(1076003)(66946007)(66476007)(66556008)(6916009)(186003)(508600001)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mTJZfQVePuN7nI+9UchmXnXNNI5VrPPRjb70G2PhVhd6xujGzM/H54q/qKmH?=
 =?us-ascii?Q?zSkgAQeLoksbHm0Ht21yCuTtPs9Pqo0PEv11sz+Xs/YoYeM1XaPMYNmPd6kj?=
 =?us-ascii?Q?NZSR8gJ6WT3vjTvnytCyWCe6y6gNqQ2Wmzl8KOODO4rohh0V/zw2AC5TXT6i?=
 =?us-ascii?Q?ziXZSvFxfzHor5JlJHl1IuDXEuzjMaTyngGnDbe7HjZdz1B+Oe/j0UbwVleo?=
 =?us-ascii?Q?hASzmxdhmyBnksBiC09lgiOPAqb6AI8ITh3e7ET4o70E8DQaJCBa+Cn0D4u3?=
 =?us-ascii?Q?5nhEmTu1J/nO66sy7rlmTZ5L0eqPaVTBm8g8mhjbOSkn41Pmga6Ood+pcvZ1?=
 =?us-ascii?Q?ZszQsoQsWN7ttrkCmk+B5xbgGY0ltwHNbDxsahFaRiqM2qx3vi6KKTDeQY/C?=
 =?us-ascii?Q?YS3RRJ0Gg7LhfXQKGQBoO/vR+n0BcojNEuszN5peObtK+WiMPYH0ByLC3oES?=
 =?us-ascii?Q?NaxrGjtqpbSishBAZQeJfDPv3+u+JIThVzEj+EGMN/7a74Ol0hGfHk5jM7wN?=
 =?us-ascii?Q?ziU8wGI/G6u6rip7xo9AwPtXIagBlceCuCJGmUw+Dzn4UzgTbdXBoJGFQHiu?=
 =?us-ascii?Q?EnXM2N5BHgIH2rSQdq0XLe23dbEqDJGRmxTwZfvjhwmi/BbYTtY5qsKlxH5n?=
 =?us-ascii?Q?1dnomxgNigd1L2fSUen8+5W08gEZ1JwdeBsQHi7Yl97JcsyeSLhj0AfYioc1?=
 =?us-ascii?Q?RBLdxf7FqsFvZhWK6oc/YLI0OduFNvKsEtN1YFCHAjwRiHA2HQ1zB02j9Cki?=
 =?us-ascii?Q?SvDnNzbSNjWTgm1j+XvZFVzYbn4JytxVnJkp6GqCXrUiBxJFt8oTcyq8Zr3y?=
 =?us-ascii?Q?/SwyEtps8V7Yv9+C/LhfaGJ8mhxwr+hJRv9cWAKF9i45K17dLHBvgNXIP9VM?=
 =?us-ascii?Q?mJ7/Q4zTu8LTWBBnHchn0+b6xAKhLJub8mtJBjW+ANHKrN+notiG7uLjhPM6?=
 =?us-ascii?Q?tHrTK140kGZBfTY7xACiComfdCPKW+O+yVL3wbwSErtQrYbyQ1zLLL5DvHph?=
 =?us-ascii?Q?Jjb5W5H378Yv5MeSnHmh52Sas+Tm3xoqALIEi91cA6In0nHHx1Eoq95bKzPG?=
 =?us-ascii?Q?Cy1tpQLduNWPyfdfGAQt3Ia/2Yeh1YyHtUSLry+BzhoUjX3miauW7DCAeX37?=
 =?us-ascii?Q?pYu28QIH5jC3r4Tj/bxcw3J/GeZ/zm1yQw6BJ/buWMpDWDmAa4wmrAISyHVS?=
 =?us-ascii?Q?T0aafpSeePlpgh0V+OmV0c50iUHfEDgyZqnIIh9YGghtxP7nDsB3xY6H/682?=
 =?us-ascii?Q?gIppHvMaJoQPkcny6z38W6PxmoTR9OUIp5DKUj3E0M53lVpPsYngGjTvCH/R?=
 =?us-ascii?Q?r2eYYK5TTYLlq3i+5ollEdPcI76rVTOtPKtUVL8MPD4F33BVP2wF59yUiWg0?=
 =?us-ascii?Q?BIWHxFrnBPMzcVNNtnuFnJQ1fVszpf1PelgiEjzLeg26xCwRmz7z5qhemNr6?=
 =?us-ascii?Q?14yJJ6JgcKcpRjmaCA+PasKj3Yh4L0tQFtADeOoUY0BNZD8AsB12w6xbRoym?=
 =?us-ascii?Q?I7KboTPApeWqA6JBPBoU8Lcx0XzEGH+jRNQ33ZJVodF0m16XxdEex1m3togd?=
 =?us-ascii?Q?/sJJxFgoglowhZKLBwFAtXhtSal7KLKLW8Ci4r4r9ThbPpYperbOyrbT/zvI?=
 =?us-ascii?Q?0qeDA0EZU9bWKZQ7TXaxXX2doSvH8xebYQcFpAdbL7LoWg5URPBwacsc76vj?=
 =?us-ascii?Q?DJI1dg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f45288e-f671-4e1d-bc65-08d9a981045b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 04:16:23.9866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HwuDWny+ttOkBypxMLULNo1l1jF3nerGvHZSIJMI4CvKh0Xuyp2dvTcRUaPngfv1CwHPHHMN9mRvbJRWjvRb1PjKQ5xB9vI27+OPVJYnE8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4446
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10170 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170019
X-Proofpoint-ORIG-GUID: 5pUegwW9GDKeeGqWAjuhy8L92PmjXVYJ
X-Proofpoint-GUID: 5pUegwW9GDKeeGqWAjuhy8L92PmjXVYJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 6d9d518192a3f633fce0821601847966280857f7

This patch adds a helper function xfs_attr_leaf_addname.  While this
does help to break down xfs_attr_set_iter, it does also hoist out some
of the state management.  This patch has been moved to the end of the
clean up series for further discussion.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 include/xfs_trace.h |   1 +
 libxfs/xfs_attr.c   | 110 ++++++++++++++++++++++++--------------------
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 227193a1e8fa..e920e4b0db8e 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -316,6 +316,7 @@
 
 #define trace_xfs_attr_sf_addname_return(a,b)	((void) 0)
 #define trace_xfs_attr_set_iter_return(a,b)	((void) 0)
+#define trace_xfs_attr_leaf_addname_return(a,b)	((void) 0)
 #define trace_xfs_attr_node_addname_return(a,b)	((void) 0)
 #define trace_xfs_attr_remove_iter_return(a,b)	((void) 0)
 #define trace_xfs_attr_rmtval_remove_return(a,b)	((void) 0)
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index c5b0abb5df20..0f90d5897c8d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -281,6 +281,65 @@ xfs_attr_sf_addname(
 	return -EAGAIN;
 }
 
+STATIC int
+xfs_attr_leaf_addname(
+	struct xfs_attr_item	*attr)
+{
+	struct xfs_da_args	*args = attr->xattri_da_args;
+	struct xfs_inode	*dp = args->dp;
+	int			error;
+
+	if (xfs_attr_is_leaf(dp)) {
+		error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
+		if (error == -ENOSPC) {
+			error = xfs_attr3_leaf_to_node(args);
+			if (error)
+				return error;
+
+			/*
+			 * Finish any deferred work items and roll the
+			 * transaction once more.  The goal here is to call
+			 * node_addname with the inode and transaction in the
+			 * same state (inode locked and joined, transaction
+			 * clean) no matter how we got to this step.
+			 *
+			 * At this point, we are still in XFS_DAS_UNINIT, but
+			 * when we come back, we'll be a node, so we'll fall
+			 * down into the node handling code below
+			 */
+			trace_xfs_attr_set_iter_return(
+				attr->xattri_dela_state, args->dp);
+			return -EAGAIN;
+		}
+
+		if (error)
+			return error;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+	} else {
+		error = xfs_attr_node_addname_find_attr(attr);
+		if (error)
+			return error;
+
+		error = xfs_attr_node_addname(attr);
+		if (error)
+			return error;
+
+		/*
+		 * If addname was successful, and we dont need to alloc or
+		 * remove anymore blks, we're done.
+		 */
+		if (!args->rmtblkno &&
+		    !(args->op_flags & XFS_DA_OP_RENAME))
+			return 0;
+
+		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+	}
+
+	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
+	return -EAGAIN;
+}
+
 /*
  * Set the attribute specified in @args.
  * This routine is meant to function as a delayed operation, and may return
@@ -316,57 +375,8 @@ xfs_attr_set_iter(
 			attr->xattri_leaf_bp = NULL;
 		}
 
-		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args,
-						      attr->xattri_leaf_bp);
-			if (error == -ENOSPC) {
-				error = xfs_attr3_leaf_to_node(args);
-				if (error)
-					return error;
-
-				/*
-				 * Finish any deferred work items and roll the
-				 * transaction once more.  The goal here is to
-				 * call node_addname with the inode and
-				 * transaction in the same state (inode locked
-				 * and joined, transaction clean) no matter how
-				 * we got to this step.
-				 *
-				 * At this point, we are still in
-				 * XFS_DAS_UNINIT, but when we come back, we'll
-				 * be a node, so we'll fall down into the node
-				 * handling code below
-				 */
-				trace_xfs_attr_set_iter_return(
-					attr->xattri_dela_state, args->dp);
-				return -EAGAIN;
-			} else if (error) {
-				return error;
-			}
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
-		} else {
-			error = xfs_attr_node_addname_find_attr(attr);
-			if (error)
-				return error;
+		return xfs_attr_leaf_addname(attr);
 
-			error = xfs_attr_node_addname(attr);
-			if (error)
-				return error;
-
-			/*
-			 * If addname was successful, and we dont need to alloc
-			 * or remove anymore blks, we're done.
-			 */
-			if (!args->rmtblkno &&
-			    !(args->op_flags & XFS_DA_OP_RENAME))
-				return 0;
-
-			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
-		}
-		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-					       args->dp);
-		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
-- 
2.25.1

