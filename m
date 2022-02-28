Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C90BC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiB1TxI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiB1Twn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC07CA335
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:52:03 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJHV9010129
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=yluYH/y/nDVVHizcZZ9R5ja+IfwuIadclopKpGEkWOg=;
 b=fAqG9KD5+AW0YeNbLHJ3imoO7U7iqi9dFOscqLbWU/J58Wk1hhhpkcLVrXeF2IvZThkd
 bvsd4RVo8qj8IbwSA6s6ktXf4N82gJgbjdVFiDRte97S+7dfeJxIQ9zE5YEQW+Z3ufKN
 VqMtLKhkz1qKGxHkRv9zlfJiIjI8EIfXh1+FFLwo83sgGXVtXpjjz21U/OYL4l2z1w2c
 ohoNLov7DqdqmPo+5+pmwhLfT3q0+pQDp0vJWkWT7fZl4hHSrmLkENK6hGcOv+M5jB72
 dlty0AfajWHKdKAJLYPbeI7AgACEpSA932PIRHETkxVdEY9F6zkITAz4ddCKx+HzSGFf AQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k40pqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJjsZ5061244
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3030.oracle.com with ESMTP id 3ef9aw0y4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:52:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ks/H7xii0mvxqImeAfqUR8Ynx242ZW6dP7qLGw1K8tt5DRFgiN5hoz4dkQIM/l75zpLOscyxx9zkHkRnbGRoWlLYawT3zVW4TR/B6f4295kH9o3L5UDeDEP5JPWGjab7nNK9cAQQZG5OIt9mtjyiQQl1/RBSexp+n191ZQdUZs55sg/Dw0dm6FGZeg4X4HOaiazY82iOpYUGW5vl9hxqZF+VmuJ/AAT1qBMSoILGmKz+Er9GRTl/YN/MZGyaR/9FsWnixiHDoEyaRrIHA5gMNytfLalrkzP/BbgDOqEdq0zy16HseiOZ3tpe73Kz5x0TNvftHTeYCK0nb0VrmKUP4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yluYH/y/nDVVHizcZZ9R5ja+IfwuIadclopKpGEkWOg=;
 b=FMSIb+7+aFfw3JtseX7Ax7wCZEvP6ICjbHq2AbXkEoPUmJWM1PPfSkfp4B83evSaRW2Ck/In/6Sjc9t96QrEWlgCvZ5lDVuDvkBADJATH57yzfRmbWpg+NCbDkvcGdbXYNB3zgevZlQbi8W2AFbxzIxD9Vsworjfa+Yd3ym6R/jN7qpxJP3o/0Kzg43m0FH+ejtShMMN5Kp/w/tDJOLO36TZ4afw92rXmWigdNZM1xDod/JkN8ogcydwC0PBXFuJI0xwhZLq9KFXAwYjKVr0QXyu79Y8+DYB9StNOpA+r0dxbPjD7XeRbh0c5fnvu5AQPDesQXeusFw9Wc1Oxcgx/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yluYH/y/nDVVHizcZZ9R5ja+IfwuIadclopKpGEkWOg=;
 b=WdwBslDzyR56/E36VnsIa8yAcr4Qj6yKhgCL6TX8Z48cI4YPl0GpKrFIaNuT+7iDhWr6uMPvKbbuYS7tC9CADPsaeygqV9ZEpYXZpWvwNGy9gaDk00e4Dq6OQoIRwkj49GJrO6UXvm0rBR1Ff8Blq7a8sAhSEJCcFSQ/FvhbvmU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN6PR10MB1732.namprd10.prod.outlook.com (2603:10b6:405:9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Mon, 28 Feb
 2022 19:51:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:51:58 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 12/15] xfs: Add helper function xfs_attr_leaf_addname
Date:   Mon, 28 Feb 2022 12:51:44 -0700
Message-Id: <20220228195147.1913281-13-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 666c707f-5821-4a6a-1f7c-08d9faf3c79b
X-MS-TrafficTypeDiagnostic: BN6PR10MB1732:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB173212343EEC65625690C6B695019@BN6PR10MB1732.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BVmDfuJYYWcWLxpssJ/fSlDpwLBQ7t2CIjzt/45s8r1ZEwoZtuYhxYZ9loUO6G/y8w4cjxNAD4F3fLnLh3S3cMIdNiWSg16vuKgQjCb1xJVTXeuhjmo/TA4MM44SyThXjKXcnjfcXj6L+oU8pI0wS8AvBrIuZ3J3QOB+RIzTB4w5bjoQ6MohLNXOymegq/4prniVv7nuRFTJw3lxqeFxK//bmtQNAcsHmQVi1rrXTBcXVwH5CUqT3P1n8QzuloYj+Z4K0eCEkViBqMt4GN3gIbfjhpWCuPI09H9sr9BNqEm7lg/fZHIfKmnleUuH/h/J+jWNG+1ptjmDxPXDdsypRlLMt+QpaFyLS8pjTfTZhsvwUtfmUIB+i8c0XJXwl64tAQJwDshO/LnZMpDSQPK3FOfUdCoqt0zmUqTvdG0N3feVBgZa9+quJHFHvtc590vy9NYHGgYozqOiJAl2+HbvLy6TDVz1dvnERJeGlGe0YC0ezBo53NsqGmpbgmTYka3CaHH7/9EijrczTMVUzRP8hhho7xZ1eExs07wvx5QZHrgVSIxopifkQgYIR05OxpZ2zRP0gdxSENlnM4dh/vITYIBQaAIJIifYPz7O5IAiosm2jtXKjFLNEyPJqhtCobHseGTVWZHWg6LA0g1GVojBk/L42/ph9ptdzbJgUQdKt6Iw91KlCpDw9NBDcY/8sZbHipOfn6YkR0d4WHZYaaHCpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(86362001)(6666004)(1076003)(52116002)(2616005)(6506007)(508600001)(26005)(186003)(83380400001)(6916009)(66556008)(66476007)(8676002)(66946007)(38100700002)(38350700002)(5660300002)(44832011)(8936002)(6512007)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9q18ThPQ8zn+lwHyRpy8nY4f9y2hDi0DwlCBViqXWffQkh/CMWpK1vtB7b2l?=
 =?us-ascii?Q?dGiU/nLrw68q1B1cLpD8PZC4ngFC/c4ccSa5QI21Vf6nfOLDrPy6Wmob63Rq?=
 =?us-ascii?Q?rnwv6IQ76o6q/+UucdZmNHSjY9i+z/XE7lXemCs0X9iBFfst12w+k0Z+3esC?=
 =?us-ascii?Q?+mnOt5FYbQ52kHePCaXkzQ3aWJrM4WwKwcZSuoTupub6+Q8TZZ5LeQ6yEgwZ?=
 =?us-ascii?Q?3erA7AH/crma7CvYjP17Owgq2kaAQhaYgdWTS3ueXVryJRR9FwcvJlbiwSme?=
 =?us-ascii?Q?ky9Vmfc6YSClYj/iBYWiSFiNRiqOHPYoHq2E9XxNdTNpDQ+1jqNTfC7uKVBK?=
 =?us-ascii?Q?oC4f7Y0Bvld5P/51Efb0fQRrH5nW7gQV0kqtGFUay77RtE2gmj6+ev1DxeoJ?=
 =?us-ascii?Q?MCcfiPhnuxAZF2WjuFHCiKQarsWPdl/RTDiSV9z4zISz+sjNV3aMIIXpGlsp?=
 =?us-ascii?Q?wHqJWkl9wEjvQfYtNw5+RZieytFcWPa0baaOtBcKYsbAqsTFDVnTiBD17CoV?=
 =?us-ascii?Q?VRxaWa1Dn5sCrtsltRJvGtRs6VxNMdloLHwNQM8pAqZbwAzGMMu0NLAuRfI9?=
 =?us-ascii?Q?YOOYNHo1u3ZaVGxWEPlC0ISZS/+9ad5KEVhzBVmNZ4DJEmwJlV8wbwaStLg1?=
 =?us-ascii?Q?348HmvVdr8ODUoOomfXdcGbwt9asWWaceZYyn+exf4Dk4lXX3RPHowDmpOs8?=
 =?us-ascii?Q?y/P0xSmz3fl5GfHSh02E6ncBq/d9M5JmvzwNReKeB2ELqvKEtMbR33wUZe/N?=
 =?us-ascii?Q?NKfD1Ax9aglnnxAtZom9iyESQs2c+LYl17mSURJqX9yqRFhqyJTuKhi/TZaj?=
 =?us-ascii?Q?mCkzx+ZniL7Ca7e/3Bq51mduh8nNep4fuNvltpa1vHug7LfrxtkA0lhNU5pd?=
 =?us-ascii?Q?u0VGXAv6Sfbar/jw3RpUSmRQurst3V9Y8j1iw43OCeZvYV/619cCUcc5msWv?=
 =?us-ascii?Q?ZgirX+9m8UG/44lojT59Vby/wt52WnPTiLjGoXdeeaE9ZSR3wXrcG/4pTsVL?=
 =?us-ascii?Q?hwp1iEyIgf1zdufI/ETDRSw+F6vGDpKE7O6VuDXBjuwKrCSXPc0gZEu8lNUx?=
 =?us-ascii?Q?7pD5zDEwfG49cqGEhytYpSlhubhw10PNdZ5LWlaLG6/t+PMYSyn9BJRhvyLn?=
 =?us-ascii?Q?uJ5Maqmnh0+TfTYEfkNOjzstTTTxukU2W+URUek43hVbe/43AmWVzpZoEuKy?=
 =?us-ascii?Q?sBQ+9XHe4alMvSglC/uexnFk8MRQirOzJwwNcT7bz3TqecYoL2LHbRb26n0/?=
 =?us-ascii?Q?9WGhtF7jGZgkeXJto45XXD8WMmeovSKT7DTOGMAa7oPqICt8/b2ME+Fc2vrw?=
 =?us-ascii?Q?pPCjm5ehY2CHhYC076WNc+ZfV6oxHZ9K7pBdhZcI07j5OXmTJWCkXxXzt9nN?=
 =?us-ascii?Q?7RBe9/smfkz2hRKtZdpm7eLe0XlZyX/bAujU4gs1kJe8meHvPg0X4dU75OXk?=
 =?us-ascii?Q?M74alOfqC/cbCfwVnyGd0C/dg3U3uj2nAqoxIQwfPeMrZrq5vKThMoKcCwuI?=
 =?us-ascii?Q?qdm0/kpnDol4pg1hxQuVGkcd5KJ2AtyloiMJVISOEL/EiR80bCT6Q+vq3j7y?=
 =?us-ascii?Q?pFlcs0q+YcRh0wtppA9r3h6T3/hi3/9PplmiJVSnUrPKKLcpUih/cxnbNYWa?=
 =?us-ascii?Q?qa6hhUASrMENJmcPT85yANddJjfbqCnJSUBpyUFboAS8K2/WJ8R/Qf4IRJ4Q?=
 =?us-ascii?Q?+fR6FA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 666c707f-5821-4a6a-1f7c-08d9faf3c79b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:58.3870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rt8OEP9zwluT9MXd+lOzZwK6CJw6rflJgZnsvtVuMTCMAsE9uvfkAwUbHh3ruaguqwlgUdRKrsDmZrsQJJ50OR88pLFeRIdYq4JryCL0RKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1732
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-ORIG-GUID: gEsRGws4srB9oZEBtUQ6x8Sp4kc3b9VZ
X-Proofpoint-GUID: gEsRGws4srB9oZEBtUQ6x8Sp4kc3b9VZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_leaf_addname.  While this
does help to break down xfs_attr_set_iter, it does also hoist out some
of the state management.  This patch has been moved to the end of the
clean up series for further discussion.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 110 +++++++++++++++++++++------------------
 fs/xfs/xfs_trace.h       |   1 +
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1b1aa3079469..7d6ad1d0e10b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -287,6 +287,65 @@ xfs_attr_sf_addname(
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
@@ -322,57 +381,8 @@ xfs_attr_set_iter(
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
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4a8076ef8cb4..aa80f02b4459 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4132,6 +4132,7 @@ DEFINE_EVENT(xfs_das_state_class, name, \
 	TP_ARGS(das, ip))
 DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
+DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
 DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
-- 
2.25.1

