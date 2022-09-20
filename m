Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0BEECAAD8
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiITMs4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiITMsz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:48:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326C36B8F1
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:48:51 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAPJmD006020;
        Tue, 20 Sep 2022 12:48:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=D2ZYftHq/GIdTf79+X7w9qhjfDFbLsEh9zUbpurOhmo=;
 b=MK0IgzRgAi3kAHKctZcJ0keHFtALkt+M7KgEjNqWB3Zh+9cKqcXXhge8W8KlQgOXmF97
 4fzLpylCRIVIpA+KbkhaQXEoxTM2XjcdNMDDjW67YNBdeTzgm8aB4QjTLkyL2vykXZcS
 CcOEQA4YGXJOwgRKrJuGAw5YIKZlaYudczyXOKNi8XS93iTJyxPQz+13fTPqSrXe9c7C
 EiY4oAVO8cisguWL+tiUFbQ7DzERNACwntvbuqAJYTceoBJVyA4ZwnNiyy5kLmRfCvK8
 NH/ZNhRje0xoglLF2IeZdIcSnkDVVWw2kPp8swXn8mQmmJOpDUyajH+foh4OI17GpF/8 Dw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kpt65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:48:46 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KArngQ025548;
        Tue, 20 Sep 2022 12:48:45 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39drhd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:48:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/6EwBDjRBpAse6XlnFnv45/Cj5uSFo+SSlvyw+VWyA4bP+ZT9jrji1aYRBMU9fOEcriwz8n7JG/4L8U8KcSDTbza941UpXfIai/O3LGjuVUakYsLDOZ2AfAwbaut9ijnsPNd7y1rmGmByhhLIGWzQNjv8X10y4LFBBBmMXUDzCkBhdXJ5Hp+RGf5OhLOHDktdTuXzOhHm0xCq0z3HxEy/5+NHNUMYEAcIUwE4S29dk2xqDe5HOCVbXuw+6rq976aVuGfoyL0/+7hkGqLeSJZ4dW1ZFMyabho7Yt5kc1jBlKfgUlcOD10X30U4fpSCt4CxVaruiv5RFdHZ3E38Ndpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2ZYftHq/GIdTf79+X7w9qhjfDFbLsEh9zUbpurOhmo=;
 b=FhN3lkx4vlagAqTJ8eFKM33OpWX9iwxJ5LcUhujqpi7lFyD3LSRHJj8fz87m2kwM15RBq8bIiUb9crgalz0mNVQD71sCDR1QW+zl/K0UVCd/NacaXZeFhrgHgYa9Wbps0tYqsMOePhID0IsWBV+6QsMLMaIRSPEPMGjojQjpmpGumSyh5e/yduyK/8TJ25XGwb+1dykgLBHq74a+oIr4iiVRSDg+Uoqdm5A5KDjUb93ZKmmzhwTb+y8V1MTokHvFK2NsFl1AywkP8TgYVJQaDG+Jy7y1dVVUZw9AAxUZEhPkShfEvfCUZvJ//Z+UgcR0Q+nL4gu6V+/KdjhOowsEyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2ZYftHq/GIdTf79+X7w9qhjfDFbLsEh9zUbpurOhmo=;
 b=K2CPLhCla+uN+eAzTShKL3E67Mz7Im0dfM+tJceb/URx+NIf5EG56eYkM2s5BE6YQRzn878GHKhU/H+v5a6HaUJfhrBiUU5mh1jTbzaPJUbDjDaFkdPXIJipNZwkLbwU9HvoL5y7wnwRW2248IPufbYFHamyDJDoUInMxwS4z68=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB4987.namprd10.prod.outlook.com (2603:10b6:610:c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 12:48:43 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:48:43 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 00/17] xfs stable candidate patches for 5.4.y (from v5.5)
Date:   Tue, 20 Sep 2022 18:18:19 +0530
Message-Id: <20220920124836.1914918-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0061.jpnprd01.prod.outlook.com
 (2603:1096:403:a::31) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB4987:EE_
X-MS-Office365-Filtering-Correlation-Id: f9990e66-36f5-492d-de99-08da9b067307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fqevYZFCPUt3Chv1QKzBbVX5RLfgSknYK2+b3ulpWkl7jgP/xyd4QJldCzmdGZsjP3MTekwjBuS9ormvvmWHMPAOciqnJfBbJsh0XppPsYSYG4G1GD8HOcd+G2be19zHoxoS/LfkOCkQdTbOus6KG2BCu3VpgRZVQieo0uPrtmMIN6moVCNU4Vjl3HJ1jqcnmXOA5ZAViTxvmN/WomnQTbtiBX+kGq1KvsTgfxj6t1X0XWi3Mbjg48pisCSWQxQifJvtuPjw3hBRiFjfsmSnP41WzjMaY10grataKZ1K6l9D4AILfnnLmEJOVyyTGItSrZapCEyOz5MkAghzoEgjpkkuFsBcfP76FsIRiBX3lTt/9LnTktm3iA+QH5UZgiC9UrA0u3vWvV/PUtsyPpXtTAbeePqvPvfaeTN2BaE531VJ6RapCvZlIgDh6CJtEdvLoFQvM3tSVm29xaMomPqXKgd3wMPRNkHBZhmr03fZ0LtDBkjGhORVmjOugMFo8sQjRq/cmqShiOnoscKEw6hALFugHC+HUbgENqcNFgh6LPBzsDxfWZySrJ2W+czzMaTdlIAeHCCFkXONPLey06xOA8NQt3QQgs/32kQ99T4/88WnLDLGkX13bXQXI9YsZWAcO5zV4GyKZbPmf9DRcIgMJLibkH3qzbmnQgiTscqd8YDCWdJhTgb861dxdSzdu1QL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(66476007)(66556008)(66946007)(5660300002)(4326008)(86362001)(8936002)(6916009)(316002)(38100700002)(8676002)(83380400001)(41300700001)(6666004)(6506007)(6486002)(2616005)(478600001)(186003)(1076003)(6512007)(26005)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hN29Um0ridQkaogLl2ps3vOKVUpZ9bAFHQdzFY4LW467A8vFSEYz96fwjVe9?=
 =?us-ascii?Q?sY4sZ5eat4WmTqTGlj8eB/7taTO2eiPFYZZnbLAG25gw721A2klayq4JsJgS?=
 =?us-ascii?Q?AuJOX+gtN32gSGFzx2ipTS1PSK0qEYS78xkDDeT9m+A53/Z8KhGIOd7zSllY?=
 =?us-ascii?Q?w4wWwNecP0WBen4ixVHMJCMUf0Iulk1YTgtsyWiDhRgV/JPMisrHHDxDits2?=
 =?us-ascii?Q?AKTrmkyL45agotfD8UY1WlVd78IdY0RU4WDqIJf2RbqOPzseZuEdX4n3BMg7?=
 =?us-ascii?Q?Wa7iA6dYQUB6lK88vkxhGWA1CNtS67nKb/OvAhJUxE7Us3e8MCROUm26YE7g?=
 =?us-ascii?Q?tReHuhz74uM4VObZAdUnU2dXvWslLOopQisHHKOYqWc7Db8QmKIXh4KNCoQR?=
 =?us-ascii?Q?2lPpiSGZU8TZPeRRSheq1gD9gZ++oWlASq83wRDLcXztNpRjlN50tFcnjjAu?=
 =?us-ascii?Q?/BHvIO8xA/w9aHaRoD/pCSiZrzcY1t+3AmVXtUcb3osVAflfwCo5A7NtGt45?=
 =?us-ascii?Q?jPUAXXhPkx91AiQt5X2jvInJ1GwEG+/UEeE/TfPBDxxg2yFpjKEtBwaXtzbe?=
 =?us-ascii?Q?zHu4u2xQy28yLorRfh7YgWFXdksDn15FIIYJM6s8H5hL0qhuqA5rKs6eij6a?=
 =?us-ascii?Q?GQ9VWda0hwgvBR1df5hqPKlaYWecsz51lAxI6NzNpHF0l3X3oxlBb89K6ZkA?=
 =?us-ascii?Q?da2o4LnXs3aUz7vjx+ZTGGy1Xg5ecXU07iH3wZ5RWa34xo3in3YUfwjM8MCL?=
 =?us-ascii?Q?jiok+QZuDIq0ApP3gxLWeF8ST18t5qvlu10Me+jtytfliaHCVztS8O7MzJmD?=
 =?us-ascii?Q?jC/UQYQyaY6qZr3afoUpib3YxT8diBvtpJhMsDm0iR54h4LpBk0ZC2YfupIV?=
 =?us-ascii?Q?aYplhvUKUf5Y1AayAooI53sZoOD7bLZ8RwIiarHUuNcdGWqv6n+WYJuFPTQK?=
 =?us-ascii?Q?nqX1Rho/rHJ+jXv7ZO6bRpNg6OKqwBimgLLaD2/NPc2Rw7BcmETsd7asZNUX?=
 =?us-ascii?Q?t434gXaJThvvlaGoRKqSay5XrvIfvoZR73L3QjpOujO78JtUcSop3EMYWYHF?=
 =?us-ascii?Q?UQdZbrKUAhgkOkj74N5bc/do/4oIwNlwudRiPzUnXlFyg/12qz7bHSV0XBEh?=
 =?us-ascii?Q?uDuLbT+bE+LDHwxDu5cnDNielpDo6ZA6fMbBDpSb0Dzq36zfDioMaoMwJTa3?=
 =?us-ascii?Q?MBoYq2Q73og/Y9lSUAuNflxX/GQmU2imqT4gBK5TQkDpWepYdah7F6Jsylad?=
 =?us-ascii?Q?2iCRmHbmH+PBYDBwerxhikQ3aWhR4FL/dN2f4lcz8Wv6+oyAjKPqSlv0KahO?=
 =?us-ascii?Q?eX/Yl+JiGfrNzDAkHS4eUau6jJtJQ1S8TTr9QWXKapx/fb6e4PwHPDB89dB9?=
 =?us-ascii?Q?n+vVjdqA5f+XFx+H2egsOR0enazL9fv6W4hHinW0bI71e5ai/QH2j9YU5+Hy?=
 =?us-ascii?Q?5Rs9nt5aXPTHjHyOhl/fELl+kQpv096nMLhSCxxPdHJRsnKUTsKLI+2KQmoJ?=
 =?us-ascii?Q?+6ytzE3c0MeAUFfm1w3xykNASAcqOA86h75/eD9ODIIM4/kze4ZW11Tmwdhr?=
 =?us-ascii?Q?JL/izFqb1fAMMNlOAPY7VLOq1QxN5FKaV4gaFeum?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9990e66-36f5-492d-de99-08da9b067307
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:48:43.0850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1GuarHCU6Axd1l+HHO7Na/D10xm2Kt5mDREXuEuwc+MQvsoo30PBZM+IEuiEOQKjeO8N19bWML016Pg9r6Nlsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4987
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200076
X-Proofpoint-ORIG-GUID: 3pwaopsVuG_jE9qZW8tYQ3jyAuVck_Qb
X-Proofpoint-GUID: 3pwaopsVuG_jE9qZW8tYQ3jyAuVck_Qb
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

Changelog:
V1 -> V2:
  1. Drop "xfs: include QUOTA, FATAL ASSERT build options in
     XFS_BUILD_OPTIONS" commit since it does not fix a real bug.

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
 fs/xfs/xfs_trace.h             |  21 +++++
 include/linux/iomap.h          |   2 +
 41 files changed, 523 insertions(+), 150 deletions(-)

-- 
2.35.1

