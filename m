Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B0F4C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2CDC64DD6
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhA1Gmd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:42:33 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:59328 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhA1Gmc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 01:42:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S6dO1w040450;
        Thu, 28 Jan 2021 06:41:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=b9+pOq/Tk3qBMgbyjIH/j94LpfG+VupeBE5ylwzI3p4=;
 b=ysCCjQ0jX8bHzAwnpuOvcwibRbVY9O7HgpzEud9A2ZF2MddQKnUFbDSOB8pxVQ5O0ao+
 GnZoMsqs3CA6RbN7iGVJN9bQHdMGJxiG2Vvcb6JW9pzxrBenr4TQDdcCo5NePgOvi+XJ
 tLtzrmB35NBxGcp/nZUJW8rR/OE/XG0VytC7yJfWFNpf2vZqokjE1gvhdXUa1JDHtWU+
 Grwi9smLGUgCYY0IoT8bGUDdEN1w3g5WnWB4ZTggBHRQ9zv0IKvgkpxLuBdVQy4EWAEo
 Fq03ejoZPAeQaAEsIthuuxzcKJm20lYBP4YzhzTnCRLd39Mi9XaTc0jyrrAxiKeh19+q rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3689aats7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 06:41:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10S6ackS096713;
        Thu, 28 Jan 2021 06:39:47 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2052.outbound.protection.outlook.com [104.47.38.52])
        by aserp3020.oracle.com with ESMTP id 368wq17yxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 06:39:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdK3ePX8c3lHcDfXvQWRNTdiEgS7PZEEtHakOCsh1KZxnXmq6g1cnVs8ujdO2JB/rA6INLOPAbqbn56o/Bus7iuNL1VNAjQqGa3U25pZd9d7TtWGu9hw/eWPyvzSCaIePZriDBYdALzUyKS5w3pxu6ArXAfwCNkdb+p9j04vz7wTagQ3drzxN/1bmCeEo1bY3V8QIqLPWuRNeP+C+kodsIPgyppc+luiJ20G9Q9+4NT3MTGq6oHSp+h8OFAkD1NHYBdkMxxx+sO2QG88+raIk8Adhb8hrJcNlgbY8gzFZ3nyIhPp8gW5gIJ/CwCafDzolViqAbiexE7j7pb4rSr18g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9+pOq/Tk3qBMgbyjIH/j94LpfG+VupeBE5ylwzI3p4=;
 b=iQVBtq5yB1XImHh77YQykS2JCx7fE3YqkDMPYIB7R3J4eqmIPvZQB+J6O5dyISQW9R+dEPjCc+B/tMjJvawhH5k1BTY2dlOhikslDR8hpAzgHbLaem+drbmThXnc+2VGyCfs2/CWcC4vnBVEmO7Ux3onP5QypslFlgdYcWzDgc2E4sDK9rqcnrsZ+prDBriGHseV7KHtcZYQEywGFjhReqDEGGrVI2ptQ2lPfbahmE18YRvL3Vn8YmTfVK+oQmlGZfLX7JfLYQUf3MHXJUs6kHvNYIll9yS6QYrgQOYtVMjl7Jj3o7P1JeEimcqm3wFrq+vPWi7+0XpTxubWwKhPvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9+pOq/Tk3qBMgbyjIH/j94LpfG+VupeBE5ylwzI3p4=;
 b=XyizVev5WmvoRzmTrowMT+UWM2CO+pmxcYkRnfVYifthm+2uIbybYt8amwcDLSsxItUh09X4rFZgRBHV46PER6/P6bUJh2G5oIbp9AFg5jlrKNda2wSE1gy3Uiw0USPeEJeiwk7+bU/U+Ep8YcrF+8u2AnSyDuCRjLhGqshAGb0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3922.namprd10.prod.outlook.com (2603:10b6:a03:1fd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Thu, 28 Jan
 2021 06:39:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3805.017; Thu, 28 Jan 2021
 06:39:44 +0000
Subject: Re: [PATCH RFC 1/1] xfs: refactor xfs_attr_set follow up
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210116081240.12478-1-allison.henderson@oracle.com>
 <20210121184720.GC1793795@bfoster>
 <ee542ded-3894-5511-bb83-beac5543ac6a@oracle.com>
 <20210127175735.GA2555063@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <4edcd2f1-f1fe-952e-2e6b-dfa78d883c41@oracle.com>
Date:   Wed, 27 Jan 2021 23:39:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210127175735.GA2555063@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.89.149]
X-ClientProxiedBy: SJ0PR03CA0146.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.223] (67.1.89.149) by SJ0PR03CA0146.namprd03.prod.outlook.com (2603:10b6:a03:33c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Thu, 28 Jan 2021 06:39:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c6fa8cb-17b7-414b-b977-08d8c3577f68
X-MS-TrafficTypeDiagnostic: BY5PR10MB3922:
X-Microsoft-Antispam-PRVS: <BY5PR10MB39225EB4F8649E199A64262795BA9@BY5PR10MB3922.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NadpgPe6T8IICn55FIzRxG6s9L0kSk8rx0XvE52OfvPcJb4p4faRQOX5BXhcBD9bSnCUTx1IoELSakdYoiZoKevzJ+GkNg6l0wdOjYvhOCI1xlp0qk9Qibp92R2oDu6cx/y6Gc/T/vIt7gGgAT/REjRaZVFakotEf7L4tANzeWeyjKqkCmrVt0Qcg3AtdQTfky5JuQmFnp4rCKvXfdRHYN6I8Ac4tGua0qBu5DEZETMcZMFh0n8xTWZS6D0o5u8GbWW62YSXs25rXtGF4jc/PyIzyikr4is2EELwO4Cgf5JLw0C6SzooBtlsWN/ZyRvjg0u+eAH25/b2ljPMtod3i5hz8AOM1Jl8hOUjxmKc6ewEn7nmovMcjtqI9CucGnzzYbKAQI/22/Esew0m43mgQV5/uDn+fqOuIMPoPrhJjNxXWYGVh6LkpDnoZ18bL3JShsAk4JNbXbLZZegUkgC2SMQ2BCVAaTMs3GGrYvMVJsiLuzvDXwntUEuO9IEyE11jTQaJA2IFr/VOy6FPHPH5OAMwzcUA7cbHaJwFMcOd3znWyW/PoaWp5Y/vOMkikYTqohs51bofjBaFukjjUIj1JU/9VPcaP1RsXErMii1BpAs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(376002)(346002)(16526019)(5660300002)(66946007)(186003)(53546011)(52116002)(31686004)(2616005)(26005)(6916009)(8936002)(478600001)(4326008)(31696002)(66556008)(83380400001)(66476007)(8676002)(86362001)(6486002)(316002)(36756003)(30864003)(16576012)(2906002)(44832011)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UXJ1YVhvSTFkdFVwc1BLT2Vnam1rczFRdnpmajV5SHFXSS82UGVIUGQ3dG5S?=
 =?utf-8?B?aHlSZmIraEd1cllkVjRWVW5UMGJmYU5mYlZwRU83R0kzNEZldWtpaDZuZGlH?=
 =?utf-8?B?M0dkV0M2QUNrNW1UamxCbW1qQjZGNkJpQU80YTNKUmFDdWNGaVQ3U09YWVpG?=
 =?utf-8?B?bnVhbjRzRUJZSUpuRm9CdHI2WlErMTVlSThqcmM0bmF2U0w1QTgwNnphbzVT?=
 =?utf-8?B?cFJtTTV0TzEwbWtGaitRWTNzaU50bGNxWDNUejdiVmFJbG5FR2ttRHhDdTRS?=
 =?utf-8?B?UmdZWUlEM1VoenpYc04ramlzMWVENGNZaXl6QTVxNkg5WGRqWjJxNzQzM3ha?=
 =?utf-8?B?RWNqZ3F0UzFUTitYSnBrZ0djbkNSNlZFU09pVjhmKzFJb25zSVN2RG1kNWdq?=
 =?utf-8?B?MkZXaDQ1UURIaytJWWhkQXIxQmdHSmIwaVhEcExXUCtVcU1JV0RMMFprNnpt?=
 =?utf-8?B?NVdSUFdNYUpTMzVYeDJudlBlVXlLQzkzSFU0OEtNOVhBZGNqUmR3SXBlSEZt?=
 =?utf-8?B?b244Y1diZC9nYXAzSEFqQzNWT2VtMlFwVkRnVjhoS2w0cCtnL1hmWVk2UGk1?=
 =?utf-8?B?RDhWU3BoUDU3M3R0YUpONGlIQ0p0YWUwcE5ENTZKY1BzN0E2WVd2RDhmTnV5?=
 =?utf-8?B?em5ycWpOQklpVEt0Rjc2T3FiTFBzRWMwWFRKaGJ0NzVVek13VkFuZkJ0VFBr?=
 =?utf-8?B?eSs5QUlGVFdQZE11Ui95NTdYd0ZzOE1vZUtnL0l4UEJaZUw3S2NnZEw2UzFS?=
 =?utf-8?B?VnpTY3lOa0tUejdXdzFOKy9HdUdnZldFY3RDNkU4MjZlVEwyOXg0M1B1WXYv?=
 =?utf-8?B?c25UM2lSeTljM3g4OWpqZ1lMZUN2b3RFNzBaOVloc01OYllZLzRWcUlmd0cy?=
 =?utf-8?B?cHA5ZHVMOEdnOXFTRUR6UG1SWHduMnBpeWpPNkIwM0lpUDRyNVJsL0VaNzdn?=
 =?utf-8?B?Mnh5YTNHNGN3ZTV6VWpsa1I5UTJhQWRKQ0lKbHJqTENveGJNY1YvQno4Y2Nr?=
 =?utf-8?B?V1J1SkVveldtZEs4WFJDREFKck9HVFFWS2V0SzJYYWFBSjZSM2M3SG9pL2ZO?=
 =?utf-8?B?MUVVbktsZC81OXpDSjdwWi9NbVZndXpOV3hCaVdjclZKOTlZazdoc29TQ1Nl?=
 =?utf-8?B?UksraTh6bTFxbXVMdHVFWC9aeXBCRUd0OVpRQVdIbGQvZWxPWGJ4R1hXZmMz?=
 =?utf-8?B?cTlyNUFGM0xWN1hGMk5uS1k2T0RQYTErR2ErdWVYM1BIZ0Y5U1d2b3FpWTZ6?=
 =?utf-8?B?dWdjRitRV09kcXRta2FYVjV4ZFZjZXJ2YVYzcXc5K05QWEovQmZwYVdrOEF2?=
 =?utf-8?B?b2FuRlpadnYyWVVxY2RZeFJGa2ZNZU9pVng2K09hdlh4L2s4TlJIeEJMMnFo?=
 =?utf-8?B?NTVzZGZEdDhzN3NYaU4xTkhTM2poSnlNK1RCRlhIU29Bem9UWGVjaXA2L0lw?=
 =?utf-8?Q?4ozfA/8j?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c6fa8cb-17b7-414b-b977-08d8c3577f68
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 06:39:44.1469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tV4icsCm4fDYzme/IoIOVaSqgFcoA2/tF2TjCHfQhlM5q0oLxg48T7QpFXU2TIfkCteqcY7N1DNVYOjW+5SJFVR098GUyQxfMxFjP5Ns9Oc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3922
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280033
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280033
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/27/21 10:57 AM, Brian Foster wrote:
> On Mon, Jan 25, 2021 at 03:22:59PM -0700, Allison Henderson wrote:
>>
>>
>> On 1/21/21 11:47 AM, Brian Foster wrote:
>>> On Sat, Jan 16, 2021 at 01:12:40AM -0700, Allison Henderson wrote:
>>>> Hi all,
>>>>
>>>> This is a follow up to Brians earlier patch
>>>> "[PATCH RFC] xfs: refactor xfs_attr_set() into incremental components"
>>>>
>>>> This patch resembles the earlier patch, but it is seated at the top of
>>>> the parent pointers set rather than the bottom to give a better
>>>> illustraion of what this approach might end up looking like in the
>>>> bigger picture.  This patch is both compiled and tested, and is meant to
>>>> be more of an exploratory effort than anything.
>>>>
>>>> Most of the state management is collapsed into the *_iter functions
>>>> similar to Brians patch which collapsed them into the *_args routines.
>>>> Though there are a few states that a still in a few subfunctions.
>>>>
>>>> In anycase, I think it gives decent idea of what the solution might
>>>> look like in practice.  Questions, comments and feedback appreciated.
>>>>
>>>
>>> Thanks for the patch. By and large, I think the centralized state
>>> management of __xfs_attr_set_iter() is much more clear than the label
>>> management approach of jumping up and down through multiple levels of
>>> helper functions. For the most part, I'm able to walk through the iter
>>> function and follow the sequence of steps involved in the set. I did
>>> have some higher level comments on various parts of the patch,
>>> particularly where we seem to deviate from centralized state management.
>>>
>>> Note that if we were to take this approach, a primary goal was to
>>> incrementally port the existing xfs_attr_set_args() implementation into
>>> states. For example, such that we could split the current monstrous
>>> xfs_attr_set() patch into multiple patches that introduce infrastructure
>>> first, and then convert the existing code a state or so at a time. That
>>> eliminates churn from factoring code into one scheme only to immediately
>>> refactor into another. It also facilitates testing because I think the
>>> rework should be able to maintain functionality across each step.
>>>
>>> Porting on top of the whole thing certainly helps to get an advanced
>>> look at the final result. However, if we do use this approach and start
>>> getting into the details of individual states and whatnot, I do think it
>>> would be better to start breaking things down into smaller patches that
>>> replace some of the earlier code rather than use it as a baseline.
>> Sure, I think doing quick and dirty patches on top moves a little faster
>> just because the infastructure is already setup, and I'm not working through
>> merge conflicts, plus it cuts out the userspace side and just the misc nits
>> that are probably best done after the greater architectural descisions are
>> set.  The idea being to just establish an end goal of course.  It is tougher
>> to review like this though, maybe we can do a few spins of this and I'll try
>> to break it down into smaller chunks if that's ok.
>>
>>
>>> Further comments inline...
>>>
>>>> Thanks!
>>>> Allison
>>>>
>>>> ---
>>>>    fs/xfs/libxfs/xfs_attr.c | 596 +++++++++++++++++++----------------------------
>>>>    fs/xfs/libxfs/xfs_attr.h |   4 +-
>>>>    2 files changed, 247 insertions(+), 353 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>> index 6ba8f4b..356e35c 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>>>> @@ -274,108 +300,197 @@ xfs_attr_set_shortform(
> ...
>>>> +int xfs_attr_set_iter(
>>>> +	struct xfs_attr_item	*attr)
>>>> +{
>>>> +	bool	done = true;
>>>> +	int 	error;
>>>> +
>>>> +	error =  __xfs_attr_set_iter(attr, &done);
>>>> +	if (error || done)
>>>> +		return error;
>>>> +
>>>> +	return xfs_attr_node_addname(attr);
>>>
>>> Note that this was also intended to go away and get folded into the
>>> state code in __xfs_attr_set_iter(), I just left off here because it
>>> looked like there might have been opportunity to fall into the remove
>>> path, and that was getting a bit more involved than I wanted to. This
>>> variant looks a little different in that we can presumably fall into
>>> this function and then back into the state machine. Even if we didn't
>>> immediately reuse the remove path, I suspect we should probably continue
>>> chunking off the remainder of the operation into proper states.
>> Yes, I'm thinking maybe I could chop this down into a few patches that just
>> sort of hoist everything up and then try to collapse down any duplicated
>> code in a successive patch.  It'll create bit of a monster function at
>> first, but I think it might help us find the an arrangement we like.
>>
> 
> FWIW, I've seen enough that the design seems sane and reasonable to me.
> It addresses my primary gripe with the current implementation of
> spreading the state management code around a bit too much. My previous
> comments on this patch were around some of the detailed state breakdown
> and management logic, but I don't think that really requires seeing the
> whole thing completely done and functional to resolve. In fact, I'd
> rather not get too deep into detailed functional and state review with
> an RFC patch based on top of the current implementation, as this patch
> is, because that will just have to be repeated when broken down into
> smaller patches and rebased.
Sure, that's fine. It kind of feels like having a mid way review, but I 
understand it's not the easiest way to review things either :-)

> 
> Of course, that is not to say we shouldn't continue down this RFC path
> if you have other reasons to do so, aren't sold on the approach, have
> design concerns, etc. I'm not totally clear on where we stand on that
> tbh. This is just an FYI that if you want my .02, I think the design is
> reasonable and I'd probably reserve detailed review for a proper non-rfc
> series.
Alrighty, I think I get the idea of what we wanna see, so I move forward 
with a v14.  If I run into a snag, we can come back to the RFCs later. 
Thanks for all the help!

Allison

> 
> Brian
> 
>> Thanks for the reviews!  I know its complicated!!
>> Allison
>>
>>>
>>> Brian
>>>
>>>> +}
>>>> +
>>>>    /*
>>>>     * Return EEXIST if attr is found, or ENOATTR if not
>>>>     */
>>>> @@ -773,145 +888,6 @@ xfs_attr_leaf_try_add(
>>>>    /*
>>>> - * Add a name to the leaf attribute list structure
>>>> - *
>>>> - * This leaf block cannot have a "remote" value, we only call this routine
>>>> - * if bmap_one_block() says there is only one block (ie: no remote blks).
>>>> - *
>>>> - * This routine is meant to function as a delayed operation, and may return
>>>> - * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
>>>> - * to handle this, and recall the function until a successful error code is
>>>> - * returned.
>>>> - */
>>>> -STATIC int
>>>> -xfs_attr_leaf_addname(
>>>> -	struct xfs_attr_item		*attr)
>>>> -{
>>>> -	struct xfs_da_args		*args = attr->xattri_da_args;
>>>> -	struct xfs_buf			*bp = NULL;
>>>> -	int				error, forkoff;
>>>> -	struct xfs_inode		*dp = args->dp;
>>>> -	struct xfs_mount		*mp = args->dp->i_mount;
>>>> -
>>>> -	/* State machine switch */
>>>> -	switch (attr->xattri_dela_state) {
>>>> -	case XFS_DAS_FLIP_LFLAG:
>>>> -		goto das_flip_flag;
>>>> -	case XFS_DAS_RM_LBLK:
>>>> -		goto das_rm_lblk;
>>>> -	default:
>>>> -		break;
>>>> -	}
>>>> -
>>>> -	/*
>>>> -	 * If there was an out-of-line value, allocate the blocks we
>>>> -	 * identified for its storage and copy the value.  This is done
>>>> -	 * after we create the attribute so that we don't overflow the
>>>> -	 * maximum size of a transaction and/or hit a deadlock.
>>>> -	 */
>>>> -
>>>> -	/* Open coded xfs_attr_rmtval_set without trans handling */
>>>> -	if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
>>>> -		attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
>>>> -		if (args->rmtblkno > 0) {
>>>> -			error = xfs_attr_rmtval_find_space(attr);
>>>> -			if (error)
>>>> -				return error;
>>>> -		}
>>>> -	}
>>>> -
>>>> -	/*
>>>> -	 * Roll through the "value", allocating blocks on disk as
>>>> -	 * required.
>>>> -	 */
>>>> -	if (attr->xattri_blkcnt > 0) {
>>>> -		error = xfs_attr_rmtval_set_blk(attr);
>>>> -		if (error)
>>>> -			return error;
>>>> -
>>>> -		trace_xfs_das_state_return(attr->xattri_dela_state);
>>>> -		return -EAGAIN;
>>>> -	}
>>>> -
>>>> -	error = xfs_attr_rmtval_set_value(args);
>>>> -	if (error)
>>>> -		return error;
>>>> -
>>>> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>>>> -		/*
>>>> -		 * Added a "remote" value, just clear the incomplete flag.
>>>> -		 */
>>>> -		if (args->rmtblkno > 0)
>>>> -			error = xfs_attr3_leaf_clearflag(args);
>>>> -
>>>> -		return error;
>>>> -	}
>>>> -
>>>> -	/*
>>>> -	 * If this is an atomic rename operation, we must "flip" the incomplete
>>>> -	 * flags on the "new" and "old" attribute/value pairs so that one
>>>> -	 * disappears and one appears atomically.  Then we must remove the "old"
>>>> -	 * attribute/value pair.
>>>> -	 *
>>>> -	 * In a separate transaction, set the incomplete flag on the "old" attr
>>>> -	 * and clear the incomplete flag on the "new" attr.
>>>> -	 */
>>>> -	if (!xfs_hasdelattr(mp)) {
>>>> -		error = xfs_attr3_leaf_flipflags(args);
>>>> -		if (error)
>>>> -			return error;
>>>> -		/*
>>>> -		 * Commit the flag value change and start the next trans in series.
>>>> -		 */
>>>> -		attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
>>>> -		trace_xfs_das_state_return(attr->xattri_dela_state);
>>>> -		return -EAGAIN;
>>>> -	}
>>>> -das_flip_flag:
>>>> -	/*
>>>> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>>>> -	 * (if it exists).
>>>> -	 */
>>>> -	xfs_attr_restore_rmt_blk(args);
>>>> -
>>>> -	error = xfs_attr_rmtval_invalidate(args);
>>>> -	if (error)
>>>> -		return error;
>>>> -
>>>> -	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
>>>> -	attr->xattri_dela_state = XFS_DAS_RM_LBLK;
>>>> -das_rm_lblk:
>>>> -	if (args->rmtblkno) {
>>>> -		error = xfs_attr_rmtval_remove(attr);
>>>> -		if (error == -EAGAIN)
>>>> -			trace_xfs_das_state_return(attr->xattri_dela_state);
>>>> -		if (error)
>>>> -			return error;
>>>> -	}
>>>> -
>>>> -	/*
>>>> -	 * Read in the block containing the "old" attr, then remove the "old"
>>>> -	 * attr from that block (neat, huh!)
>>>> -	 */
>>>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>>>> -				   &bp);
>>>> -	if (error)
>>>> -		return error;
>>>> -
>>>> -	xfs_attr3_leaf_remove(bp, args);
>>>> -
>>>> -	/*
>>>> -	 * If the result is small enough, shrink it all into the inode.
>>>> -	 */
>>>> -	forkoff = xfs_attr_shortform_allfit(bp, dp);
>>>> -	if (forkoff)
>>>> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>>>> -		/* bp is gone due to xfs_da_shrink_inode */
>>>> -
>>>> -	return error;
>>>> -}
>>>> -
>>>> -/*
>>>>     * Return EEXIST if attr is found, or ENOATTR if not
>>>>     */
>>>>    STATIC int
>>>> @@ -1065,24 +1041,9 @@ xfs_attr_node_addname(
>>>>    	struct xfs_da_state_blk		*blk;
>>>>    	int				retval = 0;
>>>>    	int				error = 0;
>>>> -	struct xfs_mount		*mp = args->dp->i_mount;
>>>>    	trace_xfs_attr_node_addname(args);
>>>> -	/* State machine switch */
>>>> -	switch (attr->xattri_dela_state) {
>>>> -	case XFS_DAS_FLIP_NFLAG:
>>>> -		goto das_flip_flag;
>>>> -	case XFS_DAS_FOUND_NBLK:
>>>> -		goto das_found_nblk;
>>>> -	case XFS_DAS_ALLOC_NODE:
>>>> -		goto das_alloc_node;
>>>> -	case XFS_DAS_RM_NBLK:
>>>> -		goto das_rm_nblk;
>>>> -	default:
>>>> -		break;
>>>> -	}
>>>> -
>>>>    	/*
>>>>    	 * Search to see if name already exists, and get back a pointer
>>>>    	 * to where it should go.
>>>> @@ -1171,93 +1132,24 @@ xfs_attr_node_addname(
>>>>    	attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
>>>>    	trace_xfs_das_state_return(attr->xattri_dela_state);
>>>>    	return -EAGAIN;
>>>> -das_found_nblk:
>>>> -
>>>> -	/*
>>>> -	 * If there was an out-of-line value, allocate the blocks we
>>>> -	 * identified for its storage and copy the value.  This is done
>>>> -	 * after we create the attribute so that we don't overflow the
>>>> -	 * maximum size of a transaction and/or hit a deadlock.
>>>> -	 */
>>>> -	if (args->rmtblkno > 0) {
>>>> -		/* Open coded xfs_attr_rmtval_set without trans handling */
>>>> -		error = xfs_attr_rmtval_find_space(attr);
>>>> -		if (error)
>>>> -			return error;
>>>> -
>>>> -		/*
>>>> -		 * Roll through the "value", allocating blocks on disk as
>>>> -		 * required.  Set the state in case of -EAGAIN return code
>>>> -		 */
>>>> -		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
>>>> -das_alloc_node:
>>>> -		if (attr->xattri_blkcnt > 0) {
>>>> -			error = xfs_attr_rmtval_set_blk(attr);
>>>> -			if (error)
>>>> -				return error;
>>>> -
>>>> -			trace_xfs_das_state_return(attr->xattri_dela_state);
>>>> -			return -EAGAIN;
>>>> -		}
>>>> -
>>>> -		error = xfs_attr_rmtval_set_value(args);
>>>> -		if (error)
>>>> -			return error;
>>>> -	}
>>>> -
>>>> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>>>> -		/*
>>>> -		 * Added a "remote" value, just clear the incomplete flag.
>>>> -		 */
>>>> -		if (args->rmtblkno > 0)
>>>> -			error = xfs_attr3_leaf_clearflag(args);
>>>> -		retval = error;
>>>> -		goto out;
>>>> -	}
>>>> -
>>>> -	/*
>>>> -	 * If this is an atomic rename operation, we must "flip" the incomplete
>>>> -	 * flags on the "new" and "old" attribute/value pairs so that one
>>>> -	 * disappears and one appears atomically.  Then we must remove the "old"
>>>> -	 * attribute/value pair.
>>>> -	 *
>>>> -	 * In a separate transaction, set the incomplete flag on the "old" attr
>>>> -	 * and clear the incomplete flag on the "new" attr.
>>>> -	 */
>>>> -	if (!xfs_hasdelattr(mp)) {
>>>> -		error = xfs_attr3_leaf_flipflags(args);
>>>> -		if (error)
>>>> -			goto out;
>>>> -		/*
>>>> -		 * Commit the flag value change and start the next trans in series
>>>> -		 */
>>>> -		attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
>>>> -		trace_xfs_das_state_return(attr->xattri_dela_state);
>>>> -		return -EAGAIN;
>>>> -	}
>>>> -das_flip_flag:
>>>> -	/*
>>>> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>>>> -	 * (if it exists).
>>>> -	 */
>>>> -	xfs_attr_restore_rmt_blk(args);
>>>> +out:
>>>> +	if (state)
>>>> +		xfs_da_state_free(state);
>>>> -	error = xfs_attr_rmtval_invalidate(args);
>>>>    	if (error)
>>>>    		return error;
>>>> +	return retval;
>>>> +}
>>>> -	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
>>>> -	attr->xattri_dela_state = XFS_DAS_RM_NBLK;
>>>> -das_rm_nblk:
>>>> -	if (args->rmtblkno) {
>>>> -		error = xfs_attr_rmtval_remove(attr);
>>>> -
>>>> -		if (error == -EAGAIN)
>>>> -			trace_xfs_das_state_return(attr->xattri_dela_state);
>>>> -
>>>> -		if (error)
>>>> -			return error;
>>>> -	}
>>>> +STATIC
>>>> +int xfs_attr_node_addname_work(
>>>> +	struct xfs_attr_item		*attr)
>>>> +{
>>>> +	struct xfs_da_args		*args = attr->xattri_da_args;
>>>> +	struct xfs_da_state		*state = NULL;
>>>> +	struct xfs_da_state_blk		*blk;
>>>> +	int				retval = 0;
>>>> +	int				error = 0;
>>>>    	/*
>>>>    	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>>> index c80575a..050e5be 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>>> @@ -376,8 +376,10 @@ enum xfs_delattr_state {
>>>>    	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
>>>>    	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
>>>>    	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
>>>> +	XFS_DAS_ALLOC_LBLK,
>>>> +	XFS_DAS_SET_LBLK,
>>>>    	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
>>>> -	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
>>>> +	XFS_DAS_INVAL_LBLK,	      /* Invalidate leaf blks */
>>>>    	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
>>>>    	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
>>>>    	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
>>>> -- 
>>>> 2.7.4
>>>>
>>>
>>
> 
