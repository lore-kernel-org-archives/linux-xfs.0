Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D2CC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244464AbiCUFTr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244797AbiCUFTp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:19:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1C933E10
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:18:19 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L3WgxG031204;
        Mon, 21 Mar 2022 05:18:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=gxSgiuWX+AxfGL9s5a7gHRxgl3RhaEL63kjsmVs8mHA=;
 b=kxKvxjAlK/LiaAcFn5chsC1Le7irCY+/DKDlS+00TAH2wXYhVEFBIOD0V+2b6iYsrPd9
 jXNn8YWGQzZlKajkUKtrBI+Y/jbIx/eLBzv+5GZ7Z7Fk6TBRq3TeDjX2zCgn06aAXySD
 rgXE/8ItU2Kp7a57TOIuRp3eI+BIGlK6LrjBdPUvuCrvS0d1lpRTaenbMEzbyU+/T+C8
 mRIFYfAQHu7pv4pGb2pUlo7uJT6xsMW3DiQOGZDe0IcEQCmXGXI35MZFoXlq8GlySz05
 jGNkBI4uLRQr5YeUU64bF0PeyHYedYn7F94Ws8eGfeZ9meFesCCBO7MerqY9lQ1fWIZh Pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0j4yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5ICX0092618;
        Mon, 21 Mar 2022 05:18:12 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2040.outbound.protection.outlook.com [104.47.74.40])
        by userp3030.oracle.com with ESMTP id 3ew49r2gye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:18:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4vEWUMIWfNLxW3jCPUHOZ8scK3iD6kHUXXGeT+yEnnPq+nyU48KibPYBtVL3/xS2IHQo8+vBAxk0wJeCMMsUu+F4sKGUG+suh9GC271dAbcRKRNDtirh0/wPznCOJCqxCfOpRdZKBUfbFK3dakJNi+EthdVsSvmvXc86cB3BmPMctARqn6f0fgYBb/vCqlEJpOQtvb4tvVm495LZibJxQSw4Tc5n+NcDTpBKWhP6KfhaxwijT9xFBGEqQ3g80cHbehYx7ydQ+6WgsKEUN1DNXIQKSdT+3PqT1m5piSfzXPGAdK3h9AULpnCEWO4toOPWzo0rntpctuuor0THWj9gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gxSgiuWX+AxfGL9s5a7gHRxgl3RhaEL63kjsmVs8mHA=;
 b=RXiNKL7ZiLHLGTNdFIj2VaB/qmnLOlstMfKPGoKD0df/98tF25PjhmgY64hZMPe/VaHIbaNbrNFme4p/4VuOtsx/pL79Hb2vM2mZ5kFiQhNneIOzTc808pm+hkagksZw+2qTcNdP/BnlFd/Q6WZmVYCjbKF084aryDNCYFgf0KSOLmFnEHGob76ueVVu0ymFGzTOGKb25T78uxN19vqQ+wn2o6tzR4jV2+GXy51Lbh+jfhOyz5JBA11EdBAdsYqbXmolpGD3DxnF5xzDtuwlFGC5gm/MT7EBZOWDd8B3l/Y/B46P5c453BoneAk/gq9qoY0ohm9vGgzsratsujjc4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxSgiuWX+AxfGL9s5a7gHRxgl3RhaEL63kjsmVs8mHA=;
 b=ogEy0CtWjPjhpE6gA3Fwn03YDNRVzQZzciBVHdFooFCh4dw4azhq2TgcaIjDIpRb6aycu6XPxn69fygI9sFyL0cZQc+kTdlMeiOmxe8j5zSKbwWbnQgZjs/fYq+prx/s0lRwRi/zS3+//ng7CdfFKmeu22m1lUxYf/Op8cg0dcU=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2105.namprd10.prod.outlook.com (2603:10b6:4:2b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Mon, 21 Mar
 2022 05:18:10 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:18:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V8 00/19] xfs: Extend per-inode extent counters
Date:   Mon, 21 Mar 2022 10:47:31 +0530
Message-Id: <20220321051750.400056-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0120.jpnprd01.prod.outlook.com
 (2603:1096:405:4::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ee59c13-3d16-4861-84da-08da0afa3097
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2105:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2105BFED8DA9351058C81D72F6169@DM5PR1001MB2105.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qfdJMu5rYRs1ihvRmwYLYsJ2a2/g47c0CAiRvmheUYR0Jz4Xe9spz9didQgzLw/wShu89tjetJDnWUuNbaAHEO/olDVegFPvNMY0TFvJzyJs/D7HOeGVUdo+M3Axanzjy5sdYW59B758hAb8cxN/ie+716CeAJuyVokA8mnoEwqKoy3dABWAppyFeh/ke4feGOWABU/WFoX2P3lSJ0prU5xEOKH9RbDlpjfs17/MYYTF8v2zwkO8hPYXssXYiFnDVl77FdunGzgzyzywl47LY10I2KQx1A0OCq3NPUx9Aa3IMH7aaS77HqncmWU8lWVguoe0B2rels/Ep5B1AdXwCbxOrEfpTmf/M6g4Hxjk422C3Nc0Uev7ox8pv/NclBGhtVWIFfK9aD305LPkqqItanzSgX4uU2r102Xs7sx4Poy8wi9/07ITSjz4qv487eY1KBcipQFzFg9Vt2gIzRb98vrVx1mvd/3iiP4BXS+0QeavODqAgYdYqnAOJYEotX+uNZzxWrR4g2W2WfiFARrN0OyC1bdBRGiQZQA4E2/yQSVM0ggtazBq690Pz1lbvivV0//sN9UEgSP5enPQMwJGbiF6pFyzW/nOgBlBFiKs7bPF7aaPMsWHuc2WufAy80xeFbK/BCYr4RDtfVI9io+cjAe3h0ejUGwTEoc3v+Yem+HzwR34TKUFgqw7BLh+oPELNQRHICs8D2NjgCtoM523M/tDLP5ft2jHWaLayyz1sGgyKLGr/tUF8O4HWyyoNOi3Xl3J6vXe5k2/sVsgC4O6Ww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(66556008)(8676002)(66946007)(4326008)(66476007)(5660300002)(86362001)(966005)(8936002)(508600001)(6666004)(186003)(1076003)(26005)(83380400001)(52116002)(2906002)(6506007)(6512007)(2616005)(38350700002)(38100700002)(316002)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?brJEASefiPVVzwVb/+S76zq1INjbMGhLEgZDWdbiuVKrbSID8pfROyFuwT8h?=
 =?us-ascii?Q?HwNes7O9XsRXIcF0CO/16x3fFA9EZgtGi3j8D7vCPLUe0f/30MAXBOW+w4e1?=
 =?us-ascii?Q?66iJGiu0WV1fr/KUWQlu0igk3tTk+pvEtJNfVCEaQHMPG3TGQ732WEFRBj8r?=
 =?us-ascii?Q?2U+Ft+Cf1i/rJdN6u8Sapk0Bs6f1uKLAQM+v0wAG6gemZCTrHnp2zlCEdul6?=
 =?us-ascii?Q?qHebket0zRWnOoAuZMVs5y8Ebzlzl7KZpls9LRSytjev6tCPAoMcDcqvtodp?=
 =?us-ascii?Q?Mx8+SL3dabm1TDrcnC9j2MXo9h/dUWP/XcnekZ/KdU7qV5zXFcVT3BzzFNYw?=
 =?us-ascii?Q?sgn2JKijNRknain0LkEgrvnseBoL40OOrBNRVBPKUOsVACT8HY7s6sfrKmkV?=
 =?us-ascii?Q?qrM72yrO3A5znSCHkD1kRIOHxXDEOHvXj6tT8Zv5LiZk5zL1QRz82drK1chQ?=
 =?us-ascii?Q?o6yvOQgbxMB7g3lgjStosHfp58FAs32OUl1HAtG9g0v70iMMbQTCD1GE2XJx?=
 =?us-ascii?Q?S82jgXJrkv3PTYtLcXdzS+a0pSbae9Ku2AP05i8qpbrHLSk6STHY3bJIiiCJ?=
 =?us-ascii?Q?YCmrumVBjcCaLg1gT9/+h0TtA/po5yKodVIUf4w/EX9zlaKpUrKPq4pm8gqF?=
 =?us-ascii?Q?IrI/RyYxgrcnyiOuHjwFYEGQvZ/o9RhUhcxhJlxYN/MLQELwXCVp8IoSPuHm?=
 =?us-ascii?Q?XuMw63niZkTxU+WJk1yxtlWaSTF5a8q8i3u6bDzAQfproTZoDNwNRMzhq13m?=
 =?us-ascii?Q?io2F+StH6EuvSUDm5kS1iEoqGAdbTcHyJ+di3vnulqkOeyBh9hz52LmjKZYK?=
 =?us-ascii?Q?5O4O1IuBAxtGUTUagAJL8WUwHKgcENXO21O7a2nAMea6Aen/zx1G1rs5xcLY?=
 =?us-ascii?Q?No1ffA68QOg7iPDz/i7Q1kIizX1RSU9QQA6TL8zjuHAxYKUFISUyXJUh/AZG?=
 =?us-ascii?Q?Zi6vn4ekqT3sDf6vuqgXEYHOXB/Q+NaqfEsKpMEqDibTC2zTTYN6lTcfZT0h?=
 =?us-ascii?Q?5oemkFyZs4HwafYxG7iHhsm3qEy4useoBB3MEXq1v5mOEav4xLLhX8QIwHdj?=
 =?us-ascii?Q?5gh77UFSNfNF2+/dLWbNUMoyCU0rtaSrVnv+1hDq1W6yA/eZMnt4+todJvOJ?=
 =?us-ascii?Q?xfdF/jsh+69g2RBdEpoEwk9ZM17bTDd8HXTQsV8sCp0BtBrqXtc1zUAUbpno?=
 =?us-ascii?Q?4BtyK1t27S/EymspnRDRQGH9HFZWHZAvT3rivXoyYegBjqzA21IH1ISEQD/Z?=
 =?us-ascii?Q?ab/F1DkhINi+Oi8fTKiaVJL51qaxDNWvMlzbPChD4PPyMUsrfBTEoj67tPGs?=
 =?us-ascii?Q?zncYMZ9XboanZTfhXUHlg6MPcFoKgNo94RniUWsK/LNPAAAgP9uF4Rg7tGZC?=
 =?us-ascii?Q?DyOzgzC9k3fdTlU2Nd6iwmjC5SJnNeVbRX4lqtLTZNPbN4CAe6assPYbxith?=
 =?us-ascii?Q?2N6q8SUj5NZk3zNpM5KcNYDz8zoBUFvRuWeO9NXzIOpNH0z6LFmwKA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ee59c13-3d16-4861-84da-08da0afa3097
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:18:10.4358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dMqLZW3ltu1se2jdMJA50XOM1Ahxh60gJ88GCnesQlidAEPpuTTowryZiPhUDkxSlVm3fqN35dzHCPsZXvnwXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2105
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210033
X-Proofpoint-GUID: r14ZyapifCcphN_pOwS-HaBAbxQ_7Lyh
X-Proofpoint-ORIG-GUID: r14ZyapifCcphN_pOwS-HaBAbxQ_7Lyh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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

The patchset has been tested by executing xfstests with the following
mkfs.xfs options,
1. -m crc=0 -b size=1k
2. -m crc=0 -b size=4k
3. -m crc=0 -b size=512
4. -m rmapbt=1,reflink=1 -b size=1k
5. -m rmapbt=1,reflink=1 -b size=4k

Each of the above test scenarios were executed on the following
combinations (For V4 FS test scenario, the last combination was
omitted).
|---------------------------+-----------|
| Xfsprogs                  | Kernel    |
|---------------------------+-----------|
| Unpatched                 | Patched   |
| Patched (disable nrext64) | Unpatched |
| Patched (disable nrext64) | Patched   |
| Patched (enable nrext64)  | Patched   |
|---------------------------+-----------|

I have also written tests to check if the correct extent counter
fields are updated with/without the new incompat flag and to verify
upgrading older fs instances to support large extent counters. I have
also fixed xfs/270 test to work with the new code base.

These patches can also be obtained from
https://github.com/chandanr/linux.git at branch
xfs-incompat-extend-extcnt-v8.

Changelog:
V7 -> V8:
1. Do not roll a transaction after upgrading an inode to "Large extent
   counter" feature. Any transaction which can cause an inode's extent counter
   to change, will have included the space required to log the inode in its
   transaction reservation calculation.  
   This means that the patch "xfs: xfs_growfs_rt_alloc: Unlock inode
   explicitly rather than through iop_committing()" is no longer required.
2. Use XFS_MAX_EXTCNT_DATA_FORK_LARGE & XFS_MAX_EXTCNT_ATTR_FORK_LARGE to
   represent large extent counter limits. Similarly, use
   XFS_MAX_EXTCNT_DATA_FORK_SMALL & XFS_MAX_EXTCNT_ATTR_FORK_SMALL to
   represent previously defined extent counter limits.
3. Decouple XFS_IBULK flags from XFS_IWALK flags in a separate patch.
4. Bulkstat operation now returns XFS_MAX_EXTCNT_DATA_FORK_SMALL as the extent
   count if data fork extent count exceeds XFS_MAX_EXTCNT_DATA_FORK_SMALL and
   userspace program isn't aware of large extent counters.

V6 -> V7:
1. Address the following review comments from V6,
   - Revert xfs_ibulk->flags to "unsigned int" type.
   - Fix definition of XFS_IBULK_NREXT64 to be independent of IWALK flags.
   - Fix possible double free of transaction handle in xfs_growfs_rt_alloc().

V5 -> V6:
1. Rebase on Linux-v5.17-rc4.
2. Upgrade inodes to use large extent counters from within a
   transaction context.

V4 -> V5:
1. Rebase on xfs-linux/for-next.
2. Use howmany_64() to compute height of maximum bmbt tree.
3. Rename disk and log inode's di_big_dextcnt to di_big_nextents.
4. Rename disk and log inode's di_big_aextcnt to di_big_anextents.
5. Since XFS_IBULK_NREXT64 is not associated with inode walking
   functionality, define it as the 32nd bit and mask it when passing
   xfs_ibulk->flags to xfs_iwalk() function. 

V3 -> V4:
1. Rebase patchset on xfs-linux/for-next branch.
2. Carve out a 64-bit inode field out of the existing di_pad and
   di_flushiter fields to hold the 64-bit data fork extent counter.
3. Use the existing 32-bit inode data fork extent counter to hold the
   attr fork extent counter.
4. Verify the contents of newly introduced inode fields immediately
   after the inode has been read from the disk.
5. Upgrade inodes to be able to hold large extent counters when
   reading them from disk.
6. Use XFS_BULK_IREQ_NREXT64 as the flag that userspace can use to
   indicate that it can read 64-bit data fork extent counter.
7. Bulkstat ioctl returns -EOVERFLOW when userspace is not capable of
   working with large extent counters and inode's data fork extent
   count is larger than INT32_MAX.

V2 -> V3:
1. Define maximum extent length as a function of
   BMBT_BLOCKCOUNT_BITLEN.
2. Introduce xfs_iext_max_nextents() function in the patch series
   before renaming MAXEXTNUM/MAXAEXTNUM. This is done to reduce
   proliferation of macros indicating maximum extent count for data
   and attribute forks.
3. Define xfs_dfork_nextents() as an inline function.
4. Use xfs_rfsblock_t as the data type for variables that hold block
   count.
5. xfs_dfork_nextents() now returns -EFSCORRUPTED when an invalid fork
   is passed as an argument.
6. The following changes are done to enable bulkstat ioctl to report
   64-bit extent counters,
   - Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
     xfs_bulkstat->bs_pad[].
   - Carve out a new 64-bit field xfs_bulk_ireq->bulkstat_flags from
     xfs_bulk_ireq->reserved[] to hold bulkstat specific operational
     flags. Introduce XFS_IBULK_NREXT64 flag to indicate that
     userspace has the necessary infrastructure to receive 64-bit
     extent counters.
   - Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to
     indicate that xfs_bulk_ireq->bulkstat_flags has valid flags set.
7. Rename the incompat flag from XFS_SB_FEAT_INCOMPAT_EXTCOUNT_64BIT
   to XFS_SB_FEAT_INCOMPAT_NREXT64.
8. Add a new helper function xfs_inode_to_disk_iext_counters() to
   convert from incore inode extent counters to ondisk inode extent
   counters.
9. Reuse XFS_ERRTAG_REDUCE_MAX_IEXTENTS error tag to skip reporting
   inodes with more than 10 extents when bulkstat ioctl is invoked by
   userspace.
10. Introduce the new per-inode XFS_DIFLAG2_NREXT64 flag to indicate
    that the inode uses 64-bit extent counter. This is used to allow
    administrators to upgrade existing filesystems.
11. Export presence of XFS_SB_FEAT_INCOMPAT_NREXT64 feature to
    userspace via XFS_IOC_FSGEOMETRY ioctl.

V1 -> V2:
1. Rebase patches on top of Darrick's btree-dynamic-depth branch.
2. Add new bulkstat ioctl version to support 64-bit data fork extent
   counter field.
3. Introduce new error tag to verify if the old bulkstat ioctls skip
   reporting inodes with large data fork extent counters.

Chandan Babu R (19):
  xfs: Move extent count limits to xfs_format.h
  xfs: Define max extent length based on on-disk format definition
  xfs: Introduce xfs_iext_max_nextents() helper
  xfs: Use xfs_extnum_t instead of basic data types
  xfs: Introduce xfs_dfork_nextents() helper
  xfs: Use basic types to define xfs_log_dinode's di_nextents and
    di_anextents
  xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits
    respectively
  xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and associated per-fs
    feature bit
  xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
  xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers
  xfs: Use uint64_t to count maximum blocks that can be used by BMBT
  xfs: Introduce macros to represent new maximum extent counts for
    data/attr forks
  xfs: Replace numbered inode recovery error messages with descriptive
    ones
  xfs: Introduce per-inode 64-bit extent counters
  xfs: Directory's data fork extent counter can never overflow
  xfs: Conditionally upgrade existing inodes to use large extent
    counters
  xfs: Decouple XFS_IBULK flags from XFS_IWALK flags
  xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
  xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags

 fs/xfs/libxfs/xfs_alloc.c       |   2 +-
 fs/xfs/libxfs/xfs_attr.c        |   9 ++-
 fs/xfs/libxfs/xfs_bmap.c        | 112 +++++++++++++-------------
 fs/xfs/libxfs/xfs_bmap_btree.c  |   3 +-
 fs/xfs/libxfs/xfs_format.h      |  80 +++++++++++++++---
 fs/xfs/libxfs/xfs_fs.h          |  21 ++++-
 fs/xfs/libxfs/xfs_ialloc.c      |   2 +
 fs/xfs/libxfs/xfs_inode_buf.c   |  80 ++++++++++++++----
 fs/xfs/libxfs/xfs_inode_fork.c  |  42 ++++++++--
 fs/xfs/libxfs/xfs_inode_fork.h  |  63 ++++++++++++++-
 fs/xfs/libxfs/xfs_log_format.h  |  33 +++++++-
 fs/xfs/libxfs/xfs_sb.c          |   5 ++
 fs/xfs/libxfs/xfs_trans_resv.c  |  11 +--
 fs/xfs/libxfs/xfs_types.h       |  11 +--
 fs/xfs/scrub/bmap.c             |   2 +-
 fs/xfs/scrub/inode.c            |  20 ++---
 fs/xfs/xfs_bmap_item.c          |   8 +-
 fs/xfs/xfs_bmap_util.c          |  57 ++++++++++---
 fs/xfs/xfs_dquot.c              |   9 ++-
 fs/xfs/xfs_inode.c              |  36 ++++++++-
 fs/xfs/xfs_inode.h              |   5 ++
 fs/xfs/xfs_inode_item.c         |  23 +++++-
 fs/xfs/xfs_inode_item_recover.c | 138 +++++++++++++++++++++++---------
 fs/xfs/xfs_ioctl.c              |   3 +
 fs/xfs/xfs_iomap.c              |  45 +++++++----
 fs/xfs/xfs_itable.c             |  19 ++++-
 fs/xfs/xfs_itable.h             |   4 +-
 fs/xfs/xfs_iwalk.h              |   2 +-
 fs/xfs/xfs_mount.h              |   2 +
 fs/xfs/xfs_reflink.c            |  17 +++-
 fs/xfs/xfs_rtalloc.c            |   9 ++-
 fs/xfs/xfs_symlink.c            |   8 ++
 fs/xfs/xfs_trace.h              |   4 +-
 33 files changed, 679 insertions(+), 206 deletions(-)

-- 
2.30.2

