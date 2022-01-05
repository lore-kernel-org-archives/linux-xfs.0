Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7953DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 13:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240435AbiAENwD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 08:52:03 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12618 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229601AbiAENwC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 08:52:02 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205D4Qi6003377;
        Wed, 5 Jan 2022 13:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mg93P6PkcFAN+W+Q92RAsLRF8CotVKZ9XQfvb9ZBih0=;
 b=AYOOWhrmQgpyPFpEHxQ18eSf9A1z+7vil9Yg2am0zcLpEjkyohjzPNOmWAD4yr/JFyzF
 KbfmWHutTnAAjjanKhbP/HhWLmJyNP3ep1wk4wmbc4a8qbjTACoZx8R+5DiAslHwd9k+
 w9fNenupiOwfazfIEGbalqUkNPnWCzLu/xSNR+00UaqobpLchS5braADKn9YWxRewSzS
 tHI0Kwe625A9sAHhCM8BcdzQ9K2OG2v2EIb0dx7OKaLnnl0+DPU0M4Bcj4/qDMMnfwkM
 RPQthKL7eKILbinEfEaixJF1tlDrfIKR6Nj3H52aAYEAY8uc/9yh4O6WEbHNiJXQHrHw 8Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc3v4mvam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:52:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 205Dk8Bi124804;
        Wed, 5 Jan 2022 13:51:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by aserp3030.oracle.com with ESMTP id 3dad0f1nrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:51:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1TxTnMTh4lAYXzFFKvqwaB2tIVDxD7k5qgOY4G4yXrJ0CZovj9YARfBjph+SFyLc09b71mMn91jMGqP9TFL9fuYrYXPQ3rLtuNO8iw6UASLaFWwVl5n5Op84kU3ELE3cSguiolSjE4LcggSjGJ7nWqh/I1CceSPjC8Kom+a6P9raTbP3SsLCq7EuWTIN1N5h+rlznbBlJcO4nodWFJOakQqzyhpipCCVhUw46w4sxw2jznvbCtA2d9XKk0ZRHPw7r+JS6UtYvI9f+2R5pn3Z+8BMw7aVXdNf7yX/sN+9MN51ORmE3y+AhOGVb/rkyI6wLkC7cPmZ9Ha07F1e2B1QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mg93P6PkcFAN+W+Q92RAsLRF8CotVKZ9XQfvb9ZBih0=;
 b=Dhv0ijb9DrABEzKnp7MdCIA4yAfaIABFrYgxtvdPuKz95P32/DLeqJutz9wdFcXxA4RxKVr7EDhL1M56jSqRMnHTwUy4hW7jBzifGihbyeGrQytoDTvqkrfKIT1mDWUhxzYOT3ULneKWuHN9SAjPfJ9fyhsw7M0r5U/O3NBPG3L3KshxJ6N2HzxWRu0DbImso7beI05435FPG7KWiIgoOkIRs6HtRdW0qAHuV6R3uwqPX5pyt1RN56CZ1Suj0fMhTkjmXny8pFOkMixw2SQcVQJzPwDFYkrYPy/YgeVj1uqAzBZyuAWUAly1aPo6lXwD0x2BzYa9moTmUa2rq3Cu7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mg93P6PkcFAN+W+Q92RAsLRF8CotVKZ9XQfvb9ZBih0=;
 b=oybOkdVHggAMZ04BlPoPvUMmw/MhQYmTF0IEmDj2qV37faueq1jA3rcroLLv0DqS6ChHb32p88211jJ4V5o+oQF2U95ccBZDcyhHxJWaXp9HeMT7i5NX3JdXpKI277EeqF8JxP8MgWQqOBDASdttSqTDG77+KZJtgfPCHi1A+sY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2542.namprd10.prod.outlook.com (2603:10b6:805:3f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 13:51:57 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.009; Wed, 5 Jan 2022
 13:51:57 +0000
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-17-chandan.babu@oracle.com>
 <20220105004706.GT31583@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 16/16] xfs: Define max extent length based on on-disk
 format definition
In-reply-to: <20220105004706.GT31583@magnolia>
Message-ID: <87k0fe8f4c.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 05 Jan 2022 19:21:47 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0121.apcprd02.prod.outlook.com
 (2603:1096:4:188::21) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 774b9a9f-a796-41ef-a96a-08d9d05289cc
X-MS-TrafficTypeDiagnostic: SN6PR10MB2542:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2542E76BBC5805C47F0AFB35F64B9@SN6PR10MB2542.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 36txgekG/4U5v4CN4gq6aEJqBm6/9ghITQPiU6NcZCLgtHA/He+GoHqTWgTIyK5kPt8F/Qjw60yGp4usVpxhe7whI/dU00hR8E7RaeGs50gNAkvgkTg6DI7TWIio0VHBzdyupX6H/p/HWDXWRR+EMIdJgW3X/IHMCEwCCkSYXMjynXePBI2qGu/l8tOSiwkrAaoqMw8SRPZGPzUpiADLxU7S4hNLmFwDTa2nlF0faxSqDf+GtgOPHL/N6GBLp2YNz6+Enp26mC+YGaXmjJBIpOu0ZDX/FozsrN71v3JY6FgHNPyVvSc5r1Lk3lNIiQmTMoN2aR0LnqxwSUsjPe9nCgxLldcu4Y6Nk+xImMpDKhsNEDdEMYYriD1S+4ol1b5WpjWtgvHm6Q19foHRN7AEFX4bhv+xzW7hzOxwgJl6rEhJCCpZ0ZPp0wjEzGYY4G/vuhDqoO7B8arfM6Z5qNuQbB01B1PANg1hJm2SM2DK/wXu+wMvFutn3iqzNoygBTcxduo1RqgfkMtXSn8v/hmwB9euQXyPQ3ACe/1EoeYUWyiGnknDzs9vyKThdj5KQ80Z5zBBf1aJUWWNbzbL0ytivF68xQI23GZPuU3Zeuz8JDlbUwfxPxuTLUBn5x3Pq3O161LAOQeNAGA/wdJ83c+WqvdVvskv+NDYEXmgWUetMHDYGko+8wvZgTk8wJ2sit6Jd1QQVwkliJLQJkko5p4r2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(33716001)(8676002)(6916009)(2906002)(83380400001)(9686003)(53546011)(8936002)(6506007)(38350700002)(508600001)(186003)(38100700002)(6512007)(86362001)(316002)(5660300002)(66946007)(4326008)(26005)(6666004)(66556008)(66476007)(6486002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iAYRCYJIZpS56O6AjrYLZaHRUG0tQfKDTCEbI9y6VleLXiR4n+oyL3t3bsIs?=
 =?us-ascii?Q?kPekataLTnqIn+jtMTha7TsT5Xv0WMOmjw9C6kI3GHTCorLPPhqrFGLxGFcb?=
 =?us-ascii?Q?83brv8CZorIp74nzZ0cZElIAF9T92iWIjVv5MycUfrsNBv7hcrJpwDPg4HyT?=
 =?us-ascii?Q?p/V5GuO/Hag0xDyC47kdAEXH5gj1wEa9mtBt74Bir6ka2I9JptG3VzBpBokk?=
 =?us-ascii?Q?gBTkMYibq/nSgt7aqhWpwTED7G47WA4Z7hJ7M+/Ny4lCDqgk5ZnGlFNSsjQ4?=
 =?us-ascii?Q?0rQPaJrL0K9I9Sg4f60772WNjeEng/ZC9fXKAZO7al66Rmoq5QAwaasK7Ym3?=
 =?us-ascii?Q?jlbQMpfuDmewOQIzvDHQ0ii2MpR7EnXGXaPgPY8koRWJwXNvwwEB6oDWTl5y?=
 =?us-ascii?Q?ShC/rr/fXAZtc40noLhsPVzABbz3EWweQe08QRyj0fFAPH6+db8IIzMfM548?=
 =?us-ascii?Q?BQ91W6YiPrB7KbPa1ROc/q3XPhAxdtNUcRH/Yx8V579su6Iwms+ZKXC2Rvq9?=
 =?us-ascii?Q?vR23ukFKvXuV9X0vy+9FEPfd5w9CxEk5k8CaJQQU1BxOfFDnHaYEcb9QuF/W?=
 =?us-ascii?Q?11Y5qBWuXMQNHvNivQkoIR2PwsdU7TkVmD2cJ7ZbS9gc2+H8J20BBwd8AVpI?=
 =?us-ascii?Q?KmETyoMIivEfxAPNNjkTVzT4HRfCgXouQh0t7sSZKke4YcOM6BYkUmhDv4Ft?=
 =?us-ascii?Q?Iqou/gGCHuAgaw3dM6siiwos1g49L0GfKl0tZ06xTMfkQA+NfaQTGUa0PEny?=
 =?us-ascii?Q?IU8jk5hrz6qbR6KidGTYXb3sOR6vx23Qv0D09n+OXJGDcHs6z2xvigH5eUyt?=
 =?us-ascii?Q?uXYbCmGytkqHaWw0yddEW+5QapaqA5jvLFffjk8yJrLnh+dJhZnTsAJp85um?=
 =?us-ascii?Q?TPN5Qtco2AVq/rWBvYwF6T/ixlWXEEbquDEFvjt4HWxy5JpYPOCztbMR96eM?=
 =?us-ascii?Q?frsWcAzSygEh/LxrGrF0DTYhtWYd1GqPOxPrsG0GUVlw5/eFnAeOVw2uL9Y4?=
 =?us-ascii?Q?VlNZrl7cPi71bG/sLtGC7qGFnwV7hHkV+qU7LGb1ODIK5nCiOoFTRiEHXMmg?=
 =?us-ascii?Q?jXJzCFELZToL6n63L762zL+dHdek935HrDztTest5/43Vn1uOnWkIF+1rjAl?=
 =?us-ascii?Q?X7hV1u9ThOSUqCuHobJs3Cdjyvtg8k4a7dTHgSn1p4PyjpjnltVDw5gohPr0?=
 =?us-ascii?Q?UPK+hxSLup0boQL21fBHOjwLgVL0/t9YPWnO/d3Rwo3mrk2TPE4KVZw9LGB6?=
 =?us-ascii?Q?GOzguDDHGvutYR+0tP388crz8MZDnwsBBnh2kFfdOIGuIaES2uzgQzrP0rXG?=
 =?us-ascii?Q?wonUVx6p9K220JhvNkTy2V+b9QuqJfnStfPgTCaWuEfGHt1VcDwUpI+SJ9ed?=
 =?us-ascii?Q?MYDOgiZx7CRVPDPAw/JXhPoLb9kgfFd+x6ZshorGhwbfD+06GJB6PRovXoXG?=
 =?us-ascii?Q?I8kRSi3aMFAK0RgJCGZ77FdytpjxH9mGKmFOZkGMruA50DfGPKOcuXNRh9Jn?=
 =?us-ascii?Q?hkENEGZLVH5pWvDT+yEnC9jak5r3pCRWHZ2PX9JJ9Nk1i6QFpgHsF4rxpEPf?=
 =?us-ascii?Q?vs73E7oruIkrLeOHzRMOmkG7eWcWz3JMK8gtEzi0lNc4NQeM2eQdzKf3B7vV?=
 =?us-ascii?Q?yNaXPfXHMa8zHKawUv0prRY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 774b9a9f-a796-41ef-a96a-08d9d05289cc
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:51:57.0698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xW7UBpwVNrdihbBlho8Q5U392+atM3IC7JYJ/vGViQuc8ctvkONXcFYCkG5eGg3u4azuyML0gN8kKU3DQ1fpZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2542
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050092
X-Proofpoint-GUID: qgMlscGS_NvdbTDZvt5P8kwxNhjZJ7gM
X-Proofpoint-ORIG-GUID: qgMlscGS_NvdbTDZvt5P8kwxNhjZJ7gM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Jan 2022 at 06:17, Darrick J. Wong wrote:
> On Tue, Dec 14, 2021 at 02:15:19PM +0530, Chandan Babu R wrote:
>> The maximum extent length depends on maximum block count that can be stored in
>> a BMBT record. Hence this commit defines MAXEXTLEN based on
>> BMBT_BLOCKCOUNT_BITLEN.
>> 
>> While at it, the commit also renames MAXEXTLEN to XFS_MAX_BMBT_EXTLEN.
>> 
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_alloc.c      |  2 +-
>>  fs/xfs/libxfs/xfs_bmap.c       | 57 +++++++++++++++++-----------------
>>  fs/xfs/libxfs/xfs_format.h     | 21 +++++++------
>>  fs/xfs/libxfs/xfs_inode_buf.c  |  4 +--
>>  fs/xfs/libxfs/xfs_trans_resv.c | 11 ++++---
>>  fs/xfs/scrub/bmap.c            |  2 +-
>>  fs/xfs/xfs_bmap_util.c         | 14 +++++----
>>  fs/xfs/xfs_iomap.c             | 28 ++++++++---------
>>  8 files changed, 72 insertions(+), 67 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> index 353e53b892e6..3f9b9cbfef43 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.c
>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>> @@ -2493,7 +2493,7 @@ __xfs_free_extent_later(
>>  
>>  	ASSERT(bno != NULLFSBLOCK);
>>  	ASSERT(len > 0);
>> -	ASSERT(len <= MAXEXTLEN);
>> +	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
>>  	ASSERT(!isnullstartblock(bno));
>>  	agno = XFS_FSB_TO_AGNO(mp, bno);
>>  	agbno = XFS_FSB_TO_AGBNO(mp, bno);
>
> Yessss another  unprefixed constant goes away.
>
> <snip>
>
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 3183f78fe7a3..dd5cffe63be3 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -885,15 +885,6 @@ enum xfs_dinode_fmt {
>>  	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
>>  	{ XFS_DINODE_FMT_UUID,		"uuid" }
>>  
>> -/*
>> - * Max values for extlen, extnum, aextnum.
>> - */
>> -#define	MAXEXTLEN			((xfs_extlen_t)0x1fffff)	/* 21 bits */
>> -#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
>> -#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
>> -#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
>> -#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
>> -
>>  /*
>>   * Inode minimum and maximum sizes.
>>   */
>> @@ -1623,7 +1614,17 @@ typedef struct xfs_bmdr_block {
>>  #define BMBT_BLOCKCOUNT_BITLEN	21
>>  
>>  #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
>> -#define BMBT_BLOCKCOUNT_MASK	((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
>> +
>> +/*
>> + * Max values for extlen and disk inode's extent counters.
>
> Nit: 'ondisk inode'
>
>
>> + */
>> +#define XFS_MAX_BMBT_EXTLEN		((xfs_extlen_t)(1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
>> +#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
>> +#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
>> +#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
>> +#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
>> +
>> +#define BMBT_BLOCKCOUNT_MASK	XFS_MAX_BMBT_EXTLEN
>
> Would this be simpler if XFS_MAX_EXTCNT* stay where they are, and only
> XFS_MAX_BMBT_EXTLEN moves down to be defined as an alias of
> BMBT_BLOCKCOUNT_MASK?
>

Yes, I think so. Also, all the *BMBT* macros defined around the same place
will probably help make the organization better.

-- 
chandan
