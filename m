Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25C3C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbiBXNEo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbiBXNEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:04:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93F6230E67
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:04:11 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYJjQ000938;
        Thu, 24 Feb 2022 13:04:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xgpJtorF7E/B8/O/fMRUNfkjIaEOZCENh6qFIlx53yk=;
 b=Z8XSgsewtnMG2hZtIqtgIKwv+fU3cXYoOceow4I7jw1zM6nZPME9e0PBlj8na42KhFmC
 qKtIxviAutvsKkuH0Kv9dmY9ReFjYPeaWvIpB8XO/ylUA4tGvPrFbdnKA6QS4MpNOm3E
 VHQmyuJ5hXmMGUnMzdPvoJVNHNndb3BnXQQwWFXfDEHAp12kNvDYVfh3Z4AY8Nvk/r29
 1BbW1WvnA6fWs1jGPWuaD+VsMmkHQ9CxXhMim2fEnk/+hw6mAs5v7LaBDpD2oem66FRs
 GOzfdreXb3Kh0QI9nDV+6VygKOJW9Rl0B8H1I8MNhhZbbHLTgw++MaVL8vUcZ1axENZa 0A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect7aqaay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD1gqX039576;
        Thu, 24 Feb 2022 13:04:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3030.oracle.com with ESMTP id 3eannxdetd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:04:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMzurKSDvF12VkYcx0heuH0/wp88uKJ1vRozr8w7bBVBqlwruxKcx5VBwuieOLObvFnESXJgK/UIoAeDlVPV+M9ESj0f0Gh1u1J9B6H6VewpdV1KYNyfDB2HpwrV+T0jXdT4dKQz98ST7Wyj6IFtRETQTcy5pABUgYZjD0lNE4YJKP5PGaVZYuRFgRDgH3BTUatC4VGytJcK4KGSpUMaJQerojdohheCAMaBeyMMvUuU6MLsZMNxwgadE+O7Z8FpiW4nKofMY+XeCIidA6VzzPhgR1vufHjyr4HhDZI5Uc7Nd8VOBDVvHrQzp1P74b9FZv1BVM9i5sJoW9cUrLZ1qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgpJtorF7E/B8/O/fMRUNfkjIaEOZCENh6qFIlx53yk=;
 b=igXkHGXfDALxHetdPlYoTyR3EnBPZUNsMNX1TE1Q9VRB6RuXwxiKn6q+w2h8eKc0n0p+U1bXe/s9b9So56GZ2h9P6v2neYIGvl53hvcYZRe2o0YwRFYQCLWkRgOzxxWkpIkEKjPkh95EUW9gS8wlp7KyaCggV+KO6Wv0xKxYYsqccIUHtYZ0BWRgpvozuQj+FrEidjDfUjMIOutVOzyIe02RhK7JFglAZO1qNj8l8Cn2gwhRwq3Y+zXTWnQSChSQZt90kTQvCbYWNCbB2G4Qrcu2e8MF697xrA7ETKxDAEjm74Q/kvCt5kHh1e3t2Z2vjinrhQ/QCSFSV/n2nTTcMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgpJtorF7E/B8/O/fMRUNfkjIaEOZCENh6qFIlx53yk=;
 b=i10teHhh5P46YntgpyJG0+/naNfeB+tM1CVyjcM/EYDkwmfQcRDVmUTGVu9VoMsnlF9o9eDCyr8JebUnG/YPiupfmWIj+3XRLaXjyPCEnL+pMUMcC7L/no67JHEpPoG34Gk5UFZI9YUxl8MI9ubLYgPXA3NCLHrpd73r9Kvu6UY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4634.namprd10.prod.outlook.com (2603:10b6:806:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 13:04:03 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:04:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 03/19] xfsprogs: Introduce xfs_iext_max_nextents() helper
Date:   Thu, 24 Feb 2022 18:33:24 +0530
Message-Id: <20220224130340.1349556-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130340.1349556-1-chandan.babu@oracle.com>
References: <20220224130340.1349556-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19418e2b-7b62-4faf-b241-08d9f79621ae
X-MS-TrafficTypeDiagnostic: SA2PR10MB4634:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB46342D136C30B06675A42040F63D9@SA2PR10MB4634.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2amPEl1153d4JU1/HVq8coQiSDXBxDGYI4mpwCtuzTGaFiMTDREHgNJ0+Bex2nG3ogcXxtqp8ScK0TDGKkDW4G6IF3VJWAQI85as8F1iLLeraRUOMVUAmNVdYUteZwJJHqtveCQq+vtV1HPwKCUBevg+UG56aFKBJtC9W0ZlCICLuoz+2NOOayQGQPLE7f9xfIyBxVO/dbsDnjWX5sf5Poq8W51XfDk/rgLsBzWa1RAy9RtLSmukRYVVlxuOdEn8kgc6rtZ9mnzWnHRXFNe1k7Mia/7IqOJraA56BYdc5x9VCROHMmJvwSalWLg9kPO4vVV7l4+SzYNpV6UcgkO/qU8++jIH5EIpgPk1L6lKebBuY69MKM8qKDJi14DcZ51z4Rxn2r0Iw7J7MZpr9kLjOKpZLmkU2lxATpvZBgKOwdeXI6DYO+XzbL/YzNw1kPqzW2HHyIPKKG1ShQkGueD2abbTdltv0khvMV9gQfSaapeP8xybwfwzvoJ0qw0O3WxgxfhunWeWagCCD6Wm+IohcFEfNRuDfb64/GSXKjSOrXIXZcjgRaMtPJ17eS13NgRwCdyxUwPO1BInSONs/9cUXPZamAZk8Xo1MwEZNY3IlBnE8p7Ss7ts1r1QjfCI2gKKiA4jbgg6u+JYNG7Gxd80KwM+XS09iitaVrsMQjyLC/oZXSOxxck8sPSwRyIyhQeKE6NJePMvIcW1UK08Vn+ftg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(66556008)(6666004)(38100700002)(38350700002)(508600001)(6486002)(66946007)(8676002)(4326008)(86362001)(66476007)(6916009)(1076003)(316002)(8936002)(36756003)(5660300002)(83380400001)(2616005)(186003)(26005)(6506007)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eDC3yLRKo2nh8OUOEVzsq5I+npTCYw5Z0KPUJURM79za7METKAUdSpaOoEBv?=
 =?us-ascii?Q?AXIvlPf9pz7XL+uFRBVXpdqGhMvev0TqsTl1gVRY57DU53vhZJKZ32mrWNvS?=
 =?us-ascii?Q?g7LmCmE1rHZlwtdG/pOUTCZGiK3ROxVSz0kjrr9ChQ7svLUcZdqsbJOXFedR?=
 =?us-ascii?Q?LpmRccG56yJnWLRRmotJEJHPwEpXNmpaXsCxjFRCQnRdpE/4hug23GVHB4fX?=
 =?us-ascii?Q?FNS+KpoVm0q/G45lvin2AQxvPZdZf4B7WQs9JcyWepkzQDfQw73OdziVOkhp?=
 =?us-ascii?Q?q7qhLn+6d45dTjyfXVq/l86w9jXCQ3dD7FSwWjb2FjCCZ6VR8/emI4la7er+?=
 =?us-ascii?Q?G1JdONeuSsEDyBSb2di9mZniaOpp2vrTfbQ/KN46m6Sgrvb+JBnJpgzOB7IR?=
 =?us-ascii?Q?I3bIVxrmlmlDvur+2W0ZGTXyWnCn1iAW6z0mkHMxW86ScZWnYEMz9wwxQ0Ub?=
 =?us-ascii?Q?TbVt4+FtUq5f2wZZmfLlkqJnIKqsaLIQtiej49ATOp/7VXnkaBORQ86nn27d?=
 =?us-ascii?Q?eWqr210QRkGRbiIqcQFn5WzNksETAFmbgaWMj6yew73JijWRE0EoZhjlLTsx?=
 =?us-ascii?Q?M4K/iwKvqaDhxg/m51GTNC69cQmJO0MWrxnPNBu0pHLnxlCUkXHfRxW4j9oG?=
 =?us-ascii?Q?vSnsj8et7ySpwrlxTa7tQEqr5TBI7GqBIi+yVJ3gGOzAE8dVGmg+iw0Up4Lo?=
 =?us-ascii?Q?39QfsJ+q7Nyce/JTgKEstVQ/M5O+4qU6UDrhZkcJHF5xPiJvae+ncEz8we8Q?=
 =?us-ascii?Q?c4If81Tjx8Xrp5R5z42ybJyrJlbNlokB5ilUHUCu1rr35LSLsImp1aprXFFa?=
 =?us-ascii?Q?5VX4NEzJm6kQFSUDv4m/kmvO7x7ttiem2lsgctJBDgSw0F47dNQ4LemYDwuv?=
 =?us-ascii?Q?5Ho3r0ALA6fa4erkrtk8rgkxpRH0qM3rWm3+hj0C4FtfKFDrJ2Oi92GT97OD?=
 =?us-ascii?Q?vUUCcWbtcohi9JlKM/AifJOP29xYyAgEi4Ibb+yh065cmps1V0bklqb4KQPR?=
 =?us-ascii?Q?DILV9cuBYjyM7Trtp2Qbuz0bd/LhlkMVaR8MA7ZMdqqU17SMCsolvRRtxUxO?=
 =?us-ascii?Q?72aanM1OyA58cnBgVvakmQuELbZUnlZMvQeci4fg43MsILEEnMaas5gm2Gss?=
 =?us-ascii?Q?lJ/t3QAwjph3rXsgxDysC3XGIXsAjQ+CHBFlcZIktdfSgvkRQdFyg3VlGS8G?=
 =?us-ascii?Q?36U9YNXIhLbZ0UdVC6r4fou8EZU7ZljhT/WfX4+J+TPqyeoYYuP9rnwWy8gm?=
 =?us-ascii?Q?+PaCkq6VI1oSHGmPsm+xCqUh5pvIqu08FLDz4tXfp/Q+B4HIkn7MOkp73KnV?=
 =?us-ascii?Q?mT99LE0v14ofe95LKKaYtCNqwBFulG1720tdirm4ZOlWjBeeTd1DX42a4Zvn?=
 =?us-ascii?Q?ByS2ox2ngB9jxAQmnxOghbzf97K+xm6UY3bR9jc2YChT1CNNNbtaVPLtqY1j?=
 =?us-ascii?Q?JvOYqYh/7VZqHfeszXwe/67VHx04l5NV6vTKlO9myi7O8z4qbhronN+lkI6A?=
 =?us-ascii?Q?QKnuVLvCUZKCurAun7w1FbvngGS8UitQgDxdgm3l/rMi3sLNHgNv560hiYxc?=
 =?us-ascii?Q?dwaRvBpDN+creaLzKK9cnpunp4yhN0+PM45m+GKMIPZBFEm+NN/SlFkYMG77?=
 =?us-ascii?Q?tH3kvOYVHUBa7XYRmC6YcM8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19418e2b-7b62-4faf-b241-08d9f79621ae
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:04:03.4399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wlbxs1nAA+EWkHQG43Z7g59CSmlf9vsaG6V7xFPVE9M3Nw4IAhQzueNINdI8lHAxzqaM1kRR9nqrsn/AuT4VpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4634
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: x8r2V6C2EQv6RnwR5X68TeA2XRfgof1t
X-Proofpoint-ORIG-GUID: x8r2V6C2EQv6RnwR5X68TeA2XRfgof1t
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_iext_max_nextents() returns the maximum number of extents possible for one
of data, cow or attribute fork. This helper will be extended further in a
future commit when maximum extent counts associated with data/attribute forks
are increased.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_bmap.c       | 9 ++++-----
 libxfs/xfs_inode_buf.c  | 8 +++-----
 libxfs/xfs_inode_fork.c | 2 +-
 libxfs/xfs_inode_fork.h | 8 ++++++++
 repair/dinode.c         | 4 ++--
 5 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 8906265a..d6c672d2 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -67,13 +67,12 @@ xfs_bmap_compute_maxlevels(
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
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index e22e49a4..855f1b3d 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -334,6 +334,7 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
 	case XFS_DINODE_FMT_LOCAL:
@@ -355,12 +356,9 @@ xfs_dinode_verify_fork(
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
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index d6ac13ee..625d8173 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -742,7 +742,7 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+	max_exts = xfs_iext_max_nextents(whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 3d64a3ac..2605f7ff 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
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
diff --git a/repair/dinode.c b/repair/dinode.c
index 909fea8e..1c5e71ec 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1796,7 +1796,7 @@ _("bad nblocks %llu for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (nextents > MAXEXTNUM)  {
+	if (nextents > xfs_iext_max_nextents(XFS_DATA_FORK)) {
 		do_warn(
 _("too many data fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			nextents, lino);
@@ -1819,7 +1819,7 @@ _("bad nextents %d for inode %" PRIu64 ", would reset to %" PRIu64 "\n"),
 		}
 	}
 
-	if (anextents > MAXAEXTNUM)  {
+	if (anextents > xfs_iext_max_nextents(XFS_ATTR_FORK))  {
 		do_warn(
 _("too many attr fork extents (%" PRIu64 ") in inode %" PRIu64 "\n"),
 			anextents, lino);
-- 
2.30.2

