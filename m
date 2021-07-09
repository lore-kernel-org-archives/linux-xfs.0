Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78963C07E9B
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 19:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C88E600D3
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 19:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhGIT7a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 15:59:30 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58518 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229459AbhGIT73 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 15:59:29 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 169JqiM9014534;
        Fri, 9 Jul 2021 19:56:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=jA60IeVdjqwRH0xXKHaK55BoYwSvRhJ+JiYJPMUg1QU=;
 b=hABMOYO3TDVHKPsoYP4f/iJqUZ/H5Wm7eb/l+tUdajqVhwwhtD7uDfE8pJ/hneaAD7dY
 9cyq/w7LA6rGY3W/CutFLHQKD6/Wz37iLe7BBz+q6jZmXHDEA2eKb+nT1avYqKM/BXlH
 tmEv+0IfGnLcl0aeha/TASmfaStej1CIdqNv46vMe8RZduf7D8LPz95Fq58eRkqnFMh8
 JeJgXyMBlQ8LDO+XlKXaOoMSrv3Q7JRY8MpxDDBaZg6n57fr4gvKSa67nURogoOUCr5t
 GABiAb7aMNa3sNxsWJU/JFpBrTGXCiMIJxFyS+QhXzDSyOykZDFfiaFGXJ3RXn1Wxurt lQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39npwbv5yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 19:56:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 169JugqQ113321;
        Fri, 9 Jul 2021 19:56:43 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by aserp3030.oracle.com with ESMTP id 39nbg9y02k-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 19:56:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTdEM2kq1+JH2obMSpuIPM05Fj93EETo3jqGHUdwOcwYnmtwwyFEXfKYpstoxdFiMbU3oZVrt/a9zb/sE2diNiVexZIWMuySE+lKUT5TrIAcpSvKlFNse4zW43cWiITTWwIrmDC6cbhTZE0nwk5XgkLR7d3Q9ccMq4c0ToSe/Y1gJ4KKefKrXpo8HAgCqDMTJJWhe9r+szwaem6DX6MIdBpUqhj0GFSlspPRsGkTseyqk+9MMbT1kTbHaNeAN33hhEf6JkT3CTPwFl9nltu2Umefjnl1BQ7fI71goak4UK30fkiQ7lgu5itQLYmRMIgcG1tsY64A03brsUGb6u6uOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jA60IeVdjqwRH0xXKHaK55BoYwSvRhJ+JiYJPMUg1QU=;
 b=avgbUsidheLLhH8jL+tR82YONkXi2MMlxhDrOyiupu3BvRV5z7zyfo5OYiUF3XlO85vL3f/GFDlk7Vn1aivbicgELYwsvkBn+uqvSTHjjGu/B1mFY+btjkhkS6DImeFJ8/owxl1w8kf6JWWH3eCoM6Tk6sKhpIqsGSMo9pQm0+gUK1xqIMJz8CwaqFMDPh8KX5pqC6KO7gE6Fdl25q9XQpGkV8n6skkTzPTlQvs/sOCZk5L8Lyb5yj+oKOLLMqyMe/8IHOqCsjefUi9FQu8a2ga17BXXA7bpYVImUpTEnHkaxlogOovRIswy35/8f3C4MWLeJ6YxTFcC6f4mFSjN5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jA60IeVdjqwRH0xXKHaK55BoYwSvRhJ+JiYJPMUg1QU=;
 b=QrEhgK57p5jGIseLfE1OrRZDhsqX1LVJKXWF1ls/qZkanPT4VO8cq78/bjLQSFSeq84vutTx15ADVRLQX1QNrmxMl4HokcS3ujo/bDUOiFzGJJsGuWK73j//WVhev8mnuqDQ/ybX2HO/Z1Tn3uB6Vvd+cobmaQohX+6PNO0ERK8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5471.namprd10.prod.outlook.com (2603:10b6:a03:302::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 19:56:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 19:56:28 +0000
Subject: Re: [PATCH v21 04/13] xfs: Handle krealloc errors in
 xlog_recover_add_to_cont_trans
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210707222111.16339-1-allison.henderson@oracle.com>
 <20210707222111.16339-5-allison.henderson@oracle.com>
 <20210709040921.GM11588@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <197d62be-66b2-d2fb-963b-504d8374b9f4@oracle.com>
Date:   Fri, 9 Jul 2021 12:56:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210709040921.GM11588@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0182.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR13CA0182.namprd13.prod.outlook.com (2603:10b6:a03:2c3::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.11 via Frontend Transport; Fri, 9 Jul 2021 19:56:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f07e6617-d47e-49f6-0e78-08d94313a3da
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5471:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5471EC7FF3DC6947179EC43595189@SJ0PR10MB5471.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I+v74aVITGyFa+6s/1lLJUGtOF0NfERQbNRI8v4Xl4ZmFx/1VbctdwqKVRZEeHiEP+fbVqaQHZ2QIWaOxcgSka132VcAq49V462c1FYcdjiHW6yn8sOkTYH1k/ZbZjwsiwtDR1uvAJK43XnaTadXyMgLIgGxU8rNMsH3fuIUp0CkTaR//mMKdHo6INNQQMSMk1XVCk8EfHWTaryUaBrQ6gHY8O2YarvycfwJfvi4WRLPZL/Ewexm6WCiC/EoKitJqp/ienXmN/6buKJh79iXouf9my+HHa5fBz71tw6IOhicTmhmbCGSCY3gU2tQjCYaIDRNpNQhsX+pcn88aYwb8dcZ3SXTykTh1J0n7yQSz8nfaYve6IPlP1Cxwpfjuoemh98ZKoAMu4g8yqLaIBWRaJJDM6z2gWf40GGi9d/kmKFMoAoIjyPvjsWfgcOo/blS71z1qtfnMYuwWG/Dvf/dg1H/OqL63hXKbc2SMiO+9S1AmwueBd473was1FlKnyJUs+5RDxEIfPGdC8NFznIs94GMG4NjsyS/D6UcFvx0QNHwRShkvp+f3ZGRGfngtALRsWPKYXfvqQvPPp9dKOCpD5AFBGBYWoH85hwrcooUUObe6S3UncjfZOdoX6HD6XwUlGZTzITjYxkfHAaVEU4bsR4NSCo1j2YHNLFpKHaNIZJY0rDdRrZSyeCQteAUYK8/iC5nKBomsiuRvYkmvNrJXmv9iUZQT1WGS11MMTby4HbxJm3c/t+CtJiPfmMYMxzu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(346002)(39850400004)(366004)(66946007)(66476007)(66556008)(31686004)(2906002)(86362001)(16576012)(186003)(6916009)(316002)(36756003)(52116002)(956004)(83380400001)(2616005)(53546011)(26005)(31696002)(38350700002)(8936002)(4326008)(478600001)(5660300002)(8676002)(6486002)(38100700002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWU0dkhtTW1PZGNqZTdjUVp3VE83V0NwSFc1RTNSdHY5b1lSbHNVMDJqRE80?=
 =?utf-8?B?amMxa01TVFBkaEt6NGkrUHlEUk80ME9POVFzZ0lTdDN4QktJRUk4ZlRLbVlG?=
 =?utf-8?B?d0p0emRVY2krVkRQRUh6M1o4MHR0V2N2L0tVeU9aQlZMMnc4ZzRqeVVVZWJq?=
 =?utf-8?B?UzJBQ2NHVkNGMWdyVUs0Q0ZHNlFaNzdKNFI0Rm82cUZ2Q3RvbGhOUkxranZK?=
 =?utf-8?B?eXpuVWlTZ2FCd3FTMnFBS1MzZlU2aDJUeDgyVUw2S2xsc1FXd2M4NHNySFBC?=
 =?utf-8?B?MElFN0dkazZFaVoyYk1hOUQwOE0rUHJ2aGllSmQvR2pWRHA1ai9TaHg2SlM3?=
 =?utf-8?B?QXVYbjRyYW1qb3h4bStNWVF1eUpFbnNka1I5UmlEeG1YSHdnNXRxRjk3QkNV?=
 =?utf-8?B?a1RkNDBmd0N2NXJ2R25keUM3bXhKLzI3ZmtrYk5lUmFtQUkvb2VpN1NWSFZE?=
 =?utf-8?B?VTVBclcxNWJuTVVXYURmMWdRa2tpeEg1U05sZ1FPR2tCd0RLNTRqY3g3R2VI?=
 =?utf-8?B?VU1MRWlsUE1RNEhZNzYyRnlzM1R6OWNDUzdndGpMUnFpajhTeFFXUC94UzBk?=
 =?utf-8?B?eGY4NTd4UG8yWmtqRHd0dnlGdEJkbUQwVmNYbjcxaXdON29vZkFYMjQ5aVht?=
 =?utf-8?B?LysrZmc0bDlTMU0xRUlVZUJxak54aEJXV1Noamh5OVZSb1A2Um9NZUNuVHM3?=
 =?utf-8?B?N24zbHhiK3RuV1lZK3NieUZqZmxpdGRxRWhnQ0IvSnROOEEzNVVLQ0prenp0?=
 =?utf-8?B?NHR5MnIvQTJmL2JhYzVhbVQrM1RmTlQzWHBObHYrSDlySXFuMVNXNXlFcC9w?=
 =?utf-8?B?bWJObzZ4c2RKRHZQZFBQQ2E5WGFyT2JVSVF1REFQZlVPRTd3OFFRNnNoalpt?=
 =?utf-8?B?c01oS29aMjlWdG1hRzBPUTdhSEZGUWxSMkhGUEpKaVB4UlJpRWtCZEdlV0pM?=
 =?utf-8?B?OUo3SEUyZnhWYmpiNkM0UFBsTFJnUWtHUUxEVStjMEhFMEcxTWp0MjVTeDI1?=
 =?utf-8?B?TE5KOWdjdERDelEvNlQ1MlhEMUtINDVUZXBZckhGN0llcms5VjBKYW90d01s?=
 =?utf-8?B?clkwdnR3cHJhTW1TSmh0ZTJ5cXdzYUNxVUtiNUtJMmcwbnZrYmNMemQ2OW9z?=
 =?utf-8?B?WFZZQWdzWFNZcWtMSXBQVUxHSU9ENW04RDB4RDJtMTE0T1V4Um5sRDNtZmFn?=
 =?utf-8?B?TTVTQjNtYUdER1piRG1iTWdvUDdKc2ZTUGRtZUVlSW10eHFLaVBldlMwL0FR?=
 =?utf-8?B?cXBpT0ZmNUp1K3RPd05MTll3UzZYUG1uQmhFVk9kNWhIdFpKUm9kTE1CU2NC?=
 =?utf-8?B?RGpaaGErcFBuSVd3VzdjN2dXMUR2WFhkVGdPbklNQ3plL25HZlMvSFF5YTg2?=
 =?utf-8?B?Yk9JTnllb1lxRkkyL3NUQXVXLzcxT1ZqcUxaNldvWlBqWDJnaUJRdkpWaUJu?=
 =?utf-8?B?Z1J2K2RJU3NWUExUYUx3UDIvTkZtc25KbXpvM0o5VWxoM01rbVgxSjBWL1lK?=
 =?utf-8?B?NUhTb1k4SXA5VEVDQ284eHJtb0ROUy9OTEN6UkQ5Nmhyc2FXL2VLZXVqRk5w?=
 =?utf-8?B?UGZ6RDBIQ0w4SVo1WE9haE9RMFZvTWRhb2ovNmZLbzdDZHNta04wODBpVlBE?=
 =?utf-8?B?SUFWNlU2ekcwOHNrWlZwK01HdWtFdThHdVpHK3BxR0hRdFJXZlQxQS82dDRM?=
 =?utf-8?B?MkxHbTF4b0h6OFF4Y0pGNnZGcDdUbnd4bFJWUXJ2UlA1WW82MHl4R2xKZVdt?=
 =?utf-8?Q?BeqQfOoo/nQeryOg2a9g6bhuNoPMNXSJWlafhPM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f07e6617-d47e-49f6-0e78-08d94313a3da
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 19:56:28.3097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BuhjBMyGiYpTuEWTJ3Un670qCD9gqFsGolYW9yuGEMPfztoe1uPrfuymBvAhSnSM/1tBRcPi3I6xJ5BM0coA1epvK3a8FhodDpPnPvq/ejc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5471
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10040 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107090098
X-Proofpoint-GUID: fl4vZ8pzN_eKS-3834kc0b6QPfJ-VjUm
X-Proofpoint-ORIG-GUID: fl4vZ8pzN_eKS-3834kc0b6QPfJ-VjUm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/8/21 9:09 PM, Darrick J. Wong wrote:
> On Wed, Jul 07, 2021 at 03:21:02PM -0700, Allison Henderson wrote:
>> Because xattrs can be over a page in size, we need to handle possible
>> krealloc errors to avoid warnings.  If the allocation does fail, fall
>> back to kmem_alloc_large, with a memcpy.
>>
>> The warning:
>>     WARNING: CPU: 1 PID: 20255 at mm/page_alloc.c:3446
>>                   get_page_from_freelist+0x100b/0x1690
>>
>> is caused when sizes larger that a page are allocated with the
>> __GFP_NOFAIL flag option.  We encounter this error now because attr
>> values can be up to 64k in size.  So we cannot use __GFP_NOFAIL, and
>> we need to handle the error code if the allocation fails.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> I'm pretty sure that 'mm: Add kvrealloc' fixes this a little more
> elegantly, but either look fine to me.  So while I'll probably take
> Dave's, here's a:
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> in the meantime.

Alrighty, thank you!  Either is fine.

Allison

> 
> --D
> 
>> ---
>>   fs/xfs/xfs_log_recover.c | 10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index ec4ccae..6ab467b 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -2062,7 +2062,15 @@ xlog_recover_add_to_cont_trans(
>>   	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
>>   	old_len = item->ri_buf[item->ri_cnt-1].i_len;
>>   
>> -	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
>> +	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL);
>> +	if (ptr == NULL) {
>> +		ptr = kmem_alloc_large(len + old_len, KM_ZERO);
>> +		if (ptr == NULL)
>> +			return -ENOMEM;
>> +
>> +		memcpy(ptr, old_ptr, old_len);
>> +	}
>> +
>>   	memcpy(&ptr[old_len], dp, len);
>>   	item->ri_buf[item->ri_cnt-1].i_len += len;
>>   	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
>> -- 
>> 2.7.4
>>
