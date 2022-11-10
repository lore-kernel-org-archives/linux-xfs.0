Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A190EC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 21:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiKJVFl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiKJVFk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 16:05:40 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353E945EFA
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 13:05:39 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAL32KK003559
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=TQCC9K1TmAHLEvwWqo2cuvA5lsGVfnoPO4frfJAfNUE=;
 b=1j+ySODiuf8g2R8mt1Dpy1hP738z4tGq+KQ5k5YwbM/yVnbwEoVNu65F7FIsph0oQySS
 L9YYKPf74dhLMbzXZQyvpTwbLZI4blimYOge5Fg9UB3yEhdUgj0HWufeNbpL3/8mnrU5
 E44897L+yOK3S/G2NIPjEYohGzWRSlBmXPl8Pbcw2SyBtdcUrVvMTVm0jwRBSgDJ4Ao4
 wb5pndT98Exoc2QCh1qVjBDxXLRiI/QPTSJAs8kR53PP34VxxqZdOWwq/G5vz7i4F1QI
 PnKjDj1rz/A5cCfs3JpTSMfyiyAWRloBRY4acxyTgSETY9MM4xJYj3JkilnSCqnYS/3E uA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks8vcg08q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKg6LM038091
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsh4fbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 21:05:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIN7+4wWUR0kfHf0tQSe+I2Lf4N3ZK3Xh0latmrbY8zl02/1I8kWWBNtr9gZ/xpSRYoMKVMlvzqG/ojgcjw5RIWHSTote7pSIRcJ3vFAMmauln4hyxW6qkqEE0fsKk12SxkMnNoTJjhB6OoP+Dsfj7pw9y0SnKt5qiTY3ndugEnzwyZbPO80lBFqIHuNkI1mFMh6+t7se3pwd7Whqf20mI/bHoW0XuZAvqTuUSWY/2jAclrSWPpZHhPqv5WALqEqwhUPAYaZQOIUvdbOSiPVeAn83Bj/y4djbScTxJv3b8ofterxoEYnrD9i43eEh6R69lPlwN8R4rNZtBXcYLfF5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQCC9K1TmAHLEvwWqo2cuvA5lsGVfnoPO4frfJAfNUE=;
 b=hy9nGMtQxUIJOtGzm2oPbtoVlUpRA3E92nUJG1jc/Ii+QO9PW2k+CCrDr5QajImDgN0cqQfFX6NlWDFars7SeRiPvfi8go0SCh4X1bCjKYoVVIWKT+5hQ/NtHuzWnzwoIdbQsfaBueuBMOa5Uc+DbECMFl54mESMHYQQfYnV1HJO1ZvP6y8ZlZN8gYhm3zaoadOVwgvTpvv0OgFKCJbPGOPLPzVerT0dWhzrTkWGIop0az7+oCyjjv3dsz9w79HYo529rgw5VPlNptN1Dg0/dewkYfu7fOZscUuzu4LpkAyLiNgVoEULa3mwSVR1PpAQVwWkEBMJ0ArUednFPH457g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQCC9K1TmAHLEvwWqo2cuvA5lsGVfnoPO4frfJAfNUE=;
 b=c6tvkHBvYWp/DRgxv+DiEQ2Q6fAo+mLeVDW0pqfoPSrg2tcA7JP/1T5ebnsIIWTjqu9zche/beqTYOHVLSsOGKWEQLnwyYTlpzxy6XQsh6TiUamzHyPLHnJ72gPTfqlpsJ8vSyYRS8EvCIetuqVOO2YVU5jcB0rknubVMCO48qw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH8PR10MB6527.namprd10.prod.outlook.com (2603:10b6:510:229::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 21:05:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 21:05:35 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 04/25] xfsprogs: get directory offset when adding directory name
Date:   Thu, 10 Nov 2022 14:05:06 -0700
Message-Id: <20221110210527.56628-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110210527.56628-1-allison.henderson@oracle.com>
References: <20221110210527.56628-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0010.namprd08.prod.outlook.com
 (2603:10b6:a03:100::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH8PR10MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 864db92c-ef66-4416-546f-08dac35f4fba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+0EQpT43lJfbalDhZEJQbrwQMjKVhgWB5QnikOQPsuH7/qS6tRfjDNKh2Rs/xCXEF/BJb9FHlghABb378QcAWYeY89BFqNjXMMizOQMG4Hbl5Mkiz6QxySC5MBtW+aa1zkIKn7oc4xt5xqsHR7VFMWGhttHZ4sX/dSx+7hsgW0Y4TLhFxrKXkxsgUwmpz7yuOqN/pVu8V1Vjs0s0RJWdPyyGNMHQi5J63iRIUtIjRjRCnIpF3gquf88vl3YQzWlKlBJgzKC1nho4lVLWdIY/xFdApMRWv7b0FOU7xsv2GY6LD/ZOI9fMwqw/irt2ztwKeZcfUtfCzyX4d/SPM5NxR0Mr27XdCo/Mwt7se8lH1iUntIC/wl+dZ6rOT+s1sVP2hJsF2vhIpW9I0Ju4DdZO2y3U2Ub6LMoeErLhgWdfcgM+4ujemEi7DraYxfFxEiHPs2n/vaKFqE5GCkm2d2ZkeGVW7HdyJUL7QGUsB5V5GacO71nRSHjxYEtHc+WoK0B54TcdTPvYNX0Get3BCZp3b87hrOirLWD+6LTuqh8lFOlNPL1XKQZRGpyXblLIF0zSBy8B/VzNPohvjbFrqzolrI79Un37S30nGHc8iSpstXI/RHhTRcKHR8cS+aa8NUPhPLwBNs4NgnYhd3cx8XUp41jwHWdWtfLMV6aGqjDrJqPeHb5kKEZZXXDz8BPURaO0sZXhmC9pfhgvB1cO3q6VQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(1076003)(186003)(83380400001)(2616005)(478600001)(6486002)(6506007)(9686003)(26005)(6512007)(6666004)(86362001)(38100700002)(2906002)(66946007)(66556008)(66476007)(8676002)(41300700001)(8936002)(6916009)(5660300002)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zKmv3ZfGNXrWDAceSI+b/Z5ZrLmzHbedXwLP5iKUjxpuuECLtdJUshfGW/WY?=
 =?us-ascii?Q?CA4ENXJEJS21AlvoTgtlsrdXOXQCMmDbFQUnCFATkXftnzTiVw3/iALMthqW?=
 =?us-ascii?Q?hT2Xw0jUN4bacuMYKG74rr5t/vxVO9blQGR6Zz15mKsMpy+icxWcNkhI6mxj?=
 =?us-ascii?Q?Wppc9OTOYU5Q4xfJQjGQc+2VbBXTtPlUT10LSz5Tis5rPbYxKo4Uk150D39r?=
 =?us-ascii?Q?tAqSJRr+59TQj28twqZHnU2TXcTUzEQ7Mx3wvhP/+MMul3q9Hfnib+AYOEuv?=
 =?us-ascii?Q?FhhB7Q67mt2UqQIFWyJ+0gPTCJ0mspWlBhb97R72BJ9Ta7JehaBbTYkTvj92?=
 =?us-ascii?Q?Rtkm9Hj++TVMVstbk5tFmTy9HK+aTMCR5cy92V6bipS0uGTgTYQRdvEQSC8W?=
 =?us-ascii?Q?HU4//6gx/grp0ar/OB26m2sWzIdbrgwkwVN6xmxi1FjajMjJkuFpBYszk8KH?=
 =?us-ascii?Q?rknjrPuJ18leYPLdgBnbegPUYToAt+H1vbTqw71P71TxU9sG+l9qDFWzo0oA?=
 =?us-ascii?Q?zhZYkEUGyCghP8mBj3k8d3bHoXnq71ey57TrlWJM7st/CNFRo1JkKnoWatOI?=
 =?us-ascii?Q?eFFvmtnJpqC7Aqp19IxOOj6K/qN9sAdPQBkYw/CFL9CLaK7WdGrDsbSmW7BA?=
 =?us-ascii?Q?QD7tws3x/ELOe5bQariNKaIa9p4oIsmpLmGmJ+yWcO+hZTsf0SQLnsmoB7Gh?=
 =?us-ascii?Q?2NPCY8IV9G0feXMe/b+Vfd8IPfZntoxsKkCGlJwN1v1aT4uHnrBewOzs845m?=
 =?us-ascii?Q?xeqGUhvNQs/Fm0GPlvME1GCy+kkq9OkGnYiqjVc0Jzbg2aAj0/c9vfS+CWqX?=
 =?us-ascii?Q?1Am0zXYjkeqQ9zvTZT7qGkmrY3MxReACA54rW4vKJzy/WJ7EyknB8OEn/i/U?=
 =?us-ascii?Q?WZLY0zFGvs65E7Tw/OX9sSasC3OuvXfpiD9/30OCETg6ZR751HLhk/uMcSrZ?=
 =?us-ascii?Q?EFPMqu/aaR7U+2gckt8OB9g4YKr+Wn1n1b5LuY8KfQx3VxXmcagma+kqOQdo?=
 =?us-ascii?Q?15OKOdTaPsi42Bd1mzjOuoxatpHvG5y07z8mp/8T5bos9+sUF+c2CTPdIY1s?=
 =?us-ascii?Q?+hjBLF3voY4ozoreCl8xCsA2rif1vvDrxK2XWW7sxd+7ZxFtliOmx4/vSGp1?=
 =?us-ascii?Q?u21rZXAchhR1LA8/OXx2acWpIEz37YfiRAeRYrczcRvj+uS5IhFVS5mksQmV?=
 =?us-ascii?Q?dxXClRF/p7LfzMrh7DErhynDSRlfZY2U6sx0V0nhKKjwdP5ro5MoINVIIozp?=
 =?us-ascii?Q?C0C4/Porwvj77tCamTzQe2lP8Q90lYGNZ0HSaniutzpgzNqe7fOKkoZSC0so?=
 =?us-ascii?Q?bGB+g+VhD+wMzlgx5JTyawpq4hvlyX3uekh12stCV95VMJOJOz+4tklYt2cp?=
 =?us-ascii?Q?A0gkCNA/VjnZLSGFm08BIRM0wyACghG/5rFNazzPuJFmZDSGxlS90NoxhlJF?=
 =?us-ascii?Q?XzaEpV4syZbyu5yz4uFbfXxLJiu166c1M/UUJleqWajPUoYBlLtvHCLApWFf?=
 =?us-ascii?Q?kr50dJBM3D1NzV0yYSE4f0T0TRhjWj055E4JaJ7mzx0ESFipku5cPyjfO3s3?=
 =?us-ascii?Q?xih9btmrGBCgWizGV9H+9ueQb/f6gKU0D95/etx1/HuJJgvr5GwjmRGdL5ix?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 864db92c-ef66-4416-546f-08dac35f4fba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:05:35.4360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nJUPW3fdQAl5x/5LaYG9D0fW5cDSP1PLvEfBOpKAzRXhmIEEUa2KOQG8pXLcspeyEG/bc81G+AFLtugxnQ4O+WLYL4pUIS+EYx/Tqt6E8Rk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6527
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100148
X-Proofpoint-GUID: xJihWvaiqGb0gfQHmKG_BdY5eOIk_niE
X-Proofpoint-ORIG-GUID: xJihWvaiqGb0gfQHmKG_BdY5eOIk_niE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 libxfs/xfs_da_btree.h   |  1 +
 libxfs/xfs_dir2.c       |  9 +++++++--
 libxfs/xfs_dir2.h       |  2 +-
 libxfs/xfs_dir2_block.c |  1 +
 libxfs/xfs_dir2_leaf.c  |  2 ++
 libxfs/xfs_dir2_node.c  |  2 ++
 libxfs/xfs_dir2_sf.c    |  2 ++
 mkfs/proto.c            |  2 +-
 repair/phase6.c         | 16 ++++++++--------
 9 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index a4b29827603f..90b86d00258f 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -81,6 +81,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index fac072fcb1d1..93347cf24660 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -256,7 +256,8 @@ xfs_dir_createname(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,
 	xfs_ino_t		inum,		/* new entry inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -311,6 +312,10 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
+	/* return the location that this entry was place in the parent inode */
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
@@ -549,7 +554,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, 0);
+	return xfs_dir_createname(tp, dp, name, 0, 0, NULL);
 }
 
 /*
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index b6df3c34b26a..4d1c2570b833 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -40,7 +40,7 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index bb9301b76880..fb5b41792498 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -570,6 +570,7 @@ xfs_dir2_block_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 8827c96c189e..fd9c48d0879e 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -863,6 +863,8 @@ xfs_dir2_leaf_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index c0eb335c3002..45fb218f0571 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -1971,6 +1971,8 @@ xfs_dir2_node_addname_int(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 
 	/* Rescan the freespace and log the data block if needed. */
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index e97799b96fc6..56ee4ff4ebe3 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -485,6 +485,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 
 	/*
 	 * Update the header and inode.
@@ -575,6 +576,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 68ecdbf36325..6b6a070fd0d2 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -328,7 +328,7 @@ newdirent(
 
 	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
-	error = -libxfs_dir_createname(tp, pip, name, inum, rsv);
+	error = -libxfs_dir_createname(tp, pip, name, inum, rsv, NULL);
 	if (error)
 		fail(_("directory createname error"), error);
 }
diff --git a/repair/phase6.c b/repair/phase6.c
index d8b23ba5286c..f5f4fcea4bd6 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -973,7 +973,7 @@ mk_orphanage(xfs_mount_t *mp)
 	/*
 	 * create the actual entry
 	 */
-	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, nres);
+	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, nres, NULL);
 	if (error)
 		do_error(
 		_("can't make %s, createname error %d\n"),
@@ -1070,7 +1070,7 @@ mv_orphanage(
 			libxfs_trans_ijoin(tp, ino_p, 0);
 
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, nres);
+						ino, nres, NULL);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
@@ -1082,7 +1082,7 @@ mv_orphanage(
 			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
 
 			err = -libxfs_dir_createname(tp, ino_p, &xfs_name_dotdot,
-					orphanage_ino, nres);
+					orphanage_ino, nres, NULL);
 			if (err)
 				do_error(
 	_("creation of .. entry failed (%d)\n"), err);
@@ -1104,7 +1104,7 @@ mv_orphanage(
 
 
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, nres);
+						ino, nres, NULL);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
@@ -1151,7 +1151,7 @@ mv_orphanage(
 		libxfs_trans_ijoin(tp, ino_p, 0);
 
 		err = -libxfs_dir_createname(tp, orphanage_ip, &xname, ino,
-						nres);
+						nres, NULL);
 		if (err)
 			do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
@@ -1334,7 +1334,7 @@ longform_dir2_rebuild(
 		libxfs_trans_ijoin(tp, ip, 0);
 
 		error = -libxfs_dir_createname(tp, ip, &p->name, p->inum,
-						nres);
+						nres, NULL);
 		if (error) {
 			do_warn(
 _("name create failed in ino %" PRIu64 " (%d)\n"), ino, error);
@@ -2936,7 +2936,7 @@ _("error %d fixing shortform directory %llu\n"),
 		libxfs_trans_ijoin(tp, ip, 0);
 
 		error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot,
-					ip->i_ino, nres);
+					ip->i_ino, nres, NULL);
 		if (error)
 			do_error(
 	_("can't make \"..\" entry in root inode %" PRIu64 ", createname error %d\n"), ino, error);
@@ -2991,7 +2991,7 @@ _("error %d fixing shortform directory %llu\n"),
 			libxfs_trans_ijoin(tp, ip, 0);
 
 			error = -libxfs_dir_createname(tp, ip, &xfs_name_dot,
-					ip->i_ino, nres);
+					ip->i_ino, nres, NULL);
 			if (error)
 				do_error(
 	_("can't make \".\" entry in dir ino %" PRIu64 ", createname error %d\n"),
-- 
2.25.1

