Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C7CC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJUW3v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiJUW3q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:29:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EFE4DB78
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:29:41 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDvHa004539
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=nRh/WH8oPKSwcTUc8CuARmREJcjSbcg0b24F3BSOyY4=;
 b=uAUyZdVahNbXjfVvUgr0gIeectUk6LU70tzvNY+oZk244MZf2s8BhUX0PsLD8MmqSHQX
 8BkQIn/f8YjNJyjHWCss6yuEetoyKMdXOrykVeCfXE78I4Uznah5uxZcTErHJSU400jZ
 CCBWd+cpSgmtIxbwSkuoVKChEpZ7ivxcbjjZWN/w5phy6Zjz89PpQl5SrTJy857G7iM6
 7uEV/4YU51SRnLg+BCOVq8/JiOqr6N6mZoA1QCyHxDOItJvP4XWwQaFIzx8dlJP3BABv
 5xvmwog/WbUmVQHOPOxxOeI30/G5ZqDzOjKvyPrfjxY77Mz6M+Nz9a43/hQ0agebQAYZ qA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mu0ajbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LJHLAh014651
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:39 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hua4x2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWfyWNGYrECqMWgpr75qKdQ/i0eKolt/3rviuUTtNVJAmn+/nk+uZctyn2/iQl+F+3Cy2Og7whb33HeemQYHalcX6LBpxdMPKBnUw7xyU61PlbHiSt75KAd05R8yCZQnj/rGYWozRAJJn4OsXI/ovKfNxwm9C/46Iio5Y5fiM789KdblzrBE1sreJnB893tdsor2Rb8lYlW/DViOT+f5TAacKgOe7Vxf442qyF63XWBbZmBM9VLYW9n8jWiEEwxB7hd+dRgI5VGAq3JL595fszJupTt2Aa5F8zMOAfgSBLGfDpR7lUY86EEOTKbhVJvRECNqBOfoVR2EdI/bQDll9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRh/WH8oPKSwcTUc8CuARmREJcjSbcg0b24F3BSOyY4=;
 b=YnaHYQdMrVTaBcohWEq5IsnHm6GslElsUGfYy0laN70f5vcz0MS2TyF5sKFXYvpHJu6GP5w/8qAXjNA4+zRM0CBI+PQy5uNrF1kep/BZOLeR5WVbbVqItm6niA/jZjpX3XKZv6cFYqv3YdTibArMYtIH0NSII0EKuysOygCawbO/sgzrw4LAGJ0stW49st/HTfDs9Nt/sTXCHb/WhgfOjwIaLY56eje9cBylXXMfBz0jt67Fgx40fjXY3wWvsdRAiohM6bQi2C5P8JsFcAc6/2QNrL6VOGJBNP87G5YYPQnRPrv5bybhQYWrXxwqqotSndXJfhWJvM2YD/xHTBo2TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRh/WH8oPKSwcTUc8CuARmREJcjSbcg0b24F3BSOyY4=;
 b=JuddOwExScl9XFSrIjjyEi8QzCYc4vhhF59cRV9jDoLogkdjvmOC3+YcGsxNalPTrGRpHFjZ2KxZZmzIK3IHgrfE1kDpdO3Fh/Dogwfmv2DyfvTMEpA299pX2nhhaT8i57dB5jhGI39/BRD/Z8t38uwGcK1CuscSvLEbkfUCa6c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6701.namprd10.prod.outlook.com (2603:10b6:8:137::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Fri, 21 Oct
 2022 22:29:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:37 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 00/27] Parent Pointers
Date:   Fri, 21 Oct 2022 15:29:09 -0700
Message-Id: <20221021222936.934426-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:a03:60::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS0PR10MB6701:EE_
X-MS-Office365-Filtering-Correlation-Id: d789ae93-5cf0-4973-bfad-08dab3b3bcfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZzqyLf/YSqmbQIPyrIeA2Gy5GwZ+//E0JnGLETonn/B8JNCGGRaySrwkb/JwjQUNedXJHDHLg7wwZ1gpXLhZ+p03u+fqF+W6rHDncU3IfjCa0zSY6eMduQW6QG3YmBoTmPEaDYJz6gVEfd2YlFR/f1B7Qq9rJf9DyigrNlq4dQIF7QM8kpPBJzChf7MpyMGgIuAFENgAohiZb7YsBCNesWhpUmX67sWY4XKE8c0uYOGdxBdXxA+JVm4547F3hpSN7eLrPuu2YRaqTqm97mS0xR6bxX8yKFYbkzAH55MdtKBKdqz3H45X1SE1xWWHGMYQiP7gB5wrrgsZNJdb8jFoHWmAeh2yAVyeGou43g23xKF6Kd0qT9XW2xlxqKZKx1/rx9z97rp261KxFm7vzMv/0DqxZXb/oB2n+TiRcfT9uTyRXRyAER6zVR/TRRErP9DeMsDuLkkSSNUHTbOV0jpURu3qaqg+tOzfxviploVCC6ZTylffiB6RT47TT2gRq6x3jhjsYbAQtWGeryApHkQq7nMzeWOshygvnrwdCLPTA2bTOGl1sRPGt3oWGmaflHHyLkAVodf7jyM/AQAmbFyCxcEtNP5M4dhQ+INduHSOuB/7O2ZZXYYu6fAql17aIUC/0N4NDERCcYVtTy87412eC1IlvYzL1CfVV9QR4X7l0yQ2nxcWTHk0SuVhuAoDJPSSdhmOJV+CmFZ/rOZ1i2cdjfsJ/2jj/fOsSl64H8fa0it693A+R/IbEbJChZo8D4usPA/rOBeZP8T+3ffjifb4hA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199015)(316002)(966005)(66556008)(6916009)(6666004)(66946007)(66476007)(8676002)(6486002)(478600001)(36756003)(5660300002)(2616005)(41300700001)(186003)(1076003)(9686003)(8936002)(83380400001)(86362001)(6506007)(2906002)(26005)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XSUzWKowXhesnT5fMkogF0wB6/rKDbKHRULjbitxajja4dRmBynlhdCnJjKC?=
 =?us-ascii?Q?khnpf+6JOy/TLdA+0dQH4h6KWMYqE4iwZ/SNFGCXSsJ3b+GYUTAYEGXvSE8k?=
 =?us-ascii?Q?yIJIt/TvgY4FvHSEuNFCcbkmZqOlT7wf4u5VoEp2FQz9fNmA0KwhjEcsPkbv?=
 =?us-ascii?Q?72FlEBrLZsElSabUDA7t92KTzAaGB/1t19n4BM5Qt71dsWO8PvtaHJ7OMJwr?=
 =?us-ascii?Q?NcHFsHov6+grApHOgDLT2QoDR0o3FVt9+NQKf89XJHbVn6WilL1RuvoEGgDc?=
 =?us-ascii?Q?HQ+ty5rDYU9H6QV9g8Ht67JXuyl6IweaK/3i9pV3N6Sz2/w+bzobR+BWZHf4?=
 =?us-ascii?Q?TcmM/5KFOiL+1r65KbxXaCZN4I9y/Asa2/q0mLjlaGRr9bw02PZPUiGq5zen?=
 =?us-ascii?Q?UdKvhhWBp5isUZ+lzPSyijAYpNh1IArl6/RBMq+0hq3vXawoCupZhxqsFD5M?=
 =?us-ascii?Q?nwz8lVFtlZcZYIo1NFegW4c6f6QQHBx5oycogWa5BSFmwh2PdzVmgdsGpvUQ?=
 =?us-ascii?Q?L/yFFoalamoQ8upB747oNNyOBMhlbmok2zdMUQ+C+0bkexpFAVfEXR6q9o4x?=
 =?us-ascii?Q?VVqC1Jv69sLArvhqkfUy+4MxzhPhyr+dkEsM0z4CBv06fLqijCnBBaa4y3cT?=
 =?us-ascii?Q?/1vsTxIgVD4pE1ci8Yacejd0I8mMNWMNGElVAgGPUA6JnQ23+jtlbCeW1KVP?=
 =?us-ascii?Q?KS/TKClCxdSXalF3r3Iwd6bRSl8lL7b9VfARi9AgpkPid08Z0DTNEx3IIFNe?=
 =?us-ascii?Q?L3Ez67KIZpHQGsZ+La2QJ+qNk9+df1x8guEAbTyhtdRNUcEbtx7uv7SQxTu4?=
 =?us-ascii?Q?ivemeS4IGdDqpVS8RWJc9icKOojBMAHFa3lFMCEWBzMTU8UXByPZBghh7mIS?=
 =?us-ascii?Q?nroqHoeSMsD4XOUcXUs7nadf9HQ/bhjLhMHj1UW3zbPzqjuSE3t3o4I7T5Si?=
 =?us-ascii?Q?pxvi9UJZ4UzYN96na1zbLTDTeP7uuU5812ZiRpca9XL3MKKa0WR9aZyR944z?=
 =?us-ascii?Q?v5/73GODtmUpQDILBhZMsY7i4Db0K/WZv8iziTMgcTCgbpV3a2sEENmwrJI7?=
 =?us-ascii?Q?nLnMvy/1JhccYsCh70pKzy4fbZ1DCff4qxErzRJHkrK8yzDIRIKEqG2GOICM?=
 =?us-ascii?Q?dfTNiJoy4is3lc//6RUyBBnuxar0KkmopgmZ29bucrulBLqOnfonNNUaNwUi?=
 =?us-ascii?Q?k4Yi8ll/i+06zDWfFY9CpGsH2L3pIrFOw1e7zSOkUqNhcxx2GDoYNA6W/pib?=
 =?us-ascii?Q?Z9KwukLUYHazDsQrcT4oLcodkTLcMPpd1Rut6pOftSUOJ4zH7yYhQjhnIh4h?=
 =?us-ascii?Q?rWRdZ1GSmDwgzDkDstEMyoATQK4Hp0z/wF6lwg5/xd87IjGZtSXyV7vMbVC6?=
 =?us-ascii?Q?oLTtNg05KIAqvvQFps00h/s3uQdHbLXReBwya9Zz6waxvRdK1+JOdPK5fF7n?=
 =?us-ascii?Q?e9EAxGhy00QIRH5XMJHm7vss9XQegQoNuyOu809Whsi3YI0tQdB45yDZY/2P?=
 =?us-ascii?Q?zyoqOpsn8PN2xSLCh01KIjkCg8svAhSrXdgL6xTxrGFJ3NWAzKM6koCWPW/9?=
 =?us-ascii?Q?gXAN9/v3aWJqjUx8KZt6qi1uqNfWstF/t63qNs4MdXS82CKGKZMhAAP3CZ/t?=
 =?us-ascii?Q?KA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d789ae93-5cf0-4973-bfad-08dab3b3bcfd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:37.9016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DfTSLn0bWxn8OK1x0lu91QSflexqkvCH+z+8Jer7AIDVLpZsBJNn9bY0gGpcWgXWi6JIAmg7RJStOk1Ezf3vICo9Tj8mJGEFDOT4uzVHVUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6701
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210131
X-Proofpoint-ORIG-GUID: CMYQ4192e8NPzAu-QNZAW2gbfnRKl-sR
X-Proofpoint-GUID: CMYQ4192e8NPzAu-QNZAW2gbfnRKl-sR
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
https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv4_r3

And the corresponding xfsprogs code is here
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v4_r1

This set has been tested with the below parent pointers tests
https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/#t

Updates since v3:

xfs: Add new name to attri/d
   Added check for new name length in xfs_attri_validate

xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
   Typo fix

xfs: Hold inode locks in xfs_rename
   Added helper xfs_iunlock_after_rename

xfs: Expose init_xattrs in xfs_create_tmpfile
   only expose new param through xfs_create_tmpfile

xfs: Increase rename inode reservation
   NEW

xfs: extend transaction reservations for parent attributes
  Added xfs_*_log_count helpers
  Refactored xfs_calc_*_reservation helpers
    Added iovec payloads to overhead calculations
  Removed xfs_calc_parent_ptr_reservations

xfs: parent pointer attribute creation
   Added xfs_pptr_calc_space_res
   Added xfs_create_space_res
   Added xfs_mkdir_space_res
   Typedef fix

xfs: add parent attributes to link
   Added xfs_link_space_res

xfs: add parent attributes to symlink
   Added xfs_symlink_space_res
   
xfs: remove parent pointers in unlink
   Added xfs_remove_space_res
   
xfs: Add parent pointers to xfs_cross_rename
   White space adjust

xfs: Add parent pointers to rename
   Added xfs_rename_space_res
   rebase updates

xfs: Filter XFS_ATTR_PARENT for getfattr
  Redone (new)

xfs: Add parent pointer ioctl
   Removed XFS_IOC_ATTR_PARENT
   Commented xfs_pptr_info
   Whitespace adjustments
      
Questions comments and feedback appreciated!

Thanks all!
Allison 

Allison Henderson (27):
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
  xfs: Increase rename inode reservation
  xfs: extend transaction reservations for parent attributes
  xfs: parent pointer attribute creation
  xfs: add parent attributes to link
  xfs: add parent attributes to symlink
  xfs: remove parent pointers in unlink
  xfs: Add parent pointers to xfs_cross_rename
  xfs: Indent xfs_rename
  xfs: Add parent pointers to rename
  xfs: Add the parent pointer support to the  superblock version 5.
  xfs: Add helper function xfs_attr_list_context_init
  xfs: Filter XFS_ATTR_PARENT for getfattr
  xfs: Add parent pointer ioctl
  xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
  xfs: drop compatibility minimum log size computations for reflink

 fs/xfs/Makefile                |   2 +
 fs/xfs/libxfs/xfs_attr.c       |  71 ++++-
 fs/xfs/libxfs/xfs_attr.h       |  13 +-
 fs/xfs/libxfs/xfs_da_btree.h   |   3 +
 fs/xfs/libxfs/xfs_da_format.h  |  30 ++-
 fs/xfs/libxfs/xfs_defer.c      |  28 +-
 fs/xfs/libxfs/xfs_defer.h      |   8 +-
 fs/xfs/libxfs/xfs_dir2.c       |  21 +-
 fs/xfs/libxfs/xfs_dir2.h       |   7 +-
 fs/xfs/libxfs/xfs_dir2_block.c |   9 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |   6 +
 fs/xfs/libxfs/xfs_format.h     |   4 +-
 fs/xfs/libxfs/xfs_fs.h         |  75 ++++++
 fs/xfs/libxfs/xfs_log_format.h |   7 +-
 fs/xfs/libxfs/xfs_log_rlimit.c |  53 ++++
 fs/xfs/libxfs/xfs_parent.c     | 207 +++++++++++++++
 fs/xfs/libxfs/xfs_parent.h     |  47 ++++
 fs/xfs/libxfs/xfs_sb.c         |   4 +
 fs/xfs/libxfs/xfs_trans_resv.c | 305 ++++++++++++++++++----
 fs/xfs/scrub/attr.c            |   2 +-
 fs/xfs/xfs_attr_item.c         | 115 +++++++--
 fs/xfs/xfs_attr_item.h         |   1 +
 fs/xfs/xfs_attr_list.c         |  17 +-
 fs/xfs/xfs_file.c              |   1 +
 fs/xfs/xfs_inode.c             | 456 ++++++++++++++++++++++++++-------
 fs/xfs/xfs_inode.h             |   3 +-
 fs/xfs/xfs_ioctl.c             | 148 +++++++++--
 fs/xfs/xfs_ioctl.h             |   2 +
 fs/xfs/xfs_iops.c              |   3 +-
 fs/xfs/xfs_ondisk.h            |   4 +
 fs/xfs/xfs_parent_utils.c      | 124 +++++++++
 fs/xfs/xfs_parent_utils.h      |  11 +
 fs/xfs/xfs_qm.c                |   4 +-
 fs/xfs/xfs_super.c             |   4 +
 fs/xfs/xfs_symlink.c           |  54 +++-
 fs/xfs/xfs_trans.c             |   6 +-
 fs/xfs/xfs_xattr.c             |   5 +-
 fs/xfs/xfs_xattr.h             |   1 +
 40 files changed, 1651 insertions(+), 226 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

-- 
2.25.1

