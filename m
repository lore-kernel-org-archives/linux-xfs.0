Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05BEFC4320E
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E395E610A0
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbhG0GVO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2076 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235474AbhG0GVN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:13 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HliK023082
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=eAKJLSkRtYUMiSL5i1bMrC9utVGPAEtp40RhY5Jnx30=;
 b=TqeomdObtv6kqre4vByt4mHgLUR8jEGdPVrlwoH7ocsMROXW5XK8SWnCE9FksBF0neq0
 u5t7hRjQcLBPmLKTpvENQrXS70dsulfuzyyt36Zyia7Asckm5SbstJErfQOW9nChFFN7
 p+xYE8snxz6JwvkcLkM07mMKVYs1ZhrTbS7vggPFMZmnvw4ejiDo1JUlz987a3AxFYI5
 DZVIhhHBR4cVkhIjD+SabybkBNHQ7c+/iV8gPlu2e/faGIrFwUjGHjT1bYF505PVJJOh
 rsqIS+p87BjD2ThYSncjIEB6Abq0ZgvXdlQxzPPRVxo82oXCXzY5ykn26D7smThaOobE og== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=eAKJLSkRtYUMiSL5i1bMrC9utVGPAEtp40RhY5Jnx30=;
 b=rbypkFQtIaV8rZ4uGvIYVPOQu97ds72SIR7ihTFRbx4BJ/nx/zPxpQz69Y3A4afrrLHA
 p3eQZyfKycPZl5Dj6fAx18uVEy6B34MpcI7tgKqlGERzaJHW1MZM+VskqSHxK6u6mw9d
 wvgW5Y0MEWb0TmAiSwrE+hZnC0qSyxgg4UCK0WC3DnFjwjifRcQ9gS4jEskh0g7GTDbk
 ucfNG80/dbL+sFNuPAWtyCeRaaUK8rUfRZb7bcWrq/53Dw9VADNtRAnExnIuyToIoxnM
 HPHT33PnmDcPWJ8wv0pZRaRGgw+hjQK6b6XJjXcF8mviNLWEYyJubbO4FHwFwKSTdllK AA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23538uxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FUt2019936
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3020.oracle.com with ESMTP id 3a2347k08d-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nu4CDx4613r+hcBvM+HN3NY/+8E6diBQ61HozMjEi8av4x08Ai4KamMUDmZvkLH9WY+LZYJQfulO7nEVcFtKgPnFXMbcJSxjfgeXTpJjaCEExv0gcI93USgzF8yQZ+N9xy2W3XG+TEcsalteflkkPuagyg+YtyCGE0Jne76cIuP9qZ/N7OH+5B/wjxnfZCKC3dpBp1vjIP3Krg5rW2sjjwd3IIyUrx0uRARTm8p4z6BA0pWNf6s0U1U5e43gTXdxSPncmBDFNmMhhmzA1ffu7MzfVlRLK6vNmuWJfPFPdmTHyQRdCS6ZHqP8RfCN1HUWhUymR5coAI4grKzWUCKZcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAKJLSkRtYUMiSL5i1bMrC9utVGPAEtp40RhY5Jnx30=;
 b=WQeEJ2KTzMFyYF8v/qCsRXbtwzBzCuxm8BAdM38YxdgDgBTjZzHoELjYufQZ3ZQPToDUv6OTJOSRZiVHdFJMncunVpYfQj1ipb6LLjvwwr/iscROxAtNDH7yd1t06zPhettZemft4iBLeWDrMgzbnVNLhHvQ05RAgdyKewy34rUv08qriRPP+UUdDuWkIxdBJAMsCMCbeGpw+FmHFGtu/8N7UIW9pOOM6YWefgrIB4/DLyVcqTHgAOfv/ir+2rscB8TAjY/WJ36I6GiSpdenxz7SCVlv7FBEwFSYtCi7NsehTwaLs5jFpmcJ1OKodRlX45Ob22/76UU2lduol8XWIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAKJLSkRtYUMiSL5i1bMrC9utVGPAEtp40RhY5Jnx30=;
 b=sRTJP782Ajc9yuxB+vVNe5xf/LtXbrO185XUkqbMkZuc9AtQy4Q4A/OHWEggMLnp3wYW46FXLLCOIJjnZyg05mgA9H4gK8C8Sf860n0kgsXHhgDGhtivStsdzrmko7cRK+xadmcBqYfjaa4oGyvb9aLk7tTBkAVOiS/g3OSQSMY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2647.namprd10.prod.outlook.com (2603:10b6:a02:b2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:21:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:08 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 02/16] xfs: clear log incompat feature bits when the log is idle
Date:   Mon, 26 Jul 2021 23:20:39 -0700
Message-Id: <20210727062053.11129-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727062053.11129-1-allison.henderson@oracle.com>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:21:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a38a3356-5db6-4896-76f5-08d950c6b8fb
X-MS-TrafficTypeDiagnostic: BYAPR10MB2647:
X-Microsoft-Antispam-PRVS: <BYAPR10MB264766576E968770F16C9E8495E99@BYAPR10MB2647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q4zmQS9HjNYzncSNGk5eGf5izshoflenWCcQFUbxKX/nUbJ9m/Op5Nfmgp4S/NurrdOR0d9dqE2boINye41x8EfEO7fa7uaiunA1dp980PJ+Q8fxTdyn2hYFNcZU1r4sX2w3gOfEffQQiicbwehE2KKD39Je09XGcVvh2Cju1XQ6ZU70YH1gdQ3rV7Kb/xeU1x373uTM/kWnIkOPWaQ20RPtUHF0jo+bFlpyX34LYVFQO9BBL2F1cSiQLnlU2+4MsHTYtQuDzekcnY4yQbzmvauSIzsDI5J6vLZBSr9WT8ZdoZ4Aq6rEDYiQvWOjlJ+sdmiB/dJ/zUHR+wqGHx83XidAbq2eqZKIhNgOjosjwfG8ys5Br6Oc/V8jkLE/3yvL+Om6mG0kwBX3S/umB5RPK0r8svnyNYDgQy1JcpMB0EPtyR47EZgCIilVELLbIPtL4+8R7TR2/YH0Ejg7a7KqevuXZcsPe4wngTTcqWGQuJbUhd96FzSBJvJjkHVsjtP/12/gPooDczYKiRyYboYplxmjfxw+sK7ewHBQBjKrx7tBd1rEaQFgZem0lPlzwxcOBIG/wKSI5Fkcg4tACzIFxhj25AIXQXECGUN1hqj4fVBRW8kBT8NQznTr5ZxXqJ7Rk5pCmkzMBS8Q0Zu553O8fSvhhs0xDmLW+8kVUC5DZLtJMmWzeZwtObZJfwa2NV2nMomDU+Ska48wPt/7WKQSug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(366004)(376002)(2906002)(6666004)(316002)(38100700002)(52116002)(5660300002)(36756003)(86362001)(8676002)(38350700002)(6916009)(44832011)(83380400001)(26005)(8936002)(6486002)(478600001)(6506007)(1076003)(186003)(2616005)(66556008)(956004)(66476007)(66946007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YMgOrx8dSfQSArmkIrCub1n5DREFTxxpfP2CeNp7zg6a0pQZ0gxD3zEXzLdN?=
 =?us-ascii?Q?ZT/bxquvR+z5wTsd7NH963Zx0EJJTEViAWlh2TUs/0x6DMXPwQsKcbcK6ocW?=
 =?us-ascii?Q?zmNrm4RUcJPMWg493ybG+nfY1v0ywzW/ax03MW0GUyC3LB762iNRnWZahuSh?=
 =?us-ascii?Q?GRAkOrryPi+eIC4rDs/ik9dULepO/0EgGHkwtl/3PjQek0NcM/imcNiVbpYk?=
 =?us-ascii?Q?iYyg+/JGfTuhM5XlZdS31I9ghEA8buokrUCWdQgQCsWC7TRZzM/IE3BcE/aO?=
 =?us-ascii?Q?UhVp+sBIEkPf0t6qrerpdxK6yVn8omMD6XGwsvOktcOGhvzhdJw1mYL+VZS7?=
 =?us-ascii?Q?gJY5IgGsArVA1Gm9KQ/XnQlXOGoxVJRq8a1gwbNkW63Gx7BKA6K8vPqT8sK6?=
 =?us-ascii?Q?d8lofPBYEJ85pRMyPIwOWjTortaf9R+CIODfro8yU95PiHapPXjsAxE04+53?=
 =?us-ascii?Q?oJ807BvCn6bxC+NeVvxErRiGnhOHhKSX2u1dJrVyKw1lYeXUomtEpgqoUW0g?=
 =?us-ascii?Q?QXSECHSMLu8tSS20jKP8FJ79M0A/a7HPVrYQoNfsltRapaa8tT0he23GW7AK?=
 =?us-ascii?Q?cp6zyD5+l81rlSqrACdXAicQben1mDkMkQB9i+B2d/55T+kwwE+EJfjug5b1?=
 =?us-ascii?Q?UUVghMk5afrNufvEpuYYdDgJUTjxYPfQtO8AhG4oldaZ+RQZPiy3jNQfvjKn?=
 =?us-ascii?Q?l2QWlYzvyJsh4O61yr7O27T8s0jGnBvj/Qa/51GcT4ldKJDRdSCzq2ohN3yS?=
 =?us-ascii?Q?vUts78RcKgYuyIOZ/VmHJEr7a5DIh/1ThM4+gJMF9chh35VsMwabwimV7sMY?=
 =?us-ascii?Q?BtWvZhK1d1sgBBjhhFBeY3LZR6HFRvO2FaHFdutAditgWfCZ0+wgMeEXmrcQ?=
 =?us-ascii?Q?xffCcn7GuS73fBjZAibqlqxY3+AvlJkjvGTx/3p7m7uftfdCsAnsba/XDaRE?=
 =?us-ascii?Q?n86aOELggU360pRMYeAMBTHoi0QquYUk6AGylGvFICM3zMC6bEgv9LY0Kd11?=
 =?us-ascii?Q?gsrSzHUZiY7cjKzY4+cU12UGlNVlQTOujcuic1K03eYEsmsskE5mhb4zujbl?=
 =?us-ascii?Q?ygZGgK1ATjC2htx6RyDhaniEU634/67w5Dy6TWh5G6Dh+MkJ4/uh7zZUcqkz?=
 =?us-ascii?Q?26qkP3UxMoKCLY0D+cuEbwRy+TdrWBitpuJtRCz5Bp7CpIeuvTRMlbweHgd2?=
 =?us-ascii?Q?mf8N3Oi4hvNuVV6V35OTPEMKBcQtj3Njj9g2zBxgOhWzIpMqJZ87I41E/Qib?=
 =?us-ascii?Q?tH0lP3laQT3wbBkJmj9AEKBoAqPg9kYG/6SVIE/m2f5owUPKt1gG7jUQ9k+F?=
 =?us-ascii?Q?i3uxrQ66zT9JOaJRvEsn3yy4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a38a3356-5db6-4896-76f5-08d950c6b8fb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:08.8343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5YvNnWtc0qCSL1tFvqweL8zBaAGXvn6GPqlDv38swGcXdtOoUrn4U76w/GkrH+83W4DZ9Czbk0KlKZ8pE0kJ3WBMDdBHDvzpW6prmwm89C8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-GUID: RavCjeW1-Cs4lda9CMhbHzbJ-Oa7B4vE
X-Proofpoint-ORIG-GUID: RavCjeW1-Cs4lda9CMhbHzbJ-Oa7B4vE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

When there are no ongoing transactions and the log contents have been
checkpointed back into the filesystem, the log performs 'covering',
which is to say that it log a dummy transaction to record the fact that
the tail has caught up with the head.  This is a good time to clear log
incompat feature flags, because they are flags that are temporarily set
to limit the range of kernels that can replay a dirty log.

Since it's possible that some other higher level thread is about to
start logging items protected by a log incompat flag, we create a rwsem
so that upper level threads can coordinate this with the log.  It would
probably be more performant to use a percpu rwsem, but the ability to
/try/ taking the write lock during covering is critical, and percpu
rwsems do not provide that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_log.c      | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log.h      |  3 +++
 fs/xfs/xfs_log_priv.h |  3 +++
 3 files changed, 55 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 9254405..c58a0d7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1338,6 +1338,32 @@ xfs_log_work_queue(
 }
 
 /*
+ * Clear the log incompat flags if we have the opportunity.
+ *
+ * This only happens if we're about to log the second dummy transaction as part
+ * of covering the log and we can get the log incompat feature usage lock.
+ */
+static inline void
+xlog_clear_incompat(
+	struct xlog		*log)
+{
+	struct xfs_mount	*mp = log->l_mp;
+
+	if (!xfs_sb_has_incompat_log_feature(&mp->m_sb,
+				XFS_SB_FEAT_INCOMPAT_LOG_ALL))
+		return;
+
+	if (log->l_covered_state != XLOG_STATE_COVER_DONE2)
+		return;
+
+	if (!down_write_trylock(&log->l_incompat_users))
+		return;
+
+	xfs_clear_incompat_log_features(mp);
+	up_write(&log->l_incompat_users);
+}
+
+/*
  * Every sync period we need to unpin all items in the AIL and push them to
  * disk. If there is nothing dirty, then we might need to cover the log to
  * indicate that the filesystem is idle.
@@ -1363,6 +1389,7 @@ xfs_log_worker(
 		 * synchronously log the superblock instead to ensure the
 		 * superblock is immediately unpinned and can be written back.
 		 */
+		xlog_clear_incompat(log);
 		xfs_sync_sb(mp, true);
 	} else
 		xfs_log_force(mp, 0);
@@ -1450,6 +1477,8 @@ xlog_alloc_log(
 	}
 	log->l_sectBBsize = 1 << log2_size;
 
+	init_rwsem(&log->l_incompat_users);
+
 	xlog_get_iclog_buffer_size(mp, log);
 
 	spin_lock_init(&log->l_icloglock);
@@ -3895,3 +3924,23 @@ xfs_log_in_recovery(
 
 	return log->l_flags & XLOG_ACTIVE_RECOVERY;
 }
+
+/*
+ * Notify the log that we're about to start using a feature that is protected
+ * by a log incompat feature flag.  This will prevent log covering from
+ * clearing those flags.
+ */
+void
+xlog_use_incompat_feat(
+	struct xlog		*log)
+{
+	down_read(&log->l_incompat_users);
+}
+
+/* Notify the log that we've finished using log incompat features. */
+void
+xlog_drop_incompat_feat(
+	struct xlog		*log)
+{
+	up_read(&log->l_incompat_users);
+}
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 813b972..b274fb9 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -142,4 +142,7 @@ bool	xfs_log_in_recovery(struct xfs_mount *);
 
 xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
 
+void xlog_use_incompat_feat(struct xlog *log);
+void xlog_drop_incompat_feat(struct xlog *log);
+
 #endif	/* __XFS_LOG_H__ */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 4c41bbfa..c507041 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -449,6 +449,9 @@ struct xlog {
 	xfs_lsn_t		l_recovery_lsn;
 
 	uint32_t		l_iclog_roundoff;/* padding roundoff */
+
+	/* Users of log incompat features should take a read lock. */
+	struct rw_semaphore	l_incompat_users;
 };
 
 #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
-- 
2.7.4

