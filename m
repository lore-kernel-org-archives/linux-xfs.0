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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852B4C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3588764EC4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhBYGS4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 01:18:56 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44234 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhBYGSx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 01:18:53 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6F2tc185063;
        Thu, 25 Feb 2021 06:18:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=YFZtVqw+GQZ+oNm1/kUdzKWHwrA0xVNEn2pXXXr53y4=;
 b=WyNSBgo/t4ckvArMm3/DliG34WXTRJKenFTKstnYDiKXxgLeqaTmohDs6UArxysYmOMC
 iLB9qLisEigtmxcgNrlWoql41TgjVExWLOJ4UWddCPrs90bivb5BWsGaHsMsNgzo54ac
 0S9FVrsszvKMz8V772/Z45nzVJKMNX7bXVeK6sZ9n5pMk4QB1TwiVEujNQuRF5d5L/ub
 N4Jh7JFHwTppJNhr6oOr+8YUCCsOIwtHZtLnereuTCtmKVaNXg5lnfHaV3MyZUC5LpCZ
 0XnHiArt2OVqKRu+Y2R4ABwNhDlrsHpL6a+kUxlEjqAdZNGS73IMsDCPZGFx59WMj6PP Xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36vr627p71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:18:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6ADop173160;
        Thu, 25 Feb 2021 06:18:05 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3020.oracle.com with ESMTP id 36uc6u2edt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:18:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkgF+H3/KSrVhtbBDTBZnmqFUvp9AeNl7eyOE4u651Sz65NwqlPoaXC/eisXdRoG9cpfbJ6g4xnwk6+zdLU2/6zsA2et6hnl9ixB//v9HMMAWxmkWQdRzXUd6N3ZhoW2NdDcLqNc4iFVvj+y9icXVl6yz0qlCDXUbgEbPU+lwdPXHWmNenw75s0hAgi6s1FSS5CeT7eGrW1qXnVNBTodTHWr4PmFKCwLTdNuDmgBUjEeGIJ9jOQq0kv3N1LyXLHesyuHUcu3czi9/LXKIDZmAt+yWk9pvVB9AYWLCvljBDZpoVZnh94FskW9omviOw4MQolUY5tseiwij0IAMyAIqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YFZtVqw+GQZ+oNm1/kUdzKWHwrA0xVNEn2pXXXr53y4=;
 b=AK1KmjWHRAMNwz/UyCJv6rCWUC89j6rUvZQb+59//48b6c4XusstY9NGC20BhzzycfzudHDQl+b+gfaqAvCp17dUuwekw0QCmAAzlE/zvtdJDRlvlc9kqdtZ3GPooZMyeRYMd8Mgkd2zakNfZ9OGcjqg2IZm1+Zm6haz10tSIjA/0UbVlRvgkkaMQI2X6MqzohjMjqZuG2X/LvA/h+/Sc++qdrqkarpwd/h9kfRXkpKuS8YkHkF8x7ijf0e5rGANfuKX30G84VOGiceOKfqFZJipJitY7Iv2mLgYTjWQ52Tkt0MheCM7mc/6c4jOPHZCIOQrR/whCX9zLc48vVOTQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YFZtVqw+GQZ+oNm1/kUdzKWHwrA0xVNEn2pXXXr53y4=;
 b=zFak7wb0Yw3XE8pEIBT/AhUV/QiwKdv/UgTkHllDyGhqdLg522dKf+qgRUyl1pgzb8fiMwTq0Qfc+oMnLgJwWL8A0vORNPWK5VQhzQI8M7/Onvba7P9Rhx+7EHTfXoIgYntf5NzZsMIO8lNU9IQ14thpI0+UvhXACt1WmcB+/uY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3780.namprd10.prod.outlook.com (2603:10b6:a03:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Thu, 25 Feb
 2021 06:18:03 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Thu, 25 Feb 2021
 06:18:03 +0000
Subject: Re: [PATCH v15 03/22] xfs: Hoist transaction handling in
 xfs_attr_node_remove_step
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-4-allison.henderson@oracle.com>
 <20210224150403.GD981777@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <9785b4be-9ee2-74db-1114-19421e8193d1@oracle.com>
Date:   Wed, 24 Feb 2021 23:18:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210224150403.GD981777@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR16CA0023.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::36) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR16CA0023.namprd16.prod.outlook.com (2603:10b6:a03:1a0::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 06:18:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf38b812-4027-40e9-3ea8-08d8d9551b9a
X-MS-TrafficTypeDiagnostic: BY5PR10MB3780:
X-Microsoft-Antispam-PRVS: <BY5PR10MB378043812048C7EADCFACA2B959E9@BY5PR10MB3780.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9hDp8nJWu++7LEOLMHUprfNeOjqCHoSFRXAqVSx1jjrpPi2gxDtw5nBJGhj4Tfu+UzAjujcUXx+2MJNqKB4erPAWw9t5bXB/jEmeOFu9UkdNAZyHs2FUspNzOn64POc1yyvaUjIaIYlnqowJ7tZYscutVJcslPfGNhpwrZg5oIw4qjVDvKrSuOAoXqqKJqPpg+NP6yFMBj8QdCcDLpw30qJoMJm0j4eKEHlEdTofLO7My7sbFgVzrTa4JGv0y0oXuB7A9TTDxL5d3raGMb9eQ5fhoEx9YbC3vOPczMQH8KAQnzBZnATRoqeLlA5h//69habQxCrWTy/hRlhefaia83LdIwHWjiTAkoE5iRp9MKVW5Nplz/UBOir0ehYIXSjc1/oDeORjdAa9mjE+PQrqxGuCyzzjKL22p+YwgDqNq0YoAwVB5t/Oetgh05d7A6kS7hLRYV21JvHrJzmaf8c3XYPHMwHNwsb+92rntVQgOLROPy9aewWAKqr5h60+tsWH+XJK6jhnT0lVxIBkeSqYMwtdaGr1diTMVnXgNq4mp11pn5nmIye37DHNpVpBx2rg1b8+IX+oUypd4P7dtEPnAnMdggXTo+rFGsh4hFxCUU8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(39860400002)(136003)(6916009)(66476007)(8936002)(4326008)(478600001)(316002)(956004)(83380400001)(31686004)(16576012)(36756003)(8676002)(86362001)(26005)(2906002)(2616005)(31696002)(66556008)(186003)(52116002)(6486002)(5660300002)(53546011)(44832011)(66946007)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TER0RldFUHF0TERxYVNVQTlmUVJ1dXdQejc2UXJuK2U4TkN2bE1VOUFkdDdG?=
 =?utf-8?B?ZGQ4N24wUlFMVURjVUJEV1A3aERqc2VSd2dUbWw2cXE1UnE3Y3oySDNqZDdE?=
 =?utf-8?B?T1Y4ZzhDS1UwbGRYYlpqVnErSzA1bFlRTlJTREZWTi9QOG1yQVZFa3lYc3Yy?=
 =?utf-8?B?NDlsYVRQcEdKdGhsYlVCMTZNV3RFamw1UTBmdHprRTRjbkgyUEhlY0VFbXVU?=
 =?utf-8?B?cm1wbklXekRiY1NOUDBoVEpVcHJaNWYyYUhKd09Wb0VmUUlXUE5xQ3VMdi9H?=
 =?utf-8?B?TnNsc25qd0NXZm5xK1pvdlFPTXR4c3NuamZMUFZXbzRnbTdEdGFlaWJnWStP?=
 =?utf-8?B?ZEtSWUtCcUsxeXpGR1REY0xMbGZuNFovbmpPTGFuZTJnbXUvOTJsRTdPQi8x?=
 =?utf-8?B?ckJLNFJtNEVXOEU2MHFzOHpXZmJaUWI1RGE4OURCN3BES3RlZVJsQVpQSHhW?=
 =?utf-8?B?Uk1zOGRiVW5xLzdNcFFyVUh6TE8zeHJqdnFINURnSUtSZjVkZE9SRVoxaEk3?=
 =?utf-8?B?dUhUWTdxS2ZPV1A2R2MyZHFrZTFUYzFxWTd1WWU4dmVMcHgybGRkbHA1WmZR?=
 =?utf-8?B?M2RPNXFrVTJ6Wi9pZmd1aXl2d2Eydk53amFrVU1uUWhNU3hSdStEaloySXNL?=
 =?utf-8?B?WmIvRHhZa1hFU1VoT05ibytlcTJ1M3IvaTBma3ZhWGhGWjhkcldNd0N6VEp2?=
 =?utf-8?B?MEwrdXFHb1NSZ0tpSElZbG55ZWswN0MwRmpsQkIvaWtBU0Z2QWdMOHBJWm0z?=
 =?utf-8?B?QU5pczM2Y3pXWDBZeEt5eEVJRDZ2aHloSkx0U0ZaVUtDb1ZOcjYyak1CVGgx?=
 =?utf-8?B?Qmt4aGpHcGtEM1FvS0VqOFpORWNGOHZRSmdsTzFHK2Q1NW1PN05ROFgwRFQy?=
 =?utf-8?B?RTFkZGVqZHRpcWFuVVUvdjJlMElhTU9hQkVEVnBZaE51NC9xeUIyWjFQRnlu?=
 =?utf-8?B?TnFvNS9ZSkFXMXlQWlNDVWFZWDJvOTZISnZUR2dqTklRZUpHNG9nWFc1dmZO?=
 =?utf-8?B?NWhYWTJPM2lyZTlvRExZcWg3VjRiZ3I1bC9QSkI2R01ucWVpSUlHeHlmUTR6?=
 =?utf-8?B?eEJZcHJrb01qSDRxWS84dkZTa0EzcXlRK3NWTysrSlJZOW5hL2liMVRxREV4?=
 =?utf-8?B?bk9OVHBTcDlBaWdxUmMzN3o2cEljWUMwdzk0Y1pwanB3TkZIQnpLN1ZxandU?=
 =?utf-8?B?NThFR29DUXpvR1dHWG96WFZaRjFtejdpNmp6Wjcyd3pwMm1oS0l5UFB5a1ly?=
 =?utf-8?B?a1d3WXRCSTkwQno5T0VEaUZMR2lxaXVLZ0t3a0ZnQVNlNHJvZ1pRbnE5NHN1?=
 =?utf-8?B?cER3cGZ3UkF1cHlxU0txTVpQTnQyREdrQW9RTWJEVGova1NvcHVBalNnODVl?=
 =?utf-8?B?T0xBV2hudWtJU1QzUnp6T2xBTDhaUTZvUzhnOEwzS1h6V3dmRytaU2V5TURO?=
 =?utf-8?B?MXhLRklBR3pDUm8yWEdSUm5IZTFaVS9QL2NockcwOTNCYlQ1TTVKNzdwWVdx?=
 =?utf-8?B?V1FaVUpJREo1eUhCNHVXdnZ2anprZks4RllFQVgxNit5Q1BOTnlSamw1eE9H?=
 =?utf-8?B?bVZJMWpHOFo4WlNRdU9OYmYwdllMTitUdC9WZlBydzR3cDVrTU9uUjc2eEFH?=
 =?utf-8?B?V2RtYkdLMnM0eXg4N3RNclBvOFZITHJuUWk0SXl6UHdsT2lkTzlMMUJIazFL?=
 =?utf-8?B?R2R1LytlZm14TkxRUXJtejc0cGNyUE1qc21ic0FrWFYyQ3BvNlRpR3IvQ2or?=
 =?utf-8?Q?TH/Pb5pQ1CyGgGYoBEd/Yr4GXYy4737vNTmkSyt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf38b812-4027-40e9-3ea8-08d8d9551b9a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 06:18:03.2760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewx6yQgCspUgSECelRYOSc3U5xl3EvDZc3GC9w/sAD0cpjjD+NhgoNm5I0l1KL4PA/yGXWBdKX9n9tX3DVvq3c6hXfm+zVld5wb5nwJcpuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3780
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250054
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
> On Thu, Feb 18, 2021 at 09:53:29AM -0700, Allison Henderson wrote:
>> This patch hoists transaction handling in xfs_attr_node_removename to
>> xfs_attr_node_remove_step.  This will help keep transaction handling in
>> higher level functions instead of buried in subfunctions when we
>> introduce delay attributes
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Great, thank you!
Allison
> 
>>   fs/xfs/libxfs/xfs_attr.c | 45 ++++++++++++++++++++++-----------------------
>>   1 file changed, 22 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 4e6c89d..3cf76e2 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1251,9 +1251,7 @@ xfs_attr_node_remove_step(
>>   	struct xfs_da_args	*args,
>>   	struct xfs_da_state	*state)
>>   {
>> -	int			retval, error;
>> -	struct xfs_inode	*dp = args->dp;
>> -
>> +	int			error = 0;
>>   
>>   	/*
>>   	 * If there is an out-of-line value, de-allocate the blocks.
>> @@ -1265,25 +1263,6 @@ xfs_attr_node_remove_step(
>>   		if (error)
>>   			return error;
>>   	}
>> -	retval = xfs_attr_node_remove_cleanup(args, state);
>> -
>> -	/*
>> -	 * Check to see if the tree needs to be collapsed.
>> -	 */
>> -	if (retval && (state->path.active > 1)) {
>> -		error = xfs_da3_join(state);
>> -		if (error)
>> -			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> -		/*
>> -		 * Commit the Btree join operation and start a new trans.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			return error;
>> -	}
>>   
>>   	return error;
>>   }
>> @@ -1299,7 +1278,7 @@ xfs_attr_node_removename(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_da_state	*state = NULL;
>> -	int			error;
>> +	int			retval, error;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>> @@ -1312,6 +1291,26 @@ xfs_attr_node_removename(
>>   	if (error)
>>   		goto out;
>>   
>> +	retval = xfs_attr_node_remove_cleanup(args, state);
>> +
>> +	/*
>> +	 * Check to see if the tree needs to be collapsed.
>> +	 */
>> +	if (retval && (state->path.active > 1)) {
>> +		error = xfs_da3_join(state);
>> +		if (error)
>> +			goto out;
>> +		error = xfs_defer_finish(&args->trans);
>> +		if (error)
>> +			goto out;
>> +		/*
>> +		 * Commit the Btree join operation and start a new trans.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, dp);
>> +		if (error)
>> +			goto out;
>> +	}
>> +
>>   	/*
>>   	 * If the result is small enough, push it all into the inode.
>>   	 */
>> -- 
>> 2.7.4
>>
> 
