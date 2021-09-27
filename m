Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B73C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 20:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9BD960EE0
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 20:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbhI0U2M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 16:28:12 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45012 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233460AbhI0U2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 16:28:11 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RKGFe3032546;
        Mon, 27 Sep 2021 20:26:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ruRz8qc+63rwLm6tGazvkLhV28CwUtQoCzFy0CH7MSY=;
 b=NM0GvdA4F/fes4dOCjkeCMDH1hLbvOgRKoYNahe/B9ZXpbkWUVeQ8Bco5Jzlj1EJDOEG
 KOf5mDlkpd36D8bPZAJQJp+WJe44Y4o51JRAGlkC5La/TtdTHsB8mvGtOxpyBJJemrdy
 jOgud7pRM4o7fd0+RUuYTOnhzfrlDGSFuv+bBQQZMUNGPyb4grtl0XGXZyi+G3JBiPw4
 p2tsDCglxWFS/UFnny5Fd9LCQ8SvbA494stfICIAvARu/KUGHmaLZq1Fjzj1of727BgB
 yda85X0zoMpVFb2yttXNnTzK3oXeKKRc4atF5NzrOD4tmDjiHmoWy4ewpogK3/fDaKgp vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbh6nj2ur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 20:26:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18RKQJc2071451;
        Mon, 27 Sep 2021 20:26:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3020.oracle.com with ESMTP id 3badhrk1nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Sep 2021 20:26:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYNYKA2PmVn/0F23bfO26cfGk8sRpJ9cf0lPz5kbe5bJRN05cni2tq9V4HDvSykIC6fzpIzoAwuJ3WKePEpJVnn2xATNsZ9OYOo4/HE9Vf1M221uHf3jZebq6hO87Z4POd9aFVMCIKB9dCk5xpykkKPJ8S56LtIPdvsgt5NDtDYkwP+BaC4Xf7Zh5XZdQhfHhFcQxIv8An4U/rUbJDB60IgOoQgwfEeLaZ4lbMVRiaUBmBo6e4Q2fPBXfzqP6uDlxEa2p6F3+ZAgbaYQZFBlQlAYAP3j33rA1TFHn+TNJppJTvq6X5sSgqAwUUH5jOjmzH0dYSvPywyZntM94xJE/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ruRz8qc+63rwLm6tGazvkLhV28CwUtQoCzFy0CH7MSY=;
 b=Iv2VZ3Mfn27aJXNqnQ/cvKCXLgsUzwfgMq1FCD2zhjiJP2O/M95S7YwcK+FDJhzF2lZDyPSURN9TpxO9wNyaQgNaQaut1p0Q2WkcAFeaHCwFZ43a+S4p0+gFxeryY9pR3KF7z3forAl/a7N/pNKT4/axe08LuZ2pc5nlbqZSjxTQnSludPPWs7MtWwKaTXOXfBf13POYIJ+gBQ55jvCta2eJB7nin4e0yKsPEhEltdz/sVBUGjvk4IA1tgnpDDcH/Zlws8/6wNGvort9Kv6wCYIkLOoHulWZK7YOXu0JDC2kf3EwR+CQgDxjtZINkGKtJkf5+yIDbyllN+iSs/BnZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruRz8qc+63rwLm6tGazvkLhV28CwUtQoCzFy0CH7MSY=;
 b=icazg+7fzKeuFRvd90GBFf3jHELcKjiSB7bjUbMcNC9ZuhT1SoJDYMA+4dkAsZxxivVPXwtaXfbKTvLfVb1TiDTcADJOM0BbxmfJ4f/9FGRmYLA4pUofErNLCq6YkO7ICYjZ6gsf7IztiTWXW5LsLXxIjW+v35pgAdytg47Eyy8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4387.namprd10.prod.outlook.com (2603:10b6:a03:211::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 20:26:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd%6]) with mapi id 15.20.4544.022; Mon, 27 Sep 2021
 20:26:27 +0000
Subject: Re: [PATCH 2/2] xfs: port the defer ops capture and continue to
 resource capture
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <163192863018.417887.1729794799105892028.stgit@magnolia>
 <163192864113.417887.5635394728171508101.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6c289144-5839-4a05-19bb-86fcf09ed135@oracle.com>
Date:   Mon, 27 Sep 2021 13:26:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <163192864113.417887.5635394728171508101.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0046.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by SJ0PR13CA0046.namprd13.prod.outlook.com (2603:10b6:a03:2c2::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Mon, 27 Sep 2021 20:26:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4f28b15-1968-426f-63c4-08d981f51534
X-MS-TrafficTypeDiagnostic: BY5PR10MB4387:
X-Microsoft-Antispam-PRVS: <BY5PR10MB43870C67942587665504A61295A79@BY5PR10MB4387.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n14L61f6SpiiIk/lo41aacNepF52p3zYXqQqenvAVQzk6yRzmJG1MIE2/pdx7qFet6hkil5El1kgBWyUuOOle+l8G/mtS2cNvsT1shyTtgVCzFCzd5yUPMBh8lrzFaztSVO6Ru0D8vHCtBjb6tv755Q9+p9it1M0f5NOWTjnm35eAUQiVWa4uLnfFy0dTxYAz1nQBUNJdzoHOM3VXK8e2KtYSj/wbPtZYHoaxCROmueggFKsEgpfLjXxOP+eCM1vSiWSZKIECEVnf+vZ+1IIBUYW9B/1lxw3BTQ0zlUbmvhrINrD1pePImMGeMowlPrBqkArTRFD3dMIPTgj5xLezKHXCJpbENKBMY6HH+lSPmglpNSrKC1peXWqMuMFdvm6QvOUZm6x9hpXHhjfzK86rv1X7gkoToEQmN++4cD0hmZRuwijAq7gO4NuzHa0u/613bbCqsURYH2UzKXG/lP+qkc+YXZuSFSmZqdo+oW/zjbFwa3skk7jHC9b31ka9OZgt8FLfZQ0jLBYjPyk5+7ZBQQMT3bMpM5CZa0S/EcGsN0qtz5y/sUtPntP+mWdyCIy5OwdfZOhNp5ge99xTdzF1pddyKRMkKpF5on850x9mM8BBJsF9l5+yfGLIQ9zPnLN7BPveG7TTz+7pwY8RKsPDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(53546011)(38100700002)(38350700002)(52116002)(66476007)(66946007)(66556008)(508600001)(4326008)(26005)(2616005)(6916009)(31686004)(6486002)(30864003)(186003)(36756003)(86362001)(956004)(31696002)(316002)(16576012)(83380400001)(8676002)(5660300002)(8936002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXhDa2s4MVFBQUtaVUpsb0pmYWZJemRZRTBySE1Ld1NudDV6ck53Ujh6eW5P?=
 =?utf-8?B?ZVBoNlNTRU4yVlJEY0J3b2VsUE5zTlRkVTg2UlhEdmlWYjZqYjR5YXhWZVIw?=
 =?utf-8?B?bkk4d0ZWV3RqWVRzSDI4UzI3ZUR3ZTAvUDJVa1FaNjZJZVRJSWxsQUU4RjJr?=
 =?utf-8?B?ZWFUQXBxR1VMVDlxN01WVk81dUVlZXdOcWdVNFV2MHNaaXVSRUNCYTNaMXVq?=
 =?utf-8?B?eVhTQmVpOUcyQUZNaEV6eUMzdmQwb3JKcGdsS2lWektKUGJhd2RrQTN0eTNt?=
 =?utf-8?B?RVpRKzB1T3JUOEI0WVZtK3Jhb2ZIU2l0TVlDVUtFRmM1K2kwUDByN3dnbWFH?=
 =?utf-8?B?dUFKR2dhd3VRcGhRM0trWjFUUUxWV0x3M2lLMmVvb3lXVi9QbHQvbTFHVmVq?=
 =?utf-8?B?SGpDUmE5YmJtaVF2eVdEQkY2QjhudFd5WU5RQkplRHFpc00vRk01TC9uQ0Vr?=
 =?utf-8?B?bm9MeXBOMGtVb1FPLy82SEExdG1vQkZLMEVwbE94TDZxNDUxdmlmU0VWdnBi?=
 =?utf-8?B?NWVoZGlDQ0pBVWxrclJVU1M0MkxaTm5VQ0tnU3ZxVHJKWE04aHBOZGRPelZO?=
 =?utf-8?B?eWZ0ZVZVQ2paRjdGWC9tZysrYkJHSzZsUkNJdmtORGhFOWY2ay91cStPVG5s?=
 =?utf-8?B?RmxEdDRDcENtY3ZrR1k1VVpneVA3Mi8wTkNhMzYreHhZZ1VzdS8rQUNOTDVh?=
 =?utf-8?B?NnZVMTFNbGNhV2RHdW82RmdPR2lOY0RlMkZIMVVYOE5YZ3NiSVpsRkREODBT?=
 =?utf-8?B?ZDFBWWFFSmdTMFpONkFUTzFiL1hXMW9WWDZxK25lS0c3ZW1hdExTaHptMW44?=
 =?utf-8?B?c1JqL0FBZU5QM2VKdlBsem1CYmR1N095SnJsa0tCNDhuTXovV2M2aEZZRGhP?=
 =?utf-8?B?cThrZ1IwT0taMk1hZWV6MXpHOGVsQ3R2bmdlZGIyeVdDVVEwV2JmWWVEbUZk?=
 =?utf-8?B?K2pMeHhISmNMSzBuNHNtS1BiK2tkYUYxd0htVjVoVzFMZlJYeXA4SVpQaWt5?=
 =?utf-8?B?allEbzhZMG9sRGJiNjh2Zlo4d1pVMWRFQ09xTTRuRytNUVZObUduQmN1Q0dL?=
 =?utf-8?B?N3NlVmtRaDUvVi9qRHdmZlVBaU9vbktlK1RPUng0elIwS1JWbjFOTEd4OEsx?=
 =?utf-8?B?SG54U3R3bnVpZndjUVRYS0pqWWNVdTJwZnJObW05UzBhcjFjcUZ6MzF2Yi8y?=
 =?utf-8?B?UlVFMnI3dFZjdVdpbTZCcnplRkRkV2djUnpzaW1iRGVBcm9BV3ArZGtmL3NF?=
 =?utf-8?B?Uk9MSVgwMFpsdjVOME5OYWZRcU54L0FuN09JRG55a1BUTE8wTDQrNHJJd2JR?=
 =?utf-8?B?eWVGaXZnYVV6L0gwVU5lQnBTOTh3NHZJeTh4ME1MRWdOZ25DMmV5UUc4WDRR?=
 =?utf-8?B?UldNQmlmd3RoQXRsNENtbFJpVnBLTTlWN2RSSWx0b0dHMmVXMmRsVzJCY2V1?=
 =?utf-8?B?QWZGSVdjVzFhNDR3dmlNNXNmWTBYeE9Feit0aEV4RURweEJvSDRlVVo5SkdZ?=
 =?utf-8?B?SE0vd1d0bk9NRGhIS0w4K3F4d2p0aXdLZkVnWmJZYUdHZm9uK3pLcS93U3pE?=
 =?utf-8?B?QytsVVg4aDgwamlFeERUdnhPZVo5Y3UrWXlONVNwWmZtRE1qL2p3UmtNUGVm?=
 =?utf-8?B?NHZJUnc0cjZhRFRyWWMzWFd1TytOMGVLSE5Ud0lpMG80RHBma3h6bHRuZ3Z0?=
 =?utf-8?B?cUFnNnZVdmllcXFpc0h4eFpINy8vNE9zWGd4Wks3VENLazh0L3FkdEc3b3dE?=
 =?utf-8?Q?4iE9RQgzrFu8y2JaiHWfwOXZB8i8CqLhfYoJPqH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f28b15-1968-426f-63c4-08d981f51534
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 20:26:27.3466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IYmyUFsc1jgYJzXB8QIOkwEqIXqRV2BTeuCfoF2dIdUP4nVNHOsRcLRDbXEGOegRuamZT1dzjWrnXNyG1HXFanXXLM4kjiZIju+ZQ6qdbxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4387
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109270137
X-Proofpoint-ORIG-GUID: iRTeNSQvRb7A-mW1FeQLN5QcwgCn2uAf
X-Proofpoint-GUID: iRTeNSQvRb7A-mW1FeQLN5QcwgCn2uAf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/17/21 6:30 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When log recovery tries to recover a transaction that had log intent
> items attached to it, it has to save certain parts of the transaction
> state (reservation, dfops chain, inodes with no automatic unlock) so
> that it can finish single-stepping the recovered transactions before
> finishing the chains.
> 
> This is done with the xfs_defer_ops_capture and xfs_defer_ops_continue
> functions.  Right now they open-code this functionality, so let's port
> this to the formalized resource capture structure that we introduced in
> the previous patch.  This enables us to hold up to two inodes and two
> buffers during log recovery, the same way we do for regular runtime.
> 
> With this patch applied, we'll be ready to support atomic extent swap
> which holds two inodes; and logged xattrs which holds one inode and one
> xattr leaf buffer.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_defer.c  |   86 +++++++++++++++++++++++++++++++++-----------
>   fs/xfs/libxfs/xfs_defer.h  |   14 +++----
>   fs/xfs/xfs_bmap_item.c     |    2 +
>   fs/xfs/xfs_extfree_item.c  |    2 +
>   fs/xfs/xfs_log_recover.c   |   12 ++----
>   fs/xfs/xfs_refcount_item.c |    2 +
>   fs/xfs/xfs_rmap_item.c     |    2 +
>   7 files changed, 79 insertions(+), 41 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 7c6490f3e537..136a367d7b16 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -650,10 +650,11 @@ xfs_defer_move(
>    */
>   static struct xfs_defer_capture *
>   xfs_defer_ops_capture(
> -	struct xfs_trans		*tp,
> -	struct xfs_inode		*capture_ip)
> +	struct xfs_trans		*tp)
>   {
>   	struct xfs_defer_capture	*dfc;
> +	unsigned short			i;
> +	int				error;
>   
>   	if (list_empty(&tp->t_dfops))
>   		return NULL;
> @@ -677,27 +678,48 @@ xfs_defer_ops_capture(
>   	/* Preserve the log reservation size. */
>   	dfc->dfc_logres = tp->t_log_res;
>   
> +	error = xfs_defer_save_resources(&dfc->dfc_held, tp);
> +	if (error) {
> +		/*
> +		 * Resource capture should never fail, but if it does, we
> +		 * still have to shut down the log and release things
> +		 * properly.
> +		 */
> +		xfs_force_shutdown(tp->t_mountp, SHUTDOWN_CORRUPT_INCORE);
> +	}
> +
>   	/*
> -	 * Grab an extra reference to this inode and attach it to the capture
> -	 * structure.
> +	 * Grab extra references to the inodes and buffers because callers are
> +	 * expected to release their held references after we commit the
> +	 * transaction.
>   	 */
> -	if (capture_ip) {
> -		ihold(VFS_I(capture_ip));
> -		dfc->dfc_capture_ip = capture_ip;
> +	for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
> +		ASSERT(xfs_isilocked(dfc->dfc_held.dr_ip[i], XFS_ILOCK_EXCL));
> +		ihold(VFS_I(dfc->dfc_held.dr_ip[i]));
>   	}
>   
> +	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
> +		xfs_buf_hold(dfc->dfc_held.dr_bp[i]);
> +
>   	return dfc;
>   }
>   
>   /* Release all resources that we used to capture deferred ops. */
>   void
> -xfs_defer_ops_release(
> +xfs_defer_ops_capture_free(
>   	struct xfs_mount		*mp,
>   	struct xfs_defer_capture	*dfc)
>   {
> +	unsigned short			i;
> +
>   	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
> -	if (dfc->dfc_capture_ip)
> -		xfs_irele(dfc->dfc_capture_ip);
> +
> +	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
> +		xfs_buf_relse(dfc->dfc_held.dr_bp[i]);
> +
> +	for (i = 0; i < dfc->dfc_held.dr_inos; i++)
> +		xfs_irele(dfc->dfc_held.dr_ip[i]);
> +
>   	kmem_free(dfc);
>   }
>   
> @@ -712,24 +734,21 @@ xfs_defer_ops_release(
>   int
>   xfs_defer_ops_capture_and_commit(
>   	struct xfs_trans		*tp,
> -	struct xfs_inode		*capture_ip,
>   	struct list_head		*capture_list)
>   {
>   	struct xfs_mount		*mp = tp->t_mountp;
>   	struct xfs_defer_capture	*dfc;
>   	int				error;
>   
> -	ASSERT(!capture_ip || xfs_isilocked(capture_ip, XFS_ILOCK_EXCL));
> -
>   	/* If we don't capture anything, commit transaction and exit. */
> -	dfc = xfs_defer_ops_capture(tp, capture_ip);
> +	dfc = xfs_defer_ops_capture(tp);
>   	if (!dfc)
>   		return xfs_trans_commit(tp);
>   
>   	/* Commit the transaction and add the capture structure to the list. */
>   	error = xfs_trans_commit(tp);
>   	if (error) {
> -		xfs_defer_ops_release(mp, dfc);
> +		xfs_defer_ops_capture_free(mp, dfc);
>   		return error;
>   	}
>   
> @@ -747,17 +766,19 @@ void
>   xfs_defer_ops_continue(
>   	struct xfs_defer_capture	*dfc,
>   	struct xfs_trans		*tp,
> -	struct xfs_inode		**captured_ipp)
> +	struct xfs_defer_resources	*dres)
>   {
>   	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>   	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
>   
>   	/* Lock and join the captured inode to the new transaction. */
> -	if (dfc->dfc_capture_ip) {
> -		xfs_ilock(dfc->dfc_capture_ip, XFS_ILOCK_EXCL);
> -		xfs_trans_ijoin(tp, dfc->dfc_capture_ip, 0);
> -	}
> -	*captured_ipp = dfc->dfc_capture_ip;
> +	if (dfc->dfc_held.dr_inos == 2)
> +		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
> +				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
> +	else if (dfc->dfc_held.dr_inos == 1)
> +		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
> +	xfs_defer_restore_resources(tp, &dfc->dfc_held);
> +	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
>   
>   	/* Move captured dfops chain and state to the transaction. */
>   	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
> @@ -765,3 +786,26 @@ xfs_defer_ops_continue(
>   
>   	kmem_free(dfc);
>   }
> +
> +/* Release the resources captured and continued during recovery. */
> +void
> +xfs_defer_resources_rele(
> +	struct xfs_defer_resources	*dres)
> +{
> +	unsigned short			i;
> +
> +	for (i = 0; i < dres->dr_inos; i++) {
> +		xfs_iunlock(dres->dr_ip[i], XFS_ILOCK_EXCL);
> +		xfs_irele(dres->dr_ip[i]);
> +		dres->dr_ip[i] = NULL;
> +	}
> +
> +	for (i = 0; i < dres->dr_bufs; i++) {
> +		xfs_buf_relse(dres->dr_bp[i]);
> +		dres->dr_bp[i] = NULL;
> +	}
> +
> +	dres->dr_inos = 0;
> +	dres->dr_bufs = 0;
> +	dres->dr_ordered = 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index e095abb96f1a..7952695c7c41 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -107,11 +107,7 @@ struct xfs_defer_capture {
>   	/* Log reservation saved from the transaction. */
>   	unsigned int		dfc_logres;
>   
> -	/*
> -	 * An inode reference that must be maintained to complete the deferred
> -	 * work.
> -	 */
> -	struct xfs_inode	*dfc_capture_ip;
> +	struct xfs_defer_resources dfc_held;
>   };
>   
>   /*
> @@ -119,9 +115,11 @@ struct xfs_defer_capture {
>    * This doesn't normally happen except log recovery.
>    */
>   int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
> -		struct xfs_inode *capture_ip, struct list_head *capture_list);
> +		struct list_head *capture_list);
>   void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
> -		struct xfs_inode **captured_ipp);
> -void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
> +		struct xfs_defer_resources *dres);
> +void xfs_defer_ops_capture_free(struct xfs_mount *mp,
> +		struct xfs_defer_capture *d);
> +void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
>   
>   #endif /* __XFS_DEFER_H__ */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 03159970133f..e66c85a75104 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -532,7 +532,7 @@ xfs_bui_item_recover(
>   	 * Commit transaction, which frees the transaction and saves the inode
>   	 * for later replay activities.
>   	 */
> -	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
> +	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
>   	if (error)
>   		goto err_unlock;
>   
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 3f8a0713573a..8f12931b0cbb 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -637,7 +637,7 @@ xfs_efi_item_recover(
>   
>   	}
>   
> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> +	return xfs_defer_ops_capture_and_commit(tp, capture_list);
>   
>   abort_error:
>   	xfs_trans_cancel(tp);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 10562ecbd9ea..53366cc0bc9e 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2466,11 +2466,11 @@ xlog_finish_defer_ops(
>   {
>   	struct xfs_defer_capture *dfc, *next;
>   	struct xfs_trans	*tp;
> -	struct xfs_inode	*ip;
>   	int			error = 0;
>   
>   	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
>   		struct xfs_trans_res	resv;
> +		struct xfs_defer_resources dres;
>   
>   		/*
>   		 * Create a new transaction reservation from the captured
> @@ -2494,13 +2494,9 @@ xlog_finish_defer_ops(
>   		 * from recovering a single intent item.
>   		 */
>   		list_del_init(&dfc->dfc_list);
> -		xfs_defer_ops_continue(dfc, tp, &ip);
> -
> +		xfs_defer_ops_continue(dfc, tp, &dres);
>   		error = xfs_trans_commit(tp);
> -		if (ip) {
> -			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -			xfs_irele(ip);
> -		}
> +		xfs_defer_resources_rele(&dres);
>   		if (error)
>   			return error;
>   	}
> @@ -2520,7 +2516,7 @@ xlog_abort_defer_ops(
>   
>   	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
>   		list_del_init(&dfc->dfc_list);
> -		xfs_defer_ops_release(mp, dfc);
> +		xfs_defer_ops_capture_free(mp, dfc);
>   	}
>   }
>   /*
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 46904b793bd4..61bbbe816b5e 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -557,7 +557,7 @@ xfs_cui_item_recover(
>   	}
>   
>   	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> +	return xfs_defer_ops_capture_and_commit(tp, capture_list);
>   
>   abort_error:
>   	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 5f0695980467..181cd24d2ba9 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -587,7 +587,7 @@ xfs_rui_item_recover(
>   	}
>   
>   	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
> +	return xfs_defer_ops_capture_and_commit(tp, capture_list);
>   
>   abort_error:
>   	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> 
