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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B42C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C74C61057
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 08:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbhHBIdj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 04:33:39 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58198 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232742AbhHBIdi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 04:33:38 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1728QGaL019278;
        Mon, 2 Aug 2021 08:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=fLs8xfE/Z7prguFFrUFdDEh71iTQGBFg5/NW7CMBvWI=;
 b=ZFfVh2fpHTzoebFgTIHtcab5RS5CU/LayYty9VpMSDjk+PURX/CX2nqyiZG+svJ2Z2lb
 XsRUXFnEwYYfJk6FLWDHBLSBK2QhTDE2t/gScXDPhf+9E5ulPbc6HmBJIogGmrJOvUuM
 hrywkf0CcNsqUunbCzyd773d+hFVDN77mNolD82JtUoOxX5zfB1RwsGwfJafqXR3bDFi
 SoFPsMpfyMqYXVIEijFp6n1YgxWGsgSPFqHdlFF87IyL/IimLogPLVplX3iXGp8WJxRp
 ZxOmz3mBWYLRmwmvWdAnJNNHR261CrfB3OIBpRqIxRl4PfHge6yIYq8mVLWcvCqFqdij tw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=fLs8xfE/Z7prguFFrUFdDEh71iTQGBFg5/NW7CMBvWI=;
 b=ZJlnJTixbQx339QHVaYRvXKWOBohgGnq6OD7FuP0vcSca+MTDxKo4HgQ0L46U+gMO25R
 iqnFMmgJ3PWISeCpSSjWmwKfUJvs+0MZ8ptvyQIMt1+rQjum6rUaoXgsTyanhwox7FTA
 a3jMLHZTU0XGh4QlEzBx4x/Bu0JkkeIwSdtC1b3IVOqT8Xm2D60h/3Fubl8my6RpWUUJ
 EuMLmfC2LEDwPthYO/ddsxAI5rWybzDXfbvzMM39k0Db7ut7/ZTFzQE98SKAW0dLOek5
 pONjG9SPz8OzZ5U0EucbAt0Hom4kDSkZmMal4Z8cFzkTOM71KgEPNYNaAjJMETA6Dtxy NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a4y2sag8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:33:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1728PpEn149807;
        Mon, 2 Aug 2021 08:33:28 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3020.oracle.com with ESMTP id 3a4xb4gafw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 08:33:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkKnsf4/O2MqDuq49pXXXTHFWXACrswZZ1vK8exDEC5XkSnMitHk9Zp7AJAm0Tyc71NNEi8I0SH383HT4rYR9rLTd0S0RmUYCg0FlYH0YOBuKAE1S5KCfRROnT2Ropc7Zl1G4Vq8cxaoh4G57QSSLtaLJVl4nDyNlwsGl+qgRNKQk4LEj341XpYQSyZMpzpZAcamm4t9K01uUYUCPhAqFt4ufytfeOie/BWCg/JoCsco3xO2tisadXZu/X3dOKaFm9snFxyDBRJFInBoT7vfwjpfQDmU5Qa6tI9Ve7WVnY49pa27SickRVaJqDzLTqgdtSpnoC6aCHWkGa+z0+Y0hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLs8xfE/Z7prguFFrUFdDEh71iTQGBFg5/NW7CMBvWI=;
 b=ljSb6Cjv2aEDeEzudeZQ+14vdtwElvlw3kT8t6qwo1L1aUZfAWpM8e6UmarfMkhFnxcoMFkhK8UW7Ve/NKHexnygam4/Gpk3ulMXDlCdIeepdjLp+A6NNQmGpnyIdSLJCGB0AYwkWksf9MmOyrpwXgAPiovzQ1CKEPp1FF+TWTgM90H6OZMOQsN1cp+h5DjG5WZl+eJSEy3KunmcTp3rZsS3elpfQAhFXK5xWV4DI/qUU7uSwJ/UKXnaBLTRczvoTS/Dp5/d883B25aZlwpJSmC01KyEQkXnzuQYgw4aj7hbbk0AxBpLBGvwCB7roonqhfqlNxe1FJNvzgDCAqsx4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLs8xfE/Z7prguFFrUFdDEh71iTQGBFg5/NW7CMBvWI=;
 b=ItSQkjM5/9ryzvdxuPS4VMLdW/VDRA1K9WjDyaZfu7j9u+G2AMn/brOCV4ZaqS5iQPsDzxAqrsdc4YcMNp8egtgZMDsVnJ1Pjk1arUbW2as9JtuPSFa3EfUBrCmJQPKIn2kItcw7TBLa6MzufRdIia4PrYDYMyvyM1jaPuSGPkg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5485.namprd10.prod.outlook.com (2603:10b6:a03:3ab::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 08:33:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 08:33:26 +0000
Subject: Re: [PATCH v22 12/16] xfs: Remove unused xfs_attr_*_args
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-13-allison.henderson@oracle.com>
 <8735rso7b6.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <af4b9133-4021-0c17-f9ce-d02a84ca9742@oracle.com>
Date:   Mon, 2 Aug 2021 01:33:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <8735rso7b6.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0031.namprd07.prod.outlook.com
 (2603:10b6:510:e::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by PH0PR07CA0031.namprd07.prod.outlook.com (2603:10b6:510:e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Mon, 2 Aug 2021 08:33:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b013d42-1c33-4a7e-46cd-08d95590325f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5485:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB54856413C5ADE4EB63D059DC95EF9@SJ0PR10MB5485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SaLWOp9HNXUMNQZdMZ7AfpmgbvIXutbxOIfM4ry0NzjFJivq6XBDSua231HbgI5bkptAJ5WVPU730fO/s0rs9vq67ldm5wSnEWjoxd8ghw/ZM/rRufU0AJ92GbKCC8/0lyawMlgzubkkHLqWVu+5U0Wgnjek2ukDyysg3Stj9/bhOMn6NxitieyHDuItLm9h1JIdsNweDALEs2hnKYav7HtnG+bT2wW1B9dgmVVJgFXCjY33kfkHmWBaAMl6IQ8Q/gq/c9PGc6GLzMpMRw/+bwO9VumSQxVghMegyVlCrusaVQm42Q5KtyjkFexbLvO7pIqCQEQyxweV/XTKx+2HtrxReXuOG8rL1Wb01XkyGhkaUgurd0Sd4HpBW6Q1lhPN7dOXRCLNffRlD0FyPUGBx9F+sbME1q06U10ZcOna6pGKT9luyDXwFfC13uLOY6TJs/T8fryPCuKrp/0sh2DtpYgsGIzlmeZAt7S3cavFFD7wkpdipHgPV7eLYZmiV8f0OifxwSZ9C5duZdG11AuLYXS+jna1X7CG0usVR7mgbnfJuG6TqJ/5Am3l0dQ5SFFtD3A4toogNaAGlFEY930WzT1awysGpL2OanGffQmDMXrGMCk3KddBDtGNN/998OgYhJQAedQb/crySgRHIoas6XCCPPtAC7EpdtHJwIi6CTIb6+3RxpHUR5/UffATty+3YiBu4gCpszyBmW1rOwvi8x3jL0Xs86hHXqHtpNdtzL53mXW3+MkU4frCfAigG48KI+rKiQ03XmyqclDfiZ0pQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(39860400002)(376002)(136003)(44832011)(4326008)(8936002)(36756003)(6486002)(86362001)(66556008)(38100700002)(38350700002)(66476007)(8676002)(316002)(2906002)(16576012)(31696002)(66946007)(31686004)(53546011)(956004)(2616005)(26005)(5660300002)(186003)(52116002)(6916009)(478600001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDZSQ2JTUk1iaXhQb2REdWdDbXhKQ3ZWbWlTNG92MHIySTFLakgzMEVlRFNr?=
 =?utf-8?B?Z0JLZndkVWlKa2JvaG1YWTRjM2JTOWZPQVY0L1NnT0s5cW5oMjErV1VNbUls?=
 =?utf-8?B?VWh1enIreWFwWUwwQVpTWVgxbHpJelFqWmRlb2hkUDFNNUtWcktZdXdIQjFS?=
 =?utf-8?B?UFdvanE2YVlvbXp6amIwdkd5VG85ODFSWTJ3WUlSbVhYRWhQVVVwUXpEQWRZ?=
 =?utf-8?B?ZlhVYkx1U3BnV0p1ZnUwbHB1QS96ODhiVGw1amNnS1plQUdXUFovZ0VSVGVu?=
 =?utf-8?B?bU9TZGs3eGZCZGozRVhXRTNhLzhSZFc0Qk5MR2lLUmoxdzd4dlg1R0FwZFdy?=
 =?utf-8?B?SG9aNWFsamdCWFJsYmcwRjRzVE43RjQ4NzJXbWJCTzBKN09weUkvNGExRmEw?=
 =?utf-8?B?bWdTSGNpWjFMbVB4VEFkTTllYmxDUTZXSGxlUkN4TXNoZHlSLzZVNzJCTTZq?=
 =?utf-8?B?TjFCUjYwS1NDODZSbzFXcHVJdWxiV05ZRmVGWmtYYW44YUhScHA2UFNIdFRJ?=
 =?utf-8?B?QkhDSmlEWlVJOGdnSitQbHdwQWp4cG44Mm44SnRPbkZlRVAzd3ViMGNsU096?=
 =?utf-8?B?NHZxOU0ySlhBc1N4aEFtVTN6d0w4SnM5V0Z6SGsxNDhTZVRPZ0I2M0U2NUZk?=
 =?utf-8?B?Q3J2b2VHSEY2amxIN2xVdFAzcVc0NUhPTk5NTHFwQ0YvYjRrcDVqVWV3MWJ3?=
 =?utf-8?B?dVhSSG5LOHpvdnZhNFZ6ZTNYQVFoTnR5VGUzbkwzQnQ1azltdjBvRStZbCs2?=
 =?utf-8?B?NWlPVWQvaHV0WjJ5ZnIxamNSQ21RSHgvdndoVWs0czBJNmllQ1dCdkV0dk5P?=
 =?utf-8?B?TVgreTNZL0xTbEdZL0xQemd5WWpqZlVZZXc4Y1B3VkN3ZGVtbUxIZlFaSUVY?=
 =?utf-8?B?NlFQZTEvMTZPU0hTRGlyaW1CUEJYdENmc0hrejNZZ2MvMHFRdFkxaEtianlJ?=
 =?utf-8?B?N1dacGQ1SUpva0F1bnZVQS9ERWIvS0hjcTgxdjNJSi9rbGE1aTFOaFVpSlcz?=
 =?utf-8?B?d01TVmtuVEVTT2tmRy9nc0c1YzlCcTRIWVhvUjJQZEprQmdXS0tvRmtJeUZ0?=
 =?utf-8?B?NUxzdzhhb2xJVVRRT1Ruazl2QkplY2JUTkRJZDhndm9sK3NEbkMwRHZZOE1U?=
 =?utf-8?B?cXNldkRIWTk2Nmwrd0cxbmQ2c3A1eHNlaTBTeFA4YmRKektIS3pEM1M1aU01?=
 =?utf-8?B?bWFEY1Ftc2Z2dmcvQzNHR09zb3pMSUlqSzZhaXZWNEQ4YmhyVnBleS9HVlpN?=
 =?utf-8?B?U0twTU9WL08wb2MvMzhxRW0zVi84WDl2bVhxcE9Xb3JCU2VuWUE1dUZSU2ZS?=
 =?utf-8?B?Z3puUHJ5MmZxYVVsS3drZkp1c0l1VWlrU1J4ZUEya2Q3V25GaW03UDBsY2RT?=
 =?utf-8?B?THdEbGNUQUxiY2M0b01XdUhybUdOaGxtME9QRHFXdWlkYkRwRnpzUkY5TUJV?=
 =?utf-8?B?QjllSDgvdUwzR3FJd21QeXdyN3hwc3BWR1RQUkY5TGtqbGcvWE9mK2laVk9u?=
 =?utf-8?B?aWdJR1VxZm9zQ3IzVitYQVc3WlQ2SCs3TnVwbVdkajdBaVdUbTZHaGN6cm1i?=
 =?utf-8?B?VEtMRXRxTkJYNXNJUmUwSnFVWlFUSi9YUXJnL0NEaGJqTXM0anVFV2VrZTA2?=
 =?utf-8?B?RkdveU5HbVZTSStxTHNjcVJGcFFZQjVTLzk1UzZ0SDdqUDdBUzd6WnFxTXVk?=
 =?utf-8?B?UGJ1QS9ZeUo2Y0dmRmJzSE5DaEJFSzhyNWdmT2wrWXE3aWtFejlvNFFxZE1v?=
 =?utf-8?Q?C4yC4C63NivoVxoSBNUfEzk4O4r10DRR6mEcV6O?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b013d42-1c33-4a7e-46cd-08d95590325f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 08:33:25.9746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Az6e0FGsbrOkY6rXDPkIXncGUAEQNO0A1jSHvDtN4L9lEb2SOhpb/42BtfuTiCyI8A4GM5m3FlnBPxJtA2rqYcvMz+CgJcwDhTqRQcmhVtc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10063 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108020059
X-Proofpoint-ORIG-GUID: mNl1Cs6OcoqaaCl8wbpa2PA0AuLri7sv
X-Proofpoint-GUID: mNl1Cs6OcoqaaCl8wbpa2PA0AuLri7sv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/1/21 8:26 PM, Chandan Babu R wrote:
> On 27 Jul 2021 at 11:50, Allison Henderson wrote:
>> Remove xfs_attr_set_args, xfs_attr_remove_args, and xfs_attr_trans_roll.
>> These high level loops are now driven by the delayed operations code,
>> and can be removed.
>>
>> Additionally collapse in the leaf_bp parameter of xfs_attr_set_iter
>> since we only have one caller that passes dac->leaf_bp
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Great! Thank you!

Allison

> 
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 96 +++--------------------------------------
>>   fs/xfs/libxfs/xfs_attr.h        | 10 ++---
>>   fs/xfs/libxfs/xfs_attr_remote.c |  1 -
>>   fs/xfs/xfs_attr_item.c          |  6 +--
>>   4 files changed, 10 insertions(+), 103 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index c447c21..ec03a7b 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -244,67 +244,13 @@ xfs_attr_is_shortform(
>>   		ip->i_afp->if_nextents == 0);
>>   }
>>   
>> -/*
>> - * Checks to see if a delayed attribute transaction should be rolled.  If so,
>> - * transaction is finished or rolled as needed.
>> - */
>> -STATIC int
>> -xfs_attr_trans_roll(
>> -	struct xfs_delattr_context	*dac)
>> -{
>> -	struct xfs_da_args		*args = dac->da_args;
>> -	int				error;
>> -
>> -	if (dac->flags & XFS_DAC_DEFER_FINISH) {
>> -		/*
>> -		 * The caller wants us to finish all the deferred ops so that we
>> -		 * avoid pinning the log tail with a large number of deferred
>> -		 * ops.
>> -		 */
>> -		dac->flags &= ~XFS_DAC_DEFER_FINISH;
>> -		error = xfs_defer_finish(&args->trans);
>> -	} else
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -
>> -	return error;
>> -}
>> -
>> -/*
>> - * Set the attribute specified in @args.
>> - */
>> -int
>> -xfs_attr_set_args(
>> -	struct xfs_da_args		*args)
>> -{
>> -	struct xfs_buf			*leaf_bp = NULL;
>> -	int				error = 0;
>> -	struct xfs_delattr_context	dac = {
>> -		.da_args	= args,
>> -	};
>> -
>> -	do {
>> -		error = xfs_attr_set_iter(&dac, &leaf_bp);
>> -		if (error != -EAGAIN)
>> -			break;
>> -
>> -		error = xfs_attr_trans_roll(&dac);
>> -		if (error) {
>> -			if (leaf_bp)
>> -				xfs_trans_brelse(args->trans, leaf_bp);
>> -			return error;
>> -		}
>> -	} while (true);
>> -
>> -	return error;
>> -}
>> -
>>   STATIC int
>>   xfs_attr_sf_addname(
>> -	struct xfs_delattr_context	*dac,
>> -	struct xfs_buf			**leaf_bp)
>> +	struct xfs_delattr_context	*dac)
>>   {
>>   	struct xfs_da_args		*args = dac->da_args;
>>   	struct xfs_inode		*dp = args->dp;
>> +	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
>>   	int				error = 0;
>>   
>>   	/*
>> @@ -337,7 +283,6 @@ xfs_attr_sf_addname(
>>   	 * add.
>>   	 */
>>   	trace_xfs_attr_sf_addname_return(XFS_DAS_UNINIT, args->dp);
>> -	dac->flags |= XFS_DAC_DEFER_FINISH;
>>   	return -EAGAIN;
>>   }
>>   
>> @@ -350,10 +295,10 @@ xfs_attr_sf_addname(
>>    */
>>   int
>>   xfs_attr_set_iter(
>> -	struct xfs_delattr_context	*dac,
>> -	struct xfs_buf			**leaf_bp)
>> +	struct xfs_delattr_context	*dac)
>>   {
>>   	struct xfs_da_args              *args = dac->da_args;
>> +	struct xfs_buf			**leaf_bp = &dac->leaf_bp;
>>   	struct xfs_inode		*dp = args->dp;
>>   	struct xfs_buf			*bp = NULL;
>>   	int				forkoff, error = 0;
>> @@ -370,7 +315,7 @@ xfs_attr_set_iter(
>>   		 * release the hold once we return with a clean transaction.
>>   		 */
>>   		if (xfs_attr_is_shortform(dp))
>> -			return xfs_attr_sf_addname(dac, leaf_bp);
>> +			return xfs_attr_sf_addname(dac);
>>   		if (*leaf_bp != NULL) {
>>   			xfs_trans_bhold_release(args->trans, *leaf_bp);
>>   			*leaf_bp = NULL;
>> @@ -396,7 +341,6 @@ xfs_attr_set_iter(
>>   				 * be a node, so we'll fall down into the node
>>   				 * handling code below
>>   				 */
>> -				dac->flags |= XFS_DAC_DEFER_FINISH;
>>   				trace_xfs_attr_set_iter_return(
>>   					dac->dela_state, args->dp);
>>   				return -EAGAIN;
>> @@ -685,32 +629,6 @@ xfs_has_attr(
>>   }
>>   
>>   /*
>> - * Remove the attribute specified in @args.
>> - */
>> -int
>> -xfs_attr_remove_args(
>> -	struct xfs_da_args	*args)
>> -{
>> -	int				error;
>> -	struct xfs_delattr_context	dac = {
>> -		.da_args	= args,
>> -	};
>> -
>> -	do {
>> -		error = xfs_attr_remove_iter(&dac);
>> -		if (error != -EAGAIN)
>> -			break;
>> -
>> -		error = xfs_attr_trans_roll(&dac);
>> -		if (error)
>> -			return error;
>> -
>> -	} while (true);
>> -
>> -	return error;
>> -}
>> -
>> -/*
>>    * Note: If args->value is NULL the attribute will be removed, just like the
>>    * Linux ->setattr API.
>>    */
>> @@ -1272,7 +1190,6 @@ xfs_attr_node_addname(
>>   			 * this. dela_state is still unset by this function at
>>   			 * this point.
>>   			 */
>> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>>   			trace_xfs_attr_node_addname_return(
>>   					dac->dela_state, args->dp);
>>   			return -EAGAIN;
>> @@ -1287,7 +1204,6 @@ xfs_attr_node_addname(
>>   		error = xfs_da3_split(state);
>>   		if (error)
>>   			goto out;
>> -		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   	} else {
>>   		/*
>>   		 * Addition succeeded, update Btree hashvals.
>> @@ -1538,7 +1454,6 @@ xfs_attr_remove_iter(
>>   			if (error)
>>   				goto out;
>>   			dac->dela_state = XFS_DAS_RM_NAME;
>> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -1565,7 +1480,6 @@ xfs_attr_remove_iter(
>>   			if (error)
>>   				goto out;
>>   
>> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>>   			dac->dela_state = XFS_DAS_RM_SHRINK;
>>   			trace_xfs_attr_remove_iter_return(
>>   					dac->dela_state, args->dp);
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 72b0ea5..c0c92bd3 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -457,9 +457,8 @@ enum xfs_delattr_state {
>>   /*
>>    * Defines for xfs_delattr_context.flags
>>    */
>> -#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>> -#define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
>> -#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
>> +#define XFS_DAC_LEAF_ADDNAME_INIT	0x01 /* xfs_attr_leaf_addname init*/
>> +#define XFS_DAC_DELAYED_OP_INIT		0x02 /* delayed operations init*/
>>   
>>   /*
>>    * Context used for keeping track of delayed attribute operations
>> @@ -517,11 +516,8 @@ bool xfs_attr_is_leaf(struct xfs_inode *ip);
>>   int xfs_attr_get_ilocked(struct xfs_da_args *args);
>>   int xfs_attr_get(struct xfs_da_args *args);
>>   int xfs_attr_set(struct xfs_da_args *args);
>> -int xfs_attr_set_args(struct xfs_da_args *args);
>> -int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> -		      struct xfs_buf **leaf_bp);
>> +int xfs_attr_set_iter(struct xfs_delattr_context *dac);
>>   int xfs_has_attr(struct xfs_da_args *args);
>> -int xfs_attr_remove_args(struct xfs_da_args *args);
>>   int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 1669043..e29c2b9 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -695,7 +695,6 @@ xfs_attr_rmtval_remove(
>>   	 * the parent
>>   	 */
>>   	if (!done) {
>> -		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
>>   		return -EAGAIN;
>>   	}
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index 44c44d9..12a0151 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -285,7 +285,6 @@ STATIC int
>>   xfs_trans_attr_finish_update(
>>   	struct xfs_delattr_context	*dac,
>>   	struct xfs_attrd_log_item	*attrdp,
>> -	struct xfs_buf			**leaf_bp,
>>   	uint32_t			op_flags)
>>   {
>>   	struct xfs_da_args		*args = dac->da_args;
>> @@ -300,7 +299,7 @@ xfs_trans_attr_finish_update(
>>   	switch (op) {
>>   	case XFS_ATTR_OP_FLAGS_SET:
>>   		args->op_flags |= XFS_DA_OP_ADDNAME;
>> -		error = xfs_attr_set_iter(dac, leaf_bp);
>> +		error = xfs_attr_set_iter(dac);
>>   		break;
>>   	case XFS_ATTR_OP_FLAGS_REMOVE:
>>   		ASSERT(XFS_IFORK_Q(args->dp));
>> @@ -424,7 +423,7 @@ xfs_attr_finish_item(
>>   	 */
>>   	dac->da_args->trans = tp;
>>   
>> -	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
>> +	error = xfs_trans_attr_finish_update(dac, done_item,
>>   					     attr->xattri_op_flags);
>>   	if (error != -EAGAIN)
>>   		kmem_free(attr);
>> @@ -640,7 +639,6 @@ xfs_attri_item_recover(
>>   	xfs_trans_ijoin(tp, ip, 0);
>>   
>>   	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
>> -					   &attr->xattri_dac.leaf_bp,
>>   					   attrp->alfi_op_flags);
>>   	if (ret == -EAGAIN) {
>>   		/* There's more work to do, so add it to this transaction */
> 
> 
