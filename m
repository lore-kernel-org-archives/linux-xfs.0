Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF020C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiDFJkH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586546AbiDFJhL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:37:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FE11E377F
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2361hkhk014690;
        Wed, 6 Apr 2022 06:20:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=oDX5sp+blu5cW/cQgbqJTVBFAnneYtv9GyGASaP8k3A=;
 b=UsdrROS8rGtntKgHwHVxiS9X539DNfwgtO1TD+d4l1VR4ha3cPCaX80cK47LSdT3xAEI
 oHTs4IQQto5ke5TJbwSAYRWZRscxcZ48agL2toGFYhw56ZLPQms05USxs//xlY60IQXE
 n1VJVCnZ7un/7cQNlkJbdALryurfZ4lEuGJv04DqOwY1nhkzYu1VKdPTRb4uHSZyEVXm
 wTvCY4s6wRD3MByCymjwlfmcs7Toe/tEvUBsJAo5EetRSZ/4JGYhELhBoJY7/d9/3qkt
 eNl2twJG3NtUcGzUes3O1EdN3lgFCaV35xhWAsT1ySbpD5zjtQS9Z2zVXIasK8CKe8iQ zQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9qrsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366ApJR022762;
        Wed, 6 Apr 2022 06:20:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx48htj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpTs7NFHCwFI+NdRephKSAxYE48/EChmFncPdZTwjEcxiI6dWC6jB8fyS/8oN+dkJbjivCAzRl/NB+2iOM0tlT9dPzNUYPAWMGL1CGb351HOEIZLYBxg3s307o05lQeGbPMxVKDc+cszlb3GL6uSC+UEHT6rscCDuKweGfNivIeeTnkhgJg8A2CfLS7JbwKy0dXwBzGCIRsNSLiA9/5ZNOym4wCXkHpHA/DdG4rFTCEXsB6Eu2ILo8m6tM6jOEpwaO5jB4292QyTtj7g8dlmFY9MaR9SLA0NDXZAwVZnkHCzXh7nZxDK/7lA2UrFxG8711ok04O0s9A6UjfMd6G9og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDX5sp+blu5cW/cQgbqJTVBFAnneYtv9GyGASaP8k3A=;
 b=dYFyxQmsEewEL3c6FHJJBuTox+K1gxUDmA2BrgLgshlm+Ky1/If6lARw+rn11VR8VIv2RbdMEQSJG8otZQU7BD7ETVYnaOHZl/GM1oVqVg4L9BycmOnT6iv9AnYGAjwxDSy8kd4whpSChy6AwgSi4p0gnHG7GPsXmku4EwICPpqTU6NTQ0mKFxqZJkWpLFdHwIAAS/qNz/ZhG1MoDUfD+qwne+yf89C39T/5GxpUohze5VZTZeeiBSrGs2sOTMc5eIxVZHAts0X/NKVaWx33hYa5d7Zoc/Zx/9iauRBi2rQgpvZiK+N3HNnMH6dILP+6evgaxvZQiPIhv7xJ5HolQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDX5sp+blu5cW/cQgbqJTVBFAnneYtv9GyGASaP8k3A=;
 b=brlXS2QJ+Dj91VLJpU3smORC35cCgwwYTGEoPBo1i3AMcdbmAT1Mbkh6ELSXmRhb0diFGmwNN0HwOW19G9dfioGllTSlOf7+VlxPd9YLqWbNhiEL2Rde5LfAXOg2CKukGmIcQ2E03LB8exI7qsqmiT74vSb3pYWjkbe/qnK4aHg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5660.namprd10.prod.outlook.com (2603:10b6:510:ff::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:44 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:43 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V9 18/19] xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
Date:   Wed,  6 Apr 2022 11:49:02 +0530
Message-Id: <20220406061904.595597-19-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 41a44ce9-727d-4353-8bb4-08da1795947d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5660:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5660E151175AF60B3BA2FEFBF6E79@PH0PR10MB5660.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nxnQxWzpdqI1GqAC5trao6eL4UZ5WNddKCnt/3BBmV33qzdBee3uTwP55GphhUVLwxvd0jTeU/9mS/dajbIq0CsUwGaY+lvIs+TRK/AIzy47x5q+WfCw5/ErfKtY5t8tDSfG50QtTLvg0ZxZJ7bhYnKAjCjaXXW7JwjOkQRbLwYJoEHpcEPO9wqOXMkgPz9Zjd655cgON+j1XJf2TE1Rw56/gLadSdZmK28YFzjkutYCa6UEffR4PRT9rgGheesD0ZXlvmiAvhlkgpRSZjrk8/+3qt/giy/A2h/udEOJxTOwC72vyG60H3vq7kqYKmM3Q6zMObx0xzTCZF7pPoPYokh53aQgLiIu1EBW19GKnGo2J5EDqkmZADam7mmcPZKCSFSByUIQa5VqhG7F+LaakscruF2df0rOvY5nLbMXQWbxdtjc1OV7IrjmGgU1pTaXtDRfUQIuIWW5cq0RVLUJeU6d+F+VhV3wB9u+wEdod0p1uGtibP2gLKDm0JTJj6iPpziU5dpwIxTWXY2ozupMGHeZ2or4rwjWkuPT/AY3V+LINkNQVfUNoOXhTsVNd1YXgEoby2c3R0cbQR5cpEmQ3u/6nAufm2w006Mr/uJxKokS+/J2vGxipdB9D7FzK8+/9UKuMZ/7FpNNKrOja04A12bF9BIINiIKzyevUJYF6YMqhwAD8Pv0kI4ykjoPS73TujZ0y3IWXfSjwmBS+YBrJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(8936002)(86362001)(508600001)(1076003)(36756003)(2616005)(6506007)(5660300002)(66556008)(2906002)(186003)(54906003)(26005)(83380400001)(8676002)(38350700002)(6512007)(6666004)(316002)(66946007)(66476007)(4326008)(6916009)(52116002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jKTlZEL0sb6o1pBFV2uq6Fkrmu1ql76zJMEr7TmJ9bwjLl/aZ1RsvTl33Q9K?=
 =?us-ascii?Q?E2uo+Yqwm/v4uEpJABjWcze9/JQ4bi6uqa3UCEPISMc+sfOBUZerRVWk/jiH?=
 =?us-ascii?Q?IOJMOrNmawkRnAOkWigsprxb8N/VQBxFYskZb9SbYTOKYocWWSz6cZADqsr4?=
 =?us-ascii?Q?HAgedZAUnpDuuv0YK6EwsyyxtiBfOLI09Snw7K5PgJTI4II8HqIMU3oP9Y/D?=
 =?us-ascii?Q?cqplX+NP0Bx+ggs7uZ+WYsIafprQnVVxyS2vLu2q6ngcrGeUaCMk5NI9rG00?=
 =?us-ascii?Q?LiXNurdSRnVmK949eFv0AYaIT/O7WCJJxmLttI7aw9vjYwZxZc9ThJGBm8xr?=
 =?us-ascii?Q?cQy816QUyO0/Bl+rorfWuOoIFv4sS/IBtJvPpk7Un1zjbvgTdsSNdvTUG5I9?=
 =?us-ascii?Q?emBp7OWUFaj4k6lwQ6BCEfXPQD1LY0toAKoVBFGblmxiKg/q0XIPRY4CfNjW?=
 =?us-ascii?Q?rHZRafCIM0brwrfikTL/cc0vgyuDSfVWcHnPW23j3wWj69XaD0JkxWgyCQ5O?=
 =?us-ascii?Q?0P+hmJDzvbsg+FE2ShxKjX+OG/UNa2rWwoxlDcLJuTMu1O7Il79VUtJUDt03?=
 =?us-ascii?Q?VtSEtCxicqQWTOQ7qvdHlR3oy70W+4myfF+WT3EEPBEcdOe5+C9HfMSMKx/Y?=
 =?us-ascii?Q?m8AEC+5uBg15ssMOjcChc993JsDkmFq0UindqPHykzXcAcadHYAfwLPMCqqh?=
 =?us-ascii?Q?IN/htVY2Oq/pW9vMNUttVZjhwsaF/FBHKamudX6qBxDtM9lbT7xpWva/ZUpc?=
 =?us-ascii?Q?mDEJgSDT3GYfhKq4wtXBDbxkuuUGfCOWobMUn3FyFZk6eQk68ww5L9FS4KcI?=
 =?us-ascii?Q?9c4AvmaypJ5cffkR5Ko6CBSB4L01i/ZMKeG080rHT0TMp7XcAQuaiY3opgy3?=
 =?us-ascii?Q?AAS8xTHF8sxbdNjM/UfaaJ2IBcroCDlLO7FhG62QWvaXy9OPAc/Daz3fE98V?=
 =?us-ascii?Q?UQVEqFm6L+KxvVTU9hlWfVqFCe1msf9UF/bO79WpW6mNRAjaIiPtgO7YzKLN?=
 =?us-ascii?Q?BnVoI1D0+grTgOBP+WBDBvrhpKUdBTbxFuz211XIAQPRhmLnR8jbc8vNE1lo?=
 =?us-ascii?Q?KjqkjIpSFWxiVH6X3L+5ujz4uhHWY73FV2A/6nGN3HzsalwehgTH/E+EO6DG?=
 =?us-ascii?Q?RJy8Pi/iKaFZdNWFDFg3hDHe8YGcv+wzNljN/B0UufJdCZxyJUT3l5Vv5U9i?=
 =?us-ascii?Q?JctvfgkZwvGAkr9XNXX9her1ozxZaoSE9x5nHoKUwnjlsnGWOxnTGMl/vvaL?=
 =?us-ascii?Q?whD1pn0VHVSNRKSkxzfDZPdbZZpNvv2SUfaJo8V7i0WqmF28sTrBVROYswFK?=
 =?us-ascii?Q?mHieNR79KRmTXgh+NczLcJXogOCkVizCVlXtb+9128yY+XmB0Rfhyyzm8AOv?=
 =?us-ascii?Q?3EAt5QdzTYhvFCDvO6lYj9p9uDkMDEO3YhV0ezvT8m0urZqwanOxgI0VRdd+?=
 =?us-ascii?Q?dJ3lsj/y2IVibr4Rt53+eoxT2F7xHljPNtHudnJgcEbimAk8QVSd3CXXjprf?=
 =?us-ascii?Q?1QeyN1kzs30WU3K97V81+cW+6OKgXYjtbqshuNq8ThRAMfB4PuRTMMUtppO7?=
 =?us-ascii?Q?d+zubTYECTzY3ZAmzBZ0+AJNpmbJR2DHd8XARmums41YU4xTlovtk7TZH9OG?=
 =?us-ascii?Q?eqUwswXRGgcqavfiapz+5dPZAxUSL7LNgq6yX9QbYx+8xlkCcbU+ZC37B0Dw?=
 =?us-ascii?Q?qyGSaj/qFiVLlbl1+1gGepzYhRkMwarQQ8pBamubVPbCfsJP0pUO0DgAxXbX?=
 =?us-ascii?Q?W4nJw+RhlWkChQntmqCwjj0DJp1lLns=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a44ce9-727d-4353-8bb4-08da1795947d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:43.7042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XBzANhi4mUpmpi3eaVyBIlM8gdXMM/fh0CeGeqAxZ6kT9yYlk5Gs1pmhb/cCw+qn4A4anh9k5jfAqWvi130rrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5660
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060027
X-Proofpoint-GUID: czyjpxovsxXmrhi6ljX_LBUAViB_zY-z
X-Proofpoint-ORIG-GUID: czyjpxovsxXmrhi6ljX_LBUAViB_zY-z
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following changes are made to enable userspace to obtain 64-bit extent
counters,
1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
   xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
   it is capable of receiving 64-bit extent counters.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h | 20 ++++++++++++++++----
 fs/xfs/xfs_ioctl.c     |  3 +++
 fs/xfs/xfs_itable.c    | 13 ++++++++++++-
 fs/xfs/xfs_itable.h    |  2 ++
 4 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1f7238db35cc..2a42bfb85c3b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -378,7 +378,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents;	/* number of extents		*/
+	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -387,8 +387,9 @@ struct xfs_bulkstat {
 	uint16_t	bs_checked;	/* checked inode metadata	*/
 	uint16_t	bs_mode;	/* type and mode		*/
 	uint16_t	bs_pad2;	/* zeroed			*/
+	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
 
-	uint64_t	bs_pad[7];	/* zeroed			*/
+	uint64_t	bs_pad[6];	/* zeroed			*/
 };
 
 #define XFS_BULKSTAT_VERSION_V1	(1)
@@ -469,8 +470,19 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
 
-#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
-				 XFS_BULK_IREQ_SPECIAL)
+/*
+ * Return data fork extent count via xfs_bulkstat->bs_extents64 field and assign
+ * 0 to xfs_bulkstat->bs_extents when the flag is set.  Otherwise, use
+ * xfs_bulkstat->bs_extents for returning data fork extent count and set
+ * xfs_bulkstat->bs_extents64 to 0. In the second case, return -EOVERFLOW and
+ * assign 0 to xfs_bulkstat->bs_extents if data fork extent count is larger than
+ * XFS_MAX_EXTCNT_DATA_FORK_OLD.
+ */
+#define XFS_BULK_IREQ_NREXT64	(1 << 2)
+
+#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
+				 XFS_BULK_IREQ_SPECIAL | \
+				 XFS_BULK_IREQ_NREXT64)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 83481005317a..e9eadc7337ce 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -813,6 +813,9 @@ xfs_bulk_ireq_setup(
 	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
 		return -ECANCELED;
 
+	if (hdr->flags & XFS_BULK_IREQ_NREXT64)
+		breq->flags |= XFS_IBULK_NREXT64;
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 71ed4905f206..847f03f75a38 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -64,6 +64,7 @@ xfs_bulkstat_one_int(
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct inode		*inode;
 	struct xfs_bulkstat	*buf = bc->buf;
+	xfs_extnum_t		nextents;
 	int			error = -EINVAL;
 
 	if (xfs_internal_inum(mp, ino))
@@ -102,7 +103,17 @@ xfs_bulkstat_one_int(
 
 	buf->bs_xflags = xfs_ip2xflags(ip);
 	buf->bs_extsize_blks = ip->i_extsize;
-	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
+
+	nextents = xfs_ifork_nextents(&ip->i_df);
+	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
+		if (nextents > XFS_MAX_EXTCNT_DATA_FORK_SMALL)
+			buf->bs_extents = XFS_MAX_EXTCNT_DATA_FORK_SMALL;
+		else
+			buf->bs_extents = nextents;
+	} else {
+		buf->bs_extents64 = nextents;
+	}
+
 	xfs_bulkstat_health(ip, buf);
 	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 2cf3872fcd2f..0150fd53d18e 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -19,6 +19,8 @@ struct xfs_ibulk {
 /* Only iterate within the same AG as startino */
 #define XFS_IBULK_SAME_AG	(1 << 0)
 
+#define XFS_IBULK_NREXT64	(1 << 1)
+
 /*
  * Advance the user buffer pointer by one record of the given size.  If the
  * buffer is now full, return the appropriate error code.
-- 
2.30.2

