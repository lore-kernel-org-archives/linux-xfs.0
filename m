Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB4E9C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 14:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiDLOFY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 10:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiDLOFX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 10:05:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA155DA53
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 07:03:05 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23CBwOg6003034;
        Tue, 12 Apr 2022 14:02:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=7UdZ2hdI6WQ62cR/f0dnp5oyMy0pSE4MWgE0lQHOhcQ=;
 b=rcT4Qa8Wm/vmNKrZC6eREupWib3gOsguqEXmYBQugREdSWYZIYDCocb6h+9sWpryRLa5
 wotfavxnrlBo1XK1uwdNbeJFEnDzFmPn0dzOMnegZADE90XQW6j51i0AsVgbQ8D+iT5V
 bQHmWwLRKRVFM3vFEwF2umk2hZ1YZWyokCRi8N1G57iwmLeFbUzmgR+mDLCjiREGqXye
 MZKOT1MoGkwK1DmGviPy05fyd8tQIoTxoO5UxU5FxCf78hVZFuKrBwuyUsmnxMbAHoCy
 7162QuT4q5jNPMwf/VNCFfeGRn8Agtn2K5KMR3ogUrfIRF7TLO1l+kftS+Wlucv1VKhT kQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2evpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 14:02:53 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23CE1OSF021532;
        Tue, 12 Apr 2022 14:02:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k2v5eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 14:02:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3gbOIdlZOMOej3nAN9XXF2YMQkWuxdE16z2s6Ofmd8w8S7unDvaNkkbMb6g5T7fGilCZyorxVXeIsoSsPWQnMzhr6stoZS7K9armujpAZ329/t9+msifJgq7Da5x4wYUfhBI6n/f94Mmy8eL4LMoeVyzA+6eQQ5I3b/+LNzTe8n393qhBhdUxdoOTna2oz6L7krWhsPN5ZhFThYm/1e3GwQMddldMCb1CEss7wOGkrhPHAKd13gfNJva0aWuHBYiLp8kpNtWg+xGpDHb7q6Tpo4wdK4wKcBDCADAhEwkMemd2nNAjT25WF/qYQ1CS5V5JvILcW9LDqAOjDuCHQ8Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UdZ2hdI6WQ62cR/f0dnp5oyMy0pSE4MWgE0lQHOhcQ=;
 b=Z1wDfPI1HsVYgMbiHLkqKz4aEVZO3t+dbCVyFBjGV3otzFLiou/nJEF7WlqU4y7R7DhdIOWD+TUgswZH31DK/WMhLL/GurJWvDsaIU1Xow14w3s6Q3AMBt/c4XI5PNX4pHnvBkYG2AnGlAICyu0//SeUdwjr3PjzzAaUNRGAKnw/hUJTeoTPLtWa75HwEggQ8ivO6wSBs5GfII73i2F3OvO7D466OMyXfC+MwmbGKtF9ucI6LIu62g6ZjOjsec+luUrVvhmuKLy8HTp07Bs6Bz5m6hIwf0BF+GpKqSoicKXrpBAJZ1DgjmwMfNMB6UkTcvNjp5+8HmJkYG1Ktcr4YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UdZ2hdI6WQ62cR/f0dnp5oyMy0pSE4MWgE0lQHOhcQ=;
 b=fShKdNVy99OK2cGMFJNVIt+xUvhaATGIwr9G0xscDKG5IB+E+G75twr51NPlr3n0bYfQrHRLWin0IBPvlJROW5eUlfRl2/w7ziadrk1Sc3nshRAeTc8pVl6+tcqVdhSRSJNuy27DwzE6byBFETd3LIl64DZAjk+XE1gDhXY35F4=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CH0PR10MB4876.namprd10.prod.outlook.com (2603:10b6:610:c9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 14:02:50 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 14:02:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, david@fromorbit.com, chandan.babu@oracle.com
Subject: [PATCH V9.2] xfs: Directory's data fork extent counter can never overflow
Date:   Tue, 12 Apr 2022 19:32:37 +0530
Message-Id: <20220412140237.1759506-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-16-chandan.babu@oracle.com>
References: <20220406061904.595597-16-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:194::8) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5263f52d-4dd1-41e3-d90e-08da1c8d2146
X-MS-TrafficTypeDiagnostic: CH0PR10MB4876:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB48763F8540E0322680F5136BF6ED9@CH0PR10MB4876.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FeKWXrlGl53KPe4zAa0yHesuRfyHatnTFSb2XWLFniF/viv0Ui8oMHcp8wRBSAemUqi4pS4ocrEHTov1mmjMalu7FHUpjmWSMLzTQvHjhybr3D0YcaKxYavRyM0dneou2zq5ILw4lkmpf4O3zj56OwPfYJZU4kpRmA3YLRuRdCipDKZVZ/S09DPKFozsxrkbapBjS+RHXPI71dPlers49OC+Qf9bQEiJfcPlBkR6BRLSKutU7eu8KbIcqkzf5womSjA6I2CbrFqM+lxen8cvBHihAMOEvpTV7Brj2VziIQY9BWa4mgXUIRaxvdogpZDBIo6nCt+MV1J7gWl8aKWIfyqCJiEOrDezG39OdDV+lx30VMB5cYVDUpVbU7bAMkt+J7uKLG9f8G9CsdQEpgXyF0GwSWaqgMJFq3mReka1hKpxoFJAVL85XZJYmckFryqVufpWIsV6f4ZXOYJCWb5dKVxHaJLp7OiYuk2MSBJjpJlzlEGsaA0uA/AOTmZSdmp+utLgvTjaxrEKcYjThQjfNdLgTdz4rYtnKM8vy5jkz+kbYFyJaPw7xjhH09DwkBDetIMWnteeZ3FJ1XGeX2LP7BjHSElPpNRqPYFx9FxdZiOpCwNhECjC3/Noam6lSSpxjOBmDYJyQe6zmGh2j+1jPmtgYz9la1GiTU/V9ZvYLcLuRnzEOJivuLlJtam4p94uJkV4Um+CaaJTlwjJYvPr4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(52116002)(186003)(6916009)(1076003)(26005)(6506007)(36756003)(6486002)(508600001)(30864003)(107886003)(66476007)(8676002)(4326008)(66556008)(2906002)(2616005)(66946007)(86362001)(5660300002)(38350700002)(316002)(38100700002)(8936002)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8+p4iHnDkxd1KfCjQf8WSZGnGhyziAdV+37+ZCF4lLTfAm5aCMIxGbXUplmX?=
 =?us-ascii?Q?VUg335tJsid38dZmxxuTuV8I+TzshGIiFwrSfnSvb190EKjHOjcDJCOzHj10?=
 =?us-ascii?Q?J9nrsTg7N2eP3c3ybKegTvFhf9uCEMilyp3j7HQ/njoIZZH61RdjJedQIeoa?=
 =?us-ascii?Q?Vh/FM6haJ/+Ca5h/RwAvGrGWa1p/eA4DNki5Cb2jsH4ELH/oBYEsfqk14R9E?=
 =?us-ascii?Q?eSIrdb2ThdM/aL7/ODRClQsHHIROUL3T5s9eEcJMzVntOWb3fk6Zr2vfgJMr?=
 =?us-ascii?Q?GuGIPNc21cq2OnhaxRfRimvN7F/tbdOwLW2dswR+XoFJB0tZDh4Bhvt/sJIu?=
 =?us-ascii?Q?ZrrwOzxVEZdEkZR/Hm1I1NpmhWfTBqpox07R14KCDOXonn+Uwbr4ocGQgksb?=
 =?us-ascii?Q?5UgzOsssjQysMAR0H0gUWD0cyW5JNaht+MjosCbiT4+ky0HqogB16GAUMcha?=
 =?us-ascii?Q?h7mPnj/v34wPykq4E+mjV7tt84bz17AAIn2VhANZ9KCKqDA92ObohiwApzdr?=
 =?us-ascii?Q?IS6ElbrjQixBz2kfX4IcAgCHuZhfwPOISNsX4m71gbEHjwHZpBY9et35hD8h?=
 =?us-ascii?Q?WYtb0xz3Aj+dCRs565DHDEba4zyPBY/UtHpxu/vWA8Lj9D8QeLTPqVkds3TI?=
 =?us-ascii?Q?rsYxcERvLcjubZN7gwp+zMLaB7V5RTlYaHL2C/2wF537P3v3ZkYzNm/b2bbw?=
 =?us-ascii?Q?4q5Oo3pHq8V8IyDCd/1K2jysIacH7mRWULKIoM2viHwj7GPtna1gkW3tKffq?=
 =?us-ascii?Q?tzN+poJmaXpSlMufYNkwdZtn1nPGvDAEIDFaFPchmQXiqL84M9F9UVvHzcuc?=
 =?us-ascii?Q?uXNYUuWM1JxD3fZidd4NdrKtQLUoRAupyzXQxbkVxkGUyHI4/WHKaEsVIwP4?=
 =?us-ascii?Q?VrswYa0OtV7MTxj27boMnXMrymqAR+wynftTstdyJa8U/8+TdVntzCms++sn?=
 =?us-ascii?Q?iXVfbT3uQNbotwaoZ+Vika4J2E5loWDqr9V6YOdURTcPdmdeycoQgVMJbJsB?=
 =?us-ascii?Q?sJCqSYjgiJgIMcHkaMbmBszbVDaX/VcYdz0u6tcMfehOr8GI8n24CjRgSTB4?=
 =?us-ascii?Q?YdLohG2FrBXjUjTIpPcoDEFmrVWkgFzcVGGEcfHI/JFXy/zLh0PFk5lMn3Wb?=
 =?us-ascii?Q?k/cDJJf0wWL5rTwMUaSemklTAm5oa6B2K8s8m6GuJ7OtNgWhtngFCXocLrb1?=
 =?us-ascii?Q?KQzAFiCnnGjWgW6zUx6j+SWtPQfI6GN/Dpb9tExxqn1QQBAoAjj1I33CMzVR?=
 =?us-ascii?Q?Gzi6fQDBE3tUxGi2aZr7p+bpE0nQySNW+droBokLVqZFgrwyl0PDWeUFgWor?=
 =?us-ascii?Q?foKM8jVl8ROn8WVnIogj4Ryt15LhU/DZl2J4RnLhNJAzIgpeqky7b6WIsLHk?=
 =?us-ascii?Q?6gh6Ou7+ZMO/WWvl4leyeGGOklhA4J8W+3Dutszekg3xsI22af+mt+tprjX0?=
 =?us-ascii?Q?AdQRjQ1HMnyvUSyX067cAn9SZ+RtmnRKAxuSjyx9NsE+Myqg6f7NgjHM3IpU?=
 =?us-ascii?Q?ykawD4Ya37fm+/l5AbFjXNMtW+YTTmwzp+XpQQnAXpbbzmcYKfJ5JSigbclG?=
 =?us-ascii?Q?OznPuhfsg0Cis7u8wVzPgmNTGPaLRpTjbor7fDQU+l9cA12fyiYXgBFtK2kC?=
 =?us-ascii?Q?8dHU74GoLmgU3mCabkDlh9eaqwmgWCU7fHvAB3AfScwe+MYXPZFjuv4vdur1?=
 =?us-ascii?Q?0gQ/6eIw3/6dzKFT2xWRgiT6MLP2eYhJoVRvgCD4UL/Uwu6kfCSFUiYb0hiM?=
 =?us-ascii?Q?QzgKGy4UySgCd3+0hJ/7l4zZsQiPqRY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5263f52d-4dd1-41e3-d90e-08da1c8d2146
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 14:02:50.2478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lq5Xv3qcL5dhqJT5Pj342WiLPCxxcWpfP3QM/q1XzUoNSC+fKDejxCRB5UpGbazyRVU/aKTBAmvUUYn30Sfz3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4876
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-12_05:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=842 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120068
X-Proofpoint-ORIG-GUID: d99oTHjfwL_2cHa8wMD3fTqQ-2Xw-TSr
X-Proofpoint-GUID: d99oTHjfwL_2cHa8wMD3fTqQ-2Xw-TSr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The maximum file size that can be represented by the data fork extent counter
in the worst case occurs when all extents are 1 block in length and each block
is 1KB in size.

With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
1KB sized blocks, a file can reach upto,
(2^31) * 1KB = 2TB

This is much larger than the theoretical maximum size of a directory
i.e. XFS_DIR2_SPACE_SIZE * 3 = ~96GB.

Since a directory's inode can never overflow its data fork extent counter,
this commit removes all the overflow checks associated with
it. xfs_dinode_verify() now performs a rough check to verify if a diretory's
data fork is larger than 96GB.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 20 -------------
 fs/xfs/libxfs/xfs_da_btree.h   |  1 +
 fs/xfs/libxfs/xfs_da_format.h  |  1 +
 fs/xfs/libxfs/xfs_dir2.c       |  8 +++++
 fs/xfs/libxfs/xfs_format.h     | 13 ++++++++
 fs/xfs/libxfs/xfs_inode_buf.c  |  3 ++
 fs/xfs/libxfs/xfs_inode_fork.h | 13 --------
 fs/xfs/xfs_inode.c             | 55 ++--------------------------------
 fs/xfs/xfs_symlink.c           |  5 ----
 9 files changed, 28 insertions(+), 91 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1254d4d4821e..4fab0c92ab70 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5147,26 +5147,6 @@ xfs_bmap_del_extent_real(
 		 * Deleting the middle of the extent.
 		 */
 
-		/*
-		 * For directories, -ENOSPC is returned since a directory entry
-		 * remove operation must not fail due to low extent count
-		 * availability. -ENOSPC will be handled by higher layers of XFS
-		 * by letting the corresponding empty Data/Free blocks to linger
-		 * until a future remove operation. Dabtree blocks would be
-		 * swapped with the last block in the leaf space and then the
-		 * new last block will be unmapped.
-		 *
-		 * The above logic also applies to the source directory entry of
-		 * a rename operation.
-		 */
-		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
-		if (error) {
-			ASSERT(S_ISDIR(VFS_I(ip)->i_mode) &&
-				whichfork == XFS_DATA_FORK);
-			error = -ENOSPC;
-			goto done;
-		}
-
 		old = got;
 
 		got.br_blockcount = del->br_startoff - got.br_startoff;
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 0faf7d9ac241..7f08f6de48bf 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -30,6 +30,7 @@ struct xfs_da_geometry {
 	unsigned int	free_hdr_size;	/* dir2 free header size */
 	unsigned int	free_max_bests;	/* # of bests entries in dir2 free */
 	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
+	xfs_extnum_t	max_extents;	/* Max. extents in corresponding fork */
 
 	xfs_dir2_data_aoff_t data_first_offset;
 	size_t		data_entry_offset;
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 5a49caa5c9df..95354b7ab7f5 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -277,6 +277,7 @@ xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
  * Directory address space divided into sections,
  * spaces separated by 32GB.
  */
+#define	XFS_DIR2_MAX_SPACES	3
 #define	XFS_DIR2_SPACE_SIZE	(1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
 #define	XFS_DIR2_DATA_SPACE	0
 #define	XFS_DIR2_DATA_OFFSET	(XFS_DIR2_DATA_SPACE * XFS_DIR2_SPACE_SIZE)
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 5f1e4799e8fa..3cd51fa3837b 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -150,6 +150,8 @@ xfs_da_mount(
 	dageo->freeblk = xfs_dir2_byte_to_da(dageo, XFS_DIR2_FREE_OFFSET);
 	dageo->node_ents = (dageo->blksize - dageo->node_hdr_size) /
 				(uint)sizeof(xfs_da_node_entry_t);
+	dageo->max_extents = (XFS_DIR2_MAX_SPACES * XFS_DIR2_SPACE_SIZE) >>
+					mp->m_sb.sb_blocklog;
 	dageo->magicpct = (dageo->blksize * 37) / 100;
 
 	/* set up attribute geometry - single fsb only */
@@ -161,6 +163,12 @@ xfs_da_mount(
 	dageo->node_hdr_size = mp->m_dir_geo->node_hdr_size;
 	dageo->node_ents = (dageo->blksize - dageo->node_hdr_size) /
 				(uint)sizeof(xfs_da_node_entry_t);
+
+	if (xfs_has_large_extent_counts(mp))
+		dageo->max_extents = XFS_MAX_EXTCNT_ATTR_FORK_LARGE;
+	else
+		dageo->max_extents = XFS_MAX_EXTCNT_ATTR_FORK_SMALL;
+
 	dageo->magicpct = (dageo->blksize * 37) / 100;
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 82b404c99b80..43de892d0305 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -915,6 +915,19 @@ enum xfs_dinode_fmt {
  *
  * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
  * 2^48 was chosen as the maximum data fork extent count.
+ *
+ * The maximum file size that can be represented by the data fork extent counter
+ * in the worst case occurs when all extents are 1 block in length and each
+ * block is 1KB in size.
+ *
+ * With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and
+ * with 1KB sized blocks, a file can reach upto,
+ * 1KB * (2^31) = 2TB
+ *
+ * This is much larger than the theoretical maximum size of a directory
+ * i.e. XFS_DIR2_SPACE_SIZE * XFS_DIR2_MAX_SPACES = ~96GB.
+ *
+ * Hence, a directory inode can never overflow its data fork extent counter.
  */
 #define XFS_MAX_EXTCNT_DATA_FORK_LARGE	((xfs_extnum_t)((1ULL << 48) - 1))
 #define XFS_MAX_EXTCNT_ATTR_FORK_LARGE	((xfs_extnum_t)((1ULL << 32) - 1))
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index ee8d4eb7d048..74b82ec80f8e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -491,6 +491,9 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
+	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
+		return __this_address;
+
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
 		return __this_address;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index fd5c3c2d77e0..6f9d69f8896e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -39,19 +39,6 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
 
-/*
- * Directory entry addition can cause the following,
- * 1. Data block can be added/removed.
- *    A new extent can cause extent count to increase by 1.
- * 2. Free disk block can be added/removed.
- *    Same behaviour as described above for Data block.
- * 3. Dabtree blocks.
- *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
- *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
- */
-#define XFS_IEXT_DIR_MANIP_CNT(mp) \
-	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
-
 /*
  * Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to
  * be added. One extra extent for dabtree in case a local attr is
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index adc1355ce853..20f15a0393e1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1024,11 +1024,6 @@ xfs_create(
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
-	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
-			XFS_IEXT_DIR_MANIP_CNT(mp));
-	if (error)
-		goto out_trans_cancel;
-
 	/*
 	 * A newly created regular or special file just has one directory
 	 * entry pointing to them, but a directory also the "." entry
@@ -1242,11 +1237,6 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
-			XFS_IEXT_DIR_MANIP_CNT(mp));
-	if (error)
-		goto error_return;
-
 	/*
 	 * If we are using project inheritance, we only allow hard link
 	 * creation in our tree when the project IDs are the same; else
@@ -3210,35 +3200,6 @@ xfs_rename(
 	/*
 	 * Check for expected errors before we dirty the transaction
 	 * so we can return an error without a transaction abort.
-	 *
-	 * Extent count overflow check:
-	 *
-	 * From the perspective of src_dp, a rename operation is essentially a
-	 * directory entry remove operation. Hence the only place where we check
-	 * for extent count overflow for src_dp is in
-	 * xfs_bmap_del_extent_real(). xfs_bmap_del_extent_real() returns
-	 * -ENOSPC when it detects a possible extent count overflow and in
-	 * response, the higher layers of directory handling code do the
-	 * following:
-	 * 1. Data/Free blocks: XFS lets these blocks linger until a
-	 *    future remove operation removes them.
-	 * 2. Dabtree blocks: XFS swaps the blocks with the last block in the
-	 *    Leaf space and unmaps the last block.
-	 *
-	 * For target_dp, there are two cases depending on whether the
-	 * destination directory entry exists or not.
-	 *
-	 * When destination directory entry does not exist (i.e. target_ip ==
-	 * NULL), extent count overflow check is performed only when transaction
-	 * has a non-zero sized space reservation associated with it.  With a
-	 * zero-sized space reservation, XFS allows a rename operation to
-	 * continue only when the directory has sufficient free space in its
-	 * data/leaf/free space blocks to hold the new entry.
-	 *
-	 * When destination directory entry exists (i.e. target_ip != NULL), all
-	 * we need to do is change the inode number associated with the already
-	 * existing entry. Hence there is no need to perform an extent count
-	 * overflow check.
 	 */
 	if (target_ip == NULL) {
 		/*
@@ -3249,12 +3210,6 @@ xfs_rename(
 			error = xfs_dir_canenter(tp, target_dp, target_name);
 			if (error)
 				goto out_trans_cancel;
-		} else {
-			error = xfs_iext_count_may_overflow(target_dp,
-					XFS_DATA_FORK,
-					XFS_IEXT_DIR_MANIP_CNT(mp));
-			if (error)
-				goto out_trans_cancel;
 		}
 	} else {
 		/*
@@ -3422,18 +3377,12 @@ xfs_rename(
 	 * inode number of the whiteout inode rather than removing it
 	 * altogether.
 	 */
-	if (wip) {
+	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
 					spaceres);
-	} else {
-		/*
-		 * NOTE: We don't need to check for extent count overflow here
-		 * because the dir remove name code will leave the dir block in
-		 * place if the extent count would overflow.
-		 */
+	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres);
-	}
 
 	if (error)
 		goto out_trans_cancel;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index affbedf78160..4145ba872547 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -226,11 +226,6 @@ xfs_symlink(
 		goto out_trans_cancel;
 	}
 
-	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
-			XFS_IEXT_DIR_MANIP_CNT(mp));
-	if (error)
-		goto out_trans_cancel;
-
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-- 
2.30.2

