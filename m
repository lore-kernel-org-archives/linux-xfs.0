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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC9EC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 02:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8877064DD1
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 02:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbhA1Cgz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 21:36:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54050 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhA1Cgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jan 2021 21:36:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S2Oarx101718;
        Thu, 28 Jan 2021 02:35:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=OLo5C+sJwCnx6gNBwk2s3PkNoAwZDO7+ywARl6AuLPM=;
 b=q90//g0fL7E9HpDuyakMnHBB8WEDRMQBUlGXzRe59xlcYqBgB1kwbf8C5Jz2j/5nZEN7
 5WbNZp27TwPS3x6GXZk/UVL76OdcLFTLIqKDjhquC4hrEQiKvB2dmEAJGV16NMTJmjju
 6ReMT+aOG7tOKry2P9ewHg7bSNrq2hDWaXLGslbICh3cHwgu+N6HR2M64lyAngyo5pLU
 RlbkSMqGpk/ny7yQI2cMJQ+YSq/QSzCDgqM3or9UP3S8FpES9166UlaavqLQfB1USC0D
 sDA36bXtDstUw9hQPaHSRPiukP7HgXQgXE/6iGFOIpaDQk5iAkCWzssg7Rf4XFawUdvv GQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 368b7r22qr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 02:35:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S2KbTP133026;
        Thu, 28 Jan 2021 02:35:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3020.oracle.com with ESMTP id 368wq1124w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 02:35:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7BvKeRpalnhcKh870caZLNhgYps/q0x8wfeLj5Cpa/GViRDdNxfBjomu3HEu48zPqEEWofWx4ZSyMe/iqUxfQptdXCPkVjQJCpoHphgjL6qYpTeZwtjKPpYCB9RKieW+2YvUYgw69xdAzhEQ+9f6y//29/t10opnaUKRy1leQ2uM1pidmKqXrwOvUJCd5ky9ED9zwTYLlKuXxcvljohoCoTMMRAm/SwOUAoqaHMFOQLiyYZhDvB4PeRgPEsx8hyfgTycVOvLNfcIiKOyBEkpHvF3oHHzpKcIUZrEhz7U3HZkHNQ1S8m1/jnZY4OsapIL7+QzKX6lT7jmHvvKxFhKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLo5C+sJwCnx6gNBwk2s3PkNoAwZDO7+ywARl6AuLPM=;
 b=ESiDJn5P40gcd75v1bSkZkTgaX2E4N8QlgLZ1AFsVn1S5SjREP/2xGX+n6E1YUFXRGea6/P11KjdpFBSAcXRk1XuYG39fSPVsmbIwTdKsvuGUwOIxCn1pgI1xu9uhPO9TaYeVIzfF+BS6wBXK5u5LKHEpssnzSFHXGuzKU8Z2Pcsy8StpxWeORn2bvVXgXy0BEPO5ap//ILWBIXCm7B8BbhpKacJGUEDqmbqFppbV+kvsL/CRUWHGfzeC7AmoLh+ga07BmFF+se7iSP/U38rnETzwPS8KoegSpapcGwvZgSCjX4C6KdF/z+GWCQ+72LK2Juywcuxce84tvhWxJC9RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLo5C+sJwCnx6gNBwk2s3PkNoAwZDO7+ywARl6AuLPM=;
 b=TqplS9lwC+SGH4HgLoQqdyxyVbxL1P8xO6nKpf4L+4tSnqon2BWp1fYaP4Vz9tvkZWXrNQeU6DzG3ufD9zAwrRh+eDCrc7x47HKJglXoyslZDdlaBhEN7sy1zrgfyCbrrqvFoCYly96tBo0joflsPm9aucEI3kOzoNiU3bjJGvY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3032.namprd10.prod.outlook.com (2603:10b6:a03:82::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 28 Jan
 2021 02:35:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3805.017; Thu, 28 Jan 2021
 02:35:52 +0000
Subject: Re: [PATCH V15 16/16] xfs: Introduce error injection to allocate only
 minlen size extents for files
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, hch@lst.de,
        "Darrick J . Wong" <darrick.wong@oracle.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
 <20210126063232.3648053-17-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <40ea5887-64b0-073f-3748-13778aa68db8@oracle.com>
Date:   Wed, 27 Jan 2021 19:35:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210126063232.3648053-17-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.89.149]
X-ClientProxiedBy: BYAPR07CA0032.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::45) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.223] (67.1.89.149) by BYAPR07CA0032.namprd07.prod.outlook.com (2603:10b6:a02:bc::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Thu, 28 Jan 2021 02:35:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03e00243-3ad1-4c64-962f-08d8c3356e1d
X-MS-TrafficTypeDiagnostic: BYAPR10MB3032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3032CCDD5F0204CE7652ED8195BA9@BYAPR10MB3032.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ck8jNqPHTXu5y8UeFspzGe6HQeEy33j9TVh7drsOa9u0gMvrCMVZkPsH4g/XTqdlINEh8igpi/7hjKuBo36BYD10givB8UYNYHipBM14tlNlk8TZPAX7znwoCV96afmq4B1JqZzMNjooomDR/xhenXNs1d2cmYjNkrpbb2OE+ILj4ZG3PWAyY4VRxxBgXJfBmaffGFIq4iV6u3XQTua4eAvxHETIA/9bX6GK04uf7oNT9zcd0/rzmU6iOkl/r6k+sqZely4oC+Gv9aW9FXaYBcYv+CU1qlShzwDyoxhS99wgkv41MVMpfa7hwgbSYHfVsYTHkzwZ+DO1lm3skWBi5rhSR2yT0WzVB0owrxAco4WZZ7yTSsJ4U4JehbKAb+x4fB9GKT+1GZOwPg3p0AKg2jNXoKKwOFaBQgJj+4yZmq66wkdGraYAHZORL1JuG2ti2wAEUL/lmFXYxMsCzivmzDCTB6o2Noh/U7NkqL2AWiXBvZKrj3On3wGrNw+9pC3KjNDHnegHD9AIeX5DG86EQtEVanLz+BLc5WsFOeqKE9QYQRksEaiWtTr1/KizWXa3b5y1D/OR7y9hYwz2obNO4elJe0HQ5vCW4BP8hHtYO6I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(316002)(8936002)(52116002)(16576012)(31696002)(36756003)(83380400001)(186003)(31686004)(44832011)(956004)(16526019)(2906002)(2616005)(86362001)(8676002)(53546011)(6486002)(26005)(4326008)(66476007)(66556008)(66946007)(5660300002)(107886003)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eWJ4UGRrNVY2MFFicGVZeFZXR2NFa3RTZFVFM29WRmxqaDJaZ2RHVWhuSkJO?=
 =?utf-8?B?b08rVStBaFk2TTRTalZ2NE54YllKNzBwVlJxb05kSVREMC9BMTNyQ2pwcnhE?=
 =?utf-8?B?VjR4SDRSNWRyY2hndUNiUThnMFZFZTlHTDdtNGh0Ums0by9ETVBqdjd5VGR3?=
 =?utf-8?B?STdUK21qNXhML2pFUjRuVnM3ZjFsYmc1Y0dxWEk3UktZajVEVkd5V2pscmUy?=
 =?utf-8?B?bW1Va0paZjU1VlViZklvU0pjNEpXck9EVDB1VGxENzJLTmFKYWtsUkZxMDNS?=
 =?utf-8?B?L21rZFArS1JzVzNVM0ZaUmRRRWtXZlRpNXJncFkxUWQyL2pESFRlR2lBdXh2?=
 =?utf-8?B?Z0VHVnRBMTZQamc3ZkNpQ00yVzJpKythd0wzNVJPNUI2VG5OOVVOZHpPbW8r?=
 =?utf-8?B?R1lIS2o0Y0ZtK0NYRU8zTkxDVmVvRzIwSWVlQ3lEVU16TlpKbWFHeWVYV05N?=
 =?utf-8?B?dlVzZEp5cHk4VXkvdnhxWVB2bHhhbGlQVC9yMTNxTUNTNVZIMmVuQ3cwUUpu?=
 =?utf-8?B?alo0QjRNcUdJYnFrMnlDVXRQYnI0STVUWlVBaEdzWjN4SEFpZXhqN0krVEFX?=
 =?utf-8?B?QVhOQnc5cW1oQjNCeWkzcHVOZVU1cExJeXdCaXI1cTErUUZZWlhLM2tiRjkr?=
 =?utf-8?B?VU1VOUptZ2pKUmZ5dlhJY21jOUxNV0VyWThVRkFRY0xwTXc5aUhyWHNIN1B5?=
 =?utf-8?B?UXhZK2hiL1UrR1RIWVF6NStTOElZa3NNRCtzVmREUFU0ajZLZjBTRXR6emZ1?=
 =?utf-8?B?ajhVbFluNkZ0MTNvSjVkOElVSjZITFE1NlFEK01mNVZxVTZWS3dEVTBkNmYy?=
 =?utf-8?B?RVkvUEZlTHNBN0RZcE56eSttZForZWRDY25jSWcxY29ad1JDYWoxSVAzRHRu?=
 =?utf-8?B?Q3JmWExVenNXam5JMFpXeHFvRS82Tk1nZG9acXNLRkt0cDlTTSsxU2NXU3Vu?=
 =?utf-8?B?eE1lUjFOZnY1WVRENjhtVlJDWU55aUNtbHptTUh1NXZyWHJGSmNRQ3dlcDg4?=
 =?utf-8?B?MkFaZ0xreTVNSy9UbFIzQjJPci82RVF3K1JSUXR4UFRRTm1RdldnalF1KzJK?=
 =?utf-8?B?WUUwVmNMSDZ5N1k3M0hzOXFuRld4eHAveTlwckhvWXhDN3B2SFB1akNCWVRM?=
 =?utf-8?B?ZTNFNUxEU0NmcVVBZG04N2ZvcGZXWlFBbUlFSG1Mb3VRMDlNYlVPcCtTNFZ5?=
 =?utf-8?B?QURNMXhqLzhnczVFYWpUZGNWcEVBanNVUGdVZkdlNE01NXZTek9XYytOWGI1?=
 =?utf-8?B?WDFZTlBmVkNrSUgydzh5MGNEWUtNR0Z1N0loek04RmltWldjdmNsNUFneEc3?=
 =?utf-8?B?Z3p0dm9xMFRpM1l6TlZaWnhxU3Vxbm9QRERkZkRWQnpRaVhzano4UTFOZEV2?=
 =?utf-8?B?RmNvWlA3Y3FCK2Y0L2lXMXZuUVVSdFBxRDdsb2Q2bE9NUHZnVDhVOTJXS2tE?=
 =?utf-8?Q?nG082bao?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e00243-3ad1-4c64-962f-08d8c3356e1d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 02:35:52.2922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cuY8WQKGe18EPQxzrv7Hl4QxyqaG38u2MRqxVmZLJ3bpi2MgYGFB4mG0ceKIJHGG0v7stWh0/qiQouC5v64FPQ/Kst++LNtp6YefVWHGwsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3032
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280012
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280012
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/25/21 11:32 PM, Chandan Babu R wrote:
> This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
> helps userspace test programs to get xfs_bmap_btalloc() to always
> allocate minlen sized extents.
> 
> This is required for test programs which need a guarantee that minlen
> extents allocated for a file do not get merged with their existing
> neighbours in the inode's BMBT. "Inode fork extent overflow check" for
> Directories, Xattrs and extension of realtime inodes need this since the
> file offset at which the extents are being allocated cannot be
> explicitly controlled from userspace.
> 
> One way to use this error tag is to,
> 1. Consume all of the free space by sequentially writing to a file.
> 2. Punch alternate blocks of the file. This causes CNTBT to contain
>     sufficient number of one block sized extent records.
> 3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
> After step 3, xfs_bmap_btalloc() will issue space allocation
> requests for minlen sized extents only.
> 
> ENOSPC error code is returned to userspace when there aren't any "one
> block sized" extents left in any of the AGs.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, looks reasonable.  Thanks!

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_alloc.c    |  50 ++++++++++++++
>   fs/xfs/libxfs/xfs_alloc.h    |   3 +
>   fs/xfs/libxfs/xfs_bmap.c     | 124 ++++++++++++++++++++++++++++-------
>   fs/xfs/libxfs/xfs_errortag.h |   4 +-
>   fs/xfs/xfs_error.c           |   3 +
>   5 files changed, 159 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 7cb9f064ac64..0c623d3c1036 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2474,6 +2474,47 @@ xfs_defer_agfl_block(
>   	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
>   }
>   
> +#ifdef DEBUG
> +/*
> + * Check if an AGF has a free extent record whose length is equal to
> + * args->minlen.
> + */
> +STATIC int
> +xfs_exact_minlen_extent_available(
> +	struct xfs_alloc_arg	*args,
> +	struct xfs_buf		*agbp,
> +	int			*stat)
> +{
> +	struct xfs_btree_cur	*cnt_cur;
> +	xfs_agblock_t		fbno;
> +	xfs_extlen_t		flen;
> +	int			error = 0;
> +
> +	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
> +			args->agno, XFS_BTNUM_CNT);
> +	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
> +	if (error)
> +		goto out;
> +
> +	if (*stat == 0) {
> +		error = -EFSCORRUPTED;
> +		goto out;
> +	}
> +
> +	error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, stat);
> +	if (error)
> +		goto out;
> +
> +	if (*stat == 1 && flen != args->minlen)
> +		*stat = 0;
> +
> +out:
> +	xfs_btree_del_cursor(cnt_cur, error);
> +
> +	return error;
> +}
> +#endif
> +
>   /*
>    * Decide whether to use this allocation group for this allocation.
>    * If so, fix up the btree freelist's size.
> @@ -2545,6 +2586,15 @@ xfs_alloc_fix_freelist(
>   	if (!xfs_alloc_space_available(args, need, flags))
>   		goto out_agbp_relse;
>   
> +#ifdef DEBUG
> +	if (args->alloc_minlen_only) {
> +		int stat;
> +
> +		error = xfs_exact_minlen_extent_available(args, agbp, &stat);
> +		if (error || !stat)
> +			goto out_agbp_relse;
> +	}
> +#endif
>   	/*
>   	 * Make the freelist shorter if it's too long.
>   	 *
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 6c22b12176b8..a4427c5775c2 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -75,6 +75,9 @@ typedef struct xfs_alloc_arg {
>   	char		wasfromfl;	/* set if allocation is from freelist */
>   	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
>   	enum xfs_ag_resv_type	resv;	/* block reservation to use */
> +#ifdef DEBUG
> +	bool		alloc_minlen_only; /* allocate exact minlen extent */
> +#endif
>   } xfs_alloc_arg_t;
>   
>   /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ee2c0a4295c6..33117aef79e5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3552,34 +3552,101 @@ xfs_bmap_process_allocated_extent(
>   	xfs_bmap_btalloc_accounting(ap, args);
>   }
>   
> -STATIC int
> -xfs_bmap_btalloc(
> -	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> +#ifdef DEBUG
> +static int
> +xfs_bmap_exact_minlen_extent_alloc(
> +	struct xfs_bmalloca	*ap)
>   {
> -	xfs_mount_t	*mp;		/* mount point structure */
> -	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
> -	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
> -	xfs_agnumber_t	ag;
> -	xfs_alloc_arg_t	args;
> -	xfs_fileoff_t	orig_offset;
> -	xfs_extlen_t	orig_length;
> -	xfs_extlen_t	blen;
> -	xfs_extlen_t	nextminlen = 0;
> -	int		nullfb;		/* true if ap->firstblock isn't set */
> -	int		isaligned;
> -	int		tryagain;
> -	int		error;
> -	int		stripe_align;
> +	struct xfs_mount	*mp = ap->ip->i_mount;
> +	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
> +	xfs_fileoff_t		orig_offset;
> +	xfs_extlen_t		orig_length;
> +	int			error;
>   
>   	ASSERT(ap->length);
> +
> +	if (ap->minlen != 1) {
> +		ap->blkno = NULLFSBLOCK;
> +		ap->length = 0;
> +		return 0;
> +	}
> +
>   	orig_offset = ap->offset;
>   	orig_length = ap->length;
>   
> -	mp = ap->ip->i_mount;
> +	args.alloc_minlen_only = 1;
>   
> -	memset(&args, 0, sizeof(args));
> -	args.tp = ap->tp;
> -	args.mp = mp;
> +	xfs_bmap_compute_alignments(ap, &args);
> +
> +	if (ap->tp->t_firstblock == NULLFSBLOCK) {
> +		/*
> +		 * Unlike the longest extent available in an AG, we don't track
> +		 * the length of an AG's shortest extent.
> +		 * XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is a debug only knob and
> +		 * hence we can afford to start traversing from the 0th AG since
> +		 * we need not be concerned about a drop in performance in
> +		 * "debug only" code paths.
> +		 */
> +		ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
> +	} else {
> +		ap->blkno = ap->tp->t_firstblock;
> +	}
> +
> +	args.fsbno = ap->blkno;
> +	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
> +	args.type = XFS_ALLOCTYPE_FIRST_AG;
> +	args.total = args.minlen = args.maxlen = ap->minlen;
> +
> +	args.alignment = 1;
> +	args.minalignslop = 0;
> +
> +	args.minleft = ap->minleft;
> +	args.wasdel = ap->wasdel;
> +	args.resv = XFS_AG_RESV_NONE;
> +	args.datatype = ap->datatype;
> +
> +	error = xfs_alloc_vextent(&args);
> +	if (error)
> +		return error;
> +
> +	if (args.fsbno != NULLFSBLOCK) {
> +		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
> +			orig_length);
> +	} else {
> +		ap->blkno = NULLFSBLOCK;
> +		ap->length = 0;
> +	}
> +
> +	return 0;
> +}
> +#else
> +
> +#define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
> +
> +#endif
> +
> +STATIC int
> +xfs_bmap_btalloc(
> +	struct xfs_bmalloca	*ap)
> +{
> +	struct xfs_mount	*mp = ap->ip->i_mount;
> +	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
> +	xfs_alloctype_t		atype = 0;
> +	xfs_agnumber_t		fb_agno;	/* ag number of ap->firstblock */
> +	xfs_agnumber_t		ag;
> +	xfs_fileoff_t		orig_offset;
> +	xfs_extlen_t		orig_length;
> +	xfs_extlen_t		blen;
> +	xfs_extlen_t		nextminlen = 0;
> +	int			nullfb; /* true if ap->firstblock isn't set */
> +	int			isaligned;
> +	int			tryagain;
> +	int			error;
> +	int			stripe_align;
> +
> +	ASSERT(ap->length);
> +	orig_offset = ap->offset;
> +	orig_length = ap->length;
>   
>   	stripe_align = xfs_bmap_compute_alignments(ap, &args);
>   
> @@ -4113,6 +4180,10 @@ xfs_bmap_alloc_userdata(
>   			return xfs_bmap_rtalloc(bma);
>   	}
>   
> +	if (unlikely(XFS_TEST_ERROR(false, mp,
> +			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> +		return xfs_bmap_exact_minlen_extent_alloc(bma);
> +
>   	return xfs_bmap_btalloc(bma);
>   }
>   
> @@ -4149,10 +4220,15 @@ xfs_bmapi_allocate(
>   	else
>   		bma->minlen = 1;
>   
> -	if (bma->flags & XFS_BMAPI_METADATA)
> -		error = xfs_bmap_btalloc(bma);
> -	else
> +	if (bma->flags & XFS_BMAPI_METADATA) {
> +		if (unlikely(XFS_TEST_ERROR(false, mp,
> +				XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
> +			error = xfs_bmap_exact_minlen_extent_alloc(bma);
> +		else
> +			error = xfs_bmap_btalloc(bma);
> +	} else {
>   		error = xfs_bmap_alloc_userdata(bma);
> +	}
>   	if (error || bma->blkno == NULLFSBLOCK)
>   		return error;
>   
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 1c56fcceeea6..6ca9084b6934 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -57,7 +57,8 @@
>   #define XFS_ERRTAG_IUNLINK_FALLBACK			34
>   #define XFS_ERRTAG_BUF_IOERROR				35
>   #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
> -#define XFS_ERRTAG_MAX					37
> +#define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
> +#define XFS_ERRTAG_MAX					38
>   
>   /*
>    * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -99,5 +100,6 @@
>   #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
>   #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
>   #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
> +#define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
>   
>   #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 3780b118cc47..185b4915b7bf 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -55,6 +55,7 @@ static unsigned int xfs_errortag_random_default[] = {
>   	XFS_RANDOM_IUNLINK_FALLBACK,
>   	XFS_RANDOM_BUF_IOERROR,
>   	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
> +	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
>   };
>   
>   struct xfs_errortag_attr {
> @@ -166,6 +167,7 @@ XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
>   XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
>   XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
>   XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
> +XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
>   
>   static struct attribute *xfs_errortag_attrs[] = {
>   	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -205,6 +207,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>   	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
>   	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
>   	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
> +	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
>   	NULL,
>   };
>   
> 
