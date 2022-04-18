Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A80C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Apr 2022 04:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbiDRE5c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Apr 2022 00:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbiDRE5Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Apr 2022 00:57:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291AE3A5
        for <linux-xfs@vger.kernel.org>; Sun, 17 Apr 2022 21:54:47 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23HN4ifb020195;
        Mon, 18 Apr 2022 04:54:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : message-id : date : content-type : mime-version;
 s=corp-2021-07-09; bh=z/juVyJUYlUk3Ik5M1bQFkL0q/LgeDiBL3WbuC38k8U=;
 b=NG5bNsY797G30Lx7XqNZccLdtg5Y+k+NzPrFJSWX1pMYERaDSoI5oQVZB+DKjLfFeoP4
 EZDAEigF43kdCHIGcnhFZyudck1ixn6XguScSuVRZ1PiibOwQFr6jEHZc49qyOwXBSBJ
 Om4ultuLa+HKbxfcd+e+0rwEAimuLkot5kVr0FsuloC9Xr8yEdLqRRiIhJTGh/0l3TLj
 ddpCWSDitIQ3ZEROnfzoHwu6Z8+nPdzE97p05rTmPwYujDUSl4xSHJLnV6pFXsYohzdi
 1TgGkx73o2IDzH1F5qbDo88VIOtmyRgUjVGBKsaDEnRp7XgXosx/v5f0Nk0mVdC2lAPp +w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmd12e04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Apr 2022 04:54:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23I4jxH8011431;
        Mon, 18 Apr 2022 04:54:36 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2168.outbound.protection.outlook.com [104.47.73.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm80rutr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Apr 2022 04:54:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHJDSWhVOIaLcN9qxSO4YN4fckEB10k9jSdrYRIucfoszzEfGwBrfETsEeiroW+Cwus/q8hxSSQFbg679/dAWTEvfuu04OdivpIWoONgpt2F1ribn7+YLRZN9/YAdjyTjYKbmCRQDd1UFEFlIfxqQjGW+z2Ot39Gsah05HKHTLvAy3ammAmA7QYGGpjMb2ZWF0A5WsmcNsFMOIxK2QtRw0a1l68QGqPlMLsBc2QLskkWfOe3vMUrNWRHUOqVsUuAoGh1cSqR3UeLDTDYYi58JXIVyWA4uQgwxMoOCZcZLiLkDSXmqiyoGBvT2WkNBP4p+JX+zbVCXNA8plQoGL6I0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/juVyJUYlUk3Ik5M1bQFkL0q/LgeDiBL3WbuC38k8U=;
 b=mJSg5cwA9GegmoVXti3wM/zn6RhWq7VpYtypKWsgHb7JqvIq82BP9zfh91F3a528+xuVKBaAkvFwDXzDIRuy85xGv5y8J7HswS8kwaKeCjxF57eaoqMcyypvCOpvw603W7iNii1IakDvKgNbwToi8SQ+75lKVROzPKTokK4ysvyFKpaDISFhuYqKy/q/j9VbSvTIWVgYh/Bjgs9Lfq5bAVZKMFvLfQYrpbw6Yr37u5Wzy8OTfjIsguQRYRf9otjCz56PCH4KPFlK96C/T8/dAOpJGxWMi6HuRXfKARBEObWt5RW8DxYS9vtJ2/VgERT4Cds8egtmRaRYFaLOL89dhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/juVyJUYlUk3Ik5M1bQFkL0q/LgeDiBL3WbuC38k8U=;
 b=QOhX7tou8+SMUE0a7P5Ex9P2rGxtpV5xebi/VkXfYa5Mn2a1o6g2zP2SRZNpQk0GfbUmY4rnUISye8fu7xNMtoBSSPaspARrJDkFDfQ7mj8QNbN26uwVslR1Y9Zw/ViVbN5pbj0diN6fZZjivWh2Xgtnx3sriGkyyVNKMdcUjtk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5546.namprd10.prod.outlook.com (2603:10b6:510:d9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 04:54:35 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::9874:fcc8:51fa:8fb5]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::9874:fcc8:51fa:8fb5%5]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 04:54:34 +0000
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [GIT PULL] xfs: Large extent counters
Message-ID: <87r15vouta.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 18 Apr 2022 10:24:25 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0065.jpnprd01.prod.outlook.com
 (2603:1096:403:a::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1993ca08-0194-408d-5852-08da20f78884
X-MS-TrafficTypeDiagnostic: PH0PR10MB5546:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5546907E0E76FF9A391BF681F6F39@PH0PR10MB5546.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v00Pc+YsVjwj1HLgtA8s90J8uuxtCgH+8IK1J3LWwVJNUW1EVMFMlYBafHrowQIfH5C4X/LK2iiAkllAZkUi1Sj0Eu7SYXb+wEC01zfj8OXWEbtitttb/O/UvNGx8/6BOfRs6mTqraeMTF5DucJHXqyF2fncpWvtUo1X89re7wMBk1BuQYfaZyp6+yo9pS9DF/g9sg0hYQCtQhoaIUPYpdLoPj9RfF2cHwYICCdWBmuzDTygLeWA//mel/Q4thn6+1/Hg7KRSOVm1lahRdsnODLbHhHY2xs9IYUlPfuBfLX9CrT6ZN/gHGfmJXNb4VGhkw394acB5EQFuF0Yd1CuvG0CeYnvREcAsWv3289hoktoUqV/gnQ6aH/kcJkf7cSAnfHTH7pQDkouyHzUKZdlzQq23jJE5k+J3NKZodripJK6Qs3KALvil4uj5rQ8tk6mYzwtSKjBxMLLBFXTWDFT9XoTC6goy6ACPKPO8vVmhhfNiVsdIhV5Ia6wo59yFMZkgjhNndK/vnUeX8B/UkHkXYgXd8X6DTqQkM55OUGeWqOBHQiW5p/ZblGuN78jUuWqksqYj8CkcIHrRvCNRFMLgfeB8AeyzMQDC570wOoeun5nGopCpph8wCy0AXjy9LrPiseY1fvIqn/wuc+D0w1mnF/S7SeQNDLbsf8i+raGs6nAoepadRdNaEqJpB/d/z44b7EMPhr7QiBUia8ysOAa00kax66w5xdYP8zHMZYcd4bnDXr3VkYwUMy8iggB8165z27rhQNsWihzt7BImPraBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(5660300002)(86362001)(83380400001)(6666004)(6916009)(966005)(66946007)(316002)(186003)(26005)(38350700002)(6486002)(38100700002)(4326008)(8676002)(66476007)(33716001)(66556008)(508600001)(8936002)(52116002)(6506007)(9686003)(2906002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X31ew9zEGn93B3/aeuCqKshvbEAkb88htOgKCE5L5LZJ9DNy6NrdXoURdANt?=
 =?us-ascii?Q?HoZYxQWMWLfMWp3CnNMs352wkKl6PG2bdqdu9SgS1swMMiEJm8Ldg38CThJt?=
 =?us-ascii?Q?+0mTAsFYP9gdGwp4ivjoHih7/Z4Jl6dBhUXfWqA2Fxh38tSvPgU/RNXaxsnA?=
 =?us-ascii?Q?vAHVnTp5i71Jep1r6MS6QMb8b8sWgJlmRoYxn+zV/JXZwLxQnaXLgYzX1Wts?=
 =?us-ascii?Q?FAgFWRHfqHMLYg7GFsbpttDlvKtxJG/w0/OkZsdpNTtAp+rCOufg4zIbJNxx?=
 =?us-ascii?Q?3zBUlFy3lErVR2wwryx7AJmtmJQLyMZtIuGmiZyByffiwe6I0Gz8GUBE0l0q?=
 =?us-ascii?Q?Nh7KV2aLD0Skody+UuKLamhoGh6CrFr8UEEfs9xY7w1jLcxJx6+lZOa8NV8n?=
 =?us-ascii?Q?egRh/VCqSMG9idDohai4I1tfdPrKPJ6GYuUXnAhoM5qfusn00T47DmH0fCjd?=
 =?us-ascii?Q?U4fwxvhjC2FtbdQqI7ACw4lwu24hcviezJHEl8Np556EZqlUbtcAglY1E/TT?=
 =?us-ascii?Q?k3f04ZqryxKHn4N/sVSBZZAPrGkNBUJqGQMXEWYCJzn+mODvvJUqj2eIiGrg?=
 =?us-ascii?Q?KmybFgMTxJp3dgJ9PaRYAc459ZjbNNy39QmUpuXpfjr1sHdv17zTmQcTNTyy?=
 =?us-ascii?Q?dc2R7wZ2KEZpXPcf43Blp9ui7YhhxhiQf/u54k0bIM5pcz03OZIoazExq/il?=
 =?us-ascii?Q?dLwr1wNj8opmJgK2YbZEv9cggiVrEmA5zxDyVZd7Sw6S3WatqiJ+6exE0iE5?=
 =?us-ascii?Q?kfYK/frJdPsrYObWyaFajZee6qkqKd5Idcl1kVvwiXBgBI8CxrCnCLPh4BGg?=
 =?us-ascii?Q?4MTvUd5uhZqdtOXmQVPuUpS2t66Cc/bBPOWnnrgNIkEv6dC42cczJzuruBKa?=
 =?us-ascii?Q?NcgQU7m2alVtuCwmhoDqd+baFwoBSe++BgvYmtFSafc5tK0ax+tP6XKiE5nX?=
 =?us-ascii?Q?d/G/G1LYCisfqhKcefm2tzY/skeZ+QvxOFPGulh7Nq5rxV6RBZsiJo3NgoNT?=
 =?us-ascii?Q?8jtDhZ4tc3GdTj52Pz2LUkR2aeJNDIrnSwhb9vcNFaM3PvP8Hxd0i52UJrFp?=
 =?us-ascii?Q?nqaXQCI8K+BMhG1LXC89MHjar0hc2PgnyhoVCRKhFCJBNwY8AI89vvQvKSSv?=
 =?us-ascii?Q?/YKi14mdbKmNERdQFOMEk6Q4FfOYS8G5uCNld1zmRETxZAzUPF3JScAkdCss?=
 =?us-ascii?Q?Dtt6dL7KK2/LvzV2h1NgEhojHukUszqv98alUAkRwUj+q/MFz9qTKZhl63Me?=
 =?us-ascii?Q?j17kKhCab/GpB6BinxOYXqWEh/7keGwoYJNfVZVqhd4V+nsqAtFIHR+4FNT/?=
 =?us-ascii?Q?bJYeBoo6Qzq3OSKwLGdwaDJOkh54FAYZwCbeIV4BUe08HI7hWBF/cm4btxyP?=
 =?us-ascii?Q?jz+cUMUnc3acGt/Y6iUSZ+u9O23/ZqHVL8sdnHtBNrCvA5fRmwirSFFdFdI3?=
 =?us-ascii?Q?Rm2/1myATgML+Njh2tzlNLMiJGbn7MSBC8MxnlPPP2jAuIsxkGkMDUXWn29U?=
 =?us-ascii?Q?/QN9637OKBf4yk5rMSmUdl/Js76ZhV6peukQAcxjS/5stStD3mtiev7G3hrd?=
 =?us-ascii?Q?pMGhkuFZASUODavB0ksIIZH5Qz2VE3dnnS3svojKg/wYfi1roBSPP8eoBVIc?=
 =?us-ascii?Q?2P5wvAucesIM5a9j8mkyvwWWjd9NIyLe6y7vNXNHkFo/qgNyzyo2YKhjXsRT?=
 =?us-ascii?Q?e/gJ0TpW9Qgq7sAI0RXoN3HmhPeWvF9W8wnuGx1eMzBFZFRgLdQrFwWXO8vi?=
 =?us-ascii?Q?1+Si2WU0IupmeBkpmLUd3TPYcZIz+iI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1993ca08-0194-408d-5852-08da20f78884
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 04:54:34.7918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+2NbmJNnzFYq0RIFRbTf1j4SvNI6t2HDkwRNVXKKvsQm/an2+nsmuuVGodAPWa6r8IGmidciL2Yt36+f6qS7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5546
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-18_01:2022-04-15,2022-04-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180029
X-Proofpoint-ORIG-GUID: T-R8G18auAJFEXzJEUzoUw2SqQswMiLz
X-Proofpoint-GUID: T-R8G18auAJFEXzJEUzoUw2SqQswMiLz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

The following changes since commit ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e:

  Linux 5.18-rc2 (2022-04-10 14:21:36 -1000)

are available in the Git repository at:

  https://github.com/chandanr/linux.git tags/large-extent-counters-v9

for you to fetch changes up to 973ac0eb3a7dfedecd385bd2b48b12e62a0492f2:

  xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags (2022-04-13 07:02:45 +0000)

----------------------------------------------------------------
xfs: Large extent counters

The commit xfs: fix inode fork extent count overflow
(3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
data fork extents should be possible to create. However the
corresponding on-disk field has a signed 32-bit type. Hence this
patchset extends the per-inode data fork extent counter to 64 bits
(out of which 48 bits are used to store the extent count).

Also, XFS has an attribute fork extent counter which is 16 bits
wide. A workload that,
1. Creates 1 million 255-byte sized xattrs,
2. Deletes 50% of these xattrs in an alternating manner,
3. Tries to insert 400,000 new 255-byte sized xattrs
   causes the xattr extent counter to overflow.

Dave tells me that there are instances where a single file has more
than 100 million hardlinks. With parent pointers being stored in
xattrs, we will overflow the signed 16-bits wide attribute extent
counter when large number of hardlinks are created. Hence this
patchset extends the on-disk field to 32-bits.

The following changes are made to accomplish this,
1. A 64-bit inode field is carved out of existing di_pad and
   di_flushiter fields to hold the 64-bit data fork extent counter.
2. The existing 32-bit inode data fork extent counter will be used to
   hold the attribute fork extent counter.
3. A new incompat superblock flag to prevent older kernels from mounting
   the filesystem.

The patchset has been tested by executing fstests with the following
mkfs.xfs options,
1. -m crc=0 -b size=1k
2. -m crc=0 -b size=4k
3. -m crc=0 -b size=512
4. -m rmapbt=1,reflink=1 -b size=1k
5. -m rmapbt=1,reflink=1 -b size=4k

Each of the above test scenarios was executed on the following
combinations (For V4 FS test scenario, the last combination was omitted).

------------------------------------
 Xfsprogs                   Kernel
------------------------------------
 Unpatched                  Patched
 Patched (disable nrext64)  Patched
 Patched (enable nrext64)   Patched
------------------------------------

I have also written tests to check if the correct extent counter
fields are updated with/without the new incompat flag and to verify
upgrading older fs instances to support large extent counters. I have
also fixed xfs/270 test to work with the new code base.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

----------------------------------------------------------------
Chandan Babu R (19):
      xfs: Move extent count limits to xfs_format.h
      xfs: Define max extent length based on on-disk format definition
      xfs: Introduce xfs_iext_max_nextents() helper
      xfs: Use xfs_extnum_t instead of basic data types
      xfs: Introduce xfs_dfork_nextents() helper
      xfs: Use basic types to define xfs_log_dinode's di_nextents and di_anextents
      xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits respectively
      xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs feature bit
      xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
      xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
      xfs: Use uint64_t to count maximum blocks that can be used by BMBT
      xfs: Introduce macros to represent new maximum extent counts for data/attr forks
      xfs: Replace numbered inode recovery error messages with descriptive ones
      xfs: Introduce per-inode 64-bit extent counters
      xfs: Directory's data fork extent counter can never overflow
      xfs: Conditionally upgrade existing inodes to use large extent counters
      xfs: Decouple XFS_IBULK flags from XFS_IWALK flags
      xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
      xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags

 fs/xfs/libxfs/xfs_alloc.c       |   2 +-
 fs/xfs/libxfs/xfs_attr.c        |   3 +
 fs/xfs/libxfs/xfs_bmap.c        | 109 +++++++++++++------------------
 fs/xfs/libxfs/xfs_bmap_btree.c  |   9 ++-
 fs/xfs/libxfs/xfs_da_btree.h    |   1 +
 fs/xfs/libxfs/xfs_da_format.h   |   1 +
 fs/xfs/libxfs/xfs_dir2.c        |   8 +++
 fs/xfs/libxfs/xfs_format.h      | 104 ++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_fs.h          |  25 +++++--
 fs/xfs/libxfs/xfs_ialloc.c      |   2 +
 fs/xfs/libxfs/xfs_inode_buf.c   |  83 ++++++++++++++++++-----
 fs/xfs/libxfs/xfs_inode_fork.c  |  39 +++++++++--
 fs/xfs/libxfs/xfs_inode_fork.h  |  76 ++++++++++++++++++----
 fs/xfs/libxfs/xfs_log_format.h  |  33 ++++++++--
 fs/xfs/libxfs/xfs_sb.c          |   5 ++
 fs/xfs/libxfs/xfs_trans_resv.c  |  11 ++--
 fs/xfs/libxfs/xfs_types.h       |  11 +---
 fs/xfs/scrub/bmap.c             |   2 +-
 fs/xfs/scrub/inode.c            |  20 +++---
 fs/xfs/xfs_bmap_item.c          |   2 +
 fs/xfs/xfs_bmap_util.c          |  27 ++++++--
 fs/xfs/xfs_dquot.c              |   3 +
 fs/xfs/xfs_inode.c              |  59 ++---------------
 fs/xfs/xfs_inode.h              |   5 ++
 fs/xfs/xfs_inode_item.c         |  23 +++++--
 fs/xfs/xfs_inode_item_recover.c | 141 ++++++++++++++++++++++++++++------------
 fs/xfs/xfs_ioctl.c              |   3 +
 fs/xfs/xfs_iomap.c              |  33 ++++++----
 fs/xfs/xfs_itable.c             |  15 ++++-
 fs/xfs/xfs_itable.h             |   5 +-
 fs/xfs/xfs_iwalk.h              |   2 +-
 fs/xfs/xfs_mount.h              |   2 +
 fs/xfs/xfs_reflink.c            |   5 ++
 fs/xfs/xfs_rtalloc.c            |   3 +
 fs/xfs/xfs_super.c              |   4 ++
 fs/xfs/xfs_symlink.c            |   5 --
 fs/xfs/xfs_trace.h              |   4 +-
 37 files changed, 607 insertions(+), 278 deletions(-)

-- 
chandan
