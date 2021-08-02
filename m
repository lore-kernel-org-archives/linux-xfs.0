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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C94F9C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F6F6018A
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhHBIdZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 04:33:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37376 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229595AbhHBIdZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 04:33:25 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1728QoVs010193;
        Mon, 2 Aug 2021 08:33:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8VvhPevA4LxbCjiPp0w2VUGQ4uW5rtOcegvCTRGNz2M=;
 b=GXTXdKq7q4YSnc9z2N01B03N3stUZ/NS+BBeZJOAHwRAD0WXh4VFoUw8BmOUJjx4OeOM
 GeT9APPJ/hwOvycZDqXbWTMpC4dfh0eGDAiHFXxODej+xZxTCEIztozaOP2adINYAPVP
 j+9xydR8fedRMMsAmARhvT7nyoUgTD4FQczXW33Mtcr+42cuSaZcEIVM2W2VKy8NAdRo
 93hZGOl/feqmuJCcDm4MfHf9Y39lxi+S7APAKUFIjX7LD0VRK7+F8evlhhnZZ6K4l8vt
 PkYLEUifdbkVrTzkLdEtcwT3fSBRDSEyvRJigeL8U+QTfmRcIkvlVPpwQCH5OCzQW0Rx 4Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8VvhPevA4LxbCjiPp0w2VUGQ4uW5rtOcegvCTRGNz2M=;
 b=Texewd5slDuWIjmTTm/W/uS3ELzOmf92r1oEORRemBHV6Y5i7MaJr96KYI8j9INSkn4f
 u0XusH3Q0iW79R3d0dLCE6QbSPaeJb5INVoWtkZMhaGBgKSo1sEpUqE+8XMaKrtQA5w4
 7vV2cTZZbJJOSO2Y/fPc5TiqFDye59wvF32YPxSGY9lCTcrwXAy4Ev8Zk2V3zbMVB0jX
 5iDSj4430FoFIrpNLerHzT1H0Rm9bI5Hfb03jUEkwpBdIi/i+QGi2a0hKA8VqAtFHgjN
 ZPcHmTsGd4SZKWOtT64zmvhptq6nzV/IXTM2mq75W7jpT76VJYgjr5cutZzJYleCmjEx lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6cntg2xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:33:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1728PqGS150004;
        Mon, 2 Aug 2021 08:33:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3020.oracle.com with ESMTP id 3a4xb4ga6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:33:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGR0kJjwK2D2VUXCXMHE2q5/07ydAMc3hWzO07/BAYlMiapbuOqecgG4zEBBv2563KJzLM+fKODwoAEI8f10PTlfOEOFf3/8m25nYCWspg1JmhxaF0+HMdXRGHLpP8mlXcsyTRFpTaz7ecpp7ScZU/09VTsR4LilgZC12RjqgBAh70gzuqxr/Z1UUcvwO2BzbctNP7Fu/OBCKY0+Iz+mo1JzoxkrH40ynWTNPruPKI7LtuTdNnwzB/A9PExOZWxGrvlBJ0CE5RB5EkGTS+ilw4NSAHcTnCxxb7jp6GxfQ7kGQQyW0YbG4x6KLQRbrTAnqYNupYwt+8PEMGi7twfJWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VvhPevA4LxbCjiPp0w2VUGQ4uW5rtOcegvCTRGNz2M=;
 b=TRc+txjdSC4n6HH79wFUkR8nbx7xlz+uEt8Nmlgh5xvTeRPECy/Dkr64mUobmOZ6ratYnbR4aUXnGyf6X+JctNbrHoV75CmGxqpR2CuGgUAerUTaMa07R0IMmef8njiawR4L7DTF0y7e8Lr0x6J22hoBE6rxFG+/a3iKvWuc0wn5rRdLQ/LgZq29oN7ATZ6fBfBK4klfIKXSKM7GN6oO1SvJ9O8x9WrrAqD6+L2MDgayVy2CcpX2BJn8sYgEEJ7QfGiRwfeGZs/4s4+JCwBRDbgL7ZTydFLJL0wT4zPHcI1RyO5T1nywA9VNf+O2g78CF5bI/blX0WprIPw/Z3wTNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8VvhPevA4LxbCjiPp0w2VUGQ4uW5rtOcegvCTRGNz2M=;
 b=IBuNGAyyKqSa/ZDwMJgHslpvTxla4gPFpzDy7SaCamrAY9xqUQ4RLol/h1LvCwHzM6ZP3yELmHjz2gBWyoW5wb7YA+wtf1RHkYCnZQCpWTZlXAjSphnSOjOMcTYhRGglGJQiVgM8TQF56n1veW+1QbI7VIyfffEuEYC9r/pViNU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5485.namprd10.prod.outlook.com (2603:10b6:a03:3ab::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 08:33:12 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 08:33:12 +0000
Subject: Re: [PATCH v22 09/16] xfs: Implement attr logging and replay
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-10-allison.henderson@oracle.com>
 <87v94s800q.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <13cf7e0f-d9c4-c96d-c0e6-c61bd976c75a@oracle.com>
Date:   Mon, 2 Aug 2021 01:33:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <87v94s800q.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0043.namprd07.prod.outlook.com
 (2603:10b6:510:e::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by PH0PR07CA0043.namprd07.prod.outlook.com (2603:10b6:510:e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Mon, 2 Aug 2021 08:33:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61468560-c782-402a-e2b4-08d955902a30
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5485:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB54855818DC58131D4E378A5A95EF9@SJ0PR10MB5485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:232;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pO7dDIdc/UWWZCZkx3IsV65aXd6pSWEPQDg6ksAizIF2tcNYblSn7WXMuxN4at9Lqh6lroR+/ecp4g4bqccWsoeRp8oSmJeWn7QlF8OM/W5NY551pJrL7lUmLy3v653aUxDv798tZKr85Vciitf5iwHOfVPUJl1NzvgYFUf6vg49jz2qFJGOJRUNbC92brX+K9JD2CSyeOLK1cNDCdekwfvVfAyPy8skG75DVo1rHfQ1E/Fc051Vl8Im6jP9nShYABQKjFj4KBIuSCdZyrhmP3xWONt7Mv98EG0ObBxBUB9w1SCLVEFKS8Th8KAfuVhCJPV/4wdk1wrfretolBvRrgIIpJElqll9UhThk7LZkSQDrrtwifqw7RklAhASxU1NsiK/Zp2Dvgp7njG8LtIGSsmAM3Ye6uW8rzJ+Mzv+4c77/CuQ/QvtJ7Z9M2BSQHzu4O50btgfiDp5jPiA2alqwU6PTxrRoCxH/X4SUTlUk0zidt/1wYtcQ581vN0RmFk+cYuJAu+7hrlJyWv4jfqja0B31Pz+qqbPh15Ts7lFp7WkuHsVz6Z6qpWnEY5LSItjy/HFbafI0pm5cMGhYXNuNDl+o60bUTuOiGclqKjn7TTURJz+9zkra2w9BAvjj3PbLn39S443TKWKb1E8BMvu4XEHh8clxcdp02VqrcZREu2exOyCKlTa+mRTcFVAmuN8N8/J846uGkbM99GkpBkMeQZRsSqP4SPyjh30Y77LkFpIYKEUnWvW3/ytGJ2epi03T8F+dbKxRXydrXUZUgwHDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(39860400002)(376002)(136003)(44832011)(4326008)(8936002)(36756003)(6486002)(86362001)(66556008)(38100700002)(38350700002)(66476007)(8676002)(316002)(2906002)(30864003)(16576012)(31696002)(66946007)(31686004)(53546011)(956004)(2616005)(26005)(5660300002)(186003)(52116002)(6916009)(478600001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U04ybFB0ZTdMQkIzUTk2bDY0SjhvWDJOdmZaL3NBSkIzZFpYU0xvM2hvdmEr?=
 =?utf-8?B?NzBRR3dldWJwTzFYb2tWMFN3VUgzbkhUYjl5M1lTT2ozTWF2Z0tlaEpFa3V2?=
 =?utf-8?B?YkN0YzlUUXZuWmhJazNBdVlJQVI3NHBjcWgwaitvNCtqU2ZLUHg3Y1B4ZVFy?=
 =?utf-8?B?WEdZM081T3Q0WnQ4dEJnMTdzbStRNGtCc2VkSDJiVi9hLzYzYTduMjRLN1FV?=
 =?utf-8?B?d2lmNUExR3Q4ZG40ZlluRm5kL1hHWTBTczMwVmhwVm5mTWt1NkhVaXdKbjNL?=
 =?utf-8?B?Q1k3VmN1dnRwWUZGNkYxYnlxeElmb05TV3U3bjdNL2FWT0NLRzJYZEtaTmsy?=
 =?utf-8?B?aUM3ZWVyWGJzRmdiaDZlQUhMTFZ2Ly9UT3RBUnk3OFFBamtBeUs4UFRlbUZL?=
 =?utf-8?B?RE1WRzZ1dGVxcFNvNTJyRm00amtjcDVEeHVuZ3d0M2lKUFlZOVNLZ3lzUFBE?=
 =?utf-8?B?UXprQXcyK29ibFY3ZTJxL29rY2loTGFJSUNXdnZuQnpqamZFbzMzVHIrRGF1?=
 =?utf-8?B?SW1paWZOTUlKQ1ZxTnlGVE5TM2VDc1AzRGQ4WWVnd3NYa1hyWHRZRklnVk4y?=
 =?utf-8?B?MkRXeEppZVR0dWVjR29ObTc5MDkwMXhNSVVnQi9TTFBSVTAzd25EazFWa0hI?=
 =?utf-8?B?aXhLcnBRaGM3WnM3RUVpZ054eFRNMzRjZEh1Z1g3RExCd2ErTG02bWdJc3VC?=
 =?utf-8?B?bFR0aXdRaEFycjJMdHFKQWdTb3RwWHVGU2tKakR5YkNVZUhDYTdJdkwzVmJq?=
 =?utf-8?B?WmtyQXdrT29Obml4aFdhc1hXcHE0WXNsanJJVjVxaW1FUnJkenM2VFk0UDkw?=
 =?utf-8?B?cFlqeVRyWi92QlNUTW1sKzZyNWxUd0NGWk1aU1hGKytKcW5EWTJUTi9wNEF5?=
 =?utf-8?B?OUJEZWUzWU1IelBqOGE2OXZxREkwWmFRYkhLeFYrZjRwb09zSDFSOVY2ZGdw?=
 =?utf-8?B?T1EvTUNFUDUrRm90YVBiTmV1UEdBNVQ1bHBVdnpPVU5wdC8wN0VRZzN0WG5x?=
 =?utf-8?B?ZjRTcjRYTWw3OUkvUGlhNWgyREVQem91WHRJU01xOGZROUpwcmljOXdJcHI2?=
 =?utf-8?B?ZUNKZnRwdjlJUjdZK3pRYURCK3laYlFDbUtEam9WMFcwMnBRQUhjMENvL1Ni?=
 =?utf-8?B?N0VWamU3UEs5OEIwMVFCVUtlejViZ1FNbzhpMGJFSW5JN3BMWjllZlQvTFVE?=
 =?utf-8?B?ZjJCRmgrS1RWcHF5Nit2Y254ZHA5Zi8yRC9BNGxCVk5DZFBHWWVvVDlOc29D?=
 =?utf-8?B?ZDJaYlVHUDlLNlR6eUVua2l6K3ZRaFBTWXRWVThpZDRUbU9BWXRCd29UTU0x?=
 =?utf-8?B?MnlxQi9uVENjRTEzcUJpeFBvNmJTZUViUW0rUmVSV2ZnV3F6NlVQQ3hyak9M?=
 =?utf-8?B?VUxXMURWdXRzZ1BYQlFjZmdaems2MmxzVXVIQ2h5dFdCYU5EY1Nic1lyMm1J?=
 =?utf-8?B?Sm9ySjlMWWpEZ1ViTzk2ak5oY0M0NXNZdWJFdDgwVDErdlFlMU13U1hidUpr?=
 =?utf-8?B?VnV5NmNiTlhFZ0JGUDNZcDlzZU1Td3MyK3dubUdBMVZ3Nkorb1lXSWdDdVlO?=
 =?utf-8?B?T0lUT1pTWGVJTjlNZkZjMU50K0RvTmJjcURoTjBaUnVDNjU1TTNja0RuM0RN?=
 =?utf-8?B?elZzWmsrc0JrWmNic1lKLzNNTys5SDF3WU9lZFE5WmVEZ2VNZ3VDc1lITXRR?=
 =?utf-8?B?V3FKc1JWbXlicmdsMHN4eXo5VVRJMGliYStNMFp3MmJnbzJsMkhWZjkrcWRD?=
 =?utf-8?Q?ptShm3zKaZysmkfDXPEmxJiW2uRGiC+XKG5RN8V?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61468560-c782-402a-e2b4-08d955902a30
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 08:33:12.2518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xdx6elayaDFqZUYoNg1VqsJ2FbenK5zfgmaqCch679M4D4JosbnBMpyuGECOmhcv5lCmXwy6Q10MiY2aiZgxwl5kOUoD3AiVZVhH6lKTNMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10063 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108020059
X-Proofpoint-ORIG-GUID: yuSzblTYsLXAczGBk0As1vmP9ATt1LvZ
X-Proofpoint-GUID: yuSzblTYsLXAczGBk0As1vmP9ATt1LvZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/30/21 5:21 AM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> This patch adds the needed routines to create, log and recover logged
>> extended attribute intents.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_defer.c  |   1 +
>>   fs/xfs/libxfs/xfs_defer.h  |   1 +
>>   fs/xfs/libxfs/xfs_format.h |  10 +-
>>   fs/xfs/xfs_attr_item.c     | 377 +++++++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 388 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index eff4a12..e9caff7 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -178,6 +178,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>>   	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>>   };
>>   
>>   static void
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index 0ed9dfa..72a5789 100644
>> --- a/fs/xfs/libxfs/xfs_defer.h
>> +++ b/fs/xfs/libxfs/xfs_defer.h
>> @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
>>   	XFS_DEFER_OPS_TYPE_RMAP,
>>   	XFS_DEFER_OPS_TYPE_FREE,
>>   	XFS_DEFER_OPS_TYPE_AGFL_FREE,
>> +	XFS_DEFER_OPS_TYPE_ATTR,
>>   	XFS_DEFER_OPS_TYPE_MAX,
>>   };
>>   
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index 3a4da111..93c1263 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -485,7 +485,9 @@ xfs_sb_has_incompat_feature(
>>   	return (sbp->sb_features_incompat & feature) != 0;
>>   }
>>   
>> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_DELATTR   (1 << 0)	/* Delayed Attributes */
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
>> +	(XFS_SB_FEAT_INCOMPAT_LOG_DELATTR)
>>   #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>>   static inline bool
>>   xfs_sb_has_incompat_log_feature(
>> @@ -590,6 +592,12 @@ static inline bool xfs_sb_version_hasbigtime(struct xfs_sb *sbp)
>>   		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME);
>>   }
>>   
>> +static inline bool xfs_sb_version_hasdelattr(struct xfs_sb *sbp)
>> +{
>> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
>> +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);
>> +}
>> +
>>   /*
>>    * Inode btree block counter.  We record the number of inobt and finobt blocks
>>    * in the AGI header so that we can skip the finobt walk at mount time when
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index a810c2a..44c44d9 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -275,6 +275,182 @@ xfs_attrd_item_release(
>>   	xfs_attrd_item_free(attrdp);
>>   }
>>   
>> +/*
>> + * Performs one step of an attribute update intent and marks the attrd item
>> + * dirty..  An attr operation may be a set or a remove.  Note that the
>> + * transaction is marked dirty regardless of whether the operation succeeds or
>> + * fails to support the ATTRI/ATTRD lifecycle rules.
>> + */
>> +STATIC int
>> +xfs_trans_attr_finish_update(
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_attrd_log_item	*attrdp,
>> +	struct xfs_buf			**leaf_bp,
>> +	uint32_t			op_flags)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	unsigned int			op = op_flags &
>> +					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
>> +	int				error;
>> +
>> +	error = xfs_qm_dqattach_locked(args->dp, 0);
>> +	if (error)
>> +		return error;
>> +
>> +	switch (op) {
>> +	case XFS_ATTR_OP_FLAGS_SET:
>> +		args->op_flags |= XFS_DA_OP_ADDNAME;
> 
> One nit: XFS_DA_OP_ADDNAME was already set by xfs_attr_set().
> 
> I don't see any other issues apart from the above nit and those pointed out by
> Darrick.
> 
Ok, will clean out.  Thanks for the reviews!
Allison

>> +		error = xfs_attr_set_iter(dac, leaf_bp);
>> +		break;
>> +	case XFS_ATTR_OP_FLAGS_REMOVE:
>> +		ASSERT(XFS_IFORK_Q(args->dp));
>> +		error = xfs_attr_remove_iter(dac);
>> +		break;
>> +	default:
>> +		error = -EFSCORRUPTED;
>> +		break;
>> +	}
>> +
>> +	/*
>> +	 * Mark the transaction dirty, even on error. This ensures the
>> +	 * transaction is aborted, which:
>> +	 *
>> +	 * 1.) releases the ATTRI and frees the ATTRD
>> +	 * 2.) shuts down the filesystem
>> +	 */
>> +	args->trans->t_flags |= XFS_TRANS_DIRTY;
>> +
>> +	/*
>> +	 * attr intent/done items are null when delayed attributes are disabled
>> +	 */
>> +	if (attrdp)
>> +		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
>> +
>> +	return error;
>> +}
>> +
>> +/* Log an attr to the intent item. */
>> +STATIC void
>> +xfs_attr_log_item(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_attri_log_item	*attrip,
>> +	struct xfs_attr_item		*attr)
>> +{
>> +	struct xfs_attri_log_format	*attrp;
>> +
>> +	tp->t_flags |= XFS_TRANS_DIRTY;
>> +	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
>> +
>> +	/*
>> +	 * At this point the xfs_attr_item has been constructed, and we've
>> +	 * created the log intent. Fill in the attri log item and log format
>> +	 * structure with fields from this xfs_attr_item
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
>> +	attrp->alfi_op_flags = attr->xattri_op_flags;
>> +	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
>> +	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
>> +	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
>> +
>> +	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
>> +	attrip->attri_value = attr->xattri_dac.da_args->value;
>> +	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
>> +	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
>> +}
>> +
>> +/* Get an ATTRI. */
>> +static struct xfs_log_item *
>> +xfs_attr_create_intent(
>> +	struct xfs_trans		*tp,
>> +	struct list_head		*items,
>> +	unsigned int			count,
>> +	bool				sort)
>> +{
>> +	struct xfs_mount		*mp = tp->t_mountp;
>> +	struct xfs_attri_log_item	*attrip;
>> +	struct xfs_attr_item		*attr;
>> +
>> +	ASSERT(count == 1);
>> +
>> +	if (!xfs_hasdelattr(mp))
>> +		return NULL;
>> +
>> +	attrip = xfs_attri_init(mp, 0);
>> +	if (attrip == NULL)
>> +		return NULL;
>> +
>> +	xfs_trans_add_item(tp, &attrip->attri_item);
>> +	list_for_each_entry(attr, items, xattri_list)
>> +		xfs_attr_log_item(tp, attrip, attr);
>> +	return &attrip->attri_item;
>> +}
>> +
>> +/* Process an attr. */
>> +STATIC int
>> +xfs_attr_finish_item(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_log_item		*done,
>> +	struct list_head		*item,
>> +	struct xfs_btree_cur		**state)
>> +{
>> +	struct xfs_attr_item		*attr;
>> +	struct xfs_attrd_log_item	*done_item = NULL;
>> +	int				error;
>> +	struct xfs_delattr_context	*dac;
>> +
>> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
>> +	dac = &attr->xattri_dac;
>> +	if (done)
>> +		done_item = ATTRD_ITEM(done);
>> +
>> +	/*
>> +	 * Corner case that can happen during a recovery.  Because the first
>> +	 * iteration of a multi part delay op happens in xfs_attri_item_recover
>> +	 * to maintain the order of the log replay items.  But the new
>> +	 * transactions do not automatically rejoin during a recovery as they do
>> +	 * in a standard delay op, so we need to catch this here and rejoin the
>> +	 * leaf to the new transaction
>> +	 */
>> +	if (attr->xattri_dac.leaf_bp &&
>> +	    attr->xattri_dac.leaf_bp->b_transp != tp) {
>> +		xfs_trans_bjoin(tp, attr->xattri_dac.leaf_bp);
>> +		xfs_trans_bhold(tp, attr->xattri_dac.leaf_bp);
>> +	}
>> +
>> +	/*
>> +	 * Always reset trans after EAGAIN cycle
>> +	 * since the transaction is new
>> +	 */
>> +	dac->da_args->trans = tp;
>> +
>> +	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
>> +					     attr->xattri_op_flags);
>> +	if (error != -EAGAIN)
>> +		kmem_free(attr);
>> +
>> +	return error;
>> +}
>> +
>> +/* Abort all pending ATTRs. */
>> +STATIC void
>> +xfs_attr_abort_intent(
>> +	struct xfs_log_item		*intent)
>> +{
>> +	xfs_attri_release(ATTRI_ITEM(intent));
>> +}
>> +
>> +/* Cancel an attr */
>> +STATIC void
>> +xfs_attr_cancel_item(
>> +	struct list_head		*item)
>> +{
>> +	struct xfs_attr_item		*attr;
>> +
>> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
>> +	kmem_free(attr);
>> +}
>> +
>>   STATIC xfs_lsn_t
>>   xfs_attri_item_committed(
>>   	struct xfs_log_item		*lip,
>> @@ -306,6 +482,30 @@ xfs_attri_item_match(
>>   	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
>>   }
>>   
>> +/*
>> + * This routine is called to allocate an "attr free done" log item.
>> + */
>> +static struct xfs_attrd_log_item *
>> +xfs_trans_get_attrd(struct xfs_trans		*tp,
>> +		  struct xfs_attri_log_item	*attrip)
>> +{
>> +	struct xfs_attrd_log_item		*attrdp;
>> +	uint					size;
>> +
>> +	ASSERT(tp != NULL);
>> +
>> +	size = sizeof(struct xfs_attrd_log_item);
>> +	attrdp = kmem_zalloc(size, 0);
>> +
>> +	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
>> +			  &xfs_attrd_item_ops);
>> +	attrdp->attrd_attrip = attrip;
>> +	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
>> +
>> +	xfs_trans_add_item(tp, &attrdp->attrd_item);
>> +	return attrdp;
>> +}
>> +
>>   static const struct xfs_item_ops xfs_attrd_item_ops = {
>>   	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>>   	.iop_size	= xfs_attrd_item_size,
>> @@ -313,6 +513,29 @@ static const struct xfs_item_ops xfs_attrd_item_ops = {
>>   	.iop_release    = xfs_attrd_item_release,
>>   };
>>   
>> +
>> +/* Get an ATTRD so we can process all the attrs. */
>> +static struct xfs_log_item *
>> +xfs_attr_create_done(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_log_item		*intent,
>> +	unsigned int			count)
>> +{
>> +	if (!intent)
>> +		return NULL;
>> +
>> +	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
>> +}
>> +
>> +const struct xfs_defer_op_type xfs_attr_defer_type = {
>> +	.max_items	= 1,
>> +	.create_intent	= xfs_attr_create_intent,
>> +	.abort_intent	= xfs_attr_abort_intent,
>> +	.create_done	= xfs_attr_create_done,
>> +	.finish_item	= xfs_attr_finish_item,
>> +	.cancel_item	= xfs_attr_cancel_item,
>> +};
>> +
>>   /* Is this recovered ATTRI ok? */
>>   static inline bool
>>   xfs_attri_validate(
>> @@ -340,13 +563,167 @@ xfs_attri_validate(
>>   	return xfs_hasdelattr(mp);
>>   }
>>   
>> +/*
>> + * Process an attr intent item that was recovered from the log.  We need to
>> + * delete the attr that it describes.
>> + */
>> +STATIC int
>> +xfs_attri_item_recover(
>> +	struct xfs_log_item		*lip,
>> +	struct list_head		*capture_list)
>> +{
>> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>> +	struct xfs_attr_item		*attr;
>> +	struct xfs_mount		*mp = lip->li_mountp;
>> +	struct xfs_inode		*ip;
>> +	struct xfs_da_args		*args;
>> +	struct xfs_trans		*tp;
>> +	struct xfs_trans_res		tres;
>> +	struct xfs_attri_log_format	*attrp;
>> +	int				error, ret = 0;
>> +	int				total;
>> +	int				local;
>> +	struct xfs_attrd_log_item	*done_item = NULL;
>> +
>> +	/*
>> +	 * First check the validity of the attr described by the ATTRI.  If any
>> +	 * are bad, then assume that all are bad and just toss the ATTRI.
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	if (!xfs_attri_validate(mp, attrip))
>> +		return -EFSCORRUPTED;
>> +
>> +	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
>> +	if (error)
>> +		return error;
>> +
>> +	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
>> +			   sizeof(struct xfs_da_args), KM_NOFS);
>> +	args = (struct xfs_da_args *)((char *)attr +
>> +		   sizeof(struct xfs_attr_item));
>> +
>> +	attr->xattri_dac.da_args = args;
>> +	attr->xattri_op_flags = attrp->alfi_op_flags;
>> +
>> +	args->dp = ip;
>> +	args->geo = mp->m_attr_geo;
>> +	args->op_flags = attrp->alfi_op_flags;
>> +	args->whichfork = XFS_ATTR_FORK;
>> +	args->name = attrip->attri_name;
>> +	args->namelen = attrp->alfi_name_len;
>> +	args->hashval = xfs_da_hashname(args->name, args->namelen);
>> +	args->attr_filter = attrp->alfi_attr_flags;
>> +
>> +	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
>> +		args->value = attrip->attri_value;
>> +		args->valuelen = attrp->alfi_value_len;
>> +		args->total = xfs_attr_calc_size(args, &local);
>> +
>> +		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
>> +				 M_RES(mp)->tr_attrsetrt.tr_logres *
>> +					args->total;
>> +		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>> +		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>> +		total = args->total;
>> +	} else {
>> +		tres = M_RES(mp)->tr_attrrm;
>> +		total = XFS_ATTRRM_SPACE_RES(mp);
>> +	}
>> +	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
>> +	if (error)
>> +		goto out;
>> +
>> +	args->trans = tp;
>> +	done_item = xfs_trans_get_attrd(tp, attrip);
>> +
>> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(tp, ip, 0);
>> +
>> +	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
>> +					   &attr->xattri_dac.leaf_bp,
>> +					   attrp->alfi_op_flags);
>> +	if (ret == -EAGAIN) {
>> +		/* There's more work to do, so add it to this transaction */
>> +		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
>> +	} else
>> +		error = ret;
>> +
>> +	if (error) {
>> +		xfs_trans_cancel(tp);
>> +		goto out_unlock;
>> +	}
>> +
>> +	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
>> +
>> +out_unlock:
>> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +	xfs_irele(ip);
>> +out:
>> +	if (ret != -EAGAIN)
>> +		kmem_free(attr);
>> +	return error;
>> +}
>> +
>> +/* Re-log an intent item to push the log tail forward. */
>> +static struct xfs_log_item *
>> +xfs_attri_item_relog(
>> +	struct xfs_log_item		*intent,
>> +	struct xfs_trans		*tp)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp;
>> +	struct xfs_attri_log_item	*old_attrip;
>> +	struct xfs_attri_log_item	*new_attrip;
>> +	struct xfs_attri_log_format	*new_attrp;
>> +	struct xfs_attri_log_format	*old_attrp;
>> +	int				buffer_size;
>> +
>> +	old_attrip = ATTRI_ITEM(intent);
>> +	old_attrp = &old_attrip->attri_format;
>> +	buffer_size = old_attrp->alfi_value_len + old_attrp->alfi_name_len;
>> +
>> +	tp->t_flags |= XFS_TRANS_DIRTY;
>> +	attrdp = xfs_trans_get_attrd(tp, old_attrip);
>> +	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
>> +
>> +	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
>> +	new_attrp = &new_attrip->attri_format;
>> +
>> +	new_attrp->alfi_ino = old_attrp->alfi_ino;
>> +	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
>> +	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
>> +	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
>> +	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
>> +
>> +	new_attrip->attri_name_len = old_attrip->attri_name_len;
>> +	new_attrip->attri_name = ((char *)new_attrip) +
>> +				 sizeof(struct xfs_attri_log_item);
>> +	memcpy(new_attrip->attri_name, old_attrip->attri_name,
>> +		new_attrip->attri_name_len);
>> +
>> +	new_attrip->attri_value_len = old_attrip->attri_value_len;
>> +	if (new_attrip->attri_value_len > 0) {
>> +		new_attrip->attri_value = new_attrip->attri_name +
>> +					  new_attrip->attri_name_len;
>> +
>> +		memcpy(new_attrip->attri_value, old_attrip->attri_value,
>> +		       new_attrip->attri_value_len);
>> +	}
>> +
>> +	xfs_trans_add_item(tp, &new_attrip->attri_item);
>> +	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
>> +
>> +	return &new_attrip->attri_item;
>> +}
>> +
>>   static const struct xfs_item_ops xfs_attri_item_ops = {
>>   	.iop_size	= xfs_attri_item_size,
>>   	.iop_format	= xfs_attri_item_format,
>>   	.iop_unpin	= xfs_attri_item_unpin,
>>   	.iop_committed	= xfs_attri_item_committed,
>>   	.iop_release    = xfs_attri_item_release,
>> +	.iop_recover	= xfs_attri_item_recover,
>>   	.iop_match	= xfs_attri_item_match,
>> +	.iop_relog	= xfs_attri_item_relog,
>>   };
> 
> 
