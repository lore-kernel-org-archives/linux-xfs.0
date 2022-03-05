Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D48C433FE
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Mar 2022 12:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiCEMoM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 07:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbiCEMoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Mar 2022 07:44:09 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22749199E0F
        for <linux-xfs@vger.kernel.org>; Sat,  5 Mar 2022 04:43:18 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2259nFfl008819;
        Sat, 5 Mar 2022 12:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MTajv7YzkLLeIZsGj6g6zTlKmI7UefDCxEP5r0H1bYA=;
 b=I+bfhJfZ9z73TlrqDErVSooaUHJeaXZTGRrj2aXNWZoDUBAqtmCxooZJDghnc7kZm2kq
 XFfraUzyGm6vX+AKjAh1Iq0rZkcdogvspzOmUiCFki7f4y62sv7cHcgEOmMQVVgV8/MK
 O+F8GhOtRv1cc4PRtXtoLUWLW/IS2SHRJu7gEgeOntVnpotFi8ULVAv+SaeXuq5tl3kt
 ytbNd+fFD34BxH9iqeMAl7UR1UqfRbROWj1uTlu8UXiEp1v/Ro7+FkXx6XB/Dtdlkbyd
 5szCVhK7OTVehzkyPZxpEbYUxl2AxhVz6MyRPGSc4NwfO/jeEZ5wGhcyLkX/yebGfPnw yA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0grkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:43:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 225CbBX0113655;
        Sat, 5 Mar 2022 12:43:13 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3020.oracle.com with ESMTP id 3ekynyqvmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:43:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rq0d/mtHCC3piHRrul+kd7vsCGZGC6EeAzfNf0ewfOsFBB/jECUhGXgJl4dSaEor1RupTmcdI70QMLM/s7fJXTPTuTZWsc3aByv+Hc6wvVZMPSAndjjOf1fZhHU36neBVIMHqWerX+8uJ5kirgHLzZJUR/tfl/uKcqG57jCGdjuwbdFzN7l9UZjV8WX5KlcqT1dUhof/eQUuEtXDklIu9eIU2uMbo0rtrTlg+Ddftbb2BBCkU5stOpMf5qQK8+bSjz2Cku+uue+DxYtG3LtrRahnaFixaoJfkGelGTSwZ6hmuVBOvg2qaYZz7uLJBBlP9d/9x3DbN2/xFQa83ke4lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTajv7YzkLLeIZsGj6g6zTlKmI7UefDCxEP5r0H1bYA=;
 b=Zm+LKp7bq7DtjDJJKmnRwleS9uaDUgXg48j7BvkEOBQBLnncuHsav1886djbMjnj9sE4OgLoIBj5o6lBXsgwnVFu1qyUwyPhC5tsLPC1hJORxT52gwTt00XNeopAoJv+1ckB3oSuSeDoK1QwzO7ZcntG1fctVCWLPaCIGwnUwEOr+T9Wk9rxeqHlxWi0+HOaiUR0TQercwH67LUtV04VS5RGCwdAZQrV1DZZAnY6Fzx5P2sZ9077j6if1c1vlv0Q4IPooMqBFhl9V+ppjtAU51TBfYdejHWzZ8eOydZO/1eEkFA9/zioc4QpMO2qrIfXhzQ6buc2tKg3U3o3npb8xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTajv7YzkLLeIZsGj6g6zTlKmI7UefDCxEP5r0H1bYA=;
 b=oog11IuRsm2aUHwx35pDQblGVbzpCV2rjqZ9lMd67vSOC/8gwJffPBHiCbY/rJKVFn2Yyi0TRZRjRWLIACh9ynG/ZP++09Mpa1oxGUTfOtOhTs4ykref8pJYqxD5f7IgrDI+bFGUeew0heMprer/9W4ArJQbixJLPT0zYSPbaCY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2821.namprd10.prod.outlook.com (2603:10b6:a03:85::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sat, 5 Mar
 2022 12:43:10 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%7]) with mapi id 15.20.5038.019; Sat, 5 Mar 2022
 12:43:10 +0000
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-5-chandan.babu@oracle.com>
 <20220304014338.GB59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 04/17] xfs: Introduce xfs_dfork_nextents() helper
Message-ID: <87fsnygegt.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20220304014338.GB59715@dread.disaster.area>
Date:   Sat, 05 Mar 2022 18:12:51 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY1PR01CA0205.jpnprd01.prod.outlook.com (2603:1096:403::35)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d4cc465-dd35-4fb5-a83c-08d9fea5b3b3
X-MS-TrafficTypeDiagnostic: BYAPR10MB2821:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB28216E96F5806D22A0C26365F6069@BYAPR10MB2821.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NHR0W5gAgfpsI1Go3312GHgpZrMOHfCouB4oJ66Mlh0c+IJar31ZZlqMi1mTIDwE0r0byTx48mT00dsaQDgPPxWNq6M9mIymc+OgF+ymOn6YIyc1RAnwmdIlA6jhrgCmQbA3Gd6s9PADmr6AIQiPT3dSjZPVt7UesDQ6y9/YcWWOZ9T9c/h7EfJ/q82CIKmF7MC2DhfYLxChS6mJkZnkyMAJs7gb7pIbxzBbcHpkMX4LEPZQFmFcai2iN/8pk5orNlqKO/b8XH+Ho12wsrFWpmEsTe0gXpxN1ZdNAmvmCAhUnqH4LFNOFQqSOfhcw+mv6TjzRPgB+Scp88pOrVtWQFQWL5ONr1rep40lVc0beM4eYLpb4Be2QymFfVB6ANvUfaelP2cD6oNZ2MAs4zKzDUFoZ9FPGlHTKbvinOUgtBg00GisJ5AEvljPmc42yYtnN0v8fynQMrIVAzzYMW9hH3biRoUNuQd8zP0UyC08iin0VQHf0QWY2hChISwXA0XrKABsaZrDlCeKFcDF6xkZBw4afuz0BqI7AZWFxI0+47uHcF1roQkJCbPns163syi12k1drOVuWC6q7SbzZRYE5S21jIX4uSGIIAQid0FEu0VLgX/meoKUJ5o66r2fCyqVFrtE0/3IAlILOsIocmuXMBZILYDViN7IHp9+/dttcY4MoaZleMFjGjRqVw1dt19M3/SCxjAyE4laid2tjgkoiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(83380400001)(26005)(2906002)(66556008)(86362001)(6486002)(186003)(316002)(66946007)(6916009)(33716001)(53546011)(5660300002)(6512007)(6506007)(52116002)(8676002)(66476007)(4326008)(38100700002)(38350700002)(6666004)(9686003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?906TlQuxV5yAvgLzd6Sotr6CqfZV2n+Tr/YEEFrlLygR2gcnebYh3NeLIlfw?=
 =?us-ascii?Q?VfuX6KeaFhPtWCmMhHsGJkFe5ZPIoWDkPsaXVG0JKCuFGzzM5caL4LSEfhB+?=
 =?us-ascii?Q?uMJtvOjCpxPBFhEmgI7PDsbG85eX1JOl9J7pnnX+n93WjdmZFoGIcDIhH4d0?=
 =?us-ascii?Q?2PQYrAIgM0nYK2ep9KJjkZ26Rw62uCQM7Oay8cYcFVXD5ijMJ5gRwciWwZlJ?=
 =?us-ascii?Q?ec1G88Ud4ToRKtFjZ8DxmK1uSdt2A2CAnUezjaCIBlct7CLEHS/XYX+sznaE?=
 =?us-ascii?Q?DCxWbjmu8tbsNpRt4tw4hSDxey7YSPIaPFKoAN55tbjoaKYe5fPatZzSmeUJ?=
 =?us-ascii?Q?sEb6fyW5g3V3bP+UtB5Foj0RnZdWR5lZRu+EMrE9isOGxtuITRG9DI2OmkVI?=
 =?us-ascii?Q?E2VfhDrmHat2PHUCGDgq7GN3kU11cdcCaRzFFXRy4/O+0Qv/saSQV5MbgK0q?=
 =?us-ascii?Q?ZiFBq8AwMCtp4cp4SlJwZWeszYcG6dAwQIgqQsqgtfspQ1jjZKtZ534lcGi8?=
 =?us-ascii?Q?RoThxoo9VoHVEsVPG33PQikOPimAC2nAdH45lQR9nKS2hwh2yFIDTD2NgEJb?=
 =?us-ascii?Q?5YG1UO6cjXvEp5DMijiSdxis/Q268kr3ksOy/61tK+yT2ujlMQfccfLWYJmJ?=
 =?us-ascii?Q?ZL2xCaE4fYlvwBEDGlFDvtZfRvlMBzAcefIhLePnZsGQ2pQy3Yb8x2hunG+l?=
 =?us-ascii?Q?frobzEv63/0Uu+S9C1nRkngOk/JDpdOiNDExujaFtSxKoo8Yy3bg35a6gk33?=
 =?us-ascii?Q?FlYn5+aGT9ovabi+gJvxOPLE45Xk5uP2IC/zEfHdHGEYrKJANLuLgChzRKi7?=
 =?us-ascii?Q?ZA3g8rQV1D4v4/VAg6GliU4pTAACCZrn79qDYb+zK4aba2uTlvp3jhYijTyq?=
 =?us-ascii?Q?6yrPt9OdAniJFwK+ohKGaKmn5mEpr35mjVi3oU1JyrISa4FZ8LmnFzNd7ptP?=
 =?us-ascii?Q?TIYaRn5bSsEeRI+E9uSziB/ePDrF3pOxssV2mwwzZ3TRR+BVgfFPjvO7Idak?=
 =?us-ascii?Q?Tav/CovAmXRO3/Zo96RzUH0NW78+jWm1gMlHs2q5zqupubZXb+QfA7B8thab?=
 =?us-ascii?Q?hajkifm5u+6bLB5JhCGok1T7GQS5x8pR6aTgu2he36TnUz8Eo1ntbRQujdYN?=
 =?us-ascii?Q?lZqwbD6LzaJ6VfnqIJfGOOAA4Rwk6J+J5ddkoxNtU9JmeS2lsq7YVFb5wZuC?=
 =?us-ascii?Q?xb5EpQagwsZaIrwprPdzXBFotDux1DPCypv1bkezeFSwRCMSMhxnOpLYiBom?=
 =?us-ascii?Q?GR/bdy1JYSW3622fS3LqBYOW61qBcEhtPHsYAutkb/iJ/y7gFfxgmFnLjA7P?=
 =?us-ascii?Q?v7Bs/an7UnGkhzuo3Vht6cG3yK74iH/vRJeWeL9IzYAi5Rb+NwxSisxNQZVU?=
 =?us-ascii?Q?Gel2WSLIFGD7WVjSqIfFgSui9l+yV7fXN8rZ2ws1k6R9qtzWGHA+xnOr8w7m?=
 =?us-ascii?Q?mV8J9+FZoknJFhU0mzgBPj2ajaQTzopSCbCB4Mvo/mjyErdAqFzjh17NRewC?=
 =?us-ascii?Q?4u34Zingj7QhPPrx23b5eCw0Dr2CVA5dvVcXHNNhW7A8X1TE9kUPRuuXT7Pv?=
 =?us-ascii?Q?7tdz3ksH3LAUcxMpigwjzISmP92jF+F4ZJ1jyoesqsq9JYA4lNN1lj6W8BVc?=
 =?us-ascii?Q?4CaDI94GZizJjMblgQokMgk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d4cc465-dd35-4fb5-a83c-08d9fea5b3b3
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 12:43:10.4945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EFsqu1R84gnxjtohGWC0s8Ip1+FURbtjeqblK+vmDA9DysRkLFswQ0NI4rnPPqpnt6yTW1Cl4GcdBwX2exQUig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203050070
X-Proofpoint-ORIG-GUID: VEeJKn9JcDflb9kF7gU3ugCL-xMrfaHR
X-Proofpoint-GUID: VEeJKn9JcDflb9kF7gU3ugCL-xMrfaHR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04 Mar 2022 at 07:13, Dave Chinner wrote:
> On Tue, Mar 01, 2022 at 04:09:25PM +0530, Chandan Babu R wrote:
>> This commit replaces the macro XFS_DFORK_NEXTENTS() with the helper function
>> xfs_dfork_nextents(). As of this commit, xfs_dfork_nextents() returns the same
>> value as XFS_DFORK_NEXTENTS(). A future commit which extends inode's extent
>> counter fields will add more logic to this helper.
>> 
>> This commit also replaces direct accesses to xfs_dinode->di_[a]nextents
>> with calls to xfs_dfork_nextents().
>> 
>> No functional changes have been made.
>> 
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_format.h     |  4 ----
>>  fs/xfs/libxfs/xfs_inode_buf.c  | 16 +++++++++++-----
>>  fs/xfs/libxfs/xfs_inode_fork.c | 10 ++++++----
>>  fs/xfs/libxfs/xfs_inode_fork.h | 32 ++++++++++++++++++++++++++++++++
>>  fs/xfs/scrub/inode.c           | 18 ++++++++++--------
>>  5 files changed, 59 insertions(+), 21 deletions(-)
>
> Mostly good - a few consistency nits below.
>
>> 
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index d75e5b16da7e..e5654b578ec0 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -925,10 +925,6 @@ enum xfs_dinode_fmt {
>>  	((w) == XFS_DATA_FORK ? \
>>  		(dip)->di_format : \
>>  		(dip)->di_aformat)
>> -#define XFS_DFORK_NEXTENTS(dip,w) \
>> -	((w) == XFS_DATA_FORK ? \
>> -		be32_to_cpu((dip)->di_nextents) : \
>> -		be16_to_cpu((dip)->di_anextents))
>>  
>>  /*
>>   * For block and character special files the 32bit dev_t is stored at the
>> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> index 5c95a5428fc7..860d32816909 100644
>> --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> @@ -336,9 +336,11 @@ xfs_dinode_verify_fork(
>>  	struct xfs_mount	*mp,
>>  	int			whichfork)
>>  {
>> -	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
>> +	xfs_extnum_t		di_nextents;
>>  	xfs_extnum_t		max_extents;
>>  
>> +	di_nextents = xfs_dfork_nextents(dip, whichfork);
>
> Why separate the declaration and init? We normally move the init
> up to the declaration, not demote it like this....
>

Having init on the same line as the declaration would cause the line to cross
80 columns. Hence, I had moved init to occur after all the declaration
statements.

>>  	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
>>  	case XFS_DINODE_FMT_LOCAL:
>>  		/*
>> @@ -405,6 +407,8 @@ xfs_dinode_verify(
>>  	uint16_t		flags;
>>  	uint64_t		flags2;
>>  	uint64_t		di_size;
>> +	xfs_extnum_t            nextents;
>> +	xfs_filblks_t		nblocks;
>>  
>>  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
>>  		return __this_address;
>> @@ -435,10 +439,12 @@ xfs_dinode_verify(
>>  	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
>>  		return __this_address;
>>  
>> +	nextents = xfs_dfork_data_extents(dip);
>> +	nextents += xfs_dfork_attr_extents(dip);
>> +	nblocks = be64_to_cpu(dip->di_nblocks);
>> +
>>  	/* Fork checks carried over from xfs_iformat_fork */
>> -	if (mode &&
>> -	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
>> -			be64_to_cpu(dip->di_nblocks))
>> +	if (mode && nextents > nblocks)
>>  		return __this_address;
>
> The naextents count is needed later in this function. Rather than
> calculate it twice, I find the code reads a lot better if it is
> structured like this:
>
> 	nextents = xfs_dfork_data_extents(dip);
> 	naextents = xfs_dfork_attr_extents(dip);
> 	nblocks = be64_to_cpu(dip->di_nblocks);
>
> 	if (mode && nextents + naextents > nblocks)
> 		return __this_address;
> 	.....
>
>>  
>>  	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
>> @@ -495,7 +501,7 @@ xfs_dinode_verify(
>>  		default:
>>  			return __this_address;
>>  		}
>> -		if (dip->di_anextents)
>> +		if (xfs_dfork_attr_extents(dip))
>>  			return __this_address;
>>  	}
>
> And then just check naextents here, too?
>

Ok. I will apply this suggestion.

>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
>> index a17c4d87520a..829739e249b6 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.c
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
>> @@ -105,7 +105,7 @@ xfs_iformat_extents(
>>  	struct xfs_mount	*mp = ip->i_mount;
>>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>>  	int			state = xfs_bmap_fork_to_state(whichfork);
>> -	xfs_extnum_t		nex = XFS_DFORK_NEXTENTS(dip, whichfork);
>> +	xfs_extnum_t		nex = xfs_dfork_nextents(dip, whichfork);
>
> I'll point out declaration with init as I mentioned earlier...
>
>>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
>>  	struct xfs_iext_cursor	icur;
>>  	struct xfs_bmbt_rec	*dp;
>> @@ -230,7 +230,7 @@ xfs_iformat_data_fork(
>>  	 * depend on it.
>>  	 */
>>  	ip->i_df.if_format = dip->di_format;
>> -	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
>> +	ip->i_df.if_nextents = xfs_dfork_data_extents(dip);
>>  
>>  	switch (inode->i_mode & S_IFMT) {
>>  	case S_IFIFO:
>> @@ -295,14 +295,16 @@ xfs_iformat_attr_fork(
>>  	struct xfs_inode	*ip,
>>  	struct xfs_dinode	*dip)
>>  {
>> +	xfs_extnum_t		naextents;
>>  	int			error = 0;
>>  
>> +	naextents = xfs_dfork_attr_extents(dip);
>> +
>
> .... and point it out again because otherwise this looks
> inconsistent.
>

Yes, this initialization should have been included as part of the declaration
since it won't violate the 80-column guideline.

>>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
>> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
>> index 87925761e174..edad5307e430 100644
>> --- a/fs/xfs/scrub/inode.c
>> +++ b/fs/xfs/scrub/inode.c
>> @@ -233,6 +233,7 @@ xchk_dinode(
>>  	unsigned long long	isize;
>>  	uint64_t		flags2;
>>  	xfs_extnum_t		nextents;
>> +	xfs_extnum_t		naextents;
>>  	prid_t			prid;
>>  	uint16_t		flags;
>>  	uint16_t		mode;
>> @@ -391,7 +392,7 @@ xchk_dinode(
>>  	xchk_inode_extsize(sc, dip, ino, mode, flags);
>>  
>>  	/* di_nextents */
>> -	nextents = be32_to_cpu(dip->di_nextents);
>> +	nextents = xfs_dfork_data_extents(dip);
>>  	fork_recs =  XFS_DFORK_DSIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
>>  	switch (dip->di_format) {
>>  	case XFS_DINODE_FMT_EXTENTS:
>> @@ -408,10 +409,12 @@ xchk_dinode(
>>  		break;
>>  	}
>>  
>> +	naextents = xfs_dfork_attr_extents(dip);
>
> Initialise the two extent counts in the same place - they are both
> first used only a handful of lines apart.
>

Ok.

-- 
chandan
