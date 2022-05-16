Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7FEC43217
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 23:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349434AbiEPX4Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 19:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350624AbiEPX4W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 19:56:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6AA286DE
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 16:56:18 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKrCDH027282;
        Mon, 16 May 2022 23:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qMG59+8HdnPbrUiut00wgSqPxiS7lGIq8Ag/Ydg1fQc=;
 b=tZ+HpwFFbTPSYgVHNy11AfICVnTNh7X8Bb3kSCXC/Qsux0hpwrbeSWfGZjqm/v8HHfaq
 udLmyk8OmyxAke0BeEiXpHN0NA/BTw4ykZypsueZUbgMKgV8dziT9V8YoTM6FILS8B+P
 AD8tNA6Na4moCGqxVPfn97Oq9T9LSgxO/XY0X7frOrPVyzTYm00Bb5TEAOYAWKdpwllu
 71ukocnq18/LyiMIegOlQNCR2Ao6qWbc7ZDBxQbBiaFZB8audzNT3bviT9fCbMuRwGHE
 lGp1YY4q4uVkqeYyu0Z0Mm5IHfvFvH+bZZHm/BS1PDVAuThwsea/i+6rTK6beYQE7Dix +Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2371vstd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 23:56:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24GNfUU1014066;
        Mon, 16 May 2022 23:56:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v27sqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 23:56:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kANqvZNSZ1p239utv0V+JbqSkZpTQu96C4l3ufYax/2+6RFoz9Dx1Qk8HelcCWQZZ3WqK/OwSyDg6ZPrcn9TDbUuO6phoXutNNEewVMA52AbkFL8f1DFeTGElQzLRLNm2B/RtxKhfGrszoS7iyg1pXZ/LneN5Y6txl4Utuh/m3ItKUfsM+AA3w8hPA3bj4y7hOv8iO51RaKzrrGeSHlJ8+ZD1h9ML3Q1swod/ysuiSDZpjLPE/pACF8ObDoUJK7OKhwL/n/oWbDa4CCV/qSPeqJjR1eXCcz7oPzkn0AbPeAjqia3nQzqXQcGOISNT30nUxWaotoizZo1w5E+O4YESA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qMG59+8HdnPbrUiut00wgSqPxiS7lGIq8Ag/Ydg1fQc=;
 b=eXCSQvGbik/wvsSFhMD195b8B7OM142CHlf5voPVsPP2MFiETsK6khgBeg5SliWIsWbzL5zWEQ4wXhZDNDEMEZbRLyHvJ9RZFPIC2q4ohm9ZzJka+QwLt4QbQIDbQWl35e0RQPClK2EqkLLxpaV12vIkuASSQU7V9dm2DbdT6EOKMieXHP03hD5v6u6g3Tr05ahfVJiW/sgzvNfQ7Omm9NJJBKE8YRYTceolOxwnhTQxnMUCD1j1BULYn/aAMtQcqkKIPqe+ibtx6WnkJ4I/MvnrZHCo+65WDuqRwGzer4GsrabpkTw7iY7GwvciEmMq3Lc4cBruiXjjkS95H1QC2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMG59+8HdnPbrUiut00wgSqPxiS7lGIq8Ag/Ydg1fQc=;
 b=wecXV0JQxv3RWt15QwjDOGqwL0xqWkS5RCMyawlngWjIWdIN3NSYSxPMUbOCQuVyDeYjxgX2jUjWdmREVd1R4Kk8jojrgMHu1Y319mIWFXXiHHTgxlzzc8CtPjPiprlCLoAoaKkVvbfNfchG8/5aRSMBO8aWhBPIEFp3UxM3DfE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA1PR10MB5758.namprd10.prod.outlook.com (2603:10b6:806:23f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 16 May
 2022 23:56:12 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 23:56:12 +0000
Message-ID: <c0f267093b7f191b4931f7fff27f3e2373e160fa.camel@oracle.com>
Subject: Re: [PATCH 3/4] xfs: reject unknown xattri log item operation flags
 during recovery
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 16 May 2022 16:56:10 -0700
In-Reply-To: <165267192904.625255.1227477138553372618.stgit@magnolia>
References: <165267191199.625255.12173648515376165187.stgit@magnolia>
         <165267192904.625255.1227477138553372618.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0049.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff9d2021-001e-460e-9ede-08da3797a794
X-MS-TrafficTypeDiagnostic: SA1PR10MB5758:EE_
X-Microsoft-Antispam-PRVS: <SA1PR10MB5758A58081BF3ABC392B229595CF9@SA1PR10MB5758.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: curzCuAQyiZbf7B//ifAHOv8QiZWEthgBp5dSOXyOk5I2k1UgYXqi9A/HIRLC60i1dkIeFXFsSLCxwuD7nxnLZBBKcGEmoptPEKXZ2GDOFtRKRROj8p8fYpZz1m0DOdYN3OTvxicBGWxqVqpujH+9S6SGP2gPjUOfKyn1DX5Yaw5SyaX4JgqekvpTGJ3OsVDcOlHFKryNZX/A9LVUOR4xuPbntOdn598op/tus660agT7b0riVnP+ONWOMtmlX35nml+2/jI4J+hiSLPT/FEbZm/hzIFZ36BLYoBHMRp/l5GlUVlurlAZe2zX7VuqT8AOgnbicEsrUTWJ1uVzIVkXh3k8w/405YEF2Y4/P/TRarQ0jHEWxsAI/q2CWdowPTU1bYhd3InrQlcgdPjbmNP+qcI+r8sSHpgnQy95EGEb0pykn4Wi8lYWQjGJ63ScMw1y5c6oRUu+LR13YQKNmuNX8uPVzrIukprMV6duygWRSdPza8+0/YA5DIIXl49XBdPewWUa1ejmzU2W8nhLvL//rUgL3xP2NkghLp9hZSuivNOYYR9e/uitu9Pa0Xh/b0oLLZVN0L+RVwaMCV1X4zCc2gh8rE6wq/U0+vu3sBcJpYSVy6i9xujFqVZuKqXZOHJhNcf+p88b5K3y+V9COEzuvVxuiV2rnxlDKrqF5PAzaxoq1+X/Sc8gNbn/DeM1uIAhLMlYoJbXr+3ME6MiVdnIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(38100700002)(6916009)(2616005)(86362001)(38350700002)(83380400001)(508600001)(6512007)(4326008)(26005)(6506007)(2906002)(8936002)(36756003)(66476007)(8676002)(66946007)(66556008)(6486002)(52116002)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejBrOU0xVDNUaVF4SGFla1Z0SW9MT3hZRzVOOGtHaDVKQ2xuUHNCOHNVcWJ3?=
 =?utf-8?B?Y1lxOUFwdkRiYTZ4MDdhUk1ITVhPVnIrREZHTmpad1YxRFFta1VTd3N4LzJx?=
 =?utf-8?B?VjgzSW9MejZEU2N0cEhyTUdZdStMbVNpQ1hTVVU4QnBJanByUWM4TUpwVkUw?=
 =?utf-8?B?L2JzdG9tdDhmWEFRbmc2RXBCV2dZVyszVnpPSVdsaVc3QXNXOFcwQklLd29k?=
 =?utf-8?B?ZURtUUN1UzdlaUZNZ0U5M2tWR1F5QTJTQjVkZXVjYzlGQ1pieG42eUUvU2Jz?=
 =?utf-8?B?NzJ6MHhGVWg3QzR1dGV1ZnNrTS9FOWlhaXVrYklTdnRPNU5IOExEM3NYNFhS?=
 =?utf-8?B?Rk5wN3RuQnJRR0JUQkE5M3pRQ1BtSG9JYTZwbEZsNHp2clJRTUNOZldGc09E?=
 =?utf-8?B?Q1hEOXBRT0hwd28xZlpNYXlBSnQ1QVBTd0U3ZHYyakw2Ny9GbkdLTDVLNGxs?=
 =?utf-8?B?eDhxRGFpRTdpeFpPUmxlNk5hZmZ6QWlqbnI0UUNNVDNjQ3lqTnBlT3pFbFR6?=
 =?utf-8?B?a20vanFjT0pLZmpNUm90ZTk4U2tJVXFUanA4dDNEY0NZclQ2NGlYa1diL0xT?=
 =?utf-8?B?eVVzQ2k1N2t6ZXk3TndCcEJ4QUdDMkJuS2oxMkk4UXIreHJxTEhMNFNWRWpm?=
 =?utf-8?B?MVRTblFqdDJ3RCt3WUVYQ2R2QWNOUlJVLzZndDVEamFlVEUwdXZyTEJQb0Rl?=
 =?utf-8?B?aXVFeEp0TGZsVzRKeUF2UVkwYUZkcml4c2tpcWlqQVJlQks5SDNEaWRZcGxQ?=
 =?utf-8?B?Mmo2dGt0bVY0L3VtbXlQcWl3b0M1aDl2cFIwMWcvYkc2VWcvMmh3U2krOXBQ?=
 =?utf-8?B?TnYxZEo2dExVU3NGRXVDaDRTYXF4UGdUUDBFdTlKTzV2UUsreEZ1VWgyV1hr?=
 =?utf-8?B?dXNEUW85ZThDZ2tpRFBrQm9tNThjNUwya2tFS3Z6bjNGZitxakVRa1A0WmI5?=
 =?utf-8?B?cjdsd0s5M1RLbVdsVUVlR29mVk5DWHhLMjVsUURQWFFEays3RXpISWp0cXk5?=
 =?utf-8?B?Tlg3VFlhb1RQSG5sU2xqdzA1MWNXSGZmRmRWMXhQbGtXb1ZST1drTCtHR0pl?=
 =?utf-8?B?RTFqMEo3UWtGd3RmQVRWbFkvY29pRjdadW55cVJOdDFtOGhmT2U2ZmpYaUxM?=
 =?utf-8?B?RFJmZzZPYlhpcTQ3RFRhZDh2SjZEUG5IU2xycit5MCtRN1pSZ0Jsb28rNXhZ?=
 =?utf-8?B?TkpEUk5vQU1qcDF2N3huSFIxdkNrc0FCT2RBRE5OVGpnTmF0MWN0blpOOGhI?=
 =?utf-8?B?OTROR3EwT21yc25iamhpUkJRUzM3K0IyNFVCNTh0UkcycDBhT1l2TVkxY1NX?=
 =?utf-8?B?NWpDRll0UnFWNkIwQ3pYZE0waWY1eC9GelQ2dERFNzlyRjZMdFd6VU1MRTFJ?=
 =?utf-8?B?NlVrMjFpUDBBM292blRNNUZpaVluVngxazZkQlQwbXZtYlErdEsxTWxOWGpp?=
 =?utf-8?B?SWRIUzJQdkJkTGxzTUdWYUxSZENLOU9IYVRLektGODdYaTBHNmJNZUlZdFlZ?=
 =?utf-8?B?MkVZWUU5WGUrRmNwZ2RCeHlaR2RyY2sxbnRKMVJORVNNK1V1djlCTnVEVnRl?=
 =?utf-8?B?eHBINWFzc2gwUm0rNmY3UFh2cURSVXF1N09yTzBZblpTbXMrNlVaTnpuRXdw?=
 =?utf-8?B?YWo4R3h0QTgrWmtsTGwxY09MMGdYdzRHRFJvdXV2RFpmOHZQSUJZSUpXcXBF?=
 =?utf-8?B?ZndaMVBKaTNnc0dlNlNGbGZ5L0ZaQTZZMTdQOGp0ekxZamZZZ0JZalRseFdN?=
 =?utf-8?B?Q0Y3clc4RndMK3daOWw3ejJhN1FCL0luSlRLRjlmUVE4Tm9WeWt2NlZIdDhj?=
 =?utf-8?B?UmgzNm95ZXBjYUhBWkV0NVY5UjdTTjVuTkFFeEx4YmdIZ2twUEVyRzQvMHpu?=
 =?utf-8?B?Y3JLMzZsTW94L2hGeWh3RVJ5OGpGVTV3YWRLYjVKOUpVbXlTUU5KeEJET0RW?=
 =?utf-8?B?c0U2aXZLRkthdmx5OU05TStJWFZvWVljMkhmOEV5ZkJLRUMvcVJlWnZnWEFH?=
 =?utf-8?B?TEF6QXZsRmlBSXgrWm15Wng4U3pSMU9CdlBpNkxRa01YTTI0b0tEZTR5VEhS?=
 =?utf-8?B?YVlTNUFQaisvblk3UCt6anMySlQrc1lTOG1vU0tQTDhuRGZBZDdhOHEzaktl?=
 =?utf-8?B?cFE4eEZPOS9ZMDgzd3A2ZjJGUGhYMnVqbHRCZUkrK2t6UDFFOEZ5NFJuVDZP?=
 =?utf-8?B?YmZJQnUyZENhRXBiS09YaWFwdFMvRHFyL25ic1BQNEt5QzBNNjF4cmlhUUk2?=
 =?utf-8?B?akt3dzk2WVBZNWxHWkVuT3p5VkZKZGZKMmRHSEFnblErS1ArSzhUVVRONDB4?=
 =?utf-8?B?YmU2Y1FsNnJ4QUJTVk45cmVTcjZBSDdOeVJEaTFtVGFjWlJsY3FjZ0lESGI3?=
 =?utf-8?Q?jBNWPyz7gzCTNvtQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff9d2021-001e-460e-9ede-08da3797a794
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 23:56:11.8720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3/hDOC9izHU4sXVGIv6F4rczYyQ1xH3e6di2RU5i7z1mQaXpT1Koa/DEPK7FnmKe+PXMQ+Q+aCd0OgfxBayvtr1gQk6qay9/gxEJUdZm2gg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5758
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_16:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160131
X-Proofpoint-GUID: OA5dL-WpGJyZuxrBTymmxJa6pWhPlqZD
X-Proofpoint-ORIG-GUID: OA5dL-WpGJyZuxrBTymmxJa6pWhPlqZD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, 2022-05-15 at 20:32 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we screen the op flags field of recovered xattr intent log
> items to reject flag bits that we don't know about.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/xfs_attr_item.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 687cf517841a..459b6c93b40b 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -349,7 +349,8 @@ xfs_attr_log_item(
>  	 */
>  	attrp = &attrip->attri_format;
>  	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
> -	attrp->alfi_op_flags = attr->xattri_op_flags;
> +	attrp->alfi_op_flags = attr->xattri_op_flags &
> +						XFS_ATTR_OP_FLAGS_TYPE_
> MASK;
>  	attrp->alfi_value_len = attr->xattri_da_args->valuelen;
>  	attrp->alfi_name_len = attr->xattri_da_args->namelen;
>  	attrp->alfi_attr_flags = attr->xattri_da_args->attr_filter;
> @@ -496,6 +497,9 @@ xfs_attri_validate(
>  	if (attrp->__pad != 0)
>  		return false;
>  
> +	if (attrp->alfi_op_flags & ~XFS_ATTR_OP_FLAGS_TYPE_MASK)
> +		return false;
> +
>  	/* alfi_op_flags should be either a set or remove */
>  	switch (op) {
>  	case XFS_ATTR_OP_FLAGS_SET:
> @@ -556,7 +560,8 @@ xfs_attri_item_recover(
>  	args = (struct xfs_da_args *)(attr + 1);
>  
>  	attr->xattri_da_args = args;
> -	attr->xattri_op_flags = attrp->alfi_op_flags;
> +	attr->xattri_op_flags = attrp->alfi_op_flags &
> +						XFS_ATTR_OP_FLAGS_TYPE_
> MASK;
>  
>  	args->dp = ip;
>  	args->geo = mp->m_attr_geo;
> @@ -567,7 +572,7 @@ xfs_attri_item_recover(
>  	args->attr_filter = attrp->alfi_attr_flags;
>  	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
>  
> -	switch (attrp->alfi_op_flags & XFS_ATTR_OP_FLAGS_TYPE_MASK) {
> +	switch (attr->xattri_op_flags) {
>  	case XFS_ATTR_OP_FLAGS_SET:
>  	case XFS_ATTR_OP_FLAGS_REPLACE:
>  		args->value = attrip->attri_value;
> 

