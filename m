Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FF0C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 09:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 525AC6023B
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 09:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbhI1JuQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Sep 2021 05:50:16 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25708 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240019AbhI1JuL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Sep 2021 05:50:11 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S8oMUQ002954;
        Tue, 28 Sep 2021 09:48:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=T0Ev9qSh9TgUllL6buUR/l1oDug7NMRaiyqiSeVYoz0=;
 b=P7VrZJhS0nqOB9JHTTOSg7dV50XkK/X+ZNxkwjdKR2nb3CQszTrAYz8B8vp4U0jPHuuS
 Oaf8IesIMy93kLl+TzJDRiVXttIkvpAzsd+y7oLwCgGQ7GkKv/d0SA3mAw7fUGl72v89
 DmthL8uVgwjajxJ6vRUK9HO4XI/OKqxe0zszoN2ZqGMItoBw7Tn6nGQuvjl05UK2BRYK
 yIGyXvDC6zLOy/9IsFyVyNShE5DONEPrZ7ZX4XyUzIaRHnLlK46dQ5S5zdudDGF0Jv2s
 BXjMtoPfVPEkCIU5a0TgRBSfx67uJPn8lf3tYp3rgBSJNWWY8FtUAKN+EWYoj34vsCge Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbj90ms2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 09:48:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18S9Vbeg173907;
        Tue, 28 Sep 2021 09:48:15 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by aserp3030.oracle.com with ESMTP id 3b9stdyahq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 09:48:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vk2D7w0JzLM3lB/BbTsIrU+o4ZRA4FKCSd2Xo929Mwo2MHYWMW+luISxWRoQ4jdU+3gAQCrpPSDYZWiMnprHUQHjp42VzKcmyDpvRE691XOYgDSgAGSpIdkWqIZUv91/B1dTNc8gz+oeDRYUYGltEnZp+4Odxoqx4rdA/yfOjtd4+tOIePg/mg4FiyaXesNq/bAnlTLBB4Ic9/EbQZz+gu/tuFWcj1mGi54R5T+Bd5smVKmfmbZClNEl1Bm7zb49A30TS4hF+DqWQhhYajMaLuVNkmNxOz0paSxPEAHNYTls14LpZhXi3YjInlHITgfEOB4VkF8werY/T7BB9RTRmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=T0Ev9qSh9TgUllL6buUR/l1oDug7NMRaiyqiSeVYoz0=;
 b=hpKhmwh1Df5iL63LrvlSLfXB+sg22FqM4Gcishc2OFq8qzo40ghkk//tyLub41685eA5E9J3lOXdziYWfs+Ncztj4smMXx617kpVjBuXeVbTPbwNHyHKowO2LkFr34oYdGCZ5xQdV9sOfrFimVeSjqb7nAFEKwXzgDAGJYeMxRv7c8JzWwMTmlsp6hCXMB8b7NyktoF90XK4/Qz87vKjhWmk1GWEZCebpSYSVkbbaLS8fVNC6yx36l4g/ivOE2mpdPDwPNrI3xUFRsZ7LAGwJEXxBQeslHoKK+55gLSdQzbGdEM4grXuF9ZtT9Sgy5B+LpC1jroW/mD6ukNrkKdVXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0Ev9qSh9TgUllL6buUR/l1oDug7NMRaiyqiSeVYoz0=;
 b=cfwTE0XggmMZOYmON82ZIUraOUL2Ndt3nv1zO4fLjVxwHJVLWtsoPcd1ixfHDjFCndeEdZ7LxJ44Lo7PlaquFY5ZDOm5grgXXqZcfWCBdoSQAGIn/z4KbeJUVY0OR/yeTBu8nKArtt2EPt77QSTlptGG8sXILbNiztPZEA+9J8Q=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3053.namprd10.prod.outlook.com (2603:10b6:805:d2::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Tue, 28 Sep
 2021 09:48:13 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 09:48:13 +0000
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-9-chandan.babu@oracle.com>
 <20210928004707.GO1756565@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 08/12] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
In-reply-to: <20210928004707.GO1756565@dread.disaster.area>
Message-ID: <874ka51168.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 28 Sep 2021 15:17:59 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0175.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::10) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (122.171.129.29) by MA1PR01CA0175.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:d::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 09:48:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d82fddb-b44d-46ac-516d-08d98265169c
X-MS-TrafficTypeDiagnostic: SN6PR10MB3053:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3053B11D10FA491479B3A67DF6A89@SN6PR10MB3053.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: izkftGJMCESJaeUlgw43rVfdfsjCAc0WXqg6GICZw/RYQAZ88BncUAT4ghC/65l09NxwNmv105RwRpL6lYAfNZvxMNkt6RmOvDkVj9csI2xNEbV7iuHXflozhDPtVinKeXnYlYVl93BTPOksuHOwSj88HZk6zz2amNFcz9e+I0KpwUs+g6rcD/VUrdZDbQ6xu/xn1S4nqfDJgTOVoiGfpIkyf66FjNJMQBlBjBEv4ZXyvWvvWnga73J7t6aYNfjRec7h5VhIs+VdUFm0gI2r7Fb0LUv+D80+kcqeFxuYRjxHHc5trz6gcIo0a2gPQcg9djodUnRBCrq15DT1pZzht4V2gOFY9oh9Rp/HFKtXoGGzyToPqh6kLU6EwqKG0961AGzW4y76Jgsl0VnUEoytq9s4aeu99v+bJSW3ZekaZ6GB7tiKGe4VDGfla+8Juf3/2q4tpEKX6Xi0yVBdBzYrcqAyFpvGfORqlITe18gq16KyvL/xDmK95zkSKWC3TYcm3olEyjZfKfTEhyolrSt1NfRBExp5nZkF7FRsoYV16RfKflDJVxtPZkFiy/889CNs+HCEnqEnn+Nd2OdyQ8KuuuPHGESqd3tBcK3m2zpieWRdHvcdentwMFsjnXIgGG7PuN1/gbw9YgAAj5dH9o2y3y+XzaRAgYa47nxLP5oftwNgpWGgB/3gZoPZPe2FH9rGmo1Q1Dku7/Op8XNgY9kJdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(316002)(6666004)(6496006)(26005)(52116002)(33716001)(4326008)(508600001)(8676002)(956004)(9686003)(83380400001)(8936002)(38350700002)(86362001)(5660300002)(6916009)(2906002)(6486002)(53546011)(66946007)(66476007)(66556008)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5nJxnI8dd6nExJ0aDWvjUXbxwZpya2DMVkM6ljrE5ACCZrEH9Ql212zBkj4J?=
 =?us-ascii?Q?e/hP8DfGjt2dxwtgCB7DBx9MGbkzA4JkqV2urX6Gjttn3zJNFW9oUghn92Ac?=
 =?us-ascii?Q?l++2HvGe7IHqv5tc9G06cD4JklOYEDliePpAsxxxD96CxCKuTYHb0QH2gu/p?=
 =?us-ascii?Q?y0pod37w5fjemx5WkwwoO0707Nr9tUANCXRBTptU3RDObvH4nXll1Z7eZrUl?=
 =?us-ascii?Q?ALsvziAADkRGAMeND5TC8J6NKto5nKzu4K3L+4SPPAH5cBzxoEIhygLX62aQ?=
 =?us-ascii?Q?Dr4Ti7g4gDjR/AQIsV1xHlEDLpSppN8gKomhho4HFVK7I4mcW/vWcCybVkJQ?=
 =?us-ascii?Q?uE71bZiHNjvOfnSX4trHXbao8A/LhP1wKQeW25tsNID2/ae68C+jCppWcisz?=
 =?us-ascii?Q?CwIJIIkWWTA++4ZrGovnEiKVPmpvVIqp7VqycJdWNwqGkWI+kBBqMTCniUIs?=
 =?us-ascii?Q?RVegQ47mN8m8CoaTtXKDvtzHeGfCaR6n8o6Qvl/HvbZMRT5SRbCielrypOt+?=
 =?us-ascii?Q?oBDEPJwTTLXWWC4Tb0ZDH0jVAtVCKsebrBfWkuXEa5bT8EeJRUuUo/fWK4MO?=
 =?us-ascii?Q?jsIs9T9E0D+hSHE0fI9y0mhHHB8yoR+U998SNmNIACGbsZogY5StZVkle8Ue?=
 =?us-ascii?Q?gvSY9bdteW2UvMLNfyJVuD1mObK7H5s1tmtPZjv6OMimKCeB/icoPevgtPsX?=
 =?us-ascii?Q?Ctvi9Ejk//EB3F12hGQGpqu3whtcp837tJnJ49xitHwu4Ew6+6MQzOuf/yK/?=
 =?us-ascii?Q?E+29g8JSxFp153Ytt9VBeXnLytG0gSCMpQVRUxuHYtwYmsShsEN2OfajNpAu?=
 =?us-ascii?Q?/NpJT2IKBFllWCDD38GJdksvY5q7TT4ooD9Sr2BkdRHS0/DlYjfpkAeswCeD?=
 =?us-ascii?Q?1lNxcLwse/Lwjxoq5gJbM4kF2gjyuJyVQ7QoLN2K2ow7sHAkwjpxI/kFoyy5?=
 =?us-ascii?Q?4VmhV4TYrz1raTWgRB9SEP2R7a5Fblq/cwmfFJhw6eFLisDkciuiASewg/oD?=
 =?us-ascii?Q?UK2DKAzvk+InpJid18ry4dNsHljSWH3kVjy7pQocgp52XkSh9m06S5oYy9wy?=
 =?us-ascii?Q?AZBMV33HL0d/+Et2ddmQuXbdNdWUQET+AGhfuwev6B32Gy5R2qL0ZPTWGkSK?=
 =?us-ascii?Q?SRmsfnU5WK6OaA2BABYOB/J2E2ZYkePe3+ra9+togHW52ksxAX/9MjL737Fy?=
 =?us-ascii?Q?/OAz6r78XCuWd0yt5TwPIja2ZG9jKqoxhxkkgQLA45qGT/dfVA3Z7LTHp0K1?=
 =?us-ascii?Q?3Xxlk4tcpb9UWfKDrRV2Ap0G6WWZ1iqUFeb8bnDcNattt28dk1eRMfyMoXpO?=
 =?us-ascii?Q?/1BIITIkSEp9OWUmlzdLnxeB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d82fddb-b44d-46ac-516d-08d98265169c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 09:48:13.5124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g/o8bSHKcDCfufVAT2rC36upWHBnu7nJDbVwDr6UgxeB0OCU5m8WrZZFHg/XE1txp/FrJ8384BEO11zh9nNhfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3053
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280056
X-Proofpoint-GUID: 4H0k_NyvoSZLxrNkbfhJkWgb4dgTrhX8
X-Proofpoint-ORIG-GUID: 4H0k_NyvoSZLxrNkbfhJkWgb4dgTrhX8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Sep 2021 at 06:17, Dave Chinner wrote:
> On Thu, Sep 16, 2021 at 03:36:43PM +0530, Chandan Babu R wrote:
>> A future commit will introduce a 64-bit on-disk data extent counter and a
>> 32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
>> xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
>> of these quantities.
>> 
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>
> So while I was auditing extent lengths w.r.t. the last patch f the
> series, I noticed that xfs_extnum_t is used in the struct
> xfs_log_dinode and so changing the size of these types changes the
> layout of this structure:
>
> /*
>  * Define the format of the inode core that is logged. This structure must be
>  * kept identical to struct xfs_dinode except for the endianness annotations.
>  */
> struct xfs_log_dinode {
> ....
>         xfs_rfsblock_t  di_nblocks;     /* # of direct & btree blocks used */
>         xfs_extlen_t    di_extsize;     /* basic/minimum extent size for file */
>         xfs_extnum_t    di_nextents;    /* number of extents in data fork */
>         xfs_aextnum_t   di_anextents;   /* number of extents in attribute fork*/
> ....
>
> Which means this:
>
>> -typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
>> -typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
>> +typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
>> +typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
>
> creates an incompatible log format change that will cause silent
> inode corruption during log recovery if inodes logged with this
> change are replayed on an older kernel without this change. It's not
> just the type size change that matters here - it also changes the
> implicit padding in this structure because xfs_extlen_t is a 32 bit
> object and so:
>
> Old					New
> 64 bit object (di_nblocks)		64 bit object (di_nblocks)
> 32 bit object (di_extsize)		32 bit object (di_extsize)
> 					32 bit pad (implicit)
> 32 bit object (di_nextents)		64 bit object (di_nextents)
> 16 bit object (di_anextents)		32 bit ojecct (di_anextents
> 8 bit object (di_forkoff)		8 bit object (di_forkoff)
> 8 bit object (di_aformat)		8 bit object (di_aformat)
> 					16 bit pad (implicit)
> 32 bit object (di_dmevmask)		32 bit object (di_dmevmask)
>
>
> That's quite the layout change, and that's something we must not do
> without a feature bit being set. hence I think we need to rev the
> struct xfs_log_dinode version for large extent count support, too,
> so that the struct xfs_log_dinode does not change size for
> filesystems without the large extent count feature.

Actually, the current patch replaces the data types xfs_extnum_t and
xfs_aextnum_t inside "struct xfs_log_dinode" with the basic integral types
uint32_t and uint16_t respectively. The patch "xfs: Extend per-inode extent
counter widths" which arrives later in the series adds the new field
di_nextents64 to "struct xfs_log_dinode" and uint64_t is used as its data
type.

So in a scenario where we have a filesystem which does not have support for
64-bit extent counters and a kernel which does not support 64-bit extent
counters is replaying a log created by a kernel supporting 64-bit extent
counters, the contents of the 16-bit and 32-bit extent counter fields should
be replayed correctly into xfs_inode's attr and data fork extent counters
respectively. The contents of the 64-bit extent counter (whose value will be
zero) in the logged inode will be replayed back into di_pad2[] field of the
inode.

Please do let me know if my explaination is incorrect.

-- 
chandan
