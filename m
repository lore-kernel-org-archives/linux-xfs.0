Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C5BC43219
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344384AbiCUFU3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344385AbiCUFUW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:20:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA6B344CA
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:57 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L54Ji4031878;
        Mon, 21 Mar 2022 05:18:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=oW1KN6VbAfM5lK47B/S92vOMY1WkQFMCIC7pIn0qbpA=;
 b=QxLIuYOnZUFXOn1+H+oApeo94XDPxIYrXVcFWyR9cOFXVzODXHVoKG9ttAfviwrn8SPo
 mt7KD7vrZjpp2qsJOGMgFD6tsUyMzVu8Hu4rA7Zs1lW5Gmx12RnNurdtFny7EgxD8MvL
 Mjj8fxP/csjTz5gjI7NytC32eXBvXOzE8G4yknh2YuWOapl6kOkAyjd1MnA8DbB38Mld
 2+8JtKPg/nboq5VL5WuBpB3U20F/CaGj/iiMDfUalV3J+ufZtdywlVsO8h3kak73G6S6
 WTkvgxfGGwe/MJ4hsebdhhnwRDoKvUhGKLMlHltZqb2cWz4OLl5mMwqV35QWxYWEzrzs VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0j510-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5FvGu057853;
        Mon, 21 Mar 2022 05:18:46 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by userp3020.oracle.com with ESMTP id 3exawgev3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHzg+HmCEIzzDd5/bXoMsmM/GQ+MYUOA74/erd3fX3Sa/SOZSOO4ajLiaWQE4QEXBG9X9h7w+XVHnU6YDaCxIsp8Lv+m5EDXnILt1K1PIpMjp6/Z+QOQHl0Z8C7k7vd6njt4gszLqTPFdw9PI0sNRJGx89tXi/QtMyDNo/v5YYVcq8pZ1XnY3OJtz9AdnrosuuYYIrlbf9BQA3eRusgUPc5fQl2BYiH2q4G4GQDtVN8hceHMB9hlaT35dRI/eNMLjAsQ/Z5t/CG+It+vtSpTfGGfWzNoMhjn5eGPHLxiHfnlKKx5z7q/HSY0PwZ/ZGFopPWhgj/zfYccVHEA96nnhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oW1KN6VbAfM5lK47B/S92vOMY1WkQFMCIC7pIn0qbpA=;
 b=fkDl/aVI58R1UNngigBCx7/BFfTvHXqOrkAfqDBsR84DcMAB+LDm3pGgVyFh2rfQbwnUnHSxhkl7Y7MMHi/z+Yre2M/PGrgTm6fZTAATTk2NLqosJJNlbvGFf4y97TELM7G0l3ooqctxNW1KQukZ4bLOGWSluFp28q1Toij9UQf9HBs+o7pcfuETrpWX/94kVlV4YcHye8cUFLXlarlahhckNFjGdqfIP/C9Lr7lHVR54Fh33WS+caiMARO/tW6ZRypaWCevJgYgVph/6VFtSyLiv+mWUBRsbj5iDX9UBIBoUKRsV9OHEU6Igigas7rX0B0+aiDuS4H3i4SAuTsZlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oW1KN6VbAfM5lK47B/S92vOMY1WkQFMCIC7pIn0qbpA=;
 b=ekqnXILLmn8fJiiSFT36/VagjJKKZNH1dOKMXfxslEm546VnB4B/tv/BtiwJN9zZLtLLkY7DTEkZBloy+9cFfTRGavsPHA9S569ALROKNg633xBK7t+gKTwc+beXJBb9TRo7+nflUk82PYWivkDsXLe5lGsJ7PB5wq6tM3pkTJU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO6PR10MB5537.namprd10.prod.outlook.com (2603:10b6:303:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Mon, 21 Mar
 2022 05:18:44 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:44 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V8 15/19] xfs: Directory's data fork extent counter can never overflow
Date:   Mon, 21 Mar 2022 10:47:46 +0530
Message-Id: <20220321051750.400056-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321051750.400056-1-chandan.babu@oracle.com>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78e9080b-b9d6-4b6f-f9fd-08da0afa44e8
X-MS-TrafficTypeDiagnostic: CO6PR10MB5537:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB55379CE9E103479952CEE564F6169@CO6PR10MB5537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HHQIN4EXlMLhwk5cVZSoePhV2r9wxhXoDwfmzJBEmSX6TfoHCqNsmzbIJsa3oA59I3jpOHJ9EXgiaOXbn0zxex7uSYT7Zp38m9EAFK27IXwd8eXQvnxWiRJQwQY7FhrFdYxW9nd0HEScE0xdvt1J4r+KoBLfOnUapl84idtX3dKzi8+j2CdqgFOZsi//p7+y7sCHnehsR0EefDvnI7lou16mj9u58LklkSEPT3Dv+V3qjpaS4J99ahQfzMUz4z8Vvr4W1fTRwTSkHlWI13S8JqPkwwvZcNyV4c7wSDNrWi6egO4Aw337LBKDdtlr+lFShik0UE6a2ZCHIPizd7v//vi9FdpO1dCXD9S0etuYtCO/MeB8UiAIbb0g+RX6z4pQTbk11RsTku5RajIMP71QHG7I65GKFskuEA0ZVTrzgNy/3JL+olqYZW3YyWmzLqInOSPW5h495Idl2GNXaIgVPVrkx4rFH/NXku9qQo+4Wa29lHfFAOsrcZiW2xSX+XfSZP0LeOIVLdmwqyhExW/Rjvc1sdezxZ5RXyxn3HOxAlBW6LgEViymm5robAH7wLbrJHOt4NG9zv2gdD3kEoNaSjU8UG0PPf7WU3Q5fbfe2xoLnWLRBfWcZeP0O2v/eaJs6Z37Y54yiJTXrwn3Z7PjPUN4cUzA+rDWMarkPzl2DxXaS8jVnL/4LqALg8tFr4IClLsxIBf2kgnCblXH6TRWgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(2616005)(4326008)(66476007)(66556008)(66946007)(6512007)(6486002)(86362001)(6916009)(8676002)(508600001)(316002)(26005)(36756003)(52116002)(5660300002)(8936002)(186003)(6506007)(83380400001)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VR/FawIYf4WbXznhqmlhgpIt+Bntq8broXmDjNS/ODVvS8m+SgzKeImiZnL4?=
 =?us-ascii?Q?0icr+ORfSQ8iAAjH+lbnkKmnACfJcjBVJcCgLVGOCQj7HOAsaGb3t7wV+ckn?=
 =?us-ascii?Q?nCyBJYWZbvLXtO1J9DrAyvOUstqhVj8MFN0UkoAZKFTlhNUMDKpPw75gS5Xb?=
 =?us-ascii?Q?/j10httHPELtn/FPylYesJ644XhL+zkBg3w3Vf++AjYrB5alqgVonNdMR4fe?=
 =?us-ascii?Q?H/qne6RSh8w63D+dPMsBNEIWw2HjJqK2f/QzAg8SikxUKbpjWzwm/GiV7G+y?=
 =?us-ascii?Q?MGMEsyO1yUe1cfhr1iRZrnB4NgikRIba8LPrrEJmpWsGi9OQnikxx1gIp8jR?=
 =?us-ascii?Q?8xfMnahbeewMrtNcirO12rJ43eZI0NHIPr6PZbpxvY5fGpbjNjjtcmhatfY8?=
 =?us-ascii?Q?3fTHDa7viKlQ5QNvgIgzj96Z7p4H4XmtuVNdzvHpLoTtUuLiCEjfwX8BAA8M?=
 =?us-ascii?Q?ZGEepMPOmfSnBI8vvje3CXQ5wZzEtj6N1hVdlINZVXs4WXAZXzExyjW6zWxO?=
 =?us-ascii?Q?Ygu/ik45VBHjt6XvE+8if0Ex5tI0oLGaFevHR/E+p0J5b9OvRq/nVIgVgx5e?=
 =?us-ascii?Q?gLn0iqzfgXYdeE76iZb6ex7yLWEDTUVXo3yLytqfqMhXGfH6nIw644s0FmjB?=
 =?us-ascii?Q?8heiiYRchswNzWr2+TsgeYIQP+f+uN5MI5JitXddixN7v5eZxBR44MYHMmAK?=
 =?us-ascii?Q?9ZIb8V8rcRwer3WQMAvcusOBQexeBZgL6tXMsvlX8u9cDOt/DO9XdKiuxSfW?=
 =?us-ascii?Q?qvMJuLUVSISOSrLZxiRNwKpXSELYVY7t+2VtXF4s2RSmKyFp9ikQDm3ZNGNl?=
 =?us-ascii?Q?gv6E9kQ609U591i4mQ/ahoJ5T18c79QhEMlcxxkSndJIb1R1Fm31SnFs7uvl?=
 =?us-ascii?Q?t9JipprJ29LtKuKtzQ7EY2pI7b/+j4hegAitcYfdto33vbUudaVXgk+irrZJ?=
 =?us-ascii?Q?bxsbY0ywtAEY6niTcV7AAco3cNIvVCx52GdhgmNXQOUYdowCQ+LVdt6+InA/?=
 =?us-ascii?Q?C38vMUcuKUgCPVS3AhHbn4vi1L+bUxZwPDWH1KxfKtJpm0wQPcqmGAETa5c7?=
 =?us-ascii?Q?H0gthkWq1feyMmPYkf/TT+lA0aCROrPhVrvmDmGMCILn20neYmkwDo8wS/yn?=
 =?us-ascii?Q?vGT/GzvdSWEmoQUA5/R3+jhib8nKRhct85TynL+1N7edutFfCkMlfGg/QeFU?=
 =?us-ascii?Q?RX+AquwxXPJpkgZ4nWusKSYqGVbomcoD9pHK3NwFLVyKuEaq5WTUVxt78SSH?=
 =?us-ascii?Q?Eu4ZERZdYcYJh7zOTiGzzpZYhnSe7uK0QGZE9azQp9eVB3Tu+OWzjH1qZOj7?=
 =?us-ascii?Q?GdrmnLL3iTnQxTaeXrBPsfCfYdNLWyOy0grDFHxzzfogIuDXnOO1sBF11TJ5?=
 =?us-ascii?Q?p/HCS1UyYi8VuGrov0w3HQVBVPFGMmPSseQEIEN63Z5ojoEV6mMX+LvXoWQe?=
 =?us-ascii?Q?FsH1yRvvi/za2p8ezB/xiWuvQzshIicgh7bYeHqY3ssX7X0O2HY3nQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e9080b-b9d6-4b6f-f9fd-08da0afa44e8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:44.2284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1PD7XNaj/bHtqZ51P9MdJpJ8m0QaQbVxBKeZcEMcZKAyuwrtEODy55NniPn5PyeDpK88BR+VwPg3ZsL1vmYmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210033
X-Proofpoint-GUID: G1s3Kg7J8vsWM_X3PZsR4BvpQ3zXsUym
X-Proofpoint-ORIG-GUID: G1s3Kg7J8vsWM_X3PZsR4BvpQ3zXsUym
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
i.e. 32GB * 3 = 96GB.

Since a directory's inode can never overflow its data fork extent counter,
this commit replaces checking the return value of
xfs_iext_count_may_overflow() with calls to ASSERT(error == 0).

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 19 +++++++++----------
 fs/xfs/xfs_inode.c       | 32 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_symlink.c     |  8 ++++++++
 3 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1254d4d4821e..5a089674c666 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5148,24 +5148,23 @@ xfs_bmap_del_extent_real(
 		 */
 
 		/*
-		 * For directories, -ENOSPC is returned since a directory entry
-		 * remove operation must not fail due to low extent count
-		 * availability. -ENOSPC will be handled by higher layers of XFS
+		 * Extent count overflow during directory entry remove/rename
+		 * operation ideally should result in -ENOSPC being returned.
+		 * This error will eventually be handled by higher layers of XFS
 		 * by letting the corresponding empty Data/Free blocks to linger
 		 * until a future remove operation. Dabtree blocks would be
 		 * swapped with the last block in the leaf space and then the
 		 * new last block will be unmapped.
 		 *
-		 * The above logic also applies to the source directory entry of
-		 * a rename operation.
+		 * However, a directory inode can never overflow its data fork
+		 * extent counter because of reasons provided in the definition
+		 * of xfs_create().
 		 */
 		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
-		if (error) {
-			ASSERT(S_ISDIR(VFS_I(ip)->i_mode) &&
-				whichfork == XFS_DATA_FORK);
-			error = -ENOSPC;
+		ASSERT(XFS_TEST_ERROR(false, ip->i_mount,
+				XFS_ERRTAG_REDUCE_MAX_IEXTENTS) || error == 0);
+		if (error)
 			goto done;
-		}
 
 		old = got;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6810c4feaa45..6016013658ff 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1023,8 +1023,25 @@ xfs_create(
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
+	/*
+	 * The maximum file size that can be represented by the data fork extent
+	 * counter in the worst case occurs when all extents are 1 block in
+	 * length and each block is 1KB in size.
+	 *
+	 * With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count
+	 * and with 1KB sized blocks, a file can reach upto,
+	 * 1KB * (2^31) = 2TB
+	 *
+	 * This is much larger than the theoretical maximum size of a directory
+	 * i.e. 32GB * 3 = 96GB.
+	 *
+	 * Hence, a directory inode can never overflow its data fork extent
+	 * counter.
+	 */
 	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
+	ASSERT(XFS_TEST_ERROR(false, dp->i_mount,
+			XFS_ERRTAG_REDUCE_MAX_IEXTENTS) || error == 0);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1249,8 +1266,15 @@ xfs_link(
 	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
 
+	/*
+	 * Please refer to the comment in xfs_create() for an explaination of
+	 * why a directory inode cannot have its data fork extent counter to
+	 * overflow.
+	 */
 	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
+	ASSERT(XFS_TEST_ERROR(false, tdp->i_mount,
+			XFS_ERRTAG_REDUCE_MAX_IEXTENTS) || error == 0);
 	if (error)
 		goto error_return;
 
@@ -3232,9 +3256,17 @@ xfs_rename(
 			if (error)
 				goto out_trans_cancel;
 		} else {
+			/*
+			 * Please refer to the comment in xfs_create() for an
+			 * explaination of why a directory inode cannot have its
+			 * data fork extent counter to overflow.
+			 */
 			error = xfs_iext_count_may_overflow(target_dp,
 					XFS_DATA_FORK,
 					XFS_IEXT_DIR_MANIP_CNT(mp));
+			ASSERT(XFS_TEST_ERROR(false, target_dp->i_mount,
+					XFS_ERRTAG_REDUCE_MAX_IEXTENTS) ||
+			       error == 0);
 			if (error)
 				goto out_trans_cancel;
 		}
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index affbedf78160..0e5acb00c59f 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -23,6 +23,7 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
+#include "xfs_errortag.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -226,8 +227,15 @@ xfs_symlink(
 		goto out_trans_cancel;
 	}
 
+	/*
+	 * Please refer to the comment in xfs_create() for an explaination of
+	 * why a directory inode cannot have its data fork extent counter to
+	 * overflow.
+	 */
 	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
+	ASSERT(XFS_TEST_ERROR(false, dp->i_mount,
+			XFS_ERRTAG_REDUCE_MAX_IEXTENTS) || error == 0);
 	if (error)
 		goto out_trans_cancel;
 
-- 
2.30.2

