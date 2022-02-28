Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1895AC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiB1TxI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiB1Twn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BDBCA736
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:52:04 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJIAw010136
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=CbDiGC6d4rIMYPHF2GXl5716s0f2UZdG5o0FyWM2F0c=;
 b=o36a2MtdTv7X74kDMwJvvPXY1PA7aIsi2Mi30QyPASKxe4MMOkDSmcRPWI47mfh2Hfea
 8V+AYaLd1bHtwBD1IGTLOYX49ihnTxZ0lCD7CX7AoZRFG/yysz5JjN+BYt+a8vQx+YyG
 5FWkQocM7LceY1OuycNLOpBhn3MCKN8vBS/Nzw/EncBZ0zGj8n2RNbqv8H4MN2Yp0mqx
 jCBC28f6hYzWXCjZVxxMOF5FeRlGp9E0MFmxPVJ4AilqOOQbQmDLGLxJFUUs+Z4sjvuw
 g7ZovKMF5OHU59Fia6hN7aCfIC1t/YMlFBFc1Z9JIGOzwWlwa8tGdqrFS2KH77Ru5Q4a pQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k40pqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJjsZ7061244
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3030.oracle.com with ESMTP id 3ef9aw0y4u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtNQjVRRa/mq579FTDcjQ/OXT+fYpnAjeEUTiL2tXyq0EQ3eckp4PFuSdWu97x19oVUFif7qiyKUilKdwwkbEKWzPsUjFn4PjlLZuWysebUxbvU+u7mOgHuTK2gUjPoP5EYS6d4YyNga56zsS65DLZmRTLkJjH6L1CCuXVJ/IDJ03xChIOjMfriHRInDDZFNG1zrcQ2YHlEl69NLkMQc9pH/YbEmHTGPCfMLhFKN8AGWDmG/btV+DHAaqdtLrGkzrCpb32e5ydt472cMPWYyJIyH06R5z9TZ7ket5zRQCk0Bz/IV617xDySunFJhRG8h6++jMy+ynn9aI3Nz2ElhSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CbDiGC6d4rIMYPHF2GXl5716s0f2UZdG5o0FyWM2F0c=;
 b=Rn/tEVM7QQk4rjxjuDt2HSY/YH7KWcDd9rS8ZTi9DejJCMR8WXD6HpRGXvAU6ZNcJEqdKpX5nQQ4jgezYoNmKexl1UzjiprqZXscBc4PpvMiZQbWT4NGfmS/BVhIdbRan72FBpbhk0tq/oMxyyyr3XW7IosrD+3ARUshAOOnftbyidiOc0zGvtfwSSKOwzeOfd84Skm2/J3HSxht2ievNF/TEKCgWyITVRtI4lPiDdxrQ9aShw1xW2vSzq9208/+aRJFLV3S/JKVm7AmKWeCBHCFmbX+FFZZYS+opLbstajmNeL1w4UJGdE6r2UXVwz1GIaa/ze0OLYNe1CDvl4Rxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CbDiGC6d4rIMYPHF2GXl5716s0f2UZdG5o0FyWM2F0c=;
 b=gy842GdWXcX4DewdkMv9EbR6eyv3zh4xLnBP68vam6yWxc84qN9+QcuP+sLLbaXemizhHwUly0foSVQZKAZ+LuTP2yi49CQrY5AstiZEGoToKny/oGdeX7GHDbAhZ75zP9DNT7Vlt/f0yVtUbQKZd4SepFLGfpTrpZZk+OMVvUY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN6PR10MB1732.namprd10.prod.outlook.com (2603:10b6:405:9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Mon, 28 Feb
 2022 19:51:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:51:59 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 13/15] xfs: Add helper function xfs_init_attr_trans
Date:   Mon, 28 Feb 2022 12:51:45 -0700
Message-Id: <20220228195147.1913281-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228195147.1913281-1-allison.henderson@oracle.com>
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 985f9090-03f0-426a-fd93-08d9faf3c7ca
X-MS-TrafficTypeDiagnostic: BN6PR10MB1732:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB173288FC50650DA6A9F5FC0595019@BN6PR10MB1732.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t4+qSiW3s9cFcl8xh+Qcvq76nkvFsF9R08BK0PX4DikNlX4tJyC2kPaj0TInN7JkKJyN+o0F1R4NRBMCXAIb0r3XU0FyZFs8K1MJNuHcJsBxPecfvQoegZwDxK2c9aG/N66IjzWbYBdIOoCG3Al1LFPQTEjQZ4osYH3MTjd8z3ejT7Rr4Gli2pnXhsistcosiik3StczsIgdgkbShGtfux4VsvJqAUIAApzjsfw5TDQA9SU1i43Bh0+iAzI8S2PXcWndIfNkta88rdYjTJa0H6gmdaxnhZQptvTHclakxjpQXaIXqqzk33b4NjA+vg9EhSILtmhO3+Zik/l2317Xh/3lJm0i2jC1wlASXA7ushWg5hqtPqbdzhKnEUF6Qx3gfG2HxDgZ/2qDmO2IbM+CUQaDv1UNjRYDBR57sl+Cdtbb3OUqA6fAI0UXt+BxsINq3ieUXtufgXMc/XtUNf7wd81U/cvd6RC33RYn6WQC8X6QfQ+mGjjD+aOPT8C0N1pi/DJw1HRMO2vLaO7IgERIWVfcjkrxzfTS1bU19PdSaEAtNzkgrDBbVr2swHzXGLRKN4gA0TT5nUF/gVBdNhmJfrOOJp8mOT8LSrc50YRzaRowQ/UcE9Vnpz9+vZrpLm6SYOVq3Keg30BvF0sBEgW8oq13Dgrk3FU8P2sQbSdwWkHNxArcdZtQwjWslq0rr7YqmOeG0h/zU8+IniYLnlUz3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(86362001)(6666004)(1076003)(52116002)(2616005)(6506007)(508600001)(26005)(186003)(83380400001)(6916009)(66556008)(66476007)(8676002)(66946007)(38100700002)(38350700002)(5660300002)(44832011)(8936002)(6512007)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jT+r1f+rn3jGrwvQ23BGSUAjkNYLTNTNF5zLuknFnSfW0JWSGLcNtg+8mjx0?=
 =?us-ascii?Q?vPVB8cPoLaNko77phIrWfaWVFhP7MpNUuyzfFcIVFt7+UB508ffeop5Zm8ce?=
 =?us-ascii?Q?tYFdICqoh9S0LpHjFkHbZGnxzRWeX+EBvduQstz65rHSSSjf6qW02/l7Ltrq?=
 =?us-ascii?Q?ZUkFlKk4kU2c4RAl4Ysid6+AeOXLDcqFtpYC17KGleCt9FEZQoBPo0DSj/L9?=
 =?us-ascii?Q?EuHyo2L2+kE2ZPSZeBNZrnsP6gCOBmCEUJtmp8Fi6I4ZpTMvqF5v80h4vYgp?=
 =?us-ascii?Q?eesT2N/P/MyHUY3pFMk/smNh/DCGD5dLnKSELCsDaK8wq3ZQAr4dvVkO1LP3?=
 =?us-ascii?Q?vx19/EVIl7MIREPl3RxIGbjNo01VY12mutUJFMkFwVojL9g0dL0o1KENnCF1?=
 =?us-ascii?Q?Seg2QU8sE7TMZhuDNQPTqyzwly7zSiLKOAb+s+/AmNXz6Lmf1dIGVB2dxN+b?=
 =?us-ascii?Q?HUZ0S8q6iLpJ1G0KJMaxYy01GCuil8HSptqCdhvoqy9+TO2V2qQ4aDbSnCyJ?=
 =?us-ascii?Q?/ItjfcqVxESX7mBURk8SCRAh+HNwvJRQtZIRngPXlGFUs/CVelk6Io868Nm4?=
 =?us-ascii?Q?OYLKEXJ2qXHNv2SNgcHReMRuv58vokdi/NhWESVcw04UGW/C8uPrX7HcWRJr?=
 =?us-ascii?Q?rFMp4GmhMVGiTuvN9mL4+xb3om7XsGh7z9/l1PK/t+mqbCDeLC6gsKUciFuf?=
 =?us-ascii?Q?798bl3ODzELAXeGn1C9SidT7RSTYX0gAHBQJC7ViRQx/vt7v7IBm20LDGZfr?=
 =?us-ascii?Q?YHE8zvgM2SfKDDG26+DKHxRUV54fakUXWR+i890fOBy/7st8fwNcwoIABDQo?=
 =?us-ascii?Q?/rzEFmnJn24p1mAwMe4UEsvvdFtY1Gbgi03c7aoZsAL8ktjBOjbFlpy0F14P?=
 =?us-ascii?Q?6+8O275BrWvXkxdDSIHbI3Hw+MEuZaPja8cyahkuiMsm4exdMq9bEePKwRpy?=
 =?us-ascii?Q?tfnssGlGzlZgbEhZKFgeVbRArBgqBZ6XtJhnugApqRwq08JDpxkedwXARFr5?=
 =?us-ascii?Q?bshOyOjEN85XDyngofzXAx+8LlheghNpPLak2RsHKZ3g6flk/1Plo3hHBu84?=
 =?us-ascii?Q?/Rc9YlgKxTRAD0Ssj23c4jXwfZSM7VZLJrkObhYP12E1v/0KizkamnWw+Plk?=
 =?us-ascii?Q?1SEhgNNcZZeuRibPCMDN2T3UQ8Ozth2tfa/II1xtzT+xDclg64KQS/l36KAb?=
 =?us-ascii?Q?WWeqfi6b3QgxIvrH0Qr4XNaaY/b+hRy6NwrQCVgjqAjvJkZoBKBCBFsLkIVu?=
 =?us-ascii?Q?guPIBAFG7irGxAzx0QFHpdlIu2pYTQ68xGPw5mVPehHEZbLaXfdMckBRDCpr?=
 =?us-ascii?Q?He4pIPD5t32oe5OrCgq4EuJ4LtOCF7C8+75Lx7Dm3iFTH8WPerSMU3lHNBdK?=
 =?us-ascii?Q?acDrPqFt0n3SG1DSQGgQzerOinKAKgcLG3pe58WdJ4Ee/i35ArsENr+1fzQt?=
 =?us-ascii?Q?xL7d0RtoOtB1g62rcLi6zITtk2VEexLgqGL6KbgppJFHzuln8htl3ilkbXTD?=
 =?us-ascii?Q?qWyQR2pU6i736rMwVqm13IVLR6s4OKgBNd8cKQme77VwfrFEejvf4qo9MAAD?=
 =?us-ascii?Q?GUvV+R6xT/zNPTB+07d2Y1mLe/vbqwESLrw+iG096QYn5a/izgwcEIPMSMsI?=
 =?us-ascii?Q?V4HwiRoyfRrEPhpF1hkSO7zwQMrHKkMS1OUvP5jE7sPpaXPG67gx7QvxAPLW?=
 =?us-ascii?Q?2fSCYg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 985f9090-03f0-426a-fd93-08d9faf3c7ca
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:58.7476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UuW1mDe6qyaNc99LslQBwUY01tBNmXyrJO0KLU42TTZ8edTsWtrKwIrsUMFKDwsaYN5j2o0jVnPE7q1NGB04qKwZGRJCIrGSz4vV/nu/Pzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1732
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-ORIG-GUID: 55kthZMSWHcVvL07EszC9f8MMFdX_1i1
X-Proofpoint-GUID: 55kthZMSWHcVvL07EszC9f8MMFdX_1i1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Quick helper function to collapse duplicate code to initialize
transactions for attributes

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 33 +++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_attr.h |  2 ++
 fs/xfs/xfs_attr_item.c   | 12 ++----------
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 7d6ad1d0e10b..41404d35c76c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -202,6 +202,28 @@ xfs_attr_calc_size(
 	return nblks;
 }
 
+/* Initialize transaction reservation for attr operations */
+void
+xfs_init_attr_trans(
+	struct xfs_da_args	*args,
+	struct xfs_trans_res	*tres,
+	unsigned int		*total)
+{
+	struct xfs_mount	*mp = args->dp->i_mount;
+
+	if (args->value) {
+		tres->tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+				 M_RES(mp)->tr_attrsetrt.tr_logres *
+				 args->total;
+		tres->tr_logcount = XFS_ATTRSET_LOG_COUNT;
+		tres->tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		*total = args->total;
+	} else {
+		*tres = M_RES(mp)->tr_attrrm;
+		*total = XFS_ATTRRM_SPACE_RES(mp);
+	}
+}
+
 STATIC int
 xfs_attr_try_sf_addname(
 	struct xfs_inode	*dp,
@@ -701,20 +723,10 @@ xfs_attr_set(
 				return error;
 		}
 
-		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres *
-					args->total;
-		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		total = args->total;
-
 		if (!local)
 			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
-
-		tres = M_RES(mp)->tr_attrrm;
-		total = XFS_ATTRRM_SPACE_RES(mp);
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
@@ -728,6 +740,7 @@ xfs_attr_set(
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
+	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
 		goto drop_incompat;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 1ef58d34eb59..f6c13d2bfbcd 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -519,6 +519,8 @@ int xfs_attr_set_iter(struct xfs_attr_item *attr);
 int xfs_attr_remove_iter(struct xfs_attr_item *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
+			 unsigned int *total);
 int xfs_attr_set_deferred(struct xfs_da_args *args);
 int xfs_attr_remove_deferred(struct xfs_da_args *args);
 
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 878f50babb23..5aa7a764d95e 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -532,17 +532,9 @@ xfs_attri_item_recover(
 		args->value = attrip->attri_value;
 		args->valuelen = attrp->alfi_value_len;
 		args->total = xfs_attr_calc_size(args, &local);
-
-		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres *
-					args->total;
-		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		total = args->total;
-	} else {
-		tres = M_RES(mp)->tr_attrrm;
-		total = XFS_ATTRRM_SPACE_RES(mp);
 	}
+
+	xfs_init_attr_trans(args, &tres, &total);
 	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		goto out;
-- 
2.25.1

