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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3989AC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5995601FF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244407AbhCCDLS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:11:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34106 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238728AbhCBKDw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 05:03:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1228KKYD173012;
        Tue, 2 Mar 2021 08:26:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SkdKgLegzge71MZvwJynEZfOxHLfIDZMERUSGX57VvQ=;
 b=JJw0E/u4lTt9QesuQleE+wb0ZDzyvohVbrBC7NXgkBqwQoZWzsj1/kR6nEwTP13J7asl
 TkyxI7Vtnow7afqmmN3ZAVY1pLZuywltMzU46KL3Gt1L1XHatayDIDHqH5LLXKz8DCmq
 dt33kF3nnvdDYWFurSV/8/ROBZmUlUvLvfT99Qc+DkKMrPmOJu6WeQcJQZLJht2Ysh0h
 WP61cpmBoNzAUNcla0TehtryIJgVnpghLJoS2OPX2Eq+5OpQaXLQSlTCtsRco01mX6Bf
 2e8m07BHvQgMxTuxSiIDrZWOUhnQpPtTN3k+Wbb7G6rrVn60qtoaua8ZlBPQglG6rTIN 1w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36ye1m6kq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 08:26:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1228QV0x140643;
        Tue, 2 Mar 2021 08:26:34 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3020.oracle.com with ESMTP id 36yyurp0rh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 08:26:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYU0qxKTrx0ruIJuUZp8+ardeT2WMQNBax7zmN7bOJZ9NpGPHTyQ1AjbrlFLaUtQvFUem0JrYENw4dxUWPzTy3g0bZzikZrGiB4GptoDPc570tt7G7XU6gEs6LQoi3Zysm5g/CPbUtH39a+yWTBuks75g0WgxnPKsnQZQtO5HOeQ8TL+PsVFww3NI4QthGDY27te4PbjyJ6qOzhGWzYQdo3R0MDf7dCXqKLcL+KE2ptFGtcJ/cX1tnlTfk7xVbrLrUQNVQiWAv53OBSSVfMTqwlhYNzUqPkNCTS59YuRx3ZDEIhtsUM3Gw0lzVNh+VWpLCDR3NySVsHfBd9OyTyi9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SkdKgLegzge71MZvwJynEZfOxHLfIDZMERUSGX57VvQ=;
 b=bY0olI84F+G6X2yhk9XhaIFgxO3oPzpt9F/VfyI8KZsICAJi+6oNxOXNDDMERukknE1pzXJZw4J4gR7TL9dd1JGFFaSIu8F6ynuW9xIuT/5b4pII+CelsQ3ag9mfcSaYNu3+n1DhhA3LAv2h8xRrsIzso1tgvMoZdp05rxtoEBj6NDmHieHkZuo0MerqT38EGvbD/oC6w3qawXV+bJqOnN4mObJ09w/FR/j9Y7mu2BDS7tbrkaqWYwjwJ67NMKCLjj6l/Cp3lv5vl867FsZrUAxccvRrpJe59rKyHruMPEQ3LsLtZe2fqGOI3NSqvSTmMzy0aPYqqt+f34rmzYI5ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SkdKgLegzge71MZvwJynEZfOxHLfIDZMERUSGX57VvQ=;
 b=0JsJODFm/fEpOxWBnQZsbvjSSANlcIxzGQSr/uUSGbjZiMzYvyAsXUxtxEJPEGxmgCwjMcjddT7xn5dGJKSKec2KnXT8k3wO6kCskZ6N2IrI4/7P+rUoh/xqgpS60/h8G18kIJVRC9PIKiWzjtie9zuGcn2oUwJZInPgPV5pGK8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3144.namprd10.prod.outlook.com (2603:10b6:a03:15c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Tue, 2 Mar
 2021 08:26:22 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.029; Tue, 2 Mar 2021
 08:26:22 +0000
Subject: Re: [PATCH v15 09/22] xfs: Hoist xfs_attr_leaf_addname
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-10-allison.henderson@oracle.com>
 <20210301181913.GI7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <fe145942-77fa-bec7-2e79-d420c3202a98@oracle.com>
Date:   Tue, 2 Mar 2021 01:26:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210301181913.GI7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0324.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0324.namprd03.prod.outlook.com (2603:10b6:a03:39d::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 2 Mar 2021 08:26:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfd19d50-c4d9-4cee-e03c-08d8dd54dcb9
X-MS-TrafficTypeDiagnostic: BYAPR10MB3144:
X-Microsoft-Antispam-PRVS: <BYAPR10MB31445F25FD53E37C19E0DD9D95999@BYAPR10MB3144.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JlCawx1O120sDp18w/BLCSJbn06uAJgp/3u1QuhL7KMPSF8nKfiueAJd9nFpA85aRKam7Fj2rh7If2Jo7JsCC5lhqxn+CzkD6owxlTMlVqjMz9IG2PBTxXj7IhhJkLh6+lqoHXAhoivbORak9MYTdk27EgsUoVdncHseMOMF5H94f60U3BEE1/zhzfZRvg76SPwpMAsQdJAIs25pbluAnTdG4BnHO7fjnVV+70NUG9vHg98uHlrhbSHF0Lzwsdk6pqV8bgkXLs7dAIVvFshRE11Hqf89m7neDhJEZowfDzsZGm49hf5AU8+7VogrsHtiZ4Z31roKT4snW3nhAagReo3qUvnlxgaGvwQpzABVHkLm0eP+1J0EtnLSPaj+3YeA2iYjocxffwjGzj5NiG7JH+A3a/0hJnXyZfkEkYRv/kySWMGfQOmruvg45twamPumtLq5d9LHgSr4aJa0pbyctFn9nQnWGobh9G/h38Jw0BQK4Kpja0ygtDAtORatDxsmKDpvKK6tMIOWraeKcTnNde7Wb8GRytWKknold3hErNJOv4WOLEFuz+9s+3YL/RyislVrXPDz3gmAc0TrU0geBJHRhN49Cgk9U/epeVOk62c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(66476007)(66556008)(52116002)(4326008)(66946007)(2616005)(6916009)(53546011)(44832011)(31696002)(16576012)(316002)(6486002)(956004)(86362001)(16526019)(8676002)(31686004)(83380400001)(8936002)(2906002)(478600001)(186003)(5660300002)(26005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K05oc0pMcmlKNjYwc0V5MjBMbGpvelF1Q1BiNFV1QTJWRENVZnhwQlQrWWxQ?=
 =?utf-8?B?R0xwb0tYRk10U2M1bHlUbWtnZ2dTQldMM1FoY245THhwWmdpZVdMTTBtdHdZ?=
 =?utf-8?B?VGRXUkFwZzhES2trdjMxYmN0U2FpY0dtM3ExQ3BKbGRGYWlTcUdtdzdpRzBl?=
 =?utf-8?B?RHNCRFdhQjZ3WlBHdnhSYWx2ZnBFUGZUWFE0VjY1QU0zczBMYVZrMGFmclRY?=
 =?utf-8?B?OWQyOW44RXpLaURMaDFlL2VqSXd1WGk4NHkvbmRBU1ArbDFJaE4zZ1oxb2Zx?=
 =?utf-8?B?RkFhOGVyaWF2dmRFamUzeWdOQWxPV2hnUGhET3RFcEFaeXlqVjNrTjd1a2d5?=
 =?utf-8?B?RUJDTzQ3WTV2VXJIWVJHN2ptd3AxN2RHS09hNVFCaFJEVGcxT20zbTlMak45?=
 =?utf-8?B?bXRTWXFzeDdJcG4zbHBMdVFIbms5MlFHZnJrODdBandPcHE2ME1wMHZ5eTND?=
 =?utf-8?B?b2d4WE8wYmh1WUZucGhEMS9QRGlLbGlJZDBuNnJVK1hRTVpaUm5FTThvZzR0?=
 =?utf-8?B?YXlRNk9XN3krMVE4c0srQmxyODZ3Q2FBZ011YXZBS3B1VDhXUnE0K0UvSm5m?=
 =?utf-8?B?SWlFYk1veGdVcmxhQ3lQTDAvc0dDS3o1MS9iL3RNSFhGOUtydW9xOW9BaXlk?=
 =?utf-8?B?aVduSmxXNFlBM1d1TkZTTFpEVlR2UVJCRkpGTEFBc3VDV0ZQQU0xeFFlN2dk?=
 =?utf-8?B?RGREL1c2YWVrSFpIdCtsdmZLbWpCV0JFVkNtV0hBSEdiTnA3Q2VNV3VraHU0?=
 =?utf-8?B?Q3pVTnZyZ3NoUXpEUm5aWk10amZlZUJWalRPT2J2WFVxK0FhdHdrdWRzYW9N?=
 =?utf-8?B?MVkveTdUaEErVmcwM3NyODBpOGlOOUlhRW9DZlJGUUp0OEZkbS9TMFk2aGZL?=
 =?utf-8?B?VFJxVkxicE52d1FMbnMvM0tZOG93cjhmbGp6MkVKY3BBZGZFZkRWeVM1RXZN?=
 =?utf-8?B?SUh6VVRQdmlud1hCdW16R1Y3MzJQK1NTTDZkcVBaVm9nTFVkdTRvZlJ0dGx4?=
 =?utf-8?B?RS93NUxzOU51NU5mMWRuRlJDT0JoM1ZxdzN4Ymk1M1VNeU9ZMUt3dnhIN0Rq?=
 =?utf-8?B?QVZCUlhtVXNiN2VuOVYrbUlHZG9QV3N0STVVV0ZTYmwwdXNVZmV3NmZJZmwr?=
 =?utf-8?B?YXROZFNJcllFb0tGdDFsNXlkOEduZm5CeUNhNER3WkRWTXdFQm9iSk9ZQ2hz?=
 =?utf-8?B?ZTF5WVpQbHNkd25qbDZMbDhBVTBFazg4b2hLbnlPMjVOOWN1Q3lqc2NqNVRP?=
 =?utf-8?B?cFYxVE9QMWxra095NGZ2WUZodVErZktLOUFkRytHbDdQWmloQzQ1WEpFK1Rr?=
 =?utf-8?B?YXJYcmdZNDY5M0dqRk05Y2NDVGg5WFVXM0YxaUMvSFF5YU9UZk52UGhlR0t6?=
 =?utf-8?B?Z01IZXRCOGduNnFPMEp4ekdPWW5kbkwwRUZFaC9mNnhrS3JyZnhNRHB0cWUv?=
 =?utf-8?B?LzNkam1sV2pqN3h0emZLeXk5amplVGwySHBpMUtNa21kUHRVUDFORnJRbmd2?=
 =?utf-8?B?UGhjQzdBVlhVNTNIWXpucW9JdUZyZlJwQ0ltaUxqNHNTSVBGS0pXbzZRUE9n?=
 =?utf-8?B?WGpDcUczQXVQUmZ6NExkVk05UDZWRDF2dktuc0h1aDMwUkhoQzdhVS9NWUZK?=
 =?utf-8?B?eUhiUEhNQnlyTGJqbGF5Zk9VV1VrWnluazd1RTJ5aWsyK3JDMWU4aVdROVFY?=
 =?utf-8?B?aWM0eEVFOUxCYnNOY3BQcEFrTkhyWG4yWGFkdnlWRVl4bkVyZVJudXFKbUVE?=
 =?utf-8?Q?2lta6fAtHLnLp4QhSEcmzgUTiM732MucKzJslUp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd19d50-c4d9-4cee-e03c-08d8dd54dcb9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 08:26:22.4409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XO6Ccf6KoScHfVR2ljG1wPItitOHtTSaekCKzbI3DUKMJ83RRJl5EBbeop5S0/VozTvPSiqlCfHWB38mQuc6Lrh7H+qlbh4HiG4Z7E0aUZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3144
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020070
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020069
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/1/21 11:19 AM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:35AM -0700, Allison Henderson wrote:
>> This patch hoists xfs_attr_leaf_addname into the calling function.  The
>> goal being to get all the code that will require state management into
>> the same scope. This isn't particuarly asetheic right away, but it is a
> 
> "aesthetic"
> 
>> preliminary step to to manageing the state machine code.
> 
> "to merging in" ?
> 
> The goto label is ugly, but afaict this patch moves code and the next
> one rearranges it the way you ultimately want it, right?
> 
> With spelling fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
Ok, will fix spelling nits.  Thank you!
Allison

> --D
> 
> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
>>   1 file changed, 96 insertions(+), 113 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 19a532a..bfd4466 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -44,9 +44,9 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>>    * Internal routines when attribute list is one block.
>>    */
>>   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>> -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
>>   
>>   /*
>>    * Internal routines when attribute list is more than one block.
>> @@ -269,8 +269,9 @@ xfs_attr_set_args(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_buf		*bp = NULL;
>>   	struct xfs_da_state     *state = NULL;
>> -	int			error = 0;
>> +	int			forkoff, error = 0;
>>   	int			retval = 0;
>>   
>>   	/*
>> @@ -286,10 +287,101 @@ xfs_attr_set_args(
>>   	}
>>   
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -		error = xfs_attr_leaf_addname(args);
>> -		if (error != -ENOSPC)
>> +		error = xfs_attr_leaf_try_add(args, bp);
>> +		if (error == -ENOSPC)
>> +			goto node;
>> +		else if (error)
>> +			return error;
>> +
>> +		/*
>> +		 * Commit the transaction that added the attr name so that
>> +		 * later routines can manage their own transactions.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, dp);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>> +		 * If there was an out-of-line value, allocate the blocks we
>> +		 * identified for its storage and copy the value.  This is done
>> +		 * after we create the attribute so that we don't overflow the
>> +		 * maximum size of a transaction and/or hit a deadlock.
>> +		 */
>> +		if (args->rmtblkno > 0) {
>> +			error = xfs_attr_rmtval_set(args);
>> +			if (error)
>> +				return error;
>> +		}
>> +
>> +		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>> +			/*
>> +			 * Added a "remote" value, just clear the incomplete
>> +			 *flag.
>> +			 */
>> +			if (args->rmtblkno > 0)
>> +				error = xfs_attr3_leaf_clearflag(args);
>> +
>> +			return error;
>> +		}
>> +
>> +		/*
>> +		 * If this is an atomic rename operation, we must "flip" the
>> +		 * incomplete flags on the "new" and "old" attribute/value pairs
>> +		 * so that one disappears and one appears atomically.  Then we
>> +		 * must remove the "old" attribute/value pair.
>> +		 *
>> +		 * In a separate transaction, set the incomplete flag on the
>> +		 * "old" attr and clear the incomplete flag on the "new" attr.
>> +		 */
>> +
>> +		error = xfs_attr3_leaf_flipflags(args);
>> +		if (error)
>> +			return error;
>> +		/*
>> +		 * Commit the flag value change and start the next trans in
>> +		 * series.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>> +		 * Dismantle the "old" attribute/value pair by removing a
>> +		 * "remote" value (if it exists).
>> +		 */
>> +		xfs_attr_restore_rmt_blk(args);
>> +
>> +		if (args->rmtblkno) {
>> +			error = xfs_attr_rmtval_invalidate(args);
>> +			if (error)
>> +				return error;
>> +
>> +			error = xfs_attr_rmtval_remove(args);
>> +			if (error)
>> +				return error;
>> +		}
>> +
>> +		/*
>> +		 * Read in the block containing the "old" attr, then remove the
>> +		 * "old" attr from that block (neat, huh!)
>> +		 */
>> +		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> +					   &bp);
>> +		if (error)
>>   			return error;
>>   
>> +		xfs_attr3_leaf_remove(bp, args);
>> +
>> +		/*
>> +		 * If the result is small enough, shrink it all into the inode.
>> +		 */
>> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
>> +		if (forkoff)
>> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> +			/* bp is gone due to xfs_da_shrink_inode */
>> +
>> +		return error;
>> +node:
>>   		/*
>>   		 * Promote the attribute list to the Btree format.
>>   		 */
>> @@ -731,115 +823,6 @@ xfs_attr_leaf_try_add(
>>   	return retval;
>>   }
>>   
>> -
>> -/*
>> - * Add a name to the leaf attribute list structure
>> - *
>> - * This leaf block cannot have a "remote" value, we only call this routine
>> - * if bmap_one_block() says there is only one block (ie: no remote blks).
>> - */
>> -STATIC int
>> -xfs_attr_leaf_addname(
>> -	struct xfs_da_args	*args)
>> -{
>> -	int			error, forkoff;
>> -	struct xfs_buf		*bp = NULL;
>> -	struct xfs_inode	*dp = args->dp;
>> -
>> -	trace_xfs_attr_leaf_addname(args);
>> -
>> -	error = xfs_attr_leaf_try_add(args, bp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * Commit the transaction that added the attr name so that
>> -	 * later routines can manage their own transactions.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * If there was an out-of-line value, allocate the blocks we
>> -	 * identified for its storage and copy the value.  This is done
>> -	 * after we create the attribute so that we don't overflow the
>> -	 * maximum size of a transaction and/or hit a deadlock.
>> -	 */
>> -	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_set(args);
>> -		if (error)
>> -			return error;
>> -	}
>> -
>> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>> -		/*
>> -		 * Added a "remote" value, just clear the incomplete flag.
>> -		 */
>> -		if (args->rmtblkno > 0)
>> -			error = xfs_attr3_leaf_clearflag(args);
>> -
>> -		return error;
>> -	}
>> -
>> -	/*
>> -	 * If this is an atomic rename operation, we must "flip" the incomplete
>> -	 * flags on the "new" and "old" attribute/value pairs so that one
>> -	 * disappears and one appears atomically.  Then we must remove the "old"
>> -	 * attribute/value pair.
>> -	 *
>> -	 * In a separate transaction, set the incomplete flag on the "old" attr
>> -	 * and clear the incomplete flag on the "new" attr.
>> -	 */
>> -
>> -	error = xfs_attr3_leaf_flipflags(args);
>> -	if (error)
>> -		return error;
>> -	/*
>> -	 * Commit the flag value change and start the next trans in series.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> -	 * (if it exists).
>> -	 */
>> -	xfs_attr_restore_rmt_blk(args);
>> -
>> -	if (args->rmtblkno) {
>> -		error = xfs_attr_rmtval_invalidate(args);
>> -		if (error)
>> -			return error;
>> -
>> -		error = xfs_attr_rmtval_remove(args);
>> -		if (error)
>> -			return error;
>> -	}
>> -
>> -	/*
>> -	 * Read in the block containing the "old" attr, then remove the "old"
>> -	 * attr from that block (neat, huh!)
>> -	 */
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> -				   &bp);
>> -	if (error)
>> -		return error;
>> -
>> -	xfs_attr3_leaf_remove(bp, args);
>> -
>> -	/*
>> -	 * If the result is small enough, shrink it all into the inode.
>> -	 */
>> -	forkoff = xfs_attr_shortform_allfit(bp, dp);
>> -	if (forkoff)
>> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> -		/* bp is gone due to xfs_da_shrink_inode */
>> -
>> -	return error;
>> -}
>> -
>>   /*
>>    * Return EEXIST if attr is found, or ENOATTR if not
>>    */
>> -- 
>> 2.7.4
>>
