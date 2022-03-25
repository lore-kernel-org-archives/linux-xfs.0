Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40321C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 06:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358466AbiCYGjC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 02:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346242AbiCYGjB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 02:39:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F6DC5587
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 23:37:28 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22P0DU75007602;
        Fri, 25 Mar 2022 06:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3eHrwXDJAh4po4MTPSH+MbwAImUtF3fj4z51xU+dVqU=;
 b=kFiSleXzffURhNHvgcu2pEYJGmOBOL/aSeqIrB9IMYhJP9mBoEkwAiaLdZdZ8vGZUP/J
 F44a7umBtQ7s4IzV2ffMDPl7NYj3Pn4ILgTAcqtBIr86HpCcFEMEJjcj8z4C/y9uiOZ+
 e2G32Ej6+krPXqCWPqFGgOv70sXrF3yKecObFBo8tOZi9RZ0J2fnW8KgybCsirLF0oD0
 kwKvkKHaQR2VlFGOGJ1K6OHchCqueFM5XP1XjytjZAK9JHsMhxXyw1uBn8Farjd4kKjF
 /XejFSCU2cpRKUVgRbNqXPY29SJbitE9LxXhgnjK8KQFFTLyvaHZYB4mnCVF1IoFEe4l Ug== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcx3m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 06:37:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22P6WIm8054214;
        Fri, 25 Mar 2022 06:37:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3030.oracle.com with ESMTP id 3ew5792ej6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 06:37:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxZdmyvZ/lj+qXGW0wxwnu5Akqng61vSczVvbqBSjwjwAi1Q8XdPuinOfMwOpSCyPspqOMa+AXvLq2USffPHkkFUrR2Ut46t6tKHUalSTFAMcIW/uAi+/NCiSO9s4WWjpwn91u5ZkDUKdz2hz2mjiq8OkQ7v/gFrsTe7z/OqcH/UwRSz3np7E3hwZGkeemXvJ39c4PRaf/1gb08FvSa+jP+187hHTUKkZTCnmwHsCvCeDVbdjxQuPZEYE7Ng/pY/L5jE7T3pjr0KewKOtsQpOH5IXAWZEzZWCOsuQqIpBtsNWyY+mtaz/sVYyNF/sXIPKAdFRNQTA9lpd6q7C57LVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3eHrwXDJAh4po4MTPSH+MbwAImUtF3fj4z51xU+dVqU=;
 b=eR9xsZsN/hoB+kwTv2DNTYNJ+WAeU8jolfp/5rooOapc/Am7nbpw3dvjY2Ck5fDPE3pxgN1NAhbtWJ0cfDO6ScvJXNlu6kz80skFpAQhsdeXTbE3x/jWHoks+GZdleGCz3tP+nZGZ5G9o+gCUwhWs1UcAKwox+qLJP7SzuRmXIStekNBag1XWhHEbvHxrfWBBQ0SQp1vjLLooMqvrNjazg5SQPcCgc4wUU9HhLqN785dnW5/g7JM2wjCLejvDZyzEVwwxaa8tTryhyzqvfxHAmyGMbnM/DgnfNGm6ft12le07EfD1tIjNUqefAQnmmO/4RyORXPsbpErQAeTLFkwDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eHrwXDJAh4po4MTPSH+MbwAImUtF3fj4z51xU+dVqU=;
 b=whg8UCNQhDUZ4YXb3gsu5GfnSBdzaMry6n6IWOOTYT92nnEoEHCG9ZLIE/c3S7HIwsN3nf1v6wMcYMfRiPoYqe/fj7LOpoCsje4NqBvF5eW9K1r9vUJ2yqoovYCNqndPn1ZFrKQRn6n9voiCmWBfxFG5mJCO+4qmfWjLzBti1x0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM6PR10MB4236.namprd10.prod.outlook.com (2603:10b6:5:212::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Fri, 25 Mar
 2022 06:37:21 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12%6]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 06:37:21 +0000
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-16-chandan.babu@oracle.com>
 <20220324221406.GL1544202@dread.disaster.area>
 <87wngiwow9.fsf@debian-BULLSEYE-live-builder-AMD64>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V8 15/19] xfs: Directory's data fork extent counter can
 never overflow
In-reply-to: <87wngiwow9.fsf@debian-BULLSEYE-live-builder-AMD64>
Message-ID: <87o81uwnaj.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 25 Mar 2022 12:07:08 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0107.apcprd06.prod.outlook.com
 (2603:1096:3:14::33) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d2b0635-f7af-4012-daa9-08da0e29e9ea
X-MS-TrafficTypeDiagnostic: DM6PR10MB4236:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB423624594B02D264F0257CCCF61A9@DM6PR10MB4236.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iKLp9paQt+VgwuwEN6aJvmf2X9iI0uU5j3oiec9JmKcBqEElK7vegQPR+OcCFrFMQXYEr+Y6kq2RcRwebmxj40jkA2khRbAxMKPGHZtbNN6ZK0NgAciBFElxZ6ndStrYl9Sh5ewNx7EYcvuDOqTy6QCLKtlVit6XRu8XO0SGpB+hjs2MiXHa3snXgoVqtYpYgNl5y7BSTjVQ2tmt/jFnp0VnJhxnAl5bTEvmGmAgz940hnvmVqvMpHcj2taS1Gk1XFLvWqhigC9TQjBM/3M2ITRpr2LdDqKo2DmYyiokhgMJjE3aMPPMUzqBF3gF1ipBXj1LeAkXOYnKPyN4EGi7xelMWoGmRJIzGY3NMN6XvP3iKlxcwXW5jI202YQnsdctIC3vIvGG0S98qQnh2oH+qu0A+ojhxw6BvSLmFUyHF3b/fRXJtY0tAqIlNHVIv7ERrATRLt5AOiKpCLSQinX6E5hdUNR4v/xplncW3xYI5g7MBq3lEnl1hEcHvMI0YuKv068pscFkC3+Ubi8bwrVsWlsWpEKcg8OuiZTlneMsKriU7OaLfbnq+6MBVVUZMB4vrsOEqtQLiu6mNmvMwsXityV7q6k07Bx2SnDsufzQv4sJjdStIx8DhqNjvIOmDBr6XI7TkLgnx6gzjCpEC+wqU0ytKUje8p8SXB9A3QdVPGDr2jfQl2ssZRlCgO3OVgSqsUqogAfqBiIpjX055NebPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6666004)(8936002)(8676002)(316002)(86362001)(5660300002)(33716001)(2906002)(6916009)(83380400001)(66476007)(38100700002)(38350700002)(66946007)(66556008)(6512007)(4326008)(9686003)(53546011)(52116002)(6506007)(508600001)(26005)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mYLNVUBMXlpAN73hpbNKV1gepodcD133oxH7zR1nysKoF8/iTO7zqDwFYT9G?=
 =?us-ascii?Q?9FWJQh58BuiHESORAywRkmmdnAq03Xs3D3KS+bkHs0fO17hXxxnKneagkPR4?=
 =?us-ascii?Q?kc0TE6e9fMLQU1NWyNAZhQYWcb4ZIwn2VOZWXMqmUTobXYeFud36pBkNIDZS?=
 =?us-ascii?Q?XcdiuabiUWMQZn8/4YEOVP2nbi2hfNod5J3A8CdQO1ghlKwmu9/KQ91QQP04?=
 =?us-ascii?Q?gmpueUdm3Ysuwyc/nI2y5/B/7+pFH+TvGPyOpjR2Ch19fFIZzZaV/rVdkExl?=
 =?us-ascii?Q?DUroU1rg4fU3x1qYmlY4KnPfhkEiK+hzwIFsiBARFu2Id+gN4BmS+LzvB69e?=
 =?us-ascii?Q?N3N0bQ3cM/Uom8FVWfgt1SGpC/5t2egai6VDVbKtHFlqSazYuilxGYWlyvDK?=
 =?us-ascii?Q?jBm+UGn4EYSCFlFSFhos88UAKEGF9t1gxX9Vogq9sgGCyfNfyW0E15O7j9FQ?=
 =?us-ascii?Q?/IbavKwRJ9yNmFV+Ulsnxj52IFQdFGoAUmXTOV2cZjAG+brxjFiuHf1IR7GT?=
 =?us-ascii?Q?qGtE91uWeevcoWW43asXgXte1chWXU+lOmRRZAwhH4V4Ei4+qNXPOaxdIbvd?=
 =?us-ascii?Q?/Cj6EwkgIHEHoxeYNYRiQSggsUfQVHiEKUj35Wc7Tfsr4EE6rLU/+vG34uPn?=
 =?us-ascii?Q?5CMaN4pd9bOzwugBVEDJcLNAZtxDp+fVvrd6UTyV6o6U0Y9KgG1QQ+xZhe8b?=
 =?us-ascii?Q?0ZFd07G2GNDd9/FmCYUCcj9qa9pE8YRZjwStlAtZAKXsE08Sq2RZqhCjy+Ig?=
 =?us-ascii?Q?dJfxMfrXsaHeooKLOIbIeZ7oyYaEhwR/jZcmuxfReYLDamtbDX5jCuCFFaNj?=
 =?us-ascii?Q?GJyyrxgAGfenWGMrM1+RQPIed/jJ8KI8C1VlTUaguNFdLzJR2lT9+7jvbiiA?=
 =?us-ascii?Q?/alx0XORIl/G5Znu69kseyM2zdxA5TWeKazOeNs0fbMZJRUiqQzxZM3Asyhq?=
 =?us-ascii?Q?DA18Uc5PpT1D8xHEbtp2vjvBXTci7XqJkmRZiFZzk9OnFH9nfuu1T1Bky4zr?=
 =?us-ascii?Q?QMQuHxhASrrY96ZD0aijGQr0+1ndNfDV5qzt5MrOQtzD1h0jTBZAZul7Wfi+?=
 =?us-ascii?Q?tUbVvBvH75RzuBThJnh23t1zYXIKXLpVV2wdPlj7qRKwlggS+GEYrj13A7vc?=
 =?us-ascii?Q?pAG0BpbaXfjdizGq+3s+JgM9ozVOkNBAKUEx5nQne7Nb2zldY3IqpUTBgrG0?=
 =?us-ascii?Q?8IuyvVDL1qXQh0iP7jVcWGwiiv/UN8AErXwUnaBvf7eRixwGjvWZzu5m+di0?=
 =?us-ascii?Q?lMSwPGp7/HlkXM0/3QRRq0mgJsbD/uwEmx/DwpBpyPP+368PrxmJrHByuQ28?=
 =?us-ascii?Q?mBdHssd/B8/GdzzpxOnkuv53xEK3olyn59Ha3zvBJtZIx4ptEfPe57DDPhCs?=
 =?us-ascii?Q?DdVstyT7ilvlwaFiS1UvHFjybmV5BcY+ueIZObytoW/pgxgywwUcpmk49FVD?=
 =?us-ascii?Q?Jof1w8FtyRi62JSQg3d6Qp4+Fjv6yt18ymQAl8yiduDAcIctwIjQan9AiDUD?=
 =?us-ascii?Q?vGmuIsukrhps/T2zvdmKkkECYsIEcLRneZQjSgOhpbnvkoxq9n+nz1/8qHFA?=
 =?us-ascii?Q?U8KYimT+x3JJqLRse8GcCr9FrIHt+ULbGOjsARrzMwQnT2u6I1QrH0rz4nE1?=
 =?us-ascii?Q?wwkkq2P8egTDF2OF32/KvfgEMdJtVvJilfVd0/QacSU0/AnvYRjQD863+F64?=
 =?us-ascii?Q?4da8erY34tXp8ifB8/rQewwOeHu/+oZYh1MRCHJJtJCX1tPB7LarO6ftXept?=
 =?us-ascii?Q?uHuQZda42H3GevFJdqKtZrUPdoth/4E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d2b0635-f7af-4012-daa9-08da0e29e9ea
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 06:37:21.0233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1OVXHCMd3GLFYJu3i+6oy6bAdiqYv1TbcwWMwEEn74Mq2Dq2CuKliS5hLzpkz2EoPfcT5VO+EckeKSQUSNkMvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4236
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10296 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=794 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203250034
X-Proofpoint-GUID: 13qsHihZTOLoO_AEF34TuttlOgY1eREu
X-Proofpoint-ORIG-GUID: 13qsHihZTOLoO_AEF34TuttlOgY1eREu
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Mar 2022 at 11:32, Chandan Babu R wrote:
> On 25 Mar 2022 at 03:44, Dave Chinner wrote:
>> On Mon, Mar 21, 2022 at 10:47:46AM +0530, Chandan Babu R wrote:
>>> The maximum file size that can be represented by the data fork extent counter
>>> in the worst case occurs when all extents are 1 block in length and each block
>>> is 1KB in size.
>>> 
>>> With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
>>> 1KB sized blocks, a file can reach upto,
>>> (2^31) * 1KB = 2TB
>>> 
>>> This is much larger than the theoretical maximum size of a directory
>>> i.e. 32GB * 3 = 96GB.
>>> 
>>> Since a directory's inode can never overflow its data fork extent counter,
>>> this commit replaces checking the return value of
>>> xfs_iext_count_may_overflow() with calls to ASSERT(error == 0).
>>
>> I'd really prefer that we don't add noise like this to a bunch of
>> call sites.  If directories can't overflow the extent count in
>> normal operation, then why are we even calling
>> xfs_iext_count_may_overflow() in these paths? i.e. an overflow would
>> be a sign of an inode corruption, and we should have flagged that
>> long before we do an operation that might overflow the extent count.
>>
>> So, really, I think you should document the directory size
>> constraints at the site where we define all the large extent count
>> values in xfs_format.h, remove the xfs_iext_count_may_overflow()
>> checks from the directory code and replace them with a simple inode
>> verifier check that we haven't got more than 100GB worth of
>> individual extents in the data fork for directory inodes....
>>
>> Then all this directory specific "can't possibly overflow" overflow
>> checks can go away completely.  The best code is no code :)
>
> I had retained the directory extent count overflow checks for the sake of
> completeness i.e. The code checks for overflow before every fs operation that
> could cause extent count to increase. However, I think your suggestion makes
> more sense. I will include this change in the next version of the patchset.

Also, Removing directory extent counter overflow checks would also mean that
the test xfs/533 (Verify that XFS does not cause inode fork's extent count to
overflow when adding/removing directory entries) has to be removed as well. I
will post a patch to do the same if no objections are raised.

-- 
chandan
