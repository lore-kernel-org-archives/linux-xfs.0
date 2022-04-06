Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA95C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240889AbiDFJkP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584997AbiDFJgL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923C52963D0
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:17 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2360Ygti001019;
        Wed, 6 Apr 2022 06:20:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=fBZUMunqmwJnwFs0rcIfU+gr1slsG608CbnR6gLmH3E=;
 b=ggQSdRAUu4XbST+qdK5qCufqJmdpwH4arnYRtnFmSqpR+XCq2ZfN09bFllrJ0mKVXTos
 AmUYryBzWaNlzFLzTyvi/q/a0GOMjhlPTOEbpG3cZPLuTXdyJQHO2qmsoFEc+8LOIaYG
 Hkc/YBxeUmWjJtS0iCjGH8yNaKHzE3PO+3Zjrm8ei34MH1fQNvnx/itwjb2ADDQJfH06
 PpDbIJBOgE1/X4wyAf6dRAp9LC7Cy+6o46nvcrKRutQZ5nzAXfx9DM+8/HRaOCy8TiTD
 1eCFCEyryx4N29tkNVFGCqsOhO4/DmdD5hspLTTHsAJUHneH14kc8/BzGpQrFr7sxcxY 1w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3squyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366Ao1D024397;
        Wed, 6 Apr 2022 06:20:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx48pcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYxRDV4LOIABdJ5foT3TaqRVHHa+jw9Js+/gxMyadDYAdtfm9Tn8ll6A1lHqBlaJaGIyR86vpYnAQrZIQxlWeyYTMX2spjZhd4itOYXEzphaBLEnBebt17/02LBda7n+ZWMlraGB0FSxxBrFQvkvVYGctwcNwONrOgQs3HeVKClIvc5m5pIKXdqrJ7BFYvREMJ561lDE/T8m8En2CRG6vnOiIQjtNHDC5MJixQ88P5wrHir12oIspFrs4Y/OTjKExm/UFIMgBZPcVzjZ6jvaD/nKcje0JvCd3IspmKYW3l/RIHRRIBivO8HEaDWeF0XCHbGSa/MhQA35/R/qjsFrNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBZUMunqmwJnwFs0rcIfU+gr1slsG608CbnR6gLmH3E=;
 b=MEl853pqVxdldPvL2woVDsehhZrMYDz7mTi2WNKIi2MJPzHUhMDAt9ej8vhvrohHU0MJO5fdtjyUVF1ruroyZUHghYvRs/CM+ru56nJCAn5sECMd1gxGx/ixL/3Pdh7UuZKy9tUsW95xYmL1N5VVdXCziUlhXS1tahhE+Ou5alx1WGG5WvY/O2PbPAtdwCW+FpT1nPQaqvriuC+hxzgLz7y8R+WC8V+X1ifQ9frkCaGx4noq/W+IVqir0FbD6TlJpuM3WCPLQhsBaizW7A8XXM3LiNZRpEYYboINXW/FxGsCku1LetCBAlwak4uJPqhQjtCUMjN/asKefCIcmwKOSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBZUMunqmwJnwFs0rcIfU+gr1slsG608CbnR6gLmH3E=;
 b=piEAznZP3EZ6n6LsqLc0/c1+gs2HOtRExBvOgBjo9lsMfZSJ2Av6WHfCcZQ0M1I1p+jPk+sbJ+S6gG742TFYUFBzy5TESLyHtY8dAp33cdLeqqDGBusvrU4Gjq18pb8CQ2Zw3RJhgnywgcWACqRfLJjCVODFjW98bbPLN3JPyCs=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:10 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V9 03/19] xfs: Introduce xfs_iext_max_nextents() helper
Date:   Wed,  6 Apr 2022 11:48:47 +0530
Message-Id: <20220406061904.595597-4-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4d9d317a-9170-4d2c-1aa5-08da1795808d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB55645569A9E3BEF8A5E087ADF6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4X9OzhxhbB2jTCLUJu00ZdeXaLAC0Aw6iP1Nvvi4VTfvVWjsdBs79rGENOyipgoTNsuRVKSz/yki1sq9wW22qDRoTR0wHTF8RG/3n4IIqDxBSyhlFOJiNTGWm4BUVZsLjjADFFLy1NyINWIVPbVXMjJ+BAIhAd7hasmTKva8dL2xTOTqjsjTIAC1GF4omCmjkzYOeJe66+cdK6wZds7804+vfO9H/i2KIO9TyA4BpQdTVhlkMspLCvBtkH3dCSLDfi3Uh5h3VYM1H2OsfV7NOOuqDDnxUHiQM6TZvukhKP2XFVx35CSWcjtH5ex/Z1ExacpdHuKtUAKQSEyeV+Bc/wi4EU7m4MiTVrVb3SD5jQDU2wXNSNQziOg+T0cFWXWp/P5IrQh300p3Q+vkFnI3dcCLatDPnqMXm+ejAcUwoKBsuCWQQT5et5G3zGPvLC4iUzN225VW4rJY/iJAABExax9qf7ZiVjobhCooeawIAP0MyTWlbSj9M017w2zk6yjjszBPFA2xwRgQSbfAulLG0oYvOBtN5t7uzTKGVkOqWXJ94mRi3nvG9CmXJnxvE9zoV61KQSjECxlqmGn60fhA2h8qFOM//4FdR3OMM6jRDXIlP4ZKvuc82YWFwbL3y46Ur4Sq7sYyZbsytDGVE7++TBRgoAwVIkLA8dFzeQuvSCvhs1IFanRWxP2fWyQx258LxBGQeVpI9th5MgUJ4/qQIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(54906003)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x3lSZFjK1kph4nPD8AmVHcNJ/Ru2cspbEvfJJEHIITwt4Nv6T75AMmd46Dcj?=
 =?us-ascii?Q?8GbiMQ1oytU8GWlwahDzlYe05GQbUjyzKnZvjPwsl3H0qsG14lVNKkhRtdaZ?=
 =?us-ascii?Q?USWe3okvFjyqHH2poDexhVpBpWCYikngY+rktwlG3keMRukjO6scgAKLIvDx?=
 =?us-ascii?Q?NC+O1dCYDVyCroLSIUkwgjjPtwQRhagRliRQhCkS0uZtmcICm3aEasx6gP04?=
 =?us-ascii?Q?IXHChrXRGrRcGTPkYQKLd8574b5VXIRsSLK6wUus0HVLuJQHBtHYZwctwJW/?=
 =?us-ascii?Q?hSJwHCRPiCO+eIr8QXc4lZwTLQYrBm2zmmZZ3PUbkdvzz1juhDSYa6aHYxza?=
 =?us-ascii?Q?Cls1SXabu9V1Mad7tNgvhNXcvx5Y0chSx4W4GU74wPbd/3cPjSUK5X8/XdDI?=
 =?us-ascii?Q?zvnCzmQyZMV1k3/7dT9JCxBA4snWGpXhqd0yaNMdPKHQX6Pg4SyngBbyGyNW?=
 =?us-ascii?Q?PPa5MTKtXfwaumCTa7rjPp96pCPv09UK8Iy6+gqAq3JPnCg6mqXU1QQiScWf?=
 =?us-ascii?Q?k9xaxpFLbbpjkGfRV18VvtLVk8lkHGRzifBVEx7Ee6gG8lmVaWg4X4Uox8ry?=
 =?us-ascii?Q?ivVy2ZHcfPIO7dBbdJvhsoCpAdc04ZJ8dNGOSALI4tSqtJz6lHD144loE3Yg?=
 =?us-ascii?Q?I16vsqwyqW44F1Axk/jUpNVte9RMR/aaOZw4z2iD9tbXL+1BkMfwnHeyU9vf?=
 =?us-ascii?Q?0aoIvXpKXqif+S8ea9IUUN495S4hOgaIsz6kwGvxWWOCSuC48jNq1fjnVh2+?=
 =?us-ascii?Q?6Aqs4yENvMSJ7ITgQpK9N5LdierRjmqttT78tRg4do4fy2oRTL3uEitnZb0p?=
 =?us-ascii?Q?z9EYFNttO19u70/VMWtgAbBv551h4lJkwXD4g5M4ixyeRhyvzOMDQe4b0ya8?=
 =?us-ascii?Q?CbF9Mf/tGfPtnUnCGex6lKErt9hbEKTWHfs1EzF4viFS3qSF0qOk5O0JDvrQ?=
 =?us-ascii?Q?1akSr0PPVO+SXHGs66cURTF+Rg87feJYGvyTzPOXPB8gizMTYkl+3GPRy0WX?=
 =?us-ascii?Q?yXXDXBd6uWmWgs+TXiUmeM3J0hMygQ0bsCVBTaiJK0Mpr3nYNlob35pZhkko?=
 =?us-ascii?Q?UyBIjwYL1csxF4KpfKnRmOkzZnBP4bsdh/VH7OtfcqenxF9hktXGdhbHqhz8?=
 =?us-ascii?Q?p5/0v3ayb4Auo6vwMnzTGGOb2z7q+iKEw9/b3MF3HiFNkDBcRvQG6YuK7ayY?=
 =?us-ascii?Q?pzwoNpd1Y4epfhKILmayjBes30XLsjjKPWKbOO+FhiNiXCDM7XBnjslaS2wL?=
 =?us-ascii?Q?6QOKUaLQlBDKPHUSzKbTijvXYxOclWm80Wn07CB+YiKvu3UiBxBtwY24yX+H?=
 =?us-ascii?Q?JLTroXaIcsOCCAz8YOfvakUfrj+NI/7Wl+E03Y5D/+2KY+885yOKia0+TZQr?=
 =?us-ascii?Q?uH1D1VDIckQMwxv3PzCimWXFaNIETQW8+eulWDcXYy6zhwn1jsp3USmd9wuu?=
 =?us-ascii?Q?qZQrJXlPM4ss8LqhSlX0ArIoUd56NIlk6x6WxHQh2S56J/vU6cpF1KE4q5tm?=
 =?us-ascii?Q?qMPfcgI4UTwuOSGF6NrTSYPhC8HkhIHEJs0YpwQvhyL/kw4vJlwUuOK//Sem?=
 =?us-ascii?Q?g/7KNYYSfbGIOj9lcuFRlMiiAFI7U+B6+PeNLIZRQa3hca+n4IhqaF6IAwaz?=
 =?us-ascii?Q?y20zRa6n33TfLKku68EeT0jaGKPobrXb2rdeEamu3HSXZBy0mqCCxOmgQTli?=
 =?us-ascii?Q?k4L6/u2n0VkB54soD7O2YZc9UUZc0i0Vu8If0H5AkXu4lrol4R77IuLbsdv9?=
 =?us-ascii?Q?RA14i2k8MhnKpFtbGeOnHPGx9M82J+s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9d317a-9170-4d2c-1aa5-08da1795808d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:10.2674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VSUe52QoUfxPFzAmx7K2vUss7RV0rLLi97UrTBrZ0HJXBZsPkp+05C0DKg2iQV7c/hvXc1H/+lhJM9TdnFzFeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060027
X-Proofpoint-ORIG-GUID: 7qEiLjdcY5bXvKJoZQXCu0w-a4NGz029
X-Proofpoint-GUID: 7qEiLjdcY5bXvKJoZQXCu0w-a4NGz029
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_iext_max_nextents() returns the maximum number of extents possible for one
of data, cow or attribute fork. This helper will be extended further in a
future commit when maximum extent counts associated with data/attribute forks
are increased.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 9 ++++-----
 fs/xfs/libxfs/xfs_inode_buf.c  | 8 +++-----
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.h | 8 ++++++++
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 00b8e6e1c404..a713bc7242a4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -74,13 +74,12 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	if (whichfork == XFS_DATA_FORK) {
-		maxleafents = MAXEXTNUM;
+	maxleafents = xfs_iext_max_nextents(whichfork);
+	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
-	} else {
-		maxleafents = MAXAEXTNUM;
+	else
 		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
-	}
+
 	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
 	minleafrecs = mp->m_bmap_dmnr[0];
 	minnoderecs = mp->m_bmap_dmnr[1];
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 87781a5d5a45..b1c37a82ddce 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -337,6 +337,7 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -358,12 +359,9 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		if (whichfork == XFS_ATTR_FORK) {
-			if (di_nextents > MAXAEXTNUM)
-				return __this_address;
-		} else if (di_nextents > MAXEXTNUM) {
+		max_extents = xfs_iext_max_nextents(whichfork);
+		if (di_nextents > max_extents)
 			return __this_address;
-		}
 		break;
 	default:
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 9149f4f796fc..e136c29a0ec1 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -744,7 +744,7 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+	max_exts = xfs_iext_max_nextents(whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 3d64a3acb0ed..2605f7ff8fc1 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -133,6 +133,14 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
+static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
+{
+	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
+		return MAXEXTNUM;
+
+	return MAXAEXTNUM;
+}
+
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
 				xfs_extnum_t nextents);
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
-- 
2.30.2

