Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D41FC4321E
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiB1TxJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiB1Twn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD61DC7E4C
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:52:02 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJHtU010133
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=81CiBT3zURwxTjFTY8vMCZC7Ut5ifRzQ27IZt5OPKS4=;
 b=IK8uSiF6Ir0b8BDqQJGlFjclZJGtjbRWl01WCY9bG4DUkCT7eB1OG8WyINMd730WjADF
 YbLQcffFGqCocQ4gpXaLzlDgBZboH0zt6MYZ2foNhTQglEzczjMS1QfnJ4z4ifRFaRGi
 vGxQ5hsj6Ln451zDhOFLkSC7Qip+fJ1FDKn98YQFjN9ZLGfA/XDGbITgR3vKNePCPIFY
 TPCscNjH2Jh3H+7TUdRD2o/lmzXTMxTMinj6BH6uJR3ljYr+GLG6Vet0TZH+4EsmU1DD
 earj8H3i6lRMotldZ3VsVlvY51fksA+EzcfR/zF8byMexRL0dfmYA1kqW4LZhuSSni5q yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k40pqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJkltr076550
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:00 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3efc13e3fr-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aw2yK66JUfUlY2Rm4xGNdbU0Ix5/CIEMR0H8bfRSZsc0cGoJnZ3omHfNr+fYCMHWN8ZxElzc3JXNQbjrliDmNb2szRgbgiziVHympiyqsYIiDYGRyYTu9DR7c5Z5TjfX7BA6es+7+kYiWya1+kgT+7VCVBYRflSTXBRvlC64hqPJc9IGlz5JmHDaq5Q3vB9+fJ0OYNOaLmYGhJ4YOr18/fbL4JKozbU/l6hagOaCWdtuRqeguvk1ekxAajhy2gKUakDQYMXWBlnTb+tub4uBY8Bwk0i+PdqoZMBwPpA4KzvM6EyHJ93Mgfv1MkNTyZL5O5JfZMwq3xLIHgxVTT8gqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81CiBT3zURwxTjFTY8vMCZC7Ut5ifRzQ27IZt5OPKS4=;
 b=Pwu1xmUtCZtb7ARFycaVZj1G9WOVQvEWCwZf1dV5Oqh9xoDoWj0JxuCpqM2yFLAzARbEzUuMzq/U5GbPy9L1J4PXIrysEzQXWo9Pj1vj7S5P6SK33nMJOtn2g8AiZ+8z8AeH7J6zZOmOdFmLHjlDzUP4L97t2ohPqu3Vye88CNxBRFCUdHVi6NjVLsI0z41CiXhhbdAiCqH7e1s5XYmuSGJAGlexQ6WYjelph4oLbaDrlcT8HhjdLqbLkzotQspjb5nc+XDvssdWqKyN8nHYfJEmpAl9uryjy0MiGWHDmZnhdokCqC8xzNiQ2iI0UtbqKrNl8crkVSpKUbGBqyVcbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81CiBT3zURwxTjFTY8vMCZC7Ut5ifRzQ27IZt5OPKS4=;
 b=vm3jbzB7LyQVLJzgx2STNxU+W373nWm+mFJ5/gmjh344pc1joHLESbsV6mSC55SI5ZWlZ+cPmjEXb4PUMntUqUn9KZSWi/huevZv9mcTYdCmN81kVs3bV2GANwVt7EZc7YXfFTDQbrO62BmHhUlskGdWmiZmtPeP8B6aBwac+lA=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 19:51:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:51:58 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 11/15] xfs: Merge xfs_delattr_context into xfs_attr_item
Date:   Mon, 28 Feb 2022 12:51:43 -0700
Message-Id: <20220228195147.1913281-12-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 96de3c17-179e-452e-876a-08d9faf3c75f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5612BB2C12E7B78751762F0295019@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ztPU0ENJp3c/0TB6TtxzR2nYar45zPAq/SZRkei7MV/l5mOsD5xFfYIZo20milU79vzQnj/BxkCwu3S5pqkP8rzWWogZoTYs2hLbCNYDdeH4ffWX33pE/+5LA1Lb24C1GwYT5z6LsDYwd5zBOC7h/1RiLx5sEqtIwzvYXowk0bYNTNY/rWEaLV5Eed9tdCMlY9K4Zlw7wG5NuKFnDYPKYhMChny7+WrobSOT1w5UEYQa/c59bVn6GVh+GkrNlC1j1O2m+TJM7K7z8Ooy9Ql0aOTaouzv537AfwCZ0TRiBsfWl8i66bnJ3qwDVgK8fTvalcLat4D7bVtyhECjlWtDQuPBiVhM+790EpNLpLfLplNXGPTihiyhYir2zozckT8hmnqWtlccNc91a9DxyKRQTtKViQJCbj6QUh5UE+WOFKJtTvEfbXqtSkMBa5YfvEWeAiiSqMx4eKL54D83k4/IOxBNhlTwjz6hdyR+NAEZJEfB7+CSqB8I6+gzfOmSq2bprFr8BecTp1y1x2ZB0MY+fntEWTjYZJhi3SkCNyoOeT7rhG8v6gzucqL14RO5DEgOfYRI1epOiSEGq0XxcPlRvyqeimCHiy2WJ4LWz9Szslp5rP+7qFCMuOmFoZ8n1cBy1gpAKUi7SzKHSjY9N8TIw6xOpHX9e3ZFgEjiM6sN0/Kb2KNBI1fySdsFdr5Hww10POzsKzVRwhbFtOpJfmmIOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(86362001)(186003)(8676002)(6916009)(1076003)(316002)(66946007)(66476007)(66556008)(2906002)(2616005)(6486002)(6666004)(6512007)(52116002)(30864003)(8936002)(508600001)(5660300002)(38350700002)(44832011)(83380400001)(38100700002)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lliyuR1aaGaGrLI60wtuIcWJIK8e5cPKI9WsscUvfQU6v67rguWShb2VCW+p?=
 =?us-ascii?Q?JrwQ//tlPZVV/0pwZAiveAWw4LtOCG88lWmArjpfm5iprNkfo+3ssIPUuShU?=
 =?us-ascii?Q?XwXDBQU1bbcwPMnvy92hXWT4uo3R/xbxvpJQE1XScm2oXybgDa0X94cXjfiV?=
 =?us-ascii?Q?vR8AbiYV7k+dSMrzzc9ecQPSsviHEdYMVLajAq0B3mi2jaD0l9Hzevx138F0?=
 =?us-ascii?Q?SprC0aXTuW5kAQQJhOrTuULWSGcwj5dnyPjji0yrz0lQcqdUwmGMbPs1mprM?=
 =?us-ascii?Q?oj6iN4/fxfTqkOKUHf3mwmso1OL8p9hYWUSkzNr5sEy/l/4TmNROQ4B2gE/V?=
 =?us-ascii?Q?pk7SUlwUMubwLX1euNC5bVku+7FwTffFgvCPc4MBcaEg8Tjg8IlGXOAWfMn4?=
 =?us-ascii?Q?yDW/zaH1cjqbiK04sRMwYfLD1sL7gJQgFxEFEgCtLdpQRN9bD1JANOjp0m5A?=
 =?us-ascii?Q?h3FlNg8DLmiXp2p8AQg9eWQYO05Dzr0V/V+TwwOJkFdIdKumY1x1FSaZLpbi?=
 =?us-ascii?Q?d5Ij4Ijgxc0oKXveC027lGWgrZDoQs7mFdZ7UFN81BW8SDv+uiOxm6JWk5OZ?=
 =?us-ascii?Q?zaoWqLEKxRwcgmRpoTL+GQL7SurVM4WI+PlasLm2vJtNuXlnGyFCnsysWzNx?=
 =?us-ascii?Q?ANJiszCCvvn2C8+nzvO/5qfdr/izVj+TsKcomK15JHfUabgi9ge8J7aIcikh?=
 =?us-ascii?Q?wHRRxxTdJmNf3h7Lc9hwpHwB0eL96/gbNeqb1ojvMCWv9W3I74gT3khCzMLF?=
 =?us-ascii?Q?IKXs2kxmguxz4bIbPJWAD4Ch4aCUdParsnZRZGXMjHXj0Penh4TJJIx4Yayw?=
 =?us-ascii?Q?4MOKzs1GLnHWc+IBD2H12zs6rEoUpbuJuz6PNXL49ePKmFW8nObHbiTwzXkj?=
 =?us-ascii?Q?mIUiwkVh+kmeCVgmSZiKhmugJgzxnFOzKt7CL+MjAraV8tuJaaqlBtCKh2aZ?=
 =?us-ascii?Q?mj27W69XDdiTeYFRpR4CT/yFzkW9peyYhjSX4Y9FnhbNSF1/DSxGh4EjBwMb?=
 =?us-ascii?Q?0T396gUF8C3bgvPihJa12R639zg9wMo6wWleH8SWQ5r9KddEmXHvSkVYR3Lp?=
 =?us-ascii?Q?IDZSeDk+0Jii8z6zgW6V0ySa9Pf0EEdcYf2P5ec9aGiaIqpTn31NHQkvyY89?=
 =?us-ascii?Q?mu9g4GvEv5Pv8nE+Yva1gHC0p0nTr6+5A6hEFoiBJrUMuc+EQoRJ1xRla/fo?=
 =?us-ascii?Q?gkloVeJAgaoNrkNuNFk6q7G7OQYjB/9oxpKWz6wx/NqunBODQLMIrnY4vQ8L?=
 =?us-ascii?Q?lcGBT/8jpYV7dtSh6ox+K8vKqpvlyI3qFkwq+JC4wGPDvepGJP5D3D0ZvK9E?=
 =?us-ascii?Q?6AGN4BRndkEEDk77x9PXF+wqTVe9iUmtUq9IO9SEzlNpLrQrzNO03SjZc9KL?=
 =?us-ascii?Q?U91PeLi9QIWybN2pI+Xwyycv/IIq7Gp+ZIHi5h6mH4g1fzGgj7bj7mEbFJ9p?=
 =?us-ascii?Q?gFcVy2YqahK5r+bCPc9ctZxjipQlS2pDV1QV9/W1aSZSmejPevW7g/qroNku?=
 =?us-ascii?Q?4YS5chMHa5imLpSEZU7flsWPF72Nf7epbtiW1MBX2aUK/+ILwPRtuqYP1Ggl?=
 =?us-ascii?Q?dl1WaynX6U5MBBXUrSfzG/kpnGtAR0505KHoMxKC8Kb73C6vSikPF7a8pfu4?=
 =?us-ascii?Q?6an4NrXpXhlEn07GGGhdQeAMQ7CPrPjlRN2dHoEno6V+bcSTiuco+Zn4QzoR?=
 =?us-ascii?Q?alJE/g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96de3c17-179e-452e-876a-08d9faf3c75f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:58.0746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f9h5uxH7Rd7QzemyZnUq5kaok7AWOI2gaQaD2nd+xGsxANqVT8/eFXpCgAMrXL8u/HMxLlIipTM2IglSuBdHc6VTrukYsP0k5staf3QipRQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-ORIG-GUID: 5vE7JGpLG4ZT-bFpZLPCdeSyRnzxmxoU
X-Proofpoint-GUID: 5vE7JGpLG4ZT-bFpZLPCdeSyRnzxmxoU
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
index 71567ec42dfc..878f50babb23 100644
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
@@ -554,8 +553,7 @@ xfs_attri_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	ret = xfs_xattri_finish_update(&attr->xattri_dac, done_item,
-				       attrp->alfi_op_flags);
+	ret = xfs_xattri_finish_update(attr, done_item, attrp->alfi_op_flags);
 	if (ret == -EAGAIN) {
 		/* There's more work to do, so add it to this transaction */
 		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
@@ -570,8 +568,8 @@ xfs_attri_item_recover(
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

