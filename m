Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EA4C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbiGRUUg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiGRUUf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:20:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896EC27FC1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:20:33 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IHh8hD026646
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=SLeVhxo/7ufr8wX3F0glqxkS6P/cVFMEskk7rxdUkPM=;
 b=gExWpwVneR0RLVkY2hQgKXcNdnF3pNSzqbyqQh0qBK0ZU/sJqJtSODD8qGEAwwPHCq5a
 4DR160civwlpiDB+53lYh6mEuVNiOXiw6Q+oZXdxRRywk9dWZr2IbSZMdw4cigBGNKrg
 cC0zZS61sR+Sa968UfPFbXXB/EMDcKbS9Eu4mR76oef2Uw3kMhrD8Z2NN11pbAw/Sxqe
 p79aKgjmXbKIi7g0mL4z3xut3utkMrK8C9JSpQWbavDfZ2pY4mIIoPK9lKXoWd1/oUYm
 NzspWcCjh/v8Y7MnyO5Nb2Dhfop8Cli4LH1u2W/69X3g9hPomHU4mtJh0cQrHjIA1773 ng== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbn7a4cfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26IIp4t3001290
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2sfbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 20:20:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGaJ9gXQZb5hcZ1hX5iwXbkmWnnYhYNNLFXevYoOz3lLBSeZjzgcz0uEVdPgOsljGIoIT3VBXUJ1f1yZ9b0FEAZXU2aRDN69wdoxPBhyNMgbIPciGlNJbm1OD0T7oMSMFhj4YrGt9k68DaosHKjrYsT3h9w+PhYCkMpkbD/S+aNZLOJG3hCUCCttDNRFtM/Rm+/KDu9MpS+MZl7GhUNXxwetHoHnZ0j2sT9Z/NBLeWiodfTILrG4S1YdSQKi8lpENJzxtrSdvb5DaeTXVucnXrmaXxPZymabFO3TfcfyiSa4rU7iXwl+VXZ6+3MXBuzRe+gNtnu0VLB1Ofc1uY/C2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLeVhxo/7ufr8wX3F0glqxkS6P/cVFMEskk7rxdUkPM=;
 b=Man2xBT45CBwTd71WEPBmd870kCQOVxw8vjwj3fFV1ACC6hGJaFpeQRUbKCklnkaJRsT5Je3dVFmjptdXpnrN1YT/wgWsNEzjj91ZG6jrC/+EqQ63vrbub4ZDPvk9bA9D+ceOx0xatiZraEpFAC/kg8+sRt5T2BrgMU1WhyA30Vj7OFrdJqtVOTiccBDdZn2IO1nam10wuOBTwn6bcCzejcfKLv0DLjXVuigBE88m4c3hu5fAspgtcIsA1GlZQPxhGMzGkKWVVNc1qGgsza3qNPhAH+Jjcu0RKkIWeENgXbrnPO1XI01xYpvbtiKu1MYABYF4E8fapB5O3OOw/CwrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLeVhxo/7ufr8wX3F0glqxkS6P/cVFMEskk7rxdUkPM=;
 b=fON5JLNRjIRY/qHCrSR0KRGTs3cEC/sTxvFubIl8JDUUCnqoSdG6hJFZ2RbWrd2r5ru7nh9yZqD/CsNDfR6UKRtCjCFH+dmsQpwvsCxPfxHhlgJTD8qWr7+4IYPquoqnEcufi/uzsh+jNTfRMTepeCL7dIMM77cYaPv88SkYF+0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS0PR10MB6128.namprd10.prod.outlook.com (2603:10b6:8:c4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.23; Mon, 18 Jul 2022 20:20:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 20:20:28 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 00/18] Parent Pointers
Date:   Mon, 18 Jul 2022 13:20:04 -0700
Message-Id: <20220718202022.6598-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39b59fe4-1c56-40b9-460d-08da68faf503
X-MS-TrafficTypeDiagnostic: DS0PR10MB6128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 54E85Ijaq6N7LyomQtmQUwBFnuEEcrlD5rXiizjGBJfjZspQKr25GNtM1hfbGgHOzLLThO302oTLW51N7CGnmPuz+obL6PGGQUYoT3rUtAQIN45H8+C3Dkhy/j3QZVrAZA2bMz2y958sGmnjzBET2ZcKrZJSsOMd1Vi73Y8h9VnqiScxV0aotGHOOO2q6otbTzpZVK/JJmOFaepvEc6J4CF4X+oTYV5vZk16oLqtCZbELmneRSqHHajnNyEZX22xre6/P5LvCt1W4kvpUFvXuR9PrdnSa9S47g+Cd/OCLL2YW3EDK0c4HQZbLJ8gGpDNU3Vzwb2GQnIkZaJI4nK5DvZYoAfENszUWgk/7SO44jcPKG7qmJTtmL/IfBubfzB1tqwRpieTR7QzORrO6QX5/kyysOcp/1cDKqXnsaCBtHU/CfhSlL/aIsPtRJQygUje0fgOSdi8DyhE/S0UAWjZgUghzzwEs9mI/8DApeHFPfo1kg0I8V23Xlu9HID9/FOG6Sr2cjx8obXNN9iqmCyOHhjNRcPeTRx6pNsd0wFX+EyNgyfLHn1EHwcCdUPTp3M75sRo2eoiLuqXcXhvuwqeI6sFUIa+Wg+wAkBHCkWd6mpkyNaq4+Y6ZocmdopfoRDPnIlz473zvwRTapdeOVuWkDLraJ33nJ1vNCs19bQicVoQT3nG1ofisZq+M7sLN6zqvPmmPHq32UnWkbvHizFVKSLkbEbninSiU4id65kLZoQbapx2gFy4lemS+5ajCd6Vt46w9MXSu2bG0z0pnFfNMLWPOlkbiaFDUIv9SYkxg95c5ISDONx8UUIBnvLrbXHq0vf9LfHmsWjJviWAHKpKq22jZgj7gQfm9we210OVsC+n1l4hhUT5p6oOJIAWRvAv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(376002)(346002)(366004)(6506007)(52116002)(6666004)(41300700001)(966005)(6486002)(83380400001)(5660300002)(478600001)(26005)(1076003)(186003)(2906002)(2616005)(6512007)(44832011)(6916009)(316002)(66476007)(66556008)(8676002)(66946007)(8936002)(38350700002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AjHIA+jGKlRuQernRFl/iLczJfHLS6oyx2Qjhcse+h07mzYEhAn0ooCrlE62?=
 =?us-ascii?Q?7b5qS9hC2a6VwN6Gg7YcGBko1hS1Zyv7vAEZbxDTNYYwV6Fv084bF3X5CzEU?=
 =?us-ascii?Q?+o6rfMmBXVKuE6iNc2pGt6HuPoAeuWL6b2hH0waPvnNoFNS7RDBs3Q9uYBXc?=
 =?us-ascii?Q?M0AZy3IaMG/81yr42OmMm0jne+XmLrpct0xoC8/DFYRAmAvzXc8RmXxsv+vg?=
 =?us-ascii?Q?3+fdYK/GV/WfU903TM1A0/DMegzZyjlUSQnwKAcWp0KZw3VzSL1/twCam29x?=
 =?us-ascii?Q?O86xhJ5zk5wwzuApRPYJ2i9LmIk8Wdr5edWSxE10DKcPD5rLM2OY3e8oSrH7?=
 =?us-ascii?Q?OBo849PcCg1pKu7ibC6WboqwYU8Opx5M14nDl3aAns9fBsuCNq6akrwy/gER?=
 =?us-ascii?Q?3PbrLWjXUPQNCCIq2/WrWexypQ+3z0pDjxdn2y8FJn79Qg6EHy8WfdqA5yc+?=
 =?us-ascii?Q?GUlYaqZxOClEXK1CUKRsdXEQ1tcmr+NpYqoo24sUhZQj9RukH1lgrrt6KUQV?=
 =?us-ascii?Q?o8W84lkxgU8LgH0R5qn4oCedaeY+Is2sFe3Cdg7jtmHGS12vx2eh+LwpS90h?=
 =?us-ascii?Q?XYlFeWnnzEKN8PB4nmQkXintGLhmlGVLxCPvC+5eAp2eSm0WYSvrAdiQumjc?=
 =?us-ascii?Q?ruDn+aNiY7JWwh415en0guVGPkJAAHGqV76cmiwvCAitTGfV4mBjfESlU1tE?=
 =?us-ascii?Q?T2tiI29lLPqK+3Tf2k69zGtCD+wSic4SLY6f5Pm0G7fqBirbB6+nH2GtYcR+?=
 =?us-ascii?Q?C7aU1F/aY4LiaWELfEPpB+ecjS9rUYCMeR3jug0bPlSsy0MqVDEEtileFIng?=
 =?us-ascii?Q?TEF+I0Hp6SwfjaDQ3FXppUvYmPvPbWTk5ph7ekYTPe7faQNVGwh/iNPXVeKz?=
 =?us-ascii?Q?m/erbEb+jufA7Z5n/lnfKBzIGkeecUBtiLENXKTXWVt+C9ImIj+66bU2hsll?=
 =?us-ascii?Q?Lowv7faxVlCqNXOFDBjcZvc+ybO8fptu4Z9h1Wa8sS4blqDvJnLDa/t/rCwE?=
 =?us-ascii?Q?SzePBryVAMee02mjJEPWGPT71tJ2AMk4H9toGkTfVowX7PRGo/Lxp7nu03il?=
 =?us-ascii?Q?CcND7qH0uJPONqmwJAUOMyL747x2qmkBPbodmEVyBb4tG12PeH0MCaq/YOg1?=
 =?us-ascii?Q?B6MVAVzKa2NVdNQ3ofPPPqZk9ndGQFjs1D9JdyLjhvQfEeWm88YVd+ylTgV2?=
 =?us-ascii?Q?Eve1GXg9qHJxB4Be2f06v6HPBmODDmu4xU48Q6Ni9VL8wLv5PAUmDAH5ceDV?=
 =?us-ascii?Q?p8NjjInGOjnz8IF3AcF03pWuh7m4utKUweBD3Ig5A5t9nww+r5KQIpdCNftu?=
 =?us-ascii?Q?I0BhtWkwBkDLrfpP9K9U0CM1/KR/ZnmAimnm3Pc9HTNp9yJ4hZ9jVkUBcRv1?=
 =?us-ascii?Q?TNVyJI9r59/FnhWDqLaTf9gBVILom+CKRRDlTmhW4UAaTzn2D4DzJsbe5Nxf?=
 =?us-ascii?Q?GLNgDoAKn2ZyCWwQocdfjNESE0ihP8xRCuoVZQWoKpEKjVplqg8+RlWYm0dd?=
 =?us-ascii?Q?qNZT4WUHVsVTlhvqqeH5XvbVeDypPUgFlhgsHl6KKtDSyeSwzl7+bmLkOvY4?=
 =?us-ascii?Q?dR3b2IzYXSpA3CIkjk3nSq8RYTx2tMJJqmsjWOfU+XCr3ZfRZU8IjNFKvpQJ?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39b59fe4-1c56-40b9-460d-08da68faf503
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 20:20:28.9497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AAGgim6WVeiEoaei3bAG0UT7IYTCRDKv2EuW4nOkAthzIIvvvxWuje+AwV3KMcNOGeNWrGUeMqM/lAhcz+cBheK1WQT8rCEp3h3hOv+59cA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_20,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180086
X-Proofpoint-ORIG-GUID: vxZIceJCufblgM4jwZzD-vJXb0HAEQy4
X-Proofpoint-GUID: vxZIceJCufblgM4jwZzD-vJXb0HAEQy4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the latest rebase of parent pointer attributes for xfs. The goal of
this patch set is to add a parent pointer attribute to each inode.  The
attribute name containing the parent inode, generation, and directory offset,
while the  attribute value contains the file name.  This feature will enable
future optimizations for online scrub, or any other feature that could make
use of quickly deriving an inodes path from  the mount point.  

This set can be viewed on github here
https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv2

And the corresponding xfsprogs code is here
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrsv2

This set has been tested with the below parent pointers tests
https://www.spinics.net/lists/fstests/msg19963.html


Updates since v2:

xfs: Fix multi-transaction larp replay
  Resend

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

xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
  Added comentarty explaining which inodes are locked
  Updated commit comment
  updated xfs_defer_ops_continue to relock inodes in the same order they
    are locked

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

