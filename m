Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854D4C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjBIICm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBIICl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:41 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA2D2684E
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:39 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197QNgX015211
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=c/jHOlarffzTAg0tgMDnBoCTeNdAP/SJTZWYnXon+tkDcnZ51PYUW+peRe9zbZhBnM9g
 CAVvkG/bPg6sZIoEgF9gU1ljXOPXP5N2zcOjAELQp3Tcd/93OB3B5DVk56vizzyJPi1v
 WEIHqGzuFVFBps1ot9nC2U99tQTbOg8ABfTi8m5SEyDCJrj//ira+Wlgg//bsWfa0Kck
 yISG+6NGAOui8mHLNMbpOqC5VYMDc4Rgv0fvusTfH9Ad3YCEaKurvzX8YTCf1NvU5aq2
 f/KrjykqFfRFFwMrvZ8P2oEF03afgMs+FaSxqXETOTm9auH88CszaY50T13N13PmzXck 0w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nheyu26cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31965ffY028432
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:38 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdteyge9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lf1citTcDlXgwiWX0ACiuRS9Ud+CdeT7U9Issrv1ZdmABdW2wpNVFvl5l9f+1Q+aeNDE1UKdKgl6x8V+8EAlHr+NoljJOEA76BU1OZ1aAaTJfl/FBOra3htgjpPmfZdTuEwUUOLdL2zTw+s7fD3MX2DWi3StgsxGCryg0eGW7zeb3eNJkfgJ3+50NhcUGf8msSF5fgYs6yQ+f+FGgJ+LDKzkUSQpGQwSie6pT2cvvogOrr6Llk2KuTKEQ/Ptpr7X+XaYeN9tCDpj0ifLkit3GWRd1dgQB+bTxQPRFRGlja6jrr20HOheYu0nzW6Bqoajd/089eooN5JP+uj3EXQZPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=a4NVkuiKQfi2lLkDt0NWPAnyU9xIbhBOY4XiIz59R3Yqb3KtZJo1yy56OjqPSDTW9UnqZz9tCDsWxH6O8akx875qKxIVSOCnSI4oQHa7nsbJV3Hqj8WmPUhWAxWGyhofxNNnrcUSUZ8h1zLent/haoD+hCgUobws5uVtHwlI4xIi+sIQ4UIV914geMkcxVD0NaV3XwdOGN6i0HJ6YOGFJS8SmIvlO0lid4RcVPjREjzf5p/pmg8t2+oCuBBdiugVPGHA3fjGtrXrHRaoirBytjjjwS78R04xLSuJJU+HZRd58CVd1JaEtq/eAkUVqXZJ1fDe7Y/VnVk+UwNJ7OquFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HDc5oSRZUZiwCZrUG1G6lMOEEvHfQHLGVwhC+kxeKs=;
 b=DkJ3OjucVZP8ZbCAqphey4tx6LfgzN3PCKDJQJTDzZfsPAFR9fEGqpegfb7MA2GvAkPFlbdBmwauT2zifdqEAByvVSH2GRGRRnzBhh5JeraUeNSN3wjKJhqOcIY0gzsIC2aUKRMOD+rs0O3zRRqzWBSCSC13TkPRWk89OTa1J20=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB5095.namprd10.prod.outlook.com (2603:10b6:408:123::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 08:02:36 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:36 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 26/28] xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
Date:   Thu,  9 Feb 2023 01:01:44 -0700
Message-Id: <20230209080146.378973-27-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0076.namprd07.prod.outlook.com
 (2603:10b6:510:f::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|BN0PR10MB5095:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b770294-b693-4fa9-81cb-08db0a7401cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HfINjNeu15Y/1G+MddirzRhDwqCHWCw2oSdcuom6tTixW6tv9/58zkq3v8pFcAqAmfC1BFLf5pACwZoCBgzW+5uokcYwCQfPjgGkutktaImKkqnmeBVuzeYC6ujP54z9Pm6tbWPNz/81CAWfMG8RernkHDnJImIa147lkFDqWufkCZsB3wic6GNOxoxNPbmUOKfXZ31CH08RCRdpYCu3hzV596nfxB3s9ahh8QzA0Ux/8jqChIVsIwzp5SZq5Rx/tIklgaznaR9x2NdGTyQMRYL02Sk8JzIzZGjZL7InDG9tn+1efQz0huJ3GvKqXYRsLyd7SWLMZA8qVpQW4a9nyYIePpRZW+Rk5+D8N7zcmimLPv6g+MT70Xnv2vsn1fQp1t/nAWXBRv/iXRuRfjNPr9gdzAKJ/0Z6KECT11TCr9uxrg+rm+T7fH9U3cyKYBY9AMRTSbCx4ZVrF5YuFWJc2OS54++6dYyBPmbg9h9mHU3CZneibgJ5RVzAID8b1Z5Itgqcb8yypjcVRcbA8OX66/mVl6panpPew8g9HI2jA+kg3gPT7vGOi4CqSEtk404Zg3n88Nm3OfmaaftUC5IrlcYsRwlBXIhW+K9Y4xQGFwHL71ufIdP6gqBaCowRv+GmIRFXGJ5OTXmPI9K/Eee4Lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199018)(1076003)(6506007)(6512007)(26005)(186003)(6666004)(38100700002)(9686003)(2616005)(2906002)(6486002)(83380400001)(316002)(41300700001)(478600001)(8936002)(6916009)(8676002)(66476007)(66556008)(86362001)(66946007)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IAy43LVec+cJKDSNFuKgKM94tuBcTtz6LoeJQj+h2+iXlE6y6perQ0WMUeSU?=
 =?us-ascii?Q?peDgVZv0odJFFrGYzUF0KHtmxpqdD8Q3W2yasziD8/KViHMZUF+kxxCksv+5?=
 =?us-ascii?Q?p1xURQ8rEbF5a+Ju24OiLeRHirWvpesAsuwT/vshNGtRuN+4aqR5f82sNWRu?=
 =?us-ascii?Q?MylQ3kkBaTle9VwgfMwDG2DWQHuIcBJDsxeiYS3RdLFQkKl/b4QQheoN2a9H?=
 =?us-ascii?Q?xeS8nzvcrEfTdzdt/EI/+7g0fndWK8ENYLrJ4Tmiw4K47+IOsLmOt+6vNWlY?=
 =?us-ascii?Q?ldOCWBc25n0hvm0u4p+7ZrNzASE+Q+7pHlg1jXqDbayLY1KxHOsBxe2ipvKN?=
 =?us-ascii?Q?D+OAS6nH/h24CHZyNR3/fggqTaqo5eUUhsbrhYxIUjVc+WuZA3HI57lJSjFD?=
 =?us-ascii?Q?vbqxczrTrAoGHmPw+Ex7gHCKxEFJIDx3h9489CSL4+NBIC+NEWvJZXcUpkIL?=
 =?us-ascii?Q?qaKd3fZFQ5kGdYan2ZTk+BJOiEjr070voj1GGOFlG2xvSBrKwmDSIb4iCwgl?=
 =?us-ascii?Q?FxO2FvXMUO8ycdlTUXgIrYGzLvNgSPjBkuDuILpcyJz0Q1wEMPE3oFeXFJ0e?=
 =?us-ascii?Q?dCWR5Cdn54ku9VOI/YLps5a1lZXhuvgGcdrCnOZVDoUik2i4aPMN8WReLZlv?=
 =?us-ascii?Q?MTSxvX78xSi43OPiR/neFnEJ2tYMXzWW3iCX3gUKtjQCRlRL1LDR0OgXWiwl?=
 =?us-ascii?Q?1P8iu/uZU1oBAiowyrUkiJfEMehMEf2sVxGcmhMPIne8dYaFEbf/Z8hUdT6s?=
 =?us-ascii?Q?NoXXO80S6RDtABctXTjc6VmQooxY3I5FeAl1A3She/ERg5OBlXRV1JHB3lWv?=
 =?us-ascii?Q?eji8Y8x+zOHyefCCqnp36bANoHYJAfHxzNIN9HMD5Vf2/uKSOvFmIGAElg0v?=
 =?us-ascii?Q?VeIRUwnoc2Ms7jkzCR98DLSXCS7RRE1VV0J05d2i8ufrn4TUjfhem6iHmPuY?=
 =?us-ascii?Q?sXCbZBdzbcY/tePE0zExKr95dDHPu/lYXkgmHpEFE+N7tyCgugnuerKZSma3?=
 =?us-ascii?Q?ob0yGkID8N2Sfkh6B4fQSU3WI1nP0LyTuELbxg6ROI8EmXeA7O+rW1J0zTNF?=
 =?us-ascii?Q?nuSDuqWjU3FyOBAIePPJ+lqEUEVkZ5M42GAWgLVOsxnGIOfQW+cwSh8PSYwX?=
 =?us-ascii?Q?UyntRr71iDuwOUcCGyygmjHvaUGcdJZUGNc9aEzosD/sUw3aKuzRI0jX/OBj?=
 =?us-ascii?Q?yhViczyhOrh7cvafL31F/PKM4U49AKfdIEaW3ws9wAKAPw5Z6QRURLxOUUcd?=
 =?us-ascii?Q?8tVIyaDLQf8Thos+WlVygx8Qar+LnwjtwuSW4M++aAeU8jQJ6CmHk8ziAHGQ?=
 =?us-ascii?Q?dwbxQ+poXxSRKMhhjU6UmVeLCMdFk7vLGF0P/OD0nLqWLQQ5nrQykmTI6Msk?=
 =?us-ascii?Q?7OUNe6swZLvZA0EY0nMtS/2hYn2eKPDLyBZv+GGwvoQ5VGwNciPDycpJWkEA?=
 =?us-ascii?Q?yf6G2eIXRuAqU0/SHQm0GHDoiJN8++RUL53Xenuwv4TOuGfRF2jPC0d5VC0G?=
 =?us-ascii?Q?eGVVW8vv/gcmSjY8pxF4s0FBNqcD6+GjZS8I/fJMu/KfYNqYQ+8G24KpOcZQ?=
 =?us-ascii?Q?J6GsIHN8gEJGTKY6oU41WLIXqm2b8Tt+ngHFRwxUcTEBEAkU4W5MsVtgSojx?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WkLD7hJW99Vcwa6vb3SU8WLtogLx/dq300s+iKzzWTPhRZwS5REhviLf18Pzoh8wuTP3JqdbhJcr0ZaWMan+2afx0WeKnxUR9NqkTQhnR48ErBv/ZQdZDQ19X+gP/kQZfV6Lh9tzFTOgFix/XVlLVlx8wTtXbrvocvPByxM8z9gjX6GkTPf3iPTfDzClCyoCfAbs0lXKfkJ/1egwKIQWKD4YQLe6KO0MtsaIfBIMDeFgoyXqaBYGlGBrXrlD2y7cBoobkiLhgtK+C975ucB9XpSpXcI9KkAhuDiW/dgHP0+bQPtaaxBQNNNvSN3F77gvfndUlA2lgr9orXDvwq/ZGAZZTJHbswAoSgy/CP7z85tWoaOWOS/yjfBdB1K+idFiRORKr7EFCWGEXt+s8kTHeajFq9FAcHrXVwMCkL0jOC9QkOKvjDzmAxennluNTMZIw/FA6p+dQMbL0bpaHnTZbqFtW4N6PMB1qF+XiT710SxsbOWlUOVlkQLw6yYNSTaMx5lo84fw4shghjJn3Hgb8OtNPst7iP4ZL4QBVYUgzbO8VCr30QjosYAJvnH1I1h8zIWy36o8mrVBDV8+AErXtCzt4qkOlsiE0ke6Tb0sCh4wxn8ZLLk94Zx0+sjWkRUwQUekILMNK/57wcHFvfE6a/BaHBfbTmhVhucVw0xHIIsGioQ9VtHacWPsIPA/aNwyUBJP/yTQMXPr70QRpFmmHeOUgEnLxsY/cg+l9GlKTOjVNiLUTsvD+KlgL3kvSQhB
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b770294-b693-4fa9-81cb-08db0a7401cc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:36.7595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +mdmX02ZIsqjnEZMDb5I8JGUqwfs3PIKuKamcFL02InnDtfnpyyfB5KPpAIL8BsLwhUhACAgeSC9UCbz/ywqTFFD5r7Uw+tpDhfo2ZAW6iI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5095
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302090075
X-Proofpoint-GUID: ItIZ1LTgWUePyGQHK_fuqRACQQHAMJEz
X-Proofpoint-ORIG-GUID: ItIZ1LTgWUePyGQHK_fuqRACQQHAMJEz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Dave and I were discussing some recent test regressions as a result of
me turning on nrext64=1 on realtime filesystems, when we noticed that
the minimum log size of a 32M filesystem jumped from 954 blocks to 4287
blocks.

Digging through xfs_log_calc_max_attrsetm_res, Dave noticed that @size
contains the maximum estimated amount of space needed for a local format
xattr, in bytes, but we feed this quantity to XFS_NEXTENTADD_SPACE_RES,
which requires units of blocks.  This has resulted in an overestimation
of the minimum log size over the years.

We should nominally correct this, but there's a backwards compatibility
problem -- if we enable it now, the minimum log size will decrease.  If
a corrected mkfs formats a filesystem with this new smaller log size, a
user will encounter mount failures on an uncorrected kernel due to the
larger minimum log size computations there.

However, the large extent counters feature is still EXPERIMENTAL, so we
can gate the correction on that feature (or any features that get added
after that) being enabled.  Any filesystem with nrext64 or any of the
as-yet-undefined feature bits turned on will be rejected by old
uncorrected kernels, so this should be safe even in the upgrade case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 9975b93a7412..e5c606fb7a6a 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -16,6 +16,39 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trace.h"
 
+/*
+ * Decide if the filesystem has the parent pointer feature or any feature
+ * added after that.
+ */
+static inline bool
+xfs_has_parent_or_newer_feature(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_is_v5(&mp->m_sb))
+		return false;
+
+	if (xfs_sb_has_compat_feature(&mp->m_sb, ~0))
+		return true;
+
+	if (xfs_sb_has_ro_compat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_RO_COMPAT_FINOBT |
+				 XFS_SB_FEAT_RO_COMPAT_RMAPBT |
+				 XFS_SB_FEAT_RO_COMPAT_REFLINK |
+				 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)))
+		return true;
+
+	if (xfs_sb_has_incompat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_INCOMPAT_FTYPE |
+				 XFS_SB_FEAT_INCOMPAT_SPINODES |
+				 XFS_SB_FEAT_INCOMPAT_META_UUID |
+				 XFS_SB_FEAT_INCOMPAT_BIGTIME |
+				 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
+				 XFS_SB_FEAT_INCOMPAT_NREXT64)))
+		return true;
+
+	return false;
+}
+
 /*
  * Calculate the maximum length in bytes that would be required for a local
  * attribute value as large attributes out of line are not logged.
@@ -31,6 +64,16 @@ xfs_log_calc_max_attrsetm_res(
 	       MAXNAMELEN - 1;
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	nblks += XFS_B_TO_FSB(mp, size);
+
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * corrects a unit conversion error in the xattr transaction
+	 * reservation code that resulted in oversized minimum log size
+	 * computations.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp))
+		size = XFS_B_TO_FSB(mp, size);
+
 	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
 
 	return  M_RES(mp)->tr_attrsetm.tr_logres +
-- 
2.25.1

