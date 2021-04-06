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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A47CEC433B4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 20:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 734DA61394
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 20:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhDFUIy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 16:08:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56118 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbhDFUIy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 16:08:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 136K4KfY112335;
        Tue, 6 Apr 2021 20:08:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=lwKv3algULW5bt8u3PXtXStjWrrvQX5gJEVPmn96sCU=;
 b=S9Sy+yfXkjXGjpBQVnP726rvDTfJkaNw5ExVnwyyXdfxZ8r+wO5JFAegmw8mpkEE0+UQ
 QREfC5XK0cSSOEedFEl5y1C2kGORK7gve411pzdMf8zbXa/lyVnfPOWuryb6z6aQ9OMf
 rrqXyelJ3eBcN18T6CvqsYwVYoaHudLMpY5EzHQ80XFSebCAA0YSMahLJUywMKneWxLw
 EWTYn6cR85i5nKMHV4WHI42gsGIvbZVTIzrYs7bUXn423nZfadACy9092XZR8+KNYUVS
 wNsXVJP/rH/RwQlZKaDvc+gcD/DVstW5FFp8orpQ6Ha0KJYtRT98bBIwSJPi+QLtGUpd Ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37rvag8d3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 20:08:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 136K02Ac103323;
        Tue, 6 Apr 2021 20:08:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3030.oracle.com with ESMTP id 37rvbdvqvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 20:08:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsrKq7CvZJdXKzQEkLzTMdjuKD8uO0GnisVnOGmOtWiT8yqYttPZixbfjQZSWFJe4bh2SE6AajE2IeCPaC4iGeeJWWtJGw8PaRGj4lGSlSSnokFqJnFCMDOjUlSlmGqWhXhP6IKt3R2hmcUh91YkOIovJxjW2CanZIaIXFjhRWyehAElv+eWAdgyQDl8n+4+z0lRcILw0P4WfATcpOdUC09SdxQO+NJ0SY1/hg687LXiqUmfbH8/yJFvKLS3/eM4A2IhdBriyBJCEMcPn/Mbg3+qzMq2aj0YpBlS0K39OQ3AE/HhQrf5Mo5xp05jAj59tcZZpFPKauVeWuIQFge7RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwKv3algULW5bt8u3PXtXStjWrrvQX5gJEVPmn96sCU=;
 b=iKgupcj2+qQOq2gyMiemWMoJhhkWx3dpQPEVWDxsGUfa6bPC5+3lNzTjVm0LfuhwpU0aktMYvE3L7Mxd9HF/O32Ae12FLkbGLXUbLeky+Tyx/orl9j75isTros61HJK4+99BzY9qbSeAM3eShANDkH79aeqazhPMTIO1Dl4ILyiTzTrsaon0k5+63QNeaWQi4s/pxJNx/JYLY4kNJAyABfM50D29hqMkp1QkOcWwK5PkrVv5Do82O+BsGWOlWVUn8HFF9gkeclN0EfxVXkBSIrwg7Dbd524ylU7H51975XJhdV+8Jv9ArRAwdcLYKs4u7FWZjIbu9axhC8juxftlCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwKv3algULW5bt8u3PXtXStjWrrvQX5gJEVPmn96sCU=;
 b=BOAdZpZ170QXwFjN2AvhQ6vVcJeqtkyaxhBZF+SGXfwOlAORtczGfsi2Pv3UC1c85o4KYdAio91nP6CQgYUBhBNjEAaQBWyGCfi/3zzxSuT4VPuaD5bRAIH7lAtTmv5UIq0FSAWU8cNob4lypfaLG8wlALRBul5m+FKN9e3Edi8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2519.namprd10.prod.outlook.com (2603:10b6:a02:b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Tue, 6 Apr
 2021 20:08:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4020.016; Tue, 6 Apr 2021
 20:08:42 +0000
Subject: Re: [PATCH 4/4] xfs: precalculate default inode attribute offset
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210406115923.1738753-1-david@fromorbit.com>
 <20210406115923.1738753-5-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <b2af530a-c1a3-3e73-910f-44754ee3792b@oracle.com>
Date:   Tue, 6 Apr 2021 13:08:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210406115923.1738753-5-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0175.namprd05.prod.outlook.com
 (2603:10b6:a03:339::30) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0175.namprd05.prod.outlook.com (2603:10b6:a03:339::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Tue, 6 Apr 2021 20:08:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f9a266d-3737-40ce-f900-08d8f937c675
X-MS-TrafficTypeDiagnostic: BYAPR10MB2519:
X-Microsoft-Antispam-PRVS: <BYAPR10MB251996BFA58A4516E015318095769@BYAPR10MB2519.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Q31IeZlj7ncMcyuknb7K7pA/e2yYwRzgkAppnP6XXAdnNGLwkHl/i99Wa1yDQ6IaqVFF+D9p2m4teFjftPlRxyk36X4se1pue6XT/cG6P0VLbl/yMFahiDRN+pDLh65OQxcBvQ5h5lgQ1kSnfrciOYjyFscQWuD8Zs7hvQ/kKtB89gJwNu7lImQbREco3EFjyWynTivs1oS5nINvyoWhTkvbZd5KlJ//YOe3T6mj3GJFkyLdAl3KZMxKMVlJbfGl90gMv5fyjMdBUG2ssuAU1+ajV4Mz8JD/KuPaVkQvG7f5ZFontCb677NbVl4QRK7WAIjIsIn+/qKYifAnOUYoSceCB8VEu4r7es/2Uq5JIBOA5BkerO+Mv7Ej43Y0lHoEn/W2wsNrF1k3PR+eVepsqRJa+TCuPhi5GeC4wFo94cui+TZG8ikMBcKoHIvab5ye0KBlOdR6U4Qr55UUD9EinnyjU1VKaoB5BXhl5Hw8CPHxbd111M1BS9ykm49A3SleXsWMBV6TVF66FKy2oHoCCC7oJuJB7JEjhFNBTXpq4LEsYEmaKCkJEsqBTpw8Bmaj1FgtaXn1YY0guv52ht6guMvluNKvdQZDDrAwcGAzBPSseD9FnMhX85TssZYakZDfPdyzrDku0XABj1DcPVt5ux/vffMqabN36tvJBEFoYo3wDT+/FOln/gVKQ8J9Z84UhCvB++t0sGqvNjvlF3w0IWKhd8sYRbWgXqqyiPsgnQY+SKgI7EoifGvba+Li3nB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(2616005)(66476007)(36756003)(26005)(8676002)(86362001)(52116002)(6486002)(66556008)(2906002)(31696002)(478600001)(8936002)(16576012)(316002)(956004)(38100700001)(31686004)(66946007)(186003)(53546011)(83380400001)(5660300002)(44832011)(16526019)(38350700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MGFVSlFRbUNmVVh0dmtoUUpNWExOQVlSNkgvMjN6MUZYUkE4clgrK2p2cVRD?=
 =?utf-8?B?NE9RR3EyWTNiY05vR3ZvTVFGRlJMNmpCR2ROcjk5MnMvWDFEL1lwY2FMRVhs?=
 =?utf-8?B?UkVKc1lnODV2enFyTStNNkk0Z3c5OHlVeG5VL2RSMCtHK2xkMFBveHh1alpL?=
 =?utf-8?B?Z2diVTYyRUZ4YVJjUVBaRmNwM0ZRb2FhRGpjVThhSFcwZlY0NFY4aG5GeENF?=
 =?utf-8?B?U3V4aFI0MHQzUFJQOHNmNlpQUXJjVTF3ZUFFYkk0TkpDMzFrNmZaT0Y0bFRR?=
 =?utf-8?B?aWdLbnJtRWNnVFg0SE1HSStGeUprbldHVXgvMlNrakJMazREN3kzaUxLcFVE?=
 =?utf-8?B?a1hZYmdKWkZoWFdXMndMNU44U2xYaVU2OHd4Y3NDNmM4MEdJUVdURExsaFVN?=
 =?utf-8?B?L2xid3ArNTlEeTl4cEFMZ1ppbG1tLzFUVjQ2dStMTkpBRnlSUzVDTGVNckl0?=
 =?utf-8?B?aFdOSmdNL0gxdEJnSDl5RENRc3pXSFZVMzIyOFVjYUplLzQrKyt2YXprMU1w?=
 =?utf-8?B?V0xOSmRDOC8rT0Z5bVdEd1pJcHE3WVNYbEI1VURUMm1zaHhJL1VNQ2Jocmwy?=
 =?utf-8?B?MnF1M3RwT0E2T1c2V2xwZVdMa00xYThTc0hSYTBmL0JobXJYRmdvZzc2ZHk1?=
 =?utf-8?B?d2VaSUtnR1lYRGtMSGhYSVFVVEtOcDl2WGhqbjVtcHhvbFBLNmdMMlpoQjJF?=
 =?utf-8?B?dm1lUDc3RUlwZzZUczVKNSsyc0dEcE1qWmdkVHRLaUVWUGZ2Z242dDZwTjN6?=
 =?utf-8?B?cDRDa2hCU0ZyakhaK0U5K0hidldxaytXdXBCQjk2VllJRWN0c2I1WjhSUElC?=
 =?utf-8?B?TUtEOGFsbmdNYWJJSEtNdjRmUk9ZckpkNVRUdjlmQmNFWkJRNStuaXF5aEhP?=
 =?utf-8?B?SVJNcjA3TVZaNUJlVmozMUlhWURYVjN3MllKSWtGa0tEcGF4WjAxNUZON2Rm?=
 =?utf-8?B?cXZuZ0RXaWI2VlUya3J4YXVUWnlFOUJHSVFhS2VaaGFJeFk1MTQwY3NkaXBR?=
 =?utf-8?B?T0p0Y0wxeDNQUjNySEFwams2d2tWWThhN3N2Y1lTTGZFejlLNUtSOEFNbExM?=
 =?utf-8?B?dUVnZnB2OUREdUgrVXNJSmxzRUp6RlhEM1dXZ3hHSWZzTFIxR01UOGwrTXpN?=
 =?utf-8?B?REJJNzcrVjMvR1VOempkUElyeld1azJWaklvMGNvTHBIdkFVRnVGRXhHdHls?=
 =?utf-8?B?Qm51WGJIZlQyWHI0MCtydW5nYmNLYmZlS1JFK3BPRFE4cmVnRVVWcEdhNTZT?=
 =?utf-8?B?Rk4vdnRiRFhCalFDWE1xdG1vNmFCSi85Y1lISTVtRDEwTEZkVEN5M1kvMGpT?=
 =?utf-8?B?cFN3VFRMWFYwbDVIWmwySTRuMHl0MnlxTlV2QUdGR1gvZHJLM3QvR3FaUUxO?=
 =?utf-8?B?SWc2aUlEMG5LakZNUVBqS2hJQWFLYnVaVStsSkVUSHVrcUNSNmJNalRVb3VB?=
 =?utf-8?B?SVZkNko4QkRTTVY4andDeEZpUlR3VW50V3BYcUd0OXhvaGpXK3RxQ0wvdmgw?=
 =?utf-8?B?UmgvR1ZUSitFMnp0OS9WTEZ2ZEJnUzJHSzhKZTgwS29oZ3BXWFhrL3oxRXFk?=
 =?utf-8?B?czRjaG9xcnU3UHp5RzY4YklWaVZzQjQxdHRILzNsS3lNeHNpYVEvUFE0cDVq?=
 =?utf-8?B?eEZLenRSTDAyVW9pTndPYU9RcmFTWmdZbXE5UHZRZS9Pbjk0UnQzamtBOFgr?=
 =?utf-8?B?amFBdmUrMm83RDV6QmNvZkE1ZFNaelUwcWp0alZTVGV4S3NKMDA2VStod05k?=
 =?utf-8?Q?d56nPM0CXRXP3tg3OQ9joNwUUOy4YnvUlleZxE/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9a266d-3737-40ce-f900-08d8f937c675
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 20:08:42.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yps3iyGDIX4w/GoqtBPNDnhwhYfVsERQT1zJ7fdec3ebOTEIjVgcXl/I++KVjQvtAKO8fdLRGP6TZZ2BiK6a3D+N7WRP+KmGwaC7sjMAwFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2519
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104060136
X-Proofpoint-GUID: SEoGn9cuAQ_wdYpGN2ex0n8rdl89ZP_B
X-Proofpoint-ORIG-GUID: SEoGn9cuAQ_wdYpGN2ex0n8rdl89ZP_B
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 spamscore=0 phishscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104060136
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/6/21 4:59 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Default attr fork offset is based on inode size, so is a fixed
> geometry parameter of the inode. Move it to the xfs_ino_geometry
> structure and stop calculating it on every call to
> xfs_default_attroffset().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_bmap.c   | 21 ++++++++++-----------
>   fs/xfs/libxfs/xfs_bmap.h   |  1 +
>   fs/xfs/libxfs/xfs_shared.h |  4 ++++
>   fs/xfs/xfs_mount.c         | 14 +++++++++++++-
>   4 files changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 414882ebcc8e..f937d3f05bc7 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -94,6 +94,15 @@ xfs_bmap_compute_maxlevels(
>   	mp->m_bm_maxlevels[whichfork] = level;
>   }
>   
> +unsigned int
> +xfs_bmap_compute_attr_offset(
> +	struct xfs_mount	*mp)
> +{
> +	if (mp->m_sb.sb_inodesize == 256)
> +		return XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
> +	return XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
> +}
> +
>   STATIC int				/* error */
>   xfs_bmbt_lookup_eq(
>   	struct xfs_btree_cur	*cur,
> @@ -192,19 +201,9 @@ uint
>   xfs_default_attroffset(
>   	struct xfs_inode	*ip)
>   {
> -	struct xfs_mount	*mp = ip->i_mount;
> -	uint			offset;
> -
>   	if (ip->i_df.if_format == XFS_DINODE_FMT_DEV)
>   		return roundup(sizeof(xfs_dev_t), 8);
> -
> -	if (mp->m_sb.sb_inodesize == 256)
> -		offset = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
> -	else
> -		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
> -
> -	ASSERT(offset < XFS_LITINO(mp));
> -	return offset;
> +	return M_IGEO(ip->i_mount)->attr_fork_offset;
>   }
>   
>   /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 6747e97a7949..a49df4092c30 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -185,6 +185,7 @@ static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
>   
>   void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
>   		xfs_filblks_t len);
> +unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
>   int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
>   int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
>   void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 8c61a461bf7b..782fdd08f759 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -176,8 +176,12 @@ struct xfs_ino_geometry {
>   
>   	unsigned int	agino_log;	/* #bits for agino in inum */
>   
> +	/* precomputed default inode attribute fork offset */
> +	unsigned int	attr_fork_offset;
> +
>   	/* precomputed value for di_flags2 */
>   	uint64_t	new_diflags2;
> +
>   };
>   
>   #endif /* __XFS_SHARED_H__ */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 1c97b155a8ee..cb1e2c4702c3 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -675,6 +675,18 @@ xfs_unmount_flush_inodes(
>   	xfs_health_unmount(mp);
>   }
>   
> +static void
> +xfs_mount_setup_inode_geom(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_ino_geometry *igeo = M_IGEO(mp);
> +
> +	igeo->attr_fork_offset = xfs_bmap_compute_attr_offset(mp);
> +	ASSERT(igeo->attr_fork_offset < XFS_LITINO(mp));
> +
> +	xfs_ialloc_setup_geometry(mp);
> +}
> +
>   /*
>    * This function does the following on an initial mount of a file system:
>    *	- reads the superblock from disk and init the mount struct
> @@ -758,7 +770,7 @@ xfs_mountfs(
>   	xfs_alloc_compute_maxlevels(mp);
>   	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
>   	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
> -	xfs_ialloc_setup_geometry(mp);
> +	xfs_mount_setup_inode_geom(mp);
>   	xfs_rmapbt_compute_maxlevels(mp);
>   	xfs_refcountbt_compute_maxlevels(mp);
>   
> 
