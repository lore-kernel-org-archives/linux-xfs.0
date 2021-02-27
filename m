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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E34C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15E4F64EB3
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhB0Atl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:49:41 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36826 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhB0Atk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 19:49:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0j6TX100238;
        Sat, 27 Feb 2021 00:48:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=VYeqj7q54be2paXj4nnxUuJ36jhFkAhe43tl0wyoumw=;
 b=0CY/P1C3myxxs8o40tvlBOEnmiDOi4AqgXkRhZbbUK1iuxoOT//ttsNQpM08tk5MRv9l
 6ZqTqpv/ytUHaS9NGQmR6YO3ueS6hJ+7HXqXFcWdpNDJgBXg8L7b/6rkRDVLQ5TBq9gi
 5B/tcw0NkuH6QvvBpMDOyIj6OO5hL9NU1mrDnu4IS1faUGG4x7O9wQUcFr80PrLwXKOC
 8lM4KJtVL9bh4iBu6synp1Vsinu7jVfAaEtFbglH7Lsfiex9O78K8HhaQa/e01yODZzf
 rZL9s6iBMLzYqIRgzOOduOLMJovFRNbVMB5w5BRpVk8OurdgHpFUQdl+74JY+OmXvBRG TQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36ugq3thu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:48:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0j1Yk044032;
        Sat, 27 Feb 2021 00:48:56 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3030.oracle.com with ESMTP id 36v9m98ky4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:48:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dLtBGSloqvQqkjHcZNzO2+mn9a1h10edjrJAmNkqagFIu+Pw5LggCM2xxCdhOCG5F8duvRP5mMnKvGfgI7UC2VvMv0QVu36XYTrygkMeHYMdygh/eq9LPTgTPPF5V9msnXc4N66375GjSSXj7o/ZqXssrIjNMjWYxu2LAmtzf4T2f6bhIjDStvpN0Oa5ExD+sfI5nllgJhPApu3juqKp6MxD+VIy2x0zkYS1vOUSSWwGp6Sk+1YlK4nb0qbguRZ0p98HaTfkrH6f5+wRNeCaanhosHJaWV/84AX46fOMMMOHbbzs5MVO6yOS/C/7r7qslIXb/mTPPFpbX2PCoXh5NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYeqj7q54be2paXj4nnxUuJ36jhFkAhe43tl0wyoumw=;
 b=fKXwqiaYfYN3pLDfLloZjgAdeD0TUpXlZHquIGFhEFS9eBufDvy0uxHMnfrykdJPgVk020tTJFgquKoeiBQpHf8WibuDgHmhfpgsFfWtkvkFG2MXQCxbg4NRGBTZufeFIY/9tZaHe6TU7Kk1Jf0Wrn5sFthqUsI/t5lui/P3N7bQlor+3jMqMZHffqV1pKU+QgGogoQ/V/7p7G22LrGGMiHqyNVtR7yyKNKuO7VE1vRAvM1UjRExLB5Uxnj/ChpJntj0RYmFM1W1724hGCvi4F0o8WR9mbsZpNccnqhiiR6/xQoDhRJqxZiJmijNfLBQE21XCcWptjSW04ByuInxIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYeqj7q54be2paXj4nnxUuJ36jhFkAhe43tl0wyoumw=;
 b=uhinHgZo9SfZl3NuQAOQZdZcMOu7Jf/F0osRDnE2ASdl0iYvQcInNUjdKMUNojCO0wkS9g3MLlD+nLlzfanUzcCzABIwVX1VGQdoBlZpxrJM1c6xga/sAZi1jGeyO+xp9Yzdl1XRJDy9AuUjgPllHZ7edTIItWJ69uyh6axGpTo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3335.namprd10.prod.outlook.com (2603:10b6:a03:15d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 00:48:54 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Sat, 27 Feb 2021
 00:48:54 +0000
Subject: Re: [PATCH v15 04/22] xfs: Hoist xfs_attr_set_shortform
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-5-allison.henderson@oracle.com>
 <20210226030343.GR7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a6e29832-62f6-d782-7e20-78b27079a4ed@oracle.com>
Date:   Fri, 26 Feb 2021 17:48:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210226030343.GR7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR13CA0169.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR13CA0169.namprd13.prod.outlook.com (2603:10b6:a03:2c7::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Sat, 27 Feb 2021 00:48:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69dc2ec8-d940-4fac-c4fb-08d8dab97506
X-MS-TrafficTypeDiagnostic: BYAPR10MB3335:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3335656F65A48B4A7470ABA4959C9@BYAPR10MB3335.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +LJWRVZX/ZIdGN+aECk8bzDetbdmRfHIkZkmbmbwEO1eALV3Ooub9a/QK3t0QChIW8Yes/h4Z/kdQ1pmyI5zNmFDW1wUgqHzbmRb1YY82GN/Y/O271OSiPKgPprWKVIFH5cTuw5a3iAQskFDQnTY8l6PWMp3O6VuKG3M6lUy91LgdGziTIjIU418xdi1gvB3mT58spgyqqn1Syti6mRhigAZnDp+sy1j9v7cIVVOpFWLb0tiih0qMqeMFoEK34xk5cwabBYWHUpNuL7FNfc8ub6g7XrLqFepdCvuFmcT8bxeeC9N5z5Ensbc5xQaCdFrZosCE4wfRS2NSE+r+VKV8K5SIUiCOYRV1+vCFCNUlzjgY4yi8p1jsG2roq+OoVIkwHsKrK3wITfLilUTCHmEAIrEOem3KP3W4PnvJybM707FZPnfQ1G/B4PQtVi9tetxNjuOagJnnqT9GjYNuEzttapXfxATsEhHUh14ppWCGgsuAgz6jQyVN6oHAUTNj2KNvVOs11Jd9LVb1/NPyS3nxufi623+K5f4rDnmYPmHcl9oKlVKhf4cXibNRWZHnl7tgC8jQAlvkBuI8fPy9P9sadeK6kdRHOsMtZd8xBfXG1w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(39860400002)(396003)(8676002)(31696002)(26005)(8936002)(52116002)(66946007)(2906002)(66476007)(36756003)(5660300002)(6486002)(44832011)(83380400001)(186003)(16526019)(53546011)(6916009)(16576012)(316002)(66556008)(31686004)(86362001)(4326008)(956004)(478600001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ckdsblV1QVhCWXZSdmdTK09URm41VEptRGNYSUt1RU9YM3VVdjUycFdxUzlN?=
 =?utf-8?B?eHdpdkpiVVllclZxcEZodjNxWG4rUDFGUWowY1RqUlhiaGlkMWdnczNWdjQz?=
 =?utf-8?B?d0dTSkhWbEQyYW5kOEExM0JmTXMxWDU4UXBvenZzeVRaRjdLVkg4TTlBZ2FJ?=
 =?utf-8?B?UU9lNjZxZ2FsZUFoZnFqVE9KaXRxajJGUlJ0ZjNncUd3TEVXdGRKRXBJNnhG?=
 =?utf-8?B?VGJZdk5lRVZ2cDNsMlo3Ni9BMkp0SlgzSzZqT3hFTmR3dTZsYzkwNHR1OE80?=
 =?utf-8?B?bEh3enJpTVd5dUJNMUxucjQ5elEweVR6dCsvVVJmMGJwc1NrbTVJc0liZEpE?=
 =?utf-8?B?amQrSC94NFczK09HZm0rQ3NHcmxhRGxMZEhNRldjU3ZaQjVCMkVrTTQ5b2Q1?=
 =?utf-8?B?WmV1ZUQvZG15Vnl2cmlrV2JaRklodWF2QmlmRHBwdG40T1Mra3BJTXhiaFJv?=
 =?utf-8?B?SDVlR0x0V0svWHhzeFNtUnBjdHhyUkdqbEtPS0RjR2lzRE5FbnFVVk1WalBr?=
 =?utf-8?B?Z2VaeG5Qc29xNjNrYm40WGNjNS9HM3R4ZCtnaEo5UTZzUTJ5ZHQrV3oxbEJ1?=
 =?utf-8?B?dWY3TTQwUmZZUXkzQlVwcHowSkxFZklYYTZocWZzWTlDZE8veDBPT01FandJ?=
 =?utf-8?B?bTMzbFRpWHlIa3Z4akhNOExKUEQxaEh0QUpmTnNJeDBPSzZpUlAxYlNJdjZ3?=
 =?utf-8?B?WWs3alJlNEErMmIzNTExTDZjY2d2VjVHb1c3QURmZWNiVVdtWDZESTFlcllm?=
 =?utf-8?B?YmVTWklLT1ovM05jdTd0SEZFVXBibDl3VExTWlc1cUMrNzhjekxMZURORThG?=
 =?utf-8?B?RVFyaGRwblBpUDFQVUI1M1AvSjZpY0tWclJNUFB6MWFvT1laS1UwR1N6UWhl?=
 =?utf-8?B?b0IvajlVd1daWmVhVnRLNEVxQXpHSk4wVmsyUXo2ZGR6ZjVKOEhaZGt5NG1j?=
 =?utf-8?B?NkZESGtIS1NDQVBka3NYa1dSRkd3S29TdzZoVm9VZ0JKV2dZdXFkZ1JRb3Uw?=
 =?utf-8?B?LzFTbEVaTm83dDltb1lSakJEUXluemc5WTgxRzBYazlKcUtYM2VPdnJCb2Qz?=
 =?utf-8?B?MHRuN2R4ajBsM25WOUdNdVpjb1EzTnF5bVQyMlMrU0hsU3FMTnlZZXFTemNq?=
 =?utf-8?B?Zmhwanp6ay9LQVNVSFFrMElqMFk4OHFzZ2FEc3NKZHFzK3c0djFhSHNwWnFC?=
 =?utf-8?B?d3JMckFIUTUvYjlHMlZvSS9WMFV5c09zMlJRTVMxL1ozWWw4cWRlOURjTDg5?=
 =?utf-8?B?d1pIRmJRMGNvcDNDSmppWjNuZUl0VHBaU3pkN2l6RkI3OC9uN21kcFpiem1l?=
 =?utf-8?B?eFdyeXo5eThjbC83RzN4R0srRzhJQW50b1loODF2bXdSSnk0YnZtMStrOWtz?=
 =?utf-8?B?aXN6L0duRVRjUlZPK25FTm9LSGxOeHdyR2ticDdCZzJGTVBkbW1VVlNsQjd4?=
 =?utf-8?B?NFBGUmp1NHpSd25mbE1Lbnpsd3c2OGZWeHl4T2F3UmF1elRYVVd0a0NKOGRW?=
 =?utf-8?B?OWx1aVdvejcwS0lGV3dSbDJ6dmVXcm9UVEFQMEJLd21kWEtCQlZFcUVlSFJl?=
 =?utf-8?B?bEJ0SndSamNkWnNMY0paTUVoUEZUZXVmQ0FqSXE0T3lHaXlXOEo0MkNFWUky?=
 =?utf-8?B?alZ3WloxVzFMVGw4ZHhZNkVkbkpSVitsYzE1OEtNKzZRaXI0ODRWcWVIM0V6?=
 =?utf-8?B?ZWR2VjI3anVwTWs2RmFya3d5WmNqQTRVRjFtekdMdldaaExXMkovSDNzUG9I?=
 =?utf-8?Q?OWEZjxzJLmGTvEvtRlsoy/x7Mj5inwK/ya+wkbW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69dc2ec8-d940-4fac-c4fb-08d8dab97506
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 00:48:54.1083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyR/DLLhky5UBbxSWid7ZnuDaNfqsQofk6Ngb8dolVW99eQoxk4g8KnVYmPyV6ZFYyKUS0+GNt5qV6abACE7+FMWCOJXJIHEz8My3p2BPjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3335
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/21 8:03 PM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:30AM -0700, Allison Henderson wrote:
>> This patch hoists xfs_attr_set_shortform into the calling function. This
>> will help keep all state management code in the same scope.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Whoah, /removing/ a function! :)
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Thanks!  Yeah, in this series we do flatten up a lot of helper functions 
with the goal of getting all the states into a single function.

Allison
> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 81 ++++++++++++++++--------------------------------
>>   1 file changed, 27 insertions(+), 54 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 3cf76e2..a064c5b 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -217,53 +217,6 @@ xfs_attr_is_shortform(
>>   }
>>   
>>   /*
>> - * Attempts to set an attr in shortform, or converts short form to leaf form if
>> - * there is not enough room.  If the attr is set, the transaction is committed
>> - * and set to NULL.
>> - */
>> -STATIC int
>> -xfs_attr_set_shortform(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_buf		**leaf_bp)
>> -{
>> -	struct xfs_inode	*dp = args->dp;
>> -	int			error, error2 = 0;
>> -
>> -	/*
>> -	 * Try to add the attr to the attribute list in the inode.
>> -	 */
>> -	error = xfs_attr_try_sf_addname(dp, args);
>> -	if (error != -ENOSPC) {
>> -		error2 = xfs_trans_commit(args->trans);
>> -		args->trans = NULL;
>> -		return error ? error : error2;
>> -	}
>> -	/*
>> -	 * It won't fit in the shortform, transform to a leaf block.  GROT:
>> -	 * another possible req'mt for a double-split btree op.
>> -	 */
>> -	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>> -	 * push cannot grab the half-baked leaf buffer and run into problems
>> -	 * with the write verifier. Once we're done rolling the transaction we
>> -	 * can release the hold and add the attr to the leaf.
>> -	 */
>> -	xfs_trans_bhold(args->trans, *leaf_bp);
>> -	error = xfs_defer_finish(&args->trans);
>> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
>> -	if (error) {
>> -		xfs_trans_brelse(args->trans, *leaf_bp);
>> -		return error;
>> -	}
>> -
>> -	return 0;
>> -}
>> -
>> -/*
>>    * Set the attribute specified in @args.
>>    */
>>   int
>> @@ -272,7 +225,7 @@ xfs_attr_set_args(
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error = 0;
>> +	int			error2, error = 0;
>>   
>>   	/*
>>   	 * If the attribute list is already in leaf format, jump straight to
>> @@ -281,16 +234,36 @@ xfs_attr_set_args(
>>   	 * again.
>>   	 */
>>   	if (xfs_attr_is_shortform(dp)) {
>> +		/*
>> +		 * Try to add the attr to the attribute list in the inode.
>> +		 */
>> +		error = xfs_attr_try_sf_addname(dp, args);
>> +		if (error != -ENOSPC) {
>> +			error2 = xfs_trans_commit(args->trans);
>> +			args->trans = NULL;
>> +			return error ? error : error2;
>> +		}
>> +
>> +		/*
>> +		 * It won't fit in the shortform, transform to a leaf block.
>> +		 * GROT: another possible req'mt for a double-split btree op.
>> +		 */
>> +		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> +		if (error)
>> +			return error;
>>   
>>   		/*
>> -		 * If the attr was successfully set in shortform, the
>> -		 * transaction is committed and set to NULL.  Otherwise, is it
>> -		 * converted from shortform to leaf, and the transaction is
>> -		 * retained.
>> +		 * Prevent the leaf buffer from being unlocked so that a
>> +		 * concurrent AIL push cannot grab the half-baked leaf buffer
>> +		 * and run into problems with the write verifier.
>>   		 */
>> -		error = xfs_attr_set_shortform(args, &leaf_bp);
>> -		if (error || !args->trans)
>> +		xfs_trans_bhold(args->trans, leaf_bp);
>> +		error = xfs_defer_finish(&args->trans);
>> +		xfs_trans_bhold_release(args->trans, leaf_bp);
>> +		if (error) {
>> +			xfs_trans_brelse(args->trans, leaf_bp);
>>   			return error;
>> +		}
>>   	}
>>   
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -- 
>> 2.7.4
>>
