Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A17EC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhLNItl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:49:41 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28222 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhLNItl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:49:41 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7tcR6005519;
        Tue, 14 Dec 2021 08:49:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=aeuw1vLa3Rj5RKvHc7DuPlqJkq+4b7QKcwzOt5xqddQ=;
 b=QwKonevke3YzSyu5SDmlZRSwSY0j/IC4tgZcjVx3h2jBlpeAWhOKUthFrfR5NKj6YNlo
 EhzF8JSXqHnnktOdogkDsUJJv3vhhNtm12wzWc2JgGxq6iefdRrXm6Gir1fClooMa1Uk
 o4nf+95k7jVbHinL3hLibM0Jlp2L3e2QwxU+l8oL/qw+L+hqQVQBwldKOCSNrW0is9qZ
 C9IdjomiuTHwDaQb3fDxf6oZu0aB2RHu/mUhHoRlAxQ9BzCyAc88HWjPiidhEeM9N0sG
 B20Zcdp4YZ7/N+aQ+5E4ko/ml85TV34JvQYPmVxy4TSCTLXh6qe6y9MJdeIPwMAWQ0eu AA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx56u2sw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8eS6a074155;
        Tue, 14 Dec 2021 08:49:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3020.oracle.com with ESMTP id 3cxmr9yjas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:49:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLXiaN1V35neNaCFQjDZSDKjOaYAtDMfeoZWKYOn/ZD7KUoAymddrafORy8WfL4Klax/BRujTnrVGkGDJBkNH4HHsBF1vLKAA2NG63+/k9ee2sZK4XwmRJqpwwlsJM6z0eAG6Pk+uBGL9078iUb6yugf4dsd0WlBe3GFi2WsrF5C5dlUiQom/hXSH44sicgubErUO4/RtGfIyjKb0Saf7EMM60TnBQofJ5+wSnKtQLJtUKmhJvpX7eAYWgR8lcZLCJuQVZPkwjzl7AyKP8szbcJYjnuabAJhcbXYtuB+Iy5HP8wkURyDhN+X3wW+DtGXv6QiC+FjkXCVDyRKaKR2DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aeuw1vLa3Rj5RKvHc7DuPlqJkq+4b7QKcwzOt5xqddQ=;
 b=mrueOWGgWuNbdVLZFydmqIBGRlWiPezFhvByHDKoi/Kvrf7hlwcF4SkWMvKA4iN43im1+Kzh5WkFrW/30iXhDQYaX1vNisXyTuHIWtIpRoGB8qA8VxTZrJwibCoVRqFzzWZTvO71e8wHStN3HeQD+13oLn/e5z2N1wynpuMgRz5KdYFf/9xVht4ozC+JM/HAIimgXMMA5t3T4cA4v1AV7KpRhAKDG+KWHjuUssrWFwToyAF5I89z7TW1WyCZCDhbXrW3VB44yQhWu8Dp+7nBPhYooiXI5QRuJPW6yFr4g7cjkCsIKzufgr/Sb1AgJnT2p8R1/hULePgoF7TihRVQgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeuw1vLa3Rj5RKvHc7DuPlqJkq+4b7QKcwzOt5xqddQ=;
 b=Ns5f9mkS1/XRs3qpdMsD4n4rEjHOy6os24QnfKmM/D9QLeGC1aEVXpJZxoX6IQs2ffbe263s43kRlB5Tr3N8wotq095ANgaelh35ik4zL3miHxI7QVgpp+3GBH/FlptTByFVuA+Lmbml49thjCjdvAwOyqLrNsiwC7zLWI9fdi8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2656.namprd10.prod.outlook.com (2603:10b6:805:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:49:34 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:49:34 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 00/20] xfsprogs: Extend per-inode extent counters
Date:   Tue, 14 Dec 2021 14:17:51 +0530
Message-Id: <20211214084811.764481-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94304ed5-401a-4928-8b3e-08d9bedea6c9
X-MS-TrafficTypeDiagnostic: SN6PR10MB2656:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2656650803300A1DD3E80B63F6759@SN6PR10MB2656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G2HJ8rw41566tLMe6ogloQxh9flc3ZHeemQb/o2rty/puoMRBpBgUYEAlVhGEs6JMPj6noRx6bL2ZvP5U0HRSKQnOx6w7UcyoQ5iLD/j9N84nML9bdxi5MZdwayEq0W6RyI+f9XXot2pSHn5DQVhCy9RQ0vgs6NJxfS+nlLcsBams+NOVRyGWmoKO0dKRjpxdMnkYbpxjaB2IOEsI5mpqTVVeoHrjX7rMIx1LAfbjiqW3ZKJYbvi+pbdqh8OBEo9kxJ5s7fGHc11aawzO/43cLsK59hRnGLGnflvk3q+vmj87XYnEt2759P/0DGeELv+81ultcEFFkq4q3td04vERZwPHYrjWsg/qwB94g4yxy8BIV3fWijve3YV6FIfg1zI9oqhtBTpSLftHHuUHt/d7b5+czjC8HdSidyStT+M31IW9OdZsbZyHUSXi2jdZg0fxdLlrOcPxHLsO1xIYn9X8jRT8wTlpXQDFW2yamdrZse8iS6nk56f+n/ESDuQZpXo4wzp79bVqCSh/5Vei0WZsrhF4QhhXFKeDkiQBAaHfOr3G+L8t28e43yICszEuIog3f3plHRktcQz/7HPoeEZI1LrEMjnMG7MwUmRnxgJAoLYSh3MqF/b9phLdCXZ3nXraZ6k3qh8sMVCc9iNg8a+k5ZJEqcpGOwO4tYN5XPtHzUTBL6z9a/lf8Zd0jh1MYrpVd80symNayivpJDjBolVQIciV9IQECKnsqCMUnskHS4qwjSxhmgQ91W/0MLv8AkItRlC2OkPlb0pXaG9kg8j0/v/G12A3Qe2mHQXUD2rIWc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(52116002)(86362001)(186003)(6512007)(8936002)(6916009)(66946007)(38100700002)(38350700002)(5660300002)(6486002)(316002)(8676002)(66556008)(66476007)(2906002)(1076003)(966005)(83380400001)(2616005)(36756003)(4326008)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DeQSa+5oHLrfwXvEGMKS/hZZUYudbMMl3D1HzA16iVLq0S3rx/EI3xHefvg2?=
 =?us-ascii?Q?NNdzNHzBHFpJtC7RqJ8cn4sHCwcEC5UrNgxmk8BB3KPOOY9SIOyIVKth8GJi?=
 =?us-ascii?Q?ielv6Rs5PDPPmfZyC/UPNRjQb7MUTGsPrTLcxhvFlT+Klq2oL6ZVtI9hwso8?=
 =?us-ascii?Q?418tAWk5Q3B/fFoCe5KS39A7JrQAzpS0Nr/HxFQIXQw8MJ/YnamawyL3egOf?=
 =?us-ascii?Q?95TVYRDrMgrdI1GZpZZovxlaFiHgkUsXx4o+fronxO4sXMryawBPIhOdxenn?=
 =?us-ascii?Q?8aSLqYroB+/aIvfEWDCrw5a5UduJaenYwtkopSP/3K3M2FwhhAp29SanEh3O?=
 =?us-ascii?Q?b6TkGX8cyQCFuCo/kuQw7zdgm4GTHPhWbEIByhn35QP0tCP1GKRF/CJzCLAh?=
 =?us-ascii?Q?/tusS2AWoglcRBGuFxeAyXohh8yaiPt8mp+EIuHXdEZ4OVHP7A7D2axnAjEA?=
 =?us-ascii?Q?EFDsK6QrRKPg1L43ole/rifh854WAfKdUL8M0FEKFl4wmiLttOg5MxoETa1x?=
 =?us-ascii?Q?NPeziCMHtwIFUI8yrkGGMtNMmmmv9/q70f7SaUe3FvKUeMp67eEWbhX4JA1D?=
 =?us-ascii?Q?WmXU2pCsv6Q9EPtGlUlVoqdUxhjc1ng4aB7vhyT76mXpf9P9bEsDtiTMzanr?=
 =?us-ascii?Q?HbQe6YgB3kWPd4IQ9PIWSQiNDgBDWbMWtI/GDeWIN6LZ4psJFM+AhoqsYOgN?=
 =?us-ascii?Q?x2PbDFsT7ENJfuaggtXypwFG9gdXvCZIgI7jStoe7d8HRp8tPnGgK5sGlUam?=
 =?us-ascii?Q?atL87hcnCrW+dnX1P37XwSPhFK/CpCWK+GTXIDU752tXreEYK6P3WQHoDIoo?=
 =?us-ascii?Q?Oj6MQa/bRxKr1H+dZcmA3wF+rmf1pOIWBSzJ2BT3TrIcvHU6o4AiKt1HbWaE?=
 =?us-ascii?Q?a9uefDx15ErWtiP9CE+j8ZQN46dE75OeITb+O3MA0eIWt1Oh4IHVMKYw57hI?=
 =?us-ascii?Q?8UtZmpzYo0X7eG/SvJGkspMnL5xZ7k089/Me3lmDpi2EVdNdG+lQgaoELoao?=
 =?us-ascii?Q?2E8VZu23eDSu8jmgKFsrrRsO0a0tQrAxwSPMFyTTQX9SRck7/c18pEcuBudE?=
 =?us-ascii?Q?KWZrXuCsJz1MT/tK8Qy3OwnO9wax3T5GRAVM7MyEGc3xZqonkPlyCW4tdvRQ?=
 =?us-ascii?Q?1Yev6HAbHhW6Su8K1rZBD32kd5KE88RtTeFJ0MlKur/Ou8ZzYkJp8u8iYi/z?=
 =?us-ascii?Q?9cf/IOWM53FHk8V1qgHx6stdszDIx/cfcmQL3Sb3WuZGvwpMJOaayf1V5K6h?=
 =?us-ascii?Q?nbSPcQ8LjUflCgLUEUfrHTWlI4ZPdYREBAQwbhVlFsOt8aqwxpfqRqmyPE57?=
 =?us-ascii?Q?6pMkfX5kqK1ERwlPo5BCfBh7BPYr5cjgodisx8s7R3PW3odVoUDWQraSQSfW?=
 =?us-ascii?Q?8jPqjt2pKggTEvc6WfJljWqUCVueZYxLhjdyCRl9ePR/hnzFOQyurdAYGK9t?=
 =?us-ascii?Q?K30gHaryZU0COzGnHP5li0M3hTdLffq0sOT4ABUCPNtpYzuX9jng+jykFENH?=
 =?us-ascii?Q?qoLMHrdMi8z13omgvp5XTYz1nN72l0/QBpiKOC+hhoBohzDMWF0RO6JvbxQF?=
 =?us-ascii?Q?/avdANBHXTKk+x5ygsGn77PtWWi7RQ5aMdMmwQ/fDFjeNOP7Lg9eGg2BKW30?=
 =?us-ascii?Q?UP6cdQm8i7XP43gv+tsBdFM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94304ed5-401a-4928-8b3e-08d9bedea6c9
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:49:34.3393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eK79UX7LVDY8VPZ4CscDuUcGS6Qw4/t9clF6b9Sm8cp/QNO8CDydnNijphQPSA4m5+MeavNqptPeAUmmM6yjyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2656
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=706 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: euMLvWkKwxHi98gqwQmhUC8tnoIcvGTv
X-Proofpoint-GUID: euMLvWkKwxHi98gqwQmhUC8tnoIcvGTv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patchset implements the changes to userspace programs that are
required to support extending inode's data and attr fork extent
counter fields. These changes allow programs in xfsprogs to be able to
create and work with filesystem instances with 64-bit data fork extent
counter and 32-bit attr fork extent counter fields.

The patchset can also be obtained from
https://github.com/chandanr/xfsprogs-dev.git at branch
xfs-incompat-extend-extcnt-v4.

Changelog:
V3 -> V4:
1. Rebase patchset on top of Darrick's "xfs: kill XFS_BTREE_MAXLEVELS"
   patchset. 
2. Carve out a 64-bit inode field out of the existing di_pad and
   di_flushiter fields to hold the 64-bit data fork extent counter.
3. Use the existing 32-bit inode data fork extent counter to hold the
   attr fork extent counter.
4. Pass XFS_BULK_IREQ_NREXT64 flag to the bulkstat ioctl if the
   underlying filesystem support for large exent counters is detected
   by the presence of XFS_FSOP_GEOM_FLAGS_NREXT64 bit.

V2 -> V3:
1. Introduce the ability to upgrade existing filesystems to use 64-bit
   extent counters if it is feasible to do so.
2. Report presence of 64-bit extent counters via xfs_info.
3. Add XFS_SB_FEAT_INCOMPAT_NREXT64 to XFS_SB_FEAT_INCOMPAT_ALL in a
   separate patch.
4. Rename mkfs.xfs option from extcnt64bit to nrext64.

V1 -> V2:
1. Rebase patches on top of Darrick's btree-dynamic-depth branch.
2. Add support for using the new bulkstat ioctl version to support
   64-bit data fork extent counter field.

Chandan Babu R (19):
  xfsprogs: Move extent count limits to xfs_format.h
  xfsprogs: Introduce xfs_iext_max_nextents() helper
  xfsprogs: Use xfs_extnum_t instead of basic data types
  xfsprogs: Introduce xfs_dfork_nextents() helper
  xfsprogs: Use basic types to define xfs_log_dinode's di_nextents and
    di_anextents
  xfsprogs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits
    respectively
  xfsprogs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs
    feature bit
  xfsprogs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
  xfsprogs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
  xfsprogs: Use xfs_rfsblock_t to count maximum blocks that can be used
    by BMBT
  xfsprogs: Introduce macros to represent new maximum extent counts for
    data/attr forks
  xfsprogs: Introduce per-inode 64-bit extent counters
  xfsprogs: Conditionally upgrade existing inodes to use 64-bit extent
    counters
  xfsprogs: Enable bulkstat ioctl to support 64-bit extent counters
  xfsprogs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported
    flags
  xfsprogs: xfs_info: Report NREXT64 feature status
  xfsprogs: Add mkfs option to create filesystem with large extent
    counters
  xfsprogs: Add support for upgrading to NREXT64 feature
  xfsprogs: Define max extent length based on on-disk format definition

Darrick J. Wong (1):
  xfsprogs: xfs_repair: allow administrators to add older v5 features

 db/bmap.c                |   8 +-
 db/btdump.c              |   4 +-
 db/check.c               |  28 +++--
 db/field.c               |   4 -
 db/field.h               |   2 -
 db/frag.c                |   8 +-
 db/inode.c               | 187 ++++++++++++++++++++++++++--
 db/metadump.c            |   6 +-
 fsr/xfs_fsr.c            |   4 +-
 include/libxfs.h         |   1 +
 include/xfs_inode.h      |   5 +
 io/bulkstat.c            |   1 +
 libfrog/bulkstat.c       |  29 ++++-
 libfrog/fsgeom.c         |   6 +-
 libxfs/libxfs_api_defs.h |   3 +
 libxfs/xfs_bmap.c        |  75 ++++++------
 libxfs/xfs_format.h      |  60 +++++++--
 libxfs/xfs_fs.h          |  13 +-
 libxfs/xfs_ialloc.c      |   2 +
 libxfs/xfs_inode_buf.c   |  62 +++++++---
 libxfs/xfs_inode_fork.c  |  13 +-
 libxfs/xfs_inode_fork.h  |  59 ++++++++-
 libxfs/xfs_log_format.h  |  22 +++-
 libxfs/xfs_sb.c          |   3 +
 libxfs/xfs_trans_resv.c  |  10 +-
 libxfs/xfs_types.h       |  11 +-
 logprint/log_misc.c      |  20 ++-
 logprint/log_print_all.c |  18 ++-
 man/man8/mkfs.xfs.8      |   7 ++
 man/man8/xfs_admin.8     |  30 +++++
 mkfs/xfs_mkfs.c          |  29 ++++-
 repair/attr_repair.c     |   2 +-
 repair/dinode.c          |  95 +++++++++------
 repair/dinode.h          |   4 +-
 repair/globals.c         |   4 +
 repair/globals.h         |   4 +
 repair/phase2.c          | 254 +++++++++++++++++++++++++++++++++++++--
 repair/phase4.c          |   2 +-
 repair/prefetch.c        |   2 +-
 repair/rmap.c            |   4 +-
 repair/scan.c            |   6 +-
 repair/xfs_repair.c      |  44 +++++++
 42 files changed, 944 insertions(+), 207 deletions(-)

-- 
2.30.2

