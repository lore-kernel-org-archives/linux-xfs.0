Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA10EC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356331AbiD0AhF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242692AbiD0AhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:37:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552AB35242
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:33:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QMZEGJ032179;
        Wed, 27 Apr 2022 00:33:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=JROn7ZjpLvh+UFudjAWedcJY0D51JWuhg0bIr/Gza4s=;
 b=YbHTXYcTmHaAhvpprbnWeV+HkOqMy0HObpl8BUjnRRu3av59ddVBgGM/u1qRtOdIiTPX
 6nFE+ppiM598mlNxxiyEmd9Q/tEs39asuzMg4XqwJbNJiAsD5ICdPfT9UA1Ap+7R9Gqr
 k1vfF16dttd0cG6yq1ksWa5aU0cgvjfSTjmDdnf8Jxh7qcdKQsO5o6gJ4nO9ot0hTYcJ
 ou1BjMBS/O7vSrRLcddBSUnnSBOOlYWMlpfxYq1q8zFRvC0g8Y5r5YLsi1dti2K1Nw5l
 2bs705K54HVtQ8oxvcc9J0lEQP39KpKclbkaWXWJzLQeU2Gig+Ddloq73O2SgLX/+G9X GA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb0yyb5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 00:33:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23R0V6n4003597;
        Wed, 27 Apr 2022 00:33:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w3ws58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 00:33:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOwq1oNxZhAWWW5kjSs6gAdjK3MLrkfjNEuRbQiYEPtrx/Zwo0A/sXmmk/8wlCx/gB9skuRgWntQ9NYceo2ChfhXEjslXd927qOqjp+Qdt7QN8yCxGc4KZjwKWvl0WSDBGi/7TqVMGBq/YU8mqCNNtAmpOpHuN+bzo6zm1czRbWulZzom3HWLB0alLBDit8IwWMaPMFeJh3qlIlJxZ5ARK4O7Rtesc8+WSTgGYtBXkJD/SQwKdE6rItiRzBSBL87qB1UKp42ALbTJPKyhJl59gGDBe2jUKk4Ajw5j+Hm+Xy2l+MTj2c9pDwRfwhoiCZhdiYONaKluW/LCVxBroby7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JROn7ZjpLvh+UFudjAWedcJY0D51JWuhg0bIr/Gza4s=;
 b=HnWjqntm7uh9NXtN7GCPpTFmsANxBI5kZUoJlU6FYnpmWvP65IaJnMWhSHGo9hrt3/vXFFOiVbJh7BFTPlLRz4WL8ahWXmhNVyEZUC2cc7ylcitMZ49d5emYvGrCPSAgu7wbnY25Cwe6/sgGud+j8K9nvgnguWu/86hniDLBlSpbp/4EbqcIky65S8f1cgPMgaBje5a6jpj6UEj/bJ48kJn1vZJKMy8dCfDcNSaYCAvMWmp+/EAMDiiMlaoYm6mu38qDDNoBlWwh/RSZS58qdDSABmXRTp7EQdZmolQaz+SuVX+QzU19Kt34h6dYXannKSp/N/t2pas4TW3QAbMQKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JROn7ZjpLvh+UFudjAWedcJY0D51JWuhg0bIr/Gza4s=;
 b=mw0xWgrF5S+pnrFVEZqZXChA6HqOmEtWSO9gRFObExev+cjAetdQxo1729ZXmQB38lrkveUkroDMFrc1ux8RIV/TZekPpMI3g80z8bTzabmDQJP3bZKmz7s3ckACyCuYKUubHff8AYvQBYaajgvJ3Fqv6FW5YU6fz5twvT1Ykrg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CY4PR10MB1767.namprd10.prod.outlook.com (2603:10b6:910:a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 27 Apr
 2022 00:33:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 00:33:50 +0000
Message-ID: <3736445dd10410485028f1683c532f06fdfcf31b.camel@oracle.com>
Subject: Re: [PATCH 12/16] xfs: introduce attr remove initial states into
 xfs_attr_set_iter
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:33:48 -0700
In-Reply-To: <20220414094434.2508781-13-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-13-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a20a949d-f2c2-4413-b7f1-08da27e599be
X-MS-TrafficTypeDiagnostic: CY4PR10MB1767:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1767DB9EE775959A493CD79895FA9@CY4PR10MB1767.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hOqwnskrR9PIIyHJOOJ5F8MnQQ/+wRacl9NlgyPuFiRGDi9/2geigHPnfujuBDv5tzyiNhYiDSspwzlZJFWUh1DYcAg2tLhmP7YDxRgH6Jy+cxNdPbbe3a5VwFRCTP5QG2LrsveQYExiKrQR4XtcTxSppbfQo3eJw4Rf/aSH1QexwvW5lUmalu9Nl7haV2ilW2WnfHJ1wm702XuXdegp5E0saT2t9kjAh8ZPEqUPVSaYQK+jk3tUJWSy3oebZowZCZJT5xaDltexGMqoOeBKzRg3jXrmFrZdBHAbFijbgB29baPUTpFNuoar/nkgFplrBG/8piHk7hOpWLsMJtbB33a/aGe/iOfi8rBACd652TUjcwuBsbKCdwgZkrbR4ovfDOGxQJzEIQdmZ/rPscGK5NkytuE6qeQb5PmkBAW1yE8mncU7iv1tmCgt9RwjyGgOe66ucwskqtUHe6mdAoMqLyZohOgSBiScxYjZ8hwyNMlI/1ciMmoBdoHKaQsOU4lEcVJpZALaBxf5qZQIYyR+UkSGhOOMxNCxScGVy5muCMUwYIiZ3TkUweS2eZpg3ZNjoniB8vNmvhSka0R0brZv9JPr25aPvERzlryqSPIBemvIIaTgTFDqwyBteDGXatpZCxJWbUKU2X2eeBWqcsu6yvmd9e9ys4+kYy9d/6+NpI64a0Ngxfr/acQ58R4dNTtYmsR5OU4OUeFVQOQdWBP/iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(186003)(66476007)(8676002)(36756003)(6506007)(66556008)(26005)(8936002)(316002)(66946007)(6512007)(2616005)(5660300002)(508600001)(6486002)(52116002)(2906002)(86362001)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkhEV3dwRFREcldMZEtNbGxEaW53UmRIeUdFbzNZOFVUT3lGVUpVVkNCdlhs?=
 =?utf-8?B?eFFKbGVVeDhDMUQxaXFjcFdJSEt3Zk9tQ1dJdFg1ZEpvQTZvbUJ5TnFuWTFS?=
 =?utf-8?B?ZWprRkdIQXprVzkzcGFHK0VQWmlLS1ZWMWFjSklTQjVIcytxUS9wbDhnSnVr?=
 =?utf-8?B?M0hGUDQ4L1QxWkVmKzdVcnNRTEhxUlNyaWxEYTFiVnIyQjhrUHc2ZmFtMy81?=
 =?utf-8?B?Q0xpM0xaNVJXTjhoSDJHZm1yVVptcE5sN282L2k4VXJqU3VVOWhkcmpOUXFB?=
 =?utf-8?B?QkNKSGVxUG9ZZ1FqbVFhZy93d281MTNLbURINEZMVFVHZjVFNGxiV3hTVndM?=
 =?utf-8?B?RGhBMFJlVUVsUmdhOEZRdmd0amRIbU5lOEt1ckFPZDlVMnY5OW5haFV3enRC?=
 =?utf-8?B?RVlQMytUQlYzUUNtLytmaDZjVm9hTDVBWS9UNVVjOXhiYi9OSEk4TkRZQW9Z?=
 =?utf-8?B?Yi9FSmxtbW9BMDVGdU5UelROcGo2MUQwZzBNNnY2UHVXdHVDbVNocUFOU3pz?=
 =?utf-8?B?b2x3K0NTeGtTUXBxQUlLQkdtalFZSlZPVEdZMU1EbDgvRU9rQzlSWGJGa0U4?=
 =?utf-8?B?NHhKVGxMN09FekZtQzJIaEFvQnRXTzl0aHlKaVlxS2g5bEFhRXhoY3lYN05R?=
 =?utf-8?B?MkJKbXRBcHpOQWJVSVhFd1pqbENvSUgrK2VIUFo5ZkFEdkZqY1FyQlBSSW9z?=
 =?utf-8?B?U0RVK3NYdG9tK3hGclNqRW4wUGE3OU42WDZTUUlBbGpoaFRkYzMwNXRMakp0?=
 =?utf-8?B?aEphYUw3MDZzSFphMHZ3OHIyYTNNYmprK3JFSmNjbXNlYW1GN21PZmxTUFIw?=
 =?utf-8?B?U2NVd3l1ZitDR3FIYmFIVS82bzBvOVAvbWpibDRiYmNiSzJldnZ0L041cHRT?=
 =?utf-8?B?SWx2L0FmOHFOcUxDWmRiUUxXUXh4M204WWxCMzcyQVlpVmVTMGF6OVJOQzh1?=
 =?utf-8?B?WXhHYnNLRTRWOEMvQzhzQkxvcEtQMnpCcTVWeTJLRDMwUTRNY2tEQlkwaVkr?=
 =?utf-8?B?QjZUbHJxVzgxUDdZSC9UcGpPZFMzZTRPblpMUWhTdkJmNmovZEJ5TVdJL3Rx?=
 =?utf-8?B?eWs5bkVGK1pBaGxnZm1LYURyeWpna29nV1NEZU9xOGFBT3hlUTZxcSs2SWZB?=
 =?utf-8?B?UXRIZ0NpWDFXSWN4ZmE1QXNmQkVybzZvTzM0SEpBTXd6c09uV3ZnYzBCa1RV?=
 =?utf-8?B?RitTT2NJczI5UDFqbHhhZVBGdjBiVGdnalpwRzNhZFFxZDZwUjk2QW55QXNu?=
 =?utf-8?B?cVhEWE5ZbU9aV2RxUHJxS0FvTVgwekhuWlAwTG5mcXFMbk5vOTk0N0tvTlMz?=
 =?utf-8?B?WElPZzQ0R3ZDZksrcFozUi9lRThKN241Mm5VK1owNlpLS0RRVmNhMzZ2cGRp?=
 =?utf-8?B?NitIOGhzRWVXVFdQY05RMVdUVG56a0NSNlpNb21Ndm0rNTdObnJjWGo4Q0Vj?=
 =?utf-8?B?L1ZqNXM5dlpQM2UrZmVuczBzSkJJeWxjaEd5STJkaENDYWRVOVlWY1NldHU1?=
 =?utf-8?B?WGhMWWt3TDhnd2lPRWJsaEJXQ1VNTFNmNElnd0Y3citWWFpwM1hsblZaUFcv?=
 =?utf-8?B?cUpObHBKaHBJYWVEeWRCamRGayt4T1lnNEtmVmN4WGs5bThML1daYXZVam1t?=
 =?utf-8?B?M2VQR2s1NHNpdG9hNStjUTdPeURpeFl6RmY1R1A3MXZPUFFLR3VXSm1sell5?=
 =?utf-8?B?L1BYbWhRZnM5Y2YySS9jaVljVFhsUVUvbkljOXQ3RStVOEc0cCtyekhseGJK?=
 =?utf-8?B?OTlhUmlicS9pemlvOUJtRGs4aVVCS0Z0MVNRbXY2K2hPaTZNRWozekZ6SHhZ?=
 =?utf-8?B?ZFFCbVczR0FKWS9PWWtXVnBLbGc0UjNBV0E2bmJVYlgzZGVuOFYzd1oyQ0tp?=
 =?utf-8?B?T2ZINFJlZjUxNHpvT3Ywdk5wT2tGb1ZtamdKUnk5czc5R1pxWkxVZklMT0ww?=
 =?utf-8?B?M2krelpLdWYxY2dIV09GU0hRN1UrQWJBRGVYTGtMTGkxa3FoSTlPaXlFU2VG?=
 =?utf-8?B?RFJsc3dCcDU4MjdxRmtSbHRBRHdSSEZaamZoRVZycEFvQnlEaHhJRTl2MnBo?=
 =?utf-8?B?aGlHTkdTYnZJMjVEd29iY3F0bjY2RTM3ZU90dEdFNXhrbHlBTW84bHkvZ05r?=
 =?utf-8?B?VU56UVROL2lIaXdkeUhweFNYYzc5VkJyU0YxRHRRZ1I4ekdlZ2ZveXNLdld5?=
 =?utf-8?B?cmYwek9WMDl2YXA0cjVCUUsvTnVIbVdwN1F6M2VqRE1jVnBwY1ZBK2hSa2dm?=
 =?utf-8?B?QmpxWFhNd1pWLzRaWWR5b3llUzB6RXVVY3BXY255U1krZmozSVNTdVFYYTdt?=
 =?utf-8?B?MXRxT3ZKckJNNVpxVEY1cVh0Z1M4Sks0MjZiOEpHSnlWN0dzOFR5QjBkTVRL?=
 =?utf-8?Q?+/IJPFSMXgqtVyzY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a20a949d-f2c2-4413-b7f1-08da27e599be
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 00:33:50.8485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgUeh+XcKpkl5n87QKeB2fusZb3RMeoffnZ+rIPC0Y1K2GKopLE/TgI2Xz69QlRSs6hzK3XcN8Elo/c0RqaYHWHihd17kYPy22Y2PvWlvJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1767
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_06:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204270001
X-Proofpoint-ORIG-GUID: qAZGPKvFQnzvGWt6pfN9Bj5ZII9dGhVu
X-Proofpoint-GUID: qAZGPKvFQnzvGWt6pfN9Bj5ZII9dGhVu
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Ground work to enable safe recovery of replace operations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 139 ++++++++++++++++++++++---------------
> --
>  fs/xfs/libxfs/xfs_attr.h |   4 ++
>  fs/xfs/xfs_trace.h       |   3 +
>  3 files changed, 84 insertions(+), 62 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a509c998e781..8665b74ddfaf 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -459,6 +459,68 @@ xfs_attr_rmtval_alloc(
>  	return error;
>  }
>  
> +/*
> + * Mark an attribute entry INCOMPLETE and save pointers to the
> relevant buffers
> + * for later deletion of the entry.
> + */
> +static int
> +xfs_attr_leaf_mark_incomplete(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	int			error;
> +
> +	/*
> +	 * Fill in disk block numbers in the state structure
> +	 * so that we can get the buffers back after we commit
> +	 * several transactions in the following calls.
> +	 */
> +	error = xfs_attr_fillstate(state);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Mark the attribute as INCOMPLETE
> +	 */
> +	return xfs_attr3_leaf_setflag(args);
> +}
> +
> +/*
> + * Initial setup for xfs_attr_node_removename.  Make sure the attr
> is there and
> + * the blocks are valid.  Attr keys with remote blocks will be
> marked
> + * incomplete.
> + */
> +static
> +int xfs_attr_node_removename_setup(
> +	struct xfs_attr_item		*attr)
> +{
> +	struct xfs_da_args		*args = attr->xattri_da_args;
> +	struct xfs_da_state		**state = &attr-
> >xattri_da_state;
> +	int				error;
> +
> +	error = xfs_attr_node_hasname(args, state);
> +	if (error != -EEXIST)
> +		goto out;
> +	error = 0;
> +
> +	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp !=
> NULL);
> +	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
> +		XFS_ATTR_LEAF_MAGIC);
> +
> +	if (args->rmtblkno > 0) {
> +		error = xfs_attr_leaf_mark_incomplete(args, *state);
> +		if (error)
> +			goto out;
> +
> +		error = xfs_attr_rmtval_invalidate(args);
> +	}
> +out:
> +	if (error)
> +		xfs_da_state_free(*state);
> +
> +	return error;
> +}
> +
>  /*
>   * Remove the original attr we have just replaced. This is dependent
> on the
>   * original lookup and insert placing the old attr in args-
> >blkno/args->index
> @@ -517,6 +579,21 @@ xfs_attr_set_iter(
>  	case XFS_DAS_NODE_ADD:
>  		return xfs_attr_node_addname(attr);
>  
> +	case XFS_DAS_SF_REMOVE:
> +		attr->xattri_dela_state = XFS_DAS_DONE;
> +		return xfs_attr_sf_removename(args);
> +	case XFS_DAS_LEAF_REMOVE:
> +		attr->xattri_dela_state = XFS_DAS_DONE;
> +		return xfs_attr_leaf_removename(args);
> +	case XFS_DAS_NODE_REMOVE:
> +		error = xfs_attr_node_removename_setup(attr);
> +		if (error)
> +			return error;
> +		attr->xattri_dela_state = XFS_DAS_NODE_REMOVE_RMT;
> +		if (args->rmtblkno == 0)
> +			attr->xattri_dela_state++;
> +		break;
> +
Ok... it took me a little bit to understand why this was here, but it
makes sense after having skipped ahead to the next patch.  We're combining the add/remove code paths to better manage rename for journal replays.  Probably just add a blurb at the top?

"We need to merge the add and remove code paths to enable safe recovery
of replace operations.  Hoist the initial remove states from
xfs_attr_remove_iter into xfs_attr_set_iter.  We will make use of them
in the next patches."

I think the rest looks ok though.
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>


>  	case XFS_DAS_LEAF_SET_RMT:
>  	case XFS_DAS_NODE_SET_RMT:
>  		error = xfs_attr_rmtval_find_space(attr);
> @@ -1334,68 +1411,6 @@ xfs_attr_node_shrink(
>  	return error;
>  }
>  
> -/*
> - * Mark an attribute entry INCOMPLETE and save pointers to the
> relevant buffers
> - * for later deletion of the entry.
> - */
> -STATIC int
> -xfs_attr_leaf_mark_incomplete(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state	*state)
> -{
> -	int			error;
> -
> -	/*
> -	 * Fill in disk block numbers in the state structure
> -	 * so that we can get the buffers back after we commit
> -	 * several transactions in the following calls.
> -	 */
> -	error = xfs_attr_fillstate(state);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Mark the attribute as INCOMPLETE
> -	 */
> -	return xfs_attr3_leaf_setflag(args);
> -}
> -
> -/*
> - * Initial setup for xfs_attr_node_removename.  Make sure the attr
> is there and
> - * the blocks are valid.  Attr keys with remote blocks will be
> marked
> - * incomplete.
> - */
> -STATIC
> -int xfs_attr_node_removename_setup(
> -	struct xfs_attr_item		*attr)
> -{
> -	struct xfs_da_args		*args = attr->xattri_da_args;
> -	struct xfs_da_state		**state = &attr-
> >xattri_da_state;
> -	int				error;
> -
> -	error = xfs_attr_node_hasname(args, state);
> -	if (error != -EEXIST)
> -		goto out;
> -	error = 0;
> -
> -	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp !=
> NULL);
> -	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
> -		XFS_ATTR_LEAF_MAGIC);
> -
> -	if (args->rmtblkno > 0) {
> -		error = xfs_attr_leaf_mark_incomplete(args, *state);
> -		if (error)
> -			goto out;
> -
> -		error = xfs_attr_rmtval_invalidate(args);
> -	}
> -out:
> -	if (error)
> -		xfs_da_state_free(*state);
> -
> -	return error;
> -}
> -
>  STATIC int
>  xfs_attr_node_removename(
>  	struct xfs_da_args	*args,
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index f4f78d841857..e4b11ac243d7 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -451,6 +451,10 @@ enum xfs_delattr_state {
>  	XFS_DAS_RM_NAME,		/* Remove attr name */
>  	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree
> */
>  
> +	XFS_DAS_SF_REMOVE,		/* Initial shortform set iter
> state */
> +	XFS_DAS_LEAF_REMOVE,		/* Initial leaf form set iter
> state */
> +	XFS_DAS_NODE_REMOVE,		/* Initial node form set iter
> state */
> +
>  	/* Leaf state set/replace sequence */
>  	XFS_DAS_LEAF_SET_RMT,		/* set a remote xattr from a
> leaf */
>  	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote
> blocks */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 3a215d298e62..c85bab6215e1 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4105,6 +4105,9 @@ TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
>  TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
>  TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
> +TRACE_DEFINE_ENUM(XFS_DAS_SF_REMOVE);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_SET_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REPLACE);

