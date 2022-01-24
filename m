Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D10C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 05:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240871AbiAXF1c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 00:27:32 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39638 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240794AbiAXF10 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 00:27:26 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20NL5x5f010082
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=O43ckQ63/Xag9atB71A/UFndK1MPM+8BJ01JSM74tBk=;
 b=TeFc0GyDAnld4G5SlTzeIVlOhQ8UqJHp+GMJfRd6NDNkhj8FVVJ2ZA87thGBCa918Epm
 BAoSOAFp/6yUiALIGsvOC47L2grg/1LYot9e5P9hj959xwvR8EMglFUyGwW1l18cKUws
 Kk9HTpOSaKC6f3+V8L49ff3sry1wWALW/4g6gFdlVCB85R8kW+diWwCWFzue/rBPxZiA
 uhlSAtbFGxPmqZn+VgO3vBxL/VLzs2M+sOfBeBrB7XxBdfe53qtd6h9FIULihak4kyCL
 GJYyQOO6QgbLouJ0UB0NfDku/fpT3iaH3vTY40QdQhSDKdiPDrFSkL1NgRwRknXUTjfy jA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dr8q3b6qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20O5REWA139905
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3030.oracle.com with ESMTP id 3dr7yd4xn2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npf91Xvn/fzNDdC87E/HVuhD8vaDr9psvkMOykeMSYadFjI8C8BiEWBFeXN2bKZt666kx+Fn68MOHYy6UaX/MUCb88U7UtTZPKRUOifvpFARU4l3IDe399nDuuDVjwqktSBh12lo325Cvw440U8ACH9NwUmeW/WwLxtOaEbDsTj81xNK85a5rggKVIkIkJJmnf+Jxi4BD4YqQFan4+q4GohbmU0vvyaJPDjlI65+175hPcU/iqe4k06rIHQk6nlMhrnIMPU0b5wDQ0tJD3fUQrt4eSCXGvbqN3DTfqlPwCEtzPAhd2x5eh+oEDc3AHxL0P8+Pakill6zRXeRqwn7cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O43ckQ63/Xag9atB71A/UFndK1MPM+8BJ01JSM74tBk=;
 b=Db9tapbdKQw4oBfzWCXcaf4qPBd4cpJ0Feuqz7KkNtTA7LV+MmG+Yfje0eteusCDl/U04nbRAObOugym9VBOZ/Mq2HsTRrZJPX5Xatd3oxkyHfTK9bQFab1XIvSYwA1CF+6cPi2l50WvRzyefWsicGLEJYxAfYzHWJqSdK6qujRVQK2RrH6K+E/qIb6GxnmcqIk/C2c1FkVm1/g5TuMVgcgReVFcHw4sQ0gzK7GbeRGwMDlRl6fqWXLul2CmQxqJi89vWMvXdKzAELvsLOLIZbf/DQpf5HQOw8pzqEeGSJZZRSeCK67XB+DoUO4r4BvYNgpNeCcd7NlT7ay6Z4I7Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O43ckQ63/Xag9atB71A/UFndK1MPM+8BJ01JSM74tBk=;
 b=sW1dv3HgXQawtEnw5XGpgjgW9hAdU2NbEAaWzYC8dujDCPdJQ60KE7T+sFHwYbhlWGAYE7oai1SuNiC8XnanwZqMvWkO3AYrybjVatuIDevtJlPyq2f3q0f1wYw4eArBvK3AU/KnYYx1wYKB+ahqDufmWfKYt7HIc5OvuZM6F/U=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB4821.namprd10.prod.outlook.com (2603:10b6:408:125::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Mon, 24 Jan
 2022 05:27:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 05:27:23 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v26 11/12] xfs: Merge xfs_delattr_context into xfs_attr_item
Date:   Sun, 23 Jan 2022 22:27:07 -0700
Message-Id: <20220124052708.580016-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124052708.580016-1-allison.henderson@oracle.com>
References: <20220124052708.580016-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41215432-7548-4c51-eafe-08d9defa30c4
X-MS-TrafficTypeDiagnostic: BN0PR10MB4821:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB48219E8166A771547A76A0FC955E9@BN0PR10MB4821.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:250;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oXvtJF85A2g+2ggJyjTgMjcDXuLffdzWPFqwFHwv7boyCSPQY9eXGQf0anGLw9cm27XgvKFcUVjFp6ttmopPxzK7I9AHVm3Ex0foj6JNNgrqL9GiW3ktNpLJz40ep0fJ/4mxKdcBUvDqx1g1D2T89US0bGwuKoRQW881AmkYtJGka1R9M+M3vLg7phKmYDzyTlosPlpb/Qu5p1jZ1zNPLRyOF7NTWKE17AqMKfATa/9v3kP3KIxv1T8PMh3FKaW8rnDn/HHVnVm+KZYXgGbz8vsySaW649wk4lT9jIunUEfcDujq/FQmEETTiAk8KJdkLLKF0htR5v5JrEc3Tgidv09N7EaNZLao2/yxgsZ39/m9cke8Mx1zMTExbM+2pkfXypWUvbTCZuqKxq9y1LMoXumoltwWD5hVrC4BkrLulAEz8BTkG1hV+KfXMIfubXcPV2azHFn0UfOxV3EPXtYmxhdoogJ195Xpm3XnB49uk9bhYLCbi/3j4Zj5uHa/rJEGixB1brLT12DzqpvKwvxFx1GnOEOB73q9zwh+iHsYsXTqJtC/QSsXPIP2iNvWIr7KQPTaWoj94/OJdRNwo+AhCV3gCfWR/9DdgpdvUT2QNoA68UZ6vOUHmqv/1xiUQq0P6b/DNtXMi/8TEzN0aLBnl+b144VMVR9rW8WSBdH999s2GVjKiSqSZA5/yO67X4KKq/R447mmLUyLZtEFtY8mNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(186003)(6666004)(52116002)(6512007)(2616005)(83380400001)(66946007)(66476007)(66556008)(38100700002)(5660300002)(30864003)(26005)(2906002)(36756003)(86362001)(6486002)(1076003)(38350700002)(316002)(44832011)(508600001)(6506007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e/qLwLJlkrifKDIWScTNY5yDjfHnx7AKQb6E467sXlWdv7b0okFOObVvzqPo?=
 =?us-ascii?Q?Qn4RHCkUrDXw5YIhY+dmyRDyxVt6NLMUy9oL+hS7bJVIv1FeHYaEBfwU0piK?=
 =?us-ascii?Q?lUdwYOWoMGA2itokTRq/dVyt5FY24bJIHl3KEmZ68ek46bspA5PZA/uvJp+T?=
 =?us-ascii?Q?Fir6CM1Lkk7p4m7NvtEACnt+yMSG3It1/Em/70yz1RSK3+1GD1mCTm6IBStK?=
 =?us-ascii?Q?uBe6EMI9orAQpPb6xokKK/vuee1vvWPvznZw9erZKQazmAwd9sXi5sypeklT?=
 =?us-ascii?Q?bJxV8NUc4IDBKmDA/a2GULWHV9zATRB+/1e6zD5v2IsUwCsVaJ2QPzscPPvI?=
 =?us-ascii?Q?rShXGHrDfyYWfz6lIgfVYH+UhyQ3nZlYkzcZzpClPUGWZaUb7k0pDDt2Nfhe?=
 =?us-ascii?Q?ASn1k7rJddaoZhYw4YMQ2IToHiHQI7FRAij8PZ0FK2Nn8f1Rgh6s1t7xJZCM?=
 =?us-ascii?Q?tX9ZYZa6e5j1igfS2hOR9ScycU6F1ix9KeSlbM+aRZh7tFuGuOwPHCXbDtvQ?=
 =?us-ascii?Q?/qtZ3XlFAiLFbOwYtijtnLhtcHdVqAJMlsrFGd7uOKT4AR46+Uh8Y2JX7Su7?=
 =?us-ascii?Q?uKoBkQapDJ2fBsFNdxoFNCohdg0DbhR7rX/haEDAqDbvSFUa8lFQwl7B6+Zz?=
 =?us-ascii?Q?Hok0x5IDpuI8SAjaCS+2Tz0TPsDhVZqYxcPS1C4oP1FqUCaRQYQQT+JELUIn?=
 =?us-ascii?Q?rp+bL0uE6qwWBgopkV111A3Dl97B+L7EHyDOihpo7kVtwSwlvxE0VXSVS7xc?=
 =?us-ascii?Q?Y3ph0qSf8r63dgX1kaPUr4m/0HLZiP6fLCFS6zkk9PZfBeQjJmKXKPVH9s2+?=
 =?us-ascii?Q?e91VEgjZlihx+Rb36pjJKz/hF0LzUSuMlt/Yp85T/8T9uDmIHU0ZLyVRBpcV?=
 =?us-ascii?Q?3Us80x8J3auh+XR8ksTFlt/ITmarqcG1GyRPmsfehBYmfnwT6nlMcsE27KIk?=
 =?us-ascii?Q?FIZmb3s+DMSixk0JLmmvQpkH9MVpwdGl7bJzhHjJ8C8ZWQUSG9yG5NyRx19F?=
 =?us-ascii?Q?h2RJYb1fc6LX33zNOlFYEADsqeQxt4oCNGMu22IueVFrerkwWBBuA3OKG7Cy?=
 =?us-ascii?Q?gqPauYDsGdbBwPoJlL/bofGbItkSCeQFKO5KsbGuGJX5xJqfvyr7to+eYGiR?=
 =?us-ascii?Q?RTTnR8Jo9JPx6ZniHLYzBjTGJ3TnDYW2oIbl5FPrlq6m5bdXEscX6BttEFU/?=
 =?us-ascii?Q?rxeVwc9jMm4LIUIIMc0+pUxr7yNWPAeFVr7a629aWTpfKUvFwOY4NZ8R56C+?=
 =?us-ascii?Q?MtTl3w92bMGNf3hD0dG5dY2yQ+bkh9nfvhllfeg4CtoTQc955Etmk9Ou0x6X?=
 =?us-ascii?Q?scPdEDWqSJKQ1ldLf0GGw2TLbadaoo0tL0Q3fROTYR/pGXxwLSHK13OBMN3e?=
 =?us-ascii?Q?0oz6GMD3nLQNOG1IOcgmVsLEOvMnPdy6eDzE8VmLjODup9V3/UtpbFFFnIDQ?=
 =?us-ascii?Q?roeHHA7t3rSI0m5UWuc0H4GDTEJzMcbhBwyGLHTRLPagm6G7UqBjycETu+9T?=
 =?us-ascii?Q?YKqcZ+OqZrjKRX/OPpY0wZz2dht18rjD/sjB1lHuKjs0u3TE8eb7zrSmyb87?=
 =?us-ascii?Q?+9GhSdkNNY4f78rT5V+cbNaETHjSr8sgk6HqGxxsmjZLEtykMcIOe5tUGqQH?=
 =?us-ascii?Q?zbHIvMXd/CX1P0R8MY5p/4MWpHMtll1lRIGaUCsGpxZSFPmhiPptY2DhQ3lc?=
 =?us-ascii?Q?9WN6wA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41215432-7548-4c51-eafe-08d9defa30c4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 05:27:19.2599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +lrIE+3dHhQJR7GY9SbZSinxpGj7aUKJkx7MuVyRV3twXIKaNfpoDhjC4BJSJRUG0t54C36SYoqiokxEuSjtCR1dP95sxq41+6Z4qhGmGYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201240036
X-Proofpoint-ORIG-GUID: e9YqAbVVeRz6wmY67IvDigZftr76JK_R
X-Proofpoint-GUID: e9YqAbVVeRz6wmY67IvDigZftr76JK_R
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a clean up patch that merges xfs_delattr_context into
xfs_attr_item.  Now that the refactoring is complete and the delayed
operation infrastructure is in place, we can combine these to eliminate
the extra struct

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 162 +++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr.h        |  40 ++++----
 fs/xfs/libxfs/xfs_attr_remote.c |  36 +++----
 fs/xfs/libxfs/xfs_attr_remote.h |   6 +-
 fs/xfs/xfs_attr_item.c          |  42 ++++-----
 5 files changed, 143 insertions(+), 143 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3d7531817e74..1b1aa3079469 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -59,10 +59,9 @@ STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
  */
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
-STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
-STATIC int xfs_attr_node_addname_find_attr(struct xfs_delattr_context *dac);
-STATIC int xfs_attr_node_addname_clear_incomplete(
-				struct xfs_delattr_context *dac);
+STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
+STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_attr_item *attr);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -249,9 +248,9 @@ xfs_attr_is_shortform(
 
 STATIC int
 xfs_attr_sf_addname(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
 	int				error = 0;
 
@@ -268,7 +267,7 @@ xfs_attr_sf_addname(
 	 * It won't fit in the shortform, transform to a leaf block.  GROT:
 	 * another possible req'mt for a double-split btree op.
 	 */
-	error = xfs_attr_shortform_to_leaf(args, &dac->leaf_bp);
+	error = xfs_attr_shortform_to_leaf(args, &attr->xattri_leaf_bp);
 	if (error)
 		return error;
 
@@ -277,7 +276,7 @@ xfs_attr_sf_addname(
 	 * push cannot grab the half-baked leaf buffer and run into problems
 	 * with the write verifier.
 	 */
-	xfs_trans_bhold(args->trans, dac->leaf_bp);
+	xfs_trans_bhold(args->trans, attr->xattri_leaf_bp);
 
 	/*
 	 * We're still in XFS_DAS_UNINIT state here.  We've converted
@@ -297,16 +296,16 @@ xfs_attr_sf_addname(
  */
 int
 xfs_attr_set_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args              *args = dac->da_args;
+	struct xfs_da_args              *args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
 	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		/*
 		 * If the fork is shortform, attempt to add the attr. If there
@@ -316,14 +315,16 @@ xfs_attr_set_iter(
 		 * release the hold once we return with a clean transaction.
 		 */
 		if (xfs_attr_is_shortform(dp))
-			return xfs_attr_sf_addname(dac);
-		if (dac->leaf_bp != NULL) {
-			xfs_trans_bhold_release(args->trans, dac->leaf_bp);
-			dac->leaf_bp = NULL;
+			return xfs_attr_sf_addname(attr);
+		if (attr->xattri_leaf_bp != NULL) {
+			xfs_trans_bhold_release(args->trans,
+						attr->xattri_leaf_bp);
+			attr->xattri_leaf_bp = NULL;
 		}
 
 		if (xfs_attr_is_leaf(dp)) {
-			error = xfs_attr_leaf_try_add(args, dac->leaf_bp);
+			error = xfs_attr_leaf_try_add(args,
+						      attr->xattri_leaf_bp);
 			if (error == -ENOSPC) {
 				error = xfs_attr3_leaf_to_node(args);
 				if (error)
@@ -343,19 +344,19 @@ xfs_attr_set_iter(
 				 * handling code below
 				 */
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 				return -EAGAIN;
 			} else if (error) {
 				return error;
 			}
 
-			dac->dela_state = XFS_DAS_FOUND_LBLK;
+			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
 		} else {
-			error = xfs_attr_node_addname_find_attr(dac);
+			error = xfs_attr_node_addname_find_attr(attr);
 			if (error)
 				return error;
 
-			error = xfs_attr_node_addname(dac);
+			error = xfs_attr_node_addname(attr);
 			if (error)
 				return error;
 
@@ -367,9 +368,10 @@ xfs_attr_set_iter(
 			    !(args->op_flags & XFS_DA_OP_RENAME))
 				return 0;
 
-			dac->dela_state = XFS_DAS_FOUND_NBLK;
+			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
 		}
-		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
+		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
+					       args->dp);
 		return -EAGAIN;
 	case XFS_DAS_FOUND_LBLK:
 		/*
@@ -380,10 +382,10 @@ xfs_attr_set_iter(
 		 */
 
 		/* Open coded xfs_attr_rmtval_set without trans handling */
-		if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
-			dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
+		if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
+			attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
 			if (args->rmtblkno > 0) {
-				error = xfs_attr_rmtval_find_space(dac);
+				error = xfs_attr_rmtval_find_space(attr);
 				if (error)
 					return error;
 			}
@@ -393,11 +395,11 @@ xfs_attr_set_iter(
 		 * Repeat allocating remote blocks for the attr value until
 		 * blkcnt drops to zero.
 		 */
-		if (dac->blkcnt > 0) {
-			error = xfs_attr_rmtval_set_blk(dac);
+		if (attr->xattri_blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(attr);
 			if (error)
 				return error;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -433,8 +435,8 @@ xfs_attr_set_iter(
 			 * Commit the flag value change and start the next trans
 			 * in series.
 			 */
-			dac->dela_state = XFS_DAS_FLIP_LFLAG;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -453,17 +455,18 @@ xfs_attr_set_iter(
 		fallthrough;
 	case XFS_DAS_RM_LBLK:
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		dac->dela_state = XFS_DAS_RM_LBLK;
+		attr->xattri_dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			if (error)
 				return error;
 
-			dac->dela_state = XFS_DAS_RD_LEAF;
-			trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
+			attr->xattri_dela_state = XFS_DAS_RD_LEAF;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
@@ -494,7 +497,7 @@ xfs_attr_set_iter(
 		 * state.
 		 */
 		if (args->rmtblkno > 0) {
-			error = xfs_attr_rmtval_find_space(dac);
+			error = xfs_attr_rmtval_find_space(attr);
 			if (error)
 				return error;
 		}
@@ -507,14 +510,14 @@ xfs_attr_set_iter(
 		 * after we create the attribute so that we don't overflow the
 		 * maximum size of a transaction and/or hit a deadlock.
 		 */
-		dac->dela_state = XFS_DAS_ALLOC_NODE;
+		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
 		if (args->rmtblkno > 0) {
-			if (dac->blkcnt > 0) {
-				error = xfs_attr_rmtval_set_blk(dac);
+			if (attr->xattri_blkcnt > 0) {
+				error = xfs_attr_rmtval_set_blk(attr);
 				if (error)
 					return error;
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 				return -EAGAIN;
 			}
 
@@ -550,8 +553,8 @@ xfs_attr_set_iter(
 			 * Commit the flag value change and start the next trans
 			 * in series
 			 */
-			dac->dela_state = XFS_DAS_FLIP_NFLAG;
-			trace_xfs_attr_set_iter_return(dac->dela_state,
+			attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
 						       args->dp);
 			return -EAGAIN;
 		}
@@ -571,18 +574,19 @@ xfs_attr_set_iter(
 		fallthrough;
 	case XFS_DAS_RM_NBLK:
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
-		dac->dela_state = XFS_DAS_RM_NBLK;
+		attr->xattri_dela_state = XFS_DAS_RM_NBLK;
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 
 			if (error)
 				return error;
 
-			dac->dela_state = XFS_DAS_CLR_FLAG;
-			trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
+			attr->xattri_dela_state = XFS_DAS_CLR_FLAG;
+			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
+						       args->dp);
 			return -EAGAIN;
 		}
 
@@ -592,7 +596,7 @@ xfs_attr_set_iter(
 		 * The last state for node format. Look up the old attr and
 		 * remove it.
 		 */
-		error = xfs_attr_node_addname_clear_incomplete(dac);
+		error = xfs_attr_node_addname_clear_incomplete(attr);
 		break;
 	default:
 		ASSERT(0);
@@ -823,7 +827,7 @@ xfs_attr_item_init(
 
 	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
 	new->xattri_op_flags = op_flags;
-	new->xattri_dac.da_args = args;
+	new->xattri_da_args = args;
 
 	*attr = new;
 	return 0;
@@ -1133,16 +1137,16 @@ xfs_attr_node_hasname(
 
 STATIC int
 xfs_attr_node_addname_find_attr(
-	struct xfs_delattr_context	*dac)
+	 struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				retval;
 
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	retval = xfs_attr_node_hasname(args, &dac->da_state);
+	retval = xfs_attr_node_hasname(args, &attr->xattri_da_state);
 	if (retval != -ENOATTR && retval != -EEXIST)
 		goto error;
 
@@ -1170,8 +1174,8 @@ xfs_attr_node_addname_find_attr(
 
 	return 0;
 error:
-	if (dac->da_state)
-		xfs_da_state_free(dac->da_state);
+	if (attr->xattri_da_state)
+		xfs_da_state_free(attr->xattri_da_state);
 	return retval;
 }
 
@@ -1192,10 +1196,10 @@ xfs_attr_node_addname_find_attr(
  */
 STATIC int
 xfs_attr_node_addname(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		*state = attr->xattri_da_state;
 	struct xfs_da_state_blk		*blk;
 	int				error;
 
@@ -1226,7 +1230,7 @@ xfs_attr_node_addname(
 			 * this point.
 			 */
 			trace_xfs_attr_node_addname_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1255,9 +1259,9 @@ xfs_attr_node_addname(
 
 STATIC int
 xfs_attr_node_addname_clear_incomplete(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_da_state		*state = NULL;
 	struct xfs_mount		*mp = args->dp->i_mount;
 	int				retval = 0;
@@ -1361,10 +1365,10 @@ xfs_attr_leaf_mark_incomplete(
  */
 STATIC
 int xfs_attr_node_removename_setup(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		**state = &dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		**state = &attr->xattri_da_state;
 	int				error;
 
 	error = xfs_attr_node_hasname(args, state);
@@ -1423,16 +1427,16 @@ xfs_attr_node_removename(
  */
 int
 xfs_attr_remove_iter(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_da_state		*state = dac->da_state;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_da_state		*state = attr->xattri_da_state;
 	int				retval, error = 0;
 	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	switch (dac->dela_state) {
+	switch (attr->xattri_dela_state) {
 	case XFS_DAS_UNINIT:
 		if (!xfs_inode_hasattr(dp))
 			return -ENOATTR;
@@ -1451,16 +1455,16 @@ xfs_attr_remove_iter(
 		 * Node format may require transaction rolls. Set up the
 		 * state context and fall into the state machine.
 		 */
-		if (!dac->da_state) {
-			error = xfs_attr_node_removename_setup(dac);
+		if (!attr->xattri_da_state) {
+			error = xfs_attr_node_removename_setup(attr);
 			if (error)
 				return error;
-			state = dac->da_state;
+			state = attr->xattri_da_state;
 		}
 
 		fallthrough;
 	case XFS_DAS_RMTBLK:
-		dac->dela_state = XFS_DAS_RMTBLK;
+		attr->xattri_dela_state = XFS_DAS_RMTBLK;
 
 		/*
 		 * If there is an out-of-line value, de-allocate the blocks.
@@ -1473,10 +1477,10 @@ xfs_attr_remove_iter(
 			 * May return -EAGAIN. Roll and repeat until all remote
 			 * blocks are removed.
 			 */
-			error = xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(attr);
 			if (error == -EAGAIN) {
 				trace_xfs_attr_remove_iter_return(
-						dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 				return error;
 			} else if (error) {
 				goto out;
@@ -1491,8 +1495,10 @@ xfs_attr_remove_iter(
 			error = xfs_attr_refillstate(state);
 			if (error)
 				goto out;
-			dac->dela_state = XFS_DAS_RM_NAME;
-			trace_xfs_attr_remove_iter_return(dac->dela_state, args->dp);
+
+			attr->xattri_dela_state = XFS_DAS_RM_NAME;
+			trace_xfs_attr_remove_iter_return(
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
@@ -1502,7 +1508,7 @@ xfs_attr_remove_iter(
 		 * If we came here fresh from a transaction roll, reattach all
 		 * the buffers to the current transaction.
 		 */
-		if (dac->dela_state == XFS_DAS_RM_NAME) {
+		if (attr->xattri_dela_state == XFS_DAS_RM_NAME) {
 			error = xfs_attr_refillstate(state);
 			if (error)
 				goto out;
@@ -1519,9 +1525,9 @@ xfs_attr_remove_iter(
 			if (error)
 				goto out;
 
-			dac->dela_state = XFS_DAS_RM_SHRINK;
+			attr->xattri_dela_state = XFS_DAS_RM_SHRINK;
 			trace_xfs_attr_remove_iter_return(
-					dac->dela_state, args->dp);
+					attr->xattri_dela_state, args->dp);
 			return -EAGAIN;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 78884e826ca4..1ef58d34eb59 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -434,7 +434,7 @@ struct xfs_attr_list_context {
  */
 
 /*
- * Enum values for xfs_delattr_context.da_state
+ * Enum values for xfs_attr_item.xattri_da_state
  *
  * These values are used by delayed attribute operations to keep track  of where
  * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
@@ -459,39 +459,32 @@ enum xfs_delattr_state {
 };
 
 /*
- * Defines for xfs_delattr_context.flags
+ * Defines for xfs_attr_item.xattri_flags
  */
 #define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
  */
-struct xfs_delattr_context {
-	struct xfs_da_args      *da_args;
+struct xfs_attr_item {
+	struct xfs_da_args		*xattri_da_args;
 
 	/*
 	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
 	 */
-	struct xfs_buf		*leaf_bp;
+	struct xfs_buf			*xattri_leaf_bp;
 
 	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
-	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		lblkno;
-	int			blkcnt;
+	struct xfs_bmbt_irec		xattri_map;
+	xfs_dablk_t			xattri_lblkno;
+	int				xattri_blkcnt;
 
 	/* Used in xfs_attr_node_removename to roll through removing blocks */
-	struct xfs_da_state     *da_state;
+	struct xfs_da_state		*xattri_da_state;
 
 	/* Used to keep track of current state of delayed operation */
-	unsigned int            flags;
-	enum xfs_delattr_state  dela_state;
-};
-
-/*
- * List of attrs to commit later.
- */
-struct xfs_attr_item {
-	struct xfs_delattr_context	xattri_dac;
+	unsigned int			xattri_flags;
+	enum xfs_delattr_state		xattri_dela_state;
 
 	/*
 	 * Indicates if the attr operation is a set or a remove
@@ -499,7 +492,10 @@ struct xfs_attr_item {
 	 */
 	unsigned int			xattri_op_flags;
 
-	/* used to log this item to an intent */
+	/*
+	 * used to log this item to an intent containing a list of attrs to
+	 * commit later
+	 */
 	struct list_head		xattri_list;
 };
 
@@ -519,11 +515,9 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
-int xfs_attr_set_iter(struct xfs_delattr_context *dac);
-int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
+int xfs_attr_set_iter(struct xfs_attr_item *attr);
+int xfs_attr_remove_iter(struct xfs_attr_item *attr);
 bool xfs_attr_namecheck(const void *name, size_t length);
-void xfs_delattr_context_init(struct xfs_delattr_context *dac,
-			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 int xfs_attr_set_deferred(struct xfs_da_args *args);
 int xfs_attr_remove_deferred(struct xfs_da_args *args);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index c806319134fb..4250159ecced 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -568,14 +568,14 @@ xfs_attr_rmtval_stale(
  */
 int
 xfs_attr_rmtval_find_space(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
-	struct xfs_bmbt_irec		*map = &dac->map;
+	struct xfs_da_args		*args = attr->xattri_da_args;
+	struct xfs_bmbt_irec		*map = &attr->xattri_map;
 	int				error;
 
-	dac->lblkno = 0;
-	dac->blkcnt = 0;
+	attr->xattri_lblkno = 0;
+	attr->xattri_blkcnt = 0;
 	args->rmtblkcnt = 0;
 	args->rmtblkno = 0;
 	memset(map, 0, sizeof(struct xfs_bmbt_irec));
@@ -584,8 +584,8 @@ xfs_attr_rmtval_find_space(
 	if (error)
 		return error;
 
-	dac->blkcnt = args->rmtblkcnt;
-	dac->lblkno = args->rmtblkno;
+	attr->xattri_blkcnt = args->rmtblkcnt;
+	attr->xattri_lblkno = args->rmtblkno;
 
 	return 0;
 }
@@ -598,17 +598,18 @@ xfs_attr_rmtval_find_space(
  */
 int
 xfs_attr_rmtval_set_blk(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	struct xfs_inode		*dp = args->dp;
-	struct xfs_bmbt_irec		*map = &dac->map;
+	struct xfs_bmbt_irec		*map = &attr->xattri_map;
 	int nmap;
 	int error;
 
 	nmap = 1;
-	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
-			dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
+	error = xfs_bmapi_write(args->trans, dp,
+			(xfs_fileoff_t)attr->xattri_lblkno,
+			attr->xattri_blkcnt, XFS_BMAPI_ATTRFORK, args->total,
 			map, &nmap);
 	if (error)
 		return error;
@@ -618,8 +619,8 @@ xfs_attr_rmtval_set_blk(
 	       (map->br_startblock != HOLESTARTBLOCK));
 
 	/* roll attribute extent map forwards */
-	dac->lblkno += map->br_blockcount;
-	dac->blkcnt -= map->br_blockcount;
+	attr->xattri_lblkno += map->br_blockcount;
+	attr->xattri_blkcnt -= map->br_blockcount;
 
 	return 0;
 }
@@ -673,9 +674,9 @@ xfs_attr_rmtval_invalidate(
  */
 int
 xfs_attr_rmtval_remove(
-	struct xfs_delattr_context	*dac)
+	struct xfs_attr_item		*attr)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	int				error, done;
 
 	/*
@@ -695,7 +696,8 @@ xfs_attr_rmtval_remove(
 	 * the parent
 	 */
 	if (!done) {
-		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
+		trace_xfs_attr_rmtval_remove_return(attr->xattri_dela_state,
+						    args->dp);
 		return -EAGAIN;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index d72eff30ca18..62b398edec3f 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -12,9 +12,9 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_remove(struct xfs_attr_item *attr);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
-int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
-int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_set_blk(struct xfs_attr_item *attr);
+int xfs_attr_rmtval_find_space(struct xfs_attr_item *attr);
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 98d65d7e891c..d95f229bf97a 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -269,11 +269,11 @@ xfs_attrd_item_release(
  */
 STATIC int
 xfs_xattri_finish_update(
-	struct xfs_delattr_context	*dac,
+	struct xfs_attr_item		*attr,
 	struct xfs_attrd_log_item	*attrdp,
 	uint32_t			op_flags)
 {
-	struct xfs_da_args		*args = dac->da_args;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 	unsigned int			op = op_flags &
 					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
 	int				error;
@@ -285,11 +285,11 @@ xfs_xattri_finish_update(
 
 	switch (op) {
 	case XFS_ATTR_OP_FLAGS_SET:
-		error = xfs_attr_set_iter(dac);
+		error = xfs_attr_set_iter(attr);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q(args->dp));
-		error = xfs_attr_remove_iter(dac);
+		error = xfs_attr_remove_iter(attr);
 		break;
 	default:
 		error = -EFSCORRUPTED;
@@ -333,16 +333,16 @@ xfs_attr_log_item(
 	 * structure with fields from this xfs_attr_item
 	 */
 	attrp = &attrip->attri_format;
-	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
+	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
 	attrp->alfi_op_flags = attr->xattri_op_flags;
-	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
-	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
-	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
-
-	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
-	attrip->attri_value = attr->xattri_dac.da_args->value;
-	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
-	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
+	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
+	attrp->alfi_name_len = attr->xattri_da_args->namelen;
+	attrp->alfi_attr_flags = attr->xattri_da_args->attr_filter;
+
+	attrip->attri_name = (void *)attr->xattri_da_args->name;
+	attrip->attri_value = attr->xattri_da_args->value;
+	attrip->attri_name_len = attr->xattri_da_args->namelen;
+	attrip->attri_value_len = attr->xattri_da_args->valuelen;
 }
 
 /* Get an ATTRI. */
@@ -383,10 +383,8 @@ xfs_attr_finish_item(
 	struct xfs_attr_item		*attr;
 	struct xfs_attrd_log_item	*done_item = NULL;
 	int				error;
-	struct xfs_delattr_context	*dac;
 
 	attr = container_of(item, struct xfs_attr_item, xattri_list);
-	dac = &attr->xattri_dac;
 	if (done)
 		done_item = ATTRD_ITEM(done);
 
@@ -394,9 +392,10 @@ xfs_attr_finish_item(
 	 * Always reset trans after EAGAIN cycle
 	 * since the transaction is new
 	 */
-	dac->da_args->trans = tp;
+	attr->xattri_da_args->trans = tp;
 
-	error = xfs_xattri_finish_update(dac, done_item, attr->xattri_op_flags);
+	error = xfs_xattri_finish_update(attr, done_item,
+					 attr->xattri_op_flags);
 	if (error != -EAGAIN)
 		kmem_free(attr);
 
@@ -518,7 +517,7 @@ xfs_attri_item_recover(
 			   sizeof(struct xfs_da_args), KM_NOFS);
 	args = (struct xfs_da_args *)(attr + 1);
 
-	attr->xattri_dac.da_args = args;
+	attr->xattri_da_args = args;
 	attr->xattri_op_flags = attrp->alfi_op_flags;
 
 	args->dp = ip;
@@ -555,8 +554,7 @@ xfs_attri_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	ret = xfs_xattri_finish_update(&attr->xattri_dac, done_item,
-				       attrp->alfi_op_flags);
+	ret = xfs_xattri_finish_update(attr, done_item, attrp->alfi_op_flags);
 	if (ret == -EAGAIN) {
 		/* There's more work to do, so add it to this transaction */
 		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
@@ -571,8 +569,8 @@ xfs_attri_item_recover(
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 out_unlock:
-	if (attr->xattri_dac.leaf_bp)
-		xfs_buf_relse(attr->xattri_dac.leaf_bp);
+	if (attr->xattri_leaf_bp)
+		xfs_buf_relse(attr->xattri_leaf_bp);
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
-- 
2.25.1

