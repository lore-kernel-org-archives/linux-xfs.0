Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F29F9C07E9B
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE9BD61CD6
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 22:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhGGWYK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 18:24:10 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21478 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230033AbhGGWYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 18:24:09 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167MKbZ1024355
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=kkGi7yVBb7BbuK4IOklA3IKfnCFcVx1TmQ0mF80VyYw=;
 b=xds/eiORRamjgldvhp7VILUBZFmFrjmXELZXAGjGVCJsBaiRVRao4e1yLwWbFJPzoavA
 bwE/hOeK253XGEog+zJqXrEg9x6tzFjuAed8ZxvizTaJOpL3DrByXwFH+7Em1D+oYbdl
 5Srj8OUWqdBvZd1wdMmHl0KlQhpYJXMGQKqcGThguCpuvsOpvIW+YmGbhS6zpKE3+I04
 +hKUIYw5wY4sEyIFm8tq5cs0Dwr3gHGsxvGT7PwVxzkBYBpYzNv4CBiIvUUP+oVLQSwo
 /a9tm2HX/EgFs6ZDU1nKUe/bHVH4Ikzr12DjffJDRXrKsLxcC0oI85gkVQaUgZxZwqtr gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39m3mhd4ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167MKYSf092507
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 39k1ny0hp5-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nli6X8k1hHzutLXfZ5R/MQusM8PgscQKzfJp16XqnHsrAyCGt0Lybq5FZRPfPnV/ogOaop6qCTxXPrA3hJOrd+svHh8Cd7RGVfNrZUteeXtI1MWHPMneUVJc+rcyoe08sTltQGIpXOBOds/fUo/B3ot3VMzxBlEYoRAdGKZRHxzWSzm3l8KQcdM3NzABBuwXd38Frm1L0eqbZvWGe3cs5MgpcuhHiuv049n69QB/0rsDc97lSaVUWX5n++mdYUvGxl0XDBaMAE6IM5TO7QwlxKyUNRP5pNrD5WbGnWMnb59cVbQWkAOpGXiLQaPH3VLn8FTyd5/JbLgRjJSwIJRXGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkGi7yVBb7BbuK4IOklA3IKfnCFcVx1TmQ0mF80VyYw=;
 b=N5eYjIpQWRX315DUPeMGAJkMdJSSwXIGz0jwaUpMm6YZYv29xgvgF4MY7Q7he7lHIxoAWMNc3ZhTqmhf+C9/xHwBtLfKI2LmhYPX3uMO6nHs1FjJmc+9mwoWNAax4zFQE0e0kASnvEmZuMSAT979+NpBVzVjXQjbrsR6zS4mMHnYF9iSnXnVCJHuusUQCupfXlX2ffNsps+3FGLKH9o2nBdJIW5wvLnlzur1t1lbhiRqg7FKoTzeF5eeNrG8XKVYoRzl46EAq4zXkksfQPmnPwXZDctM6Lz11HruiHUme39vEsCWXgI0a2AuC0zibw8EJ9N5OULU7K/NuWVyi6LKEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkGi7yVBb7BbuK4IOklA3IKfnCFcVx1TmQ0mF80VyYw=;
 b=m0bKGF9R+Ai8dxDxBYhhbnebi8il9D2F1nxxtBgrwLhLbCNVqbaNc6eq4TlPsu5QrRn4dBFo2IMEWgpyED897swMKwrquqasjBNtWlNMO+3TzSZ9U5wJsB6kE6pmaawtahtsesNhrHxF+Jo84B4QKqfsuTmmyiA14HCGyUjib9Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2760.namprd10.prod.outlook.com (2603:10b6:a02:a9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Wed, 7 Jul
 2021 22:21:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.020; Wed, 7 Jul 2021
 22:21:25 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v21 06/13] xfs: Implement attr logging and replay
Date:   Wed,  7 Jul 2021 15:21:04 -0700
Message-Id: <20210707222111.16339-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707222111.16339-1-allison.henderson@oracle.com>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Wed, 7 Jul 2021 22:21:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4458f4a9-133b-4f25-7d24-08d941958ebe
X-MS-TrafficTypeDiagnostic: BYAPR10MB2760:
X-Microsoft-Antispam-PRVS: <BYAPR10MB276033D5F7811B4075710EC6951A9@BYAPR10MB2760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DF7BlLLUddepYPPAs4Q+2R6UbIell0wYWRtluAtqwllxUFMwaiCFRyHnKH6QcoY7Z6yD+llS+7l5sskJmFUQI+xSJJdk1+1O2SzuWRX4fo+MPwp3jR8k7JA6MkL2oIZqaSqsj7JjiWAStAwwxAO9bMklevcijUclOqF28j5Nuzk43HzLljV37t+sssZPpU5FMwEAu5G5rSQvJDhLHVr//f6u4T5Yf62pkCLi6Lh3pMCqvU5eikorMFT7ziB9r6L8zAhlsllRjs4ga92OKbUDAOpX+mB1btDOSEJE/kw7+zxYBjDwdIQQaoMA7dGVpRVn2N68fPD+ETBz/noLVWElVLcelgeTwgqo/2LWqshmfu1hktc7BTfvVnkqcDZiS3mXBZpFIoptJHtualnrmg03hXU1swXR4d7U8bgHPpj2tTFv2HL8ilzoh+DvLvy02SjEITmLEvQ+Fvo93jTS4HxspIV7LckmWoqY8EvvfeUy+dYcUSDJZhs4veH5CJPQmb/R2Y4Es4MJG4W7yghWtcOUxe6i8v5WP8sapNOtL/vdPN+bR8Qnj+l+LMxU+ic07iqB9HOMCFI++ltPwsmYmZD2ZKisiBOwGZHiC0Xff378lfN+MLq+w45dV0wLdUJcWTs8juSkGWOeTv4/l4xHKSZHc+X6Jey/GP1CE/3l7kRHPU+p4X6kiuK1rQY8YJhG+gheP0iXZc9DXMkUC24D4C/cvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(478600001)(83380400001)(8676002)(2616005)(6512007)(956004)(5660300002)(44832011)(66476007)(66556008)(186003)(30864003)(2906002)(8936002)(86362001)(6916009)(36756003)(38350700002)(26005)(316002)(1076003)(52116002)(6486002)(66946007)(38100700002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DlYbCv/Zl3G8170mQN5WWPQXOLYIYYDVTmien7M2dSF79gO9YBLB2PRySKSy?=
 =?us-ascii?Q?2yYu0vEyJ2+7G8Niln+UQzzCb+k+XiiUDxtfjD7T98CC1BP1IbIh8G+l92uJ?=
 =?us-ascii?Q?fgv9kMvluPYNxg3NuwuS70QxPSymn0xb9kTVkxdpKm+5PeOtlaj8ZNvzwV/5?=
 =?us-ascii?Q?yvvEiMwWMI8zV5+6AjEiRZIJA7fF0dLUHZaru+rNvjPTC/HA1MdzPWyeZsuL?=
 =?us-ascii?Q?U8p4SzLFdxNXXtW7OFHqL3TlL5NKoMnjka7om3B9uJODd3bluRhZfgIaew5B?=
 =?us-ascii?Q?RPUyn/N2E+gUdkxsra7ERSo5pLcziGsQ7+emP6mvY7L8ZWJdr0KKHD7ejP8r?=
 =?us-ascii?Q?0N6pToioo0fRkj+lQKdSLRksUaeiil3JBs8j/dEUkZyGho9gG0rAA4L1sW1E?=
 =?us-ascii?Q?hgC91z/YmcFnFabfKcX3t5bTP5FTEO8XCZAEszfV/Mx5gdzGH/0Yv0YnLWBd?=
 =?us-ascii?Q?0xYAi8dpNg9l78CN6Da2BQedtolX45Ge1fd3jM9ydBps8QjlxOzFuo5ewPqb?=
 =?us-ascii?Q?mJjppM5HEUjFyShKp1//kVTPn6vJiK0EtdosOpdsjPgjoN4SfoVIbRw8lbzZ?=
 =?us-ascii?Q?jS6JRlKJVpLCUMKR66/TXEz+/JRIhuLcEv3uGmt8dJdnlrpxHLHZb8CscMDY?=
 =?us-ascii?Q?gQtsF8rL4WXYU4BMxzmq6rGquDSRRxGbxBNx8dA4Ovz30nFh1v6ecnNmU1lz?=
 =?us-ascii?Q?+cr5G5zzdbw/lI7G56+uh0K3QCf4otBQmnw+YJho/oHBZME1jcXRVcm+zx8/?=
 =?us-ascii?Q?oenmzXLwYQAULqTEUkLH5JCVF2WZCc4rzbWMI5VYYzviYpHh3JYLQv9uuW9N?=
 =?us-ascii?Q?1L9QiZJOtABMoJmsn16gQURquzYGekTqu23J2qOIhMFYC0uqS+DZ+PaWGD1F?=
 =?us-ascii?Q?9Ibq42pdQvNMgeyN18H1gueb0ez3iiEceb/hxNQ47ZyNeZws1/cN9njjOzDh?=
 =?us-ascii?Q?TYB60YfFGEPFz75Z5ZJYAdgIbt7B0Q67u+DVtTh2arbCsemECvLM7mY0seEf?=
 =?us-ascii?Q?eUp8urKtOwvFarY7MKEV4gbjYfGqhbimscxGVJd91LQK4nAAQYLmUP8r0wbo?=
 =?us-ascii?Q?rVUZ7OthmgFzs/sZI5Qhh/VUm7x7HpRs+yTbv2JAWK7lcjv2iQ6VimcV0HDg?=
 =?us-ascii?Q?Md60JLQ1NHE9kORY6nZ6uSsIpg5E1MK4Gr1Hc7MRic3KNOC4Rz+Xxn87FJ2I?=
 =?us-ascii?Q?5Nql6RrMxakjQWC/2Hr/DM726LccYTJj2N05iQFQRC9qy7fDc3WYjjD8fi6+?=
 =?us-ascii?Q?7TXXBH37aAsfxubbFAUFqamAE4LlYi3tUrh3IfAdxjc7pkeq5+xCbZsJNpwJ?=
 =?us-ascii?Q?aC+XVbeX6IzqXUBV7z8NuLge?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4458f4a9-133b-4f25-7d24-08d941958ebe
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:21:25.2587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xk9KUP+HeHBAb0doT3TTG+B+fWTNHVkXck571lN1I7ijE+7+IRMQWAYVEwpAlmTOXPeYi06PRkvgScZn/39NM6P17SyTgtvsLs/Wv/pkwEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070128
X-Proofpoint-GUID: 1uzgrnh6gIXUOCkZxTpEp8skX_5PPUPf
X-Proofpoint-ORIG-GUID: 1uzgrnh6gIXUOCkZxTpEp8skX_5PPUPf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds the needed routines to create, log and replay attr
intents

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c  |   1 +
 fs/xfs/libxfs/xfs_defer.h  |   1 +
 fs/xfs/libxfs/xfs_format.h |   4 +-
 fs/xfs/xfs_attr_item.c     | 394 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 399 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index eff4a12..e9caff7 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -178,6 +178,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
 static void
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 0ed9dfa..72a5789 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 3a4da111..477e815 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -485,7 +485,9 @@ xfs_sb_has_incompat_feature(
 	return (sbp->sb_features_incompat & feature) != 0;
 }
 
-#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_LOG_DELATTR   (1 << 0)	/* Delayed Attributes */
+#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
+	(XFS_SB_FEAT_INCOMPAT_LOG_DELATTR)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index c9033e2..eda6ae3 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -282,6 +282,183 @@ xfs_attrd_item_release(
 	xfs_attrd_item_free(attrdp);
 }
 
+/*
+ * Performs one step of an attribute update intent and marks the attrd item
+ * dirty..  An attr operation may be a set or a remove.  Note that the
+ * transaction is marked dirty regardless of whether the operation succeeds or
+ * fails to support the ATTRI/ATTRD lifecycle rules.
+ */
+int
+xfs_trans_attr_finish_update(
+	struct xfs_delattr_context	*dac,
+	struct xfs_attrd_log_item	*attrdp,
+	struct xfs_buf			**leaf_bp,
+	uint32_t			op_flags)
+{
+	struct xfs_da_args		*args = dac->da_args;
+	int				error;
+
+	error = xfs_qm_dqattach_locked(args->dp, 0);
+	if (error)
+		return error;
+
+	switch (op_flags) {
+	case XFS_ATTR_OP_FLAGS_SET:
+		args->op_flags |= XFS_DA_OP_ADDNAME;
+		error = xfs_attr_set_iter(dac, leaf_bp);
+		break;
+	case XFS_ATTR_OP_FLAGS_REMOVE:
+		ASSERT(XFS_IFORK_Q(args->dp));
+		error = xfs_attr_remove_iter(dac);
+		break;
+	default:
+		error = -EFSCORRUPTED;
+		break;
+	}
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the ATTRI and frees the ATTRD
+	 * 2.) shuts down the filesystem
+	 */
+	args->trans->t_flags |= XFS_TRANS_DIRTY;
+
+	/*
+	 * attr intent/done items are null when delayed attributes are disabled
+	 */
+	if (attrdp)
+		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+
+	return error;
+}
+
+/* Log an attr to the intent item. */
+STATIC void
+xfs_attr_log_item(
+	struct xfs_trans		*tp,
+	struct xfs_attri_log_item	*attrip,
+	struct xfs_attr_item		*attr)
+{
+	struct xfs_attri_log_format	*attrp;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
+
+	/*
+	 * At this point the xfs_attr_item has been constructed, and we've
+	 * created the log intent. Fill in the attri log item and log format
+	 * structure with fields from this xfs_attr_item
+	 */
+	attrp = &attrip->attri_format;
+	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
+	attrp->alfi_op_flags = attr->xattri_op_flags;
+	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
+	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
+	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
+
+	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
+	attrip->attri_value = attr->xattri_dac.da_args->value;
+	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
+	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
+}
+
+/* Get an ATTRI. */
+static struct xfs_log_item *
+xfs_attr_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_attri_log_item	*attrip;
+	struct xfs_attr_item		*attr;
+
+	ASSERT(count == 1);
+
+	if (!xfs_hasdelattr(mp))
+		return NULL;
+
+	xfs_sb_add_incompat_log_features(&mp->m_sb,
+					 XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);
+
+	attrip = xfs_attri_init(mp, 0);
+	if (attrip == NULL)
+		return NULL;
+
+	xfs_trans_add_item(tp, &attrip->attri_item);
+	list_for_each_entry(attr, items, xattri_list)
+		xfs_attr_log_item(tp, attrip, attr);
+	return &attrip->attri_item;
+}
+
+/* Process an attr. */
+STATIC int
+xfs_attr_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_attr_item		*attr;
+	struct xfs_attrd_log_item	*done_item = NULL;
+	int				error;
+	struct xfs_delattr_context	*dac;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	dac = &attr->xattri_dac;
+	if (done)
+		done_item = ATTRD_ITEM(done);
+
+	/*
+	 * Corner case that can happen during a recovery.  Because the first
+	 * iteration of a multi part delay op happens in xfs_attri_item_recover
+	 * to maintain the order of the log replay items.  But the new
+	 * transactions do not automatically rejoin during a recovery as they do
+	 * in a standard delay op, so we need to catch this here and rejoin the
+	 * leaf to the new transaction
+	 */
+	if (attr->xattri_dac.leaf_bp &&
+	    attr->xattri_dac.leaf_bp->b_transp != tp) {
+		xfs_trans_bjoin(tp, attr->xattri_dac.leaf_bp);
+		xfs_trans_bhold(tp, attr->xattri_dac.leaf_bp);
+	}
+
+	/*
+	 * Always reset trans after EAGAIN cycle
+	 * since the transaction is new
+	 */
+	dac->da_args->trans = tp;
+
+	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
+					     attr->xattri_op_flags);
+	if (error != -EAGAIN)
+		kmem_free(attr);
+
+	return error;
+}
+
+/* Abort all pending ATTRs. */
+STATIC void
+xfs_attr_abort_intent(
+	struct xfs_log_item		*intent)
+{
+	xfs_attri_release(ATTRI_ITEM(intent));
+}
+
+/* Cancel an attr */
+STATIC void
+xfs_attr_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_attr_item		*attr;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	kmem_free(attr);
+}
+
 STATIC xfs_lsn_t
 xfs_attri_item_committed(
 	struct xfs_log_item		*lip,
@@ -313,6 +490,30 @@ xfs_attri_item_match(
 	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
 }
 
+/*
+ * This routine is called to allocate an "attr free done" log item.
+ */
+struct xfs_attrd_log_item *
+xfs_trans_get_attrd(struct xfs_trans		*tp,
+		  struct xfs_attri_log_item	*attrip)
+{
+	struct xfs_attrd_log_item		*attrdp;
+	uint					size;
+
+	ASSERT(tp != NULL);
+
+	size = sizeof(struct xfs_attrd_log_item);
+	attrdp = kmem_zalloc(size, 0);
+
+	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
+			  &xfs_attrd_item_ops);
+	attrdp->attrd_attrip = attrip;
+	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
+
+	xfs_trans_add_item(tp, &attrdp->attrd_item);
+	return attrdp;
+}
+
 static const struct xfs_item_ops xfs_attrd_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
 	.iop_size	= xfs_attrd_item_size,
@@ -320,6 +521,29 @@ static const struct xfs_item_ops xfs_attrd_item_ops = {
 	.iop_release    = xfs_attrd_item_release,
 };
 
+
+/* Get an ATTRD so we can process all the attrs. */
+static struct xfs_log_item *
+xfs_attr_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	if (!intent)
+		return NULL;
+
+	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
+}
+
+const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.max_items	= 1,
+	.create_intent	= xfs_attr_create_intent,
+	.abort_intent	= xfs_attr_abort_intent,
+	.create_done	= xfs_attr_create_done,
+	.finish_item	= xfs_attr_finish_item,
+	.cancel_item	= xfs_attr_cancel_item,
+};
+
 /* Is this recovered ATTRI ok? */
 static inline bool
 xfs_attri_validate(
@@ -346,13 +570,183 @@ xfs_attri_validate(
 	return xfs_hasdelattr(mp);
 }
 
+/*
+ * Process an attr intent item that was recovered from the log.  We need to
+ * delete the attr that it describes.
+ */
+STATIC int
+xfs_attri_item_recover(
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
+{
+	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
+	struct xfs_attr_item		*new_attr;
+	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_inode		*ip;
+	struct xfs_da_args		args;
+	struct xfs_da_args		*new_args;
+	struct xfs_trans_res		tres;
+	bool				rsvd;
+	struct xfs_attri_log_format	*attrp;
+	int				error;
+	int				total;
+	int				local;
+	struct xfs_attrd_log_item	*done_item = NULL;
+	struct xfs_attr_item		attr = {
+		.xattri_op_flags	= attrip->attri_format.alfi_op_flags,
+		.xattri_dac.da_args	= &args,
+	};
+
+	/*
+	 * First check the validity of the attr described by the ATTRI.  If any
+	 * are bad, then assume that all are bad and just toss the ATTRI.
+	 */
+	attrp = &attrip->attri_format;
+	if (!xfs_attri_validate(mp, attrip))
+		return -EFSCORRUPTED;
+
+	error = xfs_iget(mp, 0, attrp->alfi_ino, 0, 0, &ip);
+	if (error)
+		return error;
+
+	if (VFS_I(ip)->i_nlink == 0)
+		xfs_iflags_set(ip, XFS_IRECOVERY);
+
+	memset(&args, 0, sizeof(struct xfs_da_args));
+	args.dp = ip;
+	args.geo = mp->m_attr_geo;
+	args.op_flags = attrp->alfi_op_flags;
+	args.whichfork = XFS_ATTR_FORK;
+	args.name = attrip->attri_name;
+	args.namelen = attrp->alfi_name_len;
+	args.hashval = xfs_da_hashname(args.name, args.namelen);
+	args.attr_filter = attrp->alfi_attr_flags;
+
+	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
+		args.value = attrip->attri_value;
+		args.valuelen = attrp->alfi_value_len;
+		args.total = xfs_attr_calc_size(&args, &local);
+
+		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+				 M_RES(mp)->tr_attrsetrt.tr_logres *
+					args.total;
+		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		total = args.total;
+	} else {
+		tres = M_RES(mp)->tr_attrrm;
+		total = XFS_ATTRRM_SPACE_RES(mp);
+	}
+	error = xfs_trans_alloc(mp, &tres, total, 0,
+				rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
+	if (error)
+		return error;
+
+	done_item = xfs_trans_get_attrd(args.trans, attrip);
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(args.trans, ip, 0);
+
+	error = xfs_trans_attr_finish_update(&attr.xattri_dac, done_item,
+					     &attr.xattri_dac.leaf_bp,
+					     attrp->alfi_op_flags);
+	if (error == -EAGAIN) {
+		/*
+		 * There's more work to do, so make a new xfs_attr_item and add
+		 * it to this transaction.  We don't use xfs_attr_item_init here
+		 * because we need the info stored in the current attr to
+		 * continue with this multi-part operation.  So, alloc space
+		 * for it and the args and copy everything there.
+		 */
+		new_attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
+				       sizeof(struct xfs_da_args), KM_NOFS);
+		new_args = (struct xfs_da_args *)((char *)new_attr +
+			   sizeof(struct xfs_attr_item));
+
+		memcpy(new_args, &args, sizeof(struct xfs_da_args));
+		memcpy(new_attr, &attr, sizeof(struct xfs_attr_item));
+
+		new_attr->xattri_dac.da_args = new_args;
+		memset(&new_attr->xattri_list, 0, sizeof(struct list_head));
+
+		xfs_defer_add(args.trans, XFS_DEFER_OPS_TYPE_ATTR,
+			      &new_attr->xattri_list);
+
+		/* Do not send -EAGAIN back to caller */
+		error = 0;
+	} else if (error) {
+		xfs_trans_cancel(args.trans);
+		goto out;
+	}
+
+	xfs_defer_ops_capture_and_commit(args.trans, ip, capture_list);
+
+out:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_irele(ip);
+	return error;
+}
+
+/* Re-log an intent item to push the log tail forward. */
+static struct xfs_log_item *
+xfs_attri_item_relog(
+	struct xfs_log_item		*intent,
+	struct xfs_trans		*tp)
+{
+	struct xfs_attrd_log_item	*attrdp;
+	struct xfs_attri_log_item	*old_attrip;
+	struct xfs_attri_log_item	*new_attrip;
+	struct xfs_attri_log_format	*new_attrp;
+	struct xfs_attri_log_format	*old_attrp;
+	int				buffer_size;
+
+	old_attrip = ATTRI_ITEM(intent);
+	old_attrp = &old_attrip->attri_format;
+	buffer_size = old_attrp->alfi_value_len + old_attrp->alfi_name_len;
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	attrdp = xfs_trans_get_attrd(tp, old_attrip);
+	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+
+	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
+	new_attrp = &new_attrip->attri_format;
+
+	new_attrp->alfi_ino = old_attrp->alfi_ino;
+	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
+	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
+	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
+
+	new_attrip->attri_name_len = old_attrip->attri_name_len;
+	new_attrip->attri_name = ((char *)new_attrip) +
+				 sizeof(struct xfs_attri_log_item);
+	memcpy(new_attrip->attri_name, old_attrip->attri_name,
+		new_attrip->attri_name_len);
+
+	new_attrip->attri_value_len = old_attrip->attri_value_len;
+	if (new_attrip->attri_value_len > 0) {
+		new_attrip->attri_value = new_attrip->attri_name +
+					  new_attrip->attri_name_len;
+
+		memcpy(new_attrip->attri_value, old_attrip->attri_value,
+		       new_attrip->attri_value_len);
+	}
+
+	xfs_trans_add_item(tp, &new_attrip->attri_item);
+	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
+
+	return &new_attrip->attri_item;
+}
+
 static const struct xfs_item_ops xfs_attri_item_ops = {
 	.iop_size	= xfs_attri_item_size,
 	.iop_format	= xfs_attri_item_format,
 	.iop_unpin	= xfs_attri_item_unpin,
 	.iop_committed	= xfs_attri_item_committed,
 	.iop_release    = xfs_attri_item_release,
+	.iop_recover	= xfs_attri_item_recover,
 	.iop_match	= xfs_attri_item_match,
+	.iop_relog	= xfs_attri_item_relog,
 };
 
 
-- 
2.7.4

