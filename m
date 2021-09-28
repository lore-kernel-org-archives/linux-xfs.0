Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63740C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 10:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B61960FD7
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 10:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240075AbhI1KJu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Sep 2021 06:09:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29130 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240055AbhI1KJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Sep 2021 06:09:46 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S9ZVhK011477;
        Tue, 28 Sep 2021 10:08:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=L9VHMkt7kHeAsk26delUCYG/WdDHl+TCqpVMM90k2Hw=;
 b=yAf9P0EbMIzm6Bc21Fo7ymP4yxAv/FojffxTeJYJrPxa3aPC8WHnFIshFgA9FgM90Hzh
 8YUaBnAhUidofM7LHlEgQ0fs9PB8ntlDL/OJODIlsi4/LV5iVgdcT96zBTh0/MK5O3TV
 BFC4XAO5exH44Pds23+T+/z59HF1qDc9LlnK+sYtBSVefYNc6IhNzUK9MIpK5wLVLnFL
 VqSk9HLyzbU+EyVGba/X1dEbEcwcBRav02bcMTRMRF7QXlJC4lUkU9ieYsNPHjlgl6kf
 AKvBDkqYwsjrtu2wC90pYSxsNf17IYGIIG8O17bOCC7h+QAvPx/RER1lCLdO83Yx/CQC bQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbh6nnvr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 10:08:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18SA6MeK061425;
        Tue, 28 Sep 2021 10:08:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3020.oracle.com with ESMTP id 3badhsgnm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 10:08:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i28eQkqMQaTrgFiwUk5aRw+3TDyOvvEBr3IcmkrUv6Dv+enjze8E9e2bK7ZKibt2QfEmfaCdGiwteMstKCxmtEX6JOsCeB7FM7WOY3/QUA4dBOeuJdZw3o8on2s8f+3AYc2PHPhHWRbbvrKHf1VpWHMUkLDkzTSl97EKaBqv35REtnO6B/kvcsJ6+FgzB4d/i5cKYpmmxSfSJrNsFi/lfyWoPL2SDCCAGab4gF0M5q5/P0qeu+H/iz1sjGjJxmEU1pkf6P0LzllY0somZSH6FBiOHzvEkB9Wkqy4M2mue1ca1uctFyRVzJKieFR8MQXr694qw4wOACK723TovNsmhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=L9VHMkt7kHeAsk26delUCYG/WdDHl+TCqpVMM90k2Hw=;
 b=dZmIVJmFqtARHMamzRvTnsLSR6CMXciVtX6GcCqJpdK4uPryYt7EpUAFeelHteBdAqcISZckHFOb8bnu9SplmTDid9iyZK50MW9r/GfkGA9BpF9U+4mb2cmL1fa4bWevW7jxNcNmJVtpHIo4IYC4iKflIdcr2vm72S3asidTN9WYFNvPtvMhe+JL8hgJBELHPpPBocaiR+FN1KsrCtMXoszyKr79h0COFAlw76/sw25c57h/9ZQy2mwy6hDrjIVy5eK1+Fng7ryjLgxOHUMQpftTbV8Ak6nNBpwFrxhDwHl+Vnc/ilAcanEVMQZi3nJbjdeMFiv3bwP66TCvCLm0ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9VHMkt7kHeAsk26delUCYG/WdDHl+TCqpVMM90k2Hw=;
 b=ZlpO07uWaBot1NulLIx/gMF6NuHRJ72LZ5oJZjOM5f2AxCHMbxAH9BkBwAJatrbD3AuutLlBJgYTCEqC/LDPgfwwFOUNYMztyb3khmW2TsNXEEakZvbl+5lYZgUKyxkDqVuYJ5i1bTBFJhkM9Su3xpGSUElFaTuK3Ub4Awhzh+0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4473.namprd10.prod.outlook.com (2603:10b6:806:11f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 10:08:02 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 10:08:02 +0000
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-13-chandan.babu@oracle.com>
 <20210928003324.GN1756565@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 12/12] xfs: Define max extent length based on on-disk
 format definition
In-reply-to: <20210928003324.GN1756565@dread.disaster.area>
Message-ID: <87wnn1ypvw.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 28 Sep 2021 15:37:48 +0530
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0045.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::31) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (122.171.129.29) by MAXPR0101CA0045.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 10:08:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e37fe666-869d-4a78-8ac7-08d98267dafd
X-MS-TrafficTypeDiagnostic: SA2PR10MB4473:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4473FB854F1390B300D28597F6A89@SA2PR10MB4473.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEi+8KVH5hDMQzY4UasJu3e5/VyxLtQDVtk9E6dint/CX0ilV/86e2XbW0E5P++mDJSjVY6pbqLHj1A9vE3ux8daR2Dx97UPh0otCfWWmpWqZz436WrPAW3S1ktSgo2Qj6bOZJav+fx5IZwIJEu0DAbEt6k0VOuWVAOE/OH37V6WaSwE9FOGbj9LZpMdGdInmjp9sfljOkiCXV6DRtaVqST+EH3FpPGvKQtsHSodgvyci+hYLiBteG8xVXuBmxuc5H5o14syRLYx9lhxfBI5R9C6nH/SCV4LN+EFcoVOyTZ/2R7jhBCDTH79A1JHpq7bI41dRj6s8kv0F6PFFfre6rTq0jHR8qXLCRJGmLgqvT3oH6EOn7syXLrZWgSjhRTToILpLtn545Wbm6SYo3ogMdQc3iXr5vtOboUMsmsICAJuOgb/gZ0nv+iR6uFmDmgi+L8nDHPME8Mz58EXmCa/dwFdGqT3O9gQZFrA7duSa0MXHdP+C2INcLksghii37oN8JDwG+cFPcTLwqiXTExEX1RFMRkPCFnODtOGqpVG1s1LiaU6fFjmkprUIr2uzwKAMFOlbPtD9NKjoBb5gW8F28lSVu7uW93+GKhxqA6fwzfTNTJUbU7Qi0dsp02xaGG0Z05v0AfKSeBPM1xpCum6VC4lKPSaILJwPUUQ1Es2OT0UOT5gUQIByPVvmlxbc9qj0lacks3fg6L3Ax40YDkPQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(508600001)(8676002)(66946007)(33716001)(66556008)(956004)(86362001)(66476007)(53546011)(6916009)(9686003)(38100700002)(6496006)(316002)(2906002)(186003)(8936002)(6666004)(26005)(5660300002)(6486002)(52116002)(83380400001)(38350700002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jVrdH2Z6gS0MwpNgDagK1g4BJ/XoLpc3scb028ILFyMNrAW5NoOT60sSTBvd?=
 =?us-ascii?Q?va3dIsol/C3IFrUxjt12y2Q74R6xhkSr4YXT2fg2FHkjw0voLSNJ5N3E3p4/?=
 =?us-ascii?Q?ocPmTOO9yof/A4W3ritzpU2SA+LjykbiXhd0NNnRLMWl7KJOG2fW4i5G+rqi?=
 =?us-ascii?Q?NkJVaoHGRJ5Uiz5eRMeLkkUjRvt+6FldY9LZDd/YUx30WZakda/DbLDDaZxF?=
 =?us-ascii?Q?E9JqcUO9gEN1YlCFDN0/xzkB0CW3rnk5JsXhx1BT1fxaBaZjYLSwEkPbfL9K?=
 =?us-ascii?Q?eHsdSe55pYPDX6SNNqtfMwLX5LnMjRiS7jX/467/mKNG8h/+2btNizSC4GoF?=
 =?us-ascii?Q?HZ0bPV8n8zU+kHh8XKDRZlP555wJVKNjPOSP+xwrsqm2NXEz8MAYui6EBnbD?=
 =?us-ascii?Q?C6e1I13fe+juwb3VMfvrSA5sOb8znSoF7byeSfS6Dkq3Q85zwVvp6jGX1yF9?=
 =?us-ascii?Q?8L0js9oJOjCyOYeRwe9R7PPU8T9qWCPgckm85c1fc57mlRcM3TbHcz4fHWSI?=
 =?us-ascii?Q?qBrDNiY8tIprMeLa3VNmmgGwRgxsa9hMtJYr85JFLDKKatbpsQQbteggNDXT?=
 =?us-ascii?Q?li4jfdHOANf3wIA2e6FFnVZ/WSxnbSBZXRpTlfqu3/ya7ayuy1NNpdkNm/jR?=
 =?us-ascii?Q?XHsrTBmsaq3NhhpkcWP/AMgqmIuray9dfXkcBnK61h/Rp1ABFOyyTwwQmrCx?=
 =?us-ascii?Q?ebcZ6ZG9n3J9NzuFRfaVJSms4RU5wbIZeF+e/q3LxvOGgwdubBPFvdSf4C8Q?=
 =?us-ascii?Q?B+vA5KI85rVDPpLH8u4+yKhYLZzC5o+uubbiTWDscWmglCxKw432rkdjtLOU?=
 =?us-ascii?Q?DyCBHzRM2RQVQSFVzCmUFCx8abei3gq8rkLgKp5Of6aDtzepRl1CXJGHanV5?=
 =?us-ascii?Q?U+X7C1ANuv70a5ATOGqrmA2uyRrSPMoXb0r8YEVKHOX19d8A+J9JWzyatFuZ?=
 =?us-ascii?Q?KX1fpYsjwwK8Kx/Jn5IdhatXdWVMTCEXBu5dNpI3zqg15sUoH9R1nj6bk9U7?=
 =?us-ascii?Q?bozH84m4FF+wDcSH5BPI04CeNJNEjc9aQoIyYE0XQdynn2R4pq9QtZKcnl+P?=
 =?us-ascii?Q?bXSAhhGIVqrqcsSSz3Zqykcp5qM/nEnSeivhuGhd+IsFR8yAyJYyFqBc2zat?=
 =?us-ascii?Q?AB/iJLJ1kEmOOu7WZ4PajHKKFqcPnX5xR2DIKd0gcibPl3ydy0IMYm+EBVPl?=
 =?us-ascii?Q?H8QFqXEjJpHqPz1u3xQwuUgeKpQrtmRCiIecgj3hiYb6YhgK9frqy53jdFcQ?=
 =?us-ascii?Q?chbMlYrlQbuvKvAvlRGK1Pku/aXPOeF3/pywcVDXHQDjKj4tnHb0YfsPY8Ih?=
 =?us-ascii?Q?JMioHEi+qCd2FjUmJUYLWL1o?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e37fe666-869d-4a78-8ac7-08d98267dafd
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 10:08:02.0023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xzVOauYhcvj13VuX/Yn3lXm9Dke2qm4dIaSsM2exS9QY4lHgArx/iZWQzZygd0xTpHODVBHZ85iVrnrlOsFjcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4473
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280059
X-Proofpoint-ORIG-GUID: nReWdiHCDECQpF4EpGBlnP_EJ8PverXG
X-Proofpoint-GUID: nReWdiHCDECQpF4EpGBlnP_EJ8PverXG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Sep 2021 at 06:03, Dave Chinner wrote:
> On Thu, Sep 16, 2021 at 03:36:47PM +0530, Chandan Babu R wrote:
>> The maximum extent length depends on maximum block count that can be stored in
>> a BMBT record. Hence this commit defines MAXEXTLEN based on
>> BMBT_BLOCKCOUNT_BITLEN.
>> 
>> While at it, the commit also renames MAXEXTLEN to XFS_MAX_EXTLEN.
>
> hmmmm. So you reimplemented:
>
> #define BMBT_BLOCKCOUNT_MASK    ((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
>
> and defined it as XFS_MAX_EXTLEN?
>
> One of these two defines needs to go away. :)
>
> Also, this macro really defines the maximum extent length a BMBT
> record can hold, not the maximum XFS extent length supported. I
> think it should be  named XFS_BMBT_MAX_EXTLEN and also used to
> replace BMBT_BLOCKCOUNT_MASK.

Thanks for the suggestion. I will incorporate this before posting the next
version of the patchset.

>
> The counter example are free space btree records - they can hold
> extents lengths up to 2^31 blocks long:
>
> typedef struct xfs_alloc_rec {
>         __be32          ar_startblock;  /* starting block number */
>         __be32          ar_blockcount;  /* count of free blocks */
> } xfs_alloc_rec_t, xfs_alloc_key_t;
>
> So, yes, I think MAXEXTLEN needs cleaning up, but it needs some more
> work to make it explicit in what it refers to.
>
> Also:
>
>> -/*
>> - * Max values for extlen and disk inode's extent counters.
>> - */
>> -#define	MAXEXTLEN		((xfs_extlen_t)0x1fffff)	/* 21 bits */
>> -#define XFS_IFORK_EXTCNT_MAXU48	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
>> -#define XFS_IFORK_EXTCNT_MAXU32	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
>> -#define XFS_IFORK_EXTCNT_MAXS32 ((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
>> -#define XFS_IFORK_EXTCNT_MAXS16 ((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
>> -
>> -
>>  /*
>>   * Inode minimum and maximum sizes.
>>   */
>> @@ -1701,6 +1691,16 @@ typedef struct xfs_bmbt_rec {
>>  typedef uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
>>  typedef xfs_bmbt_rec_t xfs_bmdr_rec_t;
>>  
>> +/*
>> + * Max values for extlen and disk inode's extent counters.
>> + */
>> +#define XFS_MAX_EXTLEN		((xfs_extlen_t)(1 << BMBT_BLOCKCOUNT_BITLEN) - 1)
>> +#define XFS_IFORK_EXTCNT_MAXU48	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
>> +#define XFS_IFORK_EXTCNT_MAXU32	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
>> +#define XFS_IFORK_EXTCNT_MAXS32 ((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
>> +#define XFS_IFORK_EXTCNT_MAXS16 ((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
>
> At the end of the patch series, I still really don't like these
> names. Hungarian notation is ugly, and they don't tell me what type
> they apply to. Hence I don't know what limit is the correct one to
> apply to which fork and which format....
>
> These would be much better as
>
> #define XFS_MAX_EXTCNT_DATA_FORK	((1ULL < 48) - 1)
> #define XFS_MAX_EXTCNT_ATTR_FORK	((1ULL < 32) - 1)
>
> #define XFS_MAX_EXTCNT_DATA_FORK_OLD	((1ULL < 31) - 1)
> #define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((1ULL < 15) - 1)
>
> The name tells me what object/format they apply to, and the
> implementation tells me the exact size without needing a comment
> to make it readable. And it doesn't need casts that just add noise
> to the implementation...

I agree. I will include this change in the next version of the patchset.

-- 
chandan
