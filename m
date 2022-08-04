Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 281F6C3F6B0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 19:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbiHDTka (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 15:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiHDTk0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 15:40:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA38F3D
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 12:40:25 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HblYQ018712
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=6n3MJAg/M7TybnlbLOdoJpjb9Xt9Bdqw7fUiwHU0Jpk=;
 b=K9OQNhf/ReasJlYOxDZPhmGjl8wqm+muYi2UKsKF2T/vK/pBG+a1GEAhRKIUZ92ekdBb
 1o61Bvx6puq8qKne/i5amRg7IazT0ZX6kjHyzrUqy3jnAolaw50rPX+xtrAI/yoxCF88
 PxLFJK53aAC56OGPvlbpW2SGBfipSEWkvPzy4oV+SQbJX1cugcrJiuH7nfncoTNdCj9i
 zwcLV/K4tKkPm2lo6X84Qw/g0sjZ0WJ6NGdXO15TLDCJr68STpcvOV2lmvKWDJmyLNZE
 O9CzO0kCq+3CJCldSfmCI+vcsUh7LGWVQi1m/x6rE2gAYptpUlzB13pSwooSTs8t7g+0 qg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvh9wmya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274IEkVj003021
        for <linux-xfs@vger.kernel.org>; Thu, 4 Aug 2022 19:40:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34n716-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Aug 2022 19:40:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkmPovkKrNHRtGRyDVMRsAhlL00KlYw9YCok11p39TRDcZa/B/v3V0RCK61QW/4VSKWSZ6Mwy5Y5JuifWio1y84MOYPotK2iE9Lia+JF5hDzPKW/P+v/l9BImlSiDT1VzeXx3b4nMexrn6gz75IfD/COt9SrCiy+iFDy880kzaTYafiAeVKan4IvHDHDtBAMckYMftuoWYeQC3twuz/wLBq7a2h4fzOYG/USqLBcLblsFD8wF/BraWPjNT9EBKYE0E9qt2e7g0IByj6Jt7XXtrt2e4uPSfV3uG8LKRSDNvm0NydkRqktZO8ilu3sGlkDh4ceyH75dcwgwRTw/La0Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6n3MJAg/M7TybnlbLOdoJpjb9Xt9Bdqw7fUiwHU0Jpk=;
 b=dzItCicENCVhBbG7/l9ZzyYWiyXybw+7wDr6FaAeUnqd2lSb/frlnXGkJmpmslNhKDikN9bqyCOwFzF9TXmq68g14knr8xvz1PumE8CN/U4fufrT38ksc+fd092kr8AI95d7aiTo7cmvYmMpw6QsZoD64PSqKMvcD4mj9vRKeXLcRA5l6C0PFpK5pJidMioQLntpiFnTFKNGws+DKNa2Ki+y7yYmw35SPntbSAS+H+Sdq20vq9QTo3kmcG4h0PRbDgL3hMM+Bih4BSJ7+X0Z2kBx9ZMhoH13+Ix1jdvToaLbazyKsfHTb6yjugTqXRx15K/fbDZDwXabtJrLOPgU6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6n3MJAg/M7TybnlbLOdoJpjb9Xt9Bdqw7fUiwHU0Jpk=;
 b=bSN0zGo86zAnUGvu5LJNLqAE4EsqiIT42GFUnzxysqMHp59L18/OU6+sFx2jA5j/C8H8BlfaQ4GkQh2D3Z7QYcbFLXPlKhoozrWQnaQDecfRFbfTKnZB0YH7XvZbVrcT39+9UeyfZqif4rwF+Xgel59kDBWUMbPKQEd2iGq9Wsg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1368.namprd10.prod.outlook.com (2603:10b6:903:22::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Thu, 4 Aug
 2022 19:40:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.016; Thu, 4 Aug 2022
 19:40:21 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RESEND v2 00/18] Parent Pointers
Date:   Thu,  4 Aug 2022 12:39:55 -0700
Message-Id: <20220804194013.99237-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e289437d-67e1-4ca5-1c27-08da76512adc
X-MS-TrafficTypeDiagnostic: CY4PR10MB1368:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9csDTE1NuR9lUKLbzaDseEKj4otwZ1VJiTuUMf5eyEwaGiFm/KyeZ6c4kWyn+YEJh/eJc5/dzVZA/3dMXQuUHqjHr9OyZ5qgW91IRX4MpHI7inTIDZ5x+bUpl0Hhdpa2GKbAO64USwWLkUGlXM1dRCfKkGHgzWhN6P+ypD5j38zD7H0r4CLQOsyeNglvC1F+8A/X7AogaI0f+FolMoYkXI9TIxeGMAgr9AaXX5TqUliIXmbOMYrj4k7J+gOlak75Tkmszzfx7omNFticuHr80OefwLhyEMPD66qturMKNnon+kzqKVXYceHFD/2rozynWxITrnhWGkohJQQ9RIkMh/AIlvdQeS/EazPWBu+k94ZijZXNmTcu4+l4jqUa9kReUox0lt2s9gowCPhlgA0dlX4gYLJLGDCM377DrETt2i85EPFM5UbPrteV3EjBYgPEh7pGT68QoakSz0DdBq+Vs2fwBkaekQUMeBHkn28fF+hIQ8p/ZMaT6Tl9sGB/7ZsCXqF9B3qOcJ1FCQrYsNHc3R5qCpYH7bjKivyo8PFXpiN36mAXTqEktlEgSU3uPXKjkwzKeDYMcO1PrdCRuTjGhadSvJToB96AYpXgk+7gGRXQXCCkOzE4XgOr2Wi3XoPZO9wu4IkMhWDSzfo4y2TIbu+bHLvXJGzDHq3m1ZPhkk5zeEVmPF0/yKH7XiuHF0JzASBY24QICu8q79hD87CKfzWgk2EBM8VXGj5TR7afK3HziTjBjR+dBKRc6vsw86+LBRt6ONCEWi0p6pMuILC9nrouME779vBlae/QDl1PMdrwYW08XY6Ci1iWPG3Se2fht5c4SDvtWYuZYrYspBIlxLafXMHYreDbzkvCn0DvQzc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(366004)(396003)(39860400002)(376002)(6512007)(6506007)(6486002)(316002)(6916009)(478600001)(41300700001)(966005)(52116002)(6666004)(38100700002)(26005)(1076003)(83380400001)(36756003)(44832011)(38350700002)(2906002)(66476007)(66946007)(186003)(8676002)(66556008)(86362001)(8936002)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4FMIZqBf9ghUJjdHkHRBTxhUicJcRWRw1zQ1eRHT2XP7md7Y4aaYfV6OsNsj?=
 =?us-ascii?Q?IB0vQVFYXooXsoZRVTWlXqLLcz5b4O24bAZyW3QwHsmICBD+ZOk8gSdKfFDM?=
 =?us-ascii?Q?jUSIouknYD4WsXCeXFrBsWgYBptQb3TwKrWf37fv3uwWA2tOY9bmmABCBU5l?=
 =?us-ascii?Q?mnt8wJlPcTEH36SKBiNodQxsgwf32e+DP8cLfQ5AwU0Pu8MxlRDHPWtp6iks?=
 =?us-ascii?Q?7oJ8No439FK+SWZx4M3w5RAgxnlNT5rt/jukg+ECZMYh1ZXOsG27Crkog8a3?=
 =?us-ascii?Q?KBwUsVEYzkIRbphnZzbA/9xi/F8INrzLfSVx1KtCKLFy4nDUDGSvgHgkgUX8?=
 =?us-ascii?Q?5OP6hF4HJxNWrKJBIKvP6jH3/QFBCLTXqpeIyhmR50zmOdRgmM1DFc9JyzWC?=
 =?us-ascii?Q?Sl5wjUHB1oTnSr0Gd/t/t0g5C6YZj+1rdD37wRsTUSeNADCNFmDj/rRX7p8F?=
 =?us-ascii?Q?3DQWWdMwb8x6fhqdz/c2zmBllpvfezdkV3RQM0S/O7lekZH+FanNEIwHEpmX?=
 =?us-ascii?Q?KjazLfOYxo1eQ6mauGjQN3p3EpJJabYqjj1KoBXxInmFHymzTgWJ8aRYWTcT?=
 =?us-ascii?Q?gG6zItbEylzaBOnTJYXzX3R6aROGb3hZFTNEjvIlp+A3iZZXDwIWO1IfHmlG?=
 =?us-ascii?Q?ClGruRRMuA7vplaQTrp+o2TSj3vOEZHAzNEDnOTP0ErdV0caXFSWgW56tEcE?=
 =?us-ascii?Q?BcFpR6h//Vk54i2yy6xS0vgncjtVkUnYyL9OYz1yRWsfjkk57DP5xju5EUKv?=
 =?us-ascii?Q?IcWOoq4eD7VjnCglhOb+71sYXxSF68LCef6q7TARm/o9CyZQG7NSGmyOSJGI?=
 =?us-ascii?Q?8XJmlg2O4rpRHkx/QSMkeww0xU+xbhV5diSqmbpIpPV1Few+Fn4OI/WZY4CI?=
 =?us-ascii?Q?gQM/P/f/A5228wYmys8etEabEVYq/b5UkcNtsjTNGH4L+42304hS3skdRUIh?=
 =?us-ascii?Q?jNsv3VUjV83cyV5/Yx38GOQIJ1ZaqdYuuX2y/h96wad+Y0WtUmlu7ANKq7cV?=
 =?us-ascii?Q?GOeKHSszN1dcx4h6jHqbBa4ugCjG5hdGFeu5P0vj2C5odPGMVzZFz8RbYzPh?=
 =?us-ascii?Q?IE2+rnwcfR6lohXvUFUbCGejRLhYktba5d3Dp0jn4lPDSDCF7sXzS5oSEKga?=
 =?us-ascii?Q?WYI4cXTS485hDxbfVAIa11f1rnG0uY10GL9aPjhVnQHwiiEE3wmIlPjt1y7L?=
 =?us-ascii?Q?U2P1KOjppO9J55ACGCAYbYcoCX/2RGv4sFKF2qZbZiE9Ly/RFwTzkBQP+CxB?=
 =?us-ascii?Q?PgKyxkSxPN3kHWayIsGG5ndBVPulvbvQUanh5bamsQPiWcSq+J1Whm4ZhQAw?=
 =?us-ascii?Q?2JiX0JlvRvkxFXNC60BjrQeCzJBy3sudnAnjlNQeS08+0DERX6GZiunWUttN?=
 =?us-ascii?Q?TvqFPiJb2scEVLxB4ZCV3u4I07UDbOi4U9hwsGAY6XBrYOFu/9MWzyyvyDSH?=
 =?us-ascii?Q?WUyQCh3xpq9pKhv7QuoYbt2byjco7yHV3CgUS+X1b2fHEh82XNn3s9b1KvUH?=
 =?us-ascii?Q?TJm3kmanLz2XatqhfbhHTLaYpo43bfBGBGAlEz15HUnY2lxh1mOYdOoE5HHE?=
 =?us-ascii?Q?8DVgaYFniEQyKuUcslBWw+Ys3FLUW5SKluPalzSeTPy90qKDDGQzkDMCyIJg?=
 =?us-ascii?Q?GQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e289437d-67e1-4ca5-1c27-08da76512adc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:40:21.1249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lj3yXfE2EyJ/L5XuQHzp7oizpD0FIdOLEXQXgLwEfhBh0ERZYoJbkjk8VC3f9iY5CuWBu/xh/jPc0zhSldYolVJYi2dpPj8cZ5EtA96EZa8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040085
X-Proofpoint-ORIG-GUID: i9no7wxhi5dHAZlS5JlTpoHSk4MJBS91
X-Proofpoint-GUID: i9no7wxhi5dHAZlS5JlTpoHSk4MJBS91
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a rebase and resend of the latest parent pointer attributes for xfs.
The goal of this patch set is to add a parent pointer attribute to each inode.
The attribute name containing the parent inode, generation, and directory
offset, while the  attribute value contains the file name.  This feature will
enable future optimizations for online scrub, or any other feature that could
make use of quickly deriving an inodes path from  the mount point.  

This set can be viewed on github here
https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv2_rebase

And the corresponding xfsprogs code is here
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrsv2

This set has been tested with the below parent pointers tests
https://www.spinics.net/lists/fstests/msg19963.html


Updates since v1:

xfs: Fix multi-transaction larp replay
  Resend (from stand alone patch)

xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
  Increased XFS_DEFER_OPS_NR_INODES from 4 to 5
  Moved to beginning of the set
  Added code in xfs_defer_ops_continue to sort the inodes
  Added commentary about which inodes are locked

xfs: Hold inode locks in xfs_trans_alloc_dir
  New patch

xfs: add parent pointer support to attribute code
  Typo fix

xfs: extend transaction reservations for parent attribute
  Made xfs_calc_parent_ptr_reservations static
  Whitespace fixes

xfs: parent pointer attribute creation
  Fixed SPDX License Headers
  Updated xfs_sb_version_hasparent to xfs_has_parent
  Type def conversions
  Whitespace
  Added helper functions: xfs_parent_init, xfs_parent_defer_add,
    xfs_parent_cancel
  Investigated mount option that overrides larp option:
    The larp global itself isnt used with in the delayed ops machinery due
    to race conditions with the syscall being toggled.  Pptrs dont toggle
    so we can just set XFS_DA_OP_LOGGED to log the pptr with out requireing
    all attrs be logged

xfs: add parent attributes to link
  Rebase to use new helpers: xfs_parent_init, xfs_parent_defer_add,
  xfs_parent_cancel, xfs_has_parent
  
xfs: add parent attributes to unlink
  rebase to use new helpers
  added helper function xfs_parent_defer_remove
  
xfs: Add parent pointers to rename
  added extra parent remove for target_ip unlinks
  rebase to use new helpers
  
xfs: Add the parent pointer support to the  superblock version 5.
changed XFS_SB_FEAT_RO_COMPAT_PARENT to XFS_SB_FEAT_INCOMPAT_PARENT

xfs: Add parent pointer ioctl
  Added pi_parents[] to struct xfs_parent_ptr
  Changed pptr helper defines into inline functions
  White space/indentation
  Reordered flag check in xfs_ioc_get_parent_pointer to be before the alloc
  Added gen number check in xfs_ioc_get_parent_pointer
  Init args in loop body of xfs_attr_get_parent_pointer

Questions comments and feedback appreciated!

Thanks all!
Allison


Allison Henderson (18):
  xfs: Fix multi-transaction larp replay
  xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
  xfs: Hold inode locks in xfs_ialloc
  xfs: Hold inode locks in xfs_trans_alloc_dir
  xfs: get directory offset when adding directory name
  xfs: get directory offset when removing directory name
  xfs: get directory offset when replacing a directory name
  xfs: add parent pointer support to attribute code
  xfs: define parent pointer xattr format
  xfs: Add xfs_verify_pptr
  xfs: extend transaction reservations for parent attributes
  xfs: parent pointer attribute creation
  xfs: add parent attributes to link
  xfs: remove parent pointers in unlink
  xfs: Add parent pointers to rename
  xfs: Add the parent pointer support to the  superblock version 5.
  xfs: Add helper function xfs_attr_list_context_init
  xfs: Add parent pointer ioctl

 fs/xfs/Makefile                |   2 +
 fs/xfs/libxfs/xfs_attr.c       |  53 ++++++-
 fs/xfs/libxfs/xfs_attr.h       |   8 +-
 fs/xfs/libxfs/xfs_da_btree.h   |   1 +
 fs/xfs/libxfs/xfs_da_format.h  |  30 +++-
 fs/xfs/libxfs/xfs_defer.c      |  28 +++-
 fs/xfs/libxfs/xfs_defer.h      |   8 +-
 fs/xfs/libxfs/xfs_dir2.c       |  21 ++-
 fs/xfs/libxfs/xfs_dir2.h       |   7 +-
 fs/xfs/libxfs/xfs_dir2_block.c |   9 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    |   6 +
 fs/xfs/libxfs/xfs_format.h     |   4 +-
 fs/xfs/libxfs/xfs_fs.h         |  58 +++++++
 fs/xfs/libxfs/xfs_log_format.h |   1 +
 fs/xfs/libxfs/xfs_parent.c     | 159 +++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h     |  39 +++++
 fs/xfs/libxfs/xfs_sb.c         |   4 +
 fs/xfs/libxfs/xfs_trans_resv.c | 105 ++++++++++---
 fs/xfs/scrub/attr.c            |   2 +-
 fs/xfs/xfs_attr_item.c         |  41 ++---
 fs/xfs/xfs_attr_list.c         |  17 ++-
 fs/xfs/xfs_file.c              |   1 +
 fs/xfs/xfs_inode.c             | 271 +++++++++++++++++++++++++--------
 fs/xfs/xfs_inode.h             |   1 +
 fs/xfs/xfs_ioctl.c             | 149 +++++++++++++++---
 fs/xfs/xfs_ioctl.h             |   2 +
 fs/xfs/xfs_ondisk.h            |   4 +
 fs/xfs/xfs_parent_utils.c      | 134 ++++++++++++++++
 fs/xfs/xfs_parent_utils.h      |  22 +++
 fs/xfs/xfs_qm.c                |   4 +-
 fs/xfs/xfs_super.c             |   4 +
 fs/xfs/xfs_symlink.c           |   6 +-
 fs/xfs/xfs_trans.c             |   6 +-
 fs/xfs/xfs_xattr.c             |   2 +-
 fs/xfs/xfs_xattr.h             |   1 +
 37 files changed, 1056 insertions(+), 170 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

-- 
2.25.1

