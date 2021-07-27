Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A4BC432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A9C26109D
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbhG0GVO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:1888 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234349AbhG0GVM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:12 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HgRC023064
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qVOMTuPbwEDZBgfnen8mj+k6kizYA6UXAna85729Ies=;
 b=nOIMQ4b87xWsD418r0m6IBFspz8/TkzpzXNfarZu+v3MWnd8+lA5VrnnwagZiGOYTQOn
 0d59idqKWuMpDi1o41eyiUWA4wtxOSK1quGAai/1RjfIIg0BFm+/TlM/Ofi5x9OeIMpt
 d4691ZRYfHYSY25T8Q9GLBr3wMr8vCfZh1NGmHYCk6IgX+24EWG4YyQu/LE5EjgJQtgI
 E9xlyH9S7B1PjYg1pycm8bHXGcDJJ1Mlz4Lc/RIp8KDErd62uNnJagiRfl+pFLRIeR1O
 nJC7ZzB1rRsF1OEbuGehIJDvhLFI9BOYCTBha08FcPCKuB7sB1XmY/7PXZEv8pRfMp+c Gg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=qVOMTuPbwEDZBgfnen8mj+k6kizYA6UXAna85729Ies=;
 b=Jnfw1bmvXzwWQYDua61i492GJ3mKfi52LuNCbEv8rakwUr3Cqb4mp/xw0mtGAXLOVKH2
 oL3DeGypFDY4eI+zBNh8h3/JWTvrjfwngRz5Dt7z6YH97O8RtF+IcjXYW9JcFVdThIkW
 ySIOaTLl6jrl4JaKgwTdhh9U+aVBPKchLwNC/FgPVNpU0MbaSvZKv3NI+zXoCnBZHoC1
 TlJHAzohBvB84NH8qRqXlHSa/G2aNei+cKhw0KSj0svg5ahzZYuuwNRlei4AlznrCw7X
 XKGwQA2jEBlpIXxVOxuW97f3+0svYpcu7wAYuygqmDf4Wrh5LZPU0mE66+V24OXGXbMT /w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23538uxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FUt1019936
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3020.oracle.com with ESMTP id 3a2347k08d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faITvlUu5oLx+v4z20ytv1trWZfVVB/pkXX4UCRpsjqOtvD6nSzYXJtbMLu/zhn3kFagzr5bQ1hmK6E1ecD3bFOD/5S8QhTqzOcDMQWNv9JRhreITpo1X6W9MeS5kxF4undKBNkGZnybTZqNjs+4Pk5JdtvF9/4oLsh8j/6F/Bu4CfPKGrevAGhgpFhWYBeADIYmJD9Hpms56rjznVi7TGqP83KqY9Nd9LDbcp39/A6VOQEV9f3hJgM0ofoZmRkhrB0azBi0IbNeMvTEKI0Zn1p0IJB+VPnj0fR+aHFqySboRRwwfWbg1jDomMHzKxHwhQelZ2GES9CzgJ+pxaJdhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVOMTuPbwEDZBgfnen8mj+k6kizYA6UXAna85729Ies=;
 b=Wtlar8imzO8LlwT6LRl/MGF2G65qitX/qq5PS4WZcRmAUQSIgsfRpf3Knftez8y54N93LfXbAqacF2cOLg4IlsrguVcCOSIutpezjkNWKDhOpk3M4UDEzXl1bQpSPHIshesNW5pBd16bJ17IqZpllwyyWDT1et/pJx2cLKT0D7z63T/6Aty4mUQDWiNry/EWwQV59wUd3oRpedZBMYiTCkxkxDy/zDq8AU+ZKnY75jyTPWjLg4vXo664J0t2MQrqdqcJiA3oMhs/yNwlJ7uXjtb0a+1ZZyVQG7WDHrItNKlsm7d5475oYxrNP3I4ldFlb6I59DhiPkK2J2BgzWbirw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVOMTuPbwEDZBgfnen8mj+k6kizYA6UXAna85729Ies=;
 b=A5tXm3t/ytnTUS/654Jn5UOcEPgtXsHZLt9URcfaOBiZlMrruV1guKiIktOjL8qk/KHoGemNCj7uiTTo6URY1kIeAQnEjK/qI/NvntR9B2CUVEuqH+MUWaEy/9qIJU8fVKSADVGfmjpkp2Y+POcMWS9MuLxbp64hofWHcqOmjC8=
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
Subject: [PATCH v22 01/16] xfs: allow setting and clearing of log incompat feature flags
Date:   Mon, 26 Jul 2021 23:20:38 -0700
Message-Id: <20210727062053.11129-2-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: f21ab389-9fb9-46c7-f324-08d950c6b8c2
X-MS-TrafficTypeDiagnostic: BYAPR10MB2647:
X-Microsoft-Antispam-PRVS: <BYAPR10MB26473572EE424CBD8E58980695E99@BYAPR10MB2647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wltnbeUII2HOoiy2yMQQBdPL4eSraih7bwbY9rgMwPGoW9Yki9EV2r7UlDiE4PWEo3h5xWVaXZfYgtleZ1sWOwzoUDBEO9yssKQjkKWKIt8BWlTwRdcE4yB1NU2SLhesmntbP0RtszEUzmCc9o7e5ZKIbLNV8y3SHsFnvNiuma+gtke4zY3UjabqJEucJD3XhUJaODUGFXJclky1msByt85ixrfrjcZqUVJ732PoyIRUs3m2nxPWy5j5AbeOGv31mSEtV3Rh1lw71EMzDWjlId5aDeP07aPGYWBL3DWotjRzjOyd+km0ns1ox2OUq8mC2DiNFgGxBJFp0k0nDFC9/pH9nju9NNB3MlMvBMS95eo3sVFy5XLb7LHNB5S8NUqda3GQmwOWM2nTqTWdPwV6pw6ySVSiAsHhRGCj/sJ63gryy0Ty5Hp5vLgPTAQz9BUdlCy4Wq+iAJ4lbmDk9aXpPtKqIEuOx/N/bj79G5hAq4LL1rB5GwrJtdoaxiY1OLlu2VJphX49cha90vhuoXWsK2ohHRtRAiuZgMWKy0AWIXZNoRejEM/mnmGGnqGBshahHx2NCzHbeupf0UsiYUc/Vywt6C8J9m2xSC6dmPif/bbhodxlrDheeS1XpSlKxmOD1xg3/KBunm0VHTkk1CbzExWeR7nyYHD5VqxdXxwrUfj/xn9N2Yz8yulo/gMZdOqHLLsafC0S/n0dnqHOnRFb4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(366004)(376002)(2906002)(6666004)(316002)(38100700002)(52116002)(5660300002)(36756003)(86362001)(8676002)(38350700002)(6916009)(44832011)(83380400001)(26005)(8936002)(6486002)(478600001)(6506007)(1076003)(186003)(2616005)(66556008)(956004)(66476007)(66946007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hiLbFFLRHXBtZU1dJ1kbKKbK1N7Kuh3QRIlLb/meSDcjVHsX57Oi3RefDmc0?=
 =?us-ascii?Q?N1FZIlG5TRhV+n/2nrtTkDcexGkMt68bBLFI2tEDHO0xREIGK4Nn3AQm1WzV?=
 =?us-ascii?Q?28BH/Mq15HbI0H1bjNf0Ez7cMVgMFJdkJaCG+IeG0I8niMnnErdpAdb0mxGa?=
 =?us-ascii?Q?Tot6/LAnoev5xKjjyh4bqhz6dvgQEe/agrkWRn56DREBzIrbavmlEz7H7tsv?=
 =?us-ascii?Q?ZayAKSI377x0MbyRv9aXm0TBND6nPPqjQF2Ooj3/LhRvQ2YtrdeCrNxLm5tN?=
 =?us-ascii?Q?O8g4d+Ej5FOTb3wPCYx27rZarTrYkM1DjaopXU5Y/aJLbRsNCRFzB71AZydq?=
 =?us-ascii?Q?bBPprwGcIkUDKcblMxjfxLEBk8eNo09HkU385ly4aA6ngsHjdQ3dgFA4lOf3?=
 =?us-ascii?Q?x3YfM2H8iJ2uKO+ZBEmUbfO0zuGbRucjS9ipFTF3r60xnFxd7ZHYmqrMAzMn?=
 =?us-ascii?Q?13wTXeJ5R8Q1DipaiqVWCPR4zZVeQJwbVPEvG884v22ddSe72N6+2FwVoGZg?=
 =?us-ascii?Q?/6ZCvCz2jiFnC0DWlgPT3HEEBpj4duJbJ7MnhygOtjVWMjhqE9tkYWkuf7Q7?=
 =?us-ascii?Q?3giS9Ac8dAPKEl6C5Z5WGOoP53vwQiJY4gDWh9pYTsbooW0V2srRYTnY367j?=
 =?us-ascii?Q?Bz1NaSN7ovh7qsE7QsN2pZ0FaDqWPQZf/KalwYElrz8aySlMK40KnyXVeeOf?=
 =?us-ascii?Q?sgPiGuE+bYtlJCYwBCwXriKAnu12ij2PK2UuhcIKQCC1Go1syXWVFbbDMl91?=
 =?us-ascii?Q?onR6wF2PyiLUzNqpVL68HlDJmUUiV5VJ7tYOsrDpfupjVp2BfWjYXxKJEbe1?=
 =?us-ascii?Q?VrJBqDeCnTOmlrWE1FVYUIQfzMTp3BD7zZRXukLKIXZ6h4/9oMK7e4DcfbPE?=
 =?us-ascii?Q?dFKImxZAmUZF7+M/GIP8E2HSDJQ2pn6B+xbN6zWEDi9bQBlvI5PwDy3jspu7?=
 =?us-ascii?Q?SbKHhlQA5DQh8KwFOugqMgicMcAlIZOwoxZMmrCiwLMhDwNFgp4s8n8IQQu8?=
 =?us-ascii?Q?PBd7hhiJY2O2dRoQV9l6VGkC0Qk41D/lrE7DXd+WPaK1QuR4GQF8UA7NC7Va?=
 =?us-ascii?Q?5+omtPHzBDNh9bC38d4Uv1zADjPtlIgLI4bnYpRkW7kgNnqG/3Mrk+tVlHgv?=
 =?us-ascii?Q?TzrdQ8TypxB10FPht8QihCDXm74q1ZgO7GkCHuNA9V+/PQmcUVPKfrML/+7Z?=
 =?us-ascii?Q?Fubp68BrXspP9mc2RU3HPHHlj1wSqh66CHDF/nrdvvmYcDroc9jrZhr+7QUA?=
 =?us-ascii?Q?dmKU2Uy1pdsxBOzncsBJmBUftp3Ra5jPXYWWWuMIwsAIKRyKRr6bymCDMbFn?=
 =?us-ascii?Q?vvdMa/Jalks6YocUAX8K73g9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f21ab389-9fb9-46c7-f324-08d950c6b8c2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:08.4928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: reH7AcnOFkS6poApdzgPijScIhFyZ1G9JB4Mnf2i33mcr8XnNSKCLgz46/Tl5KVB6k2xV6CO+qDEv1UucKP5ifoAw3bBs50AX2vgaNsX2rQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-GUID: KaPgvEzxwvdfk9UQvBaMif5gelzLOG2Y
X-Proofpoint-ORIG-GUID: KaPgvEzxwvdfk9UQvBaMif5gelzLOG2Y
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Log incompat feature flags in the superblock exist for one purpose: to
protect the contents of a dirty log from replay on a kernel that isn't
prepared to handle those dirty contents.  This means that they can be
cleared if (a) we know the log is clean and (b) we know that there
aren't any other threads in the system that might be setting or relying
upon a log incompat flag.

Therefore, clear the log incompat flags when we've finished recovering
the log, when we're unmounting cleanly, remounting read-only, or
freezing; and provide a function so that subsequent patches can start
using this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

---
 fs/xfs/libxfs/xfs_format.h |  15 +++++++
 fs/xfs/xfs_log.c           |  14 ++++++
 fs/xfs/xfs_log_recover.c   |  16 +++++++
 fs/xfs/xfs_mount.c         | 110 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h         |   2 +
 5 files changed, 157 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 76e2461..3a4da111 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -495,6 +495,21 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
+static inline void
+xfs_sb_remove_incompat_log_features(
+	struct xfs_sb	*sbp)
+{
+	sbp->sb_features_log_incompat &= ~XFS_SB_FEAT_INCOMPAT_LOG_ALL;
+}
+
+static inline void
+xfs_sb_add_incompat_log_features(
+	struct xfs_sb	*sbp,
+	unsigned int	features)
+{
+	sbp->sb_features_log_incompat |= features;
+}
+
 /*
  * V5 superblock specific feature checks
  */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 36fa265..9254405 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -947,6 +947,20 @@ int
 xfs_log_quiesce(
 	struct xfs_mount	*mp)
 {
+	/*
+	 * Clear log incompat features since we're quiescing the log.  Report
+	 * failures, though it's not fatal to have a higher log feature
+	 * protection level than the log contents actually require.
+	 */
+	if (xfs_clear_incompat_log_features(mp)) {
+		int error;
+
+		error = xfs_sync_sb(mp, false);
+		if (error)
+			xfs_warn(mp,
+	"Failed to clear log incompat features on quiesce");
+	}
+
 	cancel_delayed_work_sync(&mp->m_log->l_work);
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1721fce..ec4ccae 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3464,6 +3464,22 @@ xlog_recover_finish(
 		 */
 		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
 
+		/*
+		 * Now that we've recovered the log and all the intents, we can
+		 * clear the log incompat feature bits in the superblock
+		 * because there's no longer anything to protect.  We rely on
+		 * the AIL push to write out the updated superblock after
+		 * everything else.
+		 */
+		if (xfs_clear_incompat_log_features(log->l_mp)) {
+			error = xfs_sync_sb(log->l_mp, false);
+			if (error < 0) {
+				xfs_alert(log->l_mp,
+	"Failed to clear log incompat features on recovery");
+				return error;
+			}
+		}
+
 		xlog_recover_process_iunlinks(log);
 
 		xlog_recover_check_summary(log);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d075549..d2c40ae 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1217,6 +1217,116 @@ xfs_force_summary_recalc(
 }
 
 /*
+ * Enable a log incompat feature flag in the primary superblock.  The caller
+ * cannot have any other transactions in progress.
+ */
+int
+xfs_add_incompat_log_feature(
+	struct xfs_mount	*mp,
+	uint32_t		feature)
+{
+	struct xfs_dsb		*dsb;
+	int			error;
+
+	ASSERT(hweight32(feature) == 1);
+	ASSERT(!(feature & XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
+
+	/*
+	 * Force the log to disk and kick the background AIL thread to reduce
+	 * the chances that the bwrite will stall waiting for the AIL to unpin
+	 * the primary superblock buffer.  This isn't a data integrity
+	 * operation, so we don't need a synchronous push.
+	 */
+	error = xfs_log_force(mp, XFS_LOG_SYNC);
+	if (error)
+		return error;
+	xfs_ail_push_all(mp->m_ail);
+
+	/*
+	 * Lock the primary superblock buffer to serialize all callers that
+	 * are trying to set feature bits.
+	 */
+	xfs_buf_lock(mp->m_sb_bp);
+	xfs_buf_hold(mp->m_sb_bp);
+
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		error = -EIO;
+		goto rele;
+	}
+
+	if (xfs_sb_has_incompat_log_feature(&mp->m_sb, feature))
+		goto rele;
+
+	/*
+	 * Write the primary superblock to disk immediately, because we need
+	 * the log_incompat bit to be set in the primary super now to protect
+	 * the log items that we're going to commit later.
+	 */
+	dsb = mp->m_sb_bp->b_addr;
+	xfs_sb_to_disk(dsb, &mp->m_sb);
+	dsb->sb_features_log_incompat |= cpu_to_be32(feature);
+	error = xfs_bwrite(mp->m_sb_bp);
+	if (error)
+		goto shutdown;
+
+	/*
+	 * Add the feature bits to the incore superblock before we unlock the
+	 * buffer.
+	 */
+	xfs_sb_add_incompat_log_features(&mp->m_sb, feature);
+	xfs_buf_relse(mp->m_sb_bp);
+
+	/* Log the superblock to disk. */
+	return xfs_sync_sb(mp, false);
+shutdown:
+	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+rele:
+	xfs_buf_relse(mp->m_sb_bp);
+	return error;
+}
+
+/*
+ * Clear all the log incompat flags from the superblock.
+ *
+ * The caller cannot be in a transaction, must ensure that the log does not
+ * contain any log items protected by any log incompat bit, and must ensure
+ * that there are no other threads that depend on the state of the log incompat
+ * feature flags in the primary super.
+ *
+ * Returns true if the superblock is dirty.
+ */
+bool
+xfs_clear_incompat_log_features(
+	struct xfs_mount	*mp)
+{
+	bool			ret = false;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
+	    !xfs_sb_has_incompat_log_feature(&mp->m_sb,
+				XFS_SB_FEAT_INCOMPAT_LOG_ALL) ||
+	    XFS_FORCED_SHUTDOWN(mp))
+		return false;
+
+	/*
+	 * Update the incore superblock.  We synchronize on the primary super
+	 * buffer lock to be consistent with the add function, though at least
+	 * in theory this shouldn't be necessary.
+	 */
+	xfs_buf_lock(mp->m_sb_bp);
+	xfs_buf_hold(mp->m_sb_bp);
+
+	if (xfs_sb_has_incompat_log_feature(&mp->m_sb,
+				XFS_SB_FEAT_INCOMPAT_LOG_ALL)) {
+		xfs_info(mp, "Clearing log incompat feature flags.");
+		xfs_sb_remove_incompat_log_features(&mp->m_sb);
+		ret = true;
+	}
+
+	xfs_buf_relse(mp->m_sb_bp);
+	return ret;
+}
+
+/*
  * Update the in-core delayed block counter.
  *
  * We prefer to update the counter without having to take a spinlock for every
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c78b63f..66a47f5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -325,6 +325,8 @@ int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
 		int error_class, int error);
 void xfs_force_summary_recalc(struct xfs_mount *mp);
+int xfs_add_incompat_log_feature(struct xfs_mount *mp, uint32_t feature);
+bool xfs_clear_incompat_log_features(struct xfs_mount *mp);
 void xfs_mod_delalloc(struct xfs_mount *mp, int64_t delta);
 
 #endif	/* __XFS_MOUNT_H__ */
-- 
2.7.4

