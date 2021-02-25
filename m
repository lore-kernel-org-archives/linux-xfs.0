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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FFA9C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ED8064EC4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhBYGTK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 01:19:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52426 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbhBYGTJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 01:19:09 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6ExH4059598;
        Thu, 25 Feb 2021 06:18:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=trbkgnnQ3Qx3x154mqqHaL5PzSvz638Jr49bz6ZlWMU=;
 b=qpG43g724n0GdvBYRi7X0dqxz6HAnqiAfb5QH4hBuVnL3+s9L+FoXazB+NkiFJiHj2XE
 u/SU7epWwsoXFkOLLe/aMVjtxP4OMUl7KqaW3pAfQpI0iy+Tr9aMk5MqtkJOSJl1LCtC
 Ko8gDjKWzJnUnLo4Y/KdC8mOnUxmVodSX15Fpt0smRgm4SASi5lQBuQ/kdFzhPqgOhnS
 gYQjgALAW6HNOQaObIC5To45ytkgsw9p0gksYKMYy/7hugZoDsTgdRJ/mtMPPD8Zfqg6
 i3fFKEo+S4cPpGgIflJbBZhpVbpu+Qk+Mfph0Co9HvN+5kHlCBFBV6pEfdG50zD10Gb2 FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36ugq3m6vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:18:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6AZfd159152;
        Thu, 25 Feb 2021 06:18:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3030.oracle.com with ESMTP id 36ucc0t7rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:18:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNtWmlr4rq8yt+sbszQ8H48/kXmrqcMXXEPEyeBdhcnVphMumggd2op/kOkg6Xwwe3XTjIR+GxMgK2nYWVy0xxzGlthD24d2sB6WleXOI42Nhn3vpMiKiQ8d6rd/AR4RQcK1SpQwlzX173iEYvkEBpJpkFrJ2xN8AI6lnlZ+b8Hbgpb0mnPEaqUC6uhk6l9C8KdK3FN5GZk15X9UZWS+nTOEyYe2Kdi46wb4XNwBNf+AWcyfZ6GA4IZTnXoZkEDUL8D3/E3QxAIxRVuCyn8LzUhqf6toSrboQmvVH9CTi8CvUpN9qFyg5qVXCCKuBg2Q0q6vWJNZ21g0yet884LDFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trbkgnnQ3Qx3x154mqqHaL5PzSvz638Jr49bz6ZlWMU=;
 b=XatY/LTFETubYvzIJDp6lsUp8mTPELPite5OPN8yYjWKngQQWpKP1Z482rX+HAQeKBjAyPwLFlSXvtz2oIDDibIedjmHvHoEkhQOcZ4F8fhA5f3uWJDZZxIQFk7ZKdCKLRg4WSbVvCSifymY8Lmq0wVjJ2ZDXanqCzV/CfbePcy3/q2ZosLdFuBqUTnfkdTt60EqFLEQWKcWPQBfyGMIsW0TgNfWBUhaFMQL8O5GAEiKkr4YS8GS01nZtXnj9YJ/OkUViR1uDy09x58H83KhMYUjWhre7OOljuVKEblrfMAwgoVaBsDKAxBk627jA4pcwgFdVTz+5Ic9EVXBR0kebw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trbkgnnQ3Qx3x154mqqHaL5PzSvz638Jr49bz6ZlWMU=;
 b=czwypM6RDoPRY8DZPGx3zoir0reGql8zczFDfjhQp4i3UpA3WkLH9iWUg1YxTqc8SsWP6Mgg6RaN0RAAUCjUpLhbVplCP4atC2xIZ0N1YShWGt8TqNyE+r1bBMIVKRgmEpPdE8+M+Yf7YCckJ6EMY1FC221OSYQ1ZvuoeQYLlg0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3780.namprd10.prod.outlook.com (2603:10b6:a03:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Thu, 25 Feb
 2021 06:18:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Thu, 25 Feb 2021
 06:18:21 +0000
Subject: Re: [PATCH v15 06/22] xfs: Separate xfs_attr_node_addname and
 xfs_attr_node_addname_work
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-7-allison.henderson@oracle.com>
 <20210224150427.GG981777@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <367217bf-17b6-618a-565c-97542e2466a1@oracle.com>
Date:   Wed, 24 Feb 2021 23:18:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210224150427.GG981777@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR16CA0036.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::49) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR16CA0036.namprd16.prod.outlook.com (2603:10b6:a03:1a0::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 06:18:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88c5ffcc-5605-4898-be7c-08d8d9552685
X-MS-TrafficTypeDiagnostic: BY5PR10MB3780:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3780F9B2B091320E49408508959E9@BY5PR10MB3780.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JWGoAwo6dYJNyZUcvQ4SAwFv7ybGrEiYcfXpMl1OMggJWJIvDPqbPtSn0JKKv3UAEHr7gdvZsRHj+iq77ARwq9eTIw32BqidRSbLessl2GEmrmwqMX0JQmVYukmwD6eI1whHBFHmc/WZeJ5LiQhNW5rDrBwyVPuOsXgUm7TdwUIP1I0Zkzl/pyd4Y0KkenMq88ZY9DYA5bjUVQC+5lWGN6O2SuyxT6605MAgQT4YjhKEb0vGZGhd+4vxVvfLY2H21H7bYrHLkOXxTmzBSpE+qqSE0OYIE9/058QCoHQkflv2ny0rmbREMJvYgURZ7u1MabjTua9F31ybGoGF+hKZ4anYefpWSAAg29Ts+YpfPnezfzHP0te7Epy+TMV9RZhLpqVq6MwLNzh46SIcntdxwl0O4Q26klGI4IJhHKSpwDXvcnq6U1qrppAM50BXee5fLaI1g9KVer/CofWP50lV2U0kAL9mekt7zZkZeyutNdUyAvNZtNUXxSXlTgUrfXP0DYhc/Ud8VQTh1kwIUAjfO6po0LLVwbOHD++9mTIss9xHA/K4bsBvg6qPJCFFVJZoZSLVrdsDHhTzYx6N4BExLQGTpN+6rZ0lRk+47mh08Ks=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(39860400002)(136003)(6916009)(66476007)(8936002)(4326008)(478600001)(316002)(956004)(31686004)(16576012)(36756003)(8676002)(86362001)(26005)(2906002)(2616005)(31696002)(66556008)(186003)(52116002)(6486002)(5660300002)(53546011)(44832011)(66946007)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZmtBdVJESm51M0g3NkIyZ3BjQ2loeTdhaDZYQXhVMEJOVlY1UWQ4QXlWdWJK?=
 =?utf-8?B?bTY3ZjlKWXNEc0dwLzcyRUgrTnNQU3A4ODlmUE9EUFFieFcvcG90a1Q2aU9T?=
 =?utf-8?B?SlZzQmpIYitTK2hWVlBjSlIyaHBlRjRpTFA1T2NjU1pkUE1HQS93NG9jUFg4?=
 =?utf-8?B?NXh0NUVlMitNWk5ZQkJEdEVuc21YaXNpb2ZHZ3haVVVKeUEvNU1vT2s0a3Iv?=
 =?utf-8?B?OUtpVUljbzBYNENRRG5rTFVQRlllQkpQU2FwYzBUcnlTVG52SHJiYkxiaEZu?=
 =?utf-8?B?Sk5sWWNsWlVObzRqTFFxMmdUeGdXcmVwR08xcDJwRW84eUdwOWxFc2JVVTYw?=
 =?utf-8?B?Rmlmc1FQN0ZlWHZGMkptS0dKanFkUXlGbjM1a2hJTDZOYVJsdnhQUHZhand1?=
 =?utf-8?B?SmdpSEJ6Vi9RanJjUFVFUjl0dHBhaWZZQVVUUGYzeWhJYnAwMWRUWnF3Wmlu?=
 =?utf-8?B?cGlIWHZpWGM2SldtSC9YSm1JNERGcUMvMmc3YS9hdEVyOTlTNmRlL0lvQWN5?=
 =?utf-8?B?SGxZM2s1bkxOYlFQaVl2ZTd6SHQ2RzJMNXdFSnZpaVU3NU1ZMnpSWEtXbTZD?=
 =?utf-8?B?a21LbGpiS3UxYkFFeFd4N3dHWVR0clM4ZXJaWGtYZnBQRUtLUndSWUJJVk9k?=
 =?utf-8?B?bEQ3V3hpN0g1ZDVKWCtLcU80WFVrbWt2dlhMZnRqZWVTbkRMa25JaXVpTHFj?=
 =?utf-8?B?VEZkWTZlM2tUU0pIdE1xN25lRjJKTEVrWGNxcS9rcklCZUN1eTFIYjN0ZGdi?=
 =?utf-8?B?bkV4bU5TNXJtR2RYdVE5M2lZbVl6WDRDSUZBbDBBN1BYYmRGbXBWQ1Vmbys0?=
 =?utf-8?B?SnRsVTFpcytoSGgwcTI5cmFCYm5FcFJPSnByMWwvRzkwSGFmNnFJQlRHdFZn?=
 =?utf-8?B?YVZOZHRRa2MvaXRnVnVpTFZEcVhmSWtzNGhUTllRSGYzK3RPc3Z6bkZNTUE2?=
 =?utf-8?B?UkpuS1c0bW1Zb3oyTkZWQUFpVlJsUWp2NGw4WDFRQkJ1cUVvZHozSnFpWnZy?=
 =?utf-8?B?NURKTXdBQ0R1K0c2cXRwTHhCbTRkaktQNFBjWTJxd2FKT2VDUldZSlFselRL?=
 =?utf-8?B?UkU5cU5nU0g3QU9nT1g5YUlieThwbzBWRXJQUTc5c0pZZy8vZU9GQTJvN1d1?=
 =?utf-8?B?QzdueHRNbGdycXU4dnRyNEgyS3pyUnZkYVZyZ2lqMnBCMlRPN0QzMmlrODM0?=
 =?utf-8?B?QXFQbzYxMGNpUHl2UURlQjl5YzlhT3hKWDZKZXJBd2IzNGMzdnA0cHgyaFNl?=
 =?utf-8?B?TWRmcEsxUzF5bkJ5U0RDTEZ5K1lXS01hNVZkTjBrQkIvMElIakdDMmN0RC92?=
 =?utf-8?B?RDJtNS9JamhwZWd1dHRERVYxZU1lRm9ibHEzd1hUajFiRmRqcXFXd0w2Qjky?=
 =?utf-8?B?azRHY0g0L1p4T040NnVIbjRVL2tZT1BhRzVxOHg5TjBIZHZkdDh4dFpCL0Yv?=
 =?utf-8?B?aTRrcUNLNnU5dnVFUk1jclNpdkcwSlhYVldZeGpaSkpzejlEeC9nS1hkN0cx?=
 =?utf-8?B?MWkyN3NBY2Jwb3lTQnRDOXUwZ0UrSnl6Sk5FOXpucTAyWDVYYk1NWFllbVdW?=
 =?utf-8?B?SllIY1FrZ1JaMDFHRk9raXo5c0tCbk1BeGtJbFE4aUIydU9saGZ6ZllOY2Qz?=
 =?utf-8?B?cnpjellQeStzOENkSHB2bkxMSEpPRnJTOU8zWlR5YVFVQ2pGbWxjVXVsczlT?=
 =?utf-8?B?T1FCL1dIZndiakRtTEFyNlU0Yk1yUkhFWHVCZ21NSTFXeTA2SW9Ta0lCaCtH?=
 =?utf-8?Q?jqzkFj1Gg4aTDXc3fANzRNl8J/02tyjmhOeUycn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c5ffcc-5605-4898-be7c-08d8d9552685
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 06:18:21.6055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z+Gm4AvRADPFsMIbO4rYWQenp1dgNeEhtE8FUeFZlgW6zgpz1ROBIZ+4i84YdFPIhn3u5v48MMjRM6JvQao1WDDpQZUZ4DjwvQ1j05pGBXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3780
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250054
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/21 8:04 AM, Brian Foster wrote:
> On Thu, Feb 18, 2021 at 09:53:32AM -0700, Allison Henderson wrote:
>> This patch separate xfs_attr_node_addname into two functions.  This will
>> help to make it easier to hoist parts of xfs_attr_node_addname that need
>> state management
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Alrighty, thanks!
Allison

> 
>>   fs/xfs/libxfs/xfs_attr.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 205ad26..bee8d3fb 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_node_addname_work(struct xfs_da_args *args);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>> @@ -1059,6 +1060,25 @@ xfs_attr_node_addname(
>>   			return error;
>>   	}
>>   
>> +	error = xfs_attr_node_addname_work(args);
>> +out:
>> +	if (state)
>> +		xfs_da_state_free(state);
>> +	if (error)
>> +		return error;
>> +	return retval;
>> +}
>> +
>> +
>> +STATIC
>> +int xfs_attr_node_addname_work(
>> +	struct xfs_da_args		*args)
>> +{
>> +	struct xfs_da_state		*state = NULL;
>> +	struct xfs_da_state_blk		*blk;
>> +	int				retval = 0;
>> +	int				error = 0;
>> +
>>   	/*
>>   	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>>   	 * flag means that we will find the "old" attr, not the "new" one.
>> -- 
>> 2.7.4
>>
> 
