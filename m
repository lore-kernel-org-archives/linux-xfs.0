Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D27ECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiILN2A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiILN17 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:27:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829D9303ED
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:27:58 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEfng003056;
        Mon, 12 Sep 2022 13:27:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=RpZaKdi0C2hWqPuq8uxqcC9k15G9Hv7Cdqp0qEaSHlw=;
 b=hTn8dx14bIkf9P2KE/cfn0aIoA4a+AcYBU81o3w5PjPSprzXfZ5sW+elbAOA2ck8KDaI
 r9yNcC6YnKndPUA9ffW3Tqh+rvbRbsZ31U3rG2KGzwoGuUaWembAbUtLJS6OCxJ+Knz6
 ZB+ESMpBtScUYO2SLvCbsCR62ET8a7lRPWN/qnQoaYf7sGxDzG9DbBEv/qqrM+sC356d
 VBqOpPgwcIdZHZS9jDR6X5XR6F4Xw4JIaQ6WLwHePQSH1ITv4IDASNl8wFiQzAAp9Hly
 zJWf4iq5Ch+PZsSFZh32hdpN2vft8GKIqhl7mD/IM952IFqEFdaVNAhzNYUP9eP/5jOe 0Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgh61khgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:27:52 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEgjY020365;
        Mon, 12 Sep 2022 13:27:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgj5b13u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:27:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ca9uFY0SrnsTRz+K7pzqtlSoUbYDQqpcBtDl5diQtAMsU+o8isJD4+pz1Or9049M6ntz3vQ8lqfVTajAYPrIh+lKIHnD1HHDLAUuVMgHTaAghs6Ve7vqIC4C5nQ280pRSAZdB0jmlX/RJjNesBcyuGjN63pVnO7D7HMp1+SLboJX5mBjENHpeV95N79rU2/jfjAP8Y+Y5iBV4LAXZ/84cJTfv7fYUjOO9yRVBeYCZIJxzfxbsIeIM9s+lChruMxYuqJePFlPLMJbXA8a/i+Gn6S5NjmUTn5JTA6J/WhfJ9mwvfw6I/3182wy0BlcI/Ab48TfJqj92R3jNe1njxERxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RpZaKdi0C2hWqPuq8uxqcC9k15G9Hv7Cdqp0qEaSHlw=;
 b=eUm5xCpmg1ym/P/imJpXzf2s2HpfrycbetOOQlVOE93UvLwS8aTyKwKy0zkDvw32U10xJD+MTELggguOju/1bSuZXdOZ4P8kQ6IXwF7NWTlq1wicD9EMEeqsdiJhUgml3aVVIoJbXAYXJbobBVP2iCqy/za5t0hpVJL1mIvLljorKGlNlVLUrYe+U430D32ODHcOfH0eFLSxJZbQkoV3t0oxlmcQhvlXbJoQY50ODRb4Ec4ufADvR/k1tyet0rKAyCDEEDtJr5Yftg195w1uwKXvrRqa1P9uKFO/xlAHnLdcBLnnJ97v+8EJ7vuOpFT1jRW6+BDZAo9BxRa/O5bZBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpZaKdi0C2hWqPuq8uxqcC9k15G9Hv7Cdqp0qEaSHlw=;
 b=wg6ltVQ9Ek5TTOhIZkRTrpixMa9MB1Hi5DV8Din/SsFvefqUyIdxdcnMbODH6Jir+jYTJ3nFGU0Z0nP1DE1qtb59FWkhmVEw0QsTu/3djWWvfwHVPfF6ReaGijHvALM7daaqM4MWGDGGtPv2aoTe6yHHvs9OfBfEqoZgk/T0cH4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4173.namprd10.prod.outlook.com (2603:10b6:208:1d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:27:49 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:27:49 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 00/18] xfs stable candidate patches for 5.4.y (from v5.5)
Date:   Mon, 12 Sep 2022 18:57:24 +0530
Message-Id: <20220912132742.1793276-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:3:18::24) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4173:EE_
X-MS-Office365-Filtering-Correlation-Id: aceb6b98-6940-4905-98e2-08da94c29634
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IDQ2Pb5ACutTiatgxa4i9nAJMOrJaa3IQthIw7pZ3yMDz9QAZYzqP2azTAxbmy/6pDNuzOTWVOyNKraMSvPza6P/6yoq2nm/CFgK2EcOR2qNc2dzap6ZKSzNr/XIqQDHXr5V/b491gXOC2yLNQ5HpZ/ni8b588hzRRDK/6Q/VW6ubieDRHAqmbjCScYaSaQ01J3fatlGl3Hfi7u9MxW/zEKhb1eZ1n2KO7ZRQ/y+lDhFmjvP4c0K2GgN9UPBDZ9N41hp5AS5rs2SOt3TaD8+cx401KgI60yJAdH/v9FmEbkqsNh9otWQFmuIZbjvoSgfbqio6+PrEFMcjAl3qY68evKUjdrCKl9cB4mzxOmaGchIBATEqPR7POWWNRU9ekfhhWI7CdThn7jJyPX/Kjvb/WvCglxh/0ylMedtmoTiDT3Zt4GRKdV9WTDSNkNP6sz7cZMzqUM5BDmr2j7aqfod1F1C5hHC3Lgdtl4uhSUILKrox4vunwqFl0gZOd0X6udDYzIiNn3/54eaAug86jmDxQJlnTeg3QmINEbXg6a+8aIPDoYR+NVTkASBaNGalV/eTrRhKZIvpBo0MR0hYLtjKk7GnpWbcephsvSyZQlJzs3NbZOEWidjMS6EtAr6ev1/KB8tYIACuTfR3Fwza/Z7taxDBMO5RIm4v3nDeNxLq0qJc8VeSPn1s/nlV1AfC7nZpPX8i5qTt6+k4xcUhpl9GQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(39860400002)(376002)(346002)(136003)(316002)(6916009)(38100700002)(6512007)(2906002)(5660300002)(8936002)(66946007)(66476007)(66556008)(8676002)(4326008)(186003)(6506007)(2616005)(1076003)(478600001)(26005)(83380400001)(41300700001)(6666004)(6486002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZcbZDTeqreyI2K4MV589iVFlFuc9Ki28baBog6mBLRnUmWQr+juDMPUGsfOY?=
 =?us-ascii?Q?qSqYO/zgdyRKz6Qa0k+xfI/16nU87Uf3q6lVDQiEfULk48as+GjOpGa9sI2q?=
 =?us-ascii?Q?/HaF/pqfuQyko4CWouDUtR1eCM9SYDoJhSIebDzBcM5uXCnvLNheDFkhStej?=
 =?us-ascii?Q?oxyPeQLSijhI2148lXUutILxr8gK/841kwut9m0EWXOhktrCaNUUKYTmIx1C?=
 =?us-ascii?Q?HiXqKMRDVnYwmQ2VJuv6S+KFp+VdjJBuYm0umiR0Sywqrz4Nhi12jKd/6s3I?=
 =?us-ascii?Q?V5tYg6uhjiYLTL4/dyELS80k/Aub0ksFENIPD1Cvo0B2D+UMUlGQFviDfBRt?=
 =?us-ascii?Q?PMDAiGq6LPXYyJ2d/Xf6fJ2Ly0AfHFJnkYJtPpsa0j6gVzJx295t9pj69rHa?=
 =?us-ascii?Q?/gGmh5ndFRYNPUN9ATE4YoH0hXjlxSAMI9mib5SYXLlV3QF+na5stf7LbHEX?=
 =?us-ascii?Q?M4ddqDV6MXOHANcPqwEhB1qkyTVO8QbaV2PoDZ7Wfg8UHpAqAqtjHAnmTjJU?=
 =?us-ascii?Q?nGdu8C25Q+tea+oyWZj42XMkyGbjqkg3Kdb0tBk2LcSzpz6nXVpO9Xzu8l86?=
 =?us-ascii?Q?rO21xMKO4086l2JZv/J/pzGA8In86TCE90XJGiiwhp9gPCObmE6ncusWbr0Y?=
 =?us-ascii?Q?riYwJ9Nag5p0ANq1HITDmrN1mKJekcf8m+/sQ/qGdiQrFh08kYccawOCIhau?=
 =?us-ascii?Q?UXZOIOBQIFXOnkCsBwV+2ztIoJ4XATFxshc7+n+FxeVX4Cbl/RccqWng/+Tf?=
 =?us-ascii?Q?bKhA/uyBI/ZoF9FIz645ZFvcKDzdEiT2Z6He/ZMimYaCFfU+VhC7jwiCVW48?=
 =?us-ascii?Q?O6pO6G41sTPXMQm18iwsamaNxgz/lCj+SFg8x23mzTvYhMTFkgWepSRbPAv3?=
 =?us-ascii?Q?NvpMjODQ8+paChSabMnRByLszAv1uLwIJHo8zApIdgM1rS4G08RNotCZbG67?=
 =?us-ascii?Q?nPMDXSM98nTYPt+UYPEmQgjJl25YwWRalyixPg3Cm3ekoHjd3xoJwd22ll10?=
 =?us-ascii?Q?bIAABw1xbjq/Hf5FpbQS6A2Tni/YTzERJ+HkF3Y+hru4nDXuauJluaSEJzL8?=
 =?us-ascii?Q?1J6AzFU3z4KKMeywxSe9/Px5edFbMTLDSi8qqzusGPucq/ZOoLvfrg1HKWEE?=
 =?us-ascii?Q?+4JYUVngHvEBR+rS+xVxGp6/jI9K1HoNaX+i6cSgFu+Nx9fArEl9oQLdUyoE?=
 =?us-ascii?Q?4tz6XRJrEAVOxm/sLnempUJxBt3S4GKEPEIuEGcpSbaigpaXM0IWt3SEgbje?=
 =?us-ascii?Q?3BzgllS2JGmRmnQiY8G2GV1jYD3odrnukQmKlKQNBqK4AQB4nTmHmkP4Jobd?=
 =?us-ascii?Q?jI9rywGaKu2Rp/6ogA1FywpllBPHsD+KCFLqwN80pD6Az8qykuea88NT7WeB?=
 =?us-ascii?Q?6XIwq8aGvxeMjcPP6nfYrVXsPiPXotJ66WLcP8AqBPmp+2FhR5rbZd/xXPh2?=
 =?us-ascii?Q?YkfqgdEXKmNB4YVaH8CPZIJPMjX9YVxPyrj4ZqiaQqY7B/jc4Ycg/w7D87Io?=
 =?us-ascii?Q?J7oVEoxcxUsW/dWgeWnX0/qbH8PKBU3Nyd+TsdeNLms/EH9aXQUSj5ksyet3?=
 =?us-ascii?Q?KmUarmT9HpMJpqXLGbNa2KthCoY+UFNEB7AeDZqkCie/IdZKguEdTCI5a+gq?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aceb6b98-6940-4905-98e2-08da94c29634
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:27:49.3754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RVkYQY9dTr4pArubjDU4kESAbJJWIoNaoUjZCTbWwUql+nt/D0n3QWEjMYw692f9a3gKL0tVdDKOZC3M8DvXVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_09,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-ORIG-GUID: 7Th8XebFw_pKv89YHjBP-1vtpyGORpgt
X-Proofpoint-GUID: 7Th8XebFw_pKv89YHjBP-1vtpyGORpgt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

This 5.4.y backport series contains fixes from v5.5 release.

This patchset has been tested by executing fstests (via kdevops) using
the following XFS configurations,

1. No CRC (with 512 and 4k block size).
2. Reflink/Rmapbt (1k and 4k block size).
3. Reflink without Rmapbt.
4. External log device.

The following lists patches which required other dependency patches to
be included,

1. 050552cbe06a3a9c3f977dcf11ff998ae1d5c2d5
   xfs: fix some memory leaks in log recovery
   - 895e196fb6f84402dcd0c1d3c3feb8a58049564e
     xfs: convert EIO to EFSCORRUPTED when log contents are invalid
   - 895e196fb6f84402dcd0c1d3c3feb8a58049564e
     xfs: constify the buffer pointer arguments to error functions
   - a5155b870d687de1a5f07e774b49b1e8ef0f6f50
     xfs: always log corruption errors
2. 13eaec4b2adf2657b8167b67e27c97cc7314d923
   xfs: don't commit sunit/swidth updates to disk if that would cause
   repair failures
   - 1cac233cfe71f21e069705a4930c18e48d897be6
     xfs: refactor agfl length computation function
   - 4f5b1b3a8fa07dc8ecedfaf539b3deed8931a73e
     xfs: split the sunit parameter update into two parts

Brian Foster (2):
  xfs: stabilize insert range start boundary to avoid COW writeback race
  xfs: use bitops interface for buf log item AIL flag check

Chandan Babu R (1):
  MAINTAINERS: add Chandan as xfs maintainer for 5.4.y

Christoph Hellwig (1):
  xfs: slightly tweak an assert in xfs_fs_map_blocks

Darrick J. Wong (11):
  xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
  xfs: add missing assert in xfs_fsmap_owner_from_rmap
  xfs: range check ri_cnt when recovering log items
  xfs: attach dquots and reserve quota blocks during unwritten
    conversion
  xfs: convert EIO to EFSCORRUPTED when log contents are invalid
  xfs: constify the buffer pointer arguments to error functions
  xfs: always log corruption errors
  xfs: fix some memory leaks in log recovery
  xfs: refactor agfl length computation function
  xfs: split the sunit parameter update into two parts
  xfs: don't commit sunit/swidth updates to disk if that would cause
    repair failures

Dave Chinner (1):
  iomap: iomap that extends beyond EOF should be marked dirty

kaixuxia (1):
  xfs: Fix deadlock between AGI and AGF when target_ip exists in
    xfs_rename()

yu kuai (1):
  xfs: include QUOTA, FATAL ASSERT build options in XFS_BUILD_OPTIONS

 MAINTAINERS                    |   3 +-
 fs/xfs/libxfs/xfs_alloc.c      |  27 ++++--
 fs/xfs/libxfs/xfs_attr_leaf.c  |  12 ++-
 fs/xfs/libxfs/xfs_bmap.c       |  16 +++-
 fs/xfs/libxfs/xfs_btree.c      |   5 +-
 fs/xfs/libxfs/xfs_da_btree.c   |  24 +++--
 fs/xfs/libxfs/xfs_dir2.c       |   4 +-
 fs/xfs/libxfs/xfs_dir2.h       |   2 +
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   4 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |  12 ++-
 fs/xfs/libxfs/xfs_dir2_sf.c    |  28 +++++-
 fs/xfs/libxfs/xfs_ialloc.c     |  64 +++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h     |   1 +
 fs/xfs/libxfs/xfs_inode_fork.c |   6 ++
 fs/xfs/libxfs/xfs_refcount.c   |   4 +-
 fs/xfs/libxfs/xfs_rtbitmap.c   |   6 +-
 fs/xfs/xfs_acl.c               |  15 ++-
 fs/xfs/xfs_attr_inactive.c     |  10 +-
 fs/xfs/xfs_attr_list.c         |   5 +-
 fs/xfs/xfs_bmap_item.c         |   7 +-
 fs/xfs/xfs_bmap_util.c         |  12 +++
 fs/xfs/xfs_buf_item.c          |   2 +-
 fs/xfs/xfs_dquot.c             |   2 +-
 fs/xfs/xfs_error.c             |  27 +++++-
 fs/xfs/xfs_error.h             |   7 +-
 fs/xfs/xfs_extfree_item.c      |   5 +-
 fs/xfs/xfs_fsmap.c             |   1 +
 fs/xfs/xfs_inode.c             |  32 ++++++-
 fs/xfs/xfs_inode_item.c        |   5 +-
 fs/xfs/xfs_iomap.c             |  17 ++++
 fs/xfs/xfs_iops.c              |  10 +-
 fs/xfs/xfs_log_recover.c       |  72 +++++++++-----
 fs/xfs/xfs_message.c           |   2 +-
 fs/xfs/xfs_message.h           |   2 +-
 fs/xfs/xfs_mount.c             | 168 +++++++++++++++++++++++----------
 fs/xfs/xfs_pnfs.c              |   4 +-
 fs/xfs/xfs_qm.c                |  13 ++-
 fs/xfs/xfs_refcount_item.c     |   5 +-
 fs/xfs/xfs_rmap_item.c         |   9 +-
 fs/xfs/xfs_super.h             |  10 ++
 fs/xfs/xfs_trace.h             |  21 +++++
 include/linux/iomap.h          |   2 +
 42 files changed, 533 insertions(+), 150 deletions(-)

-- 
2.35.1

