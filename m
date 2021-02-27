Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC63C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3298364EDB
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhB0A5v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:57:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53488 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhB0A5r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 19:57:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0jatb112837;
        Sat, 27 Feb 2021 00:57:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vsyiZbU3ifgblxN5Q/O08QApNX27BcLT4fcJw8Bj5Yg=;
 b=lnmBhVdizhb5EdwOjHO8y77teCxXD43cErHwwL1BBNDhgoKVkpUs5eQg+qK4BW2KQ9Nh
 DpX6bGDWWpZ6Tm1om2NKw27OKKU8XC8b7It5uENobi2TSHbT19Z27ZQk/BHTDxHd9j1m
 QfOrApjpi6KKThBN5s+SdGy8SHhSXHuoteBX4buZRE8M0x9oU4cCkqmoy4ugGPqJ2gMl
 Oz/qnQxSs9NzwPizA43AcVSHPhbo/Q2t2Q7Gsl//uHXgukv1MVfrcNUpRKgGl2ZljWvN
 NMmZKyxXTm8W49/yaRbx+5gL7tI1yy2tMjwEbctTixKcyNgBdgBFy7C/2KKKi033DLcD Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36tsurbpp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:57:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0iskY174915;
        Sat, 27 Feb 2021 00:57:03 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3030.oracle.com with ESMTP id 36yb6rs2h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:57:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnTB5rm58m8eOpr5JHOfK7qipgXWt+Teyv7XsOq36IwGBAS+Mkr0LStxRWXpYPqLhqzR58i3Vp6tNnUUUX/GVVM9matq3bRhiOOZ2Xe3AMoYWIYghKUJn18WM0SgTzW8ALJ+TMsQwwtXT+6t3R8bPuGz1KSUtchoTXz/VdQhhFr1wP7WQTk0ta2jUc/80pgQayHoCNCW1o1Kmp7Ywz2UE9WTCv5sV8JtMmkDdQqVmVkO0v1Ru61CV+S2hvDBCDodGCvP12AcLCyjc7isBnBbQ2CNy97R0NYMJF8QR54Y4LD27VYR8BbJC8oSnzhtU/0xUfpmlMAx9maEzzv9YQHOUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsyiZbU3ifgblxN5Q/O08QApNX27BcLT4fcJw8Bj5Yg=;
 b=kDzGKi/dPZL87QsYD6fqrmxkGHhrWipO8bXDZeK++qKs0EFuqKjngClZ59ishzTiBb5FdVD1gGXnQUfLxlV9DNMUskIW6WpG+194b9MUCt65XtCTXLDL46W+bDEjqBJ6MkoJ3oCXhZ9mYMy8TAwkOaPj68z9qupDupDWjYwfRkmaBd52YVg2c+y/1cjbAyLR8uzIHMjvVLOhCO4+yyYYZDpPRkU5y2JheCDgsqbcEqlHQ2pYU2NIj8+E3J9XHC2+60zlEYWfSu4ENqcDgKQwNCd4lU9+R7bvuDpCFIQiW9CndeaNhVCDeP313d6UVrEq6Hg/fCsR/6w84EdRU8WzwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsyiZbU3ifgblxN5Q/O08QApNX27BcLT4fcJw8Bj5Yg=;
 b=wQDTAbkRgR+qW794YkzXC3EX6/ULuGCBXqanaIF0AgjtmfJEUmbauStn3ZFQl+0KieB6LREu1FCw3k1wpSCixyKSMCD01ahPigYCtCBwz1Iiq6E14viI0d0XMiKt4J7c0m+CWwGG1vWkyQJpUmhAiJSAAzTWGob3ecJXqv5bvkc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3858.namprd10.prod.outlook.com (2603:10b6:a03:1b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 00:57:01 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Sat, 27 Feb 2021
 00:57:01 +0000
Subject: Re: [PATCH v15 18/22] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-19-allison.henderson@oracle.com>
 <20210226050009.GY7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <4acb797f-6f9f-c767-d0ae-5d65d25072da@oracle.com>
Date:   Fri, 26 Feb 2021 17:57:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210226050009.GY7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0206.namprd05.prod.outlook.com
 (2603:10b6:a03:330::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0206.namprd05.prod.outlook.com (2603:10b6:a03:330::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.10 via Frontend Transport; Sat, 27 Feb 2021 00:57:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32a15356-2995-4285-fe00-08d8daba978f
X-MS-TrafficTypeDiagnostic: BY5PR10MB3858:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3858F0952BB4F3E378BAA4DB959C9@BY5PR10MB3858.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YWV1a7ATnehxn+9KJT9n6tQFCU/ZUjoQVMArXLZhZpJ4xzd8IqEzbobcMyuDlbyvHLdAzY2Eh6JPDNtzlll91qBcEW9Rj9mhlv+Kqnv/5t5e2x7NyIsCxkwVoEX/bU6l6qxTVVGqcIOfxie+vE6UZdJ4xtnrtZ6XHX82rY5uDnkRMkK5M33drhedJkf0Ag9ppvd5ZW9vrJmaUiW6rsr7WC3kove60tdoY3YOd5yHxu+QMKUCn/KeyR6Lvw7vQDiVt5eNAqeOPqQIHnabbNMENB7KV/xM7ux1zEeOzlUbuicNBTSPufONDisRzTEFAzA3HMYRpqGh682WSZ1T4D+3ZhcNy5hbISmq1bLF8KihVEjSitzC8fydoCVkmJqs0qIczwtgQhONAXGIrN6ePm+fIkAvDHh7rVUcGfeGiR29AnN/AWUq630XlGDzhSeGsXtQ5DS8P2fU2zPCA4NCYDN3ZJNSb5/Y2PKTzrh95BiUNN+D1iEqfDdzjk5zXsSuBm5fWjOsFoOt93agtWlAnYz+SPhuPrGtTKB1gLc/+mIvYht4ALW+DVK/Rj/Yy1vGLe38qeph1KdPkj5QrStWmQjy1SJUUU1FKvpJTZUZDGVVxrw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(52116002)(478600001)(6916009)(86362001)(4326008)(2906002)(31696002)(83380400001)(5660300002)(6486002)(316002)(66556008)(66476007)(36756003)(16576012)(186003)(8676002)(26005)(16526019)(956004)(2616005)(44832011)(31686004)(53546011)(8936002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VzRZUHExRFR2WEIyN1FhbmY0UVZtV20zK3ZBZU4yRVBtNFUzbDMzM1p4V1hq?=
 =?utf-8?B?dlV6RWg2SytmQ0xLOEo5TnovRjhCVmRrT0lqcCthdFNtOFJzYmFPdHNwME8x?=
 =?utf-8?B?Qkk1K0hkdWNEWXJGcWxoMWlNUWdOZSt1U0Q5WWpTQ2JQSkt3ajFKTjBUdldO?=
 =?utf-8?B?OGF5cWpBYWN6bU5lNFc2UldJR2t6MUMyQngydnd3bnJGbWxhNlNudkkvKzhH?=
 =?utf-8?B?ZkVPQnVabjRMcVZKQ0Zlc3UxMTNUMzY5eVlXcVR3VWQ5YzMxVjlERFE2SWtU?=
 =?utf-8?B?ZmZzL2dRQzBsSjdadCtVU2lHSXF4TURnT1B4bXFUT2swL3pRcVV2VnpjbWti?=
 =?utf-8?B?eklnRFJnZUMvbzA2L0U1ZjU3ai83RzhkMmFkMCt3OE9VLzdhVVZGQXVMRHpz?=
 =?utf-8?B?MXVBTWNiMHRpNWx2N0NwanhiM3pOVGZwTFgzd3hxbEdEdkk0U2JjbkZMclp1?=
 =?utf-8?B?dmdqZkZrRzZRUFA4aXJoM01GWXpGdUxSOFJVWWl1ZDlLWkoxM1p5cEVsbHZ4?=
 =?utf-8?B?NmEyMzhJMi9TL29qY3N6Smk4bmR0NnFBUWtNTkc0UEVrNEV6dFRNbkNZRFlP?=
 =?utf-8?B?VXVmUXBnalh6WjZYVGtXbzhVRXRYNHRQWTVuVkxsRWRoY1hkSmIvdDNvK2Q0?=
 =?utf-8?B?dHRGMGVISStnK1hvTWVTMVFGM3RZSlBaUnVxSkNRYmtydkZ2M0Qza3pmSzNM?=
 =?utf-8?B?NW9sUFJEeFppMC8rM2t3K2lMdGF3WFlBUDViWDVTU0Y5RGVyRTBLWE9NK1o3?=
 =?utf-8?B?a1I3TUlORk1CTEM0WW5VZ1N2cGUyNEtwYkFXM1o0a3pYcVRZYTlNN2RUQUdZ?=
 =?utf-8?B?WVJGWVU5aTFJbHpoUFVXeWg3bUNLaktMSFQ5R1pGQ05ESXdEOWN3elJmM2lF?=
 =?utf-8?B?U2hUTnUwOGE3a09EUzlYYzdNcFFkdkNUMVQ0QmM1YllucHIvUXhtZFFoL3Bw?=
 =?utf-8?B?YVJ6UWN1Sk9xS3Rxd2pSOE1nNEZ4MVBlWFZsSHFXdTgvWnhTM2ZUSThtN3RK?=
 =?utf-8?B?dkN2ZGhXbysySW9EVm5SandBNHgrVHRvMUNQcGt3V1FHai9BYlVnSWV1Z1FU?=
 =?utf-8?B?UHEzeTNZQjRVVG56bXQwU0pGRVYzWEwvbXNtMFFYTmlzdTdCbS9DSlVDRWxv?=
 =?utf-8?B?dXZpY0RYRzVqdWFOMUxJenBpQ0R4V2p5eG5HaU81eDNraEZES1NZc1AxUThI?=
 =?utf-8?B?d1ZOVHFJSVBZZ0cxV3VFcTFnRjRGS2RQSW5EV1JBSDZNY1pZQ3lWeCs5alZ2?=
 =?utf-8?B?MW5TZ3lnU2RibVhFdDVza3NVRDJHUjdUNFI4U09haU5BOXIvQy9tcUpHV0gz?=
 =?utf-8?B?SGsrU1B3L3ozUUI4TDRVNXBXbitQYUlyUHhnZGNrNmhzQnBLaWdhTS9MT1Ru?=
 =?utf-8?B?WnRlempESWc3aS9UYWEzTUxONmNGMllZUzFaR3JVQmk2dSs3V24xaXh4cy9o?=
 =?utf-8?B?OFU4SmlCVWRkVHJ3VTRpTzg3OGllM25QVVpOZEIrYWxmWEZIRGJDdkVsZzhY?=
 =?utf-8?B?NkNGNVpGNlFqMFd5SmVpazQwZEEvRGtLMlJlRXdaemN4NWw5SzBWMTJtakcz?=
 =?utf-8?B?akxzMFNzUzRnUUk0clZsUzMvK21yM1ZqS3JFYTJzQXZvWXlMUStVbnlEUTZ4?=
 =?utf-8?B?dGFBdDBucFpJaE5kNk1Cb1ArSDAwWWU4UkxISExKZGVCYmZ0MWtXVjNYNW4y?=
 =?utf-8?B?K2V3cGxXQXQvc0NleGVnbUZqaUhTbWJ5UTVEaCtWdERyVWdYMlhxNnJVellW?=
 =?utf-8?Q?bIML6Not6VHqlz5iU5jhbGlvzuR7S/OmsYhIxsy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a15356-2995-4285-fe00-08d8daba978f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 00:57:01.5140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QqRdbfhyQYfIbYaQ6dy9UP17Xz7XlG7SPz+T+jVbIcAWIor36S0Wj4fQKM7/tmUoHAFXtOOG1BCNPc7IL18VAWaYwon93hoMn8dEibftMxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3858
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/21 10:00 PM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:44AM -0700, Allison Henderson wrote:
>> From: Allison Collins <allison.henderson@oracle.com>
>>
>> These routines to set up and start a new deferred attribute operations.
> 
> "These routine set up and queue a new deferred attribute operation..."?
Sure, will fix
> 
>> These functions are meant to be called by any routine needing to
>> initiate a deferred attribute operation as opposed to the existing
>> inline operations. New helper function xfs_attr_item_init also added.
>>
>> Finally enable delayed attributes in xfs_attr_set and xfs_attr_remove.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Other than that it seems fine to me,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Thank you!
Allison

> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++--
>>   fs/xfs/libxfs/xfs_attr.h |  2 ++
>>   2 files changed, 58 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 666cc69..cec861e 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -25,6 +25,7 @@
>>   #include "xfs_trans_space.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_attr_item.h"
>> +#include "xfs_attr.h"
>>   
>>   /*
>>    * xfs_attr.c
>> @@ -838,9 +839,10 @@ xfs_attr_set(
>>   		if (error != -ENOATTR && error != -EEXIST)
>>   			goto out_trans_cancel;
>>   
>> -		error = xfs_attr_set_args(args);
>> +		error = xfs_attr_set_deferred(args);
>>   		if (error)
>>   			goto out_trans_cancel;
>> +
>>   		/* shortform attribute has already been committed */
>>   		if (!args->trans)
>>   			goto out_unlock;
>> @@ -849,7 +851,7 @@ xfs_attr_set(
>>   		if (error != -EEXIST)
>>   			goto out_trans_cancel;
>>   
>> -		error = xfs_attr_remove_args(args);
>> +		error = xfs_attr_remove_deferred(args);
>>   		if (error)
>>   			goto out_trans_cancel;
>>   	}
>> @@ -879,6 +881,58 @@ xfs_attr_set(
>>   	goto out_unlock;
>>   }
>>   
>> +STATIC int
>> +xfs_attr_item_init(
>> +	struct xfs_da_args	*args,
>> +	unsigned int		op_flags,	/* op flag (set or remove) */
>> +	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
>> +{
>> +
>> +	struct xfs_attr_item	*new;
>> +
>> +	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
>> +	new->xattri_op_flags = op_flags;
>> +	new->xattri_dac.da_args = args;
>> +
>> +	*attr = new;
>> +	return 0;
>> +}
>> +
>> +/* Sets an attribute for an inode as a deferred operation */
>> +int
>> +xfs_attr_set_deferred(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_attr_item	*new;
>> +	int			error = 0;
>> +
>> +	error = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_SET, &new);
>> +	if (error)
>> +		return error;
>> +
>> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
>> +
>> +/* Removes an attribute for an inode as a deferred operation */
>> +int
>> +xfs_attr_remove_deferred(
>> +	struct xfs_da_args	*args)
>> +{
>> +
>> +	struct xfs_attr_item	*new;
>> +	int			error;
>> +
>> +	error  = xfs_attr_item_init(args, XFS_ATTR_OP_FLAGS_REMOVE, &new);
>> +	if (error)
>> +		return error;
>> +
>> +	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
>> +
>>   /*========================================================================
>>    * External routines when attribute list is inside the inode
>>    *========================================================================*/
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index ee79763..4abf02c 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -462,5 +462,7 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>>   			      struct xfs_da_args *args);
>>   int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>> +int xfs_attr_set_deferred(struct xfs_da_args *args);
>> +int xfs_attr_remove_deferred(struct xfs_da_args *args);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> -- 
>> 2.7.4
>>
