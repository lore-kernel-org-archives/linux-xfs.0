Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A718AC6FA83
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiILN3D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiILN3C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:29:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E853055B
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:29:01 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEYNW002662;
        Mon, 12 Sep 2022 13:28:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=K1+2Ca5dwjFb7xZn5XlAWFUQBbR5jfH8M7ReeSdA/B4=;
 b=hEVNGvQwRaHLVCBNQFX0rPYDdvpDPqv9HNdf/MA6rNl0FzMf7D5OC0ZLmFk2IGW7V/vt
 5qeUQizGoFnrPwjhjk2KvX+ad/+S6ok6LZ5NFl5J9L8biyAS9Zwr/IlG0Y0ob5YR/H5F
 npYsMuzveSTG8mjf2krpZd1YEFAG62h6gVqMGvSKii9jsVLxjGQRts6tF1scXpVJA4gn
 Pwj2CqEON6S6zOZGfuAErvjKBQfsmGukjSWcQ+ztekrafES4zh6UzoqPaUX9ytnoqqdL
 2qqoLeFLnnBTzA+wlYZrhSvaXuJ4LI/lwCrZDQYbziyB6IZkq5vt0PRKp5U53Z9sM6Qh fA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgh0c3g2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEhC5010288;
        Mon, 12 Sep 2022 13:28:56 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh18tr4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9xVoqfogPMEZ87gT9YV3MXA0gQvNK1K3w4te1XGX6ASYD5D3ICRQLizYlel7nAa12PrOwKzvr8X6SkdhJQP9q4PRqGypp44+2LWMDuJdf14Re30g5n5QHTHKI4APyATiZNmfr3W8goboP+4/LfdNgVpLHVSjGu+LEtBfzsNE1FI1q0yDMc7uhdmY6ArmQmdMkf+qpnsFodFovB+rhqlyBgEnikYW70voGQ6rqUy7ia1EV+hWLw2bY7WKXcoMZHBI460AwAfgTYgbH8jQfTGMWeEYqRB8SC7sg037tN6R/Tmu91LYg3kTkOurEH1SSqCCzUiwwlKDjPshC3Nu4eRRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1+2Ca5dwjFb7xZn5XlAWFUQBbR5jfH8M7ReeSdA/B4=;
 b=YJYXyCGbov7aL9DBsEZ4vNp2nmKbAKzmQwk6bDBASQlcMiDidqVsLbLAPDzJ4vvfHkcVeyUU9jfGmt8PQfCu8uh9X7+KgPB6CIBeN7LM5txBslYuFdSuaDamHEWk727DolgjjCq2ZekslVZenPqbwtyc70amdOKyTMMHuvWshR/o/thigpkf7kMGunAE69M7L0opyESh9rDZyeIGnjeW1IMxVQNLq/R14bF7wF7wbhFVUThnBs8674D1tua2E6NT4O8HZzH/+AasiU0PaSWlBky8faDPZKAtwUwEakIQzd0URY4VLdVHBdQBRDxxnzygHMH8RszPPPPI6L/9TV+pmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1+2Ca5dwjFb7xZn5XlAWFUQBbR5jfH8M7ReeSdA/B4=;
 b=Yqr/c/Apn/Rfg5rXiG0T2Bdz35Xq3n/yMnSoXe3R5EhCm89J9MQleTgtgjIaEvP/uSAvhirDQ9mcSqGBJC+Z2ZpW3grzvDKIUrBu7bx2PNAeV4XPUEjQSTL1zmQLM82lgHaPjlMmyaHtxaZ/ye3cG5jP4YpD+XXCXtqcsW3KA40=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5888.namprd10.prod.outlook.com (2603:10b6:806:22b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 13:28:54 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:28:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 09/18] xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()
Date:   Mon, 12 Sep 2022 18:57:33 +0530
Message-Id: <20220912132742.1793276-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5888:EE_
X-MS-Office365-Filtering-Correlation-Id: 68e31e3f-452b-47d8-451b-08da94c2bd1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UEQPvibAo53hOB4AbLsJyaZpPiXUJv+EMXseVz8MI7Fp4Vw2Eb6SWDJmlMNsCaDyQHkH1SUmlHUmQvsT74dKy3vN6PcWxRWsVowpvk3Q1v9pUIGADsM0czGmYDGDX+4FLG87PSXvT4JSNM8sha82nYb2XsnRgDWOwW8T1cmDoknF8vhzjPSWgXXQmAsoqAP4YxG/Oo7/EU2/xYUPAK0LUf/jga2j2VyUqipue1+aJUbp51xEBRK0FdEwlPN2gLVmBr+AcXXtpxnoq1xkxqAwRVcCmbDSgafZYQ4V09+xauta9uSJCg4N09NHh+B7hab0kYII50EKSQ+yMdTb3x1/gRWvqUV2Rp/6+egBbzmOPgacJb7bi+O/Iu1x3g6Zb6VzgksVJLQCEWpmA+wLUX+vX8kSjppRZ/8XkxOWnbZkB92L03m2/nVQXcXyn1hvdUqblrZQTuj80IsZrh4hz1RdkGGwt7ST12cPS2GB4DdqLubSuNXuwy+cfUCEvuFl1gQx5pLB/iPKjzG509nvVu8WoTl2b/vIVWvNyU+vVd6VD9l25SDV4Xsb6qbFRAumBBAUnMPo/faAGRJEDzJUTTAsx2dhCpm82IWgratqq1qVv7Dz3bYsNRVGOSAzSrhWB8dtxpnBEWHrCMKyIPRwXP4xrL8+BZnUubHG9DnXEu7eZZJmcLKOacgicXxtIbX5yWya
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(376002)(136003)(39860400002)(6486002)(36756003)(316002)(6666004)(8936002)(6916009)(6506007)(83380400001)(478600001)(41300700001)(186003)(2906002)(1076003)(2616005)(38100700002)(66556008)(26005)(6512007)(66476007)(8676002)(4326008)(66946007)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PwrZGHytBz84uc9Ay0sjOlq4EV/wN65F778qMUHZU4gCvZEIGlkiwAoLorCY?=
 =?us-ascii?Q?zEEGIo0KGTCIiF39s6YJqrX0R8+LbC48wUHjyB/E8NjvJcPwAu0mrAOwwT/Y?=
 =?us-ascii?Q?BLyxq14pA8CA5sSMi6EZbgBBxVvHNM/vitQrRwsxD+p1saiXq9ALWjRA1hv0?=
 =?us-ascii?Q?k0F1oApBmJ8rPaI9Rin890Lrph1a72kc6c4Uv+aeU/vkMOvqWMqdWCIC/5a5?=
 =?us-ascii?Q?HC0dVZcIKlsJJRZ/pRejYki6wrymg04/x4JMn8VINn+n1n1PGzOfVfkvZ87s?=
 =?us-ascii?Q?nas7183APs0sG8TdOCc1axCfVKc3Xj+aetfoR6011Flgi96mZ405mHM+7206?=
 =?us-ascii?Q?ASEycorlpPHwpdTU4dpFSYee4LYdrOd28PciTXSA6K1wqfLrs/BBCjCNW7t1?=
 =?us-ascii?Q?v65uELsA9YXPNzVrnDG+n2martdvxzqIdCaZu2K6Fq3f0AFlJuN3uwwQoHg3?=
 =?us-ascii?Q?P9FJTmLzAOpZxeBW+byRczkAO19q9Ke/uZjsTuN5UVk8wMzfNCSaUi+7hnlv?=
 =?us-ascii?Q?ZMIPoOHous9/rvZV4ZlBOCRmqkL9TfjleFeL3Wqw0ST+Br36j4vwe7+JAp0r?=
 =?us-ascii?Q?at517gXq6/iSTOyHkWzHDBETntvmMrtBXBdBEU/Hs9YfkLgzIooYUnl4GKwF?=
 =?us-ascii?Q?/1ihyof1Q0v1nIr3ikGnyDU9ti7QPFFswmzYCGJHmKdseIYJVnAQ84ixlmh5?=
 =?us-ascii?Q?RC6PLOC4XpXsiBuRXl8oO++bU7vrZd0Sgv0w+xLTDuAtOx3KNDWNZLLUPPQy?=
 =?us-ascii?Q?abGgdPZs7l7Q6S2rQOuQZjPQ5FE3iwXVzS8gsKpYYzT0sxUoJU7qqqLTzTZr?=
 =?us-ascii?Q?uY3xIRm9DRqoHbU//90ijWIk6LB8EacogtSDI75J0y494IBRqtFSrRVOT/Qy?=
 =?us-ascii?Q?xlfpXlcvrvU8HlXC//GosmG3iD4WHPEbtCVJ/LVuJTNrpecH9Oc8uvH1yxpK?=
 =?us-ascii?Q?seFCM50BkZZx+5g/45CCmBx7DknA03TLEB8fV8QH1Ox4wvyfzpUcwX+nCSk2?=
 =?us-ascii?Q?5LMkmBQPthjUmN2Mt48vvTyDF9WIrVg54/Qeg9jfJzpXK597UMkLpbisIxpd?=
 =?us-ascii?Q?PGv4qwhJuNdEcOexNiKx6wwM/ArzR3YOgfcZuIWu0VJsa8fAcbjltads6ayv?=
 =?us-ascii?Q?YepLhncsoWX/ah8OvmG1i8oF2MY+yrncw6frw8BGRyuWeQYEHT7fQPumjjsH?=
 =?us-ascii?Q?LTotqpyS9hvLrsh4Dpq3bCYjJAq83Z0R3VK/d3DD92TFa7mcQMQhuo1TgNXj?=
 =?us-ascii?Q?P8uaE0zLF3X4N7vKlCR0VnDK9GjEKcvHQSnzGlVrXqfAdM1QgeYEtry+SziC?=
 =?us-ascii?Q?NUb9J7aysXy9eNjQ8khFJXvJQJH9pdlxItKd7Rpmfh6iHdAv9qnrYhr3YcVt?=
 =?us-ascii?Q?rGHaWxvxJpTTxFxiBPIzWT+p2UzZK0YjGGJkO4uG/wzvoO4lr0r8TzRLapim?=
 =?us-ascii?Q?ozL9ZKvxnUnzwkMQIctu+/dd/ZOp7mFjPjrdA1pAZ3JYsZC4oswvf++0AbRV?=
 =?us-ascii?Q?V570aebcHTJ1LpdL8qebCxcamFA6vWxki3yW8+vEAg3/svYgqZ6zfSxg18oo?=
 =?us-ascii?Q?6XTv0P0616nNJ/ZNYyHsr/D2XeUSRY1lAPxfcUYsRb+D7TN6iz8ekfCbsgjf?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e31e3f-452b-47d8-451b-08da94c2bd1e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:28:54.6758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pSiziv1QdJxRPz0kiPKk/72rx8R+nU2CQI4AqPLOpdQ5ILTS6i9au6uZa2cT7k5Ow5VcM1bXj5naZfCHRL1N9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5888
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_09,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=912 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-GUID: mBOj7tVlc6dOnfIry4bPo7TX6t2wAqZ5
X-Proofpoint-ORIG-GUID: mBOj7tVlc6dOnfIry4bPo7TX6t2wAqZ5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: kaixuxia <xiakaixu1987@gmail.com>

commit 93597ae8dac0149b5c00b787cba6bf7ba213e666 upstream.

When target_ip exists in xfs_rename(), the xfs_dir_replace() call may
need to hold the AGF lock to allocate more blocks, and then invoking
the xfs_droplink() call to hold AGI lock to drop target_ip onto the
unlinked list, so we get the lock order AGF->AGI. This would break the
ordering constraint on AGI and AGF locking - inode allocation locks
the AGI, then can allocate a new extent for new inodes, locking the
AGF after the AGI.

In this patch we check whether the replace operation need more
blocks firstly. If so, acquire the agi lock firstly to preserve
locking order(AGI/AGF). Actually, the locking order problem only
occurs when we are locking the AGI/AGF of the same AG. For multiple
AGs the AGI lock will be released after the transaction committed.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: reword the comment]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.h    |  2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c | 28 +++++++++++++++++++++++-----
 fs/xfs/xfs_inode.c          | 17 +++++++++++++++++
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f54244779492..01b1722333a9 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
+extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
+				xfs_ino_t inum);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index ae16ca7c422a..90eff6c2de7e 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -944,6 +944,27 @@ xfs_dir2_sf_removename(
 	return 0;
 }
 
+/*
+ * Check whether the sf dir replace operation need more blocks.
+ */
+bool
+xfs_dir2_sf_replace_needblock(
+	struct xfs_inode	*dp,
+	xfs_ino_t		inum)
+{
+	int			newsize;
+	struct xfs_dir2_sf_hdr	*sfp;
+
+	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+		return false;
+
+	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
+	newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
+
+	return inum > XFS_DIR2_MAX_SHORT_INUM &&
+	       sfp->i8count == 0 && newsize > XFS_IFORK_DSIZE(dp);
+}
+
 /*
  * Replace the inode number of an entry in a shortform directory.
  */
@@ -980,17 +1001,14 @@ xfs_dir2_sf_replace(
 	 */
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->i8count == 0) {
 		int	error;			/* error return value */
-		int	newsize;		/* new inode size */
 
-		newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
 		/*
 		 * Won't fit as shortform, convert to block then do replace.
 		 */
-		if (newsize > XFS_IFORK_DSIZE(dp)) {
+		if (xfs_dir2_sf_replace_needblock(dp, args->inumber)) {
 			error = xfs_dir2_sf_to_block(args);
-			if (error) {
+			if (error)
 				return error;
-			}
 			return xfs_dir2_block_replace(args);
 		}
 		/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7a9048c4c2f9..8990be13a16c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3215,6 +3215,7 @@ xfs_rename(
 	struct xfs_trans	*tp;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
+	struct xfs_buf		*agibp;
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
@@ -3379,6 +3380,22 @@ xfs_rename(
 		 * In case there is already an entry with the same
 		 * name at the destination directory, remove it first.
 		 */
+
+		/*
+		 * Check whether the replace operation will need to allocate
+		 * blocks.  This happens when the shortform directory lacks
+		 * space and we have to convert it to a block format directory.
+		 * When more blocks are necessary, we must lock the AGI first
+		 * to preserve locking order (AGI -> AGF).
+		 */
+		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
+			error = xfs_read_agi(mp, tp,
+					XFS_INO_TO_AGNO(mp, target_ip->i_ino),
+					&agibp);
+			if (error)
+				goto out_trans_cancel;
+		}
+
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, spaceres);
 		if (error)
-- 
2.35.1

