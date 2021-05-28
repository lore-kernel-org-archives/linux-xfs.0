Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DBEC47089
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56222613BF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 00:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbhE1Azz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 20:55:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37792 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbhE1Azr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 20:55:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14S0mvlP068554;
        Fri, 28 May 2021 00:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ER+4cYn4Z1eGg54dU2N7jDThm3IOmYo2pnTvkUV21xY=;
 b=sixdDtZCT9PCyEqwNJOvUnPxSQ+lGMZZVztOJJnZKFcDxyV0HCWTJo9SmDN95m8TbEnS
 0MSERRV6YiT+2N7Y1oN7+dn2PI9U9zkCNzE0Pm4Ve2FfeLTsFiVlffRigMpqo0NVlhIG
 M9dASWeNUET3I6jLRMZUq33cH5ZFRQ1eG7VqzgESeyuta4kIPwSYJVoyRs+PKDCHa1RP
 CQwlaaSgk01IwYQIWNZ8c3yihWUqCThA9vNHHoxpbwcLH18Je1TRAAFVFf/2ULNN8mQ5
 X1WDR0r4SjtgnINB0plsiN0kdPNrFsT2/bn6aMhEbegSbUop/L1xf0Vl2I1WEVWOHRNM Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38pqfcnq0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 00:54:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14S0k5ZZ048098;
        Fri, 28 May 2021 00:54:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by userp3030.oracle.com with ESMTP id 38pq2wy45g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 May 2021 00:54:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1PP/UJHLe2NZHxVKSy4hNmmnCB0+VuuIsX6/zE3Jtlu8i9qd3OQe22EMl9kwRa2VmJJeEmQTvEj4F5c+H8hfh3Q2lD2EJHR5kqldLXbIfBTf+UP4mtFtkshxkor3B99Pg11oD5PM/hehi7rU82EfCL9ueYKFiqeg1Z94Rabzm40nffGMksFVzWPjh2hAAiuvuQ91nGd/LHj91C54TnYXPyo0UgWDFJsTtBNyUxf4y6JV1T74fNc7JO09CZroXGUWo0UfQyiu5qUtscNkrtqen40nhJuLwV2VONKIBbWGJjwbxtaZ1dFCeyTI09fS5gY9I2fn+iY20NwUniJHioSyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ER+4cYn4Z1eGg54dU2N7jDThm3IOmYo2pnTvkUV21xY=;
 b=Ir4XmppqJAZgUng1J9S8o5dbLbq+KSISY9Yhf3IwRMHk/J7EiItE/dmLZc/8pW+fUhKbwWkrAdj7YsD1fXZL9csD+1vNBWYjO+voN0mg8McRbeeV8wrjRZ2vewEl+R2zp29qEkA5hcprBEVDSOacwRR0g+Dt9onNV9Vjp2uE6dFymdwHL0V71ZgJ3u0A8LlNfif6uOws618UD5mpTQw3zySOZ7uaq0tGwPXIvhXZTrHT+FI/exMGXq0Rml9xej97NHOdLIGRWErKvy37Qo/XjYQNVbrjADaW+GYqNcHlR2VEWk91KMrjkyFikMyLig9/QzmZZu37n/8zlRe/UQKxMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ER+4cYn4Z1eGg54dU2N7jDThm3IOmYo2pnTvkUV21xY=;
 b=y6DEHc8i/EX52nPgb8X/HioNiQI8RUUIOK/yiiOhgkHaS+N+2tGRVIvsSjkLzc7H/S9XxwMP5I53AyApGgD+Usr+AL+LRnoOOfjSYIJetmQtcxN/0/CUm/L8Rn5XfM8WC3SIzragOj8ExjBsg1mxLn+SoDWSSjfRW/PLoEDroP4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4510.namprd10.prod.outlook.com (2603:10b6:a03:2d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Fri, 28 May
 2021 00:54:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4173.022; Fri, 28 May 2021
 00:54:08 +0000
Subject: Re: [PATCH 01/39] xfs: log stripe roundoff is a property of the log
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-2-david@fromorbit.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <8146db6f-fe1c-7953-fd75-187066b048f5@oracle.com>
Date:   Thu, 27 May 2021 17:54:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210519121317.585244-2-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR03CA0190.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR03CA0190.namprd03.prod.outlook.com (2603:10b6:a03:2ef::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 00:54:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecd59510-60fc-4009-c0e7-08d9217319c3
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4510:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4510F51A31ADD5A7E0F6C9E495229@SJ0PR10MB4510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nof+zdv6+jm/Exf111ixNKUfQB/Lzg9uGXTITZ4D1gseDX8UPajwkWkZ7yom05n0Uhk+ZJ7ZPyjsVcUvjH4NvteZv1MQmqsnw1sGNfGKtvgTWAhfgS3DP+34s2CMo7dSlvmodCSQInC3uLnomA/+F/x4t/0WrITfERJqfHzPCaWflbqHKbunJeYVWTuXbBtgrqSzQTXLdvkdbUSlMhK18L7ny6fOVFwHbA6Bm+8IAlaq2XUdDsY65kjS7BBt0Kd7iNX3VwLKJp5ss0j7+zkJ+rHwrIcv0HfCtHebk6v4pJcQu5+qdm8foou2z4IV3AQ6RBmgp0eT7wnMhnR43dVbZYFlfitASjiOCX7DeMWKm/chUBVvRkEbYuWRp37bjxOaIyUXozC519SklxegsrIzL2srrcW9FssFpSs9EkWppVyIAV6jY7FSoTcLL+nrAEOEC1NSvr1nN5VMsx0C1rAY9BaqQFAXn7cdfhK9ibvPRwf0cjOs4mgc8Kn/t8Kw5CbYep+Syg4XZ3WVltb//91M+Rdcg1650IsWKFjYC3pjwOODWQ5vJQKJROXEi69a2ZBHNdcpcCJixnIfWH0rXQWAHYUKRB/5JLXQ3GRx9LLpv3LLOdWGjhsVZHIY8MkWEU5UaN4Z2EQyuDjN9KRg7l7MxIpSJiQVZ7wRlBJFLcCT+Y0Tnu38MNClkeduBam4t1ROuLcKq/jqwoGMvQA/2zmqXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(39860400002)(396003)(5660300002)(26005)(44832011)(31686004)(36756003)(316002)(478600001)(2616005)(16576012)(956004)(16526019)(2906002)(83380400001)(38100700002)(38350700002)(52116002)(86362001)(8936002)(31696002)(6486002)(8676002)(66556008)(66946007)(53546011)(186003)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QUZCajRYWkdQbVpSTGtFUkJKdSt0Y28zYlBNQytmTTl3U3MyVFhvZjBXT3Vn?=
 =?utf-8?B?MklwWHl6SE9JdXdVdEJ0SEcrekpPWC82UEZxWE9id28xRnVCY2loaXlpdytx?=
 =?utf-8?B?VlJlYmZFTXVreWtwUFFCZzVEYW1xcjhzMG43dTZ6dEVTOW03STJINng0NUdz?=
 =?utf-8?B?NGdyWUFEUGU4NjlIMkt3YXN1ZEN5OEFYb05zaGNaMHRoZzltcjBmb0xyblRM?=
 =?utf-8?B?Q2EreVJxK2VKTUo5Y0xBTjBka3ZhbitGYmVHSjZsVmRhNXdBRDcyNzJrWmdY?=
 =?utf-8?B?NGRxK2dWSERpMDY3ZXVwQ1FoUWFrMm1oTWJIRzhhekJZaGJpb0lFVWVCQ3Bq?=
 =?utf-8?B?cjVtclY3dDhZbXJaK1ZUVlRMUVB3Y0lpenBOYjYzMkpDcDZJaUM4ZE5sSCtu?=
 =?utf-8?B?akpLRVA3T2RMVlV6R0VSWmpsYTdNMnk3TUszYjU5aHkyT2FDWWljM05kb3JS?=
 =?utf-8?B?cWlHcitrc1E0NWw3ZnVuT1JtMVpMUFZFQmxCMEtIMUlxclZuc1I1ZURDT0g1?=
 =?utf-8?B?OUdzZ3ZBbS9iSGwxYmFNM3o3MUsxSThNSXlMYnNYczFNbmRNaG9zVXJQcDB5?=
 =?utf-8?B?dGp3WXFCaFRjYndFbVBMa1NxKy9LQmFmOWoveFlRM0E4L2NrMXNrTjhxSGxU?=
 =?utf-8?B?ZXdCV3hYc05STEQwSkZQMlJyU1Y5b2xVeHhySG9Gb1NodWJ5bVFHa21TVDM3?=
 =?utf-8?B?aFU0QmdvYlpuMEs4WjB6d0lqeHhQRDArSXVPSm5RVG9DZXQzUnFqV09YOWJQ?=
 =?utf-8?B?N2kvaGlMcG5qaUNOaXUzaXNMNWJOZjZ4M2UyaHVSSkl0ZEpidXNwQmdaeWNB?=
 =?utf-8?B?NVhtMlJUZDY4SzN3QzY4d200bmx6Q0VWV09zUVRBTVV3U2JXUGNMenlZeHBJ?=
 =?utf-8?B?T0JJUEtoVlF6aW5ITXIvQmJXaW5lMXNOeTVKTkFLVjRaWU95bkV6VFZWL3gz?=
 =?utf-8?B?Y3pEdFc0WWFVRVFxQXRLSXViVDcrVWZJZ24xZmtqRjgrMCtza25yQ01VWlRq?=
 =?utf-8?B?Szdpd0xGT3A5MjlxUUR1UnZoVmN4UmhrU1EvR2RtcnhhZVZnNGJGa3dEcm1W?=
 =?utf-8?B?cXI0VkFrb1V3UjJGV2NtV2xmNjYxOXdFUWs3N0VzaWV2ZE1kV1RxOXc4KzdQ?=
 =?utf-8?B?UWNkK1NqbVNnc3l3ZHNrYlltaVh1d0wyV2xnRHhFY2ZZTFFNTFQ0QjZFaXhH?=
 =?utf-8?B?bkJremYyZUt6ZmQ1bzhHTVd4NDZWMUVkVmRIVEZmejFKQXM5TDEveFNOUENX?=
 =?utf-8?B?TEs0U2VUTHhPd1lxRnVtYkx5eHg5ckFJODRIc1VLODg2cEcxQVFpVGswK2hS?=
 =?utf-8?B?ZzFTM2VKZ3VjRktMcml3T1h0Y24vRU1IMFZLRTdlYmtMSVhWRUlwcUpVc2hF?=
 =?utf-8?B?MHBTS2MxUVBFd2Rsd3hJU0l6WWxVd0diaGdyckU3Y2JwUkpQSXBXWEZsT2Nx?=
 =?utf-8?B?dmxJU21HMTI0S3VlSnBQZlFwMlhWSGdWMWQ4OEc3ZTd5UWxYUVhCQmY2R2tW?=
 =?utf-8?B?NjZFbUxKNStRV1pVN2lwTHNZR2kweDh2b3BSMURTNTN1UUdCVm51cXNpekt5?=
 =?utf-8?B?a0Y5VExpTUtwSHlGWktYbDgyMmFoR056Z0M3QzR0VDFteHZzYXhhdnoxc3BV?=
 =?utf-8?B?YVJvZXlReVBhUkxzQlh5bTFIL0NwQ3FHTGZkN2RBaGZTMjg5d3hXMnBpRjhh?=
 =?utf-8?B?WDd5aWp2UlpicjNaUm1QT0RXK2tDd1VlVDZxVEZ6bEVjUHZTRTMwazFxNWVl?=
 =?utf-8?Q?suELZ0o/1kbZTY7mjxKKfMY4F+70a5zGOieTcFE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecd59510-60fc-4009-c0e7-08d9217319c3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 00:54:08.8294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u9Xd0AQ1cm8dUs7MW8HBEkiUDQXIGZVkjEZhrY/H2L7AU+PuzmcOOmMyMXAZ65w0Hk8eOqHmz0HABlBNEoEHub8HtIjZtBtKY1dxxqG0Bfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280003
X-Proofpoint-ORIG-GUID: sDWGnhfccsvGwemnQDpXMQLw8jFCAhMO
X-Proofpoint-GUID: sDWGnhfccsvGwemnQDpXMQLw8jFCAhMO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105280003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/19/21 5:12 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We don't need to look at the xfs_mount and superblock every time we
> need to do an iclog roundoff calculation. The property is fixed for
> the life of the log, so store the roundoff in the log at mount time
> and use that everywhere.
> 
> On a debug build:
> 
> $ size fs/xfs/xfs_log.o.*
>     text	   data	    bss	    dec	    hex	filename
>    27360	    560	      8	  27928	   6d18	fs/xfs/xfs_log.o.orig
>    27219	    560	      8	  27787	   6c8b	fs/xfs/xfs_log.o.patched
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Ok makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_log_format.h |  3 --
>   fs/xfs/xfs_log.c               | 59 ++++++++++++++--------------------
>   fs/xfs/xfs_log_priv.h          |  2 ++
>   3 files changed, 27 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 3e15ea29fb8d..d548ea4b6aab 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -34,9 +34,6 @@ typedef uint32_t xlog_tid_t;
>   #define XLOG_MIN_RECORD_BSHIFT	14		/* 16384 == 1 << 14 */
>   #define XLOG_BIG_RECORD_BSHIFT	15		/* 32k == 1 << 15 */
>   #define XLOG_MAX_RECORD_BSHIFT	18		/* 256k == 1 << 18 */
> -#define XLOG_BTOLSUNIT(log, b)  (((b)+(log)->l_mp->m_sb.sb_logsunit-1) / \
> -                                 (log)->l_mp->m_sb.sb_logsunit)
> -#define XLOG_LSUNITTOB(log, su) ((su) * (log)->l_mp->m_sb.sb_logsunit)
>   
>   #define XLOG_HEADER_SIZE	512
>   
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c19a82adea1e..0e563ff8cd3b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1401,6 +1401,11 @@ xlog_alloc_log(
>   	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
>   	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
>   
> +	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1)
> +		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
> +	else
> +		log->l_iclog_roundoff = BBSIZE;
> +
>   	xlog_grant_head_init(&log->l_reserve_head);
>   	xlog_grant_head_init(&log->l_write_head);
>   
> @@ -1854,29 +1859,15 @@ xlog_calc_iclog_size(
>   	uint32_t		*roundoff)
>   {
>   	uint32_t		count_init, count;
> -	bool			use_lsunit;
> -
> -	use_lsunit = xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
> -			log->l_mp->m_sb.sb_logsunit > 1;
>   
>   	/* Add for LR header */
>   	count_init = log->l_iclog_hsize + iclog->ic_offset;
> +	count = roundup(count_init, log->l_iclog_roundoff);
>   
> -	/* Round out the log write size */
> -	if (use_lsunit) {
> -		/* we have a v2 stripe unit to use */
> -		count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));
> -	} else {
> -		count = BBTOB(BTOBB(count_init));
> -	}
> -
> -	ASSERT(count >= count_init);
>   	*roundoff = count - count_init;
>   
> -	if (use_lsunit)
> -		ASSERT(*roundoff < log->l_mp->m_sb.sb_logsunit);
> -	else
> -		ASSERT(*roundoff < BBTOB(1));
> +	ASSERT(count >= count_init);
> +	ASSERT(*roundoff < log->l_iclog_roundoff);
>   	return count;
>   }
>   
> @@ -3151,10 +3142,9 @@ xlog_state_switch_iclogs(
>   	log->l_curr_block += BTOBB(eventual_size)+BTOBB(log->l_iclog_hsize);
>   
>   	/* Round up to next log-sunit */
> -	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
> -	    log->l_mp->m_sb.sb_logsunit > 1) {
> -		uint32_t sunit_bb = BTOBB(log->l_mp->m_sb.sb_logsunit);
> -		log->l_curr_block = roundup(log->l_curr_block, sunit_bb);
> +	if (log->l_iclog_roundoff > BBSIZE) {
> +		log->l_curr_block = roundup(log->l_curr_block,
> +						BTOBB(log->l_iclog_roundoff));
>   	}
>   
>   	if (log->l_curr_block >= log->l_logBBsize) {
> @@ -3406,12 +3396,11 @@ xfs_log_ticket_get(
>    * Figure out the total log space unit (in bytes) that would be
>    * required for a log ticket.
>    */
> -int
> -xfs_log_calc_unit_res(
> -	struct xfs_mount	*mp,
> +static int
> +xlog_calc_unit_res(
> +	struct xlog		*log,
>   	int			unit_bytes)
>   {
> -	struct xlog		*log = mp->m_log;
>   	int			iclog_space;
>   	uint			num_headers;
>   
> @@ -3487,18 +3476,20 @@ xfs_log_calc_unit_res(
>   	/* for commit-rec LR header - note: padding will subsume the ophdr */
>   	unit_bytes += log->l_iclog_hsize;
>   
> -	/* for roundoff padding for transaction data and one for commit record */
> -	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1) {
> -		/* log su roundoff */
> -		unit_bytes += 2 * mp->m_sb.sb_logsunit;
> -	} else {
> -		/* BB roundoff */
> -		unit_bytes += 2 * BBSIZE;
> -        }
> +	/* roundoff padding for transaction data and one for commit record */
> +	unit_bytes += 2 * log->l_iclog_roundoff;
>   
>   	return unit_bytes;
>   }
>   
> +int
> +xfs_log_calc_unit_res(
> +	struct xfs_mount	*mp,
> +	int			unit_bytes)
> +{
> +	return xlog_calc_unit_res(mp->m_log, unit_bytes);
> +}
> +
>   /*
>    * Allocate and initialise a new log ticket.
>    */
> @@ -3515,7 +3506,7 @@ xlog_ticket_alloc(
>   
>   	tic = kmem_cache_zalloc(xfs_log_ticket_zone, GFP_NOFS | __GFP_NOFAIL);
>   
> -	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
> +	unit_res = xlog_calc_unit_res(log, unit_bytes);
>   
>   	atomic_set(&tic->t_ref, 1);
>   	tic->t_task		= current;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 1c6fdbf3d506..037950cf1061 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -436,6 +436,8 @@ struct xlog {
>   #endif
>   	/* log recovery lsn tracking (for buffer submission */
>   	xfs_lsn_t		l_recovery_lsn;
> +
> +	uint32_t		l_iclog_roundoff;/* padding roundoff */
>   };
>   
>   #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
> 
