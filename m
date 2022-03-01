Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58351C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbiCAKlD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiCAKlD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:41:03 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F87A90CE6
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:22 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2218UkhV018833;
        Tue, 1 Mar 2022 10:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=qGY+q+M1B3ote7wFWawZmN2dTASqaiTz5oj5r5FWE4A=;
 b=mfpZ5ILgciMpVmUPxS+ybf5avuuv06mwmnfzQzikBIu3TAn5inPmSCMJ5rq+E5rGJnC2
 J+LJoU6ZAM7xcAl08gchDUg7fBk4KjoEYzvYh1q56YGcXNQB3sKTvevLOvlXxk7f91hv
 9XxLnzUDCFJUtT245miprr17UEwyInv1kx1n4VTVYiwc2pREOXPQg6wiQZ8/AxDKmSnw
 87upcNkZ6H03mlKOZFyDYXjrvqzSXvNYaPXbb2D6XqdO4aI9ukFruFWDx19QR0zf6MSR
 I7Ir3epfqu5jnjzPjXpOWUfTbGlJvZMMSGw28gEbNgzmHrEUyA3PzqOKTC2uLJl9K1e4 HQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15ajakb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221AZNd5043010;
        Tue, 1 Mar 2022 10:40:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by aserp3030.oracle.com with ESMTP id 3efa8dp6cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OR2M4BpKBYftHJ66DjbkggDNs1wzELV8oAg9SEuS+wvOnm0j6mBI7PuhYE9UtuMm/g+cKstjnEDba3iy4FVs8e82JccIGCEFx5CeF1T6k8r03r46FjZl7FwuQJHMKcwE9a3PXEmWkYhxG32wHPmKoc2Ue9ZO7K4LtgW3kicak4tGZ9vU5viDD97qPE63pj/AkmvqQ5H8T25WbjjB8kb002Uqvn2M7TgkKCOAeBXsvMdb8YwoUWjcnLS0tIkj9MHTyTrp9gCwG+AfkABLw4RToq56a3bFvTKBSCNBe+oG0WySUQR1xrfFeAsSMRQBAUkxVRd5qc0AM5mXgjcKlaKJhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGY+q+M1B3ote7wFWawZmN2dTASqaiTz5oj5r5FWE4A=;
 b=GgV8Nv7M/hB3RbFnPy3fKdSwIpkaANHO7nvFa/l6jBbFDK+hIDkYz8CIbKKmYcAqnWJDNQ4U+rcX5ieJPpomipVygQfABR4ztS5Byao+lyYXAHzRPuQBhHS0SwD4RaWp25QrGiKdoG5GcGU/eeMcorpXOndnY8VVNtM5pxdAW/ymnLoUS5NdGPPpq6fiHHK0VoVRsKuksmFLtBrzOPxNOG8KNzbnV9YH6dhkwqDBV832DoQLjQHKdCx0o8OotSxnriX8ffpdpYKkS1ie65bmjJ8ocH2SvQqxl2IzRsp4QuSWlZucVY7Rrlsn/6uDAa1SDl0DZpNA/cMV2ZzZCUSMiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGY+q+M1B3ote7wFWawZmN2dTASqaiTz5oj5r5FWE4A=;
 b=IUsDlWVIIyiaadmmk0GqhNyWD9RMKKAfzHHnIul20nrIABs6q3RfAyb34IrOpdyNU5oSjp55SdW+jO3MGTg9XlG0gsuB513D8JbASnb11+w8/lqVK4V5MZAPI2of1j+Lt7jrw0/qJ0sAgvwHUvUCk1014vJs2YIQjRdu85BOEzQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:40:14 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:40:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, kernel test robot <lkp@intel.com>
Subject: [PATCH V7 06/17] xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
Date:   Tue,  1 Mar 2022 16:09:27 +0530
Message-Id: <20220301103938.1106808-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301103938.1106808-1-chandan.babu@oracle.com>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5c5f44e-18e3-48e0-a42a-08d9fb6fde4e
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB41606EBF5703D00472830AD9F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BBV3d2BEcD+JRiWAT4hXvUvYeuzr2MALlCsnU9OOKNkbPk5oG3uvivyPKYpAexqnBt4pOk3Tp12uKU+QtLbDX3q0Ov2pBVgvrWF2NCxOpGdu7/VvtKmfvRVuXg7AcNIoGNgZeYx+QAYwbBqpZNI//4B0Bd7635lZaTUaJMIXsjbFJZ9KL97B1Npd88XftuFaa8L2sFaKDSzr1TgTxUaphN9LwQ8qYWeCbMxZgSRZgTz88CyPNShc5qNf9H7w+4YZcyJkcBZoC2fcooJpIekY9Kl2mCT+BXLol+pMuY9Xy5b5T5D4cpqM9EWUZEH6RmusV6Ab1PEws28/lBVgSRQbTpp2QUq/r23YCP4CMwv5iEpEwRRSEViagKN417A031fV133gsaREJjNH5Edx7ZDYm04eNOAgsMJRFZ+eR/OMNOEdKo+u5UHjnE05gYQmpukW3t1+43+h6bLBK2Ws0v8ML7umBtmY9OwcqCtKqX7eoucFEPjlzMKaER5Jq0DHR09HUlQ5d3Lfxo/ceGnaQJSKnPXXef/+NUAOkYiSJWHZzZGIf/P0szs7mCQeyrkMugv0+1j7rWmoJWSG8+GUqDz92LmpCSP6wtHoH8XOcMIc6/EfJ3ux7NXD41nvswOKYvqeYYkQfsRNDTZLGkfBSg5XMmW26wmuVX5UDxWOOAfSkvKSQAYvKyHOYnq7diG6ao7KsJDZlY9UxOPClJstYqjZSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(508600001)(6506007)(52116002)(54906003)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?USOEBTHerL7N0SasyMgP8YnlA+rgAk3gnJ0F7fk3tkRcRmA2NM8OqiG5OvEC?=
 =?us-ascii?Q?Syu8VMO/2ZwzsPV6G9DrGPQGqeUBr5jWVVhWMnJ/WjnE2Xrwc4iC7Se3VyJn?=
 =?us-ascii?Q?kFk7vQsc4kVrM+zxNVRbKUKcMjnMn5JTeNfUXVSr0r+NEVTNJUf7Pa8dftm2?=
 =?us-ascii?Q?DmiHKk6N+ZTMAq1FGi1BKNTPXACz6AMZ03loO4/oIJL5a4Rw5r7WDAK7jb3m?=
 =?us-ascii?Q?VPSCTxcq+XvwDq4mRjIlrA/V4IbmC1HZJJrkKt+Q9G9ADx02qbJ7/tLJbuob?=
 =?us-ascii?Q?eyv6Ii/iHBZ4QmEMO23B/jh4SKWBbgPRYeyDNmCsTZaylZTFWX/1bK9EDg6t?=
 =?us-ascii?Q?6ycqneKJnfojD935r/JlSOvO5VKAKVj8PoxumLpnwfmTUn/VdgvyV7WL9EL4?=
 =?us-ascii?Q?w/KguXm/56sv0BaRWbHfqxgW+MxKkCeNpartNDkhqRHwAR4PKm4gGZXhvJ2H?=
 =?us-ascii?Q?Ad+iNkZbLhdpBbq9MfnmMQ9TlSbQNhQvFsn4KcleEVeT90JYJSfFNHx8wUjv?=
 =?us-ascii?Q?Z9HRnOA/YSSgvM+XSoWuQPY/gC7LTrMKxkpCQpBZUue+DDTE4UBBV7bzoXgO?=
 =?us-ascii?Q?UWLlgaCaf3NTIGgJesl/lk3ukpfrcUCfOQgN6xo3LZPtXLMGSOIsOpreX1fu?=
 =?us-ascii?Q?b/XGfK9ZxQPluZQpKgJ2FXKgOyofNshawcwHp7VqxpJPcXf6Iz1XN6WOQuqD?=
 =?us-ascii?Q?Wb2MWaE0WgKOmoBBwhIZG81DqdamrKz0jzQOxY6VRso5nnYZ0mO0hNM2Q86B?=
 =?us-ascii?Q?hDlyXhsKd6T+L/Wz7laupyFCK8ox//x417C0225PEUJPIYGxU4tyPTuMlRSe?=
 =?us-ascii?Q?mGZzxwt//OZu4u3vWNs2X5Ia/fIPf67wDIt5IdT7St/LDVT/pauiuisL8mQt?=
 =?us-ascii?Q?ZYpVMNbk52t8XuMpLfG3ktbeiu4QUmRVcL2amEI64UzVLTDx4hf6/g7FQOpt?=
 =?us-ascii?Q?E8k881gqIsuyKyvTV5fDOKR9Et9xWoPEDiUfZomuUlOnu6eWp0KaFknH3sO5?=
 =?us-ascii?Q?dt6P9x3HMQJl+oHMz3REddpX2N6/hXR1RWk0bPS3gFV0do4i/mwI2rCmbclW?=
 =?us-ascii?Q?7vdnyzLKhO4gqLZ99126XnFkpLplEmI0Qy61k/DODFfbgRtUuzNVMdOmlF6C?=
 =?us-ascii?Q?DBalpNhVJ8y9A5VA32oYNKbFyO0Pg38BJ3GeSBk+xP0a4iEHi3k9RteUKSC4?=
 =?us-ascii?Q?JPzDQTI2qcZqI7Dbe+KqPoJ0Jm0LkPt09HkhNCloGTug/J3U3Yv1oQkN8y3a?=
 =?us-ascii?Q?goskSaI6I1M5iZw2pn0CuRstQrBsXidC7+TZtlYJu8gqDWOdn+kgTJTQ4+2c?=
 =?us-ascii?Q?wFwsKSntwCOO8J+uajZZK8R4yrDmOruQvwHFAd4pi9lBoqMGsnI8fFTW14hR?=
 =?us-ascii?Q?JjX5DFOVUBUcC6lt2UXG5oFj8HicB3pHSBRCtcVccHFQ/mHQrzmUTOZc5TF5?=
 =?us-ascii?Q?jWb1nO8kByFHeLqpmU7fgGkbwcD2tC/8tDmRjRuwjoq+V4iGkken6zABu3tN?=
 =?us-ascii?Q?OqqOqxplyVXhS5VMGRMmjWLPVijP/B+X3mnm5xJ5Ri4ZeqQhC13kbqfEEJxY?=
 =?us-ascii?Q?hdVArn6kqvb8cmrWlLctb/ZbpJ047axqPMu/TXQnm/Ctfpdi4/Dspv3K2gla?=
 =?us-ascii?Q?CN5jVhQcmzyR+P8aaFolPvo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c5f44e-18e3-48e0-a42a-08d9fb6fde4e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:40:14.4584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YrR8IF9MoSUWMnKDm8MXDJZWw+fpBvU1HJ3dlRAdFq9twGrp+3//n0f7QmZUSAHAphxz5qBjorPoqywtSK5mUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: GK6H807xxrrBY_oUqyDeMW0tnY1C565d
X-Proofpoint-GUID: GK6H807xxrrBY_oUqyDeMW0tnY1C565d
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will introduce a 64-bit on-disk data extent counter and a
32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
of these quantities.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 6 +++---
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.h | 2 +-
 fs/xfs/libxfs/xfs_types.h      | 4 ++--
 fs/xfs/xfs_inode.c             | 4 ++--
 fs/xfs/xfs_trace.h             | 2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 98541be873d8..9df98339a43a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	int		whichfork)	/* data or attr fork */
 {
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -83,7 +83,7 @@ xfs_bmap_compute_maxlevels(
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
-	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
+	maxblocks = howmany_64(maxleafents, minleafrecs);
 	for (level = 1; maxblocks > 1; level++) {
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
@@ -467,7 +467,7 @@ xfs_bmap_check_leaf_extents(
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
-	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
+	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
 		__func__, i);
 	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 829739e249b6..ce690abe5dce 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -117,7 +117,7 @@ xfs_iformat_extents(
 	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
-		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
+		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
 			(unsigned long long) ip->i_ino, nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7ed2ecb51bca..4a8b77d425df 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -21,9 +21,9 @@ struct xfs_ifork {
 		void		*if_root;	/* extent tree root */
 		char		*if_data;	/* inline file data */
 	} if_u1;
+	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
-	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 794a54cbd0de..373f64a492a4 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -12,8 +12,8 @@ typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
-typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
-typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
+typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
+typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
 typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 04bf467b1090..6810c4feaa45 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3495,8 +3495,8 @@ xfs_iflush(
 	if (XFS_TEST_ERROR(ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp) >
 				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
-			"%s: detected corrupt incore inode %Lu, "
-			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
+			"%s: detected corrupt incore inode %llu, "
+			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
 			__func__, ip->i_ino,
 			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
 			ip->i_nblocks, ip);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3153db29de40..6b4a7f197308 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2182,7 +2182,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__entry->broot_size = ip->i_df.if_broot_bytes;
 		__entry->fork_off = XFS_IFORK_BOFF(ip);
 	),
-	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
+	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %llu, "
 		  "broot size %d, forkoff 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-- 
2.30.2

