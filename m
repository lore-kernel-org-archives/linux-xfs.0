Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754EFC433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F31961166
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 09:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbhDPJTM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 05:19:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35070 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241595AbhDPJTD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Apr 2021 05:19:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9Aie2027436
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=44TsAg3cxQSK8GRJbDXZp0fZiSAO/SKRZIfjf9SAVV4=;
 b=PAnWShABisQLwau0ZHTyhLAQJXJEDE2K05JAKUQtVj+gGp9X4vjye02+ZJmZle0jTZKE
 NUQvJrNLPCUS5dpYkAi68MvZGoLD7foGbsiZ5kAovMOlGltaWsjca+vY2W4IEh/Ua8D4
 ApJjBaOTY+9LXOp+HOqiNEuaoKjzDPviEZehOfJFsZ35S4Yrohj4h4yz+ZCeoSmiK0wr
 C8FYEwEprsA/VSE5kDJ0TLjzB6gc6uw6CPJewdWIw5KLRhNVGKW/xqKWKJv4rU2zdMC/
 JLvnoP1TSjTKWpgEm6hwbcusIe41UZ55NX/cCHsNZyI0/uBpjx0eEOtzm+uXY7qPyFaq ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37u4nnrh8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G9AXpY077087
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:37 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 37uny2cbx1-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Apr 2021 09:18:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZtHfxotLpgTI0rFIWANSN+de/FsXv/1wTNTwb/E+c6lSYC3EuQbPAALEdY4v2Ig7PT/Pchshd5WgH6u0tBGVLuu8jYMZgkzsQyK+lW6iSyh9vvTZerlbkXvB5ibeTpWDk/scKETltZ1oepuCuXYrppNgXwuwH1ts/GuLipVKgiTjy1Ae4FC6Ppl90JnyRRV92HKYN0PLkTTjkHt7uj15BCkYkSeiEXjoCv30b8lUEHX+qQqzocJxcDH+zYLnWDktYKYHysppfm52TNSX9bu3mQqCW3hVZOyoUw6wQ+BbQiHvtYWjCj0s9uEaD9+j5LKvNk5lTO+1bYS5PobUDa/Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44TsAg3cxQSK8GRJbDXZp0fZiSAO/SKRZIfjf9SAVV4=;
 b=TryDxDrm8SxhyVUNgnIOHZb/C/k/Rjx2xdJG/pbHI1RxtefVbcQavWFBqzCxNDeeuhAZZA1tYjdQs/gBwaz7TpSgsiuzFWi5nIJZOXrCe7vz1Z2BqU9Drccz4buoj2kwM1yA6R36/0qYtKK9quuOPxQUt/nav3DM3Oj6+UmGVTcuPa2ix8WHBv4w7coGIGYvZvnYRDYnjCFclNYzDwHTTzhqg9bTmewdqyuqhRy0em0PcJFDlJNv9J9uITLV9vDhTqC22qNl17EONPZd/Bs4yVjlRBuF2atCds1xANyW6GVIwTz2VkXYoGQyPutc/1179A+9jMq+zAsbJHeKqxAP4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44TsAg3cxQSK8GRJbDXZp0fZiSAO/SKRZIfjf9SAVV4=;
 b=q8OXB6XpoNdED8M8bP6eUIpG+oK/16fCjvLJjA0f2Cs4lTMe104ikXun6Stfw683QcEbtTb5AliyAnoCVR4CkLF3+N7o2UbozHJrQS6JctG3QeQTWaBc5b5Hs33bFX1DmQZ1x1KLCh3DPIliuYgP8CzCnaSYPv7t17Nx+yZfL/M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2486.namprd10.prod.outlook.com (2603:10b6:a02:b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 16 Apr
 2021 09:18:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 09:18:34 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v17 09/12] xfsprogs: Hoist xfs_attr_leaf_addname
Date:   Fri, 16 Apr 2021 02:18:11 -0700
Message-Id: <20210416091814.2041-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416091814.2041-1-allison.henderson@oracle.com>
References: <20210416091814.2041-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR07CA0070.namprd07.prod.outlook.com
 (2603:10b6:a03:60::47) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.222.141) by BYAPR07CA0070.namprd07.prod.outlook.com (2603:10b6:a03:60::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 09:18:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9c73a78-56e1-499e-9199-08d900b89c41
X-MS-TrafficTypeDiagnostic: BYAPR10MB2486:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2486C66713AFA8EFBDB51EDB954C9@BYAPR10MB2486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cHdmoVV0XNNrJsr1SXMPZdZ44xpm+WpT3xNLn/hK9zFgPT2UkmYSWNC7L9B33Jw5+I4wtRFbZFe1aERKrq44MA8Wb+LvxZKfWhcDhHma1SuT1lqkmFAkqp5nT8+GTIeKkWXOJVjPHL1Nof5vkJIe/m82ll8z1SaxuC11NpG55RXSjXT1vq5VfUy5xgKb/zFu7LwqVhfVuMit35Ei7lFxPcUFlWU3+/4+tD5brnCD5RcnfEnwIDy4zS0h49lYK35i/oiteOt2HLSb/Cz06q45s8lGveb1n5Y2BiHOuFHSsbY0VZ4ljyTGHCSme8whRuCon2CnCd6u8ZCOLrFHmyKt8ILeIWhTDzzle5iHM089tZkH5PfdzfwR8HaNmcU8GFysAqYU0MMpLJyIaZyZtUJo7EmxMU8O9PhF8uIxa3A+vCFjuxbojx6xO51xcQIyKsMuJf2lDLy17KdqRg8AqIpXWVRXUhY6QJ6dHtHzDGX2ldPlZSD9tTeGiTEqkmuJZy/nHphdeQccKwwgNCt/PWsqiXXYbQD56jK4YfCF3fxo83Q+8j7DW+FmwvOhi8C0/YIlbN1cCwupThcceR5SMyrqfiN4ROuTTqKFK4I20HhacqlGoUK/frKBGRwLSzX26wbQg28gGdaJN8B4WJ+THaTe/eNjjF0otd0f/54m72SJ7YM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(136003)(39860400002)(346002)(8676002)(36756003)(8936002)(38100700002)(508600001)(38350700002)(6486002)(66556008)(66946007)(66476007)(956004)(52116002)(6506007)(6512007)(316002)(86362001)(44832011)(83380400001)(1076003)(26005)(2906002)(6916009)(6666004)(16526019)(186003)(69590400012)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?govmplTPUp1NgSmDifca9VNYBFnNW7qoIMfJAIRs5jPIThLKM6VFnTk85h7L?=
 =?us-ascii?Q?+9wXdc0DSeFUr+r4NztlI27bLDJESr0va0VQS0YBc3TBpuZ8rgOX0980rVXv?=
 =?us-ascii?Q?PZOoUlI4JcP2tvrzNU3Z4LHc8oktsA7VOyfXp8g2FOcDFPTM6De/WAFE626W?=
 =?us-ascii?Q?+8QBVh3tYGbXCjdUS/kbFkAuqnmzh06P7/kkQF6l2W0rTk/vnSjFdQ+VuHDh?=
 =?us-ascii?Q?ojJStIX5DoHHx9VLpf7J6yCxFaAQHZrjRiZzRZuPJIdQOT6cv9E/86Ru4aK3?=
 =?us-ascii?Q?Zwqrrcki4Il2uki3200d86+nExWeXZKQZEb84lifAJ9h4OgGpwYK6Q0OrETu?=
 =?us-ascii?Q?Of/0MxfjOxbR6POPE3dnUSn19txb35aBjIVYNPXK5ozJbCYBWieRqRihGc7K?=
 =?us-ascii?Q?Fuqmcw+X40RBBjCO/LbR/w8ZMaJpLw5HGCHcQi3kP4ClM7lhSyt1uQdrROLM?=
 =?us-ascii?Q?41iW3IU8raZUz+N+dgqz5vLHPVhIaODmEd/uekCqKw9JjhoNJqRCW3abjS0j?=
 =?us-ascii?Q?UmrSfQratvBYH976p4zv2zPvJHP0CussRJM6aPzkGZ3Hpn+moWiZCKicu2OL?=
 =?us-ascii?Q?xRPA25StSh4ZdRF7+/OkKvAv40Z7bAx4zy4cjUMZHNT5WZlXr6nAz8KlcOow?=
 =?us-ascii?Q?a0lD/srcoalO8fGKMb59RaalRraJa4WliZCNWsI5ziwuG0nydzAnnIphPcTy?=
 =?us-ascii?Q?Edl8ui1+ikzYQKNhq5omleY6ZBoyXYeG42RcxAnVh9C+f7xNX3T1YzAXVLq6?=
 =?us-ascii?Q?mdJYlAJeqnA+C+wZzLEpm6RYbPLTV2YDYfrB36nR1r8N4OC+eZ99JA/5freI?=
 =?us-ascii?Q?mC2ghyJ2+Oi/uJhNvNyoVRSVHHgC1VTulovn3WXRq6+nYpvwU/hW5rIucJbd?=
 =?us-ascii?Q?YPm3XHxu1U8JZVLjmSuzEHKl1BkjonAuISqrSiHwonhGc/+Gl7u7BJCNOzPK?=
 =?us-ascii?Q?SfYslsry/bRet/S+0RXK4VmsXuQOPIQgexT9mStt2/Ak74cfB7ULDvD+rcQe?=
 =?us-ascii?Q?SNHbsjKQeCPFNcXYWbHyeni8gcKlwFLtso0ys5wu3tvFyaiBpnArKxy5Z0q1?=
 =?us-ascii?Q?uQdH10V4R632jM1zHJzfyZgvli9m6VQhxuVeodyRxlC5x2lsMNuoXbX1FE1s?=
 =?us-ascii?Q?Iy2qMI34HGgg1bsMTUu7jX2r7Uy/4IPSRxFST8x5omB4BTHmGgWALFxOKLRG?=
 =?us-ascii?Q?GXWQHVYGPkFjaYUjJeQvlS+96ujhIFjbC3eBUSQLjLSid/xfV+5Bn/z8e5f3?=
 =?us-ascii?Q?kvaVNlmSf4hW4kHyN2fLodU/Oa3K9MTRNafqtRRJ9qAcnNdZ8kg0MtN8oe55?=
 =?us-ascii?Q?eSqOi30g+83FEso+xoaIcHuK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9c73a78-56e1-499e-9199-08d900b89c41
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 09:18:34.7062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IOeFKgLf1YvWZW2ZizpwR33EW6rIPnvQ8bpuqIro8N8HlKdYMSZkNgF4sPsOdnGYgL7eXcY424LyRSkWv8muxYAv2Zh2IcXjMuuxih7F+Sw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2486
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160070
X-Proofpoint-ORIG-GUID: IzXIbwp1XjqZ3But3cQ-F-evqGiAzeWt
X-Proofpoint-GUID: IzXIbwp1XjqZ3But3cQ-F-evqGiAzeWt
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160070
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 45adc55591f5d91b9b6c7752fa4253bf3de33886

This patch hoists xfs_attr_leaf_addname into the calling function.  The
goal being to get all the code that will require state management into
the same scope. This isn't particularly aesthetic right away, but it is a
preliminary step to merging in the state machine code.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 include/xfs_trace.h |   1 -
 libxfs/xfs_attr.c   | 209 ++++++++++++++++++++++++----------------------------
 2 files changed, 96 insertions(+), 114 deletions(-)

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index a100263..fa4d38d 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -148,7 +148,6 @@
 #define trace_xfs_attr_leaf_flipflags(a)	((void) 0)
 
 #define trace_xfs_attr_sf_addname(a)		((void) 0)
-#define trace_xfs_attr_leaf_addname(a)		((void) 0)
 #define trace_xfs_attr_leaf_replace(a)		((void) 0)
 #define trace_xfs_attr_leaf_removename(a)	((void) 0)
 #define trace_xfs_attr_leaf_get(a)		((void) 0)
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 95e4875..18a465dd 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
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
@@ -271,8 +271,9 @@ xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		*bp = NULL;
 	struct xfs_da_state     *state = NULL;
-	int			error = 0;
+	int			forkoff, error = 0;
 
 	/*
 	 * If the attribute list is already in leaf format, jump straight to
@@ -287,10 +288,101 @@ xfs_attr_set_args(
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
@@ -727,115 +819,6 @@ out_brelse:
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

