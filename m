Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDE3ECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiILNaB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiILN37 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:29:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E0113CD5
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:29:57 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEYNr002662;
        Mon, 12 Sep 2022 13:29:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=713lQ5+G+BoRCxM/1KuvGy2ffMe9oRB72v9O2SufnI8=;
 b=V9C2McwPLForImMqVkB1Boh8zpw1fq5ct/jGpqznL3Gf6MuDcF9vdhLYVq01SlEc1pCE
 ZIjBsx+pVgA5LMls8iYEMDYAlQ1oXN927693itTVGFNTQ2inJOXAPEpQYCjSUP6TcnNW
 nbqb4hETkkl+88z5i4sndOUflsu4D+iLABo7aNZfg8ophTZzfwEM6Pvrk9EUddyFs9yS
 Y9fj1qNpPm0ddRLTwbKKn1odPQCqEGlSI9HXpWhTDZ/BviMXvxq/J4Eu9mLVwnKQYIrW
 7H7NqccIWwYT3h1t2qq2drlEQPNFwvQUCCyKy6FtohpgiE1DycdZccArlgqZncu+EeRY Cg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgh0c3g52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEgR8025144;
        Mon, 12 Sep 2022 13:29:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh12a88b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLCc0J/SqnoyqSWY5Cay7zZn1EU3XRJjVgPIXwNPOw5zKhdeWIBp4iian3swirWteakr+kc/TeNVqSgPbV8O9aq8kpImaaTWyOXKfFLNfZCmzYsPmFIG7gnCrCkXwdAK/N4WjV2e7B76uyRuMG7dG6dI2CUFOKqTln9xS8W9iYnFsoy0NR0ZTL8gkGUKkVhRKQfaywoTlaW5BapMRuDst+3fJ56+6DEVKM7WB6ptjuWgKECHT+8cL1yFVastpIMKD13A8HSxOtNktRyE8iwMyJc9rQxSC61lld0AO4dPeyje8k7ltpNx7riFdH/sImTxmeTIR2b9V4NFuR3+PQ9pfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=713lQ5+G+BoRCxM/1KuvGy2ffMe9oRB72v9O2SufnI8=;
 b=cN0BZCARPEA2rnIWoyUcuTZszZvEnKkej4qqx4yM4IsBpAhDVxJtEsABdknL+ZSW5CU9tt/DNDikqMOHxiUhxYskWiRZWKGEVuoMTRvsDRZBSq8DXX+UwYhBwF6QmAPqn3s6nZpyGkoGGsTB3bnOjqvQqqwnYDlgi2HeBN+iggmfMLKkctceFP74GSgNgHbwnXGqrA9IvrokcH5iRaLJ6PAM3LRFCyUY1TngpJK8kkXPZVlei35vxRy1VOB+/ubcSL+K6vyHDUigV8ManUa9sYItK+hYCcy0WTfoWOBRY57qrb0E9c94Qhix3kYL8mjmqfCwpes/avvDMAO71lmIlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=713lQ5+G+BoRCxM/1KuvGy2ffMe9oRB72v9O2SufnI8=;
 b=KDoup6VLRO1CC58LzBECHlgx3D0lPIdQSN9YKvNxo8IZ0oPWbQv9aUpLH6so9Qq+kSsMKCmqG4sQ4ehmtC4hfojQOoFgQH6GPju/lInayMY/XoHJVLZ5qPbVv1TFSVjgpkUW+5UCI+e3ESNPf0lNm9UG/fxtNwsHJWGd+wdORBk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4318.namprd10.prod.outlook.com (2603:10b6:208:1d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:29:50 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:29:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 17/18] xfs: split the sunit parameter update into two parts
Date:   Mon, 12 Sep 2022 18:57:41 +0530
Message-Id: <20220912132742.1793276-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0061.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::25) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4318:EE_
X-MS-Office365-Filtering-Correlation-Id: 56a3da41-b61b-4d5a-1f80-08da94c2de71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dAMM1mJYjfsudOVzI7gN8Cvt7Bk4pDcnAu1smBwxVtYKcpWtZQgRZEN1cMEXhNWLp+lwMzza6cbf67kJYgRWh3YyPQEyz1SBIeYdvX4sINzbyEYCazqQr2NKu5wiqxUt8+iXHOYk4GL7shLiGcZwt+X8I+9NDox2BVataE8IF+W3gUSera838OGOJ2WLYfVW6sodjuEV/YlpfsvGcC7uPmQEu1PLTD/EMv/ZrEWbitZHLivt1SIlrxal8XJSU2B8MRbthvNl53eoU1PJ0t1XFi8JsZQwJCZ5pKj5hoZzBPqLy4F5PtwrG1qYZk76+Qh46VtQuS8nMCR7GfkPf/KrZARA9bavc3PiirsZRKQXdU7RZJdP3B+hEJMzGknHCPSHGOLqWQZM9dXeRDDjpZlfETCFSaF7VTcZ3TggFqJVi2NdfWuJWuGIlWIYKXIYDSJfJow8hgL887tByQyzHvOEfXRJVGe7Vs91pdAxy6YdvAwQTGqTXFALiZOEVf2FkrrPvvTqTGPpVaZ6jd1gq0CBzYPAiN5q+vFfNcw50AN6rFIRNq7dpPUMft+lIzRg0v/ZxHWL19oy91Pz83OpRLqaxysYpGz8cIU2QmK/jwhViZlTJC6pCdiZcjOv3YdWV8mYiWM2CU9OyLlQFPkl5/g+S0p/1mIPb7c9dN9B8HTN8Qpqc/Sv+qNozgjTncdUOfy6OhJPIhoQGp4qrg0xy/CtdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(396003)(39860400002)(366004)(1076003)(6506007)(26005)(478600001)(6486002)(6512007)(6666004)(186003)(83380400001)(2906002)(2616005)(15650500001)(8936002)(5660300002)(6916009)(316002)(41300700001)(36756003)(66556008)(66946007)(66476007)(38100700002)(8676002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3wQui8Pv0vSVOazknfKc3Y7BMFq5PRbv8/qz5D4KejhFWJOccyLNSnhJU9/x?=
 =?us-ascii?Q?QLhp+0fvKnvXmb7DsBimTQ28i13nxBQmveTFirXTc3hMqwP0r4IfQF+Kgem+?=
 =?us-ascii?Q?cZWo5vkFPNamWjW1vev69/R5DroZeUd7tVgEieOA38rykgfWWaWjnRF/0IbM?=
 =?us-ascii?Q?Wsdg5r+90wrmePfxEMrymWjrqqkAhHAbp3UEwckMeOFMYNcTHUY0Uu3xmDPo?=
 =?us-ascii?Q?M06TVfP6+W6dygoM95Oh60FyFzsTGj+9GWSGAw8u6NXrF1QshDfXLpjbNz7E?=
 =?us-ascii?Q?f9D7qx+EfpMYG+5wRnBK31pOmuphG1Mc1SDKpNk6ma8TC6W0+v5AhjQdXw8R?=
 =?us-ascii?Q?MK/lgPur+Otf5tckt/Ywc+jtuCNHLSeHeFLHuFQCUzwAYw+hVQq0P2F9fCu6?=
 =?us-ascii?Q?tjiJQHCVxOl9JfYaLCj6f7jlbgzmioqfX5MPhwPVY+F6nybK4UE9Xk1mBruJ?=
 =?us-ascii?Q?mnYdqxc3eNJFwc6gBK6h+rq/eVi+CYt5MNpYkfto1f1luqEdqe5mUEEg2zO0?=
 =?us-ascii?Q?k5P4fPVB3cbgvQ2/pcYxkMw9R/JyM8g2br92Op/qIxG8nUKcSkxGM/HYEg8w?=
 =?us-ascii?Q?Ml2/eGGd2NlyWDFvrcTfDdFP4SwkUDTI8eMBFcPc3tOAdbe5JnsHPt1bhGgP?=
 =?us-ascii?Q?EFXboQEEqwgKRBtcpozA4OR39pL+NbjkVW5bbm5p8xMMb9VVKSSpyt5JgE/U?=
 =?us-ascii?Q?B97haEbLcj9CJS3KQjrXx3GrWN/gHPlCq9lgKa9NBc3PWndfIzWardH/rjue?=
 =?us-ascii?Q?/B/djEWkV6c1r3Es1FGun10SJ/raezzyGvl2T7WNkIatKvoKmKyTVgpfMD/i?=
 =?us-ascii?Q?QhCm/r5XQUNXlcWm7qWyXbtf9+Y9aMj7AiaeyMnBIO40D4TeKb2GKH9w2P89?=
 =?us-ascii?Q?11WmZjPyR9ygER/lFdqRN1uVds427DirFq5yXUIqXJgQVM3ods1xmUmOfsvd?=
 =?us-ascii?Q?XtcFccjisVr0Am24vTa7HJwiMRkWvRMbKB7Iult3S23iVEpz/GYCCj52dSz+?=
 =?us-ascii?Q?KiSqH8/cqxFCw482LUwCzu2tlRUP1Ufi6+cWwYxvVS0vh+0tIDzrRVHTuvs2?=
 =?us-ascii?Q?NAl1BOD6mzYsZACPz/kXfvqf0NbKFrb8vm14RZx2daywUXZMPVuLpapSqwxV?=
 =?us-ascii?Q?VLqTZ3SIrKmSdOHe7YmB5OEaNJLGRlUURBc5pvDx4pa1pFNnK8sWoeBZ5cBW?=
 =?us-ascii?Q?ZiwePUo5lrRcdrD1qDOSlneqwEEvoMjDxl9+/uYq9GxzJo8x83pluk2kIXLx?=
 =?us-ascii?Q?cSx4yc+LIs2irrHRXCQmhGdUxpFqV5bE8qceL2c0LYmCZabLj6IQUNSAsBKu?=
 =?us-ascii?Q?kqvAfwwJTyzYnvNhUvdughUG7qO+Y3iTPlRlciQ8XGO/4eL6QZ7xeVu4Dndu?=
 =?us-ascii?Q?89ODXcJa1QCM/RBuU0HRCqhscHRgJUu9cNEnA2aqrZeMAQOkete2PCUoIPFk?=
 =?us-ascii?Q?4UfUONMiIZ7fZ5gsi14eGyTam869ogZII1IYzYZlvmoa1NBg+DLTo/loJqkV?=
 =?us-ascii?Q?cJ35CbgGDlNNY0aM6Hu6pItexhlAtUDbelxgE4yUUdlrlg6a/pLwkIdNDoPa?=
 =?us-ascii?Q?C/TxZrj7IwWmSIQ/nj2ggrfvalVkglbarb+qZLTzS6BjELk5/DNP0AKbVXMn?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a3da41-b61b-4d5a-1f80-08da94c2de71
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:29:50.3961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /xFtp8Ta1RUbww4SB6ZNvIjFwp8hMKASmGWCoWnuC5t6o+OztUKPq2RtKh1aUkCVhgtOKRfxisAmP5sKGCUFOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_08,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-GUID: HqCTlhUh0M1nu8-_LYkE8l3wHJ95nrSb
X-Proofpoint-ORIG-GUID: HqCTlhUh0M1nu8-_LYkE8l3wHJ95nrSb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 4f5b1b3a8fa07dc8ecedfaf539b3deed8931a73e upstream.

If the administrator provided a sunit= mount option, we need to validate
the raw parameter, convert the mount option units (512b blocks) into the
internal unit (fs blocks), and then validate that the (now cooked)
parameter doesn't screw anything up on disk.  The incore inode geometry
computation can depend on the new sunit option, but a subsequent patch
will make validating the cooked value depends on the computed inode
geometry, so break the sunit update into two steps.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_mount.c | 123 ++++++++++++++++++++++++++-------------------
 1 file changed, 72 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5a0ce0c2c4bb..5c2539e13a0b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -365,66 +365,76 @@ xfs_readsb(
 }
 
 /*
- * Update alignment values based on mount options and sb values
+ * If we were provided with new sunit/swidth values as mount options, make sure
+ * that they pass basic alignment and superblock feature checks, and convert
+ * them into the same units (FSB) that everything else expects.  This step
+ * /must/ be done before computing the inode geometry.
  */
 STATIC int
-xfs_update_alignment(xfs_mount_t *mp)
+xfs_validate_new_dalign(
+	struct xfs_mount	*mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
+	if (mp->m_dalign == 0)
+		return 0;
 
-	if (mp->m_dalign) {
+	/*
+	 * If stripe unit and stripe width are not multiples
+	 * of the fs blocksize turn off alignment.
+	 */
+	if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
+	    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
+		xfs_warn(mp,
+	"alignment check failed: sunit/swidth vs. blocksize(%d)",
+			mp->m_sb.sb_blocksize);
+		return -EINVAL;
+	} else {
 		/*
-		 * If stripe unit and stripe width are not multiples
-		 * of the fs blocksize turn off alignment.
+		 * Convert the stripe unit and width to FSBs.
 		 */
-		if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
-		    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
+		mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
+		if (mp->m_dalign && (mp->m_sb.sb_agblocks % mp->m_dalign)) {
 			xfs_warn(mp,
-		"alignment check failed: sunit/swidth vs. blocksize(%d)",
-				sbp->sb_blocksize);
+		"alignment check failed: sunit/swidth vs. agsize(%d)",
+				 mp->m_sb.sb_agblocks);
 			return -EINVAL;
-		} else {
-			/*
-			 * Convert the stripe unit and width to FSBs.
-			 */
-			mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
-			if (mp->m_dalign && (sbp->sb_agblocks % mp->m_dalign)) {
-				xfs_warn(mp,
-			"alignment check failed: sunit/swidth vs. agsize(%d)",
-					 sbp->sb_agblocks);
-				return -EINVAL;
-			} else if (mp->m_dalign) {
-				mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
-			} else {
-				xfs_warn(mp,
-			"alignment check failed: sunit(%d) less than bsize(%d)",
-					 mp->m_dalign, sbp->sb_blocksize);
-				return -EINVAL;
-			}
-		}
-
-		/*
-		 * Update superblock with new values
-		 * and log changes
-		 */
-		if (xfs_sb_version_hasdalign(sbp)) {
-			if (sbp->sb_unit != mp->m_dalign) {
-				sbp->sb_unit = mp->m_dalign;
-				mp->m_update_sb = true;
-			}
-			if (sbp->sb_width != mp->m_swidth) {
-				sbp->sb_width = mp->m_swidth;
-				mp->m_update_sb = true;
-			}
+		} else if (mp->m_dalign) {
+			mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
 		} else {
 			xfs_warn(mp,
-	"cannot change alignment: superblock does not support data alignment");
+		"alignment check failed: sunit(%d) less than bsize(%d)",
+				 mp->m_dalign, mp->m_sb.sb_blocksize);
 			return -EINVAL;
 		}
+	}
+
+	if (!xfs_sb_version_hasdalign(&mp->m_sb)) {
+		xfs_warn(mp,
+"cannot change alignment: superblock does not support data alignment");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Update alignment values based on mount options and sb values. */
+STATIC int
+xfs_update_alignment(
+	struct xfs_mount	*mp)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+
+	if (mp->m_dalign) {
+		if (sbp->sb_unit == mp->m_dalign &&
+		    sbp->sb_width == mp->m_swidth)
+			return 0;
+
+		sbp->sb_unit = mp->m_dalign;
+		sbp->sb_width = mp->m_swidth;
+		mp->m_update_sb = true;
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
 		    xfs_sb_version_hasdalign(&mp->m_sb)) {
-			mp->m_dalign = sbp->sb_unit;
-			mp->m_swidth = sbp->sb_width;
+		mp->m_dalign = sbp->sb_unit;
+		mp->m_swidth = sbp->sb_width;
 	}
 
 	return 0;
@@ -692,12 +702,12 @@ xfs_mountfs(
 	}
 
 	/*
-	 * Check if sb_agblocks is aligned at stripe boundary
-	 * If sb_agblocks is NOT aligned turn off m_dalign since
-	 * allocator alignment is within an ag, therefore ag has
-	 * to be aligned at stripe boundary.
+	 * If we were given new sunit/swidth options, do some basic validation
+	 * checks and convert the incore dalign and swidth values to the
+	 * same units (FSB) that everything else uses.  This /must/ happen
+	 * before computing the inode geometry.
 	 */
-	error = xfs_update_alignment(mp);
+	error = xfs_validate_new_dalign(mp);
 	if (error)
 		goto out;
 
@@ -708,6 +718,17 @@ xfs_mountfs(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
+	/*
+	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
+	 * is NOT aligned turn off m_dalign since allocator alignment is within
+	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
+	 * we must compute the free space and rmap btree geometry before doing
+	 * this.
+	 */
+	error = xfs_update_alignment(mp);
+	if (error)
+		goto out;
+
 	/* enable fail_at_unmount as default */
 	mp->m_fail_unmount = true;
 
-- 
2.35.1

