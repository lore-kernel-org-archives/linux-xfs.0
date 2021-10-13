Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1ECC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 03:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0DA460F94
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 03:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237692AbhJMDbm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 23:31:42 -0400
Received: from mail-eopbgr1300139.outbound.protection.outlook.com ([40.107.130.139]:16234
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237704AbhJMDbl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 23:31:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGRUgrYz79Ichb0TkNNxfdLZ/e5gVOprp7DaAqfD6v7XIn/VPFG5yKIbZrC92eQh+FpLgFhTfKFjJYEqy2QAc+lfpZRQVNxNURoD4bmlGYFyWRXydxBk7S59h1Qs2rj03vnKgLdi0+m1uogKa+7sGfUwXUUZJ7m9o+a1i4AmLLmnre/5WQUI82riPThZQjNpsQTMx3Nmm4R1NtqnaiHFE3FmoJh2KRxpvZkBn6yrG0rCM8xChNdKNCj8sOv0LE9V9kzaFBmZKsXv/hBHQraqWvmzGUOtTvN8lyGMYDZrH6mpO98q2dojYMNvG7egsIGVGEnSUVnOuDYjWxIZgNxKMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=22bp3eeUbsDzLdGoLmeLG1g9/+AevkXw+t1R9QW9D24=;
 b=IVMbBS0kc4icLOiGSXt+5nSns5gRJyrwKZKdqr7/YEfGRwSk6zWDfHFBcPqmz+jqsZaD1iytZiXaXswKXK3spv4PRVZ+ConogdIb44DmB/XNKp29ih6BZLWRqxqSVQ9xi3cgjURaO83Yl7f4cek93959ZafeYglIm88HdlE8fn9NbWxtcr1e5+4gWj3+f4gne9O70GeSsLtdSRBAnemCV0bpkkXgnEihPS+ArKw9SHXos+DKRojMeTIbb+iYEyU6bTlEB3JMvs3fykXVbaEZqhNWx2dHisWX9uuF4h+e6+yVBLx5w3tj2m7lzxjr+lLVvG3jtAB3DeGk/nkcTm+bjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22bp3eeUbsDzLdGoLmeLG1g9/+AevkXw+t1R9QW9D24=;
 b=YdKMirmIT3rrfZy+qClbocFxpX/3c/9zpua+EJWLtVyjHLDm9BGiqTJiykN/o9f+LxhB6951Wb1FZhftRriwtQMlfS24MU228uquEFc6bSY/+B8MS6o7a/jLssIxNQJwydYxfGsb3iyRKipEBe8QK+RL3Dq/OdAuEbqhxjSMPh4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB2955.apcprd06.prod.outlook.com (2603:1096:100:3d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 13 Oct
 2021 03:29:37 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414%6]) with mapi id 15.20.4587.024; Wed, 13 Oct 2021
 03:29:37 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Qing Wang <wangqing@vivo.com>
Subject: [PATCH] xfs: replace snprintf in show functions with sysfs_emit
Date:   Tue, 12 Oct 2021 20:29:31 -0700
Message-Id: <1634095771-4671-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0302CA0005.apcprd03.prod.outlook.com
 (2603:1096:202::15) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
Received: from ubuntu.localdomain (103.220.76.181) by HK2PR0302CA0005.apcprd03.prod.outlook.com (2603:1096:202::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4608.4 via Frontend Transport; Wed, 13 Oct 2021 03:29:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4d26c6b-4869-45a0-aca5-08d98df9aed5
X-MS-TrafficTypeDiagnostic: SL2PR06MB2955:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SL2PR06MB29558CCBE66B3ACB4F54E538BDB79@SL2PR06MB2955.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6uMK7hguVOgL1saT6kRsu87YUQeJCOrJkqhOl/S+Vrjr+Oyf7dEXqXXMYmBtEnAk1VYeOq/KrnKJ+o9LSNXf/8hfVGSRe0ceX4SVpojo7rnqiBfFsS8oy9GlSIOJcyOoE/58g+oYQFXvSVY1XNd1mBt9akbUzGLruRleviaA3UJb4E9mf/d32pybYCiELyJNp63hG53pbJbJyonHYeMigLMirReq3jZFlgd9j2u0Kmbt5e/9/MDSBxbrfiw5Feir23Yx9qj12r5Geu0fyTVSxBk/fj4QbvQFXrYRvNj3yYCxDKLeiF7HOGssQrpKu2BQXUiiA/lVrCH2F2jbrNA456pQLbPbxPmnJIWcPtzmmaOPEjasQVrnbcS00whhjSRrm5to6DfKwyJjIUYJ4ozce9uz9dHHPyis1vu/tp5Z3WMApU+fF4nN4uSsaIDi8+R0WTpOdEWxFnA1omFRdFyTynUsgbY2M75EWF5hCmd2y7ngLLPZt4cPVH1imTLAYRm0TQRf6E0LHMWwQ03QUXcC0Zouh6oGHHxcH83BOyuC1gDxk/y7oMxI6oB66ik1Ih5XKz3W1E/FdmjdqGMMHkJUlSG1MOM1atlmTI6o3LbzF8auU+wXhZC0ssVVSyGOcJvTXqmQDgKYdZI89rqe4zzP/geg10FRmFcztRpr/1bo2/IYWxnzk60Lf9258T1HyemiODLm/KTfp8B+eRjpLzR52w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(508600001)(186003)(6666004)(107886003)(66476007)(66556008)(8936002)(66946007)(26005)(2906002)(6486002)(2616005)(36756003)(83380400001)(4326008)(52116002)(6512007)(6506007)(86362001)(8676002)(316002)(38350700002)(5660300002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dkxw8AyTYfM/uYILMkPoyc7AZH1QqEyLcYit5xaoZoiV/otVAHU2dLBwzvid?=
 =?us-ascii?Q?fIXtJ9rdWROn0gEx/6PMc66f+1bDewvBoOw2GPZpg6YsiiO1+bwW39b9L9Qe?=
 =?us-ascii?Q?0hmmPI18vrFip+Fn6Wpt/TCMDDlD6V9ZeVK81+UddpljntU/j1+HcNWTGlKv?=
 =?us-ascii?Q?anqt+JNmbA8pY3rZPiylstozEgVeE5VidQzWRVEGb/8eH5jIO5AnNKAow5Pu?=
 =?us-ascii?Q?WniJLEdaId9BcSMpEUh1B+mJN45tlE6NOccC+J2/TyBqMryeQVXYHfWSVso4?=
 =?us-ascii?Q?MPnfLDtbF4x4OYG9q5r2hOtv6GSSscjDWdLp9lW80s5GkefP9lx27OIP5z2n?=
 =?us-ascii?Q?BOI1gBot9pZPe4t81HH+foMKbl/5vBXifHgPIZsB0uTxR+hVvHIYZc6vr7pJ?=
 =?us-ascii?Q?DmwXsizUBSrywQIoGIIAEuY6Z+PD7u8OniP8Y8WRQlEh23VgKzVRDt4eDBuI?=
 =?us-ascii?Q?WoB6nxQ2vUg6oJjFv9Vq8nc8IVWz7mMfS4TELze0I9zc+8VT0qBbpSh33snw?=
 =?us-ascii?Q?wYpevL0tjzBvIebbvT851QPvXKJ6/SH0yNTLa/vwOzT64nljGs3K8i3FMOMY?=
 =?us-ascii?Q?NhF7gaCRZvt/KcXOyGw/zKc8McQ3s0CyUxxkoAB3JGNtRnKRXkefowKzZeCr?=
 =?us-ascii?Q?kHWscNxhv8G8c9rLVrPv0qXiwQBUwi+NvEZwS1qhe+7RRqz8b1eiP0JC8WTX?=
 =?us-ascii?Q?4xk6H4U+YpVzZCgKhwHhG7yAE6M52uK+IqzaV64VSA1t/BFjWd4K60NdSztB?=
 =?us-ascii?Q?16uouzJ42haylzmiwfJG5/JQivYOiwHT4ZO4zoopE6f75Yivp1jG5rTxeDtO?=
 =?us-ascii?Q?RMNE335I5U8NU6NE+GQrtSEJSOUb7qH3rwHRopqIxxb26SnSi+YdmF6mycQR?=
 =?us-ascii?Q?s8VuAVPuTwOx7/CIIL9FYph8cYioQJ79K5ZUVjl6UbEsZQcfHMeaYru/AxAQ?=
 =?us-ascii?Q?DwBkxLE4jwK6fz7xZ22y0xWIVlV3/FL/pQ2DmyzHQnOmWijMSX+Mj2EKGOlr?=
 =?us-ascii?Q?M1JuOPzlHrz9YeJcfbhmC1x9PkkSLEHX4Zob6Na2P0l99+0vnlkX8jW9s9Xz?=
 =?us-ascii?Q?ggCW97JX/d/bWENX4QWVe5xMivEHOElTPtHn4HZTWsDQycB3CwubipFQuOyk?=
 =?us-ascii?Q?SMH9yCFf5oFAcZNL74wCSlhMzio9k6uFWqnchxQzykGkNgoYI+buYDb7zYJC?=
 =?us-ascii?Q?hhXcu6UQCEKoVft4+U2xQYWWKTXJltgMrvYyfL7YrOeSuhogP7/+LsZ7fz/E?=
 =?us-ascii?Q?Lxk5X07MSGSHEYsfYDUf3293zOOIe67UHeIe9nkZn9UOKv1+QGHLqne9Lat0?=
 =?us-ascii?Q?qrbGFq+7MpRnGSyuYBI+LrA5?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d26c6b-4869-45a0-aca5-08d98df9aed5
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 03:29:37.0547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P+wLTA2obLCFAFUVQ58Ladv0gGgV8dlIRfAMiZLy8p7C9vIbUg6KKOqqOdtsj+ryKsKd1VycwZSqnTcjXivI7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB2955
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

coccicheck complains about the use of snprintf() in sysfs show functions.

Fix the coccicheck warning:
WARNING: use scnprintf or sprintf.

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Signed-off-by: Qing Wang <wangqing@vivo.com>
---
 fs/xfs/xfs_sysfs.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index f1bc88f..3c171bf 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -104,7 +104,7 @@ bug_on_assert_show(
 	struct kobject		*kobject,
 	char			*buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.bug_on_assert ? 1 : 0);
+	return sysfs_emit(buf, "%d\n", xfs_globals.bug_on_assert ? 1 : 0);
 }
 XFS_SYSFS_ATTR_RW(bug_on_assert);
 
@@ -134,7 +134,7 @@ log_recovery_delay_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.log_recovery_delay);
+	return sysfs_emit(buf, "%d\n", xfs_globals.log_recovery_delay);
 }
 XFS_SYSFS_ATTR_RW(log_recovery_delay);
 
@@ -164,7 +164,7 @@ mount_delay_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.mount_delay);
+	return sysfs_emit(buf, "%d\n", xfs_globals.mount_delay);
 }
 XFS_SYSFS_ATTR_RW(mount_delay);
 
@@ -187,7 +187,7 @@ always_cow_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.always_cow);
+	return sysfs_emit(buf, "%d\n", xfs_globals.always_cow);
 }
 XFS_SYSFS_ATTR_RW(always_cow);
 
@@ -223,7 +223,7 @@ pwork_threads_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.pwork_threads);
+	return sysfs_emit(buf, "%d\n", xfs_globals.pwork_threads);
 }
 XFS_SYSFS_ATTR_RW(pwork_threads);
 #endif /* DEBUG */
@@ -326,7 +326,7 @@ log_head_lsn_show(
 	block = log->l_curr_block;
 	spin_unlock(&log->l_icloglock);
 
-	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, block);
+	return sysfs_emit(buf, "%d:%d\n", cycle, block);
 }
 XFS_SYSFS_ATTR_RO(log_head_lsn);
 
@@ -340,7 +340,7 @@ log_tail_lsn_show(
 	struct xlog *log = to_xlog(kobject);
 
 	xlog_crack_atomic_lsn(&log->l_tail_lsn, &cycle, &block);
-	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, block);
+	return sysfs_emit(buf, "%d:%d\n", cycle, block);
 }
 XFS_SYSFS_ATTR_RO(log_tail_lsn);
 
@@ -355,7 +355,7 @@ reserve_grant_head_show(
 	struct xlog *log = to_xlog(kobject);
 
 	xlog_crack_grant_head(&log->l_reserve_head.grant, &cycle, &bytes);
-	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, bytes);
+	return sysfs_emit(buf, "%d:%d\n", cycle, bytes);
 }
 XFS_SYSFS_ATTR_RO(reserve_grant_head);
 
@@ -369,7 +369,7 @@ write_grant_head_show(
 	struct xlog *log = to_xlog(kobject);
 
 	xlog_crack_grant_head(&log->l_write_head.grant, &cycle, &bytes);
-	return snprintf(buf, PAGE_SIZE, "%d:%d\n", cycle, bytes);
+	return sysfs_emit(buf, "%d:%d\n", cycle, bytes);
 }
 XFS_SYSFS_ATTR_RO(write_grant_head);
 
@@ -424,7 +424,7 @@ max_retries_show(
 	else
 		retries = cfg->max_retries;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", retries);
+	return sysfs_emit(buf, "%d\n", retries);
 }
 
 static ssize_t
@@ -465,7 +465,7 @@ retry_timeout_seconds_show(
 	else
 		timeout = jiffies_to_msecs(cfg->retry_timeout) / MSEC_PER_SEC;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", timeout);
+	return sysfs_emit(buf, "%d\n", timeout);
 }
 
 static ssize_t
@@ -503,7 +503,7 @@ fail_at_unmount_show(
 {
 	struct xfs_mount	*mp = err_to_mp(kobject);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", mp->m_fail_unmount);
+	return sysfs_emit(buf, "%d\n", mp->m_fail_unmount);
 }
 
 static ssize_t
-- 
2.7.4

