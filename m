Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B48C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59B5661185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbhIPKKS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:10:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46786 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236222AbhIPKKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:10:18 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xtCA010930;
        Thu, 16 Sep 2021 10:08:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=e50DF7VhI9Of8nEpvD+xwFQR4gsgjYlsKVMcR4QgKuw=;
 b=p0ESSverTfASywOz/VCNoPlwH1R1EfLHPk8tBWk8rd6PYBlk0TtgvEE/RMk2JO09dFcV
 3oNknPKC9eFBvdjRost6/Ztj7OIGriZhSeljDFQZPqSLj8LCRyg9k56PvV/t6GlNqckG
 vElpNaAWYilLG0VxQYbkeIzk64V0HWucB6ZmekCpimanVXvJE+MYAANZqRKM0yjcZMzo
 u83iZSf2E0BJ1Z5cPr/9DcKoXNGczQvfBbcmO7Bp0SaVf+z/Qpua3DWQj2tuSQb+IEaE
 ncHJReU9LNYugOSougPnozRTrnDA6lgWgkJ9nCgLYtR5gp9wHGk1bCGNzfl4q1GNNO2H 6A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=e50DF7VhI9Of8nEpvD+xwFQR4gsgjYlsKVMcR4QgKuw=;
 b=Au9Z/CY6Kqb+oF//73MeVB0CpsvgWLhPL9vXVovgY8DlLPLkCQ8Xv0B/PAe3WH+vOzXK
 2AbLXPxaTzNB74bD2n0/i3veEgjhwoWLb+TVjbsogWcv+ayUDsAcaFnQfWvlJcdkmifd
 e/6QsNjBTvzTY5kby27iT+5UPcgZgFWRqDqPNuMJ1CysoHRT9dMtksNt21bHgmVzRySe
 p7/MvBD/L0ipnmp1aLYrbCzByBRKQKPDd+AOk0clY4u+fzI+eokpjAyAnj5mPXiKPyhk
 xgYLjpdc5SAkxAIZoeNOqoIku98bRhSHLHP1z9x7MaHM5XTEyYUxjWsi88d4L7Z3BqWz ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3jysjvcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:08:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5G83030701;
        Thu, 16 Sep 2021 10:08:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 3b0hjxyd5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:08:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1JX//Z254h46UlBUlrinofU+p/I4S9b5TxugyPBKddygAY2niPB3PrQMXMdEaB1i+eg8xB13mLLPX9zWTKKF7vLMz5lEq3adtcN0ePx1VFe1nzgC76P5VoV+X6g0fr/VeAWnxMShyIyMQdKbhPRM/MV0h/+s6rCnE5zXi/0wk69mX5sAlYdZcNxKW8lRzyEVEu3ogFGw3kCCAAXpfhlzkHyJARiVHTzKbCGid1K5Ad6Z2oDp+6VmNl12xkxDZheItn+2ogMtqrWy4EVntK+zRnmfY4YoRApFJ+cUWVu7SL30LPT/SzDJ7sb+gwc+PKscnH0mppdp+MAMxRnPSUG+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=e50DF7VhI9Of8nEpvD+xwFQR4gsgjYlsKVMcR4QgKuw=;
 b=jkoCLUGwWYB9+Be7dCnskZI3XDtf0niYOZF52GU6RRWq9Eletsennby4K7msFykLtFLGdOo+dgHf2h05yr1haUn8qqML7b2gchHqlhmiYgUNtFls2TKobZGZTQPKaART1MCHl8GOK8j2LtSdaa9biMpF83h2yZX1h7J+JMyU/YLCtofyunaXpS+mkrw3zXAdCYNCEfpNbtWgaNqs+5o+NmE/zprTdojvJ3+P83EAMjDRz5Cufopz2brwThbj729nTksj/3sTFTKcHlliLPAS5M/JAT+LDjtK+bAAI7UcByDeAEnrGuoXfnaR7C9K3U7rZPhmaN3ny1ae7SOMSeEW0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e50DF7VhI9Of8nEpvD+xwFQR4gsgjYlsKVMcR4QgKuw=;
 b=Tv7bi2I7wt0qMbXyPiB4lzQCGxw0DshDpW6YQFWOk32UWRKF6/RE6Xc0/NFOhUHdkh91wOM758luKQs2V6vkj0ElbMZVUl9QD9AuKVNiCmF47XPJ5sa3iCG0AfhQyFj9DB24K6cAY10sF01UtfGcWTMDBQWWufE44YUCurqyBFI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:08:52 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:08:52 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH V3 01/16] xfsprogs: xfs_repair: allow administrators to add older v5 features
Date:   Thu, 16 Sep 2021 15:38:07 +0530
Message-Id: <20210916100822.176306-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100822.176306-1-chandan.babu@oracle.com>
References: <20210916100822.176306-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MA1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:08:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03d48c3d-9886-411a-e18c-08d978f9fc07
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB287879AACD9230E6B1B3D82CF6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U0s0icYHPAM4yPJg7lejkvUKVKG76G/w9t1XIXdA0dJMRj1rA0AiZZ1RG8uVI9ELgPtRvot3jDjzs1jtwen2gE+XxCF7aqMoyF4HaUayUn3ohpD7qgUPIb4A9wWNfw/IZTrxAtfd1XuMWtei9AxJ4b9ILEM/AhxNeAB+sMJS+VVTWg1OzoLY59zINeIzC019nQ//TmXj2TvPs2yi7RRyrxE0DxrHLmWJb3T/LkOA5u+GUnoYWQxvDtx2eXSs19wwom+CxSEVwBCfozcWwnw1mHk1dG18vPDMabuQayh3D4Scl4l9l/GaP7vrN6xk9wBydDLWJ8Tf9Z1NaZqqaxf8D70jVD3R8LziTcAma9sHl1R0QMA4sSwhJjKxafKVfIxH01GbIcZTVaaTMDbkjXu3aPe/8SH05Bnx/IH7PKjYIbhHQvExEaxwRPWvIAhSA7T19CYJADdGFzewT1++mH8mqui2p9z7AKKCFXqbP2ZAbXturmyJR+iKBRBZCJ/tdulqRE9RL4y/fp6Mdg+qR1iPYG0OPF2koQpCWI2pyD9/0Yn57xLWKwvhpMo3iUJidQBG9daNTgckeiCyfzvACV445SVxx/SZRCNdhPOeQdXGjVx6XmGJmBsiOZCnMu8M8wCKEC5JKH/TikR7Ua26rs9tQQjgBJGtEuvyTtZjargg58/cPjJm8OTS0j3jM/rkT4FsJed9sgj07IiEdxub9pnfLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(54906003)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(107886003)(30864003)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H3+rlm32jTOU7LSgCEt+dk1Jp+BOv3k5ulbhfUO68u+sjpz1gFm6qsZNbvOZ?=
 =?us-ascii?Q?OP6d+8ZnKCNgM0V+STHodHonf/oUuZ373MVvgr+r7oPWoUXx9uCWjZAsWA2w?=
 =?us-ascii?Q?PRVkTcp7iUNA0TKdQI/NpDLVEbo7f1HRK3nHbAKRSYUYsyf5u7CWuwOv/xpE?=
 =?us-ascii?Q?UB9HijWGWUzKPQeRzQ+4ZLMrE1M733Q1o8V9wEgEk/g0fOo6POWfkLoml7EO?=
 =?us-ascii?Q?L7sBbi4GoyjvoraGVXqZXX+/Xv2EbN+J+f81FpoNzH3PtTGA/N6mHDMytblt?=
 =?us-ascii?Q?3ApeIwfKb+paX3NdF6k/ke6h88vdP/xHlY6ickq4Xz5OiRIYWlfVkxByU2jR?=
 =?us-ascii?Q?j3QPMJ93r7AWOmOcKr/RTYyRIVy7PB4MT1vTD0UIXVDxDzLhOgkIxv0dU6o2?=
 =?us-ascii?Q?UKH+DcvVESDQEQtLpRR70c6NxkSsRuF55M7bPnvKyRrWWlN+4eprxXaKjf5v?=
 =?us-ascii?Q?aah8me03Odhfid2Z78N+GCsEySkXHvpV1llaVdgU4D0sXmuiOtgK1n02vMMl?=
 =?us-ascii?Q?KVe6jjqY7r4dIi5IChZyWcqV7IIXjX4iHJlp6pGpVfpWIvp5cFQP3Mr8JELx?=
 =?us-ascii?Q?wdTCItCP2ThShPCbbPpCotxjD1pYwLFfIAwhQ0T5S11M0cT/8bjJQwKfHp7l?=
 =?us-ascii?Q?BWSPFds95wGbLPiYUy7yI67k8ZpNxAl7A8hdODQeGdu9OUfI/wFRGrHnvSCV?=
 =?us-ascii?Q?qEJlZrdID/qtsrHHVXTcCFZ+OVXqWQWJ9XWF7+t2s1+TgFBN5EnAxAYWUhna?=
 =?us-ascii?Q?ExmTGDr9lLadaQoVpHUu59335cTnoT5nCTekQaymwTLkpv59GMBZW7p6m+LJ?=
 =?us-ascii?Q?61XMPNwiJ9oTqo5fr8fLF4NcY1JsQE1IYvXEhdhfNZsiH2f4WecP/tq8bktb?=
 =?us-ascii?Q?A62lgb34X5qBxKq1LTwCFGZajzsdXOHxT+5HJHwzqU5eCtjvUdTJfez789iR?=
 =?us-ascii?Q?JFcd4FgSpRv2YesNrEuvsAJKcs3YsMy+GXH3L9DsZzJB1OTEQAuKpja+neIE?=
 =?us-ascii?Q?uxWTuhk3BogEDLWNhNBhV42YIxLcMFxEMS0PPENAkCM9LXVuLoDvFjxLWHe0?=
 =?us-ascii?Q?n47wCuUv/A1uNkuewowK81VcnkJMXfCCyEhGnph4DjflfAj7SZTMGdikbI9+?=
 =?us-ascii?Q?Y4kqouPsPp5P5queJWX7BXot2Mn+bPuDd2H/f7Imn+BIoYUc7Y7o4uxk0Ezk?=
 =?us-ascii?Q?YeqHUAOgiJbY2F/2EFwc1Ha1jdtfOfukCLtqHbu/DKu4NzNZXDcHmcTLUsba?=
 =?us-ascii?Q?JtjZZbHSprGBUFU8+ZrF7wJiygDVZX7q9QT9pkCJZ2xQXBRGo6vT5tvL2VwR?=
 =?us-ascii?Q?iFxsV8DxP2xZJ9ZfcoZ2ZDD/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d48c3d-9886-411a-e18c-08d978f9fc07
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:08:52.6861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XRVPw3WoInXNm1mmFNrXO9A0oIu+CB9x+gVzMgxNeiAVXu4fyh6gH7KJ3usC8BpepW70DU96vcK1xveNlaA4QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: iRK8FNjV8XbLKzX8IpTgnmNiLVtkIwMC
X-Proofpoint-ORIG-GUID: iRK8FNjV8XbLKzX8IpTgnmNiLVtkIwMC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Add to xfs_db the ability to add certain existing features (finobt,
reflink, and rmapbt) to an existing filesystem if it's eligible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 include/libxfs.h         |   1 +
 libxfs/libxfs_api_defs.h |   3 +
 man/man8/xfs_admin.8     |  30 +++++
 repair/dino_chunks.c     |   6 +-
 repair/dinode.c          |   5 +-
 repair/globals.c         |   4 +
 repair/globals.h         |   4 +
 repair/phase2.c          | 285 +++++++++++++++++++++++++++++++++++++--
 repair/phase4.c          |   5 +-
 repair/protos.h          |   1 +
 repair/rmap.c            |   4 +-
 repair/xfs_repair.c      |  44 ++++++
 12 files changed, 377 insertions(+), 15 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index 82618a56..7100155f 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -79,6 +79,7 @@ struct iomap;
 #include "xfs_refcount.h"
 #include "xfs_btree_staging.h"
 #include "xfs_imeta.h"
+#include "xfs_ag_resv.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 55dcedeb..d4d0c281 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -21,6 +21,8 @@
 
 #define xfs_ag_init_headers		libxfs_ag_init_headers
 #define xfs_ag_block_count		libxfs_ag_block_count
+#define xfs_ag_resv_free		libxfs_ag_resv_free
+#define xfs_ag_resv_init		libxfs_ag_resv_init
 
 #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
 #define xfs_allocbt_maxrecs		libxfs_allocbt_maxrecs
@@ -121,6 +123,7 @@
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
+#define xfs_ialloc_read_agi		libxfs_ialloc_read_agi
 #define xfs_icreate			libxfs_icreate
 #define xfs_icreate_args_rootfile	libxfs_icreate_args_rootfile
 #define xfs_idata_realloc		libxfs_idata_realloc
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index ad28e0f6..4f3c882a 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -149,6 +149,36 @@ Upgrade a filesystem to support larger timestamps up to the year 2486.
 The filesystem cannot be downgraded after this feature is enabled.
 Once enabled, the filesystem will not be mountable by older kernels.
 This feature was added to Linux 5.10.
+.TP 0.4i
+.B finobt
+Track free inodes through a separate free inode btree index to speed up inode
+allocation on old filesystems.
+This upgrade can fail if any AG has less than 1% free space remaining.
+The filesystem cannot be downgraded after this feature is enabled.
+This feature was added to Linux 3.16.
+.TP 0.4i
+.B reflink
+Enable sharing of file data blocks.
+This upgrade can fail if any AG has less than 2% free space remaining.
+The filesystem cannot be downgraded after this feature is enabled.
+This feature was added to Linux 4.9.
+.TP 0.4i
+.B rmapbt
+Store an index of the owners of on-disk blocks.
+This enables much stronger cross-referencing of various metadata structures
+and online repairs to space usage metadata.
+The filesystem cannot be downgraded after this feature is enabled.
+This upgrade can fail if any AG has less than 5% free space remaining.
+This feature was added to Linux 4.8.
+.TP 0.4i
+.B metadir
+Create a directory tree of metadata inodes instead of storing them all in the
+superblock.
+This is required for reverse mapping btrees and reflink support on the realtime
+device.
+The filesystem cannot be downgraded after this feature is enabled.
+This upgrade can fail if any AG has less than 5% free space remaining.
+This feature is not upstream yet.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index bdefef40..160dd4cc 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -963,7 +963,11 @@ next_readbuf:
 		}
 
 		if (status)  {
-			if (mp->m_sb.sb_rootino == ino) {
+			if (wipe_pre_metadir_file(ino)) {
+				if (!ino_discovery)
+					do_warn(
+	_("wiping pre-metadir metadata inode %"PRIu64".\n"), ino);
+			} else if (mp->m_sb.sb_rootino == ino) {
 				need_root_inode = 1;
 
 				if (!no_modify)  {
diff --git a/repair/dinode.c b/repair/dinode.c
index 758b1a15..0ffb3e6e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2386,6 +2386,9 @@ process_dinode_int(
 	ASSERT(uncertain == 0 || verify_mode != 0);
 	ASSERT(ino_bpp != NULL || verify_mode != 0);
 
+	if (wipe_pre_metadir_file(lino))
+		goto clear_bad_out;
+
 	/*
 	 * This is the only valid point to check the CRC; after this we may have
 	 * made changes which invalidate it, and the CRC is only updated again
@@ -2593,7 +2596,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		if (flags & XFS_DIFLAG_NEWRTBM) {
 			/* must be a rt bitmap inode */
 			if (lino != mp->m_sb.sb_rbmino) {
-				if (!uncertain) {
+				if (!uncertain && !add_metadir) {
 					do_warn(
 	_("inode %" PRIu64 " not rt bitmap\n"),
 						lino);
diff --git a/repair/globals.c b/repair/globals.c
index 7f7bafe3..6e52bac9 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -50,6 +50,10 @@ int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 int	lazy_count;		/* What to set if to if converting */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
+bool	add_finobt;		/* add free inode btrees */
+bool	add_reflink;		/* add reference count btrees */
+bool	add_rmapbt;		/* add reverse mapping btrees */
+bool	add_metadir;		/* add metadata directory tree */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 1964c18c..6c69413f 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -91,6 +91,10 @@ extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 extern int	lazy_count;		/* What to set if to if converting */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
+extern bool	add_finobt;		/* add free inode btrees */
+extern bool	add_reflink;		/* add reference count btrees */
+extern bool	add_rmapbt;		/* add reverse mapping btrees */
+extern bool	add_metadir;		/* add metadata directory tree */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 51234ee9..cca154d3 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -133,7 +133,8 @@ zero_log(
 
 static bool
 set_inobtcount(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
 {
 	if (!xfs_has_crc(mp)) {
 		printf(
@@ -153,14 +154,15 @@ set_inobtcount(
 	}
 
 	printf(_("Adding inode btree counts to filesystem.\n"));
-	mp->m_sb.sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
-	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
 	return true;
 }
 
 static bool
 set_bigtime(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
 {
 	if (!xfs_has_crc(mp)) {
 		printf(
@@ -174,8 +176,256 @@ set_bigtime(
 	}
 
 	printf(_("Adding large timestamp support to filesystem.\n"));
-	mp->m_sb.sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
-					  XFS_SB_FEAT_INCOMPAT_BIGTIME);
+	new_sb->sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
+					 XFS_SB_FEAT_INCOMPAT_BIGTIME);
+	return true;
+}
+
+/* Make sure we can actually upgrade this (v5) filesystem. */
+static void
+check_new_v5_geometry(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	struct xfs_sb		old_sb;
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	xfs_ino_t		rootino;
+	int			min_logblocks;
+	int			error;
+
+	/*
+	 * Save the current superblock, then copy in the new one to do log size
+	 * and root inode checks.
+	 */
+	memcpy(&old_sb, &mp->m_sb, sizeof(struct xfs_sb));
+	memcpy(&mp->m_sb, new_sb, sizeof(struct xfs_sb));
+
+	/* Do we have a big enough log? */
+	min_logblocks = libxfs_log_calc_minimum_size(mp);
+	if (old_sb.sb_logblocks < min_logblocks) {
+		printf(
+	_("Filesystem log too small to upgrade filesystem; need %u blocks, have %u.\n"),
+				min_logblocks, old_sb.sb_logblocks);
+		exit(0);
+	}
+
+	rootino = libxfs_ialloc_calc_rootino(mp, new_sb->sb_unit);
+	if (old_sb.sb_rootino != rootino) {
+		printf(
+	_("Cannot upgrade filesystem, root inode (%llu) cannot be moved to %llu.\n"),
+				(unsigned long long)old_sb.sb_rootino,
+				(unsigned long long)rootino);
+		exit(0);
+	}
+
+	/* Make sure we have enough space for per-AG reservations. */
+	for_each_perag(mp, agno, pag) {
+		struct xfs_trans	*tp;
+		struct xfs_agf		*agf;
+		struct xfs_buf		*agi_bp, *agf_bp;
+		unsigned int		avail, agblocks;
+
+		/*
+		 * Create a dummy transaction so that we can load the AGI and
+		 * AGF buffers in memory with the old fs geometry and pin them
+		 * there while we try to make a per-AG reservation with the new
+		 * geometry.
+		 */
+		error = -libxfs_trans_alloc_empty(mp, &tp);
+		if (error)
+			do_error(
+	_("Cannot reserve resources for upgrade check, err=%d.\n"),
+					error);
+
+		error = -libxfs_ialloc_read_agi(mp, tp, agno, &agi_bp);
+		if (error)
+			do_error(
+	_("Cannot read AGI %u for upgrade check, err=%d.\n"),
+					agno, error);
+
+		error = -libxfs_alloc_read_agf(mp, tp, agno, 0, &agf_bp);
+		if (error)
+			do_error(
+	_("Cannot read AGF %u for upgrade check, err=%d.\n"),
+					agno, error);
+		agf = agf_bp->b_addr;
+		agblocks = be32_to_cpu(agf->agf_length);
+
+		error = -libxfs_ag_resv_init(pag, tp);
+		if (error == ENOSPC) {
+			printf(
+	_("Not enough free space would remain in AG %u for metadata.\n"),
+					agno);
+			exit(0);
+		}
+		if (error)
+			do_error(
+	_("Error %d while checking AG %u space reservation.\n"),
+					error, agno);
+
+		/*
+		 * Would we have at least 10% free space in this AG after
+		 * making per-AG reservations?
+		 */
+		avail = pag->pagf_freeblks + pag->pagf_flcount;
+		avail -= pag->pag_meta_resv.ar_reserved;
+		avail -= pag->pag_rmapbt_resv.ar_asked;
+		if (avail < agblocks / 10)
+			printf(
+	_("AG %u will be low on space after upgrade.\n"),
+					agno);
+
+		libxfs_ag_resv_free(pag);
+
+		/*
+		 * Mark the per-AG structure as uninitialized so that we don't
+		 * trip over stale cached counters after the upgrade, and
+		 * release all the resources.
+		 */
+		libxfs_trans_cancel(tp);
+		pag->pagf_init = 0;
+		pag->pagi_init = 0;
+	}
+
+	/*
+	 * Put back the old superblock.
+	 */
+	memcpy(&mp->m_sb, &old_sb, sizeof(struct xfs_sb));
+}
+
+static bool
+set_finobt(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Free inode btree feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_finobt(mp)) {
+		printf(_("Filesystem already supports free inode btrees.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding free inode btrees to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_FINOBT;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
+static bool
+set_reflink(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Reflink feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_reflink(mp)) {
+		printf(_("Filesystem already supports reflink.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding reflink support to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
+static bool
+set_rmapbt(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Reverse mapping btree feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_reflink(mp)) {
+		printf(
+	_("Reverse mapping btrees cannot be added when reflink is enabled.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_rmapbt(mp)) {
+		printf(_("Filesystem already supports reverse mapping btrees.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding reverse mapping btrees to filesystem.\n"));
+	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
+static xfs_ino_t doomed_rbmino = NULLFSINO;
+static xfs_ino_t doomed_rsumino = NULLFSINO;
+static xfs_ino_t doomed_uquotino = NULLFSINO;
+static xfs_ino_t doomed_gquotino = NULLFSINO;
+static xfs_ino_t doomed_pquotino = NULLFSINO;
+
+bool
+wipe_pre_metadir_file(
+	xfs_ino_t	ino)
+{
+	if (ino == doomed_rbmino ||
+	    ino == doomed_rsumino ||
+	    ino == doomed_uquotino ||
+	    ino == doomed_gquotino ||
+	    ino == doomed_pquotino)
+		return true;
+	return false;
+}
+
+static bool
+set_metadir(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Metadata directory trees only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_metadir(mp)) {
+		printf(_("Filesystem already supports metadata directory trees.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding metadata directory trees to filesystem.\n"));
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_METADIR;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+
+	/* Blow out all the old metadata inodes; we'll rebuild in phase6. */
+	new_sb->sb_metadirino = new_sb->sb_rootino + 1;
+	doomed_rbmino = mp->m_sb.sb_rbmino;
+	doomed_rsumino = mp->m_sb.sb_rsumino;
+	doomed_uquotino = mp->m_sb.sb_uquotino;
+	doomed_gquotino = mp->m_sb.sb_gquotino;
+	doomed_pquotino = mp->m_sb.sb_pquotino;
+
+	new_sb->sb_rbmino = NULLFSINO;
+	new_sb->sb_rsumino = NULLFSINO;
+	new_sb->sb_uquotino = NULLFSINO;
+	new_sb->sb_gquotino = NULLFSINO;
+	new_sb->sb_pquotino = NULLFSINO;
+
+	/* Indicate that we need a rebuild. */
+	need_metadir_inode = 1;
+	need_rbmino = 1;
+	need_rsumino = 1;
+	have_uquotino = 0;
+	have_gquotino = 0;
+	have_pquotino = 0;
 	return true;
 }
 
@@ -184,16 +434,31 @@ static void
 upgrade_filesystem(
 	struct xfs_mount	*mp)
 {
+	struct xfs_sb		new_sb;
 	struct xfs_buf		*bp;
 	bool			dirty = false;
 	int			error;
 
+	memcpy(&new_sb, &mp->m_sb, sizeof(struct xfs_sb));
+
 	if (add_inobtcount)
-		dirty |= set_inobtcount(mp);
+		dirty |= set_inobtcount(mp, &new_sb);
 	if (add_bigtime)
-		dirty |= set_bigtime(mp);
-
-        if (no_modify || !dirty)
+		dirty |= set_bigtime(mp, &new_sb);
+	if (add_finobt)
+		dirty |= set_finobt(mp, &new_sb);
+	if (add_reflink)
+		dirty |= set_reflink(mp, &new_sb);
+	if (add_rmapbt)
+		dirty |= set_rmapbt(mp, &new_sb);
+	if (add_metadir)
+		dirty |= set_metadir(mp, &new_sb);
+	if (!dirty)
+		return;
+
+	check_new_v5_geometry(mp, &new_sb);
+	memcpy(&mp->m_sb, &new_sb, sizeof(struct xfs_sb));
+	if (no_modify)
                 return;
 
         bp = libxfs_getsb(mp);
diff --git a/repair/phase4.c b/repair/phase4.c
index 7f23d564..b752b07c 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -303,7 +303,10 @@ phase4(xfs_mount_t *mp)
 	if (xfs_has_metadir(mp) &&
 	    (is_inode_free(irec, 1) || !inode_isadir(irec, 1))) {
 		need_metadir_inode = true;
-		if (no_modify)
+		if (add_metadir)
+			do_warn(
+	_("metadata directory root inode needs to be initialized\n"));
+		else if (no_modify)
 			do_warn(
 	_("metadata directory root inode would be lost\n"));
 		else
diff --git a/repair/protos.h b/repair/protos.h
index 83734e85..51432703 100644
--- a/repair/protos.h
+++ b/repair/protos.h
@@ -43,3 +43,4 @@ void	phase7(struct xfs_mount *, int);
 int	verify_set_agheader(struct xfs_mount *, struct xfs_buf *,
 		struct xfs_sb *, struct xfs_agf *, struct xfs_agi *,
 		xfs_agnumber_t);
+bool wipe_pre_metadir_file(xfs_ino_t ino);
diff --git a/repair/rmap.c b/repair/rmap.c
index 6a497c30..a72c3b27 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -49,8 +49,8 @@ bool
 rmap_needs_work(
 	struct xfs_mount	*mp)
 {
-	return xfs_has_reflink(mp) ||
-	       xfs_has_rmapbt(mp);
+	return xfs_has_reflink(mp) || add_reflink ||
+	       xfs_has_rmapbt(mp) || add_rmapbt;
 }
 
 /*
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9fc81a83..95360776 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -67,6 +67,10 @@ enum c_opt_nums {
 	CONVERT_LAZY_COUNT = 0,
 	CONVERT_INOBTCOUNT,
 	CONVERT_BIGTIME,
+	CONVERT_FINOBT,
+	CONVERT_REFLINK,
+	CONVERT_RMAPBT,
+	CONVERT_METADIR,
 	C_MAX_OPTS,
 };
 
@@ -74,6 +78,10 @@ static char *c_opts[] = {
 	[CONVERT_LAZY_COUNT]	= "lazycount",
 	[CONVERT_INOBTCOUNT]	= "inobtcount",
 	[CONVERT_BIGTIME]	= "bigtime",
+	[CONVERT_FINOBT]	= "finobt",
+	[CONVERT_REFLINK]	= "reflink",
+	[CONVERT_RMAPBT]	= "rmapbt",
+	[CONVERT_METADIR]	= "metadir",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -324,6 +332,42 @@ process_args(int argc, char **argv)
 		_("-c bigtime only supports upgrades\n"));
 					add_bigtime = true;
 					break;
+				case CONVERT_FINOBT:
+					if (!val)
+						do_abort(
+		_("-c finobt requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c finobt only supports upgrades\n"));
+					add_finobt = true;
+					break;
+				case CONVERT_REFLINK:
+					if (!val)
+						do_abort(
+		_("-c reflink requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c reflink only supports upgrades\n"));
+					add_reflink = true;
+					break;
+				case CONVERT_RMAPBT:
+					if (!val)
+						do_abort(
+		_("-c rmapbt requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c rmapbt only supports upgrades\n"));
+					add_rmapbt = true;
+					break;
+				case CONVERT_METADIR:
+					if (!val)
+						do_abort(
+		_("-c metadir requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c metadir only supports upgrades\n"));
+					add_metadir = true;
+					break;
 				default:
 					unknown('c', val);
 					break;
-- 
2.30.2

