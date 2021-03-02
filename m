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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0436CC433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B46A8601FF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhCCDMV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:12:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44366 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346154AbhCBNCk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 08:02:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1228KaiP173068;
        Tue, 2 Mar 2021 08:26:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=77/n3lB+eSL8L7mi5FI2kY7JPtCxsLk0D/U8Pgfu3zE=;
 b=Geq852C4yAesCk6DMtb/pNm86f3v1EYp3acM8QkaT1bttoCuLMXQA+vjFHUfCYqaAeaw
 v8zKl7U3ALRGxOgiokNnlBZAjEQriujDazK+w6k9hUTV85YQemjM/9NSr+AOYi7d98u8
 +rMbU0UB3VE2Y4Xpwec1ZKXnH/9o3j/+lHPtOyrX2yxFXWxHs4eOAApaVO9fdUdeq/MF
 MHTpEa92oN9nqBfTt6K83oizj43NFImdgEnjLx6GN9TL1IVGnfPWWiLX2lfrri7lRGwl
 VKqFIFHPCSqwXPZB2yjepifrq87lEYWliJat5g1R+cxzCAMa10Erv0birD0Hp6q+5Y9m JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36ye1m6kpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 08:26:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1228QV0u140643;
        Tue, 2 Mar 2021 08:26:33 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3020.oracle.com with ESMTP id 36yyurp0rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 08:26:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7rSV8ACQXYXe8FeJAZx3f50eq/uGcjp7qjg8kieJQpBpeAAmJVmDNs3mturMbTqTWNe5EwNETrpVjOx1O+R8SZbXKyRpMb0+ApeEsgig8Htfc9lXivWR2k/RU8Oi5bl3aLejpOxYiUkG+sNVXuFRlEkuZEYHvQLWOH20WXMeSW0l7X285ayX3T2TVF+gAEJpRm6Xxk+A+rEcBHnnQbtw+eBbE8JfWlLhZ4FYyMD9y7yJaaDpPgJcQmTKmcrW0nojoA25/iDbIhMj/laKAWvSnq7CMSCRYseya1qj2VIaryRI3wLxr58x5v2empl7cdjgzEF0LkZYcW/Ikj89Z2P4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77/n3lB+eSL8L7mi5FI2kY7JPtCxsLk0D/U8Pgfu3zE=;
 b=Mqs85Px/8yRyTFNpkOIxq2KhQP4adZcMAoJBRZAOxZDqnQoGHSV0AqVm/FxFECgVTKX5c7RJCnup/m2GEcC3VFqWm8oEw4HpNkA2/egLRoC3EBI+VvJTcHZzpVrxgYA4WtXCSU7+GpGOe6fr1eCMaMAhe2fSfIT9IiR3BvkT8IE/p0vHoNM0NY3FGGorKDPzPgvzaSI0P8Hb2Mz2rxaqB97OGoJYIufRCcuKVx3nTg6Jo7bQiUPBv/9KETQUEtggA62PDBzlzVBF3IY1h9i8VWgFwwuh6MW0HZyMterEFVcqeONj+YDuNmNoQ338XsOX/nswScBEunnhn1a+ttD6FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77/n3lB+eSL8L7mi5FI2kY7JPtCxsLk0D/U8Pgfu3zE=;
 b=tDmZc9BoG5EqeYKlVWVcggmInY/VpYl7bWA0VIx8O3YgdOX99wU7o+CK23tAY0csNeV01oaFGCF4yjPRD/m1vc5m9zWLRXVJpu5P/wNn+mH1x55aV3GmUirzYEGYdcHC+h7ohRM/Dc2VXTmXJSKWYRXNoU6SREdIAlJAbnNh15k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3144.namprd10.prod.outlook.com (2603:10b6:a03:15c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Tue, 2 Mar
 2021 08:26:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.029; Tue, 2 Mar 2021
 08:26:19 +0000
Subject: Re: [PATCH v15 08/22] xfs: Hoist xfs_attr_node_addname
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-9-allison.henderson@oracle.com>
 <20210301180519.GH7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <7a33bea7-53bf-48db-4243-95fb384c64f9@oracle.com>
Date:   Tue, 2 Mar 2021 01:26:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210301180519.GH7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0318.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0318.namprd03.prod.outlook.com (2603:10b6:a03:39d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Tue, 2 Mar 2021 08:26:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e299553-0e22-4788-ad6d-08d8dd54dad7
X-MS-TrafficTypeDiagnostic: BYAPR10MB3144:
X-Microsoft-Antispam-PRVS: <BYAPR10MB31443D102FF5932AFD97CE8F95999@BYAPR10MB3144.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 49eHQ/XPwt5GqMJJs1hdBUEtw0cgWe9BYZKY1m8vp7czRpithYvOWLdsY10bzh6eaUfOuzH9RbC38B/sRJNZQ8go+bQFRGjvt29gtzLcqgvO42WQ+5XmXEvSEmwC9Zs47Gv6Ss+04kWTHKAKOx6oevK3YJou5eQr4Vh+Gj5IsssTKTlGJ3hPNF4iSRpCX9OV+a65mzz8Trwb8X3KXwlzaRSsdVtJfHpWjSr3p0FUXwMGpwEa6Ahorc4xfTAO/VS5mC+nrmzxGDRlyLWrqtSvKzcBVCLP01BBxyFkKIXE1waYFUf6OztP42SnXBztzctck0dl+zxEmNU7AF58YboSZDjufMobigILaoKpFNAxm3qcKKyJLn+h8KpBzNe1SCBfJhK5/goRrkgyRstaPpugz5+X6F6UGOG1wpqHD9GlY4GIvLrp686MBX9KxB/5H+YYB3cXQg3lN2NC2G9pLxlaO5oQ2FEsyvR4cEbqqL5IxB60oGPewKyq9ZKs31dv6d8KYzy+cmq+R1J44lo9Xz8xYSl/bublj87QJsboeTnR56FiqeENDKEYNOoaX3dyx8LRfEHjlBaDOq6a2sI4Eu99WndSq0TybOW3dGTqMTpcTcc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(66476007)(66556008)(52116002)(4326008)(66946007)(2616005)(6916009)(53546011)(44832011)(31696002)(16576012)(316002)(6486002)(956004)(86362001)(16526019)(8676002)(31686004)(83380400001)(8936002)(2906002)(478600001)(186003)(5660300002)(26005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?M2lVY2xwOHRPVEptWHhkWWVHSGVFNVFYekgrQThpWDVnaWtXQTVVeG1YUlgv?=
 =?utf-8?B?SHhDRm5ITmhaSlNRR1hZS0lZcUF3L2x5V3h5ZUxLNE5HbTVKdGcyOE9aRXJX?=
 =?utf-8?B?cXZtajJVSGZ2OUlkN2M0akxPbVpRcVFBbE1idjhaVmxkRDZOZW9hRGVpMXNa?=
 =?utf-8?B?cExXbzJuQ2VLUngyOCs0YzZLQ2k4Qzd1ZzBQWWZndE1OTGswd0daeEl4azVT?=
 =?utf-8?B?K3g2eCtoZUJyTlZ3VEcrYmh0Q2k2ampTOE5nc1NSVERLWk80UFZ3V3RoUmx2?=
 =?utf-8?B?eTVybkt0UzdvWHduRkRycWhmbUdKRVhza25pZVpBaVlpTWJWZXNkZlVobllH?=
 =?utf-8?B?WU5wcllJa0tMbURTWUc3b1ZrTlBBY2V1T09vZ2M2UnBHNDFlOU1McXRsa2lQ?=
 =?utf-8?B?SGR2UGZJRFFzSDk0SzJtUWl6SEpIdlA0d0Z3Y3JBd0FQNit4L05jSTN3R3FJ?=
 =?utf-8?B?YUY3RUE3VnpETDQ1R2RKK0psQ1JOWEQwbHZtSVFJSW5DcC9wb2h1eHY0ODl0?=
 =?utf-8?B?ZUx5bjhoTzF0Z2RqTEhzb0ZoQjU2ZHloWXpHSUhNQm02NmlJQmt6Z2FXck9v?=
 =?utf-8?B?YWpJVTRpVmhXQXI0dU1sQ1A2MzRHWUZlWlJjNyswL0xnRkdTSUhvNEcrYy9V?=
 =?utf-8?B?aWtNVlJydXdkcFVKa1FMMlhFS29qUEJza3VxcUJNZUM0RjN4N3JadEVwUE1R?=
 =?utf-8?B?cWlYSTg5cVFFM3JpcGZvSUt5Qk5OYXpPRk9tWldmbVY2cU1mdmVrRi82bUQ4?=
 =?utf-8?B?aFY1VVM4TEs2L0IzWU9lVjNnajEwNTltYTROMlRPalNRSDBHS1VCNlpWRkt2?=
 =?utf-8?B?OCtEdHZkaG1MQ3p5RFhxMWpmS29wdk9Od2ZCdzU2djR4MHBxM1kyUm04dUl0?=
 =?utf-8?B?MlZOeU0vMVRVNUxPL0ZCRFJ5TkpHMGNIejZuTnZoUFp0cFdpODNMSnhHL1RP?=
 =?utf-8?B?b3V2UXFrbDlGRm5TV3JXdjBvOXRvWTlrOHU4em96Zm9IWmYyUnp3N1V1T0VO?=
 =?utf-8?B?NVhGYTJoT2h1MUxiT05SOGhUam13aWVic01oVFJzZnRvejA4SEFlSTJWV0Fy?=
 =?utf-8?B?cjRLdldUendXaStEc0RsNTI1aGxGMXdHT0x4d2E3SGRNVFFraTFoaXBrRTk3?=
 =?utf-8?B?MjQvNGdPL212YU9TU0FSV0hadHpJSzVyY09XcXpXcFpqVkVZL3ordXcwQ1R3?=
 =?utf-8?B?cnA2T3hGRzBGRHRyNEo5R2ZwL3QrZkdibkNYbmlGVWw1cnY0TzRVR0xjYWV0?=
 =?utf-8?B?T1ZoKzhXUGpGMlZUeDV4R1Bma0xuUFFvZ09ycUE5MURydDhiR2hFOTJVVFR4?=
 =?utf-8?B?VW44aWwrcklRWlcveStQemhJYUNXdEQ5K2hsVkNVM3JXMFZIaXhQZ1ZSWm0x?=
 =?utf-8?B?NnFQcUVLcHh6U2tjRkxQalFnU043aHdTdUYwZnNnQUMrVHpaSjIyMnNhSGhp?=
 =?utf-8?B?Rkt4dEc5RVMzQ1g4d2EvOHFLKzl5VGpZRklYdFkvM0NwMmYzUXNQS3plVDJm?=
 =?utf-8?B?czNQMVRBMGdhNndkZUVSVXViN3ZoLy9FYXdXMkRrQjlLZTFMWkFYb1lFUm53?=
 =?utf-8?B?RVp4MnRFMmZRdXVDRHZ1TkV3T3pBU0JOMWZjTmRIUVRIejJ2S3JKM1EvZjIv?=
 =?utf-8?B?bXgrRm5ubFBET24wRkhzVFd0a3VWakR6eFhvSWRFSG40Q2tvMCtBZXppZE5N?=
 =?utf-8?B?WnZpYUt3U3l3akdLTWN4YUFKMVVkMXE2eFI4TkVybDlEQ0pWMUxGTXY5RzRZ?=
 =?utf-8?Q?NX9tzrTEoLBvoo4qPPMeSVcfYbTCDZ948LNSlZk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e299553-0e22-4788-ad6d-08d8dd54dad7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 08:26:19.3027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Kr6AhowD2lvltWuSzPaao9IjQNoy+GAOmsoDAEmJ/U9LTjrWM9AE5RaBc2b0joKY0GO8xg1Z5tDR2gC1iioBgUpn8pECNXNcmWgXt6O+4I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3144
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020070
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020069
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/1/21 11:05 AM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:34AM -0700, Allison Henderson wrote:
>> This patch hoists the later half of xfs_attr_node_addname into
>> the calling function.  We do this because it is this area that
>> will need the most state management, and we want to keep such
>> code in the same scope as much as possible
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Simple enough transplant,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Great, thank you!
Allison

> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 165 ++++++++++++++++++++++++-----------------------
>>   1 file changed, 83 insertions(+), 82 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 4333b61..19a532a 100644
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
>> @@ -268,8 +269,9 @@ xfs_attr_set_args(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> -	struct xfs_da_state     *state;
>> -	int			error;
>> +	struct xfs_da_state     *state = NULL;
>> +	int			error = 0;
>> +	int			retval = 0;
>>   
>>   	/*
>>   	 * If the attribute list is already in leaf format, jump straight to
>> @@ -320,8 +322,82 @@ xfs_attr_set_args(
>>   			return error;
>>   		error = xfs_attr_node_addname(args, state);
>>   	} while (error == -EAGAIN);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Commit the leaf addition or btree split and start the next
>> +	 * trans in the chain.
>> +	 */
>> +	error = xfs_trans_roll_inode(&args->trans, dp);
>> +	if (error)
>> +		goto out;
>> +
>> +	/*
>> +	 * If there was an out-of-line value, allocate the blocks we
>> +	 * identified for its storage and copy the value.  This is done
>> +	 * after we create the attribute so that we don't overflow the
>> +	 * maximum size of a transaction and/or hit a deadlock.
>> +	 */
>> +	if (args->rmtblkno > 0) {
>> +		error = xfs_attr_rmtval_set(args);
>> +		if (error)
>> +			return error;
>> +	}
>> +
>> +	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>> +		/*
>> +		 * Added a "remote" value, just clear the incomplete flag.
>> +		 */
>> +		if (args->rmtblkno > 0)
>> +			error = xfs_attr3_leaf_clearflag(args);
>> +		retval = error;
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * If this is an atomic rename operation, we must "flip" the incomplete
>> +	 * flags on the "new" and "old" attribute/value pairs so that one
>> +	 * disappears and one appears atomically.  Then we must remove the "old"
>> +	 * attribute/value pair.
>> +	 *
>> +	 * In a separate transaction, set the incomplete flag on the "old" attr
>> +	 * and clear the incomplete flag on the "new" attr.
>> +	 */
>> +	error = xfs_attr3_leaf_flipflags(args);
>> +	if (error)
>> +		goto out;
>> +	/*
>> +	 * Commit the flag value change and start the next trans in series
>> +	 */
>> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +	if (error)
>> +		goto out;
>> +
>> +	/*
>> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> +	 * (if it exists).
>> +	 */
>> +	xfs_attr_restore_rmt_blk(args);
>> +
>> +	if (args->rmtblkno) {
>> +		error = xfs_attr_rmtval_invalidate(args);
>> +		if (error)
>> +			return error;
>> +
>> +		error = xfs_attr_rmtval_remove(args);
>> +		if (error)
>> +			return error;
>> +	}
>> +
>> +	error = xfs_attr_node_addname_work(args);
>> +out:
>> +	if (state)
>> +		xfs_da_state_free(state);
>> +	if (error)
>> +		return error;
>> +	return retval;
>>   
>> -	return error;
>>   }
>>   
>>   /*
>> @@ -955,7 +1031,7 @@ xfs_attr_node_addname(
>>   {
>>   	struct xfs_da_state_blk	*blk;
>>   	struct xfs_inode	*dp;
>> -	int			retval, error;
>> +	int			error;
>>   
>>   	trace_xfs_attr_node_addname(args);
>>   
>> @@ -963,8 +1039,8 @@ xfs_attr_node_addname(
>>   	blk = &state->path.blk[state->path.active-1];
>>   	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>   
>> -	retval = xfs_attr3_leaf_add(blk->bp, state->args);
>> -	if (retval == -ENOSPC) {
>> +	error = xfs_attr3_leaf_add(blk->bp, state->args);
>> +	if (error == -ENOSPC) {
>>   		if (state->path.active == 1) {
>>   			/*
>>   			 * Its really a single leaf node, but it had
>> @@ -1010,85 +1086,10 @@ xfs_attr_node_addname(
>>   		xfs_da3_fixhashpath(state, &state->path);
>>   	}
>>   
>> -	/*
>> -	 * Kill the state structure, we're done with it and need to
>> -	 * allow the buffers to come back later.
>> -	 */
>> -	xfs_da_state_free(state);
>> -	state = NULL;
>> -
>> -	/*
>> -	 * Commit the leaf addition or btree split and start the next
>> -	 * trans in the chain.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>> -	if (error)
>> -		goto out;
>> -
>> -	/*
>> -	 * If there was an out-of-line value, allocate the blocks we
>> -	 * identified for its storage and copy the value.  This is done
>> -	 * after we create the attribute so that we don't overflow the
>> -	 * maximum size of a transaction and/or hit a deadlock.
>> -	 */
>> -	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_set(args);
>> -		if (error)
>> -			return error;
>> -	}
>> -
>> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>> -		/*
>> -		 * Added a "remote" value, just clear the incomplete flag.
>> -		 */
>> -		if (args->rmtblkno > 0)
>> -			error = xfs_attr3_leaf_clearflag(args);
>> -		retval = error;
>> -		goto out;
>> -	}
>> -
>> -	/*
>> -	 * If this is an atomic rename operation, we must "flip" the incomplete
>> -	 * flags on the "new" and "old" attribute/value pairs so that one
>> -	 * disappears and one appears atomically.  Then we must remove the "old"
>> -	 * attribute/value pair.
>> -	 *
>> -	 * In a separate transaction, set the incomplete flag on the "old" attr
>> -	 * and clear the incomplete flag on the "new" attr.
>> -	 */
>> -	error = xfs_attr3_leaf_flipflags(args);
>> -	if (error)
>> -		goto out;
>> -	/*
>> -	 * Commit the flag value change and start the next trans in series
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -	if (error)
>> -		goto out;
>> -
>> -	/*
>> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> -	 * (if it exists).
>> -	 */
>> -	xfs_attr_restore_rmt_blk(args);
>> -
>> -	if (args->rmtblkno) {
>> -		error = xfs_attr_rmtval_invalidate(args);
>> -		if (error)
>> -			return error;
>> -
>> -		error = xfs_attr_rmtval_remove(args);
>> -		if (error)
>> -			return error;
>> -	}
>> -
>> -	error = xfs_attr_node_addname_work(args);
>>   out:
>>   	if (state)
>>   		xfs_da_state_free(state);
>> -	if (error)
>> -		return error;
>> -	return retval;
>> +	return error;
>>   }
>>   
>>   
>> -- 
>> 2.7.4
>>
