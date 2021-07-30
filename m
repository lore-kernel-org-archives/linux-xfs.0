Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A41E3C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 09:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84A9161019
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 09:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbhG3JR5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Jul 2021 05:17:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39176 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237992AbhG3JR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jul 2021 05:17:56 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16U9CNqw004341;
        Fri, 30 Jul 2021 09:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HPS9hSIFE4bl/gwYejVbJS/wNbdtvFYjLWdEqWdRUCA=;
 b=jVaj8z+aZAvHDP4c4BgtWSC8+7R8/XqFypD+OoVqUYJIDdObAecDWgzANOmQFIMCoYOp
 TOxBCl+Gztna2qDm118nesNaTWz59kQO+5f9jOOy2S88vjRw6Q12Gtgc9/mJuNyqfcaC
 9bcbm5DeZmp7thWPBT22iuEWyAy7LX4a2YPOrV1Bevn5KhnUMaRo3V3QaQqFyFEwPmP7
 Tswox/HO3XlPv2v7Pu1Y1MH/EO/SLX4mp/clOz4aN07BzXSwJrfLTldBF10avsyBcV3N
 5FKpMuGyiHeOes1FsfFe67GtC41DujMUe/m6TEuUjsUNhuCkTrOb+Ho0kBT1wRG1qebb qA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=HPS9hSIFE4bl/gwYejVbJS/wNbdtvFYjLWdEqWdRUCA=;
 b=XOLifn3nVnFaNyAD31f6K6mtMwAAM+FaDxNO/CP3EY2ieQvkeTI9ijDoFCHgYe0W9EDH
 TB7gAZumM4yiRxGIzyEvRx/Qhz98X6BV+FeW8wUZxYyKzqFllI5Ozy0oA532GHGrxOZm
 KTGANxXZxNS2fIzFb7vVs5vQnJp8C1xnJWSfLuSKqa2dSEqIhtBt/ABRubJG7Z6rKcqn
 uBipbJxHY1JDKspU9VcrPPp7zkTqDR8i9MMmdBY03ZRvklxeaU1d6b8IWmY69nnEliuT
 KCK4AS+6EEkI0nMkFjPt9I0VSGj42gcVZ1pYhdfvCrZpdaijI0iCHhuK8e8Ae4TYllS2 Qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3jpd37ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 09:17:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16U9FOiK078509;
        Fri, 30 Jul 2021 09:17:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3020.oracle.com with ESMTP id 3a2352p0j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 09:17:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ggvgi3BvsbvVKXh1Y+POciWU4dtCf/oormNQv18iS5SRI1zorhuWJ4yJbBjDrDYNSj5n3ww8UiFyal0WusUoPdx2B+YHMU/+cWBGHFxpmiEo6btBmZ5LZT7ksudIiFZ+Sfzhdz1S9cKb9JzFVYtZTzksolZhiGdZzA3xZ3SOH5YnsZX56OemavQiAvaQmiakRGu/znYUzceIcuhHL+IXC9HGOIBDpq6mzSfdIr9b0tmzZovw6Aw04nI73FrwIelXwHEJAhuPMqF1Q34xpDb34d+U/LMw9XGpvzkKF3zKQCPJkV7oQf8YJd7jFzmMgnkvWEs/qQk/XmTQzn6Szyn/LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPS9hSIFE4bl/gwYejVbJS/wNbdtvFYjLWdEqWdRUCA=;
 b=lhf8vo8IlEBeJmebY7mF4I8SZe9IvfsvJsZMyQsWV67QpdoOeywzBDSybTmK3V16uym9xfoyGwwRESdhAPDHwYOOMjwKUw7+NtP5mt0h025CPCVakwfSpBLWTHGtzMdvxh9IwMziNS4oDg6Xb3KJd+muRhnYlROiSKyCrg7vf2R1XHSycKsQE+PWus2hA7ZRp3wem2Rtk/gtEvWvSxvNhLtmmiZW1/Jwxfhh5Y9qoCtNsOaN/wDjZ4sfwbjDgGSPEM0OUVxSoTLRmIOf5fNrj2TiH+bZZo7qg2QLZHfz07CEKj59qa2cyfu66AccbjjQX6RJR3YSQHFhQiF49fGQLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPS9hSIFE4bl/gwYejVbJS/wNbdtvFYjLWdEqWdRUCA=;
 b=oMGVIi0MYSn7qtMyn1BUnMrEcDLxSD8P5eYlLvT0AaZD04aPj3FpqsSMFWi+5wxx55vvPiAW4bygrOMmLeDH8u+SVLM3bGZSp/SyEH4o1LQuPn7kmAM9srwe8SBjWFNg5ybCKJrP39qL/le8HSgraxUTHa5ICOo6KKp7zSsEDh8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3384.namprd10.prod.outlook.com (2603:10b6:a03:14e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Fri, 30 Jul
 2021 09:17:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 09:17:48 +0000
Subject: Re: [PATCH v22 06/16] xfs: Rename __xfs_attr_rmtval_remove
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-7-allison.henderson@oracle.com> <875ywtft84.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <f4db006a-b2a2-73f5-c782-0d53ce0568d6@oracle.com>
Date:   Fri, 30 Jul 2021 02:17:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <875ywtft84.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0040.namprd08.prod.outlook.com
 (2603:10b6:a03:117::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by BYAPR08CA0040.namprd08.prod.outlook.com (2603:10b6:a03:117::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 09:17:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e53903cb-6641-478b-a449-08d9533ae5e8
X-MS-TrafficTypeDiagnostic: BYAPR10MB3384:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3384AC1513718D4D5D5AAD7995EC9@BYAPR10MB3384.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1VAE3OsA39P3YJw+r2ytnrhJ1XL/dxmyEdErumSUIEy0XpF/RYc2avH1v6G16RrY8Z9LQ5EyiENey2rGlaBVqmA4+99/aOV+2Ge7vQTFV0Vel9VL5ocwYfIViezClieG3XajS+SNfbqYlVGDy3jbbom1rOsCE8uUTTV0yAhgR2/PBL4Ootox36M2NmBZ5mH2jXN7Xxa2Rc+FddEt87kZ5g4uok3wCH1SksZh1bY5GgU+BupSYCaUDxMko6HR3vhc12WT41VJ1+DiJwdLqif+CDZ7xiIJXxNbgqeHYHrWF0PdJ/NS2UXCTV9d/VfYVwLmO1XQtouP4pNp2U+Nky1XQ9Rt6XrR1J3NQvYFljYcElhiVaXVKFZG3UnklewacEa3m8y4NFYa+vUu6hFPZzOys9lKXr1hmVociXUAqs1AGF9iSRUbHMRE7i/mHkgVTBXy9mQ7l0HbD6u5DNsDhOEGfQkLYf9b5SaZIn5jKeLn6Mmx+6F9ODpCA9O1W61wyqacbd8+wCYPhFJy49S96sr86qAjZEXnqlFfKesdyoo5dGa231H1wpuiZAvOKBAtie6ioIqo33cKl5pZ72iBwRgfx6d/wzm+b4xow40FJBj3d0HnyEZQk9yyczTDl+oAQgPePmdWqHmVNDgV/PJxYp/VJKw8Vx23pKXmxx5GR7rAAWhoDukW5buwwHSQ8uzljKew+qW0HSZMMczK4VBUjVmNoXitkF0XuT4vSCwgZrJUUb1NQ3d2os7Z31hZWrDW8i3IiT7GfFWyXBBlt1MihjpoeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(376002)(136003)(396003)(316002)(36756003)(4326008)(16576012)(8676002)(186003)(31696002)(66476007)(31686004)(478600001)(26005)(66556008)(8936002)(52116002)(66946007)(86362001)(44832011)(5660300002)(2906002)(6916009)(53546011)(38350700002)(38100700002)(2616005)(83380400001)(956004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHltdnczaDgvUHN3c2tIaGFhdjE5TVhNemFNWnkyV2hhanVWWTVJalRpalJ2?=
 =?utf-8?B?VDJ1YnViRWVxZDdXS1VkaWdPbXJaN0xLczk5cjQ4MmlvTTFrMzBQc3dRanl0?=
 =?utf-8?B?NnhXVXVrN2ROTElacUh3K1NFTDVXRDJHbGltd0cxTlB5VnBudFZLWFFwSEJx?=
 =?utf-8?B?bWFHclU4WDRNTWxKNzBNL2locnQ3eWlCSkpSV3ExVWI5QkppZHNOblpDc2t1?=
 =?utf-8?B?QnFZSVhIb2dTNDJhZ1Bja1dCQkwyUC9pWUxMSWczQmNCcXRrNW9PaHF2QmNt?=
 =?utf-8?B?bHF0ZEJ0VFU4TjhjTkMxdCs0V0o3Rkp3QUhDdDlGVnpWRUJZdG5QS1p3K0po?=
 =?utf-8?B?dUFRd1VDdVgvL0lJc3YxOGVTK1FXdlRMakMxS2szM2hsQzZjOCs4NXFZc0NS?=
 =?utf-8?B?cm1lMXpqbmRjYTA4TysvdDZPVTEvS0VNVjVhbU9aT1ZQOUEweWxzWXBVeDhL?=
 =?utf-8?B?TnNRZGl5ZmFiNEZNajZYcjhCS1QveHdoREJobjB1ZEhUWUZPZGNvZzBYU01E?=
 =?utf-8?B?VWtjZTN1ekJnQ0tsQW9qMmkxc3JIUG1MV1JTMnJYcWNqNWR6aFRTNVpXUHBI?=
 =?utf-8?B?UHFZTml1VGRsYkw1eTdqSzYzY0t3b3ZORUh6aDBYb1V3eGQ1eVRVbGJZTG1k?=
 =?utf-8?B?dzBFdjBRcEU4Z1JSZGtlSGNsK01JMVhEaHpxMVVGdHBxYVVwY1BKdVVsZGti?=
 =?utf-8?B?cFZzU0tNeGpVWXQ0NEpLWWNJUkcwK1ZZeG1TVnlzYWNzMmNidlkyOEdsTEth?=
 =?utf-8?B?MERGK0luZmN5MndqeER4Ykd1NWlkOERaYmVMamhvSDJCUzRCZlN1Y21zVGhT?=
 =?utf-8?B?aFhML1pSOGpUVjZiMVM0bXFGRHlRd0l1SG95QzVSeG45d25XSGhjUE9zRHZI?=
 =?utf-8?B?M2xmQW5NNXFNQlg1UEpsSHpkTzBXZ0VtWlhyeVRRUGhnSFArTkNMcnQzYSts?=
 =?utf-8?B?V0kvMmZWWk9mS216ZTJrOGs5cEdtamhOUUtQVjkwd1pWR285aE0xdy9oYWQx?=
 =?utf-8?B?SFZ3QmZrZWtmMTlubUd2Qk1nLzNQd2lpUTl3TlRWTHhEeFJuUFdLTG12cXBr?=
 =?utf-8?B?Vk9FNUxZTmJVbEJVQTlBRWN5Rjc1ZTUxSnBzN3IrOWpScWFXaGQzOGFSeWlS?=
 =?utf-8?B?Mlo1TTVwNUxjVzJaUW52TCtCcVFUNkZsSFljWWdIZFFLMUJmZmRlU3lveFpB?=
 =?utf-8?B?SXE0aVhoTjRJN2xzRS9BOFhCdmdqNll0blJuazdzMXd4WCtrUjBCSHE3dHJl?=
 =?utf-8?B?OFhpTzd4M0tFVVg4VjVnMEwyZ3NnZUhZTWxrTVpTajZBNHQzd05pSXZ5eEtp?=
 =?utf-8?B?R2FJRUd3YTVQUDg0ZkxmazcrdUpNTDNnMWlrMk9YVjcxR1FYTHZGcE91U2VV?=
 =?utf-8?B?NDBxQUJlMmFDWmhqZ2ozRzI3MkhwRzBCNUFycmhHcEdMZi95K3N3RVZsTTUz?=
 =?utf-8?B?SmJWcWt6NjZKZkVEaE5ZM2tvT21OZW9jRVF3OUJMY1AvZ1lvQmlmVnphaGJ1?=
 =?utf-8?B?YW83ckZhenVKaWhWMnpTckxRZ2NvZUY4YTB5VmJKOEx3bDg5VVZqbndTTUpj?=
 =?utf-8?B?VXUyY3dxKzhRdThRY2xuRmVuYnRPK3RuM2JxS0QycXljYkwzUk9nLzRFT1hV?=
 =?utf-8?B?RDNkNU9qbHNJS1h6N2s1YzRQdi9lNFAvRVBJRFZhWXJlSEJaNFhESGJwZ05Q?=
 =?utf-8?B?Tm0rTVFBYVV1cEM4THdsUGdHTzh0MEwrc2V6YTNBcE14UGh6dHZNVm43VFFP?=
 =?utf-8?Q?5n6oyHcHNK2yBoWanEbPQAOPZqtt24YK4+7oLr4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e53903cb-6641-478b-a449-08d9533ae5e8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 09:17:48.0849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ytDHhnFqdUQj1yFhC3Rz2ejDcwPiAMURh2camnl0K27/VGyOYNGacYy5GEZLM+FzQjP+3Z6HdXbjlVx1jPbjvJR+xrBnKZ1RNNNgAY5ZEPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3384
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10060 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107300056
X-Proofpoint-ORIG-GUID: 4MlRpipzpzmsD1UVeWiG9vm75ZqciYTV
X-Proofpoint-GUID: 4MlRpipzpzmsD1UVeWiG9vm75ZqciYTV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/29/21 12:56 AM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
>> to xfs_attr_rmtval_remove
>>
> 
> That was simple enough.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Great!  Thanks!

Allison

> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 6 +++---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
>>   fs/xfs/libxfs/xfs_attr_remote.h | 2 +-
>>   3 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index b0c6c62..5ff0320 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -502,7 +502,7 @@ xfs_attr_set_iter(
>>   		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
>>   		dac->dela_state = XFS_DAS_RM_LBLK;
>>   		if (args->rmtblkno) {
>> -			error = __xfs_attr_rmtval_remove(dac);
>> +			error = xfs_attr_rmtval_remove(dac);
>>   			if (error == -EAGAIN)
>>   				trace_xfs_attr_set_iter_return(
>>   					dac->dela_state, args->dp);
>> @@ -615,7 +615,7 @@ xfs_attr_set_iter(
>>   		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
>>   		dac->dela_state = XFS_DAS_RM_NBLK;
>>   		if (args->rmtblkno) {
>> -			error = __xfs_attr_rmtval_remove(dac);
>> +			error = xfs_attr_rmtval_remove(dac);
>>   			if (error == -EAGAIN)
>>   				trace_xfs_attr_set_iter_return(
>>   					dac->dela_state, args->dp);
>> @@ -1447,7 +1447,7 @@ xfs_attr_remove_iter(
>>   			 * May return -EAGAIN. Roll and repeat until all remote
>>   			 * blocks are removed.
>>   			 */
>> -			error = __xfs_attr_rmtval_remove(dac);
>> +			error = xfs_attr_rmtval_remove(dac);
>>   			if (error == -EAGAIN) {
>>   				trace_xfs_attr_remove_iter_return(
>>   						dac->dela_state, args->dp);
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 70f880d..1669043 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -672,7 +672,7 @@ xfs_attr_rmtval_invalidate(
>>    * routine until it returns something other than -EAGAIN.
>>    */
>>   int
>> -__xfs_attr_rmtval_remove(
>> +xfs_attr_rmtval_remove(
>>   	struct xfs_delattr_context	*dac)
>>   {
>>   	struct xfs_da_args		*args = dac->da_args;
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 61b85b9..d72eff3 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -12,7 +12,7 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>   		xfs_buf_flags_t incore_flags);
>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>> -int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>> +int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>>   int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
> 
> 
