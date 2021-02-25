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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49F0C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64A8364EC4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhBYGTE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 01:19:04 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44304 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbhBYGTB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 01:19:01 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6EsH1184811;
        Thu, 25 Feb 2021 06:18:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=aprBmr+SzNXwJUZTLB/dk/aVQxH4VtOHUSIBXn1ALYk=;
 b=v5OS2ll37Dx4ojJre6z4sHt25E0VQ5FizCMT47mFNJ4z0ZE5eADI/cG0eeYUPuZhRGpe
 sicJeo8qjakv24dPXkq3qSYTzN3FCBsG14jGLUTnI3FdZA0LquJfolhueS1daDxYpM/A
 dv+gsVzuLS45enSQfzt8C9fkxDTijsxkqgpBiNScgGuztfuDhIHTwcwOCLjT6zgmyGpw
 PghIs2Cj1Nx5k0MLdIYAerBzWQC6qyWzP5PlKRiBybehVIVj8RbGmTjBglabyB7Y/ts9
 UhikjHfBHfB5hMa0RwMfRRpY8uCTiT0Y0+ASayIGhaTr1k4M6iH7KmcIMXLssCpUbwv6 BQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36vr627p79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:18:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6Agri184354;
        Thu, 25 Feb 2021 06:18:17 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 36ucb1mu27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:18:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwL1SXv5WxznnWPEH5Qez427XvfhXMbMtO2jG3bX9zrcotd01HacZYYxLD6SlphdMKZh7BujsyUq+Z+QEWBkDpI9bLDQYHQ+tA18vXhYA/BLzuj/zhBpksyiUhNxpKLlNvYlvVrTAsT1/Ur82xMMXNGwRn2q1Rw5sUepYPOjpu7qh6vL1hExpHI56cVE1SsQHl4rzHYnDu/MixGYPIZGb/Ge+5neUzBmcVWwov+yWea4JfwM2ivcJb1N0WmgcxaOFfCRDoOhUXaQVUVeCZDKe4ysiopGJAS7P12M2H3BPXbPyYUPIuZBZz+dgxjNK4Eg+XygTY15Ojy9iY09HAcRyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aprBmr+SzNXwJUZTLB/dk/aVQxH4VtOHUSIBXn1ALYk=;
 b=XPUF1U2nQlkULV0r4jbd+MAxkG72LMCDxEWG0CoQV6MubL0sfn89tRvHTnKIO4kxwGJPLrTc+AQcDZEDT61mbIZibx/FYUa39Q0E0psaakziVmsjuCBG4dKb41v5kwUx+uvgXGqST6I0UlgkXC+VBeGI4lv4QWq801r5FUHQvos23wlOIJuESv0If5qqIj8nfujURk03UGaGrTkr8ak2Tz4xSFz6vPAH6oxewz6IKz3FcLNl7wVm/2G4nIuWzdrfThn1o+ren+3wQ7TX//4ZCrYwpv6ABy2vg1XeohUC8rJfd7SXu1Vrq4QNT/boPCrjlmkaNQRFLN1NArfdvNEW1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aprBmr+SzNXwJUZTLB/dk/aVQxH4VtOHUSIBXn1ALYk=;
 b=m5vS0/WItGr69ZK9/E5KNu9l5+LgypEnmnWcELYk9+rrtsYFEUrJ1t/Muv2aLi5Ax5l2L/DQS5YrIDO7Ykegx8u71CSe0u1Z7dh6Rx7pZgV6TPO+LURL0Sccek/h4UldjS1yqXJ5FYY2SNbgmECm8rFzMddB/x+U7gj6l0rMKMc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3780.namprd10.prod.outlook.com (2603:10b6:a03:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Thu, 25 Feb
 2021 06:18:14 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Thu, 25 Feb 2021
 06:18:14 +0000
Subject: Re: [PATCH v15 05/22] xfs: Add helper xfs_attr_set_fmt
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-6-allison.henderson@oracle.com>
 <20210224150419.GF981777@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <eced0dd9-1f69-a1ed-dca9-2161bea4eff0@oracle.com>
Date:   Wed, 24 Feb 2021 23:18:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210224150419.GF981777@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR16CA0015.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::28) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR16CA0015.namprd16.prod.outlook.com (2603:10b6:a03:1a0::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 06:18:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5fa4503e-0f33-4b6a-cec8-08d8d955227e
X-MS-TrafficTypeDiagnostic: BY5PR10MB3780:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3780B96A411761E6A567E4C9959E9@BY5PR10MB3780.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:576;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FmQW6KvpGC+L6myAfyzNGxHJdPafTOE+3haM4awogchCGCVkMCbpa0ZdAhneg5CDEusTJFGZIwN5z4OUhqyYmpxKZ9DWFtDodnSsOjq+KbJrLZV11pT2SOBkXiF6xBDS0yu8bNBtfezlQIWZ6dUogYBgQtOGNfjG23f+bWo/BsU/Z0fP/dOyuUVlH95+N+df0ZoboCQJZ1wi4WdHCr9CBbm5gaG5F1ScAnozafIhynx15Dh6cv3zyPU/kxm78Ikykold/RR6LKbVlFV3WryuWi2OzhEQgmf4dU099STq/XoczROyjTgMJtZ3SMecxBEDlJOJSwowvVoOXeDrrMiukvIN7SCtmn8uyAfm/5m0Jtm0PIWvCne7PrTyncBA++6QtWT/2qhRFPVYJapWrxz7eEEDJAANPSMlFqYPOWFQnB5tcrwEEDN1w32uUOE39TEbSXik0Oyd2zUaKrs6M58eVwrUwTHUfxE4fzFWMUdfLmqbYgMSpkPllp4mGK+zK4DwJsnN817dUKcZh7kp9vgYhmx8YFlH/z6aR+YNwxGjWv4pvImg9AWYrwqYLJuTWirWy8qCXrAmyq1tp2VQKA5XGcyjjs27xZk+I6aM+EXJmeU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(39860400002)(136003)(6916009)(66476007)(8936002)(4326008)(478600001)(316002)(956004)(83380400001)(31686004)(16576012)(36756003)(8676002)(86362001)(26005)(2906002)(2616005)(31696002)(66556008)(186003)(52116002)(6486002)(5660300002)(53546011)(44832011)(66946007)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q0FOWS9CR0VhUzkwYVF4eFRQQkJqMjZ2dk5MRGRtZFh1UzRtTWpOZU1FNThL?=
 =?utf-8?B?Q3RicjREeTIxQlhWc3NhUFJVNnBOeTBXVXlqbUxQRjFNUVdVcER5cnBpVW9n?=
 =?utf-8?B?VTRPWEgyekFFY0thcVo3NWkrMU9EQ1ZnbGQwMmNyMjkwSUlhaXZRNTRlMWlv?=
 =?utf-8?B?M1ZEQXRiUW5zUWtxa3l0VjJOS0MrZDlld29uWUxsbU50empGL0Z2U2IxUWV3?=
 =?utf-8?B?NHM0SVY4cDh5YzR6eFg4YmQ2bUdKRC83Y000ZGxISGdMNXN0QmxkS09WK0VO?=
 =?utf-8?B?V2MrZWJIckJ5R0hKVDFXOS92djlRd1NBb25kTWtwUGJsaTlHZ213UFA5Nm44?=
 =?utf-8?B?dS80dlI5WU1aUE5ReU5wKy90R1dPNzdxaEFPMUgwejhtU0VKU2Vsei96b0xk?=
 =?utf-8?B?NktDaUJ1QXhsVkhURE1FbmlIb3dHTmFMb2FEWGMvcE1Lb3lsMXN0cTRwVGUx?=
 =?utf-8?B?bWUxcTNEQVRjRXhZNThZeWlGNWJZTVlhT205ZWNvRVQ1akdCU1BBQ0kveDV4?=
 =?utf-8?B?bjk5UlZYb052ZW9seEZDWVkybDdUQ3N4OS8xMjBBU0Z6QTAwTzdlT2dNT3p2?=
 =?utf-8?B?bzZiMGFrNUJmbnN6SWJmVXYzci8vREkwRW02LytkVkpSNVZ4WmxsKzd3aVhY?=
 =?utf-8?B?SkRoYVFsc1BPUDMyNll3bncwOE15cUFxTlNhWjRYSHREMVVnbzI2c2g1N2Rs?=
 =?utf-8?B?elNGOFVGa2drWGZ5aWZsdDlnS1lBMFl2OGQyQXdhbllLUnVva1N6STBZay9o?=
 =?utf-8?B?QkhTakVaRDZ2UDJRamhOamJnNUs2ZWJBdG0zNVB3MGFyQzU4dVM2V1Z3SGxZ?=
 =?utf-8?B?c3hvNXJNK0NLQ0g1ZDVTNnBMVUdFdkxLdE9BS1VIcGgxVDBlY0RVdUV0WmFv?=
 =?utf-8?B?eGtHUkVUdDR6RGViZkZxZ2J0R25zN09ad1NEQitTWVFCbFJTZWd4Z0VJSFNE?=
 =?utf-8?B?a05EMVl0RmoyNUZQcndxcmwvaU55K3h1aURqYXlzc2FMK2J0UGFBN3M2VnAz?=
 =?utf-8?B?NjgxVncwZ1NPUGowZ3FibFdseFpjMFhmZ3lUdEI1UldYMEloeEFEcHdZSUFX?=
 =?utf-8?B?TDNPbkpHdUN2ZHBqMTVEY25uVDZjU0U3U0lqUlBXUHZsUkI3U3ViS0xkUWFK?=
 =?utf-8?B?NkdwSGlHTVJWcnRsVzIwU2NHYWZpOVcvYnkwaG0yVlVSM1dId1AxbVJ6Tmh0?=
 =?utf-8?B?MjgwbTU4Y2Y1ek9BN0hQbmpPcExtcEl3cXp3RmtJUDRSWFV0OFRtem51Y25J?=
 =?utf-8?B?MnFNZU5udWdmcTFSdU5IVG9hODZIeG54S2wxb0JqRlhwRG16bExHaVIxTlVj?=
 =?utf-8?B?NkwxTUJqaitSNmlWNlZnSVZYbk1mNHcrUW55Q3FxZmhLczYzTGxMSzd0L2ZE?=
 =?utf-8?B?RmFhK0J0UXpveW9QSDJtS3VsUzRuemdTWnh4Qi9zU1c4QjVwNk1wYmVQL1lF?=
 =?utf-8?B?d0Jkd0xsQUx0YTFuYlJFdkZaNWF4YkhFb01CcFpGZUxwVE51N1pGd0dYNVdW?=
 =?utf-8?B?N2xwTk8xTG04TjRUN0hZNzI3M0EwRy8xOHJpampKRlNLQS9SQkpObjk0ZjMw?=
 =?utf-8?B?eUtrcE1NWHpQaHRock1Qc1RneXQ5bU55MEEwWmc5QktXbGFpOUFUNXVhcjd5?=
 =?utf-8?B?d1FUMXd0YUVmT2xSdG1lb2MxdGdHd3F1S21YdGtwY09RcGYzSGx4YnMzdngr?=
 =?utf-8?B?Rk5BQ0FPVGxEdDRJUU0xOS9xZDVlbFI0bUZBL3JoNjh3UVFUZUFQeElUTElC?=
 =?utf-8?Q?Pni55J6sOJY1zYKCvixD/aPC85LnBuLMMwOxP4q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fa4503e-0f33-4b6a-cec8-08d8d955227e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 06:18:14.8353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sYQrOLQ3rq8QJw32biBUUr2LPF2LpzYKzetAmIAlefJA/tKwfaEwD7v/+R0Sk9awhXX2dEGnWzU/AV7fGFgczMY3zUTZ1v2a2FmYfO8BbrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3780
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250054
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/21 8:04 AM, Brian Foster wrote:
> On Thu, Feb 18, 2021 at 09:53:31AM -0700, Allison Henderson wrote:
>> This patch adds a helper function xfs_attr_set_fmt.  This will help
>> isolate the code that will require state management from the portions
>> that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
>> no further action is needed.  It returns -EAGAIN when shortform has been
>> transformed to leaf, and the calling function should proceed the set the
>> attr in leaf form.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Will add.  Thank you!!

Allison
> 
>>   fs/xfs/libxfs/xfs_attr.c | 77 +++++++++++++++++++++++++++---------------------
>>   1 file changed, 44 insertions(+), 33 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index a064c5b..205ad26 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -216,6 +216,46 @@ xfs_attr_is_shortform(
>>   		ip->i_afp->if_nextents == 0);
>>   }
>>   
>> +STATIC int
>> +xfs_attr_set_fmt(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_buf          *leaf_bp = NULL;
>> +	struct xfs_inode	*dp = args->dp;
>> +	int			error2, error = 0;
>> +
>> +	/*
>> +	 * Try to add the attr to the attribute list in the inode.
>> +	 */
>> +	error = xfs_attr_try_sf_addname(dp, args);
>> +	if (error != -ENOSPC) {
>> +		error2 = xfs_trans_commit(args->trans);
>> +		args->trans = NULL;
>> +		return error ? error : error2;
>> +	}
>> +
>> +	/*
>> +	 * It won't fit in the shortform, transform to a leaf block.
>> +	 * GROT: another possible req'mt for a double-split btree op.
>> +	 */
>> +	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Prevent the leaf buffer from being unlocked so that a
>> +	 * concurrent AIL push cannot grab the half-baked leaf buffer
>> +	 * and run into problems with the write verifier.
>> +	 */
>> +	xfs_trans_bhold(args->trans, leaf_bp);
>> +	error = xfs_defer_finish(&args->trans);
>> +	xfs_trans_bhold_release(args->trans, leaf_bp);
>> +	if (error)
>> +		xfs_trans_brelse(args->trans, leaf_bp);
>> +
>> +	return -EAGAIN;
>> +}
>> +
>>   /*
>>    * Set the attribute specified in @args.
>>    */
>> @@ -224,8 +264,7 @@ xfs_attr_set_args(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> -	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error2, error = 0;
>> +	int			error;
>>   
>>   	/*
>>   	 * If the attribute list is already in leaf format, jump straight to
>> @@ -234,36 +273,9 @@ xfs_attr_set_args(
>>   	 * again.
>>   	 */
>>   	if (xfs_attr_is_shortform(dp)) {
>> -		/*
>> -		 * Try to add the attr to the attribute list in the inode.
>> -		 */
>> -		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC) {
>> -			error2 = xfs_trans_commit(args->trans);
>> -			args->trans = NULL;
>> -			return error ? error : error2;
>> -		}
>> -
>> -		/*
>> -		 * It won't fit in the shortform, transform to a leaf block.
>> -		 * GROT: another possible req'mt for a double-split btree op.
>> -		 */
>> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> -		if (error)
>> +		error = xfs_attr_set_fmt(args);
>> +		if (error != -EAGAIN)
>>   			return error;
>> -
>> -		/*
>> -		 * Prevent the leaf buffer from being unlocked so that a
>> -		 * concurrent AIL push cannot grab the half-baked leaf buffer
>> -		 * and run into problems with the write verifier.
>> -		 */
>> -		xfs_trans_bhold(args->trans, leaf_bp);
>> -		error = xfs_defer_finish(&args->trans);
>> -		xfs_trans_bhold_release(args->trans, leaf_bp);
>> -		if (error) {
>> -			xfs_trans_brelse(args->trans, leaf_bp);
>> -			return error;
>> -		}
>>   	}
>>   
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> @@ -297,8 +309,7 @@ xfs_attr_set_args(
>>   			return error;
>>   	}
>>   
>> -	error = xfs_attr_node_addname(args);
>> -	return error;
>> +	return xfs_attr_node_addname(args);
>>   }
>>   
>>   /*
>> -- 
>> 2.7.4
>>
> 
