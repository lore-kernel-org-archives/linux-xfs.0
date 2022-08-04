Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4152C19F21
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbiHDTkq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238778AbiHDTkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B1F12628
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:34 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HbVvn001430
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=Q1GgKi/zi77NXRJC/Ns/LZICDR4IYWS8LaobQuzV9W8=;
 b=BvJKkRXO7n6dZLMPf+56zdFkAW3OnyKAIWsEbiqVKHHMBHEs6DgFS+IWU2Mb5wdtVZCv
 BJOzi2F4Ti0mwb3FvI8ST79NFwrW9mEtH0rtDN/NcoGHKGfhl27yG4uDk67UbuHDslg8
 6WhpW0zpv3S97ipU2WxWqodX2Pi2Ifqm22J5N/O7OAIwsy8wfnOd8F06Kzo7WMDJWkRo
 UgQsXN8cb2HwQWQ8iN4BDh5bwBvcOHLUKTXaVosY0eEVr7O5TreWnS27NIyrP87EC+wa
 ggXo/h0h9QotHsj9N7HyYCTqg9QhODhVZ5DYazFTaYrAlfFr9+Uawt7PLwwcjtZLKR1p aA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2x31u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274J7Jno030850
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34mm40-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7JJn/llPWG+ByGIEj+muWmPVgIZKhhMMRTD46fjAtIfHcqbarlwDWf0mY0JqMAsOCHqOTSjrY2KdIskFZ6fgOyxGk3buC7xXHVJRqEFvYjnCLzVGeZ1FCMRVFXG6OR/DAr/2CcASu4am+6eYC9QC90L+APj4MskTNjTN17BMSGWYW1voSc8rAq0ojmxIJJLauvXPqlJtUCIZgTW08UYLmIB2HucIthA/iF+s3KgbW4K0VY799ftP7gnkqaCk/eMqGq7ejkYPeBd9hnaNWFzg7t9g86k+EmY2i+GAEHYvAgIG9B9vKV4WF2lmEEQodCglfKwsocGRw0hbixu/h7i5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1GgKi/zi77NXRJC/Ns/LZICDR4IYWS8LaobQuzV9W8=;
 b=Mc7gT5XsQC9naQN/gvdxWXUkOsCSuET75Co6z4ub6je4ubm8uES0GeumOGlgP/INg8PES7GQ5YVgHmbmQ+RRP47nScbqY5BMdy3zO3orD4UrWFSaAAdb783f+N3cBObKVqu5gUYLkJO642Hg1peQMb2p7MzpiDSzpIUHFlTb30LRyPdiHofvAwsiAIC/nZ1YVg9VF7/BhsRfkWPb9+14A+RBvCA+2jP2/QxzqMzomyBC2BrUPgyqR/JhHzZhLyvdkAaXXhzEMc+I40zK1sQ9s/8gHucnNsYjita45phoYsOQKZurRus1FLGzADUYQicPsXZ/LLCjtekRkrjtebGrUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1GgKi/zi77NXRJC/Ns/LZICDR4IYWS8LaobQuzV9W8=;
 b=E8aUsQPtXVv8Ug1SrUlIhCMiEUWKJMmAUnBkR/tKb7pr8sESqQXALFxiDwlkL5MYX4OAIxo4rRnhpmHNjVQH7ldjk7ZVhi41tw+IQiOOYRRoiVM2aYQxZ1uTd2OgzgwnSb/TPvdIz26UgbFhmoK18NKQr7c124Jda7GmgwY2znk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB5011.namprd10.prod.outlook.com (2603:10b6:208:333::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Thu, 4 Aug
 2022 19:40:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:30 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 17/18] xfs: Add helper function xfs_attr_list_context_init
Date:   Thu,  4 Aug 2022 12:40:12 -0700
Message-Id: <20220804194013.99237-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804194013.99237-1-allison.henderson@oracle.com>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 116ece3b-24e2-4217-96de-08da76512e79
X-MS-TrafficTypeDiagnostic: BLAPR10MB5011:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yO6YE1VG6R5VgctLtNTEnlx0Nr1zV9XG+I8i5KHG6ts6s4hnsu1w9stK52ZHMnRRqI4XJMt9WZ48/j2AaqRHtDvxPi0sY5UF4BxUcKSzFIGYVecAjyGZxg4HLCAGdvw36pu2aaLmYCKcS7RgjOlukG5ajFSxD04YnaPBtLhkSdX6wDdsKYq2qDEhOqfJmQLgqHK+4rVUP4/ryToIF+iMCIF2+UBW1QVQexMtpXOMecKYOdEaqlPNgzUN1XV+YwokB5yfvUL4o+tqWj2xVI6LfHJ/x5BWiT9Pg1BRwLk20J4F2tchtrDhSvpjIxy8vQPZbud+Q4d6epfLZdxIpV1D1WnoGwN2K/MC2dyvl6/B4xDdtZZM5GsX4K75uthhzJEUKC2upxJ/KX3ATVx1iZzKeyMAtptmUWLsev0GHzsbkQN7xJ73vUXx7c3BNcDjLwvw+Vy+WYAI8EKNuXwlTm72xZHQdR7j/OlwlDwd1cn2WOJN1Aq7VKC1H2wGs/hJfKarMx33/t4qDwXMRzaLZqx+HDvtLuOZ9bAkPF+XyUmKh//4Or2nfGH1ViGgbPPpjiSxD3mS+HhRKz/+UCJ6xOd1fN84oL+/v1WAeGR6yq9hspIMzOLAgGGI2BCjGeYuEB/uI09bF1j1iIqLq2S72aSLFNY7cH6oZWDrFFKzfIh2zuKN39GTy4AQKwxDe4EKfOQ+gOeMqB8LginEEnCoGbUcdsFk5uU3UTU2C+4Jm/AYxFY5fry9skh8YbYWmUJ92zyVlguPTKGPZCmjjcThwQlarpbqjmc/xQImb9IgYkz7uJ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(136003)(346002)(376002)(6666004)(41300700001)(478600001)(6506007)(52116002)(6486002)(6512007)(26005)(44832011)(2906002)(36756003)(86362001)(6916009)(316002)(1076003)(38100700002)(38350700002)(8936002)(66946007)(5660300002)(66556008)(8676002)(66476007)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A2fbf1xMmvBIyzQCoTYnf+jsu3WLOrRIyH+6YRvslC/M2taMdOuuy8B7nOyd?=
 =?us-ascii?Q?HgkwQLRpi2UDXxvA+VXYGQ4ws1xq0ZQqCI464ktomOVxxWpcEhNJ91BL9fvC?=
 =?us-ascii?Q?RD4rMo3TsE3rlEsiAqpSUbqnAJVzb2xHnmZ7VXBluXasaVftDK4+SPfjbKGr?=
 =?us-ascii?Q?Ebaep9KWQsPV+Cr4f5MHHG6vknOPX166cwuZ7EqwVVYN0ndn6DXV3gqJSEYR?=
 =?us-ascii?Q?VS4XHNygNtAHsRVrKIfJaiIaHOkuDSb2p5p7T59DgnfrCaACoJWqY5awnvrw?=
 =?us-ascii?Q?lVXNklbPk3p3URjXs2WjFbxieGJkR6VS/jWdYOi2VCLKp7DybrWeCGatdRFS?=
 =?us-ascii?Q?FNPbo9igFrB7IDU2IAzq1OM1Ht3kjZCWlZwb39yqvUYtAva6qrn8lYsiix5E?=
 =?us-ascii?Q?UpblH3P6kLcB9HYJOGoky80Urq2gyLzukMrOM71S9rsTTZU3VYwuZ/WzAJ+C?=
 =?us-ascii?Q?8AbOpJydYTy4/+KtEGLsfm7TdfgdzxadsxP8AJssyzDDn3080yy52ASOPj5t?=
 =?us-ascii?Q?rekFy/qn8phtuOcqXYxEbW7T6+UM6IPSQQCv5qkkPGHv6jalNvAeg75XstLq?=
 =?us-ascii?Q?exa599hG91ZV7s8EOELLc4S4iCNVstnSfmZHusUjyNnB7o4YhHIbqhBTJgJk?=
 =?us-ascii?Q?qDO4Fmc0nl6DzdzalcHI5MJSf65TcVE9yFUuZOT5bqMogRnK4icblZ8PcvHn?=
 =?us-ascii?Q?3vWD+PdZtmcf44iUxsvFPqtj32/+brtlFOmVrNwRMLDhN4V9Acvy+lkBis0f?=
 =?us-ascii?Q?MlDM1mvl2vgDvB67pNs9x5IKUHzcB91ZL3qDvXupT3yvCDh3UN+R9TXm8lJY?=
 =?us-ascii?Q?2yCY2atRD5cIGdXK302LlubaqipHW8j8PmnUm4AiRayhS36DYpvVdN+MfM1G?=
 =?us-ascii?Q?SKv0xGZDii6jo3dDRKfXjql9rTX6xu+9SgWPvnx6qkmJuQzPi/8vk5nZl2P4?=
 =?us-ascii?Q?siiSfwxycZ3sM7qUnOTxu+O/zZ2eV6ZcK/O3p4S8iuT6tWs0qlEkexo4XXb7?=
 =?us-ascii?Q?3mKTkmM8oznzB0RJnQhc2sVg/tZOtIoPhEQaaDvgpanCK3UAQkDLbf7Oguab?=
 =?us-ascii?Q?6/KwMIVV9Dj/9xp6222ot0Ao+ABeC9NOxMOxXa8y/tDpI7Z1j8KSuF5qokRd?=
 =?us-ascii?Q?UuGwPdbL0Z8aMqXfeIO6CPwBD1U2a1RFdrKI+BcXG38xtdGjXm0E9X4PnlEE?=
 =?us-ascii?Q?dE/kXTGgz5Ts6lHtu+hyRIuMIN6sDzK1/1Ryf4ByXf/oXdUquiHZo/wXMRhD?=
 =?us-ascii?Q?2dhZVC9eiWu4i9CUEGX9XqfBErCUTEDdcwCbIetzKYdmyusjr2xvGEg/KGlV?=
 =?us-ascii?Q?K+C87N0zO+BTKJF4KTnWu/UDT41zs2Zvh7mX/dItcRvfH+bncgaKQA73rEDl?=
 =?us-ascii?Q?/XGjvqJw1hJ3Ab3ySGrW6CNvtoJnDcWT8FAa1Fs3GeTqNJhUAuTH8YGpkWBC?=
 =?us-ascii?Q?n84abpmuhDlzpctyPfSAFA0IOTJzKY9h+bcIx8zwO7BGDI+EoEP9V4DQaxBl?=
 =?us-ascii?Q?hf2F3oJymQymKtDbn9MJCPqAc81SBkc/DzzMRSdWE7ahX8Zv3ymzE6bDXXan?=
 =?us-ascii?Q?yMDgQuBrfSxiXLAw+38O+AjcDSOisd5hVm75NGQBeG9zNuhRoBK6VkjEJ1bU?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 116ece3b-24e2-4217-96de-08da76512e79
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:27.1745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWfc+haJrNJL8kWV0cIMwcjC/peispNll3zo3sles4sx2Z7A3lE7KgwHwkDuf5BmBQQtz/gLH+iq0UE+UKZhq350MJbKZ6wRM3P64157RDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5011
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040085
X-Proofpoint-ORIG-GUID: aodHXnzPBf8TK0w-5KfhzqxGM_Z_gtwk
X-Proofpoint-GUID: aodHXnzPBf8TK0w-5KfhzqxGM_Z_gtwk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 5a171c0b244b..7a54887cc37c 100644
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

