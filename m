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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F22C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FE15613C8
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhDTR5H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:57:07 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18688 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232473AbhDTR5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 13:57:07 -0400
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2021 13:57:07 EDT
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KHUZm6016483;
        Tue, 20 Apr 2021 17:41:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ccN2/tP2g6/bdjaX5VfawDJnonM0/D3CC4aiqrdXijY=;
 b=UQP5DvN1zCQYJ7F+0Yk5UdfqjBwbNGnt8wrgb/9s/zI8HUc0+rvUAc3AwnzFJut7w0lF
 jGVjhsC4GsBuFF4yhH6OC7uVtAi+Ryha7ZrgksRlw9idGJPCrb3VwNqArSJM94HSxfJW
 R/Gzs2AhqWK//Mc4xU8JQa2jDWjzpwx1P6t5/uVdnOzfFL5FgO6jl8yUz0BslYfe1AbQ
 rqHPKb3othkWYRpEOPgPevBrEBgw/TO4r15bfzdk+G6Ieejbxu/g8079JdkX0uledQeR
 An500q+DV3HvzqDRIW8Tya1uiIrFEf0OcdHomDdOgTfWjUsmK9/Ze2pH4ZeBWYlq/tui Fw== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3818ujgcjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 17:41:21 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 13KHUqrL190782;
        Tue, 20 Apr 2021 17:41:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by userp3030.oracle.com with ESMTP id 3809kycwhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 17:41:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWUzvRufRoN55MtL2K2JGgOhYygSOzaiOmsOIGXItKzgO5n9UzM7+EnHbHKpaDCg6GXaMiTf8SR/oN/hybiaD1BrJxcHPuaoEQbOrUERElP8zik8sS56281KcIw4DJFUqWwFwHdHJnbC+IMAggyRzW4kJ3eoVluG0KI59inB69TivAmIw1bJN0nBfJ+hguM3UNdjVWV82apf83/8QdBgEA/qtbsf0kH2Wf1qT1ug0eJGJNgrRKjd6StCnTLTRZArhm/MejmN5jgXd68xMobGKH7W9RxycNUjY/j7YLLQGD+Ya32/llQIM190GtYElkdigL80jKL9bDvp2kPVDy9BSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccN2/tP2g6/bdjaX5VfawDJnonM0/D3CC4aiqrdXijY=;
 b=Gm0AWVZjNpbtDxrrmkXJEyn96bAehTrPx6BxgnxzQ1bCM4TwHk0DighcD97rm3RyyyGYJsP+8sLrJAyVLuY90DRvWLsU6Iz0HZ8OaBzbkV5IveFMv1hywaR+H0tRVvARX8R+oxgwE5rJbgTApWd1BP2d2CPc52iTxQTU0xwvJ25y84/4tZdFe8nj+uU+ZGbkuKC0USSOnt0CTX6Nkt+d5pKxXJM8MKRtcguG2ePEs9Jo+R4eHV9AHcn3VQuqeiO6fTSYZiXO83jUje0YLK0m5rqgS6ZuTRkTkuJSUG8H8HqmGdDZ8hAAxqYxqI+kbBO3ZpNIFYgQsHQOi63PLDS5BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccN2/tP2g6/bdjaX5VfawDJnonM0/D3CC4aiqrdXijY=;
 b=jthDYsegqB0oYyjCCt4UJmhCOSPPI79WS6sQS5xNkKrLAbwFTreCdcU0Lz8DX0zAGYxair/gwKwyt3f6Yb+LMuMO3NsHdxvpoJYpiMfAhAyNU/e+4NCLpDlEEnnN3ua4OXZ7A3qH7+p5LXAKni/ed4IbklIBOgFvYVjItIx+wF8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3956.namprd10.prod.outlook.com (2603:10b6:a03:1b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.20; Tue, 20 Apr
 2021 17:41:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 17:41:17 +0000
Subject: Re: [PATCH v17 05/11] xfs: Separate xfs_attr_node_addname and
 xfs_attr_node_addname_clear_incomplete
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210416092045.2215-1-allison.henderson@oracle.com>
 <20210416092045.2215-6-allison.henderson@oracle.com> <87o8eaj1mr.fsf@garuda>
 <a83a5de6-2e6c-c4ec-12cd-b99522e83bc8@oracle.com> <875z0hxie5.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a710ffc8-61eb-0900-dc16-2890cf1c8c0f@oracle.com>
Date:   Tue, 20 Apr 2021 10:41:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <875z0hxie5.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::43) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BYAPR05CA0030.namprd05.prod.outlook.com (2603:10b6:a03:c0::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.8 via Frontend Transport; Tue, 20 Apr 2021 17:41:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06f6d530-0ab0-4358-3707-08d904238064
X-MS-TrafficTypeDiagnostic: BY5PR10MB3956:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3956E2D5347EF8BABB9882C895489@BY5PR10MB3956.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XS+lc/JXXemzSYM/G3KQdPrksqmp4HmLDOYGvBk8GckTrqZJ8Tt/61JCR01b1w4K5c1/eYSKvK+mAjPzERac8vuKdC2mwldwet/HB2hkXftZfbtKAvPytffCcThOagJOpDCW5Ls2wc/7pJQmQzkevAuOvFFL7mNC5T+Rvd5VoClgbqFtZsKVFxdSpvgekW0DIKS4cWbqmAAUYKetwPyQk2Gy3CzjPMpRwnykeo9WETEL3xjrgrurJTQyg2sLmmzzXJ6waadLzxDO869HhDjY9+S013Mi9JfiVJfnUXIrRPk9nsh9fZ5htFKFhAaVEtKLw37MSQYFLxqdlYyfEob3wNQfPtSHp4tzIj2AiWhLmduYwM1slfJX+/wJMd+2TCgFKpOfo2FEL9rHUxqDAa5+Ef7ezJPrrSdHhGF1zeI62C7JU99fXMNYvBq4PzxqkgPUKM/SnrIgz4+GTfbr7jHeZMt22tgIrJtIFEH46gtLmAhBanjXDemwRT2PpHuD5GW5BJCyuhhttyxu13RKYzJ0cF7lTbLUqx3MrViAEYZNjXvKVQijXbUcbxKYdUyJHAmiWdSgLRaM3PRkC5svrfO3icUWimVr3042C8mEm4gjIYCUu3tdPpXwcuwAhrcd2mFHOzUzh4QEQ1+l8nfUX1x0hxbXZhh97FW/zHweP17DdY+TESeb+GKXW+OaPywzxF9rjDQiVxwnficSSVNiiqiKWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(346002)(396003)(376002)(38350700002)(83380400001)(66556008)(38100700002)(2616005)(52116002)(4326008)(66476007)(478600001)(956004)(8936002)(8676002)(66946007)(36756003)(31696002)(16526019)(31686004)(86362001)(53546011)(186003)(6486002)(316002)(16576012)(2906002)(6916009)(26005)(5660300002)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R1FZcDM2LzJlSnR6aUVtVnNLVXhNcVFxU3ZUVUYvL0R3dnYralV3TkZmZ28w?=
 =?utf-8?B?MUY1eTVHY2xZckxGRHZZcW1aTXdFaU1pTnlrc08zeXllNzdOUFZtakNIdjFx?=
 =?utf-8?B?UVJIamdHUDBwbStOS09Eb3dhUjFOcEYzeXdGVU9scTU4M000ZzR4dmU4TTg1?=
 =?utf-8?B?QTJrUVRDYnNLVldEUFRxV2paYmw5WEFmZlNBQzVaVkpsWUx5ZEROdzBOTm1J?=
 =?utf-8?B?M2MrYXBRdkdvVWxBRmtOSjlvR3Vva0tZQnYrdEZTTWtnRDZjZ3p1dFoxVThN?=
 =?utf-8?B?Q3JSQk1IcjU0VUdWSjkvbkxiNkF0YXRwQ3k1aXUyUTBzK2Y0blkzUUZwNHFW?=
 =?utf-8?B?czcvSVl2dDc3OE41Umo0aVFrU1lrSmsxTlhQYm9Ca2Z3NVp4MU1tT2VvNk5Q?=
 =?utf-8?B?aExGSDR3ek5HQTF3TFEwTVhBVXBYanR5VysxeTlOUSs2RmdWRW5XUlRlK1A1?=
 =?utf-8?B?SFlYcHdUb2l1Rzc5Nmk2b1RGWHUxZElBUDR4dDNYbzhzMmUrQm0zdGh5ZGdv?=
 =?utf-8?B?eUNlYW02ejdiMlEvNUFWYWxuelIxcjg4SWFDaVVaK29YbUpDRUozK1JoUUF5?=
 =?utf-8?B?ZTNDTjIvazFtVlVMR0N6WkR1OGQ3YmN5NGJjVlF6am1odGovZmh4YmFhbENk?=
 =?utf-8?B?dkVubEJPdFovM2ZQaWorSFFJaHB4Z2FQdkNlSTFYbHVpTCthR2FCMGU2OTFz?=
 =?utf-8?B?V2NkaXZJcCtYb0RhTjMwR0tybGJzOXJjN2hiSVFyTE5JeGZUdzRsTGRhaGpZ?=
 =?utf-8?B?cWVzWTNjYk52NGtjVkYwUXNIa0hvLzBLUi9RZS9GUzdvcWVUUEVPOVlyYUZI?=
 =?utf-8?B?Yy9XcHRLRGNBcUNFK3BIWEYwbVRlVkpVRzVDOXA2cllhVjJHMTBlM1dQd1NE?=
 =?utf-8?B?TFg2MTYxVzEvREtvcmZ3dkdQdW5nZExzd1N0M2FOQ3FNSlBSMUpGVUhWV1VC?=
 =?utf-8?B?NTNIUGFOYlJSb2E5QnVGMGJkWjlDd09XNGw3NmY1enJhWEdmYjNPQkFneGV2?=
 =?utf-8?B?MTdwQUJqdlQ3QmFwenRSOWJZMU1NVnFENEh5M3RQU0JqaUphWEVmLzBGNHlq?=
 =?utf-8?B?bmJPdDVmanYxOWNvenNkMU1sMUpmMTRtbkY1dHhMTkl6QzAxMDA1d3B5WFRY?=
 =?utf-8?B?cW9QTlQ1Mlc3MEViaVBnUE4xN3N3NUIxUVRVNUszcDB0Qmpoc28vS2FCK2Z4?=
 =?utf-8?B?c0gyYzJTRUpEOTViUWhvSXREaUVlV2piSkJVK25FaXRDVWNnU1pTREVsOVZ0?=
 =?utf-8?B?d1RKcmdkdkpaVVhRRVZGQWE0YklHYTNGYTZrRGFQU0d4RCtoMjlmM3BaTHJS?=
 =?utf-8?B?RGorTjJWd2pjcWQzY1dBUkpnWHhJdUErVFZETGhUSGx6OXRjeXY0aVBYVDIx?=
 =?utf-8?B?NGdkTFlNL2RDVGxpbEhialMxT3dEU2oyNE4wSDJlbm05dWJnL2Z4Zk5xeGR4?=
 =?utf-8?B?Q3hmWW5OOWo1RzY5dEdMUTVuK1lOZW9jdEFROGltYTRzUmZmYXdrcjZaQlJM?=
 =?utf-8?B?YnhqV3p2dmFkVEVvczF3cUNIZXpxL3l5OGZaNDVheHZnWFpTOW5rcTdlV3FM?=
 =?utf-8?B?c3VFUnlpU2FHcVZrczRqeVlOZW4vZ2kzYmZlV25YekJKcyt1NS9EdzJsQlY3?=
 =?utf-8?B?ZDE3Qi94RDduZktKQ0E4RFp6a1RWUU8yT0YyT3FHbVprN09nRVh5SmI0aUhx?=
 =?utf-8?B?MUJIWlc3aC9CVzNIV0t2d1RCSWpKVXRJRGcwMHB5NDZCVVZrdVpGM0wrNHlv?=
 =?utf-8?Q?Ttsb6OUoFGA8wgoG586Yr4SAlNPkVW/9jilNSpF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f6d530-0ab0-4358-3707-08d904238064
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 17:41:17.5527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4mPem86pjwxHuxrMnNtbIVs7/3PvwaL7Tf88esck+b5tkCd0KEFiqJaVjP+O6IrlUwb9R24Lpy+XHM+wnjLVvJn9UnaAjVYq/r5xP2icoo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3956
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9960 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200121
X-Proofpoint-GUID: nJzoL0Rc4zw7154jwdfUysBatME2YkwX
X-Proofpoint-ORIG-GUID: nJzoL0Rc4zw7154jwdfUysBatME2YkwX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/20/21 5:14 AM, Chandan Babu R wrote:
> On 20 Apr 2021 at 00:02, Allison Henderson wrote:
>> On 4/18/21 10:15 PM, Chandan Babu R wrote:
>>> On 16 Apr 2021 at 14:50, Allison Henderson wrote:
>>>> This patch separate xfs_attr_node_addname into two functions.  This will
>>>> help to make it easier to hoist parts of xfs_attr_node_addname that need
>>>> state management
>>>>
>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>>>> ---
>>>>    fs/xfs/libxfs/xfs_attr.c | 20 ++++++++++++++++++++
>>>>    1 file changed, 20 insertions(+)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>> index fff1c6f..d9dfc8d2 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>>> @@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>>>    STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>>>    STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>>>    STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>>>> +STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
>>>>    STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>>>    				 struct xfs_da_state **state);
>>>>    STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>>> @@ -1062,6 +1063,25 @@ xfs_attr_node_addname(
>>>>    			return error;
>>>>    	}
>>>>
>>>> +	error = xfs_attr_node_addname_clear_incomplete(args);
>> Ok, so i think what we need here is an extra few lines below.  That's
>> similar to the original exit handling
>>
>> 	if (error)
>> 		goto out;
>> 	retval = error = 0;
> 
>          "retval = 0;" should suffice.
Ok, will that add in.  Thanks!
Allison

>          
>>
>> Looks good?
>>
>>>> +out:
>>>> +	if (state)
>>>> +		xfs_da_state_free(state);
>>>> +	if (error)
>>>> +		return error;
>>>> +	return retval;
>>>
>>> I think the above code incorrectly returns -ENOSPC when the user is performing
>>> an xattr rename operation and the call to xfs_attr3_leaf_add() resulted in
>>> returning -ENOSPC,
>>> 1. xfs_attr3_leaf_add() returns -ENOSPC.
>>> 2. xfs_da3_split() allocates a new leaf and inserts the new xattr into it.
>>> 3. If the user was performing a rename operation (i.e. XFS_DA_OP_RENAME is
>>>      set), we flip the "incomplete" flag.
>>> 4. Remove the old xattr's remote blocks (if any).
>>> 5. Remove old xattr's name.
>>> 6. If "error" has zero as its value, we return the value of "retval". At this
>>>      point in execution, "retval" would have -ENOSPC as its value.
>>>
>> Thanks for the catch!
>> Allison
> 
