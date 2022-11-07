Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0CDBC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiKGJCL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiKGJCH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:02:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52C0165A6
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:02:06 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75QkPO023463
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:02:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=xZgnshuie2KUFpdUcD3VP8dhUPy/T7jHe1sSC5ZgxXE=;
 b=uRd0qKeT+DnKXYauVyn9Ual3ZNFmBLpJ21c8ktcY7/vIaN3xzMJpaOVpZgnXZX/4J7Js
 nJh734ipYdZjwvw8Tw6LChCMzl4Dg3PldXSxn5B2E92kJiFw8dD1etJ+1cg6LHwRW/fQ
 BOJzI5PQH8ddj7ONgWMmFzO1bJKdxIb5dHL4GTi4R1FIQCqbbRCVNq5DgOs/XzohHlPQ
 0MiRJ6wraPeDLswXqf7bZH9Y1BzY0/1SIyw/Zld+dSb5srx3x1IQYVPjwvlQb4hHJfOo
 UqUvtlxldauJaEcRzS3fMeEFuIbAc18GO1Onzes4sZpm1fLWb/54591zAcZq3tRvucqM GQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngrek5a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:02:06 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77guUd023854
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:02:04 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsc2xrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:02:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0/l6rmEdLq2xvemPZnbgDGiqQ4+AY22sk0lWsLWfo7UDhphrlUBhyQpLbi1GlFCz5jqhXmAY4/Ua7kl54KU2N5A3RSa6drJVkFCH5QanIto00j3xy0gJpydZlo2fh17tOKCFnQhTntwsgo9Xtq8Kd2fpYf7t1mi8OpPgMoxSyuoplHxe+63zwL45XYJFnJg7wRy3yatOhnwr+nRxyrzayyQ8ZcaiPkUUliuco2vUahLm97JfhjcS6bLkjnctKuKpm0Q6TXLXNlWoiri289YKhazcAPNnwk0dW5fRZSiNqjBTiggm38QBfIm0LyIEe31wQFLJ7ZJTGVVi2AG0Ydhrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xZgnshuie2KUFpdUcD3VP8dhUPy/T7jHe1sSC5ZgxXE=;
 b=fUrS44YFYhl/bLOUTHei9iBOn4TiD8XMSpAJWkuBQMsAY3O7TL3lu+LTwzGt984S6D2OpTQO4NOSDU7z1tDEGIZaJhfzzjXUrizfLA7Vzzwpa8MXimxtTgSXtS4jBGQWOfqI6HS3nEU+qdVUHN4GNhg5Oy2dT0lKEuUgkVkOR7GiDWsNMRkuo3b0IKWNFtHLwWiuj+E5DsEBuboPguyUp71tJbRcDbqUFW2VmNx8k1P0w57NGfF1SZojm9VwCvf8jXWIBiF9aPYcf5cPgVuiPBFHEB4aPTfbtnfcMx8vCMMffJ1B8B5Hl98gMHkQb5M2TY0Dg+KSt4V4EtUEej+Rzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZgnshuie2KUFpdUcD3VP8dhUPy/T7jHe1sSC5ZgxXE=;
 b=QRn4zoGbgtIhR7QBBiUJXk2EYTjFpiDx2cOfaXpqZlj/OLtJC3ZP4dHEp66i/l72FyjjDuqEVauoy3KfliXyQC5iPXOhojUdQI3QGtkvX7Yrm91kXMg0HLpceS6j81uqPeMESImmNhvCYv2tIXXox8yOGR/fZa/UzsIvjb5PYd4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH8PR10MB6387.namprd10.prod.outlook.com (2603:10b6:510:1c2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 09:01:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:01:58 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 00/26] Parent Pointers
Date:   Mon,  7 Nov 2022 02:01:30 -0700
Message-Id: <20221107090156.299319-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0075.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH8PR10MB6387:EE_
X-MS-Office365-Filtering-Correlation-Id: 99cf95ed-69c7-41c8-fed0-08dac09eb9ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7H5WurI6q7Brsvs+qz0EsTtL1TuOzSQgGI/vE2W/c+vKd4/ugYAQdNJxGJ/4lCtZF2Dcqn8J5kKw6LVB9F88bZjJHFgHdP5lBHafnpuPCGVS2jszZWb13oNm04AOdVPc/fLPRNl1JONBXgVBZiwNzkAypKIF8gJB/nWGwfinyrEx48L0WtqOIPkD6H5imwdAkLLISLyggcP+tpqpxHcjy6y548ip4ebHgDcwZ3seRZkJZ0+Y9nU9OwWzz/NvhoT+xVyXC6BK/s8MeIDfnhADmaFAash5RSzOq8gXNnXH50GyLSpM+uzVMTBJK5F0GqB15g1bYZQSPXa/LcyeVaJ/4bGeOaaC0fmTa4kL+26dOLJePE8b/RmgFXXNrNIf6VqAGolpRpvoAKAJKMmyLZsh+QABaG/do5Vrmlsuy7/f6nAD9D6jDHHe0PtQaDTm6KpMMKvpYdMF34tWJLlkCD805cNKqunegwhE9dtS3nyghbJIb2zKOzQKnCpPtekdAsiLCPWcLKLPihnbSdz7+Vz7wqT5W95uAMkJ4suesOT/mpK6CKXhI8ylVQcIACa1vbTwaw0eLWUesiuwqCr/M2YbbbWOKSnWKrcdh/mQFLwgMZSNN4s2fJ/+AycI4CQubyackxBxnpsvx0M+InQd/hEfakOSCuPbrRBzddVlLXEIRf/0KB8zi/Vx9qoKGUOiJp2VvDy0Tfj0hwf0WT3nJefSKpipA0z/C92HhbWemI97+kt4+yYUAqA7ftYGghGDs2pXydIytididPsdPJHdG/Wngw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199015)(36756003)(86362001)(2906002)(6512007)(9686003)(26005)(6666004)(6506007)(2616005)(186003)(1076003)(83380400001)(66946007)(66556008)(66476007)(6916009)(316002)(478600001)(8676002)(8936002)(6486002)(966005)(5660300002)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ci880zSmIPbWSnvMTSpJT5WRPqa+JUv+RVBvG7oivSyGyD1UR1W4aoG9hIaZ?=
 =?us-ascii?Q?oVmZmO8U3LNVROuMW32RM6Qel1H2dpezoi/+thEO1XcCyKKRjPq68tovON7w?=
 =?us-ascii?Q?IrsXCeVm0CW7xmaiVKqCFwR9Qy7Lcr40iRfTJQuK2Iyn3WuuSNnPVp5WW5ft?=
 =?us-ascii?Q?ok1GkHnqD3za1CLwexd+oT6ImUkljTR/rImgHrpt2+qwOJ6SXMw+LzJajazD?=
 =?us-ascii?Q?OQiHUUzDM9B9ZWtXr5Vr2QDy6kuEhDCfzInOWqWLFyFyn1wuWburklQ8Od9I?=
 =?us-ascii?Q?mvpFcNWkGuOOgkVfMMkrHMBKS/BVsdqgWZCGTaKwC+ZGJorGb41nYgeTJJR/?=
 =?us-ascii?Q?g4c431tplEWwezjOBfE0EU2brdk7RemB5boH3MgHdcv9Awc+k3qmpmObC6g2?=
 =?us-ascii?Q?F/71/Yc+XASOx6kZnlLCGZ3EYKa6n/cWUYcimPi2MwITtGqlqaS11995yfO8?=
 =?us-ascii?Q?4xLeJO0d4sBzv+4xLUmO2G1E1uEsAd2LCaEZNG3XQhv8xG49+DE/iHf9c0xX?=
 =?us-ascii?Q?60ZnOJvzdundCwh4aLE90Rh4+tA188OUhkd4QCoVL16fDebhTAEp/JV8b3pG?=
 =?us-ascii?Q?zm3A+l5jb3nSDWlgTnssyQOi5rmW+D+0KTZuXdYJWsKX6GLc+yh4Jocjwd/7?=
 =?us-ascii?Q?e8enK4ziH3d3sBMlFHn8cp1e4T1hwz1bFk1dE6fqF8Kf5BAEcJzIpaKG0d9h?=
 =?us-ascii?Q?H9G5MhhbhU9BztLU2/WNUzwGEQJIIn5dp5a41lTYtZF2BLsE6KcOQ62xQXJ+?=
 =?us-ascii?Q?XpfJlG2w85cMq9vdIz8yOdmJG4u3C6tzQidVR0X2JesboetkvyUMUZOI13NV?=
 =?us-ascii?Q?NeyB4/VLb3caK1jOrWPpaG9+uNd1n5vZ2MfhPov2dqk/Jr1VMUkOsNTOiSF/?=
 =?us-ascii?Q?IEtDeAJTH2HPRjOXd11/6WfPeUzEoMVTNnCAsw0t0hpPZbssWKXCRtR1l+ud?=
 =?us-ascii?Q?aSfhIIbHnZSzI+63PgaZqz0qI+8fcvUM+DbN1nT2zZkYVs30vTV7rVxwzumo?=
 =?us-ascii?Q?Mdpmnvn7oZryXaBzyrJAvWCdXjdEy3SFn+WuUHI45DVy+u1MeZn8wQ9e3Z9+?=
 =?us-ascii?Q?a2p5vcKiiQEb+N0jjJW7gYv1jYikhKMnt1ub0gYfRpx0rLJAmZ7sJdz3TD3F?=
 =?us-ascii?Q?wCsBjcUv8tyTRwELh/T0rSOhQjMdOaCvgP6xF02HmayzXM79jQ9dptPBs0ks?=
 =?us-ascii?Q?LFd6NUXwVSrl5Sk1olyhCz0QliZshvssRgVZDCHAXdzLyxCtCzIf1Pd7v+ir?=
 =?us-ascii?Q?b1Hxa2F/POU1g22NqMri7SjVHKf4eIs1/AVvkQ7rK7A++4KoQNNUnmZyE286?=
 =?us-ascii?Q?8DP/Bric05XLodZ0cTodcy9pqpTSwhRIcpY5ctSJ4i/carpMMKh6ve4UX09Q?=
 =?us-ascii?Q?r7PsrSRh+4nkUNITwlwyyN32AAE13WeLBdrlafYLGB0QTmjy7n4cXMw4iZki?=
 =?us-ascii?Q?GFoTJQBltDtPSzdLcz427weWSh8+Oq5bKSuBZ76PQt77usSrVa6saqTB6owc?=
 =?us-ascii?Q?SFY3f7888Xz8pWIKXkFlEmUKwgzxOqTJpjZtnwLqQq0yhIML/H7YVoWqa9xC?=
 =?us-ascii?Q?EqxEi4Pr7+vkWM4+AOFQzbBKXrzmLna4QL1mferCFiI4jftS2RhL264i2ycL?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99cf95ed-69c7-41c8-fed0-08dac09eb9ab
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:01:57.9807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKXrMecZAbWj+Zr2VC++iu9ix9iqqQ6PP1nDKHTmjqsmkF9Ao5iYOBNZlDsbS/wwh6aw5BaX6YjfV34fFY0ImhGkFCZ9yKOTeGhIEvOP9vI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6387
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-ORIG-GUID: SSNQvFerYljnn7B1s_BgI7EBO_2FDaFx
X-Proofpoint-GUID: SSNQvFerYljnn7B1s_BgI7EBO_2FDaFx
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Hi all,

This is the latest parent pointer attributes for xfs.
The goal of this patch set is to add a parent pointer attribute to each inode.
The attribute name containing the parent inode, generation, and directory
offset, while the  attribute value contains the file name.  This feature will
enable future optimizations for online scrub, or any other feature that could
make use of quickly deriving an inodes path from  the mount point.  

This set can be viewed on github here
https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv5_r1

And the corresponding xfsprogs code is here
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v5_r1

This set has been tested with the below parent pointers tests
https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/#t

Updates since v4
xfs: Add new name to attri/d
   Removed 0 item count check from xlog_recover_attri_commit_pass2
   Moved error reports into switch and converted to corruption reports

xfs: Add xfs_verify_pptr
   Added const type to rec param
   Added xfs_attr3_leaf_flags needed by libxfs port
   
xfs: extend transaction reservations for parent attributes
   Refactored xfs_calc_*_reservation routines
   Added helpers:
      xfs_calc_pptr_link_overhead
      xfs_calc_pptr_unlink_overhead
      xfs_calc_pptr_replace_overhead
     
xfs: add parent attributes to link
   Removed unneeded defer cancel in xfs_link
   
xfs: add parent attributes to symlink
   Removed unneeded defer cancel in xfs_symlink
   Removed unused macro XFS_SYMLINK_SPACE_RES
   Whitespace adjust
   Comment updates

xfs: remove parent pointers in unlink
   Removed unused macro XFS_REMOVE_SPACE_RES
   
xfs: Add parent pointers to rename
   Re-ordered this patch with cross rename
   Added old_rec feild in xfs_parent_defer
   Collapsed old_parent param in xfs_parent_defer_replace into old_rec feild
   Renamed ip's to dp's
   Re-ordered xfs_parent_defer_replace parameters
   
xfs: Add parent pointers to xfs_cross_rename
   Updated calls to xfs_parent_defer_replace

Questions comments and feedback appreciated!

Thanks all!
Allison 

Allison Henderson (26):
  xfs: Add new name to attri/d
  xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
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
 fs/xfs/xfs_file.c               |   1 +
 fs/xfs/xfs_inode.c              | 424 +++++++++++++++++++++++++-------
 fs/xfs/xfs_inode.h              |   3 +-
 fs/xfs/xfs_ioctl.c              | 148 +++++++++--
 fs/xfs/xfs_ioctl.h              |   2 +
 fs/xfs/xfs_iops.c               |   3 +-
 fs/xfs/xfs_ondisk.h             |   4 +
 fs/xfs/xfs_parent_utils.c       | 124 ++++++++++
 fs/xfs/xfs_parent_utils.h       |  11 +
 fs/xfs/xfs_qm.c                 |   4 +-
 fs/xfs/xfs_super.c              |   4 +
 fs/xfs/xfs_symlink.c            |  54 +++-
 fs/xfs/xfs_trans.c              |   6 +-
 fs/xfs/xfs_xattr.c              |   5 +-
 fs/xfs/xfs_xattr.h              |   1 +
 41 files changed, 1670 insertions(+), 236 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

-- 
2.25.1

