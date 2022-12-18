Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD4C8C4167B
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 10:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiLRKDW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 05:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiLRKDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 05:03:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC027D2C3
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 02:03:11 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BI7xUcx026765
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=VdtljPiOYGqpxQ4/00ftaYKUCh7ky/1+TS3eJxCfPQw=;
 b=MFF/84Cjq60IqGGmUqwveQSmABupuZ0RA3V5mdLDGTL1GmWGGMmEbIpbtbJiGVmxkgHF
 eofkkv/eF+0uiCUKMPijxivSdurlgDedikVV0BtQYJjKYCmfiNW9mvgIlPu0j73fI8mE
 vmWdrjhORX3ps14pcHzYAFoGXdDZgzXGC7b5YcJe27HxO1oVQFYfgnckvCHBodwubQKu
 n4b+eQVaNlYHYwr0jQDYWGtCWPuRmJLeI4X7YpRPA+omRZ4JI02JSgGEHa77x8RbocZB
 S0Cqx3tpWg/nIIssIda5nALYQebtSV1c7d5sdCXywGndPobIBqycPatjkK+yM9fL4/a0 /w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tp190y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BI7bW3c007157
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh479cbhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 10:03:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=baZbGJGkFfHZ8paruNLBmRD7I4xnfTW/b+EDJEZ+mSL55h+55Niz/E/9LyGqpN12GMwrjhmJFBw9Ysf9I2Q9Pi+KbVCqHg8CbDfgM99QEWY5glf1gdNyztN+uauke16nKPs9eRAdr7J9ivN6ZDzvRUtAkaTfgS+4PvLfR163zZExNYbJhm+j2ycp4Npe8qWQObkzL+0Z7YKPCaFJtE7WkK+jwxGvujzuOmJZKVnvYEKvgftSsDMEkcL7ybM2gbiO57n86A9cDJRufSz54oX2ldK2kSOaOzE/ZKmiIqQQYTHCSenAprfV9nKBLazNiRwuJ9O8yO0AAoSewvGPLKsMpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VdtljPiOYGqpxQ4/00ftaYKUCh7ky/1+TS3eJxCfPQw=;
 b=IiJMm7nLKdbLz87RUAw37v6M+KjdTSJFawf4EnrjR4UnGf4N/MpZbmWMh9VhGEYODYRPc4hhG83HuhKM6fHdo4FTND+ava+EGcouvcJ3NX/CwfkW84ndsB4V9FYF1e3J2g58XhSYILipK6uirqvEjaDTCxlemXisv1wFscFSKoeNMHwCrnAEkUmab7s+6f12nduWhBtCMDl/p0o/csxVElC1iqe1T3AXbRjPxR/JTvHDL5p4mqj2qveyeEZSO+LZYTbohGfGyJEsBjqaFSTm+/7YtVY3IknUb0XBmZy3AstsFFpNmWSBGLaJ1Gd4mwr55WAes5bq9SRfr+geKu618A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VdtljPiOYGqpxQ4/00ftaYKUCh7ky/1+TS3eJxCfPQw=;
 b=aXoXsaBjyBshI87m0EphUni2F+5kCkJFRIKP+wKc89uFAi5fA9XX9Mu4S6aV5NLxytFMlqB6JdAQEW5weRh1tluTC0lFC/jlsIMKWPL1AgNAJa5ozK/JXi0ohAT+c8a4AJy/bcQh5Nrk3y/erOPZxVLaxk/spfomTE40bsqUB3c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 10:03:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 10:03:08 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 00/27] Parent Pointers
Date:   Sun, 18 Dec 2022 03:02:39 -0700
Message-Id: <20221218100306.76408-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:40::30) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 4325b8b8-c461-4546-6a5d-08dae0df103e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZxwlYeso9OKfG4MHajyhcDlmpEDScmUoXpUUrRcfFWCcxUhcFrgkprgAmBIlBg7f1Ubfl5m0guWijaqtNtQt81jeCplIsg6KWSBcnnIQrY0hp5aIBM6+3qKPBLsw9k4M6BkZNnmJOaOI76+QexIjB3+E6KdQCvraG7B8cWK2S8Gx+PlDK6b3OkoDnRAaq45R7MnHBpfkAqKrRO4MHG+AB1QaiugZjAP20Akk0CLfqc1u8gAl4DhtMIHy0FlK5rTzBw/UXBIXQ1zDSUNj38Akwhtqyl6lERwDOxpCulswGU71fk8XjPFMnkAm1ccBpZo3sMvvW1427rb0q5RQD9I6OWHm9lFICPkl4lvj2uT1PQIaRhszNUNf0kM+4Ak3TlLcIqYR36rDgB0JdnHP+LWStqFS6EZfzBT+IROAHLp4DxQi5szCQgMJDIAlTlZfEBi13hycmas01+f3YAd/oxaDnEw4dbnANpFCtZIqI7ik6WD2sasy3AdnpLuDwAhShhQkJ6ggrmHQ45Upot2HVyZfi2F2CLVRZLr2KDEduCaG7oqzBba7bSQ7ZiSsCCjFc4VqTE8xx8fglxOSPT0/GHyKVCfm1qvLwbbsJT5lCvZjAmlrU6IdwT7K1+t6UpS2T4fzkFto/RrfR5PuVh/7YLSO4VhOsQ5aNkt6QRAfFRunKrPWlKc5FPVgkKpptUUwiu4hVXsWEUk8VHBWh2eEYP/ZIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(66476007)(2906002)(8676002)(66556008)(5660300002)(66946007)(8936002)(41300700001)(1076003)(9686003)(26005)(186003)(6512007)(6506007)(6666004)(2616005)(6916009)(316002)(478600001)(966005)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NwIWM2O09FEHLlg6HPELwOR6xPU3fyMvhrLWmr80q1bV4K3j6pguiypT3cnO?=
 =?us-ascii?Q?bniS+9lVsyFMrerT7YnRVKMKbiJbWZ8PIvQwHu2JRt+7wOL595+/KxTTe41c?=
 =?us-ascii?Q?m90SHVQSTrfLRwy/n8GKGEkkOJNXhn54s3JydUQ3zRRndnrOLClq8HrO/Dhb?=
 =?us-ascii?Q?TYkRunKA/dm/PG4h1cjMhBRoY2wHfpPC/7nlWSqqmFGwluPhNOr0EMiQ0o7t?=
 =?us-ascii?Q?CnyS6xwmelnbwifAJq3f5Zt100Iv0RiWDeS1TOal1O687hZs+s9nkUzS/wNP?=
 =?us-ascii?Q?xZRZI2zDgbRY5SCeR0Y2BzSuR2mMthCuCAj4aemNS7dp+boVqVYVX2Nq65dz?=
 =?us-ascii?Q?/X7XY+y+6u3kFM2XvnVxt2cOroo5pOF+GTQvtgcx8hl0GiinUz1w+3Tb3j8j?=
 =?us-ascii?Q?frVTEa/9EHcrc4BbQEReWqUyyBMIEqwK3Rx3un69iUWP0SZarKDQwfdYmCVT?=
 =?us-ascii?Q?HMk0Qv9sb3/mbuo/jI/dlO5T1R834iuLhpvOzP2iiytHCVMPkYHmKm+78YlA?=
 =?us-ascii?Q?DxnTPvdTNab+yORUJ0e0u04zmtgMNsqUzKzd5rGFjMwHCkLk+L+yJGJH3CQ9?=
 =?us-ascii?Q?VAwr3CcpGl/qHQGHbGBJmuWTX0Pws0NmmRoXc2YoluIRHnYrGzxaJzNjGTKb?=
 =?us-ascii?Q?Z3RkYHOxHxu80Txogz3X3T4wRx/CgKHt7PTUZS6OLi47t+CeZOBgkfdDwFrk?=
 =?us-ascii?Q?TGg/WuvkJzccxJTBraRlMH+G/hZcnaraJuig1Jb7uYRJlNe0ougICWqpBliX?=
 =?us-ascii?Q?G/uo+PQG4XEP+zH5UbXRDx0faJbE1Em6Y9rR523DZ46SFhZVA3j8zpvx35ON?=
 =?us-ascii?Q?J9A9B4CukjjoR8FbTILxzpEYwOCQKR5I5dJPQ2469vhsL1IxMJKGsMa0PBkd?=
 =?us-ascii?Q?h5Nmwu4YiZFkXl14q+yvtdL4jVhUsvWsWSr3SQjLtFAPfQXjFTxMxL2XqVR/?=
 =?us-ascii?Q?cUdh19OUeKxne3xQ8R90o3/NOqUjcs03g4VJstC0nN7mY65VV2D0feQF3teN?=
 =?us-ascii?Q?Q3sh6q2rv3Uzy6Pfue0dkhP0+990UZPLyboz2sR0ooT3540yAeKOGyxA67DU?=
 =?us-ascii?Q?CaJqSF8qmVQLVm2gndQHhLENWDHNqPWqbC6B/nqRZAnPFGk37GidmlOJ/X0N?=
 =?us-ascii?Q?MOVAk464bSl1ZFva8acoQCbf4BE74kg+bcSFxi/TwLd//r6MSKHZFRbxauAU?=
 =?us-ascii?Q?5WRTQDS0wZ5LDAUh8kgdg6MUj1HUwmDWOo8qE5CseyKjNOUYryi1NnvtyF4d?=
 =?us-ascii?Q?SsvvKB0zqGqttGf5p+itId+GLrLpPDELxmTP/uK+JHbZUlfAz+awhGq/rmhY?=
 =?us-ascii?Q?Mb1TA4GdXI1dr7s8Vdq6ndbL0o6q0BgzGS1rjBWv35jR0lX3SL+YwYC930/K?=
 =?us-ascii?Q?dWBVx8OQ9f474CY1LrJj7RpEbGELLVN2lnslS2ci5OX7+x4HNbq/xLlrdQ0H?=
 =?us-ascii?Q?Rqq8Vl+ZbjvlRDozQdiLSoUCp2EM7mVCTjBnYZWjS+GFZZ5jV1JNxw5hCBAR?=
 =?us-ascii?Q?fsInXwcSzOKk1wF+SLQCvJPJ/o8o6pR/JORBC0WfzgZeqDQUONFGrbiLVehD?=
 =?us-ascii?Q?bAuAsLJmmhAHm2Ycze8TzvClvIMJ1FufeiHm0OIvyAQYh9UnZcVuehUFYT/x?=
 =?us-ascii?Q?oQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4325b8b8-c461-4546-6a5d-08dae0df103e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 10:03:08.2294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +8Zu0+qRhsflmszbGmRz84o9FZncVcx6eJJkScIMOyXnkoiN03ooZikC7eChh6BbeAtol1fGPhUFKZVU3Gmgn7slG4EPCfWT5T9K4uDfrXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212180095
X-Proofpoint-GUID: Yt8Gb8seiyS3iHfPzUuxM29XDxWLL_X7
X-Proofpoint-ORIG-GUID: Yt8Gb8seiyS3iHfPzUuxM29XDxWLL_X7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Hi all,

This is the latest parent pointer attributes for xfs.
The goal of this patch set is to add a parent pointer attribute to each inode.
The attribute name containing the parent inode, generation, and directory
offset, while the  attribute value contains the file name.  This feature will
enable future optimizations for online scrub, shrink, nfs handles, verity, or
any other feature that could make use of quickly deriving an inodes path from
the mount point.  

This set can be viewed on github here
https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv7

And the corresponding xfsprogs code is here
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v7

This set has been tested with the below parent pointers tests
https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/#t

Updates since v6:
Andry had reported intermittent hangs on unmount while running stress tests.
Reviewed and corrected unlocks in the case of error conditions.

xfs: parent pointer attribute creation
  Fixed dp to unlock on error
  
xfs: Hold inode locks in xfs_ialloc
  Fixed ip to unlock on create error
  
xfs: add parent attributes to symlink
  Hold and release dp across pptr operation
  
Questions comments and feedback appreciated!

Thanks all!
Allison


Allison Henderson (27):
  xfs: Add new name to attri/d
  xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
  xfs: Increase XFS_QM_TRANS_MAXDQS to 5
  xfs: Hold inode locks in xfs_ialloc
  xfs: Hold inode locks in xfs_trans_alloc_dir
  xfs: Hold inode locks in xfs_rename
  xfs: Expose init_xattrs in xfs_create_tmpfile
  xfs: get directory offset when adding directory name
  xfs: get directory offset when removing directory name
  xfs: get directory offset when replacing a directory name
  xfs: add parent pointer support to attribute code
  xfs: define parent pointer xattr format
  xfs: Add xfs_verify_pptr
  xfs: extend transaction reservations for parent attributes
  xfs: parent pointer attribute creation
  xfs: add parent attributes to link
  xfs: add parent attributes to symlink
  xfs: remove parent pointers in unlink
  xfs: Indent xfs_rename
  xfs: Add parent pointers to rename
  xfs: Add parent pointers to xfs_cross_rename
  xfs: Add the parent pointer support to the  superblock version 5.
  xfs: Add helper function xfs_attr_list_context_init
  xfs: Filter XFS_ATTR_PARENT for getfattr
  xfs: Add parent pointer ioctl
  xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
  xfs: drop compatibility minimum log size computations for reflink

 fs/xfs/Makefile                 |   2 +
 fs/xfs/libxfs/xfs_attr.c        |  71 +++++-
 fs/xfs/libxfs/xfs_attr.h        |  13 +-
 fs/xfs/libxfs/xfs_da_btree.h    |   3 +
 fs/xfs/libxfs/xfs_da_format.h   |  38 ++-
 fs/xfs/libxfs/xfs_defer.c       |  28 ++-
 fs/xfs/libxfs/xfs_defer.h       |   8 +-
 fs/xfs/libxfs/xfs_dir2.c        |  21 +-
 fs/xfs/libxfs/xfs_dir2.h        |   7 +-
 fs/xfs/libxfs/xfs_dir2_block.c  |   9 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c   |   8 +-
 fs/xfs/libxfs/xfs_dir2_node.c   |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c     |   6 +
 fs/xfs/libxfs/xfs_format.h      |   4 +-
 fs/xfs/libxfs/xfs_fs.h          |  75 ++++++
 fs/xfs/libxfs/xfs_log_format.h  |   7 +-
 fs/xfs/libxfs/xfs_log_rlimit.c  |  53 ++++
 fs/xfs/libxfs/xfs_parent.c      | 207 ++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |  46 ++++
 fs/xfs/libxfs/xfs_sb.c          |   4 +
 fs/xfs/libxfs/xfs_trans_resv.c  | 324 ++++++++++++++++++++----
 fs/xfs/libxfs/xfs_trans_space.h |   8 -
 fs/xfs/scrub/attr.c             |   2 +-
 fs/xfs/xfs_attr_item.c          | 142 +++++++++--
 fs/xfs/xfs_attr_item.h          |   1 +
 fs/xfs/xfs_attr_list.c          |  17 +-
 fs/xfs/xfs_dquot.c              |  25 ++
 fs/xfs/xfs_dquot.h              |   1 +
 fs/xfs/xfs_file.c               |   1 +
 fs/xfs/xfs_inode.c              | 427 +++++++++++++++++++++++++-------
 fs/xfs/xfs_inode.h              |   3 +-
 fs/xfs/xfs_ioctl.c              | 148 +++++++++--
 fs/xfs/xfs_ioctl.h              |   2 +
 fs/xfs/xfs_iops.c               |   3 +-
 fs/xfs/xfs_ondisk.h             |   4 +
 fs/xfs/xfs_parent_utils.c       | 125 ++++++++++
 fs/xfs/xfs_parent_utils.h       |  11 +
 fs/xfs/xfs_qm.c                 |   4 +-
 fs/xfs/xfs_qm.h                 |   2 +-
 fs/xfs/xfs_super.c              |   4 +
 fs/xfs/xfs_symlink.c            |  58 ++++-
 fs/xfs/xfs_trans.c              |   6 +-
 fs/xfs/xfs_trans_dquot.c        |  15 +-
 fs/xfs/xfs_xattr.c              |   5 +-
 fs/xfs/xfs_xattr.h              |   1 +
 45 files changed, 1712 insertions(+), 245 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

-- 
2.25.1

