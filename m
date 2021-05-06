Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCE7C433B4
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 05:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FEE460FEE
	for <linux-xfs@archiver.kernel.org>; Thu,  6 May 2021 05:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhEFF1d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 May 2021 01:27:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55060 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhEFF1c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 May 2021 01:27:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1465Nu0M150029;
        Thu, 6 May 2021 05:26:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=YcWSee6h4MWYbwIo01nbAA1G1rMEH6eprIkFEt1atzc=;
 b=gWAlUwHajCnUetCgh58JmlQNw2KJDCYIyM+C/WdPML6XSHv/7bFBYeckSNtOA1+G/Q1g
 wZkZJuFwcts88IIfmcQ8wTdflhLc2s4QJCtC8vXLoJsmlb8SMTSSox0difDSU/NAtESi
 dZvft0bXeK2Cf6In0lE8HTgQdhKyFm1PHdzCX0JcUzZNsp2n+872tB1y221LFS3OKxlh
 5ofS/78fFzqxlRgUWrKjIdL9UH6jKaX3qgZ2A3WBVZ70LYGrJCVYLeQNjrUSX/ljRCv1
 ARmyRT30AZnA6GUo+ZaASEF6wnU2dDr+frK8yLZOMF8WrqboIapcSx/fZLx4NgHn4/qh kQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38beetksft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 05:26:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1465QK4e107604;
        Thu, 6 May 2021 05:26:32 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by aserp3020.oracle.com with ESMTP id 38bebkmmvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 05:26:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aersEBLCe7D6W94Nrzyc0jraJ/CMVCpSBFd/Vgyu5/oRxGczrQNs6S4nrAzW4flqYeOmzqbMmRTDNwJ9SvDNnFcrdhUAqC43aikYdGp/9R95jLqaEC815Y39IMdDxjlAiWS8MpQP4+axaambUhkUeZ8PFTJ2Fb3gpLQQvRtlopefJDVrKxl7wRqDKNNv6zjX3hhvHt8G/KifoS+NfUxoftjtV73xC1v8RC/bsMZPsW8jt7RrdpfQYLxcECxaYZf7u/c8Rq43yV2qWPEFkFNYy3/RH9cJ+P7bBuh/LGPK3ar9aiUGNvEpfF8LLsiUjy2F9eIp0Bx/jIqg3s5PJZi6cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YcWSee6h4MWYbwIo01nbAA1G1rMEH6eprIkFEt1atzc=;
 b=dJi6pAHi0UQ8NEthGy7I2oZgfeTT5rhj+CShBNd6BJ6xS2pwhb794flSB/YgAmg9DLoio7TTBqsitmn6hsmH6yuOuERcIVfGspFITKoI4RaRH43lbOYrtp2cj326giSh+mdR1YBgDdyXC+dFBv0GFLOQYGgGt6SDZdZUWCRZ4IS1hwJsBwKJ7Z0zbZo9nOW5fBNgUacfnQtFQb+7e8O6TdYTWy1K6+/aIKeq01xKE5h4dvzpTGnpNp4cj4hIyEsUcxiFKTjop4q+KjDMbwNEbT2/tGY9KFRVpK5HW3z8FWDFQq7NVqZc9tfbyf5jqvDm8Hy6MbODTl3hlE3js0z9fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YcWSee6h4MWYbwIo01nbAA1G1rMEH6eprIkFEt1atzc=;
 b=jVc1LH+Glu3z0pJ1DCz3EjsCIXIjTZrMXJwvIibN+sdQfnF9BiW2pAYq0LVcMTRM/WAk+3DuVyR2eA75dXnXawhm4FNTpN5CoXnSF5VogH8MpO+iBX+w3F33OXHGw2Mw6vxB1PlOzlmk/cs/nUXZW6ZyEmIHQ7sru+Vh/Z+66fM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3956.namprd10.prod.outlook.com (2603:10b6:a03:1b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 6 May
 2021 05:26:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4065.039; Thu, 6 May 2021
 05:26:30 +0000
Subject: Re: [PATCH 1/2] xfs: adjust rt allocation minlen when extszhint >
 rtextsize
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <162007768318.836421.15582644026342097489.stgit@magnolia>
 <162007768898.836421.2999725068692265955.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <70001ad2-b9d3-a5ae-9d1f-20352ea428fd@oracle.com>
Date:   Wed, 5 May 2021 22:26:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <162007768898.836421.2999725068692265955.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BY5PR17CA0051.namprd17.prod.outlook.com
 (2603:10b6:a03:167::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BY5PR17CA0051.namprd17.prod.outlook.com (2603:10b6:a03:167::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 05:26:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b610b9ba-0305-4053-c117-08d9104f80c3
X-MS-TrafficTypeDiagnostic: BY5PR10MB3956:
X-Microsoft-Antispam-PRVS: <BY5PR10MB395604F159F3D13B82F301F995589@BY5PR10MB3956.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MKZqtcMNe9+dcPCRXP0oUWZmPqtnzjKXNCVLLe/at5+FRt+byjylgYcsWk655UOkDw+XcvVUmZCGnf/WJMYHXxjtt78gfILbk743qZDXR6lZet2DT47sJNNHKNKZRZ955++gJLYp6p+CsrqGkOLNvmysq5CJZJ95+rOEfCFEnvQHlKMa2GlGCrhqlv8LAjyWcSaP8XFb2lLqjz95MQK626juPt6GBsSNmYV5hQ+SQj9wikCvNAFngSYpX7QLhte+zPz6Zg0XUkydKvB3Uw3ZIX4iHg2J52M+IS8FLyqS5HcwWphN0w2OrbT3U484A/uYvjOSffTCFbV3d73zF1gDxyDmKH9Q6r+uDxgMg4D4k3YdWF6iXSpxcIv+YwYMGQVnWXOc+Z19mU6jQUnKulvS8lGThPetnmv5AGURs75I7hiQiRsKmv8jUdYEuCFZQuk27aPK1WTNU+44PsqHD5G8ZY4ipyR9ElW6xgyDp4+vOToqk4RAWPNtFBSiq63v9trJOesUTSKMZnm9/Gl46Scmd0T24Wi3nYaFUcq8DUaekUhrkRxx6rYA2Fbik1IiLl8WrzOb7nrZwdRhrLch1yDZVoeNX+iIY216AFidr6NDgajEgDMr3/YZ1xOXz9ehq4WGuR30tPC/9lHfOEcBn8j/jvj7MRJ4MLmEwQl2B5We2r0338BvCOa8d37DQeQEs4bLP5lNPdOIDzSXYickDHnf3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(136003)(39860400002)(26005)(31686004)(44832011)(8676002)(8936002)(66946007)(478600001)(36756003)(66556008)(16576012)(66476007)(186003)(2616005)(16526019)(5660300002)(6486002)(316002)(31696002)(52116002)(53546011)(6916009)(956004)(2906002)(83380400001)(38350700002)(4326008)(38100700002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Nkp4OTNjU3NubXB6dFFGNGNydnFhcTVpa2QrL2NBZEwwWksyRTZuN2ExTm1v?=
 =?utf-8?B?d2grbDJ1d1FUMWJ6TlNKV25JazVXakJXNXFYS0d2Q2U2b3JIQjJSWlZKbXJs?=
 =?utf-8?B?amluU2tnZUtWcGNxQ3d4SityVFFLN2NxMGVUWlI1eTl1OFBKR0lKK0NGWlFi?=
 =?utf-8?B?QzNpSWxuMjJvNERwdCt2cE85TkVZWi9rSSthUmcvUE0waXk3eDlqUjNvUmMv?=
 =?utf-8?B?QlhsN2hiTG9hWHQwa3QxZU5rVm5QUTlwTHRFeUFLWlN3UXhnQ3ZqcW90eDdY?=
 =?utf-8?B?bU1nSnJVaStZd3dCY3hoVkhzVzBMSjBnNnpEbTZMRHZ2bWx6Zy81QSt2am5Q?=
 =?utf-8?B?OEE2U1RuaVRpMnNEbzV2clVYQ1ZmZ2JYREhxT0F3VDMvQzdtZlMvR3BTRnFT?=
 =?utf-8?B?eXcwMUpqVVQxdXp4eUZOZExEbWozTXVvVExyU2JDTjJFV2sxRnZ6L0tJaVNJ?=
 =?utf-8?B?SnEwVy9VZE11V0ttbERZT25va3ZmRkU0TjFjK09adkc3SVlQTlFLZCtuOVNq?=
 =?utf-8?B?V1B4UlgzUzZsTi9PSzZCZnZhZEcrdmVrelZxNFF0UDhwdFY1NnRPSWE0aHdm?=
 =?utf-8?B?alJJeVIrYTE4WTE5cFVIR0Z0RWRDRXZkR1NYZnBWZEtoTUZBQTdSYk53Mlpr?=
 =?utf-8?B?WVlLTFlyUVBGR1JvMkZVeUt1RlFoRGFPeVhFc01IMG1NcnEvSXl3Z3dzNXB6?=
 =?utf-8?B?Uk1jN3ZjVWxxZng0YnQxZnRpNlBlWjJsaW04NnI3TlJOR1VFTVVMRmdJbXNL?=
 =?utf-8?B?TnhqYzRqQmROd1FNNkwvSG1DdERZUzdCSEplUDdRM2hEbXcwWnJsTlRHT09N?=
 =?utf-8?B?U0d6UWRUYW5NbmlOLzJEWDJVZHVBWDczaWxKeEQ3TWc3ZVB6TTNDSDl5WUNk?=
 =?utf-8?B?cFVUT213U29vRVY3dHRxcnQrWndyK3BpZVBJZFEybXQ5Z1g5b3o5cjdpOVRL?=
 =?utf-8?B?R1NOdDVmVzEwaHZLRm9mRmlMajk1MzRITHRPd1VTTmN6ci9nSncxVERUNk1q?=
 =?utf-8?B?TkdPSHRkWThHaXNYK2lxR3p6YitaRVpUalJzeUsrRjZMZy9qVDB0THVIbVRx?=
 =?utf-8?B?V1dkNGd1b2JwNHpZTmRmTitLUG1EQjZRbi9qSjFDak02TTQyeHB5SFQyVng0?=
 =?utf-8?B?Ty9GWjlYWVlsTCt5QWdhc05HekYrc2ZiUi9pV3JqbmdGVHl5ZDRQVlE1S1Q4?=
 =?utf-8?B?NmdQUE9IaG9PRzBGT2tWanRlOWo3OTRKNGcyRkJGenBycElPdGpseHRUbWNU?=
 =?utf-8?B?ck9QbHFBZkQrYTFrdXYyTWNJUWJKNklCMyt4RWxGSkxkQmhWVWZNUlp4cEhF?=
 =?utf-8?B?Z2JXOEo0NXF0RWFYRmI2YTg2eXo4QzJvYU5uaWtrbzFBOTJLZCtwcmtYc1dN?=
 =?utf-8?B?Q1NQd1IweW1QMTQySTYrV3FDTzdnbzVOK1RPaHM2aVgvT09vRnRqQVpWTUV3?=
 =?utf-8?B?SzJsUHFIYitlazF3SlFEZnY5NG5wcFZ2V09ZWTFFT0x6UlN6YWRGMCswcThM?=
 =?utf-8?B?ZGVnVWdNLzFBaThPOFpUNVRXbUxrNVJaYllLNzA4ZE1TQmlFOWo1bVNWUENZ?=
 =?utf-8?B?L2RodkI1R2t6dkd1dWd1NzBHdXo4VUIraHlhZzVOdEVWVjdvR2t5YUhsK0dI?=
 =?utf-8?B?TTNXN1lpQlhSR2szYTQ1UW85MERDdlcvMTRsOTk0anRDNzhmR25TM0xsR09q?=
 =?utf-8?B?R05FMnBqL3ZONFU4YW9QR05kN0N0Y1lKY01LZWRkdE9WejJMdmVCNTJTMmpV?=
 =?utf-8?Q?8aLCyLr6s3tSDGzNgTks9vDYIXpuTDgyv6ecJMl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b610b9ba-0305-4053-c117-08d9104f80c3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 05:26:30.0221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xlz2tZ9tC2LsuXnUHcDQHSDwrTGNTVJPxnVC4lch7nyQhLKiRvpKf4bLPMr5FFOL/1S/sadmR9CTHp63bC18EMR29OQnINADF1M1KbAfPcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3956
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105060035
X-Proofpoint-GUID: GciaVSyfRanuXfJ3KhoFE6DZx7_-9Skq
X-Proofpoint-ORIG-GUID: GciaVSyfRanuXfJ3KhoFE6DZx7_-9Skq
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 spamscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105060035
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/3/21 2:34 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_bmap_rtalloc doesn't handle realtime extent files with extent size
> hints larger than the rt volume's extent size properly, because
> xfs_bmap_extsize_align can adjust the offset/length parameters to try to
> fit the extent size hint.
> 
> Under these conditions, minlen has to be large enough so that any
> allocation returned by xfs_rtallocate_extent will be large enough to
> cover at least one of the blocks that the caller asked for.  If the
> allocation is too short, bmapi_write will return no mapping for the
> requested range, which causes ENOSPC errors in other parts of the
> filesystem.
> 
> Therefore, adjust minlen upwards to fix this.  This can be found by
> running generic/263 (g/127 or g/522) with a realtime extent size hint
> that's larger than the rt volume extent size.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, makes sense.  Thanks for the comments
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_bmap_util.c |   81 +++++++++++++++++++++++++++++++++---------------
>   1 file changed, 56 insertions(+), 25 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index a5e9d7d34023..c9381bf4f04b 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -71,18 +71,23 @@ xfs_zero_extent(
>   #ifdef CONFIG_XFS_RT
>   int
>   xfs_bmap_rtalloc(
> -	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
> +	struct xfs_bmalloca	*ap)
>   {
> -	int		error;		/* error return value */
> -	xfs_mount_t	*mp;		/* mount point structure */
> -	xfs_extlen_t	prod = 0;	/* product factor for allocators */
> -	xfs_extlen_t	mod = 0;	/* product factor for allocators */
> -	xfs_extlen_t	ralen = 0;	/* realtime allocation length */
> -	xfs_extlen_t	align;		/* minimum allocation alignment */
> -	xfs_rtblock_t	rtb;
> +	struct xfs_mount	*mp = ap->ip->i_mount;
> +	xfs_fileoff_t		orig_offset = ap->offset;
> +	xfs_rtblock_t		rtb;
> +	xfs_extlen_t		prod = 0;  /* product factor for allocators */
> +	xfs_extlen_t		mod = 0;   /* product factor for allocators */
> +	xfs_extlen_t		ralen = 0; /* realtime allocation length */
> +	xfs_extlen_t		align;     /* minimum allocation alignment */
> +	xfs_extlen_t		orig_length = ap->length;
> +	xfs_extlen_t		minlen = mp->m_sb.sb_rextsize;
> +	xfs_extlen_t		raminlen;
> +	bool			rtlocked = false;
> +	int			error;
>   
> -	mp = ap->ip->i_mount;
>   	align = xfs_get_extsz_hint(ap->ip);
> +retry:
>   	prod = align / mp->m_sb.sb_rextsize;
>   	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
>   					align, 1, ap->eof, 0,
> @@ -92,6 +97,15 @@ xfs_bmap_rtalloc(
>   	ASSERT(ap->length);
>   	ASSERT(ap->length % mp->m_sb.sb_rextsize == 0);
>   
> +	/*
> +	 * If we shifted the file offset downward to satisfy an extent size
> +	 * hint, increase minlen by that amount so that the allocator won't
> +	 * give us an allocation that's too short to cover at least one of the
> +	 * blocks that the caller asked for.
> +	 */
> +	if (ap->offset != orig_offset)
> +		minlen += orig_offset - ap->offset;
> +
>   	/*
>   	 * If the offset & length are not perfectly aligned
>   	 * then kill prod, it will just get us in trouble.
> @@ -116,10 +130,13 @@ xfs_bmap_rtalloc(
>   	/*
>   	 * Lock out modifications to both the RT bitmap and summary inodes
>   	 */
> -	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
> -	xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> -	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
> -	xfs_trans_ijoin(ap->tp, mp->m_rsumip, XFS_ILOCK_EXCL);
> +	if (!rtlocked) {
> +		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL|XFS_ILOCK_RTBITMAP);
> +		xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> +		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL|XFS_ILOCK_RTSUM);
> +		xfs_trans_ijoin(ap->tp, mp->m_rsumip, XFS_ILOCK_EXCL);
> +		rtlocked = true;
> +	}
>   
>   	/*
>   	 * If it's an allocation to an empty file at offset 0,
> @@ -144,30 +161,44 @@ xfs_bmap_rtalloc(
>   	do_div(ap->blkno, mp->m_sb.sb_rextsize);
>   	rtb = ap->blkno;
>   	ap->length = ralen;
> -	error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1, ap->length,
> -				&ralen, ap->wasdel, prod, &rtb);
> +	raminlen = max_t(xfs_extlen_t, 1, minlen / mp->m_sb.sb_rextsize);
> +	error = xfs_rtallocate_extent(ap->tp, ap->blkno, raminlen, ap->length,
> +			&ralen, ap->wasdel, prod, &rtb);
>   	if (error)
>   		return error;
>   
> -	ap->blkno = rtb;
> -	if (ap->blkno != NULLFSBLOCK) {
> -		ap->blkno *= mp->m_sb.sb_rextsize;
> -		ralen *= mp->m_sb.sb_rextsize;
> -		ap->length = ralen;
> -		ap->ip->i_nblocks += ralen;
> +	if (rtb != NULLRTBLOCK) {
> +		ap->blkno = rtb * mp->m_sb.sb_rextsize;
> +		ap->length = ralen * mp->m_sb.sb_rextsize;
> +		ap->ip->i_nblocks += ap->length;
>   		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
>   		if (ap->wasdel)
> -			ap->ip->i_delayed_blks -= ralen;
> +			ap->ip->i_delayed_blks -= ap->length;
>   		/*
>   		 * Adjust the disk quota also. This was reserved
>   		 * earlier.
>   		 */
>   		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
>   			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
> -					XFS_TRANS_DQ_RTBCOUNT, (long) ralen);
> -	} else {
> -		ap->length = 0;
> +					XFS_TRANS_DQ_RTBCOUNT, ap->length);
> +		return 0;
>   	}
> +
> +	if (align > mp->m_sb.sb_rextsize) {
> +		/*
> +		 * We previously enlarged the request length to try to satisfy
> +		 * an extent size hint.  The allocator didn't return anything,
> +		 * so reset the parameters to the original values and try again
> +		 * without alignment criteria.
> +		 */
> +		ap->offset = orig_offset;
> +		ap->length = orig_length;
> +		minlen = align = mp->m_sb.sb_rextsize;
> +		goto retry;
> +	}
> +
> +	ap->blkno = NULLFSBLOCK;
> +	ap->length = 0;
>   	return 0;
>   }
>   #endif /* CONFIG_XFS_RT */
> 
