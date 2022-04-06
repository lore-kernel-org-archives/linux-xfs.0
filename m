Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373ADC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243081AbiDFJks (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585892AbiDFJgt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152B32963CB
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:36 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235NpcNq006381;
        Wed, 6 Apr 2022 06:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=PlDRDpV4Ca0ybP85a8jLFUO6INlovw4duX+aQN3HEUg=;
 b=teWYEG8480lkgbyI9lJuu6Cvo/2+lH/pLKp/5zg2zCIRsSl9ZuQMolOj7H2DkoQepLZJ
 haAzOdmwH0PzIK4JdMCTj97m3sigA/CSJ/VqAev68r45IQDgmj4+tFR9yrRI5B6LYqlj
 j/kGqdJBuuAVr8DWUb2ju+EzxoW+2q/mE9d8XGIGMYdx6nCSLBUjjUrevMevSvE8bfrs
 1zQfS3ihOGyICDPPOLPh1zc1GjjbfinZYEssEdPoYZ+44qtbBwy7lqTn9CgZCUmfF4pe
 mymWxqHOq6Jp7nsilVW0sswyOVxEKZRmc1xqXpbSInDSDMfv4QDPsC4QcyKsSYUzj/3F qg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d31fyff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366AoxO024361;
        Wed, 6 Apr 2022 06:20:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx48pk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTrwxYImi4tTZ+n576Dt3MRXO+G8Mt1m1QCHrTi8J4pc2dAqW2bWG/qgp/N2SsAJiwT6ajAit10yI/kRMe/Drj5Py8E1mom9tNyndUKt2eWhLikFRrzaBzkCJ2dlC6aZNa1UfXLEMgYxRrIIZtrLPiXSiRwQuNb9gc0hcBv6BbCHUmw0q78upKjyrelGOEqiaqD8T77IG/lCnWOgXzrEnxorSbZ1iTrzvvUmKTUXXjc+yucuNjddCpf7GrRmuWBYOnorS7t+WOIfD3BCv7AyTD5ANSnwBXXsLwFFlFSCtx+FZylckW7IQXc8rU1VgL7evQRuXaxX1xgRPz+FMCnlBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PlDRDpV4Ca0ybP85a8jLFUO6INlovw4duX+aQN3HEUg=;
 b=GK/pfqXL7yMo9MG6j2sFZQ0hIxaV17vRXWP7hrDTJ/X8AzDr7t2/rmM8FI/8TGa5ueVmfI5ubIbijs7O42QLHQSBeWYHk0LHFZvgCgRj2ogcvDwpJp21YvY/J5PtcL10DuNpfzxlDRpJeC8XLPmy33xY15bLKwLFnC7BCBj4xYfxHHhuyVMNquGbMkgdcIGpgigFH7pUj74ATqm3qk8L+5xDAVrh9AbHGAhiQALtOsCcH3Th3YDvIuogprIIxBD1HfBGZABOV6OAfThz3euyofWrlqLDrgbM3aIKLvd19BZTch0F3XfKEqMXiVF/uuQgl3WhrvytOo0AzGskQMf66g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlDRDpV4Ca0ybP85a8jLFUO6INlovw4duX+aQN3HEUg=;
 b=xEf79w5wFuCP8ftSqWcfIQzIDsteO5mJ1EUKSuRPkjG8/fS27YlstjVjjvxpVbXEUYrWGrjBYg4yBYynQiqK4kjiYrMtZaVr8YWQkNLsUlWjU+7xhGaecX33RsolyAknV/0xfD29D0qbNauPY7v0cgxaLwjAhXAU6mLneTSxqRw=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:30 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:30 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V9 12/19] xfs: Introduce macros to represent new maximum extent counts for data/attr forks
Date:   Wed,  6 Apr 2022 11:48:56 +0530
Message-Id: <20220406061904.595597-13-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: fec1a6ed-eaf2-44e1-b16a-08da17958c66
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB55644310E0A56E3E4BAF9C39F6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9RCx9GqfP5lOhGCkVBqpIB4f4Rujm/xON7pp3mF0gs5boAY+MB6ZnBV05vzggmkKzAzcjR1hJgGLhSsPRp+sr1wauCpA8NZR/uU8xnUKk0KAej2Je5KY0gTU8zXDjudNG9YTkqbDP4Ls4j8hAbZPDWrboa7wUCIqD4Ogfi83wKTH5k+59kk/VNpBc3PGfFCTL47LGpp16mvjF7npi8NoIk2Ha60vd9uZ3rAlxr4l9f8q0GaL/jQFB/X6eSfsP9Pb34X2mnLBTrCqWyEJVqj6adGjh9TpCmHaXaTnwfvIES8BdJ7J+eEVX4zQHzwzwNOTRP42yzGCEaXRfbozw2qhRX29qWLAJlaYAFXfGrU7vdcznOcADhZdGbQZTN7HCHmOzeRd61b1Gn23ClR7GIsI9n6jfjBexCrtFZ6zsoYqW6PhMBMhai7x5FP9BjIvA6e8lUKHVuxTAi0dqOmlQheJkcI+kGKotQx00rQK+rPFVEAASfXKOKExSu7/j2v3b8ifsGw2/0pJI3JU1b4Iv6bwqjuVB1lPrMUAmXW97xwON4tCvUlHvLP3K0ZMUkRg3kcEONwpq4UfFt4zs9/iwE7WHnRQ54NB4bwCC1K74PPKijNMcOpr2sY3hK5alKQ1rw2VhDyb2UBQXeQaXlnb8cFA7hQa2NAamyqYLJFXbAwQSj5rpWJZoF5aGyI/MPIYpouvKIjcb3tyUWbzDzweR8b6Cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kquPbvsPlF2D8zzsRYJB6CgFYrN8v4l0Fr8GyIg7pIcoK3iH21wb6opzRIxx?=
 =?us-ascii?Q?D/tqfR7ljcIA8plgF4rEH2h5JYZ8Gp4nZOi3pzVksVqOuQraFePY4Xt6C+wz?=
 =?us-ascii?Q?ivHKTuZouShDMcxv/32u68C5FZXvo+CecFoqpsGxar8oEangRTv/hvUFIcOX?=
 =?us-ascii?Q?0TvQWYGx7C4EJcjMWYbcYs55vPm5Rd3uJpZReQ7TgzH0kUEBXquM2UTxAp3T?=
 =?us-ascii?Q?gMvAPUtsRr6fKRBACwkbKM7SCx9VbNjuKK5/qLUW2DxG9bEajpNXMSrBI9CF?=
 =?us-ascii?Q?KA8To2rnu17BE+ZIoQK/9flOvJOz1gAoVCqS2P4DjsCaqb+HYX7eQm3C9Axu?=
 =?us-ascii?Q?4aXyB65+zbfx/PbNmYKFgeDGAOTof+CHm7wOPfzKbtGZuGEF9dO+4WRo+SUV?=
 =?us-ascii?Q?k+msgSV/3Xu+Lj6YoYOr7Sm4J15pRPD09o57J5XrzanMaD269Kur64Pzuq+0?=
 =?us-ascii?Q?TWVZegiruRfTskKF9mEZpYho3ryTxDrrjx/T/8BzfWIgf/zRgWJNcabnlO5l?=
 =?us-ascii?Q?GbH/PCrmUZS5lpqoUJZ24aX6jDtr7SXCuur/u3xUFIp5xrk0SF5bL4guEbKC?=
 =?us-ascii?Q?y8Uf64dIgsfV0UPLU2Nm29zMskgPG7vcnU37l1+P1X7iYJ/NrxxnZ7O2QTFy?=
 =?us-ascii?Q?19ARFilz54+KUoFh2Y23l7cbYMtgeVdT85P9A465VOJ1OewA9VA8R4nkcVFx?=
 =?us-ascii?Q?JSmM3hzK5ofw8opQsNZBBg0G+ZmW3LvJxL5sJhhJSVzTf/gIJvgfkvcUww+Q?=
 =?us-ascii?Q?/7NJncsI71CWhwdpj5TMyziaQDO3oFSJ7Icd9rgYBAWT2lz/a2YM/49PBZlJ?=
 =?us-ascii?Q?ewMLwcdNyzTaVfVccvuChKVQPxU//PiLOIDv3tiA7Xk67DfftsvoFL01awuM?=
 =?us-ascii?Q?6KiHvnyALab9DD3L0lT7+OLHibFIvcUl+jHtMdGJqAtLqortuqzuksPVhh+t?=
 =?us-ascii?Q?pU0cYFgHGt2l6d7dY3J8W2baMryf6FanRl8ZLZDKNGPYFYd7J/nRKP95M4/2?=
 =?us-ascii?Q?l/8VnlI+/hkS0WXsvENJO8Zoe97yt3naDnj91iXCxjmT+sglYSz6KNuwpT3f?=
 =?us-ascii?Q?aOAOP4mLnEZnfxTG8r6+dfJp8kYyrt3dRmS3ya8uEgxeJ1DdOMxyq42ConsR?=
 =?us-ascii?Q?S5brx0kOR6CDlQESu3F5MQOKG5J9S+CtKhQWh3CVh8j1FM/7xQnsdWElmM1h?=
 =?us-ascii?Q?cdj06fIVevyaEsyLrlCgUxty4y1AcIbqrMRk4hdzW+Jqceqnhw7ohSh7G51j?=
 =?us-ascii?Q?UJxMCKd4eUY3u+qD2h4Zq4sF4mOUXuVOy3qyawMQxRYsoADuj236QRhfTJE7?=
 =?us-ascii?Q?nTVRn6c2Ikhnc/xhZ9RdNhnJmhBi+FEJAyMjoKr9TfsvFDcyutjXxjYvaeYY?=
 =?us-ascii?Q?s9/QEa3HSnka111sZLLflG4TDV2vvXsl6vpm5CNem+SYFChZMsJw41T/IfhF?=
 =?us-ascii?Q?Mvf1CQ3TbPftNys6JMyP9uWPKZLqI0z/JRKfgaH5czIZnbZ2O7o+YeccMXwH?=
 =?us-ascii?Q?tkVRUAnZ6phPF9ygKI6Admdiach2KvT7QIcQS9RIg4Tsiztq4i/3ZZ7d3CJL?=
 =?us-ascii?Q?YV5rgN3rheC1TFWXHYsf2UaRuMDMi/8Sc4CifcpKHt8/h6GXycjQ48U0+QYq?=
 =?us-ascii?Q?yS35U24S3runFJqGm8f1uIFe0nxJetsCos8ejYTU6VyaFmM4m7lcClK6Ky1E?=
 =?us-ascii?Q?UIbKzhLqjE8W32+sBfDHxLa9EVPw11w+bMEJCv8YDnIZy4mo4KgoJBHYBu+0?=
 =?us-ascii?Q?idpLIa1XRgezF299OlE2OEJxWh8mXBY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec1a6ed-eaf2-44e1-b16a-08da17958c66
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:30.1639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: du4Kgi56obSymv5nj4tdji5E/rBtpHhJKeje9OA0cf5kYwUYMMQOLd6HnwM2M/PLstpSjSXhl/WJlpczdJpKew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060027
X-Proofpoint-GUID: iJq1TJOiNhi52GG_rQ-6hx9Yv1jm0XZ7
X-Proofpoint-ORIG-GUID: iJq1TJOiNhi52GG_rQ-6hx9Yv1jm0XZ7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit defines new macros to represent maximum extent counts allowed by
filesystems which have support for large per-inode extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |  9 ++++-----
 fs/xfs/libxfs/xfs_bmap_btree.c |  3 ++-
 fs/xfs/libxfs/xfs_format.h     | 24 ++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_inode_buf.c  |  4 +++-
 fs/xfs/libxfs/xfs_inode_fork.c |  3 ++-
 fs/xfs/libxfs/xfs_inode_fork.h | 21 +++++++++++++++++----
 6 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b317226fb4ba..1254d4d4821e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -61,10 +61,8 @@ xfs_bmap_compute_maxlevels(
 	int		sz;		/* root block size */
 
 	/*
-	 * The maximum number of extents in a file, hence the maximum number of
-	 * leaf entries, is controlled by the size of the on-disk extent count,
-	 * either a signed 32-bit number for the data fork, or a signed 16-bit
-	 * number for the attr fork.
+	 * The maximum number of extents in a fork, hence the maximum number of
+	 * leaf entries, is controlled by the size of the on-disk extent count.
 	 *
 	 * Note that we can no longer assume that if we are in ATTR1 that the
 	 * fork offset of all the inodes will be
@@ -74,7 +72,8 @@ xfs_bmap_compute_maxlevels(
 	 * ATTR2 we have to assume the worst case scenario of a minimum size
 	 * available.
 	 */
-	maxleafents = xfs_iext_max_nextents(whichfork);
+	maxleafents = xfs_iext_max_nextents(xfs_has_large_extent_counts(mp),
+				whichfork);
 	if (whichfork == XFS_DATA_FORK)
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 	else
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 453309fc85f2..7aabeccea9ab 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -611,7 +611,8 @@ xfs_bmbt_maxlevels_ondisk(void)
 	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
 
 	/* One extra level for the inode root. */
-	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
+	return xfs_btree_compute_maxlevels(minrecs,
+			XFS_MAX_EXTCNT_DATA_FORK_LARGE) + 1;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 57b24744a7c2..eb85bc9b229b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -872,9 +872,29 @@ enum xfs_dinode_fmt {
 
 /*
  * Max values for extnum and aextnum.
+ *
+ * The original on-disk extent counts were held in signed fields, resulting in
+ * maximum extent counts of 2^31 and 2^15 for the data and attr forks
+ * respectively. Similarly the maximum extent length is limited to 2^21 blocks
+ * by the 21-bit wide blockcount field of a BMBT extent record.
+ *
+ * The newly introduced data fork extent counter can hold a 64-bit value,
+ * however the maximum number of extents in a file is also limited to 2^54
+ * extents by the 54-bit wide startoff field of a BMBT extent record.
+ *
+ * It is further limited by the maximum supported file size of 2^63
+ * *bytes*. This leads to a maximum extent count for maximally sized filesystem
+ * blocks (64kB) of:
+ *
+ * 2^63 bytes / 2^16 bytes per block = 2^47 blocks
+ *
+ * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
+ * 2^48 was chosen as the maximum data fork extent count.
  */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+#define XFS_MAX_EXTCNT_DATA_FORK_LARGE	((xfs_extnum_t)((1ULL << 48) - 1))
+#define XFS_MAX_EXTCNT_ATTR_FORK_LARGE	((xfs_extnum_t)((1ULL << 32) - 1))
+#define XFS_MAX_EXTCNT_DATA_FORK_SMALL	((xfs_extnum_t)((1ULL << 31) - 1))
+#define XFS_MAX_EXTCNT_ATTR_FORK_SMALL	((xfs_extnum_t)((1ULL << 15) - 1))
 
 /*
  * Inode minimum and maximum sizes.
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index f0e063835318..e0d3140c3622 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -361,7 +361,9 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		max_extents = xfs_iext_max_nextents(whichfork);
+		max_extents = xfs_iext_max_nextents(
+					xfs_dinode_has_large_extent_counts(dip),
+					whichfork);
 		if (di_nextents > max_extents)
 			return __this_address;
 		break;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 004b205d87b8..bb5d841aac58 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -744,7 +744,8 @@ xfs_iext_count_may_overflow(
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = xfs_iext_max_nextents(whichfork);
+	max_exts = xfs_iext_max_nextents(xfs_inode_has_large_extent_counts(ip),
+				whichfork);
 
 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
 		max_exts = 10;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 4a8b77d425df..967837a88860 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -133,12 +133,25 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
 	return ifp->if_format;
 }
 
-static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
+static inline xfs_extnum_t xfs_iext_max_nextents(bool has_large_extent_counts,
+				int whichfork)
 {
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
-		return MAXEXTNUM;
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+	case XFS_COW_FORK:
+		if (has_large_extent_counts)
+			return XFS_MAX_EXTCNT_DATA_FORK_LARGE;
+		return XFS_MAX_EXTCNT_DATA_FORK_SMALL;
+
+	case XFS_ATTR_FORK:
+		if (has_large_extent_counts)
+			return XFS_MAX_EXTCNT_ATTR_FORK_LARGE;
+		return XFS_MAX_EXTCNT_ATTR_FORK_SMALL;
 
-	return MAXAEXTNUM;
+	default:
+		ASSERT(0);
+		return 0;
+	}
 }
 
 static inline xfs_extnum_t
-- 
2.30.2

