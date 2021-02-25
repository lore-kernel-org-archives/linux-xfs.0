Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 073BEC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CA3664EC4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhBYGSz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 01:18:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41366 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhBYGSx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 01:18:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6FMJn119762;
        Thu, 25 Feb 2021 06:18:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=G+71G9RCD5NaY2WCT5GbnNaQjej+sw/ANCwzPcZ0VMA=;
 b=e4AJt7fXZf+M1BdKD1Xg05JBvTMH9hALbuy/4AVd1tV3EaCRCUgpmHXYDHjzG7ajmbvC
 t5E5FNsHUHp1VTO78ZH+HV0iBCxkuquaKiyS7vmXG8Hq4beueGWf2dqNe6sCkxcPdmmx
 MNGjcoOYVf/ZivuQDy2EKhWJEAoT44nQgkPTGO1x7h+/6q9SbC/Pz9bfYki/c/a4HvrF
 GF4+Trir4Z4eq1Glrqt3EUqTPDh4zISFvR3j7X1+6RT366f7hz9WDW1R8R15OaHbJ0l/
 qcjG93aK8QQlu3omscP1CBsPV9j591K4CGEDXQ3KmaIfLnebWiCV1KUNbOIkmkDKE7ME IA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsur5bu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:18:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6ADUs173189;
        Thu, 25 Feb 2021 06:18:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3020.oracle.com with ESMTP id 36uc6u2ebm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:18:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACSw1kNl3iIp5Wzfq96ZvCkjdnHBrgKS+fhxKVRWeU84lH77Q3LE8FOs0aJCVm8ioZ6dsdEqn5iivk10VF+u8FLUcHPk9/3QJiXQKpDTE96jaPYJJLeyZ0p/OnMYWdQerMBMEThzFAeWQ2qHSQ+y/hb0H5fUULGmmxK+VOxa5cdJ720rfsZySUjlAcM0lOMb/wZddHOj7DeHzq0C5tfXugCKCqf7cZMZKA0uQBXUWgLXqlKCVnETvux2lB01EfKYXXlmGSgbtQNpJw0CfWtefRiffErMmyF2FvaL4DtA79hHjHsijCXspTVVzYCYZvfLOufzc6cu4LSAmwMC921Bmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+71G9RCD5NaY2WCT5GbnNaQjej+sw/ANCwzPcZ0VMA=;
 b=fJ/f/w7ZgIwavbmT83aa8OrmpuB1JywYG+F86ceGIuFSZZjjelXBvVClKhlLqXDLWFth4Hw4ns6ykEzFAWmR8b51VHUGilNuXplPFEJR2uDu6iMelrnFmQ9zTh4LcP64tPi75fQsJD4WUkCl81ZxyJ4uI4Gf99puXUbSeVgDvAaIAfU5cXF+3PfpLDAIQeFNWf57ABIh0IaQZg1EmrUMctzZJQru9n8RR/ZeE1bK9y79jnWpf8cucc5Q6UgmYsTtZVh0iTGPx6eMdj/T3MpcjaMrb51XMXMSVF7LdBpQ1FmAW+3G3KKlI90Gj5yUQBIEQQvdgguFmLLnlINr3di0UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+71G9RCD5NaY2WCT5GbnNaQjej+sw/ANCwzPcZ0VMA=;
 b=vLgduMGA5C6qCJilHLmjFkJzC7aEhDiq5h2DGJduxbTdgY4KQAirZwE5seSDRW9yf3HhSnzPGIzja4rB1kYhvmA7J44C2rssivYymWGa/IGsOdZftE4KKV1agqqTXj0qu1LR7saoZGgxNrJwhaEKD/bgTwyyphtHT3Dsw+udkgQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2488.namprd10.prod.outlook.com (2603:10b6:a02:b9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Thu, 25 Feb
 2021 06:17:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Thu, 25 Feb 2021
 06:17:58 +0000
Subject: Re: [PATCH v15 02/22] xfs: Add xfs_attr_node_remove_cleanup
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-3-allison.henderson@oracle.com>
 <20210224150325.GC981777@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <debc4984-f535-91f4-9d96-2e36ca8229f0@oracle.com>
Date:   Wed, 24 Feb 2021 23:17:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210224150325.GC981777@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 06:17:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 783e3995-6ce2-4287-79de-08d8d95518a9
X-MS-TrafficTypeDiagnostic: BYAPR10MB2488:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2488F7EB8DA0A523F6458911959E9@BYAPR10MB2488.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f/5nYFYvwsNAqy6L4g4QFxAb9nOF2BnUhFpuCyciDlNIMLFmpGqcA8JRcXzdWINhidkPMrBYeonmKFD5ujJjzJYG2b1FM3kbm0pkCHwft/EySYCXqyq77WZOGVsOm57fSp7QYq8m4W+9Q0G1GB57Rrc4JLQbM8CmwTRPx0xD2LeUftK2fjvTxq1CCXurFcKrW2i2MUHmvpo5unidpfLjmHpM6+pHPhmWk4UYAQ8OzHo8D+OoX5BFi+DI57Pak0yefurmUqvffUIsitbrQUP8NUgoT14/VSqKCs1CNMKYgrk2kMx2LwQpDr4NftpQVYvBQfZLUPW8WPzilAOXq6z7Yc16lrOK3ZqvdMWLi2uWiAhGpDPKXxvFGM7SnjyuQ6S9hqA5oKONOMGLHSFpnsdSrK7RJILcYIgNCysPc0Umaiqa7OcXNIYGgOlWKU02RIbNXp0DBte/P/AiX09Qr6n0UA6ITxizxSudGqCxyUcqlViCkUqG191Hft6AqtTnlcXg5aZLjC1kiEo4/ajoLn/FZEdasqk0QJRRl0XgahT8yqQ4BSXhoEqX2+vGwYvpXDeKJGTGQ5JsCSCq26/Z3M6ec+UJGH+Lu+SXZEvG6Juc19I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39860400002)(396003)(366004)(8936002)(2616005)(956004)(52116002)(8676002)(66946007)(5660300002)(44832011)(53546011)(6486002)(2906002)(31686004)(478600001)(83380400001)(4326008)(86362001)(16576012)(31696002)(16526019)(66476007)(66556008)(26005)(316002)(6916009)(36756003)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cGhnZjRtYkFOL291RE1rYU1laEdEaExVc0JYeEZMOUttbXlQOFdUMW9oMWl6?=
 =?utf-8?B?V09Jbm5NcHVRcU9mRjR6MEJneFcvMHJqb3BUNzhJd0V0clVrY2VtOW93bXVD?=
 =?utf-8?B?SGZjWlJYTnNIMThwclZmSCtXcE9FV3JaWTByTFJ6RHRzTC9jK3lpeURzeEFY?=
 =?utf-8?B?a0NsREFpc2t0L2ZBb3JyR2ZZR2loc2hHbEtvT0tuZEZ0dEJjRnFUWTI3cHJQ?=
 =?utf-8?B?SnFYRVhkTFlzNHdwYnJqTEQ4TkFjVkZMZml2aEtIcEhXb2pRbUU1VHYzemlV?=
 =?utf-8?B?Ly9sZ0UvSm90SzRRbmpRZnZrL29sWEZqZ3pVMTh2TnRhNHc1U1NpcHVvRXdQ?=
 =?utf-8?B?bWQwbkQ2YkNmd1F5ZmU4T0M3b1RteFFKTUFMZVlUU3Z4Q3FWZExGbXdheDdL?=
 =?utf-8?B?ZzhHOWU4M3BsamlWTGpUTFlTd3NEbmF4b3R6WWhTaVpMb3c3SmVWQ1NrL2tP?=
 =?utf-8?B?TU9XVUNrNDFiSnRiYUVmVlpwY0syUG1BaWh0ZnJETWQzMi9yVnB0ZE8xWlV3?=
 =?utf-8?B?NXRMZUhLVXdtSXVZSHRMRmY3b0o0TCtUKzQ1aWNjeWJSNDBPcEd4YzVkRElv?=
 =?utf-8?B?SVFrU2VTaWo2QU00d3ViVVpOaWVZTkhkQjRWSVhGWEp0YjJjaFRMMnJFKzNm?=
 =?utf-8?B?b1FZVWFTWmhWVWNsazhlbHRLUCtrcjJyMExkYlgzQUF4Sk95NkZvZG1Qb2lU?=
 =?utf-8?B?cEtMV09CeC9CTmtyTTJhZk8zVURvRCtJc1BDUlVENHM3elBEYTJuWFk1cjRl?=
 =?utf-8?B?NHZOeExiRmZST0JsbDV0YVlrbTM1TjFqQVFqTmhGU2NCM3g2SlBOOW1YMjhG?=
 =?utf-8?B?TjhEZ3RYdjBTVUtCWmVFTnlwZyt0UHAxQmJKZjFxeG9NR1U1Yjd0d3dsZUNF?=
 =?utf-8?B?bHQ2NE5OQ0xid3VEam02blRQTGxoYXBWcElwUzRWcE1jeVMrOEwvUGg1WEV5?=
 =?utf-8?B?c3dndVhtWVRZbVVtWGFDaUJ5NllOQzNPRGhmL2U4ZkwvaC9oRlM0VFF1bU1z?=
 =?utf-8?B?bDh2d0dTRlpXaFVqT2s3eXBaclROV3kvTGRIVnZMUTBJNHVxYTRPb2piOS90?=
 =?utf-8?B?bGdUeFZHekNld0MwRFVUTzRrNHNDajIvb2tmT3NzMGJ2eElSZlFqN295RVNI?=
 =?utf-8?B?MHROajh5cjBEWjNzVnVnakFRWVJQcC9sT1YrVjgzWVAvK1dSUEVmWDV2Zmdy?=
 =?utf-8?B?R0pOTkZqYlFGYVByZ1BvZjlTbkc2bjFodlkwY2ZYTXNmRFRkM1FCaXQ0dmtk?=
 =?utf-8?B?eHFqSHF6Yjg0a2Y2UFJ6NDhBL0hUZStMTnRmN2ZPazN4cGMwN0ZDUWpMTjdD?=
 =?utf-8?B?NnZhN1BNdVVTNStjNjE3cGlMOGprTjRIWUgrcTZKZ0MyR2tvT1V5NDV4QWh1?=
 =?utf-8?B?VWVRVTZCKzNHK0U1Z1h6ZTZRSDY5SnJvbWs5RjBkZ1BPR3RRdXp2NGkvcE42?=
 =?utf-8?B?eWtCNlE0bUFGWUNFTEwwVkU3RWM2b280ZlVQSVhaYW1sTHZSNG9iK3hHYzNV?=
 =?utf-8?B?VS8zVFROdkMxdXdNdTVld0pETWdrN0NnUFAweGlnOEkrWU85SHBmdm9VenJ4?=
 =?utf-8?B?RWtxMTdSWENYeFVJejUwbW82MDRyYlQ0b0xkb3M0NzBRNkd6Q0VYS3Jkbzdh?=
 =?utf-8?B?ekIxbUdoL0V0Rm8rT0dIbTAyak01ZlpVMytGMmltQktTRENMV0tDaHUveTUy?=
 =?utf-8?B?U0Zic0VXalBBaXczekkwMzEycHArQ1kwKytQY0x6YzRyejRocmNxZ0l5anA1?=
 =?utf-8?Q?hrWYcJn9vyMG/m4EZSOIGYIBkcdvkXsIduUIZZ8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 783e3995-6ce2-4287-79de-08d8d95518a9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 06:17:58.3257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tzIEggp6rb/Eic8pnngwaCS1imjOHiVq6v9HxejaxUJQDfoWNuY2PLBE2YzyxDAWLAxzM8XIMinwl9lRNo8er+K1hzxUh5YhirYJuIT0/Dc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2488
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250054
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/21 8:03 AM, Brian Foster wrote:
> On Thu, Feb 18, 2021 at 09:53:28AM -0700, Allison Henderson wrote:
>> This patch pulls a new helper function xfs_attr_node_remove_cleanup out
>> of xfs_attr_node_remove_step.  This helps to modularize
>> xfs_attr_node_remove_step which will help make the delayed attribute
>> code easier to follow
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
> 
> Looks like I sent a review for this on v14...
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Sorry about that, I got tied up in the extra refactoring.  Will add. 
Thanks again!

Allison

> 
>>   fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
>>   1 file changed, 20 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 28ff93d..4e6c89d 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1220,6 +1220,25 @@ xfs_attr_node_remove_rmt(
>>   	return xfs_attr_refillstate(state);
>>   }
>>   
>> +STATIC int
>> +xfs_attr_node_remove_cleanup(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	*state)
>> +{
>> +	struct xfs_da_state_blk	*blk;
>> +	int			retval;
>> +
>> +	/*
>> +	 * Remove the name and update the hashvals in the tree.
>> +	 */
>> +	blk = &state->path.blk[state->path.active-1];
>> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> +	retval = xfs_attr3_leaf_remove(blk->bp, args);
>> +	xfs_da3_fixhashpath(state, &state->path);
>> +
>> +	return retval;
>> +}
>> +
>>   /*
>>    * Remove a name from a B-tree attribute list.
>>    *
>> @@ -1232,7 +1251,6 @@ xfs_attr_node_remove_step(
>>   	struct xfs_da_args	*args,
>>   	struct xfs_da_state	*state)
>>   {
>> -	struct xfs_da_state_blk	*blk;
>>   	int			retval, error;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>> @@ -1247,14 +1265,7 @@ xfs_attr_node_remove_step(
>>   		if (error)
>>   			return error;
>>   	}
>> -
>> -	/*
>> -	 * Remove the name and update the hashvals in the tree.
>> -	 */
>> -	blk = &state->path.blk[ state->path.active-1 ];
>> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> -	retval = xfs_attr3_leaf_remove(blk->bp, args);
>> -	xfs_da3_fixhashpath(state, &state->path);
>> +	retval = xfs_attr_node_remove_cleanup(args, state);
>>   
>>   	/*
>>   	 * Check to see if the tree needs to be collapsed.
>> -- 
>> 2.7.4
>>
> 
