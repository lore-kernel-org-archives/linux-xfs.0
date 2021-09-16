Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C8DC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F2F26120C
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbhIPKIj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:08:39 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39932 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235287AbhIPKIj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:08:39 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xkUd012754;
        Thu, 16 Sep 2021 10:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=lEM+wy0xLVCKAd7PkUL88webi31RWzUQrWpB4NjIuqw=;
 b=U/uXl7eEoR/1PdAf1xwo0etrReHFZrHmU8WRg0ITgL+JPEtar2u9vZ5UUpAo3unE7t1Q
 gy+tE2YUabb98hK9IYjx00FLjuy7+Rm1HzhpAmlxuaBKmZJpOLawMdcpqqlj4H+VicgI
 eW4FEs6V7zfPovR4XT+F1dpaaF2ARwvsQU4ZFVLHfjFVluM0OtOR1U1hRec4tf/qabDD
 wmOplOJcFC5FvYaEqellca2I+kRuzqABUsqum2Gsvm/RMSk21z4cu9hE0vZYZ+7ZEW+2
 YPYK85ScSpsAfGrrDTSbVZLYxi+yPdmd9h1Q1uOGmiAZpzjmdpfHi1Yjsh8wZrsFqp34 NA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=lEM+wy0xLVCKAd7PkUL88webi31RWzUQrWpB4NjIuqw=;
 b=oZFPLkgkiB05amO/1Mznt4HQpZmpdDtm1cQwskRWRJ4KNVm+Wj3TBDkKj8VIEI8EgQYB
 w7rrsHSmHMXcUjwynkrdVIIKW1c8WoCioBG8SxG4Q26Z1uOZ4hZ9chkug8Di6QGu78AK
 0VM0IfbiOAjfQkM9HxoAbbCOujLWjdpuwoQFvtpoFKWDyxc8HRc2GMZSUVbSYHpUNSd2
 V5yYW8TpKQACkGJKHi4dETf59WnaGfcRXbuAgfYU4nvnMr6YDxNSH+DLraIP9Zf3gkyq
 uTrwUadV6mMwx2D0nouYcMZfKLFYZq3A5MEfTJtL1aQ9NYsTdmcku7wus5eCf9eQTlTd SQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3s74hgjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA6c9h160380;
        Thu, 16 Sep 2021 10:07:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3030.oracle.com with ESMTP id 3b0jgfv45c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFzh2Iz2WynGEvLyl+Z8YEQw8RBiNHue9mHioU2JFxt04+FtMBW85rwMmcARvN6JfY7e/BF/OBdDAay2AcTHXJWmgbbIV4i4WbhDaQOw2pLZm+w7Mpm4ORskhiJhKTTiF4owFTkO3hNeSTRU8/PyyZ5PozXJ2y30UkzhpcVqN2UBI2SkdXtspdp1zoezzuLTomwbBgq8g9Lxc3BeuB/udPvioNd0Ep5XTiCP+6Rnhc0uDKvddfwRiA5LXG5CyjLnHFqJbYGaTFjY91J1bbzJBnLxSqd60niUTfNgG9CbvMPgQrcpeDaxNbC4qOMwyjkfqnJBcyUhFVJ+gjlcWNI+LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=lEM+wy0xLVCKAd7PkUL88webi31RWzUQrWpB4NjIuqw=;
 b=CE3V1I+E+4rKiwMHGysAng9L4Y7rTm1XlVLk28HzO7ivEl4iX/nXGKJcr7o+GDZRC3fgpcIJtaSw4fL3HUb3rSc/pKueFjY6LKu/S9xGyw4R41mVPzTfZgMRMExgiVkBWc68lK7xNy3H8RM142+leaQJ6Js9bW+foW+RxAeORkcK8e8vrHim+KLn0VWjaTuu6ZXhmsvll75hM4xzc7pMu5dMYGMhlr0jr8cSATDLIEExOpixtUVETKdeCYUUHdXNqZmx83Ccf0VOM2cV/a9rfMGToN5G8U5doIBtbeLStuIiP5Xea3NwWigLz0CerCLY0X8YNcWYpQH/AU3R0K9TYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEM+wy0xLVCKAd7PkUL88webi31RWzUQrWpB4NjIuqw=;
 b=Z+Dtt247xzBVf94bUSfQWh6+Xq4xP9vtj4mD76VGs7FYgm3yid1s1NqazSiz07xIGMGUsvnNNOvKmXs2rt3b+WH3J3vD7cglpXRjBQiBTEWZdBCUhOb5hzITxVkH0+aKWBwAFbGOm/q+wfwjVgNBwiGaXgynNI4T8zVqSg0A8jE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4505.namprd10.prod.outlook.com (2603:10b6:806:112::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 10:07:14 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:07:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 00/12] xfs: Extend per-inode extent counters
Date:   Thu, 16 Sep 2021 15:36:35 +0530
Message-Id: <20210916100647.176018-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:07:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17f68fae-fa1c-48f3-8a55-08d978f9c1ca
X-MS-TrafficTypeDiagnostic: SA2PR10MB4505:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4505BE1DA229A03F3D4DF6EAF6DC9@SA2PR10MB4505.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Lf1dNhKvSEKWGcA+ftKS1A/6QK9S9yilBZKpj1thk+WM0+IvlzlpPkfaQ617No9uZ288Rn0q5rfqIW9LdBRrlZqEnGdmWC4h9XVUfGAP2F/9LFmPUIrzmPm0Zm2btAP7exjJs82676o4XhIXVTX6Tv04vITvBZrUhqNfUmRZkH6QKu4O6twx30dWnLfFJNG8zfDt6Lzc+kmFg3ATpv1fCzCu6etSIWFgNk3IP3ARX6kHRyvt2UQ0CUxf0PqGxq4DgE/mRoduKjAaEjzTBWEkJkxPc6d7tFfv2oNzd9V2vluakYPTs9xfcfeDbo2eK4glscAU3To33bUST1IWsDlGZBNbEwleO7m24U+/tHWc1yhsREMKV9KczgkzJq/h5tOahVh59VT5vzjcld/gPrGzVzlkA2iSe3gnomXd5U4PLlxPYTgHyUL+ZkxGGhFB/OiBMsnx366Xk2o7JI+fy96r0Dd7bjS0SgiyAnoASGY+lohCeEZ3c8kJOFA5Ve9H/m700xGamANAE02bcB49R2O5YFQM0hXbUb5D6KPE5TI6M3+xhGHHbG1XOvBcg1fiyOD8E5qpTHvOOt67j+3ttOoXFkjDGM0ORAC2NfzfDFjiUenWRI/7RF0fl9E2r7XHzATQTja2QpyPfNviIAXIBT148iBY3ILH8Hn7PQI+z6gYdIJbUHYVx42eBmjhOv8HLfGWwo+cDLAyJaG/TFQH+gB3FpaZrBROW8XMzE87kbGYpsTt/nf8PIiHLUWGHYzXDK6e85+yQ+iqsHDRg/UU9qAaln8pj2b2X3p63A/bhjMWB8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(366004)(346002)(478600001)(83380400001)(86362001)(2906002)(6506007)(36756003)(8936002)(8676002)(2616005)(6666004)(186003)(6916009)(52116002)(6486002)(966005)(956004)(6512007)(5660300002)(316002)(4326008)(1076003)(66476007)(66556008)(26005)(66946007)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5GE5hW7W63jS6MmoSC342FbHuVwK2KS9za+cCMeCqNVoidWEoiia7X+VBfpq?=
 =?us-ascii?Q?yhUB1rGvHpuXLKPShbTUt64HDJtmn2MNQNBdxHxDkEVjIOpGlw2dNVyE9KqR?=
 =?us-ascii?Q?SWdceM7y/3mbL91Mx0khXjVWvqVq1LTBVCOiHbTH2Ij7bAnntVxEgVlSeL8E?=
 =?us-ascii?Q?aLmcfVyd4IjWB4a9ynkXmHwPjvAd7wDsxSctj4ESJv+7K10i3uL7uwpi5hCZ?=
 =?us-ascii?Q?S+NGmL4XGle+t+C9PdO/+XCu6al+YLhCiDEf6rMPubyJNRYnjyPYSoW1uGO+?=
 =?us-ascii?Q?7bDiqJVJejSU1rt73584t2eU40egEUYvNAAEik2mFUjeUJVQuneL57/7k8Md?=
 =?us-ascii?Q?deLKBSp1tRDDv0P5u4UlhGSs6e7pSFlKdE5G6O/Xj1ZtdcPGjHqseljy9gfD?=
 =?us-ascii?Q?V1szICd0wW+5FKaJtSOwVuMfUM73hb6sggv0ZWuD01pk31IhAL4l83s2Wb4u?=
 =?us-ascii?Q?IsgkDejnkJZoqW0O2afMG5RBFF8rkYKtFu1swBCLhMnBihsF8V55dWcbKwnN?=
 =?us-ascii?Q?m91ptKFC0K8tST7bl6ps+eIPWKp8ktoxx2nGBPMFXgsWDxr1HCtGd4/c6tMG?=
 =?us-ascii?Q?oPbVouvmbI0pkz+DY01wOUpAeBjf3q1R543E0yZO7U6fm96oHvOV4Q1wRrSb?=
 =?us-ascii?Q?eIs5Ndc/oZXNLicX8FAuLPV3CyTt5bEdRYDJyVjx/j5TrFO8rkrNwEwNaNpW?=
 =?us-ascii?Q?5TpLLMjhZ/vAzafgQTpEzNbC6F8Xhrr93/lewoXg3PBONiZHMqLLPIM4o0mT?=
 =?us-ascii?Q?v9cxmiA1Yq6tYLGPY6HuKGrltWWHu47wayqCNiecC6e/w3sQPVAhC+5UXPnt?=
 =?us-ascii?Q?8VqPQQjk4PzQG7a3AZbHkEzVq+ycMiQkWtqztDNhURU0NfdmXFQF45cXMo5x?=
 =?us-ascii?Q?cFHemZ//Yjqd5kB+eFdGNDh5jA1b9FDXke2hw3XjuehnlHTFedAO5BrgTCxz?=
 =?us-ascii?Q?IqNsr1wNMA9LKPmT18gsR4eIO63U62PMgN5ZNUWZnN6NmXZKpPOYf0B6OoiB?=
 =?us-ascii?Q?W/DOQhO5ahLCvg8ZZBbG4doQ1KAbRLdVHrIb2Zo9MceRPkaFfEBGz8XIG+vT?=
 =?us-ascii?Q?04io0OFqkmSrqW6t3XFzzR6Y4JG6XU71VrTTALroGpCTqveQEW5XgN88odVP?=
 =?us-ascii?Q?C5OoXwxCKfVsn16yQmBVK1EmPbyvDSk31pWV9eWXbgH2e0jU7jwd/LhqZlTM?=
 =?us-ascii?Q?SwHmH6eOnpYC6fFpsNO72YvKDfE5zQWLnOCM7px8+xzk+ntprPGrr4usBKOD?=
 =?us-ascii?Q?Xv7q8nwFLlHwHxRfi9riaIiDAN4YB/rwIyAeLXGQA/b2MR587ct2AWEayjDN?=
 =?us-ascii?Q?l/iunKjG+ErSkemDPsnP3IK/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f68fae-fa1c-48f3-8a55-08d978f9c1ca
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:07:14.6507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SAQk3jCu8obMP8yAZWhOaybbp2sIhdcv5R28WvCxSv6HtZNTxwQPqhSRRTVrJE46fMF6nNxRZnO5fWq9YtIfWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4505
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160064
X-Proofpoint-ORIG-GUID: MqzKmMfJGyuQnWophVgdfYMohQ9dbcNn
X-Proofpoint-GUID: MqzKmMfJGyuQnWophVgdfYMohQ9dbcNn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The commit xfs: fix inode fork extent count overflow
(3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
data fork extents should be possible to create. However the
corresponding on-disk field has a signed 32-bit type. Hence this
patchset extends the per-inode data extent counter to 64 bits out of
which 48 bits are used to store the extent count. 

Also, XFS has an attr fork extent counter which is 16 bits wide. A
workload which,
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
1. A new incompat superblock flag to prevent older kernels from mounting
   the filesystem. This flag has to be set during mkfs time.
2. A new 64-bit inode field is created to hold the data extent
   counter.
3. The existing 32-bit inode data extent counter will be used to hold
   the attr fork extent counter.

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
the new incompat flag. I have also fixed some of the existing fstests
to work with the new extent counter fields.

Increasing data extent counter width also causes the maximum height of
BMBT to increase. This requires that the macro XFS_BTREE_MAXLEVELS be
updated with a larger value. However such a change causes the value of
mp->m_rmap_maxlevels to increase which in turn causes log reservation
sizes to increase and hence a modified XFS driver will fail to mount
filesystems created by older versions of mkfs.xfs.

Hence this patchset is built on top of Darrick's btree-dynamic-depth
branch which removes the macro XFS_BTREE_MAXLEVELS and computes
mp->m_rmap_maxlevels based on the size of an AG.

These patches can also be obtained from
https://github.com/chandanr/linux.git at branch
xfs-incompat-extend-extcnt-v3.

I will be posting the changes associated with xfsprogs separately.

Changelog:
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

Chandan Babu R (12):
  xfs: Move extent count limits to xfs_format.h
  xfs: Introduce xfs_iext_max_nextents() helper
  xfs: Rename MAXEXTNUM, MAXAEXTNUM to XFS_IFORK_EXTCNT_MAXS32,
    XFS_IFORK_EXTCNT_MAXS16
  xfs: Use xfs_extnum_t instead of basic data types
  xfs: Introduce xfs_dfork_nextents() helper
  xfs: xfs_dfork_nextents: Return extent count via an out argument
  xfs: Rename inode's extent counter fields based on their width
  xfs: Promote xfs_extnum_t and xfs_aextnum_t to 64 and 32-bits
    respectively
  xfs: Enable bulkstat ioctl to support 64-bit per-inode extent counters
  xfs: Extend per-inode extent counter widths
  xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to XFS_SB_FEAT_INCOMPAT_ALL
  xfs: Define max extent length based on on-disk format definition

 fs/xfs/libxfs/xfs_bmap.c        | 80 ++++++++++++++-------------
 fs/xfs/libxfs/xfs_format.h      | 80 +++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_fs.h          | 20 +++++--
 fs/xfs/libxfs/xfs_ialloc.c      |  2 +
 fs/xfs/libxfs/xfs_inode_buf.c   | 61 ++++++++++++++++-----
 fs/xfs/libxfs/xfs_inode_fork.c  | 32 +++++++----
 fs/xfs/libxfs/xfs_inode_fork.h  | 23 +++++++-
 fs/xfs/libxfs/xfs_log_format.h  |  7 +--
 fs/xfs/libxfs/xfs_rtbitmap.c    |  4 +-
 fs/xfs/libxfs/xfs_sb.c          |  4 ++
 fs/xfs/libxfs/xfs_swapext.c     |  6 +--
 fs/xfs/libxfs/xfs_trans_inode.c |  6 +++
 fs/xfs/libxfs/xfs_trans_resv.c  | 10 ++--
 fs/xfs/libxfs/xfs_types.h       | 11 +---
 fs/xfs/scrub/attr_repair.c      |  2 +-
 fs/xfs/scrub/bmap.c             |  2 +-
 fs/xfs/scrub/bmap_repair.c      |  2 +-
 fs/xfs/scrub/inode.c            | 96 ++++++++++++++++++++-------------
 fs/xfs/scrub/inode_repair.c     | 71 +++++++++++++++++-------
 fs/xfs/scrub/repair.c           |  2 +-
 fs/xfs/scrub/trace.h            | 16 +++---
 fs/xfs/xfs_bmap_util.c          | 14 ++---
 fs/xfs/xfs_inode.c              |  4 +-
 fs/xfs/xfs_inode.h              |  5 ++
 fs/xfs/xfs_inode_item.c         | 21 +++++++-
 fs/xfs/xfs_inode_item_recover.c | 26 ++++++---
 fs/xfs/xfs_ioctl.c              |  7 +++
 fs/xfs/xfs_iomap.c              | 28 +++++-----
 fs/xfs/xfs_itable.c             | 25 ++++++++-
 fs/xfs/xfs_itable.h             |  2 +
 fs/xfs/xfs_iwalk.h              |  7 ++-
 fs/xfs/xfs_mount.h              |  2 +
 fs/xfs/xfs_trace.h              |  6 +--
 33 files changed, 478 insertions(+), 206 deletions(-)

-- 
2.30.2

