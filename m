Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB09C47088
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 18:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 172BF613C5
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 18:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbhEZSPJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 14:15:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54194 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbhEZSPI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 14:15:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14QIDYaQ049246;
        Wed, 26 May 2021 18:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=YfFVnD3bVw4NZvIgpcq8IIgGTcBHCEboos2Hc49SqY0=;
 b=xe+uE/6KwUMF9bxSJshcnyG/DIJ5u8Gbtt/X/y5CluB48v+RjxCmRvIsz3f7dlw9GEcq
 vmt9d29W4LreVSCIpypqfcIic0TTI1NMGUEABNoIG6mFpv4lCwNGdNqV1R4a/LGaR37g
 6GnXqxvpMebz5EpY16MPP6av+dUyy0UnSyQ+4lyuJIivVtNVR+2qKWKypL1arx873gmx
 OC8a+h9qVCew8gV3q8zUBgp84mA062wYPeeGZF4KCAMk/4wHuKbozr1PLIIU/2gRM9t5
 +Zsdi3RQyD+5iO8X9XlDXNhIEECr8tvNVfYNzb8aOP0SKw2I9cfZ+o0ZG1Czkb5EUotO /Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 38q3q91fhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 18:13:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14QIA7XA049143;
        Wed, 26 May 2021 18:13:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3030.oracle.com with ESMTP id 38pr0cxfv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 18:13:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vh4cGIxxfhzQv+GsXRyeIzNWVTb4B63f2NtTLaUTNLazFISZh2ZE1I/Nr3Sqk9zrZ77vMawWdXOaGNSD4IHzsn0bYyCR59NpSYq4LIv1T87WsMV4uxKG+OTY//bwtstsBkNtIh49Ar0NrsNag6HIK1OAZdPDocL/4U1kKWjXbVG0n3Tz6RBonLUqK5Yxy0K0UFWc+HREQC38aX1AUJphd9qxVeArRKTaohBB962G0NAedBZ8lxPqIY8DIhIxG+fY3G5FnlBriIqAIlNhzw8G/v+56c/8+/twjkNCZgVJFzPlLLdGZUvSX6JYlQ8vtggfGMk/w5z2BC32niDWMNeYTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfFVnD3bVw4NZvIgpcq8IIgGTcBHCEboos2Hc49SqY0=;
 b=HJ0ruV9CIEzrsrorgsXYxftVVXKiDvNPU4hiLIoTmEQoV7tFA0zQ89yWJ3UXkD01b1fellAxW/a1GFpueRFm55QYEZxhgMTW3KmW300doPTzPNy1TmTa9Cc3BxQevSmmYPaXgI7CBgPJ8VcDsb3K8cSpXvQzYUnq9TvjTNyMoufwZHUT5Qp7IcoLZvZcmWcXa/sajOMWc5ToUXZuOMD12sevbQYBuUaDngsFoe3O8FURfgnxxFBvDtOPMveCMPJK2FZEyT8Gf149Yyr0hV2YNoijy7fJDSXstoqFvAT3HLx3pTSh+uLbcrkS0yhh7LFEojkeiNuRJIGGN4e6zzqcFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfFVnD3bVw4NZvIgpcq8IIgGTcBHCEboos2Hc49SqY0=;
 b=s1lPrHR0MiZu/2f/WXMUzCGgXWonocw5RnbNjQRvxmCR/e3kmH9QRDTZgqRkDAWJ3KPQq7cyFWv4WAoak6iGZW0uVMniG65Z7wvdAzOrmi7XBf1DaDlM0luufMlsceAEPc6/9wO+DmZHJLEmQ03RnUy8F+SkoeVpVM51Iq8dcmY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3607.namprd10.prod.outlook.com (2603:10b6:a03:121::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Wed, 26 May
 2021 18:13:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 18:13:31 +0000
Subject: Re: [PATCH v19 13/14] xfs: Remove default ASSERT in xfs_attr_set_iter
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210525195504.7332-1-allison.henderson@oracle.com>
 <20210525195504.7332-14-allison.henderson@oracle.com>
 <20210525205242.GN202121@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <3d603e99-3f19-9138-5aa2-a659fd571057@oracle.com>
Date:   Wed, 26 May 2021 11:13:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210525205242.GN202121@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR03CA0011.namprd03.prod.outlook.com (2603:10b6:a03:33a::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend Transport; Wed, 26 May 2021 18:13:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d52b1847-1c55-4a25-8c41-08d92071f823
X-MS-TrafficTypeDiagnostic: BYAPR10MB3607:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3607726645BB490997C1602E95249@BYAPR10MB3607.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FblIX7LzB9/JD5W/cAlBNzWuVsRN8WF0omeALQ0TbO1CcUEgEplGhzPdYN1NoqO1qDvv3Dm+b+2MqBtctW1X9S0qOsVqvawMKPu/2ETUSCvjCHouLkJWL2+d3XlVXkPV5eZyGlODp1mdyLrngIvRM5wsNL6pdpXvUeez8/ze6VP8VuC2eMLxcz0Erw/Ipgv+K7CbgJmL2Zz901bEkbkTSFW/6+LKUVVB64Ja7qzJi7GxzpeyBwTlLne76ce0ma8AdLdvVXWyKn6aUYZJqks9fGWSJEE/L63UyA3fMrSvfszIDb14VW254ZfRELs+HwqhfywbfGBchTg8XbLsSGxbKh9jY9C1pA/1CG1HgviShDmKAre4S/Xk5loP6Q8wxSJvYIbnGVWzs4q/u4buADclic9qt+bgphBHi23gPk8j+7RWDN+mv88rIbwxwHQaix25HiOp5J9gpwJvQWz/x+W5DOfUmrCrCaDU12KT7b1qHlZ+CHDPjR+jLYKexwxUauKb/a234uklglhxPd0Hhn6VpqsfM+/scrr+amorOxOlsoOY0oeuUf/A1wFye8o94W6Tmr8efqTTnqVc40E0+0Y+Z620hCSZwmCfP8pQQ7osRggEVq3oRT28x1tcZkn25da8DK0KbjQtMMs9h6Hjf+6xJ+ya4XTne7x0j9OXdEmMyy8lWy+MQi81zEb9IbwDtPISSSYPwX2BonziLmC48pPi+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(396003)(39860400002)(376002)(36756003)(38100700002)(6916009)(83380400001)(38350700002)(16526019)(316002)(16576012)(186003)(52116002)(2906002)(2616005)(6486002)(31686004)(66556008)(44832011)(4326008)(8676002)(8936002)(53546011)(478600001)(31696002)(66476007)(26005)(86362001)(5660300002)(956004)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WlZKTFg5MDE0NnhsZ01SZmpoc1VwOGFWRjhZYnJ2SHZvbzFLenYzK2xybFRF?=
 =?utf-8?B?VXFrcWNRLzlpR1gwbGVtS0JrVkJGZ1hGYlZzT0l1N3FEaGpKbHlHK2dFNlFx?=
 =?utf-8?B?Uks2WWp4ZjdXNkJqaFM2bFc3c1Ixa3UvMzcyMnAwVkNvd1FwYk1GdjFvQVhI?=
 =?utf-8?B?TDhnV2ZNL0pydTU0WFkzZ1Jjc2xXeVlnS2dQUk5sWlNHVkUvTExIYm1qSmhW?=
 =?utf-8?B?SDJDaU5qTzBsQ1VmT2R5cXZ4bFo2dEN3V2JFZ3NEZ0YwUDdJNlRFZGRvODZ0?=
 =?utf-8?B?cVpUWVQyYWQ2MDNOQ2ptL3dmcmlXa1IwelptdG9OdDRFbDJsbHFOdzZaUk5S?=
 =?utf-8?B?ZVZGSmtubWF2WDV5Y05QZ1pnVjhkenUydEhpWTBWWWtQQlJBQXZRYzlBaDRT?=
 =?utf-8?B?b3ZlRkEzb3ppSkZCSFFCTU5rcGRHRG51S1BpY3VwOTRFd2tYM3pBdzVRdjlB?=
 =?utf-8?B?Z08ybXlQQTIxQ1A1MlZCODVsbTd0OHUvYzh5bVdDaERPSyswTEx4bmFVWWlU?=
 =?utf-8?B?WEtpelA0alF3bVZPUCtOdDIzZ0RCY2lkd1hQZFB1dE93dXd1LzA5U2NWMHox?=
 =?utf-8?B?VHY4RVNFeGpKNmZ3RWJtZVlmdDFJaXdDTE50SWZ3MUswcW10MHhHOFFKTTVG?=
 =?utf-8?B?UmxiWFYyRFlmbm00SVphVStHZjRnTmhRVHRmYWc3bTBybyt2bVdBTFAvamhs?=
 =?utf-8?B?Zmk1UHJNK1dpL2ZhUy9wNUQvdkF1SXo2RGpkb0luRTF6Qis1QTdLMVk4Qlhx?=
 =?utf-8?B?S2g4cVg1Y0puR25aVXRVa0szcEtJRHEvM1AzdW1kYVgzdXFjUTlEelNKVlJN?=
 =?utf-8?B?WDBJYzN1MlA1UUxoV0Zram9EUXM1SndmL21acmhnalBNNXdveWpvTmduTmNH?=
 =?utf-8?B?Q3ZzSGhLRUZjZ3NHcWk2QS9nZWpvQ1M5RytZMVdKTDNpRGwya2Z6ZFJwQ3NL?=
 =?utf-8?B?Yk9EcHUzU2ZNNkhvUFRsQ0FDeHRUcmZWRTRCMzJtcTlYTFNXRXRldUhVdzlv?=
 =?utf-8?B?Q01FNjUvWSsybzl6eHp4ZjdEL2JkNW1ORE5XVE02RDd5MitZTlcyUXJGQWxt?=
 =?utf-8?B?VGFtK3hHbDFpdkR0NU5rSkFTTmhBUnh6d3VUYU14N2dYOXV0WHBXZXJjcEVJ?=
 =?utf-8?B?Z01mWi9EUnR2eXVqL0JKdk9NUHdUeTRXMmhqK3pYcGhpQ2R1TCtIZDNtVUZx?=
 =?utf-8?B?OHJjTStQQVN3ZUNYenZvS2drYTh3UjRZcGVGQnFmZm9uKzAxQnBnZ3Q0U1Nn?=
 =?utf-8?B?MEw2ZXpHbXFPK05qbGtEVE5NRjk3a29Ya3RtN0ZHSXZBeXJkZTJDRXZGUnBk?=
 =?utf-8?B?ZGxMMndsYks3YklCS3hpL1oxNDZzNVNwa2cwT2JYTUswbmpWV1VnU1llc1ov?=
 =?utf-8?B?dzlFYTlHd29IZ3JJUEpiUjVCK0k5a3ZJOTlJSytocEdKUVdjTmFTanEwaEJn?=
 =?utf-8?B?aFByVy9CZFZjMG42dWtyS3FubmF4Y1llQS9LUHd1bEFqR1RvK1o4dEFXb1Vu?=
 =?utf-8?B?L21kV2dGQ1JEV0lTcjNLYmlUSzhVbkhmY3ZORkp3ZlZrTkt4ZFpEZXhDOCtT?=
 =?utf-8?B?dDlWMG9LQ1hJZHc2dWpPNkpRSFRkcXBuV0x5Vkw1N2oyL3NxWGNtMTdKY2t4?=
 =?utf-8?B?NGVoKzdwOExJL2tjYkMzWjQyK0ZFYlJzbElqSUZ2V3NzcnRVd2RzamtTZ3hB?=
 =?utf-8?B?ZGtveEZ3d2duNlE2YkE4emluUVBxZ3oxdmtzVHFKeDVjS2xOZXMzZWc1RGs3?=
 =?utf-8?Q?3S0iy+RT4j7eTvlRqKfJU9qf6bsTz1wmEqsu/jH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d52b1847-1c55-4a25-8c41-08d92071f823
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 18:13:31.8144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qorR6DqYlp7E5lKVq3NtbwuUEBHPuko1xMcXE9sLAy3dH8KfSOTRVpQRAF599MrAG0Q5GbE/KLFpi8NdM/rC83coqwsTy/3a05m9IbCmtsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3607
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260123
X-Proofpoint-GUID: J6tISD73Ea7Tt1zui8z8ONt4N0nVvyYk
X-Proofpoint-ORIG-GUID: J6tISD73Ea7Tt1zui8z8ONt4N0nVvyYk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260124
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/25/21 1:52 PM, Darrick J. Wong wrote:
> On Tue, May 25, 2021 at 12:55:03PM -0700, Allison Henderson wrote:
>> This ASSERT checks for the state value of RM_SHRINK in the set path.
>> Which would be invalid, and should never happen.  This change is being
>> set aside from the rest of the set for further discussion
>>
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 32d451b..7294a2e 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -612,7 +612,6 @@ xfs_attr_set_iter(
>>   		error = xfs_attr_node_addname_clear_incomplete(dac);
>>   		break;
>>   	default:
>> -		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
> 
> ASSERT(0); ?
> 
> AFAICT the switch statement covers all the states mentioned in the state
> diagram for attr setting, so in theory it should be impossible to land
> in this state, correct?
Yes, that's correct, so ASSERT(0); should work too.  I am fine with this 
change if others are.

Allison

> 
> --D
> 
>>   		break;
>>   	}
>>   out:
>> -- 
>> 2.7.4
>>
