Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE98BC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355254AbiDFJkY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586128AbiDFJg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C5425278C
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:45 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2365paEh024455;
        Wed, 6 Apr 2022 06:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=MMDlKqCizWigRCSILJFeS8zKvl8s+2VrynUlR+eOuys=;
 b=iaaTiQsEkiy5GY5mn6fNp7WZSEMWRtYlGoVvrcjjW6ty1yp7mKCA1CM3v96GpS3Enm97
 yebMl15Ap7wjp46YDBasFimsMsJp879O6VzXmTSY4kSLr+xmc4FjGpaAqbHAZjByV+h8
 IT3RokQ6WiziiLz+mTlyYLiWjXiW/mV7QJ71adEaPGsT2qWHmxizZmn0/dhhTwX10Tpg
 ARa21rRBRv3qKQzv1jE5gFuoWZKgpXiW6N4GzWkgijA5C5sAiNNKGLj/Y865zgx/Y4cv
 x+6uDEmWbpfPQrf9i8iXkL+SIudGPLHrFIbDGC9nnYocsBKXu7pOIMUjwMAcYKMmtsvF Ew== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1t7yg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366ARNU036393;
        Wed, 6 Apr 2022 06:20:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx473qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YwbtKbetoSFSlMBeJQI1d697FRI2/ss9i4pN+BNLEGxpcoZR6x0LMgbEh9PJHyn/bIfzhlZx+a4SfXj0jq668Nm4MFc6WjYAdlaQwEuvyQvzJKwO0q+BvGgv4UXtJQ04Svqn5JjwnMrcos6plBqrhhBO1O7Umy1oxuNg6A+NE796Cu+1s5/bGknwvUqMkov4fBJRlOiKSbstw7DKqtBsAhdVlWd2o8ofw4eoeAOdyd9s9Y3pNTg3a9xJYNur/rJ3uDHcx7RaQwwrbAk3yHKHhBVE0ccf6/IHwbCgCJao8URc7TSw1qUCP1loL5U1SFDagZPG3XYGk6x4KU8Cyll6tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MMDlKqCizWigRCSILJFeS8zKvl8s+2VrynUlR+eOuys=;
 b=U9LzcRIeIBfHacYcS2usEJvJmWpGaodqJGe0htclC8N0fom22640BMKOLOtpyeMBLzWKTEFBu+L6VF+Bmnzd4MuRXj197XAO/1RVXBM3k9cIXjXfepF99VviASBdvHmVDYUMEMKMYFfS/6a2AIUP3kgOzZXJ2urZHgSYXBSGTKsgNTAaSnG5oyR7Opgt7HbkCE72uY3wcO6W2DR+NEc1LB5ULlykvvjUVFzLQTGOHQEtJJWICDlqs95S2jCjwN5ZIW7mMwFCx4bFa9scjKR7tQcGfWHtY0x8Em5AhGm6qm6cR0vgc+dz+FA4oQVk+tlJ0MgopLrTD+PUMx0uB8lCBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMDlKqCizWigRCSILJFeS8zKvl8s+2VrynUlR+eOuys=;
 b=HlDIiG+jIkUs28NXXPbQUGsSAv8uwE9xQQKNST+sJsuNLnT20F8n0wcJ4a3dg6fz8Xwxibtt8RPKOAxKRaA/uLFomYlrpP/sw/D1XS4JWkNsOQN24qsGtrBUnAnKCkO7TIHFZNI7OJBNXs3BzAOp1w/oLaD/WfQFp8op8CopQ9E=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:36 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:36 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V9 15/19] xfs: Directory's data fork extent counter can never overflow
Date:   Wed,  6 Apr 2022 11:48:59 +0530
Message-Id: <20220406061904.595597-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061904.595597-1-chandan.babu@oracle.com>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0047.jpnprd01.prod.outlook.com
 (2603:1096:405:1::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6b51566-372a-4a8d-0cdf-08da17959051
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB556409CAAACF4A17CCD7D0B1F6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2mJrIwp6kj8YaCv+VDfnafPFp+GGNO7qyJQu7dpGTb02LRsixe9/QUNZmh1QHQCja1yMf5cTpY3Ed6AeZNmuAuU2xW8f+nSjgKkEIeUUiLD4zAlf5cHlx8GFOWzjVvLj6rcPDtjsToy7OnbTaZPOx8KYITLyk+pTO6w/R91YbjxDnibt3Q4Z2S3G3os/wLEITNcCn/1gyyCoRCkiOnjSumQ7085RIQ6q8xXwEjGnCb63dVvoJ9tDOvSckPodr1kg6XTZcqtD0kmQvvJhQrusaQPQPWikiMcRKmdHDn57S8narZq8vOibk0BjzL24rOE53u6FSbx2kZPkjhRcesTZLRYWMdmXcvAzaYtE+nvKY4NkSFgLwotVle4z/UoHs4XAd3xJ6FVBOXQP7PnRYPnfzZCIEzB51Magc1Z3NAlf6H/CCOnmFt1kCcOOQ5iojyNYHOrdL/hoxHuRtIskDzkgDo3KysEWp6wVmI+Y+Cln6Axq4Z0TEnK+fUX1g5Je98f4yV9PUdQPVMinGcNidVjW1hlEfmek4KwVWJhP+4+NYkJz4Vji3kdb+oPRJUz22ZzIC9QPKj3UCjpw8E7pO9FeY53uMqwGAsvISTVTWA985hex3VGQ7h7zZeQG1TJhEieJUoLm7pCcX+u12jj97VlaxzR+w3k7u1kGm7RTX5UWtPO+f+yG0YYiySJLTfwW60jx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zx7fyZw2nuETLtNrVAIybMZX31nPYzDz0uPd87g5gxSNec/cJeiFAW/LNMSE?=
 =?us-ascii?Q?/HoScd1ZA1r5b52eOWiwXORRD/PeojykcF5YeIbShnyx1cFNztq3IOApLImi?=
 =?us-ascii?Q?zKjQCC/Dmg2NmYpA1VPGQX2bRjjoBpqiUnz6Tc0kB/Fgh1ntdSuQKSxRu4+f?=
 =?us-ascii?Q?avn9GZrZK58EOJlP3Kd4nbGfhOP+Y9icLSanTM7i1iP4l7XvZz+T4SiIltwq?=
 =?us-ascii?Q?7LINpwvgqTJhKcGJ3SS2pvwUAgy/8NSPHiZ2WcPjxGPHMvqszBTDsZK5WiF3?=
 =?us-ascii?Q?OtrH1oO50xAADaX06kPb/XmrEp7/n1Kb/HgDSSC2v96p2SM3hoH3cumFfEAg?=
 =?us-ascii?Q?6y4sIIx+gVCljHVgqQNWxH83vqODo5K1bThWjSmcNFFZZugY+jrpzfgdOZv8?=
 =?us-ascii?Q?VoXZNdQANbSEw4wp7gwRqpqIfywwNMEUjRO5a2qiss9+ETIZdsSc3TJU+eJm?=
 =?us-ascii?Q?LneQvDvI+hHq2ATi1fI++7tExRxWFFOiowY1eySKZ5TZyiIkGU3XBFGtqG/e?=
 =?us-ascii?Q?4k5lvxWjA8K1XYN2hvvbgKjDRl6LpS4Zc0tXa8ijeb5e3XBChfWHUIGsIkI0?=
 =?us-ascii?Q?Zin7ebyp1IP3JOPFnJEOuK8gyZny1o5Df6yn4I2gC0XEmX7LpFxw3QxvB/xp?=
 =?us-ascii?Q?o+L47IOBspoV6TlhGGPsyw4TRzy9QUb7Df9WVj/445zmFzlQsWmksrIYzv8D?=
 =?us-ascii?Q?VhXI6apcAcXKjrDLjM++gLII6KCeDZtGoKgc20tvZkJECHWpBDlOk0YbSYve?=
 =?us-ascii?Q?BqsS5FdmU7DnGl2WpLKRXQdhHCYz0Dq9M9A1sgGSSxXUkeMP41S8QzDv6mXT?=
 =?us-ascii?Q?CoMgTB6ap2FuDOBmK76z+9roMP8032DWJdlQUxQ/GM/6LbuCWFPY2xplp+ol?=
 =?us-ascii?Q?4i9zA3w6FgYEtkw2pB24EY1f2ZbicfDVsWOkx8cXVij3fkISyhvrdPXZZZxK?=
 =?us-ascii?Q?SVvbXA5N/GIaWwWDk0y0m0mN6X/XNhuXBsbmbMR0GraSGA7s6DanO1QZRB4O?=
 =?us-ascii?Q?j5b3MZRRJr1RVxMvRpmPGqIjYkZK5+iWCwKxVR8b7CkqYhNBMgvseVz9FLa/?=
 =?us-ascii?Q?OPc2wAzJRiwiY0Ixe0zp7rUylWh2JeWwIGad6E8Al42t28jFzGbHnQgLV4RI?=
 =?us-ascii?Q?jWr1nZ6gKJjseb5qBQpcgt9imau/aSzCybi2puAwovVd/nwU+waYuOeEe1ZL?=
 =?us-ascii?Q?CxyTgmr9f1Fz9hfpgGOEClro2+rzRit1BcTeRPwbTD0DhdV8/jYe1YIYI+Tp?=
 =?us-ascii?Q?5UFO0t8XlUw1tSvkdi/MOxeOxE/ICZp0EfWGG5pAvlJ9MeBHD97Eo3hXtzeZ?=
 =?us-ascii?Q?eZlRYq/DNkubv/7d/n0VAfIdBviJmp1/JNQpkf4HDwbsIoNKd1DQ+GHUAPE9?=
 =?us-ascii?Q?7CCsW92F59+uoHq2LD3j6OOmKqAS3+kCmFQt1sho1J/MwuAfqSiOboyjlJrw?=
 =?us-ascii?Q?YpTFVtPdtE0gjkBfhrivceTO/+bPzLd8NLx819gJJqu1bMNBakoWDozKiX49?=
 =?us-ascii?Q?t4VGOUr2Pd121l9gndVyC/kV44IyQM2IW+ajpfZxyhySxZpBvDXf0jQEBxMp?=
 =?us-ascii?Q?+ZkOq8071CPPh/5EggwSQdn/pfFTNoC4Eu4rUtY6JzCGuZEsxL8jyBygWqIk?=
 =?us-ascii?Q?6Ovsi6URZyjcHmwy+CyPHstX9dmJuZkCH1LoBKqAmJH2OuAcyglRu394nRMN?=
 =?us-ascii?Q?wumGv8MM658TM0hFPyRHK4A3vjmH6d6HF+9rDJlUyG/Kdev8qMVL3aoN5RFB?=
 =?us-ascii?Q?b7N5OzE4mykJuABC4ULa/ybgkp1Uddc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b51566-372a-4a8d-0cdf-08da17959051
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:36.6861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MyfjxUfPNeY48OUtcQAhJ4vJexqAlEK0WlDU1mQ7lqkZbRbbJzpgojT10P34X+wvzESOYqi9YX4EAdUweRFosQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=769
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060027
X-Proofpoint-ORIG-GUID: 2kIQP2FDHEmVyX-0ym3GeKw73PBok83x
X-Proofpoint-GUID: 2kIQP2FDHEmVyX-0ym3GeKw73PBok83x
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

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 20 -------------
 fs/xfs/libxfs/xfs_da_format.h  |  1 +
 fs/xfs/libxfs/xfs_format.h     | 13 ++++++++
 fs/xfs/libxfs/xfs_inode_buf.c  |  9 ++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 13 --------
 fs/xfs/xfs_inode.c             | 55 ++--------------------------------
 fs/xfs/xfs_symlink.c           |  5 ----
 7 files changed, 25 insertions(+), 91 deletions(-)

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
index ee8d4eb7d048..54b106ae77e1 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -491,6 +491,15 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
+	if (S_ISDIR(mode)) {
+		uint64_t	max_dfork_nexts;
+
+		max_dfork_nexts = (XFS_DIR2_MAX_SPACES * XFS_DIR2_SPACE_SIZE) >>
+					mp->m_sb.sb_blocklog;
+		if (nextents > max_dfork_nexts)
+			return __this_address;
+	}
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

