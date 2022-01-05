Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CCF6C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 13:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbiAENvB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 08:51:01 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:21832 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229601AbiAENvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 08:51:01 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205D4KXL004876;
        Wed, 5 Jan 2022 13:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=WWyFmnzwF07R14+VMWDXc3T0vsvpOgFXNswfnj+HP/s=;
 b=P/wIOg8fsyl5f3zD3n0uyq+xVWv6aNdFFgXcK6KF5M1MVGrvDP8edunKx2O1LqqCM+6w
 ZzGr85LTc769Wb8URyV61Dp6aXrXpz36f3bKJDNyxWADmxOKcrs5UFjGeGFnOc513Wz4
 vbN2uEcUxXj349QEC3JBee17ssap7yrpLPaIVsRlAMVcC+5u7+Ps/POnNgfkx/pT4ZQt
 iDEHFuRMlWt7r04LoPD7BGsiW9IpyonPj+Q1JfzWoy6SIfzRfE2R2UbG/PPvHmWA30RO
 KwC8tkMWuRmjnbF1IlyJLjAMIeZTWeCjSa2x02tf1TTJ57sGiT1Rq1EHiHmPu1yipquX Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc3st4vwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:50:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 205DjlwN091100;
        Wed, 5 Jan 2022 13:50:57 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3030.oracle.com with ESMTP id 3dac2yd5vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:50:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AE1ZVSupYlyAO5wHCclNBvIiuCjBzyF9/qm5EIaXYnDhDDz8PYUaKWpTOn//cErSPQzTSk2tc/OoHS1TvoeBZrvSiZNGxwCyleFdELrqmCoxFPj8VU8Id/hGMZ3eErFYLxAzjX+HXpBh217heG6vBxLXErz0S7ru3d40hNDQ+/Xp9pL5iLsvuPmAf6XRBObVP83vzCcGGoggeWL+/2107xkz3Tdw3+roIIpFj2Dob/Hz7l2GxMBBm7HOX1jkfRd1UNkVOh6/4GHC68LIH+WMyYon9oATHEMzh5pQlDgNJ2NJTSJHJ5zi7sH/dRR8gPOtcMm9vkJcVWA53bjNJskAjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWyFmnzwF07R14+VMWDXc3T0vsvpOgFXNswfnj+HP/s=;
 b=OZfFZrk7dBMYx9PBZjlm4jgXTqfeLkyjSK30yZ2Wn00IUajKSbNNIstGOQHoYyWc15u2qKYephpG7mg8TzMUhLpU51Z05iNgHF81HKTEhyPpyDcTijt52/pdbXqNBfzhe6eRYhcugFvkxdnmMXFhnk5szVa8KXPR3YAAlk4OlogoeXjMlLzKwAj6F/wNxMCk/2nBOgacyb+CND1eL4w0l+pLkg9SsgWX/m7uNqRmM3ynJoLG9M4L/MrMQNBQ06Kh6uWvgteu1alT9ck8ZvAxJ9CrTW1x3BExsnARTBqppV+NmRq58sSUCCrEijk7oFggvwIt0tM3Ho2sIq1QkdliLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWyFmnzwF07R14+VMWDXc3T0vsvpOgFXNswfnj+HP/s=;
 b=YO1KQKstTrM2AgMoysL3b58Iz0Etyq0FBleMtQfyWAGr9HLZF01uLQFvs1JaM4KK+fF1R98nNO744EpvANNMwKiAtRoVj7luRfjNPq58TqOdYqVAXIAhHIVsG3hTMgjMDLGTsSZb/rDvvvTiF2wrRnxQVaoaJdn3vDzGRMnkceQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2974.namprd10.prod.outlook.com (2603:10b6:805:cb::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 13:50:55 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.009; Wed, 5 Jan 2022
 13:50:55 +0000
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-15-chandan.babu@oracle.com>
 <20220105002819.GQ31583@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 14/16] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
In-reply-to: <20220105002819.GQ31583@magnolia>
Message-ID: <87mtka8f62.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 05 Jan 2022 19:20:45 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0025.apcprd02.prod.outlook.com
 (2603:1096:404:a6::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3528e9ca-3900-458b-5e40-08d9d05264cd
X-MS-TrafficTypeDiagnostic: SN6PR10MB2974:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB297429E96B95017DEB68BDCCF64B9@SN6PR10MB2974.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zuraQjk8oDgH7j9VtyXCYSrIIxp760tzVFHbK/6zduIeavzIqbglNOp9VSMIxlNDjjjIUxDI1WfBuIxhuDn2yZDtrGYuCdOFr+0qK4xyKzPyM9fKxw+JpE5D8+QKprj5YRUg3KBVXw5SYSK9Ac6WKMXgdgiYimWDN5pqxUuxrl0RjIFVZtmU+rQO+D6K9YGJaghccc6diASTv5FezQ9voQm3qR8oJK/8NYAPjVl42J9jf/5ooomkMolIv9NHLNNJM76blimjlSVeJOeqX20Q22soWM0jRvHVD+WOENk8hT3ZlvOTOXn1oRuxX+eQ2h1c91fhiKDstpELwPQO+F94HTGGHsKDsCTM0QEydifYsbYF9VHQmX8QUWSxysqCb1CbHAPqP91Z/1vQpasV0zKIE8Zl9opWcymBzYCOsXuzIRpLpNFWS9caRdshT7duZAV9csITlx3/EzvXWOD9+4kWs/Bk70LFSEvbvR1qItBdF6bt7OAFf5HIE05RyZHN4mjP4jQUeLqcO1gRvo2eRIBZxccZwqQOi7eax4mNj6KgasBYoCGbjbwgyGrNGCsii/9kjPjtBvyGN8Qh7F4VEOHoXcu1vluR/1u4luDt7TJnXnOMJXA7qI3qghR8KBgDBnH0XZajX4fnfiaddfn3zfskTzJlB/t5zQHCsBZeGopnONwCEcSnZmYE3nCcaGqPrsR9ewUgacHH0K/x4meodfQHDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(53546011)(6506007)(2906002)(316002)(5660300002)(6916009)(38100700002)(8936002)(6512007)(66556008)(66946007)(66476007)(83380400001)(186003)(33716001)(38350700002)(6666004)(6486002)(508600001)(4326008)(86362001)(9686003)(8676002)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uka+7xk1D1rcDEgP1421+osGJ2IlNL9EVRJOaNKums7eu+FSdeM8uHWyYjuy?=
 =?us-ascii?Q?GvzTxisoNz+H/dHaBof5QgaUg8kDIIIZNk2/VipQY3t8zBY101TAWO6HeWwm?=
 =?us-ascii?Q?cZJ4At+MtxpRy8Y3rdyLeIsPBWRY3Qhn3AfENNXHg5G/f61nm+zaus1q7AVv?=
 =?us-ascii?Q?plA3I7x/aTb1vmpJHMV4stUargwgpJpRJ2rE6+BxwAOx9Zzx74JLtxqm+lwV?=
 =?us-ascii?Q?NQFp/lYdtZJ0Xn0tAGHcevJ8Iazt76JnElOIuPFHbZwiqDO9mo/gXxGw74ij?=
 =?us-ascii?Q?pE1Hn0Q49eXpzuMbAnxvRBzW2Okifao51jOfNUv/oVBpUAdo7ng0fS534EoE?=
 =?us-ascii?Q?ECWPs5i0vVITYqMiu6Ot/7qYUV1H6+jPX6+Hq9KObtm0uBiuB7FaHSZJHDYQ?=
 =?us-ascii?Q?Lx99qiplHYXz7gQvn07ZD/f+F4f3b36rmT7AKC9dnrP3ZlBBhVGbOJFE6iWo?=
 =?us-ascii?Q?Aul6D0Wihgd62ONTSzyC4/d0vDgyGg4qpGLyVvBsJ7jQ5QLMR9jdjezBkElr?=
 =?us-ascii?Q?HyptagDxC2RbUmdZc0xhxg3gcbBJwOWDcoGlIU6DlzysmJBqWv5jrpkjGJXB?=
 =?us-ascii?Q?ISZcnvn6PQrXmqpoO8vvSmJVUPRzI7/l+P6YuY5UorgewpaOabfWK52PQ8A3?=
 =?us-ascii?Q?5xPmLtF6PG87lFnjpzZk1tDzzO4roI12jS984xJPjhZg/rKLC/U/0pCZU+D9?=
 =?us-ascii?Q?zdKpUnPP4vjmN1BPJJ4GnWBDIabR8WKhf7xIOzJuZsCVijmi3oDzVMlZNLWk?=
 =?us-ascii?Q?xsxHeUI4IHBshf+ACdNvvgD9Nbd5lywmLnp4jNgDExcdo3DQdSZnC5uFvxM5?=
 =?us-ascii?Q?6YITmdJgwkUy3wNjGYsE4TKcZcupvbRzsyv5I0mqUeLuW/hoVQy3L0LaCPzV?=
 =?us-ascii?Q?oY2GC9Po4eWQMvJG9s4LOZhLglymbZe4PdzDzZ0sGXeJPS0voxqqa1ipXTGF?=
 =?us-ascii?Q?ohKAQByhcLuoL0Ab5p1cD/1mBjuqpJvc3rQ/LAvWvwkm+t/KRJ1/gYKoXCjM?=
 =?us-ascii?Q?CAIgz4M84wN3OFno4F69sawwb5IAB/4YMxKF6cmImLUBYVVqAGPU8mp1vNIU?=
 =?us-ascii?Q?VOvloNoYv2JhYNGJDdSF8XIrag0WMBEr4Qeho1kc9Az32J+EQMx//F5D+Mkx?=
 =?us-ascii?Q?AogJB2HnEmzHhPTWLZOs8gzNdaE9JwfqSDz2i7Slal4WdR04gVoDTmOYuC/t?=
 =?us-ascii?Q?9XranNg6ZN8ThWsvQucMhvEK3rDwSxjNJTt0K1xVT2Ysnbdyk71VoKTjWkuC?=
 =?us-ascii?Q?abcFFIZhT64t7wJjB7gUA9gmXHaG5GmZIZN+AabepNLdQMNs1K4mgBzUF9pi?=
 =?us-ascii?Q?wX/1hO59nuRj55U7yHyKlCrKADVN1ECuUXNUsKksWWSuTgxsTawGaRHcZxMl?=
 =?us-ascii?Q?q+Vg7T/kkPNIdwVByOnipyM3EgBMBzlI8OiGAdBGjMybvB16IRNHM9bfBkHV?=
 =?us-ascii?Q?hDTL4EFX3lxt7tcWTB3q10N/lsDngybkhs/WkyFatJQJvwfEXOYPug5aNWej?=
 =?us-ascii?Q?5me8rGzdfskxgO/f6MVu2GWIo1ugMEhE4Xsojpq6b15AaViDcfPxoLFJWwFa?=
 =?us-ascii?Q?z2JktAFvEHBhDnYRb/u8v2oxSbaUhc9y6hKwGGoFLt04M2QBEYYOj0kwKrL3?=
 =?us-ascii?Q?8NfrjISErgz9mKcQ0lbnufg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3528e9ca-3900-458b-5e40-08d9d05264cd
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:50:55.0634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P0ohzd8yTci9hzeTiLg87OfA2X8ZTgNpZhNtpNlouRVferuHIhhRwVwXJNxycCB79aAxejBiJBIm6nJ5KgllWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2974
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050092
X-Proofpoint-GUID: CJBB9dRmlToMeseFW_rFt7F-DBpy03wm
X-Proofpoint-ORIG-GUID: CJBB9dRmlToMeseFW_rFt7F-DBpy03wm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Jan 2022 at 05:58, Darrick J. Wong wrote:
> On Tue, Dec 14, 2021 at 02:15:17PM +0530, Chandan Babu R wrote:
>> The following changes are made to enable userspace to obtain 64-bit extent
>> counters,
>> 1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
>>    xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
>> 2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
>>    it is capable of receiving 64-bit extent counters.
>> 
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_fs.h | 12 ++++++++----
>>  fs/xfs/xfs_ioctl.c     |  3 +++
>>  fs/xfs/xfs_itable.c    | 24 +++++++++++++++++++++++-
>>  fs/xfs/xfs_itable.h    |  2 ++
>>  fs/xfs/xfs_iwalk.h     |  7 +++++--
>>  5 files changed, 41 insertions(+), 7 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index 42bc39501d81..4e12530eb518 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -393,7 +393,7 @@ struct xfs_bulkstat {
>>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>>  
>>  	uint32_t	bs_nlink;	/* number of links		*/
>> -	uint32_t	bs_extents;	/* number of extents		*/
>> +	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
>>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>>  	uint16_t	bs_version;	/* structure version		*/
>>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
>> @@ -402,8 +402,9 @@ struct xfs_bulkstat {
>>  	uint16_t	bs_checked;	/* checked inode metadata	*/
>>  	uint16_t	bs_mode;	/* type and mode		*/
>>  	uint16_t	bs_pad2;	/* zeroed			*/
>> +	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
>>  
>> -	uint64_t	bs_pad[7];	/* zeroed			*/
>> +	uint64_t	bs_pad[6];	/* zeroed			*/
>>  };
>>  
>>  #define XFS_BULKSTAT_VERSION_V1	(1)
>> @@ -484,8 +485,11 @@ struct xfs_bulk_ireq {
>>   */
>>  #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
>>  
>> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
>> -				 XFS_BULK_IREQ_SPECIAL)
>> +#define XFS_BULK_IREQ_NREXT64	(1 << 2)
>> +
>> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
>> +				 XFS_BULK_IREQ_SPECIAL | \
>> +				 XFS_BULK_IREQ_NREXT64)
>>  
>>  /* Operate on the root directory inode. */
>>  #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 174cd8950cb6..d9e9a805b67b 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -893,6 +893,9 @@ xfs_bulk_ireq_setup(
>>  	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
>>  		return -ECANCELED;
>>  
>> +	if (hdr->flags & XFS_BULK_IREQ_NREXT64)
>> +		breq->flags |= XFS_IBULK_NREXT64;
>> +
>>  	return 0;
>>  }
>>  
>> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
>> index c08c79d9e311..53ec0afebdc9 100644
>> --- a/fs/xfs/xfs_itable.c
>> +++ b/fs/xfs/xfs_itable.c
>> @@ -20,6 +20,7 @@
>>  #include "xfs_icache.h"
>>  #include "xfs_health.h"
>>  #include "xfs_trans.h"
>> +#include "xfs_errortag.h"
>>  
>>  /*
>>   * Bulk Stat
>> @@ -64,6 +65,7 @@ xfs_bulkstat_one_int(
>>  	struct xfs_inode	*ip;		/* incore inode pointer */
>>  	struct inode		*inode;
>>  	struct xfs_bulkstat	*buf = bc->buf;
>> +	xfs_extnum_t		nextents;
>>  	int			error = -EINVAL;
>>  
>>  	if (xfs_internal_inum(mp, ino))
>> @@ -102,7 +104,27 @@ xfs_bulkstat_one_int(
>>  
>>  	buf->bs_xflags = xfs_ip2xflags(ip);
>>  	buf->bs_extsize_blks = ip->i_extsize;
>> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
>> +
>> +	nextents = xfs_ifork_nextents(&ip->i_df);
>> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
>> +		xfs_extnum_t max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
>> +
>> +		if (unlikely(XFS_TEST_ERROR(false, mp,
>> +				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
>> +			max_nextents = 10;
>> +
>> +		if (nextents > max_nextents) {
>> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
>> +			xfs_irele(ip);
>> +			error = -EOVERFLOW;
>> +			goto out;
>> +		}
>> +
>> +		buf->bs_extents = nextents;
>> +	} else {
>> +		buf->bs_extents64 = nextents;
>> +	}
>> +
>>  	xfs_bulkstat_health(ip, buf);
>>  	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
>>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
>> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
>> index 7078d10c9b12..a561acd95383 100644
>> --- a/fs/xfs/xfs_itable.h
>> +++ b/fs/xfs/xfs_itable.h
>> @@ -19,6 +19,8 @@ struct xfs_ibulk {
>>  /* Only iterate within the same AG as startino */
>>  #define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
>>  
>> +#define XFS_IBULK_NREXT64	(XFS_IWALK_NREXT64)
>> +
>>  /*
>>   * Advance the user buffer pointer by one record of the given size.  If the
>>   * buffer is now full, return the appropriate error code.
>> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
>> index 37a795f03267..11be9dbb45c7 100644
>> --- a/fs/xfs/xfs_iwalk.h
>> +++ b/fs/xfs/xfs_iwalk.h
>> @@ -26,9 +26,12 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
>>  		unsigned int inode_records, bool poll, void *data);
>>  
>>  /* Only iterate inodes within the same AG as @startino. */
>> -#define XFS_IWALK_SAME_AG	(0x1)
>> +#define XFS_IWALK_SAME_AG	(1 << 0)
>>  
>> -#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
>> +#define XFS_IWALK_NREXT64	(1 << 1)
>
> The ability of the caller to handle 64-bit extent counters is not
> relevant to the internal inode walking code, so I don't think this
> belongs in the iwalk flags namespace.
>
> IOWs, XFS_IBULK_NREXT64 should be defined like this:
>
> #define XFS_IBULK_NREXT64	(1U << 31)
>
> and xfs_bulkstat should be changed to translate only the relevant
> breq->flags into the appropriate IWALK bits.  Sorry for the code
> smell...

Ok. I will incorporate this review comment in the next revision of the
patchset..

>
> --D
>
>> +
>> +#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG |	\
>> +				 XFS_IWALK_NREXT64)
>>  
>>  /* Walk all inode btree records in the filesystem starting from @startino. */
>>  typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
>> -- 
>> 2.30.2
>> 


-- 
chandan
