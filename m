Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1644C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Dec 2021 08:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhLNIrE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:47:04 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46778 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231987AbhLNIrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Dec 2021 03:47:01 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7mv6E005512;
        Tue, 14 Dec 2021 08:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=z8BTh1qygLBoOk2j3VaBmmUiAKsHh6Q2i/luNQEbfLI=;
 b=X5v9JcN/TBcE2FXU7cPdg+WaXfMmWMF6vNAl6FWzAyGynTimY6McY1J/ib/elN3omBxn
 aE4hug1IQTnYzyCVqimwwAD2O77VH0FzxUPaAtcm+BTfoyHiXRSSWNvweotPm6qLfWIh
 Eed0byOo8NHU/xZQS9zgeP/p7J6y8PDiH6WdNJ3qyAsHA5dPhFTPvJrxOS1FDndb8TFv
 NZTnrnGB5KYpC85HNUJD9ctaY890f4K4w98s9wEQ/4vVMLY7CFKN6gRcXu8fx+tz3O/A
 pswPdi7FJ9zgIwdpGN3g4+t3ejDMeu1zMEeb7Vg2Jq2Sd3AZbEBzINFU91ttGOU7QhA9 Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx56u2sqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:46:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE8fXfN156453;
        Tue, 14 Dec 2021 08:46:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3030.oracle.com with ESMTP id 3cvh3wy4tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 08:46:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3+W0gnIvzgz/OdGoZvaMQAzrOo8o6ive6xgthJO4hVuGd8uOQ4aelEU2Q5cN5cpgQ6ekXCcOBkMagbnzBSKnHRheORRBtpXBSBRFL798n1CMubudMTxMFlTc1heTmE9xJ+8Af1IhMHlUcP7XPWs9mD+ZLExB48U/XK7UrtWfm9FV7/L4edcw+2MMvrHFlkP/l6G2sRHVXGMMPzsTsc06UQZhZZHTS5G4rFo1coDWJy3m4Otob3GtE/oFl3MGrZ3OY5MIUYW4EdvTyeg2PerSnqhi99dN5dwc6x5xhMgd0EssLnsq8AaZm5tpclcp7RY4/e4U3fDiwBbeBAnMPah2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z8BTh1qygLBoOk2j3VaBmmUiAKsHh6Q2i/luNQEbfLI=;
 b=jKvSbshtnB3pa2GuF8KCbF6NvKmheXHmDIkLsWVgbg7/dYm88WLALTLu6BQH9Nl1yFr0PYFEE967H1nvb2/FG7KCaAFLPdYfslt65yiyW27Gc7JiEIe9sNza2zMajBVQ7gjCcEiodJP2aNanmxOQhW8UzG914Sx0OxhyoFFV6SUKqJatyBKJPTvriw/v9eN1JAQdA2l5DLrCpF0D7GFwJiwNLkRYRFv5Z+SoUePDZw7HQBbE2DqOGpQ8Inh63qkmfqWwH9b8VNqaKbfLCCH6di+bQSpMYH3GRKYp6+R81uaGxmX6ds6LZir5CFz2wAot14OyZk5JBDWRQOyFRedRaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8BTh1qygLBoOk2j3VaBmmUiAKsHh6Q2i/luNQEbfLI=;
 b=XIfmENl3k6WQ+/nq0VGGwwmAY/5pH5ypKDLCPUUK2BFtKAo6BnKmEbXv4uiXgEMClumo9sTlytACl6QjWym7bfR0f/xpOh61KJ6O7rvBnYr+1PsxuqryOxJcewzwmJPSNzlg7bkRvOrnD5CsHDcq22/UvQs0shPyNcmO2y3YPK0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3054.namprd10.prod.outlook.com (2603:10b6:805:d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 08:46:54 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:46:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V4 00/16] xfs: Extend per-inode extent counters
Date:   Tue, 14 Dec 2021 14:15:03 +0530
Message-Id: <20211214084519.759272-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6241f580-46ab-47e6-18e6-08d9bede479c
X-MS-TrafficTypeDiagnostic: SN6PR10MB3054:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3054A7D96DD3D057FED2D2C0F6759@SN6PR10MB3054.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e329AVmJuLSq472LvO/QTj8tO1+TFBN6PrZdQYwE8DHI7nOfjjq8nLgdMkgdIR7z00wRXy4KxD4Nfgf6kwThjlVwcMnXlnySBCJVXhi0MUjj6hHTIj28Ooq313wNBJZFwRoUxu6I2QFOOhfDcP16pepJJJ3ikqEiO3Is6x+HgushJ4v4g8aNCU8GvhUhgYCO/ZuF5dKs3q+jZFKfKREuSe4grKMldx9pRxO5x+RpgrBIvV55nVAl8kNHHUk8Lx28BOz4N+2dHKlbyRyLK9NGZqTS5onl0iz4Py/AsUOGOXxp3SoQ9SToS0zBYAPfJpcJUVS3TrqHRYHbIUFrEm3leS5xJ0LrftvAxwQhZrxJ4oa+lXJR4Pd/XrH3zTMjQzLzMPbJGyHHspFLpMsPuLMMNcMkrCeCbU2UTbc124+SIv/Ix3cPk7d02aNgracSwbv6iSrTWjLgQptzrWAw61eQ5XfWY6PiH1gnOEtyKwwh+ykQOGuhmuX9gtdyP0kgJYzxYsgyV67xn8E6FLZNKmby6tTw38MdZu8mNVjZY9AcfyqLFajow9PXRDxoby5/4h4VyrLQDhPfdWA3j4JQCN6Kda6FjfYu9e8uMArTKQShMlOcoorDiGtX2eK/OT+JGatUMLfE2v/BElJT9xmSEs5YZHMQKNL/Pqq6aFlCwZ9RqAqY4Rq4X4dr4o8l6cV+qsCKFLls5HYBMsj6bKUgpbTmus0Ocd8MSKhY+8XWQIHDI0ZgF/L4/AlqvI+3hxYz2qAI8Bxnzt9PnwFrRsy8k7j0XQfYXTTqx3vXcWm8hzDrdto=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(8676002)(66556008)(66476007)(6486002)(316002)(6916009)(6512007)(186003)(5660300002)(2906002)(36756003)(83380400001)(26005)(66946007)(966005)(2616005)(6666004)(1076003)(4326008)(6506007)(508600001)(52116002)(38350700002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ii/gYB9Fx4MrRd9f03ssYAYs2oTx3a5gGrCJJ/C9y4qiOmz5L4nimSgCYcHc?=
 =?us-ascii?Q?q4YzNq6tlW050RFtShzG/geZKMnil64BGqMEddT3p//rigE7/lDy0GNmQo5K?=
 =?us-ascii?Q?ht7flWhx0P7d60/VWocJnAALgGYxA5nbknzIuP4tL4mwRuRs+/+rema8P/84?=
 =?us-ascii?Q?zolSvyP4P7QYTx805w3O1xuNdGlFqbOlufIC0YolWOFU0aiOmk4R+X1kI2px?=
 =?us-ascii?Q?dNMBOokoTKlkQtkE8tpqhcqs0BK2p3bJnRw8jlw0xsjAllkuNVsJp0RU09PA?=
 =?us-ascii?Q?RlGdnrXEQG0SVMEGq70FCdLcb65BIVtCwAszozYIr5PVBeDxbGue91XEKjG/?=
 =?us-ascii?Q?dK6i9WlmFTIIbn8OsHiAx0Fg45RVT27vmtIHgw9AazYSWjdN9+Cay0uYr8KQ?=
 =?us-ascii?Q?Cz2AU5aEbZ0KOqlQARELZPN5U9gywqy5paWuNaIdI7RT1KoQxi4qKaUWhf4C?=
 =?us-ascii?Q?57GGgt80rQKFdIPYZlty1tuHA9U6i8bTaIFw3UAqnbDira+K8aj9arNUH0CZ?=
 =?us-ascii?Q?EY7Umu9pbTAnOgHef6EnJ5ehRA6RERRulQSno/zXe3mxAbnJUEyeu43AyHro?=
 =?us-ascii?Q?thLYWACzsB7UiDd07RLBtaQDRBuwJ2RDtR0PMJD3ROQfdI8w6/+ZuM1kZ81o?=
 =?us-ascii?Q?lJaAYdZhW/IDIVvsIVdtuvel9R8T1eOnn9V7T/DKlKDQm3Xczz0x9gdQsZCH?=
 =?us-ascii?Q?c+63F04FaKWkuJPUB0rhRTRVsI8xPQXlLClvUU1KhC6bMUmo4+4g5zEDAwuQ?=
 =?us-ascii?Q?Jn87c9XI3ROZC3q8Y03CYdjVDoV0gzt7cs5DusQxEyxs74P35ewkylc+Hx4B?=
 =?us-ascii?Q?6dQSF7DQaWJm5CDCwQ8Qs5oz0VTcDa/ZxkzHUJEwIGf89FEtNGpxQksbBojc?=
 =?us-ascii?Q?cLXFebNzBBnkfqtfpi0bHnDeYZuRd3iZDnX776lJN0aVmVOXmimo7DBnzdy5?=
 =?us-ascii?Q?G5zJ1tD9FbGdp2bKMJ/NCvJ2siZFttKcQ+JAEetSbCwRog/ZztjEz7bUudPJ?=
 =?us-ascii?Q?woP1fclct2B11CL2s45U/HMRZ7Rs0sXLm1OpTO/uYp/p8hkY2Nfuhbvtny7J?=
 =?us-ascii?Q?fNbYCHLTEHxufSwaaoaiDRb8tbSUy1fomsZR8PTAVkGcJTaJ+OqCprfu4Hil?=
 =?us-ascii?Q?BaNHpbpKzrT5rTPoMYxgoTTkaJFF+HMacO1um7LQkZ8VZzY23cMfgvvJ8T68?=
 =?us-ascii?Q?8/cNRx1XkY9w96tk1pbVvF6f9R4ufmOfOXqqfIsQyfRCisib4JtrIprstSh4?=
 =?us-ascii?Q?GjPfFHZkoIl6/KQhMu21s5L6Mh157hrnDi3rmeO+uEGBWe2jariJAHCueEsv?=
 =?us-ascii?Q?lhg/h22Xcwsk5r1+ym4aHmPB3KpG0J9elbhoSiX/qegiFwhfydwVZXIchENY?=
 =?us-ascii?Q?Zw8DSdmUlcLC0GUS/AVszGG28zWm/rJTQoyHMJuWOoJhBG1sJcGSElHgu6Nh?=
 =?us-ascii?Q?rhdhg/Enw8odANaJ8CKTVyp98gmr/K5Z1valNJvY7OjqzTRwVC7JOZ5FNqdb?=
 =?us-ascii?Q?UfB237ruxyDu8NxL0R02kCRhCKqUwV0ViIoBjtyM/IbZM/lGl4QZNhduKOa8?=
 =?us-ascii?Q?R4nLzyAhKXYE6VGtra9LtR4H45ynPxQ3NG2int0x8SqOx+9peCuzcKcqqFxr?=
 =?us-ascii?Q?wfcisQiF4EkxrZ0czYCGjYQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6241f580-46ab-47e6-18e6-08d9bede479c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 08:46:54.7565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QvzNnPNLfxJnXxYrCc4L+tHmcFFfT5TWt6rPIEyggkbFmzAmya+J8PSiep+yDEpg5Sx7rQNmjy9GJ8Via/3bGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3054
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140049
X-Proofpoint-ORIG-GUID: YcXhA7pzCTbSf5ZREb0AoLHywf-FcTD3
X-Proofpoint-GUID: YcXhA7pzCTbSf5ZREb0AoLHywf-FcTD3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The commit xfs: fix inode fork extent count overflow
(3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
data fork extents should be possible to create. However the
corresponding on-disk field has a signed 32-bit type. Hence this
patchset extends the per-inode data fork extent counter to 64 bits out
of which 48 bits are used to store the extent count.

Also, XFS has an attribute fork extent counter which is 16 bits
wide. A workload that,
1. Creates 1 million 255-byte sized xattrs,
2. Deletes 50% of these xattrs in an alternating manner,
3. Tries to insert 400,000 new 255-byte sized xattrs
   causes the xattr extent counter to overflow.

Dave tells me that there are instances where a single file has more
than 100 million hardlinks. With parent pointers being stored in
xattrs, we will overflow the signed 16-bits wide xattr extent counter
when large number of hardlinks are created. Hence this patchset
extends the on-disk field to 32-bits.

The following changes are made to accomplish this,
1. A 64-bit inode field is carved out of existing di_pad and
   di_flushiter fields to hold the 64-bit data fork extent counter.
2. The existing 32-bit inode data fork extent counter will be used to
   hold the attr fork extent counter.
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
combinations (For V4 FS test scenario, the last combination
i.e. "Patched (enable extcnt64bit)", was omitted).
|-------------------------------+-----------|
| Xfsprogs                      | Kernel    |
|-------------------------------+-----------|
| Unpatched                     | Patched   |
| Patched (disable extcnt64bit) | Unpatched |
| Patched (disable extcnt64bit) | Patched   |
| Patched (enable extcnt64bit)  | Patched   |
|-------------------------------+-----------|

I have also written a test (yet to be converted into xfstests format)
to check if the correct extent counter fields are updated with/without
the new incompat flag. I have also fixed an existing test to work with
the new extent counter fields.

These patches can also be obtained from
https://github.com/chandanr/linux.git at branch
xfs-incompat-extend-extcnt-v4.

I will be posting the changes associated with xfsprogs separately.

Changelog:
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

Chandan Babu R (16):
  xfs: Move extent count limits to xfs_format.h
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
  xfs: Use xfs_rfsblock_t to count maximum blocks that can be used by
    BMBT
  xfs: Introduce macros to represent new maximum extent counts for
    data/attr forks
  xfs: Introduce per-inode 64-bit extent counters
  xfs: Conditionally upgrade existing inodes to use 64-bit extent
    counters
  xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
  xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
  xfs: Define max extent length based on on-disk format definition

 fs/xfs/libxfs/xfs_alloc.c       |  2 +-
 fs/xfs/libxfs/xfs_bmap.c        | 78 +++++++++++++++---------------
 fs/xfs/libxfs/xfs_bmap_btree.c  |  2 +-
 fs/xfs/libxfs/xfs_format.h      | 52 +++++++++++++++-----
 fs/xfs/libxfs/xfs_fs.h          | 13 +++--
 fs/xfs/libxfs/xfs_ialloc.c      |  2 +
 fs/xfs/libxfs/xfs_inode_buf.c   | 84 +++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_inode_fork.c  | 14 +++---
 fs/xfs/libxfs/xfs_inode_fork.h  | 59 ++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_log_format.h  | 22 +++++++--
 fs/xfs/libxfs/xfs_sb.c          |  5 ++
 fs/xfs/libxfs/xfs_trans_resv.c  | 11 +++--
 fs/xfs/libxfs/xfs_types.h       | 11 +----
 fs/xfs/scrub/bmap.c             |  2 +-
 fs/xfs/scrub/inode.c            | 20 ++++----
 fs/xfs/xfs_bmap_util.c          | 14 +++---
 fs/xfs/xfs_inode.c              |  4 +-
 fs/xfs/xfs_inode.h              |  5 ++
 fs/xfs/xfs_inode_item.c         | 23 +++++++--
 fs/xfs/xfs_inode_item_recover.c | 85 ++++++++++++++++++++++++++++-----
 fs/xfs/xfs_ioctl.c              |  3 ++
 fs/xfs/xfs_iomap.c              | 28 +++++------
 fs/xfs/xfs_itable.c             | 24 +++++++++-
 fs/xfs/xfs_itable.h             |  2 +
 fs/xfs/xfs_iwalk.h              |  7 ++-
 fs/xfs/xfs_mount.h              |  2 +
 fs/xfs/xfs_trace.h              |  4 +-
 27 files changed, 428 insertions(+), 150 deletions(-)

-- 
2.25.1

