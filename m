Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CFCC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344392AbiCUFW3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344390AbiCUFW2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C323B3FD
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:21:04 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KKxfve031084;
        Mon, 21 Mar 2022 05:21:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=CLb5S+zLttDaeJi8p0l56X0pakZasocuWhPtyxCdmmI=;
 b=OiR/KLMR9KuTmX55H3rO3vqQJjoJcJjnNo/xDFssaKrJDOyrTy0xePGe9RSyFzRVPhEI
 CSXZDYGCoaJQWI7weeWaUsqHvuAZnmuAM/1F2ByXdvQ0+P5FKET7jqGCWIkXvZUKbOhm
 3LWIHFnJWykziz8rW0qT390ZSQFQn09NJJqjFbE1wNcwkTiFgJDO//y8wcDGYUyZA+Xz
 DY9CTFMyxIJlio4Ur165Y5ed2hLxOBMM1FFNUuejGYxULisakGB5rG/FxTZOgxtImWCp
 Vb415OZScTpE6tobjwYcYTcURO2gexfW+XsjEeIA9nSYwEgVnTb4JeJRgclIpPXTM7U5 FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcj4tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:21:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5Hp3h091961;
        Mon, 21 Mar 2022 05:21:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by userp3030.oracle.com with ESMTP id 3ew49r2h3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+Ay5IAQQLX/xdw3LWLCixltp8sPD1YhuY+RCIO6JMajFKSr3vuqNBhDvHWBa5L/+qA6KQPQDXFfLqNqzno89ysJ+ZRnxeQAqPJZAHitL+k3PCdqtgdQX2Nnhz1+npSO7qBO9upCXiGKk/TWGBvZRccaSN9odfZpdF+rrQ8BvxvwQkRwdAPMdi+iHNEsxe31BYA4TjcAQoZ40HmKetWbQ7FXUBp6CwpwEhtgtWF8mRFaX8PGN8tIdYzgQ59V4pHMjVJMkiKkY/Z1xpgSzQRZeGV40qessfyyllemdVg3bqzEs9ncGp9Kn5t13KFxYkwAdAZcrdl3FwlrFNfCjpBvbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLb5S+zLttDaeJi8p0l56X0pakZasocuWhPtyxCdmmI=;
 b=HN3Griu0MeQoHKy5gxKxhGplQkBOqUZTLpPQnG4pE3L9UDVsHfX6VBdQxnYxUt9w3hispKLYq0F57yf1GdrT1n/EM502yI9vhBEGcaOtQFS07a87MLO7olNGsstsjgR3xgb3IhmeAj91118+AFVdP9qio0ZTkRATaURXlnuDt1rBzjrBh8NtMu3GRU8H7mrU1DUvS2+fI6cvhD9w91+KpgetgUpofoOR3z/w55UZa1XCiceaGabFDjx2Z0xpili62OSZKOVDUwt2+mx9quNys083Hs7QjltQbbpKQ9ySE4NeBBYOImRfDXDYGW1wrrw5CivObVK7Ca7Pv+SLpPxKgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLb5S+zLttDaeJi8p0l56X0pakZasocuWhPtyxCdmmI=;
 b=l3qX9xGlyn8+At25DY+N/5dRSycv0/uWQrW5/D0PQX1dI7UieKyWQb5TC9JGZ7fHPmlxc7IB3pPiUFu4xx9CN9IYR1KTAdOC9O7DWw0VvAtdnUUxTcklEuBtSPOijbEjocrxzJEz5uZSoNrYNEAbRGLVSchluQSxLGcR+ubIiFo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:20:58 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:20:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 08/18] xfsprogs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs feature bit
Date:   Mon, 21 Mar 2022 10:50:17 +0530
Message-Id: <20220321052027.407099-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b90e3524-c4c1-45ef-13ae-08da0afa94cf
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5563CDC27EF3EDBBDD921716F6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0x+XXQgNgnQzg+IMwjhVsC0vGPz4h14iu/MVUPZIapQsnLTz8J6roPZTwUGXerlTWz5DOr+7rehQx9ed/X7F6XJ2d9fOQMX22+SxOK/ksdjdzCWDkjNXzjSEjION/6YTOClcUHrjvD7qhvcl7wxFlV4MkR8aK2ew09p6PcSNtZupHOmptFvTDBwW4E8OT2UX5x1H84e63m0wYggOnDLcyLurNA+g08Q9CuFoUVEN84dSlCafwjHxUSkgR3vB2v1CYZNsOXnltiM1OW0h9H4gJgwHCD4GQwATAluE7zbD5VGjlmEu9kLUcx8inMaoRc3hqRM2div/9L3gm/h464r6ZvHWKjffPQw8NvzniMv4K0DH+FuhbBy9msNJan5ijyq3a0pwPMvYg4a2+kd5LF8tAtHV+e4FmgYgt8RXnaRB8pR01STXkF4bOCu3+E3VIT9eb6GZgnE5XhCF7Debv9xeJzXZyUtLZkPb1WX1sM+doy1Bs9EHD2SN36h/o5THNNqEaHmHjMNrCFRQSL9ku4QIKpMHmhCfHrJQqUOfo+cBHgjDOiswOlnAzAnd4xwo0Gd95IUPoOUgwk1hQtVFFJwqr9gM9PEqhcIj9EobLIs2y5B+7ve9vxE6WXAneEyU9p4FuBxiLZJcgRU8/JCfUL34uUG4l5IO6SRI27ylqmqNnSWpFl5CiW3qVyfotXiQ8/bFpcCvAlbEnD5HQFF99LWxyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aPvzgGXNTDAb2IKc82X5AJnTNk/bJXK7danP7pMzIa1QAm+R5RkWwraMyBSo?=
 =?us-ascii?Q?HXisiXAgHPUSXnDr5QprgUUAGe35y2sW63juDKaEfm6/ou1BaUNsrDduA6pj?=
 =?us-ascii?Q?KvK9u+nN6HrCCQv+M6iTsc2Rqyzdc8hDEGuSy1xc9AIYSE8ChUOlP6r/gD7U?=
 =?us-ascii?Q?fi/t/cqd4gRFYpScAaei/JQR+T9LVYrF6RuocsPVZ/ryiSWUdIVL4j2sf/X7?=
 =?us-ascii?Q?du2bSIKbgTtpZMziu4fv6hzn0sUdBbX5OZ99ZsEITk9dP8BcAZKKFIMYqxvp?=
 =?us-ascii?Q?vsow15FfU1hxYhGwTrz78bJLm0usaCcBvkTF0O+HHqbBLPmepuU2xJLSP8Te?=
 =?us-ascii?Q?daFouCm3ExfFp2qIOdNLe/Fi1rfP2VHWcRK9FN9Kv471x5050GjuNbN5uoGX?=
 =?us-ascii?Q?DylfytM+nqKUXr+gXmMGqjXHeqLeKxYSUWWe2yiPw6vDvmQC45KzT/HOpdfI?=
 =?us-ascii?Q?vpV/9PjL9OxlDmqfxMmh+OzOcVSh4r//BNZPP+NMNqiNU9tcOtTQHimLpn5d?=
 =?us-ascii?Q?CJxJ4Hv9wYSPdvSA1Az5RUZxROEsBsykydzpw97DeYbqwqqNHtolveM2PA8b?=
 =?us-ascii?Q?YGRP/qw4lPWfs+GenXWkz90ww8eqXhXXABEkH/I4auf1NzSfNdOypwmZaBZN?=
 =?us-ascii?Q?jR/lzSeYNsBkRFMt0igCNTi9O+yI72vkGMAdLEG1GGP0xat4AzAa6KeoetXn?=
 =?us-ascii?Q?QN3FhyhbAZyofmvjtZmZ4JBGSQUjbKAbp+Moxmmts3K2wsrVo5zHXszv6tq2?=
 =?us-ascii?Q?A74l2Wk2jEpWanMfzNwKnNUmFIksqUsQtAouajYpOoiezxZACesXPFJVAXCG?=
 =?us-ascii?Q?n5S+CH6c/3yc99hudyyEAJb60SZqxDwAYEKtfqx81Ru3BeTiffcH9gdz3REL?=
 =?us-ascii?Q?oNFK1g5U/liynDOULEaiFDEupU1Q1S5cjl50xbdbJmB+FRPWmDsj6GwTmxX3?=
 =?us-ascii?Q?Sx/1zsPiHqtoLfHrttL2SZ4JV9xh0MXblB/Dc8hvxoAIRblwuE47ed7Td4Vf?=
 =?us-ascii?Q?ga+eVN5RydcRXu3kuOoigGSfQRUHnOPlG8M2doIeuPKtRtKRRtC93EtkrTeU?=
 =?us-ascii?Q?S1j/jjqzv75t7PMniiEf8zzCIJdeWjkBX+rmnYB+Wzbf/3EhoUjoCLgiN9Zf?=
 =?us-ascii?Q?DzGtIMSugRuaGQWSxWyb6EzwzFsSueoup+45wb/WN1GYPb9/beLbcGXJP0+E?=
 =?us-ascii?Q?AAlQMkszM9p2usMvW/nf20Vlgvubs/On8YkdXtpcrD/Uajtq/D749ZZwrhem?=
 =?us-ascii?Q?20G6gk5sfeCgOSg9ggJyE4WyrQI9oAGmj/gRvs0IiYQWl+xOF5LJtmrj0plT?=
 =?us-ascii?Q?DtICTsIm8HXxQc6lm/CTEGE1bNnxYrdTEfS/zHAVKl2NYcZ7Ma3YFUoTxu/B?=
 =?us-ascii?Q?rYUBBe88CWbYzh/HCL5hcceuJQj1/BxPbz2UIsMUbMYGa4krVzEgK+Cb6MY6?=
 =?us-ascii?Q?IfKmwOfcEuMhSx1ol2S5TS4gB1gQDYjPSpaopILAZ7HL9WtQu5j+7g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b90e3524-c4c1-45ef-13ae-08da0afa94cf
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:20:58.3871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mYMz8krubYcaTmnRgvYhB+TZIeMukNcnSXXDeCygFFrI+AC19iAkixdvoLhzZIVKCe6sIgxV1QPBBEgtv/wQ0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210033
X-Proofpoint-GUID: jLNCErIrTGka74m3Q-o8RupL0kHVrSah
X-Proofpoint-ORIG-GUID: jLNCErIrTGka74m3Q-o8RupL0kHVrSah
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
which support large per-inode extent counters. This commit defines the new
incompat feature bit and the corresponding per-fs feature bit (along with
inline functions to work on it).

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/sb.c             | 2 ++
 include/xfs_mount.h | 2 ++
 libxfs/xfs_format.h | 1 +
 libxfs/xfs_sb.c     | 3 +++
 4 files changed, 8 insertions(+)

diff --git a/db/sb.c b/db/sb.c
index 7510e00f..2d508c26 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -704,6 +704,8 @@ version_string(
 		strcat(s, ",BIGTIME");
 	if (xfs_has_needsrepair(mp))
 		strcat(s, ",NEEDSREPAIR");
+	if (xfs_has_large_extent_counts(mp))
+		strcat(s, ",NREXT64");
 	return s;
 }
 
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 8139831b..f05eb2af 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -154,6 +154,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
+#define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
@@ -197,6 +198,7 @@ __XFS_HAS_FEAT(realtime, REALTIME)
 __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
+__XFS_HAS_FEAT(large_extent_counts, NREXT64)
 
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index b5e9256d..cae7ffd5 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
+#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* 64-bit data fork extent counter */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 986f9466..7ab13e07 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -122,6 +122,9 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_BIGTIME;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
 		features |= XFS_FEAT_NEEDSREPAIR;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
+		features |= XFS_FEAT_NREXT64;
+
 	return features;
 }
 
-- 
2.30.2

