Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32849C636D4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjBIICO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjBIICM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19B12DE75
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:08 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197Phsm003371
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=j1UphUgrLxNzSWpMB/bI7vBqQ2f2Hy1w5Wg7M7MEFKI=;
 b=UC+BQQbVGmYyn9ZGaCKuAoD0w98QjfvMCcnxztYLpJ9zsR0SP8McW2PAm3M/eP//X3jP
 JsGpZtv/8d04lRtQjPIEJxVPOI3CSQG3HsOHbGyFTK6VnSfeH/QBs5yIjwzTzIW4mA1i
 t1O3nu/xLCg/LQWyLJMc6ibIpvLTdY/t85M/1/+WXVsOzK4Mk9j+Qzh2r5VcLPPsxcfg
 XXI6kqaVNNTEtu40BiEFST/+G5mRiJWE1iNIUOnEmzKfHVsuBg75yPKb7dS54smuFR/m
 XNgJhSB1JZrDv4E3iQeovFQFSGpsOKHfGAxWc5ACsGSfi520393WScOBXjkumoIrF75U 0Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhf8aa441-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31981xCr030986
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3njrbcxuh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbP5XlURL2ocDs9nWGgaWBeGHDfgO+PPgAzPR8U9nm/aEF8y+gZzNa+/r8C6qNnlQnJ9qRZm+ypyPLOEzL9FgD4awziwK99tp4BeDYy7Zq5Z82CJJjVwLzUZunnaFdAQ+XCdW954Nr+8q57LH4UGsGDReZNaV+i0o2s0ZOCN0OhmmgbTr7aDCv+8pT5eaqhQIwwy186YwFaXcBORqYyDjyAsnid/47N3LD7p1RNy6QWQYE6bcVAXWLgsPEuOpDkrUKv8DHEVGMDcaYE7N+dDNs3ANauY0LnWX0LXZlavLvTg9JccFLYUKhDOa/tzNTKbPxbob22NYQgmWgDHb94Vhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1UphUgrLxNzSWpMB/bI7vBqQ2f2Hy1w5Wg7M7MEFKI=;
 b=JIU66uat09LdeS4mZoBN0mOBK4ZM61Nya6yDUv2fPrPSO5Dkl5BCf1tI89PAW0kHEw/zkvAPQWdLJp0LRjcCWSYUyfH/WJK3sFZfR2Es7x1/3KtDcGyy+0PdR22YasUoxaHo9x1lwSMOKqEaeuP2IU5jd2samS4D2iYdcVOLNfrnCxzlLbAliClvewHpeVlac6R38uGru4XsHOtbHdj0ZXhZdw9v4snonyKZlhp9a5vRLHrCfmzwBNaRb8Zbanty3+dJAJ+nXYwayt7DFPi3ZNBl67izand+poVtGx8YdibCI9+Ne+fmWXiLicHDBedjCIH2gqQh3+NvIBgXYCix8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1UphUgrLxNzSWpMB/bI7vBqQ2f2Hy1w5Wg7M7MEFKI=;
 b=SKtS7QPdDP2JLvsFHOlF2urAB9AYJ4K8KhKEN7cZG9LoE9cXXUQqmOe0Eutde7/w287oC185L48wPvsRlOowy0UlFBkuUnQutMyvbsQiet6WVmqxi2Bh8sHAH/8Bu4HaO+y/kjmdoRwGL21vPxetx+XKCBQsbb2U5D2EvXLOVPg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:05 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:05 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 09/28] xfs: get directory offset when removing directory name
Date:   Thu,  9 Feb 2023 01:01:27 -0700
Message-Id: <20230209080146.378973-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:510:e::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: f2ca114d-342e-42f6-f2eb-08db0a73ef0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JdFvkkgrlnm4Yii1TwHKzgv8DsQFXC8ERDbJUhdQRtMbBf2FDG7oDGmIIWjqjpHKpCcZDi07toSVEketEJr31Xp/sLTxEylGd5McfXU16tU89lQGdZRIOHtl5xHjWGmpZoZr2Hj/fru3OdYNhj9ijxXzyEydZRxH0aHlPWsfgdV4h3ogQOlif3nbb/Q+XOX4mtdAABW7EIwwkTBwebm/tpCLlhfeoe0tI22084zKrLrUV3elNZ7G/Yv0uIwf0So/F3oSxs41M7kRWS9E0W1HtfswQpVI0+eqTCgLXHYU0/Iy2EYV2hPHHF+CHwBUxjyQo93mnHTXqej/SUNBAGD+4Jl1pARYRLgN8eAGdFyvq7mEqc5mSZ9zlLsTSprMyD9Nu4KOkArISex3UabXJ24W1wE5YnjDrOrITFuV0oFP+oezqWAwHhUEmGY7tJ+q6MubP3tWnDjIrtdGmukXc8QD+h7eDKi1He+h9/3CczObZmeOsBGMb90w/i3vZT4JddUBKTxa5iQVteMq2QBFVxnchuW9+GkWMwG1R2F+EiV4LLizck4JCmwQO/M6esR7EIy+ZNlqTl05bnERySwD/q+lGowtvZaBMV9CjhR1ug6pJnXKtiWqDkYhCo5xkeawW9q7vSP6sLGGn4TlyfIcd+tmhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cy5OzNP7CbiUYb78NQ/5hvIx0UMjIZS3v6OqGMrLQ4FTs0Y/8PBrEhW38z91?=
 =?us-ascii?Q?9ypOwKGf0PvgY8ziGn/vjq3ghf9xEslcqDyFHRcbaCUBO31Zq24evqdM6Wnm?=
 =?us-ascii?Q?DrpyZfknFo54jYCqaVHx5LefIgLp2q9/YjtbZhtL6NPurfRl5Gji6IEaMkpr?=
 =?us-ascii?Q?W//gj+oSto50KfLe/R+kPdCHqLrIrLXFkDygmsP8Y+VJlBCnShCKBVs6IS/x?=
 =?us-ascii?Q?StbmFgdvu4oWtrXK1olLZ5MBColNyXtxH3umf2t6lpNJBqlhIhzItp3+T+pt?=
 =?us-ascii?Q?2/ZP/bBLJKohGOzi4/tHdoBUROagb2HeSB+9d6VXz9HstEWfVwJZ4TW50140?=
 =?us-ascii?Q?gjl0isosSwQe34Gk6QZGcBCgXZ6nCKyVOBccwTBmZuQx01fs7ycpz2t2jZ0X?=
 =?us-ascii?Q?AIW4nd87fi4SDIPWJ29hhdhs6+GKUK1y6LZLgEOPVpizHiL1RoRCk4+ioPOz?=
 =?us-ascii?Q?1UjLpZi01zxusN1Onz+Eeu247013UJy1QPxCOBd1jKRamnwVkAQm6GHWUd8d?=
 =?us-ascii?Q?SIMr6atIeCXoBAreXC7jz82LLsUDnJrNiaEZwmaJgs7afkKnlsWryCnOkaHV?=
 =?us-ascii?Q?7MvdKOOfzizxBMSdV+vvE1+w77Wveyd0Q9TBsVOxs174IJUil1tRMut9M/XC?=
 =?us-ascii?Q?dlmIDgTHpKa+4bqMBX5ADdfa/1xZSwOe8uDI1uZgnLymYxLqeg89VoRJkTF5?=
 =?us-ascii?Q?u5DY3RCZrrZOTivUlUOMJKMMHqkhVtxIPosjDEVoEVKIyMSQVFwc//MrlFiB?=
 =?us-ascii?Q?aUC3D7/XeTCkOjwtO7S/igJeaoPz+OexvQlLCqFhstOH/E7JXSGrj2/cempP?=
 =?us-ascii?Q?c1s6i6xm+tOhlaNzxKGpbKQR340wCl0mTaIT5iRMKSokGJMTPDQN5LAZU8lr?=
 =?us-ascii?Q?S2JE/Y22/seksdSYpSRCuLZHZAJzStq3fEegHa3SctHoQs6XrruwJmhnoFhh?=
 =?us-ascii?Q?jGaTy78kyoamkCc1sX/nDKdFxIktHUjGCD/yqOcLuLOqsCd664AX6533+fKd?=
 =?us-ascii?Q?ZBedeYbLxjfPrEHprnFC4ZGllXOA7j4qw0wcRCaGEiRf2YrwH7f+Q2wx5YTn?=
 =?us-ascii?Q?a7Wo3RMFT2P1RokUsu647fZlspCb8kU2GXZfyvhlYbYRJbqHzXpBVoI+OVQT?=
 =?us-ascii?Q?MUjRl8/ABwloLJq4j4gD96LuDK0JgqlGf+Sw/FYQkjSVyumT4Sm1oHMi20Wg?=
 =?us-ascii?Q?uSCET01adSZu5MlOa5sHdXGV/8mEQ1EkAamhq67vqh6BcWoSfWGMk4Jfm/fM?=
 =?us-ascii?Q?ZorQu8Rbkr35XVKf/IDCXd6v1hP/DZeKb8vrpL7lATzPXZcwuST6/cEoB04i?=
 =?us-ascii?Q?IcpDvphc6tBRGhnHDTS/QMERloHvCWgZF3kUlz7FvgdNUQdnE4UcynN2R1hc?=
 =?us-ascii?Q?AFwTCV0vguhbzycpSVL7i3qT355XiRkldz7FO4+t33glgXchPFRHC9Kz1hV3?=
 =?us-ascii?Q?SrLGXW1bwPZsVvXeRILOUHJpfmSOaIC6IUvXtfU0+7CKVCOymKl0RVUowrSO?=
 =?us-ascii?Q?qpYUXktsFcz73oSkER+w6sQ99ogko256DFzyafXARcvM44p0TUg/PMswUq3g?=
 =?us-ascii?Q?bisY3I+JhsCEVClV3tetPg9P9Dn6Qe0XwlNyy42ZO0XYpTCKuXXxehvXR4q3?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ldZKQh0v04/7NF9NNkf6u4gf2cqRgFl5fwtDUR9A6/y/XrNRpJ01Ye7RBEzP+0/aNiopx9d3wxjeARxK4RsxO7v0jutlcJkrlMXAnOUtdpIBkj9GX2aGIGhPEQ8yrC5a4hg7empCYr4NGJlEpMjYsTaVu0psUCsQqGsKcctB/Y4O8sOYStORByzj0ji9hReSnka83u6/7CEjWt0oLG47NAFw+RUoOaFD9QQMmUc/Op9d97Chdmq1ev/ykO4v/l4jYSR+e0HUOh41z1RR5KbpnHH6xIGQz4Ky0sF6n1qtR/+NMvDcUHVKFFb7tCekGGUO35dAlCL9s61azd28VbXEduLtOGvDNUFjKhjWE2j7oxpfxBITUadd7G/jpQ4qKqEPsKT7vYM6Tdx+gMZKObFhWsYFcmejXeTI6KQ6cmqJk7VyQ/wThsA1VCga9nbAx6iA2RvbcvW+34p6i6Q0JhrMbb5NF3vz+EhPHcsiwlzTgCAjzH7R8OvmIRyimB7WiVwyKLMd5T38c71Og107gMgfFsfdj4uyTx+MpuvLD2cbyZtFk/VeCNATiYlzKhfzJbXfQlEur0dNcnerAv8AqBFT+Wy92Im0yrb1v7G5arObf+LxKb0I7ZZtu0AfC5Fewyhlzo3/GizQI9KirRVxpYguch7vBx5qZgSxqTkVyjfG6q+BUkFGGizs4i7fYrMfMu2b8MlFTMQ35I4l0bS0veDvpo7jGO1ShOiDEG/Y5DWh6kHQtEYLq+3VWs3USS7D7oSc
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ca114d-342e-42f6-f2eb-08db0a73ef0a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:05.2899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QgkXbEXF7cIPZ+5BwW1Zhkx4FfkOCKTI/GYkDJD5syZi8SaEEnfAaER3Ca9/MipAT891xL27nk6Pz9eridOI3HSeAJ/GxqsM8kOTuvEdnkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: IGFp_FRl5m3uBoRe2iWraQe0qIkpu1HS
X-Proofpoint-GUID: IGFp_FRl5m3uBoRe2iWraQe0qIkpu1HS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c       | 6 +++++-
 fs/xfs/libxfs/xfs_dir2.h       | 3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c | 4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_node.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 4 ++--
 7 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 69a6561c22cc..891c1f701f53 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -436,7 +436,8 @@ xfs_dir_removename(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	xfs_ino_t		ino,
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -481,6 +482,9 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d96954478696..0c2d7c0af78f 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -46,7 +46,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 70aeab9d2a12..d36f3f1491da 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -810,9 +810,9 @@ xfs_dir2_block_removename(
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	/*
 	 * Mark the data entry's space free.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 9ab520b66547..b4a066259d97 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1386,9 +1386,10 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &leafhdr.ents[index];
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-		xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address)));
+		xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 5a9513c036b8..39cbdeafa0f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1296,9 +1296,10 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	ASSERT(dblk->blkno == db);
-	off = xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(args->geo, args->offset);
 	ASSERT(dblk->index == off);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 44bc4ba3da8a..b49578a547b3 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -969,6 +969,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 143de4202cf4..e5ed8bdef9fe 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2508,7 +2508,7 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
@@ -3098,7 +3098,7 @@ xfs_rename(
 					spaceres);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
+					   spaceres, NULL);
 
 	if (error)
 		goto out_trans_cancel;
-- 
2.25.1

