Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0324C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 09:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiDFJkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 05:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585024AbiDFJgN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 05:36:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A773B29D5DC
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 23:20:20 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2361urMh014702;
        Wed, 6 Apr 2022 06:20:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=FY9J+lrcMey1eLoOaG9B0FdQIQybLOJ06fW8sZETD+E=;
 b=VXuiJ8155pkc34HtRd0jsY0o7BR78xlHs8UEhGt1rxWIZB6voOC8IKM76hfK2Ckn3EPk
 3Vsr6VgIgXVh/ldIpitIrzWAlF5dFbLAfTsoA4nok0hdJZCzGORx7IlKbz9+pA+cicRP
 OM9mNcdtqFKQCLuS95LFEr31B26K3lBM0gzUgF5M20zuoS4m4gkHQKhMnN3kXm0l+4gW
 lsKwLbYY8LyF5ReZefV1mKU/hG8NqClVzRuLiF1GvHGXs/Y10dWcuFvMeQnipKCC5n4o
 lxzNr9P0VDVugNQINU5Lh4N97b23XA0gWG6IPksv3kq5LLFbPFacFgn17iovgJEDO4zx 6A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9qrr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2366ApBd024421;
        Wed, 6 Apr 2022 06:20:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx48pdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 06:20:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4dVZVz0zSWJ+vO/wDxbKapGQKCJSarIuSZXWBrw1S0TL8CC4TEn62/DMb7THylaUq9X4zCximaNYPAfrfayHe3JHI//vP7lcM33o6e0MoTS8iY9MhEVVppicrieMUnJ3Hv/cCa3y8oZXGjtE3+a421TcvSZbjE8cYm7ZDIiF2HVefFkTPUGnFRLkIzCauQSqjs7lMwcyBua0lnyraJ1dIayNjzUE9mDKcefPm0E6c4HgW9WTmkXlBqmX9sXh4lWDi6XUmt+eFrXf2z6KOtDuD09uHaSB8BejwlZLNdruxN17gHlEh8G115+1n/2BwqakU6fTlINF+gRihTQ0OnIZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FY9J+lrcMey1eLoOaG9B0FdQIQybLOJ06fW8sZETD+E=;
 b=F4sPUjRfjF7Sc9cIUgj3gOY4056JCdXidRR6/vGVv2RtuDMw7cxlEgrOdiUEwixOHRqVscxXVNS9mPHOvrrUJhLjGOIS1Vm1EoYUGU2gA4vefb4hlrqzCstZiDwzThTa0PNyvovrgSXxnum89qhM98N1M+4LeIYH+GUAxvNlGHijq2OORasP7hM/PGlbYGrw0aQQMgIkfSWK3jQc33mIpCsFtA0U9sOMOgzCfhEYwEx/MRA5vWJK304CWM3+QgnrZ0OImITkkUR4J07lBlYXvl5Ns7lvp9uyYfgxpjEBYb7AKCRdkeVP0W9FUCqVYylVFNMO+mV0LITUNt5QC+7L6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FY9J+lrcMey1eLoOaG9B0FdQIQybLOJ06fW8sZETD+E=;
 b=OTVmsuovR1+dqNWkLcxkUTMzOWqj7dfW16EV7XQCYVWXymofDAdNf1eK0q5nIYJbCYwQOyNdxBYWjLV010uxLLlEP/m2eYzQLWVc1ixHMZOO2SY9MYqNTBqvtV+5JNkn6CxUMalrh8XCkTSpB4h1VlGs+3xrUy6hP1lW2/o6IJo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5564.namprd10.prod.outlook.com (2603:10b6:510:f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 06:20:12 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 06:20:12 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH V9 04/19] xfs: Use xfs_extnum_t instead of basic data types
Date:   Wed,  6 Apr 2022 11:48:48 +0530
Message-Id: <20220406061904.595597-5-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2e51c724-a8d9-492c-e299-08da179581f2
X-MS-TrafficTypeDiagnostic: PH0PR10MB5564:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5564E705E1601D5FFFCF4761F6E79@PH0PR10MB5564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fW6UDP1YHvRk1pB5ergErF2U+8S1tsthLe1a/A1TLprng/YNQdyp7JV0KRRjOb3MeiAsZTerLj6xhei7/BjL67blWIkXIbtDUkE0eB4AxvrPweKL7A0LoTzTzaejAFuG8ZSO8lf2Xt/P1960cdOUy4eQJW3LQk3P8EhrJWKzdJ66eRLNzXKi/Ehvstnh5qvkMYAKMFZcYpzp/uQ6RH4QsrfgkauLbpratiqMk71PngOETq4oBL1Mgq6pTCecnse8E9Wp2+1QZPN71cWA/rBWlnEbu1Oe0Cj4k1CnRjIz8ARwWhk5BSKnvApSPe4XFShu/Yikxc6dHINv8l42BzlDWCuarAQrl7qjwz3OEy6OcMSmndyWPWKs6qWg6WWtCGIleFiT4kVLdNtkBVFJY7yYrOyRft2L+EPIq6Ba/OD+X4BDEJf9CutCVAGyGDzL9oG+irnmju+WP/bis/jFMneeqcSPLJtVxvX3km3OhL1qSMS16Io6NoCUi0z652jJJC7STKuetwQTpGHJiTK92UVfPl7g9zCBooOVjV+gLD3aV09/TIBSM66NVEEdcPvufglMZYl9yQZ5duGFVq0dMafp4Q2/K6bSx0U9M1CvNER1xcoT/c/FCZmnGMAZ8M7843LhT3dJchkLWNhVLnxY/9xEi94xwnwlg09nSzhsaEjmzSjfrTQAxiRCRh5PhSSsAhp7ROqkfr+FMWSW7JkrF4qXeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66476007)(66946007)(6506007)(66556008)(52116002)(6512007)(6486002)(54906003)(6916009)(4326008)(8676002)(6666004)(316002)(5660300002)(1076003)(8936002)(2616005)(83380400001)(86362001)(38350700002)(38100700002)(2906002)(26005)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6wc6YFLF71oqFWVj0kQ1OZtTCgtw5M+nw9o3aBn26v26AzJ0QmeUvqjt+JeR?=
 =?us-ascii?Q?9hZbPXO8jpVSuVVc//bDesZ0duTne097XjzkYBy6cFjjg/NNNbvd6Knttagp?=
 =?us-ascii?Q?XsNIVbS2ceF28CGX2XTIIWTwVSIBx+bQsYEJwPKxEvG/jSfBscZQ8QMtnebI?=
 =?us-ascii?Q?AQedoRNSHC56S2vv7ehleTtGaeG/5g/pmQc5xxLx/So6x/uHQOk1E0VgDT7P?=
 =?us-ascii?Q?i93/4+Y1Do8sJ7j3yO0NHpsbMGd8gx9+bvVvRibwd3zFi9GaSYho0ZhfLzBy?=
 =?us-ascii?Q?eFgP2aJouJmB/hIhv18/e1oKajMUtmr2avDGoZuWjiopsEeXTjLkODeSEit9?=
 =?us-ascii?Q?vpkFiFUr0R+n/mpPumO5ysq2tNFIz4/MrP1Y1+RtHdlwRIyRmV1W/REv0bs3?=
 =?us-ascii?Q?NStsdpBEuOuaHQIdDIEgKKbXv/EGZWfnu5SVpMVd0ZMilZDCiCMvobJ3aHv0?=
 =?us-ascii?Q?3juv/UY2dFDZ+zPnAEI6EqLaqSfCOGaxfL9+9NabWqm2qekI1tTNgXXU2MNl?=
 =?us-ascii?Q?sg9psM7f2gaLHJAsKnKs+h9S1zQslp+ba61y+a3TB8wJXFf5SH4bf3FM6pJE?=
 =?us-ascii?Q?nM0UHCGg+syyH9/FCbYXc119jcNSt3YvAzc1KJ4m7PfJbeSTgMnZHXFqCiKw?=
 =?us-ascii?Q?JFxQgcumG+pmWse3ULIsVkK0M2aYHxipvemNCAR/UejAz2ly/HfjVX9WUscJ?=
 =?us-ascii?Q?jOd/fK9JSDTFOXwtERUXq9HpntFD5fhwIFvFTvEAngu9o8hjvsitv41ogiHv?=
 =?us-ascii?Q?LR7qFgRBaaWx+DT0iJYFEr5f+IiYUyiqLSnE8Suadlg5anIoWVJaMJVDSe97?=
 =?us-ascii?Q?GMMEjIK3khRGQsWPvFymP4D56i5TE7ad2EyY0uEClhVU/4vc6J2V8u8Ycx1w?=
 =?us-ascii?Q?JP0H0ebGXAeCUkFX1KQQ0G6g1t8jwQXWnLBkzB1XLpI0EkBbUdBrwTsdjMmk?=
 =?us-ascii?Q?aQjGb392e1qZYtSUkWIZjy9xvVT1ws7eY/ICa4Bnu0Y6imss2vBzhAp8wqWx?=
 =?us-ascii?Q?urlKj97I+B6x5hbjRVvrcN7Vo850y7tfFzC3yCvIgBHwyFiC9Y+2YgqnhjQC?=
 =?us-ascii?Q?0PEurlzDnehxjFfYkHs0c1fBv0J43YmlZNMGe57Hqo/a9956s8HoSAUrkO2U?=
 =?us-ascii?Q?TJWydB4Ej2c5C2lpcYFwBC3TUCQ/pI5C2sCCFUNj99L99BwovzO9y2t+W0XO?=
 =?us-ascii?Q?9UaAt4WfUYFahONlJ96cG7yzLHMZq8Fk7gVwmMVwMTDTW1v0LDU1wJsaMukl?=
 =?us-ascii?Q?gfjg84ULQOv5pwWbHHbnSK6PMIp7G21+OO6Q5EYTSToPVGdZ1AL+w+N2zLiI?=
 =?us-ascii?Q?A3NEPAd1hiRGNpZ26D1q73od2c9VN/SNviAhbFpNuRuJ3IAZR71gleWDMGb0?=
 =?us-ascii?Q?D5pZxyuxV/zrVwCKRMTh2Ulu9D3WQoEFJkPGyWj64cVuv82gmcjLVZTzHbZG?=
 =?us-ascii?Q?W6U9F7Etf1aXfPZyzCvQpD0etWjFzSoQBtiIEz8XzVWMPMm5ZhLKWGwuvgpp?=
 =?us-ascii?Q?yrjcYy+d/Mzqd4O+WPGIXnwFw1yJx8ouoKMz2odu0P8/0ypbAnYNxSW+bgTS?=
 =?us-ascii?Q?S7Tuva2DmFYQPQfxOBp23m/AUdr5WgfcsqOVnhRfnH/TgManE9K67nMUwc1a?=
 =?us-ascii?Q?5nrmpuI2Ytk5ln1t3sUVSZ43D3mkqA40BWd6PJVJwoExTBAcZsRQAZdBt9Mr?=
 =?us-ascii?Q?IUUunrsX0h3kbHtpmQK6nCJ0HnLW43ZDFqSwEr5vfdHKjsDS4KJJ7/HLLd83?=
 =?us-ascii?Q?EmEC7zG5Vu8glNSf5pAldNJzCDqggvQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e51c724-a8d9-492c-e299-08da179581f2
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 06:20:12.5809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NkVoI/SMkn1WexVI+yHozyhk26lDbs01Be51QIylr9GoAZBFXejVAVSvMrgVMku33VUzt5nyEtb/tAbWveQeiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_02:2022-04-04,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060027
X-Proofpoint-GUID: b3LCM9HFpSLF9zLmT48zKK2enWr53nDl
X-Proofpoint-ORIG-GUID: b3LCM9HFpSLF9zLmT48zKK2enWr53nDl
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_extnum_t is the type to use to declare variables which have values
obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
types (e.g. uint32_t) with xfs_extnum_t for such variables.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       | 2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
 fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
 fs/xfs/scrub/inode.c           | 2 +-
 fs/xfs/xfs_trace.h             | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a713bc7242a4..cc15981b1793 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -54,7 +54,7 @@ xfs_bmap_compute_maxlevels(
 {
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
-	uint		maxleafents;	/* max leaf entries possible */
+	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index b1c37a82ddce..7cad307840b3 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -336,7 +336,7 @@ xfs_dinode_verify_fork(
 	struct xfs_mount	*mp,
 	int			whichfork)
 {
-	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
 	xfs_extnum_t		max_extents;
 
 	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index e136c29a0ec1..a17c4d87520a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -105,7 +105,7 @@ xfs_iformat_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	int			state = xfs_bmap_fork_to_state(whichfork);
-	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
+	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
 	int			size = nex * sizeof(xfs_bmbt_rec_t);
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_rec	*dp;
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index eac15af7b08c..87925761e174 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -232,7 +232,7 @@ xchk_dinode(
 	size_t			fork_recs;
 	unsigned long long	isize;
 	uint64_t		flags2;
-	uint32_t		nextents;
+	xfs_extnum_t		nextents;
 	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b141ef78c755..16a91b4f97bd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2169,7 +2169,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__field(int, which)
 		__field(xfs_ino_t, ino)
 		__field(int, format)
-		__field(int, nex)
+		__field(xfs_extnum_t, nex)
 		__field(int, broot_size)
 		__field(int, fork_off)
 	),
-- 
2.30.2

