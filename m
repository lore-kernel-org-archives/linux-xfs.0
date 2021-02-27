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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D44AC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D3F264EDB
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhB0A6X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:58:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53778 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhB0A6V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 19:58:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0itFo111694;
        Sat, 27 Feb 2021 00:57:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=GtPMg/7lwNZpQgK0sHnKJLGaq7lb+KdqutYK5/t9N6Q=;
 b=R7IcjhjogSLzFq2Y/tvB4fvl1xLc73+7CK8XDjp+T4UN9ivCl6SsHL8zFot6HRoZU9MH
 vAvw5aTBz+LYCdBQVzJNe/VDNj1xXv2uMoJRPZJoxgc3AfpnUUqBacNsYsfYe/X9L1sH
 OPzJOFgSjYCPXBEUSRepuQPkwUftu7oWhmQpaTjMTNsnBWPHGCVHcweRMwMXyB4aeuO4
 DU56LtXSbnmF+NQdoeBBpBoEbBajS0v6Yt+BsSaKx0lkI/q7LVKHAQXVbwBbve2jCaoV
 s7+qgiI9eLdB5ki/Zvbw0KIJTyFvyQrfnvmBnSVWIK2vltjzrjBwCgwhGj7mzoyfAU08 dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsurbppv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:57:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0kYAw106653;
        Sat, 27 Feb 2021 00:57:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3020.oracle.com with ESMTP id 36uc6whvm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:57:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7TBbmK+OrS/7+goDO0fJ2OxIhlm3nydTKha9FC9ZywLxt68328PgGXlsFpmDrq49YTUaA+bG318LXZD7pYFor3B4ZS375sOIeW+mtrsUSlznkwgH4ocNtL8u3xaKHT6Sc97uGmtFvVoXyLMgknK7Ta92Ov5pWLorFjoUy6Nbfs6VWZYN6xj3KlSmd9NkmjK9abi0ZXr8nNujIScLM8XKMv8186e5J8qMYZi99bS4DMuVLW9LRLFK02efBOIqWNekc/97qB0k/4D0wXiSyreLd77I/rqxZM6ioKUSrYjPLIziNcdIc5ME+hbLhEzicbt59l8p3aILNRsbMyP0XRVyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtPMg/7lwNZpQgK0sHnKJLGaq7lb+KdqutYK5/t9N6Q=;
 b=lRMl8JAuuoA0tYWBDGQ+5vMmj4VE7eUu1vvRprtADTSD7bRSyM1RlJQvI117+GunMHaCRoTaxj8PYy0BI96KEaZ23CHVGpj5a9pdqZGlkA/STFDpcNBszk8jRJXXUJrU3lQW52KFVw4rATuuYQ3xwbodDmgcf26jCFaQJyVDD57H2rsoVEK2GcFJkI9ciuO9uMc3FeCKlMoBIpCbQZAraGG2oM7Q77a0IXTwLz3oNIZtkjNXls58esH/esbR4n0hQ4Mw4iKEOSqkkcWXsJU371RnMeu5mRIBBFhVwfw6Pdx5CSNC0Un+RNbB/XQflUdLqbFu5U0ISWErw8fnCnwtBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtPMg/7lwNZpQgK0sHnKJLGaq7lb+KdqutYK5/t9N6Q=;
 b=whMlYmDueSQcibsDCUSqa7wFvNikVVgwT5IM4h+JiHq06NbDVfANbr85brZtbg0oPzjF2xqTxtZ3A9rW94uFS8HH8lcjXlehVJ3Ok17UccagLl7CH2PexF6Z9G0Ii9O/9p+LHnCX13mK/N86rd/JSv4/5CwtgoB3UecsE24qzdI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Sat, 27 Feb
 2021 00:57:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Sat, 27 Feb 2021
 00:57:35 +0000
Subject: Re: [PATCH v15 13/22] xfs: Add state machine tracepoints
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-14-allison.henderson@oracle.com>
 <20210226050652.GB7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <846dd0e6-1e0b-c677-277a-95daf1a62967@oracle.com>
Date:   Fri, 26 Feb 2021 17:57:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210226050652.GB7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0208.namprd05.prod.outlook.com
 (2603:10b6:a03:330::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0208.namprd05.prod.outlook.com (2603:10b6:a03:330::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Sat, 27 Feb 2021 00:57:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fff38675-9f82-470d-4674-08d8dabaab96
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4496:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4496205D38059469BB1D0F7C959C9@SJ0PR10MB4496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:478;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xVwFG6cj/y1ztsFs1pv6FFPLTue2AB1q3dwKVebkFX4REslsglibDonPrIH1a1biy8sf5YEt5EHZDlbt7uDt1irBnmUeyqCHrDXdeZ+mcos51zXAo0gV/D55EApZwl9RhylJ6eFg4tdbJLGOw/H7vxKG7CCn0Ay4E/lgTRcbbPnkdD0qpiAQEllM6bUl1GLkV9iJt3fTMynN/BjP9S/flVtJEtaw7PiTrBl0qUPtpGZ1EvaRIbeemn8Mi52phaa5gMWbJq10XPmdReOtRWlnQdt+ulZ73yYGzETPCHxIz4Eqvajg07Ngvuu2iih6MyEVRM+jzdGz8bVIrfPzGVRo1/dqqtdXMPur2BUO2s6j4fSTxEusX1WSQxpv/S12pwt2UOu4/i8lDWj8zICifyuIsnYiehuIMgIEy6ywI76nS0avoxqYNLto3Rye3z1Txc4nHUYEcSJDvtntxlvA9qBfmJaCg1SzvtacpOPWnZTr4AK+C0b+me47gn8K1wylTO65D/Hf0MAoMx/D+UjrwupWoze+zIrj5seTUxxC5lQFrW861P2Q22k6pBwU+JgA63735an0Vko3qfy5OGjnxxcCtXZJ2xDwwkh5Emegj+nB6EQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(346002)(366004)(396003)(31686004)(86362001)(26005)(52116002)(186003)(16526019)(2616005)(956004)(44832011)(316002)(31696002)(16576012)(36756003)(53546011)(6916009)(6486002)(4326008)(8936002)(8676002)(66476007)(66556008)(478600001)(66946007)(5660300002)(83380400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RjNxWDVlT3NaNTlRbjdKL1l4Lzk0Tis3bndKRGZIQWRNblc3OEIzRFVKM0RT?=
 =?utf-8?B?aGQ5UXVjd0ZjQTlNVlZSSThNM01rNTlqeUI3Tmd3OSs5U0todzZqVzhwRmZW?=
 =?utf-8?B?T1pMZHBEUHNIZXQ4dFpoZ3RaamRVKy9yK0crdElIUUw4SjJ3Mld0dzc3WkVJ?=
 =?utf-8?B?NzdXMmI4eXFNMC83eWRGN2dUb3FIT0Q1Ti9JZ3BIdW1BeUZyWDBCM1lwRS83?=
 =?utf-8?B?SUc4UGVZcGc5VEUzUExCS3Vpc1U2SUdSUWxJS1NNNkR1cG9hNjZqVjZzL0Mx?=
 =?utf-8?B?UlB0SHF1NHVBSFdKVWY4emRGMm94bEd1cE5YRkZHYW8wUTkvZ2NHNTQ0ZnRG?=
 =?utf-8?B?QklkeDZ2NzFkM04zU01WUzNNOVZ6LzdHby8xVGtYV3BhbE9ZZ3FHYmFITGkz?=
 =?utf-8?B?NHBLSGJDYlkzTE9ZVkFhaGtZcFVYS3hIN2k5cWdndU8xTnh3U2huNCtXVi8r?=
 =?utf-8?B?dk1SWHYxZHNxR0pNUE1kU0ZrVytyalNVUCtyNGxITEJXaXFUU0pVNXpGMnFX?=
 =?utf-8?B?ZUNwZE51VWdyTFcyVGZqWnZnSUs5Q3VOS0VJa0JqZXVEU29WeG8vcHJQTERz?=
 =?utf-8?B?ZG00ckY5V1RpZWVLdG96SnZiRklIelRraGRyV3ZWNXVuOTFaNGZIWWduSUUw?=
 =?utf-8?B?ekpaKys5ZjFjYzBoRUFUSUttUEUyaDJYdEE1UVBFS1JhcElNODkxS0l1VUhV?=
 =?utf-8?B?YnhlS2hESC80czRNL0ROT1hVcFl3SFA0QXR6NThPZGNhT3RFOXhFdW02NHNG?=
 =?utf-8?B?Yk5WYmNZQVlhWDhyM25XMk8yYXhrMWxTVGRxM0pyODNsTlpUbkU0aEk4UzJq?=
 =?utf-8?B?UWszL2VGOEZ3NmwwK0x4ODgrRkFESS9WYXZKYzR4d0prNVQ3VGVwN0IxbFZJ?=
 =?utf-8?B?WVA3UDVGdU40eVNwRVZrZHFDNzVaNnBPdjNudzFHYkJGVWdMU3gramFDbHBE?=
 =?utf-8?B?bkVYU3NHQzdRU2V3WVJHUVBkK0xhNFVtbGxucTJGSThDU1k0OTZHYjViaFJJ?=
 =?utf-8?B?UC9wQUszUFVuM3lBTzNkZWY4UzIxaElQYU5YWVp3Z1MxR1lhamREdnQzQXRG?=
 =?utf-8?B?RFM0YlFZUThkSVU0dmZlT1M0YTV4aDFHNEtVRGlLSzJFMW96bysrYUZUak80?=
 =?utf-8?B?TnZvQkFKcjZTOER5bkN2bVpiVGtUZnRUNUZBcjlhclFNK1NCUXpYamRUMkdW?=
 =?utf-8?B?VE9QQ0lQRUhHZHhKWEwwSlF1V1pkRlQrRzRhOFBwZ1c0a20xYTJkOWppVFJC?=
 =?utf-8?B?VnZFbjNGN0hMRTRIN085UndVYVFCbWNGUnpSaFFHZG4zOGlTN2dWdDFSdW9V?=
 =?utf-8?B?eW5yODhBTW1WemMxUmMyZ0VpWnAwK25jdXM5Q1M5d0wwUW4xWW5WVUtad2Y0?=
 =?utf-8?B?Z21ycDh0ejJLNFNkcUxLQWtZU3R2UWk0WXAzcDMvaU1ybUhPd093dEIwcEx5?=
 =?utf-8?B?cEVqK0FkU0tseTFUWnp4L0NHekVMOEwvT1VHMW1rUDhDQzg5T3QxRkdka1Vu?=
 =?utf-8?B?dWpjVHZlQWY5M0tKdllyUlNQN2tpRWl6cldBK1QyVXNiYjNSU1Z3dnFDWWNt?=
 =?utf-8?B?N21QZ1ZseGF1WkxIMWIrVmxBZmVrbzExMHdVQXNrVitJZ09kQzhTL3BTeklw?=
 =?utf-8?B?Y1ZtWXBuL25neTFCVyt1NFhNNDFVcnlLZlhCUUVMQkxOS2ZSaHhFUW5mTVQ1?=
 =?utf-8?B?TkFXcWpUK2tIMkxhWkg1SkxUV0JhbUZnNEJON3BDYXE5VkdjK253UEVrUGRl?=
 =?utf-8?Q?hmHYIX9yKU9DgiqFrfSwHVje2kCBuIZhR66UZ+0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fff38675-9f82-470d-4674-08d8dabaab96
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 00:57:35.1315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYaJvDOZRel95Ufif/74s9QPXT6OgU8grh+N89vUdHpa3VzI6RiYD25OlyL449qIXActAiYNnwlptMkzT6YV02L1odXWwLgxprB4ESuFPw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/21 10:06 PM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:39AM -0700, Allison Henderson wrote:
>> This is a quick patch to add a new tracepoint: xfs_das_state_return.  We
>> use this to track when ever a new state is set or -EAGAIN is returned
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Looks good!
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cool, thank you!
Allison

> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 31 ++++++++++++++++++++++++++++++-
>>   fs/xfs/libxfs/xfs_attr_remote.c |  1 +
>>   fs/xfs/xfs_trace.h              | 25 +++++++++++++++++++++++++
>>   3 files changed, 56 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index c7b86d5..ba21475 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -313,6 +313,7 @@ xfs_attr_set_fmt(
>>   	 * the attr fork to leaf format and will restart with the leaf
>>   	 * add.
>>   	 */
>> +	trace_xfs_attr_set_fmt_return(XFS_DAS_UNINIT, args->dp);
>>   	dac->flags |= XFS_DAC_DEFER_FINISH;
>>   	return -EAGAIN;
>>   }
>> @@ -378,6 +379,8 @@ xfs_attr_set_iter(
>>   				 * handling code below
>>   				 */
>>   				dac->flags |= XFS_DAC_DEFER_FINISH;
>> +				trace_xfs_attr_set_iter_return(
>> +					dac->dela_state, args->dp);
>>   				return -EAGAIN;
>>   			}
>>   			else if (error)
>> @@ -400,10 +403,13 @@ xfs_attr_set_iter(
>>   				return error;
>>   
>>   			dac->dela_state = XFS_DAS_FOUND_NBLK;
>> +			trace_xfs_attr_set_iter_return(dac->dela_state,
>> +						       args->dp);
>>   			return -EAGAIN;
>>   		}
>>   
>>   		dac->dela_state = XFS_DAS_FOUND_LBLK;
>> +		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>>   		return -EAGAIN;
>>   
>>           case XFS_DAS_FOUND_LBLK:
>> @@ -433,6 +439,8 @@ xfs_attr_set_iter(
>>   			if (error)
>>   				return error;
>>   
>> +			trace_xfs_attr_set_iter_return(dac->dela_state,
>> +						       args->dp);
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -469,6 +477,7 @@ xfs_attr_set_iter(
>>   		 * series.
>>   		 */
>>   		dac->dela_state = XFS_DAS_FLIP_LFLAG;
>> +		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>>   		return -EAGAIN;
>>   	case XFS_DAS_FLIP_LFLAG:
>>   		/*
>> @@ -488,6 +497,9 @@ xfs_attr_set_iter(
>>   	case XFS_DAS_RM_LBLK:
>>   		if (args->rmtblkno) {
>>   			error = __xfs_attr_rmtval_remove(dac);
>> +			if (error == -EAGAIN)
>> +				trace_xfs_attr_set_iter_return(
>> +					dac->dela_state, args->dp);
>>   			if (error)
>>   				return error;
>>   		}
>> @@ -545,6 +557,8 @@ xfs_attr_set_iter(
>>   				if (error)
>>   					return error;
>>   
>> +				trace_xfs_attr_set_iter_return(
>> +					dac->dela_state, args->dp);
>>   				return -EAGAIN;
>>   			}
>>   
>> @@ -581,6 +595,7 @@ xfs_attr_set_iter(
>>   		 * series
>>   		 */
>>   		dac->dela_state = XFS_DAS_FLIP_NFLAG;
>> +		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>>   		return -EAGAIN;
>>   
>>   	case XFS_DAS_FLIP_NFLAG:
>> @@ -601,6 +616,10 @@ xfs_attr_set_iter(
>>   	case XFS_DAS_RM_NBLK:
>>   		if (args->rmtblkno) {
>>   			error = __xfs_attr_rmtval_remove(dac);
>> +			if (error == -EAGAIN)
>> +				trace_xfs_attr_set_iter_return(
>> +					dac->dela_state, args->dp);
>> +
>>   			if (error)
>>   				return error;
>>   		}
>> @@ -1214,6 +1233,8 @@ xfs_attr_node_addname(
>>   			 * this point.
>>   			 */
>>   			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			trace_xfs_attr_node_addname_return(
>> +					dac->dela_state, args->dp);
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -1394,6 +1415,9 @@ xfs_attr_node_remove_rmt (
>>   	 * May return -EAGAIN to request that the caller recall this function
>>   	 */
>>   	error = __xfs_attr_rmtval_remove(dac);
>> +	if (error == -EAGAIN)
>> +		trace_xfs_attr_node_remove_rmt_return(dac->dela_state,
>> +						      dac->da_args->dp);
>>   	if (error)
>>   		return error;
>>   
>> @@ -1513,6 +1537,8 @@ xfs_attr_node_removename_iter(
>>   
>>   			dac->flags |= XFS_DAC_DEFER_FINISH;
>>   			dac->dela_state = XFS_DAS_RM_SHRINK;
>> +			trace_xfs_attr_node_removename_iter_return(
>> +					dac->dela_state, args->dp);
>>   			return -EAGAIN;
>>   		}
>>   
>> @@ -1531,8 +1557,11 @@ xfs_attr_node_removename_iter(
>>   		goto out;
>>   	}
>>   
>> -	if (error == -EAGAIN)
>> +	if (error == -EAGAIN) {
>> +		trace_xfs_attr_node_removename_iter_return(
>> +					dac->dela_state, args->dp);
>>   		return error;
>> +	}
>>   out:
>>   	if (state)
>>   		xfs_da_state_free(state);
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 6af86bf..b242e1a 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -763,6 +763,7 @@ __xfs_attr_rmtval_remove(
>>   	 */
>>   	if (!done) {
>>   		dac->flags |= XFS_DAC_DEFER_FINISH;
>> +		trace_xfs_attr_rmtval_remove_return(dac->dela_state, args->dp);
>>   		return -EAGAIN;
>>   	}
>>   
>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>> index 363e1bf..7993f55 100644
>> --- a/fs/xfs/xfs_trace.h
>> +++ b/fs/xfs/xfs_trace.h
>> @@ -3927,6 +3927,31 @@ DEFINE_EVENT(xfs_eofblocks_class, name,	\
>>   DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
>>   DEFINE_EOFBLOCKS_EVENT(xfs_blockgc_free_space);
>>   
>> +DECLARE_EVENT_CLASS(xfs_das_state_class,
>> +	TP_PROTO(int das, struct xfs_inode *ip),
>> +	TP_ARGS(das, ip),
>> +	TP_STRUCT__entry(
>> +		__field(int, das)
>> +		__field(xfs_ino_t, ino)
>> +	),
>> +	TP_fast_assign(
>> +		__entry->das = das;
>> +		__entry->ino = ip->i_ino;
>> +	),
>> +	TP_printk("state change %d ino 0x%llx",
>> +		  __entry->das, __entry->ino)
>> +)
>> +
>> +#define DEFINE_DAS_STATE_EVENT(name) \
>> +DEFINE_EVENT(xfs_das_state_class, name, \
>> +	TP_PROTO(int das, struct xfs_inode *ip), \
>> +	TP_ARGS(das, ip))
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_set_fmt_return);
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_node_removename_iter_return);
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_node_remove_rmt_return);
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
>>   #endif /* _TRACE_XFS_H */
>>   
>>   #undef TRACE_INCLUDE_PATH
>> -- 
>> 2.7.4
>>
