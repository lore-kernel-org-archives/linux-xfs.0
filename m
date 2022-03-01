Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5781FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 10:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiCAKky (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbiCAKkx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 05:40:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0751F6E372
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 02:40:11 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2219eD3C013679;
        Tue, 1 Mar 2022 10:40:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=HEDdg+baCio3/Z1VxVwNu5I+ftLVSN0FucA/tX3cbI0=;
 b=qFHBOADNvg1sefw/Apn5+D/Ss1Z7svEUvUZDHqBnxAIcEL1zKSHAgjNR9ssRLh2/tDV0
 fDYdgMnGyIoASACUchieM+aaqTrADyko6SUr5+7UVtwUdwrdoPgfXKFtdO7AJU46IX12
 s8hMwJ3joSYIDnaNiIUWJTvlJOX3DjayGoQOv4WGwzepPabWPjJ9BDJB9xHOr+RF/DQH
 CwKLkpASYfuW3gpyynP2UMoczE2CVQR/ZmLR1ojZM851iQ1kUUX9Hvuf2SjJFKvs7kNu
 XtxS0TSoj8D0c6X+bxZX4w0KCib5QKLjLWMRonH/8+lyU0wBIRtj6cLUfA3P88pxQjbW sA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ehh2eg5kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 221AaoFQ034172;
        Tue, 1 Mar 2022 10:40:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3020.oracle.com with ESMTP id 3efc1455b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Mar 2022 10:40:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpZ7hTC7oKAX8Nw2zBfN27Yg9sLBPbQoGeZ6KKXtn8dHI6QMFwOjFBT7cEPAHAxY1+LWFNOVuFEzJKcASKiHheexo4gxN9D0u890+rs9Q/BY/+tbtRydw+IEg7ql4k41igwe1JXtdvNwZHW+HU3/bvvPn2uSLJzTb79v2uNaMlt+++zEu/06r0ksshMCVLtQQVpTx99VxryyZ8QqPzU0kmO24YWxWxwCJlPucsmCjbqcpdGDQeHmcnXDZrReGsxWZe9o9LpiSJ540x6DB5CCQPVLbcC8lnrLX++OSspCmbeDI6ewngHxJ6j/vP284wES8b4+WH55wnuDWiM/21NroA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEDdg+baCio3/Z1VxVwNu5I+ftLVSN0FucA/tX3cbI0=;
 b=B0rVTnM/45Iyw34cxMjiv3rNzzULpT7NxjoKAHFKBmsq09TewSuAzhrMXy8J/61T163lElOYiyG7U6wnk+k8KjkTbPx3+eUPUuPMK9ng/UK/3wYDudLHUXPJ8jO5dNPNFPwFPz1b73OeiLlm4uuOaAO8ebUfC9fStAzKJ1jSV2+3g4oKnJciU0kc0F9iCY2s72ARL4Q5u1E8WsqCAuDD584MQu93LtiGaprRCs7RxtXP38tbyubyW/srHSvmPvahZhVFOyE67KHdwhwhvVDHRcL50jQDQeZI+9VoyiIQwD6buqCOPd8BxfVok1xG2YJAZtlSmYi87WKfRT/nO+E0Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEDdg+baCio3/Z1VxVwNu5I+ftLVSN0FucA/tX3cbI0=;
 b=LasrXsiE1dFoNbC1gzoXbQ6eHKyE04yFnrdxvE5G8t7xmgsA40t9/oQtAYq3mMHa3lKia/dYxE2n3DyDGkyss0seDGyErpD9dwnG6LKxReQ4g88SIl7QyE0+CKneEihO7mKmg9Ve2SnoHpOM7PEQP2I4TtRuedvX35OwUzB76qs=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by MN2PR10MB4160.namprd10.prod.outlook.com (2603:10b6:208:1df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 10:39:57 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 10:39:57 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 00/17] xfs: Extend per-inode extent counters
Date:   Tue,  1 Mar 2022 16:09:21 +0530
Message-Id: <20220301103938.1106808-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68b3690c-f7ad-4a0d-eb12-08d9fb6fd40c
X-MS-TrafficTypeDiagnostic: MN2PR10MB4160:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4160BFE80EDD2BB29C3E3917F6029@MN2PR10MB4160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MQcyibmR7wj46TnGj5HhbdMAEN+RHhwTjNPCqAaEWzoo8Y9ZKrEWyFMNU6XkmIU1UwRz7jNi1PnzYbbVKLiM/kBTIqBpA1CXSJ4FoZygQOcTSji+pdMdLj9NdVqvxRtLj4BSACgC03UzFkduvuH6yG3lF2+R/7LWPicunNivzVCtyyHktPQ7ABP3xn1/BI5QsOXkRgYoenMtv6ENWttSSjOQ1OeHGlSMyGEnUoMsoMu4JNIXEv0qDpI8vH0/dkzNnTZ5y9TizJy0+ZgOk2gAtKQmB9yRpfUFf62bdtzGd8I98mzG4UpXtZMDJ4eayOg0xR0pnk4ujxo3LjpRvuudEb9hXRQ6wO2+1EEchoHE6M5rhGPSeK21Jze9oaT751Y3W57jJYLfEoDJYdl03FnmLrYUC5Ce+/uASb4TLmCu4aAN2NTn4rfNaC3p+lgxwKD/gkRzyCqLo2SulIS7qGihq9MV2ZBv1g6mAsQcitsuuELIUT4//vCzbqq2RmlTP1m424mcSmYQ9B9NR4jcNEST6kgtXCfEDMV6fnxa/fsyroICqwiohvBGGCnPfunZhkA/+WNoNavPtpukhzHFIEFgfuGoYXgMAvS8Y1OZtUuW22u6xSu8Ptcqyr2wH6tiyQxSZ5AYTQMNgQwHHesJNr+WcO14apWAzCUfTUsosBKV/1liRxaCPE1CinHP1Nstf38DKUkz2hK5Bdt+Xramd/PIbcSlmuq2OSZYZDFcHnfXto6sFX73pnkbgjHvhYgxYwEJBgRuqnS5npUzM3pdj9k85WKb4r1RR+p6miVPlq3h3q4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(38100700002)(38350700002)(186003)(83380400001)(1076003)(2616005)(8936002)(36756003)(2906002)(5660300002)(66946007)(6512007)(6486002)(966005)(508600001)(6506007)(52116002)(6916009)(316002)(8676002)(4326008)(66476007)(86362001)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HBKHhNJcaqRbdFO1xmbrMX6oU8sHh4g2V6yn2mCyIu6p6ewAqz61hbDbo0L3?=
 =?us-ascii?Q?SFv5JJkkY5mWYHzrshqQKx9YEv+ebG98JwM42AJiULWTxRWO69GqEvaKkxFv?=
 =?us-ascii?Q?8qm8nd2f4OK0ngzM3rf9fhB5T4n4VTn3TOLsGErzi//lbfeOFAZ0WTpGwidg?=
 =?us-ascii?Q?S/0p4/x2BBF5egct+FDV/2mtDz+lk4uzgrmUfxBcrYHjytEt54gI6gSYIlo5?=
 =?us-ascii?Q?Tev88S8xEi6bcct/9BEexifip/im7Ol2DEtpGOHS1siXELSmvVOpIE88ZTmK?=
 =?us-ascii?Q?QAX0E2a1XX4h+kRkMV4f9AG6i68ptInYO51tarTLEFCx0d5nDngwo09P52Zi?=
 =?us-ascii?Q?o1ndOWhgzwxUjL2LO73EvoIYY59yrth1kHCEnXgFumawk5j0S/0SzTiBjD8l?=
 =?us-ascii?Q?yIzxHcAXP24Dng5piUydP5nkz8VSZKPbSuQf53SzY+GuZ+T4GACW7aiaUNUY?=
 =?us-ascii?Q?wzOe/vLsyjyTtBbNKl4LIqfsVlTeSfYzL+K/t+VqG3bTvolazPUIk5q9BKEd?=
 =?us-ascii?Q?Xxq+N0ljhYi5Iuq+9xB7kyF0mah2YIc7bDJDfjBYDQYleRQRAroxUZr4zWk0?=
 =?us-ascii?Q?h9NNaNCvIdw62jCKArja4yXp110UyAnKvDsd57ifhlD8M7md3JvgOOydxqq8?=
 =?us-ascii?Q?v4kQkfUp71NzqlZrItCAfw95bMl5emW8gVluGGDao6cEFwghHkKEntYjBvxI?=
 =?us-ascii?Q?AHUd0zlvVt3qDllV2bPLhhpShcUGD1eVkE88hQbmp8uPdi1AAE1qEetcyfJ8?=
 =?us-ascii?Q?ZX0XTyDK8US+a6PYj7kXtx+NfQvnO79pK46nBF3nRk5X85xaTVlKvFEjWuLK?=
 =?us-ascii?Q?4U0m/c5pFxShDxZ/dcBER/cvLShefvCPMDIQiJ7v3Yf2/d5Ey8hIqhKYF1Zj?=
 =?us-ascii?Q?W0G7RKI2CPrNzOIfB3yzlrIbvri/8KJa8DD0wpD+7jePNVQB/mjTfO3ULxr7?=
 =?us-ascii?Q?iFfAILnC35z97n0UdNu0JdA6Z35GZCCNWCWAGzx6dCBFewDKNa2rqdndUvnD?=
 =?us-ascii?Q?m16VGDZsR0Eq4KwIsP+H/GbQvTAZjLOX6V4SJC2T1xrsj3a0P1cdPCRcL5gx?=
 =?us-ascii?Q?5NQJ9rALT0lxv3khhanQbCuIHTRq60U245oN8iCAyMyu3FncIsFg58CIEOyI?=
 =?us-ascii?Q?ruIpxLCnpmUTMRPBTNoSwfF/9V5cwT1JhfEfYWL4CudCm4BXQM+kon3QECmh?=
 =?us-ascii?Q?TpTCBfDrVqR9mU5SQyH6ZUGFVHfXWrko4nLmVNlE+xefVv2yHWlhb4uB6kio?=
 =?us-ascii?Q?VETkEMyaG4VG7pcczlyOZQzK3jVQVJDp6VUna4AbpvGkgykMBXWroWIGhYzF?=
 =?us-ascii?Q?O9N5gusB/Zl/wt6MXPQSeYjlzsyXsEAaMC9Txk4yxkUBZsRbP6EfNEcuMls1?=
 =?us-ascii?Q?riky8b4tFYwKDn9Bcx9TlJjDs5gkoxlxCBGzIAPh448OFOVq+bL7E0y/T52t?=
 =?us-ascii?Q?gJqZvK8X2xXJUN9ORC4ATajIbq1RWGJGy/VlZzH8RXhMjWqE4FBkmPjNjLxK?=
 =?us-ascii?Q?W0Py9Uk24fiIcjgYzgfTiJVMUvQEezoXjObjOENPbLMs9j4ZZTkIJYAgWhud?=
 =?us-ascii?Q?W/HbdLpabn6T6dAupKnwEhP2QWz5n20D8Yu1H/JPREuPE49Kt88xoxp/ipML?=
 =?us-ascii?Q?X0qRjEGyBAqHwDmJysBEXX8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68b3690c-f7ad-4a0d-eb12-08d9fb6fd40c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 10:39:57.7504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGYMTa+8wHRZKegoVLCZE/R3GHtNdkUsy2oELXtcm1Kt/Y6aRY7D3s7jsT84ALav3v8j+b7Ymfaxf5l4tU2cjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203010056
X-Proofpoint-ORIG-GUID: D22FcVWks2xRluLt_OPsYw09FrXfAdC-
X-Proofpoint-GUID: D22FcVWks2xRluLt_OPsYw09FrXfAdC-
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
|-------------------------------+-----------|
| Xfsprogs                      | Kernel    |
|-------------------------------+-----------|
| Unpatched                     | Patched   |
| Patched (disable nrext64)     | Unpatched |
| Patched (disable nrext64)     | Patched   |
| Patched (enable nrext64)      | Patched   |
|-------------------------------+-----------|

I have also written tests to check if the correct extent counter
fields are updated with/without the new incompat flag and to verify
upgrading older fs instances to support large extent counters. I have
also fixed xfs/270 test to work with the new code base.

These patches can also be obtained from
https://github.com/chandanr/linux.git at branch
xfs-incompat-extend-extcnt-v7.

Changelog:
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

Chandan Babu R (17):
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
  xfs: xfs_growfs_rt_alloc: Unlock inode explicitly rather than through
    iop_committing()
  xfs: Conditionally upgrade existing inodes to use 64-bit extent
    counters
  xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
  xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the list of supported flags
  xfs: Define max extent length based on on-disk format definition

 fs/xfs/libxfs/xfs_alloc.c       |  2 +-
 fs/xfs/libxfs/xfs_attr.c        |  3 +-
 fs/xfs/libxfs/xfs_bmap.c        | 87 ++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_bmap_btree.c  |  2 +-
 fs/xfs/libxfs/xfs_format.h      | 71 +++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_fs.h          | 21 ++++++--
 fs/xfs/libxfs/xfs_ialloc.c      |  2 +
 fs/xfs/libxfs/xfs_inode_buf.c   | 78 +++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_inode_fork.c  | 51 ++++++++++++++++---
 fs/xfs/libxfs/xfs_inode_fork.h  | 61 ++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_log_format.h  | 33 +++++++++++--
 fs/xfs/libxfs/xfs_sb.c          |  5 ++
 fs/xfs/libxfs/xfs_trans_resv.c  | 11 +++--
 fs/xfs/libxfs/xfs_types.h       | 11 +----
 fs/xfs/scrub/bmap.c             |  2 +-
 fs/xfs/scrub/inode.c            | 20 ++++----
 fs/xfs/xfs_bmap_item.c          |  3 +-
 fs/xfs/xfs_bmap_util.c          | 24 ++++-----
 fs/xfs/xfs_dquot.c              |  2 +-
 fs/xfs/xfs_inode.c              |  4 +-
 fs/xfs/xfs_inode.h              |  5 ++
 fs/xfs/xfs_inode_item.c         | 23 +++++++--
 fs/xfs/xfs_inode_item_recover.c | 85 +++++++++++++++++++++++++++-----
 fs/xfs/xfs_ioctl.c              |  3 ++
 fs/xfs/xfs_iomap.c              | 33 +++++++------
 fs/xfs/xfs_itable.c             | 30 +++++++++++-
 fs/xfs/xfs_itable.h             |  4 +-
 fs/xfs/xfs_iwalk.h              |  2 +-
 fs/xfs/xfs_mount.h              |  2 +
 fs/xfs/xfs_reflink.c            |  5 +-
 fs/xfs/xfs_rtalloc.c            | 13 +++--
 fs/xfs/xfs_trace.h              |  4 +-
 32 files changed, 532 insertions(+), 170 deletions(-)

-- 
2.30.2

