Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C37C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344229AbiCUFTv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343929AbiCUFTu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:19:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D53333E3C
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KLLRAh006156;
        Mon, 21 Mar 2022 05:18:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=fBZUMunqmwJnwFs0rcIfU+gr1slsG608CbnR6gLmH3E=;
 b=ZBfyxGrDKa12o8QPUtrBdrZJ7EWhpGbN4FUBWF2MicxX4aTSyAJ6rJsvVFokiWISZ4l5
 HtcW8HungyHkbn1xnSfoIbs1z0E42KpL7ey+d1Pj1dmbOHSA5ImeEKVsrhF2+PZVnGLA
 sci0l7sx0slNZsq//swNW+U3vhQJI4jYJgjd45RzMzzqTwRnurdlP9UTaDyQzUKgkWKu
 3Xv1Cz1cN7vi8MMwUWQ3LB8gt64bBqodRMoqmYGj7mHeyGpcis07LF/6xKyEW7HNftAu
 HdFbY6MZW6Ni+TLjmHOgYCKRyfw4kqyhIGjiuq7gH/4qvXZh0l/RgXSN+u5PeEFS/oEc Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y1t4qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5Fwim057906;
        Mon, 21 Mar 2022 05:18:19 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by userp3020.oracle.com with ESMTP id 3exawgeuyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJ32eeUtueUAX6KHP+ODLR83nvetlY0bkqNllxQH8XW7IglDAacywcPrp+b+jff/qTj0C0UlXBQLhrCDTNccwxqubHdRmA0aoxbmcn2JYx+E9KpEmeIK9RNOzrP7fnYPHjtQ+5shYnGiF7N4yEUW7tUpxuucUhmgkuuAgpHw2WsrluV7I2GfTbJImqV0eGj8NUaZIq1g5HUdkfq7ifin3dzcsJx4DBkmZylSyRuhjHuIGy3AruLq6uHsCcOLuiQZtOkPmfHpfvIsVcvF8Ohg1g638FEddwSvnSBn2oTsIXLQGb3rhTSe6F+KWYLvquYygy51lmV91uFBP3z+h2hUIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBZUMunqmwJnwFs0rcIfU+gr1slsG608CbnR6gLmH3E=;
 b=NWxH4frEDUKTG/ZOdOpq/EvW1fiFTsGl9aVPv7ynXyv8bgXQPab/OmZg/kWsX5oq6aO7ZQPTSPcLLBAdRybdE9mUkd0fQQATlMABWOPd3wuGR8Vd4iTVickBw3I34KgbaF27bVIaXwhycVslYjS1+caJN5fldJqoQpKMBsOuNJG5K5gNDuvM3AvQevV0ZVxp4oWS7skOLjQDFsuAaL0CEQY5jHDAO25Ns92/iWZIkvjeHx/vmcNk6kFE6Dj0Wt1xy+WyaHOU9DtSy5no7aZVXJ2psMo9YzC/CqmPUDcJoQ9bbBbTX0wPSCvmLFHXUD2LokM9PhcuUpfM6L47rN37hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBZUMunqmwJnwFs0rcIfU+gr1slsG608CbnR6gLmH3E=;
 b=rbKcSBItbsBBJXza0dkk6l74OFnGiX9Xxe9eokhMKS0ijeu3W07fzj5B8GD2GVExB2x9EQPD9/Kzpks5JcNkOpvWYI/RnXnY5j2Ts/EyKhX5WSbfxE5mR3RcRyj3LTGAlxqfMmQqFe1IdkPcvXj+qwokOmhfGZz7uPG+QSUkN1s=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2105.namprd10.prod.outlook.com (2603:10b6:4:2b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Mon, 21 Mar
 2022 05:18:17 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V8 03/19] xfs: Introduce xfs_iext_max_nextents() helper
Date:   Mon, 21 Mar 2022 10:47:34 +0530
Message-Id: <20220321051750.400056-4-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 0cf7d4fb-9c9b-4c5f-1ffc-08da0afa352a
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2105:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2105DE1289BF658CBAEAAC82F6169@DM5PR1001MB2105.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jDkmd5fNdNxz5g3n2kXAnyQN6VFK9wyHruyto7LAa0qoPRnsPBPYNXRZzh4jh8iUg9j0lY1cRJ+TfeBt+bvxyNGHjSr7BwzAC2SE/ECMhSN3WePWjkAJwjwm6//Wawyc/6H2s4Ovt6VkW6a4RGTygsjP7aT2tVVhOueAC2WcjeRaMh+q/q8sfz57ZnYbPFsgYl+pZYrBsafe0V3KFxKvcY04JHDQFKcpoBqAjZsY7mYs9PvaRXttjao7EJz470Ix4zXH+k6JrRlpOjIusUPTmKB1N/+ceojmbEDgtuUzJnamEUDEU3eje5Jx7nLNKPpzO9NeHPCQmRr95IKuFcbO6iAF9edeC/EUI6VeBYfpOSwzKybIyn+8ppixWxn+HRhBQUTiRWYQXdSQT794WFBLppoqO+ndzdhEUd/2ZTEbOfMNhB1EFxQEev3NzkYVZS7P37pmWsDHpc6tK0zMB4ohNi8Se0JFwxL72TC0RipGILSoVb/EgeFJhgYqkNpjb0SgmIbmSdUlP2mvD8afQoEJ6YsTwtRh2xXjVLPUx+T1wfNSCxvflHQRNRPhx3eOasBYLYXXAcIcT6S7557d8w3f/UXICVQVu8/1BpO+gbauLDN7IuX3gqNb+NbxsF+eW3oSGuIjdDyy4La/lNhZ6Y7Y+YE12ZW+pd5gcI+iBcoPI0BhknZQMheetkhoTZoM8RcHCDbUKFRpDaMm8Mstt8x58g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(66556008)(8676002)(66946007)(4326008)(66476007)(5660300002)(86362001)(8936002)(508600001)(6666004)(186003)(1076003)(26005)(83380400001)(52116002)(2906002)(6506007)(6512007)(2616005)(38350700002)(38100700002)(54906003)(316002)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ShMNMGz5i7bAaUV5vhIRfYkGuh3pSvittMm6Sh3lHr1bwNYM0LAXdOXyz3Xy?=
 =?us-ascii?Q?O/s9AOImObMiFaKD95UKdDG+utG3K9HlRd18YaB1DB++knxZCyRE0dEZehiS?=
 =?us-ascii?Q?V5iiRKpRX1YBm2pwCVmXm1XQ0KetwG1JdI5ZBSvYsPc93MYOknhT+rqXKrR1?=
 =?us-ascii?Q?eYbaQETA6DEj3mGUqCi4MKD7470Pu6aBBBQq3hj6Z2VD6R4iw623wEnpNGHu?=
 =?us-ascii?Q?N8imgdNk5beT/ppBBLYtBMMdf2QQUEk36ilhUw5jLBMSGV3A/9d/tNKJA+Ow?=
 =?us-ascii?Q?VkaVa+2PnOQObvsT1Nt90yU8bbtAFShfxPCe5XFb0sCUTizkjvlTSHLjnt0C?=
 =?us-ascii?Q?0TXR3Vj6vL72BMvTcVbIN18JeyQPxtqiiBi1J223rplskBHyEC94+pt/RZfO?=
 =?us-ascii?Q?dDFxKAh1XVggZiQkVubosscMz86Ok0vYUM2zojiu07HQs8uRiHr37aqestZi?=
 =?us-ascii?Q?FB1YYCxnqUXmya6hZgEcPy7WIkvjTRdF5O+oCOZhF5L1WIPJVtbiOA8ju9Wl?=
 =?us-ascii?Q?BPIMRUJoye/ObzMpwrmTouAS6yilNoYGMK+7Hxuwmq3+AOxQlhWihEKj8UmE?=
 =?us-ascii?Q?leYACjtlu7dAqKnXPze2uYF/HywMssEC/0nw8YzYZYtctN44AmBBudfxJ6RP?=
 =?us-ascii?Q?rmEDkBGiOBxBpzX81pf3TZAUDEo/pvXUOzJRLBNDDQaUqxOjAM2eh7eoemP6?=
 =?us-ascii?Q?vsr0p10p2JgUo5E6koIbpLc3SdnNFW+cubEp7NvclMkj5BqxEbkvOdF1BMGV?=
 =?us-ascii?Q?m6MkU+0zMlCllngWg4aElwn9yIya0cuHJadl7uvIizpfB+PJuromm0qGfklZ?=
 =?us-ascii?Q?lAXnkj4iFHhi5D9iw0py3HNTn+NgWBAvFGrms292FAG4SoUxYpO03CFW2kqP?=
 =?us-ascii?Q?VjRHDz5F6baHp2vzDL/+kaL9N7ARKUAOpWP+hEnMlqQxUjfFcz5dWQzfHlLi?=
 =?us-ascii?Q?lYQALlYqFhDiPxXdkEDq+SgOeL1uqu1aX59V5hVKwccntWnrjJnO7wqWxqUU?=
 =?us-ascii?Q?jIEQlWnvKYaXS5zi0QN/P+lDiaOgXmmbF+5akT4eDgcog/PZnjlDUfnfpCx/?=
 =?us-ascii?Q?/WxlmKkVxw0EJoFuIQBQoxx+IcfYIMWOQLkDz1gc5wnf/mQV+FhqBFjTfPn1?=
 =?us-ascii?Q?3u4oBjNh5pfDW9J2/OcDV5j7gcSeExvUoj3/Fc+npE2Tib6aXoEj4PmCD8Wn?=
 =?us-ascii?Q?+gnUKeytb0rS7VPL1EsL97SMnEIko5uIVqXLbR9lnBVCbVjwwfVvn7C3kufv?=
 =?us-ascii?Q?M6nifyiI1PS2Kio73ydlNuhYCJ6aP44CQDNUpYUKOe/Qs0UnfinMegbX6nCN?=
 =?us-ascii?Q?XqqvsoTjQ9WyNH1AIMXb6A6xK4AhwpOS4+Mwytk4csO4LZTlbELVOL8o5Cjx?=
 =?us-ascii?Q?GbUZSg4sCnZ9ilb/bzOD+fAHj0ruSV5UCdpgTV0QX4IFwgs4aJrk4ZKSNCIi?=
 =?us-ascii?Q?HmICBWn6c8FKB/QekWDak7kOxlFY+QxWI6n/yfYraRj6XSC2mcsSjg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf7d4fb-9c9b-4c5f-1ffc-08da0afa352a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:17.7038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjVcc9+NIbquYZplpI+eb8vRdYEI7EHPwyvCUPj5DKus5vy5dnHpPAevKiStv/Gj6gk0iMqzThDPzowqrdVLiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2105
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210033
X-Proofpoint-GUID: Ak8Ui2b4kVvXB6_w-eobRJvcAPju9d4y
X-Proofpoint-ORIG-GUID: Ak8Ui2b4kVvXB6_w-eobRJvcAPju9d4y
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

