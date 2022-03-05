Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE6DC433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Mar 2022 12:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiCEMp2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 07:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiCEMp2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Mar 2022 07:45:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD11F1CC7FD
        for <linux-xfs@vger.kernel.org>; Sat,  5 Mar 2022 04:44:37 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2259nFg2008819;
        Sat, 5 Mar 2022 12:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=9gxU61UO5j+Rp4Zrbq5p5MaaDOs+5ilLSGElSUM4V7Q=;
 b=X469+SpHPqa/6QISf3B4gQ3maGCsFcwPy3FP3VoGjo87TPvgReNpmuLDagHW7z/fqaqj
 KF6vjdTzlPhGNvBMMkwyu5xPrn+P6JKBCF8wnpEV9GeL11huGiM2FNtJCTS5s5mu8G/h
 pfHAG8B1p/m1VFI2YUTijE5GNMr+S/iG8pqFocqgroQBNSxhYmcai/gjWslE1UPKvdNR
 7AwkV8EDMokusz2iknvNIK5xtP1C61myTjs5X4TRg/G2nuGum+lCchkuj9UgH6WFPsyd
 M/nrzgxZGQoaAca+ykUHVWYL5k19h+ypSflZA50MyvfJu73fg544GbD3ZBChi5A1r66K 1g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0grmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:44:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 225CaxtY113046;
        Sat, 5 Mar 2022 12:44:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3020.oracle.com with ESMTP id 3ekynyqwh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:44:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DkGPupudZqoJxSET8vWc5DtD0EUuzPSiz3Mu8ZzCqBM9JvbmYUnWomocrtJrcmSie+HbA7vgBBPto10lqZ2VUt+SmjBmgwoQyeGRavZAUQRGk24qOFsAs6dzr33etmGJAGzBUc+jX26mj0IhEyIa28vkg64IXtA9RMqXABphkUcpryHNluvqBcpiLNRbenU8c6Ah6ointyBNMCAPVmNcLQA5+GUiCFyOrrNygZJlJQCQC2KWGpLFcLqdFwuH+FhM9+46dFLtP3TBbdNbG+pgJiDOZn2qTz/RXaReXNJ7x28R+pExw4dWFuYm3zoA81wtekYCVEtfPMXaVKKNILfglA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9gxU61UO5j+Rp4Zrbq5p5MaaDOs+5ilLSGElSUM4V7Q=;
 b=H8FT0rivRuAF3U8rhnCKc08/BNmhc4R99a+bvJuqXga7Fn9qK0fpZnpV9z6Ywj1YPB2klgGyJseLcXZ1VJKC0dCYswG8StxyKHr0zhMO0BdTt31Hm8X1dz9efghoN85gOeExF+aMcBc/iu2z/bmRkL3lQ6h/zlT5+MvVWBWcCWkqQ3HSLzYyhqJJDtx7thzayH2AV8fep/WSi7thKnP8GtEOwu2DOOPzT9eLlruBoi0EItp6HIt+jd2WrccwPTldLqTkg98r7yv/h2cjL7Kii1JYxFtk6XjkeHiVvWwp+J00OAUTUFrXkzWN3V4+n+Qo4yBSwhILrQ3DYBuB69kvAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gxU61UO5j+Rp4Zrbq5p5MaaDOs+5ilLSGElSUM4V7Q=;
 b=J14Y+qYYtLk1CrjrT/D9NupYbtQQnpAer7aDPwhsgLd4XgugAqPwkRLeQ3VMlL1MRZOCYFisFlfVGF7RBN72BBnTXtw3C2VksEDjAwv/GD9RV/2SQ7nzLX1TVKe6zdhfv65mjmW7CkKWDV1RRcLU1ANGJ8kpaD6Uj5SmoR3fQAc=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2821.namprd10.prod.outlook.com (2603:10b6:a03:85::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sat, 5 Mar
 2022 12:44:30 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%7]) with mapi id 15.20.5038.019; Sat, 5 Mar 2022
 12:44:30 +0000
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-12-chandan.babu@oracle.com>
 <20220304023228.GG59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 11/17] xfs: Introduce macros to represent new maximum
 extent counts for data/attr forks
Message-ID: <8735jxhm49.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20220304023228.GG59715@dread.disaster.area>
Date:   Sat, 05 Mar 2022 18:14:22 +0530
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0022.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::34)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ddcade9-85d9-438a-f888-08d9fea5e41b
X-MS-TrafficTypeDiagnostic: BYAPR10MB2821:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2821CF7F41DDA8877DF35113F6069@BYAPR10MB2821.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rMMPJ3Sv5cuyeYAQyxqpxJkvjPrS5Mh8G6q/PZlzfUV42AqwyB6l4Rb1Ze6YKe7i6r0jQFrHw+940BEHA1iKkQhh4ZKXIVLaApHRDWCOMdQM5YvUOKMg0U9OydCIRH7lp3AFWtdXS9svt4kbDteEg9/lOnG9pNWWPpHAZZwMth/oB9jxyImSuRcL6gYRGnMlUVYEUZyZtRXEDcNCimyjN6dyuSvUFjYbmVpmPpq3YmpmbPfQjXb+Lhy99JuAqAk6CxgqNM3Q+zoACdZQF5BWKxNWXza/YZBmniPyxNb8srgbPNJ9b3cPO6RHlW+iCR2BccwsSUfDcjxC8rg3t0r8f7JUAHw24/z3Ak3m0dcfWn0uQ8gjc74ftL/Tr2qVu25IWM9bg91Z4rrnNmW/u1i55qczkmNa4gFB8P8sDaZCjpXzrN4PRn5+FLGGMXNKHBFQu4fSlJnEer5c1gcrLIQ8zVK1Tortf1PLYhyQI+xyQmUttYXHM0XcT6JqmkpV+cpdBjmdR68FgPfqApw08ym4fDXIzlJ28arlvJ+X26UTFw89qF9QymuLjyg5qBDgHJSY0gQV15klTyEPIvdfU5FoWX19FkFsyCmFsYogqrgtGSPhrIHoLAJdGTebPPIXm32kEuStgrdhtf4KRpC4VS6/WPPRKerDrXQKd1iUTXW/JceSYiF1l/EMBy+YvLYA3GKVIgCagw6N6WnI+Wu/nueBVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(83380400001)(26005)(2906002)(66556008)(86362001)(6486002)(186003)(316002)(66946007)(6916009)(33716001)(53546011)(5660300002)(6512007)(6506007)(52116002)(8676002)(66476007)(4326008)(38100700002)(38350700002)(6666004)(9686003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0aWrgv+EWUkZ4MXuYayTUbxbg0G7NmbOjqnQRMildOVGxi89E0pBm3WrCitp?=
 =?us-ascii?Q?F2y5Fm37nGJmEC8W5bHzHpJuD9PpLIe4D5iqJpntZzi6VbILd2xx8r2ehcKT?=
 =?us-ascii?Q?B3KIBE77EHxvZIxlmu9jWEYpsc49kftR80E3Fs1+WjJlidp17jz8XVF3qKxh?=
 =?us-ascii?Q?xV+KGOkbjb6sNMZg9o7kGIchgjtGqC6bQpcfRQgBt5kbKCLKmt2pQuDdbeMS?=
 =?us-ascii?Q?DxlXd0DTLdXWp8tk2mrlNElK3Lgj9GcHBn45u7Hw2JBvNjkTL5A8EFgV1hDq?=
 =?us-ascii?Q?aQTtlKaypVEYL/rxHcVwnBLMDZghQDbJP8oVEWl0Vrw+iYQDhRAQMDCCDUR8?=
 =?us-ascii?Q?lcMlO0bee2rRb/mXm+D7Avqg5jrBf7UbkQcPg14ZaJg9+QJIUUlNJkhAm3Vq?=
 =?us-ascii?Q?mA2a3FVnVga2EGjqQS9vOHuJzOR7QWPGrt/E0fpWl3uc7DBL9KVj5wvKRZrT?=
 =?us-ascii?Q?QrCbBz9PaFzD3ekJWOKAo7tWqfIu8kjfScpx5eIrHybiEUjW7riJHLsoDl1N?=
 =?us-ascii?Q?Zjs6WfvA5yTVc5ZsMagwCb1ZjepgqQ7y4lAz6i+H8wanT9cU5cfa+Anr7+bl?=
 =?us-ascii?Q?bQC5eOFlEicSl+gsiyZrgtYeUa44AD86drlRClcgXb41kMxgtiBtoddpJuEG?=
 =?us-ascii?Q?z51ZHmhHbR6Tgu6SRA/Cv/hXE2isH8q7K4hXFcOIxVk5P/KsumLquL8FtDhv?=
 =?us-ascii?Q?R6T/dvMA1K4WFxxM/V8nqI1WM67qidUju/+C+7WlL/5W3DKOM1GoyZFOUd6I?=
 =?us-ascii?Q?70CvlcC4kWL1ML3rYdSHYbD8OWn8qDKKZSS4I8kn3AQQsTn/Gvusre3TtQi/?=
 =?us-ascii?Q?R6WFIu5C7SpWNysFRDgbJAh6SVWI0zfnENmyW5qBjZI2g/5Fcwpb343QWrOA?=
 =?us-ascii?Q?jXrW2cOa45WAi3+ML3dRkKi4kPJ4PEWr2C37Bo3QGI9gQIm8R99nNUP/NvR0?=
 =?us-ascii?Q?+C4e8QTZyR9bhIevg1E6T8BACUMlEidEJNViYpAU7yYZWPrfOrz5sYfl051E?=
 =?us-ascii?Q?F+bcZvCSYGbjC6JwogWYUCUuiwN/719bOCZdKbgD10DOg+hMAjtWhOfKo8cS?=
 =?us-ascii?Q?N2vJ2YJsR2lEZ+g1Lwi29cQujIvssrvpZXPR2Ep41f3EWALMglN7fV2qxCUk?=
 =?us-ascii?Q?Hkh7E/yCE8s/TG8Z2D8MZSHiMNbXZxRkpEJalBrIAZDM6TeI6iMCvmpKDFK9?=
 =?us-ascii?Q?1diU3P9wumcR+2WjttJmgu5I6WVCGJxODrDxMyaPGJsJzgwqsB6W8Q/3Irao?=
 =?us-ascii?Q?k6B5u6qWv2QYzaIhd5DW2fnSH0DrsCDwqr1FDs2HIKeqErlgi56BYoAd4mUh?=
 =?us-ascii?Q?Inbw+ETwYMwDvKpJvWlB6vl9fu7rGfPA9Muttniz4AT49vB5u2xm08R0ZVF/?=
 =?us-ascii?Q?GeqrhJdj5uQb4rO8kE3mxyg8k148c7F6yMAtRJFZl1y7A7pwUgpWmTZW/UBr?=
 =?us-ascii?Q?uJVUY50YL0u++9aVHPsTWGDzF2IkTBT1092wXT2Kdiqo4UEu1QU+glMsHQuY?=
 =?us-ascii?Q?sxBMLfZotHCLSQkp5SZBWsEIu0hGsm+T7Xn9uoruXz0A5puTGtTmP/lmky0D?=
 =?us-ascii?Q?curXSW8GYQygNypAvvEPYhLhtM4wYnsZCxq56S/bjeyxYVv+nepE+Q4Q7+yK?=
 =?us-ascii?Q?SBAdHZtu5FvkuVkT92UslPY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ddcade9-85d9-438a-f888-08d9fea5e41b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 12:44:30.2857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKvY5dGGWSRyhVZJrdgF8dQyHtelwBbCS4Vi9H9Pq2Gfg1nxHkbupotg9ewMy9PHrpQEWKYN04rrZkmU3ZirUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203050070
X-Proofpoint-ORIG-GUID: BXgpPXz-n5N6uRz-_l-SN7Rvnqdg0PaQ
X-Proofpoint-GUID: BXgpPXz-n5N6uRz-_l-SN7Rvnqdg0PaQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04 Mar 2022 at 08:02, Dave Chinner wrote:
> On Tue, Mar 01, 2022 at 04:09:32PM +0530, Chandan Babu R wrote:
>> This commit defines new macros to represent maximum extent counts allowed by
>> filesystems which have support for large per-inode extent counters.
>> 
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_bmap.c       |  8 +++-----
>>  fs/xfs/libxfs/xfs_bmap_btree.c |  2 +-
>>  fs/xfs/libxfs/xfs_format.h     | 20 ++++++++++++++++----
>>  fs/xfs/libxfs/xfs_inode_buf.c  |  3 ++-
>>  fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
>>  fs/xfs/libxfs/xfs_inode_fork.h | 19 +++++++++++++++----
>>  6 files changed, 38 insertions(+), 16 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index a01d9a9225ae..be7f8ebe3cd5 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -61,10 +61,8 @@ xfs_bmap_compute_maxlevels(
>>  	int		sz;		/* root block size */
>>  
>>  	/*
>> -	 * The maximum number of extents in a file, hence the maximum number of
>> -	 * leaf entries, is controlled by the size of the on-disk extent count,
>> -	 * either a signed 32-bit number for the data fork, or a signed 16-bit
>> -	 * number for the attr fork.
>> +	 * The maximum number of extents in a fork, hence the maximum number of
>> +	 * leaf entries, is controlled by the size of the on-disk extent count.
>>  	 *
>>  	 * Note that we can no longer assume that if we are in ATTR1 that the
>>  	 * fork offset of all the inodes will be
>> @@ -74,7 +72,7 @@ xfs_bmap_compute_maxlevels(
>>  	 * ATTR2 we have to assume the worst case scenario of a minimum size
>>  	 * available.
>>  	 */
>> -	maxleafents = xfs_iext_max_nextents(whichfork);
>> +	maxleafents = xfs_iext_max_nextents(xfs_has_nrext64(mp), whichfork);
>>  	if (whichfork == XFS_DATA_FORK)
>>  		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
>>  	else
>> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
>> index 453309fc85f2..e8d21d69b9ff 100644
>> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
>> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
>> @@ -611,7 +611,7 @@ xfs_bmbt_maxlevels_ondisk(void)
>>  	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
>>  
>>  	/* One extra level for the inode root. */
>> -	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
>> +	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_EXTCNT_DATA_FORK) + 1;
>>  }
>>  
>>  /*
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 9934c320bf01..d3dfd45c39e0 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -872,10 +872,22 @@ enum xfs_dinode_fmt {
>>  
>>  /*
>>   * Max values for extlen, extnum, aextnum.
>> - */
>> -#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
>> -#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
>> -#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
>> + *
>> + * The newly introduced data fork extent counter is a 64-bit field. However, the
>> + * maximum number of extents in a file is limited to 2^54 extents (assuming one
>> + * blocks per extent) by the 54-bit wide startoff field of an extent record.
>> + *
>> + * A further limitation applies as shown below,
>> + * 2^63 (max file size) / 64k (max block size) = 2^47
>> + *
>> + * Rounding up 47 to the nearest multiple of bits-per-byte results in 48. Hence
>> + * 2^48 was chosen as the maximum data fork extent count.
>> + */
>> +#define	MAXEXTLEN			((xfs_extlen_t)((1ULL << 21) - 1)) /* 21 bits */
>> +#define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1)) /* Unsigned 48-bits */
>> +#define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_extnum_t)((1ULL << 32) - 1)) /* Unsigned 32-bits */
>> +#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)((1ULL << 31) - 1)) /* Signed 32-bits */
>> +#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_extnum_t)((1ULL << 15) - 1)) /* Signed 16-bits */
>
> These go way beyond 80 columns. You do not need the trailing comment
> saying how many bits are supported - that's obvious from numbers.
> If you need to describe the actual supported limits, then do it
> in the head comment:
>
> /*
>  * Max values for extent sizes and counts
>  *
>  * The original on-disk extent counts were held in signed fields,
>  * resulting in maximum extent counts of 2^31 and 2^15 for the data
>  * and attr forks respectively. Similarly the maximum extent length
>  * is limited to 2^21 blocks by the 21-bit wide blockcount field of
>  * a BMBT extent record.
>  *
>  * The newly introduced data fork extent counter can hold a 64-bit
>  * value, however the  maximum number of extents in a file is also
>  * limited to 2^54 extents by the 54-bit wide startoff field of a BMBT
>  * extent record.
>  *
>  * It is further limited by the maximum supported file size
>  * of 2^63 *bytes*. This leads to a maximum extent count for maximally sized
>  * filesystem blocks (64kB) of:
>  *
>  * 2^63 bytes / 2^16 bytes per block = 2^47 blocks
>  *
>  * Rounding up 47 to the nearest multiple of bits-per-byte
>  * results in 48. Hence 2^48 was chosen as the maximum data fork
>  * extent count.
>  */
> #define	MAXEXTLEN			((xfs_extlen_t)((1ULL << 21) - 1))
> #define XFS_MAX_EXTCNT_DATA_FORK	((xfs_extnum_t)((1ULL << 48) - 1))
> #define XFS_MAX_EXTCNT_ATTR_FORK	((xfs_extnum_t)((1ULL << 32) - 1))
> #define XFS_MAX_EXTCNT_DATA_FORK_OLD	((xfs_extnum_t)((1ULL << 31) - 1))
> #define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((xfs_extnum_t)((1ULL << 15) - 1))
>

Ok. I will make the change suggested above.

>
> Hmmm. On reading that back and looking at the code below, maybe the
> names should be _LARGE and _SMALL, not (blank) and _OLD....
>

Ok. I will make this change.

>>  /*
>>   * Inode minimum and maximum sizes.
>> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> index 860d32816909..34f360a38603 100644
>> --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> @@ -361,7 +361,8 @@ xfs_dinode_verify_fork(
>>  			return __this_address;
>>  		break;
>>  	case XFS_DINODE_FMT_BTREE:
>> -		max_extents = xfs_iext_max_nextents(whichfork);
>> +		max_extents = xfs_iext_max_nextents(xfs_dinode_has_nrext64(dip),
>> +					whichfork);
>
>>  		if (di_nextents > max_extents)
>>  			return __this_address;
>>  		break;
>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
>> index ce690abe5dce..a3a3b54f9c55 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.c
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
>> @@ -746,7 +746,7 @@ xfs_iext_count_may_overflow(
>>  	if (whichfork == XFS_COW_FORK)
>>  		return 0;
>>  
>> -	max_exts = xfs_iext_max_nextents(whichfork);
>> +	max_exts = xfs_iext_max_nextents(xfs_inode_has_nrext64(ip), whichfork);
>>  
>>  	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
>>  		max_exts = 10;
>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
>> index 4a8b77d425df..e56803436c61 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.h
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
>> @@ -133,12 +133,23 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
>>  	return ifp->if_format;
>>  }
>>  
>> -static inline xfs_extnum_t xfs_iext_max_nextents(int whichfork)
>> +static inline xfs_extnum_t xfs_iext_max_nextents(bool has_nrext64,
> 							has_large_extent_counts
>> +				int whichfork)
>>  {
>> -	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
>> -		return MAXEXTNUM;
>> +	switch (whichfork) {
>> +	case XFS_DATA_FORK:
>> +	case XFS_COW_FORK:
>> +		return has_nrext64 ? XFS_MAX_EXTCNT_DATA_FORK
>> +			: XFS_MAX_EXTCNT_DATA_FORK_OLD;
>
> 		if (has_large_extent_counts)
> 			return XFS_MAX_EXTCNT_DATA_FORK_LARGE;
> 		return XFS_MAX_EXTCNT_DATA_FORK_SMALL;
>
> That reads much better to me...
>

Ok. 

-- 
chandan
