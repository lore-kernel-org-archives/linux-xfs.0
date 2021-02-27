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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8222BC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BF0B64EBA
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:55:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhB0Azv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:55:51 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhB0Azu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 19:55:50 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0pBOm103844;
        Sat, 27 Feb 2021 00:55:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6qSz703aSzL3sqvTHR4SEgxEt1xLwfAkaEPmrmwthDI=;
 b=YCTZ2wiMjWG/mjveqyJfAUVivKEc7GTYvIg/12HLReJVTNx1Ao0tqqv7YmO8+Y2dYKoS
 vKY96vXw5W02aWKDJZ5wqTpYybVnIpTeVf+2yKWlQOB2WUqCKlFDBrNtSaHt5IrzkKCB
 VRS5JAmkaP29DomIgFHAKjYzNkRNN+Wg8t2Bw/dkmLIRSDQ96E8YZqW5+XB6tnRqvHVO
 4uQh6x6Ep5cYWA3dMRqunK6p5yfr/invZQwf9g6AVXcFm5NlQKKYJu/z50Ww6FjIwQsg
 PEVognknWPBFmCqXpj9R8Lzf8UEpBm12DngPbQwGAVlmmNGR3qoulHRw/tDwlEleq0vJ 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36ugq3thyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:55:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0j3bH005838;
        Sat, 27 Feb 2021 00:55:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3020.oracle.com with ESMTP id 36ucb41x1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:55:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lO/DZ2jBfucVhdlA76cnFWO/Wh3Ga82xP/821opTTBOAfAQ6Md4/K9vKa5UWN6phhDb1DteOCtGjFnrE4S15BfqGk3AjXz9cZRuHQY/eGHuOy+x+HxJvL2DWlYds2hfNNIVI+qkXx7AXhRj8mrxfMD1JgP9KjB1YVota+AOtvLybqCMqnw1kOa/fYwntmLhcVGIzO9mfAKNYWu5eRL9TC1zsNdT4WCpArfTYR3rOMu8IIKlLYTostQkNRfRdXsI8PbDXFbcGSOyO9cYDBGqNgfsMi6ltndD0Mz98b+XLUedxItOhIIIrBJ3Z6Cvmph7R3nqUdTRv8IzAfNMpvEIU8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qSz703aSzL3sqvTHR4SEgxEt1xLwfAkaEPmrmwthDI=;
 b=WyVk3nlPHWs3kxOw2tvM8/qGyrsZu7TCd8W8DpwKPP50P0RsmEC/hIKLdDolV0uf/IuMjnt3Lsd9IDpZgYwTfkRCFjK+7f2nhgcKQxRe4jVr1VnduHanF/uP11zT7OOsrLWlSpySk8/ROJyljPB0Ad9qtF26RxpLZ9H4Y9hgHoXV1Z153mr7nv+C0XgGKff7BIxllGcLrcbzJbLqK19ezEPTl2+hZNKE4g83yUTA3PrPUcmiBptXhYxf5kKZqk/f/UY7tNOx0bfT0Ek31Od4pjbc98XvXmrnedwnIGcQDKC1hBZJB2LqHxwk1pIyQh0b/TrbsByWTJQ2SAKU1iL4ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qSz703aSzL3sqvTHR4SEgxEt1xLwfAkaEPmrmwthDI=;
 b=mjZEmZm0r5T5/Pd2ym12/PwijcOUI0rsrorcg89iau8PqVFyKOVZP6xcgyKf8t49hQOj6UBwf1TlBuT/6YhZRjX2PFVjTxbjCloZIulR6v3uW8qptFW1H1lYAFeygHSrbGDmHAzhOL0xGVtOmZ6sunmPEcAZdlLz8NRecppkF4Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 00:55:06 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Sat, 27 Feb 2021
 00:55:06 +0000
Subject: Re: [PATCH v15 21/22] xfs: Add delattr mount option
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-22-allison.henderson@oracle.com>
 <20210226042946.GW7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6a893adb-2800-5f2f-bcf5-3eadf92736b2@oracle.com>
Date:   Fri, 26 Feb 2021 17:55:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210226042946.GW7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR13CA0112.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR13CA0112.namprd13.prod.outlook.com (2603:10b6:a03:2c5::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Sat, 27 Feb 2021 00:55:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b949c195-e880-4cb2-f90b-08d8daba52d5
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:
X-Microsoft-Antispam-PRVS: <BY5PR10MB43061BEA044AEBDB501DAA25959C9@BY5PR10MB4306.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZvqRfrLJmt1sTeUngQDFMYQXiz3KuXwpc0m1+rzEKdGZmfqleSs5KeAgkiXmlnb+synNySeNdH90DfcOWzE10gRd6MBQbB460scAOydLTD6mjBAG99xtRlQRIqe71EkkFaQ3EgkUkXn0l5R7L/G495AO8ZhN6Ut/SN62GnMomwM+TqKfjevQozW9j5fkx346Hah44J7C0FNRQg5wwJE7NV/WotYE4+f87rO9Ewzr4VTfJNXUOXCv0NJi7o68VJuYhmA+jMLNXAzstC2OLYCLgQCbKCMdW11vGRBjavaerWHG7BNdQp7sqn7F5+/qeVORgTqCBPV/A4TdhXpKjUm3ixG9t2xSs3Uw9wC6KL5aoSezA5dsN+PyWoifjQ/OBMaalGu6RdNiJzbpU+7F7GOtLRyW4Uerq1ltRUZ6s/RmgOl967Y+Xo7XOeBvwkEiL1OSnZoPsSo77XvhhIWprCfN3GeQhfkaY22m27Cvu/DM1dQeFJaR8gVOmP1RZZFBLotzHM+2Xa7l7mAbVu3sP6Sln7qv5frNGV7vwpqmXIJppCaSkbvqXj4KK98r97Yf4SBAH//1pbr/54aql7wH+xaEYJBKi7mB/85uHE6EtqNjHF4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(366004)(39860400002)(136003)(8936002)(83380400001)(86362001)(6916009)(8676002)(16526019)(956004)(2906002)(2616005)(36756003)(186003)(5660300002)(66556008)(66946007)(16576012)(31696002)(6486002)(316002)(53546011)(478600001)(52116002)(31686004)(4326008)(44832011)(66476007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bDVNZXBmaDZFd29qY0xoYmNqVnBPaDFiQ1kvb2tNNVZqZGFqRm9XWjl2ckh0?=
 =?utf-8?B?RDdrQkJzcVVQWFNwNHpTTTIzNDRoM2ZTaTNZby9rbFpCVVJIVHNJK1EyWGg3?=
 =?utf-8?B?MU9XdnFmemZlRVF2bTdlZkxOYkd3YjhOWGJZemw3cmI2ZnNuMjdvVllrdHdE?=
 =?utf-8?B?SVI0N3lxWHMrckFpK2xKNWpyRWtiMDI1d3Fqa2I1dE1ZSzF3N0YySWhUTFJT?=
 =?utf-8?B?NE5JWUFkTFgwNC9KK3ZmSFZYZ2VSOVVQeVlZQVRJUHpIUFlNbDVvZ0ZoVWVU?=
 =?utf-8?B?ZHdXcXlycE0zb0F6WFcxb1laQVpONWlVMkl5Y3FzRkpLTW4rdlZRTnd2bGxB?=
 =?utf-8?B?ZVVtMkhkTHdIOTJ6M0Q4ZllwNFpSLzllRkZwSGZMWEc3aG1jdExleHEvbjVm?=
 =?utf-8?B?VXRxSk1mZkJJZFpjRSs0eEVJelZiUXRVRFlORkM3dnFKeG5YMDNscU5xTGU1?=
 =?utf-8?B?V01PZUxtN28vMjRlNzNzWk43c2JmYytWTnJUKzBzZmZrMEpjRDVleEN6dDY0?=
 =?utf-8?B?Q3ZLbngrKzkxelFTOUs2K2U5TW0yczNUQnJjUlo0aStMUjdCVVl0ell2M2RW?=
 =?utf-8?B?TGliQ1hFQ1VKV1RhNTJkK2tuTmVUbDRNWDQ5a2I0UkF0bUlnWWovd21EQUlS?=
 =?utf-8?B?RGl5cGprOFk5bVRnOWw1a1k1OTNUcTNqZTh0K0JXa3pzYUU4elJYV1kyYncx?=
 =?utf-8?B?S3lMRlBwcXE0ZTMxV0JleXYzRFN1cjBmSHlrUzNNVk90NHBsR3E5RWh3RzZt?=
 =?utf-8?B?Qng1WmtRbHRoSk9KbXdnMXJLMTZqOEduNXE0aUxBcjZXT2ZIdUl1Vi9Qam5P?=
 =?utf-8?B?U1gxMEpjQ3F1S2pLdlptbTg3NmcwYklXT2FjZHRpQVYyVmg1bDl0OUE0dmZL?=
 =?utf-8?B?dHg4bFoxYUZ3S0YvY1FncUlhdk5HVFpVQ2htc05pU1hMU0xhWkFJcDNoZ2Vs?=
 =?utf-8?B?WEZpUnJ5RUxpRWRFVGsveTFyamNUM3AvUU9waFlEUkVyWlFyUCtTNjBiOXFK?=
 =?utf-8?B?My9qbk9rNFRlM2hKazY1ekltZEtObzgzUHZ0QXAxb0prUW5vMFJwTjVwcWor?=
 =?utf-8?B?UVF3aTlXQy9EMyt6UnR4ZWh6R0s3RVBwaWxQbDVwUEZmbXIrVjJuaEZFZWx2?=
 =?utf-8?B?L3M3WTRVY015YjlsTzlNTDdVV3YyS3NoeGxCbW83UjBxR1QzVVgwSlNvdmIy?=
 =?utf-8?B?c0Q3dk56QjY1NDN0b2lmM2hLNzcvOGxOa1J6ZHNmY1JZSGhzcXlOZ0d6bGVC?=
 =?utf-8?B?V0wrNUx1RE0xdFg4MnRwMzYwdjhZVWdYMFE4RmR1RVY4Zm4yNDlFQlhHSXhy?=
 =?utf-8?B?ckJUR2RGdDF0bFlCeFdxb3RiSjFFS2pPaXdZN2ZwZTBWK1laR01QUkM1eXhs?=
 =?utf-8?B?dnF0amRPcDBDRFRTaDJyUnlDbE4wR0hqUGJEQXZwRndLRER1QnYydzNMZThv?=
 =?utf-8?B?aFZKK1hSZmxDak9TcTBVeHphZzZtQUo4YzJSSEI0YWgyanZ4dmtSeGszdVRQ?=
 =?utf-8?B?YnB0TUt6MXdpZkUzV3FmbkV5OEUveEJqQXNLamZiNy91OFMwRGZnamtsWFBl?=
 =?utf-8?B?Witpd2x0NktaMDBoL21Wck5QTUg4Z0g0MWhCSWdJY2dYOFJJWjN2ZndXRmpM?=
 =?utf-8?B?N0xNUTRMWStUd0ppZTFucnJnS0JMVmg3aUJoN2NDakgvL3BvU0swa3lNSlFY?=
 =?utf-8?B?cXV0TU5PZXAxQkh5OU1lS0w0ZzFrV0tJdXhmRWRKMHNycm80NE1DNzdBaURK?=
 =?utf-8?Q?hdlCv5i25lANV91ZGQNIkX9cruF/nKTqc1iQWkK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b949c195-e880-4cb2-f90b-08d8daba52d5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 00:55:06.2139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /xad/EozfHp0C2GEozMz2KLLRyB1p9CENCE/6pVZ9DQvXdNpGBuRfSwtntJ9DW6fIvLJquUt3S304p7ASfiYZTRD+gEY4oCxiVLEz9ndAsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4306
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/21 9:29 PM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:47AM -0700, Allison Henderson wrote:
>> This patch adds a mount option to enable delayed attributes. Eventually
>> this can be removed when delayed attrs becomes permanent.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.h | 2 +-
>>   fs/xfs/xfs_mount.h       | 1 +
>>   fs/xfs/xfs_super.c       | 6 +++++-
>>   fs/xfs/xfs_xattr.c       | 2 ++
>>   4 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index f82c0b1..35f3a53 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -30,7 +30,7 @@ struct xfs_attr_list_context;
>>   
>>   static inline bool xfs_hasdelattr(struct xfs_mount *mp)
>>   {
>> -	return false;
>> +	return mp->m_flags & XFS_MOUNT_DELATTR;
>>   }
>>   
>>   /*
>> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
>> index 659ad95..57cd914 100644
>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -250,6 +250,7 @@ typedef struct xfs_mount {
>>   #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
>>   #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
>>   #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
>> +#define XFS_MOUNT_DELATTR	(1ULL << 28)	/* enable delayed attributes */
>>   
>>   /*
>>    * Max and min values for mount-option defined I/O
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 21b1d03..f6b08f9 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -93,7 +93,7 @@ enum {
>>   	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
>>   	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
>>   	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
>> -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
>> +	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_delattr
>>   };
>>   
>>   static const struct fs_parameter_spec xfs_fs_parameters[] = {
>> @@ -138,6 +138,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
>>   	fsparam_flag("nodiscard",	Opt_nodiscard),
>>   	fsparam_flag("dax",		Opt_dax),
>>   	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
>> +	fsparam_flag("delattr",		Opt_delattr),
> 
> I wonder if this ought to be hidden behind CONFIG_XFS_DEBUG=y, but
> other than that this looks fine to me.
> 
> --D
Sure, I can wrap it with the CONFIG_XFS_DEBUG for now.  I think 
eventually the plan is to get rid of the option all together.

Allison
> 
>>   	{}
>>   };
>>   
>> @@ -1263,6 +1264,9 @@ xfs_fs_parse_param(
>>   		xfs_mount_set_dax_mode(mp, result.uint_32);
>>   		return 0;
>>   #endif
>> +	case Opt_delattr:
>> +		mp->m_flags |= XFS_MOUNT_DELATTR;
>> +		return 0;
>>   	/* Following mount options will be removed in September 2025 */
>>   	case Opt_ikeep:
>>   		xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>> index 9b0c790..8ec61df 100644
>> --- a/fs/xfs/xfs_xattr.c
>> +++ b/fs/xfs/xfs_xattr.c
>> @@ -8,6 +8,8 @@
>>   #include "xfs_shared.h"
>>   #include "xfs_format.h"
>>   #include "xfs_log_format.h"
>> +#include "xfs_trans_resv.h"
>> +#include "xfs_mount.h"
>>   #include "xfs_da_format.h"
>>   #include "xfs_inode.h"
>>   #include "xfs_da_btree.h"
>> -- 
>> 2.7.4
>>
