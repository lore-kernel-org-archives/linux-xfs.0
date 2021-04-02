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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5044FC433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1142D61105
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhDBJBU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:01:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59534 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbhDBJBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:01:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1328xwfC106465;
        Fri, 2 Apr 2021 09:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=PbUYcSbS+Etl5C9pLvKqFLqdR3gDgOQObQUBCrUKrz4=;
 b=lIaSOWfitcIiBlrAo+XNXsauqEgRqQeqozEYVpqeUVRVVibJadw8Z0/IFwn+LhNfPATd
 ngvvDgBToW+crxiNyGkjvexJEk+EU7q+hjz24Luzxj6vgQC+s3xmZtDKnh7LRXYbkryh
 4ERuL8jPUL2OMB8S7feVspgzR0328ckQsMIkWvnc9m9pdbpGb0KmJJ11F3vD+BJx+o2U
 AdtK6TgnQ0WJ55fW2MKkBN4kfmuLfGH8bZXrvaHZitokzUfkcfAmHJ/GXgHLNhZOkn/J
 fh/x+bjmNrDK166rAqV7/XI+ptWEnlXLHXHONL1Akalx3uOSvf7iXJAihAmgO7nwD6Xz Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37n2akm8mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:01:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1328ndM7041289;
        Fri, 2 Apr 2021 09:01:16 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2057.outbound.protection.outlook.com [104.47.44.57])
        by userp3030.oracle.com with ESMTP id 37n2atv2a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:01:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVJGyYqvpR/nxB7QVNX1KsQeSk5deBqLo8A6LLbF9zXiUbo2VmKWy0UCvgQ575PlAUUVQtX+ljAkT/oFfhVk8CGG+x140dOJDExdXbFKSSA+Jcopfn6BZcRJ4SgcaYsHNB1p7R6anmErdmv8iCgQt6VquQqJ58Ww1HZpgxZpl2Z1H+V3ijgiSrQfyJ1dks8LG50bU3N//fabXIlAvVnsxdPWySpcULtUEGhLEQyv+k7AaBu0CvUXLx8XxViMY862EwtN8M1BNBYKA50ZeO3uZtN+zopqHjhtI4tJx+S0XdA/PzsfDseBbHWqE74/MlBL0WIYn1rQMDTM8G6qglEeOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbUYcSbS+Etl5C9pLvKqFLqdR3gDgOQObQUBCrUKrz4=;
 b=dBOL4hy+jHe1VKb/dCUCC8WzDq/qAvUXSDekKeYl3Z/J9dZekY0Sr/YTJwmoH5wQRvaCZGzLYwh1go/Sm4tKqSA2Q+g0kTkPwLLsiDwiSaJ3Q/PshzsOUJwwG/ZpGot9JrHEy46Ou7T1Ka8sua8t4e6iKwkZCcJ8jOB/OvKuiGwFGxUnjmM4GA/xq48q+KBOJP+y2bgTZzHQsjnxyRraa+/GV/8/KLXQqQ/rbwwG/noi2kk9H/9X75JD7u7VEGOKOIBlqjwXbgrUDvWYf0/whOazpK/YKaT5Juvfv0+H2NtCVpEAgLRYWogf2aQBXOoyl3BvL1tSpJBoXrBPH9qcrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbUYcSbS+Etl5C9pLvKqFLqdR3gDgOQObQUBCrUKrz4=;
 b=AskSC+spyQQwv7RE/44TZVTnfKt15Un+Nhj4QGyRULfhWVLwfDqViyWXg8NpLXXQnixJRtM0a4flwHwXOmTDN8lAANWV+8bQXQq/R0Ujlp/vQtFL6rVgdYqIC7PY5we3TLBmFfJwA6lIqjjiWAV7COTmk14drhk/HRj8DF7fvpA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4591.namprd10.prod.outlook.com (2603:10b6:a03:2af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 09:01:15 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.3999.032; Fri, 2 Apr 2021
 09:01:15 +0000
Subject: Re: [PATCH v16 07/11] xfs: Hoist xfs_attr_node_addname
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-8-allison.henderson@oracle.com> <87sg4971ni.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <9daec758-e9d2-ae26-1d69-e50f93417492@oracle.com>
Date:   Fri, 2 Apr 2021 02:01:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <87sg4971ni.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Fri, 2 Apr 2021 09:01:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dd0e38b-85b7-4a90-45dc-08d8f5b5deee
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4591:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB459167F6C281641F231F8FF1957A9@SJ0PR10MB4591.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pgs5kvwjUe+0chG0SZK41N/gmqBBoxQplav9k/IaXvn0ZTKt16VbMEHcUS4OKzzlhgP5tPW62eKT5vQRL/0eHCYGE/e/zl4+2dCIAAdypJ8/KAkPvxmyy6kVbVNIqqyiLFG87MIsbt4FwdS6xyGc3y5uSdeyCJ3LSFTpMrX6gQyE7iJH265SqA594NrFI6c9gsAap6TF7Brizojn5QVzGalcdRltodpr12hbD/cHwS/kvxxaOlDU4jTXYSq5ZObBs58r4M/wkGLfFrQ60yLJwPSbQjd4Sg20kmcilIGpEuNeANnHU52pxEDD3F6vd8bKds6UfeZ+5jND6avXQYF3MUai2Rhcmx/JWcmDrwdpF5C3IBHPaKZqkAxydgixaKPzAeGf3UqfyDV4HZvVlj/N/bXgOU63Ej08GyGL3w+P1ZNPbLH9uarlHVBdzZ05tdqyu/e1QsIla6R9zNZWXTygMgjkOxg1RsD3H1YJ0VAAUprjhxkrvRTHxn7AXKBlhsyny8+BGMtIYDW9xXO7x27/yfHd7Zaw33v3X0cPTxGWKtOwMDeC2CWkKKBHOw1DehkApzbsTtE8U1/NfnmFPHKRrz7R2DnnUVahHEvnT+u4f4kPf7DVq2Pg6f5eeN2it8+naT/KRrykW3MUwVDt04J2VBOsh2qUwhaKGwB9Kj/akp30vr0ApzATXiwi4xaIqrPa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(136003)(366004)(8676002)(8936002)(31686004)(31696002)(66946007)(186003)(2906002)(83380400001)(956004)(52116002)(26005)(16526019)(6916009)(2616005)(6486002)(36756003)(316002)(478600001)(4326008)(38100700001)(16576012)(86362001)(66556008)(44832011)(53546011)(66476007)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZmoycnFrTzBVWFJIRzdkZHVQcHJzOTYzZGN4ZnNNV1VFb01qdU5ueGJSS01p?=
 =?utf-8?B?YW9nN1hWZGdSNjdZNnpOSGN2RUw4b1I3RWxJTFVUL0ZhMjZzRXRYOVFnN0Z0?=
 =?utf-8?B?K2MrWGtlSGxlWlJKUW9WZC85dFNFV2w4V0t1eTEwSVZtc0UwMHVhbURVZ2ty?=
 =?utf-8?B?MkZGOGEydFlVNGFvY3I5UnpXZTVxM1NIemthWXFad3AwSWhCVXlqcmw0ZThC?=
 =?utf-8?B?SFl4aUY1ZGp2dTViRUVYSyttUGkrSTZhdUNtdkZoMUh0ZFNLcC8ya2NRMjF1?=
 =?utf-8?B?NWlXelVvSlBPVTBtNnlSLzh5ZUVzT1N0d0xmcGdqSUxOdHdpTllZRHM4a0Y3?=
 =?utf-8?B?cDNtV2ZndFhJN3lqdE4vWVo1Y3pvR1RheU05ZXNKY0I2TGJSN09XVVBub2hB?=
 =?utf-8?B?Z1p4bHdhN0hZVy9JSklHQUMzZE1IZENSUGd2c3dGOVVIV2JUZ2srNmEzR2s4?=
 =?utf-8?B?YkRscFhJaGcxdHNZZE9sOFVKOG5lWkFIN29oYVAyZGhxbkxDamV5aEZHTVph?=
 =?utf-8?B?bVFQYUtLWHJpZ1VMWjVYOEtWaldDamFVMUtsbEdnR3lvQUZvZnY4bFZpS2Z3?=
 =?utf-8?B?bkpXSXJoZDBGUktxU3BEM3Q1aE9GMWtiWlZ1RUdraStpVHp3NHlja3hlVnc4?=
 =?utf-8?B?NFl2TXJrRC9wc0drajVwZU5yRTgzMnNYcHdwY3JPeEhCN0FRdS9IckVSUkd2?=
 =?utf-8?B?VU1XK1pUZ1d1OTVBcFE2UDdBa1A0OEpJbmNOaFJZNmlmNmF5M29DQk9JRVk0?=
 =?utf-8?B?RDl2c1pKNWJ4eUJwV3dUWWxoUDdMQ3JsRVRTRVFjZXZybnRGZm1ZQ2V6Y0oz?=
 =?utf-8?B?dWo5cmlNOW5oS2lwb0laYzdFRmJObnJVa1Jvb1IvckN2S0QvcDMwbnhHN29S?=
 =?utf-8?B?TWpXUUtWSHlNanJHNENuTW9HQTBiTC9NOVNWa2lOSHNpby9sVEtxL3VZV0Nv?=
 =?utf-8?B?aGg1TEp3TTR1cjJoZWZiM3YyVlhwK25kak5SdUN6QzZyRVZoUGNYUm83OGpw?=
 =?utf-8?B?M0pSWlhNSndSQXBDQlpMS2EzWGtNVjVscm1QMnVQMXZlb1pzOWQ3OVJ3bkMz?=
 =?utf-8?B?N2F4M2hmckFUR25KU3E0QTh4cWlRd0ZvT2VyMnZZSm1tdGJmblY5QWlYMWFM?=
 =?utf-8?B?VXpVd1RZWCt6UkhFak9XMy84RnhLRzJSOFlPWjhGRXVjeU15SFVrc2VUd1hE?=
 =?utf-8?B?dElBK3luVExFQUhNLzZqQ3o3L0tUR2FJRGNIazIybzZKUmo1NjVxMytqVEwz?=
 =?utf-8?B?WnRnR0czZEpNZnY3b2JnQ3Z3Y1BCcVp1eWxERzFiMWlRTk90VzF5QllZb1dQ?=
 =?utf-8?B?d2EzdHZNb1RHbzFiN0ZqYjJEODhHaVV6ZXhDK2JFWm5ScjM4RTYycWFKM1JZ?=
 =?utf-8?B?Y2xJQVRrMUgxSm9JRWZUNHBQUjlGNVB4WFIrUXFHdzBBT1l2NERrYjBQcHU0?=
 =?utf-8?B?Z0hWT3h3MFRIaW9Nd1M5ei8xZmVrNjZoRWV3cDhMMnU5T1FYS0tCZzVXM2xp?=
 =?utf-8?B?VXc0MnUzdllTRzZGK2JEN3J0b21ycTJyWHVaNW93aHJoTVdmSXhoWFUvWVpi?=
 =?utf-8?B?TWcraVlaK29mWk5FQ0hGTHNRNWZIb1dJdFRYb0dSaDh0UnFTM1lBRXdSS2la?=
 =?utf-8?B?ckM4bXNRT1pPeis5cXZWaEEwUXp3SXYyODdFYUFEcUl2TjF2d1E4L1krQ2Zh?=
 =?utf-8?B?RXNzNTAyejU3OUNzRFJIQzQ2Y3VQSFBFdVVmYzdsOHNtRkJTL2dqLzlRajdG?=
 =?utf-8?Q?4acR1DxJLg02dloIQ/t/N3JkMFFKMIE8sS7ZnVF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dd0e38b-85b7-4a90-45dc-08d8f5b5deee
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 09:01:15.1864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yTV3gNlJYdqWdBbOoeSaqoRhapgp2GKzF6QYM0wuOAi/CHdHDdh6hMx0hOhdp9ebH+8XIptO2/Pr60h6n9nkg52uEDztdaX8LZxgyTDyqUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4591
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020063
X-Proofpoint-ORIG-GUID: Y85Tu8KxKvYKGUiuVpV9uq-sxwQQNwIT
X-Proofpoint-GUID: Y85Tu8KxKvYKGUiuVpV9uq-sxwQQNwIT
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 adultscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020064
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/1/21 9:26 PM, Chandan Babu R wrote:
> On 26 Mar 2021 at 06:03, Allison Henderson wrote:
>> This patch hoists the later half of xfs_attr_node_addname into
>> the calling function.  We do this because it is this area that
>> will need the most state management, and we want to keep such
>> code in the same scope as much as possible
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 161 +++++++++++++++++++++++------------------------
>>   1 file changed, 78 insertions(+), 83 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 16159f6..5b5410f 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -52,6 +52,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>    * Internal routines when attribute list is more than one block.
>>    */
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>> +STATIC void xfs_attr_restore_rmt_blk(struct xfs_da_args *args);
>>   STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
>>   				 struct xfs_da_state *state);
>>   STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
>> @@ -270,8 +271,8 @@ xfs_attr_set_args(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> -	struct xfs_da_state     *state;
>> -	int			error;
>> +	struct xfs_da_state     *state = NULL;
>> +	int			error = 0;
>>
>>   	/*
>>   	 * If the attribute list is already in leaf format, jump straight to
>> @@ -322,8 +323,79 @@ xfs_attr_set_args(
>>   			return error;
>>   		error = xfs_attr_node_addname(args, state);
>>   	} while (error == -EAGAIN);
>> +	if (error)
>> +		return error;
> 
> Memory pointed to by 'state' is leaked if the call to either xfs_da3_split()
> or xfs_defer_finish() inside xfs_attr_node_addname() return an error.
Ok, we pulled it out because Darrick had run into a double free on his 
set up, but I think maybe it makes more sense to keep it here and set 
the pointer to null if it is freed.  Thx!

Allison

> 
> --
> chandan
> 
