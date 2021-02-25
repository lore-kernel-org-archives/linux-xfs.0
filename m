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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 781D5C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B8DE64EC4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBYGS4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 01:18:56 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41358 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBYGSy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 01:18:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6FiVV119866;
        Thu, 25 Feb 2021 06:17:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/wVfavDR9c1VLrv8o5LMkh1w30T00IeP+yF9xfrboiM=;
 b=zdETTDcR9MtZu5hGYt4mg3S3eGSCrRFWormBqCjcnuA/3hE0mKuojj9STyEmt0JVVRid
 f4fD5RzxNfBU0YyDsArgG1K62JrGa9TDowKoKbEJ569szzEixLhm1MStEKtcqVGTV5Bf
 +fzo4QHuE1sHu8kSwQipz+6Thue5inp3LHjF+vdr/EkO6O5JW7Wxrn76OyolyldUs/xU
 EbhTOhpSW2WcXacieeIm7X7E0rCFav7oQ4ula4+llrz/sDeJ4Yo6p7jkgarVBtywbnkS
 +9f5vT1A7HeEZtzYWgjYbDp0JxwPmNulL3CV6ogL5OXcPKwjq3rvIxqm19I9sNZUCMDP +w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36tsur5btd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:17:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6AfqS184254;
        Thu, 25 Feb 2021 06:17:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by aserp3020.oracle.com with ESMTP id 36ucb1mtqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:17:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZB8QlMGEa1UGJqjBD5+evgTjAlF1EGtT/LBKvQCwzhS3d6TmL6Y/y7Ccf3uC5StiA9mHcc0dWWDB8a2dIA558x/+AAsrOGerDi2ms95Vphl1huUAWgrHZehiv9qlfP/qOtWkPru9hwIxbuzWYHL1SScNPZq93LqaCCN420wfsG8FY2HWBCMOzE7qOekF80drFDtYB+01DtXdRLDHvVE5uugf+r81EmpqNWVEr45daZtvufb7aZx4/3bQHGABwYccqnlp1iouysRU008ZTycVQK9DOe32Rl2j1tD2wkxqgK2c65nIAUw10EouKg0K5Y1yUbwrUGbkWKgnbxJLmqhqLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wVfavDR9c1VLrv8o5LMkh1w30T00IeP+yF9xfrboiM=;
 b=nC8aAXSfR03qVmuxBj5ykoXSt6sfWBRQ/Km4hwHrczJCihA+DyPIbM0BfMehZcQma6ZP8psnMqTgrwiRO8yMyLvtW0xC1dWwczoRr6+Z96MVxmBzwBvK/y5TvBRIdFGLs1Tg3pAjnSOXWaHtauSVdMarp0tZqkAixhUDbcTjXkh5W93bdEVnGi1U58iIDrXxq5eP0GRveTpDaSUHPfI9D1H4Cyexrd6YUopHJvdp19SUgrXW+6xcdGb9tdwleDwvjgPTjDPa8EtNwZy7dFBmyWarKdvAF6xuu93OIcnFee7Op8WncfpSMBFoAwNDIDFPxewgAMkSClHxJyDCDnwJxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wVfavDR9c1VLrv8o5LMkh1w30T00IeP+yF9xfrboiM=;
 b=YvpH4Ftj5huEWa2BrvmolZd37+5KAoNSXUguF6oG6Aerd72YNZPX7sdLx0rNmhqfSdqDEP2VcfQtJpGgd9+nhDJQKB64pibS7dtFJ2LDYt65QzrhuYJrwzWZAlGItNYXYBUnHYhAQ0J5R+0kUsdX3E2R4TzeT+OZwLloDZQtdIg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2488.namprd10.prod.outlook.com (2603:10b6:a02:b9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Thu, 25 Feb
 2021 06:17:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Thu, 25 Feb 2021
 06:17:49 +0000
Subject: Re: [PATCH v15 01/22] xfs: Add helper xfs_attr_node_remove_step
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-2-allison.henderson@oracle.com>
 <20210224150315.GB981777@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <bfc9f778-06e6-7983-88cb-a26bf35e5ad2@oracle.com>
Date:   Wed, 24 Feb 2021 23:17:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210224150315.GB981777@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR16CA0007.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR16CA0007.namprd16.prod.outlook.com (2603:10b6:a03:1a0::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 06:17:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76e1f61c-825e-46e1-96e3-08d8d9551399
X-MS-TrafficTypeDiagnostic: BYAPR10MB2488:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2488ADFA3AC2098D8085EC45959E9@BYAPR10MB2488.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +wtr95rfIOWxrggwGxgsvFk+ejblnN4PvWoOPVJ11w0bzupAbOQ/1zCc5/MIpqleHum3MiJjdk1WkXnhZagcx3dArvsBeZb0vDwy3pUdMZFcYB9CAbiJ9EnNFQkqxnIe9wwP91d/2l5HUU07pSXLT5zYlZsTr2fSiMAesM8Pon+SPnSy+waryMdOoCanMxLB1xHTOyuk3frasrP9vNdmFRqPV7DrbZfzrh5JjhHi91RuZkK0uOcUi35XHXAwKqPl9mzs9AjnOKClL4A5y/KcgPfE0P//DzHFoO45J8jKiylVCh13ONtGUSvxljf6yEf4Gmae+VVWCZ1fNMqtEgOU3ViZkKxfqj5AjAAzyYNTTk0q+JJecAvLqjdYkikd41WkH/G9YjQ1jJOyQGc6nOWsMPIXwiST3JQqjJ0FAgkVUncOzkkx+GLN5gp0b5sMN/mLVGPdtnW85/SGkgXXFdecDAfy7VG6pLjyQ45Y6t1RKW5MUOVkoetAthQ8WgBkDee8MKpBp3sCWTDWNPX+ufIBXRYNjVRxK800LObJbj2iocc8L2p0i02JrbRNLpMg8Emlyl6P3FeB4M77ySytfUU6z93NSG0G6qIxBtU2FSxXVW8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39860400002)(396003)(366004)(8936002)(2616005)(956004)(52116002)(8676002)(66946007)(5660300002)(44832011)(53546011)(6486002)(2906002)(31686004)(478600001)(83380400001)(4326008)(86362001)(16576012)(31696002)(16526019)(66476007)(66556008)(26005)(316002)(6916009)(36756003)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S00zMzlXSGVsRStLc2cwa2dVL1JTWU4wR2xYd0JhejlQNy85SnhLOFVwMkVv?=
 =?utf-8?B?RXU2c0JGR2Fkd2FmQnFtaUt0RWpmOXJ1WFBCMHlWaXNVNjk3ZzE2a1VBK29x?=
 =?utf-8?B?V2kvZTk1ai9vNW85bUhvWDRFcEdYY2NyWkQwd3U4WGhVblBSZ2tCUzRaTzB2?=
 =?utf-8?B?cFBUUTdlTnJNOFBSV3NYcDBCKzd5UUhNUHpQdkt3TmlscGo3eXRyWmxoeHdV?=
 =?utf-8?B?cENkNm5TSXNtcUIvU3IyVk53Yy91UmNiZno1ek55UkdXam4rTEFzK21IVjVY?=
 =?utf-8?B?VG5ub3VFN3Z2ZDgxSk8zNGEySDBYUWlqVi9CUGx3QjcxQUYzaGMrYUdjcDlo?=
 =?utf-8?B?ZUsvOXFtNjFCbnMyMHpNazBtaFpWYm1qTEJHMlk5VW56eVVXdm0zV3lSVG1o?=
 =?utf-8?B?R1o2WmFFODJadm9nZDVhV2xTUTFnZWc0aWhZQnV4TDBhT3ozbDdDa2xvaEY0?=
 =?utf-8?B?UmkycUZ3NG9qT3pHODVHTXhRekUxWFN1Qk5pMG9FWEgrUEplSGQwYVJNQUFO?=
 =?utf-8?B?dm8zVVBsY29uMWpLSVB1K09OWktIZ0s0OFVBSnkrWEdnRkFnbHZMWm11Z3cx?=
 =?utf-8?B?dmQ3cFovZTF1TkpTcWZGN2NNRFA5MS82STdPLytEV3VRUktYTGRSUk1CczAv?=
 =?utf-8?B?OG1UaDlqb1ZZSlpmcTB4NWJVN2JCMXdJdmwrREUrVzdYUlc5ZGtUWThvWll2?=
 =?utf-8?B?R21RZHF5K1oxNEo5aTkrY0hPVWo2MVVyUTZCQzBiYkhRYWJ6ZThIVE1zaGI1?=
 =?utf-8?B?MmtUbkJ0dUJETUhHbUwySEo5cEp2YzhQRE9SYlV5Umh5Qnh4NHpmS2hvdUVR?=
 =?utf-8?B?ZEhOdCtuQlBjRmMwSkJWUk1sb2dxWDJOeDd6WTRBYnV5N1JJSW9TSkpCODRH?=
 =?utf-8?B?KzFpZit6ZHJ5cEhXbU94Q1lFZEI2SG9QV1RmSjdBTjU4em85d0FZcHVIeEtN?=
 =?utf-8?B?VUhaT3FrbURISHIyUVF3Sm9LWG9KZStYdlhtU0xMMGlQUW5DbVFHdjNjeklz?=
 =?utf-8?B?WnNvRVdoVFdqRFM2amYxWDlUblZvaDNPWHRjT3l1Q2FTcklNMXIvUnhZVE5D?=
 =?utf-8?B?Ri9OSVRuZ3E0VTNadVFtR1FIRFp6U0ZqUzZ1Umhza2ErVlU0WGlRTHczcTQx?=
 =?utf-8?B?SG5pT2JHeDZSWURxQmpIK1lkeVErSzlnTWlsQ0lhSDVrV3hvV1pZZEg5Z1Zs?=
 =?utf-8?B?Sk03dU1wOVBHS2VLMVBJS1ZiUUovQ0dFU0lDd2wrMkN2KzBZYk53M0s1V3ZJ?=
 =?utf-8?B?VUthZ0g4ZnFwTlhPWjJqZ01GMmFXejFBWnhOV0ZaNDE1WHZnNmJBaU5INzYz?=
 =?utf-8?B?enlzOVVpNWJmaXRCdTdlTnM1SVpqNXNzWUcxTWlCdUFWVmpPVyt6V3B6cTNB?=
 =?utf-8?B?cEgrOHhDb1VGelp1LzZLQzB0WlM4dDlqSVhxUlF6VHR6QkIvdW1zNUltTHYr?=
 =?utf-8?B?bk0waDBhWm9hR0xidXh0STJoaGgwOVlyQnFwOGtiUjJDMG8ydWZPd2xXWmQ3?=
 =?utf-8?B?V1kvd2FjRW9RNVZhMUNUUVZqdmJuOTRESXB2OHRJTTM5SHMxQkY2NWExeUhh?=
 =?utf-8?B?WGhXU3o5NGMybmlHZjc3emljUzBGNkEySWgrd1kycnBYYUtzeExEZW01ZGVi?=
 =?utf-8?B?VU5TaGdWN2JRSTJZOXkrSEUyL3V0aXBNOS9lVDd0L1o0a3hxNnE2QW9lYS82?=
 =?utf-8?B?YTdLRFQ4a0dQSkVxOTdib0hYVmxqQUFpcXV4MGZDSlVseTBGdEhLVGU1Mk13?=
 =?utf-8?Q?8dlaG8fZALvdqnGL3qHg2sqB4lqaCdwAHLJP9Re?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e1f61c-825e-46e1-96e3-08d8d9551399
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 06:17:49.8669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iSZ/IpfpFWdFD7/c7RT6edCdFeF1XeQd/l3QlF0YqVbGDdGOmc53y5jjjQEtkNGVqWd5Pdn2TK5MqeVd+DJJluNYgT3OykXSIUidAOcJgOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2488
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250054
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/21 8:03 AM, Brian Foster wrote:
> On Thu, Feb 18, 2021 at 09:53:27AM -0700, Allison Henderson wrote:
>> From: Allison Collins <allison.henderson@oracle.com>
>>
>> This patch adds a new helper function xfs_attr_node_remove_step.  This
>> will help simplify and modularize the calling function
>> xfs_attr_node_removename.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
>>   1 file changed, 34 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 472b303..28ff93d 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -1267,18 +1262,45 @@ xfs_attr_node_removename(
>>   	if (retval && (state->path.active > 1)) {
>>   		error = xfs_da3_join(state);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   		error = xfs_defer_finish(&args->trans);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   		/*
>>   		 * Commit the Btree join operation and start a new trans.
>>   		 */
>>   		error = xfs_trans_roll_inode(&args->trans, dp);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   	}
>>   
>> +	return error;
> 
> Maybe just return 0 here since it looks like error might not have been
> assigned..? With that fixed:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Sure, will do.  Thanks!

Allison

> 
>> +}
>> +
>> +/*
>> + * Remove a name from a B-tree attribute list.
>> + *
>> + * This routine will find the blocks of the name to remove, remove them and
>> + * shrink the tree if needed.
>> + */
>> +STATIC int
>> +xfs_attr_node_removename(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_da_state	*state = NULL;
>> +	int			error;
>> +	struct xfs_inode	*dp = args->dp;
>> +
>> +	trace_xfs_attr_node_removename(args);
>> +
>> +	error = xfs_attr_node_removename_setup(args, &state);
>> +	if (error)
>> +		goto out;
>> +
>> +	error = xfs_attr_node_remove_step(args, state);
>> +	if (error)
>> +		goto out;
>> +
>>   	/*
>>   	 * If the result is small enough, push it all into the inode.
>>   	 */
>> -- 
>> 2.7.4
>>
> 
