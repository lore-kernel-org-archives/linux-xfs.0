Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B26C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Nov 2021 08:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbhKXI6s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Nov 2021 03:58:48 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52890 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234024AbhKXI6r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Nov 2021 03:58:47 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AO8YSAW015765;
        Wed, 24 Nov 2021 08:55:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=AXJSKFdmqcsm2+aL2eNEuKs5i11B5y0RpD3vFbgWzkY=;
 b=Viut5b2vr3jMPFocMggunyBhkegUch52nW85Mks2Ls+j48jOEMzM80aXNGE7MWv1wKrk
 ntvifbTrylE1neh9zk7zHXhANpe4qR4hDI6L+e5h15AG5kBVQRoDtB5YhY7L3jFjMQRB
 bDMf2NdAxweKfRqYnIGq20D61/0EWAZ/2138gMNQBfWhy5qR83V75Klyw57ImlhAsH36
 10XUmc2jKWMoyeWfk4BwLVPadiFxsJZsOWRLXMq7Wt3csmbk3HBFOrXum8pPfOkWoFTw
 6lbtyuRXorS68DEZTHrQYmDSGDmlFu1Kn1+9xKY7M5JmwvExsHIuJxa7uYpeFGbR+Dd/ WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg46fg47e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 08:55:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AO8tXpw158500;
        Wed, 24 Nov 2021 08:55:36 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by userp3020.oracle.com with ESMTP id 3ch5tgyku9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 08:55:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awbE0wvmkhCgd/Iecm8heaQJStX6SfLGZAPnkz7hhJ1BhGSLd1ZukU58CunEZ23nt+oLBCzztgoiCggujLTWtoy8EYUSwgAMs7ZuIeJ+kqY/+vp2WzBYsLr8NJ67QxyM6fUySJghgLRKr/f6zsRFSk5QSbjdHszY+v24F73jCb2SNmvmCtpVhfAjJukYKjmHhJG9iGHoir/uwGpTboXmZUCT4XEhii2rH68tSbM8DsSFOtE6kNIsuRby1DSIDlvbZlwqv7cnz2CKf/YRV6ZIOpAsiDyYVflbNQMlfFV4s3xNmcHPRiaoGuy5miSBiEZE5Px6DDIxTeK30e0ChzKX7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXJSKFdmqcsm2+aL2eNEuKs5i11B5y0RpD3vFbgWzkY=;
 b=i6m3vshyDW8C66V+r1h+ZiUHWnGobJZeTaJZ6HKj9lrNnZ1b/j/bpuSeAiG7avm37NhIeYy5EtRc6ztyBpJRuIzH+TWo7s+Yv4PZgDAEpbhk9QK1lKJYJdQnwDf8K5RsYEhPlT+6BeieeIsc8K8N4sQ2jhdRmFL/wT+4jl+3xwyD8vAEUQX3IFw2mnrDFz+35TiyQG+OwQawnAimEwGfwYk359oxSan1TqDUzMgTjZbg24ZYyQEuOCM8qJGKCXv96o2jQgRtfs7aiTChZMXoxRk70ODchDLQJ9UpxLVLN8am17AbQifNMeMViELI021vjHshaoWpaHN7NaKlei4tDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXJSKFdmqcsm2+aL2eNEuKs5i11B5y0RpD3vFbgWzkY=;
 b=IGSpM8yDTnsBZk+OlCQmrfabaQo37Yl/TF2HFAyoWNufD96U4GzW6/2edYsfjxcXtsb9ghOqhHuDEi4jOtZrNt8gqu57jn543cLwpofCvOK9IY/RTi+UPMbeAP/SpeQA09ALPYbgFaw1piYEhXnKJ0aLhtdcLdevTOy71VbMu3s=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BYAPR10MB3126.namprd10.prod.outlook.com (2603:10b6:a03:15c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 08:55:25 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::6c4a:b9e2:6c7:cf2]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::6c4a:b9e2:6c7:cf2%6]) with mapi id 15.20.4713.026; Wed, 24 Nov 2021
 08:55:25 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-17-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/16] xfs: CIL context doesn't need to count iovecs
In-reply-to: <20211118231352.2051947-17-david@fromorbit.com>
Message-ID: <87v90irkzu.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 24 Nov 2021 14:25:17 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0034.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::21) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
Received: from nandi (138.3.205.55) by TYWPR01CA0034.jpnprd01.prod.outlook.com (2603:1096:400:aa::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Wed, 24 Nov 2021 08:55:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3e596de-3445-445c-92e3-08d9af2827d1
X-MS-TrafficTypeDiagnostic: BYAPR10MB3126:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3126ADFDCF8C72E7DB666FF3F6619@BYAPR10MB3126.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TQqv/CaWlC+nLcXsqXaNpSGC4pYO3vln1U+GO5jbbmNkCW4JvSA0ER3kfNtHKEommMSWeUZf8SS77r/Us6U0O+NMdqabVlS2AgFcppYIV2AWavHw6ReqZHqbf8Qv/D1Fd9V2ZzMGj39ZY25MT+CyGLFlIsW7zuxEEBIFUbomGzNhSKogFFPS0s/Z5799iN7zPErlDFW3yauCzUgHEq7t5c1R2LjW4lgtN4hnM1hOpojZU/0cvWPpj7HkQwUaHoG2cPRjHPMUzyY7l+ZaWBh/tn1X2W3HGPPYxPVmPOdbRPdF+hug1cYQzOKv+2kU0hiT+XW0SobwDNMMfKiYyNgkvPQlfKfdIJH6hHO+R5d+W1p82QCcKo1IXXqRusdyhI2qGliJm0Gt3WnfR0lGCr3ocXyQeGVgEZAZQjpe7KPR3O5XLEoKEtncFssBjbNiQd7s00lhuM1tsG7UCLl6aTXlJqZMBQmWTAnv3/wqHeXOaeYT7x4CwQA3qAsa4QWnxC5m9RPI7+w3R7iRQDD1rYG5AhJtR4W+cIFPO2LoOE+tMGQhEMgznf2pwMlNoAoqNiQdGAD7qVwv0NsGuVicCr7VvJe8fn1VQ/86yfgpZKFfLJkanPJqIPufgXCG680UIfsQuwIj6/j1pvjzkRecHrxh7MDUF4TypMqV11UzY5tmuktEbBhsmItSPyFXyFJfg/Oxe9oqOPH5W08J1YGQLU7+Hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8676002)(38100700002)(38350700002)(186003)(2906002)(6916009)(33716001)(956004)(8936002)(52116002)(66476007)(26005)(316002)(66556008)(6486002)(66946007)(5660300002)(9686003)(508600001)(83380400001)(4326008)(86362001)(53546011)(6666004)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xoFWUP2hWeBT6Zq8VnENwyA1xbEXaXgVUJHAVrr93bBerVhzaEP7L+VuNzsQ?=
 =?us-ascii?Q?9tw3UeWPTmumr8N8/EpLvnjObNZu+AdtBYoMI+seZwCw4PrySNWRUDkHU40g?=
 =?us-ascii?Q?9Uc7U95BWGeusGk4G1AlLLNXEB9cSHqGT2ybJfEhz0ddq6jjAHryiMkMygx0?=
 =?us-ascii?Q?hJ3UvOTmYIx5kjEkGxY5TLQwr6v3VVo6xhOADrt+lWIe0Tt4WTKKJv8LFSh3?=
 =?us-ascii?Q?jWxHpS/VduHW5fQrQKhy2URFGJli2/JmGpv52uPyuOMh7OXKy1x9JTPtQmsV?=
 =?us-ascii?Q?nIoqcU1eNT6IQ/x+D/0OITdmu/26qogu2A+xL9dRG6THyo3FTmAQX+iw3Z4q?=
 =?us-ascii?Q?5hlouviN+oZpzTdMBAhpUbPOVOftUxcLMJRZ7DcsFi2UBDMZnUef2MgAOqh4?=
 =?us-ascii?Q?0cIM0umjvCC0Yp5R5Y9mffLSYv2im5w+yl4AmPT0xzM4u37XzBy4Aw7LTd+o?=
 =?us-ascii?Q?MUPHlds11l4lySYkJQwp9PaSH+ajjtYSDJ7xyik4uOwWxgrHig6j47xdXwDS?=
 =?us-ascii?Q?DrrjteBT5oMnXK5H9HUiToWUM1TJR27jusRhsEwsyk81oDmqWosQn7xVt4ML?=
 =?us-ascii?Q?hWQ8LW+MTXD7CgvfRLlc9Kk1gyYOLysq3O0M6+ExR/Lyr6U81zPWrpEVzhv5?=
 =?us-ascii?Q?Y9ERh5S+ePZQ/GVYsKHFrZqDL3vj8MxPLrBrb/3+cWY2fpcJboJ5fWem5bts?=
 =?us-ascii?Q?WRFx2UQkjLgDJV0CbVVACUHwT20Z532V3zKMCM5WVBzK5q80EzK3Wlq/C8z1?=
 =?us-ascii?Q?humX9tdZBN8PMlbdA1eu0SGbATQJGGwTFuN+b0nQjB4tpOuaJasW96GzibF0?=
 =?us-ascii?Q?qzSqVs7PDgFgWiV1yeAQ86s1PobXPWFlmDh/EWzFbYL9rkB1fs9u/sJdmfgx?=
 =?us-ascii?Q?vR/qqBcsZ7hDmcqUMeMO5J7pDHMgVfhTe3kNA/3qPIqE0UiGUVKinnlYzC9M?=
 =?us-ascii?Q?/4GlTXzXunW11uHirGllIWWzrxHgAO6/M5GCY1KRAzx6qz7aSdvvP6Oh3UkA?=
 =?us-ascii?Q?RZTrKUR3PJdTdCpHBjevWL3EyfysLDniG6TUWPjeLnGXSEwjjRZ6JVSdkf3T?=
 =?us-ascii?Q?40NLSX0MTUE6Q52ktjcW1IkUHRaiev0UrtqBxPcBzbMZn0MLNDHh4KfuIyM2?=
 =?us-ascii?Q?lrLIFDtH5eotV072t8KtV9Hh//KavdLzl3UUKpIA6bnZESi2GPkQ36ND6Kdm?=
 =?us-ascii?Q?SuMgRbfqg0IVHYQzB8p/Q/tQxfAJKmuRughn7QstJNkwOiHnZHvGq8MRRatj?=
 =?us-ascii?Q?4xhgmrY09ejD0/aIwSOuM04HEzeYUVmZwtiUg3JeFWWE3Y+V0ly637Pa2mKJ?=
 =?us-ascii?Q?ZrwKtZqtMBSLPmLtM1Luwn/nRhuiznz+v5tQvFAuMrut62c/DAQ+p3Q46rmE?=
 =?us-ascii?Q?v7fCpmKeWbuDUNt3PeDT7yiAucF+SxVmp9wi+/RvUWHg2vPU2Vsrzg2GevEe?=
 =?us-ascii?Q?Fb6xyAJlr+sl69wuhIibDJ4YSt6sitf3fjihS16YeZfJTXJ1zU2wd0mWgtvU?=
 =?us-ascii?Q?tgUh91MMtFgaZaaAj7K3FtCVLjN07RZBcobQ5zmxN5cgH3OP3pRzHQqB4UC6?=
 =?us-ascii?Q?8ZkyRaTArGPL7GQDkFKA8Z88vlielxweSLh2gFBJeBuhTv2zsAgmYB4G0iXC?=
 =?us-ascii?Q?EufCk/R9Xqn+a0ZjT5vTAVI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3e596de-3445-445c-92e3-08d9af2827d1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 08:55:25.6909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nIK+CtXMW541nCk3ERkWGFhTgFMHq8H4/iOwIiR2VZENy+9ZucEgAcEhvi4tJo5+w+stAcZiUkhHpX1HwUPIQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3126
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10177 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240049
X-Proofpoint-GUID: D7FFNhl33BBpcNUgroz9kEBjoD8tjruN
X-Proofpoint-ORIG-GUID: D7FFNhl33BBpcNUgroz9kEBjoD8tjruN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Now that we account for log opheaders in the log item formatting
> code, we don't actually use the aggregated count of log iovecs in
> the CIL for anything. Remove it and the tracking code that
> calculates it.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log_cil.c  | 22 ++++++----------------
>  fs/xfs/xfs_log_priv.h |  1 -
>  2 files changed, 6 insertions(+), 17 deletions(-)
>
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index ad98e4df0e2c..f7ca7a4e6fa5 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -260,22 +260,18 @@ xlog_cil_alloc_shadow_bufs(
>  
>  /*
>   * Prepare the log item for insertion into the CIL. Calculate the difference in
> - * log space and vectors it will consume, and if it is a new item pin it as
> - * well.
> + * log space it will consume, and if it is a new item pin it as well.
>   */
>  STATIC void
>  xfs_cil_prepare_item(
>  	struct xlog		*log,
>  	struct xfs_log_vec	*lv,
>  	struct xfs_log_vec	*old_lv,
> -	int			*diff_len,
> -	int			*diff_iovecs)
> +	int			*diff_len)
>  {
>  	/* Account for the new LV being passed in */
> -	if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED) {
> +	if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
>  		*diff_len += lv->lv_bytes;
> -		*diff_iovecs += lv->lv_niovecs;
> -	}
>  
>  	/*
>  	 * If there is no old LV, this is the first time we've seen the item in
> @@ -292,7 +288,6 @@ xfs_cil_prepare_item(
>  		ASSERT(lv->lv_buf_len != XFS_LOG_VEC_ORDERED);
>  
>  		*diff_len -= old_lv->lv_bytes;
> -		*diff_iovecs -= old_lv->lv_niovecs;
>  		lv->lv_item->li_lv_shadow = old_lv;
>  	}
>  
> @@ -341,12 +336,10 @@ static void
>  xlog_cil_insert_format_items(
>  	struct xlog		*log,
>  	struct xfs_trans	*tp,
> -	int			*diff_len,
> -	int			*diff_iovecs)
> +	int			*diff_len)
>  {
>  	struct xfs_log_item	*lip;
>  
> -
>  	/* Bail out if we didn't find a log item.  */
>  	if (list_empty(&tp->t_items)) {
>  		ASSERT(0);
> @@ -389,7 +382,6 @@ xlog_cil_insert_format_items(
>  			 * set the item up as though it is a new insertion so
>  			 * that the space reservation accounting is correct.
>  			 */
> -			*diff_iovecs -= lv->lv_niovecs;
>  			*diff_len -= lv->lv_bytes;
>  
>  			/* Ensure the lv is set up according to ->iop_size */
> @@ -414,7 +406,7 @@ xlog_cil_insert_format_items(
>  		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
>  		lip->li_ops->iop_format(lip, lv);
>  insert:
> -		xfs_cil_prepare_item(log, lv, old_lv, diff_len, diff_iovecs);
> +		xfs_cil_prepare_item(log, lv, old_lv, diff_len);
>  	}
>  }
>  
> @@ -434,7 +426,6 @@ xlog_cil_insert_items(
>  	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
>  	struct xfs_log_item	*lip;
>  	int			len = 0;
> -	int			diff_iovecs = 0;
>  	int			iclog_space;
>  	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
>  
> @@ -444,7 +435,7 @@ xlog_cil_insert_items(
>  	 * We can do this safely because the context can't checkpoint until we
>  	 * are done so it doesn't matter exactly how we update the CIL.
>  	 */
> -	xlog_cil_insert_format_items(log, tp, &len, &diff_iovecs);
> +	xlog_cil_insert_format_items(log, tp, &len);
>  
>  	spin_lock(&cil->xc_cil_lock);
>  
> @@ -479,7 +470,6 @@ xlog_cil_insert_items(
>  	}
>  	tp->t_ticket->t_curr_res -= len;
>  	ctx->space_used += len;
> -	ctx->nvecs += diff_iovecs;
>  
>  	/*
>  	 * If we've overrun the reservation, dump the tx details before we move
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 3008c0c884c7..a3981567c42a 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -221,7 +221,6 @@ struct xfs_cil_ctx {
>  	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
>  	struct xlog_in_core	*commit_iclog;
>  	struct xlog_ticket	*ticket;	/* chkpt ticket */
> -	int			nvecs;		/* number of regions */
>  	int			space_used;	/* aggregate size of regions */
>  	struct list_head	busy_extents;	/* busy extents in chkpt */
>  	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */


-- 
chandan
