Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04728C433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 22:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BABBE20897
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 22:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731919AbhAYWYq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:24:46 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47882 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732066AbhAYWX7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 17:23:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10PM96L6176329;
        Mon, 25 Jan 2021 22:23:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Sr4SlATGiOjiGKa8llmNGiXVpt24nvC5zMqFUGqKqt4=;
 b=fWivsFdwK79EhSJ1pM9ccaeNF+EUg8cACmfCBiPzm6v6/dOIgkP8IwbFoLxMpBj0Hqnc
 Bn7TGpiM+iyR7iLKZroOf8PUkYNrNktdh9WY+bpjBeObKPCdx0ce2rXvTtgUYWE5Wyeh
 h/Hsvz78zRumJfRfnVSnkgDKXCAHiNBaOGWgcTOgiuLEwKfweZzxqq6sQ1JgznrKFo/y
 yH88p8jeN1R2GiIelXu3MiNSfBbW+7dk5OaI/twh82le3lX5UI7ypKODnIMQu6Qg03Ap
 tbzvoSLtCffBMVdwgjkL9jzZSwbKu/rXvyg7c/MMNGrsrYYsgGJQ4Kq/KxfRM92ueMFt 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689aaft3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 22:23:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10PMB0LA152840;
        Mon, 25 Jan 2021 22:23:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3030.oracle.com with ESMTP id 368wcm7ft8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 22:23:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZhap/qIYBAcLYb5yQxFYT0Eug/nrOvCZl7IZp0CE1v1OgSVHnYSL3XFgQGMUxe5W6+Kd9AW7SzcPBpUIc13GxapjxhO4XIQNrl2/H6JP291+5GN6w6U1B2v1/pO6t0GSJDHjekYa0SJrmzK1qOrcMxkQHe3B0ooSyZy5oqRFAKQNI4kgoEtu4GHj2D+b44l58JBeP3Ovr5qfwozN0NAK6VyVISzdZbaOA+WuHBdodyUE/gno7iy2HBizJsGfzK2iltDKKuTUAwRyS65k/dw7g4dO6wAAd8e2Aar+O+Av2Qr3XiEcjtand3TvYimM+WMXtuj3xTxPSJEIGqZOfnuBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sr4SlATGiOjiGKa8llmNGiXVpt24nvC5zMqFUGqKqt4=;
 b=aoIWDXUACJImXF1kaINuYL2V5U8v7zNZtYTRiYEe3MprZK0pOjTs8wGg0FK2CFz5XgmzFrhQNstxwplSywHQAR3w12LovFtmhokQUsRh8gqmGFeaThxy7ZtL1UbMZaFnBJRkXNcDTwrhCacMxtERv+nBXgKlD8T19YUORd3klqA6xPODwoY7g0pj0Y7IQlJBT/8c+Me4JhOXRvzTw4S9UB941lSlYsd8q+eulXu3nTp1roEOdgLx0oTZgxbV8NxIT+PrQPg2V6lemx5ZoWY0L28E3BT8Csmge/kfnvRDXK51fBKdcGGO0gTYYdt5lh6BrMX00wfelbPsmpy+eme17w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sr4SlATGiOjiGKa8llmNGiXVpt24nvC5zMqFUGqKqt4=;
 b=FZvtHRZMB3dvj5n8gTy+w8isQXg1Qd/vqb+x3ywZyzEZlGrLPAmY79aSkWsQUQL7n98HAyKD06GnhH/WhfNeE9oo+2JpghuLzURnulfR6M3oERXFgFMXsXv1Q2nAiWMpOztV2ozjhPr2b5ZkzuzcFiW9mexqCIkM+Mz+0JLYGIc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4624.namprd10.prod.outlook.com (2603:10b6:a03:2de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Mon, 25 Jan
 2021 22:23:02 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3784.019; Mon, 25 Jan 2021
 22:23:02 +0000
Subject: Re: [PATCH RFC 1/1] xfs: refactor xfs_attr_set follow up
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210116081240.12478-1-allison.henderson@oracle.com>
 <20210121184720.GC1793795@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <ee542ded-3894-5511-bb83-beac5543ac6a@oracle.com>
Date:   Mon, 25 Jan 2021 15:22:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210121184720.GC1793795@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.89.149]
X-ClientProxiedBy: BYAPR02CA0047.namprd02.prod.outlook.com
 (2603:10b6:a03:54::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.223] (67.1.89.149) by BYAPR02CA0047.namprd02.prod.outlook.com (2603:10b6:a03:54::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Mon, 25 Jan 2021 22:23:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af7bc5ab-1d8c-4512-ca27-08d8c17fc74b
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4624:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4624804049A34E2665F9B64F95BD9@SJ0PR10MB4624.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sornl5fck2GWw9qay+c25eYL5k+TqTKVhb97VCDI4IUHq/7yhDE/Ny+fJKgKaeneHgj4tUMijKivsg0BRx/vCGh4J6plWA65hZb/wkNHsuBOpm4qif8qpe2aSXNMVJ7pwuZQ5jA4X07c4ILsZXFhuBWCCrIKTt+Pl4IVx9n39z6maZtaBw35ZMuY12913BmkoOkLmVkYgkXvjOahahYugLJvOBQuqoRSg4UAYQT+z5a/IiWdlxK69qhMv5kRJ0eF/1ngv2052O9Pzjg5QV8fMiiTKsLWjoWpWx42U1AdmYKghrhHncSTBDd0+KbvONXA7axVWak8D02rPH9BSvoPGpsa8GBLae06rT4kr3zi2GgLUdSQO8LJ03SblImRh61GEhJ7QpmVTEPmbjjj3WedvIZrT/yVKqG5N7VAsefb6uNxynnLhkMR97L4gxrCJbmm4hWSzSElKEyjGZyO2r8M28Pk+OPJ9FSuLPDunaDPb0yOXtbxrQIcoWDZsdGFxpnwgb3ct/iGaaeCDgZjqAHU2A1sbyc3USf61mAs3gvr+n8vLvw6ImTj/WsdXNgr72X+cI7b5y2xLhLLoHCq54kcFW/oSYmpLpPk0J1ez36EDLw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(366004)(396003)(186003)(16526019)(52116002)(53546011)(2616005)(36756003)(26005)(66946007)(31696002)(956004)(8676002)(66556008)(44832011)(66476007)(6486002)(2906002)(4326008)(6916009)(478600001)(30864003)(16576012)(5660300002)(86362001)(316002)(31686004)(83380400001)(6666004)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NmVwZnVWSVJVSFNZeWV5aEpaWXFpNG1tN3ZqaXp4cGpUeW9EcEFqWGVxSklR?=
 =?utf-8?B?MmY0eVJjeER5OVpVdk9OTjk4TmJ1N0R4d1krcTAza2FjUVFuWGxoeERLNVFx?=
 =?utf-8?B?TkFrY1hpK1AwVDVwcSt6cTNsWnpmc2RkN0RzL1JVMDR5NDRFbzFLeTZoNWs0?=
 =?utf-8?B?b1V3dE9FV3pPMnpCOGlTWk9xUHAyNFI1c2Z2emcvL2p2ZVBnOVQ0WHppbE0w?=
 =?utf-8?B?Z2NWQzI5RVVJV1lnZmlmYnFJWHhyQ1dRQnB5ZmF6V1pYRVNINlRWUmNkZDNz?=
 =?utf-8?B?cTFHV0xyUkJGdWJpSGkxMUU2MGhDSCsvZElmTE84VUlvRUdzaG1tZi9oK1dG?=
 =?utf-8?B?NkgzZElrWk1GTFQvbFYrVDlqa2FEODlaeFlNeW92dTYwNGIzeDlNOWpuREJr?=
 =?utf-8?B?anU1bDVJazN5cDh4VjVod3FPSVAxMnFFL1N5a3FwNUF2dko2UUNvMk15N2VC?=
 =?utf-8?B?WE9IalBENWJQeWR3d0t5SXVhWWZ2dVh0M1p6cVZ6ei84R1BqdFh2dFdmZ0sw?=
 =?utf-8?B?ZkIycW5vNlJ5em94RmJ2OEkyZ1pxREtSdzExeGdaaXkyb3hhS2hFWS9CbWF6?=
 =?utf-8?B?c1IyNWdkaFB1Y0lFdU8vWktkWER4M24vK3oyZG55RFROV1o5Mzh2Tno2emQv?=
 =?utf-8?B?cDZYUnJUNU5QeUR2dmtkOUxUbEZDdkgyamRmdjJmcm5mb3AzTHVZOUxXb3FK?=
 =?utf-8?B?TGk2bWV0d0Q2S05QSEp6RUJiQlBseGFCbzZBY2IyMlByRzlkcy9sWGxOc0JV?=
 =?utf-8?B?aGFMc0E3MDJNcGFVelEvNy93QlpJOWVQNi9tcEJUdDc5bFNweW1UL2N2MWpn?=
 =?utf-8?B?Z1JRWlBOUlR5b0g1UlRNYzFQUGF0a015YkdVM1owanBOR0trck1KbFpONFVt?=
 =?utf-8?B?ZFhFMkdkeTQvbUxFejlnUVdQMTlNZ3grT2JidXEyNnRhSkJldG9QRnRMdkRk?=
 =?utf-8?B?cXBUTlRXaWtoOFl2TTZrSGVQcTNIbnZ0OHVxMno0NGZYY0ZQM2N0MHNJMWxK?=
 =?utf-8?B?UjdzSXpvVjNBSzZlQzBUWXFrUzlkdXRTU01OOFdmeERFTTY0cVF3UGcyUW9I?=
 =?utf-8?B?aDk5MzlaeHNsQmt6RGptdU9GUnI2NGlXMWFJQThQcXo5UTVEZ1kvWWxocXdK?=
 =?utf-8?B?THh1STZJVGJCWXgvN3RvbkdjVEd3K0I1VkRaWk5wcGo1ZzhkYXd1TWl3SEVZ?=
 =?utf-8?B?MmMyTm9hS04rQ1RsRlFXVUNmZEE5MzBkMFNHZ3dEeHphc2tnYkxkVnR3VTJa?=
 =?utf-8?B?dEgvRTdTOHFjNDBFSHVMTkpqbDlTTFh3WlJBd0ZOaUpZNmZqWkU1aWsyY0tE?=
 =?utf-8?B?MEdxMC8ySDJDclJzSDVNTnpHYy9lY3NkWHNOVitBRWl1WWpTWGVQbjM5c2cx?=
 =?utf-8?B?QUNGR1MrdVQzSG1qN1pzTXA4eG1zaG1mNEM4aWdoL0pkLzUyOUFFSmI4MDRK?=
 =?utf-8?Q?Kco3wBgO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af7bc5ab-1d8c-4512-ca27-08d8c17fc74b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 22:23:02.4084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEAZ5jxvsxlg2qekcHhAq4u7Q7riUzSBS94ondXNrO9tW/Cg8JvhIkrwJ/oDnbn+N8EQfQ9525kCkp3GY3mIJdQlnTkXS2r9YbqI06k/cH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4624
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9875 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101250111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9875 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101250111
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/21/21 11:47 AM, Brian Foster wrote:
> On Sat, Jan 16, 2021 at 01:12:40AM -0700, Allison Henderson wrote:
>> Hi all,
>>
>> This is a follow up to Brians earlier patch
>> "[PATCH RFC] xfs: refactor xfs_attr_set() into incremental components"
>>
>> This patch resembles the earlier patch, but it is seated at the top of
>> the parent pointers set rather than the bottom to give a better
>> illustraion of what this approach might end up looking like in the
>> bigger picture.  This patch is both compiled and tested, and is meant to
>> be more of an exploratory effort than anything.
>>
>> Most of the state management is collapsed into the *_iter functions
>> similar to Brians patch which collapsed them into the *_args routines.
>> Though there are a few states that a still in a few subfunctions.
>>
>> In anycase, I think it gives decent idea of what the solution might
>> look like in practice.  Questions, comments and feedback appreciated.
>>
> 
> Thanks for the patch. By and large, I think the centralized state
> management of __xfs_attr_set_iter() is much more clear than the label
> management approach of jumping up and down through multiple levels of
> helper functions. For the most part, I'm able to walk through the iter
> function and follow the sequence of steps involved in the set. I did
> have some higher level comments on various parts of the patch,
> particularly where we seem to deviate from centralized state management.
> 
> Note that if we were to take this approach, a primary goal was to
> incrementally port the existing xfs_attr_set_args() implementation into
> states. For example, such that we could split the current monstrous
> xfs_attr_set() patch into multiple patches that introduce infrastructure
> first, and then convert the existing code a state or so at a time. That
> eliminates churn from factoring code into one scheme only to immediately
> refactor into another. It also facilitates testing because I think the
> rework should be able to maintain functionality across each step.
> 
> Porting on top of the whole thing certainly helps to get an advanced
> look at the final result. However, if we do use this approach and start
> getting into the details of individual states and whatnot, I do think it
> would be better to start breaking things down into smaller patches that
> replace some of the earlier code rather than use it as a baseline.
Sure, I think doing quick and dirty patches on top moves a little faster 
just because the infastructure is already setup, and I'm not working 
through merge conflicts, plus it cuts out the userspace side and just 
the misc nits that are probably best done after the greater 
architectural descisions are set.  The idea being to just establish an 
end goal of course.  It is tougher to review like this though, maybe we 
can do a few spins of this and I'll try to break it down into smaller 
chunks if that's ok.


> Further comments inline...
> 
>> Thanks!
>> Allison
>>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 596 +++++++++++++++++++----------------------------
>>   fs/xfs/libxfs/xfs_attr.h |   4 +-
>>   2 files changed, 247 insertions(+), 353 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 6ba8f4b..356e35c 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -45,8 +45,8 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>>   /*
>>    * Internal routines when attribute list is one block.
>>    */
>> +STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args      *args);
>>   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>> -STATIC int xfs_attr_leaf_addname(struct xfs_attr_item *attr);
>>   STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>   
>> @@ -55,6 +55,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>    */
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname(struct xfs_attr_item *attr);
>> +STATIC int xfs_attr_node_addname_work(struct xfs_attr_item *attr);
>>   STATIC int xfs_attr_node_removename_iter(struct xfs_attr_item *attr);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>> @@ -219,52 +220,77 @@ xfs_attr_is_shortform(
>>   		ip->i_afp->if_nextents == 0);
>>   }
>>   
>> -/*
>> - * Attempts to set an attr in shortform, or converts short form to leaf form if
>> - * there is not enough room.  This function is meant to operate as a helper
>> - * routine to the delayed attribute functions.  It returns -EAGAIN to indicate
>> - * that the calling function should roll the transaction, and then proceed to
>> - * add the attr in leaf form.  This subroutine does not expect to be recalled
>> - * again like the other delayed attr routines do.
>> - */
>> -STATIC int
>> -xfs_attr_set_shortform(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_buf		**leaf_bp)
>> +int
>> +xfs_attr_set_fmt(
>> +	struct xfs_attr_item	*attr,
>> +	bool			*done)
>>   {
>> +	struct xfs_da_args	*args = attr->xattri_da_args;
>>   	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_buf		**leaf_bp = &attr->xattri_leaf_bp;
>>   	int			error = 0;
>>   
>> -	/*
>> -	 * Try to add the attr to the attribute list in the inode.
>> -	 */
>> -	error = xfs_attr_try_sf_addname(dp, args);
>> +	*done = false;
>> +	if (xfs_attr_is_shortform(dp)) {
>>   
>> -	/* Should only be 0, -EEXIST or -ENOSPC */
>> -	if (error != -ENOSPC) {
>> -		return error;
>> +		*done = true;
>> +		error = xfs_attr_try_sf_addname(dp, args);
>> +		if (!error)
>> +			*done = true;
>> +
>> +		if (error != -ENOSPC)
>> +			return error;
>> +
>> +		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>> +		if (error)
>> +			return error;
>> +
>> +		xfs_trans_bhold(args->trans, *leaf_bp);
>> +
>> +		trace_xfs_das_state_return(XFS_DAS_UNINIT);
>> +		return -EAGAIN;
>>   	}
>>   	/*
>> -	 * It won't fit in the shortform, transform to a leaf block.  GROT:
>> -	 * another possible req'mt for a double-split btree op.
>> +	 * After a shortform to leaf conversion, we need to hold the leaf and
>> +	 * cycle out the transaction.  When we get back, we need to release
>> +	 * the leaf to release the hold on the leaf buffer.
>>   	 */
>> -	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>> -	if (error)
>> -		return error;
>> +	if (*leaf_bp != NULL) {
>> +		xfs_trans_bhold_release(args->trans, *leaf_bp);
>> +		*leaf_bp = NULL;
>> +	}
>>   
>> -	/*
>> -	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>> -	 * push cannot grab the half-baked leaf buffer and run into problems
>> -	 * with the write verifier.
>> -	 */
>> -	xfs_trans_bhold(args->trans, *leaf_bp);
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> +		error = xfs_attr_leaf_try_add(args, *leaf_bp);
>> +		switch (error) {
>> +		case -ENOSPC:
>> +			/*
>> +			 * Promote the attribute list to the Btree format.
>> +			 */
>> +			error = xfs_attr3_leaf_to_node(args);
>> +			if (error)
>> +				return error;
>>   
>> -	/*
>> -	 * We're still in XFS_DAS_UNINIT state here.  We've converted the attr
>> -	 * fork to leaf format and will restart with the leaf add.
>> -	 */
>> -	trace_xfs_das_state_return(XFS_DAS_UNINIT);
>> -	return -EAGAIN;
>> +			/*
>> +			 * Finish any deferred work items and roll the
>> +			 * transaction once more.  The goal here is to call
>> +			 * node_addname with the inode and transaction in the
>> +			 * same state (inode locked and joined, transaction
>> +			 * clean) no matter how we got to this step.
>> +			 *
>> +			 * At this point, we are still in XFS_DAS_UNINIT, but
>> +			 * when we come back, we'll be a node, so we'll fall
>> +			 * down into the node handling code below
>> +			 */
>> +			trace_xfs_das_state_return(attr->xattri_dela_state);
>> +			return -EAGAIN;
>> +		case 0:
>> +			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
>> +			trace_xfs_das_state_return(attr->xattri_dela_state);
>> +			return -EAGAIN;
>> +		}
>> +	}
>> +	return error;
>>   }
>>   
>>   /*
>> @@ -274,108 +300,197 @@ xfs_attr_set_shortform(
>>    * to handle this, and recall the function until a successful error code is
>>    * returned.
>>    */
>> -int
>> -xfs_attr_set_iter(
>> -	struct xfs_attr_item		*attr)
>> +STATIC int
>> +__xfs_attr_set_iter(
>> +	struct xfs_attr_item		*attr,
>> +	bool				*done)
>>   {
>>   	struct xfs_da_args		*args = attr->xattri_da_args;
>> -	struct xfs_inode		*dp = args->dp;
>> -	struct xfs_buf			**leaf_bp = &attr->xattri_leaf_bp;
>> -	int				error = 0;
>>   	int				sf_size;
>> +	struct xfs_buf			*bp = NULL;
>> +	int				error, forkoff;
>> +	struct xfs_inode		*dp = args->dp;
>> +	struct xfs_mount		*mp = args->dp->i_mount;
>>   
>>   	/* State machine switch */
>>   	switch (attr->xattri_dela_state) {
>> -	case XFS_DAS_FLIP_LFLAG:
>> -	case XFS_DAS_FOUND_LBLK:
>> -	case XFS_DAS_RM_LBLK:
>> -		return xfs_attr_leaf_addname(attr);
>> -	case XFS_DAS_FOUND_NBLK:
>> -	case XFS_DAS_FLIP_NFLAG:
>> -	case XFS_DAS_ALLOC_NODE:
>> -		return xfs_attr_node_addname(attr);
>>   	case XFS_DAS_UNINIT:
>> -		break;
>> -	default:
>> -		ASSERT(attr->xattri_dela_state != XFS_DAS_RM_SHRINK);
>> -		break;
>> -	}
>> +		if (XFS_IFORK_Q((args->dp)) == 0) {
>> +			sf_size = sizeof(struct xfs_attr_sf_hdr) +
>> +				  xfs_attr_sf_entsize_byname(args->namelen,
>> +							     args->valuelen);
>> +			xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
>> +			args->dp->i_afp = kmem_cache_zalloc(xfs_ifork_zone, 0);
>> +			args->dp->i_afp->if_flags = XFS_IFEXTENTS;
>> +			args->dp->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
>> +		}
>>   
>> -	/*
>> -	 * New inodes may not have an attribute fork yet. So set the attribute
>> -	 * fork appropriately
>> -	 */
>> -	if (XFS_IFORK_Q((args->dp)) == 0) {
>> -		sf_size = sizeof(struct xfs_attr_sf_hdr) +
>> -				 xfs_attr_sf_entsize_byname(args->namelen,
>> -							    args->valuelen);
>> -		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
>> -		args->dp->i_afp = kmem_cache_zalloc(xfs_ifork_zone, 0);
>> -		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
>> -		args->dp->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
>> -	}
>> +		return xfs_attr_set_fmt(attr, done);
> 
> One thing the original patch tried to accomplish was to draw a line
> between the state management and underlying helpers in this iter()
> function. It looks like you've done that in other places, but here some
> of that state code is buried down in _set_fmt(). Instead, I think the
> helper should return -EAGAIN only if it should be called again and
> otherwise return 0. 
Right, but then the caller lacks enough context to decide which state 
that -EAGAIN is meant to go to.  I think I may do a little more digging 
in this area, I think we may have to further break up the helper, but 
should be do-able.

The caller then determines if/how/when to move to
> the next state. The purpose of the done flag in this case was to let the
> caller know whether the operation had completed or to move on to the
> next state.
> 
> Also, I notice a lot of
> trace_xfs_das_state_return(attr->xattri_dela_state) calls scattered
> about. Could we turn that into a common exit path out of this function
> and let the users fall into it appropriately with a label?
Sure, will do.  The traces are new from the last review, so they will 
likly still churn some reviews.  But they go in after the refactoring, 
so I'm not too worried about them at this level since we're we're mostly 
focused on re-arranging the statemachine.

> 
>> +	case XFS_DAS_FOUND_LBLK:
>> +		if (args->rmtblkno > 0) {
>> +			error = xfs_attr_rmtval_find_space(attr);
>> +			if (error)
>> +				return error;
>> +		}
>> +		attr->xattri_dela_state = XFS_DAS_ALLOC_LBLK;
> 
> Just FWIW, I get a bunch of warnings related to these fallthrus with gcc
> 10.2.1.
Ok, will add some /* fallthough */ commentary here
> 
>> +	case XFS_DAS_ALLOC_LBLK:
>> +		if (attr->xattri_blkcnt > 0) {
>> +			error = xfs_attr_rmtval_set_blk(attr);
>> +			if (error)
>> +				return error;
>>   
>> -	/*
>> -	 * If the attribute list is already in leaf format, jump straight to
>> -	 * leaf handling.  Otherwise, try to add the attribute to the shortform
>> -	 * list; if there's no room then convert the list to leaf format and try
>> -	 * again. No need to set state as we will be in leaf form when we come
>> -	 * back
>> -	 */
>> -	if (xfs_attr_is_shortform(dp)) {
>> +			trace_xfs_das_state_return(attr->xattri_dela_state);
>> +			return -EAGAIN;
>> +		}
>> +		attr->xattri_dela_state = XFS_DAS_SET_LBLK;
>> +	case XFS_DAS_SET_LBLK:
>> +		error = xfs_attr_rmtval_set_value(args);
>> +		if (error)
>> +			return error;
>>   
>> -		/*
>> -		 * If the attr was successfully set in shortform, no need to
>> -		 * continue.  Otherwise, is it converted from shortform to leaf
>> -		 * and -EAGAIN is returned.
>> -		 */
>> -		return xfs_attr_set_shortform(args, leaf_bp);
>> -	}
>> +		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>> +			/*
>> +			 * Added a "remote" value, just clear the incomplete flag.
>> +			 */
>> +			if (args->rmtblkno > 0)
>> +				error = xfs_attr3_leaf_clearflag(args);
>>   
>> -	/*
>> -	 * After a shortform to leaf conversion, we need to hold the leaf and
>> -	 * cycle out the transaction.  When we get back, we need to release
>> -	 * the leaf to release the hold on the leaf buffer.
>> -	 */
>> -	if (*leaf_bp != NULL) {
>> -		xfs_trans_bhold_release(args->trans, *leaf_bp);
>> -		*leaf_bp = NULL;
>> -	}
>> +			return error;
>> +		}
>>   
>> -	if (!xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> -		return xfs_attr_node_addname(attr);
>> +		if (xfs_hasdelattr(mp))
>> +			return error;
>>   
>> -	error = xfs_attr_leaf_try_add(args, *leaf_bp);
>> -	switch (error) {
>> -	case -ENOSPC:
>> +		error = xfs_attr3_leaf_flipflags(args);
>> +		if (error)
>> +			return error;
>>   		/*
>> -		 * Promote the attribute list to the Btree format.
>> +		 * Commit the flag value change and start the next trans in series.
>>   		 */
>> -		error = xfs_attr3_leaf_to_node(args);
>> +		attr->xattri_dela_state = XFS_DAS_INVAL_LBLK;
>> +		trace_xfs_das_state_return(attr->xattri_dela_state);
>> +		return -EAGAIN;
>> +
>> +	case XFS_DAS_INVAL_LBLK:
>> +		xfs_attr_restore_rmt_blk(args);
>> +
>> +		error = xfs_attr_rmtval_invalidate(args);
>>   		if (error)
>>   			return error;
>>   
>> +		attr->xattri_dela_state = XFS_DAS_RM_LBLK;
>> +	case XFS_DAS_RM_LBLK:
>> +		if (args->rmtblkno) {
>> +			error = xfs_attr_rmtval_remove(attr);
>> +			if (error == -EAGAIN)
>> +				trace_xfs_das_state_return(attr->xattri_dela_state);
>> +			if (error)
>> +				return error;
>> +		}
>> +
>> +		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> +				   &bp);
>> +		if (error)
>> +			return error;
>> +
>> +		xfs_attr3_leaf_remove(bp, args);
>> +
>> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
>> +		if (forkoff)
>> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> +			/* bp is gone due to xfs_da_shrink_inode */
>> +
>> +		return error;
> 
> Is this a completion state? How do end up in the state below?
> 
> Hmm.. that comes from xfs_attr_node_addname(), so it looks like this was
> split into semi-duplicate states between leaf/node formats. Was there a
> reason this was split up instead of folded together as attempted in the
> original patch?
I may have missed this collapse here.  I will see if I can consolodate 
those two

> 
>> +	case XFS_DAS_FOUND_NBLK:
>> +		if (args->rmtblkno > 0) {
>> +			error = xfs_attr_rmtval_find_space(attr);
>> +			if (error)
>> +				return error;
>> +
>> +		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
>> +	case XFS_DAS_ALLOC_NODE:
> 
> Oof, the case statement inside the if branch is rather odd here.
Yeah, I actually didnt know you could have a case in the middle of a 
scope like that, but I guess that's legal.  I could maybe wrap the below 
in a if (attr->xattri_dela_state == XFS_DAS_ALLOC_NODE).  I think that 
would be logically equivelent
> 
>> +			if (attr->xattri_blkcnt > 0) {
>> +				error = xfs_attr_rmtval_set_blk(attr);
>> +				if (error)
>> +					return error;
>> +
>> +				trace_xfs_das_state_return(attr->xattri_dela_state);
>> +				return -EAGAIN;
>> +			}
>> +
>> +			error = xfs_attr_rmtval_set_value(args);
>> +			if (error)
>> +				return error;
>> +		}
>> +
>> +		if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>> +			/*
>> +			 * Added a rmt value, just clear the incomplete flag.
>> +			 */
>> +			if (args->rmtblkno > 0)
>> +				error = xfs_attr3_leaf_clearflag(args);
>> +			return error;
>> +		}
>> +
>> +		if (!xfs_hasdelattr(mp)) {
>> +			error = xfs_attr3_leaf_flipflags(args);
>> +			if (error)
>> +				return error;
>> +			/*
>> +			 * Commit the flag value change and start the next trans
>> +			 * in series
>> +			 */
>> +			attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
>> +			trace_xfs_das_state_return(attr->xattri_dela_state);
>> +			return -EAGAIN;
>> +		}
>> +	case XFS_DAS_FLIP_NFLAG:
>>   		/*
>> -		 * Finish any deferred work items and roll the
>> -		 * transaction once more.  The goal here is to call
>> -		 * node_addname with the inode and transaction in the
>> -		 * same state (inode locked and joined, transaction
>> -		 * clean) no matter how we got to this step.
>> -		 *
>> -		 * At this point, we are still in XFS_DAS_UNINIT, but
>> -		 * when we come back, we'll be a node, so we'll fall
>> -		 * down into the node handling code below
>> +		 * Dismantle the "old" attribute/value pair by removing a
>> +		 * "remote" value (if it exists).
>>   		 */
>> -		trace_xfs_das_state_return(attr->xattri_dela_state);
>> -		return -EAGAIN;
>> -	case 0:
>> -		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
>> -		trace_xfs_das_state_return(attr->xattri_dela_state);
>> -		return -EAGAIN;
>> +		xfs_attr_restore_rmt_blk(args);
>> +
>> +		error = xfs_attr_rmtval_invalidate(args);
>> +		if (error)
>> +			return error;
>> +
>> +		attr->xattri_dela_state = XFS_DAS_RM_NBLK;
>> +	case XFS_DAS_RM_NBLK:
>> +		if (args->rmtblkno) {
>> +			error = xfs_attr_rmtval_remove(attr);
>> +
>> +			if (error == -EAGAIN) {
>> +				attr->xattri_dela_state = XFS_DAS_RM_NBLK;
>> +				trace_xfs_das_state_return(attr->xattri_dela_state);
>> +			}
>> +
>> +			if (error)
>> +				return error;
>> +		}
>> +
>> +		return xfs_attr_node_addname_work(attr);
>> +	default:
>> +		ASSERT(attr->xattri_dela_state != XFS_DAS_RM_SHRINK);
>> +		break;
>>   	}
>> +
>>   	return error;
>>   }
>>   
>> +int xfs_attr_set_iter(
>> +	struct xfs_attr_item	*attr)
>> +{
>> +	bool	done = true;
>> +	int 	error;
>> +
>> +	error =  __xfs_attr_set_iter(attr, &done);
>> +	if (error || done)
>> +		return error;
>> +
>> +	return xfs_attr_node_addname(attr);
> 
> Note that this was also intended to go away and get folded into the
> state code in __xfs_attr_set_iter(), I just left off here because it
> looked like there might have been opportunity to fall into the remove
> path, and that was getting a bit more involved than I wanted to. This
> variant looks a little different in that we can presumably fall into
> this function and then back into the state machine. Even if we didn't
> immediately reuse the remove path, I suspect we should probably continue
> chunking off the remainder of the operation into proper states.
Yes, I'm thinking maybe I could chop this down into a few patches that 
just sort of hoist everything up and then try to collapse down any 
duplicated code in a successive patch.  It'll create bit of a monster 
function at first, but I think it might help us find the an arrangement 
we like.

Thanks for the reviews!  I know its complicated!!
Allison

> 
> Brian
> 
>> +}
>> +
>>   /*
>>    * Return EEXIST if attr is found, or ENOATTR if not
>>    */
>> @@ -773,145 +888,6 @@ xfs_attr_leaf_try_add(
>>   
>>   
>>   /*
>> - * Add a name to the leaf attribute list structure
>> - *
>> - * This leaf block cannot have a "remote" value, we only call this routine
>> - * if bmap_one_block() says there is only one block (ie: no remote blks).
>> - *
>> - * This routine is meant to function as a delayed operation, and may return
>> - * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
>> - * to handle this, and recall the function until a successful error code is
>> - * returned.
>> - */
>> -STATIC int
>> -xfs_attr_leaf_addname(
>> -	struct xfs_attr_item		*attr)
>> -{
>> -	struct xfs_da_args		*args = attr->xattri_da_args;
>> -	struct xfs_buf			*bp = NULL;
>> -	int				error, forkoff;
>> -	struct xfs_inode		*dp = args->dp;
>> -	struct xfs_mount		*mp = args->dp->i_mount;
>> -
>> -	/* State machine switch */
>> -	switch (attr->xattri_dela_state) {
>> -	case XFS_DAS_FLIP_LFLAG:
>> -		goto das_flip_flag;
>> -	case XFS_DAS_RM_LBLK:
>> -		goto das_rm_lblk;
>> -	default:
>> -		break;
>> -	}
>> -
>> -	/*
>> -	 * If there was an out-of-line value, allocate the blocks we
>> -	 * identified for its storage and copy the value.  This is done
>> -	 * after we create the attribute so that we don't overflow the
>> -	 * maximum size of a transaction and/or hit a deadlock.
>> -	 */
>> -
>> -	/* Open coded xfs_attr_rmtval_set without trans handling */
>> -	if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
>> -		attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
>> -		if (args->rmtblkno > 0) {
>> -			error = xfs_attr_rmtval_find_space(attr);
>> -			if (error)
>> -				return error;
>> -		}
>> -	}
>> -
>> -	/*
>> -	 * Roll through the "value", allocating blocks on disk as
>> -	 * required.
>> -	 */
>> -	if (attr->xattri_blkcnt > 0) {
>> -		error = xfs_attr_rmtval_set_blk(attr);
>> -		if (error)
>> -			return error;
>> -
>> -		trace_xfs_das_state_return(attr->xattri_dela_state);
>> -		return -EAGAIN;
>> -	}
>> -
>> -	error = xfs_attr_rmtval_set_value(args);
>> -	if (error)
>> -		return error;
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
>> -	if (!xfs_hasdelattr(mp)) {
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			return error;
>> -		/*
>> -		 * Commit the flag value change and start the next trans in series.
>> -		 */
>> -		attr->xattri_dela_state = XFS_DAS_FLIP_LFLAG;
>> -		trace_xfs_das_state_return(attr->xattri_dela_state);
>> -		return -EAGAIN;
>> -	}
>> -das_flip_flag:
>> -	/*
>> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> -	 * (if it exists).
>> -	 */
>> -	xfs_attr_restore_rmt_blk(args);
>> -
>> -	error = xfs_attr_rmtval_invalidate(args);
>> -	if (error)
>> -		return error;
>> -
>> -	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
>> -	attr->xattri_dela_state = XFS_DAS_RM_LBLK;
>> -das_rm_lblk:
>> -	if (args->rmtblkno) {
>> -		error = xfs_attr_rmtval_remove(attr);
>> -		if (error == -EAGAIN)
>> -			trace_xfs_das_state_return(attr->xattri_dela_state);
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
>> -/*
>>    * Return EEXIST if attr is found, or ENOATTR if not
>>    */
>>   STATIC int
>> @@ -1065,24 +1041,9 @@ xfs_attr_node_addname(
>>   	struct xfs_da_state_blk		*blk;
>>   	int				retval = 0;
>>   	int				error = 0;
>> -	struct xfs_mount		*mp = args->dp->i_mount;
>>   
>>   	trace_xfs_attr_node_addname(args);
>>   
>> -	/* State machine switch */
>> -	switch (attr->xattri_dela_state) {
>> -	case XFS_DAS_FLIP_NFLAG:
>> -		goto das_flip_flag;
>> -	case XFS_DAS_FOUND_NBLK:
>> -		goto das_found_nblk;
>> -	case XFS_DAS_ALLOC_NODE:
>> -		goto das_alloc_node;
>> -	case XFS_DAS_RM_NBLK:
>> -		goto das_rm_nblk;
>> -	default:
>> -		break;
>> -	}
>> -
>>   	/*
>>   	 * Search to see if name already exists, and get back a pointer
>>   	 * to where it should go.
>> @@ -1171,93 +1132,24 @@ xfs_attr_node_addname(
>>   	attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
>>   	trace_xfs_das_state_return(attr->xattri_dela_state);
>>   	return -EAGAIN;
>> -das_found_nblk:
>> -
>> -	/*
>> -	 * If there was an out-of-line value, allocate the blocks we
>> -	 * identified for its storage and copy the value.  This is done
>> -	 * after we create the attribute so that we don't overflow the
>> -	 * maximum size of a transaction and/or hit a deadlock.
>> -	 */
>> -	if (args->rmtblkno > 0) {
>> -		/* Open coded xfs_attr_rmtval_set without trans handling */
>> -		error = xfs_attr_rmtval_find_space(attr);
>> -		if (error)
>> -			return error;
>> -
>> -		/*
>> -		 * Roll through the "value", allocating blocks on disk as
>> -		 * required.  Set the state in case of -EAGAIN return code
>> -		 */
>> -		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
>> -das_alloc_node:
>> -		if (attr->xattri_blkcnt > 0) {
>> -			error = xfs_attr_rmtval_set_blk(attr);
>> -			if (error)
>> -				return error;
>> -
>> -			trace_xfs_das_state_return(attr->xattri_dela_state);
>> -			return -EAGAIN;
>> -		}
>> -
>> -		error = xfs_attr_rmtval_set_value(args);
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
>> -		retval = error;
>> -		goto out;
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
>> -	if (!xfs_hasdelattr(mp)) {
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			goto out;
>> -		/*
>> -		 * Commit the flag value change and start the next trans in series
>> -		 */
>> -		attr->xattri_dela_state = XFS_DAS_FLIP_NFLAG;
>> -		trace_xfs_das_state_return(attr->xattri_dela_state);
>> -		return -EAGAIN;
>> -	}
>> -das_flip_flag:
>> -	/*
>> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> -	 * (if it exists).
>> -	 */
>> -	xfs_attr_restore_rmt_blk(args);
>> +out:
>> +	if (state)
>> +		xfs_da_state_free(state);
>>   
>> -	error = xfs_attr_rmtval_invalidate(args);
>>   	if (error)
>>   		return error;
>> +	return retval;
>> +}
>>   
>> -	/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
>> -	attr->xattri_dela_state = XFS_DAS_RM_NBLK;
>> -das_rm_nblk:
>> -	if (args->rmtblkno) {
>> -		error = xfs_attr_rmtval_remove(attr);
>> -
>> -		if (error == -EAGAIN)
>> -			trace_xfs_das_state_return(attr->xattri_dela_state);
>> -
>> -		if (error)
>> -			return error;
>> -	}
>> +STATIC
>> +int xfs_attr_node_addname_work(
>> +	struct xfs_attr_item		*attr)
>> +{
>> +	struct xfs_da_args		*args = attr->xattri_da_args;
>> +	struct xfs_da_state		*state = NULL;
>> +	struct xfs_da_state_blk		*blk;
>> +	int				retval = 0;
>> +	int				error = 0;
>>   
>>   	/*
>>   	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index c80575a..050e5be 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -376,8 +376,10 @@ enum xfs_delattr_state {
>>   	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
>>   	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
>>   	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
>> +	XFS_DAS_ALLOC_LBLK,
>> +	XFS_DAS_SET_LBLK,
>>   	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
>> -	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
>> +	XFS_DAS_INVAL_LBLK,	      /* Invalidate leaf blks */
>>   	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
>>   	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
>>   	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
>> -- 
>> 2.7.4
>>
> 
