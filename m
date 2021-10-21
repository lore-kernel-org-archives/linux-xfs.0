Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0203CC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 10:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF39160F6E
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 10:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhJUK3z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Oct 2021 06:29:55 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59982 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230311AbhJUK3z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Oct 2021 06:29:55 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L8uUnd030527;
        Thu, 21 Oct 2021 10:27:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qr7Mq0ux4qqrSNaXoouQDffxqcMpiGFtl5EjO+iKmX4=;
 b=eu/P/GaxhwRHyVEOI2i4w+8FoObiaJb5yPZk2xOIP7p9IPwxB2QNhf3zJFlIaRFerv2Z
 4ZSHlpLC88FPP1f6HJoahBVxpfmTMMfBw9TWMBa3UByLSYkltZv2wyGvNz9zmZJfWlHJ
 QTvw29cMOITNSMX6bkeidiHzlJidDg/Fevwixp5GxwYZoHo4r+RchxaDQCHIqZ8WWVBc
 Ha6EezhvlQ2gUhbyvlqh1ki/AIIrhHf0FGt/fsLeTDXBqyJUp8Ox1MOSTp6qWo3P8eUR
 CSNM6fZtTpslPbikOEHksL/weMFlB722+gl4uHPOUs6OQEAGnqdf8TJ3zNMXZsAiLuRD 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm3y98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 10:27:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LAGtmr034971;
        Thu, 21 Oct 2021 10:27:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by aserp3030.oracle.com with ESMTP id 3bqmshwewn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 10:27:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=io0wHqNuTKuRLhHw2UyiDQCy25/aZhHgvq3KIOoGX+AMOPZLnuSjX9H8ZHRJr3XltOzlHtp1UFzTF+Des032A+os5roVA78Jl5xRrazPhCnyJJfP3opmHFCMo4kUJFPMxSn32vHDVPydsuX8B/5xtoc1LA5MqzgwaknigwDvW10TyEakAChjXtzu9CajNs9fowd2H1JFXA1CPCTOOBo+DO3xsRJ2D2r4gryw3iUafMS68ncEQclJte/IzYEnaRvcEIPb4qe5dyCfMkLgR9HA8Rg/L1OUdUMh0QBc4HmmMr+C0auRsNKK0iQLehj2ijyrM3g1S+frKw8MCScX+kSTvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qr7Mq0ux4qqrSNaXoouQDffxqcMpiGFtl5EjO+iKmX4=;
 b=f5C09vitFpNch7mcmpRf8B2JTn4tVzRCK7V2zG7qxQkk5UoGYEQD7v/QIs31RfB9AkotlD/xBZlKB9yfXT6xjMSW9LqvL5kaWE2xFgmZwr7gYV5Q8A/fC7CCBisdqnzC6lJ14ikSpIHBhzlEWi5wiu+hmigTnjrcm6J3mKXiT8ngyckBRB0u5lwkT9eFI4Z04UrfS2e5B6ioITbQcPlkYs1Z+/e7hCIhPV/YRVZsLguyC+p1kWqgpee90DW7/O+RicHe0B7huw+FJ0LZqNDLmb2ja+f9wOMXc+mDLVUSFpRfxOgGNwmXoeJkJpgPyuwsT2WSn3PlyHZxm0wwNNyX0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qr7Mq0ux4qqrSNaXoouQDffxqcMpiGFtl5EjO+iKmX4=;
 b=SUDxBnm0rvu8szIDh9+8Es5E71jtm6XiPAh3SaHUVlsxubEjF8JbH+eVJ08aSwfeAvKxIaOrlYhviCol2M6MR9YMUVWlnB8qfqVeqaEcqNcYjGx/rTT80+bE4ZBD2s/ldyP/S1WEHJhss341akr0Mm4nls178puikzu9BRs3nos=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BYAPR10MB2805.namprd10.prod.outlook.com (2603:10b6:a03:8b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Thu, 21 Oct
 2021 10:27:34 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::c50a:e8fe:496f:8481]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::c50a:e8fe:496f:8481%8]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 10:27:34 +0000
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-8-chandan.babu@oracle.com>
 <20210927234637.GM1756565@dread.disaster.area>
 <20210928040431.GP1756565@dread.disaster.area>
 <87czors49w.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930004015.GM2361455@dread.disaster.area>
 <20210930043117.GO2361455@dread.disaster.area>
 <87zgrubjwn.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930225523.GA54211@dread.disaster.area>
 <87pmshrtsm.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20211010214907.GK54211@dread.disaster.area>
 <874k9nwt6i.fsf@debian-BULLSEYE-live-builder-AMD64>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 07/12] xfs: Rename inode's extent counter fields
 based on their width
In-reply-to: <874k9nwt6i.fsf@debian-BULLSEYE-live-builder-AMD64>
Message-ID: <87tuhavfjs.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 21 Oct 2021 15:57:19 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:3:17::19) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
Received: from nandi (138.3.205.1) by SG2PR02CA0007.apcprd02.prod.outlook.com (2603:1096:3:17::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Thu, 21 Oct 2021 10:27:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16c77c82-f7c9-40f7-4119-08d9947d6506
X-MS-TrafficTypeDiagnostic: BYAPR10MB2805:
X-Microsoft-Antispam-PRVS: <BYAPR10MB280598D6070548FD7C73760DF6BF9@BYAPR10MB2805.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jX/QVmm1AAX4cSEp1daqFUVGOxmxcB/J1idtJgKNsPrZfLV64jfz4YKvYSwDBUPD8sevWh8Hsx97BNZ5ViW7G/3XAOZ+janP5/h/UNu7N7iKUpAtM18RD8Rp/q0Vjg8CQ4iU/nza32l8VwNb6Gsli6zdQil0BD+zlsCZ19rLJAJ7ZFEt+moymI61lSosJgKfKehL+1dXwfl7f0R5xb0CDsP8EKsY41jmkCgwTibkAT997vqwsbN+V3XfxHaqNR+ll1tdzp8CK6Hv6CudrDphRtB9LOipanpqI5sG1yBzcqmbf3lsvM3yexzb6j7eWe9ygOufJzs2TOlmZpOiCwoGde/CQuYZEpKzqgc3YJOiZGr6ZWR/5KF/Df2AsKP9nRyMlbboWLc1nSSNWCX8jm2JYpSvh27v6ekEdmu/CNpphUrmC3nPllkFjVGL8DKgBSFrdn+KoOUeGqC194Yf0WBftaLphmWdL4wJUdT/RvicW5ZiKbodhZwQjMr/YhWNV+k2BuMQiU2kfKT5PYB3voRsKJJPbWQVcDQSCuIn7hqjv7fVtCy9WY+ccd431aedWL9ofXE51ezLUFlXVLte7ckE47wHlhh80hudaDBh8/1KEsMEbYjLaYCwSzmXWOrkWNt7bDISwnwpHgn9DRooj9oAz27YiKTDdGibwtKWPPTp/wL94ViZpx2D9uguWmJTrqLaxCZV8rUpQalpIoQVmepYGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(6666004)(6916009)(8676002)(52116002)(4326008)(86362001)(38100700002)(2906002)(66476007)(5660300002)(33716001)(66946007)(38350700002)(6496006)(9686003)(186003)(66556008)(26005)(508600001)(8936002)(6486002)(83380400001)(53546011)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nz8TjcWhSh8v9Clih9oHpM3bG8aptuAop+Wh15DS8Sg/VwernMbL8qwJg35A?=
 =?us-ascii?Q?TVu8cNCMxm7Jm4J2bpmjkF0iznxwpmi9iJ6VEKU0YDpVtteAx5lzOoHSRELs?=
 =?us-ascii?Q?w+JnylubiPiJ/ajrgcGirqnxppWVp4f0C3heESthl3/KikGHgYrBj5NckT5K?=
 =?us-ascii?Q?BG6t149pCzSnKKXKDzmSnqeIySU/wP+8XwRtUolgt56OIrw793+JQDkSgZ8P?=
 =?us-ascii?Q?naNWq0jp6YWT9NY2gWfImBFYXV7HbI2AALuPYNlEPJPg3YO3wEr2izhuyfBP?=
 =?us-ascii?Q?fafn36avakWhZLCYDZH8ZLkikQSOMm/FdfiMRrXpTaeghTJrynezwDA/dO16?=
 =?us-ascii?Q?g5CTCG4AhWxSI0qUeXoKAqWkeYS7uGwtVpu3zi5nW6jURI8SPCfP+L8hTF2R?=
 =?us-ascii?Q?zO58f6W4Eeu9w35UAOhEp3hWGBe+1RdUoGUpUvu2a2WUwnUv6f+4K7MHnDjN?=
 =?us-ascii?Q?10V3SsI9hnvWrAbKGOu2EMFM0CUoVHwiY/mMgEKheR2VbibZEMsjw6Rk35eL?=
 =?us-ascii?Q?2nX2iAbLT5WH+gA8m6TxAiZA6vzbNFJ6EhOPKlartwjHilcJUazUpjviulUi?=
 =?us-ascii?Q?uVqNQTob5Uwj6rH9WfrSewyEoQwQ/zwLaYejuEVsxTLDMpb7KLaf590uaZpI?=
 =?us-ascii?Q?DyTx3JZk37YUAUNALFv6ds6Mji1XlhvA0n34SIo/DoM3KfCH4Ku/W+QiuCxF?=
 =?us-ascii?Q?tc3mKker+bvCWKCxwztEyD8FFIeVkZPLUfydZwEOp9IB2mfPuwJmiPxEu2f4?=
 =?us-ascii?Q?793Xbh//2+Wx9ZLYI00Fa+AzBFgDKm3R0P41uWvSUzd314RPH2X3peyIovgN?=
 =?us-ascii?Q?zbN7E93sIXSKHGPcA4cQ9wq4c/9ws4Z90PFyGtCet1kM1OZfN2JG7Skykgw2?=
 =?us-ascii?Q?vGyUbseiWUyDlil/7NVyjivUdg569jXoQ2SYiev1s5X3nd0hICoY/u7XLPIT?=
 =?us-ascii?Q?LGVJnlnPFnidMGM/EWILBeGKxK/oHlEbyE9A/kRK5DjgBMcBhhhJHxC+3JHp?=
 =?us-ascii?Q?+lYDXOkJzPx8Z1Txd64oj23ZYGJe85jmZ33hEaf5kMNiPxtZwvAirtWZa/Oo?=
 =?us-ascii?Q?2hVSKsgHWJ1e1VXZQaX2WdFE1NMgs0Tijsv9CjcAVhoy58iaRsSrz+l8oeqS?=
 =?us-ascii?Q?3xn0eSOyynoqnyw571FFwL3FXAqb8PiWOZ9RnkLvlyUN+Zj0dETSQ6H2HLsx?=
 =?us-ascii?Q?HGkPy6WMMhqKFZHP+EaTjPewEKlV7qXKTsgFE270onX/+pFxo5r2Rp4TyjcR?=
 =?us-ascii?Q?Bn2m5lTevzxMxO27K+ktVWr74OQ5hiSrjsFMrNBHA+4doSQJpEm1C/P3d+pU?=
 =?us-ascii?Q?4146dys4cmAxNxEWJ01+B9u1cTD0R5MvvrvxjCuABOKvCPFoolK8et9B541X?=
 =?us-ascii?Q?y0hSeJJ12ViTb1Pyq34imTLLwHUUG8dL5Kvrl9NtvAmVtZGME6kErOXXjAe2?=
 =?us-ascii?Q?f50IK2kypIo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16c77c82-f7c9-40f7-4119-08d9947d6506
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 10:27:33.9852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: chandan.babu@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2805
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210053
X-Proofpoint-GUID: ElznCe023hPZgSqmWxtzseQUNhqFlYWA
X-Proofpoint-ORIG-GUID: ElznCe023hPZgSqmWxtzseQUNhqFlYWA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 13 Oct 2021 at 20:14, Chandan Babu R wrote:
> On 11 Oct 2021 at 03:19, Dave Chinner wrote:
>> On Thu, Oct 07, 2021 at 04:22:25PM +0530, Chandan Babu R wrote:
>>> On 01 Oct 2021 at 04:25, Dave Chinner wrote:
>>> > On Thu, Sep 30, 2021 at 01:00:00PM +0530, Chandan Babu R wrote:
>>> >> On 30 Sep 2021 at 10:01, Dave Chinner wrote:
>>> >> > On Thu, Sep 30, 2021 at 10:40:15AM +1000, Dave Chinner wrote:
>>> >> >
>>> >> 
[...]
>>> >> > FWIW, I also think doing something like this would help make the
>>> >> > code be easier to read and confirm that it is obviously correct when
>>> >> > reading it:
>>> >> >
>>> >> > 	__be32          di_gid;         /* owner's group id */
>>> >> > 	__be32          di_nlink;       /* number of links to file */
>>> >> > 	__be16          di_projid_lo;   /* lower part of owner's project id */
>>> >> > 	__be16          di_projid_hi;   /* higher part owner's project id */
>>> >> > 	union {
>>> >> > 		__be64	di_big_dextcnt;	/* NREXT64 data extents */
>>> >> > 		__u8	di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
>>> >> > 		struct {
>>> >> > 			__u8	di_v2_pad[6];	/* V2 inode zeroed space */
>>> >> > 			__be16	di_flushiter;	/* V2 inode incremented on flush */
>>> >> > 		};
>>> >> > 	};
>>> >> > 	xfs_timestamp_t di_atime;       /* time last accessed */
>>> >> > 	xfs_timestamp_t di_mtime;       /* time last modified */
>>> >> > 	xfs_timestamp_t di_ctime;       /* time created/inode modified */
>>> >> > 	__be64          di_size;        /* number of bytes in file */
>>> >> > 	__be64          di_nblocks;     /* # of direct & btree blocks used */
>>> >> > 	__be32          di_extsize;     /* basic/minimum extent size for file */
>>> >> > 	union {
>>> >> > 		struct {
>>> >> > 			__be32	di_big_aextcnt; /* NREXT64 attr extents */
>>> >> > 			__be16	di_nrext64_pad;	/* NREXT64 unused, zero */
>>> >> > 		};
>>> >> > 		struct {
>>> >> > 			__be32	di_nextents;    /* !NREXT64 data extents */
>>> >> > 			__be16	di_anextents;   /* !NREXT64 attr extents */
>>> >> > 		}
>>> >> > 	}
>>> 
>>> The two structures above result in padding and hence result in a hole being
>>> introduced. The entire union above can be replaced with the following,
>>> 
>>>         union {
>>>                 __be32  di_big_aextcnt; /* NREXT64 attr extents */
>>>                 __be32  di_nextents;    /* !NREXT64 data extents */
>>>         };
>>>         union {
>>>                 __be16  di_nrext64_pad; /* NREXT64 unused, zero */
>>>                 __be16  di_anextents;   /* !NREXT64 attr extents */
>>>         };
>>
>> I don't think this makes sense. This groups by field rather than
>> by feature layout. It doesn't make it clear at all that these
>> varaibles both change definition at the same time - they are either
>> {di_nexts, di_anexts} pair or a {di_big_aexts, pad} pair. That's the
>> whole point of using anonymous structs here - it defines and
>> documents the relationship between the layouts when certain features
>> are set rather than relying on people to parse the comments
>> correctly to determine the relationship....
>
> Ok. I will need to check if there are alternative ways of arranging the fields
> to accomplish the goal stated above. I will think about this and get back as
> soon as possible.

The padding that results from the following structure layout,

typedef struct xfs_dinode {
        __be16          di_magic;       /* inode magic # = XFS_DINODE_MAGIC */
        __be16          di_mode;        /* mode and type of file */
        __u8            di_version;     /* inode version */
        __u8            di_format;      /* format of di_c data */
        __be16          di_onlink;      /* old number of links to file */
        __be32          di_uid;         /* owner's user id */
        __be32          di_gid;         /* owner's group id */
        __be32          di_nlink;       /* number of links to file */
        __be16          di_projid_lo;   /* lower part of owner's project id */
        __be16          di_projid_hi;   /* higher part owner's project id */
        __u8            di_pad[6];      /* unused, zeroed space */
        __be16          di_flushiter;   /* incremented on flush */
        xfs_timestamp_t di_atime;       /* time last accessed */
        xfs_timestamp_t di_mtime;       /* time last modified */
        xfs_timestamp_t di_ctime;       /* time created/inode modified */
        __be64          di_size;        /* number of bytes in file */
        __be64          di_nblocks;     /* # of direct & btree blocks used */
        __be32          di_extsize;     /* basic/minimum extent size for file */
        union {
                struct {
                        __be32  di_big_aextcnt; /* NREXT64 attr extents */
                        __be16  di_nrext64_pad; /* NREXT64 unused, zero */
                };
                struct {
                        __be32  di_nextents;    /* !NREXT64 data extents */
                        __be16  di_anextents;   /* !NREXT64 attr extents */
                };
        };
        __u8            di_forkoff;     /* attr fork offs, <<3 for 64b align */
        __s8            di_aformat;     /* format of attr fork's data */

... can be solved by packing the two structures contained within the union i.e.

        union {
                struct {
                        __be32  di_big_aextcnt; /* NREXT64 attr extents */
                        __be16  di_nrext64_pad; /* NREXT64 unused, zero */
                } __packed;
                struct {
                        __be32  di_nextents;    /* !NREXT64 data extents */
                        __be16  di_anextents;   /* !NREXT64 attr extents */
                } __packed;
        };
        __u8            di_forkoff;     /* attr fork offs, <<3 for 64b align */
        __s8            di_aformat;     /* format of attr fork's data */

Each of the two structures start at an 8-byte offset and the two 1-byte fields
(di_forkoff & di_aformat) defined later in the structure, prevent introduction
of holes inside dinode structure.

Also, An exception shouldn't be generated if the address of any of the packed
structure members is assigned to another pointer variable and later the
pointer variable is dereferenced. This is because such an address would still
be a 4-byte aligned address (in the case of di_big_aextcnt/di_nextents) or a
2-byte aligned address (in the case of di_nrext64_pad/di_anextents).

-- 
chandan
