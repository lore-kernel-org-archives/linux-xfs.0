Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8866BC433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C39E64EEE
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhB0At2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:49:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42240 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhB0At1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 19:49:27 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0jDhm121032;
        Sat, 27 Feb 2021 00:48:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=34qoNMl7Mn/EV9/Cwmkfs/MW41kf82NEzMBH+nNODcA=;
 b=L54ARm7bs3SwutMR7zZM8R1K7i48btbhB7CyEIO3nVAFqHGwAr10evuH4ET2RRuV6yU8
 S2f0lD0BxY/GWhnjZI0eXwc/cdI2kmg5x2sR4nIRJA4y45OVeO228soR5QkdpIE3J+5o
 iQ6Z+fJBbIRCT8cpKwwEcSA2Gs3M/IXQlAW76Uo7Is9SEfgopMncJ5dGhgcA0HlNLeBI
 hF+kQzJOl52VnvZJ1oV+oBLvlVtLgyViEbDLpwEdkVhfZwmfVMYx4mZEHeXoTVCrE70C
 tyiP+s4qBV7ppmM31GFEd7rBoWWiO6XWYqF6HkzfmsPmmCCvK097z3pZFHxQ4pw4nl/w 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36xqkfb6su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:48:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0kY2o106666;
        Sat, 27 Feb 2021 00:48:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3020.oracle.com with ESMTP id 36uc6whq9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:48:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RW/Qys+0R54MQtMcluM2s29DpyR1LQGVgSk9CSZUHWv0xSrtunbR8xLRszg2g9e+6d61UpycurPpExnGjp588zQZ2H0DIK/1RRoQ1yoLFRoIm5OOGd3vaT8fZkQxbRNkOL6jznFbqcy/MXBbKXacbuN3gg12f4BFwVQsV+OdI30PgOOzq8XeRbAXFK9kKXrK/5HFqu0ANo4Q+ETdqiio3q4BvprAycDzzTnhEOIcl1Yiz5iq/4+6BkRTfA3BpvLoMUwAgzuY/d0iuUTRW+99mWIcLQ91elgBMQKeJuecx/GPrFQOkMBlNmv7qPRGYBmswOqWigYKvhkYnnLhA9HZxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34qoNMl7Mn/EV9/Cwmkfs/MW41kf82NEzMBH+nNODcA=;
 b=OqgcISXeEpxfrG91d9wjQu/qR1Da/74rEnsFB2dYpwji/jtkgi0j3zNZHVi9kNlEipjxGjiVVf3VElK3iGpq2pp5Mvyb4cEKaRegBq/ynXIxk/iNptEhJdTL9QchkosThoj8W+sVK2wMGbaE2F1VsETzvF1qjxDBqhapOI3MPJR6H1lMqhTmKxt83EpRIrOmiRbo97yv7ZjL8GPvyWv9l9m6GXN998R+XptupHHSu5xMxoGFRyGBvrb3Elo2kOU0I/Fk+UyXyrKfw/o04Yk7Lriz0Sdj6hwZkOuBgCWhPRCwBrB/ltmpzDWaJnhvwqNvD8e8RJ1I9E0oYnP1H96AtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34qoNMl7Mn/EV9/Cwmkfs/MW41kf82NEzMBH+nNODcA=;
 b=j1B7R3hQ3oNlFynppWdWG3D3VRocjDz9QW0DdF5B6eeI1UtW1VVHddFarqbkMN7Kzg6+z5n0BSDsuptABVqrSys/5Ajjxm6dAU41bIbmOgiBfqtIu0YiR64woFvv37ZTD6wgdbS4g7atc275U450TVay378Yub4VlDdfW/Y8hrk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3335.namprd10.prod.outlook.com (2603:10b6:a03:15d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 00:48:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Sat, 27 Feb 2021
 00:48:40 +0000
Subject: Re: [PATCH v15 02/22] xfs: Add xfs_attr_node_remove_cleanup
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-3-allison.henderson@oracle.com>
 <20210226030009.GP7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <bb918398-0822-8ae4-5988-c5c288302940@oracle.com>
Date:   Fri, 26 Feb 2021 17:48:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210226030009.GP7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR13CA0157.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::12) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR13CA0157.namprd13.prod.outlook.com (2603:10b6:a03:2c7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Sat, 27 Feb 2021 00:48:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a11c242-33ba-4171-4816-08d8dab96c91
X-MS-TrafficTypeDiagnostic: BYAPR10MB3335:
X-Microsoft-Antispam-PRVS: <BYAPR10MB333502024B997BEC4992D971959C9@BYAPR10MB3335.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jOwnmyME3wybQwmVn7R2OjgTHPRoHrgsLf37xyg2OjxmV8MYbwH+mXURUugXEgbP2gGSDokklNOdhGEBv/CRCfaEuKkIa3qgx6lhgyoqg1H/q8/b2Fcm12Kn6PzNOpNjo1x3qmA2XmdpDIG6wVk4HnOnOT9BVPvGcKxaj6KYibqyKIp3W7Bv0+8kxaQe2X9odNATiSdippewjv6HO/ADBJ0CxtsSdr0to9VI0fUoxQDmR0yzWID3Nf4U72Me887FMb3Pz1cMyNj0Oki21opr7MJz+2mK1kWBROz46hV5/SFLi4cnltNAW0LLMnoFWhJJcM2/Ln9BaJVw5OlEYV8vvMA/rBJ4YIJkN+Lz178QP5Xg0Xrd8fVeUVdGtJvyQDsYAYdVWsFYcRtSMMCdiOB15x5+9YNVGDQOVOpMzF7+mTt1rzpO+9q2D9ytip4YkyaJzPME/n3Id/3zMwLYvx2tSMfLkDVl7DFIedJJvHJlueVQhCOY8V+ePIXI2vNWwsiwfV3IDGHWP7RhVjzrkOw8vc/ZwEbhzn1ub+HR20Z1jd4DjRNw/nTXx9UuuizcaM6kosZNrju3XBaFc86IcGjZEPfOk0HyTtNoYC67guhMBF4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(39860400002)(396003)(8676002)(31696002)(26005)(8936002)(52116002)(66946007)(2906002)(66476007)(36756003)(5660300002)(6486002)(44832011)(83380400001)(186003)(16526019)(53546011)(6916009)(16576012)(316002)(66556008)(31686004)(86362001)(4326008)(956004)(478600001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NG5GMzZ0ZHMvaFcxQndFRkp5NW5XSHg3UWJkN3R2UFY1OVRTUjlGQWlaLytC?=
 =?utf-8?B?V1BLYUVEWUViSzdSYWRBY3Awa1JzZUJmZ2dTUzJtRENqRlhHZElQOTVxT2la?=
 =?utf-8?B?NVpzemswaEloekZzZmtaeXFhS2JDNnNMejF2Y3diMjlkVEIzNWovSGlPR2tF?=
 =?utf-8?B?RDZYVkwzS09OSkwvUDhuODdGaHp6NklkSVAxbUtGc2tQK0ZLYkRMZzRkcGov?=
 =?utf-8?B?Nmt4a05lb2FmWnJkQlc5ZVVEN3NNYUxKWXFZUEVjWnpBK25WMWRMRVhvclJH?=
 =?utf-8?B?d3NPejBsOENUc2haMUN3UkhBSlZLdm10bTYvMmN2dFlyV1pKcXZCYStkV1lR?=
 =?utf-8?B?SGkwcVphU2x6bk1oVzBvZ0kzVEo1VnppajM1YWJnUDJtTjFjU3dYdFA1NHp5?=
 =?utf-8?B?YWlGaVFkWCtFSTJxeGxqN0RhZTFhM2JCejB2cFFwRzFmNm9QNFJ2MnRQa0VS?=
 =?utf-8?B?cTB3d29RRUhpaVZUblpoa0NkeDlkcTh3eTltOFgyTmNGMzFmMXgrcVI1bDR1?=
 =?utf-8?B?RWoyWU1iWXNRejJnbFkyY3FRMExzSTlibVlwQVYyaEFNMXQzeFR1V1AxNUxF?=
 =?utf-8?B?UnZaL0x0dmJwWnNDWVUrTVE0NE1tYWhSZFVuNHQzZ1J2SXFyQ3dpWEVMOHBo?=
 =?utf-8?B?aFk0SlFiN1dHdTgxWDVMQVNsOXp3RmNYMkFwRzQwTkI4ODhtQ2YxdVNaaTVY?=
 =?utf-8?B?YjlNM2UvN1M5VTEyYXhTZmVwS0xZMmFSM1B1OUtEazN4RzlEd3pYODdSU0p4?=
 =?utf-8?B?VVhQcnhxKzd1YWZSaTdKdVlHWG9wNEpaWjI2SVRMRkNiWjQ1OW0rS1Y4MHZa?=
 =?utf-8?B?NWFYekNqZEQ5dTRSL1RzVGRVbVJ5eW5RM1B2MnQzZFU0YVF2SHBicnk1MThY?=
 =?utf-8?B?ektrN0ZVQ3g3T1RkR1g5UldYVzlYNk9IZmxvclNhM0c2YllLTExFK1FSeXkr?=
 =?utf-8?B?Q3JTSzhLZlBLSXlPbWJWMmRKR0R1cG1Lclh5U1pNbis3aFZOeXJQbXMxWmkz?=
 =?utf-8?B?LzU3TFBpazE1RUR5bzF5c1ZpbVNGWWk1blVyWTBhQkJwTDIyYzlzdkt1eWdC?=
 =?utf-8?B?bDl2bXJnTEVkazgyRkZTVXFaL01iMUt1NnF6eDViWW1DV1FOQy9RV3JubjRq?=
 =?utf-8?B?dEZWa2hOVXE2R1NLQnd5SzFCZzRJcE0vMjlVV2NyOW10MWtBeVRGaHdERmR2?=
 =?utf-8?B?eHI0Smk1bXBETnI2ekMrY0MwRm5hSzNUTXNGSEt5cDZFeTJzYUt0OHFpaTZB?=
 =?utf-8?B?Q3lVd2RVUzlDazQ4NEdMRUJka0Irc3ZNRDJkTXJGQWo1K2VKWFU4bGFaU1Bo?=
 =?utf-8?B?RktZcHdSVWIzMzlWc3dBb3JzWFgzTkhVS2Nib3FWbElXQW9xR0NLbzVlZm9K?=
 =?utf-8?B?M1A5U0tzdGhDWFFIVG5qRW9Md2o3YjF5cEJXVEs1RVZjdnUzQW9Rb3hVN3ps?=
 =?utf-8?B?cDA2cWx3TnFWVUw0bDhWMXZuTHh0TWllNTVyNHJVUXJZQ0haRHlCbU9XR0xz?=
 =?utf-8?B?MG1NS1ZYZXF1VitDWXY0NlNxRDA1cW82cUtqcitmazBOb3lmTms1NzlZRmZp?=
 =?utf-8?B?WWZTNUNuakVuNjZ2aVRwZkYybEJxQWg2QU4zMnZVZ1E0YU41Q0hwelRIbGZj?=
 =?utf-8?B?MTdpM2lKVmlnUWcxUmhBcFlpcVExSk5LOHREaEh2bnBiaGx2MDVDZjBrb3lo?=
 =?utf-8?B?M0hsYVJQNDQrb0ptclBtQUErMGV2NkJaT3VmdUNITXFwUkkyamE2ZHVBU2Nm?=
 =?utf-8?Q?9ZqPcBRyv1B5Vj9SmHss97mjrf2T5mbxUIozVE4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a11c242-33ba-4171-4816-08d8dab96c91
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 00:48:39.8987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nmYJ8c7x6tnhEbXGGJnzNIFk2G3iFbKkkA5/ySmg6HyoyjcECf3YNtxl2IEvyBrnmb6PhwL31xLvZd9VE51U7MNnk5X/QlEn+Yx19YzLb4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3335
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/21 8:00 PM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:28AM -0700, Allison Henderson wrote:
>> This patch pulls a new helper function xfs_attr_node_remove_cleanup out
>> of xfs_attr_node_remove_step.  This helps to modularize
>> xfs_attr_node_remove_step which will help make the delayed attribute
>> code easier to follow
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> 
> Looks ok,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Ok, thanks!
Allison

> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 29 ++++++++++++++++++++---------
>>   1 file changed, 20 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 28ff93d..4e6c89d 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1220,6 +1220,25 @@ xfs_attr_node_remove_rmt(
>>   	return xfs_attr_refillstate(state);
>>   }
>>   
>> +STATIC int
>> +xfs_attr_node_remove_cleanup(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	*state)
>> +{
>> +	struct xfs_da_state_blk	*blk;
>> +	int			retval;
>> +
>> +	/*
>> +	 * Remove the name and update the hashvals in the tree.
>> +	 */
>> +	blk = &state->path.blk[state->path.active-1];
>> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> +	retval = xfs_attr3_leaf_remove(blk->bp, args);
>> +	xfs_da3_fixhashpath(state, &state->path);
>> +
>> +	return retval;
>> +}
>> +
>>   /*
>>    * Remove a name from a B-tree attribute list.
>>    *
>> @@ -1232,7 +1251,6 @@ xfs_attr_node_remove_step(
>>   	struct xfs_da_args	*args,
>>   	struct xfs_da_state	*state)
>>   {
>> -	struct xfs_da_state_blk	*blk;
>>   	int			retval, error;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>> @@ -1247,14 +1265,7 @@ xfs_attr_node_remove_step(
>>   		if (error)
>>   			return error;
>>   	}
>> -
>> -	/*
>> -	 * Remove the name and update the hashvals in the tree.
>> -	 */
>> -	blk = &state->path.blk[ state->path.active-1 ];
>> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> -	retval = xfs_attr3_leaf_remove(blk->bp, args);
>> -	xfs_da3_fixhashpath(state, &state->path);
>> +	retval = xfs_attr_node_remove_cleanup(args, state);
>>   
>>   	/*
>>   	 * Check to see if the tree needs to be collapsed.
>> -- 
>> 2.7.4
>>
