Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A621C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 06:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiA0Gps (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jan 2022 01:45:48 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64162 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234487AbiA0Gps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jan 2022 01:45:48 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20R1PKWp016830;
        Thu, 27 Jan 2022 06:45:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=m+WnOcdIPD+2ef/GmEp9EGN7owSxWNwFgdrCmUqjQiI=;
 b=qUJXR5/0dmBoZ6AmjkioYTVGJ32EPDd+aDWk3e3VXqFX8cQEklCfCWjzF5vP75CO9C1X
 5jCH+ifnRO5EcQ0CtWdKlnryLCSofYZl4rIS7Xuv7NULeHqFJt7+YboFJwtXNoutjxsr
 /Zl9wlb7a9P/mUKptQ9fYATqvMy5w/dO8/H2Q43L+OgtBzNM6uyLv9lG24c8OVHOd20J
 VHHnomI9i/binEpyc6m1G3cz1uLZ0WFTBl5EEeu0wMwP7cN+2ZNXe3EmKQHinrwHgI4t
 +uZBXV2zhk3DNDzFkCEVme8eXY35ru21vPbZzD5nSsybsJU6f5bFrv8qU0rqS2CQbd+R YA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsy9s87mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 06:45:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20R6fMQc083326;
        Thu, 27 Jan 2022 06:45:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3030.oracle.com with ESMTP id 3dr7yk4ju3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 06:45:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBhk4Y26LSZtwNF9V4SHZJcwHrsqX6gZfJmIPjgJKwEZ9lksiX94kHPDNfcQQGyN6eWLUylWjVvtzWJamy09Bmfv0hR+uXVQ8AX3dfUdIOYOH0HVZtTvsiMJYG/9ThF9/YKvmeFm+phmCOU2CVv6KHIKX/c0WpAhwO8/mETOvi7CDVUFLg2lCko8yZKDM2qBEYElBQqvK0YbqgdQEo5SxaN2lN8xSDaWPAzf5+Ts5Bsu4x/uxnoVrcolLpQxckwAF2RMTYmRftJSN0RurN4BrhCLsU70qxeyKmpcVO5kRUt1gK3V50t6lyaYPVwzcHB8BTHbl3TDuUdUrSMgPOIl0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+WnOcdIPD+2ef/GmEp9EGN7owSxWNwFgdrCmUqjQiI=;
 b=H/mQnwV01yYASkkz1LFM/We+P1vxW6+0xXYcHvgJhm0wd02/LwjxCSn+S+ppNBU+l6IVy5JopVu8eF4qYaoGmewHSZsA2YENqgbMK+T/WXQI5zOGyLxV5o7ILXFAcXzo3anoBtGfcC+x2o32mHINY2r3TW6cj2QSKP+bqMyFiDS5Yfb/EOh15f9MZEHUvShfrsExAJW2ZshjhVtOvVVWHrI7XcUnLnNSN8kGAGO/KXdojl5Q9LO/SwcH88U3nvxkugBcZlLbxVvJb9XqQkDvN0WexEthX6TVYAC8IcJOEeTYro7P7YZHSdlpcr8pLzAxxPd/qv3XS42XahFw8y4whg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+WnOcdIPD+2ef/GmEp9EGN7owSxWNwFgdrCmUqjQiI=;
 b=hUwrLq62PlQ6+KOGIRArTYhuVGfFqkNFvQ5GjENd+ZYUtGpqlNVbJXjz/O03fHjaOM8r0pVpvSXeJlXhxCk62Ycnb8ZliGUUgzx6L8XhlxnFcN5BeIIEHKQMadktXaOr40xF4x/64ljDgwf4ad7JG9PTsrq+leBqOjgLJNT0MW8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR10MB1771.namprd10.prod.outlook.com (2603:10b6:4:8::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.11; Thu, 27 Jan 2022 06:45:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%8]) with mapi id 15.20.4930.017; Thu, 27 Jan 2022
 06:45:42 +0000
Message-ID: <3d8eb12e-ab2c-9ab7-304a-ca0e3cae4444@oracle.com>
Date:   Wed, 26 Jan 2022 23:45:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v26 02/12] xfs: don't commit the first deferred
 transaction without intents
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20220124052708.580016-1-allison.henderson@oracle.com>
 <20220124052708.580016-3-allison.henderson@oracle.com>
 <20220125005205.GZ13540@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20220125005205.GZ13540@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:510:5::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1420bcd-be5c-4769-c183-08d9e160a319
X-MS-TrafficTypeDiagnostic: DM5PR10MB1771:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1771200146000284A6F4D2BB95219@DM5PR10MB1771.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bkalL8OGswKYvWwrgc/Jr0eRNxtqDveMJbsiq5rwTdtnLgi9XsgeRjcYu5ziiGfbTD5dO6pkwLu/6Gf6MCRvf+GZfT7QmGs6SC/EUIRsz03dAfE7G3UB2YW1Z5pPy79Bukh0bXNiXcoAVfdSHY6krKo4zZ3hwpNV9ru8ySM+wGViEuXSJ1iHr0y63UZwU5r7klHHFfWFJS7UnbQ7nzNB40T1U+9FQpK8RVd5XgtL2+TliREAEAqotlaxZKr+YO25AiP5mqXLM8iKAMTnep7HagZW5bTSMwODzrTD95ImuD/xXXLVtrQBaKuTqbNmHVVJHnwXpAPjCi0BJ48Ri/2nBF3cMdE4GfMr/xfzzOVCa0zzMFJWCPRm/KGtF1O9M1zgOQmPwAe/xboDNK7owen8notwMGS741n//r9AzFmMBp7BecJHsPpgj8YTn8MsvqLCOpyG45oWvn/Dh3PR9wIeVxmgaIaPClq82MU2ekfeGNCGJjT3nWNNAhima2KnJfqqCxVJ7o39bPGkdsN4ljkXKt1xvNBU7QpmH+Uj0cL3Yr0RZwdKC5vjT0ZXxQ93xk3aFfaS2CjiRQSpi+iAtCO4KJx2QljsTL/0z73a3rxJlKNPSVSDPzUG3S6z3mJGXg6U6Gli78RjKC8UFP/LI1dJ8hhvoX9YVCNdDgk/wmY4B9Q1eXrRirKxrI/8dv57BmZgdjQsUAZLJwWiKFvAf331AD0Z0HHT4XhNTEwZ/1BoR72xZ3HvMsVK4zcDNXX9OWLI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(31686004)(36756003)(26005)(316002)(508600001)(186003)(5660300002)(38350700002)(6512007)(44832011)(66946007)(2906002)(6666004)(6506007)(2616005)(83380400001)(8936002)(52116002)(66556008)(4326008)(6916009)(66476007)(53546011)(38100700002)(8676002)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVpkR2I5OWJxS0lHdis3U2lHTnUwR05EKzlhN1NRajdQZmpodWlQSWtHSWhq?=
 =?utf-8?B?NlhPVjFWYVlBdFBNdEVBYUlMSFMvSFRJUmNvamFBTHhXZWw1ay9tTmxPN2kx?=
 =?utf-8?B?eHN5UTNSK3dvRlNSUStBTk5VUkU3Y24zTEhMTVc0eDY3WXQ5NzdsUkdhVjQy?=
 =?utf-8?B?ZHAvUFRyL1FPSFlWN0k0Tk1EbWtIWC9ZeWtzeW15WXg4MHZYNjhXTEFkMTRx?=
 =?utf-8?B?dm9nQ2hRM3NVUjFXaEtUc3hiKzhvbjlacnpidnVaWnNvOCtydmNzdVNBNzdO?=
 =?utf-8?B?WnVtNU1aK0pCa21VTnd4OGNhRzJveHJjV3NoQTRaY2JqV1c0UFN3eithRC9K?=
 =?utf-8?B?K1RlZjBlRUhWRmpyMzV3MFRpUCs0Rk1lV0Z6clFRMktvZUZQSnVpei8rdUxk?=
 =?utf-8?B?cW1JcmVBdTJSRVdzYU52cUNLVHowZUxFNkNNelBvUHdGcXRmYkh3VkNXK1Y4?=
 =?utf-8?B?VDVZM2sxcGM1VUo3SmlTbFJkRXJVZy9TSUVYOEUxMjhvd2FoaTM3a294SHV5?=
 =?utf-8?B?SWdYNHhwWjZuV0d1OXJWYUJGVDE1T3lrMkFmTXp0NmQ0NHVPeVFZTjAyRXVh?=
 =?utf-8?B?VHVYNGE5WEIxKzdOMmczV0ZUbi9NdVExckRURkh6VHhMeHdGNmZkZmZqODkr?=
 =?utf-8?B?Zk5BZFZlQ2JMZU9OZy8rMGY2Mmc0dDFpMXFFVFd1YTYrcUV4VENhV28xWjdS?=
 =?utf-8?B?Q25jVjBGMnBVeFVUVDlOTjB0M0FaZEFVWXl5cmp5Q1U3VllSbU5nT1FhWDUy?=
 =?utf-8?B?cW0xcWxIRnFnRlZEaVZDWVNoRGtrRFk3WitYM2J3RStOdnN0YlJCV1FLbC9E?=
 =?utf-8?B?b244cGNNVzNkVFduTDVhZGlIK093cmM0cGRTSWlrQW5LdkJBZnVIZjBUUDhj?=
 =?utf-8?B?ejNJZE1HUHhoMEZCeElBcnVCMDFGRnpmbWZobEZkQkRFMjlNQ29HKytabEVv?=
 =?utf-8?B?K0JoS3d2WEZSWUQxVkN2d1ptcnQzMzdmRmpMUWczOGlFTngwK0dIVXVFendD?=
 =?utf-8?B?Rkp0aHpxS2JpeDVRNWRDellGR2R3VWFUSUpvWFovdmtwVGkzSzhsRXc0bUJL?=
 =?utf-8?B?ZisxMlFwd0YxRE1COWRxSUNmN0RCMFJEcktLU0p0Y3pOcHpvYlFaOGdPMExi?=
 =?utf-8?B?cWFNZDlKUkU1WmtJOXdGWW9QNXV3dDMxcHpLVzNKQUxtZnp5RnFrL1k1WnZU?=
 =?utf-8?B?QUFYVUdtQ3c1Vlg4S0NLNEw0VjYzeDI0MzhoY0ZhOGtaVDBXWk5EMmFCcExq?=
 =?utf-8?B?YXBhTkdEdXhOZWJOVUcrQXBoVTRWSUd2NjJFWldiS0RJVkFIK3NOV1pOTUVj?=
 =?utf-8?B?R1R1NnpBODFRVTloRTQvQm0zaU1Rb1BJOW5PSjdXQWJka1kzQU13b2U3K3E2?=
 =?utf-8?B?ZHgya04rMDBZYzJyOVVDdUpzM2xkTWFBNmwxbitHOU9KWkRrdHpHSGJJWmV1?=
 =?utf-8?B?dTZnbUtiK1ZzZlBwQ2NLSVZCOWZvVkxSL2dtSmxZSmRySlJXWmpQcU5Tb0g5?=
 =?utf-8?B?M0ZpY1ptcjIwZDhPRU1WTmZrdDR5Y1RwTFdablpXMC9ydFFockJqeU9XVFQ3?=
 =?utf-8?B?OWVVSHlTY1F4czdRelQ5VVUraG94K2RSamdBbVdGWFZBTi9Ec0s4eXVPZXl3?=
 =?utf-8?B?OVk4eFZOVnpwVGdpU2p1a0VuVzE3YlJxMXBqUjd1S1A1NThuUW9WTFBYY3Jv?=
 =?utf-8?B?cGFBZzg5emlNMDZDMzFUaHlJbnE2TzRZTXBRdVdMS2VxUFlDQVRVNW9qR05B?=
 =?utf-8?B?ZGd3dEZXbGVZVFB3QmlpdTI3cDdOc0ZaODNEQVo4TjZ6WVp5aTRyWUswaXVQ?=
 =?utf-8?B?cG0zNDRyQ2gvc2xCU0t1aEx5eTRJcG84QVUvSXVtbmxYZEtyYTdHS1V1Rm1k?=
 =?utf-8?B?bys2YlR6c3Vqcis2MTd3dWRLZG9RZ3c5aVRYbzN2TkZuRlM5YWNXa2haaW54?=
 =?utf-8?B?UXNiQkFITU51c3FHMHQyazNGVlUyd3dndDR3WVI4NktYMXFjRmtQTTRhR2xG?=
 =?utf-8?B?eVUwQUdiaWhheFg1bWwveS8yOFpqNGVHQkJRZmt1aU5Zamh2UWNRSFpVZkp3?=
 =?utf-8?B?QWFBWjgyazgvRjJRMlpONmVadU1VZ3dJUThpbXFnUHg0NGlhNHV1R3QwSXVI?=
 =?utf-8?B?MDRtYU54eFg4eDFiM2hVNk50VndwVWIrVU5aSHlseitFZTlDNGtuRk9oTVJB?=
 =?utf-8?B?Z2FxREdHaVRTTmhkOTZaQzlpZUIxTzd2dlZzNGRyNEJmbEdWSTc2c0lNRDhT?=
 =?utf-8?B?ejBjWTQrZnJqVlRxeFNaUWxURjZ3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1420bcd-be5c-4769-c183-08d9e160a319
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 06:45:42.1619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AoTujeq1jutyW/3s2ZMIiPPwEnvurNaASXOOmmHKzj7lWcLWQ/dM/Z1SGv0cTU9nY6ROJteIZF5rBZ0gcWeDxhd2vlbgFp63A95zq6mJFgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1771
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10239 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270037
X-Proofpoint-GUID: wqkBXtS74JkDL1TtxBZvyr2igoDvbhev
X-Proofpoint-ORIG-GUID: wqkBXtS74JkDL1TtxBZvyr2igoDvbhev
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/24/22 5:52 PM, Darrick J. Wong wrote:
> On Sun, Jan 23, 2022 at 10:26:58PM -0700, Allison Henderson wrote:
>> If the first operation in a string of defer ops has no intents,
>> then there is no reason to commit it before running the first call
>> to xfs_defer_finish_one(). This allows the defer ops to be used
>> effectively for non-intent based operations without requiring an
>> unnecessary extra transaction commit when first called.
>>
>> This fixes a regression in per-attribute modification transaction
>> count when delayed attributes are not being used.
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_defer.c | 29 +++++++++++++++++------------
>>   1 file changed, 17 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index 6dac8d6b8c21..51574f0371b5 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -187,7 +187,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>>   	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>>   };
>>   
>> -static void
>> +static bool
>>   xfs_defer_create_intent(
>>   	struct xfs_trans		*tp,
>>   	struct xfs_defer_pending	*dfp,
>> @@ -198,6 +198,7 @@ xfs_defer_create_intent(
>>   	if (!dfp->dfp_intent)
>>   		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
>>   						     dfp->dfp_count, sort);
>> +	return dfp->dfp_intent;
> 
> Hm.  My first reaction is that this still ought to be an explicit
> boolean comparison...
Ah, sorry, I think you had mentioned that in the last review and I had 
forgotten to update it...

> 
>>   }
>>   
>>   /*
>> @@ -205,16 +206,18 @@ xfs_defer_create_intent(
>>    * associated extents, then add the entire intake list to the end of
>>    * the pending list.
>>    */
>> -STATIC void
>> +STATIC bool
>>   xfs_defer_create_intents(
>>   	struct xfs_trans		*tp)
>>   {
>>   	struct xfs_defer_pending	*dfp;
>> +	bool				ret = false;
>>   
>>   	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
>>   		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
>> -		xfs_defer_create_intent(tp, dfp, true);
>> +		ret |= xfs_defer_create_intent(tp, dfp, true);
>>   	}
>> +	return ret;
>>   }
>>   
>>   /* Abort all the intents that were committed. */
>> @@ -488,7 +491,7 @@ int
>>   xfs_defer_finish_noroll(
>>   	struct xfs_trans		**tp)
>>   {
>> -	struct xfs_defer_pending	*dfp;
>> +	struct xfs_defer_pending	*dfp = NULL;
>>   	int				error = 0;
>>   	LIST_HEAD(dop_pending);
>>   
>> @@ -507,17 +510,19 @@ xfs_defer_finish_noroll(
>>   		 * of time that any one intent item can stick around in memory,
>>   		 * pinning the log tail.
>>   		 */
>> -		xfs_defer_create_intents(*tp);
>> +		bool has_intents = xfs_defer_create_intents(*tp);
> 
> ...but now it occurs to me that I think we can test ((*tp)->t_flags &
> XFS_TRANS_DIRTY) instead of setting up the explicit return type.
> 
> If the ->create_intent function actually logs an intent item to the
> transaction, we need to commit that intent item (to persist it to disk)
> before we start on the work that it represents.  If an intent item has
> been added, the transaction will be dirty.
> 
> At this point in the loop, we're trying to set ourselves up to call
> ->finish_one.  The ->finish_one implementations expect a clean
> transaction, which means that we /never/ want to get to...
> 
>>   		list_splice_init(&(*tp)->t_dfops, &dop_pending);
>>   
>> -		error = xfs_defer_trans_roll(tp);
>> -		if (error)
>> -			goto out_shutdown;
>> +		if (has_intents || dfp) {
>> +			error = xfs_defer_trans_roll(tp);
>> +			if (error)
>> +				goto out_shutdown;
>>   
>> -		/* Possibly relog intent items to keep the log moving. */
>> -		error = xfs_defer_relog(tp, &dop_pending);
>> -		if (error)
>> -			goto out_shutdown;
>> +			/* Possibly relog intent items to keep the log moving. */
>> +			error = xfs_defer_relog(tp, &dop_pending);
>> +			if (error)
>> +				goto out_shutdown;
>> +		}
> 
> ...this point here with the transaction still dirty.  Therefore, I think
> all this patch really needs to change is that first _trans_roll:
> 
> 	xfs_defer_create_intents(*tp);
> 	list_splice_init(&(*tp)->t_dfops, &dop_pending);
> 
> 	/*
> 	 * We must ensure the transaction is clean before we try to finish
> 	 * deferred work by committing logged intent items and anything
> 	 * else that dirtied the transaction.
> 	 */
> 	if ((*tpp)->t_flags & XFS_TRANS_DIRTY) {
> 		error = xfs_defer_trans_roll(tp);
> 		if (error)
> 			goto out_shutdown;
> 	}
> 
> 	/* Possibly relog intent items to keep the log moving. */
> 	error = xfs_defer_relog(tp, &dop_pending);
> 	if (error)
> 		goto out_shutdown;
> 
> 	dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
> 			       dfp_list);
> 	error = xfs_defer_finish_one(*tp, dfp);
> 	if (error && error != -EAGAIN)
> 		goto out_shutdown;
> 
> Thoughts?
> 
> --D
But this makes a lot of sense, and I agree that it's a lot simpler.  I 
am fine with this as long as everyone else is?  I think Dave had 
initially authored this patch and I added it to the set.  If this works 
for everyone else, I will add these updates.

Allison

> 
>>   
>>   		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
>>   				       dfp_list);
>> -- 
>> 2.25.1
>>
