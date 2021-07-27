Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4FFC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD3860F94
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhG0GVN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:13 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:37440 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235063AbhG0GVM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:12 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6HBMj010846
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=aDQLaK5WJnL1x3iOJjbyn9lTSkPdD7xIyVBfaOWF+Ew=;
 b=A/cFO0z/s+MfFWc8iFp1PwkGNZh2h7CI953th4rU92Z2XvxZTsM0EG+k+Zbk3GNIcbGU
 Q6JDPCJRh/2RlP735Y/8Zxo+YToU0uOZPW7mW8zUrZmPRYeopXqz7KQ6Guf86jxAPzmB
 AQGEB+YCQljom7r1KuFFi5NtEumyuM+uqMzYiaTTi3W1guWdKYsbSUwpNROoAVBxMrGc
 pI8xaQXyMtt6HeScuNUB5dJ5RAEwxOMWAi0Tt99OYbCeI7Oy+un8bAWbbH1c4hMEakED
 CW4VCm8z2nrpwjKZtGxRlyVLuRZgNsf4GgB7mvKA5JHoI+ZyuOsbyVIbQgYVLEStgo03 Nw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=aDQLaK5WJnL1x3iOJjbyn9lTSkPdD7xIyVBfaOWF+Ew=;
 b=i0ogaVtUhRvgI5iuaOSgWZ0q6BP7Qb/kVeflhEeXo15mu2Pn525vf0xPABPfJMkJhbcG
 4r5nY4U2uRvnM6WFeVChdLzkhLrdHleGdtED9WcfcknGkUbX7kMxCGbobdzxRQA71Ipp
 dMtGoGlyu6aiG72gWtzd/euw0kR14okFbXSA9XZINoZ1grNk6IV/rbaKZ+Ctt1qNCvCT
 jVD8B6hm9soRc0xc5O3H8/1d062x1BZKg4i21w9l+kJHD637ILG1WiErOb3yJxYVl4Dy
 oYfpc88s/p9eyYSYTBtKBpiGSjKvEZ/vZpxjghijgyiacf5TXRUi6vQPrMjrJ6oeCn9G Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w0v9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FUt3019936
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3020.oracle.com with ESMTP id 3a2347k08d-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICxXkJYMmyngpdsu2lXi8oatIghwF2l2EHoTTPCK7tM9SDbrQYW6/vj3+ir2nVKpcddL8IekN6xA+ZPV98KrEQI+WEWvLg1dPGO3lMs5rMw+QNUlKGtxVVqShd/L5dIXONulT+vhxsqeJZ5wQLPJzHnjmpKJ5K5cELHs0OImuggtnmKJverKOh1AOX6BqSpvX02ogpA0n6wJUoAQHGlDyfBsRUBHjFNkws7ZhbbUpxvxeOmMNXUhNE9UOEM4gmQw3/Vl8u6IW4rU/V3NLbVag1xzwQWd0MBoidso4B+TWnIKq7Yzu6SVYnWlCYmyrRZClvhoH1FztqVRAmhTsdLYkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDQLaK5WJnL1x3iOJjbyn9lTSkPdD7xIyVBfaOWF+Ew=;
 b=MGtooN28bgC/kGMLGmwa7/vTrT7uJzPonrr+5HVcR2+gxL/YADK7WURPcug1kWP+xj0E7dcAox2lbrUKcgm5fjTe2PGmsTakaeWDeFearmJBeB94vOhr8LJSe9Od/pZepPoBp/zGPFRsocTR68DsFfNKa9LASaDxGrsiGb5D/oPRZcIGRpG70JKHoNKtcaYJOtanHuj1SPw/iypSSE60xXjzC2YZC/HOhBajC0G21eI/ims8OM1go/ohLGzOKZBgPGmhZtwJtZOLuD114jT6B4md6yTtnW1eGYQj3SQs/wTiZ45VTRkfDj8fsRpaMiep7yIkTc8FnV6j6Mjs5jApAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDQLaK5WJnL1x3iOJjbyn9lTSkPdD7xIyVBfaOWF+Ew=;
 b=fP3F4dZvoqyHWFMx2/BFk+s+9KDizdc4TBX9JqcShX5IY1BggPj8ClMHsOxgE5gBXZR554kSDBvXW+IuM5OnSfEW2eN4esgi6jTEvt08wMZ+v8G4ejkcLjolZ67bLrgyX62WA4Y/GfoV7nqT29CUKwHBmbLY+HE5uaBhzVAsP2M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2647.namprd10.prod.outlook.com (2603:10b6:a02:b2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:21:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:09 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 03/16] xfs: refactor xfs_iget calls from log intent recovery
Date:   Mon, 26 Jul 2021 23:20:40 -0700
Message-Id: <20210727062053.11129-4-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3c6772ef-85b5-4100-1e38-08d950c6b92f
X-MS-TrafficTypeDiagnostic: BYAPR10MB2647:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2647D5A73DC7965D847BA0C495E99@BYAPR10MB2647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zby0aHdVHIeyZ8bw07wHGxBY3/TUMZAk2WhVB6sB4+L1AyztAh7ydiEEHrtFlUPQsIzrO3EnFhlgmC4QzUvAToI5EklalnU7eOEfzDLCF+2pyyKxXQEDqQuIACA7znxZFtppEUOwG2c9vfDAtmV/Hm+Ow8F7WcdePcvdAydL1R22FdVbuziqxFJChAUOpi7VUqDaik9MJEB6vPfSPlje0JgNQ4CMPbTmydEldeXjgWm9z0PTtLkULxvtpWHNwRaRqogQA5VabFxqx2u4C26aAde8XFF+6g0kY7x6FDHPehJGXXArkSJduYMNO5oQj5bu93v8gy/onKYvPvyg/438AJpl66HThqDbFQfbPrK4Wi+2q6rdr5h95p1gH3L88dZ4nHzRPHTSWZ5xjAbrBlvR9zzLB1gM7VPCVJYjP15PsQVHmZKUpFtQC/RatY0q0b+1HQ0xKE932UkbXv+hTT34pvjf2n0xHd2q9mRUVr9d9tGch/vAXBQSPESNeGvnt/7UEfRxuoJk+wKfRNuSwVAxv4rDq1wuovJOZBCj0MkkTOwSSpH0SxWCGLtBd6pf46PsJnnFO9310Yx48CetxLNI7M6bxYpNHWQFXtWWUFusz8h7TnWFv06s0chDYcYTy2L/P7q3649OMH6z1mpTr+9udouj3lbu4LIp0KzNpPT1gG6Vjnp5bTiPX9w+QOHu0kGvqRmm2+kNQF0e/sNXVOP48g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(366004)(376002)(2906002)(6666004)(316002)(38100700002)(52116002)(5660300002)(36756003)(86362001)(8676002)(38350700002)(6916009)(44832011)(83380400001)(26005)(8936002)(6486002)(478600001)(6506007)(1076003)(186003)(2616005)(66556008)(956004)(66476007)(66946007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VKIqjv22JqnN8TK7yrUzgFHpHhId1wihz4WvwtLIFBOG2TmOqL230ox1pjbK?=
 =?us-ascii?Q?uLwoxORwc3ZiIpBy8PZqptokHuAahA9MktyAch3vyjTS4H6Z6qwPEAv5TQYl?=
 =?us-ascii?Q?P6a2F4kBk+BGBwfWiq1RkrVFhjeo1vyy04rwLUh16kkAatywDGL9NRKSJ67D?=
 =?us-ascii?Q?lrRnJwEs3AOaKR0EV2j5oXIHbK38XbNI1AlEtoKd3LhzobU1sR8AabwWV7n7?=
 =?us-ascii?Q?NFs05iyaH1oSVKF0+bm+2vKAEcFKoTuqIZ0sRYFcYCFNjeuvqiWMz/rDU8eT?=
 =?us-ascii?Q?kheVE4vNCb3Ru55VjMjmzl6juGpP0QQQgwOrhvGJ7ufCFtRtt9IU842Q9fHx?=
 =?us-ascii?Q?SNtBzZBEYqkagtLAqQU2wfzi97K0swm82AWNhHx0/+xvsU1wz5dupmAFbC+B?=
 =?us-ascii?Q?yewXOXJM6UaPNdvnjGMc9/O+dhRvdgdtYPIB860uQ1dx2RPXEHxiiwXrlC5S?=
 =?us-ascii?Q?Lt6sHOf2cOa2yO5U8DZc4t8MQpXu4DH8sVYpHhDNihu9Cwimn7gmNUuywUh9?=
 =?us-ascii?Q?5ZjeuEU3CQDalaMU3kTo6xMPAW6PY1jAcl1A/3mkXg9x46jW8Aih1Sr7lsoi?=
 =?us-ascii?Q?g/r8vwn8RtqmnqlOi2Xzo5r2VQ3QRp5K6q48Hol3PEGmaDrai5V7yyhwQ72w?=
 =?us-ascii?Q?36MmkXrGWD9l/9rGnGMbm8YN1t0bLsRbmILueUZ614rsOUL9cuHIcAVlbAKA?=
 =?us-ascii?Q?o8SBA1B/En5EBVaR/1+Rb2StIDkaXSk11LNyQojySp+TXmIiOoeGZ1HC0dVg?=
 =?us-ascii?Q?kIGywbhyoEVyi39L6qoIGky120V1Hg8A2fWR8UnI6zizlFEmw0YupnxoR+tr?=
 =?us-ascii?Q?cFFVl9/VO52h6GOAnEHSfDoS4nK4zLYP+2av2yQ11ndlbw5BWITGuMhUxr0A?=
 =?us-ascii?Q?4O5rI3TRPx9njUKxEG2mV1zG5cPFuhooPc1qDo/6X8+Kq6+pwneoaJknThwd?=
 =?us-ascii?Q?CW0R8rO0CguZu0HNRwSHqC7PkHNMrQhgzV12sBsLI+PFnn+bqMPxP3RgsO8D?=
 =?us-ascii?Q?Yol6p7N5dpt8Yrw6Jw0u5PGHB5aAmntHvlWC/Z1B3SCyZiSZT4Wjo8GgQsEJ?=
 =?us-ascii?Q?CoNI1V472WF/dSSaReJLAoNTTZGlWWiBEEBYtIDEJe8IlG3krvkAS7ZlrJY+?=
 =?us-ascii?Q?aHiACqY7wFkdk4H5DY3O6KHRo7ve0MWapk9KIdHiia8JVAGaZ/AK5qJ+Iti9?=
 =?us-ascii?Q?d1V4Fp04RAvfyJI2yEBPnwe/8Gkb5D17QGiQ23JE8mxL/8B7PzMtg4eU/ruU?=
 =?us-ascii?Q?OlJgEd8Y4610kM8EgEyEe3O3UgQVHZtxkcqdYvqo1jhqGZc+D59oFzN8dlqr?=
 =?us-ascii?Q?aKK2IVtkxMAsUvAYie1J0BiN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c6772ef-85b5-4100-1e38-08d950c6b92f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:09.1828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IPLV5Arzp7aZVdMYFABLzv1POaCtXjWRKtg9GB48g2t8YMsUg46IgtFMC4Kvv5qjEmp91P2kgHkvs6m03ywhMoae4FPadBpUTpCkakHFCwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-ORIG-GUID: z8WdzBxvJ4TLZcMMzIujLpVp4XeKyb2j
X-Proofpoint-GUID: z8WdzBxvJ4TLZcMMzIujLpVp4XeKyb2j
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hoist the code from xfs_bui_item_recover that igets an inode and marks
it as being part of log intent recovery.  The next patch will want a
common function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |  2 ++
 fs/xfs/xfs_bmap_item.c          | 11 +----------
 fs/xfs/xfs_log_recover.c        | 26 ++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 3cca2bf..ff69a00 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -122,6 +122,8 @@ void xlog_buf_readahead(struct xlog *log, xfs_daddr_t blkno, uint len,
 		const struct xfs_buf_ops *ops);
 bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
 
+int xlog_recover_iget(struct xfs_mount *mp, xfs_ino_t ino,
+		struct xfs_inode **ipp);
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e3a6919..e587a00 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -24,7 +24,6 @@
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
-#include "xfs_quota.h"
 
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
@@ -487,18 +486,10 @@ xfs_bui_item_recover(
 			XFS_ATTR_FORK : XFS_DATA_FORK;
 	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
 
-	/* Grab the inode. */
-	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
+	error = xlog_recover_iget(mp, bmap->me_owner, &ip);
 	if (error)
 		return error;
 
-	error = xfs_qm_dqattach(ip);
-	if (error)
-		goto err_rele;
-
-	if (VFS_I(ip)->i_nlink == 0)
-		xfs_iflags_set(ip, XFS_IRECOVERY);
-
 	/* Allocate transaction and do the work. */
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ec4ccae..12118d5 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -26,6 +26,8 @@
 #include "xfs_error.h"
 #include "xfs_buf_item.h"
 #include "xfs_ag.h"
+#include "xfs_quota.h"
+
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -1756,6 +1758,30 @@ xlog_recover_release_intent(
 	spin_unlock(&ailp->ail_lock);
 }
 
+int
+xlog_recover_iget(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_inode	**ipp)
+{
+	int			error;
+
+	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
+	if (error)
+		return error;
+
+	error = xfs_qm_dqattach(*ipp);
+	if (error) {
+		xfs_irele(*ipp);
+		return error;
+	}
+
+	if (VFS_I(*ipp)->i_nlink == 0)
+		xfs_iflags_set(*ipp, XFS_IRECOVERY);
+
+	return 0;
+}
+
 /******************************************************************************
  *
  *		Log recover routines
-- 
2.7.4

