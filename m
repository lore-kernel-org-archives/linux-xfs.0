Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA47AC07E9E
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 19:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFB60613CC
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 19:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhGIT7a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 15:59:30 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59286 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229606AbhGIT7a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 15:59:30 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 169JqiMA014534;
        Fri, 9 Jul 2021 19:56:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=itbARIRokoluF1iy3i/+0ZwQvaz3wYvqhir+Lrs5iJo=;
 b=tI2hUUomE7CY52yU+5IyfgNLv/aYdlVTpSLHReLInVSHCfv/owbuKRzIAtGRy62Fc2xa
 7uMJ8dQGKnYPhXiB6OlLz/7WEka/jMkq7VOFXODpqHkaHDl50CAWHIptTPjGfuawYzR6
 8RqyyP6Cb4UG8piK6JlQ8OdkqPMREzHs8fARMaSXutEMVH2ifl7/wPXOL5B/jA75RXzx
 CXZcvVs+L10VFBlyNkLqj4WKBJ6RV+0st4fU7V7k14XG34ruavngkZyoO4O/14El02pF
 G0Az6D7jxILUo+Pu1IDxA06ouQ2/Aw3HVY1KvK7UA84rkDneVA1XQkRq3497p3gNHRUs /A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39npwbv5yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 19:56:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 169Jugmr113359;
        Fri, 9 Jul 2021 19:56:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by aserp3030.oracle.com with ESMTP id 39nbg9y0c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 19:56:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERxt2YgKYDg6JsVLNgjswC0PYydzJ03KIF2I9LNmoTaF9xggOwZeqNPUirq+3r83wj8/cKOi+qNhKfMvq2UI/x5bw6KzBAl828Pm9jOspnqkju2UziqpvZHawEjjIIFzU0kzhvS0eiJYEfhRLV6LnxUa2bYsHo/3wM+RtcBiyp18l5EE6xrpNuQFZQ2//Ohoy7v+TJs6EchBQ5/kuSiDGTJfEZTEXhbV/lhYnOQJ3tx9YAsQbcfj1sw8AvtM2FNPmO+uYVSl1r3kmzt4e2xvZH6AAAjTtQKTPcy3Xhpcr5btHO41qRYzXxKVqOgBNsWRUwkXXtfVL+Tvz1escTONlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itbARIRokoluF1iy3i/+0ZwQvaz3wYvqhir+Lrs5iJo=;
 b=k+4FjQIbJswkeT5g5VCAoZq6MkgzcN33UXcrxVL00jsirxG/lA1KxXFqbHDsmg5yeiNuNnlZxc8+QPDcQNdm5zj0fkWNHKly0AZWRDMWggXha2ZU+Ya4EBswvwizjt8kuZAak3QOJJZqVtq8nHSGiedUMxZQrckkcPbGuc31omitb3VBIYWDllEDRegIV8UWCi44kLKUi/jWO28lvEKdn3yBVNvSc9X3jChMmrNWDWIIDafbq5JFT5sU90EM53aNaq3U9pVs4gLS4fCJ6t6vaKTQktffWjRjitcKurK3HlicdhhGZS8qOWpERKlxABsNDzUdfnXD17cRNNQVycXq/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itbARIRokoluF1iy3i/+0ZwQvaz3wYvqhir+Lrs5iJo=;
 b=E8R8AzFmF85yqSMqiQwAh79IDcCGyYpA6Gcr/Gw6+SmiuYvtb5uVdvmBJQb31d8W7J2OumYQZ0qGVk/fFvFPgONIIxJ8+j62cmmVhYsvpGHK1IgdQ2RHJur0AGXKqnSDe+pVfZtu1WQDfqSW8q5ysV0o/LZs/mAcMxihbT141Hs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4210.namprd10.prod.outlook.com (2603:10b6:a03:201::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Fri, 9 Jul
 2021 19:56:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 19:56:32 +0000
Subject: Re: [PATCH v21 11/13] xfs: Add delattr mount option
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210707222111.16339-1-allison.henderson@oracle.com>
 <20210707222111.16339-12-allison.henderson@oracle.com>
 <20210709041407.GP11588@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <add0c859-2f06-3ed6-8232-ad48d8e55cac@oracle.com>
Date:   Fri, 9 Jul 2021 12:56:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210709041407.GP11588@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0204.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR13CA0204.namprd13.prod.outlook.com (2603:10b6:a03:2c3::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.12 via Frontend Transport; Fri, 9 Jul 2021 19:56:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27a7dc25-4360-4c30-8cb6-08d94313a679
X-MS-TrafficTypeDiagnostic: BY5PR10MB4210:
X-Microsoft-Antispam-PRVS: <BY5PR10MB421053DC0D6E12A3F73201E295189@BY5PR10MB4210.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +0pDW2jnNlAFWi3D1g5/G018Azhu5WenpLpPZHa3dIOVedU9wb3gbwx7N3cuvAxA1yNjZyoJXep5h6sBK5MSpcyXel7841wFHMd6G6vh1vVM7vaTJMDgX599Af9s87O1ZjPfil0Y7x8NsIIUbrUQeiz7/y6dyft92IJ5GlvlYy4y0jdKU7CQSbmYwbqRVALEWLQqxvWbCZ2Wpd+vJYd8TPpKkFDloh5SJ+k6iPv8k27/DbgD/uXKCkHwFoTnwR4Ga6/MP/kegPtfp3nq/IlUP0adNN170cIfDYy+Qb56ASyBU3dO4tfT4w9cp0GsJKVHXKoYrbGqZgAHeGGgJhL7Cg7jwVf8vjzFBO6KRjO4km+80PdrLW21vGDhLhTrbMAHmfVjIQp8oHy06mc40U7n2adQ3iECQ+r9ITwnXM+bhaYVBQJ8FHkWuBxqqiGcErYMLrPGK2zzQkOR605I/upU0SfOMQ7UGuyWeW5QTdZk3ky8ZHyrkYN9JNO1/wVSRD3N1+rsla9QcUzNDSQR0mq+w8rMgRI+bbevWnpLZB6v43giiL5vkagvEt6C2BsL3L/LiTc0ndxyDPy/0dHcIjzj9AuLWbw6DT6kOZkDJb2SW3YaMMwuMsU/Wm5fLMYdBL0v4xzhDpRsE5m+9nHYyQP1z1eoI+obNFyO+dE36TuDNo9/gOFeMqUGrS2MX3b47tQAVLPPReXLAJUGSvRmGJquaWTJtDwglOeWisZqHlttP6BX6OuO/KwH7P5pdM2DZammiRBZp2yGlmySGDeigYwqbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(136003)(376002)(36756003)(8676002)(8936002)(2906002)(66946007)(6486002)(26005)(478600001)(52116002)(53546011)(66556008)(44832011)(31686004)(38100700002)(38350700002)(2616005)(956004)(186003)(6916009)(66476007)(4326008)(83380400001)(86362001)(31696002)(316002)(16576012)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b25tVWhjeGhQSHEwL3J6TjJQZXdTVjF6dmp5YVQyR1hjK1ZLN2prTWtTN0oz?=
 =?utf-8?B?K2RzSjBoSXpVWFVYS2IrZm9vcENUQzRuN3U3VkZOdkIyN2dBRS9RRlpFTWpB?=
 =?utf-8?B?V2VHWUMvMlYrL2hZbzBlY1ZLSndPWlVzaUtjVDU1UXI4SHlmekZTTjdMdTYz?=
 =?utf-8?B?c3BpcVloUDFKazR2K3h5MW9JWHVmTUhQaktvMElQME5SRW1Nc2tiZTNJOG9L?=
 =?utf-8?B?VHZZbFYwNzlGZGEyYzFMMTZCSUMxL1V5NE1TbWFXZWt2V21kQW5xSlRWcERL?=
 =?utf-8?B?ZWFHZ1dUajhxVFpZTXBqZkRQcVVFQTJCcGQ1YS9qTUdGeXg3dzZmcS9pY2k5?=
 =?utf-8?B?dndEVkZaMUxYQ3g1aGNCRTBIVWZUcFQzUXFSMzNXU0F3eGw3WTMrOE9pUm1h?=
 =?utf-8?B?c1d2eEZQZ2g5R3ZCY0NDZk90K2NwTHhmUml4dUpzVTk2R2Izd2Y4ZTFBUHp1?=
 =?utf-8?B?QktuelA3TURDZEdCaTR6bjF6Ym9FQzFYbDhyNmxEdVpZUy8yTkhDUGo4b1BT?=
 =?utf-8?B?SFpqYWpNSEJkdHFQK1ZxWGl5bFUxOU91WkZmd2p4S1ZiVkxSYjVlRGxFbmcz?=
 =?utf-8?B?YU54NUU3d2k2SnltUk1qWmNFRU5ySkdBQnM5KytTQyttSGhiS2p3UVBpblNF?=
 =?utf-8?B?OXFaYThjTTR5Qkx6ZnJvU1pGcUdvOFdKcFlmbDVQU3BTM1BXYTRmMzJ6Q05B?=
 =?utf-8?B?R3V3UGNoTmJ5Vk9sb2tzVjJFWHlRRnB6Um0waGZ1b0dIcFQ2dmtmMHlrVTBM?=
 =?utf-8?B?aUpScndILytOZmZsVmEwVkVaemd6ZkpvY0NyWkJ5NUhPZUlCUllBM2Voam1a?=
 =?utf-8?B?V0FubFY0bUlCcEtyNmo0YTRERFZzckY4dGlPRnVLL2MvQy9zSlo0NlZkNWNF?=
 =?utf-8?B?QkVCYUsyQUFtUGx1NElKdkd4Q0R2RGZvZngzR2hCVEZmV3dYNHptZzZjN2FM?=
 =?utf-8?B?aXcrR2JIZVg0cjVibDkvWTZFN0RKTDlWVC8zdW5XTHZJSWxrVktuVXQ2QTN0?=
 =?utf-8?B?MXROMUEwSkNpUXU4RlIvSUVsdUFLTVpZSTdwQ2ZFbWZhNVpNTlZRckNPL1hK?=
 =?utf-8?B?U0VlQkNQN29uRCs3U2V5VE1OZFNtNElmbW1SL2NOanhqdnlqU2dZcWpKeG0z?=
 =?utf-8?B?YlVOSmpoV3gwVDF5TVg0REZMMjRTeWRvMnJQL3F1ZjRQQnZpVi8rVHVSMFZm?=
 =?utf-8?B?Q1NaaHRnQzRYdG91LzNoWXdSeGpsQ2RvOUlkaFRXcjNZTnFVT0lOWUE4SXEz?=
 =?utf-8?B?ckduWnp5WDVIVXpNRU43YUJaQXZzanlkeVhnei9uR1VmNERHUWNpVnJvclJ3?=
 =?utf-8?B?QldDTHF5bU1HeDloRGZ2VW4zamRiMzNiRWJMYXVKcWJHdVFWZGhBQWptalJl?=
 =?utf-8?B?U2JtbEFhZU5uUmhIUFdhclNFQjlWUThZWEx5OEhBRnQ2SXArbVJkWGhZZ1JU?=
 =?utf-8?B?TWZGZFZFa09MejFCYWtuUUxDbXVoOGpmRWV2S1VES0ZKcDU2S2JUOGQ4enFm?=
 =?utf-8?B?VG5BR1JybFZlbWN4YUJCQ0tiZGJwSVk3dHlqRGswVURUWFphUnAwUzdlM0dB?=
 =?utf-8?B?bEhNM2owYVUzMUEzT3RTTmN4MHpxd2JKV0UwQ2FRSklnRTZEVWhyWnJDdjhB?=
 =?utf-8?B?alE1YkJncWZZTERzakJsU0NvTkd5bGJhT1J4QW54OUswYVlVMjhXS0syRytv?=
 =?utf-8?B?Vk5IZm8vSk9WWFJmOTI2TEFLMyt2eFVydXN1YW9leVBLY3hLbXROWDZ3UkFo?=
 =?utf-8?Q?Vqy9yH9ZUV4cMwUcRtZO4byI8/o0WZyU5/x+Rtj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a7dc25-4360-4c30-8cb6-08d94313a679
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 19:56:32.7114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RYYO9DXtejTgrjByhnMsS5yxRt9szBQUHlE/PWEWiCEoof1ptzro17ywX+KfAi9fZ60tVAQY1yNAbin9K4wrKKvRQur1PXi6z8qHM9Qu+qU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4210
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10040 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107090098
X-Proofpoint-GUID: HRSCHRoGCwd8tC4uafIjWLftZo52b-YS
X-Proofpoint-ORIG-GUID: HRSCHRoGCwd8tC4uafIjWLftZo52b-YS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/8/21 9:14 PM, Darrick J. Wong wrote:
> On Wed, Jul 07, 2021 at 03:21:09PM -0700, Allison Henderson wrote:
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
>> index 859dbef..5141958 100644
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
>> index 66a47f5..2945868 100644
>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -257,6 +257,7 @@ typedef struct xfs_mount {
>>   #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
>>   #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
>>   #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
>> +#define XFS_MOUNT_DELATTR	(1ULL << 28)	/* enable delayed attributes */
>>   
>>   /*
>>    * Max and min values for mount-option defined I/O
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index c30b077..1a7edae 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -94,7 +94,7 @@ enum {
>>   	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
>>   	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
>>   	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
>> -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
>> +	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_delattr
>>   };
>>   
>>   static const struct fs_parameter_spec xfs_fs_parameters[] = {
>> @@ -139,6 +139,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
>>   	fsparam_flag("nodiscard",	Opt_nodiscard),
>>   	fsparam_flag("dax",		Opt_dax),
>>   	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
>> +	fsparam_flag("delattr",		Opt_delattr),
>>   	{}
>>   };
>>   
>> @@ -1277,6 +1278,9 @@ xfs_fs_parse_param(
>>   		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
>>   		return 0;
>>   #endif
>> +	case Opt_delattr:
>> +		parsing_mp->m_flags |= XFS_MOUNT_DELATTR;
>> +		return 0;
> 
> Can we restrict this to CONFIG_XFS_DEBUG=y or at least log the usual
> 
> "EXPERIMENTAL logged xattrs feature in use, use at your orkgs!"
> 
> message at mount?
Sure, will add that in.  Thx!
Allison

> 
> --D
> 
>>   	/* Following mount options will be removed in September 2025 */
>>   	case Opt_ikeep:
>>   		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>> index 66b334f..7335423 100644
>> --- a/fs/xfs/xfs_xattr.c
>> +++ b/fs/xfs/xfs_xattr.c
>> @@ -8,6 +8,8 @@
>>   #include "xfs_shared.h"
>>   #include "xfs_format.h"
>>   #include "xfs_log_format.h"
>> +#include "xfs_trans_resv.h"
>> +#include "xfs_mount.h"
>>   #include "xfs_da_format.h"
>>   #include "xfs_trans_resv.h"
>>   #include "xfs_mount.h"
>> -- 
>> 2.7.4
>>
