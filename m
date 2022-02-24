Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22993C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbiBXNDt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbiBXNDr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00968230E67
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:03:17 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYb8p016953;
        Thu, 24 Feb 2022 13:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=NwHX1Sl7FY+R9f/1THWWL9TnSRk8YnFlOAfNSRXMvj8=;
 b=vvU9/63G9/JHPGwmXjS9g+6jk6L3qV4Opz9rBpnt4F7VXE1OkKsMIogbOJtM+8zxx2mh
 CWX52far0bwPdVS2QH6sNi4incFlKfjiPa6f302Ww7HB6oroZJDhQg3aKAAW+zC2eZGp
 YI/CjEiIuwU47ZL0QkqtD55TZX9vS1AQaBuIs8+RFPzpxOy63SdwX1L9WE5uSNUsglU0
 zPcCgP8YEQk+fummRlJ8jVFBei7w6Ntj4Db0YjjK1FZPWgDUI5qcOP0sb2Dj7qPqnPBm
 TQy17O9CifjcDbomEqQfNgd3PjR8qD9RAFK34oZM3GJ67Tzrhuhlt7EVFxbuXFwdboNA WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect3cq4d0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0Xq0120508;
        Thu, 24 Feb 2022 13:03:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by aserp3020.oracle.com with ESMTP id 3eb483k7g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mra53gHn5ivXsf1jcFru+9ou0IToaISCAMoiujgXjVf/8vs/s4ZZB7zr4ANW3K6YN0GWqi4O0F/mP4ppA5bt/KLZ+6VS/3/+hG0NlZ/PqpFqSNUPl2/yACr0GO07Fe2tRpxzTbRvoZbnKgF2Vgw0UMhFdU2/kCwIE/ngwcTlfJv81uHrqh49hCsNp1MM4DysA6ti7eMfwulCNS3LKYE68WD2FCue85MoikxeupKyQNMiPEVTZKjby5kTD3QYN5r8QXRZ8Gho6GepyH+YhAz44zWTuccZOYfylpZngM18JuSW275KZDHLwYKtGT44e+NJ5e6G47AsaCAIni0RqX1Ywg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NwHX1Sl7FY+R9f/1THWWL9TnSRk8YnFlOAfNSRXMvj8=;
 b=Y3VXQsRbihMbnIQwi5boIYT+g19AbrmlAYPVsqsiLBXUDu4hKKlP2lYSPkSvzhhXn4VOxgsBhz7PR2YmqTwVf2ohwUs/Z47EcAmhbtHtL2xqD3Ca3uUTv/xxElWOktILOUTYqHavifN1ij1fvgJJdA59f9WpOS7MsFebP5ouyDrHp0NfZOv0uIAbE9XdMuC01qReB1AilB2XDuH1/8AYuU7buHKXB6tSO9YY5oDUNBgQwgvbe7JIQGqTpRUGnUQFJCG+Kz4+KZ7eCq7KIZoKRRALX/rCz0llQNHNE+7QeoZVh3iF2sLCVk39MxBvJ9oKTGzBbrRwJOa3VWuHUhyaLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwHX1Sl7FY+R9f/1THWWL9TnSRk8YnFlOAfNSRXMvj8=;
 b=G9Z4P63LHL9KBcXFt7LNbl075vw5ywdJe9+v6QsioHIc4o9YaRpLQmSLazy1eAmXL6IzTn+LQ030E36Q8Nt/0MZ7HwXh78fA8C2c8TKOMQTGlTM0G8U1GTzu3Qtc1PHajavPm968zqNRUF01Kb70G72T83McxQMkJbrZxgjlLHA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:03:12 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:03:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 16/17] xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
Date:   Thu, 24 Feb 2022 18:32:10 +0530
Message-Id: <20220224130211.1346088-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130211.1346088-1-chandan.babu@oracle.com>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04e1d6fa-8e6a-4193-a2ec-08d9f7960335
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4634AF6F872613EBFE5B2DEBF63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6SqhApNV5l7DnEDTEOkNV0mtydQHO1e/IDSHCKbaWyxOzQdtR9c/UHJQ9tSAyIWTjo08HbgRBpENGE9kasRsdWML1za6IyfzL4kHPqjRR+Hzt/sq/hzdnWYyQIcb/TTZQYgB3MrrmhCrjsx5NsG0CgxvKXRCyK2pE2WiLp5ESD25rImkM3aFXIltaOZCZI71CJ6nw5sonHQ9Dk7IllcTTROBgDed+GTqUcCVLcP/ZLw15tDlPPejyhNfzMQ1oPilvB1YyxbpwvZC/TzA8ABxLhLHJJBxdwhI4eMhl5ucekuKRitix3WqzkYTR9SCvrDntfPfZ4hq1KvBZt7feHMH/Z1swX7LFASi4L/+hbjlMXmLxjtRameSMaDQ2TbSaF2U4bWD4Vfa46UR6fs5qMnjqI5q0UTWVnnsJ/6YH93/rLNxOgb0bLu8V9YtSmglqmNvAy0WLM73rdhzRaLobCS28pG4thsOhrl6pk/BheejdlxSXIgA5mJzg1pkNWMau2/+NIUxTOb9ElPdj2/OJEAH9Ufi3nmbWtE7j95uk/JeKuviVDXYDzMZxSX1PQTryn7vlS3jAd/NcUebzxUBI+x1gUF/fWdnw4XKtbU+lll9EuiPrYdpFB3v/MrsOH7fGXookpZDxCT+R+chOwlPljA0tqum49yNAB0rKf5IgN0AUOq/iSjZecb7PTJEIVJL3yJOuYGfmFwBJlj3jGtl9Zw4cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(38100700002)(38350700002)(508600001)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(2616005)(4744005)(186003)(26005)(6506007)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YbDGPdi+OGCYLjsJLEMXz5qzrXtfOwJ7bn915TZaoouBvTtRoLPZFqEfPEMe?=
 =?us-ascii?Q?t3AkyG2incbhm0sn580fgb42RZePSAdNc0kYGU8IeVlbZDdaOWp7K+O8odYx?=
 =?us-ascii?Q?locNltggZmWDyUMjHC0fswyDjjsSSEnux5B4gSlojtU2ffebIvcnILFttwg1?=
 =?us-ascii?Q?vuSuunUVhmQsfwOY9wnb/Bq1lXqNwrgJwgVJsiOu/EVW9EGL4k6e8p4PeeMr?=
 =?us-ascii?Q?WB+ogT59L4UtD1hbkw4s3dBo2V/+yK9ReDZ96TQu7+ABo030iU7saeRJWkO5?=
 =?us-ascii?Q?odzVEEa8B5YTuA50YH+QrkMc2azLruf3y7hHdRrMHA8526x9x1SR3XZYba1G?=
 =?us-ascii?Q?HoUEtzVfj0eONSfJaL1PgVm4dl6TFvKNwOvvVfEjAOrTth7BXiWljIpKgICg?=
 =?us-ascii?Q?G0SMnioxdlmuyExnfyvVPc2lA7+iPoqXcSgmW/KeY5IWEZY7zybrazPwKJnX?=
 =?us-ascii?Q?4Zdpa1icBj7FJvr8/tsuSAPcK3FSKUROh3zjC4Vu751O/7KjjOAtn7Xjiy0H?=
 =?us-ascii?Q?Cvwi4guCY3SWBABHEnssjTP1ZDIbwuluFtguNA9xTod7dtqojVkGOHx106C4?=
 =?us-ascii?Q?FPL99rTOer63HG1sxSVfqYZ6wY+Dq9fuyanFPZ3dasGBkvCz/Y+E/J4uKonH?=
 =?us-ascii?Q?W7Mz1KRYQ7E6N1/IzW0V0bqcZmyM69ROd/FUCDPAP+DRiBW6W9242ucQmOT3?=
 =?us-ascii?Q?mbbWMh4BdQiZ1GBKnpaZa/bqS02hTzkxOKNteVhqDkS4YZ6SFouBb55hdS7p?=
 =?us-ascii?Q?uUITlyqm/saQgwiO9XftSDdduau7/9ZgPqrhq+aH2pcfOQp8S9cAtIDX8aCo?=
 =?us-ascii?Q?F46OIdAF8ru643WR2vGw5pBiW2m8rZhzeTGfCu3Pugox675Rd+lCjNjndIO2?=
 =?us-ascii?Q?MHvOYIFtapxIbZVVTtnEgLvL+oG4eV2MnC/d/EQkEoRrJYNEsFbIzMF9DYQy?=
 =?us-ascii?Q?QPYl39NM1b6YUXvwXYxbed2b2V1a0KP1fFNF0e4zgE3HEI4iO6ZwkAY7u+Rs?=
 =?us-ascii?Q?zqN5NGCOox+NG8N+DRIgqY+bqLL1GjzMW19AHVHzoASzSk/F81J3LAhNIgum?=
 =?us-ascii?Q?Ya10s9VeUS987c0/iuDJYBryl8h7Ok2OJnGp49M1jULMf6jMmU/RV0eK3vK1?=
 =?us-ascii?Q?6zqqWns6WM89w73NJ81nPB3azFebCiAb7MbK5+lXujnwwN7HZnZEGitnQtB/?=
 =?us-ascii?Q?Vcn1uIi4Qoskm8T5Fx8GasWuVmxbY/xMxQoy3IcztQPtN6ILzZ/VrUgkqZeU?=
 =?us-ascii?Q?HQRIcLKkgHN9+tlA7TJlJ5MLGwLoE8+0+MSzzFRz+LoJlxsLhgp70MUvKSxa?=
 =?us-ascii?Q?i2I4woR5MWUhB4xaaa23OmGtnr4aYJkIm0b1opW5aaXbOZy9aJQ8YgyXNL/c?=
 =?us-ascii?Q?Fj6O+DfuuYMC67eHAvpgHhzXH7ullPEHmSEFmAwrf2PFH6tk+qJ3tKLN/HlX?=
 =?us-ascii?Q?udh2/aiYkqmSo9uPp29+qHAH1p2/iGe95rlelaXFDihTR0LrBKXQAYcBt48l?=
 =?us-ascii?Q?YCNg1JSGjNwL95n8x1OkRpSoJhrdqtEh+MSSuJsK7NOQQ9JiYchIlQ/oCsEU?=
 =?us-ascii?Q?hodqY9g9vblKs4wx2DGY8Xvp3PzKeCvHpldG9km7mm9hzhQaGtuJ+GIMSAp1?=
 =?us-ascii?Q?prBBIMEG6WEC3hJc+q7WZmc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04e1d6fa-8e6a-4193-a2ec-08d9f7960335
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:03:12.3617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hOleOufzgkiIdbcbwJLPLomrnILmDxbLISffWflorqX6sOM/l4q3vhyB4dP6InI2tT/7lFaqWgbgIVwjI6lzJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: _-VeFCVK6bWjYMolfAmyF2bKSaQtn8nG
X-Proofpoint-GUID: _-VeFCVK6bWjYMolfAmyF2bKSaQtn8nG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit enables XFS module to work with fs instances having 64-bit
per-inode extent counters by adding XFS_SB_FEAT_INCOMPAT_NREXT64 flag to the
list of supported incompat feature flags.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1a5b194da191..76bd5181f7d3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -378,7 +378,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
-		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
+		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
+		 XFS_SB_FEAT_INCOMPAT_NREXT64)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
2.30.2

