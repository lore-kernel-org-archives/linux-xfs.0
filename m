Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B200C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiKGJDo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiKGJDn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A878A120AD
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:42 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A78w14m013639
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=iBWgTidIg243fVrCpW4A4ODifWUh8GXxnsTSYeGREiE=;
 b=pMOW/NHCRDCTs/1XoS7G5rLTjy5Mtcuc2clmYZtLLON3XdjsswUDaSa9HY1kEJXUVoNx
 CSobZnPmXONdCgQsrxwMbzhfiFBVwAEaMkNe8dnVcbxnK53KqnvKuFNE5E0MkltWay4q
 aqlyxBRYzyBOofkbreR8xNido05JAiBm9Ltv1yDyYzgIpNfHlVDyIfRiHeVhMvXo4sl6
 /mKO/JF3l+JsXACdBXmflGeLMPD4FtF3yym1ndmM0ITT9wP7LQui3LI0hlCy3eFM9y8v
 Py4wd+Xy8RpgEUdZkd7/jjQXZFMFtXris5Xqxu6VHxyoXh3W4bxhEd0SX9jc2MlGwaIG UA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkfu7vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77ftub001503
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq0jm86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0QPOqBRO2SY9QY7mNVSR8dD2SbSy5E9QBmGQp5w0VGrpxv9YKEzlPAELsqPJjb/FZWag86CjToJQ1R+stZKTSOmp8qhaSv/KVVpYdAWkx5aLeDqfYZq1DyZpAvJto91p2g8e6WIy31nJG/o+PND2FxhdlOh3i0TnV9XH+Vj5LH45LKLCdaETcRedVNY2W+Ll9BDXQ7PPilg1EO05mCD86M3gYN+gN47q52r7+J+t3CleCxAs0V1H2GJi5L3zKGLmTjaWsbvvOEM6Icmvcr6EgIjlnS6q4VsMDr8GRLBlHNXxoBANbf0824hDH5dBV3RLhjrxY0fwIT3TwvH4esWfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBWgTidIg243fVrCpW4A4ODifWUh8GXxnsTSYeGREiE=;
 b=SFiIh/o6KboEmFNJymudyuaW/YnVhBl46GsXqhpvpJ+NzuwvGObJDcvR2Aab/5iROsEtlwGtnQGuh080BMd7X92sq7Xk0kOs0HuifI4HqBxvQcxNReWpOlAwtPQvuNTa8Xsrj9h8T1f9pnxMCY6D1NifJ0rXScbW4xYdzDCC/2W6uy6tCdVnSgk7ISr9nEi0vYDTXezgsDcRY368OEOmk941iFctoN97dy6sMpkS+FmzrEKK/0vI67uTEfkluPGVWcghxmyu+yE3ubDMQlP7oUjoBJhzu6LMM9pSercEgfGs0uiiV3l0lOLAAcY8zFqCGzH+R9nAH0fRJaFLlszVkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBWgTidIg243fVrCpW4A4ODifWUh8GXxnsTSYeGREiE=;
 b=jn5tqoL0iGWR7aYXdxw/zmmqTwOkca8qF0ioHq4UXer4yWxrf9UdT6iujUFQUXDM7JFqRYG9JZ8MxGTgi3q5G6jt8gsDK9pcD7/8iT/oMmN5gRSHdG4etLOeLPBPYddTICZsG0bna66HRC+o1ebAnFcfeaLdCvDrQUNJdZFqyqU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW4PR10MB6346.namprd10.prod.outlook.com (2603:10b6:303:1ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 09:03:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:27 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 22/26] xfs: Add helper function xfs_attr_list_context_init
Date:   Mon,  7 Nov 2022 02:01:52 -0700
Message-Id: <20221107090156.299319-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:a03:332::9) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|MW4PR10MB6346:EE_
X-MS-Office365-Filtering-Correlation-Id: 24c28de9-5f4b-40e4-e922-08dac09eef03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LWp4qC9UgqDTBryG6dRyESKpJqTA1+w7brXGQ/r3iSrQKcNzsxhm2c8t2klA6YiN+rYm9mxZlYkNE03TqWyWUWTmFfZyMhxnqEoZQlggxDxm+RdUaTB7w4OYsp1fJV+oElvKrBXxfODZUbR8fvT6QECvJs9m3//ZHbTg3l/jbR5XqBB7DPfLLPXn3NSspWv/cIX1GERcFiKKZnmBAo0pVFFIZ8ldHRNvBiuXG1S9I3g42yrB3/ujBQBl/BuL6JBVQb9ppp0DgYB91hJ7n23a9on/80Bdtlgb/cI+MsKOwfTlicmgzl/l2HoNLp1NwIEX7PYSVHOjSel1LKAIiSNxP3ImGaZycEI0JPKR5lVDLql02kIsfYcd2DJTxIapsAjfUhPsZBH+QUjcslxo1px+9kbXftXdC92noUHLWwsBncG3Z+bWx83ZwE9ZY6FUxcft6KOngz6ew2p29uhCmRm9qCxYZifl1kvtaYLfPVBEQ4I0yf2gPoudpT3u/ZTH+gG5nc/tvhcjG6YC1LUGcr4pisC3yxMIN1cFgzLDoKgy5RU6N0njeACa0biaKMWw2WLrqCPEXd139kxyOLe3LPeGgFY0OlYC3BnHygJlICHUQ6j9Ih8UQfVNmYT9hCFl6AkcUrB4hq4Z8I4Dd2Tc+CJrGJvsXWVEUJ3zB4yaPe2snbzczazH22IWUpRtfWmUU9QYYRD8kNvW6yNnu+kOaNfyog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199015)(38100700002)(6506007)(36756003)(478600001)(316002)(66946007)(66556008)(8676002)(41300700001)(6916009)(8936002)(1076003)(5660300002)(6486002)(2906002)(86362001)(66476007)(83380400001)(2616005)(6666004)(9686003)(6512007)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p79FXyXr4AAh6BWhkxwdr//bPGuwgb7wscnxQHGq0Bkgi/rzHUcxvnxFvM2E?=
 =?us-ascii?Q?9BT+TU6KmLRTI5dBA8HvKTAMymJUjxAOeWooqIlR8zIQl+t1YDJsZeopq8Bh?=
 =?us-ascii?Q?0qKdHCHSLyEJ+htrga0eAMV03WrVq6jBcj8ubS7Yq+12E/F2MFsCDh76gIDU?=
 =?us-ascii?Q?H0Y8ff1Li7C4gqnXa2wCuydhVuq4jguoVLjQMBXf6DfAim7yJdfdNtlEkOOr?=
 =?us-ascii?Q?JNlV5u9LANjTFzX2c33mjf/X6MylyvPIKj7NFnfDFVxYwb1YehJShQ4fxDW3?=
 =?us-ascii?Q?vAejVHeo+QcpAOf+zsr0+sVujKKPppN9zQOEFCF1PoTTkKVZCRPCQKCcAo1b?=
 =?us-ascii?Q?BBuv2I3weqYmheXYPphEdcPNjSc1J0sNgnRnniOU0MdPjZUTil301QsclyMM?=
 =?us-ascii?Q?HrW0ewB98m/aGF3gel6MNNygJPF79mLHlozOR/op88uTrw2/bw2BdeG4Qm9w?=
 =?us-ascii?Q?eZFV5aFs3EvE+g+tWxZXZ3zj3zZyYcbYBUJ946/PVa5xdAoANu9L4tilhimi?=
 =?us-ascii?Q?nxvBrKpIZJCAnZkpOWzykVKn+RTNgAnsx/4pJRgc5TQh2ghMvBh/wUlaxhVW?=
 =?us-ascii?Q?V+u4CCmGaV9D3J7RDRT4qmv9b07GNnyo2htpIqCY3JXZnB+Fpawa8CN5Lqmk?=
 =?us-ascii?Q?AleNMjdFBw5VnmQqNhopxB1yX6mojltAZpc2GYEJCr/DLP3AKgV0Y8eJIgc/?=
 =?us-ascii?Q?QDoQql5FeSVGQhDxgJOPldj5xLwMbUcUcYVCsSsBng6qK2DNS3+UabkgAo+O?=
 =?us-ascii?Q?ehpZJbhXq/mhhuNO+KqHLeJO49q0eWSxIfhAf90ysab0tTxCxotSvoaFAcc+?=
 =?us-ascii?Q?NAzEGN8WsvCzxriB/+R+a2tc6maZ6QbgAmh+V5rkoptKs4mOtgbcY9WhnLl0?=
 =?us-ascii?Q?D8t02GAFNfz2intBehW4xrYsCJPg4cyKFOxFrZZauY1TQQE9nxOK4nV1RPM7?=
 =?us-ascii?Q?7UUvtdpr3c6Q97PXiQy+dH15m21oew9NOhqRxsoYNKcjC1kEfoQwRtI/r1Xy?=
 =?us-ascii?Q?AzmsutI6shmfL2mK7yHaqcAUY19uC28QILsjekS+rw11pIV1In0B2MHRMvl+?=
 =?us-ascii?Q?efPzm6d6TGTdjOh+RioLFbNVdDsONQ14qLWhcKt10J94XTP3JcYL8H4JtcXv?=
 =?us-ascii?Q?A61KIZRAMDRu7pAa+hb4DJ1JRyGifBJhZcaKSecUpt3M1LYlz9OSNll4Y9S+?=
 =?us-ascii?Q?HAyQGxh8YLrJkli2dfx54ii4xH19q7v3D5U3aih1SSlrsOV3TbW9QE/lm0uC?=
 =?us-ascii?Q?zNVNd0/7cj45pSW9a0kBqeDdAmbfY23eUvFEbw1dOh3le0bbSLQGG/Lz/wfm?=
 =?us-ascii?Q?LlV/oayvUMo0VG+piZkoRfT5EBn1NIlM2LXepc0JypsUdqr9oO4wxycglgjL?=
 =?us-ascii?Q?elh5sh705yxocVGHD5tuVyKs1maSVrdUOTpLkE046+DMJf3iu7auWHwQSWxb?=
 =?us-ascii?Q?/IrX+hqHqpDvYOFPeQvbqPEXcHtQvQMQkGQQOE3nkMtU3j36+NXxtxgFAm14?=
 =?us-ascii?Q?Oyx3K34peNEl6wZpZQ7kpophQtofnMQUqqcmP8j1XVtkVFrJ2grKhnLSxwTV?=
 =?us-ascii?Q?+AOO/PJCLzk/VU35S7wI0774jG5SPBRvUt3i1J7y4/6gYVnF4DvPXOpBnAEf?=
 =?us-ascii?Q?Ww=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c28de9-5f4b-40e4-e922-08dac09eef03
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:27.4516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+WL847dbprMhnpp2EIhOqEDS4EPB11smi/QG4ykR/ybUyR8ZW6N00qWcx+zE1HlWAvfv7mljFh5hcZsQcCZd4Ues0bLscOi5NBaxkMmTgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6346
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070077
X-Proofpoint-ORIG-GUID: kmx5CWvPg8FK1DpjM6ATXahAc0ztMI3T
X-Proofpoint-GUID: kmx5CWvPg8FK1DpjM6ATXahAc0ztMI3T
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a helper function xfs_attr_list_context_init used by
xfs_attr_list. This function initializes the xfs_attr_list_context
structure passed to xfs_attr_list_int. We will need this later to call
xfs_attr_list_int_ilocked when the node is already locked.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |  1 +
 fs/xfs/xfs_ioctl.c | 54 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_ioctl.h |  2 ++
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e462d39c840e..242165580e68 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -17,6 +17,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1f783e979629..5b600d3f7981 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -369,6 +369,40 @@ xfs_attr_flags(
 	return 0;
 }
 
+/*
+ * Initializes an xfs_attr_list_context suitable for
+ * use by xfs_attr_list
+ */
+int
+xfs_ioc_attr_list_context_init(
+	struct xfs_inode		*dp,
+	char				*buffer,
+	int				bufsize,
+	int				flags,
+	struct xfs_attr_list_context	*context)
+{
+	struct xfs_attrlist		*alist;
+
+	/*
+	 * Initialize the output buffer.
+	 */
+	context->dp = dp;
+	context->resynch = 1;
+	context->attr_filter = xfs_attr_filter(flags);
+	context->buffer = buffer;
+	context->bufsize = round_down(bufsize, sizeof(uint32_t));
+	context->firstu = context->bufsize;
+	context->put_listent = xfs_ioc_attr_put_listent;
+
+	alist = context->buffer;
+	alist->al_count = 0;
+	alist->al_more = 0;
+	alist->al_offset[0] = context->bufsize;
+
+	return 0;
+}
+
+
 int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
@@ -378,7 +412,6 @@ xfs_ioc_attr_list(
 	struct xfs_attrlist_cursor __user *ucursor)
 {
 	struct xfs_attr_list_context	context = { };
-	struct xfs_attrlist		*alist;
 	void				*buffer;
 	int				error;
 
@@ -410,21 +443,10 @@ xfs_ioc_attr_list(
 	if (!buffer)
 		return -ENOMEM;
 
-	/*
-	 * Initialize the output buffer.
-	 */
-	context.dp = dp;
-	context.resynch = 1;
-	context.attr_filter = xfs_attr_filter(flags);
-	context.buffer = buffer;
-	context.bufsize = round_down(bufsize, sizeof(uint32_t));
-	context.firstu = context.bufsize;
-	context.put_listent = xfs_ioc_attr_put_listent;
-
-	alist = context.buffer;
-	alist->al_count = 0;
-	alist->al_more = 0;
-	alist->al_offset[0] = context.bufsize;
+	error = xfs_ioc_attr_list_context_init(dp, buffer, bufsize, flags,
+			&context);
+	if (error)
+		return error;
 
 	error = xfs_attr_list(&context);
 	if (error)
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index d4abba2c13c1..ca60e1c427a3 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -35,6 +35,8 @@ int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
 		      size_t bufsize, int flags,
 		      struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list_context_init(struct xfs_inode *dp, char *buffer,
+		int bufsize, int flags, struct xfs_attr_list_context *context);
 
 extern struct dentry *
 xfs_handle_to_dentry(
-- 
2.25.1

