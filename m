Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C336BC4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiLRKDd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiLRKD1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7490D65E4
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:24 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI7pKAP027146
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=1mb7kRqcNkw/e/bZlXNBO+wh8+ej77dACcQcJPKXleY=;
 b=dSgx8lhoeeVnPEbrGDYJb+NMlgALZRKSjeiikD+8ydt5Z2Ll0POTeAvYqQr011Pfs3m6
 GC8qdgjdKyDe8uXMhrA61zYpH0UH4NZ2AHh3HTp8rzRyWarGA8nSePa1HIvfC4FJFjC7
 93a4mDVhVpEF6ZxuqifbLV4gEHVDsmZQ5uPWTganKK01ZGVGGWuBlh4IobuiedR6W7Tb
 4hC7iNQRxDgqtTDyF1mpHcdgRoGUsx4ntKLrs96vsgvGMEQcp4zKjGQanpw1YqTOBt+h
 Z7dgvElmHPpKkbqTu/UgLi4poPZoifctJWxSZPioCxinBxF+ZFFQGnhhZBCM9Dlfh9YX AQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tph91x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI6Ek2O012691
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh472cfse-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTbhWHVG26ZdnBaigKdlqUi8oiu+WgDziy7nr01jrjk698i+59FrFuSomYsZb4KMSuCX0qlVL1YZ32QsVLrjvVkU95VzqkIRuxBauY4NWPEDO6+wUgDXEKMmPZ0wHaMTUuNoPPFjYkRHqxCfAI0Snxmg+bGXilg9P7mnyizlkBc/nb0pTqoGXj++cPOmCg7CliwrpfseMgZ28cI9uaiEo6E9xn6Ze7XIoR0RyA9r31Uy/E3kaneSuwECiEBI1ffymiIncDDVUX8bFj0KGbPnG/ceIN9TPLCiWM7KoV9kSJhGP8XsGdswL+e8oa3EDHGYo2QFwxFqretz6Sy4YZYqyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1mb7kRqcNkw/e/bZlXNBO+wh8+ej77dACcQcJPKXleY=;
 b=DHhlUjRx+lldljVJBKOpc72d7wVLqXqiS8CVkENLJTQKEHlaix+7Mxz6206JHUPZILSJyPlPsv1suC2mNfdU03mL5DwAJ4ukvoqUtxErqrqVPUQS47c5ntESE+uXV0B7NRE15M+hSQu1tV0utgp7l7YhSXr9lBY/rMOgahIueFOi0OqBxf2RXjUfScvCnDNSdaivIpAO5l2mc9QklYoMbCjVkCww5DZ3aXIynfmm/Hovz64HG3gQhIF5RYzf0gr1CxYV5O+0O/aJK2kY4k7MVBuH8ng3d9Iwnhoa9N4zyTv1LC1hig0qft40eaA7tEy/5pnx/Dd5NzRufZnp5LLWgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1mb7kRqcNkw/e/bZlXNBO+wh8+ej77dACcQcJPKXleY=;
 b=YkVzoW9l7HJSEEcF1bofHKVs/FbLBsuUmKrB4GbuobxGBgjBHfzlMClqbesrggDFPBYwXjKjfJYrqSAmS0tBlYsc5s0DrFAxlH45fgnF8jTZgwl5Rh4rG84VDUGAiE8emwqSA/Fc9qCuEsXGJMvQzT3NxT8RNB/g1dHIg+s7Ph4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:22 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 09/27] xfs: get directory offset when removing directory name
Date:   Sun, 18 Dec 2022 03:02:48 -0700
Message-Id: <20221218100306.76408-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221218100306.76408-1-allison.henderson@oracle.com>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0178.namprd05.prod.outlook.com
 (2603:10b6:a03:339::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 75a7e9af-abca-4a2f-574c-08dae0df18a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tWT5/jdfE2AgHSRfon9WUfIMd/LgrFxaSFx0ivc9uZLYfFKIfghJT5OEoiSmT6/v88tWTucXgKZ5LOhzDmghXXjSrTsf7mqPeL9HRrJmcHDzyoVl2HyK7oJJIplYX6jwpW+iIIGzE1ZFY871wdIZivy93FSbM+78N0Ge3jyHXZpp9DpXL6ht8/9yTOu3yqduKIXYV8NiJXrQ9SRswDwoOsSPhfDXXabK39bvo6wovi5ES6XBxq1IIvsnwmt8jcAx+tcEceEq0J0RLFl9+2dT1Rkj3I5jdV7MehBhjBOUmeRpCeIbSdxdO0MF6my5VEpy+lVm0TfID8blaGQkK+X6txQ68cQ436zeUCIH6i78jxdesX9s0lOtlm+7vlUitCTeuRJvGmaIus2LH8t7QteOdfeY9HhmTWIT6hQ71whgM7mtiq+G7Nz4+3nFL8lxrWlLpkj2VwYYmajBjH4NP69zMNMLR40zpYYK9nA9TwuwQtOQjHXz56arz+AYtj9P58HXU6Xa5WDJl32SIH7qReKDNixi1gBXlX8TY8A+8EqzTWR87CuSrGr/N0tzBOXIHtdJUEopcwVPqzXABgULIAHfcGf0s+4Ol3ONVDIl3o1wOCCfyyLJEPzvbVdEtRwu1nDXYII/T+XcEiMGBCh7Kk5UYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IZIpbYCyYqGx6Lp5CFmzitV4Mpu2e2V+clMCPSJ9CP4IexxM0FcZrqUOwC9f?=
 =?us-ascii?Q?eQ8nlPdp1HYnDxF+n5c50G3uVUSvhht6V/3nqp1NufeCLj6/nCp9B8PohWIe?=
 =?us-ascii?Q?cFfpPNENwHce0rR3MCoG3/1dM+IFvFkNNQ0w+aWDOjl2wPa6eNl6zReHvBlA?=
 =?us-ascii?Q?Cu2dDgGA9mMFVzlNjwZpEcW0M6791pvVKM+txyI58YepEoJGVkJXTB/7GmVz?=
 =?us-ascii?Q?idOp5et3vG1IaVLRToIS+fSyr5j5WIc2zbtLb+5j5X6BoyqThZdHjzE3Vi2i?=
 =?us-ascii?Q?9ogP66RQ1uVc45Di5U/l4AG16yawGS5yDyXHxmMwy6ndlqYpsGxMWtRBXDJq?=
 =?us-ascii?Q?3E26QR7kwDM2flk4uGFdp7s/f/jUepfu5SdUlPdv5uV3tm8sdSNKT1Arc1QY?=
 =?us-ascii?Q?WsKqEv5+GL8CjZS/vzJ4h9EExBOXKNkQWIg3iRjYfoNv9UbZ+/ZzmX/iG+A+?=
 =?us-ascii?Q?GmwoeoQq6Zp1N4msc/jOQMNldYom7A4aXcWEgLGXm3s8QAeLp5HqXfdVj4uh?=
 =?us-ascii?Q?VfXwqszqfmgKyDQR3Yj65gity+RloG83pifbOMGBdDMbIXxXsH+eSlFCApdU?=
 =?us-ascii?Q?a4DMlgbdb3cWqohCi9cJ1S+MH+h7RgxEbQh7pKPUoLftWG2u0IpfusO6BD1A?=
 =?us-ascii?Q?P0u5utKXl6IfA9mlXEa63w+OHAXWVpJCLJ29XgMz3+iSBDRbiHjQ47ArzS2b?=
 =?us-ascii?Q?wMc1raMJd/mxncQHXd29AUpDDlxkGij7MDz6xUz+r1kvf5nravQw9mmgVyPR?=
 =?us-ascii?Q?xLBSOCh/sjVJ3fbfUmt2YVe4pqCQ0dh6q9LU9yuNJyjOWo/BWnEhj1xOd7m8?=
 =?us-ascii?Q?FyzVfG44ttmOO6hhZAzxwvzhzccIEXuzW59jL7VLM4a974rFO9F2BK3118e+?=
 =?us-ascii?Q?0C2ACXa8vqGNNhiWsm/Ga0BW37PhaI8IYgdz+vrwCh/Lm4Yp4GOGo3F1hkqw?=
 =?us-ascii?Q?TRCphJrCeustp6Wx1l3TX8WTVTgAnNaCnQlcRWIqZwUTEzpgUy0OHZYzETU1?=
 =?us-ascii?Q?xUdT00swuWtJnlPIns3LjlTctYRqEzLdj/TLG++evECPkIjXALNNKJVxfpYs?=
 =?us-ascii?Q?E/dzuxUq2YWGP4+i8+lbX5+y9HnUSfkcSYrqJ0f5/FYCBWurdSIRkGOBfJ/k?=
 =?us-ascii?Q?QkL1Ql3eYIA/XnEcUu8v5wIqde6N+53KG5EVCQt8amjv6H5+rOlLHuffjqsg?=
 =?us-ascii?Q?iKSKHaAhRccEtsLj2WrrdFa5kj71RRVMGQTg5JwrD2PFHE9akG6cUerfxgEF?=
 =?us-ascii?Q?CXARmGiZap3ig3w05eDPsqhFqPqzEjG8FxI0q/bTZ4+wyIZnzcZcrOFb7GvJ?=
 =?us-ascii?Q?mXerwgdn5/LvYg0y7HTsBVtHvvwIAGbh6hsoLUgK0jcLpJmXckJhLz2UmOyZ?=
 =?us-ascii?Q?uBoBuC/OE+8t9FyGNnuA62bllr2kA3A3bKwdFTgg8qvEUhjGYUms7nFymz8c?=
 =?us-ascii?Q?6HyNheTUBmBbTHztSdoqBl7KPo+WuHwwuMfyo54uFtwHlLMVX2WVOBw26L0m?=
 =?us-ascii?Q?a8AZ4pJlTzxWlCxFi8vMkwjaganTcWzXDCg+qFMaSrOJ1SLxBhY4pBqcoDiP?=
 =?us-ascii?Q?AqIA9gQJGQmrK8fVjD50+gEJmx/Jv+ClP0+swHyigT5u4pu3ig+kGdicfjbH?=
 =?us-ascii?Q?GQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a7e9af-abca-4a2f-574c-08dae0df18a9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:22.3363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqepCGNJtG3/3MMWSkTCT8Z3XfVlk/yGzLT9GVpVuuC1vHD4vSVlrJlyH1IL1i+apou0uwr45E613IxwmH1yI7yZytMZPWbbHuGXXA2t/fo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212180095
X-Proofpoint-ORIG-GUID: nv-a84k0dfEtn0_UzDqVvgrSp7nad7G_
X-Proofpoint-GUID: nv-a84k0dfEtn0_UzDqVvgrSp7nad7G_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when removing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_remove.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c       | 6 +++++-
 fs/xfs/libxfs/xfs_dir2.h       | 3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c | 4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_node.c  | 5 +++--
 fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
 fs/xfs/xfs_inode.c             | 4 ++--
 7 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 69a6561c22cc..891c1f701f53 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -436,7 +436,8 @@ xfs_dir_removename(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	xfs_ino_t		ino,
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -481,6 +482,9 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d96954478696..0c2d7c0af78f 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -46,7 +46,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 70aeab9d2a12..d36f3f1491da 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -810,9 +810,9 @@ xfs_dir2_block_removename(
 	/*
 	 * Point to the data entry using the leaf entry.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	/*
 	 * Mark the data entry's space free.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 9ab520b66547..b4a066259d97 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1386,9 +1386,10 @@ xfs_dir2_leaf_removename(
 	 * Point to the leaf entry, use that to point to the data entry.
 	 */
 	lep = &leafhdr.ents[index];
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-		xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address)));
+		xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	needscan = needlog = 0;
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 5a9513c036b8..39cbdeafa0f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1296,9 +1296,10 @@ xfs_dir2_leafn_remove(
 	/*
 	 * Extract the data block and offset from the entry.
 	 */
-	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
+	args->offset = be32_to_cpu(lep->address);
+	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
 	ASSERT(dblk->blkno == db);
-	off = xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address));
+	off = xfs_dir2_dataptr_to_off(args->geo, args->offset);
 	ASSERT(dblk->index == off);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 44bc4ba3da8a..b49578a547b3 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -969,6 +969,8 @@ xfs_dir2_sf_removename(
 								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
 			       args->inumber);
+			args->offset = xfs_dir2_byte_to_dataptr(
+						xfs_dir2_sf_get_offset(sfep));
 			break;
 		}
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 29ebd4e2e279..6877266f6d7a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2508,7 +2508,7 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_trans_cancel;
@@ -3097,7 +3097,7 @@ xfs_rename(
 					spaceres);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
-					   spaceres);
+					   spaceres, NULL);
 
 	if (error)
 		goto out_trans_cancel;
-- 
2.25.1

