Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6488EC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Feb 2022 13:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbiBXNDp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Feb 2022 08:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbiBXNDo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Feb 2022 08:03:44 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9038520DB22
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 05:03:14 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYFnV007314;
        Thu, 24 Feb 2022 13:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=wUrsIxoJg9MJ6OUKCCNrbVZoBtrMjeAwc8VFjFaKGUE=;
 b=02ogr7DbhR2xG5h/wqO5u3XuXrKfQK6w2H7dU3y4Ycs+CjFJeKWks3YdNZIbnNJhQQST
 1yDmDQkXCdViA/HuPBeKi8WztwMY8b6qBIJLXQBob/RHtHMGowTi6L/8pxZt4ssvKJSk
 Uskc2sgtr0wHd5JcPBBGwoExJ2CszemTys+d+tRA29knwrdAM/yftFSr0c5vWweHln5R
 3drOGMJBd9YHl6TOnI3bPw/zUt0PrRhSrI2mIjHJUW/e7RA+7lnl3MZpc4U+njINmY42
 cU5cP9GqlWzUkDuzrd10ep6SMwdqLy61gIv4HryRfxo6FgEmA6Q/AOBHmjEpwv3FL7Dg Qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ectsx7b2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OD0XXk120477;
        Thu, 24 Feb 2022 13:03:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3020.oracle.com with ESMTP id 3eb483k7em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 13:03:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gohUEdE42x/m79CZjOfgx4BU+0zvMJeZI5IZwGSzFoa/v0gNs6Ejaoi0MFNLa+XGVFfy+SDKZmWVjFxZS8xS3kQwQ3X+yEe1SmOil0Wadw2V/96hbUpFtyHhn2/hFYuPSa7GdVfcOORvSUm2MeTQORklCYBYGI0aJNVXh2P9lu3YjmE0DDBLswvuMCen2FvfxWHv14/6RNVTYV6ySkHcLp1Es7gT34wRULNJ2+nb8AjepjhBAHkjPlIPT35spIFzEtS/aMez/YCRXen0MbhqKIhSRyUTjQHLV/WNo0/cO9DaX7xZE1YU3ER7B3pD7lD+YOCe1XScorF+RfnzwWCmew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wUrsIxoJg9MJ6OUKCCNrbVZoBtrMjeAwc8VFjFaKGUE=;
 b=X1IIndSuIM9ph0RTDMwe4quRF0CQmWOatzWjd7VykNpq6X2FjNindsWvqmmcdooCE/D9ZuGGADOlAT3MBBS6Fp+X5OI2Lc0Rw8XSFCQcmc0nQWTvx4cZL5BIqSXz6xluo8Cx0nqlCaSF7HVhSgcDr/H4oePV4kshA1kzT1drlLfC9glkEwVqRx1Dc42y3uB9gDQ0AabkBZZBi55hrrBluuz/oXAGZWx018W020ZVUNN9hK6O0E4jHJH+bGSZ1R0yXPGqAg0zyzaZ9P4cQkLl+gYrjfDF0grfFDhKv/Xo0edmN4wjGaSWLDSvu7r95DaK91/5YKZOzv+AZf6ADopT0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUrsIxoJg9MJ6OUKCCNrbVZoBtrMjeAwc8VFjFaKGUE=;
 b=DtZB7USVR1wg2QcS91IkLhkiz0Bn7Pz3nD+6Fkx+kn9V0oHHKRZp9lD2foM2sm9oEMMY0rkShcwO/8v+C3qcahzEOxXYFQjt3nLh0W4UFkQJwJYkKKbjEBYxskPc+FR+40P05wEK8Ef/apHfSa9gTq77DevUjo5wE8gqyQVOOeU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2172.namprd10.prod.outlook.com (2603:10b6:4:30::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:03:07 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 13:03:07 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V6 14/17] xfs: Conditionally upgrade existing inodes to use 64-bit extent counters
Date:   Thu, 24 Feb 2022 18:32:08 +0530
Message-Id: <20220224130211.1346088-15-chandan.babu@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 76ef49e9-834d-4760-e297-08d9f7960086
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2172:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2172C6DC06DBAE107BD78A1EF63D9@DM5PR1001MB2172.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aUzWoVp0m41OKhRap8F7FNCkKD9kL2UZxzK9tc4zJMTT8crmfTWNaa8EDHkBoEiBjqZdR3jswQNtDUgt7qiZWbNxIkdG6sFGn8xteGjndEB7SpCbHZ16+j3lUfVSjG9qa0L8ysZZF2Fo8IMHzhIQ7NZyaYCv6O7lRktcMU4HFA3ENMGjrvMjaqPmv3/WHUEGnr3aSJTffAC5gdK49WTFjW58lKRXQ/tbkt9u3ye2J129v00rzR9L5zTPnOjj68rYQ7/4wA+UEfP64RYT9VPTMMdpxIIzOl3M9moy31m1ak7IDXpUTwRvL8RsQzQVvxikS1bgXSlVLXorzTu+QX/NBLUIqfQkTdbo75OhXhryeFTtn0SwdIrZUKboOZ8Xhdwft3lVcvi4PknvCp9s+SuEjT+DwMoivgJtuWFeb/D7NKNcAvuNXSNdLxV8CZGHGX7I2XUDIp8mnste4jo0I2VvhdSw8tUsSfEHkWJet422RBWLcwH/+Rpw8weGOly7vcrEsZ0RUr/U4IZcJU6KK+oH8Vf9go1aesJSrWP7QQxKv37fHQlA4XSnRBdtSiLBF9WQWD/Vt3lclq2VPreXGqwy69W0wEbB+prs4jtLg0Z1HYhBw1nY8io8jxKHb1Ih2Tx5EtIJhbP/F3Z1zxj4ONckGVQxyzmG+v3Yb9c7MxLMFqIbnYCooAXiMzohkCrhiKyTTFZDkfqR791tsdOLgGXiGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6916009)(4326008)(508600001)(6512007)(316002)(66946007)(66556008)(38100700002)(8676002)(66476007)(5660300002)(38350700002)(6506007)(52116002)(86362001)(36756003)(2616005)(1076003)(83380400001)(26005)(186003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fFxZKTjkhwwp5K7UCko+z7NE/3M5xMGWdmn/7biOGyyHczUA9+JNlOISJ7Yj?=
 =?us-ascii?Q?i2uaTA/Rg5uVSwrX7ABsWSAa1esx76/CV28VNHR2LdBBxQPDzqh6FYiYBjyD?=
 =?us-ascii?Q?G0knQMQRBDcxpI+DP8nF2BO2i1NmGW4wNNoek5PtaUKH7vcsSZ4SWOO16YFE?=
 =?us-ascii?Q?sag4h1vGYUb/OFTnzDbcJfONg8AQI7eGseztXAavPEs1G5JT4rocomFXYvuO?=
 =?us-ascii?Q?QQsC6f0lNMDrJxtsPAlFFyAtEOIhyZSPQvjZ+UNMGIBkVNMozMUP128yT+wU?=
 =?us-ascii?Q?V9MoBs9TaCcZAw1D2C8Z1LmtyhGef9Nc9k6c5UBPUcM+EW/cl0GpEO5LAjBf?=
 =?us-ascii?Q?Dj8rFp151QP55L9G0VaFVvLzWvK3fLnibN4fcWDRo3TJbFV3zkfPoDMUokkv?=
 =?us-ascii?Q?weJaPw8mOnyD/G2FryBk3fdUee09b9h73exaPlZMD+1IhzqPTYAOG3OLjM5i?=
 =?us-ascii?Q?MrB0HOB1fR4EC1zfeDIAz9/Ls0m6wVKPYGa6ZBXHNdosOByR3qcG91vk839k?=
 =?us-ascii?Q?jOh2w6ohlb2Lcmo/GbGmkZMDdOBdujkmkOjCiYMRnHUcWBv1C5PwqEj86/En?=
 =?us-ascii?Q?FXvuRmx6hA5bOWUg/Qov+O1ZCAGJ2A7A8Cqj4VlQRih9y4qb03RRZq3mw0pS?=
 =?us-ascii?Q?N83I3L9FubOpCI8BmFEFQ6YG9HfhDqIEQ3e5khUhjT2/xvC+iDTU4b/SXiZz?=
 =?us-ascii?Q?J/5OYso7/CvkR74yFKdkvMsfbmr146yFUE/xO3VSU+qQaOnM9VF8qt4pnyTD?=
 =?us-ascii?Q?7ueMXUY1I2gt5KvLN92KPu5a10ZHImIpL9bc9SVinaSMOqKV6LQTKrxvcgti?=
 =?us-ascii?Q?a3i4MofTvspexgHjytN5bGXZ4Ne4YdcN6RiMrORWQUfV8p0nwwtD99QVm6Be?=
 =?us-ascii?Q?GJowN9njP11Lz+EaS6IhP3mTAgfvwMTDT4jQMfKVz45cqkKCrCX23P4WMrJi?=
 =?us-ascii?Q?9h40nMd6li0UwTQpwlB0Nxgnk7eWOx4hbdq99ieJ8n9X33a/+KJWIFhiV1NB?=
 =?us-ascii?Q?pw6qt4uXgwGKgdB5akyk+pqshG7FAcra1nXZaPfSesQlc9BOLZg50Xc35UQB?=
 =?us-ascii?Q?6hZs8dQlPwKRRrigczEZBcrJHAGjUR3/SFaUi+dNnLFKHXONNktSlP2+Bs0A?=
 =?us-ascii?Q?5rTjkMWk9WvFsBX6OxGWTsQWNUVvksv2VFgj9VasM7Mlhu9QCxrtW30ae1nc?=
 =?us-ascii?Q?P8GA/F4+ErdpA3+1dgmWdn1gHhKXwl9PdgF/h5uyvwBFqDvSNXjLDZ4V/Euw?=
 =?us-ascii?Q?Eb5vK+28Bni0ke/u3PEU1+54nvD6EyjwzcbXbaOCyeAA86Xr0uOhb7LmTFoe?=
 =?us-ascii?Q?mrP0f1Cycx+1dCjgwH4KIxkEa+z6M/nNNtIz1OqCD56oXZSdw+Oyd+xOfLpf?=
 =?us-ascii?Q?QTmKdoMRyk6GWFUKlx7XTfar2jw5wHeuAUMt3kRLn5CiRfOKQiAhqKPD61Gq?=
 =?us-ascii?Q?hoS0VmjHP5UD0puv9DdyOPlopRHlh6c77QFENEhAGXt2ZEU+WapIMx294nCX?=
 =?us-ascii?Q?y4g/vjbYf2hwZSZZGQ699hEJkrn0W9EI0Q9ITHoDWHYfJ3wB83q6HTfnWLoL?=
 =?us-ascii?Q?NTiLvRoZ+ztVHB3DOaqKFtXCm38xAFhW5OFYIwfjoTq/NnFRQndlIv7XCfYV?=
 =?us-ascii?Q?fa1wKJzi2icYvwict6Ukgz8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ef49e9-834d-4760-e297-08d9f7960086
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:03:07.8598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0woUg7fwlEv0U964rZEncjf8gIeI+eZYe8fQ8zSGXfHYBHCrXeKQganN6q9vqmnMFFHth0oPJcCp8VZaFgJtwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2172
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240078
X-Proofpoint-ORIG-GUID: Hqx5XBJyw8A5OYWulns1oxXO5CVkumxt
X-Proofpoint-GUID: Hqx5XBJyw8A5OYWulns1oxXO5CVkumxt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit upgrades inodes to use 64-bit extent counters when they are read
from disk. Inodes are upgraded only when the filesystem instance has
XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c       |  3 ++-
 fs/xfs/libxfs/xfs_bmap.c       |  5 ++---
 fs/xfs/libxfs/xfs_inode_fork.c | 37 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
 fs/xfs/xfs_bmap_item.c         |  3 ++-
 fs/xfs/xfs_bmap_util.c         | 10 ++++-----
 fs/xfs/xfs_dquot.c             |  2 +-
 fs/xfs/xfs_iomap.c             |  5 +++--
 fs/xfs/xfs_reflink.c           |  5 +++--
 fs/xfs/xfs_rtalloc.c           |  2 +-
 10 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 23523b802539..03a358930d74 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -774,7 +774,8 @@ xfs_attr_set(
 		return error;
 
 	if (args->value || xfs_inode_hasattr(dp)) {
-		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
+		error = xfs_trans_inode_ensure_nextents(&args->trans, dp,
+				XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error)
 			goto out_trans_cancel;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index be7f8ebe3cd5..3a3c99ef7f13 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4523,14 +4523,13 @@ xfs_bmapi_convert_delalloc(
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, whichfork,
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, whichfork,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_trans_ijoin(tp, ip, 0);
-
 	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
 	    bma.got.br_startoff > offset_fsb) {
 		/*
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index a3a3b54f9c55..d1d065abeac3 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -757,3 +757,40 @@ xfs_iext_count_may_overflow(
 
 	return 0;
 }
+
+/*
+ * Ensure that the inode has the ability to add the specified number of
+ * extents.  Caller must hold ILOCK_EXCL and have joined the inode to
+ * the transaction.  Upon return, the inode will still be in this state
+ * upon return and the transaction will be clean.
+ */
+int
+xfs_trans_inode_ensure_nextents(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	int			nr_to_add)
+{
+	int			error;
+
+	error = xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
+	if (!error)
+		return 0;
+
+	/*
+	 * Try to upgrade if the extent count fields aren't large
+	 * enough.
+	 */
+	if (!xfs_has_nrext64(ip->i_mount) ||
+	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64))
+		return error;
+
+	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+
+	error = xfs_trans_roll(tpp);
+	if (error)
+		return error;
+
+	return xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
+}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 8e6221e32660..65265ca51b0d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -286,6 +286,8 @@ int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
 int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
+int xfs_trans_inode_ensure_nextents(struct xfs_trans **tpp,
+		struct xfs_inode *ip, int whichfork, int nr_to_add);
 
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e1f4d7d5a011..27bc16a2b09b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -505,7 +505,8 @@ xfs_bui_item_recover(
 	else
 		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
 
-	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, whichfork,
+			iext_delta);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index eb2e387ba528..8d86d8d5ad88 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -855,7 +855,7 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto error;
@@ -910,7 +910,7 @@ xfs_unmap_extent(
 	if (error)
 		return error;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
@@ -1191,7 +1191,7 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
@@ -1418,7 +1418,7 @@ xfs_swap_extent_rmap(
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
 			if (xfs_bmap_is_real_extent(&uirec)) {
-				error = xfs_iext_count_may_overflow(ip,
+				error = xfs_trans_inode_ensure_nextents(&tp, ip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
@@ -1426,7 +1426,7 @@ xfs_swap_extent_rmap(
 			}
 
 			if (xfs_bmap_is_real_extent(&irec)) {
-				error = xfs_iext_count_may_overflow(tip,
+				error = xfs_trans_inode_ensure_nextents(&tp, tip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5afedcbc78c7..193a2e66efc7 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -320,7 +320,7 @@ xfs_dquot_disk_alloc(
 		goto err_cancel;
 	}
 
-	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
+	error = xfs_trans_inode_ensure_nextents(&tp, quotip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto err_cancel;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e552ce541ec2..4078d5324090 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -250,7 +250,8 @@ xfs_iomap_write_direct(
 	if (error)
 		return error;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
+			nr_exts);
 	if (error)
 		goto out_trans_cancel;
 
@@ -553,7 +554,7 @@ xfs_iomap_write_unwritten(
 		if (error)
 			return error;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_WRITE_UNWRITTEN_CNT);
 		if (error)
 			goto error_on_bmapi_transaction;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index db70060e7bf6..9d4fd2b160ff 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -615,7 +615,7 @@ xfs_reflink_end_cow_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_REFLINK_END_COW_CNT);
 	if (error)
 		goto out_cancel;
@@ -1117,7 +1117,8 @@ xfs_reflink_remap_extent(
 	if (dmap_written)
 		++iext_delta;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
+	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
+			iext_delta);
 	if (error)
 		goto out_cancel;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 379ef99722c5..4d24977d6a47 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -806,7 +806,7 @@ xfs_growfs_rt_alloc(
 		xfs_trans_ijoin(tp, ip, 0);
 		unlock_inode = true;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto out_trans_cancel;
-- 
2.30.2

