Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0746DC432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E744C61107
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhG0GUB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:20:01 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50162 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235103AbhG0GTu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:50 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6GBvp024367
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=HUFIKKBzbHEMKWM2m+0ajmiNbCXlZFxGJvTB/Em5jQQ=;
 b=09PYeeksW67tJMMx7/mT28tKz6JSOHNtj/9swLK/u6rtA6kbDpyoVUE8J/6pdrQglxJt
 vLHKoJdBaacbvW8JD/E2gXKSOGWKIOe6BjA3BWAZ3s2KtgKQY+cdUz2vwIXkwbcKCsIr
 MUucdancHAaYKA0tvTHTQV7hCZ3weeXEcyQt8Zf3q8ZHrKcJcqBPaIoBy1X8OVRhJepz
 G1Ef4vw/UKBsk1/nuinjUFyMPfa5aBpUlZtAXxQxFpStfPMNMXRpup5JGW3Miw6mP/Jr
 7u2YLMkl6yV6LYzXXjSyNvPW5VK6TNor9xaXQegyjEV9VJmqdEz3qApBWL8b8gek01cc xw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=HUFIKKBzbHEMKWM2m+0ajmiNbCXlZFxGJvTB/Em5jQQ=;
 b=cupzySjMQJ7sj/c7ip7zwh40Vd9Mf1WGj8qvYx9/JMuDi4k7bQKKalVHLa24r7FPihwb
 35M/iGZAmBo7wfWGd2CGniUtKLQa1dMU9xWRxk0t/09a80HWjHoFFx9s0EL2F+NeETIq
 Ns1JR91OC+K5On1orsJ/iIAchhu7NQC0bhBXJk15h6F2frw6OsSHc0jkXxnKp1FT2Yyp
 Yc+FCS05BhGBLzTp6j8uslHfyKKGlL8JfLq3b6S7zRHbKqUtpxxTDRvbSa4D+e+qEZ+K
 yzLndieYUxjMG6FiiuNaFFJiu59JuOUyYTb+pjBsN4ZRrC26lRslCa5+2EcG3tVfTBW4 gA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235drun8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FknP114917
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3a2349tqr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmAtnE8LcGmNMVlT9q+6NewqGw2sVNIl3DcU4BV5FESETuxEwtnLXxrqNab5LLzS0EJU+CCRsa8rWn2EPmybPLBqoESK1RyyOJjTGLBoXV3sg+BbbWdp0uNG8Pd1vzPLf0bH1HLSWqDLwVOUMquWleUoY8clzH+yvwne12BjIhj3qBdxb8d8g0ctNIs82vAAtk+qikkIHAW7oyfzRuLuXksWV0vkGnYoJwctCMbnh3entxTLQhl9MWum2ttAogebl4tYCiUtmHlMVxQ9HeqArxXVViwc4MsVU9QpbRv/p64DpjtpzRrOFHPCO3NWeLuxKtDzk3OOiKlsMnJmsAB2nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUFIKKBzbHEMKWM2m+0ajmiNbCXlZFxGJvTB/Em5jQQ=;
 b=RUAlBgLSr4M9lzW92Uzrj9Vum1NcSnzKbW/WKDbPzs04tBxqVLb5tkzzlFXFTrhEaVF6m3aKZkm0XKGJ3HDUyxnEn1VGAp9VipsN+zyoL3KywdTcVNpHdy7F+Q8b7elOWfA/TcsnqpEF3bcif+frvHhvPpURP6/nHydN+zCdj2xynaYuPrvf1tweUz1Kvem2qjetBmnn2o2xKa+s+z4he7hyzu0KbnZK/B1cAjEZZ8Eg8gXRelzAlhSutz/PzP24oI7b+lmJ/uTNKYXV4Q0T8iIF2y47SByRduPb1XDHnMDxc+x6pJ8smy9Amp1f+3gBJqHVOUTZ8k2oeWTGrNqh6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUFIKKBzbHEMKWM2m+0ajmiNbCXlZFxGJvTB/Em5jQQ=;
 b=fgN0fSqzx+vyqBQ73c5U4a4AiSBxVFOA2tAY5f82foALvlwLDxdE9Xs0hR3BdQHK1imqyfTcazC+JWxLA3S1mmwmBhWPkCRuaA/Y5I2UfhOJKB2branCYYujtxs78UDfOixeRCm9WNnVpArJTWnwYoC9KtB62dz6bTBJdTBPV6Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2791.namprd10.prod.outlook.com (2603:10b6:a03:83::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:47 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:47 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 21/27] RFC xfsprogs: Skip flip flags for delayed attrs
Date:   Mon, 26 Jul 2021 23:18:58 -0700
Message-Id: <20210727061904.11084-22-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4733e38-4e03-4d42-b365-08d950c68866
X-MS-TrafficTypeDiagnostic: BYAPR10MB2791:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27919277066A4EEB01F5056795E99@BYAPR10MB2791.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p7pYxGX9ma20kuUMt3YCoaQifFgwAJMT6jEu0iVT6BIMfVWU6YcOnKo4bbyXeJoOlq2Yc5trY5pLiVZFeVCFyX8Wx1OuXF8VgVNknJ8f5G+pLMvyL87y0J7SMW0ii0Rhb14L49xJFJWeXhKWQT7UuCro+Sg0ESLAD3MhioJ7a8qVVkX/DbkITRdQZrfezCVpy11s3pioGcQBaprzutuFIL9Q3T5pKnbLAxvJoJWuxyfVPo3yDW6sK/1NtjAbpzoNzQmv1kDHGZ1dBIs2/Y3E8UJogPThMdWavQStb5HczKtuW6QbiXAqs8yrpGvaQe6h/gAe8tOXYAnwAH8wuke/o8F8geC8ADXAEyuOAwMcARr7FARTzl3Ut0KPi0vZsZZ/14XwFtx0PIQftDThZWhSIdLfu1bRCk4iSGYUO+g3k+k6+RCW0IRLk0b9T3vtSr70WWdCi8/HPkz7lW/fDBJPfJvSpa0KkwGsshK8EwabmiVXwjbc338UILSIbc+iOBGlqse3qMMbgLWcY24G8tngQG+Zd153MrE3ntqLYzE8U96K8edAtoxhiBZnn+uv7UHjvR3EdgOIS73biLZhX2t7WBkkFxDT168raomSQ4j6af0Szj4tk76562mqvE2RfI81hZY24i1fIeBiXzSZkiZBSXH2RS4kTdJQxodfWrGTMTl1d33XBYMLA9N2s6gbsd2f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(44832011)(2906002)(36756003)(52116002)(86362001)(6916009)(83380400001)(8936002)(478600001)(956004)(1076003)(38350700002)(66476007)(6512007)(66946007)(38100700002)(66556008)(316002)(6506007)(6666004)(6486002)(26005)(5660300002)(8676002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zt+Iah015QVwzTk6y3Iiijpzr4tlQSMsE1xsw5vLY8Nh5S/LoxU94CTEv+5g?=
 =?us-ascii?Q?s+LJjs/BADAsS2I9N3Pv8aZfYZPpW9rcMYmJy5BwTdPfG8rEk2jNBC84YEPM?=
 =?us-ascii?Q?xTQmso/LqQzkCtEXzQqL5JHHMJPES6J4dSmDXMnJGnoFtG97lhuDR135CPK0?=
 =?us-ascii?Q?8HtWA4ryoSWzwWwynClZXly+lviY7SCTx3cHOXK81lw6+ftPbhbRSfZY5EJ0?=
 =?us-ascii?Q?XxZAL+axTuvpJsYZAj7/HAtJfDl02SvbsKWLrfUv8qBEcfuXxKisq3UElMmb?=
 =?us-ascii?Q?RUJOAlQOGlwJyQewAZJ3k/sa545e9xYNX3d25ItR91MhLIGNbL9I1V8U8vBT?=
 =?us-ascii?Q?yos/v6alpBA8ZO4aenn0ZS0ZudOCyWb0JcJiQRuiRK0p8Kx4hCVvpkicRIM2?=
 =?us-ascii?Q?1YD8Q9MTTBDBY7FgmkISIfDmQnAofQFdMCiisF0vXB+3TKh0dThWxBTqK12M?=
 =?us-ascii?Q?w/YJyVS/wL4sfgBzC+Xe58u3J+hm4fFwwdETBIxin9pModYq6hzGlwFL8SnM?=
 =?us-ascii?Q?tMFcuM5rL/6grmJeabyKDpe8Wx+deeKT5HSb8rPIjYcMPfulCs0lX0z1ZxtA?=
 =?us-ascii?Q?2W5otsLQ2aBLeWj8x0q9int/4VMYWecRL5c/odDPjCEL63XbDaxYn8xJNPmJ?=
 =?us-ascii?Q?dd0AFVzFXyisZ3FSD9PhgpAwMiWdfEyUBbnDjNqqRydaF6KWxaR01xvhZyfg?=
 =?us-ascii?Q?5kaHYIFpDeNvCcKMntlmVHU61NJnMwxYwRFJqus1x0CbpHVOVcFdI6m1iTwe?=
 =?us-ascii?Q?1f1pDvIpbUx5VbsUePVKJxc/HcbN8sstsqV32eEWFqD+i689KWZFHhtAurwB?=
 =?us-ascii?Q?qNkf8bB/OvYUGezfbzdTATmWSyU+TyndXGu68uT/oJhvJpgQjCerQtRrjoPB?=
 =?us-ascii?Q?JIBnjSC9OCtZgr7WyQ87CBe9dr6cLY1mcJfCm0JbJUsrN9Qm7nsjgQ2Bwx1n?=
 =?us-ascii?Q?cXQMHDXgQsAllasNyGHSBJIDwoETzFFqfkXfWwuR26lryahyO3EiQhWxgOFP?=
 =?us-ascii?Q?mFUWjLtnxNfFjj+y6CFp2pMy0s0w3VKBa8yu++uKYP4U29rsDxnZxZSPACMO?=
 =?us-ascii?Q?oYZbId9kVv8+VY6I3N9UR/k5I4dkat+qHBiSiZa1gC0ZCcReZNMHKHDX00EO?=
 =?us-ascii?Q?ALBMpE/4sZhp5DUuxXTl+6XntTJJ9x39Ic1fvBWN3eswtNYo9fdvjAmzqxDA?=
 =?us-ascii?Q?Nuj7SPk4bntRvpq3fMFwnuW5GRtIIRPRMlrwk2gCwB9JvjtOvhThbuf8Y/+V?=
 =?us-ascii?Q?V3qy4yItjwd+5r98t4rEdJhGtHihdiBEBBe8mJ7yYpjmgomrP/6na1ayYR/S?=
 =?us-ascii?Q?Dq3oqfgNF6MDEYGXlEjJtQ0g?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4733e38-4e03-4d42-b365-08d950c68866
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:47.3636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wud718N1+rp/ihsnyP2D0/S64cFwmkUJWfsqWVl8ncwFDlsRqhs3BEeGM7OSkgKWCXtJ0GJN+opCwGbLUjAs8FkotxLYdSPDC3HHJiqzPnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2791
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: cSHgT8wbdkA_tE33e3Jh5qJpKmpKMTkw
X-Proofpoint-ORIG-GUID: cSHgT8wbdkA_tE33e3Jh5qJpKmpKMTkw
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 2b1c81a8c3f453ba16b6db8dae256723bf53c051

This is a clean up patch that skips the flip flag logic for delayed attr
renames.  Since the log replay keeps the inode locked, we do not need to
worry about race windows with attr lookups.  So we can skip over
flipping the flag and the extra transaction roll for it

RFC: In the last review, folks asked for some performance analysis, so I
did a few perf captures with and with out this patch.  What I found was
that there wasnt very much difference at all between having the patch or
not having it.  Of the time we do spend in the affected code, the
percentage is small.  Most of the time we spend about %0.03 of the time
in this function, with or with out the patch.  Occasionally we get a
0.02%, though not often.  So I think this starts to challenge needing
this patch at all. This patch was requested some number of reviews ago,
be perhaps in light of the findings, it may no longer be of interest.

     0.03%     0.00%  fsstress  [xfs]               [k] xfs_attr_set_iter

Keep it or drop it?

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c      | 51 +++++++++++++++++++++++++++++---------------------
 libxfs/xfs_attr_leaf.c |  3 ++-
 2 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 70665d9..9967719 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -354,6 +354,7 @@ xfs_attr_set_iter(
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_buf			*bp = NULL;
 	int				forkoff, error = 0;
+	struct xfs_mount		*mp = args->dp->i_mount;
 
 	/* State machine switch */
 	switch (dac->dela_state) {
@@ -475,16 +476,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			return error;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		dac->dela_state = XFS_DAS_FLIP_LFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_hasdelattr(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				return error;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series.
+			 */
+			dac->dela_state = XFS_DAS_FLIP_LFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
+
+		/* fallthrough */
 	case XFS_DAS_FLIP_LFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -586,17 +592,21 @@ xfs_attr_set_iter(
 		 * In a separate transaction, set the incomplete flag on the
 		 * "old" attr and clear the incomplete flag on the "new" attr.
 		 */
-		error = xfs_attr3_leaf_flipflags(args);
-		if (error)
-			goto out;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series
-		 */
-		dac->dela_state = XFS_DAS_FLIP_NFLAG;
-		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
-		return -EAGAIN;
+		if (!xfs_hasdelattr(mp)) {
+			error = xfs_attr3_leaf_flipflags(args);
+			if (error)
+				goto out;
+			/*
+			 * Commit the flag value change and start the next trans
+			 * in series
+			 */
+			dac->dela_state = XFS_DAS_FLIP_NFLAG;
+			trace_xfs_attr_set_iter_return(dac->dela_state,
+						       args->dp);
+			return -EAGAIN;
+		}
 
+		/* fallthrough */
 	case XFS_DAS_FLIP_NFLAG:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing a
@@ -1240,7 +1250,6 @@ xfs_attr_node_addname_clear_incomplete(
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.
 	 */
-	args->attr_filter |= XFS_ATTR_INCOMPLETE;
 	state = xfs_da_state_alloc(args);
 	state->inleaf = 0;
 	error = xfs_da3_node_lookup_int(state, &retval);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index e23fc3d..056f4eb 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1478,7 +1478,8 @@ xfs_attr3_leaf_add_work(
 	if (tmp)
 		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_RENAME) {
-		entry->flags |= XFS_ATTR_INCOMPLETE;
+		if (!xfs_hasdelattr(mp))
+			entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
 		    (args->index2 <= args->index)) {
 			args->index2++;
-- 
2.7.4

