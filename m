Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD12C43381
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 07:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38FCA20656
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 07:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhA0HXm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 02:23:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58940 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317226AbhA0Akr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 19:40:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R0dKen172828;
        Wed, 27 Jan 2021 00:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vsCsYO7G4diswXOBTH/sg3KL3ssYZRSz+HI1qO/Wm5g=;
 b=WdWKhHVPB1+0VLg3mOfgPWVAxfr9/oiasFMDxmX7zDt7kvaUGBuaET25g5E7L2N8l66f
 tlU7kVA/61x8RrVyywQPmD710EkwtrrCbguckw0YUK88DSm7D4vP+4HYAmAChr6sXzIC
 6+sepbYRBXeamd3DWmR1jl48TpbMtH5CBH+6lDDG9xczqiIReXKVEZyxdFc/nxjv2Xd/
 UT823HCid5eedq7LTaBYDZxVMX/BuclgUwvlyWpfhytsXU8XWlB7S0/nQ960uupV3ZKh
 JK7X/dX0CnotEUkgtHCkBqXLwV692dDj4ILcibI9M5XtwRxVkXPcqixOUfAY8uSLhOll Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 368brkmktr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 00:39:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R0KXCR160648;
        Wed, 27 Jan 2021 00:39:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3020.oracle.com with ESMTP id 368wpykv5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 00:39:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2JgWSCMErTXFD82hpQih3AZsH834pbOGT2HhIlDkWUoU5BS1Ipm+JcVwCQ4mLIgNAc+pRU8JjhlriC+jD3rCvet+NKDR5csdKlbe8YVRwhndE80N8TjCVrXcWxbR1SEDVY8L0XgGcZMKkHu8K2IIS0Lsmgq/4vT/T+JGvDAXirXMpWj0n1VAzyqIF+fVXT14CUjm1VHkp/bu6a9M7cVLsYvpg0jeqBFkycOYp6U8fqQOiGAK2v6y3eB4iJVBM115FfE+jjejHdsJPI17+GkA2Zi7qbWYlUZjHLROeT2Wxd20nFrF0+KjZQ2rFr9PzX2ujLk3sw1l5VpYGt8ZEszsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsCsYO7G4diswXOBTH/sg3KL3ssYZRSz+HI1qO/Wm5g=;
 b=CLUvbrkZxZY3yib5imoTRu2GucgF/735KZNkvojrGV6nQ9+oTRjAVtTEUySqt5bgVGZq/+LD/XxpxZ2viRfc9FVPUm2dWuVj88rVZbzaFCKrd/zWGRtpj6lqsjC9J+Afwc13e8jZRVkTShpiutl0UZoD79BpxAQM63PaeXURDsqa38rBBWQ5jQfUc7GpenTqHmjUWS5AelF9frscL1D1DA+0ycqgoLJ+jQ0SGegt5btQvVfOMqLjRArIr/lAqzBrI/4wLZU130SOJ/RklKqMoPop38We1Ps67OrAF3+ZoLlH4t6jnDuPzogN06iVZCILW4VKy4Okwcwxwg6Mn4Xehw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsCsYO7G4diswXOBTH/sg3KL3ssYZRSz+HI1qO/Wm5g=;
 b=becVuDo8L7/se17+CM6dgl1yBVIzUbXGBmxXaVMvEDyhch+1SPmnpoQZORcYIJmkPIcR2aRd8WRmIsciQRW/FK7SQDwnXOyA7ByC8lnqkx+nzmpsT/NKflp1WjgM/Go8g27ldecOYY/6E1bHiXpbKGshJzYbSF6kPOHRJEp+L5M=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3921.namprd10.prod.outlook.com (2603:10b6:a03:1ff::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 00:39:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 00:39:24 +0000
Subject: Re: [PATCH V15 14/16] xfs: Compute bmap extent alignments in a
 separate function
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, hch@lst.de, kernel test robot <lkp@intel.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
 <20210126063232.3648053-15-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <74af9bc1-f47c-5b3f-a1a1-fd50ed1998dd@oracle.com>
Date:   Tue, 26 Jan 2021 17:39:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210126063232.3648053-15-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.89.149]
X-ClientProxiedBy: BY5PR20CA0024.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::37) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.223] (67.1.89.149) by BY5PR20CA0024.namprd20.prod.outlook.com (2603:10b6:a03:1f4::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 00:39:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0692f474-abfe-4ac2-65f2-08d8c25bfe87
X-MS-TrafficTypeDiagnostic: BY5PR10MB3921:
X-Microsoft-Antispam-PRVS: <BY5PR10MB39219EA825B1B04919AC399695BB9@BY5PR10MB3921.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:499;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Qyi3EBUIFeUQBBiQhtV9XI/HeazQ9I63h7+9Jb7dlUNqZVAxHwx/HBMzgeUUO7O1LexAyOkcMIaowC7CFNow9vcn+9Shx4aaUdFDfmk5Sh3+edoOqEdqUnzvS0tvVn3kS4cvLMkqMs8ryEoc4azZEmDMILhugORzp7Q8oh7YmvISrtYlSeiOFslZD3P7V+xpupgfJlBGr5vPGQuy2Dyvm+0uErXpkXIbwQXu6cj8xaj5ZrweraiO8NpMnqhKnFMAvXuWLCT6ihk5AXqnfSpdZqZHEhJ7/ToJHor43Jb/zJe5whsm/Jz6gKGXriLa8jmdHHr3IrvBlARapjAg4w1gB9AR0Q12Owg7YRLad5rp/EwxYw0gQ7MQgUcGJVasHEDy39QuPogYl/pgIEXQPK/KTcUfQ5ZJB718bFSaI1u7z53pvb5ZMy4xTQqnoI796+WMLvDCRBr0hHPDVPivJ0hsJQpJG93jTt8cbCXDr73BJU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(8936002)(36756003)(316002)(44832011)(16576012)(66556008)(66946007)(66476007)(86362001)(8676002)(2906002)(478600001)(5660300002)(31686004)(6486002)(4326008)(956004)(26005)(16526019)(186003)(53546011)(2616005)(83380400001)(52116002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: o0+6Wj7cavFRIlQsMe8fXGewX0KC7uK8mCKcdrcGcw+bOuLAdsTPwFQuCCSUNF5SfNzvpTy79/wa1N9f10WcaAQ3mup4rmhH6AQPcvan5XKi0xOZ3RcA0BhC59cMoKgYaI3hoOnRYFPHviXjILtuZpIaezekIyiuwUh+XOX5e8eBoOAAQukxQ0fiSfy3b4XSHFmtKaDloJ3owmcgaEZZ1QZJvVP96D/+Ca3hZ5LPLY46YKimyiw5MVPb59dKMu+ddbtV94ZaS0bDiZ9NzrLmjv9zkOaMI3Ty3V9NzNsLe7/DMyEDxOJxCL8+cuIwB40JQYnLAGH41p2Z479hKg7Q3qrOTU62aEGlwdb2mwi/n4LUbVq5IDh1y7C2+TwYfH1MLnciNuIbHSFmJd2O9BpuvoB8KGn3a6HCI43N0dn71u0w0VOdJDdts/RlhjjcXgorpHc01NFE+MMeyK0Ze31bQGiXvQ2ekoxmcVUNPTOvxuK41FrgjPUdXkAiem+7XWrAGnTF1Sg5ndv3x27FwWk7moJlkBjT029WEFVlq3YntlheJA8le3JszOBPXQwLhCSrXZZw7kScof/KCycQacvTWTElx2gszTmLw2gDJxorM4o67/Yovv0TRzxavCW1GMCUIipfb8/HKWXJ2f5LaHwAkK7tHCNpGr0imBsN30GFPsgAwq+UfgvRTn+IseQz+qQOTYjdlG5hhK62TS0oyYzc+fgiHkBp3aI5RdIWAxK6NcE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0692f474-abfe-4ac2-65f2-08d8c25bfe87
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 00:39:24.4050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JCqtfMKHUS39c5psa3WrEhuHIsFacSHF42nWjeWmjSw/ECD0m4T1vdxL4MebbLDg/5C4EPj97ZZ2nX+XSO8M8HYbpQnhm8iIdayVx8fWGD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3921
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270000
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/25/21 11:32 PM, Chandan Babu R wrote:
> This commit moves over the code which computes stripe alignment and
> extent size hint alignment into a separate function. Apart from
> xfs_bmap_btalloc(), the new function will be used by another function
> introduced in a future commit.
> 
> Reported-by: kernel test robot <lkp@intel.com> # Unused variable warning
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, looks equivalent
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_bmap.c | 89 +++++++++++++++++++++++-----------------
>   1 file changed, 52 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 0b15b1ff4bdd..a0e8968e473d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3463,13 +3463,59 @@ xfs_bmap_btalloc_accounting(
>   		args->len);
>   }
>   
> +static int
> +xfs_bmap_compute_alignments(
> +	struct xfs_bmalloca	*ap,
> +	struct xfs_alloc_arg	*args)
> +{
> +	struct xfs_mount	*mp = args->mp;
> +	xfs_extlen_t		align = 0; /* minimum allocation alignment */
> +	int			stripe_align = 0;
> +
> +	/* stripe alignment for allocation is determined by mount parameters */
> +	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> +		stripe_align = mp->m_swidth;
> +	else if (mp->m_dalign)
> +		stripe_align = mp->m_dalign;
> +
> +	if (ap->flags & XFS_BMAPI_COWFORK)
> +		align = xfs_get_cowextsz_hint(ap->ip);
> +	else if (ap->datatype & XFS_ALLOC_USERDATA)
> +		align = xfs_get_extsz_hint(ap->ip);
> +	if (align) {
> +		if (xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> +			align, 0, ap->eof, 0, ap->conv, &ap->offset,
> +			&ap->length))
> +			ASSERT(0);
> +
> +		ASSERT(ap->length);
> +	}
> +
> +	/* apply extent size hints if obtained earlier */
> +	if (align) {
> +		args->prod = align;
> +		div_u64_rem(ap->offset, args->prod, &args->mod);
> +		if (args->mod)
> +			args->mod = args->prod - args->mod;
> +	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
> +		args->prod = 1;
> +		args->mod = 0;
> +	} else {
> +		args->prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
> +		div_u64_rem(ap->offset, args->prod, &args->mod);
> +		if (args->mod)
> +			args->mod = args->prod - args->mod;
> +	}
> +
> +	return stripe_align;
> +}
> +
>   STATIC int
>   xfs_bmap_btalloc(
>   	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
>   {
>   	xfs_mount_t	*mp;		/* mount point structure */
>   	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
> -	xfs_extlen_t	align = 0;	/* minimum allocation alignment */
>   	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
>   	xfs_agnumber_t	ag;
>   	xfs_alloc_arg_t	args;
> @@ -3489,25 +3535,11 @@ xfs_bmap_btalloc(
>   
>   	mp = ap->ip->i_mount;
>   
> -	/* stripe alignment for allocation is determined by mount parameters */
> -	stripe_align = 0;
> -	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
> -		stripe_align = mp->m_swidth;
> -	else if (mp->m_dalign)
> -		stripe_align = mp->m_dalign;
> -
> -	if (ap->flags & XFS_BMAPI_COWFORK)
> -		align = xfs_get_cowextsz_hint(ap->ip);
> -	else if (ap->datatype & XFS_ALLOC_USERDATA)
> -		align = xfs_get_extsz_hint(ap->ip);
> -	if (align) {
> -		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
> -						align, 0, ap->eof, 0, ap->conv,
> -						&ap->offset, &ap->length);
> -		ASSERT(!error);
> -		ASSERT(ap->length);
> -	}
> +	memset(&args, 0, sizeof(args));
> +	args.tp = ap->tp;
> +	args.mp = mp;
>   
> +	stripe_align = xfs_bmap_compute_alignments(ap, &args);
>   
>   	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
>   	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
> @@ -3538,9 +3570,6 @@ xfs_bmap_btalloc(
>   	 * Normal allocation, done through xfs_alloc_vextent.
>   	 */
>   	tryagain = isaligned = 0;
> -	memset(&args, 0, sizeof(args));
> -	args.tp = ap->tp;
> -	args.mp = mp;
>   	args.fsbno = ap->blkno;
>   	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
>   
> @@ -3571,21 +3600,7 @@ xfs_bmap_btalloc(
>   		args.total = ap->total;
>   		args.minlen = ap->minlen;
>   	}
> -	/* apply extent size hints if obtained earlier */
> -	if (align) {
> -		args.prod = align;
> -		div_u64_rem(ap->offset, args.prod, &args.mod);
> -		if (args.mod)
> -			args.mod = args.prod - args.mod;
> -	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
> -		args.prod = 1;
> -		args.mod = 0;
> -	} else {
> -		args.prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
> -		div_u64_rem(ap->offset, args.prod, &args.mod);
> -		if (args.mod)
> -			args.mod = args.prod - args.mod;
> -	}
> +
>   	/*
>   	 * If we are not low on available data blocks, and the underlying
>   	 * logical volume manager is a stripe, and the file offset is zero then
> 
