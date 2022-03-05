Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22E1C433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Mar 2022 12:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiCEMqn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 07:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiCEMqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Mar 2022 07:46:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B21E1CC7FD
        for <linux-xfs@vger.kernel.org>; Sat,  5 Mar 2022 04:45:53 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2259nFg9008819;
        Sat, 5 Mar 2022 12:45:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=2n0qGwlgLXmtiC2Xq8Uc7VJ3rkIPvdBhp1lg4EBu7QI=;
 b=MyJt5jH4L6kBTh3xI6zV0DKdULSwJFoc5Scq6uZnv1T0GkbT6bL8cTMK0UkU7CTHspYo
 TW1SvD0V4DXvKzgKGbMz3t4jPzU2Yy3M5CLHlzIxX7zXrkjLDF3JqWPtria6dA7kElHI
 QXlQ3CYJt5B3kNzkyyhOkDzMgjQ3SjtFNG06W0QEqsi4Uyk4FH/AaXP9+5LdEYWYcPBv
 7o7MWrC4kQ3b7dC0RbrmBzWaqBZZ+XNS3qxUCQw9/xuJrcBB3vK/J6IM2nNNNkoO92DG
 iUZ/3rqSwecUME7B4WJD8VfZeKavqM7ZAnFiMTPyIzwAm88H9aT6h+0ZNjPS+3qwL3Om yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0grnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:45:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 225Cb0BM113063;
        Sat, 5 Mar 2022 12:45:48 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by aserp3020.oracle.com with ESMTP id 3ekynyqxbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:45:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3nBtwxzSZ0HOTRqG6dOeWWml/5XEanvaDhVDvEldL4e2KK/F8cQ1hk5PwsxxSAIdJmhqUmrudZbkMohsx1z3EqaAmJeUYPPlnAxjdpUkwKGeD7NPxp5ejvCCvvzhgxivuIbFhtghIFBdl0JA+7Q9EUOBiQcgisp3OY6JVlACwEqmWemOB6SHpcg2gi5m3bxxSXLOz+8lPU3JdBYwRpUvzxow25DejZNt9r2UNk+0/BYDzHMmqnVuSln7uX6sQ8zLX2jrg2D2OpF6D4041IjQcKaFmiBwNOWDXzX4XutH7OodXZ+36XywHkCVq4uJZTlsRm+tTFJDd/Axxg+aggVxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2n0qGwlgLXmtiC2Xq8Uc7VJ3rkIPvdBhp1lg4EBu7QI=;
 b=k4nG2lLZSKOyV8DTvJ8Hx6/6Z1QJByeyr7D8QUxC3TWUYhkEaMGI0gbKcORM53l13WgqdCA/faEaPnKSr0GcDENhWRkpiXT/vy/gbHLofatDvqGVN0BzJVKBdn684ktjWbsezudmLbhsBDhLPw5b6H4oj3Ru98FtuRR9IfAN+RjBBuXe213YhChczfcJXq9D90OJS60lzCjthLGqY6aK+xVAbLI8NCkcULeWU8aqisVg/ezNGMhkOy2jenDvNVgulD5eoZiXS44KvOHDRFpTr6aXNUbMY0KcTq9D9E2djCanNjVOl4lI+covWutsr/V6J2rwIgDIlaTtiE5SfUNURA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2n0qGwlgLXmtiC2Xq8Uc7VJ3rkIPvdBhp1lg4EBu7QI=;
 b=P+T8TVqpVm7Pl5SDgN9X6bDdZ/h9Mlyk67aDqpNh/1VvfjtFQXA2LQAF1hZup7wQkSBxLgL1G1PYPIR6/NRQ+bjKMVTbqRfVTj8a7szkyH66+ubmUL5IsMLqDQscrt7a6F6Uki+RKUnJsyy0nO3EuioEgUlAwHFDhe/HUP/ML1E=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2821.namprd10.prod.outlook.com (2603:10b6:a03:85::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sat, 5 Mar
 2022 12:45:46 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%7]) with mapi id 15.20.5038.019; Sat, 5 Mar 2022
 12:45:46 +0000
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-16-chandan.babu@oracle.com>
 <20220304080932.GK59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 15/17] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
In-reply-to: <20220304080932.GK59715@dread.disaster.area>
Message-ID: <87fsnwlg9a.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Sat, 05 Mar 2022 18:15:37 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR04CA0020.apcprd04.prod.outlook.com
 (2603:1096:404:15::32) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fb9139c-9799-4d1a-2a92-08d9fea61165
X-MS-TrafficTypeDiagnostic: BYAPR10MB2821:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB28212D3BD38658D85CA00688F6069@BYAPR10MB2821.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rQS4J00akcCN95Z2CKcRXTIp07toNBvNlDR0HJx+cLm+UeARm9J3GWl131HFWtrwVlPKHWqJhTLFimp70jqsb/ROuPA/kVHz126P1wgf5Cuj6ZoSEdd87MOmHnjE5SWRadPrv7xv6rXPA/Mf4o42mRN8mDHrHCNJ1XcrhnU/vBzjrvehAh4K18/opX0N7UOK9IWHEhHkNZ+tMRi/KKZgGl0ZYa4uqfXTQex13hDduePMAkSJDsG22lypMBr7ISqU6Pe/4YHlgxzM1l/GaZ5zNS0AmZjrNpeHbqwms1RQm8jaGZka0Ni3SL6bxqpKma30xvQtCY4lpAsQ8U0qxeBDqoZQgkQ7hxG6mlUmAQX/33ec7fXi/ei00c8q0EF1mRnYEjQMKHvscfIQyppLcx3EYC17XZa+8zlB2SHk7jRODvop/jblcn0J+0eviNalHgOs4c8enutx6/2kF3hVQpynSKsq4OwUunPYXdC0XLApzSBD21Nl63dpTCpjb0B/u1XJq/RlO/A0R6tYCPnKbf2M27U1fqJVJv2WvlANlDflWEcqo11PSL5ktixF2xGOwmH+86b9q28lXh03FHjmtChJafN7sEybAzOlfdLxPB/rejWbfR5gsCl/8M0Q45cpGx5VBKyWyVxD/aiF98E0XZBkHMvdTOPf1lEPs21GlKCRWVRzYRiSwja4Eg49EwUsRVQCk15j+5cAQYR5K4RC+qKwZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(83380400001)(26005)(2906002)(66556008)(86362001)(6486002)(186003)(316002)(66946007)(6916009)(33716001)(53546011)(5660300002)(6512007)(6506007)(52116002)(8676002)(66476007)(4326008)(38100700002)(38350700002)(6666004)(9686003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?++2YlOrOenROQKOSbRgXZjA8m59oTpFWc7WFBZbH31AVata/yb08TAKcfUvC?=
 =?us-ascii?Q?tB8Y8hEKZWiprkzbRmDgPpDp8Vpk6DSF+3spWtAWk69DqqNKmSFTeSq7s076?=
 =?us-ascii?Q?8l2DGfELiaOBlpXYbPIUWgtvNYz/1/FvP5Mel+eqN1zbY5OVdQPuAdHfF8cM?=
 =?us-ascii?Q?O8X9Nbzm0BG3J6Y7dI0abY9LoIWrGnsrNaSJQpbAe9t+jGZmclQRsVlm/3PN?=
 =?us-ascii?Q?E4rQHycsegiC2zArGqVzWcnDCxUMHJm5WvMl9ixe+k6rdzZkeQXrdR3J2ArY?=
 =?us-ascii?Q?rMSN6iEaDhjdJB1oz/8StrhPWhqND/uVaUoP6fyhqrCPC34dl6ZKT3FqqS5u?=
 =?us-ascii?Q?TJlRP4GBWzsIBNEk7gPXJ+WKrI00tBFWw0m9KJ46D/7HG430R6n32PioG/9V?=
 =?us-ascii?Q?14uGUPl+Q8/4wld/A47dMphRAriUxwsx/WyNoSP8hLneiQKPzdBepnUiJsoU?=
 =?us-ascii?Q?y1GUKp7LIoAtmH2xIW4npNuVPHD1bykPvXt7vQwoM2ylv6eO0sc51m5wtwxn?=
 =?us-ascii?Q?nBKbFA9qMNRe9qCYcwhd7T3DKd+Z/JQB6TpDJa6QuykF6RW7eWku8aL6A58B?=
 =?us-ascii?Q?m+t0a0YTZvqe/uzlA91336dytGanvdLiQMEsT0cQ+ZTFAtFCP5HjkuFRaF0z?=
 =?us-ascii?Q?2ENd2lVak39XF28llgI9GrFn47ydXkrxM0IoizrL1C04ZTkX72YwVjIIgrSY?=
 =?us-ascii?Q?xUCsS7uewqmdqj5wl44nGfFt6iyYNMZocNX4UGw8OvLioGmWy+yA2kf5pLYe?=
 =?us-ascii?Q?xDkR8olrgIWUi1yCcItJOewx/jF6OUYObaCweVmIiXSRqntUoihwQDbnYPQr?=
 =?us-ascii?Q?hqyar68iWo/0jjSF2RBBG4/yjbVi/4KWMMZjygY0KT6+I9j+NQj/kH8hHCfm?=
 =?us-ascii?Q?oPXYpFrs4qPwXeYF7dGCWx79MW2MusgC+YzNEYSsDwQ4EnEaHi0Ec9yjQRPb?=
 =?us-ascii?Q?osZPQuoEGY79+zpwOPRUALXdxhRpmgc3YsMkG0bdrlktf43ls+ifqegFeKSu?=
 =?us-ascii?Q?X+zeyyXPTj92kZyAw8w8xnWbVR28OPBn/mdCKTBERxt0SJFNXFppRDtVIzeq?=
 =?us-ascii?Q?9gEC8GSOotQfZXQmFOmkMbeQ/EWjT2fVyQ1l47eKaLeuqhZlAaRyBdGvR673?=
 =?us-ascii?Q?pJnx2rQb8rmVHNvCOqc/Ra+/3O0Cz/qwX9PyzoHhF9MnjCjdlls3V7ptUE+O?=
 =?us-ascii?Q?Y37ruXqNtdXGWn6T3tp27pWX/VEUgAeXzB1y7SQuCrUlEjgdDn4Uedf2sEU0?=
 =?us-ascii?Q?G2ytLchyMgY5HE6QGUfcK72AyLyRQy638aPoiFKgEGeMFfi1XQxCBjLgLpp1?=
 =?us-ascii?Q?MZz1jXbXteWT1znX/yMKyzplOHs33qbqEX2Af1Rv7ZydHjlIozg/NC9iS/nM?=
 =?us-ascii?Q?QmONCupccrQSnPChCehZpJug/6QVq2/QiBbrd05RGG45phrkpzhQLj0UQN8C?=
 =?us-ascii?Q?/WUSw9xoSfWR2sRBTzwh0i91aQZlucixlh3uwKirgJpStyciUnstDX7bNdhZ?=
 =?us-ascii?Q?a4XMkGpjDborEP9Z6gMwRRfmZKjfMMghQ62UN9tU7Tx7fYFAGDnYQQ1H83Y3?=
 =?us-ascii?Q?5KgXar9Arxo6nLejCHqI0EFcHsAIGS4UXnog0rmkLtvWVu7Iaao6NgKo9dYK?=
 =?us-ascii?Q?rVFCkFktLBBWWeCFiam/Jd4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb9139c-9799-4d1a-2a92-08d9fea61165
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 12:45:46.2316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: thm+bshLl/py4U03Nmo1XC4G3nlwfi74Q9H3+Byd46o+HFo5ngmcZOp8sJ6g2WmuxSPTJ4ZTFtTmGRKYmirCqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203050070
X-Proofpoint-ORIG-GUID: b4G8yEtfiSXJrlCUo0f4Jgbwl13gfVNp
X-Proofpoint-GUID: b4G8yEtfiSXJrlCUo0f4Jgbwl13gfVNp
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04 Mar 2022 at 13:39, Dave Chinner wrote:
> On Tue, Mar 01, 2022 at 04:09:36PM +0530, Chandan Babu R wrote:
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
>>  fs/xfs/libxfs/xfs_fs.h | 20 ++++++++++++++++----
>>  fs/xfs/xfs_ioctl.c     |  3 +++
>>  fs/xfs/xfs_itable.c    | 30 ++++++++++++++++++++++++++++--
>>  fs/xfs/xfs_itable.h    |  4 +++-
>>  fs/xfs/xfs_iwalk.h     |  2 +-
>>  5 files changed, 51 insertions(+), 8 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index 2204d49d0c3a..31ccbff2f16c 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -378,7 +378,7 @@ struct xfs_bulkstat {
>>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>>  
>>  	uint32_t	bs_nlink;	/* number of links		*/
>> -	uint32_t	bs_extents;	/* number of extents		*/
>> +	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
>>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>>  	uint16_t	bs_version;	/* structure version		*/
>>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
>> @@ -387,8 +387,9 @@ struct xfs_bulkstat {
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
>> @@ -469,8 +470,19 @@ struct xfs_bulk_ireq {
>>   */
>>  #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
>>  
>> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
>> -				 XFS_BULK_IREQ_SPECIAL)
>> +/*
>> + * Return data fork extent count via xfs_bulkstat->bs_extents64 field and assign
>> + * 0 to xfs_bulkstat->bs_extents when the flag is set.  Otherwise, use
>> + * xfs_bulkstat->bs_extents for returning data fork extent count and set
>> + * xfs_bulkstat->bs_extents64 to 0. In the second case, return -EOVERFLOW and
>> + * assign 0 to xfs_bulkstat->bs_extents if data fork extent count is larger than
>> + * XFS_MAX_EXTCNT_DATA_FORK_OLD.
>> + */
>> +#define XFS_BULK_IREQ_NREXT64	(1 << 2)
>> +
>> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
>> +				 XFS_BULK_IREQ_SPECIAL | \
>> +				 XFS_BULK_IREQ_NREXT64)
>>  
>>  /* Operate on the root directory inode. */
>>  #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 2515fe8299e1..22947c5ffd34 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -813,6 +813,9 @@ xfs_bulk_ireq_setup(
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
>> index c08c79d9e311..0272a3c9d8b1 100644
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
>> +		xfs_extnum_t	max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
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
>
> This just seems wrong. This will cause a total abort of the bulkstat
> pass which will just be completely unexpected by any application
> taht does not know about 64 bit extent counts. Most of them likely
> don't even care about the extent count in the data being returned.
>
> Really, I think this should just set the extent count to the MAX
> number and just continue onwards, otherwise existing application
> will not be able to bulkstat a filesystem with large extents counts
> in it at all.
>

Actually, I don't know much about how applications use bulkstat. I am
dependent on guidance from other developers who are well versed on this
topic. I will change the code to return maximum extent count if the value
overflows older extent count limits.

>> @@ -256,6 +278,7 @@ xfs_bulkstat(
>>  		.breq		= breq,
>>  	};
>>  	struct xfs_trans	*tp;
>> +	unsigned int		iwalk_flags = 0;
>>  	int			error;
>>  
>>  	if (breq->mnt_userns != &init_user_ns) {
>> @@ -279,7 +302,10 @@ xfs_bulkstat(
>>  	if (error)
>>  		goto out;
>>  
>> -	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
>> +	if (breq->flags & XFS_IBULK_SAME_AG)
>> +		iwalk_flags |= XFS_IWALK_SAME_AG;
>> +
>> +	error = xfs_iwalk(breq->mp, tp, breq->startino, iwalk_flags,
>>  			xfs_bulkstat_iwalk, breq->icount, &bc);
>>  	xfs_trans_cancel(tp);
>>  out:
>
> This looks like an unrelated bug fix and doesn't make any sense in
> the context of the change being made in this patch.
>

You are right. This is about removing dependency of XFS_IBULK_* flags from
XFS_IWALK_* flags. I will include this change in a separate patch.

>> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
>> index 7078d10c9b12..9223529cd7bd 100644
>> --- a/fs/xfs/xfs_itable.h
>> +++ b/fs/xfs/xfs_itable.h
>> @@ -17,7 +17,9 @@ struct xfs_ibulk {
>>  };
>>  
>>  /* Only iterate within the same AG as startino */
>> -#define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
>> +#define XFS_IBULK_SAME_AG	(1ULL << 0)
>> +
>> +#define XFS_IBULK_NREXT64	(1ULL << 1)
>
> Why are these defined as ULL? AFAICT they are only ever stored in an
> unsigned int.
>

In one of the older versions of the patchset, I had extended xfs_ibulk->flags
to an "unsigned long long" field. These changes are remnants from the older
version. I will remove ULL suffix.

>>  
>>  /*
>>   * Advance the user buffer pointer by one record of the given size.  If the
>> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
>> index 37a795f03267..3a68766fd909 100644
>> --- a/fs/xfs/xfs_iwalk.h
>> +++ b/fs/xfs/xfs_iwalk.h
>> @@ -26,7 +26,7 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
>>  		unsigned int inode_records, bool poll, void *data);
>>  
>>  /* Only iterate inodes within the same AG as @startino. */
>> -#define XFS_IWALK_SAME_AG	(0x1)
>> +#define XFS_IWALK_SAME_AG	(1 << 0)
>
> This also seems unrelated. If these flags need changing, can you
> pull it out into a separate patch explaining the what and why it
> needs changing because I'm getting lost in the 3-layer-deep (or is
> it 4?) iwalk/ibulk/ibulkreq flag munging that is all intertwined in
> this patch....
>

Sorry about that. As I had mentioned earlier, this is about removing
dependency of XFS_IBULK_* flags from XFS_IWALK_* flags. I will include this
change in a separate patch.

-- 
chandan
