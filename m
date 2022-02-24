Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F670C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbiBXNDc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiBXNDc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776F720DB22
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:03:02 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYSwi023304;
        Thu, 24 Feb 2022 13:02:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=iBkB3G2ooHws3WDfByQpf1jydXHxTW0N9ij7xAGoHhc=;
 b=DoK0zbssUowc+oI2X2yXTfVeY13W0jpFmEcFaytOuVb7pZUkm3BUWpw8AIrkmk43tzEg
 T1jBTFnr8wl5iMT9YG3SXGxn4CU5G5loe1sie9VwXgPOH9QvBZel1Px+HTlaleJTobiH
 5xPDpghQRsM+EyT7vpTi7a3GeggGoNdvwDmQdObCC6da1bvrR/yabjKa4ltj9ygnAbBU
 73s+f4IpCoYSVcE2jOn7vETsCjeP5IR/dLsMpXJ43sDX16WpesGxOmyOLSXWzF2HLxz1
 9UYzkQfM+FM30yjScc2tt+isO4UTgAqDvrJYVfNgLoApyB9cDS8xAX7jEJfu+e/xul5m WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecxfaxmfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD1fem039509;
        Thu, 24 Feb 2022 13:02:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3eannxdde1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:02:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDEH9i/0r35y83qMkYf3QxFek8JUc0HdMkim6FwLpUHrztbwfhLZ0sOQR93sCkK/Y8CjwD4C03njStkylQSXIjTVfPAGNpdQC3ZOdra4S6tP8FEfilWTFDIUv8Zb5Lm1KtQ6T7kJx5pRZcjGklH1mMWzemlX/7afEbXMTb2bhNHy8Zci+DdglAiO0xt636UUhqWf/IN5TxXuEzVR1HiNksvwCPOhrzCDuV7Y24/KIYzS8gRuxh1mezo4XyNswIdIDFkk45Xk6jS88XJTnXr7/O64Ijlje2/z6OlsEDJekinChtY/biV7+jmkmAo9hLKn2rm5HJynSGRdViLSjDfwrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBkB3G2ooHws3WDfByQpf1jydXHxTW0N9ij7xAGoHhc=;
 b=RGVh2xFEzlDULrYO6Xiw5R6kqy9mGLotZj8B1nmaQUUq+kcgWooAyF0i9B1LWuluMw6yJBPcdFDobF61upD9M0jSg8lak/4ivZ6tjRJEy6rdKYi1LvYVvdOCR839z1WXsytH74Unz03zdi4oFE9G2LtKppY3Uvg662ImTL4RsuKKKOEQhVuhP2cjY70g4QGCXgls5xyDmwECW4z0noYXzqA2r/bnIk4NAukCCRPtOttfwap8voBtYsDFZvwn4LinuOrcWoZcHzHdvsiztBUh3qBtgH7rQqy6oSNDEZOEI7EoudD1WoGZgFo+HLfFCkAtC3hxcNrVtYAchw4o7FWFmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBkB3G2ooHws3WDfByQpf1jydXHxTW0N9ij7xAGoHhc=;
 b=wckBy6qwIwR/Kw/miWlOumdWaAIogEACVdF0kKApJbVSMi9e7HZbDHjT/OEENaR8hvggn5ta11fXrrKUtZ4WxBt7yXZ0C2IHg9Wuyrdp2TidxgZigqTVVHg/VA6vGnopROIe3pK1GZCZ11JQcimXO/fefgLzS4sSTDsg9ysrZyI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3665.namprd10.prod.outlook.com (2603:10b6:408:ba::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 13:02:55 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:02:55 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 09/17] xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
Date:   Thu, 24 Feb 2022 18:32:03 +0530
Message-Id: <20220224130211.1346088-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220224130211.1346088-1-chandan.babu@oracle.com>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49674ef6-4465-42d1-e167-08d9f795f931
X-MS-TrafficTypeDiagnostic: BN8PR10MB3665:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB36654F09CE47C527863BE74CF63D9@BN8PR10MB3665.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oaywTO3fEXDNsaA7dbzouu9S9P5sGXe3hJY4yy5mwIkKCJ8gB4svhn1SKoChz+NUFGN/Z2R242sx8LmyKsgRugmkthqfFhx1j6tNuNfmRUvYtuNsX7/NXc9PHYr5rqHYRC6rqop2iipYoPpyvw6ELsbpExCf4GNcPSm5iW3nA30WyXmn1llywKckcHBfoK6krnP0b58cRj7Zrt35HR/6mVGDb+EThC6k139fktLkOobqUAR7Etkh0tEIId0A3bY2HZ7oXWrLVZa7Q7AkPMnU8OK5VeSFfT/GFEClhG2BiKU/R+mkA3MUPNOXp7Aqyuw+d5QU3tid/4VL31RaR5ZnMLXdSMnIpmIYJPCmlOkAHbzoFdNw/IiBRauYBgWA7zGSfZqnc4W8Xe6yAu6K6GtKws+4fBL199O5/3w6vMVs1B+KW1dt04HWeNlSbtro+kgxjuNwILLB4FhH9g9GBmlE589mhzOZQGfXx8kvd/TlSTZOt/sq/2xRWw0psS6mryqmR+1Z7vhQgNok7rDoaSB6URgFFC1ywFT+uRi8IthfyJ1RkNwh9H/IZnmiPtEucY2CSrcKS3K/XMErF2HOnvmkCw1gJxXQzD2ixKaU24Zoovxc/nNhZKLji346c2pydAy8KUkEsBW1Nyq84lyPFAPdhaG6ETRqRyR/ZfIcQ3pmxYm+yIcmApo9NGSYSqYXAAsFFS+yqR3ZlhbJqPj3PSi/Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6512007)(8676002)(316002)(6486002)(52116002)(508600001)(6666004)(2906002)(8936002)(66946007)(66556008)(66476007)(6506007)(5660300002)(4326008)(83380400001)(1076003)(36756003)(38100700002)(38350700002)(186003)(86362001)(2616005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iaAXprGvBTuFac4yWI451kcLatsSy3iN5niwebOwPfQ9QCS4jOoXrby13PJy?=
 =?us-ascii?Q?l/ELvuZClRMzG0uCs8eXb7F3hxDyhW5ZASkrqrZWeXq7WYKVhHXqAY2PZaj3?=
 =?us-ascii?Q?/+jEWBYwsY2HWumpZBevo/zb4NdhH/QOQFWdaNltz+YBaJT/n0EdHsigJFlW?=
 =?us-ascii?Q?7NSi3r4vSx8A4BsbBXEm4JckW0XgKKsBq5vh2ahdl9SMVhFNIt8PXtLzRc1v?=
 =?us-ascii?Q?puxe360FwBNspE+SiC6AecqcMchWiPBQqMU5ZJmwCUzsJMebGkXqM5aLSGHe?=
 =?us-ascii?Q?R8S+Cs0EdpTAIc5F8jaq3J7n2yB0GqOPhttzzhwvKuXEm6Va41GzbaTQzW/b?=
 =?us-ascii?Q?RjUwu0gv3f9xytDIhRFEXqiL4RAjaiFfWhZzoR1P7C1ownHPR82pHxcIF3Jp?=
 =?us-ascii?Q?qMWQHI6lu6CJecKJt52fTf+qfMlVMA2y+jbsusVloc+PgTWw82FrtEUzzjj9?=
 =?us-ascii?Q?KxkDD5GALhHb3acQrQ3JjhxpRYRCdS+GGPZSGoTdrGoNeFa4bFXQBnCaTcl3?=
 =?us-ascii?Q?89sAZF7w1ko/a6CVZT2X6hb3v21GHPqzRxcMo07sCeTb0+ERPR+pAqYh5jDD?=
 =?us-ascii?Q?BDfZbi3sSXziX7t6udDEGS/1SYDSdU1NjfnH2Ig7cHyI3WrkiT56FcuxOKRk?=
 =?us-ascii?Q?JARHplaK7o2bKNmu+FWGqmfLLA9rI1FcDLZjsrETz1K33QhftUdreYJJ9ZOA?=
 =?us-ascii?Q?u08dS7SXTkdbjPaPbtToXaFd9YWzELhn8/qFe6XUz2LqyTJDNfKpO63sOCGA?=
 =?us-ascii?Q?+w4Wybc/sCP4DMP7sdHpbJaeolzn19eADheWxkr+p3ljNQfB1Mc1dzOFkAsH?=
 =?us-ascii?Q?9t46of7aiFNcK2jMzGvndnk18dKSuHOK1qybkKaV+Z+iO/X3p/gY/PEZYiBw?=
 =?us-ascii?Q?bDq97I2ARJ9meb1w6rLxf2rfMtQhKbnTa9Z7qrhSAbDnXedXfogUGnI7WPXm?=
 =?us-ascii?Q?MNPIndo7dz+wKFVmJ5CUI5eea7PO8rrgnb+zbyaRUSj4UIlMA+6tY/RCw8Yv?=
 =?us-ascii?Q?GMCb9pZNV0i9eWHHixnELvj6RlzA2dWzNn3DAxfWDWOpjE4AhofNkzBwK+s0?=
 =?us-ascii?Q?x5qiQ98SoP5b0xZF+9EoAPyAuLiS0E7N/iujQQCD0IucqprYYW9Kp1X1iQBW?=
 =?us-ascii?Q?haSoK2JlvNp1UkQ/ikKYJh8HEK5Z8hOVcV63FEsvrm1Rkij8UUbK+74sbdg1?=
 =?us-ascii?Q?M/XKfUdu26TKqZhHL3P9bdzKIbdUKoHy9AiT/6Gt50igcub6w78bBtK/6hUp?=
 =?us-ascii?Q?amg8XTKCkm6vFsj9fXxYjim6W2D9p2VrA93v3wOuIVoacHwBcixkveio1UmQ?=
 =?us-ascii?Q?znLrGvUVUOOpQ4kTIePOsi+mu41qrRGGxTBjTP5gEwUuKsorrNtNzroOVYL6?=
 =?us-ascii?Q?V8L5sIb/ptUgJc+UdOa1VxI+yVdKJiUgioyUBeesLMWMKlmMz8/HnhJTW/Al?=
 =?us-ascii?Q?mEAR1Kp95w5FjBUJzR7TByH5CWag1yWbq/vOurPtun1589Jji9OjnzuXX6hK?=
 =?us-ascii?Q?bdqVub7MWGLFH0ZGIQoYe0I5TFpTBGOkfTj52Tw2BTjQnZRIq/SR97beo6lk?=
 =?us-ascii?Q?mTGQnY/gb1A4dPh2r8XlIJBG95mnchXQlD+oNcSEEud71eY6Xt9H67oqocVa?=
 =?us-ascii?Q?epm8MoLjr72xltetlPE8JcI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49674ef6-4465-42d1-e167-08d9f795f931
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:02:55.5274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GyGAAwHGhTe4wgoah1HWYw/eSaGFeFNSvFzL7Zvr3jx2eefIhOa/9IzG6vzUt7gHzoPvx5/0JJ1UC7fXWpIEog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3665
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240078
X-Proofpoint-GUID: FBWETFPWP0YT2b2g9-_JuN5HdcXlIyXH
X-Proofpoint-ORIG-GUID: FBWETFPWP0YT2b2g9-_JuN5HdcXlIyXH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the new per-inode flag XFS_DIFLAG2_NREXT64 to indicate that
an inode supports 64-bit extent counters. This flag is also enabled by default
on newly created inodes when the corresponding filesystem has large extent
counter feature bit (i.e. XFS_FEAT_NREXT64) set.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h      | 10 +++++++++-
 fs/xfs/libxfs/xfs_ialloc.c      |  2 ++
 fs/xfs/xfs_inode.h              |  5 +++++
 fs/xfs/xfs_inode_item_recover.c |  6 ++++++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7972cbc22608..9934c320bf01 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -992,15 +992,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
+#define XFS_DIFLAG2_NREXT64_BIT 4	/* 64-bit extent counter enabled */
 
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
+#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
@@ -1008,6 +1010,12 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
 }
 
+static inline bool xfs_dinode_has_nrext64(const struct xfs_dinode *dip)
+{
+	return dip->di_version >= 3 &&
+	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
+}
+
 /*
  * Inode number format:
  * low inopblog bits - offset in block
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b418fe0c0679..1d2ba51483ec 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2772,6 +2772,8 @@ xfs_ialloc_setup_geometry(
 	igeo->new_diflags2 = 0;
 	if (xfs_has_bigtime(mp))
 		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
+	if (xfs_has_nrext64(mp))
+		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b7e8f14d9fca..ee54a775a340 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -218,6 +218,11 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
+static inline bool xfs_inode_has_nrext64(struct xfs_inode *ip)
+{
+	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 239dd2e3384e..767a551816a0 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -142,6 +142,12 @@ xfs_log_dinode_to_disk_ts(
 	return ts;
 }
 
+static inline bool xfs_log_dinode_has_nrext64(const struct xfs_log_dinode *ld)
+{
+	return ld->di_version >= 3 &&
+	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
+}
+
 STATIC void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
-- 
2.30.2

