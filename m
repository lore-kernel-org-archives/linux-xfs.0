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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F02C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFB32601FF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhCCDJM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:09:12 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46098 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377810AbhCBI3S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 03:29:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1228KnEM080887;
        Tue, 2 Mar 2021 08:26:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=grBCV0d20i+MVXX/dsSPvkfwXnbNLpD7vpB8U73ZmAw=;
 b=XI1DexymHJrYuf/sMaitoF7J/0KIiHrWMKsG4gsD0iUuWuzeshl4GTfm7ziFLMuaq1jO
 BdrT7VaMlfGyBSUWBU0YczedUs6HGdfBh7adHefVFz7rkXNpt48uYRCP70qoG6rRAYGC
 xV62sD3mev+L/DbBG7Qe03gNZyvreHT1FOCJcG0Ag6LHDS9NYvy3CaJVLqCw8nm12V9J
 QRust4ZZ3HHC+QXofjGEORA9JPnS+35pwC0a/ICw0HQtMYiGdr0t83qzIQIsxuJGj6v1
 ozWB4xvePhv/XL6hLVLZUpooe8EKgJXpSEPD+v5CkxsPFYRVtF224l3ql3gNA1Fputg0 Cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36yeqmxk1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 08:26:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1228QV10140643;
        Tue, 2 Mar 2021 08:26:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3020.oracle.com with ESMTP id 36yyurp0rh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 08:26:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcUf9H429oiU7v3tinLS4yYxyjiKNipCSp+Q8Y12gVkKlfTIiC0XhIkVla6t7YxbFcly5Xoo0rIRck4y35/fpYXBMm85FktMgMjepsgUKrq4bSOW7mn/h/wSu0SYlh+/7dFOVQ09TWTJKMFC0vD/ZdsMPVfXaMlhYEYwRUgimafdV6jff1XTBnbqyRsUs4NjJP8JvX52q3Bq9rS5LeGvMTOQJLQGHtqbxNpE3hU7TBuRaP+1BmQu3/u5K4xWermrG096XA8UoB4pvx5WCYjRfnMxnknlqSmhJQyqgPkg4uBNa/XXLCyLhbIQUl7/b8Y5AfhdoUXBqvTJlDkIWhdHuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grBCV0d20i+MVXX/dsSPvkfwXnbNLpD7vpB8U73ZmAw=;
 b=Pfmuw908rCz0oLW2muq057022a7k5oTmXgT6jbFXJZcChm4vA+RGseaozE+0BKgtrZsBwZR6jG2hRfHQA3Yi61J3Dydcy8lxH+4lX6JId97/gGghbwanlCnTHgq+f5H4NCPeSaxQUNtwFaaN139efvUptYcldk01kB8P3TfGdzL0Ky5xYvuktFJ9Jm1bQECEDg38zW8JH2uwzf0OT+A2P9/K0iUSmmNgTVIg28tqaSL6iNXqHlJvbCmF3pBEoIn9jG/u/+hKC/iBOTq2GrqfELLjKUXPBQVBe5tme8k9aK2orXhYZI7F68Xa+FXcuHUlNq9o5bBQRhx0CuOagZ8P5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grBCV0d20i+MVXX/dsSPvkfwXnbNLpD7vpB8U73ZmAw=;
 b=p1x+xX8hUYvcCRG00Hr2tlXl/ffw5U2Rv1Q8wb6buO97HHTArK/FjMm/5BWRwKa6NNGn8ondSF4VFJezDdU2eTZfZpkNUNHhUo6z6JpC1Zcgp+SCO2dhGW9P/fxE8wM6WtAvSW2YY5wfhLW/U0H6ws5q45wPnNoK9W26ubIRfIo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3144.namprd10.prod.outlook.com (2603:10b6:a03:15c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Tue, 2 Mar
 2021 08:26:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.029; Tue, 2 Mar 2021
 08:26:24 +0000
Subject: Re: [PATCH v15 10/22] xfs: Hoist node transaction handling
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-11-allison.henderson@oracle.com>
 <20210301182016.GJ7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <7043300a-3622-b47b-8061-8368afb906e7@oracle.com>
Date:   Tue, 2 Mar 2021 01:26:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210301182016.GJ7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0303.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0303.namprd03.prod.outlook.com (2603:10b6:a03:39d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 2 Mar 2021 08:26:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbd6c265-5b10-4dd3-be59-08d8dd54dde7
X-MS-TrafficTypeDiagnostic: BYAPR10MB3144:
X-Microsoft-Antispam-PRVS: <BYAPR10MB314402679C5479AF1BEFEAF195999@BYAPR10MB3144.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E6W9qCaou22n1EU52HxYAPBy/iZrJaeryaVVxnmKdVGlPh9ttxiYoX7YSFHNcoh/BJ7HlT/msCO1maEiBHD7G4PBh/ONYad8ZhSPWU7GUu+U8M2fwtKMWSjsdR7JmlFeCZHzQU8A1E3QlQaBSOwxc8oo/wQg5v9rp9N3HYGgCAxru4mRKjYLgbrIirO+jv7/OwfCqgW/ijPQ8zTFATgRVCOfT8ktWHT9sCZWFuu1n6pPCbzhoeLU1fzH0ah7UeTSIpswpBGLf5Y6GFWqKdQaZjrroQeOT95yZZW8hzECBJT9O0ZVj/XxO+w0WM5gHXipRH7qSrDFgvuOBzvjkJG9XHgkWFilxtdQBMiUvgGUGL//nlQwfOlrzt42MT9wkcTf5/H3j4HYvjC8/4UfIgy3HFxHLu0p0QJxurMtzKCa63Kr3MDSIcymhyZ5dD6c46c9mfweW49P56Fi9Q/m2uzl7xRQ/Z192tz196NmI1inapwKPfaEB1BkJscBa4Nbtyl5WyMFNyUl7bnVCZXTTZIHpwFdl5XpG3D4sxJ1toPi1UWfMrulhNFHTrpe179PhLlj1LS0TopK6JVTavta55NjEKEk30qsCMT6/tMVfO4aiiY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(66476007)(66556008)(52116002)(4326008)(66946007)(2616005)(6916009)(53546011)(44832011)(31696002)(16576012)(316002)(6486002)(956004)(86362001)(16526019)(8676002)(31686004)(83380400001)(8936002)(2906002)(478600001)(186003)(5660300002)(26005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S3p0Z2ZlZ0JIU2dYS1BjekREMFhiOG5EbzVhS1djUjBqRDcxZ0d5WmJhcWhl?=
 =?utf-8?B?K0JQS3k3VHhqcWc1alA0dzFOUDgyaDZxU0pWZWQrdDBRSDFhbXVleTQ2SlpV?=
 =?utf-8?B?azVCcHV3LzBENGw3VzIzQnBKQjY5WEhMWjk1ZGxpSDM2dktpMlBDYU13YWxy?=
 =?utf-8?B?SWw1ak9XejRRRndvNGxTdHpwaVpSNlRXMlJXbXc5eGdYY0NwUjhWTE95NFI1?=
 =?utf-8?B?clpKYnkxOXpTbVd2ajB0Wm5qNzRlYXhQbW5sekJXREJ1WEJNT3h0dGtvZzJR?=
 =?utf-8?B?SDExak5tUVlXNHVIV04xU3lpaUZXcHFwdm82WFpOaU5TTDZVa0NEUzk0OVlJ?=
 =?utf-8?B?RzRGOVV6WnBCQzl5aXoxdVZMc2pkTU5iTnVCWHFRakdzWTVidVZrZldkTEtH?=
 =?utf-8?B?RW1nSXhpa0xwOTBkU2NHV1FyVXBZd2xXL1BYN0xmUFQvUy9yd3Z4L0pVOS9U?=
 =?utf-8?B?NVNIaVRLY3V2cisxT2NuRmlRcVJla0Evai8xNDNFMTFhL1E5Rm5lbFNkMzUw?=
 =?utf-8?B?c1BKQnROZ1lNR3dkSm9ZVng2Z2xUalp0c2tPNnRUYnE0dklHKyswSzZNMDJk?=
 =?utf-8?B?NHViVGdldG0vWXBIMHZpbXZJS3drT24rNUxkMlUrbjFlTzhEYVdPSy8yall6?=
 =?utf-8?B?RUtEdGZQV3B0LzYvcVkwdS9XN1ZUVTkrcWU0elNhSndTMjZoOXRjaXpOWXg4?=
 =?utf-8?B?eGllUjA2NzVLbGdaMDhBUmh4bU5DNk51cFlkVERQNCtON2J3Yzk1bHEzYXZ6?=
 =?utf-8?B?L0RMVGRJdWUxbGxXMC9wcFRpYkc4ZHhJeTRhbGdBeHFJQ1M0NVc2QzJGdHRB?=
 =?utf-8?B?R2o4bVdjaGgxd1FpcUdOeHZ4UVI1RGN3N3Z2NGNKWmNXQWhCNFVZUDVhY1dn?=
 =?utf-8?B?eTFiNXY0NU16T2hkZ3ZzY3JRcFFkbW1BYXJjVWNHMkhiUWdTeUk1Y1FjSlJh?=
 =?utf-8?B?VXI2ZS9RY2tZY1Z2MFcwamJsTnNiY0F6d1ZLMTNvWEYzbEJLb082UE0yVTJ5?=
 =?utf-8?B?ZTJzTitrVXo4MjMwN2NacG5mNDRoSXB0emMzZDNmRURwN1pXWjhBeXhDSWt6?=
 =?utf-8?B?YllJQklnVnFvRU51cGRpUW9kWWdMd0tFUUNIaWF0YTFUN0pKUmRoZDMxRCtG?=
 =?utf-8?B?K1B2RGJLSjFndDNyVVpjSjExZ0Y1cDlvNXJ6azc0VGhSZ3J2OW5lMUs3d2ly?=
 =?utf-8?B?dktQVTgxYzhSM3R0Rjd1STdIVGpVNWk0Z01rWUR5QU9iQmk1Qk5Fc09OTEYr?=
 =?utf-8?B?ekMvMmVIYnNwT21aRVo2NWh2RFR3L2pQTU1WUVRyQkpPK1Z6bHhmbVZIQmZG?=
 =?utf-8?B?MU1SMEZvM1VGeGFrRGZUZmdKRUYvUjVjQlpxV0lRNHRZQ1dhc3JkeTVRN09q?=
 =?utf-8?B?V1JkOEJITjkvS3NaS3A3dHRNRzh0UGxJa3lJS0o0MU52Qk1leUhQUlpHellZ?=
 =?utf-8?B?aUMvNmNSVTEyMHN4WWlSVVZ1Yk8zK0lJNTZUUGlyaGdaMVBGaEcrdzdhaEdj?=
 =?utf-8?B?aVk0ancyREhKdXlKdVN2a2dYdzRXWGFXb0pQcUdJR0JabEx4ME80bjlKcWN0?=
 =?utf-8?B?VisreXRROHpWbElXYTJSTXFBaFA1K3NpZDZNcjdlVnVpd0tKbzA2NWVVQ09I?=
 =?utf-8?B?NXU4WVpEZHlNYkhYaEZIOGpEeFBUVnpyYnRLTEJLR01FSmJPK3dFQnlEajNU?=
 =?utf-8?B?VTloTjdTU0NhMERBQ2N0NDc4a2dtOG91L1YvZUVYeXk1VDRZSmswY3JCZGNP?=
 =?utf-8?Q?HftuTBoJZaEbtUQWLvVA+MgD6bezLb9W+F1Coux?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd6c265-5b10-4dd3-be59-08d8dd54dde7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 08:26:24.6731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TMDcpCVBe1iGUB/tjCmvcdRjt958zoGUt5tH7opbCzEYWRzqRHjDkK8BmKO7SvLDqQWcRPO/BxY5SrmbzmTOOEOHKiTRqqlP/lgoy4UpP9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3144
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020070
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020069
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/1/21 11:20 AM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:36AM -0700, Allison Henderson wrote:
>> This patch basically hoists the node transaction handling around the
>> leaf code we just hoisted.  This will helps setup this area for the
>> state machine since the goto is easily replaced with a state since it
>> ends with a transaction roll.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 53 +++++++++++++++++++++++++-----------------------
>>   1 file changed, 28 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index bfd4466..56d4b56 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -288,8 +288,34 @@ xfs_attr_set_args(
>>   
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>   		error = xfs_attr_leaf_try_add(args, bp);
>> -		if (error == -ENOSPC)
>> +		if (error == -ENOSPC) {
>> +			/*
>> +			 * Promote the attribute list to the Btree format.
>> +			 */
>> +			error = xfs_attr3_leaf_to_node(args);
>> +			if (error)
>> +				return error;
>> +
>> +			/*
>> +			 * Finish any deferred work items and roll the transaction once
>> +			 * more.  The goal here is to call node_addname with the inode
>> +			 * and transaction in the same state (inode locked and joined,
>> +			 * transaction clean) no matter how we got to this step.
>> +			 */
>> +			error = xfs_defer_finish(&args->trans);
>> +			if (error)
>> +				return error;
>> +
>> +			/*
>> +			 * Commit the current trans (including the inode) and
>> +			 * start a new one.
>> +			 */
>> +			error = xfs_trans_roll_inode(&args->trans, dp);
>> +			if (error)
>> +				return error;
>> +
>>   			goto node;
>> +		}
>>   		else if (error)
>>   			return error;
> 
> With the braces and indenting fixed the way Brian said,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Sure, will do.  Thank you!
Allison

> 
> --D
> 
>>   
>> @@ -381,32 +407,9 @@ xfs_attr_set_args(
>>   			/* bp is gone due to xfs_da_shrink_inode */
>>   
>>   		return error;
>> +	}
>>   node:
>> -		/*
>> -		 * Promote the attribute list to the Btree format.
>> -		 */
>> -		error = xfs_attr3_leaf_to_node(args);
>> -		if (error)
>> -			return error;
>> -
>> -		/*
>> -		 * Finish any deferred work items and roll the transaction once
>> -		 * more.  The goal here is to call node_addname with the inode
>> -		 * and transaction in the same state (inode locked and joined,
>> -		 * transaction clean) no matter how we got to this step.
>> -		 */
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>>   
>> -		/*
>> -		 * Commit the current trans (including the inode) and
>> -		 * start a new one.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			return error;
>> -	}
>>   
>>   	do {
>>   		error = xfs_attr_node_addname_find_attr(args, &state);
>> -- 
>> 2.7.4
>>
