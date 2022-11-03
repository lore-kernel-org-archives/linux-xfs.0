Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60410C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 11:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiKCLy1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 07:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbiKCLyW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 07:54:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB1B12A95
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 04:54:22 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A39OAnU008308;
        Thu, 3 Nov 2022 11:54:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=oX9kNAjrjQwIj1oslww3XB/R51jrCBSw4RFZpx7uFaY=;
 b=l35w51c5u4/UohqsVTqCcW/DbaK3Erx0vBY+BpD6nqOZ8EfH+qiUjkBGsUazbF/9kTWw
 OV9yrmxEDar3mm/okCShlCxaO6Ft+oFPE9+NCErCgwgTAFJ0nbE8bLUjzjFlofSg+AZS
 101OEzIWviY7m+D1Ee7THKngb4+wsBK+rEpG0kOfiV8wbNJARFn2q/pmOXBvdBzOAoG+
 ONs2xzrv1NSNMp3FJpL7PWsdDRE/8V09hTF9fh06T3B1onAl5AhvUQHLKRWB0ZTXL7KM
 ViQWIig5dWJVBUY0aPuclQD7PyLOH5+/q4HUCu32tMOB/CkepRO9pocmuw50ScMvWWx2 BA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts1cr0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A39alVO001273;
        Thu, 3 Nov 2022 11:54:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm6j5ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Nov 2022 11:54:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbtCSCeADouqa6Jc5ic66DRzGYyh56+zVuOV1oaDeAM8aGC6W7YNVtqvvOoMjJCSNoo+6ZuqxFDaCGfeV+XvS5urUWsahCAdPRhGJjeMc2qDrxTMiTYCFQRolE41tJRPphyt2wjXycatxv5xYecroyonUW4yrzrF+Jgr2b2B58BVNl21vXWamZUrgVFlxqbh5M2jutcVis2dRsS4/Xlci5QTp+hOTb7KQYQRPua8aagP+ZltkLZk31PAUYHCGRZEsuYbRR2a2cdE/XH1hKPIYFs0Uz3E5VnVrbqF95RwLX/xhxpa/+xFqLPJw73R6RV8Z9ViypN4Bj3W1DW8Xshz/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oX9kNAjrjQwIj1oslww3XB/R51jrCBSw4RFZpx7uFaY=;
 b=OXeynyYkuqgMXtOhR2zuADtTTrpFon6LYTEII3Igb+2dSmlUI5Tsu1bRjAXGGUHwakkl0/bScO9fymS2AwekNBckzUQmHv09iHPwoJfu9h+Mw9znEDDgyZHSvP3UlGW2A8AybJr52veRRWEdt5uNmf/7RFJckNBw3ZSpF67Ja3ft4BzJTTsiIzSJHbFZWokq+4Zn451BX/Bz0YoWEPGg93YrKVgsmDnw6HhdRjuiI412yUUEG7fF1bk05W9JVUcVtHWYChGLBdDds2daQf68oIzNhMbeOijy5QhWEqCDrvClTD3OYzDTIPjJFS8zMO5BfWRkWDd8GoE1vT4qnBhEKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oX9kNAjrjQwIj1oslww3XB/R51jrCBSw4RFZpx7uFaY=;
 b=nSq2T0W1X7iceQx70+dMomV1KFyVcj1wcqh/zzzxe6mFjw89Hh6KmjcghbXFONR1/vC4swbzvUZP5crKOHJENKL3aB5zVp/ls1/lWGDzkiDwWj9kCXy2CCMZ93rTlePdlBKbuTQt3fx+W+Po90cQysJpMw93EoRdlf4ooH4xF+w=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH8PR10MB6598.namprd10.prod.outlook.com (2603:10b6:510:225::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 11:54:15 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 11:54:15 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 1/6] xfs: don't fail verifier on empty attr3 leaf block
Date:   Thu,  3 Nov 2022 17:23:56 +0530
Message-Id: <20221103115401.1810907-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221103115401.1810907-1-chandan.babu@oracle.com>
References: <20221103115401.1810907-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0026.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH8PR10MB6598:EE_
X-MS-Office365-Filtering-Correlation-Id: 58fbe72e-8527-4f02-3cfc-08dabd92219c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RKskX5dMJoxGYnFEmlaJFe52UbQ8xwIMVz5ZZWTqgO5xVjCR2Lvo5yrv02CqS+Eu81ceDglG2Xqv3QAX9kZ7+TpUmTDerU58MDhokdasHfDy6+p+XAXVR0N6jcdVxmXvqUdNzoNHMS/nJoIaS+kSXeLOevF0jtmkR/1Q6epegad4L4jTIRFNjDggmXeKW3JnH9K2NpWYz7xpmMOOxwWcI7jHbMCJC4zlw/MWHD+Uqt0VKTogdJWjUHGPtCXrQuiIuGvHD9GlYN5/TAHmgqIBd24uR3BXeLipmPE4sYSpIPObSHnAoXjmAl0VSMOas1F7a5FccwfS0KZhQVCaWzcmv5/3vXeyv7U4RCLh8/lFowjR8Z+ZceDoNKKs3V7J581mif2Pb3ldXpDNDE3Vq3Lc+KPBfARpAMkF2+YNazrXzdCA2R3jRH+oHPz+TcybzCtqGDX9I2/BNTaeND3zdLQkdG/HfuGkBp7S1rxar88646URRitg+iNr3uj7J+q01GcxH3WLySbuMgAKsNyobN92bS+N7UhCzAYRkL2jQrF7y2iWoJO177pWPhs01LY+o4iWiW8Yaanl0mMLHau3jIEBYi1sndvj3gUE3GUVJlGwA8mP2Rq2kcsLU0Q8Y8tYadkva2I1iwTgYxthO4A6X5BxCyBO/ginKxe0Fbu35ZU99moiZMRdxS8j6nJ/X+yGbNX2gkZn2RyNr2lqkT0InnUq/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199015)(86362001)(6916009)(6666004)(316002)(36756003)(5660300002)(38100700002)(2616005)(186003)(1076003)(83380400001)(2906002)(6512007)(26005)(41300700001)(66556008)(6506007)(4326008)(66476007)(8676002)(66946007)(8936002)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qQZ8MJ5sI8R28ApH5TzB8rEpLU7cngAzQqVv+BFclfLUtZodw/OSR1gYJI2o?=
 =?us-ascii?Q?raxnts520gg6Ob0zmNtn/GuxKQENjkH9jxl5MAXqyNWnmHa7tW4wnU8Jpx8J?=
 =?us-ascii?Q?rxo+qtkrxKGAeed3oG2D+vbKiZEXuHczJvIDxFVkFw834IsR2cVZnRnq8/Ou?=
 =?us-ascii?Q?cNMyodRw8QBVH3ti7+JqxQevb8L+ZUVbWARiwm0y+wc2eGFu2/egdcbM+/pc?=
 =?us-ascii?Q?C7Ug1dvjeGZWkTN8v8smQsI+o00X/IcAa493AHVByku+x+/OgnbBIQt+PYaz?=
 =?us-ascii?Q?RPKHVWrSoycNAO5TE8bj/KDr9SqJpg6irieUpTEYnMXNSfFk0bt99NV4qCVN?=
 =?us-ascii?Q?7CMN4M4jrrmme14nGWk8rIAHsISloa+Rw/r0vy4tTSRswmuUjHaoj0sUiYSG?=
 =?us-ascii?Q?H2Gsw1w/xdK9Co5gin99jVJZ/GnPAu7N6nRHXyiKXBrlFZbRJHVW5rvNKy4q?=
 =?us-ascii?Q?pIM1jWMO/KUC1Od2juVd7BlPXkaqNR/LyAi9hHsH1OfCjoj5FQJkzm9Q5xLW?=
 =?us-ascii?Q?QaU94vJ9s4wMDidD2u/GuFA41mDMcd4Sd9gUMuA2pASiE/ODxCTco3bzak4t?=
 =?us-ascii?Q?zKE0QNZ3c4tkOMDFPvAb+q9qGOuTDhVfmAgLSQYWAzLM8fSoTLW9JW8mqE8r?=
 =?us-ascii?Q?xG0AfMA1Fg1l8NvgzZTS1pM+vyt1pYUGHCetq8DyT5TCYEscAi1lvaJByiTU?=
 =?us-ascii?Q?r3NEe4AYT8JtnyAdxaAMcvSFEjyRZ47HrhKRGYAeU6jKAlW4dCiwNeb0JU8H?=
 =?us-ascii?Q?EFUhsIG5zUodg6JSewsjQzk9g03QeroGP4TJuYPYGLmYhEPtDL84jTn9/pRQ?=
 =?us-ascii?Q?a09U8mnurj/cDGGP5hodBP/gzSnH8WEF1SdaTw40RFNDeY6VM39idJ9drIj6?=
 =?us-ascii?Q?V8qZBHa1Pw7Ivmag59E1zpABMUIVgwVfHCLiD+XAz+uGBhZR1IHN9YTz3+mv?=
 =?us-ascii?Q?SIYIX/eubt6kgMlooKJbU3mQDh902/2/eIKSsFJvym7LpwTTMiD+6MwkzdO3?=
 =?us-ascii?Q?Y9Jfx8vgxrQ7eSNsJTchhjUunoXDW3rDqzeGjZYM2apuM5W5IVRqxOX0l7HE?=
 =?us-ascii?Q?ldPAvUoO9FPhiKpLq+WDMN5rPC4KpKf0qD7zMRtnPq5S0KjV6ZItj8DXDiq/?=
 =?us-ascii?Q?k25CuPnGi4qyp9YhIb/tETPfgilO90X7NVn4Ht0Xa5mjTh5cF+kCpuYtXvMY?=
 =?us-ascii?Q?2br6urgc25MpVtpOP5LTB41U9LXX0rTR7a/SPohNbpI0YUb449WMNd8bE5Jh?=
 =?us-ascii?Q?rFDNaZMaDIkHP+O0bkgH4M7wFZh+OAIBGk41axKEcxJQ7ZffcMRALP+Burrl?=
 =?us-ascii?Q?wQkeH/AtgIcQx25GJlc7XpZ7WzO0qZ59ycBckAAk417PXSx414KutfKmjFHQ?=
 =?us-ascii?Q?MqxN8ptXIgPYdhwTxqOxj+6cvARiNd+YSzto/WDyu7dCQEnexrf6C47/eV+i?=
 =?us-ascii?Q?oJ6gRphB4Zh1yA+qtCKLCZRSVEgHMK/KAveMmrlzG/cmo4Jd7UuVhIMk221o?=
 =?us-ascii?Q?CgGC7feZ+6415gkhJxoenSnOAqtCdebjC7w4qgd4Wwb7Ul+6PBvL4TGtGR4B?=
 =?us-ascii?Q?ZLVQPTdz0xZ19AB2d/ZadKNo/Wmjcl41PHE4Nqhe6ADQRQuXAW7a5Oq42waT?=
 =?us-ascii?Q?/Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58fbe72e-8527-4f02-3cfc-08dabd92219c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 11:54:15.3889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +H+3A9KkDavJ2AY4MM6igKHq9v+G30atZyMaljd3A4dk5RadO4e5PDna5T1kLYqS6bri1h/37mkT0Wkc6Pb6XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6598
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211030082
X-Proofpoint-GUID: 3nrZ02Gsjq87rdK4LiIWFFYAjTehdAWO
X-Proofpoint-ORIG-GUID: 3nrZ02Gsjq87rdK4LiIWFFYAjTehdAWO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit f28cef9e4daca11337cb9f144cdebedaab69d78c upstream.

The attr fork can transition from shortform to leaf format while
empty if the first xattr doesn't fit in shortform. While this empty
leaf block state is intended to be transient, it is technically not
due to the transactional implementation of the xattr set operation.

We historically have a couple of bandaids to work around this
problem. The first is to hold the buffer after the format conversion
to prevent premature writeback of the empty leaf buffer and the
second is to bypass the xattr count check in the verifier during
recovery. The latter assumes that the xattr set is also in the log
and will be recovered into the buffer soon after the empty leaf
buffer is reconstructed. This is not guaranteed, however.

If the filesystem crashes after the format conversion but before the
xattr set that induced it, only the format conversion may exist in
the log. When recovered, this creates a latent corrupted state on
the inode as any subsequent attempts to read the buffer fail due to
verifier failure. This includes further attempts to set xattrs on
the inode or attempts to destroy the attr fork, which prevents the
inode from ever being removed from the unlinked list.

To avoid this condition, accept that an empty attr leaf block is a
valid state and remove the count check from the verifier. This means
that on rare occasions an attr fork might exist in an unexpected
state, but is otherwise consistent and functional. Note that we
retain the logic to avoid racing with metadata writeback to reduce
the window where this can occur.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e69332d8f1cb..3d5e09f7e3a7 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -250,14 +250,6 @@ xfs_attr3_leaf_verify(
 	if (fa)
 		return fa;
 
-	/*
-	 * In recovery there is a transient state where count == 0 is valid
-	 * because we may have transitioned an empty shortform attr to a leaf
-	 * if the attr didn't fit in shortform.
-	 */
-	if (!xfs_log_in_recovery(mp) && ichdr.count == 0)
-		return __this_address;
-
 	/*
 	 * firstused is the block offset of the first name info structure.
 	 * Make sure it doesn't go off the block or crash into the header.
-- 
2.35.1

