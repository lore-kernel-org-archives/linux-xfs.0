Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68808C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344385AbiCUFWT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243729AbiCUFWQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C183B554
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:20:50 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22KIpkdu008826;
        Mon, 21 Mar 2022 05:20:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=G+1BB/RRtavn3VEanqJv4oiEczx6UoD2gMCnNt7cArw=;
 b=OkSIIFK85VxV2hbUKtnbxrj3ZFtE8HkWYT713FUoQZg2yLrvXIxjZpQaccrjsOmVl1Mg
 HQqDc8pp14hMyTOS25DIGhxYI1aBeHiY0wfLZX8lBgou1hqKuUHX8NunDeYboxwAhnL+
 fBnlaEVQd3jFXvOkQZzKN19MLIM5/ZPnLfE71MtqvncDA+vXX+fcYBMkDuYZER0J/095
 FGKq/3rz/jNMklBleWqv+cL1WOJropgaceSfLvZWtc6czgCvMx6wNdt4N3fQlnf4ouVI
 2avcBF48wy/739ZK7AIm5ZC0Awswyf/8TXbOUysKjdXQT+8C5NwJSr9jWXxzkVYY+uke oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew7qt22y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5JoXX095481;
        Mon, 21 Mar 2022 05:20:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3030.oracle.com with ESMTP id 3ew49r2h2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMXHjNnFFnakk1yhh0EzqAb1E+EgfnytNVdblc0nEsHfRwOH188UNKqfeC1Wa+Kq8Hu5SvM4fcLFPHnzTNx2uLXHNAWDK6/OGu+dkPf11w/ASpEQC33f9PmOtZXMGd9FpdMIzzGzpPHmO4XDejVuybbYaX+M+/4zmDJrQQUAyag18SFFbcOf9rUcOa+y4JS0l2RX/xMxSSh9D/ucMTFfKySQadryLMhDfDuutFUJW4+Gy57I6ZipUghw3W7l/Exsx7Z/KdeD3ry+kPqBSEeenY1G+m1Nf8dvJwt/QhPLXXKfWE+jLLT7wx7I44Y+66c908RszBx4yHXvQwepW0ddAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+1BB/RRtavn3VEanqJv4oiEczx6UoD2gMCnNt7cArw=;
 b=cNmKzaNMr6lNoAa95vN5Ljkg5yzmb+lKQ8tLdc97GAUNhuoNT6acu+xdYyJVjKl1IXQgZB01dKLRVMbHtRyKV1A+s+21HAZJguZVhH1UwQsZkuOyOoS8eSRQ4wtj4GKHgblWr4cMU5cJkRzppqUW/Xf7beN6Jbp5jGedXUv2NLb0zCjW+gmBXjGVHDZXaM7VF47m3WMZOhIvAlcuuJwZhboAp/K/SD1HODcmw8rkXPS8DiY8ZcXUs9/3BywVq/62YzWlNx+19SExdmU0WOi9w0LMlP8mewSmqSlHSEkXFvA+9SAt3y4wWgDeIj6JNXYlNKI5+AIFWtA6ZnB43GTgpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+1BB/RRtavn3VEanqJv4oiEczx6UoD2gMCnNt7cArw=;
 b=bMhujMpxx+FrJm9Fm5s+PYxdSni6TmdGOGEQWp1yX/PyN9MecrKT4yD8iDYoD9Wrc12qZbpMUdog2+sE14Ill3V9EPTi5h/N7ks30JgOYFO7XjSIz8ZM13WOz0DtDR3p6USs4p8mnazc2fWh9LjLCtlcFic+0Bv5iMnIQ4h9q7E=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:20:41 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:20:41 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 00/18] xfsprogs: Extend per-inode extent counters
Date:   Mon, 21 Mar 2022 10:50:09 +0530
Message-Id: <20220321052027.407099-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a268de5d-3e6b-45c2-f0e6-08da0afa8ad4
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB55633487BAC0EEF66E1C0E30F6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /S3JC2Sbnl88al7RXYrrBB2aac1rUREIoldsTMYqqMBsg7WoBJDeCZ7zBWaEqBARaA0rq369NDEX+vZCtAgWa9TvjJX68m383hrO6AvpjrZXGkloCUQ+hcz+6TOwZY8KUcF+zNvmK2Oyo92xlHoazbaJ51iSxbeD80hK+bUi66fmR60DyC9pJlxUMy7R1yISvGSf4GyYBeJl57JZzf7JP3hfML+rFUjGbznW+6wGl1O1+wSRMEP62+Z8fE07lkHrWlO8iyy1QfsJ1D6o3rtOI1HcTxRoAVA/VyYx7ltsvpFFA8UoLpDEDHoS14bCMMNJoYOyXbwek5SkGyJEddlLa2t+R5Xz+EhCL2wZEdzRXAs1QZ6Umwr2CbPoOiwfYw8MWJW4bp7o0x36W1wYwMs6gGUrPIytRYsfERejcRtENWEX1wqRiFmqSvZNUqwitBjgCSiggfgiI9xGqoQoLnHveUPI3nHWhyijxPrv1ye09JK0NkzuaVz6PEur0HSfb9wjsjw1l3cgb3TSnRHCZwzLzHYJUWQzI1Bev9Hpv4fTb70aioUgsBSNqzcP6AxAu31O9pkrFzB5vtBu0PzFLpKmrtyTZDnUB7v8qZeRpgmk4QbuH/+Wg62nOEcH3ooj+S25IFfZeXX9zDk030KMzkNRI51lUR0VscoBlUW4zeahuC2TLXYXcK0pxZjmEglcoJt3EnZP44bRQfwir9N/nMKJ8jsGHVL9X5XgCdspQo0UP68zDI1yscupKDMYufmmVAAqjETmtLDF7csuG3TXQz3jr5F1LqwVngm2K3/XEwY9ZKQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(966005)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gEIMAb28vuAdrvMdKMcalLm3H0rGdqgE01epBhzJdqFwM1ANdGmxBJRl/luN?=
 =?us-ascii?Q?hvoIF4FLOs2Eq6Ip5fkPX/GB4nJJdfSrNGZrWzazt3t2qrITpBLB2PuuEfk2?=
 =?us-ascii?Q?1ZngeJIcSaPt4SlfLFR7h9zvkSUqjn0nv1Rdp/GgUj5+6eRQfZxRsw/VhzlQ?=
 =?us-ascii?Q?E4eOVHi7388n/p/TrhJ8eU0EwKuDRpoFVlGSWoUehiqOQ/FE5c+wEJPi6bND?=
 =?us-ascii?Q?Hgj5YGGy2nKjujRv3YA3jqU22sBxz9ZTrcy+EL+owYfVdDhnd4lA22JcaQFY?=
 =?us-ascii?Q?uFNZhRgEAdv2lu4dUsXD6Nkh0xLF+r/snUSRUGWHXKLEtHwQjibq+OFbHeXO?=
 =?us-ascii?Q?A6sdXii0/W8QTwfmGn5ZpLp5Y73P8XDu6AL0pH3w126gA4lFpOhuw/NkBN8/?=
 =?us-ascii?Q?ZLXJn4D+D9daeOHkbFDQx1i6n01azjPN4Pzk00BrclrTdrzmZBd//o3+pswK?=
 =?us-ascii?Q?U+m1jq50Fdd34hrJqtOMFFpvpDJJNNanDNU1tKunRlDnD6fngl/nONSe3ZVC?=
 =?us-ascii?Q?ZWwkOjKkHhqIR82A7VEzzqLu1SYGk08YIF8g4cfBE7IYlQ+e8KAIka9pacv9?=
 =?us-ascii?Q?wvlmXTzfPQng72lQdgxL5QK732I88ntAfIru2l+U+m9EXOPwiGdWV4wmE81z?=
 =?us-ascii?Q?TRqdqtptaI9wlkJiXzQsxH3joaPULgLF9rpyxjIyWCZbn8O8fj2IXuuGZfGj?=
 =?us-ascii?Q?1vECE00l7P6sKcTIFDe1g2kYQNcVocp/ln0nXtYOFCko3CU8eKMpFpti9cpO?=
 =?us-ascii?Q?11F7htKsfimDw5r7RHL+UtwSD6ceNWF/nHbeCkFROpp0IU669ez86tThTB02?=
 =?us-ascii?Q?FKp3zWGaftSS/kJ2OFwiBpakpg49t7VAOJPkOWXFWP1+MtPhPzGNvJ6UacvP?=
 =?us-ascii?Q?mlAG9TrV1inJn0cx9wLuIAB8/LJlYY7Vf0smTv083H21HIcdur1K13+6gIbU?=
 =?us-ascii?Q?LeIaF3n/RBUqTUJt0V3GXjiXirX8bEA+SNPl7E+iPBap6kiqD8S0TkwdvYL+?=
 =?us-ascii?Q?YS6rhGpHA5NFhUT25tU4Yoeu48nGci7fAoSvyeh5wkWyMNN6glqGgQxvavcq?=
 =?us-ascii?Q?z5ZAajWAmFHnFohMgYjXeG+pf31RIKaPKlMFBdc98+f58LGnR12/teMaB9d6?=
 =?us-ascii?Q?I3PDBT4Uhvp96JxzYsbo/lAp8y+7IusVbfSDpAi2FLZ6hhOOsrt1b7+NS/go?=
 =?us-ascii?Q?KEiQDJIjmAhjcaKB5yYfmeTGerwNf9QahDSPVeigTxGbTzb79dJ8n7K/qFAQ?=
 =?us-ascii?Q?Cs3MbFwNDw+sq+AVa5u71Db4SzCZP1QZUJzbeE1HzVH4Bo9hbMatBHDw7bVs?=
 =?us-ascii?Q?vrHu9CGSUJxFCULBhTssMC7mZrZUUfa7NiYWGGQT9jbC6pu/FGkrX69S19eu?=
 =?us-ascii?Q?rLQdGR60w6kwbVPCRwo2PlVmD07gsgT2CVeIvQGa5hT9J3SXDQjnIQ+ciZ/p?=
 =?us-ascii?Q?azriBreLSytBXPv2ZC6FUaMXsdwHEouyXREbOLm4jaa4srjqa5ZBEw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a268de5d-3e6b-45c2-f0e6-08da0afa8ad4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:20:41.6158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kIDWj0vg1FWQY9rlz0b8FqljhJyZaYUnRaVfxvUxTkhT14Yj5EYApKIuOEhdSmRslonNCDwkQ4SwmvfFF6NOhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=950 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210033
X-Proofpoint-GUID: YRsOKK2-e_9h073uXhvIyz9SULcYWmmB
X-Proofpoint-ORIG-GUID: YRsOKK2-e_9h073uXhvIyz9SULcYWmmB
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
xfs-incompat-extend-extcnt-v7.

Changelog:
V6 -> V7:
1. Appy review comments suggested for V7 of kernel patchset.

V5 -> V6:
1. Sync changes made to files under libxfs/.
2. Apply trivial changes suggested during review of V5 patchset.

V4 -> V5:
1. Rebase on Darrick's upgrade-older-features branch.
2. Recompute transaction reservation values before checking if
   upgrading an fs to a new feature would succeed.
3. xfs_db: Revert back display names of per-inode extent counter
   fields to nextents and naextents. Use the value from the appropriate
   field of disk inode based on whether the inode has nrext64 feature
   bit set or not.
4. Skip nrext64_pad when printing entire inode.   
5. Report nrext64 support through xfs_db's version command.
6. Update xfs_admin's manual page to show that xfs_admin can try to
   upgrade an fs to nrext64 feature.

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

Chandan Babu R (18):
  xfsprogs: Move extent count limits to xfs_format.h
  xfsprogs: Define max extent length based on on-disk format definition
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
  xfsprogs: Use uint64_t to count maximum blocks that can be used by
    BMBT
  xfsprogs: Introduce macros to represent new maximum extent counts for
    data/attr forks
  xfsprogs: Introduce per-inode 64-bit extent counters
  xfsprogs: Enable bulkstat ioctl to support 64-bit extent counters
  xfsprogs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported
    flags
  xfsprogs: xfs_info: Report NREXT64 feature status
  mkfs: add option to create filesystem with large extent counters
  xfsprogs: Add support for upgrading to NREXT64 feature

 db/bmap.c                     |   8 +-
 db/btdump.c                   |   4 +-
 db/check.c                    |  28 +++--
 db/field.c                    |   4 -
 db/field.h                    |   2 -
 db/frag.c                     |   8 +-
 db/inode.c                    | 224 ++++++++++++++++++++++++++++++++--
 db/metadump.c                 |   6 +-
 db/sb.c                       |   2 +
 fsr/xfs_fsr.c                 |   4 +-
 include/xfs_inode.h           |   5 +
 include/xfs_mount.h           |   2 +
 io/bulkstat.c                 |   1 +
 libfrog/bulkstat.c            |  29 ++++-
 libfrog/fsgeom.c              |   6 +-
 libxfs/xfs_bmap.c             |  77 ++++++------
 libxfs/xfs_bmap_btree.c       |   3 +-
 libxfs/xfs_format.h           |  80 ++++++++++--
 libxfs/xfs_fs.h               |  21 +++-
 libxfs/xfs_ialloc.c           |   2 +
 libxfs/xfs_inode_buf.c        |  80 +++++++++---
 libxfs/xfs_inode_fork.c       |  15 +--
 libxfs/xfs_inode_fork.h       |  59 ++++++++-
 libxfs/xfs_log_format.h       |  33 ++++-
 libxfs/xfs_sb.c               |   6 +
 libxfs/xfs_trans_resv.c       |  10 +-
 libxfs/xfs_types.h            |  11 +-
 logprint/log_misc.c           |  20 ++-
 logprint/log_print_all.c      |  18 ++-
 man/man2/ioctl_xfs_bulkstat.2 |  11 +-
 man/man8/mkfs.xfs.8.in        |   7 ++
 man/man8/xfs_admin.8          |   7 ++
 mkfs/lts_4.19.conf            |   1 +
 mkfs/lts_5.10.conf            |   1 +
 mkfs/lts_5.15.conf            |   1 +
 mkfs/lts_5.4.conf             |   1 +
 mkfs/xfs_mkfs.c               |  29 ++++-
 repair/attr_repair.c          |   2 +-
 repair/dinode.c               |  97 +++++++++------
 repair/dinode.h               |   4 +-
 repair/globals.c              |   1 +
 repair/globals.h              |   1 +
 repair/phase2.c               |  24 ++++
 repair/phase4.c               |   2 +-
 repair/prefetch.c             |   2 +-
 repair/scan.c                 |   6 +-
 repair/xfs_repair.c           |  11 ++
 47 files changed, 778 insertions(+), 198 deletions(-)

-- 
2.30.2

